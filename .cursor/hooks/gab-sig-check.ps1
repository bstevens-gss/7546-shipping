$input = [Console]::In.ReadToEnd() | ConvertFrom-Json
$filePath = $input.filepath

if ($filePath -notmatch '\.g2u$') {
    exit 0
}

$sigPath = "$filePath.sig"
$fileName = Split-Path $filePath -Leaf

if (-not (Test-Path $sigPath)) {
    $result = @{ additional_context = "WARNING: No .sig file found for $fileName. The script cannot run outside the Code Editor until signed. Use the gab-sign skill to create the signature." }
    $result | ConvertTo-Json -Compress
    exit 0
}

$g2uTime = (Get-Item $filePath).LastWriteTime
$sigTime = (Get-Item $sigPath).LastWriteTime

if ($g2uTime -gt $sigTime) {
    $result = @{ additional_context = "WARNING: Signature is STALE for $fileName (.g2u modified after .sig). Re-sign with the gab-sign skill before running." }
    $result | ConvertTo-Json -Compress
    exit 0
}

exit 0
