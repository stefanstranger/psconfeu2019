#region Get Azure Function URLs
$ResourceGroupName = 'psconfeu2019-rg'
Invoke-AzResourceAction -ResourceGroupName $ResourceGroupName -ResourceType 'Microsoft.Web/sites/functions' -ResourceName 'psconfeu2019/GetGroup' -Action listsecrets -ApiVersion '2018-02-01' -Force -OutVariable GetGroup
Invoke-AzResourceAction -ResourceGroupName $ResourceGroupName -ResourceType 'Microsoft.Web/sites/functions' -ResourceName 'psconfeu2019/NewGroup' -Action listsecrets -ApiVersion '2018-02-01' -Force -OutVariable NewGroup
Invoke-AzResourceAction -ResourceGroupName $ResourceGroupName -ResourceType 'Microsoft.Web/sites/functions' -ResourceName 'psconfeu2019/RemoveGroup' -Action listsecrets -ApiVersion '2018-02-01' -Force -OutVariable RemoveGroup
#endregion

#region Variables
$DisplayName = 'PSConfEu-Demo-Group'
$Description = 'PSConfEu Demo Group'
$MailNickName = 'psconfeudemogroup'
$UserPrincipalName = 'johndoe@sstranger.onmicrosoft.com'
$Members = 'janedoe@sstranger.onmicrosoft.com'
#endregion

#region Retrieve AAD Group via Azure Function
Invoke-RestMethod -Method Get -Uri ('{0}&Displayname={1}' -f $GetGroup.trigger_url, $DisplayName)
#endregion

#region Create AAD Group local development
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