# 09 - Service desk in Jira Service Management

## Goal

A service desk for Muster GmbH: request types, priorities P1–P4 with SLAs, a customer portal and a knowledge base. The work of blocks 4–8 is tracked as tickets; 15 incident scenarios are solved and documented in `tickets/`.

This file grows with the block. The first part (setup) was done before the Microsoft 365 trial, so the trial days are spent on M365 only.

## Setup (13 Nov 2026)

### Platform

| Item | Value |
| --- | --- |
| Product | Jira Service Management, Free plan (up to 3 agents; sold as part of Atlassian "Service Collection") |
| Space | `Muster IT`, key `IT`, template IT service management |
| Portal | `Muster IT-Service`, German introduction text |
| Channel access | Restricted: only customers added by agents or admins (default was open to anyone) |
| Browser | Separate Chrome profile `Lab` for all lab portals (Jira, Action1, later Entra / Intune / Sophos) |

The Free plan has no change management (Premium only). Changes are recorded as service requests with the label `change`.

### Request types (template defaults)

| Category | Request types |
| --- | --- |
| Service requests | Get IT help, Onboard new employees, Request a new account, Request admin access, Request new hardware, Request new software, Emailed request (email channel, hidden from portal) |
| Incidents | Report a system problem, Report broken hardware |

Renaming to German and the knowledge base follow later in block 9.

### Priorities

Jira priorities are a site-wide setting and are not renamed. Mapping:

| Lab | Jira |
| --- | --- |
| P1 | Highest |
| P2 | High |
| P3 | Medium |
| P4 | Low, Lowest |

Priority is set manually for now. Impact × Urgency (both fields exist in the ITSM template) is not yet mapped to the priority; planned as an automation rule.

### Calendar

`Muster Bürozeiten`: Monday–Friday 08:00–17:00, Europe/Vienna. The service desk window is 9 hours; it is covered by staff with 8-hour days and lunch breaks. One business day = `9h` in SLA targets.

### SLAs

Same targets for both categories (Incidents, Service requests). P1 uses the 24/7 calendar, all other priorities `Muster Bürozeiten`.

| Priority | Time to first response | Time to resolution |
| --- | --- | --- |
| P1 Highest | 30m | 4h |
| P2 High | 2h | 9h (1 business day) |
| P3 Medium | 8h | 27h (3 business days) |
| P4 Low, Lowest | 9h | 45h (5 business days) |
| All remaining | 8h | 27h |

Conditions:

| SLA | Start | Pause | Stop |
| --- | --- | --- | --- |
| Time to first response | Work item created | – | Comment for customers; status Waiting for customer; resolution set |
| Time to resolution | Work item created; resolution cleared (reopened) | Status Waiting for customer | Resolution set |

A ticket waiting for the user does not count against the service desk. An internal note does not stop the first-response clock; only a reply to the customer does.

`Time to close after resolution` kept as template default.

### Verification

Test ticket `IT-1` (Incident), created Friday 13 Nov 14:51, priority Medium:

| SLA | Target | Due | Calculation |
| --- | --- | --- | --- |
| First response | 8h | Mon 16 Nov 13:51 | Fri 2:09 + Mon 5:51 |
| Resolution | 27h | Wed 18 Nov 14:51 | Fri 2:09 + Mon 9h + Tue 9h + Wed 6:51 |

Both due dates match the business-hours calendar. `IT-1` closed afterwards.

## Action1 account

Account created (EU data center) before the trial. No agent installed yet: agents go only into the lab VMs in block 8, never on the host. The installation token is not stored in this repository.

## Troubleshooting

| Problem | Cause | Solution |
| --- | --- | --- |
| Sign-up offered only Kanban / Scrum templates | Sign-up started in Jira (work management), not in JSM | JSM already existed on the site; new space created via Spaces → + → IT service management |
| SLA goals counter stayed at "5 of 90" after editing | The counter counts goal groups (per category), not priority rows | Verified with a test ticket instead |
| Queue column "Time to resolution": "There was a problem showing this field" | SLA recalculation after config change and priority change | Refresh in the work item's SLA panel; transient |
