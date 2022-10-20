<#
    Title: Get Last User

    Purpose: 
        This script was built to process a list of hosts
        and output a report of the last known user based
        on a registry value for 'LastLoggedOnUser' and
        'LastLoggedOnDisplayname'

    Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>

$HostList = Read-Host'(Input Format) <SAMPLE-SOURCE-PATH>\Remote-Hosts.txt'
$Computers = Get-Content $HostList
$HostCount = 0


Function Get-LastUser {
    <#

    .SYNOPSIS
        This script gets the last known users on a host

    .DESCRIPTION
        This script references the remote hosts registry and returns
        results based upon the SID for the user and the Display Name
        that corresponds to their account in Active Directory.

    .NOTES
        This script will require the console calling it to be opened
        as an administrator, or to be called from a batch file that
        alters the PowerShell Execution Policy.
    
    #>

    Foreach ($Computer in $Computers){
        $HostCount += 1
        Write-Progress -Activity "Retrieving Last User" -Status "Host: $($Computer)" -PercentComplete ($HostCount * 100 / $Computers.count)
        $LastUser = (Invoke-Command -ComputerName $Computer -ScriptBlock {
            $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI'
            $RegValue = Get-ItemProperty -Path $RegPath
            $RegValue.LastLoggedOnUser
            $RegValue.LastLoggedOnDisplayName
        })
        $LastUser | Export-CSV -Path '<SAMPLE-OUTPUT-PATH>\User-Query.csv' -NoTypeInformation -Append
    }

}

# Call the function that was just created
Get-LastUser