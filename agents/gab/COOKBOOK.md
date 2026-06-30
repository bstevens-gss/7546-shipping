# GAB COOKBOOK -- Task-Oriented Quick Reference
# When you need to DO something, look it up here. Every entry is verified working code.
# Source: extracted from agents/gab/*.md reference files + production dashboards
---

## DASHBOARD SCAFFOLD (Most Common Project Pattern)

This is the #1 pattern you build. Every dashboard follows this exact lifecycle.
Reference: `GAB_6039_BOM_WO_Status.g2u`, `PPT_AR_Aging_Dash.g2u`, `PPT_OpenWorkOrders.g2u`

### Main sub lifecycle
```
Program.Sub.Main.Start
F.Intrinsic.Control.Try
V.Local.sError.Declare
V.Local.sIcon.Declare

F.Intrinsic.String.Build("{0}\GAB\GAS\gss2.ico",V.Caller.PluginsDir,V.Local.sIcon)
Gui.frmMain..Icon(V.Local.sIcon)

F.Intrinsic.Control.CallSub(SetAnchors)
F.Intrinsic.Control.CallSub(SetContextMenus)

F.ODBC.Connection!con.OpenConnection(V.Ambient.PDSN,V.Ambient.PUser,V.Ambient.PPass,500)

Gui.frmMain..Show()

F.Intrinsic.Control.BlockEvents
F.Intrinsic.Control.CallSub(LockScreen)
F.Intrinsic.Control.CallSub(LoadData)
F.Intrinsic.Control.CallSub(EnableScreen)
F.Intrinsic.Control.UnBlockEvents
F.Intrinsic.Control.CallSub(Deserialize)

F.Intrinsic.Control.Catch
    F.Intrinsic.String.Build("Project: {0}{1}{1}Sub: {2}{1}Error {3}: {4}",V.Ambient.ScriptPath,V.Ambient.Newline,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndTry
Program.Sub.Main.End
```
' CRITICAL: Show BEFORE data load. BlockEvents prevents cascade. LockScreen hides grid.
' Connection opens BEFORE Show. Deserialize restores saved column layout.

### LockScreen / EnableScreen pair
```
Program.Sub.LockScreen.Start
Gui.frmMain.lblStatus.Visible(True)
Gui.frmMain.progressBar1.Visible(True)
Gui.frmMain.gsGC.Visible(False)
Program.Sub.LockScreen.End

Program.Sub.EnableScreen.Start
Gui.frmMain.gsGC.Visible(True)
Gui.frmMain.lblStatus.Visible(False)
Gui.frmMain.progressBar1.Visible(False)
Program.Sub.EnableScreen.End
```

### SetAnchors (resizable forms)
```
Program.Sub.SetAnchors.Start
'Bitmask: 0=None, 1=Top, 2=Bottom, 4=Left, 8=Right, 15=All
Gui.frmMain.gsGC.Anchor(15)
Gui.frmMain.lblStatus.Anchor(5)
Gui.frmMain.progressBar1.Anchor(5)
Program.Sub.SetAnchors.End
```
' 15 = all sides (grid fills). 5 = top+left. 9 = top+right.

### LoadData (flat grid - most common)
```
Program.Sub.LoadData.Start
F.Intrinsic.Control.Try
V.Local.sError.Declare
V.Local.sSQL.Declare(String)

Gui.frmMain.lblStatus.Caption("Loading data...")

F.Intrinsic.Control.If(V.DataTable.dtOrders.Exists,=,True)
    F.Data.DataTable.Close("dtOrders")
F.Intrinsic.Control.EndIf

V.Local.sSQL.Set("SELECT JOB,SUFFIX,PART,DESCRIPTION,QTY_ORDER,DATE_DUE FROM V_JOB_HEADER WHERE DATE_CLOSED = '1900-1-1' ORDER BY DATE_DUE")
F.Data.DataTable.CreateFromSQL("dtOrders","con",V.Local.sSQL,True)

F.Intrinsic.Control.CallSub(LoadGridView)

F.Intrinsic.Control.Catch
    F.Intrinsic.String.Build("Project: {0}{1}{1}Sub: {2}{1}Error {3}: {4}",V.Ambient.ScriptPath,V.Ambient.Newline,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndTry
Program.Sub.LoadData.End
```
' ALWAYS close existing DT before recreating. CreateFromSQL: name, CONN, SQL, global.

### LoadGridView (flat grid bind via DataTable)
```
Program.Sub.LoadGridView.Start
Gui.frmMain.gsGC.AddGridviewFromDatatable("dtOrders","gvOrders")
Gui.frmMain.gsGC.MainView("gvOrders")
Gui.frmMain.gsGC.SuspendLayout()
Gui.frmMain.gsGC.SetGridViewProperty("gvOrders","MultiSelect",True)
Gui.frmMain.gsGC.SetGridViewProperty("gvOrders","AllowSort",True)
Gui.frmMain.gsGC.SetGridViewProperty("gvOrders","AllowFilter",True)
Gui.frmMain.gsGC.SetGridViewProperty("gvOrders","OptionsViewColumnAutoWidth",False)
Gui.frmMain.gsGC.SetGridViewProperty("gvOrders","OptionsViewShowGroupPanel",False)
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","JOB","Caption","Job")
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","JOB","Width",80)
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","JOB","Fixed","Left")
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","JOB","ReadOnly",True)
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","JOB","CellForeColor",V.Enum.ThemeColors!AccentColor)
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","DATE_DUE","DisplayCustomDatetime","d")
Gui.frmMain.gsGC.SetColumnProperty("gvOrders","DATE_DUE","HeaderHAlignment","Center")
Gui.frmMain.gsGC.ResumeLayout()
Gui.frmMain.gsGC.BestFitColumns("gvOrders")
Program.Sub.LoadGridView.End
```
' AddGridviewFromDatatable(dtName, gvName). MainView AFTER bind.
' SuspendLayout/ResumeLayout wraps ALL property calls.
' CellForeColor = AccentColor makes column clickable-looking for drill-down.

### LoadGridView (DataView bind - for hierarchical or filtered)
```
F.Data.DataView.Create("dtOrders","dvOrders")
Gui.frmMain.gsGC.AddGridViewFromDataView("gvOrders","dtOrders","dvOrders")
Gui.frmMain.gsGC.MainView("gvOrders")
```
' Use DataView when: (a) master-detail AddRelation, (b) live filter needed.
' AddGridViewFromDataView params: gvName, dtName, dvName.

### Hierarchical grid (master-detail with AddRelation)
```
'-- 1. Create parent DT
F.Data.DataTable.CreateFromSQL("dtParent","con",V.Local.sSQLParent,True)

'-- 2. Create child DT with $ naming convention
F.Data.DataTable.CreateFromSQL("dtParent$dtChild","con",V.Local.sSQLChild,True)

'-- 3. Add relation (parent DT, parent key col, child DT, child key col, relation name)
F.Data.DataTable.AddRelation("dtParent","JOB","dtParent$dtChild","PARENT_WO","Children")

'-- 4. Create DataViews for both
F.Data.DataView.Create("dtParent","dvParent")
F.Data.DataView.Create("dtParent$dtChild","dvChild")

'-- 5. Bind parent as main, child as detail
Gui.frmMain.gsGC.AddGridViewFromDataView("gvParent","dtParent","dvParent")
Gui.frmMain.gsGC.AddGridViewFromDataView("gvChild","dtParent$dtChild","dvChild")
Gui.frmMain.gsGC.MainView("gvParent")
```
' CRITICAL: Child DT name uses $ (dtParent$dtChild). This is NOT optional.
' AddRelation keys MUST be unique in parent. Use SELECT DISTINCT or composite keys.
' User says "child grid" → this pattern. NOT two separate GsGridControl instances.

### RowCellClick handler (drill-down via CallWrapper)
```
Program.Sub.gsGC_RowCellClick.Start
F.Intrinsic.Control.Try
V.Local.sError.Declare
V.Local.sJob.Declare(String)
V.Local.sSuffix.Declare(String)
V.Local.sParams.Declare(String)

F.Intrinsic.Control.SelectCase(V.Args.Column)
    F.Intrinsic.Control.CaseAny("JOB","SUFFIX")
        Gui.frmMain..Enabled(False)
        Gui.frmMain.gsGC.GetCellValueByColumnName("gvOrders","JOB",V.Args.RowIndex,V.Local.sJob)
        Gui.frmMain.gsGC.GetCellValueByColumnName("gvOrders","SUFFIX",V.Args.RowIndex,V.Local.sSuffix)
        F.Intrinsic.String.Build("7!*!{0}!*!{1}!*!A",V.Local.sJob,V.Local.sSuffix,V.Local.sParams)
        F.Global.General.CallWrapperSync(450000,V.Local.sParams)
        Gui.frmMain..Enabled(True)
    F.Intrinsic.Control.CaseAny("PART","LOCATION")
        Gui.frmMain..Enabled(False)
        Gui.frmMain.gsGC.GetCellValueByColumnName("gvOrders","PART",V.Args.RowIndex,V.Local.sJob)
        Gui.frmMain.gsGC.GetCellValueByColumnName("gvOrders","LOCATION",V.Args.RowIndex,V.Local.sSuffix)
        F.Intrinsic.String.Build("{0}!*!{1}!*!O",V.Local.sJob,V.Local.sSuffix,V.Local.sParams)
        F.Global.General.CallWrapperSync(300011,V.Local.sParams)
        Gui.frmMain..Enabled(True)
F.Intrinsic.Control.EndSelect

F.Intrinsic.Control.Catch
    F.Intrinsic.String.Build("Project: {0}{1}{1}Sub: {2}{1}Error {3}: {4}",V.Ambient.ScriptPath,V.Ambient.Newline,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
F.Intrinsic.Control.EndTry
Program.Sub.gsGC_RowCellClick.End
```
' V.Args.Column = clicked column name. V.Args.RowIndex = row number.
' CaseAny matches multiple columns. Disable form during CallWrapper to prevent re-entry.
' Common CW IDs: 450000=WO view, 2009=WO edit, 300011=Part SD, 200000=SO, 175200=PO

### CallWrapper parameter patterns (common drill-downs)
```
'-- Work Order (view): mode 7=view, 8=no-dollars
F.Intrinsic.String.Build("7!*!{0}!*!{1}!*!A",V.Local.sJob,V.Local.sSuffix,V.Local.sParams)
F.Global.General.CallWrapperSync(450000,V.Local.sParams)

'-- Work Order (edit):
F.Intrinsic.String.Build("{0}!*!{1}!*!O",V.Local.sJob,V.Local.sSuffix,V.Local.sParams)
F.Global.General.CallWrapperSync(2009,V.Local.sParams)

'-- Part Standard (view O / edit M):
F.Intrinsic.String.Build("{0}!*!{1}!*!O",V.Local.sPart,V.Local.sLoc,V.Local.sParams)
F.Global.General.CallWrapperSync(300011,V.Local.sParams)

'-- Sales Order:
F.Intrinsic.String.Build("{0}!*!V!*!{1}",V.Local.sSO,V.Local.sCust,V.Local.sParams)
F.Global.General.CallWrapperSync(200000,V.Local.sParams)

'-- Purchase Order:
F.Intrinsic.String.Build("V!*!{0}!*!",V.Local.sPO,V.Local.sParams)
F.Global.General.CallWrapperSync(175200,V.Local.sParams)
```

### CellValueChanged handler (inline edit + SQL write-back)
```
Program.Sub.gsGC_CellValueChanged.Start
V.Local.sSQL.Declare(String)
V.Local.sKey.Declare(String)
V.Local.sText.Declare(String)

F.Intrinsic.Control.If(V.Args.Column,=,"NOTES")
    Gui.frmMain.gsGC.GetCellValueByColumnName("gvOrders","JOB",V.Args.RowIndex,V.Local.sKey)
    F.Intrinsic.String.Replace(V.Args.Value,"'","''",V.Local.sText)
    F.Intrinsic.String.Build("UPDATE MY_TABLE SET NOTES = '{0}' WHERE JOB = '{1}'",V.Local.sText,V.Local.sKey,V.Local.sSQL)
    F.ODBC.Connection!con.Execute(V.Local.sSQL)
F.Intrinsic.Control.EndIf
Program.Sub.gsGC_CellValueChanged.End
```
' V.Args.Column = edited column. V.Args.Value = new value. V.Args.RowIndex = row.
' ALWAYS escape single quotes with Replace before SQL.

### Conditional row coloring (SetRowAppearance)
```
'-- Loop after grid bind, inside SuspendLayout/ResumeLayout:
F.Intrinsic.Control.For(V.Local.i,0,V.DataTable.dtOrders.RowCount--,1)
    F.Intrinsic.Control.If(V.DataTable.dtOrders(V.Local.i).DATE_DUE!FieldVal,<,V.Ambient.Date)
        Gui.frmMain.gsGC.SetRowAppearance("gvOrders",V.Local.i,"BackColor","Pink")
    F.Intrinsic.Control.EndIf
F.Intrinsic.Control.Next(V.Local.i)
```
' SetRowAppearance params: gvName, rowIndex, property, value.
' Call INSIDE SuspendLayout/ResumeLayout block. Use FieldValIsNull check for dates.

### Refresh button handler
```
Program.Sub.cmdRefresh_Click.Start
F.Intrinsic.Control.CallSub(Serialize)
F.Intrinsic.Control.BlockEvents
F.Intrinsic.Control.CallSub(LockScreen)
F.Intrinsic.Control.CallSub(LoadData)
F.Intrinsic.Control.CallSub(EnableScreen)
F.Intrinsic.Control.UnBlockEvents
F.Intrinsic.Control.CallSub(Deserialize)
Program.Sub.cmdRefresh_Click.End
```
' Serialize saves grid layout → reload data → Deserialize restores layout.

### Form_UnLoad (cleanup)
```
Program.Sub.Form_UnLoad.Start
F.Intrinsic.Control.If(V.Global.bLoadData)
    F.Intrinsic.Control.CallSub(Serialize)
F.Intrinsic.Control.EndIf
F.ODBC.Connection!con.Close
F.Intrinsic.Control.End
Program.Sub.Form_UnLoad.End
```
' ALWAYS close connection. Serialize only if data was loaded. End terminates script.

### Serialize / Deserialize (grid layout persistence via GS_Registry)
```
Program.Sub.Serialize.Start
V.Local.sLayout.Declare(String)
Gui.frmMain.gsGC.Serialize(V.Local.sLayout)
F.Global.Registry.AddValue(V.Ambient.Username,"GAB_MYSCRIPT","1000",V.Local.sLayout)
Program.Sub.Serialize.End

Program.Sub.Deserialize.Start
V.Local.sLayout.Declare(String)
F.Global.Registry.GetValue(V.Ambient.Username,"GAB_MYSCRIPT","1000",V.Local.sLayout)
F.Intrinsic.Control.If(V.Local.sLayout,<>,"")
    Gui.frmMain.gsGC.Deserialize(V.Local.sLayout)
F.Intrinsic.Control.EndIf
Program.Sub.Deserialize.End
```
' Saves/restores column widths, order, visibility per user. Use script reg ID.

### DataView bind decision tree
```
' USE AddGridviewFromDatatable WHEN:
'   - Flat grid, no filtering, no parent-child
'   - After ToDataTable from a filtered DataView

' USE AddGridViewFromDataView WHEN:
'   - Master-detail hierarchy with AddRelation
'   - Live-filtered view that may change at runtime
'   - DataView.Create("dtName","dvName") MUST be called first
```

### DataView full lifecycle (Create + SetFilter + Close)
```
Program.Sub.LoadFilteredGrid.Start
V.Local.sFilter.Declare(String)

'-- 1. Create a plain (unfiltered) DataView -- ALWAYS 2 args
F.Data.DataView.Create("dtOrders","dvFiltered")

'-- 2. Apply a filter -- SetFilter is 3 args (dtName, dvName, expression)
V.Local.sFilter.Set("STATUS = 'Open'")
F.Data.DataView.SetFilter("dtOrders","dvFiltered",V.Local.sFilter)

'-- 3. Bind the DataView to a grid
Gui.frmMain.gsGC.AddGridViewFromDataView("gvOrders","dtOrders","dvFiltered")
Gui.frmMain.gsGC.MainView("gvOrders")

'-- 4. Change filter later (no need to close/recreate)
F.Data.DataView.SetFilter("dtOrders","dvFiltered","STATUS = 'Closed'")

'-- 5. Close -- ALWAYS 2 args (dtName, dvName)
F.Data.DataView.Close("dtOrders","dvFiltered")
Program.Sub.LoadFilteredGrid.End
```
' DataView.Create: ONLY 2-arg (plain) or 5-arg (relational).
' NEVER use 3-arg or 4-arg -- they trigger wrong overload and crash.
' DataView.SetFilter: exists and works. DataView.Filter: does NOT exist.
' DataView.Close: ALWAYS 2 args. 1 arg = "Expected 2, was passed 1".

### Reading Gui properties safely (avoid Error 5108)
```
'-- WRONG: nested Gui read as argument crashes
Gui.frmMain.ddl.ItemData(Gui.frmMain.ddl.ListIndex)

'-- CORRECT: read via V.Screen first, then pass local
V.Local.iIdx.Declare(Long)
V.Local.iIdx.Set(V.Screen.frmMain!ddl.ListIndex)
Gui.frmMain.ddl.ItemData(V.Local.iIdx)
```
' Rule: NEVER pass a Gui.frmX.ctrl.Prop read as an argument to another call.
' Always V.Screen read into a local variable first.

---

## String Operations

### Find text in a string (boolean)
```
F.Intrinsic.String.IsInString(V.Local.sHaystack,"needle",True,V.Local.bFound)
```
' True = case-insensitive. NOT F.Intrinsic.String.Find -- does not exist

### Get position of substring
```
F.Intrinsic.String.InStr(V.Local.sSource,"find",0,V.Local.iPos)
```
' Returns 1-based position; 0 = not found. 3rd param = start position (0-based)

### Replace text
```
F.Intrinsic.String.Replace(V.Local.sSource,"old","new",V.Local.sResult)
```

### Split string into array
```
F.Intrinsic.String.Split(V.Local.sData,"*!*",V.Local.sArr)
```
' Access elements: V.Local.sArr(0), V.Local.sArr(1), etc.

### Build string with placeholders
```
F.Intrinsic.String.Build("{0} has {1} items",V.Local.sName,V.Local.iCount,V.Local.sResult)
```
' MUST have {N} placeholders. Min 3 args: format + 1 sub + result. NOT for literal strings

### Concatenate strings
```
F.Intrinsic.String.Concat(V.Local.sA,V.Local.sB,V.Local.sResult)
```
' Variadic: last param is always result. NOT + operator -- GAB has no string concat operator

### Check if string is empty/whitespace
```
F.Intrinsic.String.IsNullOrWhiteSpace(V.Local.sInput,V.Local.bEmpty)
```

### Get string length
```
F.Intrinsic.String.Len(V.Local.sSource,V.Local.iLen)
```

### Trim whitespace
```
F.Intrinsic.String.Trim(V.Local.sSource,V.Local.sResult)
```

### Substring (left/right/mid)
```
F.Intrinsic.String.Left(V.Local.sSource,5,V.Local.sResult)
F.Intrinsic.String.Right(V.Local.sSource,3,V.Local.sResult)
F.Intrinsic.String.Mid(V.Local.sSource,3,5,V.Local.sResult)
```
' Mid: start pos (1-based like VB Mid$), length. Mid(s,1,3) = first 3 chars

### Convert case
```
F.Intrinsic.String.UCase(V.Local.sSource,V.Local.sResult)
F.Intrinsic.String.LCase(V.Local.sSource,V.Local.sResult)
```

### Pad string (left/right)
```
F.Intrinsic.String.LPad(V.Local.sVal,"0",6,V.Local.sResult)
F.Intrinsic.String.RPad(V.Local.sVal," ",20,V.Local.sResult)
```

### Format number
```
F.Intrinsic.String.Format(V.Local.fValue,"#,##0.00",V.Local.sResult)
```
' "mm" returns MONTH not minutes. Use "nn" for minutes

### Join array to string
```
F.Intrinsic.String.Join(V.Local.sArr,",",V.Local.sResult)
```

### Make string SQL-safe (Pervasive)
```
V.Local.sTemp.Set(V.Local.sInput)
V.Local.sSafe.Set(V.Local.sTemp.PSQLFriendly)
```
' Two-step: read into local first, THEN access .PSQLFriendly property. Never chain on V.Screen

---

## Grid Operations

### Bind DataTable to grid
```
Gui.frmMain.gsGC.AddGridviewFromDatatable("dtOrders","dtOrders")
Gui.frmMain.gsGC.MainView("dtOrders")
```
' Root level: DT name = DV name = GV name (all must match). Do NOT use DataSource + MainView together

### Hide a grid column
```
Gui.frmMain.gsGC.SetColumnProperty("gvMain","COL_NAME","Visible",False)
```
' NOT SetColumnVisible -- that method does not exist

### Set column caption
```
Gui.frmMain.gsGC.SetColumnProperty("gvMain","PART","Caption","Part Number")
```

### Set column width
```
Gui.frmMain.gsGC.SetColumnProperty("gvMain","PART","Width",150)
```

### Auto-fit columns
```
Gui.frmMain.gsGC.BestFitColumns("gvMain")
```
' Always call AFTER ResumeLayout

### Grid property setup (with SuspendLayout)
```
Gui.frmMain.gsGC.SuspendLayout
Gui.frmMain.gsGC.SetGridviewProperty("gvMain","AllowSort",True)
Gui.frmMain.gsGC.SetGridviewProperty("gvMain","AllowFilter",True)
Gui.frmMain.gsGC.SetColumnProperty("gvMain","PART","Caption","Part Number")
Gui.frmMain.gsGC.SetColumnProperty("gvMain","PART","Width",150)
Gui.frmMain.gsGC.ResumeLayout
Gui.frmMain.gsGC.BestFitColumns("gvMain")
```
' ALWAYS wrap property config in SuspendLayout/ResumeLayout

### Get cell value by column name
```
Gui.frmMain.gsGC.GetCellValueByColumnName("gvMain","PART",V.Local.iRow,V.Local.sPart)
```
' Params: gridview, column, rowIndex, result
' In event handlers: use V.Args.RowIndex (RowCellClick) or V.Args.FocusedRowHandle (FocusedRowChanged)
' Outside events: iterate with For loop over V.DataTable.dtName.RowCount
' NOTE: GetFocusedRowHandle() method does NOT exist -- row comes from V.Args in events

### Get selected rows (multi-select)
```
Gui.frmMain.gsGC.GetSelectedRows("gvMain",V.Local.sRows)
```
' Returns *!*-delimited row handles

### Refresh grid after data change
```
Gui.frmMain.gsGC.DataSource("dtName")
```
' Re-bind the DataTable to refresh. NOT RefreshDataSource -- does not exist

### Enable group panel
```
Gui.frmMain.gsGC.SetGridviewProperty("gvMain","ShowGroupPanel",True)
```
' NOT AllowGroup -- that property does not exist

### Context menu on grid
```
Gui.frmMain.gsGC.ContextMenuAddItem("mnuGrid","edit",0,"Edit Record")
Gui.frmMain.gsGC.ContextMenuAddItem("mnuGrid","delete",0,"Delete Record")
Gui.frmMain.gsGC.ContextMenuAttach("mnuGrid","gsGC")
Gui.frmMain.gsGC.SetItemEventHandler("mnuGrid","edit",GridMenuClick)
Gui.frmMain.gsGC.SetItemEventHandler("mnuGrid","delete",GridMenuClick)
```

---

## Tab Control

### Create tab pages
```
Gui.frmMain.tabMain.Tabs(3)
Gui.frmMain.tabMain.SetTab(0)
Gui.frmMain.tabMain.Caption("Orders")
Gui.frmMain.tabMain.SetTab(1)
Gui.frmMain.tabMain.Caption("Details")
Gui.frmMain.tabMain.SetTab(2)
Gui.frmMain.tabMain.Caption("History")
```
' NOT Tab.AddPage or Tab.AddTab -- those do not exist

### Read active tab index
```
V.Local.iTab.Set(V.Screen.frmMain!tabMain.Tab)
```
' Property read -- NO parentheses. NOT .GetTab()

### Switch to a tab programmatically
```
Gui.frmMain.tabMain.SetTab(2)
```

### Enable/disable a tab
```
Gui.frmMain.tabMain.TabEnabled(1,False)
```
' Params: tab index, enabled boolean

### Set tab color
```
Gui.frmMain.tabMain.TabColor(0,V.Color!Blue)
```

---

## Form Operations

### Show form (standard pattern)
```
Gui.frmMain..Show
Gui.frmMain..AlwaysOnTop(True)
Gui.frmMain..AlwaysOnTop(False)
```
' AlwaysOnTop flash brings form to front. Without .Show, script exits after Main

### Modal child form
```
Gui.frmParent..Enabled(False)
Gui.frmChild..Show
Gui.frmChild..WaitForDismiss
Gui.frmParent..Enabled(True)
```
' Child's close button: .Visible(False), NOT F.Intrinsic.Control.End

### Set form title
```
Gui.frmMain..Caption("My Application")
```
' NOT .Text() on forms -- use .Caption()

### Create form in ScreenSU
```
Gui.frmMain..Create(BaseForm)
Gui.frmMain..Caption("My Form")
Gui.frmMain..Size(800,600)
Gui.frmMain..Sizeable(True)
Gui.frmMain..MaxButton(True)
```
' Form types: BaseForm, DashForm, DialogForm. Bare .Create is invalid

### UsePixels (REQUIRED first line of Main for GUI scripts)
```
F.Intrinsic.UI.UsePixels
```
' Without this, all ScreenSU coordinates are interpreted as twips → form is giant

---

## Data / ODBC

### Query into DataTable (standard pattern)
```
V.Local.sSQL.Set("SELECT PART, DESCRIPTION FROM V_PART_MSTR WHERE PART = 'WIDGET'")
F.Data.DataTable.CreateFromSQL("dtParts","con",V.Local.sSQL,True)
```
' CreateFromSQL params: (name, connectionName, sql, globalScope). Pass True if used across subs.

### Loop through DataTable rows
```
F.Intrinsic.Control.For(V.Local.iRow,0,V.DataTable.dtParts.RowCount--,1)
  V.Local.sPart.Set(V.DataTable.dtParts(V.Local.iRow).PART!FieldVal)
  V.Local.sDesc.Set(V.DataTable.dtParts(V.Local.iRow).DESCRIPTION!FieldVal)
F.Intrinsic.Control.Next(V.Local.iRow)
```
' RowCount-- because For is 0-based. Field access: V.DataTable.dt(row).COLUMN!FieldVal

### Close DataTable (always do this)
```
F.Data.DataTable.Close("dtParts")
```
' Close when done. Global-scope DataTables persist until explicitly closed.

### Execute and return single value
```
V.Local.sSQL.Set("SELECT COUNT(*) FROM PART_MSTR")
F.ODBC.Connection!con.ExecuteAndReturn(V.Local.sSQL,V.Local.sCount)
```
' Returns first column of first row as String. Check V.Ambient.ExecuteAndReturnEOF for no-rows

### Execute (no return)
```
F.ODBC.Connection!con.Execute(V.Local.sSQL)
```

---

## DataTable

### Create from SQL
```
F.Data.DataTable.CreateFromSQL("dtOrders","con",V.Local.sSQL,True)
```
' Params: name, connection, SQL, globalScope. True = survives across subs

### Get cell value
```
V.Local.sVal.Set(V.DataTable.dtOrders(0).PART!FieldVal)
V.Local.fQty.Set(V.DataTable.dtOrders(V.Local.iRow).QTY!FieldValFloat)
```
' Pattern: V.DataTable.name(row).COLUMN!FieldVal. Column BEFORE the !

### Set cell value
```
F.Data.DataTable.SetValue("dtOrders",V.Local.iRow,"STATUS","Complete")
```

### Row count
```
V.Local.iCount.Set(V.DataTable.dtOrders.RowCount)
```
' Property -- no parentheses. NOT GetRowCount() -- that doesn't exist

### Add row
```
F.Data.DataTable.AddRow("dtOrders","PART","WIDGET","QTY","10","STATUS","Open")
```
' Name/value pairs after the DT name

### Delete row
```
F.Data.DataTable.DeleteRow("dtOrders",V.Local.iRow)
F.Data.DataTable.AcceptChanges("dtOrders")
```
' DeleteRow only MARKS for deletion. AcceptChanges physically removes

### Filter with DataView
```
F.Data.DataView.Create("dtOrders","dvFiltered",22,"STATUS = 'Open'","PART ASC")
```
' Params: source DT, view name, flags(22=standard), filter expression, sort

### Export to JSON
```
F.Data.DataTable.SaveToJson("dtOrders","C:\temp\data.json")
```
' For WebView2 data -- never build JSON manually with String.Build

### Close DataTable
```
F.Data.DataTable.Close("dtOrders")
```

---

## Control Interactions

### Set textbox text
```
Gui.frmMain.txtName.Text("Hello World")
```

### Read textbox text
```
V.Local.sVal.Set(V.Screen.frmMain!txtName.Text)
```
' NO parentheses on reads. Read uses !, write uses .

### Show/hide a control
```
Gui.frmMain.lblStatus.Visible(True)
Gui.frmMain.lblStatus.Visible(False)
```

### Enable/disable a control
```
Gui.frmMain.btnSave.Enabled(False)
```

### Populate dropdown
```
Gui.frmMain.ddlType.AddItem("Option A")
Gui.frmMain.ddlType.AddItem("Option B")
Gui.frmMain.ddlType.ListIndex(0)
```

### Read dropdown selection
```
V.Local.iIdx.Set(V.Screen.frmMain!ddlType.ListIndex)
V.Local.sText.Set(V.Screen.frmMain!ddlType.Text)
```

### Set checkbox
```
Gui.frmMain.chkActive.Value(True)
```
' Use .Value, NOT .Checked

### Read checkbox
```
F.Intrinsic.Control.If(V.Screen.frmMain!chkActive.Value,=,1)
```
' Returns 0 or 1, NOT True/False. Always compare explicitly with =,1 or =,0

---

## Events

### Wire button click (in ScreenSU)
```
Gui.frmMain.btnSave.Event(Click,btnSave_Click)
```
' NOT OnClick -- event name is "Click" not "OnClick"

### Wire grid row change (in ScreenSU)
```
Gui.frmMain.gsGC.Event(FocusedRowChanged,Grid_RowChanged)
```

### Wire tab click (in ScreenSU)
```
Gui.frmMain.tabMain.Event(Click,tabMain_Click)
```
' Tab only supports Click event -- NOT Change

### Wire form close (in ScreenSU)
```
Gui.frmMain..Event(UnLoad,frmMain_UnLoad)
```
' Double-dot for form-level events

### Wire timer (in ScreenSU)
```
Gui.frmMain.tmr1.Event(Timer,tmr1_Tick)
```

---

## File I/O

### Read file to string
```
F.Intrinsic.File.File2String("C:\path\file.txt",V.Local.sContent)
```
' Path is FIRST argument

### Write string to file
```
F.Intrinsic.File.String2File("C:\path\file.txt",V.Local.sContent)
```
' Path is FIRST argument. NOT (content, path)

### Append to file
```
F.Intrinsic.File.Append2FileNewLine("C:\path\log.txt",V.Local.sLine)
```
' Path FIRST, content SECOND

### Check file exists
```
F.Intrinsic.File.Exists("C:\path\file.txt",V.Local.bExists)
```

### Delete file
```
F.Intrinsic.File.DeleteFile("C:\path\file.txt")
```

---

## Error Handling

### Try/Catch (single risky operation only)
```
F.Intrinsic.Control.Try
  F.ODBC.Connection!con.Execute(V.Local.sSQL)
F.Intrinsic.Control.Catch
  F.Intrinsic.UI.Msgbox("SQL failed")
F.Intrinsic.Control.EndTry
```
' CANNOT nest Try/Catch in same sub. For complex error handling use SetErrorHandler

### SetErrorHandler pattern
```
F.Intrinsic.Control.SetErrorHandler(ErrHandler)
' ... risky code ...
F.Intrinsic.Control.SetErrorHandler()
F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label(ErrHandler)
F.Intrinsic.UI.Msgbox(V.Ambient.ErrorMessage)
F.ODBC.Connection!con.Close
```
' SetErrorHandler target is a LABEL, not a sub name

### End program
```
F.Intrinsic.Control.End
```
' Only call from main form's UnLoad handler or shutdown logic

---

## Debugging

### Enable native trace (for gab-test-debug)
```
' Create sentinel file: %TEMP%\GSS\octsrs.logging (done by test-debug.ps1)
' Trace output appears in: %TEMP%\GSS\octsrs.*.debug
```

### Targeted logging
```
F.Intrinsic.Debug.SetLA(V.Local.sMsg)
F.Intrinsic.Debug.EnableLogging
```
' SetLA writes to native trace. Do NOT use SetLevel (pops a blocking dialog)

### Take screenshot (GUI test validation)
```
Gui.frmMain..TakeScreenshot("C:\temp\screenshots\test_01.png")
```

---

## CallSub / Args

### Call subroutine with arguments
```
F.Intrinsic.Control.CallSub(ProcessItem,"sPartNum",V.Local.sPart,"iQty",V.Local.iQty)
```
' Name/value pairs after sub name

### Receive arguments in called sub
```
V.Local.sPart.Set(V.Args.sPartNum)
V.Local.iQty.Set(V.Args.iQty.Long)
```
' Use V.Args.argName directly. NOT ArgToVar for simple value passing

### Return value via global
```
' In called sub:
V.Global.sResult.Set("Success")
' In caller after CallSub returns:
V.Local.sOutcome.Set(V.Global.sResult)
```
' V.Args is READ-ONLY. Cannot use V.Args to return data

### Extract array element before passing
```
V.Local.sTemp.Set(V.Local.sParts(1))
F.Intrinsic.Control.CallSub(MySub,"sArg",V.Local.sTemp)
```
' NEVER pass V.Local.arr(N) directly -- GAB passes the entire array. Extract first

### Nested CallSub argument scoping
```
' When A → B → C, string literals passed from B to C may arrive empty via ArgToVar
' Workaround: use V.Global for data in deeply nested CallSub chains
```

---

## DashForm Toolbar

### Launch URL from DashForm Toolbar Button

Wire the `UserButtonClicked` event in ScreenSU, add the button at runtime in Main (NOT in ScreenSU), and use `SelectCase` + `ShellExec` in the handler:

```
'-- ScreenSU: wire the event ONLY
Program.Sub.ScreenSU.Start
Gui.frmMain..Create(DashForm)
Gui.frmMain..Caption("My Dashboard")
Gui.frmMain..Size(1000,600)
Gui.frmMain..Event(UserButtonClicked,UserButtonClicked)
Program.Sub.ScreenSU.End

'-- Main: add the button at RUNTIME (BarAddButton CANNOT be in ScreenSU)
Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors
V.Local.sError.Declare(String,"")

F.Intrinsic.UI.UsePixels
Gui.frmMain..BarAddButton("btnHelp","Help Wiki",0)
Gui.frmMain..BarAddButton("btnPortal","Customer Portal",0)
Gui.frmMain..Show
Gui.frmMain..AlwaysOnTop(True)
Gui.frmMain..AlwaysOnTop(False)
F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Error {0}: {1}",V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

'-- Handler: dispatch by button key
Program.Sub.UserButtonClicked.Start
F.Intrinsic.Control.SelectCase(V.Args.Button)
F.Intrinsic.Control.Case("btnHelp")
    F.Intrinsic.UI.ShellExec("https://wiki.example.com/help")
F.Intrinsic.Control.Case("btnPortal")
    F.Intrinsic.UI.ShellExec("https://portal.example.com")
F.Intrinsic.Control.EndSelect
Program.Sub.UserButtonClicked.End
```

**PITFALL:** `BarAddButton` CANNOT be placed in ScreenSU — it must be called at runtime (Main or later). `BarHelpButton(True, ...)` only shows the OCTSRS About overlay; it does NOT open a URL.
