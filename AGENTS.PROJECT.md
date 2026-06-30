# Project Configuration
# Fill this file out when deploying agents to a new project.
# This file is project-specific and should NOT be overwritten by deploy-agents.ps1.

---

## Customer

| Field | Value |
|-------|-------|
| Customer Name | `TODO` |
| Customer Code | `TODO` |
| Contact(s) | `TODO` |

---

## Environment

| Field | Value |
|-------|-------|
| DSN | `TODO` (e.g., `DSN=GLOBAL_PLA; UID=Master; PWD=master`) |
| GlobalShop Version | `TODO` |
| GAB IDE Version | `TODO` |
| Global Directory | `TODO` (e.g., `C:\Global Shop Solutions\`) |
| Plugins Directory | `TODO` |

---

## Paths

| Field | Value |
|-------|-------|
| Sample G2U Files | `C:\Users\rking\OneDrive - Global Shop Solutions\RKing\` (organized by customer folder, then project number) |
| Reference Artifacts | `TODO` (e.g., path to NTP/spec reference documents) |
| Project Scripts Directory | `TODO` (e.g., `.\scripts\`) |

---

## Project Info

| Field | Value |
|-------|-------|
| Project Number | `TODO` |
| Feature Number(s) | `TODO` |
| Go-Live Date | `TODO` |
| Billing Model | `TODO` (Type A/B/C/D -- see agents/AGENTS.QUOTING.md) |

---

## Supplemental Documents

Track RFQs, change requests, and other stakeholder-provided files here.
When a new document arrives, the agent will auto-extract it per agents/AGENTS.DOCUMENTS.md.

| Document | Source Format | Extracted? | Location |
|----------|--------------|------------|----------|
| <!-- Add rows as documents arrive --> | | | |

---

## Project Memories

Record project-specific decisions, discoveries, and constraints here.
This is the fallback location for memories when no other AGENTS.x.md file is relevant.

<!-- Add memories below this line -->

### Codesoft Label Naming Convention (TC-03, ARC 6907 Extended Pre-Proc)
- **Label directory**: `{BusintDir}\labels\custom\` (e.g., `c:\Apps\Global\BUSINT\labels\custom\`)
- **Standard naming** (1 copy): `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustomerNumber}.lab`
- **Multi-copy naming** (N copies): `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustomerNumber}_x{N}.lab`
  - Example: `OE_Wireless_Shipping_9001_Extended_WST_CUST123_x4.lab` prints 4 identical labels per container
- **Default fallback**: If no customer-specific file exists, the standard default template is used (1 copy)
- **Mechanism**: The pre-proc (`BIR_OE_Wireless_Shipping_Label_Extended.g2u`) adds a `LABEL_COPY` column to `dtData` with the parsed copy count. Sentinel reads this column and prints that many copies.
- **Lookup priority**: (1) Exact match `{base}_{CC}_{CustNo}.lab` → 1 copy. (2) Wildcard match `{base}_{CC}_{CustNo}_x*.lab` → N copies. (3) Default → 1 copy.

### TC-04: Load Manifest Weight Calculation (OE_LoadReport_MKE.rpt)
- **Report inspection (5/20/26):** XML dump via RptToXml.exe confirmed current state:
  - Tables: LOAD_PLAN (primary), V_ORDER_SHIP_TO, V_ORDER_LINES, V_STAGING_QUANTITY, V_ORDER_HEADER, V_SHIPMENT_LINES, V_PO_LINES, V_VENDOR_MASTER, V_PO_HEADER, V_PO_VENDOR_BUY
  - Subreport "ItemMaster" uses V_ITEM_MASTER for lot/bin/quantity detail per line
  - Record selection: `{LOAD_PLAN.LOAD_NO} = {?Load Number}` only — no validation filter
  - No weight calculation — `V_ORDER_LINES.WEIGHT` and `V_SHIPMENT_LINES.WEIGHT` are available (UseCount=0) but not placed
  - Report Footer is empty (no grand totals)
- **SDK limitation confirmed:** Crystal Reports Engine SDK cannot add new tables, formula fields, or SQL Expression fields. Only existing formula text and visual properties can be modified programmatically.
- **Approaches abandoned:** (1) SQL Expression subqueries -- Zen PSQL doesn't support scalar subqueries in Crystal SQL Expressions. (2) SQL Command for BOL_PACK_DTL -- adding any data source (Command or table) breaks outside PO line visibility due to Crystal join resolution issues. (3) Direct BOL_PACK_DTL table -- row multiplication + same PO visibility issue.
- **Final approach:** Weight from existing fields (`V_SHIPMENT_LINES.QTY_SHIPPED * (V_ORDER_LINES.WEIGHT / V_ORDER_LINES.QTY_ORDERED)`). Validation enforced in GAB `Click_Print_LoadManifest` before calling the report (warns if non-validated lines exist). Record selection stays as load number only -- no validation in Crystal.
- **Full instructions:** See `TC04_Crystal_Instructions.md` in workspace root.
- **GAB invocation:** `Click_Print_LoadManifest` subroutine (lines ~6118-6179), calls `RunReportPreProcessor` with param "Load Number", report path `{BusintDir}\Custom\OE_LoadReport.rpt`.
- **Production deployment:** Working copy is `OE_LoadReport_MKE.rpt`, deploy to `{BusintDir}\Custom\OE_LoadReport.rpt`.

### GAB_7546_OE_ShippingReview_Load.g2u — Shipping Dashboard
- **Validated flag fix (5/19/26):** The POL key in the `dValidation` dictionary (line ~1898) must NOT use dash separators. The grid's POL column (line ~1810) concatenates `H.PCK_NO+G.ORDER_NO+G.ORDER_LINE` without dashes, so the dictionary must match: `B.PCK_NO + B.ORDER_NO + B.ORDER_LINE`.
- **Outside PO lines:** Loaded by `LoadLoad_7551_outsidePO` (line ~8305), merged into `dtLoad0` with mode 2. This path is fragile — do NOT change the merge mode, do NOT uncomment `Validate_7551` in `LoadLoad`, and do NOT add a WHERE clause to the main query. These changes were tested and confirmed to break PO line visibility.
- **Safe changes:** INNER JOIN optimization on the main query, SELECT clause improvements (FLAG_USE_MQD qualification, TRUCK_TYPE simplification, ++ fix, SHP_HLD_FLAG IS NULL fix) are all confirmed working alongside outside PO lines.
- **Validate_7551 fix (5/20/26):** Changed from file-existence check (`V.Ambient.ScriptPath\GCG_7551_...g2u`) to table-existence check (`GCG_7551_PO_PACK`). The file check caused outside PO lines to not load when launched from GAB CE or .gaf because `V.Ambient.ScriptPath` differs from the production scripts directory. The table check is launch-context-independent.
- **Ship Load allocation validation fix (6/22/26):** `Click_Load_Ship` allocation check had a hardcoded test packing list `'0200516'` in HEAT/SERIAL_NUMBER/LOT SQL queries instead of using `'{0}'` placeholder. Validation always checked the wrong PL, allowing Ship Load to silently pass even when staged items had no allocations. Fixed by replacing hardcoded value with `'{0}'`. Also added `Case("NONE")` + `If(sSQL <> "")` guard to skip allocation check when no allocation type is configured.
