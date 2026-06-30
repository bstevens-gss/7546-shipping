# GAB Pitfalls & Anti-Patterns
# Known issues, critical runtime behaviors, and syntax traps
# Last verified: 2026-06-30 | Product version: unverified | v5.0.0 feedback compilation (61 entries)

> Load this file when writing new subroutines, implementing error handling, debugging, or working with DataTables, ODBC, grids, or DLL integration. The quick-reference list in `agents/AGENTS.GAB.md` summarizes the top mistakes; this file provides full explanations and code examples.

---

# ANTI-PATTERNS TO AVOID

> **CRITICAL -- NEVER invent, guess, or assume GAB functions, methods, properties, events, enums, or syntax.** GAB is a proprietary language with zero public documentation. The ONLY valid API surface is what is explicitly documented in `agents/AGENTS.GAB.md` and the `agents/gab/*.md` reference files (API.md, GUI.md, GRID.md, DATA.md, IO.md, INTEGRATION.md, CALLWRAPPERS.md, HOOKS.md, VARIABLES.md, ENUMS.md). If a function or method is not documented in these files, it does not exist as far as you are concerned. When you need functionality that is not documented, ASK the user rather than fabricating a plausible-sounding API call. A hallucinated function call will compile-fail silently in GAB and waste the user's time debugging phantom errors.

## Cursor StrReplace/Write Strips UTF-8 BOM (Invalidates .sig)

Cursor's file editing tools (StrReplace, Write) always output plain UTF-8 without BOM.
GAB .g2u/.lib files MUST have the BOM (EF BB BF). The signing script writes the BOM.

If you edit after signing:
- BOM is stripped
- .sig hash no longer matches (hash was computed over BOM bytes via Encoding.Default)
- On next open, Cursor re-adds the BOM (settings say utf8bom), changing Date Modified

Rule: Sign is ALWAYS the last operation. No StrReplace/Write after sign.

## Syntax Traps
- **Never** use inline math operators (`+`, `-`, `*`, `/`) in expressions -- GAB has NO inline operators; use `F.Intrinsic.Math.*` functions
- **Never** use `+` for string concatenation -- GAB has NO string concatenation operator. Use `F.Intrinsic.String.Build("{0} {1}",a,b,result)`, `F.Intrinsic.String.Concat(a,b,result)`, or sequential `.Set()`/`.Append()` calls. The `+` symbol is treated as literal text, not an operator
- **Never** put literal `{` or `}` in a `String.Build` format string -- pass them as parameters via placeholder index
- **Never** use `F.Intrinsic.String.Build` when there are no `{N}` placeholders in the format string -- use `V.Local.sVar.Set("literal string")` instead. `String.Build` is for parameter substitution only
- **Never** reverse the argument order of `String2File`/`File2String` -- it is `(path, content/variable)`, path always first (see also `agents/gab/IO.md` for the full file I/O API)
- **Never** use `F.Intrinsic.String.UBound(arr, result)` -- `.UBound` is a property, use `V.Local.result.Set(V.Local.arr.UBound)`
- **Never** use parentheses on `.PSQLFriendly`, `.SQLServerFriendly`, or `.SQLServFriendly` -- they are properties, not methods. `V.Local.sVal.PSQLFriendly()` causes Runtime Error 113; use `V.Local.sVal.PSQLFriendly`
- **Never** chain `.PSQLFriendly` or `.SQLServerFriendly` directly on a `V.Screen` read expression -- it fails at parse time. Read the value into a local variable first, then apply the property in a separate `.Set()` call
- **Never** use parentheses when reading variable properties. ALL property accessors on any variable scope (`V.Screen`, `V.Local`, `V.Global`, `V.DataTable`, etc.) are properties and never take parentheses. `.Text`, `.Tab`, `.ListIndex`, `.Caption`, `.PervasiveDate`, `.PSQLFriendly`, `.UBound`, `.Exists`, `.RowCount--` are all property reads. Using parentheses (e.g., `.Text()`, `.Tab()`, `.ListIndex()`, `.PervasiveDate()`) causes a runtime error. The parenthesized form is only valid on the WRITE/SET side via `Gui.form.ctrl.Property(value)`
- **Never** use `.Left(N)` or `.Right(N)` with arbitrary N -- use `F.Intrinsic.String.Left(str, N, result)` or the fixed `.Left3`, `.Left5` properties
- **Never** chain `.Not` on `.Exists` or ANY property accessor -- `.Not` only works on **boolean variables**, not on property reads. `V.DataTable.dtName.Exists.Not`, `.IsDate.Not`, `.IsNumeric.Not` all silently evaluate incorrectly. Use the comparison form instead: `F.Intrinsic.Control.If(V.DataTable.dtName.Exists,=,False)` or `F.Intrinsic.Control.If(V.Local.sVal.IsNumeric,=,False)`
- **Never** declare variables inside loops -- variables are subroutine-scoped, not block-scoped; re-declaring silently resets the value
- **Never** use `F.Intrinsic.UI.DropDown()` -- this function does NOT exist in GAB (error 999000). For a selection list, use `F.Intrinsic.UI.BrowserFromString("Title","Item1~Item2~Item3","|","~","Column","200",V.Local.sResult)`. The result is the selected row text (or `***CANCEL***` if dismissed)
- **Never** use `F.Intrinsic.UI.MsgBox2()` -- this function does NOT exist in some GAB runtimes (error 999000). Use `F.Intrinsic.UI.Msgbox(sMessage,"Title",V.Enum.MsgBoxStyle!YesNo,V.Local.iReturnButton)` for Yes/No confirmation
- **Never** use `DropDownList.Clear()` -- the `.Clear` method does NOT exist on DropDownList or ComboBox controls. To repopulate, use `.ClearItems` (on ComboBox/DropDownList/ListBox/ListView/TreeView) or recreate the control
- **Never** use `F.Intrinsic.String.Mid(source, start, 0, result)` expecting "rest of string" -- length `0` returns an empty string, NOT everything from start to end. Use `F.Intrinsic.String.Replace` or `F.Intrinsic.String.Right` instead
- **Never** use .NET type names in `DataTable.AddColumn` -- GAB column types are simple strings: `"String"`, `"Float"`, `"Long"`, `"Boolean"`, `"Date"`. Using `"System.String"` or `"System.Decimal"` causes Error 21015
- **Never** use `SetCellValueByColumnName` -- this method does NOT exist. Use `F.Data.DataTable.AddRow("dtName","Col1","Val1","Col2","Val2")` for new rows or `F.Data.DataTable.SetValue("dtName",rowIndex,"ColName","value")` for updates
- **Never** use `AllowGroup` as a `SetGridviewProperty` -- this property does NOT exist. Use `ShowGroupPanel` to enable/disable the group panel
- **Never** use `SetIcon(V.Enum.FormIconApplication!...)` or `SvgPicture(V.Enum.Image!...)` in ScreenSU -- these enum references crash ScreenSU at parse time. Set icons at runtime in Main if needed
- **Never** use `F.Global.Inventory.CreatePart()` for part creation -- this may not exist in all runtimes (error 999000). Use `F.Global.Inventory.AddPartToBatch()` + `F.Global.Inventory.PostPartBatch` (batch pattern) as used in production seed tools
- **Never** use `.Prepend()` on any variable -- this method does not exist in GAB (0 hits across 1,536 production files, 0 hits on GitHub). To prepend text, use `F.Intrinsic.String.Build("{0}{1}",V.Local.sPrefix,V.Local.sExisting,V.Local.sResult)` or sequential `.Set()`/`.Append()` calls
- **Never** use `DoWhile` -- this loop construct does not exist in GAB. The only loop constructs are `F.Intrinsic.Control.For/Next` and `F.Intrinsic.Control.DoUntil/Loop`. To loop while a condition is true, invert the condition for `DoUntil`
- **Never** use `F.Intrinsic.String.IsNumeric` -- `IsNumeric` lives in the Math namespace, not String. Correct: `F.Intrinsic.Math.IsNumeric(V.Local.sVal,V.Local.bResult)`
- **Never** use `F.Data.DataTable.GetRowCount()`, `GetColumnCount()`, `GetColumnNames()`, or `GetValue()` -- these methods do NOT exist in GAB. Use `V.DataTable.dtName.RowCount` (property, not method), `V.DataTable.dtName(row).ColName!FieldVal` for cell reads, and `F.Data.DataTable.GetFieldNames("dtName",V.Local.sFields)` for column names (returns `*!*`-delimited string)
- **Never** use `F.Intrinsic.String.Length(var, result)` -- this function does NOT exist (Error 999000). Use `F.Intrinsic.String.Len(source, outputLength)` or the `.Length` property accessor: `V.Local.iLen.Set(V.Local.sStr.Length)`
- **Never** use `Create(OptionButton)` -- the control type `OptionButton` does NOT exist in GAB. The correct radio button control type is `Option`. Use `Gui.Form_Name.optMyRadio.Create(Option)`
- **Never** use `Gui.Form_Name..BlockEvents` or `Gui.Form_Name.ctrl.BlockEvents` -- BlockEvents is NOT a GUI method. It is a global control flow function: `F.Intrinsic.Control.BlockEvents` and `F.Intrinsic.Control.UnblockEvents`
- **Never** use `F.Data.DataTable.SaveToDB("dtName","conName")` (2-parameter form) -- this signature is fabricated. The correct signature is `F.Data.DataTable.SaveToDB("DTName","ConnectionName","DBTableName","KeyFields",Mode)` with optional field map parameter
- **Never** use `F.Data.DataTable.RowCount("tableName",V.Local.iCount)` as a function call -- this does NOT exist in GAB 2019 (Error 600). Use the property accessor: `V.Local.iCount.Set(V.DataTable.dtName.RowCount)` which works in all versions
- **Never** attempt to SET a `V.Args` variable -- `V.Args.*` is read-only. `V.Args.sName.Set("value")` silently fails or errors. To return data from a subroutine called via `CallSub`, use a `V.Global` variable as a return buffer
- **Never** use `V.DataTable.dtName(row,"ColName")` accessor syntax -- the comma inside the parentheses is invalid (Error 113). The correct read syntax is `V.DataTable.dtName(row).ColName!FieldVal` (or `!FieldValTrim`, `!FieldValLong`, etc.)
- **Never** build JSON strings manually for WebView2 data injection -- use `F.Data.DataTable.SaveToJson("dtName","C:\path\data.json")` to write DataTable data as JSON to a file, then load it in the HTML via `<script src="data.json">`. Manual JSON building with `String.Build` and `DblQuote` is fragile and breaks on special characters. See Pattern G in `PATTERNS.md`
- **Never** write `.gaf` launcher files in INI format (`[GAF]` / `ScriptPath=`) -- the correct format is `key::value` pairs: `TRANSID::900000` followed by `SCRIPT::C:\path\to\script.g2u`. Each pair on its own line, no section headers
- **Never** use inline arithmetic in `For` loop bounds or ANY function arguments -- `For(i, 0, iMax - 1, 1)` is INVALID because GAB has no inline operators anywhere, including function call parameters. Pre-compute with `F.Intrinsic.Math.Sub(V.Local.iMax,1,V.Local.iLast)` then `For(i,0,V.Local.iLast,1)`
- **Never** reverse `Append2FileNewLine` parameters -- it is `(filepath, content)`, path always first. Same convention as `String2File(path, content)`. Writing `Append2FileNewLine(content, path)` silently creates a garbage file named after your log content
- **Never** use `F.Data.DataView.Filter(...)` -- this method does NOT exist. The correct function is `F.Data.DataView.SetFilter("dtName","dvName","filterExpression")` with 3 parameters: parent DataTable name, DataView name, and a SQL-style filter expression (e.g., `"PartNumber LIKE '%widget%'"`)
- **Never** wire a `Change` event on Tab controls -- Tab controls only have a `Click` event, NOT `Change`. Wire `Gui.frmMain.tabMain.Event(Click,TabClicked)` in ScreenSU. Read the active tab index via `V.Screen.frmMain!tabMain.Tab` (0-based index)
- **Never** reverse `GetCellValueByColumnName` parameters -- the correct order is `(gridviewName, columnName, rowHandle, resultVariable)`. Passing `(gridviewName, rowHandle, columnName, resultVariable)` silently returns empty string or wrong data
- **Never** guess SQL table or column names -- ALWAYS query the database schema or consult working reference scripts first. Wrong table names cause silent "no such table or object" Zen errors that waste entire debug cycles. Use `V_*` views for reads (e.g., `V_BOM_MSTR`, `V_ROUTER_LINE`). Check `agents/schema/*.md` for verified table/column definitions
- **Never** call `F.Intrinsic.String.IsInString` with 3 arguments -- the correct signature is `(Source, SearchFor, CaseSensitive, Output)` with 4 params. Passing 3 args = Error 405. Swapping params 3 and 4 = Error 999000 null ref
- **Never** declare `V.Local.j.Declare()` with no type prefix and no explicit type -- causes Error 5101 ("No variable type specified"). GAB infers type from Hungarian prefix (`i`=Long, `s`=String, `b`=Boolean, `d`=Decimal, `dt`=Date). A bare name like `j` gives GAB no type information
- **Never** access `V.Args.*` for a parameter the caller did NOT pass -- GAB has NO optional CallSub arguments. Accessing `V.Args.sParam` when the caller omitted it causes Error 5150 immediately. Every caller MUST pass every argument the callee reads
- **Never** use bare boolean variables with `,or,`/`,and,` in If -- `F.Intrinsic.Control.If(V.Global.bFlag1,or,V.Global.bFlag2)` produces Error 1020. GAB `If` supports `or`/`and` only between full comparison expressions. Use the flag pattern: `If(V.Global.bFlag1,=,True)` then check the second condition separately, or pre-compute a combined flag
- **Never** compare a Date variable directly without guarding for empty/null -- produces Error 800. Always check `!FieldValTrim` for empty string first, before any date comparison using `!FieldVal`:
  ```
  F.Intrinsic.Control.If(V.DataTable.dt(iRow).DateCol!FieldValTrim,<>,"")
      '-- Safe to compare the date value now
      F.Intrinsic.Control.If(V.DataTable.dt(iRow).DateCol!FieldVal,<,V.Ambient.Date)
      F.Intrinsic.Control.EndIf
  F.Intrinsic.Control.EndIf
  ```
- **Never** expect `F.Intrinsic.Variable.AddRV` to modify the caller's local variable -- `AddRV("name",val)` sets the RETURN value for the subroutine, but the caller must explicitly read it back via `V.Local.var.Set(V.Args.param)` after CallSub returns
- **Never** assume reordering lines in ScreenSU changes visual layout -- GAB ScreenSU uses **absolute pixel positioning**. A control's visual location is determined solely by the X,Y values in `.Create()` or `.Position()` parameters. The order of lines in ScreenSU has ZERO effect on visual layout. To move a control, change its X,Y coordinate values
- **Never** call `F.Data.DataTable.AcceptChanges` out of sequence with `DeleteRow` -- `DeleteRow` alone only MARKS rows for deletion; they remain in the DataTable until `AcceptChanges` is called. If you call `FillFromDictionary`, `Merge`, or iterate rows between `DeleteRow` and `AcceptChanges`, you get Error 999000. Always: `DeleteRow` → `AcceptChanges` immediately, with no operations between them
- **Never** call `F.Data.DataTable.RemoveColumn` on a column referenced by an `AddExpressionColumn` -- fails with Error 999000. Workaround: `AddExpressionColumn` → `CopyColumn` (copies calculated values) → `RemoveColumn` (expression column) → `RemoveColumn` (source column)
- **Never** use `F.Data.DataTable.Create("Parent$child")` -- the `$` naming convention is only supported by `CreateFromSQL` and `ToDataTable`. Using `$` in `Create()` fails with Error 21002. For an empty schema with `$` naming, use `CreateFromSQL` with `WHERE PK = '-1'`
- **Never** use `RTrim()` or `LTrim()` in `AddExpressionColumn` expressions -- produces Error 999000. Only `Trim()` is supported in DataTable expression columns. This is the opposite of Zen SQL where only LTRIM/RTRIM exist
- **Never** put the condition on `Loop` instead of `DoUntil` -- `DoUntil(condition)` + `Loop` (no args) is correct. `DoUntil()` + `Loop(condition)` causes Error 400. Secondary hazard: Error 400 inside a Try block leaves ODBC connections open
- **Never** join `CUSTOMER_MASTER` without `AND REC = '1'` -- produces strings of zeros instead of customer names. Multiple REC values reuse `NAME_CUSTOMER` for other purposes. Always: `WHERE REC = '1'` when joining CUSTOMER_MASTER, or use `V_CUSTOMER_MASTER` view which pre-filters
- **Never** query `V_HOLIDAY_SCHED` for holiday dates -- this view contains stale legacy data (dates from 2009/2010). The correct source is `V_OP_HEADER` with ID 402410: `SELECT F_DATE FROM V_OP_HEADER WHERE ID = 402410 AND F_DATE <> '1900-01-01'`
- **Never** use `F.Intrinsic.UI.Msgbox` in scripts running from OLU or Task Scheduler -- hangs the process indefinitely and can max out server resources. Unattended scripts must use dual file-based logging: Activity Log (timestamps + status) and Error Log (full error detail). See PATTERNS.md for the standard Log_Activity/Log_Error subroutine pattern
- **Never** use `.Append` to build SQL query strings -- GAB strings have no line length limit. Use a single `.Set()` with the full query, or pass the SQL literal directly to `CreateFromSQL`. `.Append` for SQL invites injection risk, makes the query unreadable, and complicates debugging
- **Prefer** `SaveToDB` mode 256 (upsert) over DELETE + INSERT patterns -- mode 256 modifies existing records matching the key and inserts unmatched rows. Key fields are the BUSINESS key (not identity column). DELETE + INSERT introduces race condition risk and can trigger referential integrity violations

## Multi-Level Grid Relation Rules

These rules address hierarchical/master-detail grids with `AddRelation` and multi-level expand/collapse. They emerged from 8+ failed iterations building BOM/Router deep-dive grids:

- **`AddRelation` requires unique key columns** -- Error 21034 ("These columns don't currently have unique values") means the relation key column has duplicates in the parent DataTable. Fix: use `SELECT DISTINCT` in child queries, composite keys, or `GROUP BY` to guarantee uniqueness. A single PART column is almost never unique in real BOM data (same component appears in multiple assemblies or at multiple BOM sequences)
- **`AddGridViewFromDataView` second param = ROOT view name** -- For ALL child views at ANY depth, the second parameter must be the ROOT gridview name (e.g., `"dtFullBOM"`), NOT the child's own DataTable name. Passing the wrong name causes Error 121000 ("The specified view was not found"). The `Bom.g2u` reference always passes the root name
- **Root DT = DV = GV naming** -- At root level, the DataTable name, DataView name, and GridView name must ALL be identical. Using different names (`dtFullBOM`, `dvFullBOM`, `gvFullBOM`) breaks the grid's internal view resolver. Correct pattern: `CreateFromSQL("dtFullBOM",...)` then `AddGridviewFromDatatable("dtFullBOM","dtFullBOM")` then `MainView("dtFullBOM")`
- **Child gridview names are auto-generated** -- When using `$` child DataTables with `AddRelation`, the child gridview name is determined by GAB internally. Do NOT assume you know it or hardcode it. Use `GetFocusedGridview` at runtime to discover the actual name. The naming convention appears to be the child portion after `$` but this is not guaranteed
- **`MainView` MUST come after ALL child views are added** -- If an error occurs before `MainView(rootName)` is called, the entire grid stays blank with no visible error. Always structure code so `MainView` executes even if a child level fails (use `SetErrorHandler` to continue past individual child failures)
- **`ExpandMasterRow` only expands level 1** -- To expand ALL levels of a hierarchical grid, you must loop through child gridviews. Auto-generated child view names follow the pattern `rootName_1`, `rootName_2`, `rootName_3`, etc. Loop through each and call `ExpandMasterRow` on their rows separately
- **Iterative deepening queue pattern** -- For multi-level BOM explosions, use a queue-based loop: query root children into `rootDT$childDT`, add relation, add gridview. Then for each manufactured child, query ITS children into another `$`-named DataTable, add relation, add gridview. Continue until queue is empty. This is the `Bom.g2u` pattern (see `agents/gab/PATTERNS.md` Pattern I)
- **Zen SQL: no `_` prefix aliases, no subquery FROM** -- Zen database engine does not allow column aliases starting with underscore (`_UID` causes syntax error). Also does not support `SELECT ... FROM (SELECT ...)` derived tables. Use direct JOINs with DISTINCT instead of subqueries
- **UNION ALL column type matching** -- When using `UNION ALL` to combine BOM + Router data, all branches must have matching column types. Cast numeric columns (like `SET_UP`, `RUN_TIME`) to `CHAR` to match string columns in other UNION branches. Type mismatches cause silent data corruption or Zen errors

## GUI Rules
- **Never** forget to call `.Show` + `AlwaysOnTop(True/False)` on DashForm/BaseForm scripts. GAB terminates the process after Main exits unless a form is visible and holding the message loop. The correct pattern is:
  ```
  Gui.frmMain..Show
  Gui.frmMain..AlwaysOnTop(True)
  Gui.frmMain..AlwaysOnTop(False)
  ```
  The `AlwaysOnTop` flash brings the form to the front without permanently pinning it. Without `.Show`, the script exits silently after Main completes.
- **Never** rely on the form's ControlBox (X button) to close child/secondary forms -- clicking X **disposes** the form and all its controls, making them inaccessible for the rest of the session. Remove the ControlBox (`Gui.frmChild..ControlBox(False)`) and add an explicit Close button that calls `.Visible(False)` to hide the form without disposing it. This allows re-showing the form later.
- **Never** use `.FontBold(True/False)` or `.FontItalic(True/False)` -- these properties do not exist. Use `.FontStyle(Bold, Italic, Underline, Strikethrough, Shadow)` with 5 Boolean parameters. Example: `.FontStyle(True,False,False,False,False)` for bold only.
- **Never** use `Gui.<Form>..Create` without a form type parameter. The correct syntax is `Gui.<Form>..Create(BaseForm)`, `Gui.<Form>..Create(DashForm)`, or `Gui.<Form>..Create(DialogForm)`. A bare `.Create` or `.Create,` with no argument is invalid and will fail silently.
- **Never** use `Gui.<Form>..Unload` -- it is not a valid form runtime method. To hide a form use `.Visible(False)`, to close a child form use `.Close`, to terminate the program use `F.Intrinsic.Control.End`
- **Never** use `.Scrolling()` on TextBox or TextboxM controls -- it is not a valid property. (`.Scrolling()` IS valid on ProgressBar controls.)
- **Never** use `.Text()` to set the display text on forms, buttons, labels, checkboxes, or frames -- use `.Caption()`. The `.Text()` setter is only valid on text-content controls (Textbox, TextboxM, RichEdit). Using `.Text()` on a form or button causes Runtime Error 600 ("Invalid property/method specified").
- **Never** place event wiring in Main -- Main may re-execute on form refresh. Wire events via `Gui.<control>.Event(EventName, SubName)` in **ScreenSU** (preferred) or via `AddEventHandler` in **Preflight** (legacy). The ScreenSU `.Event()` syntax is the standard approach used in production scripts
- **Never** use `V.Enum.*` references in ScreenSU for form-level properties like `AccentColor` -- the form designer cannot parse enum references in ScreenSU blocks. Use the raw integer value instead (e.g., `AccentColor(2)` for Blue). See `agents/gab/ENUMS.md` section AccentColorCodes for the value mapping
- **Never** use `Gui.Form.Name.` (dot-separated form name) -- the correct form reference is `Gui.Form_Name.` (underscore). Dots between `Form` and the name cause Error 113 at parse time
- **Never** use `Gui.Form.Create("name",w,h,"title")` inline form creation -- GAB requires `Gui.Form_Name..Create(BaseForm)` then separate `..Caption()`, `..Size()` calls
- **Never** use `CommandButton` as a control type -- it does not exist in GAB. Use `Button`
- **Never** use `Event(OnClick,SubName)` for button click events -- the event name `OnClick` does NOT exist (Runtime Error 10003: "The specified control event {ONCLICK} does not exist"). The correct Button click event is `Event(Click,SubName)`. This applies to all controls -- use the event name without the `On` prefix
- **Never** use inline position/size in `Create()` like `.Create(Button,"label",x,y,w,h)` -- GAB requires `.Create(Button)` then separate `.Size()`, `.Position()`, `.Caption()` calls
- **Never** compare `V.Args.GsCardViewControlName` (or any `V.Args.*ControlName`) against mixed-case strings -- V.Args returns control names in **UPPERCASE** (e.g., `GSCARDTODO` not `gsCardToDo`). Always normalize with `F.Intrinsic.String.UCase` before comparing, or compare against uppercase literals
- **Never** assume `F.Data.DataTable.DeleteRow` physically removes the row -- it only MARKS the row for deletion. Call `F.Data.DataTable.AcceptChanges("dtName")` after `DeleteRow` to physically remove marked rows. Without `AcceptChanges`, the row remains in the DataTable and bound controls still display it
- **Never** assume `AccordionControl.NavigationFrame("navMain")` auto-switches NavPages on click -- it does NOT. You MUST manually call `Gui.Form_Name.navMain.SelectedIndex(n)` inside the `ElementClick` handler based on `V.Args.ElementID`. Every production GAB script does this manually
- **Never** rely on `GsWebView2.ExecuteScript()` for pushing data from GAB to JavaScript -- it causes **Error 3000** ("This property is not supported by the object") at runtime. Use **file-based data injection** instead: write data to a `.js` sidecar file from GAB, then load it in the HTML via `<script src="...">`. See Pattern G in `PATTERNS.md` for the complete approach
- **Never** use JavaScript libraries that require HTTP origin (e.g., CesiumJS, Mapbox GL) in a `GsWebView2` loaded via `file://` -- CORS blocks all tile requests from `file://` origin. Use libraries that work with `file://` (e.g., Leaflet.js with ESRI/OpenStreetMap CDN tiles). If an HTTP-origin library is mandatory, consider `SetVirtualHostNameToFolderMapping` on the WebView2 control (if supported by the GAB runtime)
- **Never** use `F.Intrinsic.Debug.Print` when running scripts via `.gaf` launcher -- `Print` output only appears in the GAB IDE debugger and is silently discarded in unattended execution. Use `F.Intrinsic.Debug.EnableLogging` + `SetLA(...)` for diagnostics in `.gaf`-launched scripts
- **DO** use `F.Intrinsic.Debug.EnableLogging` in `.gaf`-launched scripts -- creates `octsrs.*.debug` trace files in `%TEMP%\GSS\` regardless of launch method. It is automation-safe and provides native trace output
- **NEVER** use `F.Intrinsic.Debug.SetLevel` -- it pops a blocking `DevExpress.XtraInputBox` dialog ("Enter debugging level") that halts execution until a user responds. Use the `octsrs.logging` sentinel file for trace enablement instead
- **NEVER** inject custom file-writing debug code (`Append2FileNewLine` to a `.debug.log`, `DebugLog` subroutines, `V.Global.sDebugLogPath`). Use native OCTSRS trace: `F.Intrinsic.Debug.EnableLogging` + `SetLA(...)` with the `octsrs.logging` sentinel
- **NEVER** use twip values in any script. `F.Intrinsic.UI.UsePixels` is mandatory for ALL GUI scripts. All Size/Position values must be in pixels
- **Always** call `F.Intrinsic.UI.UsePixels` as the **first statement in Main** for any script with a ScreenSU block. Without it, all pixel-based ScreenSU coordinates (Size, Position) are interpreted as twips, making the form astronomically large and unusable. This is the single most common cause of "my form is giant" or "everything is off screen"

## GUI Layout & Anchoring Rules
- **Always** set `.Sizeable(True)` on forms intended for user interaction. Fixed-size forms should be the exception
- **Always** set `.MinX()` and `.MinY()` to meaningful minimums on resizable forms. The demo default of `MinX(0)/MinY(0)` allows the form to collapse to unusable size
- **Always** set `.MaxButton(True)` alongside `.Sizeable(True)` for dashboards
- **Always** anchor controls appropriately for resize behavior. Default anchor is `5` (Top+Left = fixed position). Forgetting `.Anchor()` means controls stay pinned top-left and ignore resize
- **Never** use `Dock(5)` (Fill) on a grid without considering its siblings -- a Dock(5) control consumes ALL remaining space and covers any controls added before it. If using Dock-based layout, add Top/Bottom docked elements FIRST, then the Dock(5) Fill element LAST
- **Never** mix Dock and Anchor on the same control unless you understand the interaction. Typically: use Dock for the layout skeleton (sidebar, toolbar, fill area) and Anchor for fine-grained resize within regions
- **Always** use `.Parent("frameName")` to place child controls inside Frame containers. Controls default to being children of the form

### Anchor Values (WinForms AnchorStyles bit flags)
| Value | Edges | Use case |
|------:|-------|----------|
| 0 | None | Floating, no resize tracking |
| 1 | Top | Pin to top only |
| 2 | Bottom | Pin to bottom only |
| 4 | Left | Pin to left only |
| 5 | Top+Left | **Default** -- fixed position, no resize |
| 6 | Bottom+Left | Bottom-left buttons |
| 8 | Right | Pin to right only |
| 9 | Top+Right | Top-right aligned buttons |
| 10 | Bottom+Right | Close/Save at bottom-right |
| 13 | Top+Left+Right | **Header/toolbar band** -- stretches width |
| 14 | Bottom+Left+Right | **Status bar** -- stretches width at bottom |
| 15 | All | **Fill** -- stretches with container (grids, tabs) |

### Dock Values (DockStyle enum, or raw integer)
| Value | `V.Enum.DockStyle!` | Behavior |
|------:|---------------------|----------|
| 0 | None | Manual position |
| 1 | Top | Dock to top edge |
| 2 | Bottom | Dock to bottom |
| 3 | Left | Dock to left |
| 4 | Right | Dock to right |
| 5 | Fill | Fill remaining space |

### Production Layout Patterns

**Pattern A: Anchor-based dashboard (most common for new scripts)**
```
Gui.frmMain..Create(BaseForm)
Gui.frmMain..Sizeable(True)
Gui.frmMain..MaxButton(True)
Gui.frmMain..MinX(700)
Gui.frmMain..MinY(500)
Gui.frmMain.fraHeader.Create(Frame)
Gui.frmMain.fraHeader.Size(910,160)
Gui.frmMain.fraHeader.Position(15,10)
Gui.frmMain.fraHeader.Anchor(13)
Gui.frmMain.gsGCMain.Create(GsGridControl)
Gui.frmMain.gsGCMain.Size(910,440)
Gui.frmMain.gsGCMain.Position(15,180)
Gui.frmMain.gsGCMain.Anchor(15)
```

**Pattern B: Dock-based layout (toolbar + fill grid)**
```
Gui.frmMain.fraToolbar.Create(Frame)
Gui.frmMain.fraToolbar.Dock(1)
Gui.frmMain.fraToolbar.Size(0,80)
Gui.frmMain.gsGC.Create(GsGridControl)
Gui.frmMain.gsGC.Dock(5)
```

**Pattern C: Sidebar + content (Accordion left, fill right)**
```
Gui.frmMain.accNav.Create(AccordionControl)
Gui.frmMain.accNav.Dock(3)
Gui.frmMain.navMain.Create(NavFrame)
Gui.frmMain.navMain.Dock(5)
```

**Pattern D: Frame container with child controls using Parent**
```
Gui.frmMain.fraViewer.Create(Frame)
Gui.frmMain.fraViewer.Anchor(15)
Gui.frmMain.wvConfig.Create(GsWebView2)
Gui.frmMain.wvConfig.Parent("fraViewer")
Gui.frmMain.wvConfig.Dock(5)
```

## Grid/Data Binding Rules
- **Never** combine `Gui.<Form>.<GsGridControl>.DataSource("dtName")` with `Gui.<Form>.<GsGridControl>.MainView("gvName")` on the same grid. For editable grids or any scenario requiring `SetGridviewProperty`, `SetColumnProperty`, or other view-scoped configuration, bind with `AddGridviewFromDatatable` / `AddGridviewFromDataview` and `MainView` only. Use `DataSource` only for read-only display when a named gridview and column/grid property APIs are not required. The same rule applies to `GsAdvBandedGridControl` (shared binding behavior).
- **Never** include the `$ChildDT` suffix in the `SourceDataTableName` argument when calling any `F.Data.DataView.ToDataTable*` function (`ToDataTable`, `ToDataTableDistinct`). Even if the DataView was created from a child DataTable, pass only the parent DataTable name. Example: use `"dtSalesOrders"`, not `"dtSalesOrders$dtWorkOrders"`. This does **not** apply to `F.Data.DataView.CreateFromDataTable`.
- **Never** create a child DataTable without the `$` naming convention when it will be used in `F.Data.DataTable.AddRelation`. The child must be created as `dtParent$dtChild` (e.g., `F.Data.DataTable.CreateFromSQL("dtStaging$dtStagExpand",...)`) -- not as a standalone name like `"dtStagExpand"`. The `$` prefix establishes the parent-child link at creation time. When binding to a grid via `AddGridviewFromDatatable`, the child gridview is **auto-named** by GAB as the child DataTable portion (e.g., `gvChild` derived from `dtParent$dtChild`). Do not assume you control the child gridview name -- use `GetFocusedGridview` to discover it at runtime
- **Never** call `Gui.<Form>.gsGC.AddRelation` when `F.Data.DataTable.AddRelation` has already been established between the same parent and child DataTables. The DataTable-level relation is sufficient; the grid inherits it automatically. Using both is redundant and causes unexpected behavior.
- **Prefer** string literals (e.g., `"AllowSort"`, `"Caption"`) over `V.Enum.GridViewPropertyNames!` / `V.Enum.ColumnPropertyNames!` for grid/column property names -- the enum form requires GSSVersion >= 2023.1 and causes Error 5150 on older runtimes. If using the enum form, guard with `F.Intrinsic.Control.If(V.Caller.GSSVersion,>=,2023.1)`
- **Always** wrap grid property configuration (`SetGridviewProperty`, `SetColumnProperty`, `SetColumnVisible`, etc.) in `SuspendLayout` / `ResumeLayout`. Without this wrapper, grid columns may not render, data may appear invisible, and the grid may look empty even though the DataTable has rows:
  ```
  Gui.frmMain.gsGC.SuspendLayout
  Gui.frmMain.gsGC.SetGridviewProperty("gvMain","AllowSort",True)
  Gui.frmMain.gsGC.SetGridviewProperty("gvMain","AllowFilter",True)
  Gui.frmMain.gsGC.SetColumnProperty("gvMain","PART","Caption","Part Number")
  Gui.frmMain.gsGC.SetColumnProperty("gvMain","PART","Width",150)
  Gui.frmMain.gsGC.ResumeLayout
  Gui.frmMain.gsGC.BestFitColumns("gvMain")
  ```
- **Always** call `BestFitColumns("gvName")` after `ResumeLayout` to auto-size columns to their content on initial load
- **Always** remember that `GetFocusedGridview` returns the **DataTable name** in UPPERCASE, NOT the gridview name. If you have `AddGridviewFromDatatable("dtOrders","gvOrders")`, calling `GetFocusedGridview` returns `"DTORDERS"` not `"gvOrders"`. Use `F.Intrinsic.String.UCase` when comparing
- **Always** ensure parent key columns are unique when using `F.Data.DataTable.AddRelation`. If the parent DataTable has duplicate values in the key column(s), `AddRelation` fails with an obscure error. For BOM structures, use a composite key like `PARENT+SEQUENCE_BOM` (not just `PARENT` alone). Create a calculated column combining the fields if needed
- **Never** use subquery derived tables in Zen SQL `FROM` clauses -- Actian Zen does not support `SELECT ... FROM (SELECT ...)` syntax. Use direct `JOIN` with `DISTINCT` instead. For complex aggregations, use a temporary DataTable or multiple queries
- **Always** use the 4-parameter form of `ContextMenuAddItem` for production context menus: `ContextMenuAddItem("menuName","itemKey",0,"Caption")`. The first param is the menu name, second is a unique key, third is the icon index (0 for none), fourth is the display caption. Then call `ContextMenuAttach("menuName","controlName")` to bind the menu to a control. Use `SetItemEventHandler("menuName","itemKey",SubName)` for click handling
- **Always** use `RowCellClick` for right-click context preparation (setting the focused row before showing a context menu) and `FocusedRowChanged` for left-click grid navigation (loading detail data when the user selects a row). Do not use `FocusedRowChanged` for right-click workflows -- it fires too late in the event chain

## CallSub & Subroutine Argument Traps
- **Never** use `V.Local.sMsg` to read a parameter passed via `CallSub` -- parameters arrive in the `V.Args` scope, NOT `V.Local`. When you call `F.Intrinsic.Control.CallSub(MySub,"sMsg",V.Local.sValue)`, the receiving subroutine must read it as `V.Args.sMsg`, not declare `V.Local.sMsg` and expect it to contain the value. Declaring `V.Local.sMsg` creates an empty local variable that shadows the passed argument:
  ```
  ' WRONG -- sMsg is always empty:
  Program.Sub.DebugLog.Start
  V.Local.sMsg.Declare(String,"")
  F.Intrinsic.UI.Msgbox(V.Local.sMsg)
  Program.Sub.DebugLog.End

  ' CORRECT -- read from V.Args:
  Program.Sub.DebugLog.Start
  F.Intrinsic.UI.Msgbox(V.Args.sMsg)
  Program.Sub.DebugLog.End
  ```
  This is the **#1 cause of blank debug logs, blank summary text, and blank helper sub output**. Every subroutine that receives parameters via CallSub must use `V.Args.<paramName>` to read them.
- **Never** place `V.Local.*.Declare(...)` inside a `Try/Catch` block -- variable declarations inside Try/Catch crash GAB at **parse time** (not runtime). Always declare all variables at the top of the subroutine, before the Try block:
  ```
  ' WRONG -- crashes at parse time:
  F.Intrinsic.Control.Try
      V.Local.sResult.Declare(String,"")
      '...
  F.Intrinsic.Control.Catch
  F.Intrinsic.Control.EndTry

  ' CORRECT -- declare before Try:
  V.Local.sResult.Declare(String,"")
  F.Intrinsic.Control.Try
      '...
  F.Intrinsic.Control.Catch
  F.Intrinsic.Control.EndTry
  ```

## For Loop & Operator Traps
- **Never** use `.--` (decrement) or `.++` (increment) directly in `For` loop bounds -- the operator **mutates the variable on every iteration**. `For(iRow, 0, iCount.--, 1)` decrements `iCount` each time through the loop, so subsequent loops using `iCount` see a smaller value. Pre-compute the upper bound with `F.Intrinsic.Math.Sub(iCount, 1, iMax)` and use the stable `iMax` variable:
  ```
  ' WRONG -- iCount is destroyed by the loop:
  F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iCount.--,1)
  '... after loop, iCount is now 0

  ' CORRECT -- pre-compute upper bound:
  F.Intrinsic.Math.Sub(V.Local.iCount,1,V.Local.iMax)
  F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iMax,1)
  '... after loop, iCount is still the original value
  ```

### No Inline `mod` in If Statements

`F.Intrinsic.Control.If` does **not** support the `mod` operator inline. This will fail:

```
'-- WRONG: mod is not a comparison operator
F.Intrinsic.Control.If(V.Local.iCount,mod,50,=,0)
```

Pre-compute the remainder into a local variable first:

```
'-- CORRECT: pre-compute then compare
F.Intrinsic.Math.Mod(V.Local.iCount,50,V.Local.iRemainder)
F.Intrinsic.Control.If(V.Local.iRemainder,=,0)
    '-- do something every 50 iterations
F.Intrinsic.Control.EndIf
```

- **Never** use `F.Data.DataTable.ExecuteSQLNonQuery` -- this method does NOT exist. For INSERT/UPDATE/DELETE statements, use `F.ODBC.Connection!con.Execute(V.Local.sSQL)` on an open connection

## Variable & Path Traps
- **Never** use `V.Caller.FilePath` -- this variable does NOT exist (Error 119). Use `V.Ambient.ScriptPath` for the script's directory path, or `V.Caller.ScriptFile` for the fully-qualified script filename
- **Never** assume `""` (double-double-quote) in a GAB string literal produces a single `"` in output -- GAB's `""` escape produces **literal `""`** (two quote characters) in the generated string. To embed a real double-quote character, use `V.Ambient.DblQuote` and concatenate or replace:
  ```
  ' WRONG -- produces doubled quotes in output:
  V.Local.sJson.Set("[""value1"",""value2""]")
  ' Output: [""value1"",""value2""]

  ' CORRECT -- use DblQuote + Replace to get single quotes:
  V.Local.sQ.Set(V.Ambient.DblQuote)
  F.Intrinsic.String.Build("[{0}value1{0},{0}value2{0}]",V.Local.sQ,V.Local.sJson)
  ' Output: ["value1","value2"]
  ```
  **Preferred for DataTable → JSON:** Use `F.Data.DataTable.SaveToJson("dtName","path.json")` instead of manually building JSON strings. Manual JSON building with DblQuote is fragile and breaks on special characters, nested objects, or unicode. See the SaveToJson → File2String → WebView2 pattern in `PATTERNS.md`

## HTTP / REST / JSON Communication Traps
- **Never** use `F.Communication.HTTP.Reset()` between HTTP calls -- `Reset()` nukes the entire component's internal state including method type and SSL configuration, causing "Invalid method specified" errors on subsequent calls. Use `F.Communication.HTTP.ResetHeaders` instead, which only clears headers, cookies, and local file settings while preserving the component's operational state
- **Never** use `F.Communication.HTTPS.*` methods when you have access to `F.Communication.HTTP.*` with SSL config -- while `HTTPS.*` is documented in the API reference, the `HTTP.*` component with `Config("SSLEnabledProtocols=4032",sResult)` is the tested and reliable approach. The `HTTPS.*` namespace may cause "Invalid method specified" in some runtimes
- **Never** apply `F.Intrinsic.String.MakeURLFriendly()` to a full URL including the scheme (`https://`) -- it over-encodes the `://` and path separators into percent-encoded characters, producing an invalid URL. Apply `MakeURLFriendly` only to **query parameter values**, not the full URL:
  ```
  ' WRONG -- over-encodes the entire URL:
  F.Intrinsic.String.MakeURLFriendly("https://api.example.com/search?q=hello world",V.Local.sUrl)
  ' Result: https%3A%2F%2Fapi.example.com%2Fsearch%3Fq%3Dhello%20world

  ' CORRECT -- encode only the parameter value:
  F.Intrinsic.String.MakeURLFriendly("hello world",V.Local.sEncoded)
  F.Intrinsic.String.Build("https://api.example.com/search?q={0}",V.Local.sEncoded,V.Local.sUrl)
  ```
- **Always** set `F.Communication.HTTP.SetProperty("LocalFile",sResponsePath)` when using `HTTP.Post` or `HTTP.Get` -- without a `LocalFile`, the HTTP component may not properly capture the response. Use `F.Communication.JSON.ParseFile(sResponsePath)` to parse the response afterward
- **Never** assume `F.Communication.JSON.ReadProperty("XText",...)` returns a bare value -- JSON string values are returned **with surrounding double-quote characters** (e.g., `"GAB Test"` not `GAB Test`). Strip quotes before comparing:
  ```
  F.Communication.JSON.ReadProperty("XText",V.Local.sVal)
  F.Intrinsic.String.Replace(V.Local.sVal,V.Ambient.DblQuote,"",V.Local.sVal)
  ```
- **Always** use `F.Communication.REST.*` for simple REST API calls (GET/POST/PUT/DELETE with JSON) -- the REST component handles SSL, encoding, and response parsing more reliably than the lower-level HTTP component. Reserve `HTTP.*` for scenarios requiring fine-grained control (custom headers, file downloads, multipart uploads)
- **Always** use **1-based** array indexing in JSON XPath navigation -- `F.Communication.JSON.SetProperty("XPath","/JSON/results/[1]/name")` for the first element, not `[0]`

## Runtime Behavior
- **Never** close a DataTable in one subroutine if a subsequent subroutine in the call chain still needs it
- **Never** reuse the same ODBC connection name across concurrent or nested operations
- **Never** use `F.Intrinsic.Control.End` as normal flow in business logic subroutines; it terminates the entire program. **Exception:** the UnLoad handler on a single-screen `.g2u` MUST call `F.Intrinsic.Control.End` (both on the normal path and after the error handler) because there is no parent screen to return to
- **Never** use `GoTo` across `Try/Catch` boundaries -- it corrupts the error handler stack
- **Never** skip error handling in subroutines
- **Never** leave ODBC connections open longer than needed

- **Never** create a file named `octsrs.logging` at `%TEMP%\GSS\` unless you intend to enable **machine-wide trace logging** for the GAB runtime. The mere existence of this sentinel file enables verbose diagnostic logging for ALL Octsrs.net processes on the machine, which can significantly impact performance. Remove it when debugging is complete
- **Always** remember that `F.Data.DataTable.GetFieldNames("dtName",V.Local.sFields)` returns a `*!*`-delimited string (not comma or pipe). You must `F.Intrinsic.String.Split(V.Local.sFields,"*!*",V.Local.sFields)` before using `.UBound` or indexing into the result array
- **Always** consider `SaveToProtobuf` vs `SaveToJson` version branching when targeting multiple GSSVersion environments. `SaveToJson` is available in GSSVersion >= 2022.0; older versions only support `SaveToProtobuf`. Guard with `F.Intrinsic.Control.If(V.Caller.GSSVersion,>=,2022.0)` and branch accordingly

## SQL/Data Rules
- **Never** assume column order in SQL; always name columns explicitly
- **Never** write a `CreateFromSQL` statement without first validating column names against the target DSN or the schema docs in `agents/schema/*.md`. Query schema metadata (e.g., `SELECT TOP 1 * FROM view_name`) via ODBC if the schema doc is unavailable. Column names must be verified -- never guess from naming conventions or memory alone
- **Never** hardcode connection strings; use `V.Ambient.PDSN/PUser/PPass`
- **NEVER** use OpenRecordset* functions (OpenRecordsetRO, OpenRecordsetRW, OpenLocalRecordsetRO, OpenLocalRecordsetRW) -- they are **BANNED**. Use `F.Data.DataTable.CreateFromSQL` for queries, `ExecuteAndReturn` for scalar lookups
- **NEVER** use V.ODBC recordset accessors (V.ODBC.con!rst.*) -- use V.DataTable.dt(row).Col!FieldVal instead
- **Avoid** row-by-row database operations; prefer batch DataTable.SaveToDB

## Hook Rules
- **Never** guess or assume which `V.Passed` fields are available in a hook script. The set of `V.Passed` variables is entirely determined by the calling hook point — each hook passes its own named elements. Always ask the user for the hook number and its passed elements. Always guard access with `F.Intrinsic.Variable.PassedExists` before reading.

### V.Passed Metadata: Properties, Not Methods

`V.Passed` metadata transforms (`.Name`, `.DataType`, `.Length`, `.HWnd`, `.Locked`, `.Hidden`, `.NoChange`, `.TabStop`) are **read properties without parentheses**:

```
'-- CORRECT: property reads (no parens)
V.Local.sName.Set(V.Passed.Employee.Name)
V.Local.sType.Set(V.Passed.Employee.DataType)

'-- WRONG: method-style parens cause Error 113
V.Local.sName.Set(V.Passed.Employee.Name())
```

Write operations (`.Set()`, `.Append()`) DO use parentheses.

## Formatting Rules
- **Never** add blank lines inside `ScreenSU` blocks -- all control definitions must be packed tight with no spacing between lines. The GAB IDE strips blank lines from ScreenSU on save.
- **Never** add blank lines inside `Preflight` blocks -- declarations go directly between `Program.Sub.Preflight.Start` and `Program.Sub.Preflight.End` with no spacing.
- **Always** place a blank line after `F.Intrinsic.Control.ClearErrors` before variable declarations in subroutine bodies. This separates the error handler setup from the business logic.
- **Always** place `BlockEvents` after variable declarations, not before. Declare all locals first, then call `F.Intrinsic.Control.BlockEvents`.
- **Always** make ODBC connections self-contained within the subroutine that uses them -- open, query/execute, and close in the same sub. The caller should not manage the connection on behalf of a called sub.

## File/Project Rules
- **Never** save a library file (no ScreenSU block) as `.g2u` -- it must be `.lib`
- **Never** modify a standard `.lib` file (e.g., `100200.lib`, `200800.lib`, `930000.lib`). These are Global Shop Solutions-provided libraries shipped with GAB. Include them via `Program.External.Include.Library` in Preflight and interact only through their documented DataTables, global variables, and exposed subroutines. If a standard library has a bug or limitation, work around it in your own code -- do not patch the `.lib` file.
- When a GAB script uses a standard `.lib` file via `Program.External.Include.Library` (e.g., `930000.lib`), copy both the `.lib` and its `.lib.sig` companion from `%GSSPATH%PLUGINS\GAB\GAS\` into the project folder where the `.g2u` script lives. This prevents Runtime Error 30 ("Include file is missing") when running outside the GAS directory. **If the `GSSPATH` environment variable does not exist on the system, do not attempt to copy files** -- inform the user that GSSPATH is not set and the `.lib` files must be obtained manually.
- **Never** modify the Comments block at file end
- **Never** use `F.Intrinsic.Debug.InvokeDebugger` or `F.Intrinsic.Debug.Stop` in production code

## Legacy Avoidance
- **Never** use `GsFlexGrid` or `HFlexGrid` in new projects -- use `GsGridControl` instead (GsFlexGrid reference is retained only for maintaining legacy scripts)
- **Never** use UDTs (`Variable.Define`, `V.uLocal`, `V.uGlobal`, `F.Intrinsic.Variable.UDT*`) in new projects -- use `DataTable` instead (UDT reference is retained only for maintaining legacy scripts)

---

# CRITICAL GAB BEHAVIOR: Try/Catch CANNOT Be Nested Within the Same Subroutine

**GAB `Try/Catch` blocks CANNOT be nested within the same subroutine.** GAB tracks only one active Try/Catch context per subroutine. Placing a `Try` inside another `Try` in the same sub causes errors between the outer `Try` and the inner `Try` to route to the **inner** `Catch` instead of the outer one.

**Cross-subroutine Try/Catch IS allowed.** Subroutine A can use Try/Catch and call subroutine B which also uses Try/Catch — each subroutine maintains its own error handler context and they do not interfere.

**The correct error handling strategy:**
- **`SetErrorHandler` + label-based error handling** is the **standard pattern for ALL subroutines**. This is the general-purpose error handling mechanism in GAB.
- **`Try/Catch`** is reserved ONLY for **targeted error capture** around a specific risky operation (e.g., wrapping a single ODBC call, file operation, or DLL invocation where you expect a particular failure and want to handle it gracefully without terminating the subroutine).
- **Never nest a `Try` block inside another `Try` block in the same subroutine.** The inner Try hijacks error routing from the outer Try.
- When using `Try/Catch` for targeted capture, keep the `Try` block as small as possible -- wrap only the single operation that might fail, not the entire subroutine body.

**Anti-pattern -- same-subroutine nesting (WILL MISROUTE ERRORS):**
```
Program.Sub.Main.Start
F.Intrinsic.Control.Try
     Function.Intrinsic.UI.UsePixels
     F.Intrinsic.Control.BlockEvents
     Gui.FormDocLib..Show
     Gui.FormDocLib..AlwaysOnTop(True)
     Gui.FormDocLib..AlwaysOnTop(False)
     F.Intrinsic.Control.CallSub(Get_Data)
     F.Intrinsic.Control.CallSub(Set_Prop)
     F.Intrinsic.Control.CallSub(Deserialize)
    F.Intrinsic.Control.Try                         <-- NESTED Try inside outer Try
         V.Global.bShow.Set(True)
    F.Intrinsic.Control.Catch                       <-- errors from ABOVE route HERE
         F.Intrinsic.Control.CallSub(ErrorMessage)
    F.Intrinsic.Control.EndTry
    F.Intrinsic.Control.UnBlockEvents
F.Intrinsic.Control.Catch
    F.Intrinsic.Control.CallSub(ErrorMessage)
F.Intrinsic.Control.EndTry
Program.Sub.Main.End
```
If `Get_Data`, `Set_Prop`, or `Deserialize` throws an error, it jumps to the **inner** Catch (not the outer one), because GAB only tracks one active Try/Catch context per subroutine. The outer Catch becomes unreachable for errors that occur before the inner Try is encountered.

**Correct pattern -- standard subroutine:**
```
Program.Sub.LoadData.Start
F.Intrinsic.Control.SetErrorHandler("LoadData_Err")
F.Intrinsic.Control.ClearErrors
V.Local.sError.Declare(String,"")
'... business logic ...
F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("LoadData_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: myproject.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.LoadData.End
```

**Correct pattern -- targeted Try/Catch for a single risky operation within a SetErrorHandler sub:**
```
Program.Sub.TryImport.Start
F.Intrinsic.Control.SetErrorHandler("TryImport_Err")
F.Intrinsic.Control.ClearErrors
V.Local.sError.Declare(String,"")
V.Local.bImportOk.Declare(Boolean,"True")
'-- Targeted Try/Catch: wrap ONLY the risky DLL call
F.Intrinsic.Control.Try
    F.Automation.Generic.CallMethodReturnVariable(V.Local.oImporter,"Import",V.Local.sFilePath,V.Local.sResult)
F.Intrinsic.Control.Catch
    V.Local.bImportOk.Set(False)
F.Intrinsic.Control.EndTry
'-- Continue with SetErrorHandler-protected logic
F.Intrinsic.Control.If(V.Local.bImportOk,=,False)
    F.Intrinsic.UI.Msgbox("Import failed. Check file format.")
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
'... rest of logic ...
F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("TryImport_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: myproject.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(frmMainUnLoad)
F.Intrinsic.Control.EndIf
Program.Sub.TryImport.End
```

---

# CRITICAL GAB BEHAVIOR: Array Elements in CallSub Arguments

**NEVER pass `V.Local.arrayVar(N)` directly as a CallSub argument.**

GAB passes the **entire array**, not just the element at index N. The receiving subroutine's `ArgToVar` gets the full array, and property accessors like `.Trim`, `.Long` operate on element 0 instead of the intended element.

**Wrong:**
```
F.Intrinsic.Control.CallSub(MySub,"sArg",V.Local.sParts(1))
```

**Correct — extract to a plain variable first:**
```
V.Local.sTemp.Set(V.Local.sParts(1))
F.Intrinsic.Control.CallSub(MySub,"sArg",V.Local.sTemp)
```

This was discovered during the WebView2 dashboard port when passing split hash fragment elements to subroutines.

---

# CRITICAL GAB BEHAVIOR: Nested CallSub ArgToVar Scoping

**When subroutine A calls subroutine B via CallSub, and subroutine B calls subroutine C via CallSub, the arguments passed from B to C may not be received correctly by `ArgToVar` in C.** Specifically, string literal arguments (e.g., `"sType","audit"`) can arrive as empty strings in the nested callee.

This was discovered when `UrlChanged` → `ViewAuditLog` → `WriteModalAndReload` chain resulted in `ArgToVar("sType",V.Local.sType)` returning empty despite `"audit"` being passed explicitly.

**Workaround:** Avoid relying on `ArgToVar` for data that can be communicated through other means (globals, file contents, etc.). When nesting CallSub calls, minimize the number of arguments passed to deeply nested subroutines.

---

# CRITICAL GAB BEHAVIOR: Every DLL Method Must Accept a String Parameter

**GAB's `CallMethod` / `CallMethodReturnVariable` always passes the Args field as a single `string` to the .NET method**, even when the GAB script passes `""`. The .NET runtime performs overload resolution looking for a method that accepts `(string)` -- a parameterless method will fail with:

> `Overload resolution failed because no accessible 'MethodName' accepts this number of arguments`

**Wrong -- parameterless method will fail when called from GAB:**
```csharp
public string Ping() { return "PONG"; }
```

**Correct -- accept the string parameter (ignore it if unused):**
```csharp
public string Ping(string args) { return "PONG"; }
```

This applies to **every** method intended to be called via `F.Automation.Generic.CallMethod` or `CallMethodReturnVariable`. Multi-parameter methods use `*!*` as a delimiter within that single string; the .NET runtime maps them to multiple method parameters in order.

---

# CRITICAL GAB BEHAVIOR: String.Build and Literal Braces

`F.Intrinsic.String.Build` uses `{N}` as placeholder syntax. To include a **literal `{` or `}`** in the output, you must pass them as parameters — you cannot escape them inline.

**Wrong — braces interpreted as malformed placeholders:**
```
F.Intrinsic.String.Build("window.DATA={""type"":""test""};",V.Local.sResult)
```

**Correct — pass braces as parameters:**
```
V.Local.sQ.Set(V.Ambient.DblQuote)
V.Local.sLB.Set("{")
V.Local.sRB.Set("}")
F.Intrinsic.String.Build("window.DATA={2}{0}type{0}:{0}test{0}{3};",V.Local.sQ,"",V.Local.sLB,V.Local.sRB,V.Local.sResult)
' Output: window.DATA={"type":"test"};
```

Use `V.Ambient.DblQuote` (or assign to a local variable) for embedded double quotes in generated JS/JSON strings. The key pattern is: **assign special characters to local variables, then reference them by placeholder index.**

---

# CRITICAL GAB BEHAVIOR: String2File Argument Order

`F.Intrinsic.File.String2File` takes **(path, content)** — path first, content second.

**Wrong — will error with "Illegal characters in path":**
```
F.Intrinsic.File.String2File(V.Local.sContent, V.Local.sFilePath)
```

**Correct:**
```
F.Intrinsic.File.String2File(V.Local.sFilePath, V.Local.sContent)
```

The same order applies to `File2String`: **(path, outputVariable)**.

---

# CRITICAL GAB BEHAVIOR: DataTable Lifetime Across Subroutines

DataTable Create functions (`CreateFromSQL`, `Create`, `CreateFromString`, `CreateFromCSV`, etc.) accept an optional `GlobalScope` Boolean parameter. **When omitted, it defaults to `False` (local scope)** -- the DataTable is destroyed when the creating subroutine exits. If another subroutine tries to access it, Error 21001 ("does not exist in callable scope") occurs.

**Rule:** If a DataTable is used across subroutines (created in sub A, read in sub B), pass `True` as the GlobalScope parameter. Example: `F.Data.DataTable.CreateFromSQL("dtName","con",sSql,True)`.

**Pattern:** When a DataTable is needed across multiple subroutines in a call chain (e.g., `LoadData` → `BuildJson`), do NOT close it in the first sub. Close it in the last consumer.

**Always guard access:**
```
F.Intrinsic.Control.If(V.DataTable.dtName.Exists)
    F.Intrinsic.Control.If(V.DataTable.dtName.RowCount--,>=,0)
        '... safe to iterate
    F.Intrinsic.Control.EndIf
    F.Data.DataTable.Close("dtName")
F.Intrinsic.Control.EndIf
```

---

# CRITICAL GAB BEHAVIOR: ODBC Connection Naming

Each `F.ODBC.Connection!name.OpenCompanyConnection` must use a **unique name**. If two subroutines or nested calls use the same connection name, one may silently close the other's connection.

**Wrong — reusing `con` in a nested call chain:**
```
F.ODBC.Connection!con.OpenCompanyConnection     ' Parent opens
F.Intrinsic.Control.CallSub(ChildSub)           ' Child also opens !con → conflict
```

**Correct — use unique names per context:**
```
F.ODBC.Connection!conMain.OpenCompanyConnection  ' Main data load
F.ODBC.Connection!conCfg.OpenCompanyConnection   ' Config query
F.ODBC.Connection!conSave.OpenCompanyConnection  ' Save operations
```

---

# CRITICAL GAB BEHAVIOR: Left/Right Properties Are Fixed-Width Only

The `.Left<N>` and `.Right<N>` inline properties only support **hardcoded widths**: `.Left1`, `.Left2`, `.Left3`, `.Left5`, `.Left10`, etc. You cannot pass an arbitrary variable like `.Left(N)`.

**Wrong — no dynamic Left function exists:**
```
V.Local.sResult.Set(V.Local.sStr.Left(3))
```

**Correct — use F.Intrinsic.String.Left for dynamic widths:**
```
F.Intrinsic.String.Left(V.Local.sStr, 3, V.Local.sResult)
```

Or use a fixed-width property when the width is known at code-writing time:
```
V.Local.sResult.Set(V.Local.sStr.Left3)
```

---

# CRITICAL GAB BEHAVIOR: UBound Is a Property, Not a Function

`.UBound` is a **property accessor** on a split-string array variable, NOT a function call.

**WRONG:** `F.Intrinsic.String.UBound(V.Local.sArray, V.Local.iResult)` — this function does not exist.

**CORRECT:** `V.Local.iResult.Set(V.Local.sArray.UBound)`

The same applies to `.LBound`. These are read-only properties accessed via `.Set()`, not `F.Intrinsic.String.*` function calls.

---

# CRITICAL GAB BEHAVIOR: FocusCell Takes Integer Column Index, NOT Column Name

`GsGridControl.FocusCell` third parameter is an **integer column index** (0-based), NOT a column name string.

**WRONG:** `Gui.frmMain.gsGC.FocusCell("gvName",0,"COLUMN_NAME")` — causes "Conversion from string to type 'Integer' is not valid" error.

**CORRECT:** `Gui.frmMain.gsGC.FocusCell("gvName",0,1)` — uses column index 1.

To resolve a column name to index:
```
Gui.frmMain.gsGC.GetColumnIndexByName("gvName","COLUMN_NAME",V.Local.iColIndex)
Gui.frmMain.gsGC.FocusCell("gvName",0,V.Local.iColIndex)
```

If you just need to select a row without cell focus, use `SelectRow` instead:
```
Gui.frmMain.gsGC.SelectRow("gvName",0)
```

Verified from 900+ production scripts (RKing reference library, 2026-05-24).

---

# CRITICAL GAB BEHAVIOR: FocusedRowChanged Uses V.Args.FocusedRowHandle, NOT V.Args.RowHandle

The `FocusedRowChanged` event provides `V.Args.FocusedRowHandle`, NOT `V.Args.RowHandle`.

**WRONG:** `V.Local.iRow.Set(V.Args.RowHandle)` — causes Error 5150: "The specified variable {VARIABLE.ARGS.ROWHANDLE} does not exist"

**CORRECT:** `V.Local.iRow.Set(V.Args.FocusedRowHandle)`

Each event type has its own arg names:
- `FocusedRowChanged` → `V.Args.FocusedRowHandle`, `V.Args.PrevFocusedRowHandle`
- `RowCellClick` → `V.Args.RowHandle`, `V.Args.RowIndex`, `V.Args.Column`, `V.Args.CellValue`
- `CellValueChanged` → `V.Args.RowHandle`, `V.Args.Column`, `V.Args.Value`

Do NOT assume arg names are shared across events. Verified from production scripts and runtime Error 5150 (2026-05-24).

---

# CRITICAL GAB BEHAVIOR: V.Args.FocusedRowHandle Is a VISUAL Index, NOT a DataTable Handle

In `FocusedRowChanged`, `V.Args.FocusedRowHandle` is the **visual row position** (0 = first visible row), NOT the DataTable row index. In unfiltered grids these are identical, so code appears to work. In **filtered grids** they diverge — visual index 0 maps to DataTable row 0 (the first overall row), not the first filtered row.

**WRONG — breaks when grid is filtered:**
```
Gui.<Form>.gsGC.GetCellValueByColumnName("gvName","ColName",V.Args.FocusedRowHandle,V.Local.sResult)
```

**CORRECT — works with filtered AND unfiltered grids:**
```
V.Local.sSelectedRow.Declare(String,"")
V.Local.iRow.Declare(Long,-1)

Gui.<Form>.gsGC.GetSelectedRows("gvName",V.Local.sSelectedRow)
V.Local.iRow.Set(V.Local.sSelectedRow.Trim.Long)
Gui.<Form>.gsGC.GetCellValueByColumnName("gvName","ColName",V.Local.iRow,V.Local.sResult)
```

**Why other approaches fail:**
- `GetCellValueByColumnName(FocusedRowHandle)` — reads DataTable row 0 instead of filtered row (silent wrong data)
- `GetCellValue(colIndex, FocusedRowHandle)` — same problem, also reads from DataTable position
- `GetRowHandle(FocusedRowHandle)` — returns -1 in filtered grids (does not convert visual→DataTable)
- `GetGridviewProperty("FocusedRowHandle")` — ERR, property not accessible

**Only `GetSelectedRows` returns the true DataTable row handle.** Verified via diagnostic instrumentation, 2026-05-25.

---

# Deprecated/Obsolete APIs (from HelpJuice Deep Audit)

> Source: [`docs/helpjuice-deep-audit.md`](docs/helpjuice-deep-audit.md) — 40 functions flagged deprecated or obsolete across 3,193 HelpJuice articles. Do not use these in new code. The gab-lint skill warns on usage (rules DEP1–DEP20).

| # | Function | Status | Note | Alternative |
|:-:|----------|--------|------|-------------|
| 1-3 | Function.Automation.Zip.UnZip/Zip/ZipContents | Obsolete | Namespace is obsolete | Use F.Intrinsic.File zip methods |
| 4 | Function.Communication.Network.GetAuxUserInfo | Obsolete | Namespace is obsolete | N/A |
| 5 | Function.Global.General.ReadLibraryReferences | Obsolete | Function is obsolete | N/A |
| 6-7 | Function.Global.Object.CallMethod/OpenConnection | Obsolete | Command is obsolete | N/A |
| 8 | Function.Global.Security.CheckUserAccess | Deprecated | Since 2010 | Use CheckUserAccessIPM |
| 9-12 | Function.Global.SSF.ReadFile/ReadItem/WriteFile/WriteItem | Deprecated | Do not use | N/A |
| 13 | Function.Intrinsic.Debug.BenchmarkModeEnable | Deprecated | | Use TimerStart/TimerElapsed |
| 14-15 | Function.Intrinsic.UI.AddCalendarFeature/ClearCalendarFeatures | Obsolete | | N/A |
| 16 | Function.Intrinsic.UI.Keyboard | Obsolete | Namespace is obsolete | N/A |
| 17-36 | Function.ODBC.* (recordset methods) | **BANNED for new code** | Lint rules E10/E11/DEP12 flag as ERROR; 833+ legacy scripts still use them but agents must NEVER generate new recordset code | Use `F.Data.DataTable.CreateFromSQL` or `ExecuteAndReturn` |
| 37 | Function.ODBC.Misc.GetDriverList | **Disabled** | Returns Error 599 at runtime | N/A |
| 38 | GUI.*form.*option.Locked | Deprecated | | Use .Enabled(False) |
| 39 | Program.Requires.Manifest.Check | Obsolete | | N/A |
| 40 | Function.ODBC.Misc.InvokeSpy | **Disabled** | Returns Error 599 at runtime | N/A |

**ODBC Recordset Status (updated 2026-06-12): BANNED FOR NEW CODE.** All `OpenRecordset*` and `OpenLocalRecordset*` methods are **prohibited in new scripts**. Use `F.Data.DataTable.CreateFromSQL` for multi-row queries and `F.ODBC.Connection!con.ExecuteAndReturn` for scalar lookups. Lint rule `E10` flags any recordset open as an ERROR. Lint rule `E11` flags any `V.ODBC.*` recordset accessor as an ERROR. These methods still function in the runtime (833+ legacy scripts use them), but agents must NEVER generate new code using them. Only `InvokeSpy` and `GetDriverList` are truly disabled (Error 599).

**CRITICAL: `.Open(DSN,user,pass)` does NOT exist.** The correct ODBC connection methods are:
- `F.ODBC.Connection!con.OpenConnection(DSN,user,pass)` -- for explicit DSN/user/pass
- `F.ODBC.Connection!con.OpenCompanyConnection` -- for the current company database
OCTSRS dispatch handles `OPENCONNECTION`, not `OPEN`. Using bare `.Open(` causes a runtime error.

---

# Callwrapper Best Practices

GAB has **two distinct callwrapper APIs**, both widely used in production (897 RKing scripts + GSS-Custom GitHub). See also [`docs/investigation-upload-tables-callwrappers.md`](docs/investigation-upload-tables-callwrappers.md).

## Named API (Preferred for new code)

Use for typed property access to GSSEO callwrapper programs:

```
F.Global.Callwrapper.New("alias", "Manufacturing.CloseWorkOrderSequence")
F.Global.Callwrapper.SetProperty("alias", "BeginningWorkOrder", V.Local.sJob)
F.Global.Callwrapper.Run("alias")
F.Global.Callwrapper.GetProperty("alias", "Status", V.Local.sStatus)
```

Also available: `GetResult("alias", outputVar)` for programs that return a single result object.

## Numeric API (Legacy, still widely used)

Use when invoking ERP screens/processes by mode number:

```
F.Intrinsic.String.ConcatCallWrapperArgs(arg1, arg2, ..., V.Local.sParams)
F.Global.General.CallWrapperSync(300011, V.Local.sParams)
```

Common mode numbers: `300011` (Issue Material to WIP), `450000` (Close Work Order Sequence), `200000` (Sales Order), `50`/`51` (Print / 1-Shot upload).

## 1-Shot Upload Programs (Mode 50/51)

Invoke fixed-width file upload programs:

```
F.Global.General.CallWrapperSync(50, "UPLINV")
```

79 upload programs documented in [`docs/upload-tables-full-extract.json`](docs/upload-tables-full-extract.json) with 3,556 field definitions.

**Debug tip:** Call `F.Intrinsic.Debug.CallWrapperDebugEnable` before `CallWrapperSync` to trace CW parameter passing (see gab-test-debug skill).

---

# F.Intrinsic.Debug API Classification (Runtime-Verified)

> Validated via [`test/CETESTS/debug_api_test.g2u`](test/CETESTS/debug_api_test.g2u) — 24 PASS, 1 FAIL (Resume), 2026-05-25.

## 22 Automation-Safe Methods

Safe for unattended scripts, `.gaf` launches, and gab-test-debug instrumentation:

SetLA, SetLABuild, Print, EnableLogging, CallWrapperDebugEnable, CallWrapperDebugEnableSilent, CallWrapperDebugDisable, TimerStart, TimerElapsed, TimerElapsedTicks, BenchmarkModeEnable (deprecated), BenchmarkThreshold, ToggleOutput, ToggleOutputListing, DumpVariableList, DumpOutputHookfile, SetScriptVersion, SetProgramDirectory, SetErrorTimeout (not implemented in 2023.x), OverrideGSSVersion, WatchVariable

## 3 Interactive-Only Methods

**BLOCK on dialog — never use in unattended scripts:**

| Method | Behavior |
|--------|----------|
| **SetLevel** | Pops a `DevExpress.XtraInputBox` dialog ("Enter debugging level") that blocks until user responds. **BANNED.** Use the `octsrs.logging` sentinel file instead. |
| ShowCallerInfo | Pops debugger dialog; blocks until user clicks Continue (~48s observed in test) |
| Stop | Breakpoint; halts execution outside attached debugger |
| InvokeDebugger | Launches full debugger GUI |

## 1 Invalid Method

| Method | Behavior |
|--------|----------|
| Resume | Exists in Intellisense index but fails at runtime with **"Invalid method specified"** — do not call |

**Note:** `InvokeDebuggerInDebug` passes runtime tests but is a no-op when no debugger is attached — safe but useless in automation.
