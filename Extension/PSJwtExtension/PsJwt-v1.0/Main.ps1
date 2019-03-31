Trace-VstsEnteringInvocation $MyInvocation
Import-VstsLocStrings "$PSScriptRoot\Task.json"

Write-Verbose -Message ('Start Storage Account Extension')

#region Get inputs.
$Action = Get-VstsInput -Name Action -Require
$StorageAccountName = Get-VstsInput -Name StorageAccountName -Require
$ResourceGroupName = Get-VstsInput -Name ResourceGroupName -Require
$DebugDeploymentDebugLevel = Get-VstsInput -Name DebugDeploymentDebugLevel
$__vsts_input_errorActionPreference = Get-VstsInput -Name errorActionPreference
$__vsts_input_failOnStandardError = Get-VstsInput -Name FailOnStandardError
$TargetAzurePs = Get-VstsInput -Name TargetAzurePs
$CustomTargetAzurePs = Get-VstsInput -Name CustomTargetAzurePs
#endregion

#region variables for Azure PowerShell Module Version
$otherVersion = "OtherVersion"
$latestVersion = "LatestVersion"
#endregion

#region configure Azure RM PowerShell Module version 
if ($targetAzurePs -eq $otherVersion) {
    if ($customTargetAzurePs -eq $null) {
        throw (Get-VstsLocString -Key InvalidAzurePsVersion $customTargetAzurePs)
    }
    else {
        $targetAzurePs = $customTargetAzurePs.Trim()        
    }
}

$pattern = "^[0-9]+\.[0-9]+\.[0-9]+$"
$regex = New-Object -TypeName System.Text.RegularExpressions.Regex -ArgumentList $pattern

if ($targetAzurePs -eq $latestVersion) {
    $targetAzurePs = ""
}
elseif (-not($regex.IsMatch($targetAzurePs))) {
    throw (Get-VstsLocString -Key InvalidAzurePsVersion -ArgumentList $targetAzurePs)
}
#endregion

#region Verbose Output for input fields
Write-Verbose -Message ('Input fields are:')
Write-Verbose -Message ('Action: {0}' -f $Action)
Write-Verbose -Message ('StorageAccountName:  {0}' -f $StorageAccountName)
Write-Verbose -Message ('ResourceGroupName: {0}' -f $resourceGroupName)
Write-Verbose -Message ('DebugDeploymentDebugLevel: {0}' -f $debugDeploymentDebugLevel)

#endregion

# Dot source the private functions.
. "$PSScriptRoot\Utility.ps1"
$targetAzurePs = Get-RollForwardVersion -azurePowerShellVersion $targetAzurePs

$authScheme = 'ServicePrincipal'

Update-PSModulePathForHostedAgent -targetAzurePs $targetAzurePs -authScheme $authScheme

#region Execute selected Action
switch ($action) {
    "createStorageAccount" {
        Write-Verbose "Create a Storage Account Resource"
        $Location = Get-VstsInput -Name Location -Require
        $AccountType = Get-VstsInput -Name AccountType -Require
        $AccessTier = Get-VstsInput -Name AccessTier -Require

        Write-Host "Create a Storage Account"
        $scriptFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "Operations\Create-StorageAccount.ps1"))
        $scriptCommand = "& '$($scriptFile.Replace("'", "''"))' -resourceGroupName $resourceGroupName -StorageAccountName $StorageAccountName -Location $Location -AccountType $AccountType -AccessTier $AccessTier -debugDeploymentDebugLevel $debugDeploymentDebugLevel"
    }
    "removeStorageAccount" {
        Write-Verbose "Remove Storage Account from Resource Group"
        $scriptFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "Operations\Remove-StorageAccount.ps1"))
        $scriptCommand = "& '$($scriptFile.Replace("'", "''"))' -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName"
    }
    default {
        throw 'Unknow action'
    }
}

try {
    # Initialize Azure.
    Import-Module $PSScriptRoot\ps_modules\VstsAzureHelpers_
    Initialize-Azure -azurePsVersion $targetAzurePs -strict

    # Remove all commands imported from VstsTaskSdk, other than Out-Default.
    # Remove all commands imported from VstsAzureHelpers_.
    Get-ChildItem -LiteralPath function: |
        Where-Object {
        ($_.ModuleName -eq 'VstsTaskSdk' -and $_.Name -ne 'Out-Default') -or
        ($_.Name -eq 'Invoke-VstsTaskScript') -or
        ($_.ModuleName -eq 'VstsAzureHelpers_' )
    } |
        Remove-Item

    # For compatibility with the legacy handler implementation, set the error action
    # preference to continue. An implication of changing the preference to Continue,
    # is that Invoke-VstsTaskScript will no longer handle setting the result to failed.
    $global:ErrorActionPreference = 'Continue'

    # Undocumented VstsTaskSdk variable so Verbose/Debug isn't converted to ##vso[task.debug].
    # Otherwise any content the ad-hoc script writes to the verbose pipeline gets dropped by
    # the agent when System.Debug is not set.
    $global:__vstsNoOverrideVerbose = $true

    # Run the user's script. Redirect the error pipeline to the output pipeline to enable
    # a couple goals due to compatibility with the legacy handler implementation:
    # 1) STDERR from external commands needs to be converted into error records. Piping
    #    the redirected error output to an intermediate command before it is piped to
    #    Out-Default will implicitly perform the conversion.
    # 2) The task result needs to be set to failed if an error record is encountered.
    #    As mentioned above, the requirement to handle this is an implication of changing
    #    the error action preference.
    ([scriptblock]::Create($scriptCommand)) | 
        ForEach-Object {
        Remove-Variable -Name scriptCommand
        Write-Host "##[command]$_"
        . $_ 2>&1
    } | 
        ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            if ($_.FullyQualifiedErrorId -eq "NativeCommandError" -or $_.FullyQualifiedErrorId -eq "NativeCommandErrorMessage") {
                , $_
                if ($__vsts_input_failOnStandardError -eq $true) {
                    "##vso[task.complete result=Failed]"
                }
            }
            else {
                if ($__vsts_input_errorActionPreference -eq "continue") {
                    , $_
                    if ($__vsts_input_failOnStandardError -eq $true) {
                        "##vso[task.complete result=Failed]"
                    }
                }
                elseif ($__vsts_input_errorActionPreference -eq "stop") {
                    throw $_
                }
            }
        }
        else {
            , $_
        }
    }
}
finally {
    if ($__vstsAzPSInlineScriptPath -and (Test-Path -LiteralPath $__vstsAzPSInlineScriptPath) ) {
        Remove-Item -LiteralPath $__vstsAzPSInlineScriptPath -ErrorAction 'SilentlyContinue'
    }

    Import-Module $PSScriptRoot\ps_modules\VstsAzureHelpers_
    Remove-EndpointSecrets
    Disconnect-AzureAndClearContext -authScheme $authScheme -ErrorAction SilentlyContinue
}