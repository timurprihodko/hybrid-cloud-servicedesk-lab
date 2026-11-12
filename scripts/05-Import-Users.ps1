# Block 3 / Step 5 - 20 users from CSV + separate admin account
# UPN suffix stays muster.internal until the M365 tenant exists (see 06-Set-UpnSuffix.ps1).
param(
    [string]$Csv       = "$PSScriptRoot\users.csv",
    [string]$UpnSuffix = 'muster.internal',
    [string]$AdminSam  = 'adm-timur'
)
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory

$root = "OU=Muster,$((Get-ADDomain).DistinguishedName)"
$pw   = Read-Host 'Initial password for all users (change at next logon)' -AsSecureString

foreach ($u in Import-Csv $Csv -Encoding UTF8) {
    $sam = $u.SamAccountName
    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'"
    if ($existing) {
        # A failed earlier run can leave the object disabled, without password and group
        if (-not $existing.Enabled) { Write-Warning "$sam exists but is disabled - check password and group" }
        else { Write-Host "skip  $sam" }
        continue
    }

    New-ADUser -Name "$($u.GivenName) $($u.Surname)" `
        -GivenName $u.GivenName -Surname $u.Surname -DisplayName "$($u.GivenName) $($u.Surname)" `
        -SamAccountName $sam -UserPrincipalName "$sam@$UpnSuffix" `
        -Department $u.Department -Title $u.Title -Company 'Muster GmbH' -City 'Wien' `
        -Path "OU=$($u.Department),OU=Benutzer,$root" `
        -AccountPassword $pw -ChangePasswordAtLogon $true -Enabled $true

    Add-ADGroupMember -Identity "GG-$($u.DeptCode)" -Members $sam
    Write-Host "ok    $sam"
}

# Admin account: separate from daily account, not synced (OU Admins is outside sync scope)
if (-not (Get-ADUser -Filter "SamAccountName -eq '$AdminSam'")) {
    $apw = Read-Host "Password for $AdminSam" -AsSecureString
    New-ADUser -Name $AdminSam -SamAccountName $AdminSam -UserPrincipalName "$AdminSam@muster.internal" `
        -Path "OU=Admins,$root" -AccountPassword $apw -Enabled $true
    Add-ADGroupMember -Identity 'Domain Admins' -Members $AdminSam
}

Get-ADUser -SearchBase "OU=Benutzer,$root" -Filter * -Properties Department |
    Group-Object Department | Select-Object Name, Count
