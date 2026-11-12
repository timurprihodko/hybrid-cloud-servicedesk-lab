# Block 3 / Step 7 - join CL01 to muster.internal
# Run on CL01 (elevated) after it received a DHCP lease from 10.10.20.0/24.
# Two passes: rename + reboot first, then join. Join and rename in one
# Add-Computer call can fail with "The directory service is busy".
$ErrorActionPreference = 'Stop'

ipconfig /all | Select-String 'IPv4|DNS-Server|DNS Servers'
nltest /dsgetdc:muster.internal

if ($env:COMPUTERNAME -ne 'CL01') {
    Rename-Computer -NewName 'CL01' -Restart
    return   # run the script again after reboot
}

Add-Computer -DomainName 'muster.internal' `
    -OUPath 'OU=Computer,OU=Muster,DC=muster,DC=internal' `
    -Credential 'MUSTER\adm-timur' `
    -Restart
# After reboot: log on as MUSTER\thomas.bauer, then: whoami; gpresult /r
