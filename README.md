[![HitCount](https://hits.dwyl.com/Nick-Rudy/Windows-Management-Sample.svg?style=flat-square&show=unique)](http://hits.dwyl.com/Nick-Rudy/Windows-Management-Sample)

# Windows-Management-Sample
	
This repository is a sample of some basic Windows Administrative PowerShell tools that I have developed during my time as an Information Systems Security Officer. 

## Scripts

The scripts provided vary between remote queries on individual hosts as well as some functionality to reference a source file for larger lists of hostnames. 

### Get Last User

There are multiple ways to determine the last user of a host. However, during my tenure I have had to parse large lists of hostnames that were found during a Nessus scan. 

The [Get-LastUser](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Get-LastUser.ps1) script is designed to prompt the user to input the file path directly into the shell window.

```PowerShell
Read-Host '(Input Format) <SAMPLE-SOURCE-PATH>\Remote-Hosts.txt'
(Input Format) <SAMPLE-SOURCE-PATH>\Remote-Hosts.txt: 
```

### Remote GPUpdate

### Stale Computers

### Test IPv6 Enabled

### Update Missing Drivers

## Modules

### PowerShell Module Template

I built this [Module Template](https://github.com/Nick-Rudy/Windows-Management-Sample/blob/main/Modules/PowerShell-Module-Template.psm1) to use as a base for any future development. It has saved me time in having to build out the basic formatting and helps to keep my products in a more uniform and legible manner.

### Set Variables

### Get File Name

### Get Progress

### Get Profile Verification

### Get Awareness Training Verification