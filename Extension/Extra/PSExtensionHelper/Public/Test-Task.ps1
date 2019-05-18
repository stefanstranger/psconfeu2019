Function Test-Task {
    [CmdletBinding()]
    Param
    (# Path of Task.json file
        [Parameter(Mandatory = $true,
            Position = 0)]
        $Path)
    
    #region Get latest task schema
    $Schema = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/azure-pipelines-task-lib/master/tasks.schema.json').Content
    #endregion
        
    #region validate task    
    Test-Json -Json (Get-Content -path $Path -raw) -Schema $Schema -ErrorVariable jsontest -ErrorAction SilentlyContinue
    ($jsontest.errordetails)
    #endregion
}