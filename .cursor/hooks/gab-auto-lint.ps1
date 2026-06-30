$input = [Console]::In.ReadToEnd() | ConvertFrom-Json
$filePath = $input.filepath

if ($filePath -notmatch '\.(g2u|lib)$') {
    exit 0
}

$lintScript = Join-Path $env:USERPROFILE ".cursor\skills\gab-lint\scripts\gab-lint.ps1"
if (-not (Test-Path $lintScript)) {
    $result = @{ additional_context = "gab-lint skill not installed at $lintScript" }
    $result | ConvertTo-Json -Compress
    exit 0
}

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $lintScript -Path $filePath -Format json -Severity warning 2>&1
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    $result = @{ additional_context = "GAB lint: no issues found in $(Split-Path $filePath -Leaf)" }
} elseif ($exitCode -eq 1) {
    $issues = ($output | Out-String).Trim()
    if ($issues.Length -gt 2000) { $issues = $issues.Substring(0, 2000) + "... (truncated)" }
    $result = @{ additional_context = "GAB lint issues in $(Split-Path $filePath -Leaf):`n$issues" }
} else {
    $result = @{ additional_context = "GAB lint skipped (exit code $exitCode)" }
}

$result | ConvertTo-Json -Compress
exit 0
