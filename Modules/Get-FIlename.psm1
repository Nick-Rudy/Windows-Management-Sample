<#
	Title: Get Filename

	Purpose: 
		This module was created to import the Get-Filename function to
        provide a GUI interface to select a source file based on file
        type.

	Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>

Function Get-FileName($InitialDirectory) {
    <#
        .SYNOPSIS
            This function is used to populate a GUI to select a csv file that was exported from ATCTS.

        .DESCRIPTION
            This function uses the system assembly to call on the Windows Open File Dialog box to give
            the user the ability to navigate through directories and select the appropriate csv file to
            be imported in for comparison.

        .EXAMPLE
            $SourceFile1 = Get-FileName "C:\<FOLDER_NAME>"

            Using this will store the file name in the variable $SourceFile1
    #>
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.Filter = "CSV (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName

}

# Setting aliases to be used in shorthand format
Set-Alias get-fn Get-FileName


# Exporting the functions as Module Members with their aliases
Export-ModuleMember -Function Get-FileName -Alias get-fn