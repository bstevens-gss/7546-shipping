---
name: gab-run
description: >-
  Run GAB .g2u scripts via the .gaf launch mechanism. Use when the user asks
  to run, execute, launch, or test a GAB script, .g2u file, or mentions .gaf files.
  Handles signing, .gaf creation, and execution in one step.
---

# GAB Script Runner

Run `.g2u` scripts through the GSS `.gaf` dispatch chain without the GAB Code Editor.

## Prerequisites

- **gab-sign** skill must be installed for auto-signing.
- `.gaf` file association must be registered with Windows (GSS handles this).
- GSS ERP installed with a Global directory (auto-detected, or set `GSS_GLOBAL_DIR` env var).

## Automatic Environment Validation

Every launch runs a **preflight check** that:

1. **Finds the Global directory** -- checks `$env:GSS_GLOBAL_DIR`, then searches common paths (`C:\APPS\GLOBAL`, `D:\APPS\GLOBAL`, etc.), then checks the Windows registry.
2. **Validates `GSS_GAF.g2u`** exists at `<GlobalDir>\PLUGINS\GAB\GAS\GSS_GAF.g2u`.
3. **Checks for Trans900000** subroutine inside `GSS_GAF.g2u`. If missing, **automatically injects it** from the template and re-signs the file.
4. **Checks `.sig` exists** for `GSS_GAF.g2u`. If missing, auto-signs it.

This means a fresh GSS install will be automatically prepared for `.gaf` execution on first run. Use `-SkipPreflight` to bypass if you know the environment is good.

## Quick Run (sign + launch)

After editing a `.g2u` in Cursor, sign and run it in one command:

```powershell
$runScript = Join-Path $env:USERPROFILE ".cursor/skills/gab-run/scripts/run-gaf.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File $runScript -Script "<file.g2u>" -Sign
```

## Run Without Re-signing

If the `.g2u` is already signed and unchanged:

```powershell
$runScript = Join-Path $env:USERPROFILE ".cursor/skills/gab-run/scripts/run-gaf.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File $runScript -Script "<file.g2u>"
```

## Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-Script` | Yes | Path to the `.g2u` file to run |
| `-Sign` | No | Signs the `.g2u` before launching (calls gab-sign skill) |
| `-GafPath` | No | Explicit `.gaf` output path. Default: same dir as script, same basename |
| `-NoLaunch` | No | Creates the `.gaf` but does not execute it |
| `-SkipPreflight` | No | Skip the GSS_GAF.g2u environment validation |

## After Editing a .g2u in Cursor

Whenever a `.g2u` file is modified and the user wants to test it, the agent MUST:

1. Call `run-gaf.ps1 -Script "<path>" -Sign` (signs + launches in one step)
2. Report the hash and confirm launch

Do NOT sign and launch as separate steps -- the skill handles both.

## How It Works

The execution chain:

```
run-gaf.ps1 → signs .g2u → creates .gaf → shell-executes .gaf
    ↓
Windows file association → GSSMenu.exe → GSS_GAF_Launch.gas
    ↓
GSS_GAF_Launch.gas reads .gaf → sets TRANSID + SCRIPT as passed elements
    ↓
GSS_GAF.g2u → Trans900000 → CallSyncGAS(V.Passed.SCRIPT)
    ↓
Your .g2u script runs
```

## .gaf File Format

The `.gaf` launcher file uses a simple **key::value** format (NOT INI):

```
TRANSID::900000
SCRIPT::C:\path\to\your\script.g2u
```

- Each line is `KEY::VALUE` (double colon separator)
- `TRANSID` is always `900000` for GAB script launches
- `SCRIPT` is the full path to the `.g2u` file
- No section headers like `[GAF]`
- No `ScriptPath=` INI-style assignments

Additional parameters can be added (one per line) and will be available as `V.Passed.*` elements in the called script. Parsed by `GSS_GAF_Launch.gas`.

## Trans900000 Setup (Automatic)

The preflight check handles this automatically. If `Trans900000` is not in `GSS_GAF.g2u`,
the script injects it from the template at `templates/trans900000.g2u.block` and re-signs.

No manual setup is needed. The first `run-gaf.ps1` call on a fresh environment will
detect the missing subroutine, inject it, sign it, and proceed with the launch.

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| "No transaction was passed" | `.gaf` missing `TRANSID::900000` | Regenerate `.gaf` with this skill |
| "Missing parameter SCRIPT" | `.gaf` missing `SCRIPT::` line | Regenerate `.gaf` with this skill |
| Script does not launch | `.gaf` file association not registered | Open any `.gaf` manually first to register |
| Signature error | `.sig` missing or stale | Use `-Sign` flag to re-sign before launch |
| Trans900000 not found (error 5010) | `GSS_GAF.g2u` missing the subroutine | Run without `-SkipPreflight` (auto-injects) |
| "Cannot find GSS Global directory" | GSS not installed or path unknown | Set `GSS_GLOBAL_DIR` env var or run `setup-dev-env.ps1` |
