<#
.Synopsis
    Build script (https://github.com/nightroman/Invoke-Build) for creating an Azure DevOps Extension for the CCoE Storage Account Product

.Description

    The initial configuration of this build script need the following to be configured:
    - Variables section. Update the variables in accordance to the CCoE Product Extension you want to create and publish.
    - For local build tasks, you need to create a environment variable npm_config_vsts_pat that contains the PAT for managing the extension.
    - For Azure DevOps Pipeline usage, create a Build Pipeline variable called PAT (Personal Access Token).

    This build script uses the InvokeBuild PowerShell Module to execute the following Build Task:
    1. ps_modules. This tasks copies all needed PowerShell Modules to the CCoE Product Extension.
    2. InstallNodeModules. This task installs all needed node modules configured in the package.json file.
    3. CreateExtension. This task creates an Azure DevOps Extension in the \dist folder. Extension version is not updated!
    4. UpdateExtensionVersion. This task retrieves the latest version of the Extension and updates the version.
    5. BuildCreateExtension. This tasks creates a new version of the Extension and saves the Extension in the dist folder.
    6. PublishExtension. This task publishes the Extension created by build task BuildCreateExtension to the Azure DevOps MarketPlace.
    7. Clean. This task cleans the product folder. Removes the ps_modules and dist folders.

    Local Development machine usage (make sure you have initially run the bootstrap.ps1 script for the pre-requisites):
    invoke-build -Task [enter task name]. Example: Invoke-Build -Task BuildCreateExtension.

    To use build script in Azure DevOps Pipelines, use Invoke-SABuild.ps1 script and add argument for PAT (build variable)

#>

param ($PAT)

#region variables
$script:ProductName = 'StorageAccount'
$script:Publisher = 'CCoEBootcamp'
$script:ExtensionId = 'CCoE-Bootcamp-Demo-Sample-StorageAccount'
$script:ProductVersion = '1.0'
$script:ProductPath = ( '{0}\{1}-v{2}' -f $PSScriptRoot, $ProductName, $ProductVersion)
#endregion

#region use the most strict mode
Set-StrictMode -Version Latest
#endregion

#region Build Task variables
task Version {

    assert $script:ProductName
    assert $script:ProductVersion
    assert $script:ProductPath
}
#endregion

#region Task copy ps_modules to Extension
task ps_modules {
    if (-not (Test-Path ("$script:ProductPath\ps_modules"))) {

        $null = New-Item -Path ("$script:ProductPath\ps_modules") -ItemType Directory

    }

    # Excluded file 'OpenSSL License.txt' because tfx cannot handle files with space in their name
    Copy-Item -Path '..\..\ps_modules\' -Filter *.* -Recurse -Destination ("$script:ProductPath") -Exclude 'OpenSSL License.txt' -Force
}
#endregion

#region Install Node Modules
task InstallNodeModules {
    exec {npm install "$PSScriptRoot" }
}
#endregion

#region Task Create Extension. Don't update Extension version.
task CreateExtension {
    exec {tfx extension create --root ("$PSScriptRoot") --output-path ("$PSScriptRoot\dist") --manifest-globs vss-extension.json --override ('{{\"version\": \"{0}\"}}' -f $script:newVersion) --trace-level debug} 
}
#endregion

#region Update to latest Extension version
task UpdateExtensionVersion {
    #If PAT parameter is not being used, use local npm_config_vsts_pat environment variable
    if (!($PAT)) {
        $PAT = $env:npm_config_vsts_pat
    }
    #region get version from vss-extension.json
    $ExtensionVersion = [Version](Get-Content -path ("$PSScriptRoot\vss-extension.json") | ConvertFrom-Json).Version
    #endregion

    try {
        #region retrieve latest extension version from MarketPlace
        $Version = exec {tfx extension show --publisher ($script:Publisher) --extension-id ($script:ExtensionId) --token ($PAT) --output json | 
                convertfrom-json | 
                select-Object -ExpandProperty Versions | Select-Object -First 1 | select-object -Property version 
        }
        [Version]$Latest = $Version.version
        #endregion

        #region update version
        if ($Latest) {        
            [String]$script:NewVersion = New-Object -TypeName System.Version -ArgumentList ($Latest.Major, $Latest.Minor, ($Latest.Build + 1))
        }
        else {
            [String]$script:NewVersion = New-Object -TypeName System.Version -ArgumentList ($ExtensionVersion.Major, $ExtensionVersion.Minor, ($ExtensionVersion.Build + 1))
        }
        #endregion
        Write-Output -InputObject ('New Extension version: {0}' -f $script:NewVersion)
    }
    catch {   
        [String]$script:NewVersion = New-Object -TypeName System.Version -ArgumentList ($ExtensionVersion.Major, $ExtensionVersion.Minor, ($ExtensionVersion.Build + 1))
        Write-Output -InputObject ('New Extension version: {0}' -f $script:NewVersion)
    }
}
#endregion

#region Task Create Extension. First Task ps_modules is run, secondly the CreateExtensionTask is run.
task BuildCreateExtension ps_modules, InstallNodeModules, UpdateExtensionVersion, CreateExtension
#endregion

#region Task Publish Extension
task PublishExtension {
    #If PAT parameter is not being used, use local npm_config_vsts_pat environment variable
    if (!($PAT)) {
        $PAT = $env:npm_config_vsts_pat
    }
    try {
        #retrieve file name vsix file
        $vsixfile = (Get-ChildItem -Path ("$PSScriptRoot\dist") -Filter "*.vsix").Fullname | Split-Path -Leaf -ErrorAction Stop
        exec {tfx extension publish --vsix ("$PSScriptRoot\dist\$vsixfile") --token ($PAT)}
    }
    catch {
        throw $_
    }    
}
#endregion

#region Task clean up ps_modules folder and dist folder and content
task Clean {
    # Clean ps_modules folder
    if ((Test-Path ("$ProductPath\ps_modules"))) {

        Remove-Item -Path ("$ProductPath\ps_modules") -Recurse -Force

    }

    #Clean dist folder and contents
    if ((Test-Path ("$PSScriptRoot\dist"))) {

        Remove-Item -Path ("$PSScriptRoot\dist") -Recurse -Force

    }

}
#endregion

#region Default task
task . Clean, ps_modules, CreateExtension
#endregion