#https://github.com/Microsoft/azure-pipelines-task-lib/blob/master/tasks.schema.json

Enum inputtypes {
    string
    picklist
    boolean
    radio
}

#region InputProperties Class
Class InputProperties {
    [bool] $EditableOptions

    InputProperties(
        [bool] $EditableOptions
    ) {
        $this.EditableOptions = @{'EditableOptions' = $EditableOptions }
    }
}
#endregion

#region Input Class
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
#endregion

#region ExtensionTask Class
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
#endregion

#region New Input Property Function
Function New-InputPropertyObject {
    [CmdletBInding()]
    Param(
        [Parameter(Mandatory = $true)]
        [boolean]$Exist
    )

    return [InputProperties]::new($false)
}
#endregion

#region New Input Object Function
Function New-InputObject {
    [CmdletBInding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$name,
        [Parameter(Mandatory = $true)]
        [string]$aliases,
        [Parameter(Mandatory = $true)]
        [string]$label,
        [Parameter(Mandatory = $true)]
        [string]$type,
        [Parameter(Mandatory = $false)]
        [string]$defaultvalue,
        [Parameter(Mandatory = $true)]
        [boolean]$required,
        [Parameter(Mandatory = $false)]
        [string]$helpMarkDown,
        [Parameter(Mandatory = $true)]
        [string]$groupname,
        [Parameter(Mandatory = $true)]
        [boolean]$visibleRule,
        [Parameter(Mandatory = $true)]
        [InputProperties]$properties,
        [Parameter(Mandatory = $false)]
        [string]$options
    )

    return [Input]@{
        name         = $name
        aliases      = $aliases
        label        = $label
        type         = $type
        defaultvalue = $defaultvalue
        required     = $required
        helpMarkDown = $helpMarkDown
        groupName    = $groupname
        visibleRule  = $visibleRule
        properties   = $properties
        options      = $options
    }
}
#endregion