<#
    Polaris can be used by web developers and system administrators alike to build web applications and APIs quickly and with very little code.

    Link: https://powershell.github.io/Polaris/docs/about_Polaris.html

    Simple example of an API (listening on port 8585) returning running Processes on localhost

    Collapse regions - Ctrl K + Ctrl 8
#>

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