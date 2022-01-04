<#
    Requirement : Check a shared drive and / or a file to see what files or documents types are in there

    Written by : Josh Wallace

    Date : 06/02/2021
#>

#Functions
function Get-Folder ([string]$Path){
    $Exists = Test-Path $Path
        if (!$Exists) {
            Write-Host "Sorry, we are unable to find $Path. Please enter a vaild file path."
        }
        else {
            Write-Host "$Path does exist!"
        }
}
function Get-FolderStatistics([string]$Path){
    $files = dir $Path -Recurse | where {!$_.PSIsContainer}
       $files | Group-Object -Property Extension | select `
       @{Label="Quantity";Expression={$_.Count}}, `
       @{Label="File Type";Expression={$_.Name}}, `
       @{Label="File Path";Expression={$_.Group}} | ft 
   }

#Input
$Path = Read-Host "Please enter a path"

#Run Commands
Get-Folder -Path $Path

$Output = Get-FolderStatistics -Path $Path

cls

Write-Host "Please see the file infomation for $Path"

$Output

Pause