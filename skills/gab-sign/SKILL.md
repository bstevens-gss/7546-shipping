---
name: gab-sign
description: >-
  Sign GAB .g2u script files by generating the companion .sig signature file.
  Use when the user saves a .g2u file, asks to sign a GAB script, mentions
  .sig files, or needs to make a .g2u file runnable outside the GAB Code Editor.
---

# GAB Script Signing

Sign `.g2u` files so the GAB runtime accepts them without the GAB Code Editor.

## Algorithm

The `.sig` file contains: `MD5(salt + File.ReadAllText(path, Encoding.Default))` using ASCII byte encoding.

| USERDOMAIN | Salt |
|------------|------|
| GSS, GLOBAL, INFISY | `GlobalShopSolutionsGAB` |
| Everything else | `CustomerGAB` |

## Quick Sign (inline)

Locate the script from the user's personal skills or the workspace:

```powershell
$signScript = Join-Path $env:USERPROFILE ".cursor/skills/gab-sign/scripts/sign-g2u.ps1"
```

Then run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File $signScript -Path "<file.g2u>"
```

This updates the Comments timestamps and generates the `.sig` in one operation.
To re-sign without touching timestamps (e.g. verifying an existing file):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File $signScript -Path "<file.g2u>" -SkipTimestamps
```

## After Editing a .g2u in Cursor

Whenever a `.g2u` file is saved or modified in Cursor, the agent MUST re-sign it before the user tests. Just call the script with `-Path` — timestamps update automatically to match the save moment.

## Creating a New .g2u from Scratch

When generating a new `.g2u` file, include a Comments block at the end:

```
Program.Sub.Comments.Start
${$5$}$2.0.0.0$}$2
${$6$}$<username>$}$<localTimestamp>$}$CursorSigned
${$7$}$File Version:1.0.<utcTimestamp>.0
Program.Sub.Comments.End
```

Where:
- `<username>` = `$env:USERNAME`
- `<localTimestamp>` = `yyyyMMddHHmmssfff` (local time)
- `<utcTimestamp>` = `yyyyMMddHHmmss` (UTC)

Then sign it with the script.

## File Format Requirements

- **Encoding**: UTF-8 with BOM (bytes `EF BB BF`)
- **Line endings**: CRLF (`\r\n`)
- **No trailing newline** after `Program.Sub.Comments.End`

## Verification

To verify a `.sig` is correct without running in the ERP:

```powershell
$path = "<file.g2u>"
$md5 = [System.Security.Cryptography.MD5]::Create()
$content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::Default)
$salted = "GlobalShopSolutionsGAB" + $content
$computed = ([BitConverter]::ToString($md5.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($salted))) -replace '-','').ToLower()
$actual = (Get-Content "$path.sig").Trim()
Write-Host "Match: $($computed -eq $actual)"
```

## Batch Signing

To sign all `.g2u` files in a directory:

```powershell
$signScript = Join-Path (Get-Location) ".cursor/skills/gab-sign/scripts/sign-g2u.ps1"
Get-ChildItem "<directory>" -Filter "*.g2u" | ForEach-Object {
    powershell -NoProfile -ExecutionPolicy Bypass -File $signScript -Path $_.FullName
}
```

## Provenance

Algorithm reverse-engineered from `GabLicensingAndEncryption.dll` via IL decompilation:
- `GabEncryption.SignScript(path)` calls `File2String(path)` then `CalculateHash(content)` then `File.WriteAllText(path + ".sig", hash)`
- `File2String` uses `File.ReadAllText(path, Encoding.Default)`
- `CalculateHash` prepends domain salt, then standard MD5 via `GetMD5HashFromString`
- `DetermineHashStatus` validates by trying GlobalShopSolutionsGAB then CustomerGAB salts
- Customer sites (non-GSS domain) use `CustomerGAB` salt automatically
