<#
.Synopsis
    Build script (https://github.com/nightroman/Invoke-Build) for creating an Azure DevOps Extension for the CCoE Storage Account Product

.Description

    Build tasks for Azure Function

#>
#region variables
$script:AzureFunctionPath = ( '{0}\{1}' -f $PSScriptRoot, 'AzureFunction')
#endregion

#region use the most strict mode
Set-StrictMode -Version Latest
#endregion

#region Task copy ManageAAD PowerShell Module to Azure Function
task modules {
    if (-not (Test-Path ("$script:AzureFunctionPath\Modules\ManageAADGroup"))) {
        $null = New-Item -Path ("$script:AzureFunctionPath\Modules\ManageAADGroup") -ItemType Directory
    }

    Copy-Item -Path '.\Module\ManageAADGroup' -Filter *.* -Recurse -Destination ("$script:AzureFunctionPath\Modules") -Force
}
#endregion

#region start azure function
task start {
    exec { Set-Location .\AzureFunction; func start }
}
#endregion

#region Task clean up ps_modules folder and dist folder and content
task Clean {
    # Clean ps_modules folder
    if ((Test-Path ("$AzureFunctionPath\Modules"))) {

        Remove-Item -Path ("$AzureFunctionPath\Modules") -Recurse -Force

    }
}
#endregion

#region Default task
task . Clean, Modules
#endregion