# GAB Hook System Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with hooks, V.Caller, V.Passed, or script launching
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

---

## HOW HOOKS WORK

1. GlobalShop fires a hook number (e.g., hook 1234) when a user triggers an action.
2. The runtime checks whether a script is associated with that hook.
3. The runtime creates a hook file (`.hf`) with context data.
4. The runtime loads the `.hf` file and executes the associated `.gas` script.
5. The script reads context via `Variable.Caller.*` and `Variable.Passed.*`.

---

## HOOK FILE (.hf) STRUCTURE

| Field | Description |
|-------|-------------|
| Script path | Path to the `.gas` script to run |
| Company code | Current company |
| Username | GlobalShop user |
| Hook number | Hook that triggered execution |
| Calling program | Executable name that invoked the hook |
| Calling program PID | Process ID of the calling program |
| Global directory | GlobalShop root directory |
| Plugins directory | Plugins folder path |
| Screen fields | Screen/context field values from the caller |
| Passed elements | Named values supplied by the calling program |
| Debug level | Active debug level |

**Notes:** Hook files are temporary. The runtime deletes them after loading (except in debug/IDE mode). The active hook file path is exposed in the `GSHOOKFILE` environment variable.

---

## CALLER VARIABLES (Variable.Caller.*)

For the full V.Caller table (52+ entries), see **`agents/gab/VARIABLES.md` > "V.Caller"**. The most commonly used in hooks:

| Variable | Hook Context |
|----------|--------------|
| `V.Caller.Hook` | Hook number that triggered this script -- use in `SelectCase` to dispatch |
| `V.Caller.CompanyCode` | Current company code |
| `V.Caller.User` | GlobalShop username |
| `V.Caller.Caller` | Name of the calling executable |
| `V.Caller.PID` | PID of the calling program |
| `V.Caller.GlobalDir` | GlobalShop root directory |
| `V.Caller.PluginsDir` | Plugins directory path |
| `V.Caller.ScriptFile` | Path to the current script file |
| `V.Caller.Debug` | Current debug level |
| `V.Caller.AccentColor` | Theme accent color |

> **Note:** Both `V.Caller.*` (short) and `Variable.Caller.*` (long) forms are valid. The short form is preferred in new code.
>
> Variable names verified against `VARIABLES.md` and production scripts.

### Discovery: ListCallerVars

`F.Intrinsic.Variable.ListCallerVars(sResult)` returns a `*!*`-delimited list of ALL caller variable names. Split and access dynamically:

```
V.Local.sCallerVars.Declare(String,"")
V.Local.sItems.Declare(String,"")
V.Local.i.Declare(Long,0)
F.Intrinsic.Variable.ListCallerVars(V.Local.sCallerVars)
F.Intrinsic.String.Split(V.Local.sCallerVars,"*!*",V.Local.sItems)
F.Intrinsic.Control.For(V.Local.i,0,V.Local.sItems.UBound,1)
    V.Local.sValue.Set(V.Caller.[V.Local.sItems(V.Local.i)])
F.Intrinsic.Control.Next(V.Local.i)
```

> **Note:** `V.Ambient.ItemList` enumerates V.Passed elements; `ListCallerVars` enumerates V.Caller variables. Both use `*!*` delimiter.

---

## PASSED ELEMENTS (Variable.Passed.*)

Passed elements are named values the calling program sends through the hook file. **Different hooks pass different elements.** Always verify presence before reading.

> **CRITICAL:** The set of `V.Passed` variables is **entirely determined by the calling hook point**. There is no universal list of `V.Passed` fields — each hook passes its own set of named elements. For example, one hook may pass `V.Passed.IPMHND` while another passes `V.Passed.IPMH`; these are different fields from different hooks, not aliases. **Never guess or assume which `V.Passed` fields are available.** The user must specify the hook number and its passed elements for the script being developed. Always use `F.Intrinsic.Variable.PassedExists` to guard access.

### V.Passed Naming Conventions

Analysis of 84 shipped GSS scripts reveals these V.Passed naming patterns. **The numbered elements (000xxx) are positional indices of screen controls from the calling program — the same number means a completely different field on every hook.** Only the special flags (777777, Cancel, etc.) have consistent meaning across all hooks.

| Pattern | Example | Meaning |
|---------|---------|---------|
| `000001`–`000NNN` | `V.Passed.000002` | **Hook-specific positional field** — index into the calling program's screen controls. What `000002` IS depends entirely on which hook fired. No universal mapping exists. |
| `SHP700S5_000002` | `V.Passed.SHP700S5_000010` | **Screen-qualified positional field** — Screen ID + Section + Field index. More self-documenting than bare numbers but still hook-specific. |
| Named string | `V.Passed.Order`, `V.Passed.PART` | Explicit named passes — self-documenting, domain-specific values |
| `777777` | `V.Passed.777777` | **Override flag** (universal) — set to nonzero to override core behavior (see `HookCD.IsOverrideSupported`) |
| `Cancel` | `V.Passed.Cancel` | **Cancel flag** (universal) — set to nonzero to cancel the calling operation (see `HookCD.IsCancelSupported`) |
| `GAB` | `V.Passed.GAB` | GAB engine identifier flag |
| `FIRST` | `V.Passed.FIRST` | First-invocation flag (often true on first hook fire in a session) |
| `009000`–`009005` | `V.Passed.009000` | Grid/tab section indices (often tied to grid-level hooks — still hook-specific) |
| `008000`–`008002` | `V.Passed.008000` | Secondary section indices (hook-specific) |
| `ResultsCacheKey` | `V.Passed.ResultsCacheKey` | Cache key (universal) — set this to have the runtime cache results instead of re-invoking GAB next time |

### V.Passed Elements by Shipped Script (Reference Examples)

The following shipped scripts demonstrate which V.Passed elements are available at their respective hook points. Use these as reference when developing against similar hooks:

| Script | V.Passed Count | Key Elements |
|--------|---------------|--------------|
| `ATG_SI_Address_Validation.g2u` | 51 | Positional fields (000001–000360), `SHP700S5_*` screen fields, `FIRST`, `SOFTWARE`, `VALIDSHIPADDRESS` |
| `ATG_SI_Ship_Session.g2u` | 45 | Shipping data: `SHIPTOADRS1/2`, `SHIPTOCITY/STATE/ZIP`, `CARRIERNAME/ADDR/PHONE`, `MSTRTRACKINGNO`, `PACKINGNO` |
| `GAB_5326_PO_APPROVAL_REQ.g2u` | 25 | PO fields: positional (000002–000115), section indices (008000–009001), `Cancel`, `GAB` |
| `GSS_GAF.g2u` | 20 | Named context: `BEG`, `END`, `HOOK`, `MODE`, `ORDER`, `PART`, `PO`, `WO`, `QUOTE`, `SCRIPT`, `TRANSID` |
| `ATG_CC_Processing.g2u` | 20 | CC fields: `CARDNO`, `CARDNAME`, `CCTYPE`, `CVV2CODE`, `EXPIREDT`, `AMOUNT`, `ORDER`, `TID` |
| `GAB_4912_UserFields.g2u` | 9 | Positional fields (000003–000190), `ResultsCacheKey` |
| `GAB_GUI_StartJobSeqComment_5975.g2u` | 6 | Named: `Job`, `Sequence`, `ScanJob`, `ScanSeq`, `ScanSuffix`, `MainFormView` |
| `GAB_SFDC_ScanBadge.g2u` | 3 | `ScanData`, `ReturnEmployeeID`, `ReturnErrorMessage` |

> **The full V.Passed catalog for all 84 scripts is at `tools/vpassed_catalog.json`.**

### Dynamic V.Passed Access (Bracket Syntax)

V.Passed elements can be accessed dynamically using bracket notation when the element name is in a variable. This is essential for discovery/exploration scripts that enumerate passed elements at runtime.

```
'-- Split V.Ambient.ItemList (delimiter is *!*) to get all element names
F.Intrinsic.String.Split(V.Ambient.ItemList,"*!*",V.Local.sItems)

'-- Iterate and access each element dynamically
F.Intrinsic.Control.For(V.Local.i,0,V.Local.sItems.UBound,1)
    V.Local.sName.Set(V.Local.sItems(V.Local.i))
    V.Local.sValue.Set(V.Passed.[V.Local.sName])
    V.Local.sType.Set(V.Passed.[V.Local.sName].DataType)
    V.Local.sLength.Set(V.Passed.[V.Local.sName].Length)
    V.Local.sHwnd.Set(V.Passed.[V.Local.sName].HWnd)
    V.Local.sLocked.Set(V.Passed.[V.Local.sName].Locked)
    V.Local.sHidden.Set(V.Passed.[V.Local.sName].Hidden)
    V.Local.sNoChange.Set(V.Passed.[V.Local.sName].NoChange)
    V.Local.sTabStop.Set(V.Passed.[V.Local.sName].TabStop)
F.Intrinsic.Control.Next(V.Local.i)
```

Available dynamic properties (all property reads, no parentheses):

| Property | Returns | Description |
|----------|---------|-------------|
| `V.Passed.[var]` | String | The element's current value |
| `V.Passed.[var].DataType` | String | Type code: `N`=Numeric, `D`=Date, `BR`=Browser, etc. |
| `V.Passed.[var].Name` | String | The element's display name/label |
| `V.Passed.[var].Length` | String | Maximum field length |
| `V.Passed.[var].HWnd` | String | Window handle of the UI control |
| `V.Passed.[var].Locked` | String | Whether the control is locked/read-only |
| `V.Passed.[var].Hidden` | String | Whether the control is hidden |
| `V.Passed.[var].NoChange` | String | Whether the value is read-only to the hook |
| `V.Passed.[var].TabStop` | String | Whether the control participates in tab order |

> **Source:** Pattern discovered in shipped `GABScreenConfig.gas`. The `V.Ambient.ItemList` delimiter is `*!*`.

> **Tool:** `test/GAB_HookExplorer.g2u` uses this pattern to silently catalog all V.Passed elements into the `GAB_HOOK_EXPLORER` database table. Bind it to any hook and it auto-discovers the elements.

**Check-first pattern (static access):**

```
V.Local.sOrderId.Declare(String)
V.Local.bHasPassed.Declare(Boolean)
F.Intrinsic.Variable.PassedExists("OrderId",V.Local.bHasPassed)
F.Intrinsic.Control.If(V.Local.bHasPassed)
    V.Local.sOrderId.Set(V.Passed.OrderId)
F.Intrinsic.Control.EndIf
```

---

## HOOK DISPATCH PATTERN

Use `SelectCase` on the hook number when one script handles multiple hooks. The hook numbers in the dispatch must match the hook associations configured for the script -- always get the correct hook numbers from the user or from `agents/hooks/*.md` documentation rather than guessing:

```
F.Intrinsic.Control.SelectCase(V.Caller.Hook)
    F.Intrinsic.Control.Case("38120")
        F.Intrinsic.Control.CallSub(HandlePreOnlineUpdate)
    F.Intrinsic.Control.Case("50610")
        F.Intrinsic.Control.CallSub(HandleSFDC)
    F.Intrinsic.Control.CaseElse
        F.Intrinsic.Control.CallSub(HandleDefault)
F.Intrinsic.Control.EndSelect
```

---

## HOOK ASSOCIATION MANAGEMENT

> **Full signature:** `AddHookSequenceAssociation` has **10 parameters**. See `agents/gab/API_MISC.md` > Global.Hook for the complete signature:
> `F.Global.Hook.AddHookSequenceAssociation(HookNumber, SyncFlag, ScriptPath, ScriptName, TraceSeqFlag, ScriptType, Runtime, Notes, WidgetFlag, ReturnVariable)`

Verified usage from `test/GAB_HookExplorerDeploy.g2u`:

```
F.Global.Hook.AddHookSequenceAssociation(V.Local.sHookId,False,V.Global.sExplorerPath,V.Global.sExplorerName,False,"V2",2,"Hook Explorer - auto-catalogs V.Passed","",V.Local.iResult)
```

Other hook management APIs:

```
F.Global.Hook.UpdateHookSequenceAssociation(iHookNumber,iSequence,sScriptPath)
F.Global.Hook.ReadPassedElement(sElementName,sResult)
F.Global.General.IsHookActive(iHookNumber,bResult)
F.Global.General.FireHook(iHookNumber,sHookData)
```

**Note:** When multiple scripts are bound to the same hook, they run in **sequence order** (lower sequence numbers first).

---

## PASSING DATA BETWEEN PROGRAMS

**Caller** sets data before launching another program:

```
F.Global.General.SetPassedDataElement("OrderId",V.Local.sOrderId)
F.Global.General.SetPassedDataElement("Action","EDIT")
F.Global.General.CallWrapperSync(sProgramPath,sHookData,sResult)
```

**Callee** reads what was passed (always guard with `PassedExists`):

```
V.Local.sOrderId.Declare(String)
V.Local.sAction.Declare(String)
V.Local.bExists.Declare(Boolean)
F.Intrinsic.Variable.PassedExists("OrderId",V.Local.bExists)
F.Intrinsic.Control.If(V.Local.bExists)
    V.Local.sOrderId.Set(V.Passed.OrderId)
F.Intrinsic.Control.EndIf
F.Intrinsic.Variable.PassedExists("Action",V.Local.bExists)
F.Intrinsic.Control.If(V.Local.bExists)
    V.Local.sAction.Set(V.Passed.Action)
F.Intrinsic.Control.EndIf
```

Call `F.Global.General.ResetPassedDataElements()` before a new call to avoid stale values.

### Program Launch Methods

| Method | Description |
|--------|-------------|
| `F.Global.General.CallWrapperSync(sProgramPath, sHookData, sResult)` | Launches a program synchronously (blocks until it returns) |
| `F.Global.General.CallWrapperAsync(sProgramPath, sHookData, sResult)` | Launches a program asynchronously (returns immediately) |
| `F.Global.General.CallSyncGAS(sGASFile, sHookFile, sResult)` | Runs a compiled `.gas` file synchronously |
| `F.Global.General.CallAsyncGAS(sGASFile, sHookFile, sResult)` | Runs a compiled `.gas` file asynchronously |
| `F.Global.General.GetPassedIdFromHandle(iHandle, sResult)` | Gets the passed data ID from a window handle |

---

## PASSED VARIABLE METHODS (Variable.Passed.*var.*)

These are the grouped methods available on any `V.Passed.*` variable. They include both the standard inline variable properties (shared with V.Local, V.Global, etc.) and hook-specific metadata properties unique to V.Passed.

### Hook-Specific Metadata Properties

These properties are **unique to V.Passed** and return metadata about the passed element from the calling program's context.

> **Note:** V.Passed metadata reads are **properties without parentheses**. Using `()` will cause Error 113.

#### Hidden
Returns the hidden state of the passed element's UI control.
```
V.Passed.ElementName.Hidden
```

#### HWnd
Returns the window handle (HWND) of the passed element's UI control.
```
V.Passed.ElementName.HWnd
```

#### IID()
Returns the internal identifier (IID) of the passed element.
```
V.Passed.ElementName.IID()
```

#### Locked
Returns the locked state of the passed element's UI control.
```
V.Passed.ElementName.Locked
```

#### Length
Returns the maximum length constraint of the passed element.
```
V.Passed.ElementName.Length
```

#### Name
Returns the name of the passed element.
```
V.Passed.ElementName.Name
```

#### NoChange
Returns the no-change flag of the passed element (indicates whether the value is read-only to the hook).
```
V.Passed.ElementName.NoChange
```

#### TabStop
Returns the tab-stop state of the passed element's UI control.
```
V.Passed.ElementName.TabStop
```

#### DataType
Returns the data type of the passed element.
```
V.Passed.ElementName.DataType
```

### Standard Inline Properties (Shared with All Variable Scopes)

These properties work the same as on `V.Local`, `V.Global`, etc. See `agents/AGENTS.GAB.md` for full descriptions.

#### Set(Value [, Hook#])
Assigns a value to the passed element. The optional Hook# parameter enables cross-program set.
```
V.Passed.ElementName.Set("NewValue")
V.Passed.ElementName.Set("NewValue", V.Local.iHookNumber)
```

#### Append(Expression)
Appends a value to the passed element in-place.
```
V.Passed.ElementName.Append(V.Local.sAdditionalText)
```

#### Type Conversion
```
V.Passed.ElementName.String()              ' Convert to string
V.Passed.ElementName.Long()                ' Convert to long integer
V.Passed.ElementName.Float()               ' Convert to float (double)
```

#### String Manipulation
```
V.Passed.ElementName.Trim()                ' Trim both ends
V.Passed.ElementName.LTrim()               ' Trim leading spaces
V.Passed.ElementName.RTrim()               ' Trim trailing spaces
V.Passed.ElementName.UCase()               ' Uppercase
V.Passed.ElementName.LCase()               ' Lowercase
V.Passed.ElementName.PCase()               ' Proper case (Title Case)
V.Passed.ElementName.Length()              ' String length
V.Passed.ElementName.Left1                 ' Left 1 character (Left2, Left3, Left4 also available)
V.Passed.ElementName.Right1                ' Right 1 character (Right2, Right3 also available)
```

#### Validation
```
V.Passed.ElementName.IsDate()              ' True if value is a valid date
V.Passed.ElementName.IsNumeric()           ' True if value is numeric
```

#### Formatting & Date
```
V.Passed.ElementName.Format*()             ' Format value (general; * = format specifier)
V.Passed.ElementName.DateComp()            ' Date comparison value (sortable)
V.Passed.ElementName.TimeComp()            ' Time comparison value (sortable)
V.Passed.ElementName.PercentToDecimal()    ' Convert percentage to decimal (25 -> 0.25)
```

#### Database Escaping
```
V.Passed.ElementName.PSQLFriendly          ' Escape single quotes for Pervasive SQL
V.Passed.ElementName.SQLServerFriendly     ' Escape single quotes for SQL Server
```

#### Boolean / Array
```
V.Passed.ElementName.Not()                 ' Boolean negation
V.Passed.ElementName.UBound()              ' Array upper bound
V.Passed.ElementName.LBound()              ' Array lower bound
V.Passed.ElementName.Redim(iLower, iUpper)           ' Resize array
V.Passed.ElementName.RedimPreserve(iLower, iUpper)   ' Resize preserving data (args optional)
```

### Quick Reference Table

| Method | Category | Description |
|--------|----------|-------------|
| `.Append(expr)` | Mutation | Append value in-place |
| `.DateComp()` | Formatting | Sortable date value |
| `.Float()` | Conversion | Convert to float |
| `.Format*()` | Formatting | Format value |
| `.Hidden` | **Hook metadata** | UI hidden state (property, no `()`) |
| `.HWnd` | **Hook metadata** | Window handle (property, no `()`) |
| `.IID()` | **Hook metadata** | Internal identifier |
| `.IsDate()` | Validation | True if valid date |
| `.IsNumeric()` | Validation | True if numeric |
| `.LBound()` | Array | Lower bound |
| `.LCase()` | String | Lowercase |
| `.Left#()` | String | Left N characters |
| `.Length()` | String | String length (method on value) |
| `.Length` | **Hook metadata** | Max length constraint (property, no `()`) |
| `.Locked` | **Hook metadata** | UI locked state (property, no `()`) |
| `.Long()` | Conversion | Convert to long |
| `.LTrim()` | String | Left trim |
| `.Name` | **Hook metadata** | Element name (property, no `()`) |
| `.NoChange` | **Hook metadata** | Read-only flag (property, no `()`) |
| `.Not()` | Boolean | Negation |
| `.PCase()` | String | Proper case |
| `.PercentToDecimal()` | Conversion | Percentage to decimal |
| `.PSQLFriendly` | Escaping | Escape for Pervasive SQL |
| `.Redim(lo,hi)` | Array | Resize array |
| `.RedimPreserve(lo,hi)` | Array | Resize preserving data |
| `.Right#()` | String | Right N characters |
| `.RTrim()` | String | Right trim |
| `.Set(val [,hook#])` | Mutation | Assign value |
| `.SQLServerFriendly` | Escaping | Escape for SQL Server |
| `.String()` | Conversion | Convert to string |
| `.TabStop` | **Hook metadata** | Tab-stop state (property, no `()`) |
| `.TimeComp()` | Formatting | Sortable time value |
| `.Trim()` | String | Trim both ends |
| `.DataType` | **Hook metadata** | Data type (property, no `()`) |
| `.UBound()` | Array | Upper bound |
| `.UCase()` | String | Uppercase |

---

## PRECALLEREXIT / POSTCALLEREXIT EVENTS

The runtime recognizes these subroutine names by parsing source. They tie to `Variable.Caller.PID` monitoring.

```
Program.Sub.PreCallerExit.Start
    ' Fires when the calling program's PID is no longer running
    ' Use for cleanup before the caller disappears
Program.Sub.PreCallerExit.End

Program.Sub.PostCallerExit.Start
    ' Fires after the calling program has exited
Program.Sub.PostCallerExit.End
```

---

## SIGNATURE VALIDATION

| Status | Meaning |
|--------|---------|
| GSSSignature | Signed by GlobalShop (internal/official) |
| CustomerSignature | Signed by a customer developer |
| NoSignature | No `.sig` file found (blocked in production) |
| Invalid | Signature does not match script (blocked) |

Every `.gas` file needs a companion `.sig` file (32-character MD5-like hash). Scripts without a valid signature do not run outside the IDE/debug mode.

```
F.Global.General.CheckSig(sFilePath,sResult)
F.Global.General.SignGAS(sFilePath,sSignature)
F.Global.General.GetScriptOrigin(sResult)
```

---

## ANTI-PATTERNS

- **Never** assume specific passed elements exist — always use `PassedExists`.
- **Never** guess or invent hook numbers — always get hook numbers from the user or from `agents/hooks/*.md` documentation. Hook numbers in `SelectCase` dispatch are expected (they match the script's configured hook associations), but the numbers themselves must come from an authoritative source.
- **Never** edit hook files manually — the runtime owns their lifecycle.
- **Never** ignore signature requirements — unsigned scripts fail in production.
- **Always** plan for the caller exiting — use `PreCallerExit` / `PostCallerExit` for cleanup.

