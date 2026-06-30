# GAB GUI Dialogs & Specialized APIs Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with UI dialogs, browsers, mobile patterns, FunctionLinks, dashboards, and extra control methods
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# UI DIALOGS

## Double-Dot Notation
In ScreenSU, form-level properties use double dot (`..`) and control-level properties use single dot (`.`):
```
Gui.FrmMain..Create(BaseForm)          ' Form-level: double dot (..)
Gui.FrmMain..Caption("My Form")        ' Form-level
Gui.FrmMain..Size(800,600)             ' Form-level

Gui.FrmMain.cmdSave.Create(Button)     ' Control-level: single dot (.)
Gui.FrmMain.cmdSave.Caption("Save")    ' Control-level
```
In runtime code (Main, subroutines), the same pattern applies:
```
Gui.FrmMain..Show                       ' Show form (form-level)
Gui.FrmMain..Close                      ' Close form
Gui.FrmMain..AccentColor(iColorValue)   ' Set accent color

Gui.FrmMain.txtName.Text("Hello")      ' Set control text (control-level)
Gui.FrmMain.cmdSave.Enabled(False)     ' Disable control
```

```
F.Intrinsic.UI.Msgbox(sMessage)
F.Intrinsic.UI.Msgbox(sMessage,"Title")
F.Intrinsic.UI.Msgbox(sMessage,"Title",4,iReturnButton)    ' Yes/No
F.Intrinsic.UI.InvokeSearch("Customer",V.Local.sResult)     ' Entity search browser
F.Intrinsic.UI.Browser("Title","con",sSQL,sTitles,sWidths,iMaxRows,iMaxCols,sResult)
F.Intrinsic.UI.Browser(51,,V.Local.sResult)                 ' Employee browser
F.Intrinsic.UI.SetBrowserHotTypeAhead(True)
F.Intrinsic.UI.ShowOpenFileDialog("","XLSX [.xlsx]|*.xlsx|CSV [.csv]|*.csv","",V.Local.sResult)
F.Intrinsic.UI.ShowSaveFileDialog("","XLSX|*.XLSX",V.Local.sResult)
F.Intrinsic.UI.ShowColorSelectionDialog(V.Local.iColor)
F.Intrinsic.UI.InvokeWaitDialog("Processing...")
F.Intrinsic.UI.ChangeWaitStatus("Step 2...")
F.Intrinsic.UI.CloseWaitDialog
F.Intrinsic.UI.UsePixels                                    ' If this appears ANYWHERE in code, all size/position values become Pixels not Twips
F.Intrinsic.UI.Sleep(.25)                                   ' Sleep 0.25 seconds
F.Intrinsic.UI.SleepMS(500)                                 ' Sleep 500ms
F.Intrinsic.UI.InputBox("Prompt","Title","Default",sResult) ' Input dialog
F.Intrinsic.UI.MsgBoxExt(sMessage,"Title",iButtons,iIcon,iResult)  ' Extended MsgBox
F.Intrinsic.UI.RGB(iRed,iGreen,iBlue,iResult)              ' Create RGB color value
F.Intrinsic.UI.CommonBrowser(iEntityType,sFilter,sResult)   ' Entity browser by type
F.Intrinsic.UI.SetBrowserOOT(bValue)                        ' Set browser on-top behavior
F.Intrinsic.UI.SetWaitDialogAlwaysOnTop(bValue)             ' Wait dialog stays on top
F.Intrinsic.UI.ChangeCallerProperty("PropertyName",value)   ' Modify calling form property
F.Intrinsic.UI.MiniBrowser("Title","con",sSQL,sTitles,sWidths,sResult) ' Simplified browser (fewer params than full Browser)
```

> **CRITICAL:** `F.Intrinsic.UI.DropDown()` does **NOT** exist in GAB (error 999000). For a dropdown-style selection list, use `BrowserFromString` with a single column:
> ```
> F.Intrinsic.UI.BrowserFromString("Pick an option","Option A~Option B~Option C","|","~","Choose","200",V.Local.sResult)
> ```
> The result is the selected row's text, or `***CANCEL***` if the user dismisses the dialog.
>
> **CRITICAL:** `F.Intrinsic.UI.MsgBox2()` does **NOT** exist in some GAB runtimes (error 999000). Use `F.Intrinsic.UI.Msgbox` with button style params instead.

MsgBox with enum-style buttons and results:
```
F.Intrinsic.UI.Msgbox("Are you sure?","Confirm",V.Enum.MsgBoxStyle!YesNo,V.Local.iRet)
F.Intrinsic.Control.If(V.Local.iRet,=,V.Enum.MsgBoxResult!Yes)
    '... user clicked Yes
F.Intrinsic.Control.EndIf
```

## F.Intrinsic.UI.Browser

### Signatures

```
F.Intrinsic.UI.Browser(Title, ConnectionName, Basis, ColumnTitles, ColumnWidths, Return)
F.Intrinsic.UI.Browser(Title, ConnectionName, Basis, ColumnTitles, ColumnWidths, WidthOfBrowser, HeightOfBrowser, FormatOverride, Return)
F.Intrinsic.UI.Browser(CommonBrowserId, ReturnVariable)
```

### Arguments

| Argument | Type | Description |
|----------|------|-------------|
| `Title` | String | Title of the browser window (not used with the common-browser overload) |
| `ConnectionName` | String | ODBC connection name |
| `Basis` | String | SQL statement to retrieve records |
| `ColumnTitles` | StringArray | Column header titles delimited with `*!*` |
| `ColumnWidths` | LongArray | Column widths delimited with `*!*` |
| `WidthOfBrowser` | Long | Width of the browser window |
| `HeightOfBrowser` | Long | Height of the browser window |
| `FormatOverride` | StringArray | Column format strings delimited with `*!*` (see format tables below) |
| `CommonBrowserId` | Long | Predefined common browser ID (see table below) |
| `Return` / `ReturnVariable` | String | Selected row result, or `***CANCEL***` if dismissed |

### Examples

**Common browser (single argument):**
```
V.Local.CommonBrowserIdArgument.Declare(Long,50)
V.Local.Return.Declare(String)
F.Intrinsic.UI.Browser(V.Local.CommonBrowserIdArgument,V.Local.Return)
```

**SQL-based browser (6-argument):**
```
V.Local.Query.Declare(String)
V.Local.Columns.Declare(String)
V.Local.Widths.Declare(String)
V.Local.Return.Declare(String)

F.ODBC.Connection!conX.OpenConnection(V.Ambient.PDSN,V.Ambient.PUser,V.Ambient.PPass)
F.Intrinsic.String.Split("2000*!*2000*!*2000*!*2000","*!*",V.Local.Widths)
F.Intrinsic.String.Split("SampleString*!*SampleNumber*!*SampleDate*!*SampleTime","*!*",V.Local.Columns)

V.Local.Query.Set("SELECT '1234.56' as SampleString, 1234.56 as SampleNumber, CAST('2024-09-27' AS DATE) AS SampleDate, CAST('11:30:45' AS Time) AS SampleTime ")

F.Intrinsic.UI.Browser("Select Source","conx",V.Local.Query,V.Local.Columns,V.Local.Widths,V.Local.Return)
'Return "1234.56*!*1234.56*!*9/27/2024 12:00:00 AM*!*11:30:45"
```

**SQL-based browser with size and format override (9-argument):**
```
V.Local.Query.Declare(String)
V.Local.Columns.Declare(String)
V.Local.Widths.Declare(String)
V.Local.WidthsBrowser.Declare(Long,10000)
V.Local.HeightBrowser.Declare(Long,10000)
V.Local.Return.Declare(String)
V.Local.FormatOverride.Declare(String,"")

F.ODBC.Connection!conX.OpenConnection(V.Ambient.PDSN,V.Ambient.PUser,V.Ambient.PPass)
F.Intrinsic.String.Split("2000*!*2000*!*2000*!*2000","*!*",V.Local.Widths)
F.Intrinsic.String.Split("SampleString*!*SampleNumber*!*SampleDate*!*SampleTime","*!*",V.Local.Columns)
F.Intrinsic.String.Split("#,##0*!*#,##0*!*#,##0*!*#,##0","*!*",V.Local.FormatOverride)

V.Local.Query.Set("SELECT '1234.56' as SampleString, 1234.56 as SampleNumber, CAST('2024-09-27' AS DATE) AS SampleDate, CAST('11:30:45' AS Time) AS SampleTime ")

F.Intrinsic.UI.Browser("Select Source","conx",V.Local.Query,V.Local.Columns,V.Local.Widths,V.Local.WidthsBrowser,V.Local.HeightBrowser,V.Local.FormatOverride,V.Local.Return)
'Return "1234.56*!*1234.56*!*9/27/2024 12:00:00 AM*!*11:30:45"
```

### Remarks

- If no row is selected the return string will be `***CANCEL***`.
- If a row is selected the columns are delimited by `*!*`. Use `F.Intrinsic.String.Split` to extract individual column values.
- Arrays must be 0-based.
- `F.Intrinsic.UI.Browser` supports type-ahead on both the primary and filtered tabs.
- `F.Intrinsic.UI.Browser` and `F.Intrinsic.UI.MiniBrowser` are always-on-top.
- As of OCTSRS.EXE version 401, `F.Intrinsic.UI.Browser` supports exporting on the filtered resultset tab via an "Export Resultset" button. The button is disabled if neither Microsoft Excel nor OpenOffice are present; if both are present, Excel is used.

### Common Browser IDs

| ID | Description | | ID | Description | | ID | Description |
|----|-------------|-|----|-------------|-|----|-------------|
| `10` | GS User Browser | | `250` | Prospect Browser | | `3005` | BOM Browser, Part |
| `15` | GS Group Browser | | `280` | Suspect Browser | | `4000` | Purchase Order Browser |
| `50` | Employee Browser | | `300` | Vendor Browser | | `6000` | GL Account Browser (Account, Description) |
| `51` | Employee Browser, exclude terminated | | `400` | Workcenter Browser | | `90000` | BI Report Browser |
| `70` | Employee Department | | `1000` | Work Order Browser | | `90010` | BI Report Browser, Custom/User |
| `100` | Inventory, Part/Rev | | `2000` | Project Browser | | `90100` | Doc Control Groups |
| `105` | Inventory, Part | | `2700` | Router Browser, Router/Rev | | | |
| `130` | Product Line Browser | | `2705` | Router Browser, Router | | | |
| `150` | Bin Browser | | `3000` | BOM Browser, Part/Rev | | | |
| `205` | Customer Browser | | | | | | |
| `225` | Customer/Prospect | | | | | | |

### Custom Numeric Format Strings

Used with `FormatOverride` for numeric columns.

| Specifier | Name | Description | Example |
|-----------|------|-------------|---------|
| `0` | Zero placeholder | Replaces with digit if present; otherwise `0` | `1234.5678` (`"00000"`) → `01235` |
| `#` | Digit placeholder | Replaces with digit if present; otherwise nothing. Non-significant `0` is suppressed (e.g. `0003` `"####"` → `3`) | `1234.5678` (`"#####"`) → `1235` |
| `.` | Decimal point | Position of the decimal separator | `0.45678` (`"0.00"`) → `0.46` |
| `,` | Group separator / scaling | As group separator: inserts localized separator between groups. As scaling: divides by 1000 per comma | `2147483647` (`"##,#"`) → `2,147,483,647` |
| `%` | Percentage | Multiplies by 100 and inserts `%` | `0.3697` (`"%#0.00"`) → `%36.97` |
| `‰` | Per mille | Multiplies by 1000 and inserts `‰` | `0.03697` (`"#0.00‰"`) → `36.97‰` |
| `E0` / `E+0` / `E-0` | Exponential | Scientific notation; zeros after E set minimum exponent digits | `987654` (`"#0.0e0"`) → `98.8e4` |
| `\` | Escape | Next character is literal | `987654` (`"\###00\#"`) → `#987654#` |
| `'string'` / `"string"` | Literal delimiter | Enclosed characters copied unchanged | `68` (`"# 'degrees'"`) → `68 degrees` |
| `;` | Section separator | Separate formats for positive, negative, and zero | `12.345` (`"#0.0#;(#0.0#);-\0-"`) → `12.35` |

### Custom Date and Time Format Strings

Used with `FormatOverride` for date/time columns.

| Specifier | Description | Example (`2009-06-15T13:45:30`) |
|-----------|-------------|------|
| `d` | Day of month, 1–31 | `15` |
| `dd` | Day of month, 01–31 | `15` |
| `ddd` | Abbreviated day name | `Mon` |
| `dddd` | Full day name | `Monday` |
| `f` – `fffffff` | Fractional seconds (tenths → ten-millionths) | `6175425` (7 f's) |
| `F` – `FFFFFFF` | Fractional seconds, trailing zeros suppressed | `6175425` (7 F's) |
| `g` / `gg` | Period or era | `A.D.` |
| `h` | Hour, 12-hour clock 1–12 | `1` |
| `hh` | Hour, 12-hour clock 01–12 | `01` |
| `H` | Hour, 24-hour clock 0–23 | `13` |
| `HH` | Hour, 24-hour clock 00–23 | `13` |
| `K` | Time zone info | `-07:00` |
| `m` | Minute, 0–59 | `45` |
| `mm` | Minute, 00–59 | `45` |
| `M` | Month, 1–12 | `6` |
| `MM` | Month, 01–12 | `06` |
| `MMM` | Abbreviated month name | `Jun` |
| `MMMM` | Full month name | `June` |
| `s` | Second, 0–59 | `30` |
| `ss` | Second, 00–59 | `30` |
| `t` | First character of AM/PM | `P` |
| `tt` | AM/PM designator | `PM` |
| `y` | Year, 0–99 | `9` |
| `yy` | Year, 00–99 | `09` |
| `yyy` | Year, minimum 3 digits | `2009` |
| `yyyy` | Year, 4 digits | `2009` |
| `yyyyy` | Year, 5 digits | `02009` |
| `z` | Hours offset from UTC, no leading zero | `-7` |
| `zz` | Hours offset from UTC, with leading zero | `-07` |
| `zzz` | Hours and minutes offset from UTC | `-07:00` |
| `:` | Time separator | `:` |
| `/` | Date separator | `/` |
| `'string'` / `"string"` | Literal delimiter | `('arr:' h:m t)` → `arr: 1:45 P` |
| `%` | Custom format specifier prefix | `(%h)` → `1` |
| `\` | Escape character | Treats next character as literal |

## Browser Variants
```
F.Intrinsic.UI.BrowserFromDataTable("Title","dtName",sTitles,sWidths,sResult)
F.Intrinsic.UI.BrowserFromDataview("Title","dtName","dvName",sTitles,sWidths,sResult)
F.Intrinsic.UI.BrowserFromString("Title",sData,sDelimiter,sRowDelimiter,sTitles,sWidths,sResult)
F.Intrinsic.UI.BrowserFromStringNet("Title",sData,sDelimiter,sRowDelimiter,sTitles,sWidths,sResult)
F.Intrinsic.UI.BrowserFromFile("Title",sFilePath,sColDelim,sRowDelim,sTitles,sWidths,sResult)
F.Intrinsic.UI.BrowserFromFileNet("Title",sFilePath,sColDelim,sRowDelim,sTitles,sWidths,sResult)
F.Intrinsic.UI.CommonBrowser(iEntityType,sFilter,sResult)
F.Intrinsic.UI.MiniBrowser("Title","con",sSQL,sTitles,sWidths,sResult)
```

## Browser Configuration
```
F.Intrinsic.UI.SetBrowserMultiSelect(bValue)            ' Enable multi-row selection
F.Intrinsic.UI.SetBrowserColumnFormatting(sFormatting)   ' Column format overrides
F.Intrinsic.UI.SetBrowserHotTypeAhead(bValue)            ' Incremental search as you type
F.Intrinsic.UI.SetBrowserOOT(bValue)                     ' Browser always-on-top behavior
```

## File & Folder Dialogs
```
F.Intrinsic.UI.ShowOpenFileDialog(sInitialDir,sFilter,sTitle,sResult)
F.Intrinsic.UI.ShowSaveFileDialog(sInitialDir,sFilter,sResult)
F.Intrinsic.UI.ShowColorSelectionDialog(iResult)
F.Intrinsic.UI.ShowFontSelectionDialog(sResult)
F.Intrinsic.UI.FolderBrowser(sDescription,sInitialPath,sResult)
```

## Wait/Progress Dialogs
```
F.Intrinsic.UI.InvokeWaitDialog(sMessage)
F.Intrinsic.UI.ChangeWaitStatus(sMessage)
F.Intrinsic.UI.CloseWaitDialog
F.Intrinsic.UI.SetWaitDialogAlwaysOnTop(bValue)
```

## Color Functions
```
F.Intrinsic.UI.RGB(iRed,iGreen,iBlue,iResult)
F.Intrinsic.UI.ColorIntensityShift(iColor,fIntensity,iResult)
F.Intrinsic.UI.ColorToGreyscale(iColor,iResult)
F.Intrinsic.UI.ConvertArgbToRgb(iArgb,iResult)
```

## UI Utility Functions
```
F.Intrinsic.UI.Sleep(fSeconds)                           ' Pause (fractional seconds)
F.Intrinsic.UI.SleepMS(iMilliseconds)                   ' Pause (milliseconds)
F.Intrinsic.UI.Beep                                      ' System beep
F.Intrinsic.UI.PlaySound(sFilePath)                      ' Play WAV file
F.Intrinsic.UI.GetKeyState(sKey,bResult)                 ' Check if key is pressed
F.Intrinsic.UI.FontExists(sFontName,bResult)             ' Check if font is installed
F.Intrinsic.UI.GetLocaleSetting(sSettingName,sResult)    ' Read locale info
F.Intrinsic.UI.GetFormList(sResult)                      ' List all open forms
F.Intrinsic.UI.Screenshot(sFilePath)                     ' Capture screen to file
F.Intrinsic.UI.ScreenshotHWND(iHandle,sFilePath)         ' Capture specific window
F.Intrinsic.UI.GetImageMetrics(sFilePath,sResult)        ' Get image dimensions
F.Intrinsic.UI.DoEvents                                   ' Process pending UI events
F.Intrinsic.UI.Timer(fResult)                             ' Seconds elapsed since midnight (Single)
F.Intrinsic.UI.Keyboard(iSize,iMode,iTargetHandle)       ' Show on-screen keyboard
F.Intrinsic.UI.GenerateKeyboardEvent                      ' Generate a keyboard event
F.Intrinsic.UI.SetLockState(sKey,bState)                  ' Set Num/Caps/Scroll lock state
F.Intrinsic.UI.SetApplicationIcon(sFormName,sFilePath)    ' Set application icon from file
F.Intrinsic.UI.EnableV1Compatibility                      ' Enable legacy V1 screen/font rendering
F.Intrinsic.UI.AverageColorSample(iColor1,iColor2,iColor3,iColor4,iResult)  ' Average color of 4 samples
F.Intrinsic.UI.ColorComponentShift(iColor,iShiftR,iShiftG,iShiftB,iResult)  ' Shift individual RGB components

' Clipboard
F.Intrinsic.UI.GetClipboardText(sResult)                  ' Read clipboard text
F.Intrinsic.UI.SetClipboardText(sText)                    ' Write text to clipboard
F.Intrinsic.UI.ClearClipboard                              ' Clear clipboard contents

' Calendar rendering features
F.Intrinsic.UI.AddCalendarFeature(dDate,sProperty,sArg1,sArg2,sKey)
F.Intrinsic.UI.ClearCalendarFeatures
F.Intrinsic.UI.SetCalXOffset(value)
F.Intrinsic.UI.SetCalYOffset(value)
F.Intrinsic.UI.SetCalXSpacing(value)
F.Intrinsic.UI.SetCalYSpacing(value)

' Browser dialog configuration
F.Intrinsic.UI.SetBrowserButton0Text(sText)               ' Custom OK button text
F.Intrinsic.UI.SetBrowserButton1Text(sText)               ' Custom Cancel button text
F.Intrinsic.UI.SetBrowserColumnResizeMode                  ' Set grid column resize mode
F.Intrinsic.UI.SetBrowserHotTypeAheadColumn(iColIndex)     ' Enable hot type-ahead on column
F.Intrinsic.UI.SetBrowserParentHwnd(iHandle)               ' Set browser parent window

' MsgBoxExt/InputBoxExt configuration
F.Intrinsic.UI.SetAltBoxCharLimit(iLimit)                  ' Character limit for alt box
F.Intrinsic.UI.SetAltBoxHelpTopic(sURL)                    ' Help button URL
F.Intrinsic.UI.SetAltBoxOOT                                ' Set extended inputbox dialog style
F.Intrinsic.UI.SetAltBoxParentHwnd(iHandle)                ' Set alt box parent window
F.Intrinsic.UI.SetWaitDialogParentHwnd(iHandle)            ' Set wait dialog parent window
```

## Script Identity
```
F.Intrinsic.UI.SetScriptName(sName)                     ' Set display name in task list
F.Intrinsic.UI.SuppressOutput(bValue)                   ' Suppress standard output
```

## Flyout Dialog
```
F.Intrinsic.UI.FlyoutDialog(sTitle,sMessage,iDuration,sPosition)
```
Displays a non-blocking notification that auto-dismisses.

## Input Dialogs
```
F.Intrinsic.UI.InputBox(sPrompt,sTitle,sDefault,sResult)
F.Intrinsic.UI.InputBoxExt(sPrompt,sTitle,sDefault,iInputType,sResult)
```

---

# MOBILE SCRIPT PATTERNS

Mobile scripts run on GS Mobile and output HTML results.

```
Program.Sub.Main.Start
V.Local.sSQL.Declare(String)
V.Local.sMobileResult.Declare(String)

V.Global.sTransID.Set(V.Passed.DATA-TRANSID)

F.ODBC.Connection!Con.OpenCompanyConnection
F.Intrinsic.Control.Try
    '... business logic ...
    
    ' Return HTML result to mobile
    F.Intrinsic.String.Build("Success: {0}",V.Local.sValue,V.Local.sMobileResult)
    F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Passed.DATA-TRANSID,V.Local.sMobileResult)
    
    ' Redirect to another mobile page
    F.Intrinsic.String.Build("<script type='text/javascript'> window.location.href ='Custom.aspx?sTXID={0}'; </script>",V.Global.iTXID,V.Local.sMobileResult)
    F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Passed.DATA-TRANSID,V.Local.sMobileResult)
    
F.Intrinsic.Control.Catch
    F.Intrinsic.Control.CallSub(CatchingMobile)
F.Intrinsic.Control.EndTry

F.ODBC.Connection!Con.Close
Program.Sub.Main.End
```

---

# FUNCTIONLINKS CONTROL (Gui.<Form>.<FunctionLinksControl>.*)

FunctionLinks display a panel of clickable action links organized into collapsible groups.

## FunctionLinks API
```
Gui.<Form>.<FL>.AddGroup(sGroupID,sCaption,[sParentGroupID],[bCollapsible],[bCollapsed],[iInternationalID],[bGroupVisible])
Gui.<Form>.<FL>.AddFunctionLink(sLinkID,sCaption,[SvgPicture],[iSvgWidth],[iSvgHeight],[sImage],[iHookNo],[iInternationalID],[sGroupID],[bBeginGroup])
Gui.<Form>.<FL>.UpdateFunctionLink(sLinkID,sCaption,[SvgPicture],[iSvgWidth],[iSvgHeight],[sImage],[iHookNo],[iInternationalID],[sGroupID],[bBeginGroup])
Gui.<Form>.<FL>.UpdateGroup(sGroupID,sCaption,[sParentGroupID],[bCollapsible],[bCollapsed],[iInternationalID])
Gui.<Form>.<FL>.RemoveFunctionLink(sLinkID)
Gui.<Form>.<FL>.SetGroupCollapsed(sGroupID,bCollapsed)
Gui.<Form>.<FL>.SetGroupVisible(sGroupID,bVisible)
Gui.<Form>.<FL>.SetLinkMetaData(sLinkID,sDataN)
Gui.<Form>.<FL>.ClearLinkMetaData(sLinkID)
Gui.<Form>.<FL>.FireHooks(bHooksShouldFire)
```

## FunctionLinks Appearance
```
Gui.<Form>.<FL>.FontName(sName)
Gui.<Form>.<FL>.FontSize(fSize)
Gui.<Form>.<FL>.FontStyle(iStyle)                        ' 0=Regular, 1=Bold, 2=Italic, 4=Underline, 8=Strikeout
Gui.<Form>.<FL>.ForeColor(color)                         ' Accepts V.Enum.ThemeColors, Long, hex string, named color, RGB, or ARGB
Gui.<Form>.<FL>.Locked(bLocked)
Gui.<Form>.<FL>.FlowBreak(bBreakAfter)
Gui.<Form>.<FL>.Margin(iLeft,iTop,iRight,iBottom)
Gui.<Form>.<FL>.Padding(iLeft,iTop,iRight,iBottom)
Gui.<Form>.<FL>.Position(fX,fY)
Gui.<Form>.<FL>.TabIndex(iIndex)
Gui.<Form>.<FL>.TabStop(bIsTabStop)
```

---

# GSOBJECTGRIDCONTROL (Gui.Form.GsObjectGridControl.*)

The GsObjectGridControl is an object-backed grid control (as opposed to DataTable-backed GsGridControl).

## GsObjectGridControl API
```
Gui.<Form>.<OGC>.Create("controlName")
Gui.<Form>.<OGC>.EnableMasterViewMode(bEnabled)
Gui.<Form>.<OGC>.AddGridview("gvName")
Gui.<Form>.<OGC>.MainView("gvName")
Gui.<Form>.<OGC>.DataSource("objectName")
Gui.<Form>.<OGC>.AddColumn("gvName","ColName","DataType",bVisible,bReadOnly)
Gui.<Form>.<OGC>.AddDisplayPartColumn("gvName","ColName",bVisible,bReadOnly)
Gui.<Form>.<OGC>.AddExpressionColumn("gvName","ColName","Expression",bVisible,bReadOnly)
Gui.<Form>.<OGC>.ColumnEdit("gvName","ColName","EditorType","EditorArgs")
Gui.<Form>.<OGC>.SetColumnProperty("gvName","ColName","PropName",value)
Gui.<Form>.<OGC>.GetCellValueByColumnName("gvName","ColName",iRowIndex,sResult)
Gui.<Form>.<OGC>.SetCellValue("gvName","ColName",iRowIndex,"value")
Gui.<Form>.<OGC>.GetFocusedGridView(sResult)
Gui.<Form>.<OGC>.GetGridviewProperty("gvName","PropName",sResult)
Gui.<Form>.<OGC>.SetGridViewProperty("gvName","PropName",value)
Gui.<Form>.<OGC>.GetRowCount("gvName",iResult)
Gui.<Form>.<OGC>.GetRowHandle("gvName",iVisibleIndex,iResult)
Gui.<Form>.<OGC>.GetRowValues("gvName",iRow,"Col1*!*Col2",sResult)
Gui.<Form>.<OGC>.GetSelectedRows("gvName",sResult)
Gui.<Form>.<OGC>.BestFitColumns("gvName")
Gui.<Form>.<OGC>.ExpandMasterRow("gvName",iRowHandle)
Gui.<Form>.<OGC>.CollapseMasterRow("gvName",iRowHandle)
Gui.<Form>.<OGC>.BeginDataUpdate
Gui.<Form>.<OGC>.EndDataUpdate
Gui.<Form>.<OGC>.Event("EventName","SubName")
```

---

# GSDASHBOARDVIEWER (Gui.Form.GsDashboardViewer.*)

```
Gui.<Form>.<DV>.Create("controlName")
Gui.<Form>.<DV>.GetDashboards(sResult)                   ' Get list of available dashboards
Gui.<Form>.<DV>.LoadDashboard(sDashboardName)             ' Load a dashboard by name
```

---

# ADDITIONAL CONTROL METHODS (extracted-only)

## Frame Control Extras
```
Gui.<Form>.<Frame>.ButtonSvgImage(SvgImage)
Gui.<Form>.<Frame>.FlowBreak(bBreakAfterControl)
Gui.<Form>.<Frame>.HasButton(bHasButton)
```

## ComboBox Extras
```
Gui.<Form>.<ComboBox>.AddItems(sItems)                   ' Add items to combobox
```

## GsRichEditControl Extras
```
Gui.<Form>.<RichEdit>.AppendRtfText(sRtfText)            ' Append RTF-formatted text
```

## GsWebBrowser Extras
```
Gui.<Form>.<WebBrowser>.LoadUrl(sUrl)                    ' Navigate to URL
```

## GsWebView Extras
```
Gui.<Form>.<WebView>.ZoomFactor(fZoom)                   ' Set zoom level
```

## GsWebView2 Extras
```
Gui.<Form>.<WebView2>.ShowPrintUI                         ' Show print dialog
```

## GsChart Extras
```
Gui.<Form>.<Chart>.AddSeriesToBarChart(sSeriesName,sValues,sCategories)
Gui.<Form>.<Chart>.AddSeriesToLineChart(sSeriesName,sValues,sCategories)
```

## GsCardView Extras
```
Gui.<Form>.<CardView>.AddDataView("dvName")              ' Bind DataView to CardView
```

## GsSchedulerControl Extras
```
Gui.<Form>.<Scheduler>.AddStatuses(sStatuses)            ' Add scheduler statuses
```

## GsToggleSwitch Extras
```
Gui.<Form>.<Toggle>.OffText(sText)                       ' Set "off" state label
Gui.<Form>.<Toggle>.OnText(sText)                        ' Set "on" state label
```

## GsFlexGrid (Legacy) Extras
```
Gui.<Form>.<FlexGrid>.ReadRow(iRow,sResult)              ' Read entire row data
Gui.<Form>.<FlexGrid>.RowHeight(iRow,iHeight)            ' Set row height
```

## Hyperlink / ListView Extras
```
Gui.<Form>.<Hyperlink>.AutoSizeMode(iMode)               ' Set auto-size behavior
Gui.<Form>.<ListView>.ClearListViewColumns               ' Remove all ListView columns
```

## Generic Control Extras
```
Gui.<Form>.<Control>.Dispose                              ' Destroy control at runtime
Gui.<Form>.<Control>.ControlGroup(sGroupName)             ' Assign control to a group
Gui.<Form>.<Control>.BorderColor(iColor)
Gui.<Form>.<Control>.LayoutCaption(sCaption)
Gui.<Form>.<Control>.ToolTipText(sText)
Gui.<Form>.<Control>.UpDown(bEnabled)
Gui.<Form>.<Control>.Sorted(bSorted)
Gui.<Form>.<Control>.SetListviewColumnWidth(iColIndex,iWidth)
Gui.<Form>.<Control>.NodeProps(sNodeKey,sPropName,value)  ' TreeView node property
Gui.<Form>.<Control>.TabsPerRow(iCount)
Gui.<Form>.<Control>.RenderCalendar                       ' Render MonthView calendar
Gui.<Form>.<Control>.ImageToFile(sFilePath)               ' Save control image to file
Gui.<Form>.<Control>.TextHeight(sText,iResult)            ' Measure text height
Gui.<Form>.<Control>.TextWidth(sText,iResult)             ' Measure text width
Gui.<Form>.<Control>.AllowResizing(bAllow)                ' Enable/disable column resizing (GsFlexGrid)
```

## Form-Level Extras
```
Gui.<Form>..AddMenuItem(sMenuID,sCaption,sParentID)
Gui.<Form>..AllowDock(bAllow)
Gui.<Form>..AllowUndock(bAllow)
Gui.<Form>..ApplyMasks
Gui.<Form>..ApplyTheme(sThemeName)
Gui.<Form>..ApplyTranslation
Gui.<Form>..BindTo(sFormName)
Gui.<Form>..Circle(iX,iY,iRadius)
Gui.<Form>..ClearGroup(sGroupName)
Gui.<Form>..ClearScreen
Gui.<Form>..ContextMenuClearComboItems(sMenuID)

' Internal menu manipulation
Gui.<Form>..InternalMenuAddItem(sMenuID,sCaption,sParentID)
Gui.<Form>..InternalMenuAddComboItem(sMenuID,sItem)
Gui.<Form>..InternalMenuClearComboItems(sMenuID)
Gui.<Form>..InternalMenuRemoveItem(sMenuID)
Gui.<Form>..InternalMenuSetItemText(sMenuID,sCaption)
Gui.<Form>..InternalMenuSetItemEventHandler(sMenuID,sSubName)
```

