<#
    PowerShell module for creating cross-platform websites and REST APIs. 
    
    Link: https://universaldashboard.iol

    Simple example of an API (listening on port 8686) returning running Processes on localhost
#>

#region Import Universal Dashboard Community PowerShell Module
Import-Module -Name 'UniversalDashboard.Community'
#endregion

#region Create a REST API endpoint for processes
$Endpoint = New-UDEndpoint -Url "/process" -Method "GET" -Endpoint {
    Get-Process | ForEach-Object { [PSCustomObject]@{ ProcessName = $_.Name; Id = $_.ID; CPU = $_.CPU} }  | ConvertTo-Json
}
Start-UDRestApi -Endpoint $Endpoint -Port 8686 -Name 'PSConfEu'
#endregion

#region call UD process REST API endpoint
Invoke-RestMethod -Uri http://localhost:8686/api/process
#endregion

#region Stop REST API endpoint
Stop-UDRestApi -Name 'PSConfEu'
#endregion