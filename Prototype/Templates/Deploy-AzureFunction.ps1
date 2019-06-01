<#
    This script will deploy the Azure Function in an Azure Resource Group
    Make sure you have already logged in.
#>

#region variables
$SubscriptionName = 'Visual Studio Enterprise'
$ResourceGroupName = 'psconfeu2019-rg'
$Location = 'westeurope'
$ARMTemplateFile = 'C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Templates\azuredeploy.json'
$ARMTemplateParameterFile = 'C:\Users\stefstr\Documents\GitHub\psconfeu2019\Prototype\Templates\azuredeploy.parameters.json'
#endregion

#region Login
Get-AzContext
Disconnect-AzAccount
Add-Azaccount -Subscription $SubscriptionName
#endregion

#region Resource Group
if (!(Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location
}
else {
    Write-Output -InputObject ('Resource Group: {0} already exists' -f $ResourceGroupName)
}
#endregion

#region deploy Azure Function. Added whatif to prevent time loss.
New-AzResourceGroupDeployment -Name 'psconfeu2019' -ResourceGroupName $ResourceGroupName -TemplateFile $ARMTemplateFile -TemplateParameterFile $ARMTemplateParameterFile -Mode Incremental -WhatIf
#endregion