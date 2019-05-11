#region Open build script
. code ..\PSJwtExtension\PSJwtExtension.build.ps1
#endregion

#region create Extension
Invoke-Build -File ..\PSJwtExtension\PSJwtExtension.build.ps1
#endregion