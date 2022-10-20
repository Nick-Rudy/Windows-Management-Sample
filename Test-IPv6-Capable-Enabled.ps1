<#
    Title: Test_IPv6_Capable-Enabled.ps1
   
    Purpose:
       Test remote computer for IPv6 capability/Enabled.
		
    Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>



$TargetOU = "<SAMPLE-OU-PATH>"
$RecordCount = 0

$ADPull = Get-ADComputer -SearchBase $TargetOU -SearchScope Subtree -Filter * -Properties Name | Select @{Name="ComputerName";Expression={$_."Name"}}
[System.Collections.ArrayList]$UncheckedHosts = $ADPull | ForEach-Object Name
$CheckedHosts = @()
ForEach ($Computer in $ADPull) {
    $CheckedHosts += $Computer
    $UncheckedHosts.remove($Computer)
    Write-Progress -Activity "Checking Network Adapter" -Status "Host: $($Computer.Name)" -PercentComplete ($RecordCount * 100 / $ADPull)
    $IPv4Stat = Invoke-Command -ComputerName $Computer -ScriptBlock {Get-NetAdapterBinding -Name * -ComponentID ms_tcpip4 | Select Name,DisplayName,ComponentID,Enabled | Format-Table Name} | Out-File "<SAMPLE-OUTPUT-PATH>\IPv4Status.csv" -Append
    $IPv6Stat = Invoke-Command -ComputerName $Computer -ScriptBlock {Get-NetAdapterBinding -Name * -ComponentID ms_tcpip6 | Select Name,DisplayName,ComponentID,Enabled | Format-Table Name} | Out-File "<SAMPLE-OUTPUT-PATH>\IPv6Status.csv" -Append
    Write-Host $Computer.Name 
    Write-Host $IPv4Stat
    Write-Host $IPv6Stat
}