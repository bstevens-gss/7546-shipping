<#
.SYNOPSIS
    Run a GAB .g2u script via the .gaf launch mechanism.

.DESCRIPTION
    1. Validates the GSS environment (finds Global dir, checks GSS_GAF.g2u has Trans900000)
    2. Optionally signs the .g2u file (calls gab-sign skill)
    3. Creates a .gaf file with TRANSID::900000 and SCRIPT::<path>
    4. Shell-executes the .gaf (Windows file association launches GSS_GAF_Launch.gas)

    On re-run, kills only the PIDs spawned by the previous launch (tracked in
    a .gaf.pids file). Never touches other GAB apps the user has open.

.PARAMETER Script
    Path to the .g2u file to run.

.PARAMETER Sign
    If set, signs the .g2u before launching (recommended after edits).

.PARAMETER GafPath
    Optional explicit path for the .gaf file. Defaults to same dir as script.

.PARAMETER NoLaunch
    If set, creates the .gaf but does not launch it.

.PARAMETER SkipPreflight
    Skip the GSS_GAF.g2u environment validation.

.EXAMPLE
    .\run-gaf.ps1 -Script "MyScript.g2u" -Sign

.EXAMPLE
    .\run-gaf.ps1 -Script "MyScript.g2u" -SkipPreflight
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$Script,

    [switch]$Sign,

    [string]$GafPath,

    [switch]$NoLaunch,

    [switch]$SkipPreflight
)

$ErrorActionPreference = "Stop"

$Script = [System.IO.Path]::GetFullPath($Script)

if (-not (Test-Path $Script)) {
    Write-Error "Script not found: $Script"
    exit 1
}

# --- Resolve gab-sign script path (used by preflight and user signing) ---
function Find-SignScript {
    $candidate = Join-Path $PSScriptRoot "..\..\gab-sign\scripts\sign-g2u.ps1"
    if (Test-Path $candidate) { return (Resolve-Path $candidate).Path }
    $candidate = Join-Path $env:USERPROFILE ".cursor\skills\gab-sign\scripts\sign-g2u.ps1"
    if (Test-Path $candidate) { return $candidate }
    return $null
}

# --- Resolve GSS Global directory ---
function Find-GlobalDir {
    if ($env:GSS_GLOBAL_DIR -and (Test-Path $env:GSS_GLOBAL_DIR)) {
        return $env:GSS_GLOBAL_DIR
    }
    foreach ($drive in @("C","D","E","F")) {
        foreach ($sub in @("$($drive):\APPS\GLOBAL", "$($drive):\GLOBAL")) {
            if (Test-Path (Join-Path $sub "plugins\GAB")) { return $sub }
        }
    }
    $regPaths = @(
        "HKLM:\SOFTWARE\Global Shop Solutions",
        "HKLM:\SOFTWARE\WOW6432Node\Global Shop Solutions"
    )
    foreach ($rp in $regPaths) {
        $val = (Get-ItemProperty $rp -Name "GlobalDirectory" -ErrorAction SilentlyContinue).GlobalDirectory
        if ($val -and (Test-Path $val)) { return $val }
    }
    return $null
}

# --- Collect all descendant PIDs from a root process (BFS via Win32_Process) ---
function Get-DescendantPids {
    param([int]$RootPid)

    $all = @($RootPid)
    $frontier = @($RootPid)

    while ($frontier.Count -gt 0) {
        $next = @()
        foreach ($parent in $frontier) {
            $children = Get-CimInstance Win32_Process -Filter "ParentProcessId = $parent" -ErrorAction SilentlyContinue
            foreach ($child in $children) {
                $cid = [int]$child.ProcessId
                if ($cid -notin $all) {
                    $all += $cid
                    $next += $cid
                }
            }
        }
        $frontier = $next
    }

    return $all
}

# --- Preflight: validate GSS_GAF.g2u environment ---
if (-not $SkipPreflight) {
    Write-Host ""
    Write-Host "--- GSS Environment Preflight ---" -ForegroundColor Cyan

    $globalDir = Find-GlobalDir
    if (-not $globalDir) {
        Write-Host "  FAIL  Cannot find GSS Global directory." -ForegroundColor Red
        Write-Host "        Set GSS_GLOBAL_DIR env var or run setup-dev-env.ps1." -ForegroundColor Gray
        exit 1
    }
    Write-Host "  OK    Global directory: $globalDir" -ForegroundColor Green

    $gasDir = Join-Path $globalDir "PLUGINS\GAB\GAS"
    $gafScript = Join-Path $gasDir "GSS_GAF.g2u"
    $gafSig    = Join-Path $gasDir "GSS_GAF.g2u.sig"

    # Check GSS_GAF.g2u exists
    if (-not (Test-Path $gafScript)) {
        Write-Host "  FAIL  GSS_GAF.g2u not found at $gafScript" -ForegroundColor Red
        Write-Host "        The GSS GAF dispatcher script is missing from this installation." -ForegroundColor Gray
        exit 1
    }
    Write-Host "  OK    GSS_GAF.g2u exists" -ForegroundColor Green

    # Check for Trans900000 subroutine
    $gafContent = [System.IO.File]::ReadAllText($gafScript)
    if ($gafContent -match "Program\.Sub\.Trans900000\.Start") {
        Write-Host "  OK    Trans900000 present in GSS_GAF.g2u" -ForegroundColor Green
    } else {
        Write-Host "  WARN  Trans900000 MISSING from GSS_GAF.g2u -- injecting..." -ForegroundColor Yellow

        # Load the Trans900000 template block
        $templatePath = Join-Path $PSScriptRoot "..\templates\trans900000.g2u.block"
        if (-not (Test-Path $templatePath)) {
            Write-Host "  FAIL  Template not found at $templatePath" -ForegroundColor Red
            exit 1
        }
        $trans900000Block = [System.IO.File]::ReadAllText($templatePath)

        # Inject before Program.Sub.Comments.Start (standard anchor point)
        if ($gafContent -match "Program\.Sub\.Comments\.Start") {
            $gafContent = $gafContent -replace "(Program\.Sub\.Comments\.Start)", "$trans900000Block`r`n`r`n`$1"
        } else {
            $gafContent = $gafContent.TrimEnd() + "`r`n`r`n" + $trans900000Block + "`r`n"
        }

        [System.IO.File]::WriteAllText($gafScript, $gafContent)
        Write-Host "  OK    Trans900000 injected into GSS_GAF.g2u" -ForegroundColor Green

        # Re-sign GSS_GAF.g2u
        $signPath = Find-SignScript
        if ($signPath) {
            Write-Host "  ...   Signing GSS_GAF.g2u..." -ForegroundColor Yellow
            & powershell -NoProfile -ExecutionPolicy Bypass -File $signPath -Path $gafScript -SkipTimestamps
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  OK    GSS_GAF.g2u signed" -ForegroundColor Green
            } else {
                Write-Host "  FAIL  Could not sign GSS_GAF.g2u (exit $LASTEXITCODE)" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "  FAIL  gab-sign skill not found -- cannot sign GSS_GAF.g2u" -ForegroundColor Red
            exit 1
        }
    }

    # Check .sig exists for GSS_GAF.g2u
    if (-not (Test-Path $gafSig)) {
        Write-Host "  WARN  GSS_GAF.g2u.sig missing -- signing..." -ForegroundColor Yellow
        $signPath = Find-SignScript
        if ($signPath) {
            & powershell -NoProfile -ExecutionPolicy Bypass -File $signPath -Path $gafScript -SkipTimestamps
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  OK    GSS_GAF.g2u signed" -ForegroundColor Green
            } else {
                Write-Host "  FAIL  Could not sign GSS_GAF.g2u" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "  FAIL  gab-sign skill not found and .sig is missing" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "  OK    GSS_GAF.g2u.sig exists" -ForegroundColor Green
    }

    Write-Host "--- Preflight passed ---" -ForegroundColor Cyan
    Write-Host ""
}

# Sign the user's script if requested (always -Force: lint gate belongs to the lint skill, not run)
if ($Sign) {
    $signScript = Find-SignScript
    if ($signScript) {
        Write-Host "Signing $Script ..."
        & powershell -NoProfile -ExecutionPolicy Bypass -File $signScript -Path $Script -Force
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Signing failed"
            exit 1
        }
    } else {
        Write-Warning "gab-sign skill not found -- skipping sign"
    }
}

# Verify .sig exists for the user's script
$sigPath = "$Script.sig"
if (-not (Test-Path $sigPath)) {
    Write-Error "No .sig file found at $sigPath -- script will not run. Use -Sign to auto-sign."
    exit 1
}

# Determine paths
$scriptDir  = [System.IO.Path]::GetDirectoryName($Script)
$scriptName = [System.IO.Path]::GetFileNameWithoutExtension($Script)
if (-not $GafPath) {
    $GafPath = Join-Path $scriptDir "$scriptName.gaf"
}
$pidFile = Join-Path $scriptDir "$scriptName.gaf.pids"

# --- Kill only PIDs we previously tracked ---
if (Test-Path $pidFile) {
    $trackedPids = Get-Content $pidFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }
    $killedAny = $false
    foreach ($tpid in $trackedPids) {
        $proc = Get-Process -Id ([int]$tpid) -ErrorAction SilentlyContinue
        if ($proc -and $proc.ProcessName -eq "Octsrs.net") {
            $title = if ($proc.MainWindowTitle) { $proc.MainWindowTitle } else { "(no window)" }
            Write-Host "  Killing tracked PID $tpid ($title)..." -ForegroundColor Yellow
            Stop-Process -Id ([int]$tpid) -Force -ErrorAction SilentlyContinue
            $killedAny = $true
        } elseif ($proc) {
            Write-Host "  Skipping PID $tpid -- process is now $($proc.ProcessName), not Octsrs.net" -ForegroundColor DarkYellow
        }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
    if ($killedAny) { Start-Sleep -Milliseconds 500 }
}

# Snapshot Octsrs.net PIDs before launch (used only by name-diff fallback)
$pidsBefore = @(Get-Process -Name "Octsrs.net" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)

# Remove existing .gaf if present (may be stale/locked)
if (Test-Path $GafPath) {
    $retries = 3
    for ($r = 1; $r -le $retries; $r++) {
        try {
            Remove-Item $GafPath -Force -ErrorAction Stop
            break
        } catch {
            if ($r -eq $retries) {
                Write-Error "Cannot remove locked .gaf after $retries attempts: $GafPath"
                exit 1
            }
            Write-Host "  .gaf locked, retry $r/$retries..." -ForegroundColor Yellow
            Start-Sleep -Milliseconds 500
        }
    }
}

# Write the .gaf file
$gafContent = "TRANSID::900000`r`nSCRIPT::$Script"
[System.IO.File]::WriteAllText($GafPath, $gafContent)
Write-Host "Created: $GafPath"
Write-Host "  TRANSID: 900000"
Write-Host "  SCRIPT:  $Script"

# Launch and track spawned PIDs
if (-not $NoLaunch) {
    Write-Host "Launching..."
    $launcher = Start-Process $GafPath -PassThru
    $launcherPid = $launcher.Id

    # Poll for Octsrs.net PIDs in the launcher's descendant tree (GAF chain spawns ~3 processes).
    # Chain: .gaf -> GSSMenu -> GSS_GAF_Launch.gas -> GSS_GAF.g2u -> your script.
    # Parent tracking may fail across COM/shell boundaries; fall back to a narrow name-diff window.
    $maxWaitMs   = 20000
    $minWaitMs   = 12000
    $pollMs      = 1000
    $elapsed     = 0
    $newPids     = @()
    $prevCount   = 0
    $stablePolls = 0

    while ($elapsed -lt $maxWaitMs) {
        Start-Sleep -Milliseconds $pollMs
        $elapsed += $pollMs

        $descendants = Get-DescendantPids -RootPid $launcherPid
        $candidates = @()
        foreach ($dpid in $descendants) {
            $proc = Get-Process -Id $dpid -ErrorAction SilentlyContinue
            if ($proc -and $proc.ProcessName -eq "Octsrs.net") {
                $candidates += $dpid
            }
        }
        $newPids = @($candidates | Sort-Object -Unique)

        if ($newPids.Count -eq $prevCount -and $newPids.Count -gt 0) {
            $stablePolls++
        } else {
            $stablePolls = 0
        }
        $prevCount = $newPids.Count

        if ($stablePolls -ge 2 -and $elapsed -ge $minWaitMs) { break }
    }

    if ($newPids.Count -eq 0) {
        Write-Host "  Parent tracking found no Octsrs.net processes; trying name-diff fallback..." -ForegroundColor Yellow

        $fallbackMaxMs    = 15000
        $fallbackPollMs   = 500
        $fallbackStableMs = 4000
        $fallbackElapsed  = 0
        $firstDetectedAt  = $null

        while ($fallbackElapsed -lt $fallbackMaxMs) {
            Start-Sleep -Milliseconds $fallbackPollMs
            $fallbackElapsed += $fallbackPollMs

            $pidsNow = @(Get-Process -Name "Octsrs.net" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)
            $candidates = @($pidsNow | Where-Object { $_ -notin $pidsBefore })
            $validated = @()
            foreach ($cpid in $candidates) {
                $proc = Get-Process -Id $cpid -ErrorAction SilentlyContinue
                if ($proc -and $proc.ProcessName -eq "Octsrs.net") {
                    $validated += $cpid
                }
            }
            $newPids = @($validated | Sort-Object -Unique)

            if ($newPids.Count -gt 0 -and -not $firstDetectedAt) {
                $firstDetectedAt = $fallbackElapsed
            }

            if ($firstDetectedAt -and ($fallbackElapsed - $firstDetectedAt) -ge $fallbackStableMs) {
                break
            }
        }
    }

    # Write tracked PIDs
    if ($newPids.Count -gt 0) {
        if ($newPids.Count -gt 4) {
            Write-Host "  Warning: captured $($newPids.Count) PIDs (chain normally spawns ~3)" -ForegroundColor Yellow
        }
        $capturedAt = (Get-Date).ToString("s")
        $header = "# launcher=$launcherPid captured=$capturedAt"
        @($header) + ($newPids | ForEach-Object { "$_" }) | Out-File -FilePath $pidFile -Encoding ascii
        Write-Host "  Tracking $($newPids.Count) spawned PID(s): $($newPids -join ', ')" -ForegroundColor Cyan
    } else {
        $maxWaitSec = [math]::Round($maxWaitMs / 1000)
        Write-Host "  Warning: no new Octsrs.net PIDs detected after ${maxWaitSec}s" -ForegroundColor Yellow
    }

    Write-Host "Done -- GAB script dispatched via .gaf"
} else {
    Write-Host "NoLaunch set -- .gaf created but not executed"
}
