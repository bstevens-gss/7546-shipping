> **Sub-file of** [`agents/AGENTS.HOOKS.md`](../AGENTS.HOOKS.md) — program-to-hook count tables for Shipping.

# Shipping Hooks

Sub-file of agents/AGENTS.HOOKS.md — loaded when developing Shipping customizations.

## SHP — Shipping

| Program | Hooks | Notes |
|---------|-------|-------|
| SHP700 | 30 | Shipping main |
| SHP310 | 28 | Shipping Processing |
| SHP720 | 9 | Shipping Labels |
| SHP205 | 8 | Shipping Reports |
| SHP723 | 6 | Shipping Sub-screen |
| SHP721 | 6 | Shipping Labels |
| SHP331 | 5 | Shipping Sub-screen |
| SHP710 | 4 | Shipping Sub-screen |
| SHP120 | 2 | Shipping |
| SHP100 | 2 | Shipping |
| SHP751 | 1 | Shipping |
| GSS_ShipStatus.exe | 6 | .NET Ship Status |

---

For the complete hook catalog (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`all_hooks_table.md`](all_hooks_table.md). For GAB hook coding patterns and V.Caller/V.Passed reference, see [`agents/gab/HOOKS.md`](../gab/HOOKS.md).
