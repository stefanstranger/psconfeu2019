#region Import Module PSExtension
Import-Module C:\Users\stefstr\Documents\GitHub\psconfeu2019\Extension\Extra\PSExtensionHelper\PSExtensionHelper.psd1 -verbose
#endregion

#region variables
$params = @{
    Name               = 'PSJwt'
    TaskName           = 'JWT-Demo'
    #FriendlyName       = 'JSON Web Token Extension Demo'    
    Description        = 'JSON Web Token Extension Demo for PowerShell Conference EU 2019'
    #helpMarkDown       = 'Use this task to decode or create a JSON Web Token'
    Category           = 'Deploy'
    Visibility         = 'Release'
    Author             = 'Stefan Stranger'
    Version            = '1.0.0'
    Preview            = $true
    InstanceNameFormat = 'JSON Web Token Extension Demo'
}
#endregion

#region Call Function ConvertTo-Task
ConvertTo-Task @params -verbose
#endregion

