using namespace System.Net

# Input bindings are passed in via param block. 
# The TriggerMetadata parameter is used to supply additional information about the trigger
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger GetGroup function processed a request."

# Get TriggerMetadata
Write-Verbose ($TriggerMetadata | Convertto-Json) -Verbose

# Interact with query parameters or the body of the request.
$DisplayName = $Request.Query.DisplayName
if (-not $DisplayName) {
    $DisplayName = $Request.Body.DisplayName
}

if ($DisplayName) {
    $status = [HttpStatusCode]::OK
     
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
