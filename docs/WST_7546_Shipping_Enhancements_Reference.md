# WST 7546 — Shipping Enhancements Reference

**Customer:** PLA (Plastics)
**Date:** 5/20/26 – 5/21/26 BS
**Application:** Shipping Dashboard w/Load Planning [7546]

---

## Files Modified

| File | Location | Description |
|------|----------|-------------|
| `GAB_7546_OE_ShippingReview_Load.g2u` | Workspace / `{BusintDir}\GAS\` | Main Shipping Dashboard GAB script |
| `BIR_OE_Wireless_Shipping_Label_Extended.g2u` | `c:\Apps\Global\BUSINT\PREPROC\` | Label pre-processor for 9001 shipping labels |
| `ShippingDashPicklist_Load_MKE.rpt` | Workspace / `{BusintDir}\Custom\` | Shipping Pick List Crystal Report (Report 95) |
| `OE_LoadReport_MKE.rpt` | Workspace / `{BusintDir}\Custom\OE_LoadReport.rpt` | Load Manifest Crystal Report |
| `TC04_Crystal_Instructions.md` | Workspace | Manual Crystal Report designer instructions for TC-04 |

---

## TC-01: Pick List Printing by Line

**Purpose:** Print Report 95 (Pick List) per individual order line instead of per order, and allow one-click assignment to pre-pick Load 9999 with immediate printing from Open Orders and Past Due tabs.

### Changes

#### 1. Context Menu — Open Orders Tab
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 862–864

Added "Assign to Pre-Pick Load & Print Pick Lists" context menu item, wired to `Assign_Picker_9999_Print`.

```gab
Gui.frmShip..ContextMenuAddItem(V.Local.sContextMenuName,
    "AssignPicker_9999_Print",0,"Assign to Pre-Pick Load && Print Pick Lists")
Gui.frmShip..ContextMenuSetItemEventHandler(V.Local.sContextMenuName,
    "AssignPicker_9999_Print","Assign_Picker_9999_Print")
```

#### 2. Context Menu — Past Due Tab
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 872–874

Same menu item for Past Due grid, wired to `Assign_Picker_Due_9999_Print`.

#### 3. New Subroutine — `Assign_Picker_9999_Print`
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 6760–6877

Assigns checked Open Orders lines to pre-pick Load 9999, prompts for printer, then loops each line and prints Report 95 with three parameters:

| Parameter | Value |
|-----------|-------|
| `OrderNo` | Order number from selected row |
| `OrderLine` | Order line from selected row |
| `LoadNo` | `9999` (pre-pick) |

```gab
F.Intrinsic.String.Split("OrderNo*!*OrderLine*!*LoadNo","*!*",V.Local.sName)
F.Intrinsic.String.Build("{0}*!*{1}*!*9999",
    v.DataTable.dtSaveOrderPicker(v.Local.iPrint).ORDER_NO!FieldValTrim,
    v.DataTable.dtSaveOrderPicker(v.Local.iPrint).ORDER_LINE!FieldValTrim,V.Local.sValue)
F.Global.BI.PrintReport(95,3,V.Local.sName,V.Local.sValue,V.Local.sPrinter,True)
```

#### 4. New Subroutine — `Assign_Picker_Due_9999_Print`
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 6879–6996

Identical logic to #3, sourced from `dtDueShip` (Past Due tab).

#### 5. `PrintPickList` — OrderLine Parameter Added
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 3437–3442

The Report 95 branch (when `ddlPicklistRpt.ItemData = 2`) now passes `OrderLine`:

| Before | After |
|--------|-------|
| `OrderNo*!*LoadNo` | `OrderNo*!*OrderLine*!*LoadNo` |

```gab
F.Intrinsic.String.Split("OrderNo*!*OrderLine*!*LoadNo","*!*",V.Local.sName)
F.Intrinsic.String.Build("{0}*!*{1}*!*{2}",
    V.Args.OrderNo,V.Args.OrderLine,V.Args.LoadNo,V.Local.sValue)
```

#### 6. Crystal Report — `ShippingDashPicklist_Load_MKE.rpt` (Report 95)
**File:** `ShippingDashPicklist_Load_MKE.rpt` | **Deploy to:** `{BusintDir}\Custom\`

The Crystal Report now accepts the `OrderLine` parameter and uses it in record selection to filter the pick list to a single order line rather than the entire order.

#### 7. `GsGCLoad_RowCellClick` — PICKLIST Column (Load Tab)
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 4788–4796

- Now reads `ORDER_LINE` and `ORDER_SUFFIX` from the clicked row
- **Blocks PO lines:** If `ORDER_SUFFIX` starts with "P", shows info message and exits
- Passes `OrderLine` to `PrintPickList`

```gab
F.Intrinsic.String.Left(V.Local.sordersuffix.Trim,1,V.Local.stemp)
F.Intrinsic.Control.If(V.Local.stemp,=,"P")
    F.Intrinsic.UI.Msgbox("Pick lists are not available for outside PO lines.","Information")
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
F.Intrinsic.Control.CallSub(PrintPickList,"OrderNo",V.Local.sOrderNo,
    "OrderLine",V.Local.sOrderLine,"ShipSchd",V.Local.sShipSchd,"LoadNo",V.Local.sLoadNo)
```

---

## TC-02: PO Pack List Printing

**Purpose:** Print PO Pack List (`GCG_7551_PO_PACK.rpt`) from the Load tab context menu with direct printer output (no preview), lot/bin suppression, and auto-chaining from the existing "Print PL w/Certs" flow.

### Changes

#### 1. Global Variables
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 431–433

| Variable | Type | Purpose |
|----------|------|---------|
| `V.Global.bSuppressPOPackLotBin` | Boolean | Controls `SUPPRESS_LOTBIN` Crystal parameter |
| `V.Global.sPOPackPrinter` | String | Target printer for direct output |

#### 2. Context Menu — Load Tab
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 946–949

Added "[Print PO Pack Report]" menu item, conditionally shown when `GCG_7551_PO_PACK` table exists (`Validate_7551`).

#### 3. `Validate_7551` — Table Existence Check
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 8621–8633

Replaced file-existence check with ODBC `TableExists` check for `GCG_7551_PO_PACK`. This ensures consistent behavior regardless of launch context (GAB CE, .gaf, or GS Menu).

#### 4. New Subroutine — `PrintPOPackForLoad`
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 8651–8712

- Filters `dtLoad` for selected PO lines (`ORDER_SUFFIX LIKE 'P%'`)
- Extracts distinct `Carrier Load Number` values as PO Pack identifiers
- Passes `PO_PACK_NUM` and `SUPPRESS_LOTBIN` parameters to Crystal
- Prints directly to `V.Global.sPOPackPrinter` without preview

```gab
V.Local.sParam.Set("PO_PACK_NUM*!*SUPPRESS_LOTBIN")
F.Intrinsic.String.Build("{0}*!*{1}",
    v.DataTable.dtLoadPOPL(v.Local.sSel(v.Local.i)).Carrier Load Number!FieldValtrim,
    V.Local.sSuppressFlag,V.Local.sValue)
F.Global.BI.PrintReport(v.Local.iRptID,3,V.Local.sParam,V.Local.sValue,
    V.Global.sPOPackPrinter,True)
```

#### 5. New Subroutine — `Click_Print_POPackList`
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 8714–8738

Standalone context-menu handler: prompts for printer, sets lot/bin suppression, calls `PrintPOPackForLoad`, then resets globals.

#### 6. `Click_Print_PL_Certs` — Auto-Chain PO Pack
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 8475–8481

After existing "Print PL w/Certs" completes, automatically chains PO Pack Report printing using the same printer with lot/bin suppressed.

---

## TC-03: Customer-Specific Label Printing & Multiple Copies

**Purpose:** Support customer-specific Codesoft label templates with `_x{N}` copy count suffix for 9001 shipping labels, passing copy count to Sentinel via `LABEL_COPY` column.

### Changes

All changes in `BIR_OE_Wireless_Shipping_Label_Extended.g2u`, subroutine `LoadData`.

#### 1. Variable Declarations
**Lines:** 28–32

Declares search/copy-count variables; defaults `iCopies` to 1.

#### 2. Customer-Specific Label Lookup with `_x{N}` Copy Count
**Lines:** 54–87

**Lookup priority:**
1. Exact match: `OE_Wireless_Shipping_9001_Extended_{CC}_{CustNo}.lab`
2. Wildcard match: `OE_Wireless_Shipping_9001_Extended_{CC}_{CustNo}_x{N}.lab`
3. Fallback: `OE_Wireless_Shipping_9001_Extended.lab` (default, 1 copy)

If a `_x{N}` file is found:
- Uses `F.Intrinsic.File.GetFileList` for wildcard search
- Parses `N` from the filename by finding `_x` before `.lab`
- Validates `N` is numeric; defaults to 1 if not

```gab
F.Intrinsic.String.InStrRev(V.Local.sBaseName,"_x",0,V.Local.iXPos)
' ... extracts substring between "_x" and ".lab" ...
F.Intrinsic.Control.If(V.Local.sXPart.IsNumeric)
    V.Local.iCopies.Set(V.Local.sXPart.Long)
```

#### 3. `LABEL_COPY` Column for Sentinel
**Lines:** 89–90

Adds `LABEL_COPY` Long column to `dtData` with the parsed copy count. Sentinel reads this column to determine how many copies to print per lot.

```gab
F.Data.DataTable.AddColumn("dtData","LABEL_COPY","Long",V.Local.iCopies)
```

---

## TC-04: Load Manifest Weight Calculation

**Purpose:** Calculate and display total weight (SO + PO) on the Load Manifest report, populate PO line weights on the Load tab grid, and add validation warnings before printing.

### GAB Changes

#### 1. Weight Calculation Variables
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 6144–6150

All declared as **String** (not Double — GAB crashes with typed Double variables or `F.Intrinsic.Math.Add` on Double).

| Variable | Purpose |
|----------|---------|
| `sTotalWeight` | Combined SO + PO weight (string) |
| `sSOWt` | SO weight from dictionary |
| `sPOWt` | PO weight from dictionary |

#### 2. Validation Warning Before Printing
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 6165–6174

Before printing the manifest, checks for non-validated rows. If found, warns the user but still prints.

```gab
v.Local.sFilterString.Set("[SELECT] = 1 AND [VALIDATED]=0")
' ... creates DataView and checks for non-validated rows ...
F.Intrinsic.UI.Msgbox("Rows exist in load(s) that are not yet flagged as validated. 
    Manifest will only show validated lines.","Warning")
```

#### 3. Weight Dictionaries — `dSOWt` and `dPOWt`
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 6182–6192

Two SQL dictionaries calculate weight per load number:

**SO Weight (`dSOWt`):**
```sql
SELECT CAST(G.LOAD_NO AS VARCHAR(10)), 
       COALESCE(SUM(I.QTY_SHIPPED * COALESCE(M.LBS,0)),0) 
FROM LOAD_PLAN G 
  LEFT JOIN V_ORDER_LINES A ON ...
  LEFT JOIN STAGING_QUANTITY H ON G.ORDER_NO = H.ORDER_NO AND G.ORDER_LINE = H.LINE 
  LEFT JOIN V_SHIPMENT_LINES I ON A.ORDER_NO = I.ORDER_NO 
      AND A.RECORD_NO = I.ORDER_REC AND I.ORDER_SUFFIX = H.SEQ 
  LEFT JOIN INVENTORY_MST2 M ON A.PART = M.PART AND A.LOCATION = M.LOCATION 
WHERE G.ORDER_SUFFIX NOT LIKE 'P%' AND G.SHIPPED <> 1 AND G.LOAD_NO > -1 
GROUP BY G.LOAD_NO
```

**PO Weight (`dPOWt`):**
```sql
SELECT CAST(G.LOAD_NO AS VARCHAR(10)), 
       COALESCE(SUM(CASE WHEN ISNUMERIC(RTRIM(P.USER_3)) = 1 
           THEN CONVERT(RTRIM(P.USER_3),SQL_DOUBLE) * COALESCE(M.LBS,0) 
           ELSE 0 END),0) 
FROM LOAD_PLAN G 
  LEFT JOIN V_PO_LINES P ON G.ORDER_NO = P.PURCHASE_ORDER AND G.ORDER_LINE = P.RECORD_NO 
  LEFT JOIN GCG_7551_PO_PACK K ON P.PURCHASE_ORDER = K.PURCHASE_ORDER AND P.RECORD_NO = K.PO_LINE 
  LEFT JOIN INVENTORY_MST2 M ON K.PART = M.PART AND P.LOCATION = M.LOCATION 
WHERE G.ORDER_SUFFIX LIKE 'P%' 
GROUP BY G.LOAD_NO
```

Columns `SO_WT` and `PO_WT` are added to `dtLoadManifest` and filled from these dictionaries.

#### 4. Total Weight Calculation and Parameter Passing
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 6199–6208

Uses `F.Intrinsic.Math.Add` with **string variables** to sum SO + PO weights. Passes two parameters to Crystal Report:

| Parameter | Value |
|-----------|-------|
| `Load Number` | Load number from selected row |
| `Total Weight` | String sum of SO_WT + PO_WT |

```gab
F.Intrinsic.Math.Add(V.Local.sSOWt,V.Local.sPOWt,V.Local.sTotalWeight)
F.Intrinsic.String.build("{0}*!*{1}","Load Number","Total Weight",V.Local.sParams)
F.Intrinsic.String.build("{0}*!*{1}",<LOAD NUMBER>,V.Local.sTotalWeight,V.Local.sValues)
```

#### 5. PO Line Weight in Load Tab Grid
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Lines:** 8611 (in `LoadLoad_7551_outsidePO`)

Added `INVENTORY_MST2` join and `WEIGHT` calculation to the outside PO query, populating the "Est. Unpackaged Weight" column on the Load tab grid:

```sql
LEFT JOIN INVENTORY_MST2 M ON K.PART = M.PART AND P.LOCATION = M.LOCATION
...
COALESCE(CASE WHEN ISNUMERIC(RTRIM(P.USER_3)) = 1 
    THEN CONVERT(RTRIM(P.USER_3),SQL_DOUBLE) * COALESCE(M.LBS,0) 
    ELSE 0 END, 0) AS WEIGHT
```

#### 6. Form Title
**File:** `GAB_7546_OE_ShippingReview_Load.g2u` | **Line:** 10

Changed from `"Shipping Dashboard"` to `"Shipping Dashboard w/Load Planning [7546]"`.

### Crystal Report Changes (Manual — see `TC04_Crystal_Instructions.md`)

| Step | Change | Location |
|------|--------|----------|
| 1 | Add `INVENTORY_MST2` to ItemMaster subreport (LEFT JOIN on PART+LOCATION) | Subreport Database Expert |
| 2 | Add `@LineWeightShared` formula: `sum(QUANTITY) * LBS` → shared variable | Subreport Formula Fields |
| 3 | Add `@ResetWeightVars` formula (reset shared vars) | Main Report Header |
| 4 | Add `@LineWeight` formula (reads shared var) | Main Report Detail Section 1 (SO only) |
| 5 | Add `{?Total Weight}` **String** parameter | Main Report Parameter Fields |
| 6 | Add `@TotalWeightDisplay` formula: `ToNumber({?Total Weight})` | Main Report Formula Fields |
| 7 | Display `{@TotalWeightDisplay} lbs` in Page Header | Main Report PageHeaderSection1 |

---

## Key Technical Notes

### GAB Double Variable Crash
GAB crashes when using typed `Double` variables with `F.Intrinsic.Math.Add`. All weight math uses **default-typed (String) variables** instead. This is consistent with the rest of the codebase (e.g., `fQty_onwater`, `fQty_OnhandlessOTW`).

### SO Weight SQL Join Path
The correct join for SO staged quantity matches the Load tab query:
- `STAGING_QUANTITY` (not `V_STAGING_QUANTITY`)
- Join: `G.ORDER_LINE = H.LINE` (not `H.SEQ`)
- V_SHIPMENT_LINES: `I.ORDER_SUFFIX = H.SEQ` (not `H.PCK_NO = I.PCK_NO`)

### PO Weight Sources
- **Staged Qty:** `V_PO_LINES.USER_3` (string, requires `ISNUMERIC` + `CONVERT`)
- **Part:** `GCG_7551_PO_PACK.PART` (not `V_PO_LINES.PART`)
- **Location:** `V_PO_LINES.LOCATION`
- **Weight per piece:** `INVENTORY_MST2.LBS`

### Validate_7551
Uses `f.ODBC.Connection!con.TableExists(GCG_7551_PO_PACK,v.Global.b7551)` instead of file-existence check for consistent behavior across all launch contexts.

---

## Deployment Checklist

| Item | Source | Destination |
|------|--------|-------------|
| GAB Script | `GAB_7546_OE_ShippingReview_Load.g2u` | `{BusintDir}\GAS\GAB_7546_OE_ShippingReview_Load.g2u` + `.sig` |
| Label Pre-Proc | `BIR_OE_Wireless_Shipping_Label_Extended.g2u` | `{BusintDir}\PREPROC\` + `.sig` |
| Pick List Report | `ShippingDashPicklist_Load_MKE.rpt` | `{BusintDir}\Custom\` (Report 95) |
| Load Manifest Report | `OE_LoadReport_MKE.rpt` | `{BusintDir}\Custom\OE_LoadReport.rpt` |
| Crystal changes (TC-04) | Per `TC04_Crystal_Instructions.md` | Manual in Crystal Reports designer |

All `.g2u` files must be signed before deployment. Use `gab-sign` skill or the sign-g2u.ps1 script.
