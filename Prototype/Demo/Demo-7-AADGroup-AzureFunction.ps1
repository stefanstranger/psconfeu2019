#region Variables
$GetGroupCode = '6i4bwvTLa/xaak5QqeSQ3GoWAooMpbzX11/Weuy6GpXnbljCcTachA=='
$RemoveGroupCode = 'Fh9JI9cE4F5mI2NLXV46G3dbYtWUt9UI7elceQCAduFVQneNKnbNww=='
$NewGroupCode = '9qKwpNOHnto/5luzzeM6m1bfBcnAXoy4rh3sr5H0pCvfQ1xQhuBgbA=='
$DisplayName = 'PSConfEu-Demo-Group'
$Description = 'PSConfEu Demo Group'
$MailNickName = 'psconfeudemogroup'
$UserPrincipalName = 'johndoe@sstranger.onmicrosoft.com'
$Members = 'janedoe@sstranger.onmicrosoft.com'
#endregion

#region Retrieve AAD Group via Azure Function
Invoke-RestMethod -Method Get -Uri ('https://psconfeu2019.azurewebsites.net/api/getgroup?code={0}&Displayname={1}' -f $GetGroupCode, $DisplayName)
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
    URI         = ('https://psconfeu2019.azurewebsites.net/api/newgroup?code={0}&DisplayName={1}&Description={2}&MailNickName={3}&UserPrincipalName={4}&Members={5}' -f $NewGroupCode, $DisplayName, $Description, $MailNickName, $UserPrincipalName, $Members)
}

Invoke-RestMethod @params
#endregion

#region Remove AAD Group with Azure Function
$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json' }
    Method      = 'Post'
    URI         = ('https://psconfeu2019.azurewebsites.net/api/removegroup?code={0}&DisplayName={1}' -f $RemoveGroupCode, $DisplayName)
}

Invoke-RestMethod @params
#endregion