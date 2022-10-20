[![HitCount](https://hits.dwyl.com/Nick-Rudy/Windows-Management-Sample.svg?style=flat-square&show=unique)](http://hits.dwyl.com/Nick-Rudy/Windows-Management-Sample)

# Windows-Management-Sample
	
This repository is a sample of some basic Windows Administrative PowerShell tools that I have developed during my time as an Information Systems Security Officer. 

## Scripts

The scripts provided vary between remote queries on individual hosts as well as some functionality to reference a source file for larger lists of hostnames. 

### Get Last User

There are multiple ways to determine the last user of a host. However, during my tenure I have had to parse large lists of hostnames that were found during a Nessus scan :mag:. I usually just export the csv report and copy the column into a text file with one host on each line to keep it simple. 

The [Get-LastUser](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Get-LastUser.ps1) script is designed to prompt the user to input the file path of the text file directly into the shell window.

```PowerShell
Read-Host '(Input Format) <SAMPLE-SOURCE-PATH>\Remote-Hosts.txt'
```

It also includes a progress bar using the ```Write-Progress``` statement to show progression and list the current host it is working on. Using the 'LogonUI' registry path it checks for specific values and returns them to a variable on the originating host to be exported to a csv file.

After the function is built it calls for it to execute and starts the process to query each host on the list. 

### Remote GPUpdate

### Stale Computers

### Test IPv6 Enabled

### Update Missing Drivers

## Modules :desktop_computer:

During recent efforts to revisit current processes I have decided that some of the scripts that I regularly use are too large to parse and debug manually when there is any sort of issue. Because of this I have changed course to break them out into separate modules that can be used or replicated multiple times, but that make it easier to determine where the problem is when something doesn't function correctly.

### PowerShell Module Template

I built this [Module Template](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Modules/PowerShell-Module-Template.psm1) to use as a base for any future development. It has saved me time in having to build out the basic formatting and helps to keep my products in a more uniform and legible manner.

### Set Variables

### Get File Name

### Get Progress

### Get Profile Verification

### Get Awareness Training Verification

#### License
The MIT License information can be found [here](https://nick-rudy.mit-license.org/)