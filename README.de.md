# Hybrid Cloud & Service Desk Lab (Kurzfassung)

Laborumgebung, die die IT eines kleinen Wiener Unternehmens („Muster GmbH“, 20 Mitarbeitende) nachbildet: lokales Active Directory hinter einer Sophos Firewall, hybride Identität mit Microsoft Entra ID, Geräteverwaltung mit Intune, Microsoft-365-Administration, Service Desk in Jira Service Management und Patch-Management mit Action1.

Fortsetzung meines ersten Labs [homelab](https://github.com/timurprihodko/homelab) (AD DS, DNS, DHCP, GPO, Linux-Domänenbeitritt) – diesmal mit Schwerpunkt Hybrid und Cloud.

## Aktueller Stand

- **VirtualBox:** Firewall (FW01) und Domain Controller (DC01) eingerichtet; Windows-11-Clients folgen.
- **Sophos Firewall (SFOS 22.0.3):** Zonen SERVER und CLIENT, Interfaces, NAT und eine temporäre Internet-Regel eingerichtet; strenges Regelwerk, Webfilter und VPN folgen.
- **Geplant:** Active Directory, Entra Connect, Conditional Access, Intune mit Autopilot, Exchange Online, Defender for Business, Action1, 15 dokumentierte Tickets in Jira Service Management.

## Netzwerk

| Netz | Subnetz | Zweck |
| --- | --- | --- |
| MGMT | 172.16.16.0/24 | Verwaltung der Firewall vom Host |
| SERVER | 10.10.10.0/24 | Server (DC01) |
| CLIENT | 10.10.20.0/24 | Clients (CL01, CL02) |

Die vollständige Dokumentation ist auf Englisch: [README.md](README.md).
