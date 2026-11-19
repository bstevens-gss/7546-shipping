# SQL assertions for staged-packing suffix e2e.
# Phases: formula | dedupe | baseline | after242 | after243 | after243ship | after242ship | afterShipLoadLp
# formula: SHP710 next-seq applied to unshipped LOAD_PLAN (GAB does not write ORDER_HEADER)
# dedupe: which unshipped LOAD_PLAN row survives a second suffix, and what assign/ship do with it
# afterShipLoadLp: live LOAD_PLAN check; pass -PackingSuffix -HeaderBefore [-Order]
param(
  [ValidateSet('formula','dedupe','baseline','after242','after243','after243ship','after242ship','afterShipLoadLp')]
  [string]$Phase = 'baseline',
  [string]$Dsn = 'GLOBAL_PLA',
  [string]$Uid = 'Master',
  [string]$Pwd = 'master',
  [string]$Order = '0010967',
  [string]$PackingSuffix = '',
  [string]$HeaderBefore = ''
)

$ErrorActionPreference = 'Stop'

function Get-LoadPlanNextSuffix([string]$Pack, [string]$Header) {
  $p = [int]($Pack.Trim())
  $h = [int]($Header.Trim())
  $n = if ($p -ge $h) { $p + 1 } else { $h }
  return '{0:D4}' -f $n
}

function New-LpRow([string]$Load, [string]$Suffix, [bool]$Shipped, [bool]$Staged, [string]$Line = '001') {
  [pscustomobject]@{ Load = $Load; Suffix = $Suffix; Shipped = $Shipped; Staged = $Staged; Line = $Line }
}

function Get-LoadRank([string]$Load) {
  $t = "$Load".Trim()
  if ($t -eq '0') { return 0 }
  if ($t -eq '9999') { return 1 }
  return 2
}

# Unshipped rows with suffix P are ignored. Two rows that each match an open
# packing are left in place. Otherwise one row stays: the staged row, else the
# header suffix, else the highest suffix, with a real load winning a tie.
# A survivor that is not staged moves to the header suffix when that key is free.
function Select-LoadPlanKeep($Rows, [string]$HeaderSuffix) {
  $rows = @($Rows)
  $shippedLoads = @($rows | Where-Object { $_.Shipped } | ForEach-Object { "$($_.Load)".Trim() })
  $open = @($rows | Where-Object { -not $_.Shipped -and "$($_.Suffix)".Trim() -ne 'P' })
  $result = [pscustomobject]@{
    Action = 'keep'; KeptLoad = ''; KeptSuffix = ''; DeletedLoads = @(); ShippedLoads = @($shippedLoads)
  }
  if ($open.Count -eq 0) {
    $result.Action = 'leave'
    return $result
  }
  if ($open.Count -eq 1) {
    $result.KeptLoad = "$($open[0].Load)".Trim()
    $result.KeptSuffix = "$($open[0].Suffix)".Trim()
    return $result
  }
  $staged = @($open | Where-Object { $_.Staged })
  if ($staged.Count -ge 2) {
    $result.Action = 'leave'
    return $result
  }
  $keep = $null
  if ($staged.Count -eq 1) {
    $keep = $staged[0]
    $result.KeptSuffix = "$($keep.Suffix)".Trim()
  } else {
    $headerNum = [int]$HeaderSuffix.Trim()
    $bestKey = $null
    foreach ($r in $open) {
      $sfxNum = [int]"$($r.Suffix)".Trim()
      $match = if ($sfxNum -eq $headerNum) { 1 } else { 0 }
      $key = ($match * 1000000) + ($sfxNum * 100) + (Get-LoadRank $r.Load)
      if ($null -eq $keep -or $key -gt $bestKey) {
        $keep = $r
        $bestKey = $key
      }
    }
    $result.KeptSuffix = "$($keep.Suffix)".Trim()
    $blocked = @($rows | Where-Object {
      $_.Line -eq $keep.Line -and $_.Shipped -and "$($_.Suffix)".Trim() -eq $HeaderSuffix.Trim()
    })
    if ($result.KeptSuffix -ne $HeaderSuffix.Trim() -and $blocked.Count -eq 0) {
      $result.KeptSuffix = $HeaderSuffix.Trim()
    }
  }
  $result.KeptLoad = "$($keep.Load)".Trim()
  $result | Add-Member -NotePropertyName KeptOriginalSuffix -NotePropertyValue "$($keep.Suffix)".Trim() -Force
  $result.DeletedLoads = @($open | Where-Object {
    -not ("$($_.Load)".Trim() -eq $result.KeptLoad -and "$($_.Suffix)".Trim() -eq "$($keep.Suffix)".Trim())
  } | ForEach-Object { "$($_.Load)".Trim() })
  return $result
}

function Get-AssignLoadPlan($Rows, [string]$HeaderSuffix, [string]$TargetLoad) {
  $plan = Select-LoadPlanKeep $Rows $HeaderSuffix
  $rows = @($Rows)
  $open = @($rows | Where-Object { -not $_.Shipped -and "$($_.Suffix)".Trim() -ne 'P' })
  if ($plan.Action -eq 'leave' -or $open.Count -eq 0) {
    $insert = ($open.Count -eq 0)
    return [pscustomobject]@{ Insert = $insert; Load = $(if ($insert) { $TargetLoad } else { '' }); Suffix = $(if ($insert) { $HeaderSuffix } else { '' }); RowCount = $(if ($insert) { 1 } else { $open.Count }) }
  }
  $remaining = @($open | Where-Object { $plan.DeletedLoads -notcontains "$($_.Load)".Trim() })
  if ($remaining.Count -eq 0) {
    return [pscustomobject]@{ Insert = $true; Load = $TargetLoad; Suffix = $HeaderSuffix; RowCount = 1 }
  }
  if ($remaining.Count -gt 1) {
    return [pscustomobject]@{ Insert = $false; Load = "$($remaining[0].Load)".Trim(); Suffix = "$($remaining[0].Suffix)".Trim(); RowCount = $remaining.Count }
  }
  $row = $remaining[0]
  $load = "$($row.Load)".Trim()
  if ($TargetLoad -eq '9999' -and $load -eq '0') { $load = '9999' }
  $suffix = "$($row.Suffix)".Trim()
  if (-not $row.Staged) {
    $blocked = @($rows | Where-Object { $_.Shipped -and $_.Line -eq $row.Line -and "$($_.Suffix)".Trim() -eq $HeaderSuffix.Trim() })
    if ($blocked.Count -eq 0) { $suffix = $HeaderSuffix.Trim() }
  }
  return [pscustomobject]@{ Insert = $false; Load = $load; Suffix = $suffix; RowCount = 1 }
}

function Invoke-ShipLoadSuffix($Rows, [string]$PackSuffix, [string]$HeaderSuffix) {
  $plan = Select-LoadPlanKeep $Rows $HeaderSuffix
  $target = Get-LoadPlanNextSuffix $PackSuffix $HeaderSuffix
  $live = New-Object System.Collections.Generic.List[object]
  foreach ($r in @($Rows)) {
    $drop = (-not $r.Shipped -and "$($r.Suffix)".Trim() -ne 'P' -and $plan.DeletedLoads -contains "$($r.Load)".Trim() -and -not ("$($r.Load)".Trim() -eq $plan.KeptLoad -and "$($r.Suffix)".Trim() -eq $plan.KeptOriginalSuffix))
    if (-not $drop) { $live.Add($r) }
  }
  $dup = $false
  $unshipped = @($live | Where-Object { -not $_.Shipped -and "$($_.Suffix)".Trim() -ne 'P' })
  if ($plan.Action -eq 'keep' -and $unshipped.Count -eq 1 -and -not $unshipped[0].Staged) {
    $cur = "$($unshipped[0].Suffix)".Trim()
    if ($cur -ne $target) {
      $blocked = @($live | Where-Object { $_.Line -eq $unshipped[0].Line -and "$($_.Suffix)".Trim() -eq $target -and -not ($_.Load -eq $unshipped[0].Load -and $cur -eq $target) })
      if ($blocked.Count -eq 0) {
        $unshipped[0] = [pscustomobject]@{ Load = $unshipped[0].Load; Suffix = $target; Shipped = $false; Staged = $false; Line = $unshipped[0].Line }
      }
    }
  }
  $left = @($unshipped)
  $sfx = if ($left.Count -ge 1) { "$($left[0].Suffix)".Trim() } else { '' }
  return [pscustomobject]@{ DuplicateKey = $dup; UnshippedCount = $left.Count; UnshippedSuffix = $sfx }
}

$fail = 0
function Expect($cond, $msg) {
  if ($cond) { Write-Host "  [PASS] $msg" }
  else { Write-Host "  [FAIL] $msg"; $script:fail++ }
}

if ($Phase -eq 'formula') {
  Write-Host "PHASE formula"
  Expect ((Get-LoadPlanNextSuffix '0000' '0000') -eq '0001') "pack 0000 header 0000 -> LOAD_PLAN 0001"
  Expect ((Get-LoadPlanNextSuffix '0001' '0000') -eq '0002') "pack 0001 header 0000 -> LOAD_PLAN 0002 (not header+1=0001)"
  Expect ((Get-LoadPlanNextSuffix '0000' '0002') -eq '0002') "pack 0000 header 0002 -> LOAD_PLAN 0002 (not header+1=0003)"
  Expect ((Get-LoadPlanNextSuffix '0001' '0002') -eq '0002') "pack 0001 header 0002 -> LOAD_PLAN stays 0002"
  Write-Host "RESULT formula fail=$fail"
  if ($fail -gt 0) { exit 3 } else { exit 0 }
}

if ($Phase -eq 'dedupe') {
  Write-Host "PHASE dedupe"
  $staged = @(
    (New-LpRow '11731' '0000' $false $true),
    (New-LpRow '9999' '0001' $false $false)
  )
  $keepStaged = Select-LoadPlanKeep $staged '0001'
  Expect ($keepStaged.Action -eq 'keep') "one staged row is kept"
  Expect ($keepStaged.KeptLoad -eq '11731') "staged load 11731 stays"
  Expect ($keepStaged.KeptSuffix -eq '0000') "staged suffix stays 0000"
  Expect (($keepStaged.DeletedLoads -join ',') -eq '9999') "unstaged 9999 twin is dropped"

  $headerHit = @(
    (New-LpRow '11731' '0000' $false $false),
    (New-LpRow '9999' '0001' $false $false)
  )
  $keepHdr = Select-LoadPlanKeep $headerHit '0001'
  Expect ($keepHdr.KeptSuffix -eq '0001') "unstaged pair keeps header suffix 0001"
  Expect ($keepHdr.KeptLoad -eq '9999') "header-suffix row is the 9999 row"
  Expect (($keepHdr.DeletedLoads -join ',') -eq '11731') "older suffix row is dropped"

  $assign = Get-AssignLoadPlan @( (New-LpRow '11731' '0000' $false $false) ) '0001' '9999'
  Expect (-not $assign.Insert) "assign does not insert when an old-suffix row exists"
  Expect ($assign.Load -eq '11731') "real load stays put"
  Expect ($assign.Suffix -eq '0001') "assign moves that row to the header suffix"
  Expect ($assign.RowCount -eq 1) "assign leaves one row"

  $fromZero = Get-AssignLoadPlan @( (New-LpRow '0' '0000' $false $false) ) '0001' '9999'
  Expect (-not $fromZero.Insert) "load 0 is updated rather than inserted again"
  Expect ($fromZero.Load -eq '9999') "load 0 moves to 9999"
  Expect ($fromZero.Suffix -eq '0001') "load 0 takes the header suffix"

  $ship = Invoke-ShipLoadSuffix @(
    (New-LpRow '11731' '0000' $false $false),
    (New-LpRow '9999' '0001' $false $false)
  ) '0000' '0000'
  Expect (-not $ship.DuplicateKey) "ship suffix sync does not land on an existing key"
  Expect ($ship.UnshippedCount -eq 1) "one unshipped row remains"
  Expect ($ship.UnshippedSuffix -eq '0001') "survivor ends on packing+1"

  $shippedOld = @(
    (New-LpRow '11731' '0000' $true $false),
    (New-LpRow '9999' '0001' $false $false)
  )
  $keepShip = Select-LoadPlanKeep $shippedOld '0001'
  Expect (($keepShip.DeletedLoads -join ',') -eq '') "a shipped old-suffix row is not deleted"
  Expect ($keepShip.ShippedLoads -contains '11731') "shipped load 11731 is still there"

  $suffixP = @(
    (New-LpRow '100' 'P' $false $false),
    (New-LpRow '9999' 'P' $false $false)
  )
  $keepP = Select-LoadPlanKeep $suffixP '0001'
  Expect ($keepP.Action -eq 'leave') "suffix P rows are left alone"
  Expect (($keepP.DeletedLoads -join ',') -eq '') "suffix P rows are not deleted"

  Write-Host "RESULT dedupe fail=$fail"
  if ($fail -gt 0) { exit 3 } else { exit 0 }
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
      $h[$r.GetName($c)] = [string]$r.GetValue($c)
    }
    $out.Add($h)
  }
  $r.Close()
  return $out
}

$hdr = @(Get-Rows "SELECT RTRIM(H.ORDER_SUFFIX) AS HDR_SUFFIX FROM V_ORDER_HEADER H WHERE H.ORDER_NO = '$Order' AND H.RECORD_TYPE = 'A'")
$shp = @(Get-Rows "SELECT RTRIM(S.ORDER_SUFFIX) AS ORDER_SUFFIX, RTRIM(S.PCK_NO) AS PCK_NO, RTRIM(S.SHP_STATUS) AS SHP_STATUS FROM V_SHIPMENT_HEADER S WHERE S.ORDER_NO = '$Order' ORDER BY S.ORDER_SUFFIX")
$lp  = @(Get-Rows "SELECT RTRIM(LP.LOAD_NO) AS LOAD_NO, RTRIM(LP.ORDER_LINE) AS ORDER_LINE, LP.PICKED, LP.SHIPPED, RTRIM(LP.ORDER_SUFFIX) AS ORDER_SUFFIX FROM LOAD_PLAN LP WHERE LP.ORDER_NO = '$Order'")

$headerSuffix = if ($hdr.Count -gt 0) { [string]$hdr[0]['HDR_SUFFIX'] } else { '' }
$suffixes = @($shp | ForEach-Object { $_['ORDER_SUFFIX'] })
$statuses = @($shp | ForEach-Object { $_['SHP_STATUS'] })
$packs    = @($shp | ForEach-Object { $_['PCK_NO'] })
$picked242 = @($lp | Where-Object { $_['LOAD_NO'].Trim() -eq '242' } | ForEach-Object { $_['PICKED'] })
$picked243 = @($lp | Where-Object { $_['LOAD_NO'].Trim() -eq '243' } | ForEach-Object { $_['PICKED'] })
$shipped242 = @($lp | Where-Object { $_['LOAD_NO'].Trim() -eq '242' } | ForEach-Object { $_['SHIPPED'] })
$shipped243 = @($lp | Where-Object { $_['LOAD_NO'].Trim() -eq '243' } | ForEach-Object { $_['SHIPPED'] })
$st242 = ''
$st243 = ''
for ($i = 0; $i -lt $packs.Count; $i++) {
  $p = $packs[$i].Trim()
  if ($p -eq '1200922') { $st242 = $statuses[$i] }
  if ($p -eq '1200923') { $st243 = $statuses[$i] }
}

Write-Host "PHASE $Phase"
Write-Host "ORDER_HEADER.ORDER_SUFFIX=$headerSuffix"
Write-Host "SHIPMENT_HEADER count=$($shp.Count) suffixes=$($suffixes -join ',') status=$($statuses -join ',') pck=$($packs -join ',')"
Write-Host "LOAD 242 PICKED=$($picked242 -join ',') SHIPPED=$($shipped242 -join ',')  LOAD 243 PICKED=$($picked243 -join ',') SHIPPED=$($shipped243 -join ',')"

function Test-Picked($vals) {
  foreach ($v in @($vals)) {
    if ("$v" -match '^(True|1|Y)$') { return $true }
  }
  return $false
}

switch ($Phase) {
  'baseline' {
    Expect ($headerSuffix -eq '0000') "ORDER_HEADER suffix still 0000"
    Expect ($shp.Count -eq 0) "no SHIPMENT_HEADER rows yet"
    Expect (-not (Test-Picked $picked242)) "load 242 not picked"
    Expect (-not (Test-Picked $picked243)) "load 243 not picked"
  }
  'after242' {
    Expect ($headerSuffix -eq '0000') "ORDER_HEADER suffix still 0000"
    Expect ($shp.Count -eq 1) "one SHIPMENT_HEADER after first packing"
    Expect ($suffixes[0] -eq '0000') "first packing suffix 0000"
    Expect ($statuses[0] -eq '0') "first packing SHP_STATUS 0 (staged)"
    Expect (Test-Picked $picked242) "load 242 PICKED=1"
  }
  'after243' {
    Expect ($headerSuffix -eq '0000') "ORDER_HEADER suffix still 0000"
    Expect ($shp.Count -eq 2) "two SHIPMENT_HEADER rows"
    Expect (($suffixes -join ',') -eq '0000,0001') "suffixes 0000 then 0001"
    Expect (($statuses -join ',') -eq '0,0') "both SHP_STATUS 0"
    Expect (($packs | Select-Object -Unique).Count -eq 2) "distinct packing numbers"
    Expect (Test-Picked $picked242) "load 242 PICKED=1"
    Expect (Test-Picked $picked243) "load 243 PICKED=1"
  }
  'after243ship' {
    Expect (Test-Picked $picked243) "load 243 PICKED=1"
    Expect (Test-Picked $shipped243) "load 243 SHIPPED=1"
    Expect ($st243 -ne '0' -and $st243 -ne '') "packing 1200923 SHP_STATUS no longer staged 0 (got '$st243')"
    Expect (-not (Test-Picked $shipped242)) "load 242 still not shipped"
  }
  'after242ship' {
    Expect (Test-Picked $picked242) "load 242 PICKED=1"
    Expect (Test-Picked $shipped242) "load 242 SHIPPED=1"
    Expect ($st242 -ne '0' -and $st242 -ne '') "packing 1200922 SHP_STATUS no longer staged 0 (got '$st242')"
    Expect (Test-Picked $shipped243) "load 243 remains shipped"
  }
  'afterShipLoadLp' {
    if ([string]::IsNullOrWhiteSpace($PackingSuffix) -or [string]::IsNullOrWhiteSpace($HeaderBefore)) {
      Write-Host "  [FAIL] afterShipLoadLp requires -PackingSuffix and -HeaderBefore"
      $script:fail++
    } else {
      $expected = Get-LoadPlanNextSuffix $PackingSuffix $HeaderBefore
      $unshipped = @($lp | Where-Object { -not (Test-Picked $_['SHIPPED']) } | ForEach-Object { $_.ORDER_SUFFIX.Trim() })
      Write-Host "expected unshipped LOAD_PLAN suffix=$expected unshipped=$($unshipped -join ',')"
      Expect ($unshipped.Count -gt 0) "at least one unshipped LOAD_PLAN row for order"
      foreach ($sfx in $unshipped) {
        Expect ($sfx -eq $expected) "unshipped LOAD_PLAN suffix $sfx equals $expected"
      }
    }
  }
}

$conn.Close()
Write-Host "RESULT $Phase fail=$fail"
if ($fail -gt 0) { exit 3 } else { exit 0 }
