> **Sub-file of** [`agents/AGENTS.HOOKS.md`](../AGENTS.HOOKS.md) — program-to-hook count tables for Inventory and Lot Tracking.

# Inventory & Lot Tracking Hooks

Sub-file of agents/AGENTS.HOOKS.md — loaded when developing Inventory customizations.

## INV — Inventory

| Program | Hooks | Notes |
|---------|-------|-------|
| INVMAIN | 81 | Inventory Maintenance main |
| INV014GI | 42 | Inventory Inquiry |
| INV220GI | 29 | Inventory Extended Inquiry |
| INV516GI | 29 | Inventory Where-Used |
| INV500GI | 25 | Inventory Status |
| INV060 | 25 | Inventory Receipts |
| INV950 | 16 | Inventory Custom Fields |
| INV010XR | 14 | Inventory Cross-Ref |
| INV122 | 12 | Inventory Adjustments |
| INV395 | 11 | Inventory History |
| INV503 | 10 | Inventory Labels |
| INV018GI | 9 | Inventory Reports |
| INV026 | 8 | Inventory Transfers |
| INV025 | 7 | Inventory Counts |
| INV870GI | 7 | Inventory Reporting |
| INV121 | 6 | Inventory Transactions |
| INV500N | 6 | Inventory Status (new) |
| INV570 | 6 | Inventory Inquiry |
| INV022GI | 6 | Inventory Inquiry |
| INV010P | 5 | Inventory Print |
| INVMRP01 | 5 | MRP Processing |
| INV501 | 4 | Inventory Labels |
| INV017GI | 3 | Inventory Reports |
| INV307 | 2 | Inventory Report |
| INV982 | 2 | Inventory Utility |
| INV984 | 2 | Inventory Utility |
| INV504 | 2 | Inventory Labels |
| INV508 | 2 | Inventory Labels |
| INV018PT | 1 | Inventory Print |
| INV072 | 1 | Inventory |
| INV362 | 1 | Inventory |
| INV985 | 1 | Inventory Utility |
| GSS_InvExtendedStatus | 6 | .NET Inv Extended Status |
| GSS_InvHistory.exe | 6 | .NET Inv History |
| GSS_ItemHistory.exe | 6 | .NET Item History |
| GSS_LocationStatus.exe | 6 | .NET Location Status |
| GSS_PartCatalog.exe | 12 | .NET Part Catalog |
| GSS_PartXRef.exe | 6 | .NET Part Cross-Ref |

## LOT — Lot Tracking

| Program | Hooks | Notes |
|---------|-------|-------|
| LOT133GI | 29 | Lot Where-Used |
| LOT010GI | 23 | Lot Inquiry main |
| LOT054GI | 19 | Lot Detail |
| LOT155GI | 14 | Lot Reports |
| LOT111GI | 7 | Lot Inquiry |
| LOT500GI | 6 | Lot Status |

---

For the complete hook catalog (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`all_hooks_table.md`](all_hooks_table.md). For GAB hook coding patterns and V.Caller/V.Passed reference, see [`agents/gab/HOOKS.md`](../gab/HOOKS.md).
