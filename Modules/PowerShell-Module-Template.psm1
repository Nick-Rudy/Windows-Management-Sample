<#
	Title: PowerShell Module Template

	Purpose: 
		This module was created to set as a template to build
		future PowerShell Modules

	Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>

Function Get-Sample {
    <#
        .SYNOPSIS
            Brief synopsis of the function.

        .DESCRIPTION
            Description of the function and it's purpose

        .PARAMETER Example1
            Explanation of a parameter to be used with module (Must be defined in function)

        .EXAMPLE
            Place to display an example of how to execute function

            Example:

                "Sample-Test"

        .NOTES
            Place to input notes on changes/updates/requirements
    #>
    Write-Output 'Input the function text to run #Sample-Test'

}

Set-Alias get-samp Get-Sample # Stage any aliases or shorthand for the function command

Export-ModuleMember -Function Get-Sample -Alias get-samp # Export the defined function to be used when module is imported