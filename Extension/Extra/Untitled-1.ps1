$ParameterSets = (Get-Command convertto-jwt).ParameterSets 

foreach ($ParameterSet in $ParameterSets) {
    #iterate all Parameters
    $MyParameterSet =@()
    foreach ($Parameter in $ParameterSet) {
        $MyParams = $Parameter.Parameters | Where-Object { $_.Position -ne '-2147483648' }
    }
    #Create new Object
    $MyParameterSet += [PSCustomObject]@{
        Name             = $MyParams.Name
        ParameterSetName = $ParameterSet.Name    
    }
    $MyParameterSet
}
    

<#

        if ($Parameter.position -ne '-2147483648') {
            [PSCustomObject]@{
                Name             = $Parameter.Parameters.Name
                ParameterSetName = $Parameter.Name    
            }
        }
        #>