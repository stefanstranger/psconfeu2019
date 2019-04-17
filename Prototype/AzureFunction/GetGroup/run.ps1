using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger GetGroup function processed a request."

# Interact with query parameters or the body of the request.
$DisplayName = $Request.Query.DisplayName
if (-not $DisplayName) {
    $DisplayName = $Request.Body.DisplayName
}

if ($DisplayName) {
    $status = [HttpStatusCode]::OK
     
    <#
    #region Authenticate
    $TokenEndpoint = ('https://login.microsoftonline.com/{0}/oauth2/v2.0/token' -f $env:tenantid )

    $Body = @{
        'client_id'     = $env:ClientID
        'grant_type'    = 'client_credentials'
        'client_secret' = $env:ClientSecret
        'scope'         = 'https://graph.microsoft.com/.default'
    }

    $params = @{
        ContentType = 'application/x-www-form-urlencoded'
        Headers     = @{'accept' = 'application/json' }
        Body        = $Body
        Method      = 'Post'
        URI         = $TokenEndpoint
    }

    $Body = Invoke-RestMethod @params
    #endregion
    #>


    #region Check if Group Exists
    $params = @{
        'DisplayName'  = $DisplayName
        'ClientID'     = $env:ClientID
        'ClientSecret' = $env:ClientSecret
        'TenantID'     = $env:Tenantid
        'Verbose'      = $true
    }
    $Body = Get-AADGroup @params
    #endregion

}
else {
    $Status = [HttpStatusCode]::BadRequest
    $Body = "Please pass a DisplayName for Azure Active Directory Group on the query string or in the request body."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $Status
        Body       = $Body
    })
