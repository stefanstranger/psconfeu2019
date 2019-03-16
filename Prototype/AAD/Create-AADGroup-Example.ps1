<#
    Create an Azure Active Directory Group Example
#>


#region variables
$Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
$ClientID = 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' #ApplicationID
$ClientSecret = "$env:psconfeu"
#endregion

#region Authenticate
$TokenEndpoint = ('https://login.microsoftonline.com/{0}/oauth2/v2.0/token' -f $tenantid )

$Body = @{
    'client_id'     = $ClientID
    'grant_type'    = 'client_credentials'
    'client_secret' = $ClientSecret
    'scope'         = 'https://graph.microsoft.com/.default'
}

$params = @{
    ContentType = 'application/x-www-form-urlencoded'
    Headers     = @{'accept' = 'application/json'}
    Body        = $Body
    Method      = 'Post'
    URI         = $TokenEndpoint
}

$Token = Invoke-RestMethod @params
#endregion

#region Check Access Token
ConvertFrom-JWT -Token $Token.access_token -OutVariable jwttoken
$jwttoken.roles
#endregion

#region Get User info
$Uri = ('https://graph.microsoft.com/v1.0/users/{0}' -f '74f060dc-fe58-4b72-a888-ae363052cb27')

$params = @{
    ContentType = 'application/json'
    Headers     = @{
        'authorization' = "Bearer $($Token.Access_Token)"
    }
    Method      = 'Get'
    URI         = $Uri 
}

$Result = Invoke-RestMethod @params
$Result
#endregion

#region Create AAD Group
# https://docs.microsoft.com/en-us/graph/api/group-post-groups?view=graph-rest-1.0

$Uri = ('https://graph.microsoft.com/v1.0/groups')

$Body = @{
    'Description'        = 'PSConfEu Demo Group'
    "displayName"        = "PSConfEu-Demo-Group"
    "groupTypes"         = @(
        "Unified"
    )
    "mailEnabled"        = $true
    "mailNickname"       = "psconfeudemogroup"
    "securityEnabled"    = $false
    "owners@odata.bind"  = @(
        "https://graph.microsoft.com/v1.0/users/74f060dc-fe58-4b72-a888-ae363052cb27")
    "members@odata.bind" = @(
        "https://graph.microsoft.com/v1.0/users/ab8438ca-22fe-4eb9-a1bf-045859a84207")
}

$params = @{
    ContentType = 'application/json'
    Headers     = @{
        'authorization' = "Bearer $($Token.Access_Token)"
    }
    Body        = ($Body | ConvertTo-Json)
    Method      = 'Post'
    URI         = $Uri 
}

$Result = Invoke-RestMethod @params
#endregion