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
        Write-Verbose -Message ('Import PowerShell Module {0}' -f $Name)
        Import-Module -Name $Name
        $ModuleInfo = Get-Module -Name $Name
    }
    #endregion

    #region Create new Task Objects
    $Task = New-ExtensionTask
    #endregion

    #region Create Group Ojects
    $Task.Groups = New-TaskGroup
    #endregion

    #region Create Input Objects
    $Task.Inputs = New-TaskInput -Name $Name

    #region output Task.json
    $Task | ConvertTo-Json -Depth 10
    #endregion

    #region validate Task Json with schema
    $Schema = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/azure-pipelines-task-lib/master/tasks.schema.json').Content
    Test-Json -Json ( $Task | ConvertTo-Json -Depth 3 | out-string) -Schema $Schema -ErrorVariable jsontest -ErrorAction SilentlyContinue
    ($jsontest.errordetails)
    #endregion
}