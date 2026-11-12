# Block 4 prep - run on 16 Nov after the M365 tenant exists.
# Example: .\06-Set-UpnSuffix.ps1 -Suffix mustergmbhlab.onmicrosoft.com
param([Parameter(Mandatory)][string]$Suffix)
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory

Get-ADForest | Set-ADForest -UPNSuffixes @{ Add = $Suffix }

$base = "OU=Benutzer,OU=Muster,$((Get-ADDomain).DistinguishedName)"
Get-ADUser -SearchBase $base -Filter * | ForEach-Object {
    Set-ADUser $_ -UserPrincipalName "$($_.SamAccountName)@$Suffix"
}
Get-ADUser -SearchBase $base -Filter * | Select-Object SamAccountName, UserPrincipalName
