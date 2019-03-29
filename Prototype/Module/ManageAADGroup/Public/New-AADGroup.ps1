<#
    https://docs.microsoft.com/en-us/graph/api/group-post-groups?view=graph-rest-1.0

    Example:
    New-AADGroup -DisplayName 'demo' -Description 'demo' -MailNickName 'demo' -OwnerObjectID '74f060dc-fe58-4b72-a888-ae363052cb27' -ClientId 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' -ClientSecret $env:psconfeu -Verbose
#>

Function New-AADGroup {
    [CmdletBinding()]
    Param(
        # AAD Group DisplayName
        [Parameter(Mandatory = $true)]        
        [string]$DisplayName,
        # AAD Group Description
        [Parameter(Mandatory = $false)]            
        [string]$Description,
        # AAD Group MailNickName    
        [Parameter(Mandatory = $true)]        
        [string]$MailNickName,
        # AAD Group Owner User Principal name (john.doe@asml.com)
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
        [Parameter(Mandatory = $false,
            ParameterSetName = 'ServicePrincipal')]
        [string]$TenantId = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81',
        # Group Members
        [Parameter(Mandatory = $false)]
        [string[]]$Members
    )

    try {
        #region Get Access Token
        $params = @{
            ClientID     = $clientId
            ClientSecret = $clientSecret
            TenantId     = $TenantId
        }

        $Token = Get-AccessToken @params
        Write-Debug -message ('Token: {0}' -f $Token.access_token)
        #endregion

        #region retrieve Object Id for Owner User Prinipal Name
        Write-Verbose -Message ('New-AADGroup - Retrieving AAD User {0} Object Id' -f $UserPrincipalName)
        $AADUser = Get-AADUser -UserPrincipalName $UserPrincipalName -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId
        Write-Debug -Message ('AADUser variable: {0}' -f $AADUser.id)
        #endregion

        #region retrieve Group Member Object Ids
        Write-Verbose -Message ('Retrieve Group Member Object Ids')
        if ($Members) {
            $MemberObjectList = @()
            Foreach ($Member in $Members) {
                Write-Verbose -Message ('New-AADGroup - Retrieving AAD User {0} with ClientId and ClientSecret' -f $Member)
                $AADUserMember = Get-AADUser -UserPrincipalName $Member -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId

                $MemberObjectList += ('https://graph.microsoft.com/v1.0/users/{0}' -f $($AADUserMember.id))            
            }
            $MemberObjectList
        }
        #endregion


        #region Create AAD Group
        Write-Verbose -Message ('Create AAD Group')
        $Uri = ('https://graph.microsoft.com/v1.0/groups')

        if (!($Description)) {
            $Description = ''
        }

        $Body = [ordered]@{
            'displayName'       = $DisplayName
            'description'       = $Description
            "mailEnabled"       = $false
            "mailNickname"      = $MailNickName
            "securityEnabled"   = $true
            "owners@odata.bind" = @(
                ('https://graph.microsoft.com/v1.0/users/{0}' -f $($AADUser.id))
            )
        }

        # add members if needed
        if ($MemberObjectList -ne $null) {
            $Body += @{'members@odata.bind' = $MemberObjectList}
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
        Write-Verbose -Message ('New-AADGroup - Response {0}' -f $($Response[1] | Convertto-Json))

        return ($Response[1])
        #endregion

    }
    catch {
        Throw ('Error Message {0}' -f ($_ | ConvertFrom-Json).error)
    }
}