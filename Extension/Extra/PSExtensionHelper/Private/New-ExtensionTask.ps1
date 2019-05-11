Function New-ExtensionTask {
    #region Create Task Object
    return [PSCustomObject]@{
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
}