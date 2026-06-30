# GAB CallWrapper Reference (Index)
# Sub-agent of agents/AGENTS.GAB.md -- routes to module-specific CallWrapper reference files
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

This file is the **routing index** for CallWrapper documentation. Detailed entries are split into module files (each under ~100K characters) so agents load only what they need.

## CALLWRAPPER USAGE PATTERN

Every module file begins with this pattern:

```
F.Global.CallWrapper.New("alias","Namespace.ClassName")
F.Global.CallWrapper.SetProperty("alias","PropertyName",sValue)
F.Global.CallWrapper.Run("alias")
F.Global.CallWrapper.GetProperty("alias","PropertyName",sResult)
```

> **Note:** GAB is case-insensitive, so `F.Global.callwrapper` and `F.Global.CallWrapper` are equivalent at runtime. This documentation standardizes on `F.Global.CallWrapper` (PascalCase). Production scripts may use other casings — they are functionally identical.

---

## Module files

| File | Coverage (original `CALLWRAPPERS` sections) |
|------|---------------------------------------------|
| `agents/gab/CW_ACCOUNTING.md` | Usage pattern + **Accounting** |
| `agents/gab/CW_INVENTORY.md` | Usage pattern + **Inventory** |
| `agents/gab/CW_MANUFACTURING.md` | Usage pattern + **Manufacturing** |
| `agents/gab/CW_PURCHASING.md` | Usage pattern + **Object CallWrappers**, **Payroll**, **Purchasing** |
| `agents/gab/CW_QUALITY.md` | Usage pattern + **Quality** |
| `agents/gab/CW_SALES_1.md` | Usage pattern + **Sales** (Part 1: `# Sales` through `Sales.IntercompanySalesOrderEvent`) |
| `agents/gab/CW_SALES_2.md` | Usage pattern + **Sales** (Part 2: `Sales.Invoicing.*`, quoting, shipments, freight, and remaining Sales entries) |
| `agents/gab/CW_SUPPORT.md` | Usage pattern + **Support**, **Troubleshoot CallWrappers** |

**Sales** is split at `## Sales.Invoicing.*` because a single Sales file exceeded the size limit. Read **both** `CW_SALES_1.md` and `CW_SALES_2.md` for a full Sales CallWrapper search.

---

## Routing guidance

| When working on… | Open |
|------------------|------|
| AP, GL, tax, checks, batch helpers | `CW_ACCOUNTING.md` |
| Item master, transfers, part lookups | `CW_INVENTORY.md` |
| BOM, work orders, WIP, serialization, labor | `CW_MANUFACTURING.md` |
| PO, requisitions, RFQ, vendor quotes, payroll imports, object wrappers | `CW_PURCHASING.md` |
| RMA, engineering change, reject disposition | `CW_QUALITY.md` |
| Tax authorities, pricing, configurator, duplicate checks, early Sales entries | `CW_SALES_1.md` |
| Invoicing, quoting, shipments, freight, packing lists, ship schedule, remaining Sales | `CW_SALES_2.md` |
| Soft locks, OPTEXCH, location validation, CallWrapper troubleshooting | `CW_SUPPORT.md` |

---

## Content integrity

The eight module files contain **every** line of the former monolithic reference body (source lines 16–8443: from `# Accounting` through the end of **Troubleshoot CallWrappers**), with the usage pattern (lines 5–13) duplicated at the top of each module file for convenience. No reference text was removed—only partitioned.
