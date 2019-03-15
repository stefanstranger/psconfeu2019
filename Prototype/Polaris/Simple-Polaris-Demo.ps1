#region clean up
Remove-PolarisRoute
Stop-Polaris
#endregion

#region start Polaris session
New-PolarisRoute -path process -Method GET -ScriptBlock {
    $ProcessInfo = Get-Process | Select-Object ProcessName, Id, CPU | ConvertTo-Json
    $Response.json($ProcessInfo)
}
Start-Polaris -Port 8585
#endregion

#region Retrieve Polaris Route
Get-PolarisRoute
#endregion

#region call Polaris Service. Needs to be called from another process.
# Invoke-RestMethod -Method Get -Uri http://localhost:8585/process
#endregion

#region Remove Polaris Route and stop Polaris
Remove-PolarisRoute -path /process
Stop-Polaris
#endregion

