Function Get-CommandParameter {
    [CmdletBInding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Name)

    $Cmdlet = Get-Command -Name $Name
    $Parameters = $Cmdlet.ParameterSets.Parameters | Where-Object { $_.Position -ne '-2147483648' }
    $Help = Get-Help -Name $Name
    $Inputs = @()
    Foreach ($Parameter in $Parameters) {
        $Inputs += (
            [Input]@{
                Name         = $Parameter.Name
                label        = $Parameter.Name
                type         = $($Parameter.ParameterType).Name
                defaultvalue = $null
                required     = $true
                helpMarkDown = $Help.details.description.text
                groupName    = '__AllParameterSets'
                visibleRule  = $null
                properties   = [InputProperties]::new($false)
                option       = $null
            }
        )
    }
    return $Inputs
}