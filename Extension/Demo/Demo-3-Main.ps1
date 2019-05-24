<#
    DON'T FORGET to collapse all regions in demo scripts
    Ctrl + K Ctrl +8

    #####################################################
    Demo 3 - Show artifacts of PSJwtExtension - 10 minutes
    #####################################################

    Show:
    - Extension Manifest and task files
    - Task.json
    - Main.ps1
    - Show VSTS Commandlets 
    (Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\ps_modules\VstsTaskSdk\VstsTaskSdk.psd1 -Verbose)
    - ps_modules
#>

#region Import VSTS SDK Helper Module
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\ps_modules\VstsTaskSdk\VstsTaskSdk.psd1 -Verbose -Force
#endregion

#region Get-VSTSInput command
Get-Command -Name Get-VstsInput -Syntax
#endregion