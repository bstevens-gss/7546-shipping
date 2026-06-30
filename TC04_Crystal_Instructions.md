# TC-04: Crystal Report Modification Instructions
## OE_LoadReport_MKE.rpt -> OE_LoadReport.rpt

**Date:** 5/20/26 BS

---

## Current State (from XML inspection)

- **Record Selection:** `{LOAD_PLAN.LOAD_NO} = {?Load Number}` -- no validation filter
- **Weight fields:** `V_ORDER_LINES.WEIGHT` and `V_SHIPMENT_LINES.WEIGHT` exist but are NOT placed
- **Staged qty:** `V_SHIPMENT_LINES.QTY_SHIPPED` -- used in `@StagingQtyTotal`
- **Report Footer:** Empty (no grand totals)
- **Subreport "ItemMaster":** Uses `V_ITEM_MASTER` (PART, LOCATION, LOT, BIN, QUANTITY)
  - Already passes shared variable: `shared numbervar QuantityTotal := sum({V_ITEM_MASTER.QUANTITY})`
  - Linked via `@AllocationStaging` = `ORDER_NO-SUFFIX-LINE` → `V_ITEM_MASTER.HEAT`
  - Fires once per detail line (both SO and PO lines)

> **NOTE:** Adding tables/commands to the **main report** breaks PO line visibility.
> Weight source (`INVENTORY_MST2.LBS`) is added to the **subreport** only,
> which is isolated from the main report's join resolution.

---

## Step 1: Add INVENTORY_MST2 to the Subreport

1. Double-click the **ItemMaster** subreport to open it in the designer
2. **Database** menu > **Database Expert**
3. Add `INVENTORY_MST2` to Selected Tables (from ODBC > Global_PLA)
4. On the **Links** tab, create links from `V_ITEM_MASTER` to `INVENTORY_MST2`:
   - `V_ITEM_MASTER.PART` = `INVENTORY_MST2.PART`
   - `V_ITEM_MASTER.LOCATION` = `INVENTORY_MST2.LOCATION`
5. Set join type to **Left Outer Join** (arrow from V_ITEM_MASTER to INVENTORY_MST2)
6. Click **OK**

> Left Outer ensures rows still appear even if INVENTORY_MST2 has no matching record.
> INVENTORY_MST2 has one row per PART+LOCATION, so no row multiplication.

## Step 2: Add Weight Shared Variable Formula in Subreport

1. Still inside the **ItemMaster** subreport
2. **Field Explorer** > right-click **Formula Fields** > **New**
3. Name it: `LineWeightShared`
4. Formula:

```
shared numberVar lineWeight;

if not IsNull({INVENTORY_MST2.LBS}) and {INVENTORY_MST2.LBS} <> 0 then
    lineWeight := sum({V_ITEM_MASTER.QUANTITY}) * {INVENTORY_MST2.LBS}
else
    lineWeight := 0;

lineWeight
```

5. Place `{@LineWeightShared}` in the **Report Footer** of the subreport
   (next to or below the existing `Sum of QUANTITY` field)
   - It can be hidden (suppress) if you don't want it visible in the subreport detail
   - **It MUST be placed** even if suppressed -- Crystal only evaluates placed formulas

> `sum({V_ITEM_MASTER.QUANTITY})` = total staged qty across all lots for this line.
> `INVENTORY_MST2.LBS` = weight per piece from inventory master.
> Grand total is NOT accumulated here -- it comes from the GAB parameter instead.

## Step 3: Add Reset Formula in Main Report Header

1. Close the subreport (click outside it to return to main report)
2. **Field Explorer** > right-click **Formula Fields** > **New**
3. Name it: `ResetWeightVars`
4. Formula:

```
shared numberVar lineWeight := 0;
""
```

5. Place `{@ResetWeightVars}` in **ReportHeaderSection1**
   - Suppress it (right-click > Format Field > check "Suppress")
   - This ensures shared variables reset on each report run

## Step 4: Add Line Weight Display Formula in Main Report (SO lines only)

1. **Field Explorer** > right-click **Formula Fields** > **New**
2. Name it: `LineWeight`
3. Formula:

```
shared numberVar lineWeight
```

4. Place `{@LineWeight}` in **Detail Section 1** (SO lines) ONLY:
   - Position to the right of existing fields
   - Suggested: Left=6300, Width=1200, Height=221
   - Right-align, format as number with 2 decimal places
   - **CRITICAL:** Place it AFTER (below or to the right of) the ItemMaster subreport
     so it evaluates after the subreport sets the shared variable

5. Do **NOT** place `{@LineWeight}` in Detail Section 2 (PO lines).
   PO lines have no subreport, so the shared variable would be stale.
   PO weight is included in the grand total calculated by the GAB script.

6. Add column header "Weight (lbs)" in the SO group header:
   - Insert > Text Object, text = "Weight (lbs)"
   - Position at Left=6300 to match the LineWeight field
   - Match existing font style (Arial 11pt, Underline)

## Step 5: Add Total Weight Parameter and Display

The grand total (SO + PO combined) is calculated in the GAB script and
passed as a **String** parameter. GAB uses `F.Intrinsic.Math.Add` with
string variables (GAB crashes with typed Double variables).

1. **Field Explorer** > right-click **Parameter Fields** > **New**
2. Name: `Total Weight`
3. Type: **String**
4. Prompting text: `Total Weight`
5. Click **OK**

6. Create a formula to convert the string to a displayable number:
   - **Field Explorer** > right-click **Formula Fields** > **New**
   - Name: `TotalWeightDisplay`
   - Formula:

```
if {?Total Weight} <> "" and {?Total Weight} <> "0" then
    ToNumber({?Total Weight})
else
    0
```

7. Edit **Text6** in PageHeaderSection1 (right-click > Edit Text):
   - Add a new line embedding the formula:

```
Load Number: {LOAD_PLAN.LOAD_NO}
Order Qty: {@OrderQtyTotal}
Staged Qty: {@StagingQtyTotal}
Total Weight: {@TotalWeightDisplay} lbs
```

   - Format `{@TotalWeightDisplay}` as Number with 2 decimal places

> The `{?Total Weight}` parameter is populated by the GAB script which
> queries INVENTORY_MST2.LBS for both SO and PO lines and sums them.
> It is passed as a string because GAB's `F.Intrinsic.Math.Add` outputs
> to string variables (typed Double variables cause crashes).

## Step 6: Record Selection -- Keep Simple

The record selection stays as:

```
{LOAD_PLAN.LOAD_NO} = {?Load Number}
```

> Validation is enforced in the GAB script BEFORE calling the report.

## Step 7: Save and Test

1. Save as `OE_LoadReport_MKE.rpt` (workspace copy)
2. Test with a load that has:
   - SO lines with known parts (verify INVENTORY_MST2.LBS values)
   - Outside PO lines (ORDER_SUFFIX starts with 'P')
   - Check: `SELECT PART, LOCATION, LBS FROM INVENTORY_MST2 WHERE PART = '900500'`
3. Verify:
   - Both SO and PO lines appear
   - Each line's weight = staged qty x INVENTORY_MST2.LBS
   - Total weight = sum of all line weights
   - PO lines are NOT broken by the INVENTORY_MST2 addition
4. When verified, deploy to `{BusintDir}\Custom\OE_LoadReport.rpt`

---

## GAB Script Changes (validation enforcement)

Validation is enforced in `Click_Print_LoadManifest` (GAB_7546_OE_ShippingReview_Load.g2u)
BEFORE calling the report. This mirrors the Ship Load validation pattern.

**What was added:** A validation check that warns the user if any selected rows
are not validated. The manifest still prints (showing all lines for the load),
but the user is notified that non-validated lines exist.

**Location:** Lines ~6148-6158 (after AcceptChanges, before the load number filter)

```
'5/20/26 BS - TC-04: validate all selected rows are validated before printing manifest
v.Local.sFilterString.Set("[SELECT] = 1 AND [VALIDATED]=0")
f.Data.DataView.Create("dtLoad","dvManifestVal",22,v.Local.sFilterString,"")
f.Data.DataView.ToDataTable("dtload","dvManifestVal","dtManifestVal",True)
F.Data.Datatable.Select("dtManifestVal","[VALIDATED]=0",v.Local.sSel)
F.Intrinsic.Control.If(v.Local.sSel,<>,"***NORETURN***")
    F.Intrinsic.UI.Msgbox("Rows exist in load(s) that are not yet flagged as validated. Manifest will only show validated lines.","Warning")
F.Intrinsic.Control.EndIf
f.Data.DataView.Close("dtLoad","dvManifestVal")
f.Data.Datatable.Close("dtManifestVal")
```

---

## Approaches Attempted and Abandoned

| Approach | Result |
|----------|--------|
| SQL Expression subqueries for BOL_PACK_DTL | Zen PSQL does not support scalar subqueries in Crystal SQL Expressions |
| SQL Command (GROUP BY) for BOL_PACK_DTL | Adding any data source to main report breaks outside PO line visibility |
| Direct BOL_PACK_DTL table addition to main report | Row multiplication + same PO visibility issue |
| Formula using V_ORDER_LINES.WEIGHT | Only works for SO lines; V_ORDER_LINES is NULL for PO lines |

## Final Architecture

- **Weight Source:** `INVENTORY_MST2.LBS` (per-piece weight), joined on PART+LOCATION
- **SO Per-Line Weight:** Subreport adds INVENTORY_MST2, calculates `qty * lbs`,
  stores in shared variable → main report `@LineWeight` reads it (Detail Section 1 only)
- **PO Per-Line Weight:** Not shown on report (no subreport in PO detail section)
- **Grand Total (SO+PO):** Calculated in GAB via two Dictionary SQL queries (SO staged qty + PO staged qty),
  summed with `F.Intrinsic.Math.Add` (string variables), passed as `{?Total Weight}` String parameter
- **PO Staged Qty Source:** `V_PO_LINES.USER_3` (same as dtLoad "Staged Qty" for PO lines)
- **Validation:** GAB script warns before printing if non-validated lines exist
- **Record Selection:** Load number only -- no validation in Crystal

---

## Key Table/Field Reference

| Field | Source | Usage |
|-------|--------|-------|
| Per-Piece Weight | `INVENTORY_MST2.LBS` | Added to subreport, joined on PART+LOCATION |
| Staged Qty (lots) | `V_ITEM_MASTER.QUANTITY` | Already in subreport (UseCount=3) |
| Staged Qty (SO line) | `V_SHIPMENT_LINES.QTY_SHIPPED` | Used in GAB SO weight SQL |
| Staged Qty (PO line) | `V_PO_LINES.USER_3` | Used in GAB PO weight SQL |
| Qty Total (shared) | `shared numbervar QuantityTotal` | Already exists in subreport |
| Line Weight (shared) | `shared numberVar lineWeight` | New -- set in subreport, read in main (SO only) |
| Total Weight (param) | `{?Total Weight}` | New **String** parameter -- calculated in GAB, passed to report |
| Total Weight (formula) | `{@TotalWeightDisplay}` | Converts string param to number for display |

## Existing Report Groups

| Level | Field | Purpose |
|-------|-------|---------|
| 1 | `LOAD_PLAN.LOAD_SEQ` | Load sequence (suppressed) |
| 2 | `LOAD_PLAN.CUSTOMER` | Customer grouping (suppressed) |
| 3 | `LOAD_PLAN.ORDER_NO` | Order header (S/O or P/O info displayed) |

## Deployment

| Location | Purpose |
|----------|---------|
| `c:\Users\bstevens\AI\Cursor\7546\OE_LoadReport_MKE.rpt` | Working copy |
| `{BusintDir}\Custom\OE_LoadReport.rpt` | Production location |
