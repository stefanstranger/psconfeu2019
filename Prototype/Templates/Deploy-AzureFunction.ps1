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
#endregion

#region deploy Azure Function
New-AzResourceGroupDeployment -Name 'psconfeu2019' -ResourceGroupName $ResourceGroupName -TemplateFile $ARMTemplateFile -TemplateParameterFile $ARMTemplateParameterFile -Mode Incremental
#endregion