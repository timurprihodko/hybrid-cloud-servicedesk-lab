# Block 3 / Step 4 - OU structure and department groups
# Departments are read from users.csv (UTF-8) so the script itself has no umlauts.
param([string]$Csv = "$PSScriptRoot\users.csv")
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory

$domainDN = (Get-ADDomain).DistinguishedName
$root     = "OU=Muster,$domainDN"

function New-OUIfMissing([string]$Name, [string]$Path) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -SearchScope OneLevel)) {
        New-ADOrganizationalUnit -Name $Name -Path $Path -ProtectedFromAccidentalDeletion $true
    }
}

New-OUIfMissing 'Muster' $domainDN
'Benutzer', 'Computer', 'Gruppen', 'Admins' | ForEach-Object { New-OUIfMissing $_ $root }

$depts = Import-Csv $Csv -Encoding UTF8 | Select-Object Department, DeptCode -Unique
foreach ($d in $depts) {
    New-OUIfMissing $d.Department "OU=Benutzer,$root"
    $g = "GG-$($d.DeptCode)"
    if (-not (Get-ADGroup -Filter "Name -eq '$g'")) {
        New-ADGroup -Name $g -GroupScope Global -GroupCategory Security `
            -Path "OU=Gruppen,$root" -Description "Abteilung $($d.Department)"
    }
}

# New computer objects (domain join without -OUPath) land in Muster/Computer
redircmp "OU=Computer,$root"
