<#
	Title: Set Variables

	Purpose: 
		This module was created to import the function to preset the 
        required variables for running the Cyber Awareness Update 
        module.

	Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>



Function Set-Variables {
    <#
        .SYNOPSIS
            This function is used to pre-stage required variables for use in other modules.

        .DESCRIPTION
            To process the report there are several variables that are required to be 
            pre-staged. By preparing these variables within this module it will help 
            to save time and allow them to be used multiple times.

        .EXAMPLE
            Set-Variables

        .NOTES
            Current variables defined:
                $DisableUsers
                $Cushion
                $VerboseOutput
                $TargetOU
                $MandatoryFields
                $Today
                $TooOld
                $RecordCount
                $CheckedUsers
                $AllUsers
                $AllData
                $UncheckedUsers
    #>
    $DisableUsers = $true
    $Cushion = 1
    $VerboseOutput = $false
    $TargetOU = "OU=Users,DC=Sample,DC=com"
    $MandatoryFields = @("Name","Enterprise Email Address","Date Awareness Training Completed","Date Most Recent Army IT UA Doc Signed","EDIPI")
    $Today = (Get-Date).ToString("yyyyMMdd")
    $TooOld = (Get-Date).AddDays( (-365 - $Cushion ) )
    $RecordCount = 0
    $CheckedUsers = @()
    $AllData = @()
    $AllUsers = Get-ADUser -SearchBase $TargetOU -SearchScope Subtree -LDAPFilter "(Name=*)" -Properties Description,"SAMPLE-ATTRIBUTE",mail,sAMAccountName
    [System.Collections.ArrayList]$UncheckedUsers = $AllUsers | ForEach-Object DistinguishedName

}


# Setting aliases to be used in shorthand format
Set-Alias set-prev Set-Variables



# Exporting the functions as Module Members with their aliases
Export-ModuleMember -Function Set-Variables -Alias set-prev