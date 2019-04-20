#region variables
$Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
$apiversion = '1.6'
$RoleAssignmentID = '5b567255-7703-4780-807c-7be8301ae99b' #Group.Read.All
$ManagedIdenityObjectId = '5b4dbf1a-6503-40e1-b70b-68ba9f7d3905'
$ResourceID = '00000003-0000-0000-c000-000000000000' # AppId for Graph API
$Token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkhCeGw5bUFlNmd4YXZDa2NvT1UyVEhzRE5hMCIsImtpZCI6IkhCeGw5bUFlNmd4YXZDa2NvT1UyVEhzRE5hMCJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLndpbmRvd3MubmV0LyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQ5NmYwYjI3LTRmYTQtNGMzZC04YmJlLTE5YzRiNjg3NWM4MS8iLCJpYXQiOjE1NTU2NjIyMzksIm5iZiI6MTU1NTY2MjIzOSwiZXhwIjoxNTU1NjY2MTM5LCJhY3IiOiIxIiwiYWlvIjoiQVdRQW0vOExBQUFBc0dpekVZUVZlS3FoYjJGcHJOVHQ1Mm5mTWZOeDNRZHcrei9tL1dSQ094MjJGVHlsVnFGRTZob1U0T1ZkYnZYTldJZDRNNEpZNlNqZU0xcnRWWjFSci9nTURlTE4vSUtEQTNjdjdkLzF3VWRBSXJaUjdlSUpLTTJyR3R5MDJMVFIiLCJhbHRzZWNpZCI6IjU6OjEwMDMwMDAwODAxQzFENzEiLCJhbXIiOlsicnNhIl0sImFwcGlkIjoiMTk1MGEyNTgtMjI3Yi00ZTMxLWE5Y2YtNzE3NDk1OTQ1ZmMyIiwiYXBwaWRhY3IiOiIwIiwiZW1haWwiOiJzdGVmc3RyQG1pY3Jvc29mdC5jb20iLCJmYW1pbHlfbmFtZSI6IlN0cmFuZ2VyIiwiZ2l2ZW5fbmFtZSI6IlN0ZWZhbiIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0Ny8iLCJpbl9jb3JwIjoidHJ1ZSIsImlwYWRkciI6IjgyLjc1LjUxLjEyOSIsIm5hbWUiOiJTdGVmYW4gU3RyYW5nZXIiLCJvaWQiOiJjZjdlMGZlMi1mYjg3LTQxMjctYjcyYi03Y2ZkOTc2ZjY3Y2MiLCJwdWlkIjoiMTAwM0JGRkQ4RURCRTJDNiIsInNjcCI6IjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsInN1YiI6ImE4dU5XbmpsZXllY0pmdEFYNVhMYXJ4eFNhUEFUci1PQ3Y5cHJLTVpSbXMiLCJ0ZW5hbnRfcmVnaW9uX3Njb3BlIjoiRVUiLCJ0aWQiOiI0OTZmMGIyNy00ZmE0LTRjM2QtOGJiZS0xOWM0YjY4NzVjODEiLCJ1bmlxdWVfbmFtZSI6InN0ZWZzdHJAbWljcm9zb2Z0LmNvbSIsInV0aSI6InZ4WmcwNzJ0ckVPV3NKblJBQVNqQUEiLCJ2ZXIiOiIxLjAifQ.IpiwYf3L3dIaGaxL0vDZEZ7_nKq-jHi7DfazLNjNYoKkiymavnREdyMiF2qNPrGdyXtwdbHKpkArQxXY6ypcOZkBDAszIjnb6U8ejlfZbZVJYwY8E_v9klCcBQSHcSYNC8Zq6c9hXu4x1jmoqLF8wq5H4Cx5llCEZFa0niBmgylD0TO5iBew_ltT0Nl8U0QwjBvXcqoXChG9OZTiF0fXMXgHGnu7Xs1StjV13QcfvPjIQVstEPQ8IgRI-WZtlgUtlWr_g_uV9cKZFuYQVyKlCpoaPO5vBtOT1xM8zUjG6pF8YwPsA_vD1kZUvc9CZwD_fWnJTbr5JeljOIUJxSDLjA'
#endregion

#region Get Managed Idenity information
$Uri = ('https://graph.windows.net/{0}/{1}/{2}?api-version={3}' -f $tenantId, 'servicePrincipals', $ManagedIdenityObjectId, $apiversion)

$params = @{
    ContentType = 'application/json'
    Headers     = @{'accept' = 'application/json';
        'authorization'  = "Bearer $($Token)" 
    }
    Method      = 'Get'
    URI         = $Uri
    Verbose     = $true
}

Invoke-RestMethod @params
#endregion

#region Get App Role Assignment Managed Identity
$Uri = ('https://graph.windows.net/{0}/{1}/{2}/appRoleAssignments?api-version={3}' -f $tenantId, 'servicePrincipals', $ManagedIdenityObjectId, $apiversion)

$params = @{
    ContentType = 'application/json'
    Headers     = @{'accept' = 'application/json';
        'authorization'  = "Bearer $($Token)" 
    }
    Method      = 'Get'
    URI         = $Uri
    Verbose     = $true
}

Invoke-RestMethod @params
#endregion

#region Assing App Role to MS
$Uri = ('https://graph.windows.net/{0}/{1}/{2}/appRoleAssignments?api-version={3}' -f $tenantId, 'servicePrincipals', $ManagedIdenityObjectId, $apiversion)
$Body = @{
    'id'          = $RoleAssignmentID # Role Assignment ID in Graph API. Example: Group.Read.All 5b567255-7703-4780-807c-7be8301ae99b
    'resourceid'  = $ResourceID # AppId of the Graph Service Principal
    'principalid' = $ManagedIdenityObjectId # The unique identifier (id) for the principal being granted the access (Managed Identity id)
} | convertto-json


$params = @{
    ContentType = 'application/json'
    Headers     = @{'accept' = 'application/json';
        'authorization'  = "Bearer $($Token)" 
    }
    Body        = $Body
    Method      = 'Post'
    URI         = $Uri
    Verbose     = $true
}

Invoke-RestMethod @params 
#endregion