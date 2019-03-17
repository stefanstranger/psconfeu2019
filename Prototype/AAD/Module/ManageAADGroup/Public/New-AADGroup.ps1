Function New-AADGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        # AAD Group DisplayName
        [string]$DisplayName,
        [Parameter(Mandatory = $false)]
        # AAD Group Description
        [string]$Description,
        [Parameter(Mandatory = $true)]
        # AAD Group MailNickName
        [string]$MailNickName,
        [Parameter(Mandatory = $true)]
        # AAD Group Owner ObjectId
        [string]$OwnerObjectID,
        [Parameter(Mandatory = $true)]
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
        #endregion

        #region parse Access Token
        #ConvertFrom-JWT -Token $Token
        #endregion

        #region Create AAD Group
        $Uri = ('https://graph.microsoft.com/v1.0/groups')

        if (!($Description)) {
            $Description = ''
        }

        $Body = @{
            'displayName'       = $DisplayName
            'description'       = $Description
            "groupTypes"        = @(
                "Unified"
            )
            "mailEnabled"       = $true
            "mailNickname"      = $MailNickName
            "securityEnabled"   = $false
            "owners@odata.bind" = @(
                ('https://graph.microsoft.com/v1.0/users/{0}' -f $OwnerObjectID)
            )
        }

        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token.access_token)"
            }
            Body        = ($Body | ConvertTo-Json)
            Method      = 'Post'
            URI         = $Uri 
        }
        
        $Response = Invoke-RestMethod @params -ErrorAction Stop
        Write-Verbose -Message ('Response {0}' -f $($Response | Convertto-Json))

        return ($Response)
        #endregion

    }
    catch {
        Throw ('Error Message {0}' -f ($_ | ConvertFrom-Json).error)
    }
}