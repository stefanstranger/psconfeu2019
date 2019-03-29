<#
    https://docs.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0

    Example:

    Get-AADUser -UserPrincipalName 'john.doe@sstranger@onmicrosoft.com' -ClientId 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' -ClientSecret $env:psconfeu -Verbose
#>

Function Get-AADUser {

    [CmdletBinding()]
    Param(
        # AAD User DisplayName
        [Parameter(Mandatory = $true)]        
        [string]$UserPrincipalName,
        # ClientId from Service Principal (Service Endpoint)
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ServicePrincipal')]        
        [string]$ClientId,
        # ClientSecret from Service Principal (Service Endpoint)
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ServicePrincipal')]
        [string]$ClientSecret,
        # Tenant ID
        [Parameter(Mandatory = $false)]
        [string]$TenantId = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81',
        # Optional Access Token parameter
        [Parameter(Mandatory = $false,
            ParameterSetName = 'AccessToken')]
        [string]$AccessToken
    )

    try {

        #region Get Access Token
        if (!($AccessToken)) {
            $params = @{
                ClientID     = $clientId
                ClientSecret = $clientSecret
                TenantId     = $TenantId
            }
            $Token = Get-AccessToken @params
            #endregion
        }
        else {
            $Token = [PSCustomObject]@{ 
                Access_Token = $AccessToken
            }
        }

        Write-Verbose -message ('Get-AADUser - Access Token value: {0}; User {1}' -f $($Token.Access_Token), $UserPrincipalName)


        #region Get User info
        $Uri = ('https://graph.microsoft.com/v1.0/users/{0}' -f $UserPrincipalName)

        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token.Access_Token)"
            }
            Method      = 'Get'
            URI         = $Uri 
        }

        $Response = Invoke-RestMethod @params -ErrorAction Stop
        return $Response
        #endregion
    }
    catch {
        Throw ('Error Message {0}' -f ($_))
    }
}