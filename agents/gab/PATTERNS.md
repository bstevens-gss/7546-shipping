# GAB Complete Code Patterns
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

Complete, tested reference scripts showing how individual GAB patterns compose into real programs.
`CORE.md` has the generic template snippets with `<placeholders>`; these patterns show them in context.

**Usage:** When generating a new `.g2u` file, copy the matching pattern below and adapt it to the user's requirements. Replace placeholder values (form titles, SQL queries, column names, hook numbers) with real ones.

| Pattern | Type | Key Features |
|---------|------|-------------|
| **A** | Standalone Form | ScreenSU layout, events, Read/Set syntax, checkbox, error handling |
| **B** | Data Grid | ODBC, DataTable, GsGridControl binding, layout persistence, grid events |
| **C** | Headless Hook | Hook dispatch, V.Passed guards, PSQLFriendly, unique ODBC names |
| **D** | DLL-Backed Feature | LoadAssembly, CreateObject, delimited args/results, .NET interop |
| **E** | Entity Object CRUD | CreateDB, Create, Load (key-preload), GetValue/SetValue, Save, Dispose |
| **F** | WebView2 Dashboard | GsWebView2, file:// URL, hash-based JS-to-GAB (**ExecuteScript causes Error 3000 -- see Pattern G for workaround**) |
| **G** | WebView2 + HTTP Batch API | File-based data injection, `F.Communication.HTTP.Post`, Geocodio batch geocoding, pre-computed For bounds |
| **H** | Reusable Popup Form | ControlBox(False), Visible(False) to hide, DataTable cleanup on re-show, anchor for resize |
| **I** | Hierarchical Grid | Multi-level BOM explosion, queue-based deepening, AddRelation -- **see `GRID.md` "Hierarchical Master-Detail Grid" section** |

---

## Data Operation Guidelines

### Prefer Set-Based Operations Over For Loops

NEVER use For loops for bulk data operations when a set-based alternative exists. Set-based operations are orders of magnitude faster and less error-prone:

| Set-Based Tool | Replaces |
|----------------|----------|
| Dictionary + FillFromDictionary | For loop with per-row lookup/match |
| DataView + ToDataTable | For loop with per-row If filter |
| Compute | For loop summing/counting/aggregating |
| SetValue with row -1 | For loop setting all rows to same value |
| AddExpressionColumn | For loop calculating derived values |
| RunningTotal | For loop accumulating sums |
| Merge | For loop copying between DataTables |

**For loops are acceptable for:** Small bounded datasets (<50 rows), per-row logic with no set equivalent (e.g., calling an API per row), grid formatting.

### Filter via DataView+ToDataTable (Never Loop+If)

**Anti-pattern:** Looping a full DataTable with per-row If checks to subset rows.

**Correct pattern:** Use `DataView.Create` with a filter expression + `ToDataTable`:
```
F.Data.DataView.Create("dtOrders","dvOverdue","DATE_SHIP < '" + V.Ambient.Date.PervasiveDate + "'")
F.Data.DataView.ToDataTable("dtOrders","dvOverdue","dtOverdueOnly",True)
```

### Build SQL IN Clause (No Loop)

Build dynamic IN clauses from DataTable data without loops:
```
F.Data.DataView.ToDataTableDistinct("dtSource","dvAll","dtDistinct","PART",True)
F.Data.DataView.ToString("dtDistinct","dvAll","PART","*!*",V.Local.sList)
F.Intrinsic.String.Replace(V.Local.sList,"*!*","','",V.Local.sList)
F.Intrinsic.String.Build("SELECT * FROM V_INVENTORY_ALL WHERE PART IN ('{0}')",V.Local.sList,V.Local.sSQL)
```

### Orphan Filtering (AddRelation Error 21034 Workaround)

When `AddRelation` fails with Error 21034 due to orphan child records and the SQL cannot be changed, use a post-load set-based pattern:
1. Load parent and child DataTables normally
2. Build a Dictionary from parent keys
3. Use `FillFromDictionary` to create a filtered child table with only matching records
4. Apply `AddRelation` to the filtered child

### Direct Property Accessor Usage

Use `V.DataTable.*.RowCount--` directly in `If` and `For` conditions without creating intermediate variables:
```
'-- CORRECT: direct accessor
F.Intrinsic.Control.For(V.Local.iRow,0,V.DataTable.dtOrders.RowCount--,1)

'-- UNNECESSARY: intermediate variable for single-use read
V.Local.iMax.Set(V.DataTable.dtOrders.RowCount--)
F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iMax,1)
```
Only create a holding variable when the value is used more than twice AND changes between uses.

### BlockEvents Inline Guard Rule

When a handler calls `BlockEvents` at entry, EVERY exit path must call `UnblockEvents` — including early-exit guards (`If → ExitSub`). Failure to do this leaves events permanently blocked:
```
Program.Sub.gsGC1_FocusedRowChanged.Start
F.Intrinsic.Control.Try
    F.Intrinsic.Control.BlockEvents
    V.Local.iRow.Declare(Long,-1)
    Gui.frmMain.gsGC.GetSelectedRows("gvMain",V.Local.sRow)
    V.Local.iRow.Set(V.Local.sRow.Trim.Long)
    F.Intrinsic.Control.If(V.Local.iRow,<,0)
        F.Intrinsic.Control.UnblockEvents
        F.Intrinsic.Control.ExitSub
    F.Intrinsic.Control.EndIf
    '... process row ...
    F.Intrinsic.Control.UnblockEvents
F.Intrinsic.Control.Catch
    F.Intrinsic.Control.UnblockEvents
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndTry
Program.Sub.gsGC1_FocusedRowChanged.End
```

---

## Pattern A: Standalone Form

A single-form script with text input, checkbox, Save/Cancel buttons, and status label.

**Demonstrates:**
- ScreenSU layout packed tight (no blank lines inside ScreenSU or Preflight blocks)
- `.Caption()` for form/button/label/checkbox display text (never `.Text()` on these)
- `.SetIcon()` for form icon (never `.FormIcon()`)
- Event wiring in ScreenSU via `Gui.<ctrl>.Event(EventName, SubName)`
- Main Initialization Sequence (UsePixels, WaitDialog, Show, AlwaysOnTop flash)
- `SetErrorHandler` in every subroutine with blank line after `ClearErrors`
- `BlockEvents` after variable declarations (never before)
- Read syntax (`V.Screen.form!ctrl.Property`) vs Set syntax (`Gui.form.ctrl.Property(value)`)
- Checkbox read returns 0/1, compare explicitly with `=,1`
- Centralized `ErrorMessage` sub with `Try/Catch` (safe leaf-sub usage)

```
Program.Sub.ScreenSU.Start
Gui.frmMain..Create(BaseForm)
Gui.frmMain..Caption("Pattern: Standalone Form")
Gui.frmMain..Size(500,400)
Gui.frmMain..Event(UnLoad,frmMainUnLoad)
Gui.frmMain.lblTitle.Create(Label)
Gui.frmMain.lblTitle.Size(300,20)
Gui.frmMain.lblTitle.Position(20,20)
Gui.frmMain.lblTitle.Caption("Customer Name")
Gui.frmMain.lblTitle.FontStyle(True,False,False,False,False)
Gui.frmMain.txtName.Create(Textbox)
Gui.frmMain.txtName.Size(300,25)
Gui.frmMain.txtName.Position(20,45)
Gui.frmMain.chkActive.Create(Checkbox)
Gui.frmMain.chkActive.Size(200,25)
Gui.frmMain.chkActive.Position(20,85)
Gui.frmMain.chkActive.Caption("Active")
Gui.frmMain.chkActive.Value(True)
Gui.frmMain.cmdSave.Create(Button)
Gui.frmMain.cmdSave.Size(100,35)
Gui.frmMain.cmdSave.Position(20,130)
Gui.frmMain.cmdSave.Caption("Save")
Gui.frmMain.cmdSave.Event(Click,cmdSave_Click)
Gui.frmMain.cmdCancel.Create(Button)
Gui.frmMain.cmdCancel.Size(100,35)
Gui.frmMain.cmdCancel.Position(130,130)
Gui.frmMain.cmdCancel.Caption("Cancel")
Gui.frmMain.cmdCancel.Event(Click,cmdCancel_Click)
Gui.frmMain.lblStatus.Create(Label)
Gui.frmMain.lblStatus.Size(400,20)
Gui.frmMain.lblStatus.Position(20,185)
Gui.frmMain.lblStatus.Caption("")
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

'-- Pixel mode (ScreenSU coordinates are pixels)
F.Intrinsic.UI.UsePixels

'-- V.Enum.* in ScreenSU crashes at parse time -- set icons/accent at runtime in Main
Gui.frmMain..SetIcon(V.Enum.FormIconApplication!SupplyAndDemand)
Gui.frmMain..AccentColor(V.Enum.AccentColorCodes!Blue)
Gui.frmMain.cmdSave.SvgPicture(V.Enum.Image!SAVE_COLOR)

'-- Wait dialog while form initializes
F.Intrinsic.UI.InvokeWaitDialog("Loading...")

'-- Close wait dialog before showing form
F.Intrinsic.UI.CloseWaitDialog

'-- Show form
Gui.frmMain..Show

'-- Focus flash (forces form to front without staying on top)
Gui.frmMain..AlwaysOnTop(True)
Gui.frmMain..AlwaysOnTop(False)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.UI.CloseWaitDialog
    F.Intrinsic.String.Build("Project: pattern_form.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.cmdSave_Click.Start
F.Intrinsic.Control.SetErrorHandler("cmdSave_Click_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sName.Declare(String,"")
V.Local.sMsg.Declare(String,"")

F.Intrinsic.Control.BlockEvents

'-- Read from controls (V.Screen with ! delimiter, no parentheses)
V.Local.sName.Set(V.Screen.frmMain!txtName.Text)

'-- Validate: name must not be empty
F.Intrinsic.Control.If(V.Local.sName.Trim,=,"")
    F.Intrinsic.UI.Msgbox("Customer name is required.")
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf

'-- Read checkbox (returns 0 or 1, compare explicitly)
F.Intrinsic.Control.If(V.Screen.frmMain!chkActive.Value,=,1)
    F.Intrinsic.String.Build("Saving active customer: {0}",V.Local.sName,V.Local.sMsg)
F.Intrinsic.Control.Else
    F.Intrinsic.String.Build("Saving inactive customer: {0}",V.Local.sName,V.Local.sMsg)
F.Intrinsic.Control.EndIf

'-- Set control property (Gui with . delimiter, value in parentheses)
Gui.frmMain.lblStatus.Caption(V.Local.sMsg)

F.Intrinsic.UI.Msgbox(V.Local.sMsg)

F.Intrinsic.Control.UnBlockEvents

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("cmdSave_Click_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.Control.CallSub(ErrorMessage)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.cmdSave_Click.End

Program.Sub.cmdCancel_Click.Start
F.Intrinsic.Control.SetErrorHandler("cmdCancel_Click_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.Control.CallSub(frmMainUnLoad)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("cmdCancel_Click_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(ErrorMessage)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.cmdCancel_Click.End

Program.Sub.frmMainUnLoad.Start
F.Intrinsic.Control.SetErrorHandler("frmMainUnLoad_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.Control.End

F.Intrinsic.Control.Label("frmMainUnLoad_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.frmMainUnLoad.End

Program.Sub.ErrorMessage.Start
'-- Centralized error handler (leaf sub -- Try/Catch is safe here, no nesting risk)
F.Intrinsic.Control.Try

F.Intrinsic.Control.If(V.Global.bError)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
V.Global.bError.Set(True)

V.Local.sError.Declare(String,"")
F.Intrinsic.String.Build("Project: pattern_form.g2u{0}{0}Subroutine: {1}{0}Error: {2} - {3}",V.Ambient.NewLine,V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
F.Intrinsic.UI.Msgbox(V.Local.sError)

V.Global.bError.Set(False)

F.Intrinsic.Control.Catch
F.Intrinsic.Control.EndTry
Program.Sub.ErrorMessage.End
```

---

## Pattern B: Data Grid

A form with a GsGridControl bound to a SQL query, Refresh button, grid events, and layout persistence.

**Demonstrates:**
- ScreenSU and Preflight packed tight (no blank lines)
- Self-contained ODBC in `LoadData` (open, query, close inside the sub -- caller does not manage the connection)
- Real GSS schema names (`INVENTORY_MSTR`, `PART`, `QTY_ONHAND`, `AMT_COST`)
- `AddGridviewFromDatatable` + `MainView` (never `DataSource` + `MainView`)
- `CreateFromSQL` with connection name string (never `V.Ambient.PDSN/PUser/PPass`)
- `SuspendLayout` / `ResumeLayout` around grid configuration
- String literals for `SetGridviewProperty` and `SetColumnProperty` (never `V.Enum.GridViewPropertyNames`)
- Column formatting: Caption, Width, Fixed, DisplayFormatType, DisplayCustomNumeric, CellHAlignment
- `Serialize` / `Deserialize` for layout persistence across refreshes
- `BlockEvents` after variable declarations, wrapping data rebuild to prevent cascading handlers
- Grid-level `InvokeWait` / `HideWait`
- `RowCellClick` with V.Args.Column dispatch and `FocusedRowChanged` with V.Args.FocusedRowHandle
- Copy V.Args to locals first (volatile during event processing)
- DataTable existence check before Close
- `BestFitColumns` after initial load

```
Program.Sub.ScreenSU.Start
Gui.frmMain..Create(BaseForm)
Gui.frmMain..Caption("Pattern: Data Grid")
Gui.frmMain..Size(900,600)
Gui.frmMain..Event(UnLoad,frmMainUnLoad)
Gui.frmMain.cmdRefresh.Create(Button)
Gui.frmMain.cmdRefresh.Size(110,35)
Gui.frmMain.cmdRefresh.Position(20,15)
Gui.frmMain.cmdRefresh.Caption("Refresh")
Gui.frmMain.cmdRefresh.Event(Click,cmdRefresh_Click)
Gui.frmMain.gsGCMain.Create(GsGridControl)
Gui.frmMain.gsGCMain.Size(860,500)
Gui.frmMain.gsGCMain.Position(20,60)
Gui.frmMain.gsGCMain.Event(RowCellClick,gsGCMain_RowCellClick)
Gui.frmMain.gsGCMain.Event(FocusedRowChanged,gsGCMain_FocusedRowChanged)
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.UI.UsePixels

'-- V.Enum.* in ScreenSU crashes at parse time -- set icons/accent at runtime in Main
Gui.frmMain..SetIcon(V.Enum.FormIconApplication!SupplyAndDemand)
Gui.frmMain..AccentColor(V.Enum.AccentColorCodes!Blue)
Gui.frmMain.cmdRefresh.SvgPicture(V.Enum.Image!REFRESH_COLOR)

F.Intrinsic.UI.InvokeWaitDialog("Loading...")

F.Intrinsic.Control.CallSub(LoadData)

F.Intrinsic.UI.CloseWaitDialog

Gui.frmMain..Show
Gui.frmMain..AlwaysOnTop(True)
Gui.frmMain..AlwaysOnTop(False)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.UI.CloseWaitDialog
    F.Intrinsic.String.Build("Project: pattern_grid.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.LoadData.Start
F.Intrinsic.Control.SetErrorHandler("LoadData_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sSQL.Declare(String,"")

'-- Build SQL (always name columns explicitly, verify against schema)
V.Local.sSQL.Set("SELECT PART, DESCRIPTION, QTY_ONHAND, AMT_COST FROM INVENTORY_MSTR WHERE QTY_ONHAND > 0 ORDER BY PART")

'-- Open connection
F.ODBC.Connection!conLoad.OpenCompanyConnection

'-- Create DataTable from SQL using the named ODBC connection
F.Data.DataTable.CreateFromSQL("dtParts","conLoad",V.Local.sSQL,True)

'-- close connection
F.ODBC.Connection!conLoad.Close

'-- Bind grid: AddGridviewFromDatatable + MainView (never DataSource + MainView)
Gui.frmMain.gsGCMain.AddGridviewFromDatatable("gvParts","dtParts")
Gui.frmMain.gsGCMain.MainView("gvParts")

'-- Configure grid properties inside SuspendLayout/ResumeLayout
Gui.frmMain.gsGCMain.SuspendLayout

'-- Gridview properties (string literals for version safety -- no V.Enum.GridViewPropertyNames)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","AllowSort",True)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","AllowFilter",True)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","AllowColumnResizing",True)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","AllowColumnMoving",True)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","OptionsViewShowAutoFilterRow",True)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","OptionsViewColumnAutoWidth",False)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","OptionsSelectionEnableAppearanceFocusedRow",True)
Gui.frmMain.gsGCMain.SetGridviewProperty("gvParts","ShowGroupPanel",True)

'-- Column properties (string literals for version safety -- no V.Enum.ColumnPropertyNames)
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","PART","Caption","Part Number")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","PART","Width",150)
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","PART","Fixed","Left")

Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","DESCRIPTION","Caption","Description")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","DESCRIPTION","Width",250)

Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","QTY_ONHAND","Caption","Qty On Hand")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","QTY_ONHAND","Width",120)
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","QTY_ONHAND","DisplayFormatType","Numeric")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","QTY_ONHAND","DisplayCustomNumeric","#,##0.00")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","QTY_ONHAND","CellHAlignment","Far")

Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","AMT_COST","Caption","Unit Cost")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","AMT_COST","Width",120)
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","AMT_COST","DisplayFormatType","Numeric")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","AMT_COST","DisplayCustomNumeric","$ #,##0.00")
Gui.frmMain.gsGCMain.SetColumnProperty("gvParts","AMT_COST","CellHAlignment","Far")

Gui.frmMain.gsGCMain.ResumeLayout

Gui.frmMain.gsGCMain.BestFitColumns("gvParts")

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("LoadData_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: pattern_grid.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.LoadData.End

Program.Sub.cmdRefresh_Click.Start
F.Intrinsic.Control.SetErrorHandler("cmdRefresh_Click_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.Control.CallSub(RefreshData)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("cmdRefresh_Click_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: pattern_grid.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.cmdRefresh_Click.End

Program.Sub.RefreshData.Start
F.Intrinsic.Control.SetErrorHandler("RefreshData_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sLayout.Declare(String,"")

'-- 1. Save user's grid layout before rebuilding
Gui.frmMain.gsGCMain.Serialize("gvParts",V.Local.sLayout)

'-- 2. Block events during rebuild
F.Intrinsic.Control.BlockEvents

'-- 3. Show grid-level wait indicator
Gui.frmMain.gsGCMain.InvokeWait("Refreshing...")

'-- 4. Close existing DataTable, reopen connection, reload
F.Intrinsic.Control.If(V.DataTable.dtParts.Exists)
    F.Data.DataTable.Close("dtParts")
F.Intrinsic.Control.EndIf

F.Intrinsic.Control.CallSub(LoadData)

'-- 5. Unblock events
F.Intrinsic.Control.UnBlockEvents

'-- 6. Restore user's grid layout (column widths, sorts, filters, grouping)
F.Intrinsic.Control.If(V.Local.sLayout.Trim,<>,"")
    Gui.frmMain.gsGCMain.Deserialize(V.Local.sLayout)
F.Intrinsic.Control.EndIf

'-- 7. Hide grid wait indicator
Gui.frmMain.gsGCMain.HideWait

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("RefreshData_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    Gui.frmMain.gsGCMain.HideWait
    F.Intrinsic.String.Build("Project: pattern_grid.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.RefreshData.End

Program.Sub.gsGCMain_RowCellClick.Start
F.Intrinsic.Control.SetErrorHandler("gsGCMain_RowCellClick_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sCol.Declare(String,"")
V.Local.sCellVal.Declare(String,"")

F.Intrinsic.Control.BlockEvents

'-- Copy V.Args values to locals first (volatile during event processing)
V.Local.sCol.Set(V.Args.Column)

F.Intrinsic.Control.SelectCase(V.Local.sCol)
    F.Intrinsic.Control.Case("PART")
        V.Local.sCellVal.Set(V.Args.CellValue)
        F.Intrinsic.UI.Msgbox(V.Local.sCellVal)
    F.Intrinsic.Control.CaseElse
        '-- No action for other columns
F.Intrinsic.Control.EndSelect

F.Intrinsic.Control.UnBlockEvents

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("gsGCMain_RowCellClick_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.String.Build("Project: pattern_grid.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.gsGCMain_RowCellClick.End

Program.Sub.gsGCMain_FocusedRowChanged.Start
F.Intrinsic.Control.SetErrorHandler("gsGCMain_FocusedRowChanged_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sPart.Declare(String,"")
V.Local.iRow.Declare(Long,0)

F.Intrinsic.Control.BlockEvents

'-- CRITICAL: FocusedRowHandle is a VISUAL index. Use GetSelectedRows for DataTable handle in filtered grids.
V.Local.iRow.Set(V.Args.FocusedRowHandle)

'-- Read cell value by column name from the focused row
Gui.frmMain.gsGCMain.GetCellValueByColumnName("gvParts","PART",V.Local.iRow,V.Local.sPart)

F.Intrinsic.Control.UnBlockEvents

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("gsGCMain_FocusedRowChanged_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.String.Build("Project: pattern_grid.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.gsGCMain_FocusedRowChanged.End

Program.Sub.frmMainUnLoad.Start
F.Intrinsic.Control.SetErrorHandler("frmMainUnLoad_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

'-- Clean up DataTables before exiting
F.Intrinsic.Control.If(V.DataTable.dtParts.Exists)
    F.Data.DataTable.Close("dtParts")
F.Intrinsic.Control.EndIf

F.Intrinsic.Control.End

F.Intrinsic.Control.Label("frmMainUnLoad_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.frmMainUnLoad.End

Program.Sub.ErrorMessage.Start
F.Intrinsic.Control.Try

F.Intrinsic.Control.If(V.Global.bError)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
V.Global.bError.Set(True)

V.Local.sError.Declare(String,"")
F.Intrinsic.String.Build("Project: pattern_grid.g2u{0}{0}Subroutine: {1}{0}Error: {2} - {3}",V.Ambient.NewLine,V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
F.Intrinsic.UI.Msgbox(V.Local.sError)

V.Global.bError.Set(False)

F.Intrinsic.Control.Catch
F.Intrinsic.Control.EndTry
Program.Sub.ErrorMessage.End
```

---

## Pattern C: Headless Hook

A hook-dispatched script with no GUI. Dispatches by hook number, validates passed variables, runs SQL, and terminates.

**Demonstrates:**
- Headless `.g2u` structure: no ScreenSU block, starts with Preflight
- Preflight packed tight (no blank lines)
- `V.Caller.Hook` dispatch via `SelectCase`
- `PassedExists` guard before every `V.Passed` read
- `.PSQLFriendly` escaping (two-step: read into local, then apply property)
- Unique ODBC connection names per subroutine (`conBeforeSave`, `conAfterPost`)
- `CreateFromSQL` with named connection string
- `V.DataTable.dt.Exists` and `.RowCount--` checks before access
- `F.Intrinsic.Control.End` for headless termination (no form event loop)
- `F.ODBC.Connection!con.Execute` for INSERT/UPDATE statements
- `V.Caller.User` for audit context
- ScreenSU is optional -- add it when the hook needs to show a form to the user

```
Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

'-- Dispatch based on hook number (get actual hook numbers from user or hook docs)
F.Intrinsic.Control.SelectCase(V.Caller.Hook)
    F.Intrinsic.Control.Case("12345")
        F.Intrinsic.Control.CallSub(HandleBeforeSave)
    F.Intrinsic.Control.Case("12346")
        F.Intrinsic.Control.CallSub(HandleAfterPost)
    F.Intrinsic.Control.CaseElse
        '-- Unknown hook, exit gracefully
F.Intrinsic.Control.EndSelect

'-- No form show, no event loop -- headless script terminates here
F.Intrinsic.Control.End

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: pattern_hook.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.HandleBeforeSave.Start
F.Intrinsic.Control.SetErrorHandler("HandleBeforeSave_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.bExists.Declare(Boolean,False)
V.Local.sOrderId.Declare(String,"")
V.Local.sPartNo.Declare(String,"")
V.Local.sSQL.Declare(String,"")

'-- Always guard V.Passed access with PassedExists
F.Intrinsic.Variable.PassedExists("OrderId",V.Local.bExists)
F.Intrinsic.Control.If(V.Local.bExists)
    V.Local.sOrderId.Set(V.Passed.OrderId)
F.Intrinsic.Control.Else
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf

F.Intrinsic.Variable.PassedExists("PartNo",V.Local.bExists)
F.Intrinsic.Control.If(V.Local.bExists)
    V.Local.sPartNo.Set(V.Passed.PartNo)
F.Intrinsic.Control.EndIf

'-- PSQLFriendly is a property (no parens) and cannot chain on V.Passed directly
'-- Two-step: read into local, then escape
V.Local.sOrderId.Set(V.Local.sOrderId.PSQLFriendly)

'-- Unique ODBC connection name for this sub (not reused by other subs)
F.ODBC.Connection!conBeforeSave.OpenCompanyConnection

F.Intrinsic.String.Build("SELECT COUNT(*) AS CNT FROM GS_ORDER_DETAIL WHERE ORDER_ID = '{0}'",V.Local.sOrderId,V.Local.sSQL)
F.Data.DataTable.CreateFromSQL("dtValidation","conBeforeSave",V.Local.sSQL,True)

F.ODBC.Connection!conBeforeSave.Close

'-- Check DataTable existence and row count before access
F.Intrinsic.Control.If(V.DataTable.dtValidation.Exists)
    F.Intrinsic.Control.If(V.DataTable.dtValidation.RowCount--,>=,0)
        '-- Business logic goes here
    F.Intrinsic.Control.EndIf
    F.Data.DataTable.Close("dtValidation")
F.Intrinsic.Control.EndIf

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("HandleBeforeSave_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndIf
Program.Sub.HandleBeforeSave.End

Program.Sub.HandleAfterPost.Start
F.Intrinsic.Control.SetErrorHandler("HandleAfterPost_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.bExists.Declare(Boolean,False)
V.Local.sTransId.Declare(String,"")
V.Local.sUser.Declare(String,"")
V.Local.sSQL.Declare(String,"")
V.Local.sMsg.Declare(String,"")

'-- Read caller context
V.Local.sUser.Set(V.Caller.User)

'-- Guard every V.Passed read
F.Intrinsic.Variable.PassedExists("TransId",V.Local.bExists)

F.Intrinsic.Control.If(V.Local.bExists)
    V.Local.sTransId.Set(V.Passed.TransId)
F.Intrinsic.Control.Else
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf

V.Local.sTransId.Set(V.Local.sTransId.PSQLFriendly)

'-- Unique ODBC connection name (different from HandleBeforeSave)
F.ODBC.Connection!conAfterPost.OpenCompanyConnection

F.Intrinsic.String.Build("INSERT INTO GS_AUDIT_LOG (TRANS_ID, ACTION, USER_NAME, LOG_DATE) VALUES ('{0}', 'POST', '{1}', CURDATE())",V.Local.sTransId,V.Local.sUser,V.Local.sSQL)
F.ODBC.Connection!conAfterPost.Execute(V.Local.sSQL)

F.ODBC.Connection!conAfterPost.Close

F.Intrinsic.String.Build("Audit log recorded for transaction {0}",V.Local.sTransId,V.Local.sMsg)
F.Intrinsic.UI.Msgbox(V.Local.sMsg)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("HandleAfterPost_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndIf
Program.Sub.HandleAfterPost.End

Program.Sub.ErrorMessage.Start
F.Intrinsic.Control.Try

F.Intrinsic.Control.If(V.Global.bError)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
V.Global.bError.Set(True)

V.Local.sError.Declare(String,"")
F.Intrinsic.String.Build("Project: pattern_hook.g2u{0}{0}Subroutine: {1}{0}Error: {2} - {3}",V.Ambient.NewLine,V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
F.Intrinsic.UI.Msgbox(V.Local.sError)

V.Global.bError.Set(False)

F.Intrinsic.Control.Catch
F.Intrinsic.Control.EndTry
Program.Sub.ErrorMessage.End
```

---

## Pattern D: DLL-Backed Feature

A headless script that loads a .NET Framework 4.6.2 DLL, calls a method with delimited arguments, and parses the delimited result.

**Demonstrates:**
- `F.Automation.Generic.LoadAssembly` / `CreateObject` / `CallMethodReturnVariable` lifecycle
- Every DLL method accepts a single `string` parameter and returns a `string` (mandatory DLL contract)
- `*!*` delimiter for passing multiple arguments to the DLL and parsing the result
- `SetErrorHandler` wrapping (DLL exceptions surface as GAB runtime errors)
- Assembly path from `V.Caller.LocalGSSTempDir` or a known plugins directory

```
Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sDllPath.Declare(String,"")
V.Local.sArgs.Declare(String,"")
V.Local.sResult.Declare(String,"")
V.Local.sParts.Declare(String)

'-- Build path to DLL (deployed alongside the .g2u or in a known location)
F.Intrinsic.String.Build("{0}MyIntegration.dll",V.Caller.LocalGSSTempDir,V.Local.sDllPath)

'-- Load assembly, create object, call method
F.Automation.Generic.LoadAssembly(V.Local.sDllPath)
F.Automation.Generic.CreateObject("myObj","MyIntegration.ApiClient")

'-- Build delimited args string: DLL method receives a single string
F.Intrinsic.String.Build("GET*!*https://api.example.com/orders*!*Bearer {0}",V.Global.sApiToken,V.Local.sArgs)

'-- Call the method; it returns a delimited result string
F.Automation.Generic.CallMethodReturnVariable("myObj","Execute",V.Local.sArgs,V.Local.sResult)

'-- Parse result (DLL returns "StatusCode*!*Body")
F.Intrinsic.String.Split(V.Local.sResult,"*!*",V.Local.sParts)
F.Intrinsic.Control.If(V.Local.sParts(0),=,"200")
    F.Intrinsic.UI.Msgbox(V.Local.sParts(1))
F.Intrinsic.Control.Else
    F.Intrinsic.String.Build("API call failed with status {0}: {1}",V.Local.sParts(0),V.Local.sParts(1),V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
F.Intrinsic.Control.EndIf

F.Intrinsic.Control.End

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: pattern_dll.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.Main.End
```

> **Key rules from `agents/gab/DLL.md`:** Target .NET Framework 4.6.2 only. Every method GAB calls must accept `(string)` and return `string`. Use `*!*` or `|` delimiters. Use `packages.config` (not `PackageReference`). Deploy DLL + dependencies to the same folder.

---

## Pattern E: Entity Object CRUD

A headless script that creates a DB connection, loads an entity object, reads and updates field values.

**Demonstrates:**
- `F.Global.Object.CreateDB` / `Create` / `Load` / `GetValue` / `SetValue` / `Save` / `Dispose` lifecycle
- Key-preload pattern (set keys via `SetValue` before `Load` with mode 800)
- Status code checks after `Load` and `Save`
- `CloseConnection` cleanup in a dedicated Cleanup sub
- Unique connection name pattern

```
Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
V.Global.iCon.Declare(Long,0)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.iRet.Declare(Long,0)
V.Local.sDesc.Declare(String,"")

'-- 1. Create DB connection for entity operations
F.Global.Object.CreateDB("GlobalDB",V.Global.iCon)

'-- 2. Create entity object instance (Inventory.Part is the GsseoType)
F.Global.Object.Create("oPart","Inventory.Part","GlobalDB",V.Global.iCon)

'-- 3. Key-preload pattern: set key fields before Load
F.Global.Object.SetValue("oPart","PartNumber","WIDGET-A")
F.Global.Object.SetValue("oPart","PartNumberRevision","")
F.Global.Object.SetValue("oPart","LocationCode","TX")

'-- 4. Load with mode 800 (key-preload mode)
F.Global.Object.Load("oPart",800,V.Local.iRet)

'-- 5. Check load status (0 = success)
F.Intrinsic.Control.If(V.Local.iRet,<>,0)
    F.Intrinsic.String.Build("Entity load failed with status {0}",V.Local.iRet,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(Cleanup)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf

'-- 6. Read a field value
F.Global.Object.GetValue("oPart","Description",V.Local.sDesc)
F.Intrinsic.UI.Msgbox(V.Local.sDesc)

'-- 7. Update a field value
F.Global.Object.SetValue("oPart","Description","Updated Widget A Description")

'-- 8. Save changes
F.Global.Object.Save("oPart",V.Local.iRet)

F.Intrinsic.Control.If(V.Local.iRet,<>,0)
    F.Intrinsic.String.Build("Entity save failed with status {0}",V.Local.iRet,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
F.Intrinsic.Control.Else
    F.Intrinsic.UI.Msgbox("Part updated successfully.")
F.Intrinsic.Control.EndIf

'-- 9. Cleanup
F.Intrinsic.Control.CallSub(Cleanup)
F.Intrinsic.Control.End

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: pattern_entity.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(Cleanup)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.Cleanup.Start
F.Intrinsic.Control.SetErrorHandler("Cleanup_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Global.Object.Dispose("oPart")
F.Global.Object.CloseConnection("GlobalDB",V.Global.iCon)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Cleanup_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    '-- Swallow cleanup errors to avoid masking the original error
F.Intrinsic.Control.EndIf
Program.Sub.Cleanup.End
```

> **Key rules from `agents/gab/INTEGRATION.md`:** Entity types follow `Module.SubModule.EntityName` format. Always check `Load`/`Save` return status (0 = success). Use `Dispose` + `CloseConnection` for cleanup. Key-preload mode (800) requires `SetValue` before `Load`.

---

## Pattern F: WebView2 Dashboard

A form with a GsWebView2 control hosting an HTML file, with bidirectional JS-to-GAB communication via URL hash.

**Demonstrates:**
- `GsWebView2` creation and `Source` navigation to a `file://` URL
- `UrlChanged` event for JS-to-GAB communication via `window.location.hash`
- Hash fragment parsing with `InStr` + `Mid` + `Split`
- `ExecuteScript` for GAB-to-JS communication
- Cache-busting reload pattern
- File path construction using `V.Caller.LocalGSSTempDir`

```
Program.Sub.ScreenSU.Start
Gui.frmDash..Create(BaseForm)
Gui.frmDash..Caption("Pattern: WebView2 Dashboard")
Gui.frmDash..Size(1024,768)
Gui.frmDash..Event(UnLoad,frmDashUnLoad)
Gui.frmDash.wv2Main.Create(GsWebView2)
Gui.frmDash.wv2Main.Dock(5)
Gui.frmDash.wv2Main.Event(UrlChanged,wv2Main_UrlChanged)
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
V.Global.iReloadCounter.Declare(Long,0)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sHtmlPath.Declare(String,"")
V.Local.sFileUrl.Declare(String,"")

F.Intrinsic.UI.UsePixels

'-- V.Enum.* in ScreenSU crashes at parse time -- set icons/accent at runtime in Main
Gui.frmDash..SetIcon(V.Enum.FormIconApplication!SupplyAndDemand)
Gui.frmDash..AccentColor(V.Enum.AccentColorCodes!Blue)

F.Intrinsic.UI.InvokeWaitDialog("Loading dashboard...")

'-- Build file:// URL from the HTML sidecar file
F.Intrinsic.String.Build("{0}dashboard.html",V.Caller.LocalGSSTempDir,V.Local.sHtmlPath)
F.Intrinsic.String.Replace(V.Local.sHtmlPath,"\","/",V.Local.sFileUrl)
F.Intrinsic.String.Concat("file:///",V.Local.sFileUrl,V.Local.sFileUrl)

'-- Navigate to the HTML file
Gui.frmDash.wv2Main.Source(V.Local.sFileUrl)

F.Intrinsic.UI.CloseWaitDialog

Gui.frmDash..Show
Gui.frmDash..AlwaysOnTop(True)
Gui.frmDash..AlwaysOnTop(False)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.UI.CloseWaitDialog
    F.Intrinsic.String.Build("Project: pattern_webview2.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmDashUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.wv2Main_UrlChanged.Start
F.Intrinsic.Control.SetErrorHandler("wv2Main_UrlChanged_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sUrl.Declare(String,"")
V.Local.iHashPos.Declare(Long,0)
V.Local.sFragment.Declare(String,"")
V.Local.sParts.Declare(String)
V.Local.sAction.Declare(String,"")

F.Intrinsic.Control.BlockEvents

'-- Read current URL from the WebView2 control
V.Local.sUrl.Set(V.Screen.frmDash!wv2Main.SourceUrl)

'-- Extract hash fragment (JS sets window.location.hash = "action|arg1|arg2|_t=<timestamp>")
F.Intrinsic.String.InStr(V.Local.sUrl,"#",1,V.Local.iHashPos)
F.Intrinsic.Control.If(V.Local.iHashPos,=,0)
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf

F.Intrinsic.Math.Add(V.Local.iHashPos,1,V.Local.iHashPos)
F.Intrinsic.String.Mid(V.Local.sUrl,V.Local.iHashPos,4000,V.Local.sFragment)

'-- Split on pipe delimiter: action|arg1|arg2|_t=<nonce>
F.Intrinsic.String.Split(V.Local.sFragment,"|",V.Local.sParts)
V.Local.sAction.Set(V.Local.sParts(0))

'-- Dispatch based on action
F.Intrinsic.Control.SelectCase(V.Local.sAction)
    F.Intrinsic.Control.Case("loadData")
        F.Intrinsic.Control.CallSub(HandleLoadData)
    F.Intrinsic.Control.Case("saveRecord")
        F.Intrinsic.Control.CallSub(HandleSaveRecord)
    F.Intrinsic.Control.CaseElse
        '-- Unknown action, ignore
F.Intrinsic.Control.EndSelect

F.Intrinsic.Control.UnBlockEvents

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("wv2Main_UrlChanged_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndIf
Program.Sub.wv2Main_UrlChanged.End

Program.Sub.HandleLoadData.Start
F.Intrinsic.Control.SetErrorHandler("HandleLoadData_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sSQL.Declare(String,"")
V.Local.sJson.Declare(String,"")
V.Local.sScript.Declare(String,"")
V.Local.sDataFile.Declare(String,"")

'-- Query data
F.ODBC.Connection!conDash.OpenCompanyConnection
V.Local.sSQL.Set("SELECT TOP 100 PART, DESCRIPTION, QTY_ONHAND FROM INVENTORY_MSTR ORDER BY PART")
F.Data.DataTable.CreateFromSQL("dtDash","conDash",V.Local.sSQL,True)
F.ODBC.Connection!conDash.Close

'-- Convert to JSON for the HTML side
F.Data.DataTable.SaveToJson("dtDash",V.Local.sJson)

'-- WARNING: ExecuteScript causes Error 3000 on GsWebView2.
'-- Use file-based data injection instead (see Pattern G).
'-- Write data to a .js file and load it via <script src="..."> in the HTML.
F.Intrinsic.String.Build("window.DATA={0};",V.Local.sJson,V.Local.sScript)
F.Intrinsic.String.Build("{0}dashboard_data.js",V.Ambient.ScriptPath,V.Local.sDataFile)
F.Intrinsic.File.String2File(V.Local.sDataFile,V.Local.sScript)

'-- Cleanup
F.Intrinsic.Control.If(V.DataTable.dtDash.Exists)
    F.Data.DataTable.Close("dtDash")
F.Intrinsic.Control.EndIf

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("HandleLoadData_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndIf
Program.Sub.HandleLoadData.End

Program.Sub.HandleSaveRecord.Start
F.Intrinsic.Control.SetErrorHandler("HandleSaveRecord_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

'-- Placeholder: implement save logic based on sParts(1), sParts(2), etc. from URL hash
F.Intrinsic.UI.Msgbox("Save action received from dashboard.")

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("HandleSaveRecord_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndIf
Program.Sub.HandleSaveRecord.End

Program.Sub.frmDashUnLoad.Start
F.Intrinsic.Control.SetErrorHandler("frmDashUnLoad_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.Control.End

F.Intrinsic.Control.Label("frmDashUnLoad_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.frmDashUnLoad.End

Program.Sub.ErrorMessage.Start
F.Intrinsic.Control.Try

F.Intrinsic.Control.If(V.Global.bError)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
V.Global.bError.Set(True)

V.Local.sError.Declare(String,"")
F.Intrinsic.String.Build("Project: pattern_webview2.g2u{0}{0}Subroutine: {1}{0}Error: {2} - {3}",V.Ambient.NewLine,V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
F.Intrinsic.UI.Msgbox(V.Local.sError)

V.Global.bError.Set(False)

F.Intrinsic.Control.Catch
F.Intrinsic.Control.EndTry
Program.Sub.ErrorMessage.End
```

> **Key rules from `agents/gab/GUI_CONTROLS.md`:** JS-to-GAB uses `window.location.hash` (triggers `UrlChanged`). **GAB-to-JS via `ExecuteScript` causes Error 3000** -- use **file-based data injection** instead (see Pattern G below). Append `_t=<timestamp>` to hash to ensure change detection. `fetch()` does not work from `file://` -- use `<script src>` injection for data loading.

---

## Pattern G: WebView2 with File-Based Data Injection & HTTP Batch API

A form with GsWebView2 where GAB queries a database, calls an external REST API (Geocodio batch geocoding), writes pre-processed data to a `.js` sidecar file, and the HTML loads it instantly.

**Demonstrates:**
- **File-based data injection** (workaround for `ExecuteScript` Error 3000)
- **`F.Communication.HTTP.Post`** for calling external batch REST APIs from GAB
- **JSON response parsing** with `F.Communication.JSON.ParseFile` and XPath navigation
- **Pre-computed upper bounds** for For loops (avoids `.--` mutation pitfall)
- **`V.Ambient.DblQuote`** for building valid JSON strings without doubled-quote corruption
- **`F.Intrinsic.File.DeleteFile`** with existence check before overwriting stale response files
- **`V.Ambient.ScriptPath`** for sidecar file paths (not `V.Caller.FilePath` which does not exist)
- Leaflet.js with ESRI satellite/terrain tiles (works from `file://`, no CORS issues)

**Data flow:**
1. GAB queries DB → builds address list → POSTs to Geocodio batch API
2. GAB parses geocoded lat/lng from JSON response
3. GAB writes `data.js` file with pre-geocoded records
4. HTML loads `data.js` via `<script src>` → plots markers instantly

```
Program.Sub.ScreenSU.Start
Gui.frmMap..Create(BaseForm)
Gui.frmMap..Caption("CRM Geo Map")
Gui.frmMap..Size(1280,800)
Gui.frmMap..Event(UnLoad,frmMapUnLoad)
Gui.frmMap.wv2Map.Create(GsWebView2)
Gui.frmMap.wv2Map.Dock(5)
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.UI.UsePixels
F.Intrinsic.UI.InvokeWaitDialog("Loading data...")

F.Intrinsic.Control.CallSub(LoadAndPushData)

F.Intrinsic.UI.CloseWaitDialog
Gui.frmMap..Show
Gui.frmMap..AlwaysOnTop(True)
Gui.frmMap..AlwaysOnTop(False)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.UI.CloseWaitDialog
    F.Intrinsic.String.Build("Project: crm_geomap.g2u {0}{0}Sub: {1}{0}Error {2}: {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMapUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.LoadAndPushData.Start
F.Intrinsic.Control.SetErrorHandler("LoadAndPushData_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sSQL.Declare(String,"")
V.Local.sQ.Declare(String,"")
V.Local.sBody.Declare(String,"")
V.Local.sDataPath.Declare(String,"")
V.Local.sGeoPath.Declare(String,"")
V.Local.iCustCount.Declare(Long,0)
V.Local.iCustMax.Declare(Long,0)
V.Local.iRow.Declare(Long,0)
V.Local.bExists.Declare(Boolean,False)

'-- DblQuote for building valid JSON
V.Local.sQ.Set(V.Ambient.DblQuote)

'-- Query DB
F.ODBC.Connection!conMap.OpenCompanyConnection
V.Local.sSQL.Set("SELECT RTRIM(CUST_CODE) AS ID, RTRIM(CUST_NAME) AS NAME, RTRIM(ADDRESS1) AS ADDR, RTRIM(CITY) AS CITY, RTRIM(STATE) AS ST FROM CUSTOMER_MASTER WHERE REC = 1")
F.Data.DataTable.CreateFromSQL("dtCust","conMap",V.Local.sSQL,True)
F.ODBC.Connection!conMap.Close

'-- Pre-compute upper bounds (NEVER use .-- in For loops)
V.Local.iCustCount.Set(V.DataTable.dtCust.RowCount)
F.Intrinsic.Math.Sub(V.Local.iCustCount,1,V.Local.iCustMax)

'-- Build Geocodio batch request body: ["addr1, city, st", "addr2, city, st"]
V.Local.sBody.Set("[")
F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iCustMax,1)
    F.Intrinsic.Control.If(V.Local.iRow,>,0)
        V.Local.sBody.Append(",")
    F.Intrinsic.Control.EndIf
    F.Intrinsic.String.Build("{0}{1}, {2}, {3}{0}",V.Local.sQ,V.DataTable.dtCust(V.Local.iRow).ADDR,V.DataTable.dtCust(V.Local.iRow).CITY,V.DataTable.dtCust(V.Local.iRow).ST,V.Local.sTemp)
    V.Local.sBody.Append(V.Local.sTemp)
F.Intrinsic.Control.Next(V.Local.iRow)
V.Local.sBody.Append("]")

'-- Fix doubled quotes from GAB string escaping
F.Intrinsic.String.Replace(V.Local.sBody,V.Ambient.QuadQuote,V.Ambient.DblQuote,V.Local.sBody)

'-- Delete stale response file before POST
F.Intrinsic.String.Build("{0}georesponse.json",V.Ambient.ScriptPath,V.Local.sGeoPath)
F.Intrinsic.File.Exists(V.Local.sGeoPath,V.Local.bExists)
F.Intrinsic.Control.If(V.Local.bExists)
    F.Intrinsic.File.DeleteFile(V.Local.sGeoPath)
F.Intrinsic.Control.EndIf

'-- POST to Geocodio batch API
F.Communication.HTTP.ResetHeaders
F.Communication.HTTP.SetProperty("ContentType","application/json")
F.Communication.HTTP.SetProperty("PostData",V.Local.sBody)
F.Communication.HTTP.SetProperty("LocalFile",V.Local.sGeoPath)
F.Communication.HTTP.Post("https://api.geocod.io/v1.7/geocode?api_key=YOUR_KEY_HERE")

'-- Parse geocoded lat/lng from response and build data.js
F.Communication.JSON.Reset
F.Communication.JSON.ParseFile(V.Local.sGeoPath)

'-- Write data file with pre-geocoded lat/lng
F.Intrinsic.String.Build("{0}map_data.js",V.Ambient.ScriptPath,V.Local.sDataPath)
'... (build JS variable string with lat/lng from JSON XPath, write via String2File)

'-- Navigate WebView2 to HTML (which loads map_data.js via <script src>)
'... (build file:// URL, set Source)

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("LoadAndPushData_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndIf
Program.Sub.LoadAndPushData.End
```

**JSON XPath for Geocodio batch response:**
```
' Navigate to first result's best match:
F.Communication.JSON.SetProperty("XPath","/JSON/results/[1]/response/results/[1]/location/lat")
F.Communication.JSON.ReadProperty("XText",V.Local.sLat)
F.Communication.JSON.SetProperty("XPath","/JSON/results/[1]/response/results/[1]/location/lng")
F.Communication.JSON.ReadProperty("XText",V.Local.sLng)
' Note: Geocodio uses 1-based array indexing in XPath
```

> **Key rules:** `ExecuteScript` does NOT work on GsWebView2 (Error 3000). Use file-based injection: GAB writes a `.js` data file, HTML loads it via `<script src>`. Pre-compute For loop bounds with `F.Intrinsic.Math.Sub` (never use `.--` in bounds). Use `V.Ambient.DblQuote` and `QuadQuote` replace to build valid JSON. Delete stale response files before HTTP POST. Use `V.Ambient.ScriptPath` for sidecar file paths.

---

## Production Micro-Patterns

Short, composable patterns extracted from production scripts (`C:\Apps\Global`, RKing). Use these inside larger patterns A–G.

### Pattern: SaveToJson → File2String → WebView2 Data Pipeline

The canonical way to pass data from GAB DataTables to a WebView2-hosted HTML dashboard. This replaces manual JSON building with `String.Build` and `DblQuote`.

```
F.Data.DataTable.SaveToJson("dtData","C:\path\data.json")
F.Intrinsic.File.File2String("C:\path\data.json",V.Local.sJson)
' Embed JSON in a JS sidecar file:
F.Intrinsic.String.Build("window.DATA={0};",V.Local.sJson,V.Local.sJs)
F.Intrinsic.File.String2File("C:\path\data.js",V.Local.sJs)
' HTML loads via: <script src="data.js"></script>
```

> **Always use `SaveToJson`** for WebView2 data — never build JSON manually with `String.Build` and `DblQuote`. See Pattern F/G for full dashboard context.

### Pattern: DataTable Row Iteration (replaces banned recordset pattern)

```
V.Local.sSQL.Set("SELECT COLUMN_NAME FROM TABLE WHERE condition = 'value'")
F.Data.DataTable.CreateFromSQL("dt","con",V.Local.sSQL,True)
F.Intrinsic.Control.For(V.Local.iRow,0,V.DataTable.dt.RowCount--,1)
    V.Local.sVal.Set(V.DataTable.dt(V.Local.iRow).COLUMN_NAME!FieldVal)
    ' ... process row ...
F.Intrinsic.Control.Next(V.Local.iRow)
F.Data.DataTable.Close("dt")
```
' NOTE: OpenRecordset* is BANNED. Always use DataTable.CreateFromSQL for queries.

### Pattern: Context Menu (Production 4-Parameter)

Production scripts use the 4-parameter `ContextMenuAddItem` signature and `ContextMenuAttach` on the grid:

```
F.Intrinsic.UI.ContextMenuCreate("mnuGrid")
F.Intrinsic.UI.ContextMenuAddItem("mnuGrid","edit",0,"Edit Record")
F.Intrinsic.UI.ContextMenuAddItem("mnuGrid","delete",0,"Delete Record")
F.Intrinsic.UI.ContextMenuAddItem("mnuGrid","export",0,"Export to Excel")
F.Intrinsic.UI.SetItemEventHandler("mnuGrid","edit",HandleEdit)
F.Intrinsic.UI.SetItemEventHandler("mnuGrid","delete",HandleDelete)
F.Intrinsic.UI.SetItemEventHandler("mnuGrid","export",HandleExport)
Gui.frmMain.gsGC.ContextMenuAttach("gvMain","mnuGrid")
```

> See `GUI_EVENTS.md` for `ContextMenuAttach` wiring and `RowCellClick` event selection guidance.

### Pattern H: Reusable Popup Drill-Down Form

A secondary form that can be shown/hidden repeatedly without disposal. Used for detail views triggered by grid double-click or button press.

```
Program.Sub.ScreenSU.Start
Gui.frmMain..Create(BaseForm)
Gui.frmMain..Size(960,700)
Gui.frmMain..Caption("Main Form")
Gui.frmMain..Sizeable(True)
' ... main form controls ...
Gui.frmDetail..Create(BaseForm)
Gui.frmDetail..Size(600,450)
Gui.frmDetail..Caption("Detail View")
Gui.frmDetail..Sizeable(True)
Gui.frmDetail..MinX(400)
Gui.frmDetail..MinY(300)
Gui.frmDetail..ControlBox(False)
Gui.frmDetail.gsGC.Create(GsGridControl)
Gui.frmDetail.gsGC.Anchor(15)
Gui.frmDetail.gsGC.Size(570,380)
Gui.frmDetail.gsGC.Position(15,15)
Gui.frmDetail.cmdClose.Create(Button)
Gui.frmDetail.cmdClose.Size(80,30)
Gui.frmDetail.cmdClose.Position(505,410)
Gui.frmDetail.cmdClose.Anchor(10)
Gui.frmDetail.cmdClose.Caption("Close")
Gui.frmDetail.cmdClose.Event(Click,CloseDetail)
Program.Sub.ScreenSU.End

Program.Sub.ShowDetail.Start
V.Local.sKey.Declare(String,"")
F.Intrinsic.Variable.ArgToVar("sKey",V.Local.sKey)
' Clean up previous data (form persists between shows)
F.Intrinsic.Control.If(V.DataTable.dtDetail.Exists)
    F.Data.DataTable.Close("dtDetail")
F.Intrinsic.Control.EndIf
' Load fresh data for this key
V.Local.sSQL.Declare(String,"")
F.Intrinsic.String.Build("SELECT * FROM V_DETAIL_TABLE WHERE KEY_COL='{0}'",V.Local.sKey,V.Local.sSQL)
F.Data.DataTable.CreateFromSQL("dtDetail","",V.Local.sSQL)
Gui.frmDetail.gsGC.AddGridviewFromDatatable("dtDetail","gvDetail")
Gui.frmDetail.gsGC.MainView("gvDetail")
' Show (not create -- form already exists from ScreenSU)
Gui.frmDetail..Visible(True)
Program.Sub.ShowDetail.End

Program.Sub.CloseDetail.Start
' Hide, do NOT dispose -- allows re-show later
Gui.frmDetail..Visible(False)
Program.Sub.CloseDetail.End
```

**Key rules:**
- `ControlBox(False)` removes the X button (which would DISPOSE the form permanently)
- Close button uses `.Visible(False)` to hide without disposing
- Always clean up old DataTables at the TOP of ShowDetail (form persists between calls)
- Use `Anchor(15)` on the grid so it resizes with the popup
- Use `Anchor(10)` (Bottom+Right) on the Close button

### Pattern: DataView Filter (Search Box)

Apply a live filter to a grid DataView as the user types in a search box:

```
Program.Sub.SearchChanged.Start
V.Local.sSearch.Declare(String,"")
V.Local.sFilter.Declare(String,"")
V.Local.sSearchSafe.Declare(String,"")
V.Local.sSearch.Set(V.Screen.frmMain!txtSearch.Text)
F.Intrinsic.Control.If(V.Local.sSearch,=,"")
    F.Data.DataView.SetFilter("dtParts","dvParts","")
F.Intrinsic.Control.Else
    V.Local.sSearchSafe.Set(V.Local.sSearch.PSQLFriendly)
    F.Intrinsic.String.Build("PartNumber LIKE '%{0}%' OR Description LIKE '%{0}%'",V.Local.sSearchSafe,V.Local.sFilter)
    F.Data.DataView.SetFilter("dtParts","dvParts",V.Local.sFilter)
F.Intrinsic.Control.EndIf
Program.Sub.SearchChanged.End
```

**Key rules:**
- `SetFilter` takes 3 params: DataTable name, DataView name, filter expression
- Empty string `""` clears the filter (shows all rows)
- Always sanitize user input with `.PSQLFriendly` before embedding in filter expressions
- Wire to `Gui.frmMain.txtSearch.Event(TextChanged,SearchChanged)` in ScreenSU
