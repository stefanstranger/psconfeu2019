<#
    https://docs.microsoft.com/en-us/graph/api/group-get?view=graph-rest-1.0
    https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,'Test')

    Example:
    Get-AADGroup -DisplayName 'demo' -ClientId 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' -ClientSecret $env:psconfeu -Verbose
#>

Function Get-AADGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        # AAD Group DisplayName
        [string]$DisplayName,
        [Parameter(Mandatory = $false)]
        # ClientId from Service Principal (Service Endpoint)
        [string]$ClientId,
        # ClientSecret from Service Principal (Service Endpoint)
        [Parameter(Mandatory = $true)]
        [string]$ClientSecret,
        [Parameter(Mandatory = $false)]
        [string]$TenantId = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81'
    )

    try {

        #region Get Access Token
        $params = @{
            ClientID     = $clientId
            ClientSecret = $clientSecret
            TenantId     = $TenantId
        }

        $Token = Get-AccessToken @params
        Write-Verbose ('Token: {0}' -f $Token.access_token)
        #endregion

        #region Get AAD Group
        $Uri = ('https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,''{0}'')' -f $DisplayName)
        Write-Verbose ('Uri: {0}' -f $Uri)
        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token.access_token)"
            }
            Method      = 'Get'
            URI         = $Uri 
        }
        
        $Response = (Invoke-RestMethod @params -ErrorAction Stop).Value
        Write-Verbose -Message ('Response: {0}' -f $($Response | Convertto-Json))
        #When no AAD Group is found create an error message
        if ($Response) {
            return ($Response)
        }
        else {
            Throw ('AAD Group {0} not found' -f $DisplayName)
        }
        #endregion

    }
    catch {
        Throw ('Error Message {0}' -f ($_))
    }
}