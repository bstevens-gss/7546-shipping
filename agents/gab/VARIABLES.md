# GAB Variables & Enums Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with system variables or enums
# Last verified: 2026-06-30 | Product version: unverified | v5.0.0 feedback update

---

> **MANDATORY RULE: Variable Declaration Verification.** After writing any new code that introduces a variable not already declared, immediately verify the variable exists in the appropriate Declare block (either at the top of the subroutine for V.Local, or in the Preflight/Variables block for V.Global). This check is mandatory before signing. GAB requires ALL variables to be explicitly declared before use — undeclared variables cause runtime errors.

# VARIABLE SCOPES & SYSTEM VARIABLES

## V.Ambient (Read-Only System State)
| Variable | Purpose |
|----------|---------|
| `V.Ambient.NewLine` | CRLF / carriage-return + line-feed character |
| `V.Ambient.NewLines` | Number of new lines in the last InputBoxExt multiline result |
| `V.Ambient.Tab` | Tab character (ASCII decimal 9) |
| `V.Ambient.Date` | Current date |
| `V.Ambient.Now` | Current date/time in `M/D/YYYY HH:NN:SS AM/PM` format |
| `V.Ambient.FileVersion` | File version of the GAB script (`[Major].[Minor].[BuildNumber].[LicenseType]`) |
| `V.Ambient.IUser` | *GSS internal* -- used internally for setting DB user |
| `V.Ambient.Time` | Current time in `1/1/0001 HH:NN:SS AM/PM` format (date portion is always epoch) |
| `V.Ambient.DblQuote` | Double quote character -- use with `String.Build` placeholders to embed `"` in generated JSON/JS (see `PITFALLS.md` for the doubled-quote workaround) |
| `V.Ambient.Null` | Null value |
| `V.Ambient.DBNull` | Database null value |
| `V.Ambient.ErrorNumber` | Last error number |
| `V.Ambient.ErrorDescription` | Last error description |
| `V.Ambient.ErrorLine` | Line where error occurred |
| `V.Ambient.CurrentSubroutine` | Current sub name |
| `V.Ambient.SubroutineCalledFrom` | Name of the subroutine that called the current subroutine |
| `V.Ambient.PDSN` | Pervasive DSN |
| `V.Ambient.PUser` | Pervasive user |
| `V.Ambient.PPass` | Pervasive password |
| `V.Ambient.Ccon` | DSN for Global Common Database |
| `V.Ambient.Cuser` | Username for Global Common Database |
| `V.Ambient.Cpass` | Password for Global Common Database |
| `V.Ambient.CurDir` | Returns current directory |
| `V.Ambient.DBServerName` | Global Shop database server name |
| `V.Ambient.DatabaseType` | Returns the database type |
| `V.Ambient.DomainController` | Domain controller name |
| `V.Ambient.CompanyName` | Current company name |
| `V.Ambient.PID` | Process ID |
| `V.Ambient.PervasiveClientVersion` | Pervasive SQL version on the client (use `.IntPart` for version-specific feature checks) |
| `V.Ambient.PervasiveServerVersion` | Pervasive SQL version on the server (use `.IntPart` for version-specific feature checks) |
| `V.Ambient.PI` | Mathematical constant Pi |
| `V.Ambient.PrinterDialogSelection` | Name of printer selected via `F.Intrinsic.Printer.SelectPrinterDialog` (`***CANCEL***` if none selected) |
| `V.Ambient.ProxyEnabled` | True if a proxy is enabled |
| `V.Ambient.ProxyPort` | Proxy server port |
| `V.Ambient.ProxyServer` | Proxy server address |
| `V.Ambient.Is64Bit` | True if the local Windows instance is 64-bit |
| `V.Ambient.IsDocked` | True if the program is currently docked within a widget-hosting tile |
| `V.Ambient.IsGAB1` | True if running in GAB1 engine |
| `V.Ambient.IsGAB2` | True if running in GAB2 engine |
| `V.Ambient.IsGSSServer` | True if running on the Global Shop database server |
| `V.Ambient.IsInIDE` | True if the program is being run from the GAB code editor |
| `V.Ambient.IsInTaskScheduler` | True if the program is being run from the Task Scheduler |
| `V.Ambient.IsTerminalServicesClient` | True if running from Terminal Services / Remote Desktop |
| `V.Ambient.IsWidget` | True if running as a widget |
| `V.Ambient.IsWidgetCapable` | True if the environment supports widgets |
| `V.Ambient.GABVersion` | GAB version (format: `Mmmmmrrr` where M=Major, m=minor, r=revision) |
| `V.Ambient.GSSServer` | Global Shop database server |
| `V.Ambient.ICon` | Current connection index |
| `V.Ambient.InstanceHandle` | Instance handle of the current process |
| `V.Ambient.IPass` | Current connection password |
| `V.Ambient.IPMChild` | Communication handle of an async child GAB process (set when child registers with parent) |
| `V.Ambient.IPMParent` | Communication handle of the parent process (0 if no parent) |
| `V.Ambient.ScriptPath` | Script directory path (use this for sidecar file paths -- `V.Caller.FilePath` does NOT exist) |
| `V.Ambient.ScreenHeight` | Screen height in twips |
| `V.Ambient.ScreenWidth` | Screen width in twips |
| `V.Ambient.ShellExecPID` | PID of the task launched by the last `ShellExec` or `ShellExecSync` call (note: for sync calls the PID is out of scope by the time it can be checked) |
| `V.Ambient.ShellExecReturn` | Long integer return from the last `ShellExec` or `ShellExecSync` call |
| `V.Ambient.CallWrapperReturn` | Return value from last CallWrapper |
| `V.Ambient.BEH` | Status of the BlockEventHandler flag (True if events are currently blocked via `BlockEvents`) |
| `V.Ambient.BorderHeight` | Window border height in current units (pixels if UsePixels active) |
| `V.Ambient.BorderWidth` | Window border width in current units (pixels if UsePixels active) |
| `V.Ambient.BrowserButton` | Browser button state |
| `V.Ambient.Cancel` | Cancel flag |
| `V.Ambient.AltBoxClick` | Button clicked in last AltBox dialog (1=Ok, 2=Yes, 4=No, 8=Custom1, 16=Custom2) |
| `V.Ambient.AltBoxVal` | Value entered in the last InputBoxExt/AltBox dialog (read after checking `AltBoxClick`) |
| `V.Ambient.ExecuteAndReturnEOF` | True if last ExecuteAndReturn returned no rows |
| `V.Ambient.ItemList` | Delimited string of passed data element IDs |
| `V.Ambient.KeyboardHandle` | Window handle of the on-screen keyboard |
| `V.Ambient.LastAction` | Last action performed |
| `V.Ambient.MenuBarHeight` | Menu bar height in current units |
| `V.Ambient.MsgBoxAbort` | MsgBox result constant: Abort was clicked |
| `V.Ambient.MsgBoxCancel` | MsgBox result constant: Cancel was clicked |
| `V.Ambient.MsgBoxIgnore` | MsgBox result constant: Ignore was clicked |
| `V.Ambient.MsgBoxNo` | MsgBox result constant: No was clicked |
| `V.Ambient.MsgBoxOK` | MsgBox result constant: OK was clicked |
| `V.Ambient.MsgBoxRetry` | MsgBox result constant: Retry was clicked |
| `V.Ambient.MsgBoxSave` | MsgBox result constant: Save was clicked |
| `V.Ambient.MsgBoxYes` | MsgBox result constant: Yes was clicked |
| `V.Ambient.MyIPMh` | Inter-process messaging handle for the current process |
| `V.Ambient.QuadQuote` | Four consecutive quote characters |
| `V.Ambient.TerminalServicesClientName` | Name of the Terminal Services / Remote Desktop client machine |
| `V.Ambient.ThreadID` | Thread ID of the currently executing instance |
| `V.Ambient.ExecutionTime` | Elapsed execution time of the current script |
| `V.Ambient.Timer` | Current timer value |
| `V.Ambient.TimerElapsed-<timername>` | Elapsed time in seconds of the specified timer (timers created via `F.Intrinsic.Date.TimerStart`) |
| `V.Ambient.TitlebarHeight` | Title bar height in current units |
| `V.Ambient.TwipsPerPixelX` | Twips-per-pixel ratio on the X axis |
| `V.Ambient.TwipsPerPixelY` | Twips-per-pixel ratio on the Y axis |
| `V.Ambient.WindowsBuildNumber` | Windows OS build number |
| `V.Ambient.WindowsPlatformID` | Windows platform ID |
| `V.Ambient.WindowsServicePack` | Windows service pack name (also included in `V.Ambient.WindowsVersion` long form) |
| `V.Ambient.WindowsUpTime` | Windows system uptime |
| `V.Ambient.WindowsVersionName` | Windows version name (also included in `V.Ambient.WindowsVersion` long form) |
| `V.Ambient.WindowsVersionNumber` | Windows version number (also included in `V.Ambient.WindowsVersion` long form) |
| `V.Ambient.NoReturn` | Value sentinel `***NORETURN***` — use transforms `IsNoReturn` / `IsNotNoReturn` to test return values |
| `V.Ambient.ScriptFile` | Alias for `V.Caller.ScriptFile` — seen in production code; prefer `V.Caller.ScriptFile` |
| `V.Ambient.Date.PervasiveDate` | Current date in Pervasive format |
| `V.Ambient.Now.FormatYYYYMMDDHHNNSS` | Formatted timestamp |

## V.Caller (Execution Context)
| Variable | Purpose |
|----------|---------|
| `V.Caller.CompanyCode` | 3-character company code |
| `V.Caller.Terminal` | Global Shop session number |
| `V.Caller.User` | Global Shop user name — GSS ERP user, NOT Windows OS login. For Windows login use `V.System.UserName`. Do NOT use or invent `V.Caller.WindowsUser` (does not exist). |
| `V.Caller.Handle` | Screen handle of the calling program (when invoked from a Global Shop hook) |
| `V.Caller.ScriptFile` | Fully-qualified GAS program filename |
| `V.Caller.FilesDir` | GSS Files directory |
| `V.Caller.LocalGSSTempDir` | Fully-qualified path to the Global Shop portion of the local user's temporary folder (`%TEMP%\GSS`) |
| `V.Caller.TempDir` | Temp directory |
| `V.Caller.BusintDir` | Business Intelligence directory |
| `V.Caller.PluginsDir` | Plugins directory |
| `V.Caller.GlobalDir` | Fully-qualified path to the Global Shop base directory |
| `V.Caller.InstallDir` | GSS installation directory |
| `V.Caller.GSSVersion` | Global Shop version |
| `V.Caller.Version` | Caller program version (context: `F.Intrinsic.Debug.OverrideGSSVersion` can override this for testing) |
| `V.Caller.UserExportPath` | Fully-qualified path to the user's default export directory (from Menu Options; falls back to `LocalGSSTempDir` if not set) |
| `V.Caller.Hook` | Hook number associated with the screen |
| `V.Caller.Caller` | Program that invoked OCTSRS |
| `V.Caller.ConfigDir` | Configuration directory |
| `V.Caller.CSFailDir` | Communication Server fail directory |
| `V.Caller.CSLogDir` | Communication Server log directory |
| `V.Caller.CSPassDir` | Communication Server pass directory |
| `V.Caller.CSWatchDir` | Communication Server watch directory |
| `V.Caller.DDFDir` | DDF (Data Dictionary Files) directory |
| `V.Caller.Debug` | True if OCTSRS is running in debug mode |
| `V.Caller.DocDir` | Documents directory |
| `V.Caller.GasDir` | Fully-qualified path to the Plugins\GAB\GAS directory |
| `V.Caller.HelpDir` | Help files directory |
| `V.Caller.LangCodeAux` | Secondary language code |
| `V.Caller.LangCodePri` | Primary language code |
| `V.Caller.Pervasive` | Pervasive database information |
| `V.Caller.PID` | Process ID of the calling program |
| `V.Caller.ProgramsDir` | Programs directory |
| `V.Caller.ScriptsDir` | Scripts directory |
| `V.Caller.ScriptVer` | Script version |
| `V.Caller.SP2Dir` | SP2 directory |
| `V.Caller.Switches` | Command-line switches when Caller was invoked (core: N=New, O=Open, V=View, D=Delete; secondary programs: any value) |
| `V.Caller.Sync` | True if OCTSRS is running synchronously |
| `V.Caller.TimeInfoClient` | Client time information |
| `V.Caller.TimeInfoOrigin` | Origin time information |
| `V.Caller.WirelessASPDir` | Wireless ASP directory |
| `V.Caller.WrunDir` | Wrun directory |

## V.Args (Event Arguments)
| Variable | Purpose |
|----------|---------|
| `V.Args.Column` | Clicked column name |
| `V.Args.ColumnName` | Column name (grid events) |
| `V.Args.RowIndex` | Clicked row index |
| `V.Args.Button` | Mouse button ("Left"/"Right") |
| `V.Args.Value` | Control value |
| `V.Args.SelectedValue` | Selected value |
| `V.Args.File` | File argument |
| `V.Args.FilePath` | File path argument |
| `V.Args.Go_TO` | GoTo argument |
| `V.Args.Action` | Action identifier |
| `V.Args.AllowEdit` | Whether editing is allowed |
| `V.Args.ControlName` | Name of the control |
| `V.Args.Data` | Generic data argument |
| `V.Args.DataTableName` | DataTable name in context |
| `V.Args.AvailableDatatableName` | Available DataTable name |
| `V.Args.Error` | Error information |
| `V.Args.Filter` | Filter expression |
| `V.Args.ActiveFilterExpression` | Active filter expression |
| `V.Args.FormName` | Form name in context |
| `V.Args.GridName` | Grid control name |
| `V.Args.GridViewName` | Grid view name |
| `V.Args.ID` | Generic ID argument |
| `V.Args.Message` | Message text |
| `V.Args.Name` | Name argument |
| `V.Args.Path` | Path argument |
| `V.Args.ScriptPath` | Script path argument |
| `V.Args.X` | Mouse X coordinate |
| `V.Args.Y` | Mouse Y coordinate |
| `V.Args.Clicks` | Mouse click count |
| `V.Args.Shift` | Shift key state |
| `V.Args.Location` | Mouse location string |
| `V.Args.Delta` | Mouse wheel delta |
| `V.Args.MouseRow` | Row index under mouse cursor (grid) |
| `V.Args.MouseCol` | Column index under mouse cursor (grid) |
| `V.Args.View` | View name (CardView/grid focus events) |
| `V.Args.GsCardViewControlName` | CardView control name in events |
| `V.Args.IsOn` | GsToggleSwitch: current state (Boolean) |
| `V.Args.OnText` | GsToggleSwitch: on label text |
| `V.Args.OffText` | GsToggleSwitch: off label text |
| `V.Args.ToggleName` | BarToggleButton: toggle name |
| `V.Args.Toggled` | BarToggleButton: toggled state |
| `V.Args.EventSource` | Event origin (e.g. "FORM") |
| `V.Args.Screen` | Form/screen name that owns the control |
| `V.Args.ControlType` | Control type name (e.g. "GSGRIDCONTROL") |
| `V.Args.EventType` | Event type name (e.g. "FOCUSEDROWCHANGED") |
| `V.Args.RowHandle` | Row handle for RowCellClick/CellValueChanged events. **NOT available for FocusedRowChanged** (use `V.Args.FocusedRowHandle` instead — see above). |
| `V.Args.FocusedRowHandle` | Focused row handle for FocusedRowChanged event (**CRITICAL: this is a VISUAL index, not a DataTable row handle**. In filtered grids it does NOT correspond to the underlying DataTable row. Use `GetSelectedRows` to obtain the true DataTable row handle. Guard: `If(V.Args.FocusedRowHandle,<,0)` for filter-row clicks returning sentinel `-2147483646`. See `GRID.md` § 'Reading cell values in filtered grids' and `PITFALLS.md` § FocusedRowHandle.) |
| `V.Args.PrevFocusedRowHandle` | Previous focused row handle (visual index — see FocusedRowHandle caveat) |
| `V.Args.Handled` | Whether the event is handled (Boolean) |
| `V.Args.CellValue` | Cell value (RowCellClick, KeyPress, KeyPressEnter) |
| `V.Args.ActiveFilterCriteria` | Active filter criteria (ColumnFilterChanged) |
| `V.Args.ActiveFilterRowCount` | Row count matching filter (ColumnFilterChanged) |
| `V.Args.GridControlName` | Grid control name (grid events) |
| `V.Args.ActiveSortString` | Active sort expression (ColumnSortingChanged) |
| `V.Args.TableName` | Bound DataTable name (grid events) |
| `V.Args.Row` | Row index under mouse (MouseCellEnter/Exit) |
| `V.Args.SourceRowIndex` | Underlying DataTable row index (MouseCellEnter/Exit events) |
| `V.Args.ColumnIndex` | Column index (ColumnPositionChanged, KeyPress) |
| `V.Args.ColumnVisibleIndex` | Column visible index, default -1 (ColumnPositionChanged) |
| `V.Args.KeyChar` | Key character pressed (KeyPress) |
| `V.Args.Subroutine` | Subroutine name (error handler context) |

## V.Passed (Parameters from calling program)

`V.Passed` provides fields passed from the calling program to a hook script:
```
V.Passed.DATA-TRANSID          ' Mobile transaction ID
V.Passed.MainFormView-...      ' Passed form view data
```

> **CRITICAL:** The available `V.Passed` fields are **entirely hook-specific**. Each hook point passes its own set of named elements — there is no universal list. The user must provide the hook number and its passed elements for the script being developed. Always guard access with `F.Intrinsic.Variable.PassedExists` before reading any `V.Passed` field.

For complete hook-related `V.Passed` properties (`.Hidden()`, `.HWnd()`, `.Set()`, etc.), see `agents/gab/HOOKS.md`.

## Subroutine Return Values — `AddRV` and `V.Args`

A called subroutine can return values to its caller using `F.Intrinsic.Variable.AddRV`. After `CallSub` returns, the calling subroutine reads the return values via `V.Args.<ReturnVariableName>`.

```
F.Intrinsic.Variable.AddRV(ReturnVariableName, Value)
```

| Argument | Type | Description |
|----------|------|-------------|
| ReturnVariableName | String | Name of the return variable (the caller reads it as `V.Args.<ReturnVariableName>`) |
| Value | Any | The value to return |

**Example:**
```
Program.Sub.Sub1.Start
F.Intrinsic.Control.CallSub(Sub2)
F.Intrinsic.UI.Msgbox(V.Args.Math)
' Results: 4
Program.Sub.Sub1.End

Program.Sub.Sub2.Start
V.Local.iRet.Declare(Long)
F.Intrinsic.Math.Add(2,2,V.Local.iRet)
F.Intrinsic.Variable.AddRV("Math",V.Local.iRet)
Program.Sub.Sub2.End
```

> **Note:** `AddRV` sets the return value from *inside* the called subroutine. After `CallSub` returns, the calling subroutine reads the returned value via `V.Args.<Name>`. Multiple return values can be set by calling `AddRV` multiple times with different names.

## V.Static (Subroutine-Persistent Variables)
Static variables retain their value across multiple calls to the same subroutine. They are declared like V.Local but persist for the lifetime of the program.
```
V.Static.<name>.Declare(<Type>)
V.Static.<name>.Declare(<Type>,<DefaultValue>)
```

Example:
```
Program.Sub.IncrementCounter.Start
V.Static.iCallCount.Declare(Long,0)
F.Intrinsic.Math.Add(V.Static.iCallCount,1,V.Static.iCallCount)
' iCallCount is 1 on first call, 2 on second call, etc.
Program.Sub.IncrementCounter.End
```

For full declaration syntax, BulkDeclare, and inline properties, see **`agents/gab/CORE.md` > "Declaration"**.

## V.uLocal / V.uGlobal (UDT Variable Scopes)

> **LEGACY ONLY -- Do NOT use in new GAB projects.** Use DataTable instead.

Dedicated scopes for User-Defined Type variables. Members accessed via `!` syntax.
- `V.uLocal` -- subroutine-scoped (destroyed when sub exits)
- `V.uGlobal` -- program-scoped (persists across all subroutines)

```
V.uLocal.<name>.Declare()                          ' Declare local UDT variable
V.uGlobal.<name>.Declare()                         ' Declare global UDT variable
V.uLocal.<name>.Redim(iLower, iUpper)              ' Resize array
V.uLocal.<name>.RedimPreserve(iLower, iUpper)      ' Resize preserving data (args optional on uLocal)
V.uGlobal.<name>.RedimPreserve(iLower, iUpper)     ' Resize preserving data (args required on uGlobal)
V.uLocal.<name>!<member>.Set(value)                ' Set member value
V.uLocal.<name>!<member>.Append(expression)        ' Append to member
V.uLocal.<name>.LBound()                           ' Array lower bound
V.uLocal.<name>.UBound()                           ' Array upper bound
```

UDT members support all standard inline properties (`.Trim()`, `.String()`, `.Long()`, `.Float()`, `.UCase()`, `.PSQLFriendly`, etc.). For the full reference, see `agents/gab/DATA.md` > UDT Variable Scopes.

## V.Screen (Live form control access)
```
V.Screen.<FormName>!<ControlName>.Text
V.Screen.<FormName>!<ControlName>.Value
V.Screen.<FormName>!<ControlName>.Visible
V.Screen.<FormName>!<ControlName>.ItemData      ' Bound value of selected DropDownList item
```

## V.External (Cross-Program Variable Access)
Variables in another running GAB program, accessible via hook handle. Supports read, write, and standard inline transforms.

```
V.External.sVarName                                ' Read external variable
V.External.sVarName.Set("value")                   ' Set external variable (current hook)
V.External.sVarName.Set("value",iHookNumber)       ' Set external variable (specific hook#, optional)
V.External.sVarName.Append("text")                 ' Append to external variable
```

Supported inline transforms: `.Float()`, `.IsDate()`, `.IsNumeric()`, `.LBound()`, `.LCase()`, `.Length()`, `.Long()`, `.LTrim()`, `.Not()`, `.PCase()`, `.PercentToDecimal()`, `.RTrim()`, `.String()`, `.StrLit()`, `.Trim()`, `.UBound()`, `.UCase()`

## V.System (Read-Only System Variables)
Read-only access to Windows environment variables exposed by the GAB runtime. V.System variables are **read-only** -- no Declare, Set, Append, or array operations. They support only the standard inline read-only properties for type conversion, string manipulation, validation, formatting, and database escaping.

| Variable | Returns | Description |
|----------|---------|-------------|
| `V.System.AllUsersProfile` | String | Path to the All Users profile directory |
| `V.System.ComputerName` | String | Name of the user's computer |
| `V.System.HomeDrive` | String | Drive letter of the user's home directory (e.g. `C:`) |
| `V.System.HomePath` | String | Path portion of the user's home directory (e.g. `\Users\jsmith`) |
| `V.System.LogonServer` | String | Name of the logon server (e.g. `\\DOMAINCTRL`) |
| `V.System.OS` | String | Operating system identifier |
| `V.System.Path` | String | System PATH environment variable |
| `V.System.ProgramFiles` | String | Path to the Program Files directory |
| `V.System.SessionName` | String | Terminal Services session name |
| `V.System.Temp` | String | Path to the user's temp directory |
| `V.System.UserDomain` | String | Domain name of the logged-in user |
| `V.System.UserName` | String | Login name of the current user |
| `V.System.UserProfile` | String | Full path to the user's profile directory |
| `V.System.WinDir` | String | Path to the Windows directory |

```
V.Local.sComputer.Declare(String)
V.Local.sComputer.Set(V.System.ComputerName)

V.Local.sUser.Declare(String)
V.Local.sUser.Set(V.System.UserName)

V.Local.sTempPath.Declare(String)
V.Local.sTempPath.Set(V.System.Temp)
```

Supported inline properties: `.Float()`, `.IsDate()`, `.IsNumeric()`, `.LCase()`, `.Length()`, `.Long()`, `.LTrim()`, `.PCase()`, `.PervasiveDate()`, `.PSQLFriendly`, `.RTrim()`, `.SQLServerFriendly`, `.String()`, `.StrLit()`, `.Trim()`, `.UCase()`

**Note:** V.System does **not** support `.Not()`, `.LBound()`, `.UBound()`, `.PercentToDecimal()`, `.Append`, `.Format*()`, `.Left#`, `.Right#`, or array operations -- it exposes a subset of the standard inline properties focused on type conversion, string cleanup, validation, and database escaping.

## V.Translation (Internationalization Lookup)
Read-only access to localized strings by their InternationalID. The InternationalID is a numeric identifier that maps to a translated string in the GSS internationalization system. Controls that have an `.InternationalID()` V.Screen property use the same ID system.

```
V.Translation.<InternationalID>
```

```
' Display a localized message by ID
F.Intrinsic.UI.Msgbox(V.Translation.111)

' Use in string building
V.Local.sMsg.Declare(String)
V.Local.sMsg.Set(V.Translation.111)
```

## V.ASCII
```
V.ASCII.01          ' ASCII character 1
V.ASCII.13          ' Carriage return
V.ASCII.10          ' Line feed
V.ASCII.0176        ' Degree symbol
V.ASCII.148         ' Closing double quote
```

V.ASCII variables support all standard inline property transforms:
`.Float()`, `.IsDate()`, `.IsNumeric()`, `.LCase()`, `.Length()`, `.Long()`, `.LTrim()`, `.PCase()`, `.PervasiveDate()`, `.RTrim()`, `.String()`, `.StrLit()`, `.Trim()`, `.UCase()`

Example:
```
V.ASCII.13.Long()       ' Returns 13 as a Long
V.ASCII.65.String()     ' Returns "A" as a String
```

## V.Color
```
V.Color.Black
V.Color.Blue
V.Color.Cyan
V.Color.Gray
V.Color.Green
V.Color.Grey                  ' Alias for Gray
V.Color.GSS                   ' GSS brand color
V.Color.LtBlue
V.Color.LtGray
V.Color.LtGreen
V.Color.LtGrey                ' Alias for LtGray
V.Color.LtMagenta
V.Color.LtRed
V.Color.LtCyan
V.Color.Magenta
V.Color.Orange
V.Color.Pink
V.Color.Red
V.Color.White
V.Color.Yellow
V.Color.PRI                   ' Primary theme color
V.Color.SEC                   ' Secondary theme color
```

---

# V.Enum REFERENCE

The GAB Code Editor and OCTSRS support enums for commonly used "magic numbers". Type `V.Enum.` in the editor and intellisense will list available enumerations. After selecting one, add `!` to see the available values.

For the complete per-enum type reference (all enum types and values), see **`agents/gab/ENUMS.md`**.

Commonly used enums at a glance: `V.Enum.ThemeColors!*`, `V.Enum.GridViewPropertyNames!*`, `V.Enum.ColumnPropertyNames!*`, `V.Enum.MsgBoxStyle!*`, `V.Enum.Image!*`.


## Additional Variable Properties

| Property | Purpose |
|----------|---------|
| `.AppendNewLine` | Append string followed by a newline |
| `.LBound` | Array lower bound (always 0 in GAB) |
| `.UBound` | Array upper bound (last valid index) |
| `.UBound++` | Array upper bound + 1 (shorthand for count/next-index) |

Example:
```
V.Local.sLog.AppendNewLine("Step 1 complete")
V.Local.sLog.AppendNewLine("Step 2 complete")

V.Local.iLast.Set(V.Local.sArray.UBound)        ' Last valid index
V.Local.iCount.Set(V.Local.sArray.UBound++)      ' Element count (UBound + 1)
V.Local.iFirst.Set(V.Local.sArray.LBound)        ' Always 0
```

# ADDITIONAL VARIABLES (extracted from official documentation)

## V.Local / V.Global / V.Static Inline Properties

For the complete inline property reference (declaration methods, type conversion, string manipulation, validation, formatting, database escaping, unit conversion, boolean/array/increment), see **`agents/gab/CORE.md` > "Inline Variable Properties"**.

All inline properties apply identically to `V.Local`, `V.Global`, and `V.Static` scoped variables.

## Ambient.Now Usage
Sets a local or global variable to the current datetime in the format `M/D/YYYY HH:NN:SS AM/PM`.
```
V.Local.sDate.Declare
V.Local.sDate.Set(V.Ambient.Now)
```

## Ambient.Time Usage
Sets a local or global variable to the current time stamp in the format `1/1/0001 HH:NN:SS AM/PM`.
```
V.Local.sTime.Declare
V.Local.sTime.Set(V.Ambient.Time)
```

## V.ODBC Recordset Properties

Access via `V.ODBC.<con>!<rst>.<Property>`. For the complete reference with examples, see `agents/gab/DATA.md` → "Recordset Variable Accessors".

| Property | Returns | Description |
|----------|---------|-------------|
| `.BOF` | Boolean | Before first record |
| `.EOF` | Boolean | After last record |
| `.FieldCount` | Long | Number of columns |
| `.FieldType!{Field}` | Long | ADO data type code |
| `.FieldVal!{Field}` | String | Field value |
| `.FieldValFloat!{Field}` | Float | Field as double |
| `.FieldValIsNull!{Field}` | Boolean | True if NULL |
| `.FieldValIsNumeric!{Field}` | Boolean | True if numeric |
| `.FieldValLeft{nn}!{Field}` | String | Leftmost nn characters |
| `.FieldValLong!{Field}` | Long | Field as long integer |
| `.FieldValLTrim!{Field}` | String | Left-trimmed value |
| `.FieldValNot!{Field}` | Long | Bitwise NOT of value |
| `.FieldValOrdinal!{Index}` | String | Field by zero-based index |
| `.FieldValPervasiveDate!{Field}` | String | Date as yyyy-MM-dd |
| `.FieldValRight{nn}!{Field}` | String | Rightmost nn characters |
| `.FieldValRTrim!{Field}` | String | Right-trimmed value |
| `.FieldValString!{Field}` | String | Explicit string conversion |
| `.FieldValTrim!{Field}` | String | Both-sides-trimmed value |
| `.Set!{Field}(value)` | (write) | Set field value before `.Update` |
| `.State` | Long | 1 = open/ready |

## V.Screen.*form.*cntrl Grouped Methods

All properties available on form controls at runtime.

- **Read**: `V.Screen.<Form>!<Control>.<Property>` (no parentheses)
- **Write**: `Gui.<Form>.<Control>.<Property>("value")` (parentheses on write)

Form-level properties are accessed via `V.Screen.<Form>.<Property>` (or `V.Screen.<Form>..<Property>` with double-dot notation); these are marked with **Form** in the table below.

**Complete property list** (not all apply to every control type):

| Property | Applicable To | Description |
|----------|---------------|-------------|
| `.Alignment` | TextBox, TextBoxM, TextBoxR, Label, Hyperlink, Option, CheckBox | Text/content alignment |
| `.Anchor` | Many | Anchor edges for auto-resize with parent |
| `.AnimationLengthInMS` | NavFrame | Page transition animation duration in milliseconds |
| `.AutoEllipsis` | Button, CheckBox, ComboBox, DatePicker, Hyperlink, KeyLabel, Label, ListBox, Option | Whether text truncation shows an ellipsis |
| `.AutoSize` | CheckBox, Frame, Hyperlink, KeyLabel, Label, Option | Whether control auto-sizes to fit content |
| `.BackColor` | All | Background color |
| `.BorderStyle` | Many | Border style value |
| `.Busy` | HtmlContainer, GSFlexGrid | True if loading/processing |
| `.Caption` | All | Caption/title text |
| `.Checked` | CheckBox, Option | Check state (0/1/2) |
| `.CheckedAsBoolean` | CheckBox, Option | Check state as True/False |
| `.Col` | GSFlexGrid, HFlexGrid | Current column index |
| `.ColAlignment` | HFlexGrid | Current column alignment |
| `.Collapsed` | SplitContainer | Whether the collapsible panel is collapsed |
| `.CollapsiblePanel` | SplitContainer | Which panel is collapsible (0 = Panel1, 1 = Panel2) |
| `.Cols` | GSFlexGrid, HFlexGrid | Total columns |
| `.ColWidth` | HFlexGrid | Current column width |
| `.ControlType` | All | Returns the control type name (e.g. "TextBoxR", "Button") |
| `.CurrentColumn` | TextBox, TextBoxM | Current cursor column position |
| `.CurrentLine` | TextBox, TextBoxM | Current cursor line number |
| `.CurrentX` | All | Current X coordinate |
| `.CurrentY` | All | Current Y coordinate |
| `.Detail` | ProgressPanel | Detail/secondary text line |
| `.Dock` | Many | Dock style (None, Top, Bottom, Left, Right, Fill) |
| `.DockedHeight` | DockPanel | Height when docked |
| `.DockedWidth` | DockPanel | Width when docked |
| `.DockPosition` | DockPanel | **Obsolete.** Dock position value |
| `.DroppedDown` | ComboBox, DDL | True if dropdown is currently open |
| `.Enabled` | All | True if enabled |
| `.ExcludeFromUndo` | Many | Whether control is excluded from undo tracking |
| `.FixedCols` | HFlexGrid | Fixed (non-scrollable) columns |
| `.FixedPanel` | SplitContainer | Which panel stays fixed on resize (0 = Panel1, 1 = Panel2) |
| `.FixedRows` | HFlexGrid | Fixed header rows |
| `.Focused` | Many | True if control currently has focus |
| `.FontName` | Many | Font family name |
| `.FontSize` | Many | Font size |
| `.FontSizeDelta` | ProgressPanel | Offset applied to default font size |
| `.FontSizeDetail` | ProgressPanel | Font size of detail text |
| `.FontStyle` | ProgressPanel | Font style of caption text |
| `.FontStyleDetail` | ProgressPanel | Font style of detail text |
| `.ForeColor` | All | Foreground color |
| `.Height` | All | Control height |
| `.HWnd` | All | Window handle |
| `.ImageAlign` | Button, Hyperlink, Label | Image alignment relative to text |
| `.InternationalID` | Many | Translation label ID for internationalization |
| `.IsLoading` | GsWebBrowser | True if browser is currently loading |
| `.IsReady` | GsWebBrowser | True if browser is ready for interaction |
| `.IsSelectedPage` | NavPage | True if this page is the currently selected page |
| `.ItemData` | ListBox, ComboBox, DDL, Directory | Bound value of selected item |
| `.Key` | Many | Control key identifier |
| `.KeyColor` | KeyLabel | Color of the keyboard-shortcut highlight character |
| `.Left` | All | Left position |
| `.LineCount` | TextBox, TextBoxM | Total number of text lines |
| `.List` / `.List(Index)` | ListBox, ComboBox, DDL, Directory | Text of selected item; DDL also accepts `Index` as Long to get item by position |
| `.ListCount` | ListBox, ComboBox, DDL, Directory | Total list items |
| `.ListIndex` | ListBox, ComboBox, DDL, Directory | Selected item index |
| `.ListItemCount` | ListView, ComboBox, DDL | Total list items |
| `.ListItemKey` | ListView | Selected item key |
| `.ListItemText` | ListView | Selected item text |
| `.ListItemTextExtended(Value)` | ListView | Extended text (Value as Long) |
| `.ListViewContents` | ListView | Serialized ListView contents |
| `.LocationName` | HtmlContainer | Current document title |
| `.LocationUrl` | GsWebBrowser | Current page URL |
| `.LocationURL` | HtmlContainer | Current page URL |
| `.Locked` | Many | Read-only state |
| `.Max` | TextBox, ProgressBar, Slider | Maximum allowed value |
| `.MaxDropDownItems` | ComboBox, DDL | Max visible items in dropdown before scrolling |
| `.MaxLength` | TextBox, TextBoxM | Maximum number of characters allowed |
| `.MetaData0` - `.MetaData9` | All | Custom metadata slots 0-9; AccordionControl and FunctionLinks accept optional sub-element/LinkID String param |
| `.Min` | TextBox, ProgressBar, Slider | Minimum allowed value |
| `.NodeCount` | TreeView | Total nodes |
| `.NodeKey` | TreeView | Selected node key |
| `.NodeSelected` | TreeView | Selected node identifier |
| `.NodeText` | TreeView | Selected node text |
| `.Offset` | ProgressPanel | Distance between panel edge and loading indicator |
| `.Orientation` | SplitContainer | Split orientation (0 = Horizontal, 1 = Vertical) |
| `.Path` | Directory, HtmlContainer | Current directory or file path |
| `.PervasiveDate` | DatePicker | Selected date formatted for Pervasive SQL (yyyy-MM-dd) |
| `.Result` | **Form** | Form result value returned to caller |
| `.ResultString` | **Form** | Form result as string |
| `.Row` | GSFlexGrid, HFlexGrid | Current row index |
| `.Rows` | GSFlexGrid, HFlexGrid | Total rows |
| `.RowSel` | GSFlexGrid, HFlexGrid | End row of selection |
| `.RtfText` | TextBoxR | Rich text (RTF) content |
| `.Scrolling` | ProgressBar | Scrolling/animation style (True = marquee, False = value bar) |
| `.SelectedIndex` | NavFrame | Index of the currently selected page |
| `.SelectedItemKey` | ListView, TreeView | Selected item key |
| `.SelectedItemSubItem` | ListView | Selected sub-item text |
| `.SelectedItemText` | ListView, TreeView | Selected item display text |
| `.SelectedText` | TextBox, TextBoxM, TextBoxR | Currently selected text content (alias for `.SelText`) |
| `.SelectionMode` | ListBox | Selection mode |
| `.SelLength` | TextBox, TextBoxM, TextBoxR, ComboBox | Selected text length |
| `.SelStart` | TextBox, TextBoxM, TextBoxR, ComboBox, MonthView | Selection start position |
| `.SelText` | TextBox, TextBoxM, TextBoxR, ComboBox | Selected text content |
| `.SourceUrl` | GsWebView2 | Current page URL |
| `.SplitterPosition` | SplitContainer | Current splitter bar position in pixels |
| `.Tab` | Tab, NavFrame | Currently selected tab/page index |
| `.TabIndex` | Many | Tab order position |
| `.TabStop` | Many | Tab navigation participation |
| `.Text` | All | Text content |
| `.ToolTip` | Many | Tooltip text |
| `.Top` | All | Top position |
| `.UndockedHeight` | DockPanel | Height when floating (undocked) |
| `.UndockedWidth` | DockPanel | Width when floating (undocked) |
| `.UseLayout` | DockPanel, Frame, NavPage, SplitContainer, Tab, TextBox | Whether layout persistence is enabled |
| `.Value` | CheckBox, ComboBox, DatePicker, DDL, HScrollBar, ListBox, MonthView, Option, ProgressBar, Slider, VScrollBar | Current value / scroll position |
| `.View` | ListView | Current view mode |
| `.Visibility` | DockPanel | Panel visibility state (Visible, AutoHide, Hidden) |
| `.Visible` | All | True if visible |
| `.Width` | All | Control width |
| `.WindowHandle` | All | Window handle |
| `.WindowState` | **Form** | Form window state (0 = Normal, 1 = Minimized, 2 = Maximized) |
| `.ZoomFactor` | GsWebBrowser, GsWebView2 | Current browser zoom level |

For per-control details and examples, see `agents/gab/GUI_EVENTS.md` → "Screen Variable Properties" (or `agents/gab/GUI.md` index).

## Common Error Codes

| Code | Description |
|------|-------------|
| 5102 | Type mismatch (wrong data type in operation) |
| 5116 | Subscript out of range (array index beyond UBound) |
| 5117 | Variable not declared |
| 5120 | Object not found (DataTable, Dictionary, etc. does not exist) |
| 21056 | Syntax error in DataView filter (usually unescaped single quotes) |

---

# VARIABLE ANTI-PATTERNS

- **Re-declaring a variable silently resets it** -- `V.Local.sName.Declare(String,"")` called twice in the same sub resets `sName` to empty string on the second declaration
- **Long and Integer are interchangeable** -- GAB maps both to the same underlying 32-bit type; use `Long` consistently
- **V.Static persists across calls** -- do not assume static variables start at their default value on every call
- **.UBound on an empty array returns -1** -- always check before iterating
- **String array elements are empty strings, not null** -- `V.Local.sArr(0)` on a freshly Redim'd array is `""`, not null
- **Inline property transforms cannot chain on DataTable/DataView column reads** -- `.UCASE`, `.LCASE`, `.Trim`, etc. cannot be applied inline when reading a value from a DataTable or DataView row via `!FieldValTrim`. Extract to a local variable first, then apply the transform separately:
  ```
  ' WRONG -- will error:
  F.Intrinsic.Control.If(V.DataTable.dtOrders(V.Local.i).REC_TYPE!FieldValTrim.UCASE, =, "FRGHT")

  ' CORRECT -- extract then transform:
  V.Local.sTemp.Set(V.DataTable.dtOrders(V.Local.i).REC_TYPE!FieldValTrim)
  V.Local.sTemp.Set(V.Local.sTemp.UCASE)
  F.Intrinsic.Control.If(V.Local.sTemp, =, "FRGHT")
  ```
- **F.Intrinsic.Math.Round requires a float argument** -- passing a string-typed variable as the first argument causes a runtime resolve error. Always apply the `.Float` modifier when the source variable may be a string:
  ```
  ' WRONG -- will error if sAmount is a string variable:
  F.Intrinsic.Math.Round(V.Local.sAmount, 2, V.Local.dResult)

  ' CORRECT -- use .Float to ensure numeric type:
  F.Intrinsic.Math.Round(V.Local.sAmount.Float, 2, V.Local.dResult)
  ```
