# GAB Data Operations Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with data, strings, math, dates, or databases
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

This file is a **routing index**. Detailed reference has been split into focused sub-files so each stays under size limits. Load the sub-file that matches your task.

| Topic | Sub-file | Contents (summary) |
|-------|----------|-------------------|
| String, Math, Date | [`agents/gab/DATA_STRING.md`](DATA_STRING.md) | `F.Intrinsic.String.*`, `F.Intrinsic.Math.*`, `F.Intrinsic.Date.*`, separators |
| ODBC / SQL / recordsets | [`agents/gab/DATA_ODBC.md`](DATA_ODBC.md) | Connections, `Execute`, recordsets, `V.ODBC.*` accessors, transactions, Azure, schema, BLOBs |
| DataTable / DataView | [`agents/gab/DATA_DATATABLE.md`](DATA_DATATABLE.md) | `F.Data.DataTable.*`, `V.DataTable.*`, `F.Data.DataView.*`, `V.DataView.*`, row/column ops |
| Dictionary, LINQ, misc data APIs | [`agents/gab/DATA_MISC.md`](DATA_MISC.md) | Dictionary, `F.Data.Linq.*`, `F.Data.Object.*`, StringBuilder, GSSXML, UDTs, `F.Intrinsic.Variable.*` |

**Line coverage:** Original monolithic reference lines 4–3794 map to the four sub-files in order (STRING+MATH+DATE, ODBC, DATATABLE+DATAVIEW, remainder). Each sub-file begins with the standard two-line title plus `---` before its section headers.
