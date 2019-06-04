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
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\ps_modules\VstsTaskSdk\VstsTaskSdk.psd1 -whatif
code C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\ps_modules\VstsTaskSdk\InputFunctions.ps1
#endregion

#region open Task library on Github
Start-Process 'https://github.com/Microsoft/azure-pipelines-task-lib'
Start-Process 'https://github.com/microsoft/azure-pipelines-task-lib/tree/master/powershell'
#endregion

#region PowerShell on Target Machine Task code on Github
Start-Process 'https://github.com/microsoft/azure-pipelines-tasks/tree/master/Tasks/PowerShellOnTargetMachinesV3'
#endregion