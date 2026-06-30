> **Sub-file of** [`agents/AGENTS.HOOKS.md`](../AGENTS.HOOKS.md) — program-to-hook count tables for Work Orders and SFDC.

# Work Order & SFDC Hooks

Sub-file of agents/AGENTS.HOOKS.md — loaded when developing Work Order or Shop Floor customizations.

## JOB/WO — Jobs & Work Orders

| Program | Hooks | Notes |
|---------|-------|-------|
| JB0011GI | 91 | Work Order Inquiry (2nd most hooks) |
| JB0052GI | 45 | WO Material Inquiry |
| JB0075GI | 44 | WO Operations/Labor |
| JB0010GI | 41 | Job Inquiry main |
| JB033A | 34 | Job Costing |
| JB0083 | 33 | Job Scheduling |
| JB0027 | 29 | Work Order Browser |
| JB032BGI | 29 | Job Update Inquiry |
| JB0076GI | 28 | WO Labor Detail |
| JB0081 | 27 | Job Maintenance |
| JB0343 | 21 | Job Sub-screen |
| JB0085 | 19 | Job Status |
| JB0710 | 18 | WO Routing |
| JB0252 | 16 | Job Browser |
| JB0471 | 15 | Job History |
| JB0551GI | 15 | Job Reports |
| JB0080 | 14 | Job Maintenance |
| JB0066 | 13 | Job Inquiry |
| JB0351 | 13 | Job Sub-screen |
| JB0356 | 13 | Job Inquiry |
| JB0700 | 23 | WO Operations |
| JB0075R | 11 | WO Labor Reports |
| JB0028 | 10 | Work Order Browser |
| JB0082 | 10 | Job Scheduling |
| JB0098 | 10 | Job Inquiry |
| JB0474 | 10 | Job History |
| JBAPP01 | 9 | Job Approval |
| JB0096 | 9 | Job Reports |
| JB0650 | 8 | WO Closure |
| JB032BGR | 8 | Job Update Report |
| JB0010S | 8 | Job Inquiry Sub |
| JB0038 | 7 | Job |
| JB0131 | 5 | Job |
| JB032A | 5 | Job On-line Update |
| JB0305 | 6 | Job Sub-screen |
| JB0306 | 6 | Job Sub-screen |
| JB0308 | 6 | Job Sub-screen |
| JB0010M | 6 | Job Inquiry (mobile) |
| JB0122 | 6 | Job Reports |
| JB0830 | 6 | WO Closure |
| JB0019GI | 13 | Job Sub-Inquiry |
| WOQUERY | 49 | Work Order Query tool |
| JB0641 | 3 | Job |
| JB0052S | 2 | WO Material Sub |
| JB0011CL | 2 | WO Closure |
| JB0986 | 2 | Document Link creation |
| JB0989 | 2 | Document Link |
| JB0660 | 1 | WO |
| JBUTL002 | 2 | Job Utility |

## SFDC — Shop Floor Data Collection

| Program | Hooks | Notes |
|---------|-------|-------|
| SFDC2 | 101 | SFDC main (4th most hooks overall) |
| SFDC.NET | 6 | .NET SFDC |

---

For the complete hook catalog (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`all_hooks_table.md`](all_hooks_table.md). For GAB hook coding patterns and V.Caller/V.Passed reference, see [`agents/gab/HOOKS.md`](../gab/HOOKS.md).
