---
name: Split SO Line Feature
overview: Add a "Split SO Line" context menu item to Open Orders and Due Today/Past Due tabs in the Shipping Dashboard. When invoked, it shows a modal form where users can specify a split quantity and new due date for selected lines, creating new SO lines via ORDADCMD, updating original lines and setting new line promise dates via a single Sales.UpdateOrderLinesByFile CallWrapper call with a two-line CSV file, and enforcing business rules against ship schedules and staged shipments. Also includes an "Edit Sales Order" context menu item to open the selected order in the classic Order Entry screen.
todos:
  - id: screensu
    content: Add frmSplitLine form definition in ScreenSU block (form, grid, buttons, label, events)
    status: completed
  - id: context-menu
    content: Add 'Split SO Line' context menu item to CTXOPEN and CTXDUE in SetContextMenus subroutine
    status: completed
  - id: split-click
    content: "Create SplitSOLine_Click subroutine: collect checked rows, build dtSplitLines (global scope), configure grid, show modal form with UI reset"
    status: completed
  - id: split-save
    content: "Create SplitSOLine_Save subroutine: validate, check locks/ship schedule/staging, build upload files, call ORDADCMD, update new line user field (dynamic lookup from OE_USER_FLDS_LN for 'SPLIT FROM LINE' label)/DATE_ORDER via SQL, update original line qty/price/weight and new line DATE_ITEM_PROM via single Sales.UpdateOrderLinesByFile CallWrapper with two-line CSV"
    status: completed
  - id: split-cancel-unload
    content: Create SplitSOLine_Cancel and frmSplitLine_UnLoad subroutines for form dismissal
    status: completed
  - id: validation-ship-sched
    content: "Add validation: block split when ship schedule exists for order line (V_OE_SHIP_SCHED)"
    status: completed
  - id: validation-staging
    content: "Add validation: block split when order line is part of a staged shipment (STAGING_QUANTITY)"
    status: completed
  - id: promise-date-callwrapper
    content: Move DATE_ITEM_PROM update from direct SQL to Sales.UpdateOrderLinesByFile CSV position 16 via second line in upload file
    status: completed
  - id: price-format
    content: Format price with 6 decimal precision (0.000000) per CallWrapper spec for original line CSV
    status: completed
  - id: edit-so-context-menu
    content: Add 'Edit Sales Order' context menu item below 'Split SO Line' on Open Orders and Past Due grids
    status: completed
  - id: edit-so-click
    content: "Create EditSalesOrder_Click subroutine: IPM permission check, lock check, launch Sales.EditSalesOrderInClassicScreen"
    status: completed
  - id: user-field-lookup
    content: "Dynamic user field lookup: search OE_USER_FLDS_LN for label 'SPLIT FROM LINE', map KEY_ID to USER_x column. Skip UPDATE if not configured."
    status: completed
  - id: shared-dict-optimization
    content: "Shared dictionary optimization: consolidate duplicate dictionary SQL queries from LoadOpenOrders and LoadLoad into LoadSharedDictionaries/CloseSharedDictionaries subroutines"
    status: completed
isProject: false
---

# Split SO Line (Order Parser) Feature

## Summary

Add a right-click context menu item "Split SO Line" on the **Open Orders** (`CTXOPEN` / `GsGCAllShip`) and **Due Today & Past Due** (`CTXDUE` / `GsGCDue`) tabs. This launches a modal form displaying the selected lines in a grid where users can enter a split quantity and new due date. On save, the system creates new SO lines via `ORDADCMD`, then uses a single `Sales.UpdateOrderLinesByFile` CallWrapper call with a two-line CSV file to both update the original line (qty/price/weight) and set the new split line's promise date (`DATE_ITEM_PROM`) at CSV position 16. Business rules enforce blocks against ship schedules and staged shipments.

## File Changed

- `[GAB_7546_OE_ShippingReview_Load.g2u](GAB_7546_OE_ShippingReview_Load.g2u)` -- the sole script in this workspace

## Reference Pattern

From `[GCG_6644_mobile_OE_Backorder_Parts.g2u](c:\Apps\Global\PLUGINS\GAB\GAS\GCG_6644_mobile_OE_Backorder_Parts.g2u)`:

- **New line creation**: Build a fixed-width upload file, call `F.Intrinsic.Task.Launchgsssync("ORDADCMD","-c",sParam)` where sParam = `CompanyCode + User(8-padded) + FilePath`
- **Next line number**: `SELECT TOP 1 record_no FROM v_order_lines WHERE order_no = '{0}' AND record_no < 700 ORDER BY record_no DESC`, take Left3, add 1, LPad to 3

From `[Global Shop Solutions — Sales.UpdateOrderLinesByFile.pdf](Global Shop Solutions — Sales.UpdateOrderLinesByFile.pdf)`:

- **Line updates**: Build comma-delimited file with one or more CSV lines and invoke via CallWrapper
- **CSV position 16**: Promise date (DATE_ITEM_PROM), format YYYYMMDD

## Changes

### 1. ScreenSU -- Add `frmSplitLine` modal form (~line 342)

New form with:

- `**frmSplitLine`** (BaseForm, ~800x600 pixels, caption "Split SO Line", not sizeable, UnLoad event)
- `**GsGCSplit**` (GsGridControl, docked, for displaying selected rows)
- `**cmdSplitSave**` (Button, "Save")
- `**cmdSplitCancel**` (Button, "Cancel")
- `**lblSplitStatus**` (Label, status messages)

Grid columns (from the selected rows):

**Read-only context columns:**

- CUSTOMER -- customer number
- NAME_CUSTOMER -- customer name
- ORDER_NO -- sales order number
- RECORD_NO -- line number (display, 3-char)
- PART / DISPLAY_PART -- part number
- DESCRIPTION -- part description
- SHIP_ID -- ship-to ID
- CITY_SHIP -- ship-to city
- STATE_SHIP -- ship-to state
- NAME_CUSTOMER_SHIP -- ship-to name
- QTY_BO -- current open quantity (read-only)

**Editable columns (yellow background):**

- **QTY_SPLIT** (numeric, yellow background) -- user enters split quantity; must be > 0 and < QTY_BO
- **NEW_DUE_DATE** (date picker, yellow background) -- user enters new due date for the split line

### 2. SetContextMenus -- Add "Split SO Line" item (~line 776)

Inside the existing `If(sControl = "GsGCAllShip" OR sControl = "GsGCDue")` block, add:

```
Gui.frmShip..ContextMenuAddItem(sContextMenuName,"SplitSOLine",0,"Split SO Line")
Gui.frmShip..ContextMenuSetItemEventHandler(sContextMenuName,"SplitSOLine","SplitSOLine_Click")
```

This places it on both CTXOPEN and CTXDUE menus, available regardless of mobile picklist settings.

### 3. Preflight -- Global variable (~line 425)

```
V.Global.bSplitSaved.Declare(Boolean,False)
```

Tracks whether a successful save occurred so the main form knows to refresh grids on return.

### 4. New Subroutine: `SplitSOLine_Click`

Context menu handler. Flow:

1. **Permission check**: `F.Global.Security.CheckUserAccessIPM(132,1,bHasAccess)` — Order Entry > Edit > Sales Orders (level 1 required). If denied, show message and exit.
2. Determine active tab via `V.Screen.frmShip!tabShip.SelectedTab` to know which DataTable to query (dtAllShip vs dtDue)
3. Use `F.Data.Datatable.Select("dtAllShip","ASSIGNPICKER = 1",sSel)` to get checked rows
3. If no rows selected, show message and exit
4. Build `dtSplitLines` DataTable **with global scope** (`F.Data.DataTable.Create("dtSplitLines",True)`) with columns:
  - **Visible read-only**: CUSTOMER, NAME_CUSTOMER, ORDER_NO, RECORD_NO, ORDER_LINE, PART, DISPLAY_PART, DESCRIPTION, SHIP_ID, CITY_SHIP, STATE_SHIP, NAME_CUSTOMER_SHIP, QTY_BO
  - **Visible editable**: QTY_SPLIT (Float, default 0), NEW_DUE_DATE (Date -- no default value parameter, avoids DateTime parse error)
  - **Hidden (needed for save)**: LOCATION, PRODUCT_LINE, ORDER_SUFFIX, WEIGHT, PRICE, COST
5. Populate from the checked rows using source DataTable field accessors
6. Bind to `GsGCSplit` grid view
7. Set column properties:
  - QTY_SPLIT and NEW_DUE_DATE: `AllowEdit=True`, `ReadOnly=False`, `CellBackColor=V.Enum.ThemeColors!ColorYellow.Highlight`
  - Read-only columns: `AllowEdit=False`, `ReadOnly=True`
  - Hidden columns: `Visible=False`
8. **Reset UI state** before showing (fixes stale button/label state on re-open):
  - `V.Global.bSplitSaved.Set(False)`
  - `lblSplitStatus.Caption("Enter Qty to Split and New Due Date. Yellow cells are editable.")`
  - `cmdSplitSave.Enabled(True)`
  - `cmdSplitCancel.Enabled(True)`
9. Show `frmSplitLine` as modal dialog (Disable parent -> Show -> WaitForDismiss -> Enable parent)

### 5. New Subroutine: `SplitSOLine_Save` (cmdSplitSave_Click)

Save handler. For each row in `dtSplitLines`:

**A. First-pass validation loop (all rows, before confirmation prompt):**

- QTY_SPLIT > 0 (ExitSub with message if not)
- QTY_SPLIT < QTY_BO -- strict less-than per spec (ExitSub with message if not)

**B. Confirmation prompt:**

- `"You are about to split {N} line(s). Continue?"` -- MsgBox Yes/No
- Disable Save and Cancel buttons during processing

**C. Per-line processing loop:**

For each row, the following checks and operations are performed in order:

**C1. Order Lock check:**

- Call existing `OrderLocked` subroutine
- If locked, show message with locking user, set `bSkip = True`

**C2. Ship Schedule validation (7546 Hultec 03/23/2026):**

- Query: `SELECT COUNT(*) FROM V_OE_SHIP_SCHED WHERE ORDER_NO = '{0}' AND ORDER_LINE = '{1}'`
- Any record (open or closed) blocks the split
- If found, show message, set `bSkip = True`

**C3. Staged Shipment validation (7546 Hultec 03/23/2026):**

- Query: `SELECT COUNT(*) FROM STAGING_QUANTITY WHERE ORDER_NO = '{0}' AND LINE = '{1}'`
- Any record blocks the split
- If found, show message, set `bSkip = True`

**C4. Get next line number** (per reference pattern):

```sql
SELECT TOP 1 record_no FROM v_order_lines
WHERE order_no = '{0}' AND record_no < '700'
ORDER BY record_no DESC
```

Take Left3, add 1, LPad "0" to 3 chars. Append "0" for 4-char RECORD_NO.

**C5. Fetch original line data:**

```sql
SELECT PRICE, COST, DATE_ORDER, QTY_ORDERED, WEIGHT
FROM ORDER_LINES WHERE ORDER_NO = '{0}' AND RECORD_NO = '{1}'
```

- Retrieves PRICE, COST for the upload file
- Retrieves DATE_ORDER to copy to the new line
- Retrieves QTY_ORDERED and WEIGHT to compute unit weight and recalculate remaining weight:
  - `fUnitWeight = fOrigWeight / fLineQty`
  - `fLineQty = fLineQty - fQtySplit` (remaining quantity)
  - `fNewWeight = fUnitWeight * fLineQty` (recalculated weight for original line)

**C6. Build fixed-width upload file and call ORDADCMD:**

- Build upload text per fixed-width format (see Upload File Format section below)
- Write to `{FilesDir}\SPLIT_{OrderNo}_{i}`
- Build param: `CompanyCode + User(8-padded) + FilePath`
- `F.Intrinsic.Task.Launchgsssync("ORDADCMD","-c",sParam)`
- Defensive cleanup: check `F.Intrinsic.File.Exists` before `DeleteFile`

**C7. Update new line's user field** with original line number for traceability:

Dynamic lookup from `dtUserFields` (loaded at startup from `V_OE_USER_FLDS_LN`):

1. Search `dtUserFields` for a row where `LABEL` = `'SPLIT FROM LINE'` (trimmed comparison, LABEL is CHAR(20) with trailing spaces)
2. If found, extract `KEY_ID` (CHAR(2), e.g., "05"), convert to integer, build column name as `USER_` + integer (e.g., `USER_5`)
3. If **not found** (no "SPLIT FROM LINE" label configured), **skip the UPDATE entirely** — the split proceeds without writing to any user field

The lookup happens **once** before the `For` loop, stored in `V.Local.sUFColumn`. The UPDATE is wrapped in a conditional:

```
F.Intrinsic.Control.If(V.Local.sUFColumn,<>,"")
    F.Intrinsic.String.Build("UPDATE ORDER_LINES SET {0} = '{1}' WHERE ORDER_NO = '{2}' AND RECORD_NO = '{3}'", V.Local.sUFColumn, V.Local.sRecNo, V.Local.sOrderNo, V.Local.sNewRecNo, V.Local.sSQL)
    F.ODBC.Connection!con.Execute(V.Local.sSQL)
F.Intrinsic.Control.EndIf
```

**C8. DATE_ITEM_PROM on new line** (commented out -- now handled via CallWrapper):

```
' Direct SQL commented out; DATE_ITEM_PROM now set via Sales.UpdateOrderLinesByFile CSV position 16.
' UPDATE ORDER_LINES SET DATE_ITEM_PROM = '{newDueYYYYMMDD}', MUST_DLVR_BY_DATE = '{newDueYYYYMMDD}'
' WHERE ORDER_NO = '{orderNo}' AND RECORD_NO = '{newRecordNo}'
```

**C9. Copy DATE_ORDER from original line to new line:**

```sql
UPDATE ORDER_LINES SET DATE_ORDER = '{origDateOrder}'
WHERE ORDER_NO = '{orderNo}' AND RECORD_NO = '{newRecordNo}'
```

**C10. Update original line and set new line promise date via Sales.UpdateOrderLinesByFile CallWrapper:**

Build a **two-line CSV file** -- both lines processed by a single CallWrapper invocation:

**CSV Line 1** -- Update original line (qty, formatted price, weight):

```
L,{OrderNo},{OrigLineNo(3)},,,{RemainingQty},{FormattedPrice},,,,,,,,,,,,,,,,,{NewWeight},,,
```

- Price formatted with `F.Intrinsic.String.Format(fPrice,"0.000000",sMsg)` -- 6 decimal precision per CallWrapper spec

**CSV Line 2** -- Set DATE_ITEM_PROM on new split line at position 16:

```
L,{OrderNo},{NewLineNo(3)},,,,,,,,,,,,,{PromiseDateYYYYMMDD},,,,,,,,,,,
```

- No price sent for the new line
- Promise date uses `FormatYYYYMMDD`

Lines concatenated with `V.Ambient.Newline` before writing to file.

- Write to `{FilesDir}\SPLIT_UPD_{OrderNo}_{i}.txt`
- Invoke CallWrapper:

```
  F.Global.Callwrapper.New("SplitUpd","Sales.UpdateOrderLinesByFile")
  F.Global.Callwrapper.SetProperty("SplitUpd","Company",V.Caller.CompanyCode)
  F.Global.Callwrapper.SetProperty("SplitUpd","CallingProgram","GAB_7546_OE_ShippingReview_Load")
  F.Global.Callwrapper.SetProperty("SplitUpd","Screenless",1)
  F.Global.Callwrapper.SetProperty("SplitUpd","InputFileName",sFileName)
  F.Global.CallWrapper.Run("SplitUpd")
  

```

- Check Status property; show warning if not "Success"
- Defensive cleanup: check `F.Intrinsic.File.Exists` before `DeleteFile`

**D. After all rows processed:**

- Set `V.Global.bSplitSaved = True`
- Update status label: "Split complete."
- Hide `frmSplitLine`

**E. Error handling (Catch block):**

- Show error details with project, subroutine, error number/description, GAB version
- Re-enable Save and Cancel buttons
- Update status label: "An error occurred. Review and try again or Cancel."

### 6. New Subroutine: `SplitSOLine_Cancel` (cmdSplitCancel_Click)

- Set `V.Global.bSplitSaved = False`
- Close DataTable `dtSplitLines` if exists
- Hide form: `Gui.frmSplitLine..Visible(False)`

### 7. New Subroutine: `frmSplitLine_UnLoad`

- `Gui.frmSplitLine..Visible(False)` (standard modal child unload pattern)

### 8. Grid Serialization for Split SO Line

Saves and restores the user's grid layout (column widths, order, sort, filter) for `GsGCSplit` using the GSS Registry with key `GVSPLIT`.

**ScreenSU**: Context menu `CTXSPLIT` created and attached to `GsGCSplit` with "Reset Grid Serialization" item linked to `ResetSplitGridColumns` handler.

**SplitSOLine_Click (Deserialize)**: After `BestFitColumns`, reads saved layout from registry and applies via `Deserialize`. First-time users get auto-fit columns; returning users get their saved layout.

```
F.Global.Registry.ReadValue(V.Caller.User,V.Caller.CompanyCode,"GVSPLIT",7546,1000,6,"",V.Local.sSer)
If sSer.Trim <> "" -> Gui.frmSplitLine.GsGCSplit.Deserialize(sSer)
```

**frmSplitLine_UnLoad (Serialize)**: Saves current grid layout to registry before hiding the form.

```
Gui.frmSplitLine.GsGCSplit.Serialize("gvSplit",V.Local.sSer)
F.Global.Registry.AddValue(V.Caller.User,V.Caller.CompanyCode,"GVSPLIT",7546,1000,...)
```

**ResetSplitGridColumns**: Clears saved layout by writing empty string to registry. Takes effect on next form open.

### 10. Context Menu: "Edit Sales Order" (~line 879)

Added below "Split SO Line" in the same `If(sControl = "GsGCAllShip" OR sControl = "GsGCDue")` block:

```
Gui.frmShip..ContextMenuAddItem(sContextMenuName,"EditSalesOrder",0,"Edit Sales Order")
Gui.frmShip..ContextMenuSetItemEventHandler(sContextMenuName,"EditSalesOrder","EditSalesOrder_Click")
```

### 11. New Subroutine: `EditSalesOrder_Click`

Context menu handler for editing a sales order in the classic Order Entry screen (ORD200). Flow:

1. **Permission check**: `F.Global.Security.CheckUserAccessIPM(132,1,bHasAccess)` — Order Entry > Edit > Sales Orders (level 1 required). If denied, show message and exit.
2. **Determine active tab** via `V.Screen.frmShip!tabShip.Tab`:
   - Tab 0 = Open Orders (`dtAllShip`)
   - Tab 1 = Due Today & Past Due (`dtDueShip`)
   - Any other tab: show message and exit
3. **Get selected rows** via `F.Data.Datatable.Select` with `ASSIGNPICKER = 1`:
   - If `***NORETURN***`: show "No lines selected" message and exit
4. **Extract ORDER_NO** from the first selected row only (single order edit)
5. **Check OrderLocked**: Call existing `OrderLocked` subroutine. If locked, show message with locking user and exit.
6. **Disable parent tab** to prevent concurrent actions
7. **Launch CallWrapper**:

```
F.Global.Callwrapper.New("EditSO","Sales.EditSalesOrderInClassicScreen")
F.Global.Callwrapper.SetProperty("EditSO","Company",V.Caller.CompanyCode)
F.Global.Callwrapper.SetProperty("EditSO","SalesOrder",V.Local.sOrderNo)
F.Global.CallWrapper.Run("EditSO")
```

8. **Re-enable parent tab** — no automatic grid refresh; user refreshes manually

### 12. Dynamic User Field Lookup for Split Traceability (7546 Hultec 03/25/2026)

Replaced hardcoded `USER_5` column with a dynamic lookup from `OE_USER_FLDS_LN` via the existing `dtUserFields` DataTable (loaded at startup by `GetUserFields`).

**Lookup logic** (runs once before the save loop in `SplitSOLine_Save`):

1. Loop through `dtUserFields` rows (5 max, one per user field)
2. Compare each row's `LABEL` (trimmed via `FieldValTrim`) against `"SPLIT FROM LINE"`
3. If found: extract `KEY_ID` (CHAR(2)), convert to integer via `F.Intrinsic.Math.Add(KEY_ID, 0, iUFKeyID)`, build column name `USER_{iUFKeyID}` (e.g., KEY_ID "05" -> `USER_5`)
4. If not found: `sUFColumn` stays empty, and the UPDATE is **skipped entirely** — the split proceeds without writing to any user field

**Variables**: `V.Local.sUFColumn` (resolved column name or ""), `V.Local.iUF` (loop counter), `V.Local.iUFKeyID` (integer KEY_ID)

**Conditional UPDATE** inside the per-line processing loop:

```
F.Intrinsic.Control.If(V.Local.sUFColumn,<>,"")
    F.Intrinsic.String.Build("UPDATE ORDER_LINES SET {0} = '{1}' WHERE ORDER_NO = '{2}' AND RECORD_NO = '{3}'",V.Local.sUFColumn,V.Local.sRecNo,V.Local.sOrderNo,V.Local.sNewRecNo,V.Local.sSQL)
    F.ODBC.Connection!con.Execute(V.Local.sSQL)
F.Intrinsic.Control.EndIf
```

### 13. Shared Dictionary Loading Optimization (7546 Hultec 03/25/2026)

Consolidated six duplicate dictionary SQL queries that were running identically in both `LoadOpenOrders` and `LoadLoad` into shared subroutines:

**New Subroutine: `LoadSharedDictionaries`** — Executes each lookup SQL once:

- `dCustOrderNotes` — `V_CUST_ORDER_NOTES` (with inner try/catch for missing view)
- `dNotes` — `GAB_4167_SO_NOTES` (customer SO notes)
- `dText` — `ORDER_LN_TEXT WHERE ORDER_TYPE = 9999` (order line text)
- `dShortDesc` / `dLongDesc` — `OE_Carrier` (carrier descriptions, via `dtCarrDesc` temp DataTable)
- `d90` — Location 90 / on-water inventory (branch-dependent on `ddlCalculateMRPOnHand.ItemData`)

**New Subroutine: `CloseSharedDictionaries`** — Closes all six dictionaries with a guard for `dCustOrderNotes` (skips close if it failed to load).

**Modified `LoadOpenOrders` and `LoadLoad`** — Removed all `CreateFromSQL`, `SetDefaultReturn`, and `Close` calls for the six shared dictionaries. Retained only `AddColumn` + `FillFromDictionary` calls using the pre-loaded dictionaries. The `d90` fill still uses the correct key column (`PARTLOC` vs `PART`) based on the dropdown selection.

**Wired into both call sites**:

- **Initial startup**: `LoadSharedDictionaries` -> `LoadOpenOrders` -> `LoadDueOrders` -> ... -> `LoadLoad` -> `CloseSharedDictionaries` -> `Deserialize`
- **`cmdRefresh_Click`**: Same pattern with `LoadSharedDictionaries` before and `CloseSharedDictionaries` after the load subs

**Net effect**: 6 SQL queries eliminated per load/refresh cycle.

## Key Design Decisions


| Decision                     | Choice                                                                                  | Rationale                                                                                                              |
| ---------------------------- | --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Row selection                | ASSIGNPICKER checkbox pattern                                                           | Consistent with existing Assign Picker, Remove Picker features                                                         |
| New line creation            | `ORDADCMD` via `Launchgsssync` with fixed-width file                                    | Proven pattern from GCG_6644                                                                                           |
| Original line update         | `Sales.UpdateOrderLinesByFile` CallWrapper                                              | Replaced direct SQL recordset RW to use standard GSS API for line updates                                              |
| Two-line CSV file            | Single CallWrapper call processes both original line update and new line promise date   | Efficient -- one file, one invocation for two updates                                                                  |
| Promise date via CallWrapper | CSV position 16 with `FormatYYYYMMDD`                                                   | Replaced direct SQL UPDATE of DATE_ITEM_PROM; uses the standard API instead                                            |
| MUST_DLVR_BY_DATE            | No longer explicitly set                                                                | Was previously set alongside DATE_ITEM_PROM via direct SQL; now only DATE_ITEM_PROM is set via CallWrapper position 16 |
| Price formatting             | `F.Intrinsic.String.Format(fPrice,"0.000000",sMsg)` -- 6 decimal precision              | CallWrapper spec: "Unit Price 16 (up to six decimals)"                                                                 |
| Price on new split line      | Not sent (empty at position 7)                                                          | Only the original line sends price; new line only receives promise date                                                |
| Weight recalculation         | `unit_weight = orig_weight / orig_qty`, then `new_weight = unit_weight * remaining_qty` | Proportional weight split based on quantity                                                                            |
| Date formatting              | `FormatYYYYMMDD` for SQL writes and CallWrapper                                         | Actian Zen stores dates in YYYYMMDD format                                                                             |
| DATE_ORDER copy              | Fetched from original line and applied to new line via SQL UPDATE                       | New line inherits the original order date, not the current date                                                        |
| User field traceability       | Dynamic lookup from OE_USER_FLDS_LN for label "SPLIT FROM LINE"; maps KEY_ID to USER_x column. If not configured, skip the UPDATE entirely | Replaces hardcoded USER_5; adapts to customer's user field configuration                                               |
| DataTable scope              | `F.Data.DataTable.Create("dtSplitLines",True)` -- global scope                          | Required so SplitSOLine_Save can access the DataTable created in SplitSOLine_Click                                     |
| UI state reset               | Reset label/buttons in SplitSOLine_Click before showing form                            | Prevents stale state from previous save operations                                                                     |
| Grid cell styling            | `CellBackColor` with `V.Enum.ThemeColors!ColorYellow.Highlight`                         | `BackColor` is not supported; must use `CellBackColor`                                                                 |
| Editable columns             | Set both `AllowEdit=True` AND `ReadOnly=False`                                          | DataTable-sourced columns default ReadOnly=True; both properties needed                                                |
| NEW_DUE_DATE column          | No default value parameter in `AddColumn`                                               | Empty string default causes DateTime parse error; omit the 4th parameter                                               |
| Ship schedule check          | Block split if **any** record in `V_OE_SHIP_SCHED`                                      | Even closed schedules block splitting                                                                                  |
| Staged shipment check        | Block split if **any** record in `STAGING_QUANTITY`                                     | Active staging blocks splitting                                                                                        |
| Defensive file deletion      | `F.Intrinsic.File.Exists` check before all `DeleteFile` calls                           | ORDADCMD and CallWrapper may consume the file                                                                          |
| Skip behavior                | Per-line skip with `bSkip` flag, continue to next line                                  | Consistent with OrderLocked pattern; allows partial batch processing                                                   |
| No undo                      | Per spec                                                                                | Users must manually fix via SO Edit screen                                                                             |
| Edit SO permission           | `CheckUserAccessIPM(132,1)` — Order Entry > Edit > Sales Orders (level 1)              | Level 1 edit permission required for Order Entry                                                                       |
| Edit SO row selection        | ASSIGNPICKER checkbox, first selected row only                                          | Consistent with Split SO Line; classic screen edits one order at a time                                                |
| Edit SO confirmation         | No confirmation prompt                                                                  | Matches existing ORDER_NO click handler behavior; streamlined UX                                                       |
| Edit SO post-edit refresh    | Manual refresh by user                                                                  | Per user requirement; avoids unnecessary grid reload                                                                   |
| Edit SO lock check           | OrderLocked subroutine, hard block (ExitSub)                                            | Prevents opening edit screen when order is locked by another user                                                      |
| Edit SO tab disable          | Disable `tabShip` during edit, re-enable in Catch block too                             | Prevents concurrent actions; matches existing pattern at line 3179                                                     |
| Shared dictionary loading    | `LoadSharedDictionaries`/`CloseSharedDictionaries` subs; load once, fill both DataTables | Eliminates 6 duplicate SQL queries per refresh; dictionaries are read-only lookups safe to reuse                       |


## Upload File Format (from GCG_6644 reference)

Fixed-width positions for ORDADCMD:

- Pos 1: Record type ("O" for Order)
- Pos 2-8: Customer (7, right-padded spaces)
- Pos 9-15: Order Number (7)
- Pos 16-35: Part (20, right-padded spaces)
- Pos 36-53: Fill (18 spaces)
- Pos 54-55: Location (2)
- Pos 56-60: Product Line (5)
- Pos 61-90: Description (30)
- Pos 91-93: Line Number (3, zero-padded)
- Pos 94: Line Type ("S")
- Pos 95-107: Qty Ordered (9int + 4dec, zero-padded)
- Pos 108-117: Weight (7int + 3dec, zero-padded)
- Pos 118-133: Price (10int + 6dec, zero-padded)
- Remaining: Fill + UOM + flags (per reference pattern)

## CallWrapper Update File Format (Sales.UpdateOrderLinesByFile)

Comma-delimited, two lines per split operation in a single file:

**Line 1 -- Original line update (qty, price, weight):**

```
L,{OrderNo},{OrigLineNo(3-char)},,,{RemainingQty},{FormattedPrice(0.000000)},,,,,,,,,,,,,,,,,{NewWeight},,,
```

**Line 2 -- New split line (promise date only):**

```
L,{OrderNo},{NewLineNo(3-char)},,,,,,,,,,,,,{PromiseDateYYYYMMDD},,,,,,,,,,,
```

### CSV Position Map


| Pos    | Field                      | Line 1 (original) | Line 2 (new split)     |
| ------ | -------------------------- | ----------------- | ---------------------- |
| 1      | Record type                | L                 | L                      |
| 2      | Order Number               | {OrderNo}         | {OrderNo}              |
| 3      | Order Line                 | {OrigLineNo}      | {NewLineNo}            |
| 4-5    | (extra commas)             | empty             | empty                  |
| 6      | Qty                        | {RemainingQty}    | empty                  |
| 7      | Price                      | {FormattedPrice}  | empty                  |
| 8      | Cost                       | empty             | empty                  |
| 9-14   | (6 extra after Cost)       | empty             | empty                  |
| 15     | Discount                   | empty             | empty                  |
| **16** | **Promise Date**           | **empty**         | **{dNewDue YYYYMMDD}** |
| 17-22  | (remaining after Discount) | empty             | empty                  |
| 23     | Product Line               | empty             | empty                  |
| 24     | Weight                     | {NewWeight}       | empty                  |
| 25-27  | (trailing)                 | empty             | empty                  |


## Bugs Fixed During Implementation


| #   | Symptom                                                     | Root Cause                                                                                   | Fix                                                                                            |
| --- | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 1   | "String was not recognized as a valid DateTime"             | `AddColumn("dtSplitLines","NEW_DUE_DATE","Date","")` -- empty string default for Date column | Removed 4th parameter from AddColumn                                                           |
| 2   | "SetColumnProperty Error: This property is not supported"   | Used `BackColor` instead of `CellBackColor`, and raw `65535` instead of theme enum           | Changed to `CellBackColor` with `V.Enum.ThemeColors!ColorYellow.Highlight`                     |
| 3   | QTY_SPLIT column not editable                               | `ReadOnly` not explicitly set to `False`; DataTable columns default ReadOnly=True            | Added `SetColumnProperty(..., "ReadOnly", False)`                                              |
| 4   | "DataTable {dtSplitLines} does not exist in callable scope" | `Create("dtSplitLines")` used local scope; Save sub couldn't access it                       | Changed to `Create("dtSplitLines",True)` for global scope                                      |
| 5   | Label and buttons locked after processing                   | UI state not reset when form reopened                                                        | Added reset logic in SplitSOLine_Click before showing form                                     |
| 6   | DATE_ITEM_PROM stored incorrectly                           | Used `FormatMM/DD/YYYY` instead of `FormatYYYYMMDD`                                          | Changed to `FormatYYYYMMDD`                                                                    |
| 7   | DATE_ORDER not copied to new line                           | Not implemented; new line defaulted to current date                                          | Added SELECT of DATE_ORDER from original line + UPDATE on new line                             |
| 8   | Weight not recalculated on original line                    | Only qty was updated, weight left unchanged                                                  | Compute unit_weight, recalculate proportional weight for remaining qty                         |
| 9   | Direct SQL update replaced                                  | Used OpenRecordsetRW for original line update                                                | Replaced with `Sales.UpdateOrderLinesByFile` CallWrapper                                       |
| 10  | "Error 200: The specified file {} was not found"            | `DeleteFile` called without checking if file still exists                                    | Added `F.Intrinsic.File.Exists` guards before all `DeleteFile` calls                           |
| 11  | DATE_ITEM_PROM via direct SQL                               | Direct SQL UPDATE for promise date on new line                                               | Moved to CallWrapper CSV position 16 via second line in upload file; direct SQL commented out  |
| 12  | Price precision                                             | fPrice passed as raw float to CallWrapper                                                    | Formatted with `F.Intrinsic.String.Format(fPrice,"0.000000")` for 6 decimal precision per spec |


