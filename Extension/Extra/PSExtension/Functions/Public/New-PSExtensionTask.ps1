<#
    Steps:
    1. Retrieve Cmdlet Parameters
    2. Create Input Properties per parameter
    3. Create Extension Task

#>

#region create Input Objects

#region create InputObjectProperty
$InputProperty = [InputProperties]::new($false)
#endregion

$MyInputs = @()

#region create Input Object with hashtable
$MyInput = [Input]@{
    name         = 'ConvertFrom-JWT'
    aliases      = 'aliases'
    label        = 'Parsing (decoding) and verifying JSON Web Token'
    type         = 'string'
    defaultValue = $null
    required     = $true
    helpMarkDown = 'Parsing (decoding) and verifying JSON Web Token'
    groupName    = '__AllParameterSets'
    visibleRule  = $null
    properties   = $InputProperty
    options      = $null
}
#endregion

$MyInputs += $MyInput

#region create Input Object with hashtable
$MyInput = [Input]@{
    name         = 'ConvertTo-JWT'
    aliases      = 'aliases'
    label        = 'Creating (encoding) JSON Web Token'
    type         = 'string'
    defaultValue = $null
    required     = $true
    helpMarkDown = 'Creating (encoding) JSON Web Token'
    groupName    = '__AllParameterSets'
    visibleRule  = $null
    properties   = $InputProperty
    options      = $null
}
#endregion

$MyInputs += $MyInput
#endregion

#region Create Input Object from Cmdlet
$Cmdlet = Get-Command -Name Convertfrom-Jwt 
$Parameters = $Cmdlet.ParameterSets.Parameters | Where-Object { $_.Position -ne '-2147483648' }
$Help = Get-Help -Name ConvertFrom-JWT
[PSCustomObject]@{
    Name         = $Parameters.Name
    label        = $Help.description.text
    type         = $($Parameters.ParameterType).Name
    defaultValue = $null
    required     = $true
    helpMarkDown = $Help.details.description.text
    groupName    = '__AllParameterSets'
    visibleRule  = $null
    properties   = $InputProperty
    options      = $null
}

[Input]@{
    name         = 'ConvertTo-JWT'
    aliases      = 'aliases'
    label        = 'Creating (encoding) JSON Web Token'
    type         = 'string'
    defaultValue = $null
    required     = $true
    helpMarkDown = 'Creating (encoding) JSON Web Token'
    groupName    = '__AllParameterSets'
    visibleRule  = $null
    properties   = $InputProperty
    option       = $null
}


#endregion


#region create new ExtensionTask
$NewExtensionTask = [ExtensionTask]@{
    id           = ((New-Guid).Guid)
    name         = 'JWT-Demo'
    friendlyName = 'CCoE Demo Azure Storage Account'
    description  = 'The CCoE Demo certified Azure Storage Account'
    helpMarkDown = 'Use this release task to deploy a Storage Account as a certified service.'
    category     = 'Deploy'
    visibility   = 'Release'
    author       = 'Stefan Stranger'
    version      = "1.0.0"
    inputs       = $MyInputs
}
#endregion

$NewExtensionTask | ConvertTo-Json