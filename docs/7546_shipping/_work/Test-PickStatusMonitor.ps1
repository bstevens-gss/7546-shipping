$ErrorActionPreference = 'Stop'
$bin = 'C:\APPS\GLOBAL\BIN'
$bi = [Reflection.Assembly]::LoadFrom((Join-Path $bin 'BusinessIntelligence.dll'))
Add-Type -Path (Join-Path $bin 'Newtonsoft.Json.dll')
$transfer = [Activator]::CreateInstance($bi.GetType('BusinessIntelligence.Domain.DashboardReading.Encryption.TransferContainerEncryptionProvider'))
$path = 'C:\Users\bstevens\AI\Cursor\7546\docs\7546_shipping\GAB_7546_Pick_Monitor.bixp'
$desk = 'C:\Users\bstevens\AI\Cursor\7546\docs\7546_shipping\GAB_7546_Pick_Status.bixp'
$fails = @()
function Expect([bool]$ok, [string]$name) {
  if (-not $ok) { $script:fails += $name; Write-Host "FAIL $name" }
  else { Write-Host "PASS $name" }
}
Expect (Test-Path $path) 'monitor file exists'
if (-not (Test-Path $path)) { Write-Host 'FAILED 1'; exit 1 }
function Read-Dash([string]$file) {
  $obj = Get-Content -Raw $file | ConvertFrom-Json
  $plain = [string]$transfer.GetType().GetMethod('Decrypt').Invoke($transfer, @([string]$obj.EncryptedContent)).SuccessValue
  $pack = [Newtonsoft.Json.Linq.JObject]::Parse($plain)
  return [string]$pack['_exports']['Dashboard'][0].GetValue('Data')
}
$xml = Read-Dash $path
$desktop = Read-Dash $desk
Expect ($xml.Contains('<Title Text="Picking Monitor"')) 'monitor title'
Expect ($desktop.Contains('<Title Text="Picking Status"')) 'desktop title stays'
Expect (([regex]::Matches($xml, '<Grid ')).Count -eq 1) 'one short list'
Expect ($xml.Contains('Name="Who is picking"')) 'short list is who is picking'
Expect (-not $xml.Contains('gridDashboardItem2') -and -not $xml.Contains('gridDashboardItem3')) 'long lists stay off the monitor'
Expect (-not $xml.Contains('<Pie ') -and -not $xml.Contains('<ComboBox ') -and -not $xml.Contains('<DateFilter ') -and -not $xml.Contains('<TabContainer ')) 'no mouse controls'
Expect (([regex]::Matches($xml, '<Chart ')).Count -eq 1) 'one bar chart'
Expect ($xml.Contains('SeriesType="StackedBar"')) 'bars compare people'
Expect (([regex]::Matches($xml, '<Card ComponentName="card')).Count -eq 6) 'six big numbers'
Expect ($xml.Contains('Name="Longest queue (days)"') -and $xml.Contains('LONGEST_QUEUE_DAYS') -and $xml.Contains('SummaryType="Max"')) 'longest queue is a max, not a sum'
Expect ($xml.Contains('Name="Released"') -and $xml.Contains('EARLIEST_RELEASE')) 'release time is shown'
$cards = [regex]::Matches($xml, '<Card ComponentName="card[^"]*".*?</Card></Card>')
Expect ($cards.Count -eq 6) 'big number blocks'
foreach ($c in $cards) {
  Expect ($c.Value.Contains('DeltaIndicator Visible="false"') -and $c.Value.Contains('Sparkline Visible="false"')) 'big numbers have no score'
}
Expect ($xml.Contains('DashboardItem="cardOpen"') -and $xml.Contains('DashboardItem="chartDashboardItem1"') -and $xml.Contains('DashboardItem="gridDashboardItem1"')) 'one screen'
Expect (-not $xml.Contains('V_GAB_7546_PICK_LINE')) 'line view stays off'
Expect (-not $xml.Contains('MOBILE_USER_INFO')) 'no common name join'
$date = [regex]::Match($xml, '<Dimension DataMember="OLDEST_PICK_BY_STILL_OPEN"[^/]*/>').Value
Expect ($date.Contains('DateTimeGroupInterval="DayMonthYear"')) 'short list date is a full date'
$col = [regex]::Match($xml, '<GridDimensionColumn Name="Oldest pick-by still open"[^>]*>').Value
Expect ($col.Contains('Weight="')) 'date column is wide'
$formats = [regex]::Matches($xml, '<NumericFormat [^/]*/>')
Expect ($formats.Count -gt 0) 'count format present'
foreach ($f in $formats) { Expect ($f.Value.Contains('Precision="0"')) 'counts show as whole numbers' }
if ($fails.Count -gt 0) { Write-Host ("FAILED " + $fails.Count); exit 1 }
Write-Host 'ALL PASSED'
exit 0
