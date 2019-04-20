<#
    The Managed Identity created for the Azure Function App needs Microsoft Graph App Role permissions.
    Application Permissions:
        - Read all groups
        - Read and write all groups
        - Read directory data
    Delegated Permissions:
        - Read and write all groups
        - View your basic profile
#>

#region variables
$Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
$tenantdomainName = 'sstranger.onmicrosoft.com'
$apiversion = '1.6'
#endregion

#region Connect with Azure Subscription
Add-AzAccount -Tenant $Tenantid
#endregion

#region retrieve current context
Write-Output -InputObject ('Retrieve current context')
$Context = Get-AzContext
#endregion

#region retrieve Access Token
$User = Get-AzADUser -StartsWith $($Context.Account.Id).Split('.')[0]
$Context.TokenCache
$cache = $Context.TokenCache
$cacheItems = $cache.ReadItems()
$token = ($cacheItems | Where-Object { $_.Resource -eq "https://graph.windows.net/" })
$AccessToken = $token.AccessToken

write-output -InputObject ("Token: {0}`n AccountId: {1}`n TenantId: {2}" -f $AccessToken, $User.DisplayName, $Context.Tenant.Id )
#endregion

#region get AppRoles for Graph API
function Get-ServicePrincipal {
    [CmdletBinding()]
    param (
        [string]$Token,
        [string]$TenantDomain,
        [string]$ApiVersion = '1.6'
    )
    
    begin {
        #region variables
        $Uri = ('https://graph.windows.net/{0}/{1}?api-version={2}' -f $tenantDomain, 'servicePrincipals', $apiversion)
        #endregion
    }
    
    process {

        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token)"
            }
            Method      = 'Get'
            URI         = $Uri 
        }
          
        return (Invoke-RestMethod @params).value
        
    }
}

Get-ServicePrincipal -Token $AccessToken -TenantDomain $tenantdomainName -ApiVersion $apiversion | Where-Object { $_.AppDisplayName -eq 'Microsoft Graph' } -OutVariable Graph
$Graph.AppRoles
#endregion

#region Get Managed Identity Object ID
Get-ServicePrincipal -Token $AccessToken -TenantDomain $tenantdomainName -ApiVersion $apiversion | Where-Object { $_.DisplayName -eq 'psconfeu2019' } -OutVariable ManagedIdentity -Verbose
#endregion

#region Get Managed Identity Role Assignments
function Get-MIAppRoleAssignment {
    [CmdletBinding()]
    param (
        [string]$Token,
        [string]$TenantId,
        [string]$ApiVersion = '1.6',
        [string]$ObjectId
    )
    
    begin {
        #region variables
        $Uri = ('https://graph.windows.net/{0}/{1}/{2}/appRoleAssignments?api-version={3}' -f $tenantId, 'servicePrincipals', $ObjectId, $apiversion)
        #endregion
        Write-Verbose -Message ('Uri: {0}' -f $Uri)
    }
    
    process {

        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token)"
            }
            Method      = 'Get'
            URI         = $Uri 
        }
          
        return (Invoke-RestMethod @params)
        
    }
}

Get-MIAppRoleAssignment -Token $AccessToken -TenantId $tenantid -ObjectId $($ManagedIdentity.ObjectId) -OutVariable result -Verbose
$result | Select-Object -ExpandProperty value
#endregion

#region Retrieve Application and Delegated Graph API Permissions
$ApplicationPermissions = $Graph.AppRoles | Where-Object { $_.DisplayName -eq 'Read all groups' -or $_.DisplayName -eq 'Read and write all groups' -or $_.DisplayName -eq 'Read directory data' }
$DelegatedPermissions = $Graph.oauth2Permissions | Where-Object { $_.userconsentdisplayname -eq 'Read and write all groups' -or $_.userconsentdisplayname -eq 'View your basic profile' }
#endregion

#region Add Graph API Role permissions for Managed Identity
function Set-MIAppRoleAssignment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]$Token,

        # The unique identifier (objectId) for the target resource (service principal) for which the assignment was made.
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]$ResourceID,

        # The unique identifier (objectId) for the principal being granted the access. 
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]$PrincipalId,

        # RoleAssignmentID.
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]$RoleAssignmentID,

        # Tenant Domain Name.
        [Parameter(Mandatory = $true)]
        [string]
        $tenantDomain,

        # Api Version.
        [Parameter(Mandatory = $false)]
        [string]
        $ApiVersion = '1.6'
    )
    
    begin {
        $Uri = ('https://graph.windows.net/{0}/{1}/{2}/appRoleAssignments?api-version={3}' -f $tenantDomain, 'servicePrincipals', $PrincipalID, $apiversion)
        Write-Verbose -Message ('uri: {0}' -f $uri)
    }
    
    process {        
 
        $Body = @{
            'id'          = $RoleAssignmentID # Role Assignment ID. Example: Directory.Read.All 7ab1d382-f21e-4acd-a863-ba3e13f7da6
            'resourceid'  = $ResourceID # AppId of the Graph Service Principal
            'principalid' = $PrincipalID # The unique identifier (id) for the principal being granted the access (Managed Identity id)
        } | ConvertTo-Json
 

        $params = @{
            ContentType = 'application/json'
            Headers     = @{
                'authorization' = "Bearer $($Token)"
            }
            Method      = 'Post'
            URI         = $Uri
            Body        = $Body
        }

        Write-Verbose -Message ($params | convertto-json)

        return (Invoke-RestMethod @params)
    }
    
    end {
    }
}


#Iterate Role Permissions and set Role Permission
Foreach ($AppPermission in $ApplicationPermissions) {
    Set-MIAppRoleAssignment -token $AccessToken -ResourceID $Graph.appId -RoleAssignmentID $AppPermission.id -PrincipalId $ManagedIdentity.ObjectId -tenantDomain $tenantdomainName -ApiVersion $apiversion -Verbose
}

Foreach ($DelegatedPermission in $DelegatedPermissions) {
    Set-MIAppRoleAssignment -token $AccessToken -ObjectId $ManagedIdentity.objectid -RoleAssignmentID $DelegatedPermission.id -tenantDomain $tenantdomainName -ApiVersion $apiversion
}


#endregion