#region Import Universal Dashboard Community PowerShell Module
Import-Module -Name 'UniversalDashboard.Community'
#endregion

#region Create a REST API endpoint for processes
$Endpoint = New-UDEndpoint -Url "/newgroup" -Method "POST" -Endpoint {
    param($DisplayName, $Description, $MailNickName, $OwnerObjectId)

    #region Import Custom ManageAADGroup Module
    Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\AAD\Module\ManageAADGroup -Verbose
    #endregion

    $params = @{
        'DisplayName'   = $DisplayName
        'Description'   = $Description
        'MailNickName'  = $MailNickName
        'OwnerObjectID' = $OwnerObjectId
        'ClientId'      = 'a6e00d89-360e-40c6-a7de-3ad29d733fc7'
        'ClientSecret'  = $env:psconfeu
    }

    Try {
        New-AADGroup @params
    }
    Catch {
        $_
    }
}
Start-UDRestApi -Endpoint $Endpoint 
#endregion

#region Call REST API
$body = @{
    'DisplayName'   = 'Demo'
    'Description'   = 'Demo'
    'MailNickName'  = 'Demo'
    'OwnerObjectID' = '1234567'
}
Invoke-RestMethod -Uri http://localhost:80/api/newgroup -Method POST -Body $body -OutVariable Result
#endregion

#region Stop UD REST API
Get-UDRestApi | Stop-UDRestApi
#endregion