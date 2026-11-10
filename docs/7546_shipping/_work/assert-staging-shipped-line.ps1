# Staging Shipments must not list an order line that is already on Shipped Orders.
# The sibling query (dtLTemp) adds order lines that are not in STAGING_QUANTITY
# onto the open packing list. A line with LN_SHP_STAT <> 0 and QTY_SHIPPED <> 0
# is already shipped and must stay off that list.
# 0010657 / 0010: ship status 1, qty backordered still 10. Must be absent.
# 0010967 / 0050: fully shipped sibling (qty backordered 0). Must be absent.
# 0010967 / 0010: never shipped. Must remain.
param(
  [string]$Dsn = 'GLOBAL_PLA',
  [string]$Uid = 'Master',
  [string]$Pwd = 'master',
  [string]$Script = ''
)

$ErrorActionPreference = 'Stop'
if ($Script -eq '') {
  $Script = Join-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent) 'GAB_7546_OE_ShippingReview_Load.g2u'
}

$text = [System.IO.File]::ReadAllText($Script)
$marker = 'CreateFromSQL("dtLTemp","con","'
$start = $text.IndexOf($marker)
if ($start -lt 0) { throw "dtLTemp SQL not found in $Script" }
$start += $marker.Length
$end = $text.IndexOf('")', $start)
if ($end -lt 0) { throw "dtLTemp SQL end not found" }
$sql = $text.Substring($start, $end - $start).Trim().TrimEnd(';')

$conn = New-Object System.Data.Odbc.OdbcConnection("DSN=$Dsn;UID=$Uid;PWD=$Pwd")
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $sql
$da = New-Object System.Data.Odbc.OdbcDataAdapter $cmd
$dt = New-Object System.Data.DataTable
[void]$da.Fill($dt)
$conn.Close()

function Has-Line($order, $line) {
  foreach ($row in $dt.Rows) {
    if ($row['ORDER_NO'].ToString().Trim() -eq $order -and $row['Line'].ToString().Trim() -eq $line) { return $true }
  }
  return $false
}

$fail = 0
function Expect($cond, $msg) {
  if ($cond) { Write-Host "  [PASS] $msg" }
  else { Write-Host "  [FAIL] $msg"; $script:fail++ }
}

Write-Host "dtLTemp rows=$($dt.Rows.Count)"
Expect (-not (Has-Line '0010657' '0010')) "0010657 line 0010 (ship status 1, backorder 10) is not on Staging"
Expect (-not (Has-Line '0010967' '0050')) "0010967 line 0050 (fully shipped) is not on Staging"
Expect (Has-Line '0010967' '0010') "0010967 line 0010 (never shipped) stays on Staging"
Write-Host "RESULT fail=$fail"
if ($fail -gt 0) { exit 1 }
exit 0
