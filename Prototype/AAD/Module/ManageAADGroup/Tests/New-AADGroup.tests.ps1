<#
    Pester Unit Tests for Function New-AadGroup
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


#region Test Function New-AzureAadGroup
Describe -Name 'Test New-AzureAadGroup Function' -Fixture {
    It -name 'Passes the New-AzureAadGroup Function' -test {

        # Mock Invoke-RestMethod for retrieving token
        Mock Invoke-RestMethod {return @{'access_token' = '1234567'}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0} for token' -f $uri); 'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri } -ModuleName ManageAadGroup -Verifiable
            
        # Mock Azure Function ManageAadGroup Response
        Mock Invoke-RestMethod {return @{'DisplayName' = 'PesterDemo'; 'Description' = 'Pester Demo Group'; 'MailNickName' = 'PesterDemo'}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0}' -f $uri); 'https://graph.microsoft.com/v1.0/groups' -eq $Uri} -Module ManageAadGroup -Verifiable
               
        #Parameters
        $params = @{
            'DisplayName'   = 'PesterDemo'
            'Description'   = 'Pester Demo Group'
            'MailNickName'  = 'PesterDemo'
            'OwnerObjectId' = '12345'
            'ClientId'      = '12345'
            'ClientSecret'  = '12345'
            'TenantId'      = '12345'
      
        }
        $Result = New-AadGroup @params
        Write-Verbose -Message ('Result DisplayName: {0}' -f $Result.DisplayName)
        $Result.DisplayName | Should Be 'PesterDemo'

        # Test if Mock is being called
        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It

        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://graph.microsoft.com/v1.0/groups' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It
    }
}
#endregion

#region Test Web Exceptions
Describe -Name 'Test New-AzureAadGroup Function Exceptions' -fixture {

    It -name 'Should fail for Group already exists (ObjectConflict)' -test {

        # Mock Invoke-RestMethod for retrieving token
        Mock Invoke-RestMethod {return @{'access_token' = '1234567'}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0} for token' -f $uri); 'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri } -ModuleName ManageAadGroup -Verifiable
            
        # Mock Invoke-RestMethod for Group already exists.
        Mock Invoke-RestMethod {     
            $Exception = [System.Management.Automation.RuntimeException]::new()
            $Response = [PSCustomObject]@{ 
                Code    = 'Request_BadRequest'
                Message = 'Another object with the same value for property mailNickname already exists'
            }
            $Exception | Add-Member -Name Response  -MemberType NoteProperty -Value $Response -Force
            Throw $Exception
        } -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0}' -f $uri); 'https://graph.microsoft.com/v1.0/groups' -eq $Uri} -Module ManageAadGroup -Verifiable 
    
        #Parameters
        $params = @{
            'DisplayName'   = 'PesterDemo'
            'Description'   = 'Pester Demo Group'
            'MailNickName'  = 'PesterDemo'
            'OwnerObjectId' = '12345'
            'ClientId'      = '12345'
            'ClientSecret'  = '12345'
            'TenantId'      = '12345'
      
        }
        {New-AadGroup @params} | Should Throw

        # Test if Mock is being called
        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It

        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://graph.microsoft.com/v1.0/groups' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It
    }

    It -name 'Should fail for not existing Owner (Request_ResourceNotFound)' -test {

        # Mock Invoke-RestMethod for retrieving token
        Mock Invoke-RestMethod {return @{'access_token' = '1234567'}} -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0} for token' -f $uri); 'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri } -ModuleName ManageAadGroup -Verifiable
            
        # Mock Invoke-RestMethod for Group already exists.
        Mock Invoke-RestMethod {     
            $Exception = [System.Management.Automation.RuntimeException]::new()
            $Response = [PSCustomObject]@{ 
                Code    = 'Request_ResourceNotFound'
                Message = "Resource '1234456' does not exist or one of its queried reference-property objects are not present"
            }
            $Exception | Add-Member -Name Response  -MemberType NoteProperty -Value $Response -Force
            Throw $Exception
        } -ParameterFilter {Write-Verbose ('Mock Invoke-RestMethod Uri filter {0}' -f $uri); 'https://graph.microsoft.com/v1.0/groups' -eq $Uri} -Module ManageAadGroup -Verifiable 
    
        #Parameters
        $params = @{
            'DisplayName'   = 'PesterDemo'
            'Description'   = 'Pester Demo Group'
            'MailNickName'  = 'PesterDemo'
            'OwnerObjectId' = '12345'
            'ClientId'      = '12345'
            'ClientSecret'  = '12345'
            'TenantId'      = '12345'
      
        }
        {New-AadGroup @params} | Should Throw

        # Test if Mock is being called
        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://login.microsoftonline.com/12345/oauth2/v2.0/token' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It

        Assert-MockCalled Invoke-RestMethod -ParameterFilter {'https://graph.microsoft.com/v1.0/groups' -eq $uri} -ModuleName ManageAadGroup -Exactly 1 -Scope It
    }
}
#endregion