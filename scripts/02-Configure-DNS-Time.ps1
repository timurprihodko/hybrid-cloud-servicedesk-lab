# Block 3 / Step 2 - DNS client, forwarders, reverse zones, PDC time source
# Run on DC01 as MUSTER\Administrator after promotion.
$ErrorActionPreference = 'Stop'

$if = (Get-NetIPAddress -IPAddress 10.10.10.10).InterfaceAlias
Set-DnsClientServerAddress -InterfaceAlias $if -ServerAddresses 127.0.0.1

# Replaces any forwarder taken over from the old adapter config
Set-DnsServerForwarder -IPAddress 1.1.1.1, 1.0.0.1

foreach ($net in '10.10.10.0/24', '10.10.20.0/24') {
    $zone = ($net.Split('/')[0].Split('.')[2..0] -join '.') + '.in-addr.arpa'
    if (-not (Get-DnsServerZone -Name $zone -ErrorAction SilentlyContinue)) {
        Add-DnsServerPrimaryZone -NetworkId $net -ReplicationScope Forest -DynamicUpdate Secure
    }
}
if (-not (Get-DnsServerResourceRecord -ZoneName '10.10.10.in-addr.arpa' -Name '10' -RRType Ptr -ErrorAction SilentlyContinue)) {
    Add-DnsServerResourceRecordPtr -ZoneName '10.10.10.in-addr.arpa' -Name '10' `
        -PtrDomainName 'dc01.muster.internal'
}

# PDC emulator = time source of the domain
w32tm /config /manualpeerlist:"0.at.pool.ntp.org,0x8 1.at.pool.ntp.org,0x8" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time
w32tm /resync /force

# Checks
Resolve-DnsName microsoft.com | Select-Object -First 1
Resolve-DnsName _ldap._tcp.dc._msdcs.muster.internal -Type SRV
w32tm /query /status
