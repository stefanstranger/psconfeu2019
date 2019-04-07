#https://github.com/Microsoft/azure-pipelines-task-lib/blob/master/tasks.schema.json

Enum inputtypes {
    string
    picklist
    boolean
    radio
}

Class InputProperties {
    [bool] $EditableOptions

    InputProperties(
        [bool] $EditableOptions
    ) {
        $this.EditableOptions = @{'EditableOptions' = $EditableOptions }
    }
}


Class Input {
    [string] $name #required
    [string[]] $aliases
    [string] $label #required 
    [string] $type #required    
    [string] $defaultvalue
    [bool] $required
    [string] $helpMarkdown
    [string] $groupname
    [string] $visibleRule  
    [object] $properties
    [object] $options

    #region Parameterless Constructor
    Input () {
    }
    #endregion

    #region Required Parameters Constructor
    Input (
        [string] $name, #required
        [string] $label, #required 
        [string] $type #required
    ) {
        $this.name = $name
        $this.label = $label
        $this.type = $type  

    }
    #endregion
    
    #region Constructor
    Input(
        [string]$name,
        [string[]] $aliases,
        [string] $label,
        [inputtypes] $type,        
        [string] $defaultvalue,
        [bool] $required,
        [string] $helpMarkdown,
        [string] $groupname,
        [string] $visibleRule,       
        [object] $properties,
        [object] $options
    ) {
        $this.name = $name
        $this.aliases = $aliases
        $this.label = $label
        $this.type = $type        
        $this.defaultvalue = $defaultvalue
        $this.required = $required
        $this.helpMarkDown = $helpMarkdown
        $this.groupname = $groupname
        $this.visibleRule = $visibleRule   
        $this.properties = $properties
        $this.options = $options
    }
    #endregion  
}


Class ExtensionTask {
    #public properties
    [guid] $id
    [string] $name 
    [string] $friendlyname
    [string] $description
    [string] $helpMarkdown
    [string] $category
    [string[]] $visibility
    [string] $author 
    [version] $version
    [string] $preview
    [string] $demands
    [string] $instanceNameFormat
    [string[]] $groups
    [Input[]] $inputs 
    [string] $execution

    #region Parameterless Constructor
    ExtensionTask () {
    }
    #endregion
 
    #region Constructor
    ExtensionTask (
        [guid] $id, 
        [string] $name,
        [string] $friendlyname,
        [string] $description,
        [string] $helpMarkdown,
        [string] $category,
        [string[]] $visibility,
        [string] $author,
        [version] $version,
        [string] $preview,
        [string] $demands,
        [string] $instanceNameFormat,
        [string[]]$groups,
        [Input[]]$inputs, 
        [string] $execution
    ) {
        $this.Id = $id
        $this.Name = $Name
        $this.friendlyname = $friendlyname
        $this.description = $description
        $this.$helpMarkdown = $helpMarkdown
        $this.category = $category
        $this.visibility = $visibility
        $this.author = $author
        $this.version = $version
        $this.preview = $preview
        $this.demands = $demands
        $this.instanceNameFormat = $instanceNameFormat
        $this.groups = $groups
        $this.inputs = $inputs 
        $this.execution = $execution
    }
    #endregion
}

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
    defaultvalue = $null
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
    defaultvalue = $null
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
$Cmdlet.ParameterSets.Parameters | Where-Object { $_.Position -ne '-2147483648' }
$Cmdlet.Parameters
[PSCustomObject]@{
    Name         = $Cmdlet.Name
    label        = 'Creating (encoding) JSON Web Token'
    type         = 'string'
    defaultvalue = $null
    required     = $true
    helpMarkDown = 'Creating (encoding) JSON Web Token'
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
    defaultvalue = $null
    required     = $true
    helpMarkDown = 'Creating (encoding) JSON Web Token'
    groupName    = '__AllParameterSets'
    visibleRule  = $null
    properties   = $InputProperty
    options      = $null
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


