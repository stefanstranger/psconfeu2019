using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger GetGroup function processed a request."

Write-Host ('Request Object: {0}' -f ($request | convertto-json))

# Interact with query parameters or the body of the request.
$DisplayName = $Request.Query.DisplayName
if (-not $DisplayName) {
    $DisplayName = $Request.Body.DisplayName
}

$Description = $Request.Query.Description
if (-not $Description) {
    $Description = $Request.Body.Description
}

$MailNickName = $Request.Query.MailNickName
if (-not $MailNickName) {
    $MailNickName = $Request.Body.MailNickName
}

$UserPrincipalName = $Request.Query.UserPrincipalName
if (-not $UserPrincipalName) {
    $UserPrincipalName = $Request.Body.UserPrincipalName
}

$Members = $Request.Query.Members
if (-not $Members) {
    $Members = $Request.Body.Members
}

Write-Host ('DisplayName: {0}' -f $DisplayName)

if ($DisplayName -and $Description -and $MailNickName -and $UserPrincipalName -and $Members) {
    $status = [HttpStatusCode]::OK
     
    #region Create AAD Security Group
    $params = @{
        'DisplayName'       = $DisplayName
        'Description'       = $Description
        'MailNickName'      = $MailNickName
        'UserPrincipalName' = $UserPrincipalName
        'Members'           = $Members
        'ClientID'          = $env:ClientID
        'ClientSecret'      = $env:ClientSecret
        'TenantID'          = $env:Tenantid
        'Verbose'           = $true
    }
    
    New-AADGroup @params
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
