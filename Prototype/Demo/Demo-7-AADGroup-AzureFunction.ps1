#region Retrieve AAD Group via Azure Function
Invoke-RestMethod -Method Get -Uri 'https://psconfeu2019.azurewebsites.net/api/getgroup?code=6i4bwvTLa/xaak5QqeSQ3GoWAooMpbzX11/Weuy6GpXnbljCcTachA==&Displayname=PSConfEu-Demo-Group'
#endregion

#region Create AAD Group
$Body = @{
    'DisplayName'       = 'PSConfEu-Demo-Group'
    'Description'       = 'PSConfEu Demo Group'
    'MailNickName'      = 'psconfeudemogroup'
    'UserPrincipalName' = 'johndoe@sstranger.onmicrosoft.com'
    'Members'           = 'janedoe@sstranger.onmicrosoft.com'
}

$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json' }
    Body        = $Body
    Method      = 'Post'
    URI         = 'http://localhost:7071/api/NewGroup'
}


Invoke-RestMethod -Uri ('http://localhost:7071/api/NewGroup?DisplayName={0}&Description={1}&MailNickName={2}&UserPrincipalName={3}&Members={4}' -f $Body.DisplayName, $Body.Description, $Body.MailNickName, $body.UserPrincipalName, $Body.Members) -Method POST

Invoke-RestMethod @params

#region Create new AAD Group with Azure Function
$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json' }
    Body        = $Body
    Method      = 'Post'
    URI         = ('https://psconfeu2019.azurewebsites.net/api/newgroup?code=9qKwpNOHnto/5luzzeM6m1bfBcnAXoy4rh3sr5H0pCvfQ1xQhuBgbA==&DisplayName={0}&Description={1}&MailNickName={2}&UserPrincipalName={3}&Members={4}' -f 'PSConfEu-Demo-Group', 'PSConfEu-Demo-Group', 'psconfeudemogroup', 'johndoe@sstranger.onmicrosoft.com', 'janedoe@sstranger.onmicrosoft.com')
}

Invoke-RestMethod @params
#endregion