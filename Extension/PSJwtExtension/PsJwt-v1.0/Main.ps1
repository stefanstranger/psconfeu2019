Trace-VstsEnteringInvocation $MyInvocation
Import-VstsLocStrings "$PSScriptRoot\Task.json"

Write-Verbose -Message ('Start JWT Demo Extension')

#region Get inputs.
$Action = Get-VstsInput -Name Action -Require
#endregion

#region Import PSJwt PowerShell Module
Write-Verbose -Message ('Importing PSJwt PowerShell Module')
Import-Module $PSScriptRoot\ps_modules\PSJwt\1.0.0\\PSJwt.psd1
#endregion

#region Execute selected Action
switch ($action) {
    "convertfrom" {
        Write-Verbose "Get JSON Web Token"
        $Token = Get-VstsInput -Name Token -Require

        #region Verbose Output for input fields
        Write-Verbose -Message ('Input fields are:')
        Write-Verbose -Message ('Action: {0}' -f $Action)
        Write-Verbose -Message ('Token:  {0}' -f $Token)
        #endregion

        Write-Host "Decode JSON Web Token"
        ConvertFrom-JWT -Token $Token       
    }
    "convertto" {
        Write-Verbose "Get PayLoad and Secret"
        $PayLoad = Get-VstsInput -Name Payload -Require
        $Secret = Get-VstsInput -Name Secret -Require

        #region Verbose Output for input fields
        Write-Verbose -Message ('Input fields are:')
        Write-Verbose -Message ('Action: {0}' -f $Action)
        Write-Verbose -Message ('PayLoad: {0}' -f $Payload)
        Write-Verbose -Message ('Secret: {0}' -f $Secret)
        #endregion

        #region Function to convert JSON to HashTable
        #From https://4sysops.com/archives/convert-json-to-a-powershell-hash-table/
        function ConvertTo-Hashtable {
            [CmdletBinding()]
            [OutputType('hashtable')]
            param (
                [Parameter(ValueFromPipeline)]
                $InputObject
            )
        
            process {
                ## Return null if the input is null. This can happen when calling the function
                ## recursively and a property is null
                if ($null -eq $InputObject) {
                    return $null
                }
        
                ## Check if the input is an array or collection. If so, we also need to convert
                ## those types into hash tables as well. This function will convert all child
                ## objects into hash tables (if applicable)
                if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
                    $collection = @(
                        foreach ($object in $InputObject) {
                            ConvertTo-Hashtable -InputObject $object
                        }
                    )
        
                    ## Return the array but don't enumerate it because the object may be pretty complex
                    Write-Output -NoEnumerate $collection
                }
                elseif ($InputObject -is [psobject]) {
                    ## If the object has properties that need enumeration
                    ## Convert it to its own hash table and return it
                    $hash = @{ }
                    foreach ($property in $InputObject.PSObject.Properties) {
                        $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
                    }
                    $hash
                }
                else {
                    ## If the object isn't an array, collection, or other object, it's already a hash table
                    ## So just return it.
                    $InputObject
                }
            }
        }

        $HashTablePayload = $PayLoad | ConvertFrom-Json | ConvertTo-HashTable
        #endregion        

        Write-Host "Encode JSON Web Token"
        ConvertTo-JWT -PayLoad $HashTablePayload -Secret $Secret         
    }
    default {
        throw 'Unknow action'
    }
}