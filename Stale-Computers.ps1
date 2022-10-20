<#
    Title: Stale Computers

    Purpose:
        This script is designed to check Active Directory attributes 
        for hosts with a 'lastLogonDate' attribute that is over 90 - 120
        days old. 

    Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/

    .SYNOPSIS
        Get stale computers from AD and output reports to disable/delete

    .DESCRIPTION
        This script is designed to query Active Directory for Computer objects
        within a specified OU. The 'lastLogonDate' attribute will be used 
        to track those over 90 days in the 'Disable' report and those over
        120 days in the 'Delete' report. 

        For the hosts that are disabled it will append their description 
        to state that it was disabled for inactivity. 

    .NOTES
        The intent is to stage this script as a scheduled task on a server 
        to run daily and ensure that stale hosts are removed, and tracked.

        Need to-do:
            Add line to automate follow up for auto-disable/delete


#>

$DisableDays = (Get-Date).AddDays(-90) 
$RemoveDays = (Get-Date).AddDays(-120) 

## Export a csv with dynamic file name for each generation. EX: 20200605-10:44--AD_Computer_Removal_WHAT-IF.csv
$filename = Get-Date -Format "yyyyMMdd-HH:mm"
$Export = "<SAMPLE-OUTPUT-PATH>\AD_Computer_Removal_WHAT-IF__$(Get-Date -Format 'yyyyMMdd-HHmm').csv"

## Disable computers After 90 Days of inactivity
$computers_90day = Get-ADComputer -Property Name,lastLogonDate,Description -Filter {lastLogonDate -lt $DisableDays -and Enabled -eq $True} -SearchBase "<SAMPLE-OU-PATH>" | Set-ADComputer -enabled $false -Description "Disabled for inactivity ( $(Get-Date -format yyyyMMdd) )$($_.Description)" 
 
## Find inactive Computers older than 120 days
$computers_older = Get-ADComputer -Property Name,lastLogonDate -Filter {Name -like "<SAMPLE-FILTER-VALUE>" -and lastLogonDate -lt $RemoveDays -and Enabled -eq $false} -SearchBase "<SAMPLE-OU-PATH>"

## Export the computers to a csv file to easily view the results
$computers_older | Export-csv -path $Export -Append