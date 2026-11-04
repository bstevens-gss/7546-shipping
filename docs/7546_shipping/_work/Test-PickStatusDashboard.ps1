$ErrorActionPreference = 'Stop'
$bin = 'C:\APPS\GLOBAL\BIN'
$bi = [Reflection.Assembly]::LoadFrom((Join-Path $bin 'BusinessIntelligence.dll'))
Add-Type -Path (Join-Path $bin 'Newtonsoft.Json.dll')
$transfer = [Activator]::CreateInstance($bi.GetType('BusinessIntelligence.Domain.DashboardReading.Encryption.TransferContainerEncryptionProvider'))
$path = 'C:\Users\bstevens\AI\Cursor\7546\docs\7546_shipping\GAB_7546_Pick_Status.bixp'
$obj = Get-Content -Raw $path | ConvertFrom-Json
$plain = [string]$transfer.GetType().GetMethod('Decrypt').Invoke($transfer, @([string]$obj.EncryptedContent)).SuccessValue
$pack = [Newtonsoft.Json.Linq.JObject]::Parse($plain)
$xml = [string]$pack['_exports']['Dashboard'][0].GetValue('Data')
$fails = @()
function Expect([bool]$ok, [string]$name) {
  if (-not $ok) { $script:fails += $name; Write-Host "FAIL $name" }
  else { Write-Host "PASS $name" }
}
Expect ($xml.Contains('<Title Text="Picking Status"')) 'title'
Expect (([regex]::Matches($xml, '<Grid ')).Count -eq 3) 'three grids'
Expect ($xml.Contains('Name="Who is picking"') -and $xml.Contains('Name="Open loads"') -and $xml.Contains("Name=`"Today's counts`"")) 'grid names'
Expect (-not $xml.Contains('<Pie ')) 'no pie'
Expect (([regex]::Matches($xml, '<Chart ')).Count -eq 1) 'one bar chart'
Expect ($xml.Contains('Name="Open lines by picker"') -and $xml.Contains('SeriesType="StackedBar"') -and $xml.Contains('DataMember="V_GAB_7546_PICK_NOW"')) 'bars compare pickers'
$chart = [regex]::Match($xml, '<Chart .*?</Chart>').Value
Expect ($chart.Contains('LINES_OPEN') -and $chart.Contains('LINES_PICKED_NOT_SHIPPED') -and $chart.Contains('SummaryType="Sum"')) 'bars use the totals'
Expect (([regex]::Matches($xml, '<Card ComponentName="card')).Count -eq 6) 'six big numbers'
Expect ($xml.Contains('Name="Longest queue (days)"') -and $xml.Contains('LONGEST_QUEUE_DAYS') -and $xml.Contains('SummaryType="Max"')) 'longest queue is a max, not a sum'
Expect ($xml.Contains('Name="Released"') -and $xml.Contains('EARLIEST_RELEASE')) 'release time is shown'
foreach ($cardName in @('Lines still open','Lines picked not shipped','Open loads','Lines picked today','Lines shipped today')) {
  Expect ($xml.Contains(('Name="{0}"' -f $cardName))) ("big number: " + $cardName)
}
$cards = [regex]::Matches($xml, '<Card ComponentName="card[^"]*".*?</Card></Card>')
Expect ($cards.Count -eq 6) 'big number blocks'
foreach ($c in $cards) {
  Expect ($c.Value.Contains('DeltaIndicator Visible="false"') -and $c.Value.Contains('Sparkline Visible="false"') -and $c.Value.Contains('BottomValue1 Visible="false"')) 'big numbers have no score'
}
Expect ($xml.Contains('ComponentName="cardLoads"') -and $xml.Contains('DataMember="LOAD_NO"') -and $xml.Contains('SummaryType="Count"')) 'open loads counts loads'
Expect ($xml.Contains('DashboardItem="chartDashboardItem1"') -and $xml.Contains('DashboardItem="cardOpen"')) 'pictures are on the page'
Expect ($xml.Contains('V_GAB_7546_PICK_NOW') -and $xml.Contains('V_GAB_7546_LOAD_DISPATCH') -and $xml.Contains('V_GAB_7546_PICK_DAY')) 'three views'
Expect (-not $xml.Contains('V_GAB_7546_PICK_LINE')) 'line view stays off'
Expect (-not $xml.Contains('MOBILE_USER_INFO')) 'no common name join'
$dates = [regex]::Matches($xml, '<Dimension DataMember="(OLDEST_PICK_BY_STILL_OPEN|SHIP_DATE|OLDEST_PICK_BY)"[^/]*/>')
Expect ($dates.Count -eq 3) 'three date columns'
foreach ($d in $dates) {
  Expect ($d.Value.Contains('DateTimeGroupInterval="DayMonthYear"')) ("full date: " + $d.Groups[1].Value)
}
foreach ($col in @('Ship date','Oldest pick-by','Oldest pick-by still open')) {
  $colXml = [regex]::Match($xml, ('<GridDimensionColumn Name="{0}"[^>]*>' -f [regex]::Escape($col))).Value
  Expect ($colXml.Contains('Weight="')) ("date column is wide: " + $col)
}
$formats = [regex]::Matches($xml, '<NumericFormat [^/]*/>')
Expect ($formats.Count -gt 0) 'count format present'
foreach ($f in $formats) {
  Expect ($f.Value.Contains('Precision="0"')) 'counts show as whole numbers'
}
if ($fails.Count -gt 0) { Write-Host ("FAILED " + $fails.Count); exit 1 }
Write-Host 'ALL PASSED'
exit 0
