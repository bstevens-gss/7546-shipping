# GAB GUI Advanced Controls Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with GsCardView, GsAdvBandedGridControl, GsWebView2, and related event tables
# Last verified: 2026-05-24 | Product version: unverified | Agent kit audit pass
---
### GsCardView
A card-based data view control for record browsing.
```
Gui.<Form>.GsCardView1.Create(GsCardView)
Gui.<Form>.GsCardView1.Enabled(True)
Gui.<Form>.GsCardView1.Visible(True)
Gui.<Form>.GsCardView1.Size(1028,510)
Gui.<Form>.GsCardView1.Position(16,99)
Gui.<Form>.GsCardView1.Event(Click,GsCardView1_Click)
Gui.<Form>.GsCardView1.Event(GotFocus,GsCardView1_GotFocus)
Gui.<Form>.GsCardView1.Event(LostFocus,GsCardView1_LostFocus)
Gui.<Form>.GsCardView1.Event(MouseDown,GsCardView1_MouseDown)
Gui.<Form>.GsCardView1.Event(MouseMove,GsCardView1_MouseMove)
Gui.<Form>.GsCardView1.Event(MouseUp,GsCardView1_MouseUp)

' Bind data
Gui.<Form>.GsCardView1.AddDataTable("dtName")
Gui.<Form>.GsCardView1.SetDataSource("dtName")

' Serialize/Deserialize
Gui.<Form>.GsCardView1.Serialize(V.Local.sLayout)
Gui.<Form>.GsCardView1.Deserialize(V.Local.sLayout)

' Properties (individual)
Gui.<Form>.GsCardView1.SetProperty(V.Enum.GsCardView!BorderStyle,V.Enum.GsCardViewBorderStyle!Simple)
Gui.<Form>.GsCardView1.SetProperty(V.Enum.GsCardView!ShowButtonMode,V.Enum.GsCardViewShowButtonMode!ShowOnlyInEditor)
Gui.<Form>.GsCardView1.SetProperty(V.Enum.GsCardView!OptionsBehaviorFieldAutoHeight,True)

' Properties (batch via Data Object)
F.Data.Object.Create("cardProps")
F.Data.Object.AddProperty("cardProps",V.Enum.GsCardView!CardWidth,800)
F.Data.Object.AddProperty("cardProps",V.Enum.GsCardView!OptionsSelectionMultiSelect,True)
F.Data.Object.AddProperty("cardProps",V.Enum.GsCardView!OptionsViewShowFieldCaptions,False)
F.Data.Object.AddProperty("cardProps","CardCaptionFormat","{0} {YearBuilt}")    ' Format string for card titles
F.Data.Object.AddProperty("cardProps","ActiveFilterString","[Col] >= 5")         ' Filter expression
Gui.<Form>.GsCardView1.SetProperty("cardProps")

' Layout constraints
Gui.<Form>.GsCardView1.MaximumCardColumns(2)              ' Max columns of cards; Long
Gui.<Form>.GsCardView1.MaximumCardRows(2)                 ' Max rows of cards; Long
Gui.<Form>.GsCardView1.OptionsView.ShowFilterPanelMode(2) ' Filter panel visibility; Long (0=Never, 1=Default, 2=ShowAlways)
```

#### GsCardView Events V.Args

> ControlType for all events: `"GSCARDVIEW"`
>
> **CRITICAL:** `V.Args.GsCardViewControlName` and `V.Args.ControlName` return the control name in **ALL UPPERCASE** (e.g., `GSCARDTODO` not `gsCardToDo`). When comparing against your control names in a shared Click handler, always normalize with `F.Intrinsic.String.UCase(V.Local.sCtrl,V.Local.sCtrl)` first, or compare against uppercase literals.

**Click event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "GSCARDVIEW1") |
| `V.Args.ControlType` | String | "GSCARDVIEW" |
| `V.Args.GsCardViewControlName` | String | Name of the card view control (e.g. "GSCARDVIEW1") |
| `V.Args.RowIndex` | Long | Index of the clicked row |
| `V.Args.EventType` | String | "CLICK" |

**Focus events** (GotFocus, LostFocus) -- 6 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "GSCARDVIEW1") |
| `V.Args.ControlType` | String | "GSCARDVIEW" |
| `V.Args.View` | String | Name of the view (e.g. "GSCARDVIEW1") |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

**Mouse events** (MouseDown, MouseMove, MouseUp) -- 14 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "GSCARDVIEW1") |
| `V.Args.ControlType` | String | "GSCARDVIEW" |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Location` | String | Mouse location as point string (e.g. "\{X=109,Y=86\}") |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.GsCardViewControlName` | String | Name of the card view control (e.g. "GSCARDVIEW1") |
| `V.Args.RowIndex` | Long | Index of the row under the mouse |
| `V.Args.EventType` | String | "MOUSEDOWN", "MOUSEMOVE", or "MOUSEUP" |

**Event call chain:** When clicking a card, the event sequence is:
`FORM MouseDown` -> `GsCardView1_MouseDown` -> `GsCardView1_LostFocus` -> `GsCardView1_MouseUp` -> `GsCardView1_GotFocus` -> `GsCardView1_MouseMove` (repeats on move) -> `GsCardView1_Click`

### GsAdvBandedGridControl
A DevExpress banded grid that groups columns under hierarchical band headers. Supports nested parent/child bands for organized column layouts.

> **Note:** `GsAdvBandedGridControl` event `V.Args` tables have **different arg counts** from `GsGridControl` events (documented in `GUI_EVENTS.md`). Do not mix arg tables between the two control types -- always use the V.Args table for the specific control type you are working with.
```
Gui.<Form>.GsAdvBandedGridControl1.Create(GsAdvBandedGridControl)
Gui.<Form>.GsAdvBandedGridControl1.Enabled(True)
Gui.<Form>.GsAdvBandedGridControl1.Visible(True)
Gui.<Form>.GsAdvBandedGridControl1.Size(470,321)
Gui.<Form>.GsAdvBandedGridControl1.Position(25,30)
Gui.<Form>.GsAdvBandedGridControl1.Event(CellValueChanged,GsAdvBandedGridControl1_CellValueChanged)
Gui.<Form>.GsAdvBandedGridControl1.Event(ColumnFilterChanged,GsAdvBandedGridControl1_ColumnFilterChanged)
Gui.<Form>.GsAdvBandedGridControl1.Event(ColumnPositionChanged,GsAdvBandedGridControl1_ColumnPositionChanged)
Gui.<Form>.GsAdvBandedGridControl1.Event(FocusedRowChanged,GsAdvBandedGridControl1_FocusedRowChanged)
Gui.<Form>.GsAdvBandedGridControl1.Event(GotFocus,GsAdvBandedGridControl1_GotFocus)
Gui.<Form>.GsAdvBandedGridControl1.Event(KeyPress,GsAdvBandedGridControl1_KeyPress)
Gui.<Form>.GsAdvBandedGridControl1.Event(KeyPressEnter,GsAdvBandedGridControl1_KeyPressEnter)
Gui.<Form>.GsAdvBandedGridControl1.Event(LostFocus,GsAdvBandedGridControl1_LostFocus)
Gui.<Form>.GsAdvBandedGridControl1.Event(MouseCellEnter,GsAdvBandedGridControl1_MouseCellEnter)
Gui.<Form>.GsAdvBandedGridControl1.Event(MouseCellExit,GsAdvBandedGridControl1_MouseCellExit)
Gui.<Form>.GsAdvBandedGridControl1.Event(MouseDown,GsAdvBandedGridControl1_MouseDown)
Gui.<Form>.GsAdvBandedGridControl1.Event(MouseMove,GsAdvBandedGridControl1_MouseMove)
Gui.<Form>.GsAdvBandedGridControl1.Event(MouseUp,GsAdvBandedGridControl1_MouseUp)
Gui.<Form>.GsAdvBandedGridControl1.Event(RowCellClick,GsAdvBandedGridControl1_RowCellClick)
Gui.<Form>.GsAdvBandedGridControl1.Event(RowClick,GsAdvBandedGridControl1_RowClick)

' Bind data
Gui.<Form>.GsAdvBandedGridControl1.AddGridViewFromDataTable("gvName","dtName")
Gui.<Form>.GsAdvBandedGridControl1.MainView("gvName")

' Band management (hierarchical column grouping)
Gui.<Form>.GsAdvBandedGridControl1.AddGridBand("bandMain","Main")
Gui.<Form>.GsAdvBandedGridControl1.AddGridBand("bandDetail","Detail Info")
Gui.<Form>.GsAdvBandedGridControl1.AddChildGridBand("bandMain","bandDetail")     ' Nest child under parent

' Assign columns to bands
' AddBandedColumnToOwnerBand(FieldName, Caption, bVisible, OwnerBandName, iRowIndex, bAutoFillDown, bReadOnly)
Gui.<Form>.GsAdvBandedGridControl1.AddBandedColumnToOwnerBand("HP","HP",True,"bandPerformance",0,False,False)
Gui.<Form>.GsAdvBandedGridControl1.AddBandedColumnToOwnerBand("Desc","Description",True,"bandNotes",0,True,False)

' Assign columns to child bands
' AddBandedChildColumnToOwnerBand(FieldName, Caption, bVisible, ParentBandName, ChildBandName, iRowIndex, bAutoFillDown, bReadOnly)
Gui.<Form>.GsAdvBandedGridControl1.AddBandedChildColumnToOwnerBand("Model","Model",True,"bandMain","bandModel",0,False,False)
Gui.<Form>.GsAdvBandedGridControl1.AddBandedChildColumnToOwnerBand("Price","Price",True,"bandMain","bandPrice",0,True,False)

' Column editor (in-place editing)
Gui.<Form>.GsAdvBandedGridControl1.BandedChildColumnEdit("ColName","dropdownlist","item1*!*item2*!*item3")

' Serialize/Deserialize (file-path based, not string)
Gui.<Form>.GsAdvBandedGridControl1.Serialize(sXmlFilePath)
Gui.<Form>.GsAdvBandedGridControl1.Deserialize(sXmlFilePath)

' Get cell value
Gui.<Form>.GsAdvBandedGridControl1.GetCellValueByColumnName("gvName","ColName",iRow,sResult)

' Gridview properties (use dedicated enum namespaces)
Gui.<Form>.GsAdvBandedGridControl1.SetGridviewProperty(V.Enum.GsAdvBandedGridViewPropertyNames!Editable,True)
Gui.<Form>.GsAdvBandedGridControl1.SetGridviewProperty(V.Enum.GsAdvBandedGridViewPropertyNames!EditingMode,V.Enum.GridEditingMode!Inplace)
```

#### GsAdvBandedGridControl Events V.Args

> ControlType for all events: `"GSADVBANDEDGRIDCONTROL"`

**MouseDown / MouseMove / MouseUp events** -- 15 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Location` | String | Coordinate pair (e.g. "{X=174,Y=137}") |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.MouseRow` | Long | Row index under mouse |
| `V.Args.MouseCol` | Long | Column index under mouse (-1 if none) |
| `V.Args.EventType` | String | "MOUSEDOWN", "MOUSEMOVE", or "MOUSEUP" |

**RowCellClick event** -- 17 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.Button` | String | Mouse button |
| `V.Args.CellValue` | String | Value of the clicked cell |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Column` | String | Column name |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.Handled` | Boolean | Whether the event is handled |
| `V.Args.Location` | String | Coordinate pair |
| `V.Args.RowHandle` | Long | Row handle |
| `V.Args.RowIndex` | Long | Row index |
| `V.Args.IsGroupRow` | Boolean | Whether clicked row is a group row |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.EventType` | String | "ROWCELLCLICK" |

**RowClick event** -- 15 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.Button` | String | Mouse button |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.Handled` | Boolean | Whether the event is handled |
| `V.Args.Location` | String | Coordinate pair |
| `V.Args.RowHandle` | Long | Row handle |
| `V.Args.RowIndex` | Long | Row index |
| `V.Args.IsGroupRow` | Boolean | Whether clicked row is a group row |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.EventType` | String | "ROWCLICK" |

**MouseCellExit event** -- 17 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.TableName` | String | Name of the bound data table |
| `V.Args.MouseCol` | Long | Column index |
| `V.Args.Row` | Long | Row index |
| `V.Args.SourceRowIndex` | Long | Source (unfiltered) row index |
| `V.Args.Button` | String | Mouse button |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Location` | String | Coordinate pair |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.EventType` | String | "MOUSECELLEXIT" |

**KeyPressEnter event** -- 14 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.GridControlName` | String | Name of the grid control |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.ColumnName` | String | Column name of the focused cell |
| `V.Args.ColumnIndex` | Long | Column index |
| `V.Args.RowHandle` | Long | Row handle |
| `V.Args.RowIndex` | Long | Row index |
| `V.Args.CellValue` | String | Value of the focused cell |
| `V.Args.KeyPress` | Long | ASCII key code (13 for Enter) |
| `V.Args.Character` | String | Character representation |
| `V.Args.EventType` | String | "KEYPRESSENTER" |

**KeyPress event** -- 14 args:

Same structure as KeyPressEnter. `V.Args.EventType` = `"KEYPRESS"`.

**ColumnFilterChanged event** -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.ActiveFilterCriteria` | String | Active filter criteria expression |
| `V.Args.ActiveFilterExpression` | String | Active filter expression string |
| `V.Args.ActiveFilterRowCount` | Long | Number of rows matching the filter |
| `V.Args.GridControlName` | String | Name of the grid control |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.TableName` | String | Name of the bound data table |
| `V.Args.EventType` | String | "COLUMNFILTERCHANGED" |

**ColumnPositionChanged event** -- 9 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.ColumnName` | String | Name of the moved column |
| `V.Args.ColumnIndex` | Long | New column index |
| `V.Args.ColumnVisibleIndex` | Long | New visible index |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.EventType` | String | "COLUMNPOSITIONCHANGED" |

**CellValueChanged event** -- 9 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.Column` | String | Column name |
| `V.Args.RowHandle` | Long | Row handle |
| `V.Args.RowIndex` | Long | Row index |
| `V.Args.Value` | String | New cell value |
| `V.Args.EventType` | String | "CELLVALUECHANGED" |

**FocusedRowChanged event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.PrevFocusedRowHandle` | Long | Visual row index of the previously focused row (not a DataTable row handle) |
| `V.Args.FocusedRowHandle` | Long | Visual row index of the newly focused row (not a DataTable row handle) |
| `V.Args.EventType` | String | "FOCUSEDROWCHANGED" |

> **CRITICAL — Filtered Grid Caveat:**  
> `V.Args.FocusedRowHandle` is a **visual row index**, NOT a DataTable row handle.  
> In filtered/sorted grids, it does NOT correspond to the underlying DataTable row.  
> **Use `GetSelectedRows` to obtain the true DataTable row handle** before calling `GetCellValueByColumnName`.  
> Guard: `If(V.Args.FocusedRowHandle,<,0)` — filter-row clicks return sentinel `-2147483646`.  
> See `GRID.md` § "Reading cell values in filtered grids" and `PITFALLS.md`.

**GotFocus / LostFocus events** -- 6 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.View` | String | Name of the gridview |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

> **Note:** GsAdvBandedGridControl GotFocus/LostFocus include `View` (6 args), unlike simple controls which have 5 args.

**MouseCellEnter event** -- 17 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "GSADVBANDEDGRIDCONTROL" |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.TableName` | String | Name of the bound data table |
| `V.Args.MouseCol` | Long | Column index |
| `V.Args.Row` | Long | Row index |
| `V.Args.SourceRowIndex` | Long | Source (unfiltered) row index |
| `V.Args.Button` | String | Mouse button |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Location` | String | Coordinate pair |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.EventType` | String | "MOUSECELLENTER" |

#### SetColumnProperty (GsAdvBandedGridControl)

**Syntax:**
```
Gui.<Form>.<GsAdvBandedGridControl>.SetColumnProperty(sColumnName, EnumPropertyName, PropertyValue)
```
- `sColumnName` (String) -- column name
- `EnumPropertyName` -- `V.Enum.GsAdvBandedGridColumnPropertyNames!<Name>`
- `PropertyValue` -- Boolean, Date, Float, Long, or String depending on property

**Column Properties Reference:**

| Property | Value Type | Description |
|----------|-----------|-------------|
| **Layout** | | |
| `VisibleIndex` | Long | Column's visible position. |
| `Width` | Long | Column width. |
| `MinWidth` | Long | Minimum column width. |
| `MaxWidth` | Long | Maximum column width. |
| `RowCount` | Long | Number of rows the column spans in a band. |
| `RowIndex` | Long | Row position of the column within its band. |
| `ColIndex` | Long | Column index within its band row. |
| `ColVIndex` | Long | Visual column index. |
| `ColumnSpan` | Long | Number of columns the cell spans horizontally. |
| `RowSpan` | Long | Number of rows the cell spans vertically. |
| `AutoFillDown` | Boolean | Whether column auto-fills remaining band height. |
| `StartNewRow` | Boolean | Whether column starts a new row in the band. |
| `UseEditorColRowSpan` | Boolean | Whether editor respects column/row span settings. |
| `AbsoluteIndex` | Long | Absolute column index. |
| `ColumnHandle` | Long | Internal column handle. |
| `VisibleWidth` | Long | Visible width of the column. |
| **General** | | |
| `Caption` | String | Column header caption. |
| `Name` | String | Column name. |
| `FieldName` | String | Data source field name. |
| `FieldNameSortGroup` | String | Field used for sorting/grouping (when different from display field). |
| `ColumnEditName` | String | Name of the column's in-place editor. |
| `Visible` | Boolean | Whether column is visible. |
| `ReadOnly` | Boolean | Whether column is read-only. |
| `ToolTip` | String | Column tooltip. |
| `Tag` | Object | Custom tag data attached to column. |
| `AccessibleName` | String | Accessibility name. |
| `AccessibleDescription` | String | Accessibility description. |
| `AccessibleRole` | Enum | Accessibility role (`V.Enum.AccessibleRole!*`). |
| `CustomizationCaption` | String | Caption shown in the customization form. |
| `CustomizationSearchCaption` | String | Caption used for search in the customization form. |
| `CaptionLocation` | Enum | Edit form caption location (`V.Enum.EditFormColumnCaptionLocation!*`). |
| **OptionsColumn** | | |
| `AllowEdit` | Boolean | Whether cell editors can be invoked. |
| `AllowFocus` | Boolean | Whether column can receive focus. |
| `AllowGroup` | Boolean | Whether column can be grouped. |
| `AllowSort` | Boolean | Whether column sorting is allowed. |
| `AllowMerge` | Boolean | Whether column cells can be merged. |
| `AllowMove` | Boolean | Whether column can be moved/dragged. |
| `AllowShowHide` | Boolean | Whether column appears in show/hide menu. |
| `AllowSize` | Boolean | Whether column width can be resized. |
| `AllowIncrementalSearch` | Boolean | Whether incremental search is enabled. |
| `FixedWidth` | Boolean | Whether column width is fixed. |
| `FixedStyle` | Enum | Column fixed/anchor style (`V.Enum.FixedStyle!*`). |
| `ShowButtonMode` | Enum | Which cells show editor buttons (`V.Enum.ShowButtonMode!*`). |
| `ShowCaption` | Boolean | Whether column caption is shown. |
| `ShowInCustomizationForm` | Boolean | Whether column appears in customization form. |
| `ShowInExpressionEditor` | Boolean | Whether column appears in expression editor. |
| `Printable` | Boolean | Whether column data is printed. |
| `ImmediateUpdateRowPosition` | Boolean | Whether row position updates immediately. |
| `TabStop` | Boolean | Whether column can be focused via TAB key. |
| **OptionsFilter** | | |
| `AllowFilter` | Boolean | Whether column filtering is enabled. |
| `AllowAutoFilter` | Boolean | Whether auto-filter row is enabled for column. |
| `AllowInHeaderSearch` | Boolean | Whether in-header search is enabled. |
| `InHeaderSearchPrompt` | String | Placeholder text for in-header search box. |
| `AllowFilterModeChanging` | Boolean | Whether filter mode can be changed at runtime. |
| `AutoFilterCondition` | Enum | Auto-filter condition (`V.Enum.AutoFilterCondition!*`). |
| `ImmediateUpdateAutoFilter` | Boolean | Whether data updates immediately after auto-filter. |
| `ImmediateUpdatePopupDateFilterOnCheck` | Boolean | Whether date filter updates on calendar checkbox toggle. |
| `ImmediateUpdatePopupDateFilterOnDateChange` | Boolean | Whether date filter updates on date selection. |
| `ImmediateUpdatePopupExcelFilter` | Boolean | Whether Excel-style popup filter updates immediately. |
| `FilterPopupMode` | Enum | Filter popup style (`V.Enum.FilterPopupMode!*`). |
| `FilterBySortField` | Boolean | Whether filtering uses the sort field. |
| `ShowBlanksFilterItems` | Boolean | Whether "(Blanks)"/"(Non Blanks)" filter items appear. |
| `ShowEmptyDateFilter` | Boolean | Whether null-date filter item appears. |
| `PopupExcelFilterDefaultTab` | Enum | Default tab in Excel-style filter (`V.Enum.ExcelFilterDefaultTab!*`). |
| `PopupExcelFilterNumericValuesTabFilterType` | Enum | Numeric filter type in Excel popup (`V.Enum.ExcelFilterNumericValuesTabFilterType!*`). |
| `PopupExcelFilterDateTimeValuesTabFilterType` | Enum | DateTime filter type in Excel popup (`V.Enum.ExcelFilterDateTimeValuesTabFilterType!*`). |
| `PopupExcelFilterEnumFilters` | Enum | Enum filter type in Excel popup (`V.Enum.ExcelFilterEnumFilters!*`). |
| `PopupExcelFilterTextFilters` | Enum | Text filter type in Excel popup (`V.Enum.ExcelFilterTextFilters!*`). |
| `PopupExcelFilterGrouping` | String | Excel filter grouping expression. |
| **Sort & Group** | | |
| `GroupIndex` | Long | Column's group position. `-1` = not grouped. |
| `SortOrder` | Enum | Sort order (`V.Enum.ColumnSortOrder!*`). |
| `SortIndex` | Long | Sort priority index. |
| `SortMode` | Enum | Sort mode (`V.Enum.ColumnSortMode!*`). |
| `FilterMode` | Enum | Filter mode (`V.Enum.ColumnFilterMode!*`). |
| `GroupInterval` | Enum | Grouping interval (`V.Enum.ColumnGroupInterval!*`). |
| **Display / Image** | | |
| `ImageAlignment` | Enum | Header image alignment (`V.Enum.StringAlignment!*`). |
| `ImageIndex` | Long | Header image index. |
| **Unbound** | | |
| `UnboundType` | Enum | Unbound column data type (`V.Enum.UnboundColumnType!*`). |
| `UnboundDataTypeName` | String | Unbound data type name. |
| `UnboundExpression` | String | Unbound expression formula. |
| `IsUnboundExpressionValid` | Boolean | Whether the unbound expression is valid (read-only). |
| `ShowUnboundExpressionMenu` | Boolean | Whether unbound expression menu is available. |
| **Misc** | | |
| `SearchText` | String | Current search text for the column. |
| `SummaryText` | String | Summary text for the column. |
| `CanShowInCustomizationForm` | Boolean | Whether column can appear in customization form (read-only). |
| `CanShowInAdvancedCustomizationForm` | Boolean | Whether column can appear in advanced customization form (read-only). |
| `AllowSummaryMenu` | Boolean | Whether summary menu is available for the column. |
| `IsLoading` | Boolean | Whether column is currently loading (read-only). |

**Examples:**
```
V.Local.sCol.Declare(String,"Description")
V.Local.bVal.Declare(Boolean,False)

' Disable editing for a column
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty(V.Local.sCol,V.Enum.GsAdvBandedGridColumnPropertyNames!AllowEdit,V.Local.bVal)

' Common property settings
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!AllowEdit,False)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!ReadOnly,True)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!Visible,False)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!Caption,"Display Name")
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!Width,150)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!AllowFilter,False)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!AllowSort,True)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!GroupIndex,0)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!TabStop,False)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!ShowCaption,False)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!FixedWidth,True)
Gui.<Form>.GsAdvBandedGridControl1.SetColumnProperty("ColName",V.Enum.GsAdvBandedGridColumnPropertyNames!FilterPopupMode,V.Enum.FilterPopupMode!Excel)
```

---

### GsWebView2 -- Runtime Limitations & Workarounds

The `GsWebView2` control hosts a Chromium-based browser inside a GAB form. It works well for loading HTML dashboards via `file://` URLs, but has critical runtime limitations discovered through production testing:

#### CRITICAL: `ExecuteScript` causes Error 3000

`Gui.<Form>.wv2.ExecuteScript(sScript)` causes **Runtime Error 3000** ("This property is not supported by the object"). Despite appearing in documentation, it does NOT work on GsWebView2 at runtime.

**Workaround -- file-based data injection:**
1. GAB writes data to a `.js` sidecar file (e.g., `window.DATA = {...};`)
2. HTML loads the data file via `<script src="map_data.js"></script>`
3. HTML processes data on page load (or via `setInterval` polling for the data variable)

See `PATTERNS.md` → Pattern G for the complete implementation.

#### CRITICAL: `file://` origin blocks CORS for tile-based map libraries

JavaScript libraries that fetch map tiles (CesiumJS, Mapbox GL JS, Google Maps JS API) will fail silently or show a black globe when loaded from a `file://` URL. The browser's Same-Origin Policy blocks cross-origin tile requests from `file://`.

**Libraries that WORK from `file://`:**
| Library | CDN Tile Source | 3D? | API Key? |
|---------|----------------|-----|----------|
| **Leaflet.js** | ESRI Satellite, ESRI Terrain, OpenStreetMap | No (2D) | No |
| **globe.gl** | Built-in earth texture | Yes (3D globe) | No |

**Libraries that DO NOT work from `file://`:**
| Library | Reason |
|---------|--------|
| CesiumJS | WebGL tile pipeline requires HTTP origin |
| Mapbox GL JS | Token-authenticated tile fetching blocked by CORS |

**Recommended approach for maps in GAB:** Use Leaflet.js with ESRI satellite/terrain tiles. Add a layer switcher for Satellite, Hybrid, Terrain, and Streets views. All CDN-loaded, no API keys required, fully functional from `file://`.

#### Working GsWebView2 Methods

| Method | Status | Description |
|--------|--------|-------------|
| `.Create(GsWebView2)` | Works | Create control |
| `.Source(sUrl)` | Works | Navigate to URL (file:// or http://) |
| `.Dock(N)` | Works | Standard dock |
| `.Event(UrlChanged,SubName)` | Works | JS-to-GAB via hash fragment |
| `.ExecuteScript(sScript)` | **BROKEN (Error 3000)** | Use file-based injection |

#### Google Street View Embed (free, no API key)

To add Street View to a map popup, use the free Google Maps embed URL:
```html
<iframe src="https://maps.google.com/maps?layer=c&cbll={lat},{lng}&cbp=12,0,0,0,0&output=svembed"
        width="100%" height="300" frameborder="0"></iframe>
```
This works from `file://` because the iframe loads from Google's HTTP origin, not the parent document's origin.

---

### SplitContainer Layout Pattern

Production layout from SOHistory (7882) and Executive Dashboard (5784): a vertical split with summary grid in Panel1 and detail grid in Panel2.

```
Gui.frmMain.splMain.Create(SplitContainer)
Gui.frmMain.splMain.Dock(5)
Gui.frmMain.splMain.SplitterPosition(400)
Gui.frmMain.splMain.Orientation(0)  ' 0=Vertical, 1=Horizontal
' Place controls in Panel1 and Panel2 via .Parent:
Gui.frmMain.gsGCSummary.Create(GsGridControl)
Gui.frmMain.gsGCSummary.Parent("splMain",1)
Gui.frmMain.gsGCSummary.Dock(5)
Gui.frmMain.gsGCDetail.Create(GsGridControl)
Gui.frmMain.gsGCDetail.Parent("splMain",2)
Gui.frmMain.gsGCDetail.Dock(5)
```

> **Orientation:** `0` = vertical split (panels side-by-side), `1` = horizontal split (panels stacked). Use `SplitterPosition` to set the initial divider position in pixels/twips.

