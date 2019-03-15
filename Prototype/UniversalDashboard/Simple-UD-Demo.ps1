#region Import Universal Dashboard Community PowerShell Module
Import-Module -Name 'UniversalDashboard.Community'
#endregion

#region Create a REST API endpoint for processes
$Endpoint = New-UDEndpoint -Url "/process" -Method "GET" -Endpoint {
    Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; ID = $_.ID} }  | ConvertTo-Json
}
Start-UDRestApi -Endpoint $Endpoint -Port 8686 -Name 'PSConfEu'
#endregion

#region call UD process REST API endpoint
Invoke-RestMethod -Uri http://localhost:8686/api/process
#endregion

#region Stop REST API endpoint
Stop-UDRestApi -Name 'PSConfEu'
#endregion