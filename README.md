# Hybrid Cloud & Service Desk Lab

Lab environment that simulates the IT of a small Viennese company ("Muster GmbH", 20 employees): an on-premises Active Directory behind a Sophos firewall, hybrid identity with Microsoft Entra ID, device management with Intune, Microsoft 365 administration, a service desk in Jira Service Management and patch management with Action1.

Follow-up to my first lab, [homelab](https://github.com/timurprihodko/homelab) (on-premises AD DS, DNS, DHCP, GPO, Linux domain join). This project extends it from on-premises to hybrid and cloud administration.

## Status

| # | Block | Status |
| --- | --- | --- |
| 1 | VirtualBox host and VMs | In progress: FW01 and DC01 done, CL01 and CL02 pending |
| 2 | Sophos Firewall: zones, rules, VPN | In progress: base configuration done, strict rules, web filter and VPN pending |
| 3 | Active Directory foundation | Planned |
| 4 | Hybrid identity (AD to Entra ID) | Planned |
| 5 | Entra ID: MFA, Conditional Access, SSPR, roles | Planned |
| 6 | Intune: enrollment, compliance, apps, Autopilot | Planned |
| 7 | Exchange Online, Teams, SharePoint | Planned |
| 8 | Defender for Business and Action1 | Planned |
| 9 | Service desk in Jira Service Management (15 tickets) | Planned |

## Architecture

```
                       Internet
                           |
                 VirtualBox NAT (WAN)
                           |
            +--------------+--------------+
            |   FW01 - Sophos Firewall    |   Port1 MGMT 172.16.16.16/24
            |   SFOS 22.0.3               |   (host-only, admin access only)
            +------+---------------+------+
                   |               |
        Port3 SERVER zone   Port4 CLIENT zone
         10.10.10.0/24       10.10.20.0/24
                   |               |
            DC01 10.10.10.10    CL01, CL02
            AD DS, DNS, DHCP    DHCP via relay to DC01
```

Cloud services (planned): Microsoft 365 Business Premium trial (Entra ID, Intune, Exchange Online, Defender for Business), Jira Service Management Free, Action1.

## Networks

| Network | VirtualBox type | Subnet | Gateway | Purpose |
| --- | --- | --- | --- | --- |
| WAN | NAT | assigned by VirtualBox | - | Internet access for FW01 only |
| MGMT | Host-only | 172.16.16.0/24 | - | Sophos web admin from the host |
| SERVER | Internal network | 10.10.10.0/24 | 10.10.10.1 | Servers |
| CLIENT | Internal network | 10.10.20.0/24 | 10.10.20.1 | Clients |
| VPN | Sophos remote access | 10.10.99.0/24 | 10.10.99.1 | Remote users (planned) |

## Virtual machines

| VM | OS | Role | vCPU | RAM | Disk |
| --- | --- | --- | --- | --- | --- |
| FW01 | Sophos Firewall Home (SFOS 22.0.3) | Gateway, zones, NAT, VPN | 2 | 4 GB | 80 GB dynamic |
| DC01 | Windows Server 2025 Standard Evaluation (Desktop Experience) | AD DS, DNS, DHCP, Entra Connect | 2 | 3 GB | 60 GB dynamic |
| CL01 | Windows 11 Enterprise Evaluation | Hybrid join, Intune | 2 | 3 GB | planned |
| CL02 | Windows 11 Enterprise Evaluation | Entra join, Autopilot | 2 | 3 GB | planned |

Host: Windows 11 Home, 32 GB RAM, 8 cores / 16 threads, VirtualBox.

## Documentation

- [01 - VirtualBox setup](docs/01-virtualbox-setup.md)
- [02 - Sophos Firewall](docs/02-sophos-firewall.md)

## Repository structure

```
hybrid-cloud-servicedesk-lab/
├── README.md
├── README.de.md
├── docs/          one file per block
├── policies/      exported Conditional Access, Intune and Sophos settings (no secrets)
├── runbooks/      onboarding, offboarding, lost device
├── tickets/       15 service desk cases: symptom, cause, solution
├── kb/            knowledge base articles (German)
├── scripts/       PowerShell scripts
└── screenshots/
```

## Security note

This repository contains no passwords, keys, serial numbers, tenant IDs or public IP addresses. Screenshots are redacted before upload.
