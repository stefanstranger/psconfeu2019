#region Import Module PSExtension
Remove-Module PSExtensionHelper
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\Extra\PSExtensionHelper\PSExtensionHelper.psd1 -verbose
#endregion

#region variables
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