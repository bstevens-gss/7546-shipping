# GAB Linter Rules Reference

## Severity Levels

| Level | Meaning |
|-------|---------|
| **ERROR** | Will cause runtime failure, crash, or silent data corruption |
| **WARNING** | Likely failure, deprecated pattern, or known problematic approach |
| **CONVENTION** | Style/maintainability; won't cause runtime errors |

---

## A: Syntax & Operators

### A1 — Inline math operators
GAB has no `+`, `-`, `*`, `/` operators. All math must use `F.Intrinsic.Math.*` functions.

**Wrong:** `V.Local.iTotal = V.Local.iA + V.Local.iB`
**Right:** `F.Intrinsic.Math.Add(V.Local.iA,V.Local.iB,V.Local.iTotal)`

### A2 — String concatenation with +
The `+` symbol is treated as literal text, not an operator.

**Wrong:** `V.Local.s.Set(V.Local.sA + V.Local.sB)`
**Right:** `F.Intrinsic.String.Build("{0}{1}",V.Local.sA,V.Local.sB,V.Local.s)`

### A6 — CallWrapper casing
**Wrong:** `F.Global.Callwrapper` (lowercase w)
**Right:** `F.Global.CallWrapper` (capital W)

### A8 — Math for date arithmetic
`F.Intrinsic.Math.Add` on dates produces `1900-01-01`.

**Wrong:** `F.Intrinsic.Math.Add(V.Local.dDate,1,V.Local.dResult)`
**Right:** `F.Intrinsic.Date.DateAdd("D",1,V.Local.dDate,V.Local.dResult)`

### A10 — DoWhile keyword (ERROR)
`DoWhile` does not exist in GAB. Only `For`/`Next` and `DoUntil`/`Loop` are valid loop constructs.

**Wrong:** `DoWhile V.Local.iCount < 10`
**Right:** `DoUntil V.Local.iCount >= 10` … `Loop` or use `For`/`Next`

---

## B: Properties & Accessors

### B1 — Property reads with parentheses
Variable properties are NEVER function calls. Parentheses cause runtime errors.

**Wrong:** `V.Local.s.Set(V.Screen.frm!txt.Text())`
**Right:** `V.Local.s.Set(V.Screen.frm!txt.Text)`

Affected properties: `.Text`, `.Tab`, `.ListIndex`, `.PervasiveDate`, `.Caption`,
`.UBound`, `.PSQLFriendly`, `.Exists`, `.Long`, `.Trim`, `.Float`, `.Boolean`, etc.

### B2 — UBound as function
**Wrong:** `F.Intrinsic.String.UBound(V.Local.sArray,V.Local.iResult)`
**Right:** `V.Local.iResult.Set(V.Local.sArray.UBound)`

### B5 — Dynamic Left/Right
**Wrong:** `V.Local.sResult.Set(V.Local.sStr.Left(3))`
**Right:** `F.Intrinsic.String.Left(V.Local.sStr,3,V.Local.sResult)` or `.Left3`

### B6 — Dot-chained FieldVal accessors
**Wrong:** `!FieldVal.Long`, `!FieldVal.Trim`
**Right:** `!FieldValLong`, `!FieldValTrim` (single token, no dot)

### B7 — Chained accessor on accessor
**Wrong:** `!FieldValTrim.Long`
**Right:** `!FieldValLong` or extract to variable first

### B9 — Exists.Not
**Wrong:** `V.DataTable.dtName.Exists.Not`
**Right:** `F.Intrinsic.Control.If(V.DataTable.dtName.Exists,=,False)`

---

## C: GUI Read/Write

### C4 — FontBold/FontItalic
**Wrong:** `.FontBold(True)`
**Right:** `.FontStyle(True,False,False,False,False)` (5 boolean params)

### C5 — Checked on checkboxes
**Wrong:** `.Checked(True)`
**Right:** `.Value(True)` / `.Value(False)`

### C7, C8 — Form Create syntax
**Wrong:** `.Create()`, `.Create(Form)`
**Right:** `.Create(BaseForm)`, `.Create(DashForm)`, `.Create(DialogForm)`

### C9 — Form Unload
**Wrong:** `Gui.frmMain..Unload`
**Right:** `.Visible(False)`, `.Close`, or `F.Intrinsic.Control.End`

### C10 — .Text() on non-text controls
`.Text()` only works on TextBox/TextboxM/RichEdit. On buttons, labels, checkboxes,
and frames it causes Error 600.

**Wrong:** `Gui.frm.cmdSave.Text("Save")`
**Right:** `Gui.frm.cmdSave.Caption("Save")`

### C15 — ReadOnly on TextBox
**Wrong:** `Gui.frm.txtName.ReadOnly(True)`
**Right:** `Gui.frm.txtName.Locked(True)`

---

## D: Grid & Data Binding

### D6 — FocusedRowHandle property
`GetGridviewProperty("gv","FocusedRowHandle",...)` is not supported.
Use `GetSelectedRowsInFocus` for button-click row resolution.

### D7 — Legacy grid controls
`GsFlexGrid` / `HFlexGrid` are deprecated. Use `GsGridControl`.

### D10 — GetSelectedRowsInFocus wrong param count (ERROR)
Takes 1 param only (return variable). Does NOT accept a gridview name.

**Wrong:** `Gui.frmMain.gsGC.GetSelectedRowsInFocus("gvMain",V.Local.sRows)`
**Right:** `Gui.frmMain.gsGC.GetSelectedRowsInFocus(V.Local.sRows)`

### D11 — GetSelectedRows too many params (ERROR)
Takes exactly 2 params: (gridViewName, returnVar).

**Wrong:** `Gui.frmMain.gsGC.GetSelectedRows("gvMain",V.Local.iCount,V.Local.sRows)`
**Right:** `Gui.frmMain.gsGC.GetSelectedRows("gvMain",V.Local.sRows)`

### D12 — GetCellValueByColumnName param order (ERROR)
2nd param must be a string column name literal, not a variable.

**Wrong:** `Gui.frmMain.gsGC.GetCellValueByColumnName("gvMain",V.Local.iRow,"PART",V.Local.sPart)`
**Right:** `Gui.frmMain.gsGC.GetCellValueByColumnName("gvMain","PART",V.Local.iRow,V.Local.sPart)`

### D13 — GetCellValue with string column name (ERROR)
2nd param is an INTEGER column index, not a string column name.

**Wrong:** `Gui.frmMain.gsGC.GetCellValue("gvMain","PART",0,V.Local.sVal)`
**Right:** `Gui.frmMain.gsGC.GetCellValue("gvMain",iColIndex,0,V.Local.sVal)` or use `GetCellValueByColumnName`

### D14 — SetCellValue with string column name (ERROR)
Same as D13: 2nd param must be integer column index.

**Wrong:** `Gui.frmMain.gsGC.SetCellValue("gvMain","STATUS",0,"Done")`
**Right:** `Gui.frmMain.gsGC.SetCellValueByColumnName("gvMain","STATUS",0,"Done")`

### D15 — HideRow missing boolean (ERROR)
Requires 3 params: (gridViewName, rowIndex, boolean).

**Wrong:** `Gui.frmMain.gsGC.HideRow("gvMain",V.Local.iRow)`
**Right:** `Gui.frmMain.gsGC.HideRow("gvMain",V.Local.iRow,True)`

### D16 — ExportDetails wrong first param (ERROR)
Params are (fileFormat, filePath, mode). First param is format, not gridview.

**Wrong:** `Gui.frmMain.gsGC.ExportDetails("gvMain","C:\out.xlsx","xlsx")`
**Right:** `Gui.frmMain.gsGC.ExportDetails("xlsx","C:\out.xlsx",0)`

### D17 — AddRow missing values (ERROR)
GsGridControl.AddRow requires delimited values matching column count.

**Wrong:** `Gui.frmMain.gsGC.AddRow("gvMain")`
**Right:** `Gui.frmMain.gsGC.AddRow("gvMain","val1*!*val2*!*val3")`

---

## E: DataTable & ODBC

### E5 — ODBC IsOpen
`V.ODBC.conName.IsOpen` does not exist. Use Try/Catch around Close.

### E6 — Hardcoded connection strings
Use `V.Ambient.PDSN`, `V.Ambient.PUser`, `V.Ambient.PPass`.

---

## F: File I/O

### F3 — AppendToFile
**Wrong:** `F.Intrinsic.File.AppendToFile(...)`
**Right:** `F.Intrinsic.File.Append2File(...)` or `Append2FileNewLine(...)`

### F4 — Blank lines in ScreenSU
The GAB IDE strips blank lines from ScreenSU blocks on save. Keep them packed.

---

## G: CallSub & Error Handling

### G1 — Array elements in CallSub
GAB passes the entire array, not the element at index N.

**Wrong:** `CallSub(MySub,"sArg",V.Local.sParts(1))`
**Right:** `V.Local.sTemp.Set(V.Local.sParts(1))` then `CallSub(MySub,"sArg",V.Local.sTemp)`

### G2 — V.Args in CallSub targets
`V.Args` is for event arguments (grid/form events), not CallSub parameters.

**Wrong:** `V.Args.sName.Declare(String)`
**Right:** `F.Intrinsic.Variable.ArgToVar("sName",V.Local.sName)`

### G4 — Nested Try/Catch
GAB tracks only one Try/Catch context per subroutine. Nesting misroutes errors.

**Wrong:** Two `Try` blocks in the same subroutine
**Right:** Use `SetErrorHandler` for the sub; single small `Try` only for one risky op

---

## H: Invented APIs

These functions/methods DO NOT EXIST in GAB:

| Rule | Invented API | Correct Alternative |
|------|-------------|---------------------|
| H1 | `F.Global.Inventory.Browse()` | `F.Intrinsic.UI.Browser` with SQL |
| H2a | `F.Data.Dictionary.Set()` | `.AddItem()` / `.UpdateItem()` |
| H2b | `F.Data.Dictionary.Get()` | `V.Dictionary.dict![key]` / `.GetItem()` |
| H3a | `F.Intrinsic.String.Count()` | `F.Intrinsic.String.Occurs()` |
| H3b | `F.Intrinsic.String.GetElement()` | `V.Local.sArray(iIndex)` after Split |
| H4 | `V.Ambient.UserID` | `V.Caller.User` |
| H5 | DevExpress grid methods | GAB grid API equivalents |
| H6 | `AddRepositoryComboBox` | `ColumnEdit` / `RowColumnEdit` |
| H7 | `Dictionary.Create("n","String","String")` | `Dictionary.Create("n")` |
| H8 | `AppendToFile` | `Append2File` / `Append2FileNewLine` |
| H9 | `V.Ambient.ScriptDirectory` | `V.Ambient.ScriptPath` |
| H10 | `F.Intrinsic.Control.DoWhile` | `F.Intrinsic.Control.For` or `DoUntil` |
| H11 | `GsWebView2.ExecuteScript()` | File-based JSON injection into HTML |
| H12 | `V.Caller.FilePath` | `V.Ambient.ScriptPath` |
| H13 | `F.Intrinsic.String.Chr()` | `V.Ambient.DblQuote` for double-quote |
| H14 | `V.Args.RowHandle` (FocusedRowChanged) | `V.Args.FocusedRowHandle` |
| H15 | `V.Args.Column` (RowCellClick) | Use `GetCellValueByColumnName` |
| H16 | `V.Args.CellValue` (RowCellClick) | Use `GetCellValueByColumnName` |
| H17 | `CreatePieChart` (any format) | `CreateVertBarChart` + `AddSeriesToBarChart` loop |
| H18 | `F.Data.DataTable.GetRowCount/GetColumnCount/GetColumnNames/GetValue` | `V.DataTable.dt.RowCount` / `V.DataTable.dt(row).Col!FieldVal` |
| H19 | `V.*.Prepend()` | `.Set()` with `F.Intrinsic.String.Build` to prepend |
| H20 | `F.Intrinsic.String.IsNumeric` | `F.Intrinsic.Math.IsNumeric` |
| H21 | `V.Args.*.Set()` | Use `V.Global` for writable return buffers |
| H22 | `F.ODBC.Connection!*.Open()` (bare) | `OpenConnection(DSN,user,pass)` or `OpenCompanyConnection` |
| H27 | `.RemoveGridView()` | Does not exist — grid views cannot be removed at runtime |
| H28 | `.SetFocusedRow()` | `SelectRow("gvName", iRow)` or `FocusCell("gvName", iRow, iCol)` |
| H29 | `.SelectedPage()` | Tab: `SetTab(n)` / NavFrame: `SelectedIndex(n)` |
| H30 | `V.Ambient.TempDir` | `V.Caller.TempDir` or `V.Caller.LocalGSSTempDir` |
| H32 | `.GetTab()` | `V.Screen.frmName!tabName.Tab` (read) / `SetTab(n)` (set) |

### H18 — DataTable invented methods (ERROR)
`GetRowCount`, `GetColumnCount`, `GetColumnNames`, and `GetValue` do NOT exist on `F.Data.DataTable`.

**Wrong:** `F.Data.DataTable.GetRowCount("dt",V.Local.iRows)`
**Right:** `V.Local.iRows.Set(V.DataTable.dt.RowCount)`

**Wrong:** `F.Data.DataTable.GetValue("dt",1,"ColName",V.Local.sVal)`
**Right:** `V.Local.sVal.Set(V.DataTable.dt(1).ColName!FieldVal)`

There is no GAB equivalent for `GetColumnCount` or `GetColumnNames`.

### H19 — .Prepend() (ERROR)
`.Prepend()` does not exist on GAB string variables (0 hits in production code).

**Wrong:** `V.Local.sResult.Prepend("prefix")`
**Right:** `F.Intrinsic.String.Build("{0}{1}","prefix",V.Local.sResult,V.Local.sResult)`

### H20 — IsNumeric wrong namespace (ERROR)
`IsNumeric` lives under `Math`, not `String`.

**Wrong:** `F.Intrinsic.String.IsNumeric(V.Local.sVal,V.Local.iIsNum)`
**Right:** `F.Intrinsic.Math.IsNumeric(V.Local.sVal,V.Local.iIsNum)`

### H21 — Writing to V.Args (ERROR)
`V.Args` variables are read-only event arguments. Cannot call `.Set()` on them.

**Wrong:** `V.Args.sReturn.Set("value")`
**Right:** `V.Global.sReturn.Set("value")`

### H22 — Bare ODBC .Open() (WARNING)
Bare `.Open()` does not exist on ODBC connection objects. Use the named open methods.

**Wrong:** `F.ODBC.Connection!con.Open()`
**Right:** `F.ODBC.Connection!con.OpenConnection(V.Ambient.PDSN,V.Ambient.PUser,V.Ambient.PPass)` or `OpenCompanyConnection`

### H23 — F.Data.DataView.Filter (ERROR)
`F.Data.DataView.Filter` does not exist. The correct function is `SetFilter` with 3 parameters.

**Wrong:** `F.Data.DataView.Filter("dvParts","PartNumber LIKE '%widget%'")`
**Right:** `F.Data.DataView.SetFilter("dtParts","dvParts","PartNumber LIKE '%widget%'")`

### H24 — F.Intrinsic.String.Chr (ERROR)
`F.Intrinsic.String.Chr()` does not exist in GAB. For special characters, use ambient variables.

**Wrong:** `F.Intrinsic.String.Chr(34,V.Local.sQuote)`
**Right:** `V.Local.sQuote.Set(V.Ambient.DblQuote)` (for `"`) or `V.Local.sCR.Set(V.Ambient.CR)` (for CR)

### H25 — F.Intrinsic.UI.DropDown (ERROR)
`F.Intrinsic.UI.DropDown()` does not exist in GAB (error 999000).

**Wrong:** `F.Intrinsic.UI.DropDown("Select Part","210900~210901~210902",V.Local.sResult)`
**Right:** `F.Intrinsic.UI.BrowserFromString("Select Part","210900~210901~210902","|","~","Part","200",V.Local.sResult)`

### H26 — Change event on Tab/controls (ERROR)
`Change` is not a valid event for Tab controls (or most GAB controls). Tab uses `Click`.

**Wrong:** `Gui.frmMain.tabMain.Event(Change,TabChanged)`
**Right:** `Gui.frmMain.tabMain.Event(Click,TabClicked)` — read `V.Screen.frmMain!tabMain.Tab` for active index

### H27 — RemoveGridView (ERROR)
`RemoveGridView` does not exist on GsGridControl. Grid views cannot be removed at runtime.

**Wrong:** `Gui.frmMain.gsGC.RemoveGridView("gvTemp")`
**Right:** Use `ClearRows("gvName")` to clear data, or `Visible(False)` to hide the entire grid.

### H28 — SetFocusedRow (ERROR)
`SetFocusedRow` does not exist. The runtime exposes `SelectRow` and `FocusCell`.

**Wrong:** `Gui.frmMain.gsGC.SetFocusedRow("gvMain",V.Local.iRow)`
**Right:** `Gui.frmMain.gsGC.SelectRow("gvMain",V.Local.iRow)`

### H29 — SelectedPage on Tab/NavFrame (ERROR)
`SelectedPage` is not exposed as a GAB method on either Tab or NavFrame controls.

**Wrong:** `Gui.frmMain.tabMain.SelectedPage(2)` or `Gui.frmMain.navMain.SelectedPage(1)`
**Right:** `Gui.frmMain.tabMain.SetTab(2)` / `Gui.frmMain.navMain.SelectedIndex(1)`

### H30 — V.Ambient.TempDir (ERROR)
`V.Ambient.TempDir` does not exist. Temp directories are under `V.Caller`.

**Wrong:** `F.Intrinsic.String.Build("{0}myfile.tmp",V.Ambient.TempDir,V.Local.sPath)`
**Right:** `F.Intrinsic.String.Build("{0}myfile.tmp",V.Caller.TempDir,V.Local.sPath)`

### H32 — GetTab on Tab controls (ERROR)
`.GetTab()` does not exist. Read the active tab via `V.Screen` property; set it via `SetTab(n)`.

**Wrong:** `Gui.frmMain.tabDetail.GetTab(V.Local.iTab)`
**Right:** `V.Local.iTab.Set(V.Screen.frmMain!tabDetail.Tab)` (read) / `Gui.frmMain.tabDetail.SetTab(2)` (set)

### A1b/A1c — Inline arithmetic in function arguments (ERROR)
GAB has no inline operators anywhere, including inside function call parentheses.

**Wrong:** `F.Intrinsic.Control.For(V.Local.i,0,V.Local.iMax - 1,1)`
**Right:**
```
F.Intrinsic.Math.Sub(V.Local.iMax,1,V.Local.iLast)
F.Intrinsic.Control.For(V.Local.i,0,V.Local.iLast,1)
```

### A1d — `--` suffix on variables (ERROR)
The `--` suffix only works on the `RowCount` property of DataTables (meaning "RowCount minus 1"). It is NOT a general decrement operator and does NOT work on `V.Local` or `V.Global` variables.

**Wrong:** `F.Intrinsic.Control.For(V.Local.i,0,V.Local.iRows--,1)`
**Right:**
```
F.Intrinsic.Math.Sub(V.Local.iRows,1,V.Local.iMax)
F.Intrinsic.Control.For(V.Local.i,0,V.Local.iMax,1)
```

**Valid usage:** `F.Intrinsic.Control.For(V.Local.i,0,V.DataTable.dt.RowCount--,1)` — this IS valid because `RowCount--` is the special property.

---

## I: ScreenSU Restrictions (Runtime-verified 2026-05-23)

### I1 — V.Color in ScreenSU
`V.Color.*` resolves to empty string in ScreenSU. Causes Error 113.

**Wrong:** `Gui.frm.fra.BackColor(V.Color.Gray)` in ScreenSU
**Right:** Set colors at runtime in a `SetupColors` sub called from Main

### I2 — CheckBox Value type
CheckBox `.Value` is Long (0/1), not Boolean.

**Wrong:** `.Value(True)` / `.Value(False)`
**Right:** `.Value(1)` / `.Value(0)`

### I3 — DataTable accessor syntax
**Wrong:** `V.DataTable.dtName!ColName(rowIndex)`
**Right:** `V.DataTable.dtName(rowIndex).ColName!FieldVal`

### I4 — .Length() with parentheses
`.Length` is a property, not a method. Parentheses cause Error 113.

**Wrong:** `V.Local.sStr.Length()`
**Right:** `V.Local.sStr.Length`

### I5 — Raw table names in SELECT
Always use `V_*` views for reads. Raw table column names may differ from view columns.

**Wrong:** `SELECT * FROM ORDER_HEADER`
**Right:** `SELECT * FROM V_ORDER_HEADER`

### I6 — Panel control (does not exist)
`Panel` is not a GAB control. Use `Frame` as the container.

**Wrong:** `Gui.frm.pnl.Create(Panel)`
**Right:** `Gui.frm.fra.Create(Frame)`

### I7 — GsWebView2.Navigate() (does not exist)
`.Navigate()` causes Error 3000. Use `.Source()` to change the URL.

**Wrong:** `Gui.frm.wv2.Navigate(url)`
**Right:** `Gui.frm.wv2.Source(url)`

### I8 — F.Intrinsic.String for file ops (wrong namespace)
File operations live under `F.Intrinsic.File`, not `F.Intrinsic.String`.

**Wrong:** `F.Intrinsic.String.String2File(...)` / `F.Intrinsic.String.File2String(...)`
**Right:** `F.Intrinsic.File.String2File(...)` / `F.Intrinsic.File.File2String(...)`

### I9 — ScriptPath without backslash separator
`V.Ambient.ScriptPath` has no trailing `\` when launched via `.gaf`. Always add `\` in path builds.

**Wrong:** `F.Intrinsic.String.Build("{0}MyFile.dll",V.Ambient.ScriptPath,...)`
**Right:** `F.Intrinsic.String.Build("{0}\MyFile.dll",V.Ambient.ScriptPath,...)`

### I10 — F.Intrinsic.File.Delete (does not exist)
`F.Intrinsic.File.Delete` and `F.Intrinsic.File.Kill` cause Error 999000. Use `F.Intrinsic.File.DeleteFile`.

**Wrong:** `F.Intrinsic.File.Delete(path)` / `F.Intrinsic.File.Kill(path)`
**Right:** `F.Intrinsic.File.DeleteFile(path)`

### I11 — Variable declarations inside control flow blocks
Variable declarations inside `Try/Catch`, `If/Else`, or `For/Next` blocks crash GAB at parse time with no error message. All declarations must be at the subroutine top.

**Wrong:**
```
F.Intrinsic.Control.Try
    V.Local.sResult.Declare(String,"")
    ...
F.Intrinsic.Control.EndTry
```
**Right:**
```
V.Local.sResult.Declare(String,"")
F.Intrinsic.Control.Try
    ...
F.Intrinsic.Control.EndTry
```

### I12 — V.Ambient.ApplicationPath (does not exist)
`V.Ambient.ApplicationPath`, `V.Ambient.MachineName`, `V.Ambient.UserName`, `V.Ambient.StartupPath` all cause Error 5150. They are NOT valid ambient variables.

### I13 — DataTable.SaveToJson writes to FILE, not variable
`SaveToJson` and `SaveToXML` write to FILES. They do NOT return JSON/XML strings.

**Wrong:** `F.Data.DataTable.SaveToJson("dt",V.Local.sJson)`
**Right:** `F.Data.DataTable.SaveToJson("dt","C:\path\output.json")`
**SaveToXML:** `F.Data.DataTable.SaveToXML("dt",0,True,"C:\path\output.xml")`

### I14 — DataTable.AddRow with positional args
`AddRow` requires column-name/value PAIRS, not positional values.

**Wrong:** `F.Data.DataTable.AddRow("dt","value1","value2")`
**Right:** `F.Data.DataTable.AddRow("dt","Col1","value1","Col2","value2")`

### I15 — V.DataTable.ColumnCount (does not exist)
`V.DataTable.name.ColumnCount` is not valid. Only `.RowCount` and `.Exists` work.

### I16 — Dot-separated form names (Gui.Form.Name.)
**Wrong:** `Gui.Form.frmDash.Create(...)` (dot between Form and name)
**Right:** `Gui.Form_frmDash..Create(BaseForm)` (underscore between Form and name)

### I17 — Inline form creation
**Wrong:** `Gui.Form.Create("frmDash",960,720,"Title")`
**Right:** `Gui.Form_frmDash..Create(BaseForm)` + `..Caption("Title")` + `..Size(960,720)`

### I18 — CommandButton control type
**Wrong:** `Gui.frm.btn.Create(CommandButton)`
**Right:** `Gui.frm.btn.Create(Button)`

### I19 — Inline position/size in Create
**Wrong:** `Gui.frm.btn.Create(Button,"Save",10,90,140,30)`
**Right:** `Gui.frm.btn.Create(Button)` + `.Size(140,30)` + `.Position(10,90)` + `.Caption("Save")`

### I20 — Dock(5) before sibling controls
Dock(5) (Fill) consumes all remaining space. If set before other controls are added, it covers them.

**Wrong:**
```
Gui.frm.gsGC.Create(GsGridControl)
Gui.frm.gsGC.Dock(5)
Gui.frm.fraToolbar.Create(Frame)
Gui.frm.fraToolbar.Dock(1)
```
**Right (dock Top/Bottom first, Fill last):**
```
Gui.frm.fraToolbar.Create(Frame)
Gui.frm.fraToolbar.Dock(1)
Gui.frm.gsGC.Create(GsGridControl)
Gui.frm.gsGC.Dock(5)
```

### I21 — Sizeable(False) with no MinX/MinY
Resizable forms should always set minimum dimensions. `MinX(0)/MinY(0)` allows collapse to zero.

### I22 — Panel control (does not exist)
`Panel` is not a valid GAB control type. Use `Frame` as a container.

**Wrong:** `Gui.frm.pnl.Create(Panel)`
**Right:** `Gui.frm.fra.Create(Frame)`

### I23 — DataTable accessor with comma (ERROR)
Comma-separated column inside accessor parentheses is invalid syntax.

**Wrong:** `V.DataTable.dtName(1,"ColName")`
**Right:** `V.DataTable.dtName(1).ColName!FieldVal`

### I24 — .gaf INI format (ERROR)
`.gaf` launch files use `key::value` format, not Windows INI format. Applies only to `.gaf` files.

**Wrong:**
```
[GAF]
ScriptPath=C:\path\script.g2u
```
**Right:**
```
TRANSID::900000
SCRIPT::C:\path\script.g2u
```

---

## L: Layout & Anchoring

### L1 — Missing Anchor on resizable form controls
When `.Sizeable(True)` is set on the form, controls without `.Anchor()` default to `5` (Top+Left) and won't resize.

### L2 — Anchor value reference
| Value | Edges | Use |
|------:|-------|-----|
| 5 | Top+Left | Fixed position (default) |
| 6 | Bottom+Left | Bottom-left buttons |
| 9 | Top+Right | Top-right buttons |
| 10 | Bottom+Right | Close/Cancel corner |
| 13 | Top+Left+Right | Header/toolbar band |
| 14 | Bottom+Left+Right | Status bar band |
| 15 | All | Fill (grids, tabs, main content) |

### L3 — DashForm vs BaseForm for dock panels
`BaseForm` does not support `DockPanel` controls. Use `DashForm` for dockable panel layouts.

---

## M: Missing/Invented APIs (from test sessions)

### M1 — F.Intrinsic.UI.DropDown (does NOT exist)
`F.Intrinsic.UI.DropDown()` is not a valid GAB function.
**Right:** `F.Intrinsic.UI.BrowserFromString("Title","Item1~Item2~Item3","|","~","Column","200",V.Local.sResult)`

### M2 — F.Intrinsic.UI.MsgBox2 (does NOT exist in some runtimes)
**Right:** `F.Intrinsic.UI.Msgbox(sMessage,"Title",V.Enum.MsgBoxStyle!YesNo,V.Local.iReturnButton)`

### M3 — DropDownList/ComboBox .Clear() (does NOT exist)
**Right:** Use `.ClearItems` to remove all items from list controls.

### M4 — SetCellValueByColumnName (does NOT exist)
**Right:** `F.Data.DataTable.SetValue("dtName",rowIndex,"ColName","value")` or `AddRow` with col/val pairs.

### M5 — AllowGroup grid property (does NOT exist)
**Right:** Use `ShowGroupPanel` as the `SetGridviewProperty` name.

### M6 — SetIcon/SvgPicture enum refs in ScreenSU
`SetIcon(V.Enum.FormIconApplication!...)` and `SvgPicture(V.Enum.Image!...)` crash ScreenSU at parse time. Set at runtime.

### M7 — F.Global.Inventory.CreatePart (may not exist)
May return error 999000. Use `AddPartToBatch` + `PostPartBatch` (production batch pattern).

### M8 — String.Mid with length 0
`F.Intrinsic.String.Mid(source, start, 0, result)` returns empty string, NOT "rest of string". Use Replace or Right.

### M9 — System.String as DataTable column type
GAB uses `"String"`, `"Float"`, `"Long"` -- NOT `"System.String"`, `"System.Decimal"` (error 21015).

---

## N: V.Args & Event Behavior

### N1 — V.Args.*ControlName returns UPPERCASE
`V.Args.GsCardViewControlName`, `V.Args.ControlName`, and similar return names in **ALL UPPERCASE** (e.g., `GSCARDTODO` not `gsCardToDo`). Always normalize with `F.Intrinsic.String.UCase` before comparing.

### N2 — DataTable.DeleteRow only marks for deletion
`F.Data.DataTable.DeleteRow` does NOT physically remove the row. Call `F.Data.DataTable.AcceptChanges("dtName")` afterward.

### N3 — AccordionControl.NavigationFrame does NOT auto-switch
Must manually call `navMain.SelectedIndex(n)` in the `ElementClick` handler based on `V.Args.ElementID`.

---

## P: Legacy

### P1 — UDTs deprecated
`Variable.Define`, `V.uLocal`, `V.uGlobal` are deprecated. Use DataTable.
