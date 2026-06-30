# GAB Core Language Reference
# Variables, Control Flow, Error Handling, and Coding Conventions
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

This file contains the detailed language reference for GAB's core constructs.
For syntax rules, file structure, anti-patterns, and critical gotchas, see `agents/AGENTS.GAB.md`.

> **CRITICAL REMINDERS** (from `agents/AGENTS.GAB.md` -- always applies):
> - **No inline math operators** (`+`, `-`, `*`, `/`) in GAB statements. Use `F.Intrinsic.Math.Add()`, `.Sub()`, `.Mult()`, `.Div()` etc. The `.++` and `.--` variable properties are the only inline numeric operations (and must appear inside another expression, not standalone).
> - **No `+` for string concatenation.** Use `F.Intrinsic.String.Build("{0}{1}",a,b,result)`, `F.Intrinsic.String.Concat(a,b,result)`, or `.Set()`/`.Append()`.
> - **`String.Build` requires at least one `{N}` placeholder AND matching substitution arguments.** For literal strings with no placeholders, use `V.Local.s.Set("...")` instead — calling `String.Build` with zero substitution args fails with Error 405.
> - **Expression strings are different.** Operators like `+`, `*`, etc. ARE valid inside DataTable expression strings and LINQ expressions (these use a .NET-based mini-language, not GAB statement syntax). See `agents/gab/DATA_DATATABLE.md` > Expression Syntax.

---

**Table of contents**

- **[COMMENTS](#comments)** -- Apostrophe comments, section labels, and `'@` doc pointers
- **[VARIABLE SYSTEM (Core)](#variable-system-core)** -- Declare, types, assignment, inline properties, arrays
  - [Declaration](#declaration)
  - [Data Types](#data-types)
  - [Assignment](#assignment)
  - [Inline Variable Properties](#inline-variable-properties-chainable-on-variable-references)
  - [Array Operations](#array-operations)
- **[CONTROL FLOW](#control-flow)** -- Conditionals, loops, events, Try/Catch, calls, utilities
  - [Conditionals](#conditionals)
  - [Select Case](#select-case)
  - [Loops](#loops)
  - [Subroutine Calls](#subroutine-calls)
  - [GoTo](#goto)
  - [Event Blocking](#event-blocking)
  - [Try/Catch/Finally](#trycatchfinally)
  - [Inline If (IIf)](#inline-if-iif)
  - [Raise Error](#raise-error)
  - [Argument Checking](#argument-checking)
  - [Variable Utilities](#variable-utilities)
- **[ERROR HANDLING](#error-handling)** -- SetErrorHandler, standard and mobile patterns
  - [Error Handler Types](#error-handler-types)
  - [Standard Pattern](#standard-pattern-mandatory-for-every-non-trivial-subroutine)
  - [Mobile Error Pattern](#mobile-error-pattern)
- **[CODING CONVENTIONS](#coding-conventions)** -- Naming, patterns, Main/refresh/events, units
  - [Naming](#naming)
  - [Readability](#readability)
  - [Boilerplate Every Subroutine Must Have](#boilerplate-every-subroutine-must-have)
  - [Grid Setup Pattern](#grid-setup-pattern)
  - [Connection Pattern](#connection-pattern)
  - [Data Loading Pattern](#data-loading-pattern)
  - [Main Initialization Sequence](#main-initialization-sequence-mandatory-for-new-g2u-files)
  - [Wait Dialog Best Practices](#wait-dialog-best-practices)
  - [Data Refresh Pattern](#data-refresh-pattern)
  - [Event Handler Pattern](#event-handler-pattern)
  - [Pixel Units (UsePixels is MANDATORY)](#pixel-units-usepixels-is-mandatory)

---

# COMMENTS (MANDATORY IN ALL NEW CODE)

**Every subroutine, every logical section, and every SQL query MUST have a comment.** This is not a suggestion. Agents must proactively add comments without being asked.

Single-line comments use a leading apostrophe:
```
'This is a comment
'F.Intrinsic.UI.Msgbox("commented out code")
```

### What MUST be commented

- **Subroutine purpose** -- a `'-- <purpose>` line immediately after every `Program.Sub.<Name>.Start`
- **SQL queries** -- what data the query fetches/updates and why
- **Event handlers** -- what triggers the event and what it should accomplish
- **Section headers** every 5-10 lines in longer subs (`'-- Load data`, `'-- Validate`, `'-- Save`)
- **Business or ERP rules** that are not obvious from the code alone
- **Prerequisites** and **order-dependent** steps (what must happen before what)
- **Edge cases** and **workarounds** (including why the workaround exists)
- **Non-obvious calls** -- explain what a CallWrapper does and what the parameters mean

### What NOT to comment

- Avoid comments that only restate the next line (e.g. narrating `Gui.form.cmd.Save` as "save the form")
- Do not comment trivial single-line assignments or simple Gui property sets

### Doc comments (`'@`)

For subroutines with non-trivial arguments or return behavior, use structured doc comments so the GAB IDE and maintainers see the contract. See **Documentation Comments** in `agents/AGENTS.GAB.md` for `'@ Arg` and `'@ Return` syntax.

---

# VARIABLE SYSTEM (Core)

## Declaration

```
V.Local.<name>.Declare                          ' Type inferred from Hungarian prefix (s=String, i=Long, f=Float, d=Date, b=Boolean)
V.Local.<name>.Declare(<Type>)                  ' Typed
V.Local.<name>.Declare(<Type>,<DefaultValue>)   ' Typed with default
V.Global.<name>.Declare(<Type>,<DefaultValue>)  ' Global scope
V.Static.<name>.Declare(<Type>,<DefaultValue>)  ' Static: persists across calls to same subroutine
```

### V.Local Declaration Reference
```
V.Local.sString.Declare(String,"")
V.Local.iLong.Declare(Long,0)
V.Local.bBoolean.Declare(Boolean,False)
V.Local.fFloat.Declare(Float,0)
V.Local.dDate.Declare(Date)
V.Local.baByteArray.Declare(ByteArray)
```

### V.Global Declaration Reference
```
V.Global.sString.Declare(String,"")
V.Global.iLong.Declare(Long,0)
V.Global.bBoolean.Declare(Boolean,False)
V.Global.fFloat.Declare(Float,0)
V.Global.dDate.Declare(Date)
V.Global.baByteArray.Declare(ByteArray)
```

### V.Static Declaration Reference
V.Static variables persist their value across multiple calls to the same subroutine within a single program execution. They support the same Declare, Set, Append, inline properties, and array operations as V.Local and V.Global.
```
V.Static.sLastSearch.Declare(String,"")
V.Static.iCallCount.Declare(Long,0)
V.Static.bInitialized.Declare(Boolean,False)
```

### Bulk Declaration
The double-dot (`..`) before `BulkDeclare` is required syntax -- the first dot ends the scope (`V.Local.`), the second starts the method name. This is not a typo.
```
V.Local..BulkDeclareString(sA,sB,sC)
V.Local..BulkDeclareLong(iA,iB,iC)
V.Local..BulkDeclareBoolean(bA,bB)
V.Local..BulkDeclareFloat(fA,fB,fC)
V.Local..BulkDeclareDate(dA,dB)
```
The same `BulkDeclare*` syntax works on `V.Global.` and `V.Static.` scopes as well.

## Data Types
| Type | Prefix Convention | Example |
|------|-------------------|---------|
| String | s | `V.Local.sSQL.Declare(String,"")` |
| Long | i | `V.Local.iCount.Declare(Long,0)` |
| Float | f | `V.Local.fTotal.Declare(Float,0)` |
| Boolean | b | `V.Local.bCheck.Declare(Boolean,False)` |
| Date | d | `V.Local.dStart.Declare(Date)` |
| ByteArray | ba | `V.Local.baData.Declare(ByteArray)` |
| StringList | (none) | `V.Local.sRet.Declare(StringList)` |

## Assignment
```
V.Local.sName.Set("value")
V.Local.iCount.Set(0)
V.Global.bFlag.Set(True)
V.Global.sName.Set("value",iHookNumber)            ' Optional Hook# for cross-program set
```

## Inline Variable Properties (chainable on variable references)

These properties are read-only accessors available on any variable scope (V.Local, V.Global, V.Static, V.Ambient, V.Caller, V.Passed, V.Printer, V.Screen, V.External, V.System, V.ASCII, etc.).
**Note:** `V.Passed` has additional hook-specific metadata properties (Hidden, HWnd, IID, Locked, MaxLength, Name, NoChange, TabStop, Type). See `agents/gab/HOOKS.md` for the full V.Passed method reference.
**Note:** `V.Printer` exposes a read-only subset (no Set/Append/array methods). See `agents/gab/API_PRINTER.md` for the full V.Printer method reference.
**Note:** `V.System` exposes a read-only subset (no Set/Append/Declare/array methods, no Not/LBound/UBound). See `agents/gab/VARIABLES.md` for details.

### Type Conversion
| Property | Purpose |
|----------|---------|
| `.String()` | Convert to string |
| `.Long()` | Convert to long (rounds floats: `25.79` → `26`) |
| `.Float()` | Convert to float |
| `.Boolean()` | Convert to boolean (`"0"` → `False`, `"1"` → `True`) |
| `.Date()` | Convert to date type |
| `.Currency()` | Format as currency string (rounds to 2 decimals: `10.896` → `10.90`) |
| `.Base64` | Returns value as Base64-encoded string |
| `.IntPart` | Returns integer part of a float, discarding decimals (`12.3` → `12`) |

### String Manipulation
| Property | Purpose |
|----------|---------|
| `.Trim` | Trim whitespace from both ends (property, no parentheses) |
| `.LTrim` | Trim whitespace from left (property, no parentheses) |
| `.RTrim` | Trim whitespace from right (property, no parentheses) |
| `.UCase()` | Convert to uppercase |
| `.LCase()` | Convert to lowercase |
| `.PCase()` | Convert to proper case (Title Case) |
| `.Length()` | String length |
| `.Left<N>` | Left N characters (e.g. `.Left1`, `.Left5`, `.Left10`) |
| `.Right<N>` | Right N characters (e.g. `.Right1`, `.Right5`, `.Right10`) |
| `.StrLit()` | Wrap value as a string literal (adds quotes) |
| `.StringTrim()` | Convert to string and trim whitespace from both ends |
| `.LcTrim()` | Lowercase + trim both ends |
| `.LclTrim()` | Lowercase + trim left only |
| `.LcrTrim()` | Lowercase + trim right only |
| `.UcTrim()` | Uppercase + trim both ends |
| `.UclTrim()` | Uppercase + trim left only |
| `.UcrTrim()` | Uppercase + trim right only |
| `.Append` | Append string to variable in-place |

### Validation
| Property | Purpose |
|----------|---------|
| `.IsDate()` | Returns True if value is a valid date |
| `.IsNumeric()` | Returns True if value is numeric |
| `.IsCancel` | Returns True if value is `***CANCEL***` (no parentheses — property, not method) |
| `.IsNotCancel` | Returns True if value is NOT `***CANCEL***` |
| `.IsNoReturn` | Returns True if value is `***NORETURN***` |
| `.IsNotNoReturn` | Returns True if value is NOT `***NORETURN***` |
| `.IsNullOrWhiteSpace` | Returns True if value is null, empty, or only whitespace |
| `.IsNotNullOrWhiteSpace` | Returns True if value has non-whitespace content |

> **CRITICAL:** `Browser`, `BrowserFromString`, `BrowserFromStringNet`, `BrowserFromFile`, `BrowserFromFileNet`, `InputBox`, and similar dialog functions return `***CANCEL***` (not empty string) when the user clicks X or cancels. Always check for `***CANCEL***` before processing the result. Use `.IsCancel` (no parentheses) on variables or compare directly: `F.Intrinsic.Control.If(V.Local.sResult,=,"***CANCEL***")`.
> **CRITICAL:** `.IsCancel`, `.IsNotCancel`, `.IsNoReturn`, `.IsNotNoReturn`, `.IsNullOrWhiteSpace`, `.IsNotNullOrWhiteSpace` are **properties** — do NOT use parentheses. `V.Local.sResult.IsCancel` is correct; `V.Local.sResult.IsCancel()` is invalid.

### Numeric Conversion
| Property | Purpose |
|----------|---------|
| `.PercentToDecimal()` | Convert percentage value to decimal (e.g. 25 → 0.25) |

### Formatting
| Property | Purpose |
|----------|---------|
| `.Format<spec>` | Format value; spec can be `DD`, `MMMM`, `YYYY`, `YYYYMMDDHHNNSS`, `HHNNSS`, etc. |
| `.PervasiveDate()` | Format date for Pervasive SQL (`2024-06-20`) |
| `.DateComp()` | Date with time stripped to midnight (sortable date representation) |
| `.TimeComp()` | Time with date stripped to `1/1/0001` (sortable time representation) |
| `.Hour` | Hour component (0-23) |
| `.Minute` | Minute component (0-59) |
| `.Second` | Second component (0-59) |
| `.FromGDate` | Convert minutes-since-Jan-1-1968 (Long) to DateTime |
| `.ToGDate` | Convert DateTime to minutes-since-Jan-1-1968 (Long) |

### Database Escaping
| Property | Purpose |
|----------|---------|
| `.PSQLFriendly` | Escape single quotes, double quotes, and backslashes for Pervasive SQL |
| `.SQLServerFriendly` / `.SQLServFriendly` | Escape single quotes, double quotes, and backslashes for SQL Server |

> **CRITICAL:** `.PSQLFriendly`, `.SQLServerFriendly`, and `.SQLServFriendly` are **properties** -- do NOT use parentheses. `V.Local.sVal.PSQLFriendly` is correct; `V.Local.sVal.PSQLFriendly()` causes Runtime Error 113.
>
> **CRITICAL:** These properties **cannot be chained** on `V.Screen` read expressions. The value must first be read into a local variable, then the property applied in a separate `.Set()`:
> ```
> ' WRONG -- chaining on V.Screen fails at parse time:
> V.Local.sPart.Set(V.Screen.FormPart!txtPart.Text.PSQLFriendly)
>
> ' CORRECT -- two-step read then escape:
> V.Local.sPart.Set(V.Screen.FormPart!txtPart.Text)
> V.Local.sPart.Set(V.Local.sPart.PSQLFriendly)
> ```

### Unit Conversion
| Property | Purpose |
|----------|---------|
| `.PixelsToTwips` | Convert pixel value to twips |
| `.TwipsToPixels` | Convert twip value to pixels |

### Boolean / Array / Other
| Property | Purpose |
|----------|---------|
| `.Not` | Boolean negation |
| `.UBound` | Array upper bound |
| `.Exists` | DataTable/DataView existence check |

### .Append Example
```
V.Local.sResult.Append("<br />")        ' Appends to string in-place
V.Local.sResult.Append(V.Local.sChunk)  ' Append variable
```

## Array Operations
```
V.Local.sRet.Redim                    ' Clear array
V.Local.sRet.Redim(0,5)              ' Resize
V.Local.sRet.RedimPreserve(0,10)     ' Resize preserving data
V.Local.sRet(0)                       ' Access by index
V.Local.iCount.++                     ' Increment by 1 (MUST appear inside another expression/function call)
V.Local.iCount.--                     ' Decrement by 1 (MUST appear inside another expression/function call)
```

**CRITICAL: `.++` and `.--` MUST appear as arguments inside another function call -- they cannot be standalone statements.** They return the new value AND set the variable as a side effect. (Note: this is NOT the same as the "no inline math operators" rule in `agents/AGENTS.GAB.md`, which prohibits infix operators like `a + b`. `.++`/`.--` are property accessors on variables, not infix operators.)
```
F.Intrinsic.UI.Msgbox(V.Local.iCount.++)           ' Valid: inline -- increments iCount AND returns new value
F.Intrinsic.UI.Msgbox(V.Local.iCount.--)           ' Valid: inline -- decrements iCount AND returns new value
V.Local.iCount.Set(V.Local.iCount.++)              ' Valid but redundant: .++ already sets the variable
F.Intrinsic.Math.Add(V.Local.iCount, 1, V.Local.iCount)  ' Also valid: explicit add
V.Local.iCount.++                                   ' INVALID: standalone .++ errors
```

For full system variable tables (V.Ambient, V.Caller, V.Args, V.Enum, V.Color, V.ASCII), see `agents/gab/VARIABLES.md`.

---

# CONTROL FLOW

## Conditionals
```
F.Intrinsic.Control.If(<expr>,<op>,<value>)
    '...
F.Intrinsic.Control.ElseIf(<expr>,<op>,<value>)
    '...
F.Intrinsic.Control.Else
    '...
F.Intrinsic.Control.EndIf
```

### Single-Parameter Boolean If
Boolean variables can be evaluated directly without an operator:
```
F.Intrinsic.Control.If(V.Global.bAllowFeature)
    '... executes when True
F.Intrinsic.Control.EndIf

F.Intrinsic.Control.If(V.Local.bFound.Not)
    '... executes when False (using .Not property)
F.Intrinsic.Control.EndIf
```

### Compound Conditions
```
F.Intrinsic.Control.If(<expr1>,<op1>,<val1>,"AND",<expr2>,<op2>,<val2>)
F.Intrinsic.Control.If(<expr1>,<op1>,<val1>,"OR",<expr2>,<op2>,<val2>)
F.Intrinsic.Control.AndIf(<expr>,<op>,<value>)
```

### Comparison Operators
`=`, `<>`, `<`, `>`, `<=`, `>=`

**`mod` is NOT supported inline** in `F.Intrinsic.Control.If`. Pre-compute with `F.Intrinsic.Math.Mod(dividend, divisor, result)` into a local variable, then compare the result.

## Select Case
```
F.Intrinsic.Control.SelectCase(<expression>)
    F.Intrinsic.Control.Case("value1")
        '...
    F.Intrinsic.Control.Case("value2")
        '...
    F.Intrinsic.Control.CaseAny("A","B","C")
        '...
    F.Intrinsic.Control.Case("X","OR","Y")
        '...
    F.Intrinsic.Control.CaseRange(1,100)
        '... matches if expression is between 1 and 100 inclusive
    F.Intrinsic.Control.CaseElse
        '...
F.Intrinsic.Control.EndSelect
```

## Loops
```
' For loop (ascending, explicit step)
' .RowCount-- returns (row count minus 1), i.e. the last 0-based index
F.Intrinsic.Control.For(V.Local.i,0,V.DataTable.dt.RowCount--,1)
    '...
    F.Intrinsic.Control.ExitFor(V.Local.i)    ' Break
F.Intrinsic.Control.Next(V.Local.i)

' For loop (step defaults to 1 when omitted)
F.Intrinsic.Control.For(V.Local.i,0,10)
    '...
F.Intrinsic.Control.Next(V.Local.i)

' For loop (descending -- use step -1 when deleting rows to avoid index shift)
F.Intrinsic.Control.For(V.Local.i,V.DataView.dt!dv.RowCount--,0,-1)
    '...
F.Intrinsic.Control.Next(V.Local.i)

' Do Until loop
F.Intrinsic.Control.DoUntil(V.ODBC.con!rst.EOF,=,True)
    '...
F.Intrinsic.Control.Loop

' Unconditional Do loop (use ExitDo to break)
F.Intrinsic.Control.Do
    '...
    F.Intrinsic.Control.ExitDo
F.Intrinsic.Control.Loop
```

## Subroutine Calls
```
F.Intrinsic.Control.CallSub(SubName)
F.Intrinsic.Control.CallSub(SubName,"Arg1","Value1","Arg2","Value2")
F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.End                     ' Terminate program
```

## GoTo
```
F.Intrinsic.Control.GoTo("LabelName")
F.Intrinsic.Control.Label("LabelName")
```

## Event Blocking
```
F.Intrinsic.Control.BlockEvents
'... modify UI without triggering events ...
F.Intrinsic.Control.UnBlockEvents
F.Intrinsic.Control.DoEvents                   ' Process pending UI events (keep UI responsive in long loops)
```

## Try/Catch/Finally

> **Try/Catch cannot be nested within the same subroutine** — a Try block inside another Try block in the same sub will misroute errors. However, calling another subroutine via `CallSub` that has its own Try/Catch is **perfectly valid** and works correctly. Use `SetErrorHandler` + label-based error handling as the standard pattern for all subroutines. Reserve `Try/Catch` only for **targeted error capture** around a single risky operation (e.g., wrapping one ODBC call or DLL invocation). See `agents/gab/PITFALLS.md` > "CRITICAL GAB BEHAVIOR: Try/Catch CANNOT Be Nested" for the full rule and examples.

```
F.Intrinsic.Control.Try
    '...
F.Intrinsic.Control.Catch
    '...
F.Intrinsic.Control.CatchWhen(5102)            ' Catch only specific error number
    '...
F.Intrinsic.Control.Finally
    '... always executes (cleanup, close connections)
F.Intrinsic.Control.EndTry
F.Intrinsic.Control.ExitTry                    ' Jump to Finally from within Try block
```
`Finally` is optional. When present, it runs whether or not an exception occurred -- ideal for closing connections or unblocking events.
`CatchWhen(errorNumber)` catches only a specific error, letting others propagate.
`ExitTry` jumps directly to the `Finally` block (or `EndTry` if no `Finally`).

## Inline If (IIf)
```
F.Intrinsic.Control.IIf(V.Local.bFlag,=,True,"Yes","No",V.Local.sResult)
```

## Raise Error
```
F.Intrinsic.Control.RaiseError(iErrorCode,sErrorDescription)
```
Programmatically raises an error that can be caught by `SetErrorHandler` or `Try/Catch`.

## Argument Checking
```
F.Intrinsic.Variable.ArgExists("ArgName",V.Local.bRet)
F.Intrinsic.Variable.PassedExists("ParamName",V.Local.bRet)
F.Intrinsic.Variable.ArgToVar("ArgName",V.Local.sVar)         ' Copy arg value to variable
F.Intrinsic.Control.IsInCallstack(SubName,V.Local.bRet)
```

## Variable Utilities
```
F.Intrinsic.Variable.AddToArray(sArray,"newElement")           ' Append element to array
F.Intrinsic.Variable.PopArray(sArray,sResult)                  ' Remove and return last element
F.Intrinsic.Variable.RemoveArrayElementByOrdinal(sArray,iIndex)
F.Intrinsic.Variable.RemoveArrayElementByValue(sArray,"value")
F.Intrinsic.Variable.Sort(sArray,"ASC")                        ' Sort array (ASC/DESC)
F.Intrinsic.Variable.SetProperty("VarName","PropertyName",value)
F.Intrinsic.Variable.AddPV("ParamName",sValue)                ' Add to passed values
F.Intrinsic.Variable.AddRV("ReturnName",sValue)               ' Add to return values
F.Intrinsic.Variable.ListCallerVars(sResult)                   ' List all caller variables
F.Intrinsic.Variable.FindIDFromName("VarName",iResult)         ' Get variable ID from name
```

---

# ERROR HANDLING

> **MANDATORY RULE**: Every subroutine MUST have error handling. The ONLY exceptions are `ScreenSU`, `Preflight`, and `Comments`. This includes event handlers, utility subs, and form lifecycle subs — no "too small" threshold.

> **MANDATORY RULE**: Error handlers MUST terminate the program (for GUI scripts) or log and exit (for unattended scripts). Never leave a program running after an unhandled error — users continuing after errors causes data corruption.

## Error Handler Types
```
F.Intrinsic.Control.SetErrorHandler("LabelName")  ' Jump to label on error (standard)
F.Intrinsic.Control.ErrorResume                    ' Resume execution on the line after the error (use sparingly)
F.Intrinsic.Control.ClearErrors                    ' Reset error state
```

## Try/Catch Pattern (preferred for new code)

Try/Catch is the preferred error handling for new scripts. `Try` MUST be the first executable line after `Program.Sub.SubName.Start` — BEFORE any `.Declare` statements. Variable declarations belong inside the Try block.

```
Program.Sub.<SubName>.Start
F.Intrinsic.Control.Try
    V.Local.sError.Declare(String,"")
    V.Local.sResult.Declare(String,"")

    '... business logic ...

F.Intrinsic.Control.Catch
    F.Intrinsic.String.Build("Project: <filename>.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(<FormUnload>)
F.Intrinsic.Control.EndTry
Program.Sub.<SubName>.End
```

**For unattended/OLU scripts** (no MsgBox allowed):
```
F.Intrinsic.Control.Catch
    F.Intrinsic.Control.CallSub(Log_Error)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndTry
```

**Nesting restriction**: Try/Catch CANNOT be nested within the same subroutine (see PITFALLS.md). Cross-subroutine nesting IS valid — sub A with Try/Catch calling sub B with its own Try/Catch works correctly.

## SetErrorHandler Pattern (legacy-compatible, still valid for maintenance)

SetErrorHandler + label-based error handling is the original GAB pattern. Still fully valid and required when maintaining existing scripts that use it.

```
Program.Sub.<SubName>.Start
F.Intrinsic.Control.SetErrorHandler("<SubName>_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

'... business logic ...

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("<SubName>_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: <filename>.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(<FormUnload>)
F.Intrinsic.Control.EndIf
Program.Sub.<SubName>.End
```

## Mobile Error Pattern
```
Program.Sub.CatchingMobile.Start
V.Local.sError.Declare(String)
F.Intrinsic.String.Build("PROJECT:{1}{0}{1}{1}SUBROUTINE:{1}{2}{1}{1}ERROR DESCRIPTION:{1}{3}{1}{1}ON LINE:{1}{4}",V.Caller.ScriptFile,"<br />",V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorDescription,V.Ambient.ErrorLine,V.Local.sError)
F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,V.Local.sError)
Program.Sub.CatchingMobile.End
```

---

# CODING CONVENTIONS

## Naming
- **Forms**: `Gui.FrmMain`, `Gui.F_Main`, `Gui.FormStructural`
- **Buttons**: `cmdSave`, `cmdCancel`, `cmdRefresh`
- **Labels**: `lblTitle`, `lblStatus`
- **TextBoxes**: `txtCustomer`, `txtOrderNo`
- **DropDownLists**: `ddlStatus`, `ddlType`
- **CheckBoxes**: `chkActive`, `chkApproved`
- **DatePickers**: `dtpStart`, `dtpEnd`
- **DateTimeOffsets**: `dtoCreated`, `dtoModified`
- **Grids**: `gsGCMain` ~~`gsGCFlex`~~ (GsFlexGrid names are legacy only)
- **Frames**: `framePrimary`, `frameSummary`
- **Timers**: `tmrElapsed`, `tmrRefresh`
- **AccordionControls**: `AccordionControl1`
- **BreadCrumbs**: `GsBreadCrumb1`, `GsBreadCrumb2`
- **BarDocks**: `bardock1`
- **TileViews**: `GsTileViewControl1`
- **CardViews**: `GsCardView1`
- **ToggleSwitches**: `GsToggleSwitch1`
- **ProgressPanels**: `progressPanel1`
- **PictureBoxes**: `picName`
- **ListBoxes**: `lst1`, `lstItems`
- **ListViews**: `lvw1`, `lvwItems`
- **TreeViews**: `trvSettings`, `trvMenu`
- **SplitContainers**: `SplitContainer1`
- **Tabs**: `tab1`, `tabMain`
- **FlowFrames**: `flow1`, `flowButtons`
- **Hyperlinks**: `link1`, `linkAttachment`
- **WebBrowsers**: `gsWebBrowser`, `GsWebView21`
- **PdfViewers**: `GsPdfViewer1`
- **RichEdits**: `GsRichEditControl1`
- **Spreadsheets**: `GsSpreadsheetControl1`
- **Schedulers**: `GsScheduler1`
- **Charts**: `gsChart1`, `GsChartProfit`
- **Barcodes**: `GsBarcodeControl1`
- **BandedGrids**: `GsAdvBandedGridControl1`
- **LookUps (GsLookUpControl)**: `luPart`, `luCustomer`
- **Lookups (Browser)**: `lookupCust`, `lookupPart`, `lookupInventoryPart`, `lkUsers`
- **MonthViews**: `monthView1`
- **NavFrames**: `nav1`
- **NavPages**: `navpage1`
- **Sliders**: `sld1`
- **HtmlContainers**: `htmlView`
- **Subroutines**: PascalCase (`LoadFormData`, `ValidateForm`, `SaveOrder`)
- **Event handlers**: `<ControlName>_<Event>` (`cmdSave_Click`, `ddlStatus_Change`)
- **Variables**: Hungarian notation (`s`=String, `i`=Long, `f`=Float, `b`=Boolean, `d`=Date). **No single-character variable names** — `V.Local.i`, `V.Local.j` cause Error 5101 (no type inferred) and are unreadable. Always use prefix + descriptive name: `iRow`, `iIdx`, `sFilter`, `bFlag`. Exception: do not rename existing single-char variables in legacy code you are maintaining

## Readability

- Prefer **small, named subroutines** (`CallSub`) over very long linear blocks in `Main` or event handlers when logic can be grouped by purpose.
- Use **blank lines** between logical blocks where the file’s style allows it.
- **Match the surrounding file**: error-handling pattern, `Program.Sub` layout, imports, and naming—new code should read like the same author wrote it.
- Do **not** sacrifice clarity for micro-optimization unless a documented requirement demands it.

## Boilerplate Every Subroutine Must Have
1. `SetErrorHandler` + `ClearErrors` at top
2. Blank line after `ClearErrors`
3. Variable declarations (`V.Local.sError.Declare(String,"")`, etc.)
4. `BlockEvents` (if needed) -- always after variable declarations, never before
5. Business logic
6. `ExitSub` before error label
7. Error label with standardized error message build
8. Msgbox + UnLoad/End on error

## Grid Setup Pattern
1. `SuspendLayout` before bulk property changes
2. Set grid properties (sort, filter, group panel, etc.)
3. Set column properties (captions, visibility, edit, alignment, formatting)
4. `ResumeLayout` after changes

## Connection Pattern
- Make ODBC connections self-contained: open, query/execute, and close within the same subroutine. The caller should not manage connections on behalf of a called sub.
- Open connections as late as possible
- Close connections as early as possible
- Use named connections for parallel operations (`con`, `conB`, `conC`)
- Wrap in Try/Catch for mobile scripts

## Data Loading Pattern
1. Open connection
2. `CreateFromSQL` to load data
3. Close connection
4. Add computed/expression columns
5. Create dictionaries for lookups
6. Fill from dictionary
7. Bind to grid

## Main Initialization Sequence (MANDATORY for new .g2u files)

Every `.g2u` Main subroutine should follow this proven sequence. Adapt steps as needed but preserve the ordering. Uses `SetErrorHandler` (not `Try/Catch`) because Main calls subroutines that themselves use `SetErrorHandler`.

```
Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors
V.Local.sError.Declare(String,"")

'-- 1. Pixel mode (MANDATORY for all GUI scripts)
F.Intrinsic.UI.UsePixels

'-- 2. Wait dialog (show immediately so user knows something is happening)
F.Intrinsic.UI.InvokeWaitDialog("Loading...")

'-- 3. Open database connection
F.ODBC.Connection!con.OpenCompanyConnection

'-- 4. Load lookups and dropdowns
F.Intrinsic.Control.CallSub(LoadLookups)

'-- 5. Configure context menus
F.Intrinsic.Control.CallSub(SetContextMenus)

'-- 6. Load data and bind grids
F.Intrinsic.Control.CallSub(LoadData)

'-- 7. Close wait dialog
F.Intrinsic.UI.CloseWaitDialog

'-- 8. Show the form
Gui.<FormName>..Show

'-- 9. Focus flash (forces form to front without staying on top)
Gui.<FormName>..AlwaysOnTop(True)
Gui.<FormName>..AlwaysOnTop(False)

F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.UI.CloseWaitDialog
    F.Intrinsic.String.Build("Project: <filename>.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(<FormUnload>)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End
```

**Key details:**
- **UsePixels** is mandatory for all GUI scripts -- must be the first statement in Main.
- **Wait dialog** should show before any slow operations (SQL, file I/O). Use `F.Intrinsic.UI.ChangeWaitStatus("Step 2 of 5...")` for multi-step loads.
- **Close wait before Show**, not after -- the user should see the form appear with data already loaded.
- **AlwaysOnTop flash** (`True` then immediately `False`) forces the form to the front of the z-order without permanently staying on top. This is the standard pattern used in production scripts.
- For **hook-dispatched** scripts, wrap the main logic in `SelectCase(V.Caller.Hook)` after step 1.
- **Error handler closes the wait dialog** before showing the error message -- if the wait dialog is still up when the error msgbox fires, the user may not see the message.

## Wait Dialog Best Practices

| API | Scope | Use When |
|-----|-------|----------|
| `F.Intrinsic.UI.InvokeWaitDialog("text")` | Form-level | Loading entire form, multi-step init |
| `Gui.<Form>.gsGC.InvokeWait("text")` | Grid-level | Loading/rebuilding a single grid |
| `F.Intrinsic.UI.ChangeWaitStatus("text")` | Updates existing dialog | Multi-step operations (progress updates) |
| `F.Intrinsic.UI.CloseWaitDialog` | Form-level | Paired with `InvokeWaitDialog` |
| `Gui.<Form>.gsGC.HideWait` | Grid-level | Paired with grid `InvokeWait` |

## Data Refresh Pattern

When the user triggers a refresh (button click, context menu, timer), follow this sequence to avoid event cascading and preserve user layout:

```
Program.Sub.RefreshData.Start
F.Intrinsic.Control.SetErrorHandler("RefreshData_Err")
F.Intrinsic.Control.ClearErrors
V.Local.sError.Declare(String,"")
V.Local.sLayout.Declare(String,"")

'-- 1. Save user's grid layout
Gui.<Form>.gsGC.Serialize("gvName",V.Local.sLayout)

'-- 2. Block events to prevent cascading handlers during rebuild
F.Intrinsic.Control.BlockEvents

'-- 3. Show wait indicator
Gui.<Form>.gsGC.InvokeWait("Refreshing...")

'-- 4. Close and reload DataTables
F.Intrinsic.Control.If(V.DataTable.dtName.Exists)
    F.Data.DataTable.Close("dtName")
F.Intrinsic.Control.EndIf
F.Intrinsic.Control.CallSub(LoadData)

'-- 5. Unblock events
F.Intrinsic.Control.UnBlockEvents

'-- 6. Restore user's grid layout
F.Intrinsic.Control.If(V.Local.sLayout.Trim,<>,"")
    Gui.<Form>.gsGC.Deserialize(V.Local.sLayout)
F.Intrinsic.Control.EndIf

'-- 7. Hide wait indicator
Gui.<Form>.gsGC.HideWait

F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("RefreshData_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    Gui.<Form>.gsGC.HideWait
    F.Intrinsic.String.Build("Project: <filename>.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(<FormUnload>)
F.Intrinsic.Control.EndIf
Program.Sub.RefreshData.End
```

**Critical rules:**
- **Serialize before rebuild, Deserialize after** -- preserves the user's column widths, sort, filter, and grouping across refreshes.
- **BlockEvents** wraps the entire data rebuild to prevent `CellValueChanged`, `FocusedRowChanged`, etc. from firing during grid reconstruction.
- **Always UnBlockEvents in the error handler** -- if an error occurs during refresh, events must still be unblocked or the form becomes unresponsive. Also hide the wait indicator in the error handler.
- **For single-cell edits**, avoid full refresh -- update the DB row directly, then update the in-memory DataTable cell with `F.Data.DataTable.SetValue("dtName", rowIndex, "ColName", value)` and rebind the grid. Full rebuild is only needed when the data source has changed externally.

## Event Handler Pattern

Event handler subroutines (Click, CellValueChanged, RowCellClick, etc.) require additional discipline compared to regular subroutines:

### Grid Event Handler Template
```
Program.Sub.gsGC_RowCellClick.Start
F.Intrinsic.Control.SetErrorHandler("gsGC_RowCellClick_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sCol.Declare(String,"")
V.Local.sError.Declare(String,"")

F.Intrinsic.Control.BlockEvents

V.Local.sCol.Set(V.Args.Column)

F.Intrinsic.Control.SelectCase(V.Local.sCol)
    F.Intrinsic.Control.Case("ACTION_COL")
        '... handle action column click ...
    F.Intrinsic.Control.Case("DETAIL_COL")
        '... handle detail column click ...
    F.Intrinsic.Control.CaseElse
        '... default behavior or no-op ...
F.Intrinsic.Control.EndSelect

F.Intrinsic.Control.UnBlockEvents
F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("gsGC_RowCellClick_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.UnBlockEvents
    F.Intrinsic.String.Build("Project: <filename>.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}",V.Ambient.NewLine,V.Ambient.CurrentSubroutine,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
    F.Intrinsic.Control.CallSub(<FormUnload>)
F.Intrinsic.Control.EndIf
Program.Sub.gsGC_RowCellClick.End
```

**Key rules:**
- **BlockEvents after variable declarations, UnBlockEvents at every exit path** -- including early returns and error handlers. Forgetting `UnBlockEvents` in the error handler will freeze the UI. Declare all locals first, then call `BlockEvents`.
- **Use SelectCase on V.Args.Column** to dispatch grid cell clicks to the correct handler logic.
- **Copy V.Args values to local variables first** before branching -- V.Args values are volatile and may change if events fire during processing.

### Centralized Error Handler Pattern

For scripts with many subroutines, use a centralized error handler to avoid code duplication. This is one of the few places where `Try/Catch` is appropriate -- the ErrorMessage sub is a leaf subroutine that does not call other subroutines, so there is no nesting risk. The `Try/Catch` here silently absorbs any error in the error handler itself to prevent infinite recursion.

```
Program.Sub.ErrorMessage.Start
F.Intrinsic.Control.Try

F.Intrinsic.Control.If(V.Global.bError)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
V.Global.bError.Set(True)

V.Local.sError.Declare(String,"")
F.Intrinsic.String.Build("Project: <filename>.g2u{0}{0}Subroutine: {1}{0}Error: {2} - {3}",V.Ambient.NewLine,V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorNumber,V.Ambient.ErrorDescription,V.Local.sError)
F.Intrinsic.UI.Msgbox(V.Local.sError)

V.Global.bError.Set(False)

F.Intrinsic.Control.Catch
F.Intrinsic.Control.EndTry
Program.Sub.ErrorMessage.End
```

The `V.Global.bError` guard prevents infinite recursion if the error handler itself throws an error. The `Try/Catch` here is a **targeted use** -- it wraps only this leaf subroutine's body and the sub does not call other subs that use `Try/Catch`.

## Pixel Units (UsePixels is MANDATORY)

`F.Intrinsic.UI.UsePixels` is **required** as the first statement in Main for ANY script with a ScreenSU block. Twips are **never** used in new code. All `.Size()`, `.Position()`, and dimension values are in **pixels**.

There is no valid reason to omit UsePixels. If you see a legacy script without it, add it.

**All GUI scripts MUST begin Main with:**
```
F.Intrinsic.UI.UsePixels
```

For full GUI control creation, layout, and property reference, see `agents/gab/GUI.md` (index) and its sub-files.
