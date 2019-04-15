Function Get-AccessToken {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        # ClientId from Service Principal (Service Endpoint)
        [string]$ClientId,
        # ClientSecret from Service Principal (Service Endpoint)
        [Parameter(Mandatory = $true)]
        [string]$ClientSecret,
        [Parameter(Mandatory = $false)]
        [string]$TenantId = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81'
    )
    
    $TokenEndpoint = ('https://login.microsoftonline.com/{0}/oauth2/v2.0/token' -f $tenantid )

    $Body = @{
        'client_id'     = $ClientID
        'client_secret' = $ClientSecret
        'grant_type'    = 'client_credentials'        
        'scope'         = 'https://graph.microsoft.com/.default'
    }

    $params = @{
        ContentType = 'application/x-www-form-urlencoded'
        Headers     = @{'accept' = 'application/json'}
        Body        = $Body
        Method      = 'Post'
        URI         = $TokenEndpoint
    }

    try {
        Write-Verbose -message ('Retrieving Access Token for ClientID: {0}' -f $clientId)
        $Token = Invoke-RestMethod @params -ErrorAction Stop
        return $($Token)

    }
    catch {
        Write-Error -Message ('Failed to retrieve Access Token')
    }
}