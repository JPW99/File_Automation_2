<#
    Requirement : Find what AD groups have access to a folder and then run a report on who is in those groups

    Written by : Josh Wallace

    Date : 06/02/2021

    Version : 0.0.1

    Changes : See change log for details

#>

#Function : What groups have access to a folder / shared drive
function Get-Permissions ([string]$path, [bool]$Report){

       if ($path -and !$Report) {
           
        (Get-Acl $path).Access | Select-Object `
        @{Label="Identity";Exp={$_.IdentityReference}}, `
		@{Label="Right";Exp={$_.FileSystemRights}}, `
		@{Label="Access";Exp={$_.AccessControlType}}, `
		@{Label="Inherited";Exp={$_.IsInherited}} | ft -GroupBy $_.IdentityReference
    }
        if ($path -and $Report -eq $true) {
        
            (Get-Acl $path).Access | Select-Object `
        @{Label="Identity";Exp={$_.IdentityReference}}, `
		@{Label="Right";Exp={$_.FileSystemRights}}, `
		@{Label="Access";Exp={$_.AccessControlType}}, `
		@{Label="Inherited";Exp={$_.IsInherited}} | ft -GroupBy $_.IdentityReference

            $OutPutFile = Read-Host "Pleas enter a location \ file name for the report"

                (Get-Acl $path).Access | select IdentityReference,FileSystemRights,AccessControlType,IsInherited |
                    foreach {

                    New-Object psobject -Property @{

                    Identity = $_.IdentityReference
                    Right = $_.FileSystemRights
                    Access = $_.AccessControlType
                    Inherited = $_.IsInherited
                }

                    } | Select Identity,Access,Right,Inherited | Export-Csv -Delimiter "," -Path $OutPutFile
            
        }

}