<#
    Demo Universal Dashboard Manage AAD Group REST API

    In browser you can use: 
    http://localhost:8080/api/getgroup?displayname=PSConfEu-Demo-Group

    http://localhost:8080/api/removegroup?displayname=PSConfEu-Demo-Group

    http://localhost:8080/api/newgroup?displayname=PSConfEu-Demo-Group&description=PSConfEu%20Demo%20Group&mailnickname=psconfeudemogroup&userprincipalname=johndoe@sstranger.onmicrosoft.com&members=janedoe@sstranger.onmicrosoft.com
#>

#region Import Universal Dashboard Community PowerShell Module
Import-Module -Name 'UniversalDashboard.Community'
#endregion

#region Endpoint
$Endpoints = @()
#endregion

#region Create a REST API endpoint for Getting AAD Group info
$Endpoints += New-UDEndpoint -Url "/getgroup" -Method "GET" -Endpoint {
    param($DisplayName)

    #region variables
    $Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
    $ClientID = 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' #ApplicationID
    $ClientSecret = "$env:psconfeu"
    #endregion

    #region Import Custom ManageAADGroup Module
    Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Module\ManageAADGroup
    #endregion

    Try {
        #region Check if Group Exists
        $params = @{
            'DisplayName'  = $DisplayName
            'ClientID'     = $ClientID
            'ClientSecret' = $ClientSecret
            'TenantID'     = $Tenantid
        }
        Get-AADGroup @params | ForEach-Object { [PSCustomObject]@{ 
                id              = $_.id; 
                createdDateTime = $_.createdDateTime
                description     = $_.description
                displayName     = $_.displayName
                mailEnabled     = $_.mailEnabled
                mailNickName    = $_.mailNickName
                renewedDateTime = $_.renewedDateTime
                securityEnabled = $_.securityEnabled
            } }  | ConvertTo-Json
        #endregion
    }
    Catch {
        $Exception = [System.Net.WebException]::new()
        $Response = [PSCustomObject]@{ 
            StatusCode = [PSCustomObject]@{
                Value__ = 404
            }
        }
        $Exception | Add-Member -Name Response  -MemberType NoteProperty -Value $Response -Force
        $Exception
    }
}
#endregion

#region Create REST API Endpoint for Creating an AAD Group
$Endpoints += New-UDEndpoint -Url "/newgroup" -Method "POST" -Endpoint {
    param($DisplayName, $Description, $MailNickName, $UserPrincipalName, $Members)

    #region variables
    $Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
    $ClientID = 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' #ApplicationID
    $ClientSecret = "$env:psconfeu"
    #endregion

    #region Import Custom ManageAADGroup Module
    Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Module\ManageAADGroup
    #endregion

    Try {
        $params = @{
            'DisplayName'       = $DisplayName
            'Description'       = $Description
            'MailNickName'      = $MailNickName
            'UserPrincipalName' = $UserPrincipalName
            'Members'           = $Members
            'ClientID'          = $ClientID
            'ClientSecret'      = $ClientSecret
            'TenantID'          = $Tenantid
        }
        New-AADGroup @params | Foreach-Object { 
            [PSCustomObject]@{ 
                id              = $_.id; 
                createdDateTime = $_.createdDateTime
                description     = $_.description
                displayName     = $_.displayName
                mailEnabled     = $_.mailEnabled
                mailNickName    = $_.mailNickName
                renewedDateTime = $_.renewedDateTime
                securityEnabled = $_.securityEnabled
            } 
        } | ConvertTo-Json
    }
    Catch {
        $Exception = [System.Net.WebException]::new()
        $Response = [PSCustomObject]@{ 
            StatusCode = [PSCustomObject]@{
                Value__ = 404
            }
        }
        $Exception | Add-Member -Name Response  -MemberType NoteProperty -Value $Response -Force
        $Exception
    }
}
#endregion

#region Create REST API Endpoint for Removing an AAD Group
$Endpoints += New-UDEndpoint -Url "/removegroup" -Method "POST" -Endpoint {
    param($DisplayName)

    #region variables
    $Tenantid = '496f0b27-4fa4-4c3d-8bbe-19c4b6875c81' #sstranger
    $ClientID = 'a6e00d89-360e-40c6-a7de-3ad29d733fc7' #ApplicationID
    $ClientSecret = "$env:psconfeu"
    #endregion

    #region Import Custom ManageAADGroup Module
    Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Module\ManageAADGroup
    #endregion

    Try {
        $params = @{
            'DisplayName'  = $DisplayName
            'ClientID'     = $ClientID
            'ClientSecret' = $ClientSecret
            'TenantID'     = $Tenantid
        }
        Remove-AADGroup @params | Foreach-Object { 
            [PSCustomObject]@{ 
                Code    = $_.Code; 
                Message = $_.Message
            } 
        } | ConvertTo-Json
    }
    Catch {
        $Exception = [System.Net.WebException]::new()
        $Response = [PSCustomObject]@{ 
            StatusCode = [PSCustomObject]@{
                Value__ = 404
            }
        }
        $Exception | Add-Member -Name Response  -MemberType NoteProperty -Value $Response -Force
        $Exception
    }
}
#endregion

#region start Endpoints
Start-UDRestApi -port 8080 -Endpoint $Endpoints -Name RESTAPI
#endregion

#region Call REST API to Create Group
$body = @{
    'DisplayName'       = 'PSConfEu-Demo-Group'
    'Description'       = 'PSConfEu Demo Group'
    'MailNickName'      = 'psconfeudemogroup'
    'UserPrincipalName' = 'johndoe@sstranger.onmicrosoft.com'
    'Members'           = 'janedoe@sstranger.onmicrosoft.com'
}
Invoke-RestMethod -Uri http://localhost:8080/api/newgroup -Method POST -Body $body -OutVariable Result
#endregion

#region Call REST API to get Group
$body = @{
    'DisplayName' = 'PSConfEu-Demo-Group'
}
Invoke-RestMethod -Uri http://localhost:8080/api/getgroup -Method GET -Body $body -OutVariable Result
#endregion

#region Call REST API to remove Group
$body = @{
    'DisplayName' = 'PSConfEu-Demo-Group'
}
Invoke-RestMethod -Uri http://localhost:8080/api/removegroup -Method POST -Body $body -OutVariable Result
#endregion

#region Stop UD REST API
Stop-UDRestApi -Name RESTAPI
#endregion