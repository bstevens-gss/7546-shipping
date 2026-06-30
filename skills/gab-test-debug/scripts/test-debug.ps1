<#
.SYNOPSIS
    Sign, run, and capture native trace output from a GAB .g2u script.

.DESCRIPTION
    Orchestrates the full test-debug cycle for GAB scripts:
    1. Signs the .g2u (calls gab-sign skill)
    2. Creates the octsrs.logging sentinel file for native trace
    3. Launches via .gaf (calls gab-run skill)
    4. Polls for native trace files (octsrs.*.debug) in %TEMP%\GSS\
    5. Returns trace contents for analysis
    6. Cleans up the sentinel file

.PARAMETER Script
    Path to the .g2u file to test.

.PARAMETER TimeoutSeconds
    Max seconds to wait for trace file activity. Default: 30.

.PARAMETER PollIntervalMs
    Milliseconds between trace file checks. Default: 1000.

.PARAMETER SkipSign
    Skip signing (use when the .sig is already current).

.PARAMETER SkipLaunch
    Sign and prepare but do not launch (dry run).

.PARAMETER Clean
    Delete old trace and log files before launching so only fresh output is captured.

.PARAMETER Tail
    Number of lines to return from the end of the trace. Default: all lines.

.PARAMETER EnableTrace
    Create the octsrs.logging sentinel file in %TEMP%\GSS\ before launch to enable
    machine-wide native trace logging. The sentinel is deleted after capture.
    Default: $true.

.EXAMPLE
    .\test-debug.ps1 -Script "C:\path\to\script.g2u" -Clean -TimeoutSeconds 20

.EXAMPLE
    .\test-debug.ps1 -Script "C:\path\to\script.g2u" -SkipSign -Tail 50
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$Script,

    [int]$TimeoutSeconds = 30,

    [int]$PollIntervalMs = 1000,

    [switch]$SkipSign,

    [switch]$SkipLaunch,

    [switch]$Clean,

    [int]$Tail = 0,

    [bool]$EnableTrace = $true
)

$ErrorActionPreference = "Stop"

$Script = [System.IO.Path]::GetFullPath($Script)
if (-not (Test-Path $Script)) {
    Write-Error "Script not found: $Script"
    exit 1
}

$scriptDir  = [System.IO.Path]::GetDirectoryName($Script)
$scriptName = [System.IO.Path]::GetFileNameWithoutExtension($Script)
$gssTemp    = Join-Path $env:TEMP "GSS"

Write-Host "=== GAB Test-Debug ===" -ForegroundColor Cyan
Write-Host "  Script:   $Script"
Write-Host "  TraceDir: $gssTemp"
Write-Host "  Timeout:  ${TimeoutSeconds}s"

# Clean old trace/log files if requested
if ($Clean) {
    if (Test-Path $gssTemp) {
        $oldTraces = Get-ChildItem $gssTemp -Filter "octsrs.*.debug" -ErrorAction SilentlyContinue
        if ($oldTraces) {
            $oldTraces | Remove-Item -Force -ErrorAction SilentlyContinue
            Write-Host "  Cleaned $($oldTraces.Count) old trace file(s)" -ForegroundColor Yellow
        }
    }
}

# Kill only PIDs tracked from a previous run of THIS script's .gaf launch.
$pidFile = Join-Path $scriptDir "$scriptName.gaf.pids"
if (Test-Path $pidFile) {
    $trackedPids = Get-Content $pidFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and $_ -notmatch '^#' -and $_ -match '^\d+$' }
    $killedAny = $false
    foreach ($tpid in $trackedPids) {
        $proc = Get-Process -Id ([int]$tpid) -ErrorAction SilentlyContinue
        if ($proc -and $proc.ProcessName -eq "Octsrs.net") {
            $title = if ($proc.MainWindowTitle) { $proc.MainWindowTitle } else { "(no window)" }
            Write-Host "  Killing tracked PID $tpid ($title) from previous run..." -ForegroundColor Yellow
            Stop-Process -Id ([int]$tpid) -Force -ErrorAction SilentlyContinue
            $killedAny = $true
        } elseif ($proc) {
            Write-Host "  Skipping PID $tpid -- process is now $($proc.ProcessName), not Octsrs.net" -ForegroundColor DarkYellow
        }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
    if ($killedAny) { Start-Sleep -Milliseconds 500 }
}

# Record pre-launch state for native trace files
$launchTime = [datetime]::UtcNow

# Sign
if (-not $SkipSign) {
    $signScript = Join-Path $PSScriptRoot "..\..\gab-sign\scripts\sign-g2u.ps1"
    if (-not (Test-Path $signScript)) {
        $signScript = Join-Path $env:USERPROFILE ".cursor\skills\gab-sign\scripts\sign-g2u.ps1"
    }
    if (-not (Test-Path $signScript)) {
        $signScript = Join-Path $env:USERPROFILE ".gab-agents\skills\gab-sign\scripts\sign-g2u.ps1"
    }
    if (Test-Path $signScript) {
        Write-Host "  Signing..." -ForegroundColor Gray
        & powershell -NoProfile -ExecutionPolicy Bypass -File $signScript -Path $Script -Force
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Signing failed"
            exit 1
        }
    } else {
        Write-Warning "gab-sign skill not found -- skipping sign"
    }
}

# Create octsrs.logging sentinel for native trace
$sentinelPath = $null
if ($EnableTrace) {
    if (-not (Test-Path $gssTemp)) { New-Item -ItemType Directory -Path $gssTemp -Force | Out-Null }
    $sentinelPath = Join-Path $gssTemp "octsrs.logging"
    New-Item -ItemType File -Path $sentinelPath -Force | Out-Null
    Write-Host "  Created trace sentinel: $sentinelPath" -ForegroundColor Gray
}

# Launch via gab-run
if (-not $SkipLaunch) {
    $runScript = Join-Path $PSScriptRoot "..\..\gab-run\scripts\run-gaf.ps1"
    if (-not (Test-Path $runScript)) {
        $runScript = Join-Path $env:USERPROFILE ".cursor\skills\gab-run\scripts\run-gaf.ps1"
    }
    if (-not (Test-Path $runScript)) {
        $runScript = Join-Path $env:USERPROFILE ".gab-agents\skills\gab-run\scripts\run-gaf.ps1"
    }
    if (Test-Path $runScript) {
        Write-Host "  Launching via .gaf..." -ForegroundColor Gray
        & powershell -NoProfile -ExecutionPolicy Bypass -File $runScript -Script $Script -GafPath (Join-Path $scriptDir "$scriptName.gaf")
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Launch failed"
            exit 1
        }
    } else {
        Write-Warning "gab-run skill not found -- cannot launch"
        exit 1
    }
}

# Poll for native trace files and/or custom log
Write-Host "  Waiting for trace output..." -ForegroundColor Gray

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$traceFound = $false
$traceFiles = @()

while ((Get-Date) -lt $deadline) {
    # Check for native trace files modified after launch
    if (Test-Path $gssTemp) {
        $traceFiles = @(Get-ChildItem $gssTemp -Filter "octsrs.*.debug" -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTimeUtc -gt $launchTime })
        if ($traceFiles.Count -gt 0) {
            $traceFound = $true
            # Wait a moment for the trace to finish writing
            Start-Sleep -Milliseconds 500
            $checkSizes = $traceFiles | ForEach-Object { $_.Length }
            Start-Sleep -Milliseconds 1500
            $traceFiles = @(Get-ChildItem $gssTemp -Filter "octsrs.*.debug" -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTimeUtc -gt $launchTime })
            $newSizes = $traceFiles | ForEach-Object { $_.Length }
            $stillGrowing = $false
            for ($i = 0; $i -lt [Math]::Min($checkSizes.Count, $newSizes.Count); $i++) {
                if ($newSizes[$i] -gt $checkSizes[$i]) { $stillGrowing = $true; break }
            }
            if (-not $stillGrowing) { break }
        }
    }

    # Check for error dialogs mid-poll (script died without trace)
    $midErrProcs = Get-Process | Where-Object {
        $_.ProcessName -eq "Octsrs.net" -and $_.MainWindowTitle -like "*Error*"
    } 2>$null
    if ($midErrProcs -and -not $traceFound) {
        Write-Host "  GAB error dialog appeared during wait -- script crashed" -ForegroundColor Red
        break
    }

    Start-Sleep -Milliseconds $PollIntervalMs
}

# Helper: clean up sentinel
function Remove-Sentinel {
    if ($sentinelPath -and (Test-Path $sentinelPath)) {
        Remove-Item $sentinelPath -Force -ErrorAction SilentlyContinue
        Write-Host "  Removed trace sentinel: $sentinelPath" -ForegroundColor Gray
    }
}

# Report results
Write-Host ""

# Collect all output content
$allContent = ""

if ($traceFound -and $traceFiles.Count -gt 0) {
    Write-Host "=== NATIVE TRACE CAPTURED ===" -ForegroundColor Green
    Write-Host "TRACE_STATUS=CAPTURED"
    Write-Host "TRACE_FILES=$($traceFiles.Count)"
    Write-Host ""

    foreach ($tf in $traceFiles) {
        Write-Host "--- TRACE: $($tf.Name) ($($tf.Length) bytes, $($tf.LastWriteTime)) ---" -ForegroundColor Cyan
        try {
            $traceContent = Get-Content $tf.FullName -Raw -ErrorAction SilentlyContinue
            if ($traceContent) {
                if ($Tail -gt 0) {
                    ($traceContent -split "`n") | Select-Object -Last $Tail
                } else {
                    Write-Host $traceContent
                }
                $allContent += $traceContent
            }
        } catch {
            Write-Host "  (Could not read trace file -- may still be locked)" -ForegroundColor Yellow
        }
        Write-Host "--- END TRACE ---" -ForegroundColor Cyan
        Write-Host ""
    }
} else {
    Write-Host "=== NO TRACE OUTPUT ===" -ForegroundColor Red
    Write-Host "No native trace files were created in: $gssTemp"
    Write-Host ""

    # Check if GAB threw an error dialog or left orphan processes
    $errProcs = Get-Process | Where-Object {
        $_.ProcessName -eq "Octsrs.net" -and $_.MainWindowTitle -notlike "*Global Shop*"
    } 2>$null
    if ($errProcs) {
        Write-Host "GAB ERROR DIALOG DETECTED:" -ForegroundColor Red
        foreach ($ep in $errProcs) {
            Write-Host "  PID $($ep.Id): $($ep.MainWindowTitle)" -ForegroundColor Red
        }
        Write-Host "  The script crashed before producing trace output." -ForegroundColor Yellow
        Write-Host "  Check GAB syntax, library includes, or missing subroutines." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "STALE_PIDS=$($errProcs.Id -join ',')"
    } else {
        Write-Host "Possible causes:" -ForegroundColor Yellow
        Write-Host "  1. Script crashed before the runtime could write trace data"
        Write-Host "  2. GSS/ERP is not running or .gaf association not registered"
        Write-Host "  3. The octsrs.logging sentinel was removed before the script ran"
    }
    Remove-Sentinel
    Write-Host ""
    Write-Host "TRACE_STATUS=NO_OUTPUT"
    exit 2
}

# Remove sentinel now that capture is complete
Remove-Sentinel

# Quick error scan across all captured content
if ($allContent) {
    $errorPatterns = @("ERROR:", "[ERROR]", "Error Occurred", "Runtime Error", "FAILED", "Exception")
    $foundErrors = @()
    foreach ($pat in $errorPatterns) {
        if ($allContent -match [regex]::Escape($pat)) {
            $foundErrors += $pat
        }
    }

    if ($foundErrors.Count -gt 0) {
        Write-Host ""
        Write-Host "=== ERRORS DETECTED ===" -ForegroundColor Red
        foreach ($e in $foundErrors) {
            Write-Host "  Pattern matched: $e" -ForegroundColor Red
        }
        Write-Host "TRACE_STATUS=ERRORS_FOUND"
        exit 3
    }
}

Write-Host ""
Write-Host "TRACE_STATUS=OK"
exit 0
