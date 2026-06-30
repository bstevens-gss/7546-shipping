---
AGENT_TITLE: GAB Coding Agent
AGENT_DESCRIPTION: Language reference and coding rules for Global Shop Solutions GAB (.g2u and .lib) scripting.
AGENT_USAGE: Load when writing or editing GAB scripts (.g2u), libraries (.lib), or any GAB/Global Shop scripting work.
---

# GAB (Global Application Builder) Coding Agent
# Language Reference & Coding Rules for .g2u Files

GAB is Global Shop Solutions' proprietary RAD scripting language for ERP customization.
Files use the `.g2u` extension. Libraries use `.lib` (same syntax, no ScreenSU block).

---

# CRITICAL RULES -- BEHAVIORAL MANDATES

These rules govern agent behavior when writing GAB code. They address meta-failures (hallucinated APIs, skipped verification, ignored references) that cause cascading debug cycles. Violation of these rules wastes significant user time.

1. **NEVER invent APIs.** If you have not seen the method/function/property explicitly documented in `agents/gab/*.md` reference files, it DOES NOT EXIST. GAB is proprietary with zero public documentation. A plausible-sounding API name is almost certainly wrong. When in doubt, search the reference files first. If not found, ASK the user.

2. **ALWAYS read PITFALLS.md BEFORE writing new code.** Every new subroutine, every DataTable operation, every grid binding, every event handler has known traps. Load `agents/gab/PITFALLS.md` before starting. This is not optional.

3. **ALWAYS consult reference scripts before writing new code.** Follow the Reference Script Discovery hierarchy (see section below): search GitHub orgs first, then the local Global Directory, then the workspace. Production `.g2u` files contain battle-tested patterns that should be adapted, not reinvented. When you find a relevant script, read it and use its patterns. Do NOT skip this step and invent from the docs alone.

4. **ALWAYS use /gab-lint AND /gab-validate before signing.** Run the pattern-based lint skill (`gab-lint.ps1`) AND the allowlist API validator (`Validate-GabApi.ps1`) on your code before entering the test-debug cycle. The pattern linter catches known anti-patterns; the allowlist validator catches ANY invalid API call, variable, or namespace using a registry extracted directly from the OCTSRS runtime source code. Never skip either step.
   ```powershell
   # Pattern-based lint
   powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gab-agents\skills\gab-lint\scripts\gab-lint.ps1" -Path "<file.g2u>"
   # Allowlist API validation
   powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gab-agents\tools\Validate-GabApi.ps1" -Path "<file.g2u>"
   ```

5. **ALWAYS use /gab-sign for signing.** Never hand-roll the signature algorithm. The signing uses MD5 + a specific salt + `Encoding.Default` encoding. Use the `gab-sign` skill which handles this correctly.

6. **NEVER present untested code as working.** TDD-GAB means: sign, launch via .gaf with the `octsrs.logging` sentinel enabled, verify native trace output in `%TEMP%\GSS\` shows clean execution OR confirm the window title appears in the process list, THEN present to the user. Use `F.Intrinsic.Debug.*` methods (SetLA, EnableLogging, DumpVariableList) for targeted diagnostics -- do NOT inject custom DebugLog subroutines as a first step (that is a last resort). If you cannot verify, say so explicitly -- do NOT claim "it should be up" or "the form is ready" without evidence.

7. **NEVER guess SQL table or column names.** Always check `agents/schema/*.md` or query the database. Wrong table names cause silent failures that waste entire debug cycles.

---

# GAB CODING PROTOCOL (Mandatory Workflow)

This protocol must be followed for EVERY subroutine you write. It prevents the #1 cause of wasted time: invented APIs that pass a casual eye review but crash at runtime.

## Per-Subroutine Checklist

1. **Consult COOKBOOK.md** → Find the closest matching task entry. Use its pattern as your starting point.
2. **Check CHEATSHEET.md §1** → Verify you're not violating any syntax rules (inline math, concat, delimiters).
3. **Write the code** → Using patterns from step 1 and syntax rules from step 2.
4. **Run Validate-GabApi.ps1** → Every `F.Namespace.Nominative.Method` call must pass the allowlist. Fix any failures BEFORE proceeding.
5. **Run Validate-ScreenSU.ps1** (if GUI script) → Catches silent-crash bugs (invalid control types, wrong events, Text/Caption confusion).
6. **Run gab-lint.ps1** → Catches structural anti-patterns (nested Try, missing Close, etc.).
7. **Sign + TDD launch** → Only after steps 4-6 pass clean.

## COMMONLY INVENTED APIs (NEVER use these)

These are APIs that agents REPEATEDLY hallucinate. They DO NOT EXIST. The correct alternatives are shown.

| Invented (WRONG) | Correct Alternative | Notes |
|-------------------|--------------------|-|
| `Tab.AddPage()` / `Tab.AddTab()` | `.Tabs(N)` + `.SetTab(i)` + `.Caption("text")` | Set total count, then configure each |
| `F.Intrinsic.String.Find()` | `F.Intrinsic.String.IsInString(haystack,needle,caseIns,bResult)` | Boolean check; for position use `InStr` |
| `SetColumnVisible("gv","col",True)` | `SetColumnProperty("gv","col","Visible",True)` | Generic property setter |
| `GetRowCount()` | `V.DataTable.dt.RowCount` | Property read, no parens |
| `Tab.GetTab()` / `Tab.ActiveTab` | `V.Screen.form!tab.Tab` | Property read via V.Screen |
| `ArgToVar(x,y)` for simple args | `V.Args.argName` | Direct read; ArgToVar is for legacy/complex only |
| `.Text("label")` on Button/Label | `.Caption("label")` | Text is for TextBox/ComboBox only |
| `F.Intrinsic.Math.Add(a,b)` (2 args) | `F.Intrinsic.Math.Add(a,b,result)` | ALL math ops require 3 args (result var) |
| `String.Build("literal",sResult)` | `V.Local.s.Set("literal")` | Build requires {N} placeholders + subs |
| `.DataSource("dt")` for initial bind | `.AddGridviewFromDatatable("dt","gv")` + `.MainView("gv")` | DataSource is for REFRESH only (after initial bind) |
| `OnClick` / `OnChange` / `OnTimer` | `Click` / `Change` / `Timer` | Drop the "On" prefix in all event names |
| `F.Intrinsic.Control.SetDebugLevel()` | `F.Intrinsic.Debug.SetLA()` + `EnableLogging` | SetDebugLevel pops a BLOCKING dialog |
| `GetFocusedRowHandle("gv",outVar)` | Use `V.Args.RowIndex` / `V.Args.FocusedRowHandle` from events | Method does not exist; row comes from event args |
| `RefreshDataSource("gv")` | `.DataSource("dtName")` | Re-bind to refresh; RefreshDataSource is invented |
| `F.Intrinsic.Debug.SetErrorTimeout(N)` | (no alternative) | Not implemented in OCTSRS 2023.x; causes ERROR 1500 |
| `V.Ambient.LocalAppData` | `V.Caller.LocalGSSTempDir` | V.Ambient.LocalAppData doesn't exist; use V.Caller |
| `RemoveGridView("gv")` | `F.Data.DataTable.Close("dt")` | Grid clears when DT closes; no RemoveGridView method |
| `GetSelectedRowsInFocus("gv",outVar)` | `GetSelectedRowsInFocus(outVar)` | Only 1 arg (no gv name); returns comma-sep row indices |
| `SelectAll` / `UnselectAll` | `SetGridViewProperty("gv","SelectAll",True/False)` | Property, not standalone method |
| `ShowAutoFilterRow` / `SelectionCheckbox` | `SetGridViewProperty("gv","OptionsViewShowAutoFilterRow",True)` | Use OptionsView prefix properties |
| `GetSelectedRowHandles(outVar)` | `GetSelectedRowsInFocus(outVar)` | Correct name is GetSelectedRowsInFocus |
| `DataView.Filter(dv,expr)` | `F.Data.DataView.SetFilter("dtName","dvName","expr")` | No `Filter` method -- use `SetFilter` (3 args: dt, dv, expression) |
| `V.Args.RowHandle` (in RowCellClick) | `V.Args.RowIndex` | RowHandle is for FocusedRowChanged only |
| `FocusCell("gv",row,"colName")` | `FocusCell("gv",row,colIndex)` | 3rd param is integer column INDEX, never string name |
| `OpenRecordsetRO` / `OpenRecordsetRW` | `F.Data.DataTable.CreateFromSQL("dt","con",sql,True)` | **BANNED** -- recordsets prohibited; use DataTable for all queries |
| `OpenLocalRecordsetRO` / `OpenLocalRecordsetRW` | `F.Data.DataTable.CreateFromSQL("dt","con",sql,True)` | **BANNED** -- local recordsets prohibited; DataTable handles all cases |
| `V.ODBC.con!rst.FieldVal!COL` | `V.DataTable.dt(row).COL!FieldVal` | **BANNED** -- recordset field access; use DataTable row accessor |
| `V.ODBC.con!rst.MoveNext` / DoUntil loop | `For/Next` loop over `V.DataTable.dt.RowCount--` | **BANNED** -- row-by-row iteration uses DataTable row index |
| `F.ODBC.Connection!con.CloseRecordsets` | `F.Data.DataTable.Close("dt")` | **BANNED** -- no recordsets to close; close DataTable instead |

---

# MANDATORY REFERENCE FILES

**You MUST load COOKBOOK.md and CHEATSHEET.md BEFORE writing ANY GAB code.** This is not optional.

| File | Purpose | When to load |
|------|---------|--------------|
| `agents/gab/COOKBOOK.md` | Task → correct code snippet (~95 entries) | **MANDATORY before writing code** |
| `agents/gab/CHEATSHEET.md` | One-page syntax + signatures + controls | **MANDATORY before writing code** |
| `agents/gab/ERROR_CODES.md` | Error number → diagnosis → fix | When debugging runtime errors |
| `agents/gab/MCP_REFERENCE.md` | Full MCP intelligence documentation | When MCP tiebreaker needed |

---

# REFERENCE SCRIPT DISCOVERY

Before writing GAB code for any non-trivial task, search for production scripts that already do something similar. Follow this hierarchy -- stop at the first level that yields a useful match:

## Level 1: GitHub Organizations (Primary)

Search GSS's GitHub orgs for `.g2u` files matching the task domain. These orgs contain customer-deployed production scripts:

| Org | Contents |
|-----|----------|
| `Global-Shop-Solution-GAB` | Official GSS GAB examples and customer solutions |
| `GSS-Custom` | Custom GAB projects for specific customers |
| `GlobalShopSolutionsR-D-Hack-A-Thon` | R&D hackathon projects (experimental) |

**Search by keyword** (e.g., looking for BOM-related scripts):
```powershell
gh api "search/code?q=extension:g2u+org:Global-Shop-Solution-GAB+BOM" --jq '.items[] | "\(.repository.full_name) \(.path)"'
```

**Search both orgs at once:**
```powershell
gh api "search/code?q=extension:g2u+org:Global-Shop-Solution-GAB+<keyword>" --jq '.items[] | "\(.repository.full_name) \(.path)"'
gh api "search/code?q=extension:g2u+org:GSS-Custom+<keyword>" --jq '.items[] | "\(.repository.full_name) \(.path)"'
```

**Fetch a specific file for reading:**
```powershell
gh api "repos/<owner>/<repo>/contents/<path>" --jq '.content' | [System.Convert]::FromBase64String((gh api "repos/<owner>/<repo>/contents/<path>" --jq '.content') -replace "`n","") | [System.Text.Encoding]::UTF8.GetString($_)
```

Or clone the repo temporarily, read the file, and clean up:
```powershell
gh repo clone <owner>/<repo> -- --depth 1 --filter=blob:none
# read the file
Remove-Item -Recurse -Force <repo>
```

## Level 2: Local Global Directory (Fallback)

If GitHub is unavailable or the search yields no results, scan the local GSS installation for `.g2u` and `.gas` files. The paths come from `AGENTS.PROJECT.md`:

| Path | What's There |
|------|-------------|
| `<GlobalDir>\PLUGINS\gab\gas\` | Shipped GAB scripts (`.g2u`, `.gas`, `.lib`) -- GSS-provided |
| `<GlobalDir>\PLUGINS\gab\` | GAB libraries and tools |
| `<GlobalDir>\PLUGINS\` | Broader plugin directory including GAB subdirectories |

```powershell
# Find .g2u files matching a keyword in the GAS directory
Get-ChildItem -Path "C:\APPS\GLOBAL\PLUGINS\gab\gas" -Filter "*.g2u" -Recurse |
    Select-String -Pattern "<keyword>" -List |
    Select-Object -ExpandProperty Path
```

The Global Directory path is machine-specific -- read it from `AGENTS.PROJECT.md` (Environment table, "Global Directory" row). If `AGENTS.PROJECT.md` is not configured, check for the `GSSPATH` environment variable or default to `C:\APPS\GLOBAL`.

## Level 3: Workspace (Always Available)

Check the current workspace for reference scripts:
- `test/` directory -- test and demo scripts
- Any `.g2u` files the user has open or recently referenced
- Neighboring project folders under the user's workspace root

## When to Search

- **New script from scratch**: Always search Level 1 + 2 for similar scripts in the same domain (BOM, shipping, invoicing, etc.)
- **New feature in existing script**: Search for the specific API pattern (e.g., "CallWrapperSync 300011", "GsWebView2", "AddRelation")
- **Unknown SQL tables/columns**: Search for scripts that query the same area
- **Unfamiliar control or event**: Search for usage examples before inventing patterns
- **Debugging a pattern mismatch**: Compare your code against production scripts that work

---

# SUB-AGENT ROUTING

Detailed API reference is split into focused sub-files in the `agents/gab/` directory.
**Read the relevant sub-file(s) based on what the task requires:**

| When you need... | Read this file |
|------------------|----------------|
| Variables, control flow, error handling, coding conventions, naming, patterns | `agents/gab/CORE.md` |
| V.Ambient, V.Caller, V.Args, V.Color, V.ASCII, V.Screen, V.ODBC tables | `agents/gab/VARIABLES.md` |
| V.Enum catalog (all enum types and values) -- **read TOC first, then only the sections you need** | `agents/gab/ENUMS.md` |
| String/Math/Date operations, ODBC, DataTable, DataView, Dictionary, LINQ, UDTs (legacy), StringBuilder | `agents/gab/DATA.md` (index) → `DATA_STRING.md`, `DATA_ODBC.md`, `DATA_DATATABLE.md`, `DATA_MISC.md` |
| GUI form creation, all control types, events, context menus, UI dialogs, mobile patterns | `agents/gab/GUI.md` (index) → `GUI_FORMS.md`, `GUI_CONTROLS.md`, `GUI_ADVANCED_CONTROLS.md`, `GUI_EVENTS.md`, `GUI_DIALOGS.md` |
| GsGridControl properties, column formatting, grid operations, layout persistence | `agents/gab/GRID.md` |
| HTTP/REST/JSON/XML/SOAP/SFTP/FTP/IMAP/OAuth/Serial, network, printer, debug, task, .NET automation, libraries | `agents/gab/API.md` (index) + `agents/gab/API_*.md` topic files |
| Hooks, hook files (.hf), V.Caller, V.Passed, script launch, signatures | `agents/gab/HOOKS.md` |
| File I/O (handle-based, binary, append, metadata, paths), Excel, PDF, Word, ZIP, BDF, image | `agents/gab/IO.md` |
| CallWrapper classes (Accounting, Inventory, Manufacturing, Purchasing, Sales, Quality, Support) | `agents/gab/CALLWRAPPERS.md` (index) → `agents/gab/CW_*.md` module files |
| GlobalShop ERP integration, security, entity objects, workflow, shipping, mobile, registry, scanner, mapper, GSSUI | `agents/gab/INTEGRATION.md` |
| .NET DLL integration (creating DLLs for GAB, C# project setup, class design, build, deployment) | `agents/gab/DLL.md` |
| Anti-patterns, critical runtime behaviors, syntax traps, error handling patterns, known pitfalls | `agents/gab/PITFALLS.md` |
| Complete code patterns (form, grid, hook) for use as scaffolding when generating new scripts | `agents/gab/PATTERNS.md` |

**For comprehensive tasks (new g2u file, full-feature script), read ALL sub-files.**
**For focused tasks (e.g., "add a grid"), read only the relevant ones (GUI + GRID).**
**Always load `agents/gab/PITFALLS.md` when writing new subroutines, error handling, or debugging runtime issues.**
**When generating a new .g2u file from scratch**, always load `agents/gab/PATTERNS.md` in addition to the recipe files. Use the matching pattern (Form, Grid, or Hook) as scaffolding and adapt it to the user's requirements.

## Task Recipes

When the user's request maps to a common task pattern, load this pre-mapped file bundle instead of guessing which sub-files apply. PITFALLS is included in every recipe.

| Task | Load these files | Cross-load (other Tier 2) |
|------|-----------------|--------------------------|
| **New standalone form** | CORE, GUI_FORMS, GUI_CONTROLS, GUI_EVENTS, PATTERNS, PITFALLS | -- |
| **Form with editable grid** | CORE, GUI_FORMS, GUI_CONTROLS, GUI_EVENTS, GRID, DATA_DATATABLE, PATTERNS, PITFALLS | AGENTS.GSSDB.md if querying GSS tables |
| **Read-only report grid** | CORE, GUI_FORMS, GRID, DATA_DATATABLE, DATA_ODBC, PITFALLS | AGENTS.ZEN.md + AGENTS.GSSDB.md for SQL |
| **Lookup / search form** | CORE, GUI_FORMS, GUI_CONTROLS, GRID, DATA_ODBC, DATA_DATATABLE, PITFALLS | AGENTS.GSSDB.md for schema |
| **Hook script** | CORE, HOOKS, VARIABLES, PATTERNS, PITFALLS + relevant CW_*.md for the ERP area | AGENTS.HOOKS.md for hook catalog; AGENTS.GSSDB.md for schema |
| **Data import / export** | CORE, IO, DATA_DATATABLE, DATA_ODBC, PITFALLS | AGENTS.ZEN.md if writing SQL |
| **REST API integration** | CORE, API_HTTP, DATA_MISC (JSON/XML), PITFALLS | -- |
| **DLL-backed feature** | CORE, DLL, API_AUTOMATION, PITFALLS | AGENTS.TDD.md for .NET testing |
| **CallWrapper automation** | CORE, CALLWRAPPERS (index) + relevant CW_*.md, PITFALLS | AGENTS.GSSDB.md for schema |
| **WebView2 / HTML dashboard** | CORE, GUI_ADVANCED_CONTROLS, API_HTTP, IO, PITFALLS | -- |
| **Hierarchical master-detail grid** | CORE, GUI_FORMS, GRID (Pattern I section), DATA_DATATABLE, DATA_ODBC, PITFALLS (Multi-Level Grid Relation Rules) | AGENTS.GSSDB.md for schema |
| **Reusable library (.lib)** | CORE, PITFALLS + topic sub-files matching the library's purpose | -- |
| **Multi-form modal dialog** | CORE, GUI_FORMS, GUI_CONTROLS, GUI_EVENTS, PITFALLS | -- |
| **Excel / PDF / file automation** | CORE, IO, PITFALLS | -- |
| **Modify existing script** | CORE, PITFALLS + topic sub-files matching the area being changed | -- |

**Notes:**
- CORE is always first -- it covers variables, control flow, error handling, and naming conventions.
- When a recipe says "relevant CW_*.md", consult the `CALLWRAPPERS.md` index to determine which module file(s) match the ERP area (Sales, Inventory, Manufacturing, etc.).
- If SQL is involved in any recipe, also load `AGENTS.ZEN.md` for Actian Zen dialect rules and `AGENTS.GSSDB.md` for the schema index.

---

# SYNTAX NOTES

## Namespace Aliases
`F.Intrinsic` is the short form of `Function.Intrinsic`. Both are valid and interchangeable:
```
F.Intrinsic.Control.EndIf              ' Short form (preferred)
Function.Intrinsic.Control.EndIf       ' Long form (equivalent)
```

The same applies to all top-level namespaces: `F.Data` = `Function.Data`, `F.ODBC` = `Function.ODBC`, etc.

## Variable Prefix Aliases
`V.` is the short form of `Variable.`. Both are valid and interchangeable:
```
V.Local.sName.Declare(String)          ' Short form (preferred)
Variable.Local.sName.Declare(String)   ' Long form (equivalent)

V.Enum.Image!EDIT_COLOR                ' Short form (preferred)
Variable.Enum.Image!EDIT_COLOR         ' Long form (equivalent)

V.Args.IsOn                            ' Short form (preferred)
Variable.ARGS.IsOn                     ' Long form (equivalent, note ARGS is uppercase in long form)
```

When generating code, prefer the short form (`V.`) for consistency.

## Case Insensitivity
GAB identifiers are **case-insensitive**. These are all equivalent:
```
F.Data.DataTable.CreateFromSQL(...)     ' PascalCase
F.Data.Datatable.CreateFromSQL(...)     ' Mixed case
V.DataTable.dtName.RowCount             ' PascalCase
V.Datatable.dtName.RowCount             ' Mixed case
```

Field accessors are also case-insensitive:
```
V.DataTable.dt(0).ColumnName!FieldVal          ' Standard
V.DataTable.dt(0).ColumnName!FIELDVAL          ' Uppercase (equivalent)
V.DataTable.dt(0).ColumnName!FieldValTrim      ' Standard
V.DataTable.dt(0).ColumnName!FIELDVALTRIM      ' Uppercase (equivalent)
```

**CRITICAL:** The column name goes BEFORE the `!`, not after. The pattern is `.ColumnName!FieldVal` -- NOT `.Col!ColumnNameFieldVal`. Example: `.Job!FieldValTrim` is correct; `.Col!JobFieldValTrim` is INVALID.

**CRITICAL:** Type-suffixed field accessors are single tokens, NOT chained properties. Use `.FieldValFloat`, `.FieldValLong`, `.FieldValTrim` -- NOT `.FieldVal.Float`, `.FieldVal.Long`, `.FieldVal.Trim`. The dot-chained form is INVALID. For booleans, use plain `.FieldVal` (returns the boolean value directly) or `.FieldValNot` (negated). There is NO `.FieldValBoolean`.

When generating code, prefer PascalCase (`DataTable`, `FieldVal`) for consistency.

## Secondary Delimiter (`:!:`)
GAB uses `*!*` as the primary field separator. When values themselves may contain `*!*`, use `:!:` as a secondary (nested) delimiter:
```
' Nested structure: outer split on *!*, inner split on :!:
V.Local.sData.Set("Key1:!:Val1*!*Key2:!:Val2")
F.Intrinsic.String.Split(V.Local.sData,"*!*",V.Local.sOuter)   ' ["Key1:!:Val1", "Key2:!:Val2"]
F.Intrinsic.String.Split(V.Local.sOuter(0),":!:",V.Local.sInner)  ' ["Key1", "Val1"]
```

---

# FILE STRUCTURE

## File Extension Rule
- **`.g2u`** -- standalone scripts (with or without GUI). If the script has a GUI, it includes a `Program.Sub.ScreenSU` block. Headless scripts (e.g., hook-triggered, no UI) omit ScreenSU entirely and start with Preflight.
- **`.lib`** -- reusable library files included by other scripts via `Program.External.Include.Library`. Libraries have no ScreenSU block and no Main entry point of their own.

Every g2u/lib file follows this mandatory structure in order:

```
Program.Sub.ScreenSU.Start     <- GUI layout (omit entirely for headless .g2u and .lib files)
...
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start     <- Global variables, library includes
...
Program.Sub.Preflight.End

Program.Sub.Main.Start          <- Entry point
...
Program.Sub.Main.End

Program.Sub.<SubName>.Start     <- Additional subroutines
...
Program.Sub.<SubName>.End

Program.Sub.Comments.Start      <- Auto-generated metadata (NEVER modify)
${$5$}$<version>$}$<n>
${$6$}$<user>$}$<timestamp>$}$<hash>
${$7$}$File Version:<version>
Program.Sub.Comments.End
```

### CRITICAL: Comments Block
The `Program.Sub.Comments.Start/End` block is auto-generated by the GAB IDE. It contains an encrypted hash. **NEVER modify, delete, or regenerate this block.** If creating a new file, omit it entirely and let the IDE generate it on first save.

## Execution Order
1. **ScreenSU** -- parsed to build GUI and wire events via `Gui.<control>.Event(EventName, SubName)` (not "called" at runtime)
2. **Preflight** -- runs first: declare globals, include libraries
3. **Main** -- entry point: initialize UI, load data, show form
4. After Main returns, the program enters the **event loop** (user clicks, timer ticks, etc.)

**Event wiring belongs in ScreenSU.** The `Gui.<control>.Event(EventName, SubName)` syntax in ScreenSU is the standard and preferred approach. `AddEventHandler` in Preflight is a legacy alternative.

## File Compilation & Signatures
| Extension | Purpose |
|-----------|---------|
| `.g2u` / `.lib` | Source code (plain text, human-editable) |
| `.gas` | Compiled GAB script (produced by GAB IDE Compile) |
| `.sig` | Signature file (32-char hash companion to .gas) |

The runtime executes `.gas` files, not `.g2u` source. Every `.gas` must have a matching `.sig` for production use. See `agents/gab/HOOKS.md` for signature validation details.

## Namespace Imports
Subroutines can import a namespace to use shorter function names within that scope:
```
Program.Sub.CalcTotals.Start
Program.Sub.Namespace.Imports("F.Intrinsic.Math")
' Now can call Add(), Sub(), Mult() directly instead of F.Intrinsic.Math.Add()
Program.Sub.CalcTotals.End
```

## Documentation Comments
GAB supports structured doc comments (parsed by GAB IDE):
```
'@ Arg OrderId : String = The order ID to process
'@ Arg Action : String = EDIT, VIEW, or DELETE
'@ Return Result : String = Success or error message
```

## Code Comments (MANDATORY)

**You MUST add comments when writing GAB code. This is not optional.**

Every piece of generated GAB code must include:
- **Subroutine purpose comment** -- a `'-- <purpose>` line immediately after `Program.Sub.<Name>.Start`
- **Section headers** in any sub longer than 10 lines -- `'-- Load data`, `'-- Validate`, `'-- Build grid`, etc.
- **SQL intent** -- a comment above every SQL string explaining what it fetches/updates and why
- **Business logic** -- comment any conditional logic explaining the business rule, not the code mechanics
- **Non-obvious calls** -- explain why a CallWrapper is being called, what the parameters mean
- **Event handlers** -- comment what triggers the event and what it should accomplish

Do NOT comment obvious single-line assignments or simple Gui property sets. But when in doubt, comment it.

Use **`'@ Arg` / `@ Return` doc comments** on subroutines with non-trivial parameters or return semantics when it aids the GAB IDE and readers.

Expanded guidance: **`gab/CORE.md`** section **COMMENTS (MANDATORY IN ALL NEW CODE)**.

---

# GUI PROPERTY ACCESS RULES

- **Read** a control property: `V.Screen.form!ctrl.Property` (no parentheses)
  - Example: `V.Local.sVal.Set(V.Screen.frmMain!txtName.Text)`
  - Example: `V.Local.iSel.Set(V.Screen.frmMain!ddlType.ListIndex)`
- **Set** a control property: `Gui.form.ctrl.Property(value)` (dot separators, value in parentheses)
  - Example: `Gui.frmMain.txtName.Text("Hello")`
  - Example: `Gui.frmMain.ddlType.ListIndex(0)`
- **Never** use `V.Screen.form!ctrl.Property(value)` to SET a value -- that is the READ syntax with incorrect parentheses
- **Never** use `V.Screen.form!ctrl.Property()` (empty parens) to READ a value -- drop the parentheses
- Note the delimiter difference: reads use `!` (`V.Screen.form!ctrl`), sets use `.` (`Gui.form.ctrl`)

> **Universal rule:** This no-parentheses-on-read rule applies to ALL variable scopes, not just `V.Screen`: `V.Screen.form!ctrl.Property`, `V.Local.var.Property`, `V.Global.var.Property`, `V.DataTable.dt(...).Col!FieldVal`, etc. -- no parentheses on reads, ever. The parenthesized form is only valid on the WRITE/SET side via `Gui.form.ctrl.Property(value)`.

## Checkbox-Specific Rules

- **Set** a checkbox: `Gui.form.chk.Value(True)` or `Gui.form.chk.Value(False)`
  - **Never** use `.Checked(True/False)` -- `.Checked` is not valid for setting; use `.Value`
- **Read** a checkbox: `V.Screen.form!chk.Value` -- returns `0` (unchecked) or `1` (checked), NOT True/False
  - **Always** compare with `=,1` or `=,0` in conditionals
  - Example: `F.Intrinsic.Control.If(V.Screen.frmMain!chkActive.Value,=,1)`
  - **Never** use bare boolean check like `F.Intrinsic.Control.If(V.Screen.frmMain!chkActive.Value)` -- compare explicitly

## Multi-Form Modal Dialog Pattern

A single `.g2u` can contain multiple forms. To show a second form as a modal dialog:

1. Disable the parent form: `Gui.frmParent..Enabled(False)`
2. Show the child form: `Gui.frmChild..Show`
3. Block until closed: `Gui.frmChild..WaitForDismiss`
4. Re-enable the parent form: `Gui.frmParent..Enabled(True)`
5. Read any result values from globals set by the child form

The child form's UnLoad event **must** call `Gui.frmChild..Visible(False)` to hide the form instead of destroying it. Do NOT use `F.Intrinsic.Control.End` -- only the main form's UnLoad uses `End`.

---

# GOLDEN RULE

> **NEVER invent, guess, or assume GAB functions, methods, properties, events, enums, or syntax.** GAB is a proprietary language with zero public documentation. The ONLY valid API surface is what is documented in this file and the `agents/gab/*.md` reference files. If a function is not documented, it does not exist. When you need undocumented functionality, ASK the user.

## Quick Reference: Most Common Mistakes

These one-liners cover the highest-frequency errors. Full explanations and code examples are in `agents/gab/PITFALLS.md`.

- **Check production scripts first** -- before inventing new approaches, review scripts at `C:\Apps\Global` and RKing patterns
- **WebView2 data** -- always use `SaveToJson` for WebView2 data; never build JSON manually with `String.Build` and `DblQuote`
- **Form show sequence** -- always call `.Show` + AlwaysOnTop flash on DashForm/BaseForm (`AlwaysOnTop(True)` then `AlwaysOnTop(False)`)
- **No inline operators** -- use `F.Intrinsic.Math.*` functions, not `+`, `-`, `*`, `/`
- **No string concatenation with `+`** -- use `F.Intrinsic.String.Build`, `.Concat`, or `.Set`/`.Append`
- **String.Build requires `{N}` placeholders** -- do not use it for literal strings with no placeholders
- **String2File/File2String** -- path is always the FIRST argument
- **Try/Catch cannot nest within the same subroutine** -- a `Try` inside another `Try` in the same sub misroutes errors to the inner `Catch`. Cross-subroutine Try/Catch is fine. Use `SetErrorHandler` as the standard pattern; `Try/Catch` only for single risky operations
- **Array elements in CallSub** -- extract `V.Local.arr(N)` to a temp variable before passing
- **DataTable scope defaults to local** -- pass `True` (GlobalScope) on Create/CreateFromSQL if the DataTable outlives the creating sub. Don't close in sub A if sub B still needs the data
- **ODBC connection names must be unique** -- no reuse across nested calls
- **`.UBound` is a property** -- use `V.Local.x.Set(V.Local.arr.UBound)`, not `F.Intrinsic.String.UBound()`
- **`.PSQLFriendly` / `.SQLServerFriendly` are properties** -- no parentheses, no chaining on `V.Screen`
- **Variable property reads have no parentheses** -- `.Text`, `.Tab`, `.ListIndex`, `.Caption`, `.PervasiveDate` are properties, not methods

---

# REFERENCE: g2u Files Location

See `AGENTS.PROJECT.md` > "Sample G2U Files" for the path to reference g2u scripts (organized by customer folder, then project number).

---

# APPENDIX: MCP Intelligence (Summary)

MCP Intelligence (`user-mcp-intelligence`) provides authoritative GAB API validation via `gab-commands` (5,421 definitions), COBOL business logic via `cobol-codebase`, docs via `book-of-armaments`, and log analysis via `log-parser`.

**Quick usage:** `CallMcpTool(server:"user-mcp-intelligence", toolName:"call_proxy_tool", arguments:{server:"gab-commands", tool_name:"validate_gab_command", arguments:"{\"commandName\":\"...\"}"})`

**When to use:** For function calls not found in local docs, for ERP behavior investigation, for CallWrapper parameter lookups, for log analysis. Falls back to local tools (`Validate-GabApi.ps1`, `agents/gab/*.md`) when disconnected.

**Full reference:** See `agents/gab/MCP_REFERENCE.md` for complete downstream server docs, tool tables, and fallback hierarchy.
