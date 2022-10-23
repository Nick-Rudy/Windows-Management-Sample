[![HitCount](https://hits.dwyl.com/Nick-Rudy/Windows-Management-Sample.svg?style=flat-square&show=unique)](http://hits.dwyl.com/Nick-Rudy/Windows-Management-Sample)

# Windows-Management-Sample :technologist:
	

This repository is a sample of some basic Windows Administrative PowerShell tools that I have developed during my time as an Information Systems Security Officer. 


## Scripts


The scripts provided vary between remote queries on individual hosts as well as some functionality to reference a source file for larger lists of hostnames. 


### Get Last User

There are multiple ways to determine the last user of a host. However, during my tenure I have had to parse large lists of hostnames that were found during a Nessus scan :mag:. I usually just export the csv report and copy the column into a text file with one host on each line to keep it simple. 


The [Get-LastUser](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Get-LastUser.ps1) script is designed to prompt the user to input the file path of the text file directly into the shell window.


```PowerShell
Read-Host '(Input Format) <SAMPLE-SOURCE-PATH>\Remote-Hosts.txt'
```


It also includes a progress bar using the ```Write-Progress``` statement to show progression and list the current host it is working on. Using the 'LogonUI' registry path it checks for specific values and returns them to a variable on the originating host to be exported to a CSV file.


After the function is built it calls for it to execute and starts the process to query each host on the list. 

### Remote GPUpdate

With so many tools :mechanic: it can get a little confusing on which one fits best for the job. While conducting Nessus scans I was required to maintain less than 5 percent failed credential scans. The largest source of that issue for me was hosts that missed the Group Policy update that updated the credentials for the scan. 


The [Remote-GPUpdate](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Remote-GPUpdate.ps1) script allowed me to cycle through all of the hosts with failed credentials to enumerate which ones would require hands on coordination with the user. 


This script takes a different approach in the selection of the source file to pull from. Using the `System.Reflection.Assembly` I built a function to populate a Windows file dialog box that allows the user to search through their directories using a GUI to select. 


Now with the source file identified I just needed to create a conditional loop to cycle through each host and execute the necessary command.


```PowerShell
$GPup = Invoke-Command -ComputerName $H -ScriptBlock { GPUpdate /Force }
```


To ensure that the loop didn't get caught up on a single host and exit I used a `Try` `Catch` statement with the `Continue` command to tell it to essentially write it down and keep going. 


### Stale Computers


In larger enterprise environments it is easy to lose track of which hosts are still current and online. With my environment we were required to ensure that any host or user that had not communicated with the Domain Controller in 90 days was disabled, and for those over 120 days the objects were to be deleted from the domain. 


When the scope of devices is several thousand end points it is required to have some sort of automated method to verify this criterion. The [Stale-Computers](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Stale-Computers.ps1) script was created to serve as a scheduled task on a secluded server. This was set to run daily and output a 'what if' report to track the hosts that would have been disabled/deleted.


It was then up to someone to parse this list regularly to ensure that no critical components were included, and then to execute a script manually to set all of the computer object `enabled` attributes to `$false`. 


### Test IPv6 Enabled


When certain industry standards are changed and it comes time for the lifecycle review I was regularly tasked to determine which hosts did not meet the new requirements. The [Test IPv6 Enabled](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Test-IPv6-Capable-Enabled.ps1) script allowed me to quickly inspect all of the domain hosts with the `Get-NetAdapterBinding` command and track which ones currently had their IPv6 capability enabled. 


During one incident this actually helped me to quickly enumerate all of the hosts and alter the setting when a Network Engineer accidentally changed the local DHCP server to prioritize issuing IPv6 addresses and force renew the leases. :open_mouth:


### Update Missing Drivers


Early on when we adopted a centrally managed patching server the administrators had a tendency to force push update packages to every workstation that would make various drivers disappear from the host. 


To combat the rush of tickets and phone calls of angry customers on `Patch Tuesdays` I developed a simple script to check the local host for missing drivers. Using the `Win32_ComputerSystem.Manufacturer` attribute I was able to assign it to a sub-folder that had all of the corresponding driver files stored on the server.


With the `PNPUtil` software I instructed it to recursively search the folder and `/add-driver` 


```PowerShell
PNPUtil.exe /add-driver $_.FullName /install
```


## Modules :desktop_computer:


During recent efforts to revisit current processes I have decided that some of the scripts that I regularly use are too large to parse and debug manually when there is any sort of issue. Because of this I have changed course to break them out into separate modules that can be recycled :recycle: or replicated multiple times, but that make it easier to determine where the problem is when something doesn't function correctly.


### PowerShell Module Template


I built this [Module Template](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Modules/PowerShell-Module-Template.psm1) to use as a base for any future development. It has saved me time in having to build out the basic formatting and helps to keep my products in a more uniform and legible manner.


## User Compliance


For my current major project I am working on upgrading the previous script that was used to manage user compliance with the Department of Defense (DoD) 8570 Baseline Certification training requirements. Each general user is required to annually complete their Cyber Awareness training and sign their User Agreement to confirm understanding of basic best practices in cybersecurity. The singular script that was used consisted of nearly 200 lines of poorly notated script. With any small detail that changes about our current environment or how we configure and track user accounts it would break.

The upgraded version is going to be a much shorter version that calls on multiple modules that are centrally tracked and managed. This will improve our ability to make necessary changes so that we don't have a large period of time where the users will fall out of compliance. 

### Set Variables

The first module that I created was designed to set up multiple variables that are either static throughout the script and other modules, or that prestage an array to contain users that have been reviewed and those left to review. 

In the `Set-Variables` module I define the target OU, mandatory report headers, variables to calculate the 365 day window with a 1 day cushion, and the string to retrieve all users within that container. The 'DistinguishedName' attribute is used to track who has been checked and who remains.

### Get File Name

Next I staged a module to call the `Get-FileName` function that uses the Windows 'OpenFileDialog' form to prompt the user to select the appropriate CSV file(s) for importing. The update script will import this module:

```PowerShell
Import Get-FileName
```

Then using the function I set both files as an initial variable to `Get-Content` from afterwards:

```PowerShell
# Select the CSV Reports
$Source1 = Get-FileName 'C:\Folder'
$Source2 = Get-FileName 'C:\Folder'

# Retrieve content from reports
$Source1Data = Get-Content $Source1
$Source2Data = Get-Content $Source2
```

This will allow me to later perform a comparison of the column headers to check for issues before importing the CSV to assign the attributes for each user. 

### Get Progress

Nothing is worse than running a script and having to wait forever only to find out that there was an error so nothing happened. For this exact reason I created a module to stage the variables and statement for this script so that I can display a progress bar at the top of the shell window. 

By using the `$AllData` variable with the 'count' attribute I can use the total number of objects in an equation to determine what the increment is for each user to progress towards 100%. That can then be displayed using the '-PercentComplete' argument for the `Write-Progress` statement. 

### Get Profile Verification

Because we have to track the user certificates and training dates in an exterior database there are sometimes discrepancies between the number of personnel in the database and the number of user objects within Active Directory. The database we use to export the reports has a setting to prevent updating the exported training dates if the user's profile has not been verified by one of the Information Security Officer's. 

To assist with tracking the unverified profiles I have created another module to check the CSV reports after they have been imported and merged to generate a report for us to review them. It will also be used to take their names out of the rotation for disabling to ensure that they aren't auto-disabled in error.

### Get Awareness Training Verification

Sometimes with automation there are issues when networks go down or a profile is misconfigured. The system we use for training is an enterprise wide training site that is supposed to use the user's credentials to verify login and upon completion of training it auto-uploads their training certificate to their profile. In cases where this process fails users can manually upload their certificate, but again an Information Security Officer must validate the authenticity before it can be accepted. 

Similar to the `Get-ProfileVerification` module this module checks the value for the 'Awareness Training Verified' column and removes those with a 'No' value from the `$UncheckedUsers` array as well before exporting a separate report. 


## Current Progress

Although this process is still in testing with each module to ensure all functionality I welcome any and all advice to help simplify this process. My hopes is that with the current files I have uploaded I can demonstrate my experience with PowerShell, and at the same time hopefully help others in their efforts with these templates to automate some of these simpler tasks. I will be updating this repository regularly as it progresses. If you have any questions or comments feel free to start a discussion in this repository!


#### License
The MIT License information can be found [here](https://nick-rudy.mit-license.org/)