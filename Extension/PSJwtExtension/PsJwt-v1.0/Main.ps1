Trace-VstsEnteringInvocation $MyInvocation
Import-VstsLocStrings "$PSScriptRoot\Task.json"

Write-Verbose -Message ('Start JWT Demo Extension')

#region Get inputs.
$Action = Get-VstsInput -Name Action -Require
#endregion

#region Import PSJwt PowerShell Module
Write-Verbose -Message ('Importing PSJwt PowerShell Module')
Import-Module $PSScriptRoot\ps_modules\PSJwt\1.0.0\\PSJwt.psd1
#endregion

#region Execute selected Action
switch ($action) {
    "convertfrom" {
        Write-Verbose "Get JSON Web Token"
        $Token = Get-VstsInput -Name Token -Require

        #region Verbose Output for input fields
        Write-Verbose -Message ('Input fields are:')
        Write-Verbose -Message ('Action: {0}' -f $Action)
        Write-Verbose -Message ('Token:  {0}' -f $Token)
        #endregion

        Write-Host "Decode JSON Web Token"
        ConvertFrom-JWT -Token $Token       
    }
    "convertto" {
        Write-Verbose "Get PayLoad and Secret"
        $PayLoad = Get-VstsInput -Name PayLoad -Require
        $Secret = Get-VstsInput -Name Secret -Require

        #region Verbose Output for input fields
        Write-Verbose -Message ('Input fields are:')
        Write-Verbose -Message ('Action: {0}' -f $Action)
        Write-Verbose -Message ('PayLoad: {0}' -f $PayLoad)
        Write-Verbose -Message ('Secret: {0}' -f $Secret)
        #endregion

        Write-Host "Encode JSON Web Token"
        ConvertTo-JWT -PayLoad $Payload -Secret $Secret  
       
    }
    default {
        throw 'Unknow action'
    }
}