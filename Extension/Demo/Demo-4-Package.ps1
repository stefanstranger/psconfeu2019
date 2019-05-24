<#
    DON'T FORGET to collapse all regions in demo scripts
    Ctrl + K Ctrl +8

    #####################################################
    Demo 4 - Package Extension - 5 minutes
Demo 4 - Package Extension - 5 minutes
    #####################################################

    Demo how to package the extension using the build tasks
#>

#region Open build script
. code ..\PSJwtExtension\PSJwtExtension.build.ps1
#endregion

#region create Extension
Invoke-Build -File ..\PSJwtExtension\PSJwtExtension.build.ps1
#endregion

#region open Visual Studio MarketPlace to publish Extension
Start-Process 'https://marketplace.visualstudio.com/manage/publishers/slvstranger'
#endregion

#region View Extension
Start-Process 'https://marketplace.visualstudio.com/items?itemName=SLVStranger.PSConfEU-Demo-Extension'
#endregion