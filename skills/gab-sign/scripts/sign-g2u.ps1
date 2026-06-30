<#
.SYNOPSIS
    Signs a .g2u GAB script file by generating the companion .sig file.

.DESCRIPTION
    Replicates the GAB Code Editor's signing algorithm:
    1. Updates the Comments block timestamps to the current time
    2. Writes the .g2u file (UTF-8 with BOM, CRLF)
    3. Computes MD5 of domain-salted content (ASCII bytes)
    4. Writes the hash to <path>.sig

    Timestamps and .sig are always written together as one save operation.

.PARAMETER Path
    Path to the .g2u file to sign.

.PARAMETER SkipTimestamps
    If set, signs without updating timestamps. Use only for re-signing
    an already-timestamped file without changing metadata.

.PARAMETER Force
    Bypass the pre-sign lint check. Use when you need to sign a file
    that has known lint errors (e.g., legacy scripts being preserved as-is).

.PARAMETER User
    Username for the ${$6$} line. Defaults to $env:USERNAME.

.EXAMPLE
    .\sign-g2u.ps1 -Path "C:\Apps\Global\BUSINT\PREPROC\MyScript.g2u"

.EXAMPLE
    .\sign-g2u.ps1 -Path "C:\Apps\Global\BUSINT\PREPROC\MyScript.g2u" -SkipTimestamps
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [switch]$SkipTimestamps,

    [switch]$Force,

    [string]$User = $env:USERNAME
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"
    exit 1
}

# -- Lint Gate: refuse to sign if lint errors are found --
if (-not $Force) {
    $lintScript = Join-Path $PSScriptRoot "..\..\gab-lint\scripts\gab-lint.ps1"
    if (Test-Path $lintScript) {
        $lintOutput = & $lintScript -Path $Path -Severity "error" -Format "text" 2>&1
        $lintExit = $LASTEXITCODE
        if ($lintExit -ne 0) {
            Write-Host ""
            Write-Host "LINT GATE FAILED - refusing to sign." -ForegroundColor Red
            Write-Host "Fix the errors below, or use -Force to bypass:" -ForegroundColor Yellow
            Write-Host ""
            $lintOutput | ForEach-Object { Write-Host $_ }
            Write-Host ""
            exit 1
        }
    }
}

$sigPath = "$Path.sig"

# Capture save time once so .g2u and .sig share the exact same moment
$now = [System.DateTime]::Now
$utcNow = [System.DateTime]::UtcNow

if (-not $SkipTimestamps) {
    $localTs = $now.ToString("yyyyMMddHHmmssfff")
    $utcTs = $utcNow.ToString("yyyyMMddHHmmss")

    # Detect encoding: if file starts with UTF-8 BOM, read as UTF-8; otherwise use Default
    $rawBytes = [System.IO.File]::ReadAllBytes($Path)
    $hasBom = ($rawBytes.Length -ge 3 -and $rawBytes[0] -eq 0xEF -and $rawBytes[1] -eq 0xBB -and $rawBytes[2] -eq 0xBF)
    $readEncoding = if ($hasBom) { [System.Text.Encoding]::UTF8 } else { [System.Text.Encoding]::Default }
    $lines = [System.IO.File]::ReadAllLines($Path, $readEncoding)
    $modified = $false

    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i].StartsWith('${$6$}$')) {
            $lines[$i] = '${$6$}$' + $User + '$}$' + $localTs + '$}$CursorSigned'
            $modified = $true
        }
        if ($lines[$i].StartsWith('${$7$}$')) {
            $lines[$i] = '${$7$}$File Version:1.0.' + $utcTs + '.0'
            $modified = $true
        }
    }

    if ($modified) {
        $content = ($lines -join "`r`n") + "`r`n"
        $utf8BOM = New-Object System.Text.UTF8Encoding $true
        [System.IO.File]::WriteAllText($Path, $content, $utf8BOM)
    }
}

# Determine salt based on USERDOMAIN
$domain = if ($env:USERDOMAIN) { $env:USERDOMAIN.ToUpper() } else { "" }
$domainOverride = if ($env:DOMAINOVERRIDE) { $env:DOMAINOVERRIDE.ToUpper() } else { "" }

if ($domain -in @("INFISY", "GLOBAL", "GSS")) {
    $salt = "GlobalShopSolutionsGAB"
} elseif ($domainOverride -in @("INFISY", "GSS")) {
    $salt = "GlobalShopSolutionsGAB"
} else {
    $salt = "CustomerGAB"
}

# Compute .sig from the file as it now exists on disk
$md5 = [System.Security.Cryptography.MD5]::Create()
$fileContent = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::Default)
$salted = $salt + $fileContent
$hashBytes = $md5.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($salted))
$sigHash = ([BitConverter]::ToString($hashBytes) -replace '-','').ToLower()

[System.IO.File]::WriteAllText($sigPath, $sigHash)

# Force matching LastWriteTime on script and sig so they appear as a single save operation
[System.IO.File]::SetLastWriteTime($Path, $now)
[System.IO.File]::SetLastWriteTime($sigPath, $now)

Write-Host "Signed: $Path"
Write-Host "Time:   $($now.ToString('yyyy-MM-dd HH:mm:ss.fff'))"
Write-Host "Hash:   $sigHash"
