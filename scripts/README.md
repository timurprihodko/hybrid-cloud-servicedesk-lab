# Scripts

PowerShell scripts for block 3 (Active Directory foundation). Run them in order on the VM named in the table, in an elevated PowerShell window, after `Set-ExecutionPolicy -Scope Process Bypass -Force`. Scripts 02-05 can be run again; existing objects are skipped.

| Script | Run on | Purpose |
| --- | --- | --- |
| `01-Install-ADForest.ps1` | DC01 | AD DS and DNS roles, new forest `muster.internal` (NetBIOS `MUSTER`), reboot |
| `02-Configure-DNS-Time.ps1` | DC01 | DNS client on loopback, forwarders, reverse zones, PTR record, NTP for the PDC emulator |
| `03-Configure-DHCP.ps1` | DC01 | DHCP role, authorization in AD, scope `10.10.20.0/24` for the CLIENT network |
| `04-Create-OU-Groups.ps1` | DC01 | OU structure under `Muster`, one security group per department, `redircmp` |
| `05-Import-Users.ps1` | DC01 | 20 users from `users.csv`, separate admin account |
| `06-Set-UpnSuffix.ps1` | DC01 | Add the Microsoft 365 tenant domain as UPN suffix (block 4) |
| `07-Join-CL01.ps1` | CL01 | Rename, reboot, then join the domain |
| `users.csv` | - | Users with department and title (UTF-8) |

Department names with umlauts are stored only in `users.csv`, which is read with `-Encoding UTF8`. Windows PowerShell 5.1 reads `.ps1` files without a BOM as ANSI, so umlauts inside the scripts would break.

Passwords are entered at runtime with `Read-Host -AsSecureString` and are not stored anywhere in this repository.
