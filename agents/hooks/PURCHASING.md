> **Sub-file of** [`agents/AGENTS.HOOKS.md`](../AGENTS.HOOKS.md) — program-to-hook count tables for Purchasing.

# Purchasing Hooks

Sub-file of agents/AGENTS.HOOKS.md — loaded when developing Purchase Order customizations.

## PUR/PO — Purchasing

| Program | Hooks | Notes |
|---------|-------|-------|
| PUR064GI | 39 | PO Line Inquiry |
| PUR100GI | 32 | PO Receipts |
| PUR011GI | 30 | PO Inquiry main |
| PUR021GI | 24 | PO Entry |
| PUR064GH | 24 | PO Line History |
| PUR064U | 16 | PO User Screen |
| PURA60GM | 15 | PO Approval Grid |
| PUR108 | 15 | PO Reports |
| PUR103 | 13 | PO Processing |
| PURS183A | 11 | PO Sub-screen |
| OPTEXCH | 10 | Option Exchange |
| PURA60GI | 8 | PO Approval Inquiry |
| PUR160 | 8 | PO Receipt Returns |
| PURA65N | 8 | PO Vendor RFQ (new) |
| PURA65V | 7 | PO Vendor Pricing |
| PUR064CL | 7 | PO Line Close |
| PUR064GM | 6 | PO Grid Maintenance |
| PUR013GI | 7 | PO Inquiry |
| PURA60WO | 7 | PO Approval WO |
| PUR103U | 7 | PO Processing User |
| PUR119GI | 7 | PO Reports |
| PURMRP01 | 7 | MRP PO Processing |
| PURA64GI | 6 | PO Approval Inquiry |
| PURA65 | 6 | PO Vendor RFQ |
| PURS183B | 3 | PO Sub-screen |
| PUR109 | 2 | PO Processing |
| PUR1EM | 1 | PO Email |
| AutoPOGenGridview | 8 | Auto PO Generation |
| AutomatedPurchaseOrderGenerati | 10 | Auto PO Generation (alt) |
| GSS_POBlanket.exe | 6 | .NET PO Blanket |
| GSS_POHistory | 6 | .NET PO History |
| GSS_PurchasePriceVariance | 6 | .NET Purchase Price Var |
| GSS_PurchasePriceVariance.exe | 6 | .NET Purchase Price Var (alt) |
| Picklist_MRP.exe | 1 | MRP Picklist |

---

For the complete hook catalog (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`all_hooks_table.md`](all_hooks_table.md). For GAB hook coding patterns and V.Caller/V.Passed reference, see [`agents/gab/HOOKS.md`](../gab/HOOKS.md).
