<#
    Title: Get Progress

    Purpose: 
        This module was created to import the Get-Progress function to
        provide an overall progress bar for the current action.

    Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>

Function Get-Progress {
    <#
        .SYNOPSIS
            This function is used to display the current progress.

        .DESCRIPTION
            This function will use the pre-staged $RecordCount variable to calculate the current progress
            of the script and display that value as a progress bar at the top of the window.

        .EXAMPLE
            Get-Progress

        .NOTES
            Equation:
                
                $Counted = $AllData.count
                $Increment = 100 / $Counted
                $RecordCount + $Increment = $PercComp
                For (x in y) {
                    Write-Progress -Activity "What you're doing" -Status "Current: " -PercentComplete ($PercComp / $Counted) 
                }

            As records are processed the $RecordCount will increase by a value stored 
            within the $Increment variable. The $Increment is calculated by taking a 
            total of 100 for the complete percentage and dividing it by the $Counted
            variable. The $Counted variable uses the '.count' attribute for $AllData.
            The combination of $RecordCount and $Increment will be used in a statement
            'write-progress' within the -PercentComplete parameter to show completion
            progress.
    #>
    
    $Counted = $AllData.count 
    $Increment = 100 / $Counted
    Write-Progress -Activity "Updating Active Directory" -Status "Locating: $($UserEmail)" -PercentComplete ($PercComp / $Counted)

}

# Setting aliases to be used in shorthand format
Set-Alias get-pr Get-Progress

# Exporting the functions as Module Members with their aliases
Export-ModuleMember -Function Get-Progress -Alias get-pr