Function New-TaskInput {
    [CmdletBinding()]
    Param
    (
        # Name of PowerShell Module
        [Parameter(Mandatory = $true,
            Position = 0)]
        $Name,
        # PowerShell Module
        [Parameter(Mandatory = $true,
            Position = 0)]
        [PSCustomObject]$Module)

    #region create input objects
    $options = $null
    1..($groups.length - 1) | ForEach-Object {
        $options += @{
            $($Groups[$_].Name) = $($Groups[$_].displayName)
        }
    }

    $Inputs = @()
    $DefaultInput = [PSCustomObject]@{
        name         = 'action'
        type         = 'pickList'
        label        = 'Action'
        defaultValue = $($groups[1].name).replace('-','')
        required     = $true
        groupName    = $Module.Name
        helpMarkDown = ('Choose the action for {0} PowerShell Module' -f $Module.Name )
        properties   = @{
            EditableOptions = 'False'
        }
        options      = $options
    }
    $Inputs += $DefaultInput

    #Create for each parameter of a function a task input
    Function Get-Parameter {
        [CmdletBinding()]
        Param
        (
            # Name of Command
            [Parameter(Mandatory = $true,
                Position = 0)]
            $Name)

        $ParameterSets = (Get-Command $Name).ParameterSets 

        foreach ($ParameterSet in $ParameterSets) {
            #iterate all Parameters
            $MyParameterSet = @()
            foreach ($Parameter in $ParameterSet) {
                $MyParams = $Parameter.Parameters | Where-Object { $_.Position -ne '-2147483648' }
            }
            #Create new Object
            $MyParameterSet += [PSCustomObject]@{
                Name             = $MyParams.Name
                ParameterSetName = $ParameterSet.Name    
            }
            $MyParameterSet
        }   
    }

    #Get all commands from the PowerShell module
    $Commands = Get-Command -Module $Name
    $CommandInputs = @()

    Foreach ($Command in $Commands) {

        (Get-Parameter -Name $Command.Name).Name | ForEach-Object {
            $Commandinputs += [PSCustomObject]@{
                name         = $_
                type         = "string"
                label        = $_
                required     = $true
                groupName    = $Module.Name
                helpMarkDown = $(Get-Help -Name $($Command.Name) -Parameter $($_)).Description.text
                visibleRule  = ('action = {0}' -f $($Command.Name).replace('-', ''))
            }
        }
    }
    $Inputs += $Commandinputs
    Return $Inputs
    #endregion
}