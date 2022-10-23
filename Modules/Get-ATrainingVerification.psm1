<#
    Title: ATCTS Awareness Training Verification Module

    Purpose: 
        This module was created to check against ATCTS reports and generate
        a report of all ATCTS profiles that have Awareness Training that is
        unverified.

    Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>

Function Get-ATrainingVerification {
    <#
        .SYNOPSIS
            This function checks for ATCTS profile verfication.

        .DESCRIPTION
            This function references an exported CSV report from ATCTS to
            check the 'Awareness Training Verified' column for any profiles 
            showing as unverified with a value of 'No'

        .EXAMPLE

            Get-ATrainingVerification $Source1

        .EXAMPLE

            Get-ATV $Source1

        .NOTES
            This function references the $Source1 Variable that is set during the 
            'Cyber-Update-Script.ps1'. The output is stored as a CSV report will 
            be titled using the (Date)-Unverified-ATCTS-Awareness-Training.csv

    #>

    # Set the output directory for the CSV file
    $ATrainUnVerif = "<SAMPLE-OUTPUT-PATH>$($Today)-Unverified-ATCTS-Awareness-Training.csv" 
    
    Write-Host -ForeGroundColor Magenta "Checking Source File: "
    Write-Host -ForeGroundColor DarkCyan "Filtering for unverified awareness training"

    # Call for the content of the $Source1 file that was used in the 'Cyber-Update-Script.ps1' and filter for 'No' value
    $UnATrain1 = Get-Content -Path $Source1 | ConvertFrom-CSV | Where-Object {$_."Awareness Training Verified" -eq "No"}
    
    Write-Host -ForeGroundColor DarkCyan "Generating Report"

    # Remove each unverified profile from the $UncheckedUsers array
    ForEach ($UserA in $UnATrain1) {
        $UncheckedUsers = $UncheckedUsers - $UserA
    }

    # Export the CSV report selecting all of the headers
    $UnATrain1 | Select-Object -Property 'Name','EDIPI','Enterprise Email Address','Date Awareness Training Completed','Awareness Training Verified','Date Most Recent Army IT UA Doc Signed','Profile Verified' | Export-CSV -Path 

    Write-Host -ForeGroundColor Green "Report Generated: "
    Write-Host -ForeGroundColor Green "Check Results Folder for Findings"

}

Set-Alias get-atv Get-ATrainingVerification

Export-ModuleMember -Function Get-ATrainingVerification -Alias get-atv