<#
    Example script how to convert a PowerShell Function into an ADO Extension Task
#>

#region Import Task schema
$TaskSchema = Get-Content -Path 'C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\tasks.schema.json'
$TaskSchema | ConvertFrom-Json -OutVariable foo
#endregion

#region retrieve Module info
$ModuleName = 'PSJwt'
Import-Module -Name $ModuleName
Get-Module -Name $ModuleName -OutVariable ModuleInfo
#endregion

#region Variables
$name = 'JWT-Demo'
$friendlyname = $ModuleInfo.Description
$description = 'JSON Web Token Extension Demo for PowerShell Conference EU 2019'
$helpMarkdown = 'Use this task to decode or create a JSON Web Token'
$category = 'Deploy'
$visibility = 'Release'
$author = 'Stefan Stranger'
$version = '1.0.0'
$preview = 'true'
$instanceNameFormat = 'JSON Web Token Extension Demo'
#endregion

#region Create Task Object
$Task = $null
$Task = [PSCustomObject]@{
    id                 = $(New-Guid).Guid 
    name               = [string] $name
    friendlyname       = [string] $friendlyname
    description        = [string] $description
    helpMarkdown       = [string] $helpMarkdown
    category           = [string] $category
    visibility         = [string[]] $visibility
    author             = [string] $author
    version            = [version] $version
    preview            = [string] $preview
    demands            = [string] $demands
    instanceNameFormat = [string] $instanceNameFormat
    groups             = [string[]]$groups
    inputs             = [PSCustomObject[]]$inputs
    execution          = [PSCustomObject]@{
        PowerShell3 = @{
            target = 'Main.ps1'
        }
    }
}
#endregion

#region create Groups Objects
$groups = @()
$DefaultGroup = [PSCustomObject]@{
    name        = $ModuleInfo.Name
    displayname = $ModuleInfo.Description
    isExpanded  = $true
}
$groups += $DefaultGroup
#create a group for each function in the module
$ModuleInfo.ExportedCommands.GetEnumerator() | foreach-object {
    
    $groups += [PSCustomObject]@{
        name        = $($_.Key)
        displayname = $(get-help $_.Value).Synopsis
        isExpanded  = $true
    }
}
$task.groups = $groups
#endregion

#region create input objects
$options = $null
1..($groups.length - 1) | ForEach-Object {
    $options += @{
        $($Groups[$_].Name) = $($Groups[$_].displayName)
    }
}

$inputs = @()
$DefaultInput = [PSCustomObject]@{
    name         = 'action'
    type         = 'pickList'
    label        = 'Action'
    defaultValue = $groups[1].name
    required     = $true
    groupName    = $ModuleInfo.Name
    helpMarkDown = ('Choose the action for {0} PowerShell Module' -f $ModuleInfo.Name )
    properties   = @{
        EditableOptions = 'False'
    }
    option       = $options
}
$inputs += $DefaultInput

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
$Commands = Get-Command -Module $ModuleName
$CommandInputs = @()

Foreach ($Command in $Commands) {

    (Get-Parameter -Name $Command.Name).Name | ForEach-Object {
        $Commandinputs += [PSCustomObject]@{
            name         = $_
            type         = "string"
            label        = $_
            required     = $true
            groupName    = $ModuleInfo.Name
            helpMarkDown = $(Get-Help -Name $($Command.Name) -Parameter $($_)).Description.text
            visibleRule  = ('action = {0}' -f $Command.Name)
        }
    }
}
$inputs += $Commandinputs
$task.inputs = $inputs
#endregion

#region output Task.json
$task | ConvertTo-Json -Depth 10
#endregion