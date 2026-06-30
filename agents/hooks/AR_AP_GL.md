> **Sub-file of** [`agents/AGENTS.HOOKS.md`](../AGENTS.HOOKS.md) — program-to-hook count tables for AP, AR, and GL.

# Financial Hooks (AP, AR, GL)

Sub-file of agents/AGENTS.HOOKS.md — loaded when developing Accounts Payable, Accounts Receivable, or General Ledger customizations.

## AP — Accounts Payable

| Program | Hooks | Notes |
|---------|-------|-------|
| AP0020GI | 41 | AP Inquiry main |
| AP0043RG | 27 | AP Register |
| AP0043GI | 15 | AP Invoice Inquiry |
| AP0048GI | 8 | AP Aging |
| AP Payments | 7 | AP Payment processing |
| APChecks.exe | 6 | Check printing |
| AP0206GI | 5 | AP Report |
| AP0700 | 4 | AP Configuration |
| AP0041 | 7 | AP Batch |
| AP0270 | 2 | AP Adjustments |

## AR — Accounts Receivable

| Program | Hooks | Notes |
|---------|-------|-------|
| AR0020GI | 45 | AR Customer Inquiry main |
| AR0044GI | 16 | AR Invoice Inquiry |
| AR0150GI | 15 | AR Aging / Custom Fields |
| ARTBL | 10 | AR Table Maintenance |
| AR0180 | 8 | AR Adjustments |
| AR0027 | 6 | AR Batch |
| AR0170GI | 6 | AR Reports |
| AR0040GI | 1 | AR Inquiry |
| AR00020 | 1 | (variant) |

## GL — General Ledger

| Program | Hooks | Notes |
|---------|-------|-------|
| OLG002 | 76 | Online GL Journal Entry (high hook count) |
| GL0002 | 7 | GL Inquiry |
| GL0003 | 7 | GL Account Maintenance |
| GL0010 | 6 | GL Batch |
| GL0905 | 6 | GL Reports |
| GL0046 | 1 | GL Sub-function |
| GL0009 | 1 | GL Sub-function |
| OLL30C | 9 | Online GL Sub-screen |
| OLL302 | 1 | Online GL Sub-screen |
| OLL338 | 7 | Online GL Sub-screen |
| GSS_ChartOfAccounts | 6 | .NET Chart of Accounts |
| GSS_BatchesNotPosted | 6 | .NET Batches Not Posted |
| GSS_BatchesNotPosted.exe | 7 | .NET Batches Not Posted (alt) |
| GSS_ProjectedJournalReversals | 16 | .NET Projected Reversals |
| GSS_RepeatJournalEntries.exe | 6 | .NET Repeat JE |

---

For the complete hook catalog (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`all_hooks_table.md`](all_hooks_table.md). For GAB hook coding patterns and V.Caller/V.Passed reference, see [`agents/gab/HOOKS.md`](../gab/HOOKS.md).
