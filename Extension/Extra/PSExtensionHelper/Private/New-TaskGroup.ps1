Function New-TaskGroup {

    [CmdletBinding()]
    Param
    (
        # PowerShell Module
        [Parameter(Mandatory = $true,
            Position = 0)]
        [PSCustomObject]$Module)

    #region create Groups Objects
    $groups = @()
    $DefaultGroup = [PSCustomObject]@{
        name        = $Module.Name
        displayName = $Module.Description
        isExpanded  = $true
    }
    $groups += $DefaultGroup
    #create a group for each function in the module
    $Module.ExportedCommands.GetEnumerator() | foreach-object {
        #Implement error handling when no help is found
        $groups += [PSCustomObject]@{
            name        = $($_.Key).replace('-', '')
            displayName = $(Get-Help $_.Value).Synopsis
            isExpanded  = $true
        }
    }

    return $groups
    #endregion
}