<#
.SYNOPSIS
    PowerShell Module file for PSExtension
.DESCRIPTION
    This PowerShell module file will load all the functions present under Private and Public folder.
.LINK
    https://github.com/StefanStranger/PSConfeu2019
#>

if ($MyInvocation.line -match '-verbose') {
    $VerbosePreference = 'continue'
}

# Retrieve parent folder
$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Path

Write-Verbose -Message "Loading Private Functions"
$PrivateFunctions = Get-ChildItem -Path "$ScriptPath\Functions\Private" -Filter *.ps1 | Select-Object -ExpandProperty FullName

foreach ($Private in $PrivateFunctions) {
    Write-Verbose -Message "importing function $($function)"
    try {
        . $Private
    }
    catch {
        Write-Warning -Message $_
    }
}

Write-Verbose -Message "Loading Public Functions"
$PublicFunctions = Get-ChildItem -Path "$ScriptPath\Functions\Public" -Filter *.ps1 | Select-Object -ExpandProperty FullName

foreach ($public in $PublicFunctions) {
    Write-Verbose "importing function $($function)"
    try {
        . $public
    }
    catch {
        Write-Warning -Message $_
    }
}

Write-Verbose -Message "Loading Public Classes"
$PublicClasses = Get-ChildItem -Path "$ScriptPath\Classes\Public" -Filter *.ps1 | Select-Object -ExpandProperty FullName

foreach ($pc in $PublicClasses) {
    Write-Verbose "importing $($pc)"
    try {
        . $pc
    }
    catch {
        Write-Warning -Message $_
    }
}

#region change verbose preference
$VerbosePreference = 'SilentlyContinue'
#endregion