<#
    PowerShell module for creating cross-platform websites and REST APIs. 
    
    Link: https://universaldashboard.io

    Simple example of an API (listening on port 8686) returning running Processes on localhost

    Notes:
    - Collapse regions - Ctrl K + Ctrl 8
    - Restart integrated PowerShell host to make sure no session data from Polaris is kept.
#>

#region clean op host
# Remove-Module -Name Polaris, Polaris.Class, PolarisMiddleWare.Class, PolarisRequest.Class, PolarisResponse.Class, UniversalDashboard.Community -ErrorAction SilentlyContinue
#endregion

#region Import Universal Dashboard Community PowerShell Module
# Import-Module -Name 'UniversalDashboard.Community' -Verbose
#endregion

#region Create a REST API endpoint for processes
$Endpoint = New-UDEndpoint -Url "/process" -Method "GET" -Endpoint {
    Get-Process | ForEach-Object { [PSCustomObject]@{ ProcessName = $_.Name; Id = $_.ID; CPU = $_.CPU } } | ConvertTo-Json
}
Start-UDRestApi -Endpoint $Endpoint -Port 8686 -Name 'PSConfEu'
#endregion

#region call UD process REST API endpoint
Invoke-RestMethod -Uri http://localhost:8686/api/process
#endregion

#region Stop REST API endpoint
Stop-UDRestApi -Name 'PSConfEu'
#endregion

#region Create REST API for PSConfEU Agenda
$Endpoint = New-UDEndpoint -Url "/psconfeu" -Method "POST" -Endpoint {
    param($name)
    # Get PSConfEU Agenda
    $Agenda = Invoke-RestMethod -Method 'Get' -Uri 'https://raw.githubusercontent.com/psconfeu/2019/master/sessions.json'
    $Agenda | 
    Where-Object { $_.Name -match "$name" } |
    ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Starts = $_.Starts; Ends = $_.Ends; Track = $_Track; Description = $_.Description; Speaker = $_.Speaker } } | ConvertTo-Json
}
Start-UDRestApi -Endpoint $Endpoint -Port 8787 -Name 'Agenda'
#endregion

#region call PSConfEu Agenda REST API
Invoke-RestMethod -Uri 'http://localhost:8787/api/psconfeu' -Method 'Post' -Body @{'Name' = 'proto' }
#endregion

#region Stop REST API endpoint
Stop-UDRestApi -Name 'Agenda'
#endregion