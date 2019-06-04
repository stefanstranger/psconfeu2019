Trace-VstsEnteringInvocation $MyInvocation
Import-VstsLocStrings "$PSScriptRoot\Task.json"

Write-Verbose -Message ('Start HW Demo Extension')

#region Get inputs.
$Action = Get-VstsInput -Name Action -Require
#endregion

#region Import PSJwt PowerShell Module
Write-Verbose -Message ('Importing PSHelloWorld PowerShell Module')
Import-Module $PSScriptRoot\ps_modules\PSHelloWorld\0.1.0\PSHelloWorld.psd1
#endregion

#region Execute selected Action
switch ($action) {
    "NewHelloWorld" {
        Write-Verbose "Get Hello World"
        $FirstName = Get-VstsInput -Name FirstName -Require
        $LastName = Get-VstsInput -Name LastName -Require

        #region Verbose Output for input fields
        Write-Verbose -Message ('Input fields are:')
        Write-Verbose -Message ('Action: {0}' -f $Action)
        Write-Verbose -Message ('FirstName:  {0}' -f $FirstName)
        Write-Verbose -Message ('LastName:  {0}' -f $LastName)
        #endregion

        Write-Host "New Hello World"
        ConvertFrom-JWT -Token $Token       
    }
    default {
        throw 'Unknow action'
    }
}