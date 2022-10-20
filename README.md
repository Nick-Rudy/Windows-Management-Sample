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


### Set Variables


### Get File Name


### Get Progress


### Get Profile Verification


### Get Awareness Training Verification


#### License
The MIT License information can be found [here](https://nick-rudy.mit-license.org/)