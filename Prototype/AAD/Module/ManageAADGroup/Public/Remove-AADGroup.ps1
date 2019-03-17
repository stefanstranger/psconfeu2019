<#
    https://docs.microsoft.com/en-us/graph/api/group-delete?view=graph-rest-1.0

    Example:
    Remove-AADGroup -DisplayName 'demo' -ClientId 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' -ClientSecret $env:psconfeu -Verbose
#>

Function Remove-AADGroup {
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

        #region Get AAD Group ID
        $AADGroup = Get-AADGroup -DisplayName $DisplayName -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId
        #endregion

        #region Remove AAD Group
        $Uri = ('https://graph.microsoft.com/v1.0/groups/{0}' -f $($AADGroup.id))
        Write-Verbose ('Uri: {0}' -f $Uri)
        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token.access_token)"
            }
            Method      = 'Delete'
            URI         = $Uri 
        }
        
        Invoke-RestMethod @params -ErrorAction Stop
        $Response = [PSCustomObject]@{ 
            Code    = 'OK'
            Message = ('AAD Group {0} deleted' -f $DisplayName)
        }
        return $Response
        #endregion

    }
    catch {
        Throw ('Error Message {0}' -f ($_))
    }
}