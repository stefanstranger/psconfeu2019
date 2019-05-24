<#
    This PowerShell script is used to call the PSJwtExtension.build.ps1 script from an ADO Build Pipeline with
#>

param ($PAT)

Invoke-Build  .\PSJwtExtension.build.ps1 -PAT $PAT -Task BuildCreateExtension