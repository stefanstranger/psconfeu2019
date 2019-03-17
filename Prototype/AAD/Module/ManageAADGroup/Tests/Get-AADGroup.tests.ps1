<#
    Pester Unit Tests for Function Get-AadGroup
#>

#region Load ManageAadGroups Module
$ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path)
Write-Verbose -Message ('ModulePath {0}' -f $ModulePath)
$ModuleName = 'ManageAadGroup'
$ManifestPath = "$ModulePath\$ModuleName.psd1"
Write-Verbose -Message ('ManifestPath {0}' -f $ManifestPath)

if (Get-Module -Name $ModuleName) {
    Remove-Module $ModuleName -Force
}
Import-Module $ManifestPath -Verbose:$false
#endregion

#region enable verbose
$VerbosePreference = 'Continue' #Disable when publised
#endregion

#region Test Function Get-AzureAadGroup
Describe -Name 'Test Get-AzureAadGroup Function' -Fixture {
    It -name 'Passes the Get-AzureAadGroup Function' -test {

        # Mock Invoke-RestMethod for retrieving token
        Mock Invoke-RestMethod {return @{'access_token' = '1234567'}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0} for Get-AccessToken' -f $uri); 'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $Uri } -ModuleName ManageAadGroup -Verifiable
            
        # Mock Azure Function ManageAadGroup Response
        Mock Invoke-RestMethod {return @{'value' = @{'DisplayName' = 'PesterDemo'}}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0} for Get-AADGroup' -f $uri); 'https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,''PesterDemo'')' -eq $Uri} -Module ManageAadGroup -Verifiable
               
        #Parameters
        $params = @{
            'DisplayName'  = 'PesterDemo'
            'ClientId'     = '12345'
            'ClientSecret' = '12345'
            'TenantId'     = '12345'      
        }

        $Result = Get-AadGroup @params
        Write-Verbose -Message ('Result DisplayName: {0}' -f $Result.DisplayName)
        $Result.DisplayName | Should Be 'PesterDemo'

        # Test if Mock is being called
        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It

        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,''PesterDemo'')' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It
    }
}


#region Test Web Exceptions
Describe -Name 'Test Get-AzureAadGroup Function Exceptions' -fixture {

    It -name 'Should fail when Group is not found' -test {

        # Mock Invoke-RestMethod for retrieving token
        Mock Invoke-RestMethod {return @{'access_token' = '1234567'}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0} for token' -f $uri); 'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri } -ModuleName ManageAadGroup -Verifiable
            
        # Mock Invoke-RestMethod for not existing Group.
        Mock Invoke-RestMethod {     
            $Exception = [System.Management.Automation.RuntimeException]::new()
            $Response = [PSCustomObject]@{ 
                Message = 'Error Message AAD Group PesterDemo not found'
            }
            $Exception | Add-Member -Name Response  -MemberType NoteProperty -Value $Response -Force
            Throw $Exception
        } -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0}' -f $uri); 'https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,''PesterDemo'')' -eq $Uri} -Module ManageAadGroup -Verifiable 
    
        #Parameters
        $params = @{
            'DisplayName'  = 'PesterDemo'
            'ClientId'     = '12345'
            'ClientSecret' = '12345'
            'TenantId'     = '12345'      
        }
        {Get-AadGroup @params} | Should Throw

        # Test if Mock is being called
        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It

        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,''PesterDemo'')' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It
    }
}
#endregion


