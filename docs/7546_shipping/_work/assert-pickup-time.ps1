# SQL assertions for Load tab Pickup Time / Dropoff Time.
# Phases: projection | afteredit
# projection: sentinel 1900-01-01 12:00:00 becomes empty; load 101 keeps 12/22/2023
# afteredit: all unshipped LOAD_PLAN rows for -LoadNo match -ExpectedPickup / -ExpectedDropoff;
#            shipped rows for the same load stay at -ShippedPickup / -ShippedDropoff (default sentinel)
param(
  [ValidateSet('projection','afteredit')]
  [string]$Phase = 'projection',
  [string]$Dsn = 'GLOBAL_PLA',
  [string]$Uid = 'Master',
  [string]$Pwd = 'master',
  [int]$LoadNo = 218,
  [string]$ExpectedPickup = '2026-08-27 14:30:00',
  [string]$ExpectedDropoff = '2026-08-27 16:00:00',
  [string]$ShippedPickup = '1900-01-01 12:00:00',
  [string]$ShippedDropoff = '1900-01-01 12:00:00'
)

$ErrorActionPreference = 'Stop'

$fail = 0
function Expect($cond, $msg) {
  if ($cond) { Write-Host "  [PASS] $msg" }
  else { Write-Host "  [FAIL] $msg"; $script:fail++ }
}

function Normalize-Ts([string]$v) {
  if ([string]::IsNullOrWhiteSpace($v) -or $v -eq [string][DBNull]::Value) { return '' }
  $dt = [datetime]::MinValue
  if ([datetime]::TryParse($v, [ref]$dt)) {
    return $dt.ToString('yyyy-MM-dd HH:mm:ss')
  }
  return $v.Trim()
}

$conn = New-Object System.Data.Odbc.OdbcConnection("DSN=$Dsn;UID=$Uid;PWD=$Pwd")
$conn.Open()
function Get-Rows($sql) {
  $cmd = $conn.CreateCommand()
  $cmd.CommandText = $sql
  $r = $cmd.ExecuteReader()
  $out = New-Object System.Collections.Generic.List[hashtable]
  while ($r.Read()) {
    $h = @{}
    for ($c = 0; $c -lt $r.FieldCount; $c++) {
      $val = $r.GetValue($c)
      if ($val -is [DBNull]) { $h[$r.GetName($c)] = '' }
      else { $h[$r.GetName($c)] = [string]$val }
    }
    $out.Add($h)
  }
  $r.Close()
  return $out
}

Write-Host "PHASE $Phase"

switch ($Phase) {
  'projection' {
    $sql = @"
SELECT LOAD_NO,
  CASE WHEN PICKUP_TIME = '1900-01-01 12:00:00' THEN CONVERT(NULL, SQL_TIMESTAMP) ELSE PICKUP_TIME END AS PICKUP_TIME,
  CASE WHEN DROPOFF_TIME = '1900-01-01 12:00:00' THEN CONVERT(NULL, SQL_TIMESTAMP) ELSE DROPOFF_TIME END AS DROPOFF_TIME
FROM LOAD_PLAN
WHERE LOAD_NO IN (101, 242, 243)
"@
    $rows = @(Get-Rows $sql)
    Expect ($rows.Count -gt 0) "projection returned rows for loads 101/242/243"

    $r101 = @($rows | Where-Object { $_.LOAD_NO.Trim() -eq '101' })
    $r242 = @($rows | Where-Object { $_.LOAD_NO.Trim() -eq '242' })
    $r243 = @($rows | Where-Object { $_.LOAD_NO.Trim() -eq '243' })

    if ($r101.Count -gt 0) {
      $p = Normalize-Ts $r101[0]['PICKUP_TIME']
      Expect ($p.StartsWith('2023-12-22')) "load 101 pickup survives conversion (got '$p')"
    } else {
      Expect $false "load 101 exists for projection"
    }

    foreach ($row in ($r242 + $r243)) {
      $p = Normalize-Ts $row['PICKUP_TIME']
      $d = Normalize-Ts $row['DROPOFF_TIME']
      Expect ($p -eq '') "sentinel pickup projects empty for load $($row.LOAD_NO) (got '$p')"
      Expect ($d -eq '') "sentinel dropoff projects empty for load $($row.LOAD_NO) (got '$d')"
    }
  }
  'afteredit' {
    $rows = @(Get-Rows "SELECT LOAD_NO, SHIPPED, PICKUP_TIME, DROPOFF_TIME FROM LOAD_PLAN WHERE LOAD_NO = $LoadNo")
    Expect ($rows.Count -gt 0) "LOAD_PLAN has rows for load $LoadNo"

    $unshipped = @($rows | Where-Object { $_.SHIPPED -notmatch '^(True|1|Y)$' })
    $shipped = @($rows | Where-Object { $_.SHIPPED -match '^(True|1|Y)$' })
    $expP = Normalize-Ts $ExpectedPickup
    $expD = Normalize-Ts $ExpectedDropoff
    $shpP = Normalize-Ts $ShippedPickup
    $shpD = Normalize-Ts $ShippedDropoff

    Write-Host "load=$LoadNo unshipped=$($unshipped.Count) shipped=$($shipped.Count) expectedPickup=$expP expectedDropoff=$expD"

    Expect ($unshipped.Count -gt 0) "at least one unshipped LOAD_PLAN row for load $LoadNo"
    foreach ($row in $unshipped) {
      $p = Normalize-Ts $row['PICKUP_TIME']
      $d = Normalize-Ts $row['DROPOFF_TIME']
      Expect ($p -eq $expP) "unshipped pickup '$p' equals '$expP'"
      Expect ($d -eq $expD) "unshipped dropoff '$d' equals '$expD'"
    }
    foreach ($row in $shipped) {
      $p = Normalize-Ts $row['PICKUP_TIME']
      $d = Normalize-Ts $row['DROPOFF_TIME']
      Expect ($p -eq $shpP) "shipped pickup stays '$shpP' (got '$p')"
      Expect ($d -eq $shpD) "shipped dropoff stays '$shpD' (got '$d')"
    }
  }
}

$conn.Close()
Write-Host "RESULT $Phase fail=$fail"
if ($fail -gt 0) { exit 3 } else { exit 0 }
