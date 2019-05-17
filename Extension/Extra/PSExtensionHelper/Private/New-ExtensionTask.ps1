Function New-ExtensionTask {
    #region Create Task Object
    return [PSCustomObject]@{
        id                 = $(New-Guid).Guid 
        name               = [string] $name
        friendlyName       = [string] $friendlyname
        description        = [string] $description
        helpMarkDown       = [string] $helpMarkdown
        category           = [string] $category
        visibility         = [string[]] $visibility
        author             = [string] $author
        version            = [PSCustomObject]@{
            Major = [int]$Version.Split('.')[0]
            Minor = [int]$Version.Split('.')[1]
            Patch = [int]$Version.Split('.')[2]
        }
        preview            = [boolean] $preview
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