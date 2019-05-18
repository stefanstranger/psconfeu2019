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
        $InstanceNameFormat,
        # OutFile (output file path for task.json)
        [Parameter(Mandatory = $true)]
        $OutFile,
        # OutFile (output file path for task.json)
        [Parameter(Mandatory = $false)]
        [Switch]$Validate  
    )

    #region retrieve Module info
    if (!(Get-Module -Name $Name)) {
        Write-Verbose -Message ('Import PowerShell Module {0}' -f $Name)
        Import-Module -Name $Name        
    }
    $Script:Module = Get-Module -Name $Name
    #endregion

    #region Create new Task Objects
    $Task = New-ExtensionTask
    #endregion

    #region Configure Task Properties FriendlyName, Description and MarkdownHelp
    $Task.FriendlyName = ('{0} PowerShell Module for Azure DevOps Extension' -f $Module.Name)
    $Task.helpMarkdown = $($Module.Description)
    #endregion

    #region Create Group Ojects
    $Script:Groups = New-TaskGroup -Module $Module
    $Task.Groups = $Groups
    #endregion

    #region Create Input Objects
    $Task.Inputs = New-TaskInput -Name $Name -Module $Module

    #region output Task.json
    $Task | ConvertTo-Json -Dept 3 | Out-File $OutFile -Force
    #endregion

    #region validate Task Json with schema
    if ($Validate) {
        Test-Task -Path $OutFile
    }
    #endregion

    #region clean up
    Remove-Variable -Name Groups -Force
    Remove-Variable -Name Module -Force
    #endregion
}