' Build a valid Codesoft GAB_7546_CARRIER_PALLET.lab via Lppx2 COM.
Option Explicit
On Error Resume Next

Const DEST = "C:\Apps\Global\BUSINT\LABELS\custom\GAB_7546_CARRIER_PALLET.lab"

Dim app, docs, doc, fv, fml, texts, t
Dim vars, i, errN, errD

Set app = CreateObject("Lppx2.Application")
If Err.Number <> 0 Then
  WScript.Echo "CreateObject Lppx2.Application failed: " & Err.Number & " " & Err.Description
  WScript.Quit 1
End If

Set docs = app.Documents
docs.Add
Set doc = app.ActiveDocument
If doc Is Nothing Then
  WScript.Echo "Documents.Add produced no ActiveDocument"
  app.Quit
  WScript.Quit 1
End If

' 4.00 in x 6.00 in portrait. Codesoft Format.Label* is thousandths of an inch.
Err.Clear
doc.Format.PaperName = "4 x 6"
doc.Format.LabelWidth = 4000
doc.Format.LabelHeight = 6000
WScript.Echo "Size PaperName=" & doc.Format.PaperName & " LW=" & doc.Format.LabelWidth & " LH=" & doc.Format.LabelHeight
Err.Clear

Set fv = doc.Variables.FormVariables
Set fml = doc.Variables.Formulas
Set texts = doc.DocObjects.Texts

vars = Array( _
  "SHIP_FROM_NAME", "SHIP_FROM_ADRS1", "SHIP_FROM_ADRS2", "SHIP_FROM_CITYSTZIP", "SHIP_FROM_PHONE", _
  "DELIVER_TO_NAME", "DELIVER_TO_ADRS1", "DELIVER_TO_CITYSTZIP", "PRO_NO", "PALLET_COUNT")

For i = 0 To UBound(vars)
  Err.Clear
  fv.Add vars(i)
  If Err.Number <> 0 Then
    WScript.Echo "FormVariables.Add " & vars(i) & ": " & Err.Number & " " & Err.Description
    Err.Clear
  End If
Next

fv.Item("SHIP_FROM_NAME").Value = "UNIVERSAL DISPLAY & FIXTURES"
fv.Item("SHIP_FROM_ADRS1").Value = "3333 WEST UNIVERSITY DRIVE"
fv.Item("SHIP_FROM_ADRS2").Value = "SUITE 1109"
fv.Item("SHIP_FROM_CITYSTZIP").Value = "DENTON, TX 76207"
fv.Item("SHIP_FROM_PHONE").Value = "972-221-5157"
fv.Item("DELIVER_TO_NAME").Value = "SALTLAKE RREW 10954"
fv.Item("DELIVER_TO_ADRS1").Value = "4884 W 1100 S"
fv.Item("DELIVER_TO_CITYSTZIP").Value = "SALT LAKE CITY UT 84104"
fv.Item("PRO_NO").Value = "7460697425"
fv.Item("PALLET_COUNT").Value = "PALLET 1 OF 3"

Sub AddStatic(name, val, leftX, topY, wid, hei, fontSize)
  Dim tx
  Err.Clear
  texts.Add
  Set tx = texts.Item(texts.Count)
  tx.Name = name
  tx.Left = leftX
  tx.Top = topY
  tx.Width = wid
  tx.Height = hei
  tx.Alignment = 1
  tx.Value = val
  tx.Font.Name = "Arial"
  tx.Font.Size = fontSize
  tx.Font.Bold = True
  If Err.Number <> 0 Then
    WScript.Echo "AddStatic " & name & ": " & Err.Number & " " & Err.Description
    Err.Clear
  End If
End Sub

Sub AddVar(name, varName, leftX, topY, wid, hei, fontSize)
  Dim tx, fn, f
  fn = "f_" & varName
  Err.Clear
  fml.Add fn
  Set f = fml.Item(fn)
  f.Expression = "{" & varName & "}"
  Err.Clear
  texts.Add
  Set tx = texts.Item(texts.Count)
  tx.Name = name
  tx.Left = leftX
  tx.Top = topY
  tx.Width = wid
  tx.Height = hei
  tx.Alignment = 1
  tx.VariableName = fn
  tx.Value = fv.Item(varName).Value
  tx.Font.Name = "Arial"
  tx.Font.Size = fontSize
  tx.Font.Bold = True
  If Err.Number <> 0 Then
    WScript.Echo "AddVar " & name & ": " & Err.Number & " " & Err.Description
    Err.Clear
  End If
End Sub

' Portrait pallet placard, mils (0.001 inch). 4in wide text band.
AddStatic "txtLogo", "UNIVERSAL", 200, 200, 3600, 350, 16
AddStatic "txtShipFromHdr", "Ship from:", 200, 650, 3600, 280, 12
AddVar "txtFromName", "SHIP_FROM_NAME", 200, 950, 3600, 320, 14
AddVar "txtFromAdrs1", "SHIP_FROM_ADRS1", 200, 1280, 3600, 260, 11
AddVar "txtFromAdrs2", "SHIP_FROM_ADRS2", 200, 1540, 3600, 260, 11
AddVar "txtFromCity", "SHIP_FROM_CITYSTZIP", 200, 1800, 3600, 260, 11
AddVar "txtFromPhone", "SHIP_FROM_PHONE", 200, 2060, 3600, 260, 11
AddStatic "txtDelivHdr", "DELIVER TO", 200, 2450, 3600, 280, 12
AddVar "txtDelName", "DELIVER_TO_NAME", 200, 2750, 3600, 320, 14
AddVar "txtDelAdrs1", "DELIVER_TO_ADRS1", 200, 3080, 3600, 260, 11
AddVar "txtDelCity", "DELIVER_TO_CITYSTZIP", 200, 3340, 3600, 260, 11
AddStatic "txtProHdr", "PRO#", 200, 3850, 3600, 260, 14
AddVar "txtProNo", "PRO_NO", 200, 4120, 3600, 320, 16
AddVar "txtPallet", "PALLET_COUNT", 200, 4600, 3600, 450, 20

Err.Clear
doc.SaveAs DEST
If Err.Number <> 0 Then
  WScript.Echo "SaveAs failed: " & Err.Number & " " & Err.Description
  docs.CloseAll False
  app.Quit
  WScript.Quit 1
End If

WScript.Echo "Saved " & DEST
WScript.Echo "FormVariables=" & fv.Count & " Texts=" & texts.Count

docs.CloseAll False
app.Quit
WScript.Echo "OK"
