<#
    Demo how to use the earlier deployed PowerShell for Azure Functions.

    Note:
    - First deploy the Azure Function with script Deploy-AzureFunction.ps1
#>

#region Deploy Azure Function with ARM Template
. code C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Templates\Deploy-AzureFunction.ps1
#endregion

<#
    Walkthrough code for PowerShell Azure Function
#>

#region Variables
$DisplayName = 'PSConfEu-Demo-Group'
$Description = 'PSConfEu Demo Group'
$MailNickName = 'psconfeudemogroup'
$UserPrincipalName = 'johndoe@sstranger.onmicrosoft.com'
$Members = 'janedoe@sstranger.onmicrosoft.com'
$ResourceGroupName = 'psconfeu2019-rg'
#endregion

#region start Function locally
invoke-build C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\AzureFunction.build.ps1 -Task Modules
invoke-build C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\AzureFunction.build.ps1 -Task Start
#endregion

#region Create AAD Group local development
# Run from another host
$Body = @{
    'DisplayName'       = $DisplayName
    'Description'       = $Description
    'MailNickName'      = $MailNickName
    'UserPrincipalName' = $UserPrincipalName
    'Members'           = $Members
}

$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json' }
    Body        = $Body
    Method      = 'Post'
    URI         = ('http://localhost:7071/api/NewGroup?DisplayName={0}&Description={1}&MailNickName={2}&UserPrincipalName={3}&Members={4}' -f $DisplayName, $Description, $MailNickName, $UserPrincipalName, $Members)
}
Invoke-RestMethod @params
#endregion

#region Get Azure Function URLs
Invoke-AzResourceAction -ResourceGroupName $ResourceGroupName -ResourceType 'Microsoft.Web/sites/functions' -ResourceName 'psconfeu2019/GetGroup' -Action listsecrets -ApiVersion '2018-02-01' -Force -OutVariable GetGroup
Invoke-AzResourceAction -ResourceGroupName $ResourceGroupName -ResourceType 'Microsoft.Web/sites/functions' -ResourceName 'psconfeu2019/NewGroup' -Action listsecrets -ApiVersion '2018-02-01' -Force -OutVariable NewGroup
Invoke-AzResourceAction -ResourceGroupName $ResourceGroupName -ResourceType 'Microsoft.Web/sites/functions' -ResourceName 'psconfeu2019/RemoveGroup' -Action listsecrets -ApiVersion '2018-02-01' -Force -OutVariable RemoveGroup
#endregion

#region Retrieve AAD Group via Azure Function
Invoke-RestMethod -Method Get -Uri ('{0}&Displayname={1}' -f $GetGroup.trigger_url, $DisplayName)
#endregion

#region Create new AAD Group with Azure Function
$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json' }
    Body        = $Body
    Method      = 'Post'
    URI         = ('{0}&DisplayName={1}&Description={2}&MailNickName={3}&UserPrincipalName={4}&Members={5}' -f $NewGroup.trigger_url, $DisplayName, $Description, $MailNickName, $UserPrincipalName, $Members)
}

Invoke-RestMethod @params
#endregion

#region Remove AAD Group with Azure Function
$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json' }
    Method      = 'Post'
    URI         = ('{0}&DisplayName={1}' -f $RemoveGroup.trigger_url, $DisplayName)
}

Invoke-RestMethod @params
#endregion

#region Remove Resource Group
if (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue) {
    Remove-AzResourceGroup -Name $ResourceGroupName
}
#endregion