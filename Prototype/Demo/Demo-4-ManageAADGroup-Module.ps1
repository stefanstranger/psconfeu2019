<#
    ManageAAD Group PowerShell module is a wrapper module on the Graph API for managing Active Directory Groups.
#>

#region variables
$Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
$ClientID = 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' #ApplicationID
$ClientSecret = "$env:psconfeu"
$DisplayName = 'PSConfEu-Demo-Group'
#endregion

#region Import ManageAADGroup Module
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Module\ManageAADGroup -verbose
#endregion

#region Create AAD Security Group
$params = @{
    'DisplayName'       = $DisplayName
    'Description'       = 'PSConfEu Demo Group'
    'MailNickName'      = 'psconfeudemogroup'
    'UserPrincipalName' = 'johndoe@sstranger.onmicrosoft.com'
    'Members'           = 'janedoe@sstranger.onmicrosoft.com'
    'ClientID'          = $ClientID
    'ClientSecret'      = $ClientSecret
    'TenantID'          = $Tenantid
    'Verbose'           = $true
}
New-AADGroup @params
#endregion

#region Check if Group Exists
$params = @{
    'DisplayName'  = $DisplayName
    'ClientID'     = $ClientID
    'ClientSecret' = $ClientSecret
    'TenantID'     = $Tenantid
    'Verbose'      = $true
}
Get-AADGroup @params
#endregion

#region remove AAD Group
$params = @{
    'DisplayName'  = $DisplayName
    'ClientID'     = $ClientID
    'ClientSecret' = $ClientSecret
    'TenantID'     = $Tenantid
    'Verbose'      = $true
}
Remove-AADGroup @params
#endregion