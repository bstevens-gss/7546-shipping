---
name: gab-test-debug
description: >-
  Automatically test and debug GAB .g2u scripts by signing, launching via .gaf,
  capturing native trace output, and analyzing results. Use when the user asks to
  test, debug, run and check, troubleshoot, or iterate on a GAB script, or when a
  .g2u script produces unexpected behavior or errors.
---

# GAB Test-Debug

Automated test-debug loop for `.g2u` scripts: sign, run, capture native trace, analyze, fix, repeat.

## Prerequisites

- **gab-sign** and **gab-run** skills must be installed.
- GSS ERP must be running with `.gaf` file association registered.
- `Trans900000` must exist in `GSS_GAF.g2u` (see gab-run skill).

## How It Works

GAB scripts run inside the GSS ERP process -- there is no stdout/stderr to capture.
This skill uses **native trace logging**: the `octsrs.logging` sentinel file enables the
runtime's built-in diagnostic trace, which writes `octsrs.*.debug` files to `%TEMP%\GSS\`.
The orchestrator creates the sentinel before launch, polls for trace output, and reads it back.

```
test-debug.ps1 creates octsrs.logging sentinel
    ↓
Signs .g2u → launches .gaf → polls for native trace files
    ↓
Agent reads trace output → analyzes → fixes → repeats
```

## Quick Start

### 1. Optionally add in-script debug calls

GAB has a full `F.Intrinsic.Debug.*` namespace. Use these native methods -- do NOT inject custom logging subroutines:

```
F.Intrinsic.Debug.EnableLogging
F.Intrinsic.Debug.SetLA("Starting RefreshData for order: ",V.Local.sOrderNum)
```

Key native debug methods for test-debug:

| Method | Purpose |
|--------|---------|
| `EnableLogging` | Enables per-script trace (complements the sentinel) |
| `SetLA(expr,...)` | Write context to Live Activity window + trace |
| `SetLABuild(fmt,args)` | Format-string version of SetLA |
| `DumpVariableList` | Dump all variables to trace file |
| `ToggleOutputListing` | Write a `.debug` listing file |
| `TimerStart` / `TimerElapsed` | Profile expensive operations |
| `CallWrapperDebugEnable` | Trace CallWrapper parameter passing |

These are all automation-safe. See the full API reference below.

### 2. Run the test cycle

```powershell
$tds = Join-Path $env:USERPROFILE ".gab-agents/skills/gab-test-debug/scripts/test-debug.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File $tds -Script "<file.g2u>" -Clean
```

### 3. Read the trace

The script prints native trace contents to stdout. Also readable as `octsrs.*.debug` files in `%TEMP%\GSS\`.

### 4. Analyze and iterate

Fix the issue, add more `SetLA` calls if needed for context, re-run. Repeat until the trace shows clean execution.

## Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `-Script` | Yes | -- | Path to the `.g2u` file |
| `-TimeoutSeconds` | No | 30 | Max seconds to wait for trace activity |
| `-PollIntervalMs` | No | 1000 | Polling interval in milliseconds |
| `-SkipSign` | No | false | Skip signing (when `.sig` is current) |
| `-SkipLaunch` | No | false | Sign and prepare but do not launch |
| `-Clean` | No | false | Delete old trace files before launch |
| `-EnableTrace` | No | true | Create/delete `octsrs.logging` sentinel automatically |
| `-Tail` | No | 0 (all) | Return only last N lines |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Trace captured, no errors detected |
| 1 | Signing or launch failed |
| 2 | No trace output was produced |
| 3 | Trace captured but error patterns found |

## Agent Workflow (step by step)

When the user asks to test/debug a `.g2u` script, follow this loop:

### Step 1: Read the script
Read the `.g2u` file. Identify what it does and where it might fail.

### Step 2: Add native debug calls (minimal, targeted)
Use `F.Intrinsic.Debug.*` methods at key points -- do NOT add custom logging subroutines:
- `F.Intrinsic.Debug.EnableLogging` at top of Main
- `F.Intrinsic.Debug.SetLA(...)` at key decision points, error handlers, and before risky operations
- `F.Intrinsic.Debug.DumpVariableList` before operations that could fail
- `F.Intrinsic.Debug.CallWrapperDebugEnable` before CallWrapper calls

### Step 3: Run
```powershell
$tds = Join-Path $env:USERPROFILE ".gab-agents/skills/gab-test-debug/scripts/test-debug.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File $tds -Script "<file.g2u>" -Clean
```

### Step 4: Capture and analyze
Read the native trace output. Look for:
- Error codes and descriptions in the trace
- Missing trace entries -- the script crashed at that point
- Unexpected variable values via `DumpVariableList` output
- CallWrapper parameter issues via CW debug trace

### Step 5: Fix
Make targeted fixes based on the trace evidence. Do NOT guess -- the trace tells you exactly where execution stopped.

### Step 6: Re-run
Repeat from Step 3. Use `-SkipSign` if only the analysis changed (not the `.g2u`).

### Step 7: Screenshot Validation (for GUI scripts)

For scripts with a GUI (ScreenSU block), add `TakeScreenshot` calls at key validation points to capture visual proof:

```
Gui.frmMain..TakeScreenshot("C:\path\to\screenshots\01_InitialLoad.png")
```

**Rules:**
- Create a `screenshots/` directory in the project folder
- Name files sequentially: `01_InitialLoad.png`, `02_AfterDataLoad.png`, `03_AfterAction.png`
- Place `TakeScreenshot` AFTER the form is fully rendered (after `.Show` + `AlwaysOnTop` flash + data load)
- Screenshots are deliverable evidence for quotes/mockups -- include them in DOCX specs
- The agent should READ the captured screenshots after the test-debug cycle to visually confirm the UI rendered correctly

**Pattern for automated screenshot in test scripts:**
```
'-- After form loads and data populates
Gui.frmMain..TakeScreenshot(V.Local.sScreenshotPath)
'-- After a specific user action is simulated
F.Intrinsic.Control.CallSub(ProcessPallet)
Gui.frmMain..TakeScreenshot(V.Local.sScreenshot2Path)
```

### Step 8: Verify before presenting
Before telling the user the script is working, you MUST have at least ONE of these:
- **Native trace evidence**: An `octsrs.*.debug` file in `$env:TEMP\GSS\` was created/modified after your launch timestamp
- **Process evidence**: `Get-Process` shows a window title matching the script's form caption (e.g., `"Manufacturing Dashboard (PLA)"`)
- **Screenshot evidence**: A `.png` file in the project's `screenshots/` directory with a timestamp matching your run

If you have NONE of these, you MUST NOT claim the script is working. Say explicitly: "I cannot verify the script launched successfully. Here's what I tried: ..."

### Step 8: Strip debug calls and clean up
Once the script works, remove any `F.Intrinsic.Debug.*` calls you added (leave any that were already in the script). Verify that the `octsrs.logging` sentinel file has been removed from `%TEMP%\GSS\` (`test-debug.ps1` does this automatically).

## CRITICAL MANDATES

These rules are non-negotiable. Violation wastes significant user time:

1. **NEVER present untested code as working.** Saying "it should be up" or "the form is ready" without trace or process evidence is a violation of this skill's contract. If you cannot verify, say so.

2. **After EVERY code change, re-sign before re-launching.** The `.sig` file is invalidated by any edit to the `.g2u`. Use the `/gab-sign` skill -- never skip this step or assume the old signature is still valid.

3. **If the script won't launch**, verify `.gaf` format immediately:
   ```
   TRANSID::900000
   SCRIPT::C:\path\to\script.g2u
   ```
   NOT INI format (`[GAF]` / `ScriptPath=`). This is the #1 cause of "nothing happened" after launch.

4. **NEVER inject custom file-writing debug code.** No `Append2FileNewLine`, no `DebugLog` subroutine, no `.debug.log` files. The native OCTSRS trace system (`octsrs.logging` sentinel + `F.Intrinsic.Debug.*` methods) provides all necessary diagnostic output.

5. **Enable native trace via the `octsrs.logging` sentinel file**, NOT via in-script `SetLevel` calls. The `test-debug.ps1` script handles this automatically (creates `%TEMP%\GSS\octsrs.logging` before launch, deletes after capture). Do NOT inject `F.Intrinsic.Debug.SetLevel` into scripts -- it pops an interactive dialog that blocks unattended execution.

6. **Monitor `octsrs.*.debug` files** in `$env:TEMP\GSS\` for native trace output. Check file modification timestamps to confirm they're from YOUR run, not a stale prior session.

## Debugging Hierarchy

Follow this order. Only escalate to the next level when the current level doesn't give you enough information:

### Level 1: Native Trace (Default -- No Script Modification Required)
- `test-debug.ps1` creates the `octsrs.logging` sentinel automatically
- Sign and launch the script as-is
- Read native `octsrs.*.debug` trace files from `%TEMP%\GSS\`
- Check for error dialogs via process list

### Level 2: Targeted Debug API Calls (Minimal Script Modification)
Add `F.Intrinsic.Debug.*` calls at specific points of interest:
```
F.Intrinsic.Debug.EnableLogging
F.Intrinsic.Debug.SetLA("Entering LoadData, order=",V.Local.sOrder)
F.Intrinsic.Debug.DumpVariableList
F.Intrinsic.Debug.CallWrapperDebugEnable
```
These are part of the GAB language -- they are not custom code. Strip them after debugging.

### BANNED: Custom File-Based Logging
**NEVER** inject custom `DebugLog` subroutines, `Append2FileNewLine` calls, or `.debug.log` file patterns. The native OCTSRS trace system provides all necessary diagnostic output. If native trace + Level 2 API calls don't give you enough detail, increase `SetLA` granularity -- do NOT create file-writing debug code.

## Stale Process Handling

Both `test-debug.ps1` and `run-gaf.ps1` use **PID-file tracking** to manage stale processes.
When `run-gaf.ps1` launches a `.gaf`, it records the spawned PIDs in a `<scriptName>.gaf.pids`
file. On re-run, both scripts read this file and kill ONLY the tracked PIDs -- never other GAB
processes the user has open independently.

This means running test-debug will never kill a GAB form or script you launched manually or
from another project. Only processes spawned by a previous run of the same script are terminated.

When no trace output is found, the script also checks for error dialogs that appeared during the run
and reports their PIDs for diagnosis (but does not kill them automatically).

The polling loop detects error dialogs mid-wait and breaks early instead of waiting the full timeout.

## F.Intrinsic.Debug API Reference (Runtime-Verified)

Validated via [`test/CETESTS/debug_api_test.g2u`](../../test/CETESTS/debug_api_test.g2u) -- 24 PASS, 1 FAIL (Resume), 2026-05-25.

### Automation-Safe Methods (21)

These methods are safe to use during automated test-debug cycles and unattended `.gaf` runs:

| Method | Parameters | Notes |
|--------|------------|-------|
| SetLA | Expression, [ExpressionN...] | Most common in production. Writes to Live Activity window |
| SetLABuild | BaseString, Args | Format-string version of SetLA. Missing from native index |
| Print | Value | Debug console output |
| EnableLogging | (none) | Enables per-script trace; complements the `octsrs.logging` sentinel |
| CallWrapperDebugEnable | (none) | Enable CW tracing -- call before CallWrapperSync |
| CallWrapperDebugEnableSilent | (none) | Silent CW debug. Missing from native index |
| CallWrapperDebugDisable | (none) | Disable CW tracing after call |
| TimerStart | Name | Start named performance timer |
| TimerElapsed | Name, ReturnVariable | Returns elapsed milliseconds |
| TimerElapsedTicks | Name, ReturnVariable | Returns ticks (higher precision). Missing from native index |
| BenchmarkModeEnable | Boolean | Deprecated but still works -- prefer TimerStart/TimerElapsed |
| BenchmarkThreshold | Long | Benchmark threshold in ms |
| ToggleOutput | Expression (Boolean) | Toggle debug output |
| ToggleOutputListing | (none) | Creates `.debug` listing file in temp directory |
| DumpVariableList | (none) | Dump all variables to `.debug` file |
| DumpOutputHookfile | (none) | Dump hook file output |
| SetScriptVersion | Value | Set version label for debugging |
| SetProgramDirectory | OverrideDirectory | Override program directory for path resolution |
| SetErrorTimeout | Long (seconds) | NOT IMPLEMENTED in 2023.x -- do not use |
| OverrideGSSVersion | String | Test future-version GAB commands |
| WatchVariable | FullyQualifiedName, Value | Watch variable changes during debug |

### CRITICAL: Interactive-Only Methods -- Never Use in Unattended Scripts

These methods **BLOCK execution** waiting for user interaction. They will hang automated test-debug cycles and unattended `.gaf` launches:

| Method | Behavior |
|--------|----------|
| **SetLevel** | Pops a `DevExpress.XtraInputBox` dialog ("Enter debugging level") that blocks until the user responds. Use the `octsrs.logging` sentinel file instead. |
| **ShowCallerInfo** | Pops debugger dialog; blocks until user clicks Continue (~48s observed in runtime test) |
| **Stop** | Breakpoint; halts execution outside attached debugger |
| **InvokeDebugger** | Launches full debugger GUI |

Also avoid **Resume** -- it exists in the Intellisense index but fails at runtime with "Invalid method specified".

## Common Failure Modes

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| No trace files created | Script crashed before any execution | Check GAB syntax, library includes, missing subroutines |
| No trace files + `GAB ERROR DIALOG DETECTED` | GAB syntax error or missing dependency | Check error dialog text, verify `.lib` files are present |
| Trace shows startup but no business logic | Crash in variable declarations or early logic | Add `SetLA` calls between declaration blocks |
| Error codes in trace | Runtime error at specific point | Check the error number against GAB error reference |
| Script runs but no `.gaf` launch | `.gaf` file association not registered | Open any `.gaf` manually first, or check GSS installation |
| `.gaf` file locked | Previous run left a stale process | Auto-handled: scripts kill only tracked PIDs from `.gaf.pids` and retry |
| Trace is stale (timestamps don't match) | Script finished before polling started | Reduce `-PollIntervalMs` or increase `-TimeoutSeconds` |

## Additional Resources

- For signing details, see the **gab-sign** skill
- For `.gaf` launch mechanism, see the **gab-run** skill
