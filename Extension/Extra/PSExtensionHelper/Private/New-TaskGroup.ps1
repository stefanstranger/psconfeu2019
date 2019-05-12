Function New-TaskGroup {

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
        #Implement error handling when no help is found
        $groups += [PSCustomObject]@{
            name        = $($_.Key)
            displayname = $(Get-Help $_.Value).Synopsis
            isExpanded  = $true
        }
    }

    return $groups
    #endregion
}