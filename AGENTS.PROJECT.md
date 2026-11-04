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

### 7546 Carrier Pallet Label (Walmart office pallet, not S20 77)
- Freight Class grid column `PRINT_CARRIER_PALLET` caption **Carrier Labels** prints via Codesoft, not S20 / FIELD_24 / LABEL_FLAG.
- Freight Class `PRINT_LABEL` caption is **BOL Labels** (S20 pallet 77).
- Template path: `{V.Caller.BusintDir}\labels\custom\GAB_7546_CARRIER_PALLET.lab`. Size is **4x6 portrait**. Column is hidden until that file exists.
- Field contract and sample artwork: `docs/7546_shipping/GAB_7546_CARRIER_PALLET_LABEL.md`.
- Distinct from header **Walmart Labels 5055** (carton/item, Branch 1 custom / no preprocessor) and from freight-class **BOL Labels** (S20 / standard report **77**).
- **Do not treat 5055 as report 97.** Report **97** is the standard GSS Sales Order Label (`OE_Sales_Order_97.lab` + `BIR_OE_Sales_Order_Label.g2u`) — Codesoft agent Branch 2. **5055** (`GAB_5055_SO_LABEL.g2u`) is Branch 1: custom Codesoft, no BIR preprocessor, launched from GasDir like Carrier Pallet.
- **Report 53 (Shipping Label) is not core Branch 2.** Shipped `BIR_GLOBAL` sequence is Crystal only (`OE_ShipLbl.rpt`) — no native Codesoft `.lab` and no core label preprocessor. A Codesoft 53 label is always an ARC overlay:
  - **ARC 4799:** `{BusintDir}\LABELS\Custom\GCG_4799_OE_ShipLab_53.lab` + GasDir `GCG_4799_OE_ShipLab_53.g2u` (comment: “Preprocessor for BI RptID 53”). Clinic also has size variants (`_Large` / `_Medium` / `_Micro` / `_Small`) and customer forks (`GCG_4799_OE_ShipLab_53_*.g2u`).
  - **ARC 6907 Extended:** `{BusintDir}\LABELS\Custom\OE_ShippingLabel_53_Extended.lab` + `BIR_OE_ShippingLabel_53_Extended.g2u` (`iStandardReportID=53`, includes `BIR_Codesoft_ExtendedPreProc.lib`). Clinic `GAP_6907.Hooks` registers that preproc on hook **16090** (`GAPHookID` 71160). Optional twin: `OE_ShippingLabel_53_Extended_Balance.lab`.
- **Mandatory question on any 53 Codesoft request:** stop and ask whether they want **ARC 4799** (`GCG_4799_OE_ShipLab_53.lab`) or **ARC 6907 Extended** (`OE_ShippingLabel_53_Extended.lab`). Do not choose from installed files, do not default, and do not invent a core `OE_ShipLbl.lab`. Proceed only after they answer.
- **Branch 2 test (core only):** shipped `BIR_GLOBAL` ID **and** a Codesoft `.lab` sequence **and** a core preprocessor (77, 97, 9001, 1865, …). A Report Maintenance name that says “label” is not enough. 53 fails that test unless 4799 or 6907 is present.
- `PALLET_COUNT` strips leading zeros from `BOL_PALLET_NUM.PLLT_NO` (CHAR 8 `00000001`) via `ConvertToLong` so the label prints `PALLET 1 OF 2`.
- Freight Class grid is one row per order/line/pallet (`GROUP BY`), not one row per carton on `BOL_PACK_DTL`.

### Codesoft Label Naming Convention (TC-03, ARC 6907 Extended Pre-Proc)
- **Label directory**: `{BusintDir}\labels\custom\` (e.g., `c:\Apps\Global\BUSINT\labels\custom\`)
- **Report 53 in this set:** default template `OE_ShippingLabel_53_Extended.lab` (clinic copy verified OLE `D0-CF-11-E0`, 257536 bytes). Not the same file as ARC 4799 `GCG_4799_OE_ShipLab_53.lab`.
- **Standard naming** (1 copy): `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustomerNumber}.lab`
- **Multi-copy naming** (N copies): `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustomerNumber}_x{N}.lab`
  - Example: `OE_Wireless_Shipping_9001_Extended_WST_CUST123_x4.lab` prints 4 identical labels per container
- **Default fallback**: If no customer-specific file exists, the standard default template is used (1 copy)
- **Mechanism**: The pre-proc (`BIR_OE_Wireless_Shipping_Label_Extended.g2u`) adds a `LABEL_COPY` column to `dtData` with the parsed copy count. Sentinel reads this column and prints that many copies.
- **Lookup priority**: (1) Exact match `{base}_{CC}_{CustNo}.lab` → 1 copy. (2) Wildcard match `{base}_{CC}_{CustNo}_x*.lab` → N copies. (3) Default → 1 copy.
- **Company dest (Codesoft agent):** `{stem}_Extended_{CompanyCode}.lab` when they want a clinic/company file without a customer number. Fixture: source `PU_PO_Receipt_2818_Extended.lab` → dest `PU_PO_Receipt_2818_Extended_UDF.lab` (4x6 landscape, sample at `docs/7546_shipping/_work/codesoft_samples/PU_PO_Receipt_2818_Extended_sample.png`). Do not overwrite the shared Extended file. Stock `BIR_PU_PO_Receipt_Label_Extended.g2u` still prints the default until wired.
- **1835 WIP FG (Codesoft agent):** dest `SF_WIP_FG_1835_Extended_UDF.lab` (4x6 landscape). **Branch 2: first clone, then match the sample file.** Best-match DataMatrix (`Symbology=120`, `Code2D.ModuleX`) and snap cells. Do not add a second HR Text on a barcode that already prints interpretation. Designer blue `ABC123` on the Bin bars is the `BIN` binding preview, not a Text. Sample: `docs/7546_shipping/_work/codesoft_samples/SF_WIP_FG_1835_sample.png`.
- **2818 Standard RD convert:** source `LABELS\PU_PO_Receipt_2818.lab` already places `USER_ID` / `CurrDate` past `LabelWidth`. Do not save that source. Clamp dest / placement / REPX so nothing runs off the page (`docs/7546_shipping/_work/rd-label/pu-po-2818/`).

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
- **Multi-BOL/PL print fix (7/23/26):** `Click_Print_BOL` and `Click_Print_PL` only printed the last BOL/PL when multiple distinct values existed. Root cause: `CallWrapperSync(910060)` and `CallWrapper.Run("PL")` return before the print pipeline fully processes. In a tight loop, the next call overwrites the previous call's staging data. Fix: (1) moved `BlockEvents`/`UnBlockEvents` to wrap only the DataView extraction, not the print loop; (2) added `F.Intrinsic.UI.Sleep(3)` between iterations. **Critical learning:** `F.Intrinsic.UI.Sleep()` pumps the Windows message loop (allowing print pipeline to complete), while `F.Intrinsic.UI.SleepMS()` is a hard thread block that starves the message pump — `SleepMS` did NOT fix the issue, only `Sleep` did.
- **BOL print delay visible (8/20/26):** `Click_Print_BOL` Sleep was gated on `If(i < sSel.UBound)` after Split; that property compare can skip the delay. Bound is now stored in `iCnt` (Long). Between BOLs: wait dialog + **5 × `Sleep(1)`** with `ChangeWaitStatus` countdown and `DoEvents`. 3s was not enough (first BOL printed blank); 10s was longer than needed. Catch also closes the wait dialog.
- **Pro/Tracking vs Ship From scope (8/20/26):** Pro Number and Tracking Number copy only to rows with the same Packing List (`PCK_NO`). Empty packing list is blocked (`Cannot edit ... no shipment exists for this line.`). One `SHIPMENT_HEADER` UPDATE by `PCK_NO`; one `BOL_HEADER` UPDATE by the edited row's `WAYBILL_NO` if present. User values go through a local `.PSQLFriendly` (`sSafe`) before SQL. BOL Ship From still copies to every `dtLoad` row with the same Load Number (not 0/9999) and updates every waybill on that load.
- **S15 add to existing pallet (8/26/26):** Product SHP730, not 7546 GAB. Second S15 of the same order/line onto the same pallet **fails when Field_7 (to-bin) is unchanged** (PLA always DPICK). `4120` keys TEMP by LOT+BIN+HEAT+SERIAL; WIR200 maps BIN from Field_7, not Field_22. Same to-bin → reuse SEQ → `4100` insert → **3692**. WIR200 `ROLLBACK-BIN` overwrites 630 with 0 (audit Successful upload / error 0). Different Field_7 bumps SEQ (660). Empty lot and carton 0 are not the fail condition. Workaround: new pallet. R&D: update-or-bump SEQ on S15 add; do not mask 630.
- **Staged suffix e2e (8/26/26):** Named loads 242 then 243, order `0010967` lines 0050/0090, part `900500`, **Create New Pallet**. Virgin `ORDER_HEADER.ORDER_SUFFIX` stayed `0000` through stage. `SHIPMENT_HEADER`: PL `1200922` suffix `0000`, then PL `1200923` suffix `0001`. Ship 243 (S40 `000005745`): status `1`, header next-seq `0002`. Ship 242 (S40 `000005746`): status `1`; header **stayed `0002`** because shipped suffix `0000` is below next-seq. Spec: `docs/7546_shipping/_work/assert-suffix.ps1`.
- **Ship Load LOAD_PLAN suffix (8/26/26):** `Click_Load_Ship` does **not** write `ORDER_HEADER.ORDER_SUFFIX` (S40/SHP710 still does). Unshipped `LOAD_PLAN` rows for the same order use SHP710’s rule: packing suffix from `V_SHIPMENT_HEADER` vs grid `CURRENT_ORDER_SUFFIX`; if packing >= header next-seq set packing+1, else header; never decrease. Skip unshipped lines that already have a staged packing (`V_STAGING_QUANTITY` + `V_SHIPMENT_HEADER.SHP_STATUS='0'`). Formula spec: `assert-suffix.ps1 -Phase formula`.
- **Ship Load picked flag (10/7/26):** `Click_Load_Ship` sets `LOAD_PLAN.PICKED = 1` only on a line that passed the Ship Load checks: load not 0 or 9999, validated, ship date set, packing list present (or outside PO), carrier has no shipping interface, and staged qty is fully allocated. The update keys that line (order, suffix, line, load), same as `SHIPPED = 1`. If any checked line fails a check, Ship Load exits before either flag is written. Other lines on the load are left alone.
- **Shipped Orders pro / tracking / BOL (10/2/26):** `gvShipped` shows `V_SHIPMENT_HEADER.PRO_NO`, `TRACKING_NO`, and `WAY_BILL` (caption BOL; same value as `BOL_HEADER.WAYBILL_NO`) from the A record (`RECORD_TYPE = 'A'`). All three are read-only. Edits stay on the Load tab.
- **Shipped Orders carrier / SCAC (10/2/26):** `gvShipped` also shows read-only Carrier Code (`V_SHIPMENT_HEADER.CARRIER_CD`) and SCAC (`V_OE_CARRIER.SCAC`) for that A record. SCAC is the carrier row for `CARRIER_CD` and `SRVC_TYPE`.
- **Shipped Orders Load # (10/8/26):** `gvShipped` shows read-only Load # from the shipped `LOAD_PLAN` row (`SHIPPED = 1`, load not 0 or 9999) matched on order, `ORDER_REC` to `ORDER_LINE`, and suffix. More than one match shows the highest load number. A line with no shipped load stays blank.
- **Shipped Orders container details (10/2/26):** Packing No on `gvShipped` opens `frmLpn`, titled Container Details. Pallets tab lists distinct `V_BOL_PACK_DTL.PLLT_NO` for the clicked packing list (caption Pallet No) and reads `USR_DFND_NO` from `V_BOL_PALLET_NUM` on that list. Cartons tab lists distinct `V_BOL_PACK_DTL.CRTN_NO` for that same packing list (caption Carton No) and reads `USER_DFND_NO` and `TRACKING_NO` from `V_BOL_CARTON_NUM` on that list. Both grids are read-only. Load and Staging packing-list clicks still open the core packing list.
- **Pro Number sets BOL Ship From (10/20/26):** Saving Pro Number on the Load tab still writes `SHIPMENT_HEADER.PRO_NO` for that packing list and `BOL_HEADER.PRO_NO` for the edited row’s BOL. When that BOL exists, the script takes `TOP 1 BIN` from `BOL_PACK_DTL` for the packing list (`RTRIM(BIN) <> ''`, `ORDER BY BIN`). The first character picks `V_LOCATION_ADDRESS`: `L` blank (Lewisville), `D` = `DT` (Denton), `E` = `D2` (Denton 2). That location’s name and address are written to that BOL only, and every Load row showing the same BOL is refreshed. No bin, a blank bin, or any other first character leaves BOL Ship From unchanged. The manual BOL Ship From picker still sets every BOL on the load. Shipped Orders stays read-only.
- **Cust Due Date / Ready To Ship (10/20/26):** Walmart required date belongs on `ORDER_LINES.MUST_DLVR_BY_DATE`. Open Orders already shows that field as **Cust Due Date** (ship-schedule lines use `CUST_DUE_DATE` when `FLAG_USE_MQD = 'Y'`). **Ship Date** is `DATE_ITEM_PROM`. Ready To Ship stays “remaining on-hand covers open qty,” and On Hold still wins. Only **UDF Running Total** (dropdown item 4) consumes on-hand by Ship Date, then Cust Due Date, then order, then line. An earlier Ship Date still takes the quantity ahead of a later Ship Date. A blank Ship Date or Cust Due Date sorts after every real date. Running Total (item 1) and the allocation modes keep table order (`DATE_ITEM_PROM`, order, line). The Due tab is still Ship Date on or before today. Writing the Walmart date, and Mary’s SO Dashboard, are outside this script.
- **Onsite Nov 3 (11/3/26):** Refresh Load reloads only the Load tab. Qty On Hand (Full) is the quantity before the running total depletes it. On Load shows the load number, including 0 and 9999. A real load number wins when the line is also on one. Blank means there is no unshipped load row. Assign Picker paints 0 on a blank On Load cell, and Assign to Pre-pick paints 9999 when the cell is blank or 0. The same line on the other tab is updated too. Apply Note writes `GAB_4167_SO_NOTES` for checked visible Open Orders or Past Due lines. Apply ship date to paperwork writes the Load Ship Date already on a checked visible line onto the packing list, shipment, BOL, and load. The line does not have to be marked Picked. Packing-list prints go BOL then packing list, with the same five-second wait the BOL print uses. Bulk checks use VISROW so a filter does not act on hidden checked rows. Picker counts for Dashboard Designer are the four views in `docs/7546_shipping/V_GAB_7546_PICK_DISPATCH.sql`. Last update is the save stamp, not pick-complete time. No score target. The user ran this file on PLA on 11/3/26 and created the four views. Picking Status is imported on common as dashboard 5010, Management group. At 8:45 PM the open viewer shows full dates. Load 172 is a Load with 2 lines still open, 0 picked, ship date 2/23/2026, oldest pick-by 4/10/2025, and Any still assigned 0. Who is picking oldest dates are 4/8/2025. Today's picked and shipped counts are 0. Later the same night they chose a list, bars, and big numbers, for the desktop viewer. `GAB_7546_Pick_Status.bixp` is that desktop package. `GAB_7546_Pick_Monitor.bixp` is the monitor package: six totals, the bar, and the short Who is picking list. Queue days start the day Ready to Pick is turned on, in whole days, and the screen shows the longest wait with Max. The clock time is saved with that day and shown as Released. A later save does not move the time. Lines already released have no time until marked again. A later save does not move that day, and moving the line to another load keeps it. Lines already released stay blank until marked again. The release table is `GAB_7546_PICK_RELEASE`. The shipping screen creates that table and rebuilds the four views when the queue column is missing. It does not drop the table. The shipping screen was opened again at 10:06 PM after the column check was fixed. Ready to Pick was not clicked. The view was not read back. Neither dashboard file is on the open viewer until it is imported. A monitor is the same viewer on a large screen. It is not the old Displays menu and not the KPI Dashboard.
