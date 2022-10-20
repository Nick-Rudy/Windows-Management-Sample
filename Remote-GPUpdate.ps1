#Requires -modules activedirectory
#Requires -version 5.1
#Requires -runasadministrator

<#
    Title: Remote_GP_Update.ps1
   
    Purpose:
       To call a list of host IP addresses and remotely run a Group Policy Udate on them.

    Author: Nick Rudy
    License: https://nick-rudy.mit-license.org/
#>


# Set variable for record count to list as part of the progress bar
$RecordCount = 0

# Set variable for todays date to a string for file naming
$Today = (Get-Date).ToString("yyyyMMdd")




# Create function to prompt for the text file containing the IP addresses
Function Get-FileName($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "TXT (*.txt)| *.txt"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename 
}

# Notify host shell window to prompt user to select the host text file
Write-Host -ForeGroundColor Green "Locating Host IP List"

# Set variable to call for the host text file in a dialog box
$SourceFile = Get-FileName "<SOURCE_FILE_DIRECTORY>"

# Create a ForEach loop to cycle through the list of IP addresses and send the remote GPUpdate command
ForEach($H in $SourceFile){
    # With each pass increase the count by 1
    $RecordCount += 1
    # Present Progress bar at the top of the console to show status
    Write-Progress -Activity "Contacting Hosts" -Status "Sending GPUpdate command to $H" -PercentComplete ($RecordCount * 100 / $SourceFile.count)
    Try{
        # Set variable for invocation and definition of scriptblock to be ran on each host
        $GPup = Invoke-Command -ComputerName $H -ScriptBlock { GPUpdate /Force }
        }
    Catch{
        # Set value for failure statement and then continue
        $GPup = "Couldn't connect to host $($). WinRM service may be off"
        Continue
    }
    # Write result in console with each iteration
    Write-Host $GPup
}

# Output the results of the GPUpdate command to a CSV file for review
$GPup | Out-File "<REPORT_FILE_DIRECTORY>$($Today).csv" -NoTypeInformation -Append