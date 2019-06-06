<#
    DON'T FORGET to collapse all regions in demo scripts
    Ctrl + K Ctrl +8

    #####################################################
    Demo how to use the PSExtensionHelper PowerShell Module. 10 mins
    #####################################################

    This module converts commands from a PowerShell module in a task.json
#>

#region Import Module PSExtension
Remove-Module PSExtensionHelper -ErrorAction SilentlyContinue
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\Extra\PSExtensionHelper\PSExtensionHelper.psd1 -verbose
#endregion

#region variables for PSJwt PowerShell Module
$params = @{
    Name               = 'PSJwt'
    TaskName           = 'JWT-Demo'
    Description        = 'JSON Web Token Extension Demo for PowerShell Conference EU 2019'
    Category           = 'Deploy'
    Author             = 'Stefan Stranger'
    Version            = '1.0.0'
    Preview            = $true
    InstanceNameFormat = 'JSON Web Token Extension Demo'
    OutFile            = "$env:Temp\task.json"
}
#endregion

#region Call Function ConvertTo-Task
ConvertTo-Task @params -Validate
#endregion

#region open task.json
. code "$env:Temp\task.json"
#endregion

#region compare original with dynamically created task.json
$archivePath = Join-Path (Split-path $((Get-Location).Path)) -ChildPath "\PSJwtExtension\PsJwt-v1.0\task.json"

. code -d "$env:Temp\task.json" "$archivePath"
#endregion

#region Import Module PSHelloWorld
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\Extra\PSHelloWorld\Output\PSHelloWorld\0.1.0\PSHelloWorld.psd1 -Verbose
#endregion

#region variables for PSHelloWorld Module convertion
$params = @{
    Name               = 'PSHelloWorld'
    TaskName           = 'HelloWorld-Demo'
    Description        = 'Hello World Demo for PowerShell Conference EU 2019'
    Category           = 'Deploy'
    Author             = 'Stefan Stranger'
    Version            = '1.0.1'
    Preview            = $true
    InstanceNameFormat = 'HelloWorld Extension Demo'
    OutFile            = "$env:Temp\task.json"
}
#endregion

#region Call Function ConvertTo-Task
ConvertTo-Task @params -Validate
#endregion

#region open new task.json
. code "$env:Temp\task.json"
#endregion

#region copy task.json to Extension folder
Copy-Item "$env:Temp\task.json" -Destination "..\PSHWExtension\PsHW-v1.0" -Force
#endregion

#region Build Extension
Invoke-Build ..\PSHWExtension\PSHWExtension.build.ps1 -Task .
#endregion

#region clean up
Invoke-Build ..\PSHWExtension\PSHWExtension.build.ps1 -Task clean
Remove-Item "..\PSHWExtension\PsHW-v1.0\task.json"
#endregion