# Block 3 / Step 1 - Promote DC01 to first DC of muster.internal
# Run on DC01 as local Administrator. Take snapshot "DC01-pre-adds" first.
$ErrorActionPreference = 'Stop'

if ($env:COMPUTERNAME -ne 'DC01') {
    Rename-Computer -NewName 'DC01' -Restart
    return
}

Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools

$dsrm = Read-Host 'DSRM password' -AsSecureString

Install-ADDSForest `
    -DomainName 'muster.internal' `
    -DomainNetbiosName 'MUSTER' `
    -InstallDns `
    -SafeModeAdministratorPassword $dsrm `
    -Force
# Server reboots automatically. Log on afterwards as MUSTER\Administrator.
