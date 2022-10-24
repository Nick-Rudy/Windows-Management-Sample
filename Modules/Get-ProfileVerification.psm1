<#
	Title: ATCTS Profile Verification Module

	Purpose: 
		This module was created to check against ATCTS reports and generate
		a report of all ATCTS profiles that are currently unverified.

	Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>

Function Get-ProfileVerification {
	<#
		.SYNOPSIS
			This function checks for ATCTS profile verification.

		.DESCRIPTION
			This function references an exported CSV report from ATCTS to
			check the 'Profile Verified' column for any profiles showing
			as unverified with a value of 'No'

		.EXAMPLE

			Get-ProfileVerification $Source1

		.EXAMPLE

			Get-PVF $Source1

		.NOTES
			This function references the $Source1 Variable that is set during the 
			'Cyber-Update-Script.ps1'. The output is a CSV report will be titled 
			using the (Date)-Unverified-ATCTS-Profiles.csv

	#>

	# Set the output directory for the CSV file
	$ProfUnVerif = "<SAMPLE-OUTPUT-PATH>$($Today)-Unverified-ATCTS-Profiles.csv" 
	
	Write-Host -ForeGroundColor Magenta "Checking Source File: "
	Write-Host -ForeGroundColor DarkCyan "Filtering for unverified profiles"

	# Call for the content of the $Source1 file that was used in the 'Cyber-Update-Script.ps1' and filter for 'No' value
	$UnProfile1 = Get-Content -Path $Source1 | ConvertFrom-CSV | Where-Object {$_."Profile Verified" -eq "No"}
	
	Write-Host -ForeGroundColor DarkCyan "Generating Report"

	# Remove each unverified profile from the $UncheckedUsers array
	ForEach ($User in $UnProfile1) {
		$UncheckedUsers = $UncheckedUsers - $User
	}

	# Export the CSV report selecting all of the headers
	$UnProfile1 | Select-Object -Property 'Name','EDIPI','Enterprise Email Address','Date Awareness Training Completed','Awareness Training Verified','Date Most Recent Army IT UA Doc Signed','Profile Verified' | Export-CSV -Path 

	Write-Host -ForeGroundColor Green "Report Generated: "
	Write-Host -ForeGroundColor Green "Check Results Folder for Findings"

}

Set-Alias get-pv Get-ProfileVerification

Export-ModuleMember -Function Get-ProfileVerification -Alias get-pv