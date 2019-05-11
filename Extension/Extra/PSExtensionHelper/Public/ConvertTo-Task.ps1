Function ConvertTo-Task {
    [CmdletBinding()]
    Param
    (
        # Name of PowerShell Module
        [Parameter(Mandatory = $true,
            Position = 0)]
        $Name,
        # Name of the ADO Task
        [Parameter(Mandatory = $true)]
        $TaskName,
        # Description of the ADO Task
        [Parameter(Mandatory = $true)]
        $Description,
        # Category of the ADO Task
        [Parameter(Mandatory = $true)]
        $Category,
        # Visibility of the ADO Task
        [Parameter(Mandatory = $true)]
        $Visibility,
        # Author of the ADO Task
        [Parameter(Mandatory = $true)]
        $Author,
        # Version of the ADO Task
        [Parameter(Mandatory = $true)]
        $Version,
        # Preview of the ADO Task
        [Parameter(Mandatory = $true)]
        $Preview,
        # InstanceNameFormat of the ADO Task
        [Parameter(Mandatory = $true)]
        $InstanceNameFormat    
    )

    #region retrieve Module info
    if (!(Get-Module -Name $Name)) {
        Import-Module -Name $Name
        $script:ModuleInfo = Get-Module -Name $Name
    }
    #endregion

    #region Create new Task Objects
    $Script:Task = New-ExtensionTask
    #endregion

    #region Create Group Ojects
    $Script:Groups = New-TaskGroup
    #endregion

    #region Create Input Objects
    $Task.Inputs = New-TaskInput -Name $Name

    #region output Task.json
    $Task | ConvertTo-Json -Depth 10
    #endregion

}