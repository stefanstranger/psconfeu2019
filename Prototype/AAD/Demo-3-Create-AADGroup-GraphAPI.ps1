<#
    Create an Azure Active Directory Security Group with the Graph API Example 
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

#region Create AAD Security Group with John Doe as Owner
# https://docs.microsoft.com/en-us/graph/api/group-post-groups?view=graph-rest-1.0

$Uri = ('https://graph.microsoft.com/v1.0/groups')

$Body = [ordered]@{
    'displayName'       = 'PSConfEu Demo Group'
    'description'       = "PSConfEu-Demo-Group"
    "mailEnabled"       = $false
    "mailNickname"      = "psconfeudemogroup"
    "securityEnabled"   = $true
    "owners@odata.bind" = @(
        ('https://graph.microsoft.com/v1.0/users/{0}' -f '74f060dc-fe58-4b72-a888-ae363052cb27')
    )
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

Invoke-RestMethod @params -OutVariable Result
#endregion

#region Remove AAD Group
$Uri = ('https://graph.microsoft.com/v1.0/groups/{0}' -f $($Result.id))
$params = @{
    ContentType = 'application/json'
    Headers     = @{
        'authorization' = "Bearer $($Token.access_token)"
    }
    Method      = 'Delete'
    URI         = $Uri 
}

Invoke-RestMethod @params
#endregion