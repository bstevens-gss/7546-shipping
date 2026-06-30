# GAB Hooks, Includes, Network, Printer, Debug & Task Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with hook-based scripts, library includes, network auth, printer APIs, debugging, and task/process APIs
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# HOOK-BASED SCRIPTS

For complete hook system documentation including V.Caller, V.Passed, hook associations, PreCallerExit/PostCallerExit, and signature validation, see `agents/gab/HOOKS.md`.

Basic hook dispatch pattern:
```
Program.Sub.Main.Start
F.Intrinsic.Control.SelectCase(V.Caller.Hook)
    F.Intrinsic.Control.Case("49710")
        F.Intrinsic.Control.CallSub(RegisterButtons)
    F.Intrinsic.Control.Case("38120")
        F.Intrinsic.Control.CallSub(PreOnlineUpdate)
F.Intrinsic.Control.EndSelect
Program.Sub.Main.End
```

---

# LIBRARY INCLUDES

```
Program.Sub.Preflight.Start
Program.External.Include.Library(sFileName, bIsEmbedded)    ' .lib files
Program.External.Include.File(sFileName, bIsEmbedded)       ' All other file types (.dll, etc.)
Program.Sub.Preflight.End
```

`Library` and `File` are identical except that `Library` refers to `.lib` files, and `File` refers to all other types. In general, this is managed by the Included Files tab in the GAB IDE.

| Parameter | Description |
|-----------|-------------|
| sFileName | The name of the file to include |
| bIsEmbedded | When True, OCTSRS looks for the file as part of the G2P Package. When False, it searches the execution directory. |

Libraries share the same syntax as g2u files but without the ScreenSU block. Subroutines from libraries are callable via `F.Intrinsic.Control.CallSub`.

---

# NETWORK

```
F.Communication.Network.AuthenticateUser(sUser,sPass,sDomain,bResult)
F.Communication.Network.GetIPFromHostName(sHostName,sResult)
```

---

# PRINTER

```
F.Intrinsic.Printer.GetPrinters(sResult)                              ' List all printers
F.Intrinsic.Printer.SelectPrinterDialog(sResult)                      ' Show printer picker dialog
F.Intrinsic.Printer.SelectPrinterByNameExact(sPrinterName,bResult)    ' Select by exact name
F.Intrinsic.Printer.SetDefaultPrinter(sPrinterName)                   ' Set as default
F.Intrinsic.Printer.RestorePrinter                                     ' Restore previous default
```

## Printer Ambient Properties (V.Printer.*)

Built-in read-only properties that expose the current printer's state and configuration.

```
V.Printer.ColorMode             ' Color mode setting
V.Printer.Copies                ' Number of copies configured
V.Printer.CurrentX              ' Current X print position
V.Printer.CurrentY              ' Current Y print position
V.Printer.DefaultPrinter        ' Name of the workstation's default printer
V.Printer.DeviceName            ' Printer device name
V.Printer.DriverName            ' Printer driver name
V.Printer.Duplex                ' Duplex (double-sided) setting
V.Printer.HDC                   ' Device context handle (HDC) for the printer
V.Printer.Height                ' Printable page height
V.Printer.Orientation           ' Page orientation (portrait/landscape)
V.Printer.Page                  ' Current page number
V.Printer.PaperBin              ' Paper bin/tray selection
V.Printer.PaperSize             ' Paper size setting
V.Printer.Port                  ' Printer port name
V.Printer.Width                 ' Printable page width
```

| Property | Description |
|----------|-------------|
| `V.Printer.ColorMode` | Color mode setting of the current printer |
| `V.Printer.Copies` | Number of copies configured for printing |
| `V.Printer.CurrentX` | Current horizontal (X) print position |
| `V.Printer.CurrentY` | Current vertical (Y) print position |
| `V.Printer.DefaultPrinter` | Name of the workstation's default printer |
| `V.Printer.DeviceName` | Device name of the current printer |
| `V.Printer.DriverName` | Driver name of the current printer |
| `V.Printer.Duplex` | Duplex (double-sided) printing setting |
| `V.Printer.HDC` | Device context handle (HDC) for the printer |
| `V.Printer.Height` | Printable page height |
| `V.Printer.Orientation` | Page orientation (portrait/landscape) |
| `V.Printer.Page` | Current page number during printing |
| `V.Printer.PaperBin` | Paper bin/tray selection |
| `V.Printer.PaperSize` | Paper size setting |
| `V.Printer.Port` | Printer port name |
| `V.Printer.Width` | Printable page width |

## Printer Variable Accessors (V.Printer.*var.*)

`V.Printer` variables expose a read-only subset of the standard inline variable properties. These provide type conversion, string manipulation, validation, and formatting on printer-related variable values.

```
V.Printer.varName.Float()              ' Convert to float (double)
V.Printer.varName.IsDate()             ' True if value is a valid date
V.Printer.varName.IsNumeric()          ' True if value is numeric
V.Printer.varName.LCase()              ' Lowercase
V.Printer.varName.Length()             ' String length
V.Printer.varName.Long()              ' Convert to long integer
V.Printer.varName.LTrim()             ' Left trim
V.Printer.varName.PCase()             ' Proper case (Title Case)
V.Printer.varName.PervasiveDate()     ' Date formatted as yyyy-MM-dd for Pervasive SQL
V.Printer.varName.RTrim()             ' Right trim
V.Printer.varName.String()            ' Convert to string
V.Printer.varName.StrLit()            ' Wrap value as a string literal (adds quotes)
V.Printer.varName.Trim()              ' Trim both ends
V.Printer.varName.UCase()             ' Uppercase
```

| Method | Category | Description |
|--------|----------|-------------|
| `.Float()` | Conversion | Convert to float |
| `.IsDate()` | Validation | True if valid date |
| `.IsNumeric()` | Validation | True if numeric |
| `.LCase()` | String | Lowercase |
| `.Length()` | String | String length |
| `.Long()` | Conversion | Convert to long integer |
| `.LTrim()` | String | Left trim |
| `.PCase()` | String | Proper case |
| `.PervasiveDate()` | Formatting | Date as yyyy-MM-dd |
| `.RTrim()` | String | Right trim |
| `.String()` | Conversion | Convert to string |
| `.StrLit()` | String | Wrap as string literal |
| `.Trim()` | String | Trim both ends |
| `.UCase()` | String | Uppercase |

---

# DEBUGGING

```
F.Intrinsic.Debug.InvokeDebugger      ' Launch debugger
F.Intrinsic.Debug.Stop                ' Breakpoint
F.Intrinsic.Debug.SetScriptVersion(sVersion)  ' Set version label for debugging
F.Intrinsic.Debug.Print(sMessage)                ' Print to debug console
F.Intrinsic.Debug.SetLA(sLabel)                  ' Set label/annotation
F.Intrinsic.Debug.SetLABuild(sFormat,sArgs)      ' Set label with Build formatting
F.Intrinsic.Debug.WatchVariable(sVarName)         ' Add variable to watch list
F.Intrinsic.Debug.DumpVariableList(sResult)       ' Dump all variables
F.Intrinsic.Debug.BenchmarkModeEnable             ' Enable benchmarking
F.Intrinsic.Debug.TimerStart                       ' Start timer
F.Intrinsic.Debug.TimerElapsed(sResult)           ' Read elapsed time
F.Intrinsic.Debug.CallWrapperDebugEnable          ' Enable CallWrapper debug output
F.Intrinsic.Debug.ShowCallerInfo               ' Display caller info dialog
```

Remove all debug statements before deploying to production.

---

# TASK MANAGEMENT (F.Intrinsic.Task.*)

```
F.Intrinsic.Task.LaunchAsync(sCommand,sArgs)             ' Launch external process (async)
F.Intrinsic.Task.LaunchSync(sCommand,sArgs)              ' Launch and wait for completion
F.Intrinsic.Task.LaunchGSSAsync(sProgramPath)            ' Launch GSS program async
F.Intrinsic.Task.LaunchGSSSync(sProgramPath)             ' Launch GSS program sync
F.Intrinsic.Task.ShellExec(hWnd,sVerb,sFile,sArgs,sDir,iShowCmd)  ' Execute shell command (Win32 ShellExecute)
F.Intrinsic.Task.PIDRunning(iPID,bResult)                ' Check if process is running
F.Intrinsic.Task.TerminatePID(iPID)                      ' Kill process
F.Intrinsic.Task.KillPID(sPID)                           ' Kill process by PID (String)
F.Intrinsic.Task.GetProcessList(sResult)                 ' List running processes
F.Intrinsic.Task.AppActivate(sWindowTitle)               ' Bring window to front
F.Intrinsic.Task.SendKeys(sKeys)                         ' Send keystrokes to active window
F.Intrinsic.Task.SetEnvironmentVariable(sName,sValue)    ' Set env var
F.Intrinsic.Task.CreateLock(sLockName,bResult)           ' Create named lock
F.Intrinsic.Task.CheckLock(sLockName,bResult)            ' Check if lock exists
```

---


# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: CommandProtocolComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CommandProtocolComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CommandProtocolComponent.vb`
- **Feature toggle:** `e66bfcba-0ebd-4315-9367-5669d334cd4d`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~208 lines

### Runtime purpose
The Command Protocol Component provides functionality for generating and launching GSS Menu Protocol URIs for inter-application communication.

### Implementation notes (OCTSRS)
#### Feature Toggle
- Requires feature toggle `e66bfcba-0ebd-4315-9367-5669d334cd4d` to be enabled
- Returns immediately if toggle is disabled

#### Object Management
- Uses UserDefinedObjects collection
- URI objects tracked by name

#### Migration Notes
- Modern implementation using builders
- No database interaction

### Dependencies
#### External Dependencies
- GSS.CommandProtocol.IPC.Objects.Builders

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `GENERATEURI` | Generate a protocol URI |
| `ADDPAYLOAD` | Add payload to URI |
| `GETURL` | Get the URL string |

### Key method signatures & edge cases
#### `GENERATEURI`
**GAB Syntax:** `Subroutine.Global.CommandProtocol.GenerateUri(JobStreamID, LaunchThroughMenu, CompanyCode, [NewInstance], Variable.Local.ObjectName)`

**Purpose:** Generates a GSS Menu Protocol URI for launching screens.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | JobStreamID | String | Yes | Job stream identifier |
| 2 | LaunchThroughMenu | Boolean | Yes | Use menu support |
| 3 | CompanyCode | String | Yes | Company code |
| 4 | NewInstance | Boolean | No | Create new instance |
| R | ObjectName | String | Yes | Return - URI object name |

#### `LAUNCH`
**GAB Syntax:** `Subroutine.Global.CommandProtocol.Launch(URIObjectName)`

**Purpose:** Launches the generated URI.

#### `GETURL`
**GAB Syntax:** `Function.Global.CommandProtocol.GetUrl(URIObjectName, Variable.Local.URL)`

**Purpose:** Gets the URL string from a URI object.

#### `ADDPAYLOAD`
**GAB Syntax:** `Subroutine.Global.CommandProtocol.AddPayload(URIObjectName, Key, Value)`

**Purpose:** Adds payload data to a URI object.

---

## Component Reference: DebugInformationComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DebugInformationComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DebugInformationComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~516 lines

### Runtime purpose
The Debug Information Component provides debugging and diagnostic functionality for GAB script development and troubleshooting.

### Implementation notes (OCTSRS)
#### Debug Levels
- `GlobalShopDebugLevel` controls visibility
- `GlobalShopCoreDebugLevel` controls call wrapper debug
- `IsLoggingEnabled` controls log output

#### Benchmark Mode
- Hides debugger for performance testing
- Enables logging for timing data
- Threshold for reporting slow operations

#### Migration Notes
- No database interaction
- UI dependency (debugger form)
- Core development tool

### Dependencies
#### Components Called
- None directly

#### External Dependencies
- Debugger form (UI component)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `INVOKEDEBUGGERINDEBUG` | Open debugger if in debug mode |
| `ENABLELOGGING` | Enable logging |
| `STARTLOGGING` | Start logging |
| `TOGGLEOUTPUT` | Toggle output display |
| `TOGGLEOUTPUTLISTING` | Toggle output listing |
| `BENCHMARKTHRESHOLD` | Set benchmark threshold |
| `TIMERELAPSEDTICKS` | Get elapsed ticks |
| `CALLWRAPPERDEBUGDISABLE` | Disable call wrapper debug |
| `CALLWRAPPERDEBUGENABLESILENT` | Enable silent debug |
| `DUMPOUTPUTHOOKFILE` | Dump hook file contents |
| `SETLEVEL` | Set debug level |
| `SETERRORTIMEOUT` | Set error timeout |
| `SETPROGRAMDIRECTORY` | Set program directory |
| `OVERRIDEGSSVERSION` | Override GSS version |

### Key method signatures & edge cases
#### `INVOKEDEBUGGER`
**GAB Syntax:** `Subroutine.In.Debug.InvokeDebugger()`

**Purpose:** Opens the debugger window and pauses execution.

**Business Rules:**
- Sets InitializationComplete to True
- Sets GlobalShopDebugLevel to 1 if 0
- Makes debugger visible
- Populates debugger with current state

#### `PRINT`
**GAB Syntax:** `Subroutine.In.Debug.Print(Message)`

**Purpose:** Prints a message to the debug output.

#### `DUMPVARIABLELIST`
**GAB Syntax:** `Subroutine.In.Debug.DumpVariableList()`

**Purpose:** Outputs all current variables to debug log.

#### `SETLEVEL`
**GAB Syntax:** `Subroutine.In.Debug.SetLevel(Level)`

**Purpose:** Sets the debug verbosity level.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Level | Integer | Yes | Debug level (0-2) |

**Levels:**
- 0 - No debugging
- 1 - Normal debugging
- 2 - Verbose debugging

---

## Component Reference: HookAssociationComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\HookAssociationComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\Hooks\HookAssociationComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The Hook Association Component manages hook associations and event handling for the GSS hook system.

### Implementation notes (OCTSRS)
#### Hook System
- Core extensibility mechanism
- Event-driven architecture
- Sequence-based execution

#### Migration Notes
- Check source file for detailed methods
- Complex hook management
- May use ADODB for data access

### Dependencies
#### Components Called
- `GlobalShopComponent` - For hook firing

---

---

## Component Reference: PrinterComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\PrinterComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\PrinterComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~164 lines

### Runtime purpose
The Printer Component provides printer management functionality including printer selection, default printer management, and printer enumeration.

### Implementation notes (OCTSRS)
#### Windows API
- Uses SetDefaultPrinter from winspool.drv
- Windows-specific functionality

#### Printer Tracking
- Stores previous default printer
- Can restore after temporary change

#### Migration Notes
- No database interaction
- Windows-specific (winspool.drv)
- Uses .NET printing classes

### Dependencies
#### External Dependencies
- System.Drawing.Printing
- winspool.drv (Windows API)

#### Components Called
- `UiComponent` - For printer dialog

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `SELECTPRINTERBYNAMEFRAGMENT` | Select printer by name fragment |

### Key method signatures & edge cases
#### `GETPRINTERS`
**GAB Syntax:** `Function.Global.Printer.GetPrinters(Variable.Local.PrinterList)`

**Purpose:** Gets a list of all available printers.

**Returns:** Delimited list of printer names

#### `SELECTPRINTERBYNAMEEXACT`
**GAB Syntax:** `Function.Global.Printer.SelectPrinterByNameExact(PrinterName, Variable.Local.Selected)`

**Purpose:** Selects a printer by exact name match.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | PrinterName | String | Yes | Exact printer name |
| R | Selected | Boolean | Yes | Return - True if found |

#### `SELECTPRINTERBYNAMEFRAGMENT`
**GAB Syntax:** `Function.Global.Printer.SelectPrinterByNameFragment(NameFragment, Variable.Local.Selected)`

**Purpose:** Selects a printer by partial name match.

#### `SETDEFAULTPRINTER`
**GAB Syntax:** `Subroutine.Global.Printer.SetDefaultPrinter(PrinterName)`

**Purpose:** Sets the system default printer.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | PrinterName | String | Yes | Printer to set as default |

#### `RESTOREPRINTER`
**GAB Syntax:** `Subroutine.Global.Printer.RestorePrinter()`

**Purpose:** Restores the previous default printer.

---
