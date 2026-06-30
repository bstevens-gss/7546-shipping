# GAB CHEAT SHEET
# Scan this BEFORE and DURING coding. Every line here is verified.
# This is a memory aid, not a replacement for full docs.
---

## 1. Syntax Rules (CRITICAL)

| Rule | Wrong | Right |
|------|-------|-------|
| No inline math | `iTotal + 1` | `F.Intrinsic.Math.Add(V.Local.iTotal,1,V.Local.iTotal)` |
| No + concat | `sA + sB` | `F.Intrinsic.String.Concat(sA,sB,sResult)` or `String.Build` |
| No () on reads | `V.Screen.frm!txt.Text()` | `V.Screen.frm!txt.Text` |
| Read uses ! | `V.Screen.frm.txt.Text` | `V.Screen.frm!txt.Text` |
| Write uses . | `V.Screen.frm!txt.Text("hi")` | `Gui.frm.txt.Text("hi")` |
| FieldVal col!suffix | `V.DataTable.dt(0).!COLFieldVal` | `V.DataTable.dt(0).COL!FieldVal` |
| Type suffix = one token | `.FieldVal.Float` | `.FieldValFloat` |
| No inline math in args | `For(i,0,iMax-1,1)` | Pre-compute: `Math.Sub(iMax,1,iLast)` then `For(i,0,iLast,1)` |
| String.Build needs {N} | `String.Build("hello",sR)` | `V.Local.sR.Set("hello")` |
| Try/Catch no nesting | Try inside Try (same sub) | Use `SetErrorHandler` instead |
| Vars are sub-scoped | Declare inside If/For | Declare at top of sub |
| GUI scripts need UsePixels | (form is giant) | `F.Intrinsic.UI.UsePixels` as first line of Main |
| Form show pattern | Just `.Show` | `.Show` + `.AlwaysOnTop(True)` + `.AlwaysOnTop(False)` |

---

## 2. Top 30 Function Signatures

```
F.Intrinsic.String.Build(sFormat, sub1 [,sub2...], sResult)
F.Intrinsic.String.Concat(sA, sB [,sC...], sResult)
F.Intrinsic.String.IsInString(sHaystack, sNeedle, bCaseInsensitive, bResult)
F.Intrinsic.String.InStr(sSource, sFind, iStartPos, iResult)
F.Intrinsic.String.Split(sSource, sDelim, sArrayResult)
F.Intrinsic.String.Replace(sSource, sFind, sReplace, sResult)
F.Intrinsic.String.Left(sSource, iLen, sResult)
F.Intrinsic.String.Right(sSource, iLen, sResult)
F.Intrinsic.String.Mid(sSource, iStart, iLen, sResult)   ' iStart is 1-based (VB Mid$)
F.Intrinsic.String.Len(sSource, iResult)
F.Intrinsic.String.Trim(sSource, sResult)
F.Intrinsic.String.UCase(sSource, sResult)
F.Intrinsic.String.Format(value, sFormatMask, sResult)
F.Intrinsic.String.Join(sArray, sDelim, sResult)
F.Intrinsic.Math.Add(val1, val2, result)
F.Intrinsic.Math.Sub(val1, val2, result)
F.Intrinsic.Math.Mult(val1, val2, result)
F.Intrinsic.Math.Div(val1, val2, result)
F.Intrinsic.Math.IsNumeric(sVal, bResult)
F.Intrinsic.Control.If(val1, operator, val2)
F.Intrinsic.Control.For(iVar, iStart, iEnd, iStep)
F.Intrinsic.Control.DoUntil(val1, operator, val2)
F.Intrinsic.Control.CallSub(SubName [,"argName",argValue...])
F.Intrinsic.Control.End
F.Data.DataTable.CreateFromSQL(sName, sConnName, sSQL, bGlobalScope)
F.Data.DataTable.AddRow(sName, "Col1","Val1" [,"Col2","Val2"...])
F.Data.DataTable.SetValue(sName, iRow, sCol, value)
F.Data.DataTable.Close(sName)
F.Intrinsic.File.String2File(sPath, sContent)
F.Intrinsic.File.File2String(sPath, sResult)
F.Intrinsic.UI.Msgbox(sMessage [,"sTitle",vStyle,iResultButton])
F.Intrinsic.UI.InputBox(sPrompt, sTitle, sDefault, sResult)
```

---

## 3. Control Quick-Ref

| Type | Key Events | Key Properties/Methods |
|------|-----------|----------------------|
| **Button** | Click | .Caption(), .Enabled(), .Visible() |
| **TextBox** | Change, Click, KeyPressEnter | .Text(), .MaxLength(), .Locked() |
| **TextBoxM** | Change, Click | .Text(), .Scrolling(), .Locked() |
| **Label** | Click, DblClick | .Caption(), .AutoSize(), .BackColor() |
| **Frame** | BorderButtonClick, Click | .Caption(), .HasButton(), .Enabled() |
| **Tab** | Click (NOT Change) | .Tabs(N), .SetTab(i), .Caption(), .TabEnabled(i,b) |
| **CheckBox** | Change, Click | .Value(True/False), read: `V.Screen..Value` compare =,1 |
| **ComboBox** | Change, SelectedIndexChanged | .AddItem(), .ListIndex(), .Text, .ClearItems |
| **DropDownList** | Change, SelectedIndexChanged | Same as ComboBox |
| **DatePicker** | Change, Click | .CustomFormat(), .AllowBlank(), .Locked() |
| **GsGridControl** | FocusedRowChanged, RowCellClick | .AddGridviewFromDatatable(), .MainView(), .SetColumnProperty() |
| **Timer** | Timer | .Interval(ms), .Enabled(True/False) |
| **PictureBox** | Click, DblClick | .SizeMode(), .BackColor() |
| **Option** | Click | .Caption(), read: V.Screen..Value |
| **ListBox** | Click, DblClick, SelectedIndexChanged | .AddItem(), .ListIndex(), .Sorted() |
| **GsLookUpControl** | SelectionMade | .LookupMode(), .MultiSelect() |

---

## 4. V.Args Quick-Ref by Event

| Event | Key V.Args | Notes |
|-------|-----------|-------|
| **Click** (Button) | .EventSource, .Screen, .ControlName, .ControlType, .EventType | Standard 5 args |
| **FocusedRowChanged** (Grid) | .GsGridControlName, .FocusedRowHandle, .PreviousRowHandle | Use FocusedRowHandle for GetCellValueByColumnName |
| **RowCellClick** (Grid) | .GsGridControlName, .Column, .CellValue, .RowIndex | Column = clicked column name; RowIndex = row for GetCellValue |
| **CellValueChanged** (Grid) | .GsGridControlName, .Column, .Value, .RowIndex | Value = new edited value |
| **Change** (TextBox) | .EventSource, .Screen, .ControlName, .ControlType | No special args |
| **Change** (ComboBox) | .EventSource, .Screen, .ControlName, .ControlType | Read ListIndex/Text via V.Screen |
| **SelectionMade** (Lookup) | .lookupReturn, .Value | V.Object access for full entity |
| **Timer** | .EventSource, .Screen, .ControlName | Fires at .Interval frequency |
| **UnLoad** (Form) | .EventSource, .Screen | Wire in ScreenSU: `Gui.frm..Event(UnLoad,sub)` |
| **ElementClick** (Accordion) | .ElementID | Use SelectCase to route by clicked element |
| **Toggled** (GsToggleSwitch) | .IsOn, .GsToggleSwitchName, .OnText, .OffText | .IsOn = current state |

**CRITICAL: In RowCellClick, use `V.Args.RowIndex` not `V.Args.RowHandle`.** In `FocusedRowChanged`, use `V.Args.FocusedRowHandle` not `V.Args.RowHandle`.

---

## 5. Grid Decision Tree (STOP and check this before coding any grid)

| Question | Answer → Do This |
|----------|-----------------|
| Flat grid, single table? | `AddGridviewFromDatatable("dtX","gvX")` + `MainView("gvX")` |
| User said "child grid" or master-detail? | `AddRelation` + `AddGridViewFromDataView` (ONE GsGridControl) |
| Filtered view that changes at runtime? | `DataView.Create` + `SetFilter` + `AddGridViewFromDataView` |
| Refresh existing grid with new data? | Close DT → re-CreateFromSQL → `gsGC.DataSource("dtX")` |
| Save/restore column layout? | `Serialize`/`Deserialize` + `F.Global.Registry` |

### Grid bind lifecycle (memorize this):
```
BlockEvents → LockScreen → Close(old DT) → CreateFromSQL → AddGridviewFromX → SuspendLayout → SetColumnProperty... → ResumeLayout → MainView → BestFitColumns → EnableScreen → UnBlockEvents → Deserialize
```

### Common CW IDs for RowCellClick drill-downs:
| Target | CW ID | Param pattern |
|--------|-------|---------------|
| WO view | 450000 | `7!*!{job}!*!{sfx}!*!A` |
| WO edit | 2009 | `{job}!*!{sfx}!*!O` |
| Part SD | 300011 | `{part}!*!{loc}!*!O` |
| Sales Order | 200000 | `{so}!*!V!*!{cust}` |
| PO | 175200 | `V!*!{po}!*!` |

---

## 6. ScreenSU Crash Prevention

These cause SILENT failures (no error, no log, form just doesn't work):

| Mistake | What Happens | Fix |
|---------|--------------|-----|
| `CommandButton`, `Panel`, etc. | Control silently not created | Use `Button`, `Frame` -- check screensu-registry.json |
| `V.Enum.X!Y` in ScreenSU | May crash parse or resolve wrong | Use raw integer values in ScreenSU; enums in Main |
| `.Text("label")` on Button/Label/Frame | Error 600 or wrong behavior | Use `.Caption("label")` on these controls |
| `Event(OnClick,Sub)` | Error 10003 | Drop "On" prefix: `Event(Click,Sub)` |
| `Event(Change,Sub)` on Tab | Error 10003 | Tab only has `Click` event |
| `.Create(Button,"label",x,y,w,h)` | May crash or ignore params | Use `.Create(Button)` + separate `.Size()`, `.Position()`, `.Caption()` |
| Event wiring in Main | Re-fires on form refresh | Wire events in ScreenSU with `.Event()` |
| Missing `.Show` in Main | Script exits immediately | Always `.Show` + AlwaysOnTop flash |
| Missing `UsePixels` in Main | Form is astronomically large | First line of Main: `F.Intrinsic.UI.UsePixels` |

**Run `Validate-ScreenSU.ps1` before signing** to catch these automatically.

---

## 7. V.Enum Safety

**NEVER guess enum member names.** Invalid members crash at runtime with no recovery.

```
' WRONG -- invented member name, will crash
Gui.frmMain.pic.Image(V.Enum.Image!FIND_COLOR)

' CORRECT -- only use verified values or skip the call
' If unsure, omit the enum entirely or use a raw integer
```

Only use V.Enum values you have verified in:
1. OCTSRS production scripts (the `.gas`/`.g2u` test fixtures)
2. The runtime source code (`Definitions.json`)
3. A working reference script that uses that exact member name
