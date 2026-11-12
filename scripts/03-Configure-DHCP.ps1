# Block 3 / Step 3 - DHCP for CLIENT network (10.10.20.0/24) via Sophos DHCP relay
# Run on DC01 as MUSTER\Administrator.
$ErrorActionPreference = 'Stop'

Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerSecurityGroup
Restart-Service DHCPServer

if (-not (Get-DhcpServerInDC | Where-Object IPAddress -eq '10.10.10.10')) {
    Add-DhcpServerInDC -DnsName 'dc01.muster.internal' -IPAddress 10.10.10.10
}
# Suppress "Complete DHCP configuration" notification in Server Manager
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12' -Name ConfigurationState -Value 2

if (-not (Get-DhcpServerv4Scope -ScopeId 10.10.20.0 -ErrorAction SilentlyContinue)) {
    Add-DhcpServerv4Scope -Name 'CLIENT' -StartRange 10.10.20.100 -EndRange 10.10.20.199 `
        -SubnetMask 255.255.255.0 -LeaseDuration 8.00:00:00 -State Active
}
Set-DhcpServerv4OptionValue -ScopeId 10.10.20.0 `
    -Router 10.10.20.1 -DnsServer 10.10.10.10 -DnsDomain 'muster.internal'

Get-DhcpServerv4Scope
Get-DhcpServerv4OptionValue -ScopeId 10.10.20.0
