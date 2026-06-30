# GAB GUI Controls Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with GsRepositoryLookup through GsTileViewControl and related control APIs
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---
### GsRepositoryLookup
A lookup control designed for embedding into grid columns via `ColumnEdit`. Unlike `GsLookUpControl` (standalone), a `GsRepositoryLookup` is attached to a grid column so users can pick from a lookup popup inline.

**ScreenSU setup:**
```
Gui.<Form>.LookupRepo.Create(GsRepositoryLookup)
Gui.<Form>.LookupRepo.Title("Parts")
Gui.<Form>.LookupRepo.Size(100,120)
Gui.<Form>.LookupRepo.Position(215,12)
Gui.<Form>.LookupRepo.LookupMode(1154)              ' GSS entity type ID
Gui.<Form>.LookupRepo.Enabled(True)
```

**Runtime configuration:**
```
Gui.<Form>.LookupRepo.DisplayProperty("LongPartNumber")
Gui.<Form>.LookupRepo.TextEditStyle(0)               ' 0 = editable text, 1 = non-editable
Gui.<Form>.LookupRepo.IsForcePopup(False)             ' True = always show popup; False = auto-complete
Gui.<Form>.LookupRepo.HookSequence(-1)                ' GAB override hook sequence (-1 = first active)
Gui.<Form>.LookupRepo.UseHook(False)                  ' Set False to suppress GAB override scripts
Gui.<Form>.LookupRepo.Event(SelectionMade,luRepo_SelectionMade)
```

**Binding to a grid column:** Use `ColumnEdit` with editor type `"lookup"` and the repository control name:
```
Gui.<Form>.GsGridControl1.ColumnEdit("gvName","ColName","lookup","LookupRepo")
```

**SelectionMade handler:** Similar to `GsLookUpControl`, but also provides `V.Args.Value` (the single cell value based on `DisplayProperty`):
```
Program.Sub.luRepo_SelectionMade.Start
F.Intrinsic.UI.Msgbox(V.Args.Value)
F.Intrinsic.UI.Msgbox(V.Object.[V.Args.lookupReturn](0).LongPartNumber!FieldVal)
Program.Sub.luRepo_SelectionMade.End
```

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source identifier |
| `V.Args.Screen` | String | Form name |
| `V.Args.ControlName` | String | Control name (e.g., `"LookupRepo"`) |
| `V.Args.ControlType` | String | Control type |
| `V.Args.EventType` | String | `"SelectionMade"` |
| `V.Args.Value` | String | Selected cell value based on `DisplayProperty` |
| `V.Args.lookupReturn` | String | Entity object instance name containing the selected result |

### GsWebBrowser
An embedded web browser control.
```
Gui.<Form>.gsWebBrowser.Create(GsWebBrowser)
Gui.<Form>.gsWebBrowser.Dock(5)
Gui.<Form>.gsWebBrowser.Navigate(sURL)
Gui.<Form>.gsWebBrowser.Event(UrlChanged,gsWebBrowser_UrlChanged)
```

### GsWebView2
A modern Chromium-based web browser control (successor to GsWebBrowser).
```
Gui.<Form>.GsWebView21.Create(GsWebView2)
Gui.<Form>.GsWebView21.Dock(5)
Gui.<Form>.GsWebView21.Source(sURL)        ' Load URL (triggers UrlChanged event)
Gui.<Form>.GsWebView21.Navigate(sURL)      ' Alternative navigation
Gui.<Form>.GsWebView21.Event(UrlChanged,GsWebView21_UrlChanged)  ' Register URL change handler
```

**Reading current URL:**
```
V.Local.sUrl.Set(V.Screen.frmDash!GsWebView21.SourceUrl)
```

#### GsWebView2 + HTML Communication Architecture

For web-based UIs hosted in GsWebView2, use this bidirectional communication pattern:

**JS → GAB (URL hash):** JavaScript modifies `window.location.hash`, which triggers GAB's `UrlChanged` event.
```javascript
// JS side
window.location.hash = "action|arg1|arg2|_t=" + Date.now();
```
```
' GAB side - UrlChanged handler
V.Local.sUrl.Set(V.Screen.frmDash!GsWebView21.SourceUrl)
F.Intrinsic.String.InStr(V.Local.sUrl,"#",1,V.Local.iHashPos)
F.Intrinsic.Math.Add(V.Local.iHashPos,1,V.Local.iHashPos)
F.Intrinsic.String.Mid(V.Local.sUrl,V.Local.iHashPos,4000,V.Local.sFragment)
F.Intrinsic.String.Split(V.Local.sFragment,"|",V.Local.sParts)
V.Local.sAction.Set(V.Local.sParts(0))
F.Intrinsic.Control.SelectCase(V.Local.sAction)
    F.Intrinsic.Control.Case("refresh")
        '...
F.Intrinsic.Control.EndSelect
```

**GAB → JS (file + reload):** GAB writes data to a `.js` sidecar file, then reloads the page.
```
' Write data file
F.Intrinsic.File.String2File(V.Global.sJsonPath, V.Local.sContent)

' Build file:/// URL (convert backslashes, encode spaces)
F.Intrinsic.String.Replace(V.Global.sHtmlPath,"\","/",V.Local.sFileUrl)
F.Intrinsic.String.Replace(V.Local.sFileUrl," ","%20",V.Local.sFileUrl)
F.Intrinsic.String.Concat("file:///",V.Local.sFileUrl,V.Local.sFileUrl)

' Reload with cache buster
F.Intrinsic.Math.Add(V.Global.iReloadCounter,1,V.Global.iReloadCounter)
F.Intrinsic.String.Build("{0}?tab={1}&t={2}",V.Local.sFileUrl,V.Global.iActiveTab,V.Global.iReloadCounter,V.Local.sUrl)
Gui.frmDash.GsWebView21.Source(V.Local.sUrl)
```

**CRITICAL:** `fetch()` does not work from `file://` protocol due to browser security. Use `<script>` tag injection instead:
```javascript
// HTML loads data via script tag, not fetch
var script = document.createElement("script");
script.src = "inv_data.js?t=" + Date.now();
script.onload = function() { /* window.INV_DATA is now available */ };
document.head.appendChild(script);
```

The JS sidecar file wraps data in a global variable assignment:
```javascript
// inv_data.js (generated by GAB)
window.INV_DATA={"meta":{...},"rows":[...]};
```

### GsPdfViewer
An embedded PDF viewer control. Supports deferred (lazy) creation for performance -- create on first use rather than in ScreenSU.

**ScreenSU setup (inline creation):**
```
Gui.<Form>.GsPdfViewer1.Create(GsPdfViewer)
Gui.<Form>.GsPdfViewer1.Enabled(True)
Gui.<Form>.GsPdfViewer1.Visible(True)
Gui.<Form>.GsPdfViewer1.Zorder(0)
Gui.<Form>.GsPdfViewer1.Size(619,461)
Gui.<Form>.GsPdfViewer1.Position(51,63)
Gui.<Form>.GsPdfViewer1.CreateRibbon(7)
Gui.<Form>.GsPdfViewer1.Dock(5)
Gui.<Form>.GsPdfViewer1.SetProperty(V.Enum.GsPdfViewer!ZoomMode,V.Enum.GsPdfViewerZoomMode!FitToWidth)
Gui.<Form>.GsPdfViewer1.LoadDocument(sFilePath)
Gui.<Form>.GsPdfViewer1.Event(KeyPress,GsPdfViewer1_KeyPress)
Gui.<Form>.GsPdfViewer1.Event(KeyPressEnter,GsPdfViewer1_KeyPressEnter)
Gui.<Form>.GsPdfViewer1.Event(MouseDown,GsPdfViewer1_MouseDown)
Gui.<Form>.GsPdfViewer1.Event(MouseMove,GsPdfViewer1_MouseMove)
Gui.<Form>.GsPdfViewer1.Event(MouseUp,GsPdfViewer1_MouseUp)
```

**Deferred creation pattern** (preferred when the control may not always be needed):
Guard with a global boolean; create the control in a dedicated subroutine on first use.
```
' -- In Preflight: declare tracking flag --
V.Global.bPDFControlCreated.Declare(Boolean,False)

' -- Dedicated loader subroutine --
Program.Sub.GsPDFControl_Load.Start
  Gui.<Form>.GsPdfViewer1.Create(GsPdfViewer)
  Gui.<Form>.GsPdfViewer1.Enabled(True)
  Gui.<Form>.GsPdfViewer1.Visible(False)
  Gui.<Form>.GsPdfViewer1.Zorder(0)
  Gui.<Form>.GsPdfViewer1.Size(11070,7965)
  Gui.<Form>.GsPdfViewer1.Position(0,0)
  Gui.<Form>.GsPdfViewer1.CreateRibbon(7)
  Gui.<Form>.GsPdfViewer1.Parent("tabx1",0)
  Gui.<Form>.GsPdfViewer1.Dock(5)
  Gui.<Form>.GsPdfViewer1.SetProperty(V.Enum.GsPdfViewer!ZoomMode,V.Enum.GsPdfViewerZoomMode!FitToWidth)
Program.Sub.GsPDFControl_Load.End

' -- On-demand creation + document load --
F.Intrinsic.Control.If(V.Global.bPDFControlCreated,=,False)
  F.Intrinsic.Control.CallSub(GsPDFControl_Load)
  V.Global.bPDFControlCreated.Set(True)
F.Intrinsic.Control.EndIf
Gui.<Form>.GsPdfViewer1.Visible(True)
Gui.<Form>.GsPdfViewer1.LoadDocument(V.Local.sFile)
```

**Multi-viewer visibility pattern** (when switching between PDF, RichEdit, Spreadsheet, WebView):
Hide all other viewer controls before showing the target viewer.
```
' -- File extension routing helper --
Program.Sub.GetControlName.Start
V.Local.sExt.Set(V.Args.EXT)
F.Intrinsic.Control.If(V.Local.sExt,=,"PDF")
  V.Local.sControlName.Set("PdfViewer")
F.Intrinsic.Control.ElseIf(...)
  '... RichEdit for DOCX/RTF/TXT, Spreadsheet for XLSX/CSV, Web for HTTP/HTML, Image for JPG/PNG
F.Intrinsic.Control.EndIf
F.Intrinsic.Variable.AddRV("CONTROL",V.Local.sControlName)
Program.Sub.GetControlName.End

' -- Caller: route by extension, hide others, show + load target --
F.Intrinsic.Control.CallSub(GetControlName,"EXT",V.Local.sExtension.UCase)
F.Intrinsic.Control.If(V.Args.CONTROL,=,"PdfViewer")
  F.Intrinsic.Control.If(V.Global.bPDFControlCreated,=,False)
    F.Intrinsic.Control.CallSub(GsPDFControl_Load)
    V.Global.bPDFControlCreated.Set(True)
  F.Intrinsic.Control.EndIf
  F.Intrinsic.Control.If(V.Global.bSpreadsheetControlCreated,=,True)
    Gui.<Form>.GsSpreadsheetControl1.Visible(False)
  F.Intrinsic.Control.EndIf
  F.Intrinsic.Control.If(V.Global.bRichEditControlCreated,=,True)
    Gui.<Form>.GsRichEditControl1.Visible(False)
  F.Intrinsic.Control.EndIf
  Gui.<Form>.GSWebView21.Visible(False)
  Gui.<Form>.GsPdfViewer1.Visible(True)
  Gui.<Form>.GsPdfViewer1.LoadDocument(V.Local.sFile)
F.Intrinsic.Control.EndIf
```

> **Reference:** `ATG_DocControl_V2.g2u` -- production document management script demonstrating deferred creation, multi-viewer toggling, and file-extension-based routing across GsPdfViewer, GsRichEditControl, GsSpreadsheetControl, and GsWebView2.

#### GsPdfViewer Events V.Args

> ControlType: `"GSPDFVIEWER"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("None", "Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**KeyPress event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.KeyPress` | Long | ASCII key code of the pressed key (e.g. 115 for "s") |
| `V.Args.Character` | String | Character representation of the key (e.g. "s") |

**KeyPressEnter event** -- 5 args (standard args only)

### GsRichEditControl
A rich text editor with ribbon toolbar. Supports deferred (lazy) creation for performance -- create on first use rather than in ScreenSU.

**ScreenSU setup (inline creation):**
```
Gui.<Form>.GsRichEditControl1.Create(GsRichEditControl)
Gui.<Form>.GsRichEditControl1.Enabled(True)
Gui.<Form>.GsRichEditControl1.Visible(True)
Gui.<Form>.GsRichEditControl1.Zorder(0)
Gui.<Form>.GsRichEditControl1.Size(439,336)
Gui.<Form>.GsRichEditControl1.Position(67,63)
Gui.<Form>.GsRichEditControl1.CreateRibbon(65535)
Gui.<Form>.GsRichEditControl1.DisplayFormulabar(True)
Gui.<Form>.GsRichEditControl1.Dock(5)
Gui.<Form>.GsRichEditControl1.LoadDocument(sFilePath)
Gui.<Form>.GsRichEditControl1.LoadFromString(sContent)
Gui.<Form>.GsRichEditControl1.Event(GotFocus,GsRichEditControl1_GotFocus)
Gui.<Form>.GsRichEditControl1.Event(KeyPress,GsRichEditControl1_KeyPress)
Gui.<Form>.GsRichEditControl1.Event(KeyPressEnter,GsRichEditControl1_KeyPressEnter)
Gui.<Form>.GsRichEditControl1.Event(LostFocus,GsRichEditControl1_LostFocus)
Gui.<Form>.GsRichEditControl1.Event(MouseDown,GsRichEditControl1_MouseDown)
Gui.<Form>.GsRichEditControl1.Event(MouseMove,GsRichEditControl1_MouseMove)
Gui.<Form>.GsRichEditControl1.Event(MouseUp,GsRichEditControl1_MouseUp)
```

**Deferred creation pattern** (preferred when the control may not always be needed):
Guard with a global boolean; create the control in a dedicated subroutine on first use.
```
' -- In Preflight: declare tracking flag --
V.Global.bRichEditControlCreated.Declare(Boolean,False)

' -- Dedicated loader subroutine --
Program.Sub.GsRichEditControl_Load.Start
  Gui.<Form>.GsRichEditControl1.Create(GsRichEditControl)
  Gui.<Form>.GsRichEditControl1.Enabled(True)
  Gui.<Form>.GsRichEditControl1.Visible(False)
  Gui.<Form>.GsRichEditControl1.Zorder(0)
  Gui.<Form>.GsRichEditControl1.Size(11070,7965)
  Gui.<Form>.GsRichEditControl1.Position(0,0)
  Gui.<Form>.GsRichEditControl1.CreateRibbon(65535)
  Gui.<Form>.GsRichEditControl1.Parent("tabx1",0)
  Gui.<Form>.GsRichEditControl1.Dock(5)
Program.Sub.GsRichEditControl_Load.End

' -- On-demand creation + document load --
F.Intrinsic.Control.If(V.Global.bRichEditControlCreated,=,False)
  F.Intrinsic.Control.CallSub(GsRichEditControl_Load)
  V.Global.bRichEditControlCreated.Set(True)
F.Intrinsic.Control.EndIf
Gui.<Form>.GsRichEditControl1.Visible(True)
Gui.<Form>.GsRichEditControl1.LoadDocument(V.Local.sFile)
```

> **Reference:** `ATG_DocControl_V2.g2u` -- production document management script demonstrating deferred creation and multi-viewer toggling for GsRichEditControl alongside GsPdfViewer, GsSpreadsheetControl, and GsWebView2.

#### GsRichEditControl Events V.Args

> ControlType: `"GSRICHEDITCONTROL"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("None", "Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**KeyPress event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.KeyPress` | Long | ASCII key code of the pressed key (e.g. 115 for "s") |
| `V.Args.Character` | String | Character representation of the key (e.g. "s") |

**GotFocus / LostFocus events** -- 5 args (standard args only)

**KeyPressEnter event** -- 5 args (standard args only)

**Event chain:** GotFocus -> (user interacts) -> MouseDown -> LostFocus -> MouseUp

### GsSpreadsheetControl
An embedded spreadsheet editor with ribbon toolbar.

**ScreenSU setup:**
```
Gui.<Form>.GsSpreadsheetControl1.Create(GsSpreadsheetControl)
Gui.<Form>.GsSpreadsheetControl1.Enabled(True)
Gui.<Form>.GsSpreadsheetControl1.Visible(True)
Gui.<Form>.GsSpreadsheetControl1.Zorder(0)
Gui.<Form>.GsSpreadsheetControl1.Size(696,469)
Gui.<Form>.GsSpreadsheetControl1.Position(53,35)
Gui.<Form>.GsSpreadsheetControl1.LoadDocument("")
Gui.<Form>.GsSpreadsheetControl1.CreateRibbon(8191)
Gui.<Form>.GsSpreadsheetControl1.DisplayFormulabar(True)
Gui.<Form>.GsSpreadsheetControl1.Event(KeyPress,GsSpreadsheetControl1_KeyPress)
Gui.<Form>.GsSpreadsheetControl1.Event(MouseDown,GsSpreadsheetControl1_MouseDown)
Gui.<Form>.GsSpreadsheetControl1.Event(MouseMove,GsSpreadsheetControl1_MouseMove)
Gui.<Form>.GsSpreadsheetControl1.Event(MouseUp,GsSpreadsheetControl1_MouseUp)
Gui.<Form>.GsSpreadsheetControl1.Event(GotFocus,GsSpreadsheetControl1_GotFocus)
Gui.<Form>.GsSpreadsheetControl1.Event(LostFocus,GsSpreadsheetControl1_LostFocus)
```

**Additional methods:**
```
Gui.<Form>.GsSpreadsheetControl1.Dock(5)
Gui.<Form>.GsSpreadsheetControl1.LoadFromUDT(V.uGlobal.uData)
Gui.<Form>.GsSpreadsheetControl1.ExportToUDT(V.uGlobal.uData)
```

#### GsSpreadsheetControl Events V.Args

> ControlType: `"GSSPREADSHEETCONTROL"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("None", "Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**KeyPress event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.KeyPress` | Long | ASCII key code of the pressed key (e.g. 115 for "s") |
| `V.Args.Character` | String | Character representation of the key (e.g. "s") |

**GotFocus / LostFocus events** -- 5 args (standard args only)

**Event chain:** GotFocus -> (user interacts) -> MouseDown -> LostFocus -> MouseUp

### GsSchedulerControl
A calendar/scheduler control for appointment management with resources, labels, statuses, and print preview.

**ScreenSU setup:**
```
Gui.<Form>.GsSchedulerControl1.Create(GsSchedulerControl)
Gui.<Form>.GsSchedulerControl1.Enabled(True)
Gui.<Form>.GsSchedulerControl1.Visible(True)
Gui.<Form>.GsSchedulerControl1.Zorder(0)
Gui.<Form>.GsSchedulerControl1.Size(872,500)
Gui.<Form>.GsSchedulerControl1.Position(10,10)
Gui.<Form>.GsSchedulerControl1.Parent("frame1")
Gui.<Form>.GsSchedulerControl1.Anchor(15)
Gui.<Form>.GsSchedulerControl1.Dock(5)
```

**Mapping syntax:** GsSchedulerControl uses a delimited mapping string to bind datatable columns to scheduler properties:
- `PropertyName*!*ColumnName` -- maps a scheduler property to a datatable column
- `@!@` -- separates multiple mapping pairs
- Example: `"ID*!*Id@!@Caption*!*ResourceName"` maps scheduler `ID` to column `Id`, and `Caption` to column `ResourceName`

**Setting properties:**
```
' ActiveViewType: Day(0), Week(1), Month(2), WorkWeek(3), Timeline(4), Gantt(5), FullWeek(6), Agenda(7)
Gui.<Form>.GsSchedulerControl1.SetProperties(V.Enum.SchedulerControlProperties!ActiveViewType,V.Enum.SchedulerControlActiveViewType!Day)
Gui.<Form>.GsSchedulerControl1.SetProperties("ActiveViewtype",3)    ' String/numeric form also works

' GroupType: "none", "date", "resource"
Gui.<Form>.GsSchedulerControl1.SetProperties("GroupType","none")

' Appearance
Gui.<Form>.GsSchedulerControl1.SetAppearanceProperties(V.Enum.SchedulerControlAppearanceProperties!AppointmentForeColor,V.Color.Gray)
```

**Resources datatable + binding:**
```
F.Data.DataTable.Create("dtResources",true)
F.Data.DataTable.AddColumn("dtResources","ResourceName","String")
F.Data.DataTable.AddColumn("dtResources","Id","Long")
F.Data.DataTable.AddRow("dtResources","ResourceName","John","Id",1)
F.Data.DataTable.AddRow("dtResources","ResourceName","Phillip","Id",2)

Gui.<Form>.GsSchedulerControl1.AddResources("dtResources","ID*!*Id@!@Caption*!*ResourceName")
```

**Appointments datatable + binding:**
```
F.Data.DataTable.Create("dtAppointments",true)
F.Data.DataTable.AddColumn("dtAppointments","StartDate","datetime")
F.Data.DataTable.AddColumn("dtAppointments","EndDate","datetime")
F.Data.DataTable.AddColumn("dtAppointments","ResourceID","Long")
F.Data.DataTable.AddColumn("dtAppointments","Subject","String")
F.Data.DataTable.AddColumn("dtAppointments","Status","Long")
F.Data.DataTable.AddColumn("dtAppointments","label","Long")
F.Data.DataTable.AddColumn("dtAppointments","Location","String")
F.Data.DataTable.AddColumn("dtAppointments","AllDay","Boolean")

F.Data.DataTable.AddRow("dtAppointments","StartDate",V.Local.dStart,"EndDate",V.Local.dEnd,"ResourceID",1,"Subject","Meeting with John","Status",V.Enum.AppointmentStatuses!Free,"label",V.Enum.AppointmentLabels!MustAttend)

Gui.<Form>.GsSchedulerControl1.AddAppointments("dtAppointments","Start*!*StartDate@!@End*!*EndDate@!@ResourceId*!*ResourceID@!@Subject*!*Subject@!@Label*!*label@!@Status*!*Status")
```

**Extended appointment mapping** (with Location and AllDay):
```
Gui.<Form>.GsSchedulerControl1.AddAppointments("dtAppointments","Start*!*StartDate@!@End*!*EndDate@!@AppointmentId*!*ResourceID@!@Subject*!*Subject@!@Location*!*Location@!@Label*!*label@!@Status*!*Status@!@AllDay*!*Allday")
```

**Labels datatable + binding:**
```
F.Data.DataTable.Create("dtLabels",true)
F.Data.DataTable.AddColumn("dtLabels","LabelName","String")
F.Data.DataTable.AddColumn("dtLabels","Id","Long")
F.Data.DataTable.AddRow("dtLabels","LabelName","Critical","Id",2)

Gui.<Form>.GsSchedulerControl1.AddLabels("dtLabels","Id*!*Id@!@MenuCaption*!*LabelName")
```

**Creating items directly (without datatable):**
```
' Create an appointment
Gui.<Form>.GsSchedulerControl1.CreateAppointment(V.Enum.AppointmentType!Normal,"Start",V.Local.dStart,"End",V.Local.dEnd,"Subject","Meeting with Sales Department")

' Create a label with color
Gui.<Form>.GsSchedulerControl1.CreateLabel("NotNeeded","NotNeeded",V.Color.Yellow)

' Create a resource with ID and color
Gui.<Form>.GsSchedulerControl1.CreateResource(5,"Katie",V.Color.Red)

' Create a status with color
Gui.<Form>.GsSchedulerControl1.CreateStatus("OnJuryDuty","OnJuryDuty",V.Color.Black)
```

**Print preview:**
```
Gui.<Form>.GsSchedulerControl1.ShowPrintPreview
```

#### GsSchedulerControl Appointment Mapping Properties

| Mapping Property | DataTable Column Type | Description |
|------------------|-----------------------|-------------|
| `Start` | datetime | Appointment start date/time |
| `End` | datetime | Appointment end date/time |
| `ResourceId` | Long | Linked resource ID |
| `AppointmentId` | Long | Appointment identifier (alternative to ResourceId for grouping) |
| `Subject` | String | Appointment subject/title |
| `Label` | Long | Label ID (maps to AppointmentLabels enum or custom label) |
| `Status` | Long | Status ID (maps to AppointmentStatuses enum or custom status) |
| `Location` | String | Appointment location (optional) |
| `AllDay` | Boolean | Whether the appointment spans the full day (optional) |

#### GsSchedulerControl Enums

| Enum | Values |
|------|--------|
| `V.Enum.SchedulerControlProperties!ActiveViewType` | Property name for SetProperties |
| `V.Enum.SchedulerControlActiveViewType` | `!Day`(0), `!Week`(1), `!Month`(2), `!WorkWeek`(3), `!Timeline`(4), `!Gantt`(5), `!FullWeek`(6), `!Agenda`(7) |
| `V.Enum.SchedulerControlAppearanceProperties` | `!AppointmentForeColor` |
| `V.Enum.AppointmentStatuses` | `!Free`, `!Tentative`, `!WorkingElsewhere` |
| `V.Enum.AppointmentLabels` | `!MustAttend`, `!Important` |
| `V.Enum.AppointmentType` | `!Normal` |

> **Reference:** Inline example above is a complete working g2u file. `GCG_TimeKeeper.g2u` demonstrates production use with SQL-loaded appointments, computed date ranges, and WorkWeek view with resource grouping.

### GsSpellChecker
A non-visual service control that attaches spell-checking to text controls (TextBox, TextboxM, TextBoxR). Created at runtime in Main (not in ScreenSU).

> **Exception to ScreenSU rule:** `GsSpellChecker`, deferred-creation `GsPdfViewer`, and deferred-creation `GsRichEditControl` are created in Main or a subroutine rather than in ScreenSU. Event wiring for these controls (if any) also occurs in the creating subroutine rather than ScreenSU.

**Setup (in Main, after UsePixels):**
```
Gui.<Form>.GsSpellChecker1.Create(GsSpellChecker)
Gui.<Form>.GsSpellChecker1.Enabled(True)
Gui.<Form>.GsSpellChecker1.Culture("en-US")

' SpellCheckMode: 0 = On Demand, 1 = As You Type
Gui.<Form>.GsSpellChecker1.SpellCheckMode(1)

' Attach to all text controls in a container (form or frame)
Gui.<Form>.GsSpellChecker1.ParentContainer("Form")
```

**Checking specific controls (On-Demand mode):**
```
' Check a single control
Gui.<Form>.GsSpellChecker1.Check("txtMemo")

' Check all controls within a container
Gui.<Form>.GsSpellChecker1.CheckContainer("frameName")

' Show/hide right-click spell check menu
Gui.<Form>.GsSpellChecker1.SetShowSpellCheckMenu(True)
```

**Complete working example:**
```
Program.Sub.ScreenSU.Start
Gui.Form..Create(BaseForm)
Gui.Form..Caption("Form")
Gui.Form..Size(640,580)
Gui.Form..Position(0,0)
Gui.Form..Event(UnLoad,Form_UnLoad)
Gui.Form.txtTextBox.Create(TextBox,"",True,590,26,0,26,32,True,0,"Tahoma",8,,1)
Gui.Form.txtMemo.Create(TextboxM)
Gui.Form.txtMemo.Enabled(True)
Gui.Form.txtMemo.Visible(True)
Gui.Form.txtMemo.Size(590,228)
Gui.Form.txtMemo.Position(26,70)
Gui.Form.txtRichText.Create(TextBoxR)
Gui.Form.txtRichText.Enabled(True)
Gui.Form.txtRichText.Visible(True)
Gui.Form.txtRichText.Size(590,200)
Gui.Form.txtRichText.Position(26,312)
Program.Sub.ScreenSU.End

Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels
Gui.Form.GsSpellChecker1.Create(GsSpellChecker)
Gui.Form.GsSpellChecker1.Culture("en-US")
Gui.Form.GsSpellChecker1.SpellCheckMode(1)
Gui.Form.GsSpellChecker1.ParentContainer("Form")
Gui.Form..Show
Program.Sub.Main.End
```

> **Note:** GsSpellChecker is created at runtime, not in ScreenSU. Use `SpellCheckMode(1)` for real-time as-you-type checking. Use `SpellCheckMode(0)` with `Check()` or `CheckContainer()` for on-demand checking.

### HtmlContainer
An embedded HTML rendering control for displaying HTML content, web pages, or local HTML files. Exposes browser-like properties (Busy, LocationName, LocationURL, Path) for monitoring navigation state.
```
Gui.<Form>.htmlView.Create(HtmlContainer)
Gui.<Form>.htmlView.Size(6000,4000)
Gui.<Form>.htmlView.Position(120,360)
Gui.<Form>.htmlView.Dock(5)
Gui.<Form>.htmlView.Visible(True)
Gui.<Form>.htmlView.Enabled(True)
Gui.<Form>.htmlView.Navigate("https://example.com")
Gui.<Form>.htmlView.Navigate("C:\temp\report.html")
```

Runtime read-back properties (see `agents/gab/GUI_EVENTS.md` > "HtmlContainer V.Screen Properties" for the full table):
```
V.Screen.<Form>!htmlView.Busy()            ' True while loading
V.Screen.<Form>!htmlView.LocationName()    ' Document title
V.Screen.<Form>!htmlView.LocationURL()     ' Current URL
V.Screen.<Form>!htmlView.Path()            ' Source path/URL
```

### GsFlexGrid (Legacy)

> **LEGACY ONLY -- Do NOT use in new GAB projects.** Use GsGridControl instead. This reference exists only for maintaining older scripts that already use GsFlexGrid.

Legacy grid control (predecessor to GsGridControl).
```
Gui.<Form>.flexGrid1.Create(GsFlexGrid)
Gui.<Form>.flexGrid1.Cols(5)
Gui.<Form>.flexGrid1.Rows(10)
Gui.<Form>.flexGrid1.FixedCols(0)
Gui.<Form>.flexGrid1.FixedRows(1)
Gui.<Form>.flexGrid1.ColWidth(0,2000)
Gui.<Form>.flexGrid1.TextMatrix(iRow,iCol,"value")
Gui.<Form>.flexGrid1.GetTextMatrix(iRow,iCol,sResult)
Gui.<Form>.flexGrid1.TopRow(iRow)
Gui.<Form>.flexGrid1.RowSel(iRow)
Gui.<Form>.flexGrid1.ClearFilters()                 ' Clears all column filters on the grid

' Data manipulation
Gui.<Form>.flexGrid1.InsertRow()
Gui.<Form>.flexGrid1.DeleteRow(iRow)
Gui.<Form>.flexGrid1.MoveRow()
Gui.<Form>.flexGrid1.MoveRowToTop()
Gui.<Form>.flexGrid1.Commit()
Gui.<Form>.flexGrid1.TextMatrixKey("keyValue",iCol,"value")  ' Set cell by key column

' Appearance
Gui.<Form>.flexGrid1.RowColor(iRow, backColor, foreColor)
Gui.<Form>.flexGrid1.ColumnWidth(iCol, iWidth)
Gui.<Form>.flexGrid1.SetActiveCell(iRow, iCol)
Gui.<Form>.flexGrid1.SetColumnPercentages("20:30:50")        ' Colon-delimited percentages
Gui.<Form>.flexGrid1.HideAll()
Gui.<Form>.flexGrid1.SortColumn(iCol)
Gui.<Form>.flexGrid1.Sorting(True)

' Styles
Gui.<Form>.flexGrid1.BuildStyle("styleName","definition")
Gui.<Form>.flexGrid1.ApplyStyle("styleName")
Gui.<Form>.flexGrid1.ClearStyle()
Gui.<Form>.flexGrid1.RemoveStyle()

' Data I/O
Gui.<Form>.flexGrid1.LoadFromString(sData)
Gui.<Form>.flexGrid1.LoadFromUDT()
Gui.<Form>.flexGrid1.LoadRecordset(sRecordset)
Gui.<Form>.flexGrid1.Export(sFileName)
Gui.<Form>.flexGrid1.ExportToUDT()

' Hierarchical
Gui.<Form>.flexGrid1.SetParentRow(iRow)
Gui.<Form>.flexGrid1.GetParentRow(V.Local.iResult)
Gui.<Form>.flexGrid1.SetKey(iCol)

' Miscellaneous
Gui.<Form>.flexGrid1.Subclass("subclassName")
Gui.<Form>.flexGrid1.PaintPicture("imagePath")
```

### AccordionControl
A collapsible sidebar navigation control with serializable layout.
```
Gui.<Form>.AccordionControl1.Create(AccordionControl)
Gui.<Form>.AccordionControl1.Enabled(True)
Gui.<Form>.AccordionControl1.Visible(True)
Gui.<Form>.AccordionControl1.Size(3900,4500)
Gui.<Form>.AccordionControl1.Position(765,525)
Gui.<Form>.AccordionControl1.Minimized(False)
Gui.<Form>.AccordionControl1.Dock(3)                          ' 3 = Left dock
Gui.<Form>.AccordionControl1.AddElement(elementName,"Caption","icon_name",240,240,,-1,0,"",False,True,False,1)
Gui.<Form>.AccordionControl1.NavigationFrame("navFrameName")   ' Link to navigation frame
Gui.<Form>.AccordionControl1.Event(ElementClick,AccordionControl1_ElementClick)
Gui.<Form>.AccordionControl1.Event(MouseClick,AccordionControl1_MouseClick)
Gui.<Form>.AccordionControl1.Event(MouseDown,AccordionControl1_MouseDown)
Gui.<Form>.AccordionControl1.Event(MouseMove,AccordionControl1_MouseMove)
Gui.<Form>.AccordionControl1.Event(MouseUp,AccordionControl1_MouseUp)

' Serialization (persist user layout)
Gui.<Form>.AccordionControl1.AccordionSerialize(V.Local.sLayout)
Gui.<Form>.AccordionControl1.AccordionDeserialize(V.Local.sLayout)

' Element management
Gui.<Form>.AccordionControl1.UpdateElement(ElementName, Caption, SvgPicture, SvgPictureWidth, SvgPictureHeight, Picture, HookNo, InternationalID, ParentElementName, BeginsGroup, Visible, ElementStyle)
Gui.<Form>.AccordionControl1.RemoveElement(ElementName)
Gui.<Form>.AccordionControl1.SetElementVisible(ElementName, bVisible)
Gui.<Form>.AccordionControl1.SetElementCollapsed(ElementName, bCollapsed)
Gui.<Form>.AccordionControl1.SetElementMetaData(ElementName, MetaData0, ..., MetaData9)
Gui.<Form>.AccordionControl1.ClearElementMetaData(ElementName)
Gui.<Form>.AccordionControl1.NavPageElementVisible(NavPageElementName, bVisible)

' Control properties
Gui.<Form>.AccordionControl1.AllowResize(bFlag)
Gui.<Form>.AccordionControl1.SetAccordionControlProperty(V.Enum.AccordionControlProperties!PropertyName, Value)
```

#### AccordionControl Events V.Args

**Mouse events** (MouseClick, MouseDown, MouseMove, MouseUp):

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "ACCORDIONCONTROL1") |
| `V.Args.ControlType` | String | "ACCORDIONCONTROL" |
| `V.Args.EventType` | String | Event name (e.g. "MOUSECLICK") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**ElementClick event** (15 args -- standard 11 + 4 element-specific):

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "ACCORDIONCONTROL" |
| `V.Args.EventType` | String | "ELEMENTCLICK" |
| `V.Args.Button` | String | Mouse button |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Click x-coordinate |
| `V.Args.Y` | Long | Click y-coordinate |
| `V.Args.HookNo` | Long | Hook number (-1 if none) |
| `V.Args.ElementID` | String | Element name (e.g. "aceAutoPO") |
| `V.Args.Caption` | String | Element caption text |
| `V.Args.ElementStyle` | Long | Element style value |

#### AccordionControl V.Screen Properties

The AccordionControl exposes `MetaData0` through `MetaData9` with an optional `ElementName` parameter. When `ElementName` is omitted, returns metadata for the control itself. When provided, returns metadata for the named sub-element.

```
V.Screen.<Form>!AccordionControl1.MetaData0()                   ' Control-level metadata slot 0
V.Screen.<Form>!AccordionControl1.MetaData0("elementName")      ' Element-level metadata slot 0
V.Screen.<Form>!AccordionControl1.MetaData1("elementName")      ' Element-level metadata slot 1
' ... MetaData2 through MetaData8 follow the same pattern ...
V.Screen.<Form>!AccordionControl1.MetaData9("elementName")      ' Element-level metadata slot 9
```

| Method | Argument | Description |
|--------|----------|-------------|
| `.MetaData0([ElementName])` | Optional String | Metadata slot 0 for the control or named element |
| `.MetaData1([ElementName])` | Optional String | Metadata slot 1 for the control or named element |
| `.MetaData2([ElementName])` | Optional String | Metadata slot 2 for the control or named element |
| `.MetaData3([ElementName])` | Optional String | Metadata slot 3 for the control or named element |
| `.MetaData4([ElementName])` | Optional String | Metadata slot 4 for the control or named element |
| `.MetaData5([ElementName])` | Optional String | Metadata slot 5 for the control or named element |
| `.MetaData6([ElementName])` | Optional String | Metadata slot 6 for the control or named element |
| `.MetaData7([ElementName])` | Optional String | Metadata slot 7 for the control or named element |
| `.MetaData8([ElementName])` | Optional String | Metadata slot 8 for the control or named element |
| `.MetaData9([ElementName])` | Optional String | Metadata slot 9 for the control or named element |

#### AccordionControl Method Reference

**AddElement** -- Adds a new Group or Item to the AccordionControl.
```
Gui.<Form>.<AccordionControl>.AddElement(ElementName, Caption, [SvgPicture], [SvgPictureWidth], [SvgPictureHeight], [Picture], [HookNo], [InternationalID], [ParentElementName], [BeginsGroup], [Visible], [ElementStyle])
```
| Parameter | Type | Description |
|-----------|------|-------------|
| ElementName | String | Unique identifier for this element |
| Caption | String | Displayed text |
| SvgPicture | V.Enum.Image (optional) | Icon shown left of text |
| SvgPictureWidth | Long (optional) | Width of the SvgPicture |
| SvgPictureHeight | Long (optional) | Height of the SvgPicture |
| Picture | String (optional) | Included image name or full path to external image |
| HookNo | Long (optional) | Hook to fire on click; -1 = no hook |
| InternationalID | Long (optional) | Translation ID for Caption; 0 = no translation |
| ParentElementName | String (optional) | ElementName of parent to nest under |
| BeginsGroup | Boolean (optional) | If True, adds separator above this item |
| Visible | Boolean (optional) | Visibility of element and children |
| ElementStyle | V.Enum.AccordionElementStyle (optional) | Group or single Item |

**UpdateElement** -- Updates an existing element (same signature as AddElement).
```
Gui.<Form>.<AccordionControl>.UpdateElement(ElementName, Caption, SvgPicture, SvgPictureWidth, SvgPictureHeight, Picture, HookNo, InternationalID, ParentElementName, BeginsGroup, Visible, ElementStyle)
```

**RemoveElement** -- Removes an element from the AccordionControl.
```
Gui.<Form>.<AccordionControl>.RemoveElement(ElementName)
```

**SetElementVisible** -- Sets the visibility of an element.
```
Gui.<Form>.<AccordionControl>.SetElementVisible(ElementName, Visible)
```

**SetElementCollapsed** -- Collapses or expands a Group-style element.
```
Gui.<Form>.<AccordionControl>.SetElementCollapsed(ElementName, Collapsed)
```

**SetElementMetaData** -- Sets metadata values for the specified element (MetaData0..MetaData9).
```
Gui.<Form>.<AccordionControl>.SetElementMetaData(ElementName, MetaData0, ..., MetaDataN)
```

**ClearElementMetaData** -- Clears all metadata for the specified element.
```
Gui.<Form>.<AccordionControl>.ClearElementMetaData(ElementName)
```

**NavPageElementVisible** -- Sets the visibility of a NavPage element linked to the AccordionControl.
```
Gui.<Form>.<AccordionControl>.NavPageElementVisible(NavPageElementName, Visible)
```

**AllowResize** -- Enables or disables user resizing of the AccordionControl.
```
Gui.<Form>.<AccordionControl>.AllowResize(Flag)
```

**SetAccordionControlProperty** -- Sets a named property on the AccordionControl.
```
Gui.<Form>.<AccordionControl>.SetAccordionControlProperty(V.Enum.AccordionControlProperties!PropertyName, PropertyValue)
```

**AccordionSerialize** -- Serializes the control's layout to an XML string.
```
Gui.<Form>.<AccordionControl>.AccordionSerialize(ReturnString)
```

**AccordionDeserialize** -- Applies an XML layout to the control.
```
Gui.<Form>.<AccordionControl>.AccordionDeserialize(XmlLayout)
```

### GsBreadCrumb
A breadcrumb navigation control for hierarchical drill-down filtering. Users click through
cascading node levels; each selection narrows the path. Commonly used for multi-criteria
report filtering (e.g., Part Number > Customer > Salesperson).

```
' ScreenSU -- create the control and register events
Gui.<Form>.GsBreadCrumb1.Create(GsBreadCrumb)
Gui.<Form>.GsBreadCrumb1.Enabled(True)
Gui.<Form>.GsBreadCrumb1.Visible(True)
Gui.<Form>.GsBreadCrumb1.Size(992,22)
Gui.<Form>.GsBreadCrumb1.Position(15,77)
Gui.<Form>.GsBreadCrumb1.Event(PathChanged,GsBreadCrumb1_PathChanged)
Gui.<Form>.GsBreadCrumb1.Event(MouseClick,GsBreadCrumb1_MouseClick)
Gui.<Form>.GsBreadCrumb1.Event(GotFocus,GsBreadCrumb1_GotFocus)
Gui.<Form>.GsBreadCrumb1.Event(LostFocus,GsBreadCrumb1_LostFocus)

' Runtime -- set root node
Gui.<Form>.GsBreadCrumb1.MainBreadCrumb(sCaption, sKeyValue)

' Runtime -- add child nodes (3-parameter form: parent key, caption, key)
Gui.<Form>.GsBreadCrumb1.AddNode(sParentKeyValue, sCaption, sKeyValue)

' Runtime -- navigation
Gui.<Form>.GsBreadCrumb1.SelectNode(sKeyValue)
Gui.<Form>.GsBreadCrumb1.ClearChildNodes(sKeyValue)

' Runtime -- build full tree from combinations (shorthand)
Gui.<Form>.GsBreadCrumb1.PopulateBreadCrumbWithCombinations(sRootCaption, sRootKey, "Cap1", "Val1", "Cap2", "Val2", ...)

' Appearance
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!BackColor, V.Enum.GsBreadCrumbColor!BlanchedAlmond)
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!BorderStyle, V.Enum.GsBreadCrumbBorderStyles!Style3D)
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!ForeColor, V.Enum.GsBreadCrumbColor!Blue)
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!Font, "Segoe UI Semilight", 15.75, V.Enum.GsBreadCrumbFontStyle!Bold, V.Enum.GsBreadCrumbFontGraphicsUnit!Pixel, 0)
```

**Events:**

| Event | Fires when... |
|-------|--------------|
| PathChanged | User selects a different node, changing the breadcrumb path |
| MouseClick | User clicks anywhere on the control |
| GotFocus | Control receives focus |
| LostFocus | Control loses focus |

**V.Args -- PathChanged:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | "FORM" |
| `V.Args.Screen` | String | Form name |
| `V.Args.ControlName` | String | "GSBREADCRUMB1" |
| `V.Args.ControlType` | String | "GSBREADCRUMB" |
| `V.Args.GsBreadCrumbName` | String | Control name |
| `V.Args.SelectedNode` | String | Caption of the selected node |
| `V.Args.SelectedNodeValue` | String | Key value of the selected node |
| `V.Args.Path` | String | Full path from root (e.g., "Select:\Part Number") |
| `V.Args.EventType` | String | "PATHCHANGED" |

**V.Args -- MouseClick:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | "FORM" |
| `V.Args.Screen` | String | Form name |
| `V.Args.ControlName` | String | "GSBREADCRUMB1" |
| `V.Args.ControlType` | String | "GSBREADCRUMB" |
| `V.Args.GsBreadCrumbName` | String | Control name |
| `V.Args.Button` | String | "Left" or "Right" |
| `V.Args.Clicks` | Long | Click count (1 = single, 2 = double) |
| `V.Args.Location` | String | Formatted coordinates (e.g., "{X=73,Y=9}") |
| `V.Args.Delta` | Long | Mouse wheel delta |
| `V.Args.X` | Long | X coordinate of click |
| `V.Args.Y` | Long | Y coordinate of click |
| `V.Args.SelectedNode` | String | Caption of the selected node |
| `V.Args.SelectedNodeValue` | String | Key value of the selected node |
| `V.Args.Path` | String | Full path from root |
| `V.Args.EventType` | String | "MOUSECLICK" |

**V.Args -- GotFocus / LostFocus:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | "FORM" |
| `V.Args.Screen` | String | Form name |
| `V.Args.ControlName` | String | "GSBREADCRUMB1" |
| `V.Args.ControlType` | String | "GSBREADCRUMB" |
| `V.Args.GsBreadCrumbName` | String | Control name |
| `V.Args.SelectedNode` | String | Caption of the currently selected node |
| `V.Args.SelectedNodeValue` | String | Key value of the currently selected node |
| `V.Args.Path` | String | Full path from root |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

**Typical pattern -- build a hierarchical navigation tree:**
```
V.Local.sRoot.Declare(String, "Select:")

' Set root node
Gui.<Form>.GsBreadCrumb1.MainBreadCrumb(V.Local.sRoot, V.Local.sRoot)

' Add top-level choices under root
Gui.<Form>.GsBreadCrumb1.AddNode(V.Local.sRoot, "Part Number", "Part Number")
Gui.<Form>.GsBreadCrumb1.AddNode(V.Local.sRoot, "Customer Number", "Customer Number")
Gui.<Form>.GsBreadCrumb1.AddNode(V.Local.sRoot, "Salesperson Code", "Salesperson Code")

' Add sub-choices under "Part Number" (use unique key values to avoid collisions)
Gui.<Form>.GsBreadCrumb1.AddNode("Part Number", "Customer Number", "CustomerUnderPart")
Gui.<Form>.GsBreadCrumb1.AddNode("Part Number", "Salesperson Code", "SalespersonUnderPart")

' Style the control
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!BackColor, V.Enum.GsBreadCrumbColor!BlanchedAlmond)
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!BorderStyle, V.Enum.GsBreadCrumbBorderStyles!Style3D)
Gui.<Form>.GsBreadCrumb1.SetProperty(V.Enum.GsBreadCrumb!ForeColor, V.Enum.GsBreadCrumbColor!Blue)
```

### BarDock
A toolbar/ribbon dock control for buttons, dropdowns, and combo boxes.
```
Gui.<Form>.bardock1.Create(BarDock)

' Add dropdown menu
Gui.<Form>.bardock1.BarAddDropDown("Name","Name",V.Enum.Image!EXPORT_BLACK,"",False,V.Enum.BarItemLinkAlignment!Right)
Gui.<Form>.bardock1.BarAddDropDownItem("ItemName","ItemName","ParentDropDown",V.Enum.Image!EXPORT_COLOR,V.Enum.BarItemPaintStyle!CaptionGlyph)

' Add button
Gui.<Form>.bardock1.BarAddButton("Name","Name",V.Enum.Image!ENTER_BLACK,"",False,V.Enum.BarItemLinkAlignment!Right,V.Enum.BarItemPaintStyle!CaptionGlyph)

' Add combo box
Gui.<Form>.bardock1.BarAddComboBox("Name","Name",iWidth,"",False,False,V.Enum.BarItemLinkAlignment!Right)
Gui.<Form>.bardock1.BarAddComboBoxItem("ComboBoxName","ItemName","DisplayValue",iDataValue)
Gui.<Form>.bardock1.BarAddComboBoxItems("ComboBoxName","Dictionary","DictName")
Gui.<Form>.bardock1.BarAddComboBoxItems("ComboBoxName","DataTable","DTName","KeyCol","ValueCol")
Gui.<Form>.bardock1.BarAddComboBoxItems("ComboBoxName","DataView","DTName","DVName","KeyCol","ValueCol")

' Add text box
Gui.<Form>.bardock1.BarAddTextBox("Name","Caption",iWidth,"EmptyPrompt",False)

' Remove items
Gui.<Form>.bardock1.BarRemoveButton("Name")
Gui.<Form>.bardock1.BarRemoveTextBox("Name")
Gui.<Form>.bardock1.BarRemoveComboBox("Name")
Gui.<Form>.bardock1.BarRemoveComboBoxItem("ComboBoxName",iItemOrdinal)
```

#### BarDock Events
```
Gui.<Form>.bardock1.Event(ButtonClicked,Sub_bardock1_ButtonClicked)
Gui.<Form>.bardock1.Event(Click,Sub_bardock1_Click)
Gui.<Form>.bardock1.Event(ComboBoxEditValueChange,Sub_bardock1_ComboBoxEditValueChange)
Gui.<Form>.bardock1.Event(ComboBoxSelectedIndexChanged,Sub_bardock1_ComboBoxSelectedIndexChanged)
Gui.<Form>.bardock1.Event(DblClick,Sub_bardock1_DblClick)
Gui.<Form>.bardock1.Event(Drop,Sub_bardock1_Drop)
Gui.<Form>.bardock1.Event(MouseClick,Sub_bardock1_MouseClick)
Gui.<Form>.bardock1.Event(MouseDown,Sub_bardock1_MouseDown)
Gui.<Form>.bardock1.Event(MouseMove,Sub_bardock1_MouseMove)
Gui.<Form>.bardock1.Event(MouseUp,Sub_bardock1_MouseUp)
Gui.<Form>.bardock1.Event(TextBoxEditValueChanged,Sub_bardock1_TextBoxEditValueChanged)
```

| Event | Description |
|-------|-------------|
| `ButtonClicked` | Fired when a bar button is clicked |
| `Click` | General click on the BarDock area |
| `ComboBoxEditValueChange` | Fired when a combo box item's edit value changes |
| `ComboBoxSelectedIndexChanged` | Fired when the selected index of a combo box changes |
| `DblClick` | Double-click on the BarDock area |
| `Drop` | Fired on a drop action (drag-and-drop) |
| `MouseClick` | Mouse click on the BarDock |
| `MouseDown` | Mouse button pressed on the BarDock |
| `MouseMove` | Mouse moved over the BarDock |
| `MouseUp` | Mouse button released on the BarDock |
| `TextBoxEditValueChanged` | Fired when a text box item's value changes |

### GsTileViewControl
A tile/card layout control for visual data display with rich formatting.

**ScreenSU setup:**
```
Gui.<Form>.GsTileViewControl1.Create(GsTileViewControl)
Gui.<Form>.GsTileViewControl1.Enabled(True)
Gui.<Form>.GsTileViewControl1.Visible(True)
Gui.<Form>.GsTileViewControl1.Size(812,326)
Gui.<Form>.GsTileViewControl1.Position(14,71)
Gui.<Form>.GsTileViewControl1.Event(GotFocus,GsTileViewControl1_GotFocus)
Gui.<Form>.GsTileViewControl1.Event(LostFocus,GsTileViewControl1_LostFocus)
Gui.<Form>.GsTileViewControl1.Event(KeyDown,GsTileViewControl1_KeyDown)
Gui.<Form>.GsTileViewControl1.Event(KeyUp,GsTileViewControl1_KeyUp)
Gui.<Form>.GsTileViewControl1.Event(MouseDown,GsTileViewControl1_MouseDown)
Gui.<Form>.GsTileViewControl1.Event(MouseUp,GsTileViewControl1_MouseUp)
```

**Runtime methods -- data binding:**
```
Gui.<Form>.GsTileViewControl1.AddTileView("viewName")
Gui.<Form>.GsTileViewControl1.AddTileViewFromDataTable("viewName","dtName")
Gui.<Form>.GsTileViewControl1.AddTileViewFromDataView("dtName","dvName","viewName")
Gui.<Form>.GsTileViewControl1.DataSource("dtName")
Gui.<Form>.GsTileViewControl1.DataSource("dtName","dvName")
Gui.<Form>.GsTileViewControl1.MainView("viewName")
```

**Runtime methods -- serialize/deserialize:**
```
Gui.<Form>.GsTileViewControl1.Serialize("viewName",V.Local.sLayout)
Gui.<Form>.GsTileViewControl1.Deserialize(V.Local.sLayout)
```

**Runtime methods -- tile layout properties:**
```
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!OptionsTilesRowCount,3)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!OptionsTilesPadding,20)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!OptionsTilesItemPadding,0)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!OptionsTilesIndentBetweenItems,20)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!OptionsTilesItemSize,340,190)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!OptionsTilesOrientation,V.Enum.GsTileViewOptionsTilesOrientation!Vertical)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!AppearanceItemNormalBackColor,V.Enum.GsTileViewAppearanceColor!Green)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!AppearanceItemNormalForeColor,V.Enum.GsTileViewAppearanceColor!White)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("viewName",V.Enum.GsTileView!AppearanceItemNormalBorderColor,V.Enum.GsTileViewAppearanceColor!Transparent)
```

**Runtime methods -- column definitions (fractional widths):**
```
Gui.<Form>.GsTileViewControl1.AddTableColumnDefinition("viewName",0.4)
Gui.<Form>.GsTileViewControl1.AddTableColumnDefinition("viewName",0.6)
```

**Runtime methods -- tile item elements:**
```
Gui.<Form>.GsTileViewControl1.AddTileViewItemElement("viewName","elementName")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileViewItemElements!StretchVertical,True)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileViewItemElements!Width,3)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileViewItemElements!TextAlignment,V.Enum.GsTileViewItemElementsTextAlignment!MiddleRight)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileViewItemElements!MaxWidth,100)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileViewItemElements!ColumnIndex,1)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!Text,"LABEL")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!TextLocation,10,10)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!AnchorIndent,2)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!ImageSize,220,185)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!ImageAlignment,V.Enum.GsTileViewImageAlignment!MiddleRight)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!ImageScaleMode,V.Enum.GsTileViewImageScaleMode!Stretch)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!ImageLocation,10,0)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!AppearanceNormalFontSizeDelta,-1)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!AppearanceNormalFontStyleDelta,V.Enum.GsTileViewAppearanceNormalFontStyleDelta!Bold)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element",V.Enum.GsTileView!AppearanceNormalFont,"Segoe UI Semilight",25.75,V.Enum.GsTileViewAppearanceNormalFontStyle!Regular,V.Enum.GsTileViewAppearanceNormalFontGraphicsUnit!Point,0)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("viewName","element","TextVisible",False)

' Anchor elements to each other
Gui.<Form>.GsTileViewControl1.AnchorElement("viewName","childElement","parentElement")
```

#### GsTileViewControl Methods

##### Create

```
Gui.<Form>.GsTileViewControl.Create(GsTileViewControl)
```

Creates a new GsTileViewControl instance on the form. Called in ScreenSU.

**Example:**

```
Gui.<Form>.GsTileViewControl1.Create(GsTileViewControl)
```

##### AddTileView

```
Gui.<Form>.GsTileViewControl.AddTileView(TileViewName)
```

- `TileViewName` (String) -- name for the new tile view

Creates an empty named tile view within the control. Columns and rows can then be added manually via `AddColumn` and `AddRow`.

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
Gui.<Form>.GsTileViewControl1.AddTileView(V.Local.TileViewName)
```

##### AddTileViewFromDataTable

```
Gui.<Form>.GsTileViewControl.AddTileViewFromDataTable(TileViewName, DataTableName)
```

- `TileViewName` (String) -- name for the new tile view
- `DataTableName` (String) -- name of the DataTable whose structure and data populate the view

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.DataTableName.Declare(String,"DataTableName")
Gui.<Form>.GsTileViewControl1.AddTileViewFromDataTable(V.Local.TileViewName, V.Local.DataTableName)
```

##### AddTileViewFromDataView

```
Gui.<Form>.GsTileViewControl.AddTileViewFromDataView(DataTableName, DataViewName, TileViewName)
```

- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `TileViewName` (String) -- name for the new tile view

**Example:**

```
V.Local.DataTableName.Declare(String,"DataTableName")
V.Local.DataViewName.Declare(String,"DataViewName")
V.Local.TileViewName.Declare(String,"TileViewName")
Gui.<Form>.GsTileViewControl1.AddTileViewFromDataView(V.Local.DataTableName, V.Local.DataViewName, V.Local.TileViewName)
```

##### AddColumn

```
Gui.<Form>.GsTileViewControl.AddColumn(TileViewName, ColumnName, DataType, Visible)
```

- `TileViewName` (String) -- name of the tile view
- `ColumnName` (String) -- name for the new column
- `DataType` (String) -- data type: `"String"`, `"Long"`, `"Float"`, `"Date"`, `"Boolean"`
- `Visible` (Boolean) -- whether the column is visible in the tile display

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.ColumnName.Declare(String,"ColumnName1")
V.Local.DataType.Declare(String,"String")
V.Local.Visible.Declare(Boolean,True)
Gui.<Form>.GsTileViewControl1.AddColumn(V.Local.TileViewName, V.Local.ColumnName, V.Local.DataType, V.Local.Visible)
```

##### AddRow

```
Gui.<Form>.GsTileViewControl.AddRow(TileViewName, ColumnName0, ColumnValue0 [, ColumnNameN, ColumnValueN ...])
```

- `TileViewName` (String) -- name of the tile view
- `ColumnName0` (String) -- first column name
- `ColumnValue0` (Boolean, Date, Float, Long, or String) -- value for the first column
- `ColumnNameN, ColumnValueN` -- additional column name/value pairs (repeating)

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.ColumnName1.Declare(String,"ColumnName1")
V.Local.ColumnValue1.Declare(String,"Column value 1")
V.Local.ColumnName2.Declare(String,"ColumnName2")
V.Local.ColumnValue2.Declare(String,"Column value 2")
Gui.<Form>.GsTileViewControl1.AddRow(V.Local.TileViewName, V.Local.ColumnName1, V.Local.ColumnValue1, V.Local.ColumnName2, V.Local.ColumnValue2)
```

##### DataSource

```
Gui.<Form>.GsTileViewControl.DataSource(DataTableName)
Gui.<Form>.GsTileViewControl.DataSource(DataTableName, DataViewName)
```

- `DataTableName` (String) -- name of the DataTable
- `DataViewName` (String, optional) -- name of a DataView to bind. When omitted, the DataTable itself is used as the data source.

**Example:**

```
' Bind directly to a DataTable
Gui.<Form>.GsTileViewControl1.DataSource("partTable")

' Bind to a specific DataView
Gui.<Form>.GsTileViewControl1.DataSource("partTable","TileViewPart")
```

##### MainView

```
Gui.<Form>.GsTileViewControl.MainView(TileViewName)
```

- `TileViewName` (String) -- name of the tile view to set as the active/main view

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
Gui.<Form>.GsTileViewControl1.MainView(V.Local.TileViewName)
```

##### GetCellValueByColumnName

```
Gui.<Form>.GsTileViewControl.GetCellValueByColumnName(TileViewName, ColumnName, RowIndex, ReturnValue)
```

- `TileViewName` (String) -- name of the tile view
- `ColumnName` (String) -- column to read from
- `RowIndex` (Float) -- zero-based row index
- `ReturnValue` (Boolean, Date, Float, Long, or String) -- output; the cell value

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.ColumnName.Declare(String,"ColumnName")
V.Local.RowIndex.Declare(Float,0)
V.Local.ReturnValue.Declare(String)
Gui.<Form>.GsTileViewControl1.GetCellValueByColumnName(V.Local.TileViewName, V.Local.ColumnName, V.Local.RowIndex, V.Local.ReturnValue)
```

##### SetTileViewProperty

```
Gui.<Form>.GsTileViewControl.SetTileViewProperty(TileViewName, PropertyName, PropertyValue)
```

- `TileViewName` (String) -- name of the tile view
- `PropertyName` (Enum) -- a `V.Enum.GsTileView!OptionsTiles*` enum value identifying the property
- `PropertyValue` (Enum, Boolean, Date, Float, Long, or String) -- the value to set. For enum-valued properties, use the corresponding `V.Enum.GsTileViewOptionsTiles*!` value.

**Example:**

```
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart", V.Enum.GsTileView!OptionsTilesOrientation, V.Enum.GsTileViewOptionsTilesOrientation!Horizontal)
```

##### SetTileViewItemProperty

```
Gui.<Form>.GsTileViewControl.SetTileViewItemProperty(TileViewName, ColumnName, PropertyName, PropertyValue)
```

- `TileViewName` (String) -- name of the tile view
- `ColumnName` (String) -- name of the column/element
- `PropertyName` (Enum) -- a `V.Enum.GsTileViewItemElements` enum value identifying the item property
- `PropertyValue` (Boolean, Date, Float, Long, or String) -- the value to set

**Example:**

```
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Model", V.Enum.GsTileViewItemElements!Width, 10)
```

##### AddTileViewItemElement

```
Gui.<Form>.GsTileViewControl.AddTileViewItemElement(TileViewName, ElementName)
```

- `TileViewName` (String) -- name of the tile view
- `ElementName` (String) -- name for the new tile item element

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.ElementName.Declare(String,"ElementName")
Gui.<Form>.GsTileViewControl1.AddTileViewItemElement(V.Local.TileViewName, V.Local.ElementName)
```

##### AnchorElement

```
Gui.<Form>.GsTileViewControl.AnchorElement(TileViewName, ElementName, AnchorElementName)
```

- `TileViewName` (String) -- name of the tile view
- `ElementName` (String) -- name of the element to anchor
- `AnchorElementName` (String) -- name of the element to anchor to (the parent)

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.ElementName.Declare(String,"childElement")
V.Local.AnchorName.Declare(String,"parentElement")
Gui.<Form>.GsTileViewControl1.AnchorElement(V.Local.TileViewName, V.Local.ElementName, V.Local.AnchorName)
```

##### AddTableColumnDefinition

```
Gui.<Form>.GsTileViewControl.AddTableColumnDefinition(TileViewName, Length [, PaddingLeft] [, PaddingRight])
```

- `TileViewName` (String) -- name of the tile view
- `Length` (Long) -- column width (fractional values define proportional widths, e.g. `0.4` = 40%)
- `PaddingLeft` (Long, optional) -- left padding
- `PaddingRight` (Long, optional) -- right padding

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
Gui.<Form>.GsTileViewControl1.AddTableColumnDefinition(V.Local.TileViewName, 0.4)
Gui.<Form>.GsTileViewControl1.AddTableColumnDefinition(V.Local.TileViewName, 0.6)
```

##### Serialize

```
Gui.<Form>.GsTileViewControl.Serialize(TileViewName, ReturnValue)
```

- `TileViewName` (String) -- name of the tile view to serialize
- `ReturnValue` (String) -- output; the XML layout string

**Example:**

```
V.Local.TileViewName.Declare(String,"TileViewName")
V.Local.sLayout.Declare(String)
Gui.<Form>.GsTileViewControl1.Serialize(V.Local.TileViewName, V.Local.sLayout)
```

##### Deserialize

```
Gui.<Form>.GsTileViewControl.Deserialize(XMLTileViewLayout)
```

- `XMLTileViewLayout` (String) -- XML layout string previously obtained from `Serialize`

**Example:**

```
V.Local.sLayout.Declare(String)
Gui.<Form>.GsTileViewControl1.Deserialize(V.Local.sLayout)
```

##### Enable

```
Gui.<Form>.GsTileViewControl.Enable(Enabled)
```

- `Enabled` (Boolean) -- `True` to enable, `False` to disable

**Example:**

```
Gui.<Form>.GsTileViewControl1.Enable(True)
```

##### Visible

```
Gui.<Form>.GsTileViewControl.Visible(Visible)
```

- `Visible` (Boolean) -- `True` to show, `False` to hide

**Example:**

```
Gui.<Form>.GsTileViewControl1.Visible(False)
```

##### Size

```
Gui.<Form>.GsTileViewControl.Size(Width, Height)
```

- `Width` (Long) -- width in pixels
- `Height` (Long) -- height in pixels

**Example:**

```
Gui.<Form>.GsTileViewControl1.Size(812, 326)
```

##### Position

```
Gui.<Form>.GsTileViewControl.Position(X, Y)
```

- `X` (Float) -- horizontal position
- `Y` (Float) -- vertical position

**Example:**

```
Gui.<Form>.GsTileViewControl1.Position(50, 50)
```

##### Dock

```
Gui.<Form>.GsTileViewControl.Dock(Dock)
```

- `Dock` (Long) -- dock style value

**Example:**

```
Gui.<Form>.GsTileViewControl1.Dock(0)
```

##### Parent

```
Gui.<Form>.GsTileViewControl.Parent(ParentName)
```

- `ParentName` (String) -- name of the parent container control

**Example:**

```
V.Local.ParentName.Declare(String,"ParentName")
Gui.<Form>.GsTileViewControl1.Parent(V.Local.ParentName)
```

##### Margin

```
Gui.<Form>.GsTileViewControl.Margin(Left, Top, Right, Bottom)
```

- `Left` (Float) -- left margin
- `Top` (Float) -- top margin
- `Right` (Float) -- right margin
- `Bottom` (Float) -- bottom margin

**Example:**

```
Gui.<Form>.GsTileViewControl1.Margin(3, 3, 3, 3)
```

##### FlowBreak

```
Gui.<Form>.GsTileViewControl.FlowBreak(FlowBreak)
```

- `FlowBreak` (Boolean) -- when `True`, the next control in a FlowFrame wraps to a new line

Only applicable when the control is a child of a FlowFrame.

**Example:**

```
Gui.<Form>.GsTileViewControl1.FlowBreak(True)
```

#### GsTileViewControl Events V.Args

> ControlType: `"GSTILEVIEWCONTROL"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`) are present in every event and omitted from tables below. Note: `V.Args.EventType` is always the **last** arg in GsTileViewControl events.

**Mouse events** (MouseDown, MouseUp) -- 15 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Location` | String | Composite location string, e.g. `{X=145,Y=68}` |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.GsTileViewControlName` | String | Name of the tile view control instance |
| `V.Args.MouseRow` | Long | Row index under the mouse (0-based) |
| `V.Args.MouseCol` | Long | Column index under the mouse (-1 when not over a column) |
| `V.Args.EventType` | String | "MOUSEDOWN" or "MOUSEUP" |

**Key events** (KeyDown, KeyUp) -- 14 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.GsTileViewControlName` | String | Name of the tile view control instance |
| `V.Args.TileViewName` | String | Active tile view name (e.g. "DefaultTileView") |
| `V.Args.ColumnName` | String | Focused column name (empty if none) |
| `V.Args.ColumnIndex` | Long | Focused column index (-1 if none) |
| `V.Args.RowHandle` | Long | Row handle of the focused tile |
| `V.Args.RowIndex` | Long | Row index of the focused tile (0-based) |
| `V.Args.CellValue` | String | Value of the focused cell (empty if none) |
| `V.Args.KeyPress` | Long | Virtual key code (e.g. 49 for "1") |
| `V.Args.Character` | String | Key name (e.g. "ShiftKey", "ControlKey", "D1") |
| `V.Args.EventType` | String | "KEYDOWN" or "KEYUP" |

**GotFocus / LostFocus events** -- 6 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.View` | String | Active tile view name (e.g. "DefaultTileView") |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

**Event chain:** GotFocus -> (user clicks) -> MouseDown -> LostFocus -> MouseUp

> **Note:** GsTileViewControl uses `KeyDown`/`KeyUp` events (not `KeyPress`). The `CHARACTER` arg returns key names (e.g. "ShiftKey", "ControlKey") rather than printable characters. Mouse events include tile-specific context (`MouseRow`, `MouseCol`, `GsTileViewControlName`). Focus events include a `View` arg identifying the active tile view.

#### GsTileViewControl Complete Examples

##### Example 1 -- AddTileViewFromDataTable

Populate a tile view from a DataTable. Demonstrates AddColumn (adding a column after binding), AddRow, Serialize/Deserialize, SetTileViewProperty, SetTileViewItemProperty, and GetCellValueByColumnName.

```
Program.Sub.ScreenSU.Start
Gui.Form..Create(BaseForm)
Gui.Form..Caption("Form")
Gui.Form..Size(838,511)
Gui.Form..MinX(0)
Gui.Form..MinY(0)
Gui.Form..Position(0,0)
Gui.Form..AlwaysOnTop(False)
Gui.Form..FontName("Tahoma")
Gui.Form..FontSize(8.25)
Gui.Form..ControlBox(True)
Gui.Form..MaxButton(True)
Gui.Form..MinButton(True)
Gui.Form..MousePointer(0)
Gui.Form..Moveable(True)
Gui.Form..Sizeable(True)
Gui.Form..ShowInTaskBar(True)
Gui.Form..TitleBar(True)
Gui.Form..Event(UnLoad,Form_UnLoad)
Gui.Form.lbl_GsTileView.Create(Label,"GsTileView with DataTable",True,314,33,0,241,27,True,0,"Tahoma",16,,0,0)
Gui.Form.lbl_GsTileView.BorderStyle(0)
Gui.Form.lbl_Event.Create(Label,"Event:",True,48,21,0,28,419,True,0,"Tahoma",10,,0,0)
Gui.Form.lbl_Event.BorderStyle(0)
Gui.Form.txt_EventInfo.Create(TextBox,"",True,732,22,0,79,420,True,0,"Tahoma",7.8,,1)
Gui.<Form>.GsTileViewControl1.Create(GsTileViewControl)
Gui.<Form>.GsTileViewControl1.Enabled(True)
Gui.<Form>.GsTileViewControl1.Visible(True)
Gui.<Form>.GsTileViewControl1.Size(812,326)
Gui.<Form>.GsTileViewControl1.Position(14,71)
Gui.<Form>.GsTileViewControl1.Event(GotFocus,GsTileViewControl1_GotFocus)
Gui.<Form>.GsTileViewControl1.Event(LostFocus,GsTileViewControl1_LostFocus)
Gui.<Form>.GsTileViewControl1.Event(KeyDown,GsTileViewControl1_KeyDown)
Gui.<Form>.GsTileViewControl1.Event(KeyUp,GsTileViewControl1_KeyUp)
Gui.<Form>.GsTileViewControl1.Event(MouseDown,GsTileViewControl1_MouseDown)
Gui.<Form>.GsTileViewControl1.Event(MouseUp,GsTileViewControl1_MouseUp)
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels

F.Data.DataTable.Create("partTable",True)
F.Data.DataTable.AddColumn("partTable","Trademark","String")
F.Data.DataTable.AddColumn("partTable","Model","String")
F.Data.DataTable.AddColumn("partTable","Category","String")
F.Data.DataTable.AddColumn("partTable","Price","String")

F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz1","Model","sl 500 Road1","Category","SPORTS1","Price","$81,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz2","Model","sl 500 Road2","Category","SPORTS2","Price","$82,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz3","Model","sl 500 Road3","Category","SPORTS3","Price","$83,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz4","Model","sl 500 Road4","Category","SPORTS4","Price","$84,800.00")

Gui.<Form>.GsTileViewControl1.AddTileViewFromDataTable("TileViewPart","partTable")
Gui.<Form>.GsTileViewControl1.MainView("TileViewPart")

Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","NewColumnName2","String",True)
Gui.<Form>.GsTileViewControl1.AddRow("TileViewPart","Trademark","New Trademark Value","Model","New Model Value","Category","New Category Value","Price","New Price Value","NewColumnName2","New NewColumnName2 Value")

V.Local.Serialize.Declare(String)
Gui.<Form>.GsTileViewControl1.Serialize("TileViewPart",V.Local.Serialize)
Gui.<Form>.GsTileViewControl1.Deserialize(V.Local.Serialize)

Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesOrientation,V.Enum.GsTileViewOptionsTilesOrientation!Horizontal)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Model",V.Enum.GsTileViewItemElements!Width,10)

V.Local.ModelValue.Declare(String)
Gui.<Form>.GsTileViewControl1.GetCellValueByColumnName("TileViewPart","Model",0,V.Local.ModelValue)

Gui.Form..Show
Program.Sub.Main.End

Program.Sub.Form_UnLoad.Start
F.Intrinsic.Control.End
Program.Sub.Form_UnLoad.End

Program.Sub.GsTileViewControl1_GotFocus.Start
Gui.Form.txt_EventInfo.Text("GotFocus")
Program.Sub.GsTileViewControl1_GotFocus.End

Program.Sub.GsTileViewControl1_LostFocus.Start
Gui.Form.txt_EventInfo.Text("LostFocus")
Program.Sub.GsTileViewControl1_LostFocus.End

Program.Sub.GsTileViewControl1_KeyDown.Start
Gui.Form.txt_EventInfo.Text("KeyDown")
Program.Sub.GsTileViewControl1_KeyDown.End

Program.Sub.GsTileViewControl1_KeyUp.Start
Gui.Form.txt_EventInfo.Text("KeyUp")
Program.Sub.GsTileViewControl1_KeyUp.End

Program.Sub.GsTileViewControl1_MouseDown.Start
V.Local.MouseDown.Declare(String)
F.Intrinsic.String.Concat("MouseDown: BUTTON[",V.Args.Button,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", CLICKS[",V.Args.Clicks,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", SHIFT[",V.Args.Shift,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", LOCATION[",V.Args.Location,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", DELTA[",V.Args.Delta,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", X[",V.Args.X,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", Y[",V.Args.Y,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", GSTILEVIEWCONTROLNAME[",V.Args.GsTileViewControlName,"]",V.Local.MouseDown)
Gui.Form.txt_EventInfo.Text(V.Local.MouseDown)
Program.Sub.GsTileViewControl1_MouseDown.End

Program.Sub.GsTileViewControl1_MouseUp.Start
Gui.Form.txt_EventInfo.Text("MouseUp")
Program.Sub.GsTileViewControl1_MouseUp.End
```

##### Example 2 -- AddTileViewFromDataView

Populate a tile view from a filtered/sorted DataView.

```
Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels

F.Data.DataTable.Create("partTable",True)
F.Data.DataTable.AddColumn("partTable","Trademark","String")
F.Data.DataTable.AddColumn("partTable","Model","String")
F.Data.DataTable.AddColumn("partTable","Category","String")
F.Data.DataTable.AddColumn("partTable","Price","String")

F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz1","Model","sl 500 Road1","Category","SPORTS1","Price","$81,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz2","Model","sl 500 Road2","Category","SPORTS2","Price","$82,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz3","Model","sl 500 Road3","Category","SPORTS3","Price","$83,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz4","Model","sl 500 Road4","Category","SPORTS4","Price","$84,800.00")

F.Data.DataView.Create("partTable","DataViewName",22,"Model >= '0'","Model DESC")
Gui.<Form>.GsTileViewControl1.AddTileViewFromDataView("partTable","DataViewName","TileViewPart")
Gui.<Form>.GsTileViewControl1.MainView("TileViewPart")

Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","NewColumnName2","String",True)
Gui.<Form>.GsTileViewControl1.AddRow("TileViewPart","Trademark","New Trademark Value","Model","New Model Value","Category","New Category Value","Price","New Price Value","NewColumnName2","New NewColumnName2 Value")

V.Local.Serialize.Declare(String)
Gui.<Form>.GsTileViewControl1.Serialize("TileViewPart",V.Local.Serialize)
Gui.<Form>.GsTileViewControl1.Deserialize(V.Local.Serialize)

Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesOrientation,V.Enum.GsTileViewOptionsTilesOrientation!Horizontal)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Model",V.Enum.GsTileViewItemElements!Width,10)

V.Local.ModelValue.Declare(String)
Gui.<Form>.GsTileViewControl1.GetCellValueByColumnName("TileViewPart","Model",0,V.Local.ModelValue)

Gui.Form..Show
Program.Sub.Main.End
```

##### Example 3 -- AddTileView (Manual)

Build a tile view entirely in code without a DataTable source. Columns and rows are added manually.

```
Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels

Gui.<Form>.GsTileViewControl1.AddTileView("TileViewPart")
Gui.<Form>.GsTileViewControl1.MainView("TileViewPart")

Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","Trademark","String",True)
Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","Model","String",True)
Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","Category","String",True)
Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","Price","String",True)
Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","NewColumnName2","String",True)

Gui.<Form>.GsTileViewControl1.AddRow("TileViewPart","Trademark","New Trademark Value","Model","New Model Value","Category","New Category Value","Price","New Price Value","NewColumnName2","New NewColumnName2 Value")

V.Local.Serialize.Declare(String)
Gui.<Form>.GsTileViewControl1.Serialize("TileViewPart",V.Local.Serialize)
Gui.<Form>.GsTileViewControl1.Deserialize(V.Local.Serialize)

Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesOrientation,V.Enum.GsTileViewOptionsTilesOrientation!Horizontal)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Model",V.Enum.GsTileViewItemElements!Width,10)

V.Local.ModelValue.Declare(String)
Gui.<Form>.GsTileViewControl1.GetCellValueByColumnName("TileViewPart","Model",0,V.Local.ModelValue)

Gui.Form..Show
Program.Sub.Main.End
```

##### Example 4 -- DataSource Binding

Bind a DataView as a data source instead of using AddTileViewFromDataTable/DataView.

```
Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels

F.Data.DataTable.Create("partTable",True)
F.Data.DataTable.AddColumn("partTable","Trademark","String")
F.Data.DataTable.AddColumn("partTable","Model","String")
F.Data.DataTable.AddColumn("partTable","Category","String")
F.Data.DataTable.AddColumn("partTable","Price","String")

F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz1","Model","sl 500 Road1","Category","SPORTS1","Price","$81,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz2","Model","sl 500 Road2","Category","SPORTS2","Price","$82,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz3","Model","sl 500 Road3","Category","SPORTS3","Price","$83,800.00")
F.Data.DataTable.AddRow("partTable","Trademark","Mercedes-Benz4","Model","sl 500 Road4","Category","SPORTS4","Price","$84,800.00")

F.Data.DataView.Create("partTable","TileViewPart",22,"Model >= '0'","Model DESC")

Gui.<Form>.GsTileViewControl1.DataSource("partTable","TileViewPart")
Gui.<Form>.GsTileViewControl1.MainView("TileViewPart")

Gui.<Form>.GsTileViewControl1.AddColumn("TileViewPart","NewColumnName2","String",True)
Gui.<Form>.GsTileViewControl1.AddRow("TileViewPart","Trademark","New Trademark Value","Model","New Model Value","Category","New Category Value","Price","New Price Value","NewColumnName2","New NewColumnName2 Value")

V.Local.Serialize.Declare(String)
Gui.<Form>.GsTileViewControl1.Serialize("TileViewPart",V.Local.Serialize)
Gui.<Form>.GsTileViewControl1.Deserialize(V.Local.Serialize)

Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesOrientation,V.Enum.GsTileViewOptionsTilesOrientation!Horizontal)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Model",V.Enum.GsTileViewItemElements!Width,10)

V.Local.ModelValue.Declare(String)
Gui.<Form>.GsTileViewControl1.GetCellValueByColumnName("TileViewPart","Model",0,V.Local.ModelValue)

Gui.Form..Show
Program.Sub.Main.End
```

##### Example 5 -- Rich Layout with Images

Full example demonstrating tile layout properties, column definitions, item elements, anchoring, font styling, image configuration, and BYTEARRAY image columns.

```
Program.Sub.ScreenSU.Start
Gui.Form..Create(BaseForm)
Gui.Form..Caption("Form")
Gui.Form..Size(838,511)
Gui.Form..MinX(0)
Gui.Form..MinY(0)
Gui.Form..Position(0,0)
Gui.Form..AlwaysOnTop(False)
Gui.Form..FontName("Tahoma")
Gui.Form..FontSize(8.25)
Gui.Form..ControlBox(True)
Gui.Form..MaxButton(True)
Gui.Form..MinButton(True)
Gui.Form..MousePointer(0)
Gui.Form..Moveable(True)
Gui.Form..Sizeable(True)
Gui.Form..ShowInTaskBar(True)
Gui.Form..TitleBar(True)
Gui.Form..Event(UnLoad,Form_UnLoad)
Gui.Form.lbl_GsTileView.Create(Label,"GsTileView with DataTable",True,314,33,0,241,27,True,0,"Tahoma",16,,0,0)
Gui.Form.lbl_GsTileView.BorderStyle(0)
Gui.Form.lbl_Event.Create(Label,"Event:",True,48,21,0,28,419,True,0,"Tahoma",10,,0,0)
Gui.Form.lbl_Event.BorderStyle(0)
Gui.Form.txt_EventInfo.Create(TextBox,"",True,732,22,0,79,420,True,0,"Tahoma",7.8,,1)
Gui.<Form>.GsTileViewControl1.Create(GsTileViewControl)
Gui.<Form>.GsTileViewControl1.Enabled(True)
Gui.<Form>.GsTileViewControl1.Visible(True)
Gui.<Form>.GsTileViewControl1.Size(812,326)
Gui.<Form>.GsTileViewControl1.Position(14,71)
Gui.<Form>.GsTileViewControl1.Event(GotFocus,GsTileViewControl1_GotFocus)
Gui.<Form>.GsTileViewControl1.Event(LostFocus,GsTileViewControl1_LostFocus)
Gui.<Form>.GsTileViewControl1.Event(KeyDown,GsTileViewControl1_KeyDown)
Gui.<Form>.GsTileViewControl1.Event(KeyUp,GsTileViewControl1_KeyUp)
Gui.<Form>.GsTileViewControl1.Event(MouseDown,GsTileViewControl1_MouseDown)
Gui.<Form>.GsTileViewControl1.Event(MouseUp,GsTileViewControl1_MouseUp)
Program.Sub.ScreenSU.End

Program.Sub.Preflight.Start
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels

F.Data.DataTable.Create("partTable",True)
F.Data.DataTable.AddColumn("partTable","Image","BYTEARRAY")
F.Data.DataTable.AddColumn("partTable","Address","String")
F.Data.DataTable.AddColumn("partTable","YearBuilt","String")
F.Data.DataTable.AddColumn("partTable","Price","Float")
F.Data.DataTable.AddColumn("partTable","Status","String")

V.Local.fileName.Declare(String,"C:\Sample\Gss_logo.png")
F.Image.File.Load("imageObject",V.Local.fileName)
V.Local.toByteArrayResult.Declare(BYTEARRAY)
F.Image.File.ToByteArray(V.Local.fileName,V.Local.toByteArrayResult)

F.Data.DataTable.AddRow("partTable","Address","652 Avonwick Gate, Toronto, ON M3A25","YearBuilt",2008,"Price",10000,"Status",1,"Image",V.Local.toByteArrayResult)
F.Data.DataTable.AddRow("partTable","Address","328 S Kerema Ave, Milford, CT 06465","YearBuilt",2010,"Price",20000,"Status",0,"Image",V.Local.toByteArrayResult)
F.Data.DataTable.AddRow("partTable","Address","82649 Topeka St, Riverbank, CA 95360","YearBuilt",2009,"Price",30000,"Status",0,"Image",V.Local.toByteArrayResult)
F.Data.DataTable.AddRow("partTable","Address","5119 Beryl Dr, San Antonio, TX 78212","YearBuilt",2007,"Price",40000,"Status",1,"Image",V.Local.toByteArrayResult)

Gui.<Form>.GsTileViewControl1.AddTileViewFromDataTable("TileViewPart","partTable")
Gui.<Form>.GsTileViewControl1.MainView("TileViewPart")

' Tile layout properties
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesRowCount,3)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesPadding,20)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesItemPadding,0)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesIndentBetweenItems,20)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesItemSize,340,190)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!AppearanceItemNormalForeColor,V.Enum.GsTileViewAppearanceColor!White)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!AppearanceItemNormalBorderColor,V.Enum.GsTileViewAppearanceColor!Transparent)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!AppearanceItemNormalBackColor,V.Enum.GsTileViewAppearanceColor!Green)
Gui.<Form>.GsTileViewControl1.SetTileViewProperty("TileViewPart",V.Enum.GsTileView!OptionsTilesOrientation,V.Enum.GsTileViewOptionsTilesOrientation!Vertical)

' Column definitions (proportional widths)
Gui.<Form>.GsTileViewControl1.AddTableColumnDefinition("TileViewPart",0.4)
Gui.<Form>.GsTileViewControl1.AddTableColumnDefinition("TileViewPart",0.6)

' Split line element (decorative vertical divider)
Gui.<Form>.GsTileViewControl1.AddTileViewItemElement("TileViewPart","splitLine")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","splitLine",V.Enum.GsTileViewItemElements!StretchVertical,True)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","splitLine",V.Enum.GsTileViewItemElements!Width,3)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","splitLine",V.Enum.GsTileViewItemElements!TextAlignment,V.Enum.GsTileViewItemElementsTextAlignment!MiddleRight)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","splitLine",V.Enum.GsTileView!AppearanceNormalBackColor,V.Enum.GsTileViewAppearanceColor!Red)

' Address caption element
Gui.<Form>.GsTileViewControl1.AddTileViewItemElement("TileViewPart","AddressCaption")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","AddressCaption",V.Enum.GsTileView!Text,"ADDRESS")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","AddressCaption",V.Enum.GsTileViewItemElements!TextAlignment,V.Enum.GsTileViewItemElementsTextAlignment!TopLeft)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","AddressCaption",V.Enum.GsTileView!TextLocation,10,10)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","AddressCaption",V.Enum.GsTileView!AppearanceNormalFontSizeDelta,-1)

' Address value -- anchored below AddressCaption
Gui.<Form>.GsTileViewControl1.AnchorElement("TileViewPart","Address","AddressCaption")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Address",V.Enum.GsTileView!AnchorIndent,2)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Address",V.Enum.GsTileViewItemElements!MaxWidth,100)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Address",V.Enum.GsTileView!AppearanceNormalFontStyleDelta,V.Enum.GsTileViewAppearanceNormalFontStyleDelta!Bold)

' Year caption element
Gui.<Form>.GsTileViewControl1.AddTileViewItemElement("TileViewPart","YearCaption")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","YearCaption",V.Enum.GsTileView!Text,"Year Built")
Gui.<Form>.GsTileViewControl1.AnchorElement("TileViewPart","YearCaption","Address")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","YearCaption",V.Enum.GsTileView!AnchorIndent,14)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","YearCaption",V.Enum.GsTileView!AppearanceNormalFontSizeDelta,-1)

' Year value -- anchored below YearCaption
Gui.<Form>.GsTileViewControl1.AnchorElement("TileViewPart","YearBuilt","YearCaption")
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","YearBuilt",V.Enum.GsTileView!AnchorIndent,2)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","YearBuilt",V.Enum.GsTileView!AppearanceNormalFontStyleDelta,V.Enum.GsTileViewAppearanceNormalFontStyleDelta!Bold)

' Price value -- positioned at bottom-left with custom font
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Price",V.Enum.GsTileViewItemElements!TextAlignment,V.Enum.GsTileViewItemElementsTextAlignment!BottomLeft)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Price",V.Enum.GsTileView!AnchorIndent,2)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Price",V.Enum.GsTileView!TextLocation,10,-10)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Price",V.Enum.GsTileView!AppearanceNormalFontStyleDelta,V.Enum.GsTileViewAppearanceNormalFontStyleDelta!Bold)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Price",V.Enum.GsTileView!AppearanceNormalFont,"Segoe UI Semilight",25.75,V.Enum.GsTileViewAppearanceNormalFontStyle!Regular,V.Enum.GsTileViewAppearanceNormalFontGraphicsUnit!Point,0)

' Hide Status text
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Status","TextVisible",False)

' Image column -- placed in second table column with stretch scaling
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Image",V.Enum.GsTileViewItemElements!ColumnIndex,1)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Image",V.Enum.GsTileView!ImageSize,220,185)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Image",V.Enum.GsTileView!ImageAlignment,V.Enum.GsTileViewImageAlignment!MiddleRight)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Image",V.Enum.GsTileView!ImageScaleMode,V.Enum.GsTileViewImageScaleMode!Stretch)
Gui.<Form>.GsTileViewControl1.SetTileViewItemProperty("TileViewPart","Image",V.Enum.GsTileView!ImageLocation,10,0)

Gui.Form..Show
Program.Sub.Main.End

Program.Sub.Form_UnLoad.Start
F.Intrinsic.Control.End
Program.Sub.Form_UnLoad.End

Program.Sub.GsTileViewControl1_GotFocus.Start
Gui.Form.txt_EventInfo.Text("GotFocus")
Program.Sub.GsTileViewControl1_GotFocus.End

Program.Sub.GsTileViewControl1_LostFocus.Start
Gui.Form.txt_EventInfo.Text("LostFocus")
Program.Sub.GsTileViewControl1_LostFocus.End

Program.Sub.GsTileViewControl1_KeyDown.Start
Gui.Form.txt_EventInfo.Text("KeyDown")
Program.Sub.GsTileViewControl1_KeyDown.End

Program.Sub.GsTileViewControl1_KeyUp.Start
Gui.Form.txt_EventInfo.Text("KeyUp")
Program.Sub.GsTileViewControl1_KeyUp.End

Program.Sub.GsTileViewControl1_MouseDown.Start
V.Local.MouseDown.Declare(String)
F.Intrinsic.String.Concat("MouseDown: BUTTON[",V.Args.Button,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", CLICKS[",V.Args.Clicks,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", SHIFT[",V.Args.Shift,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", LOCATION[",V.Args.Location,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", DELTA[",V.Args.Delta,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", X[",V.Args.X,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", Y[",V.Args.Y,"]",V.Local.MouseDown)
F.Intrinsic.String.Concat(V.Local.MouseDown,", GSTILEVIEWCONTROLNAME[",V.Args.GsTileViewControlName,"]",V.Local.MouseDown)
Gui.Form.txt_EventInfo.Text(V.Local.MouseDown)
Program.Sub.GsTileViewControl1_MouseDown.End

Program.Sub.GsTileViewControl1_MouseUp.Start
Gui.Form.txt_EventInfo.Text("MouseUp")
Program.Sub.GsTileViewControl1_MouseUp.End
```

