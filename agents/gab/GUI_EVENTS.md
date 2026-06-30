# GAB GUI Runtime, V.Screen State & Events Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with common control properties, V.Screen state access, runtime methods, alerts, event reference, and context menus
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

> **Scope note:** Despite the filename `GUI_EVENTS.md`, this file covers more than events. It is the primary reference for **V.Screen property access** (per-control state), **common control properties**, **control runtime methods**, the **alert system**, the **event types matrix**, and **context menus**. If you are looking for V.Screen read/set patterns, this is the correct file.

---
### GsToggleSwitch
An on/off toggle switch control.

**ScreenSU setup:**
```
Gui.<Form>.GsToggleSwitch1.Create(GsToggleSwitch)
Gui.<Form>.GsToggleSwitch1.Enabled(True)
Gui.<Form>.GsToggleSwitch1.Visible(True)
Gui.<Form>.GsToggleSwitch1.Size(95,24)
Gui.<Form>.GsToggleSwitch1.Position(107,219)
Gui.<Form>.GsToggleSwitch1.Event(,GsToggleSwitch1_Toggled)
Gui.<Form>.GsToggleSwitch1.Event(GotFocus,GsToggleSwitch1_GotFocus)
Gui.<Form>.GsToggleSwitch1.Event(LostFocus,GsToggleSwitch1_LostFocus)
```

> **Note:** The Toggled event uses an empty first parameter `Event(,SubName)` -- it is the control's default event.

#### GsToggleSwitch Events V.Args

> ControlType: `"GSTOGGLESWITCH"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`) are present in every event and omitted from tables below. All three events share the same 9-arg signature.

**Toggled / GotFocus / LostFocus events** -- 9 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.GsToggleSwitchName` | String | Name of the toggle switch control instance |
| `V.Args.IsOn` | Boolean | Current toggle state (True = On, False = Off) |
| `V.Args.OffText` | String | Text displayed in the Off state (e.g. "Off") |
| `V.Args.OnText` | String | Text displayed in the On state (e.g. "On") |
| `V.Args.EventType` | String | "TOGGLED", "GOTFOCUS", or "LOSTFOCUS" |

**Event chain:** GotFocus -> (user toggles) -> LostFocus

> **Note:** All events (not just Toggled) include the full toggle state context (`IsOn`, `OffText`, `OnText`, `GsToggleSwitchName`). Use `V.Args.IsOn` in the Toggled handler to determine the new state.

### ProgressPanel
An overlay panel showing loading/progress state with configurable alignment.
```
' Standard creation
Gui.<Form>.progressPanel1.Create(ProgressPanel,"Please Wait","Loading...",20,0,False,iWidth,iHeight,iX,iY)

' Compact creation: Create(ProgressPanel, sTitle, sDetail, iOffset, iBorderStyle, bVisible, iWidth, iHeight, iLeft, iTop, bEnabled)
' iOffset = distance between edge of control and loading wheel
' iBorderStyle = 0 for no border, 1 for border

Gui.<Form>.progressPanel1.FontSizeDetail(8.25)
Gui.<Form>.progressPanel1.BackColor(65535)
Gui.<Form>.progressPanel1.ContentAlignment(V.Enum.ContentAlignment!MiddleCenter)
Gui.<Form>.progressPanel1.Detail(sDetailString)                ' Set the detail (small) text
Gui.<Form>.progressPanel1.DetailInternationalID(iID)           ' Set International ID for detail text
Gui.<Form>.progressPanel1.CaptionInternationalID(iID)          ' Set International ID for caption text
Gui.<Form>.progressPanel1.FontSizeDelta(iDelta)                ' Offset font size from default
Gui.<Form>.progressPanel1.FontStyleDetail(iStyle)              ' Set detail text font style
Gui.<Form>.progressPanel1.Offset(iOffset)                      ' Distance between edge and loading wheel
Gui.<Form>.progressPanel1.Visible(True)
```

### VScrollBar
A vertical scrollbar control.
```
Gui.<Form>.vsb1.Create(VScrollBar)
Gui.<Form>.vsb1.Enabled(True)
Gui.<Form>.vsb1.Locked(False)
Gui.<Form>.vsb1.Position(100,100)
Gui.<Form>.vsb1.Picture(sFqFilename)
Gui.<Form>.vsb1.Value(50)
Gui.<Form>.vsb1.TabIndex(0)
Gui.<Form>.vsb1.TabStop(True)
Gui.<Form>.vsb1.Event(Change,vsb1_Change)
```

### GsGridControl (DevExpress Grid)
```
Gui.<Form>.gsGC.Create(GsGridControl)
Gui.<Form>.gsGC.Size(14625,7155)
Gui.<Form>.gsGC.Position(0,690)
Gui.<Form>.gsGC.Anchor(15)
Gui.<Form>.gsGC.Event(RowCellClick,gsGC_RowCellClick)
Gui.<Form>.gsGC.Event(CellValueChanged,gsGC_CellValueChanged)
Gui.<Form>.gsGC.Dock(5)
```

## Common Control Properties
| Property | Values |
|----------|--------|
| `Anchor(n)` | 1=Top, 2=Bottom, 4=Left, 8=Right, 15=All, 6=Bottom+Left, 9=Top+Right |
| `Dock(n)` | 0=None, 1=Top, 2=Bottom, 3=Left, 4=Right, 5=Fill (or `V.Enum.DockStyle!`) |
| `FontStyle(Bold,Italic,Underline,Strikethrough,Shadow)` | Boolean each |
| `FontName(s)` | Set the font for the control |
| `Zorder(n)` | Stack order |
| `TabStop(True/False)` | Include in tab order |
| `TabIndex(n)` | Position in tab order |
| `Parent("name")` | Set parent container |
| `Parent("tabName",tabIndex)` | Set parent to specific tab |
| `BorderStyle(n)` | 0=None, 1=Border (3D effects removed; simple on/off) |
| `ExcludeFromUndo(b)` | Exclude this control from the undo/redo system (DashForm) |
| `ClearItems` | Removes all items from the control. No arguments. Applies to: dropdownlist, combobox, listbox, listview, treeview |
| `DefaultValue(Value)` | Sets the initial/default value of a control. Value type varies by control -- see table below |
| `Group(Group)` | Assign control to a group; Group as Long |
| `ContextMenuAttach(MenuName)` | Attach a context menu to the control; MenuName as String |
| `ContextMenuDetach(MenuName)` | Detach a context menu from the control; MenuName as String |
| `LayoutCaptionVisible(IsVisible)` | Show/hide the layout caption for a control; IsVisible as Boolean |
| `SvgPicture(V.Enum.Image!, [iWidth=16], [iHeight=16])` | Set SVG icon on the control |
| `SvgPictureSize(iWidth, iHeight)` | Set the SVG icon size |
| `UseLayout(b)` | Convert control to use layout (generally designer-only; auto-arranges child controls) |
| `UpdateLayout(sFileName)` | Replace default layout (FQN or packaged filename). Blank string reverts to default |

### DefaultValue Types by Control

| Control | Value Type |
|---------|-----------|
| button | Any |
| checkbox | Boolean |
| combobox | String |
| datepicker | (via DefaultValue) |
| dropdownlist | (via DefaultValue) |
| hyperlink | String |
| keylabel | String |
| label | String |
| monthview | String |
| option | Boolean | **(DEPRECATED)** |
| progressbar | Float |
| textbox | String |
| textboxm | String |
| textboxr | String |

### SvgPicture (Built-in SVG Icons)

Controls with Picture properties also support `SvgPicture` and `SvgPictureSize`. These are standard application icons that can be used without saving an image file externally. Set in the designer or programmatically using `V.Enum.Image!`.

**Supported controls:** PictureBox, Button, Hyperlink, Label

**In ScreenSU** (string name):
```
Gui.<Form>.pic1.SvgPicture("icon_add_color")
Gui.<Form>.cmd1.SvgPicture("icon_add_color")
Gui.<Form>.link1.SvgPicture("icon_add_black")
Gui.<Form>.lbl1.SvgPicture("icon_add_color")
```

**At runtime** (enum):
```
Gui.<Form>.pic1.SvgPicture(V.Enum.Image!ADD_BLACK)
Gui.<Form>.cmd1.SvgPicture(V.Enum.Image!ADD_COLOR)
Gui.<Form>.link1.SvgPicture(V.Enum.Image!ADD_PLAIN_BLACK)
Gui.<Form>.lbl1.SvgPicture(V.Enum.Image!ADD_PLAIN_COLOR)

Gui.<Form>.pic1.SvgPictureSize(50,50)
Gui.<Form>.cmd1.SvgPictureSize(50,50)
Gui.<Form>.link1.SvgPictureSize(50,50)
Gui.<Form>.lbl1.SvgPictureSize(50,50)
```

For the full image catalog, see `V.Enum.Image!` in `agents/gab/ENUMS.md`.

### Control Wait Overlay
Show a ProgressPanel overlay on any control while it loads:
```
Gui.<Form>.<Control>.InvokeWait(Description, [Title])  ' Description as String, Title as String (opt)
Gui.<Form>.<Control>.UpdateWait(Description, [Title])  ' Description as String, Title as String (opt)
Gui.<Form>.<Control>.HideWait()  ' Hides the wait overlay (no params)
```

## Control Runtime Methods
At runtime, control properties can be set dynamically (outside ScreenSU):
```
Gui.<Form>.txtName.Text("new value")       ' Set textbox text
Gui.<Form>.txtName.Text(V.Local.sValue)    ' Set from variable
Gui.<Form>.lblName.Caption("new text")     ' Set label caption
Gui.<Form>.lblName.Caption(V.Local.sVal)   ' Set from variable
Gui.<Form>.txtName.SelectAll              ' Select all text in textbox
Gui.<Form>.ddlName.ListIndex(2)            ' Set dropdown selection
Gui.<Form>.chkName.Value(1)               ' Check checkbox
Gui.<Form>.cmdName.Enabled(False)          ' Disable button
Gui.<Form>.txtName.Visible(False)          ' Hide control
Gui.<Form>.txtName.BackColor(V.Color.LtGray)  ' Set background color
```

### Dynamic Control References (using variables)
Form and control names can be resolved from variables at runtime:
```
Gui.[V.Local.sForm].[V.Local.sControl].Export(V.Local.sPath,"xlsx")
Gui.[V.Local.sFormName]..SetFocus
```

## Screen Variable Properties (V.Screen.*form.*)

Read-only properties to query form and control state at runtime. Access via `V.Screen.<Form>.<Control>.<Property>` or `V.Screen.<Form>!<Control>.<Property>`.

```
V.Screen.<Form>.<Control>.BackColor           ' Background color
V.Screen.<Form>.<Control>.Caption             ' Caption text
V.Screen.<Form>.<Control>.ControlType         ' Control type name
V.Screen.<Form>.<Control>.CurrentX            ' Current X coordinate
V.Screen.<Form>.<Control>.CurrentY            ' Current Y coordinate
V.Screen.<Form>.<Control>.Enabled             ' True if enabled
V.Screen.<Form>.<Control>.Focused             ' True if has focus
V.Screen.<Form>.<Control>.FontName            ' Font name
V.Screen.<Form>.<Control>.FontSize            ' Font size
V.Screen.<Form>.<Control>.ForeColor           ' Foreground color
V.Screen.<Form>.<Control>.Height              ' Control height
V.Screen.<Form>.<Control>.HWnd               ' Window handle (HWND)
V.Screen.<Form>.<Control>.InternationalID     ' Translation label ID
V.Screen.<Form>.<Control>.Left                ' Left position
V.Screen.<Form>.<Control>.MetaData0           ' Metadata slot 0 (set via Gui.*.SetMetadata)
V.Screen.<Form>.<Control>.MetaData1           ' Metadata slot 1
V.Screen.<Form>.<Control>.MetaData2           ' Metadata slot 2
V.Screen.<Form>.<Control>.MetaData3           ' Metadata slot 3
V.Screen.<Form>.<Control>.MetaData4           ' Metadata slot 4
V.Screen.<Form>.<Control>.MetaData5           ' Metadata slot 5
V.Screen.<Form>.<Control>.MetaData6           ' Metadata slot 6
V.Screen.<Form>.<Control>.MetaData7           ' Metadata slot 7
V.Screen.<Form>.<Control>.MetaData8           ' Metadata slot 8
V.Screen.<Form>.<Control>.MetaData9           ' Metadata slot 9
V.Screen.<Form>.<Control>.Result              ' Result value
V.Screen.<Form>.<Control>.ResultString        ' Result as string
V.Screen.<Form>.<Control>.Text                ' Text content
V.Screen.<Form>.<Control>.Top                 ' Top position
V.Screen.<Form>.<Control>.Visible             ' True if visible
V.Screen.<Form>.<Control>.Width               ' Control width
V.Screen.<Form>.<Control>.WindowHandle        ' Window handle
V.Screen.<Form>.<Control>.WindowState         ' Form window state
```

### Property Reference

| Property | Returns | Description |
|----------|---------|-------------|
| `.BackColor` | Long | Background color |
| `.Caption` | String | Caption/title text |
| `.ControlType` | String | Control type (button, textbox, label, checkbox, combobox, dropdownlist, frame, listbox, timer, datepicker, tab, treeview, listview, gsflexgrid, etc.) |
| `.CurrentX` | Long | Current X coordinate |
| `.CurrentY` | Long | Current Y coordinate |
| `.Enabled` | Boolean | True if the control is enabled |
| `.Focused` | Boolean | True if the control has focus |
| `.FontName` | String | Font family name |
| `.FontSize` | Long | Font size |
| `.ForeColor` | Long | Foreground (text) color |
| `.Height` | Long | Control height |
| `.HWnd` | Long | Window handle (HWND) |
| `.InternationalID` | Long | Numeric label ID for international translation |
| `.Left` | Long | Left edge position |
| `.MetaData0` - `.MetaData9` | String | Custom metadata slots 0-9 (set via `Gui.<Form>.<Control>.SetMetadata`) |
| `.Result` | Variant | Result value |
| `.ResultString` | String | Result as string |
| `.Text` | String | Text content of the control |
| `.Top` | Long | Top edge position |
| `.Visible` | Boolean | True if the control is visible |
| `.Width` | Long | Control width |
| `.WindowHandle` | Long | Window handle |
| `.WindowState` | Long | Window state of the form |

### ControlType Valid Values

`button`, `picturebox`, `label`, `textbox`, `textboxr`, `textboxm`, `timer`, `checkbox`, `combobox`, `dropdownlist`, `frame`, `listbox`, `hscrollbar`, `vscrollbar`, `progressbar`, `treeview`, `listview`, `slider`, `spinh`, `spinv`, `datepicker`, `option` (DEPRECATED), `monthview`, `tab`, `web`, `hflexgrid`, `htmlcontainer`, `gsflexgrid`, `directory`, `imagelist`, `keylabel`

### Complete V.Screen.*form.*cntrl Grouped Methods

The following is the complete set of properties available via `V.Screen.<Form>!<Control>.<Property>`. Not all properties apply to every control type -- calling a property on an incompatible control returns empty/default. The `!` separator and `.` separator are interchangeable: `V.Screen.frmMain!txtName.Text` equals `V.Screen.frmMain.txtName.Text`.

### Per-Control V.Screen Properties

Each control type exposes the common properties listed above, plus control-specific additions. Properties listed here are **in addition to** the common set. Some form-level properties (Result, ResultString, WindowState) are only available on the form itself, not on child controls.

#### Common Extended Properties (shared by multiple control types)

These properties appear on many controls in addition to the base set above:

| Property | Returns | Description |
|----------|---------|-------------|
| `.Alignment()` | Long | Content alignment |
| `.Anchor()` | Long | Anchor setting (1=Top, 2=Bottom, 4=Left, 8=Right, combinable) |
| `.AutoEllipsis()` | Boolean | Whether text truncation shows ellipsis |
| `.AutoSize()` | Boolean | Whether control auto-sizes to content |
| `.BorderStyle()` | Long | Border style value |
| `.Dock()` | Long | Dock setting (5=Fill) |
| `.ExcludeFromUndo()` | Boolean | Whether excluded from undo tracking |
| `.Key()` | String | Control's key identifier |
| `.Locked()` | Boolean | Whether control is locked (read-only) |
| `.TabIndex()` | Long | Position in tab order |
| `.TabStop()` | Boolean | Whether control participates in tab navigation |
| `.ToolTip()` | String | Tooltip text |

#### Button V.Screen Properties

Additional properties beyond common + common extended:

| Property | Returns | Description |
|----------|---------|-------------|
| `.ImageAlign(Alignment)` | V.Enum.ImageAlignToText | Image alignment within the button; Alignment as V.Enum.ImageAlignToText |
| `.LabelStretch(ShouldStretchOnTranslation)` | Boolean | Whether button stretches when label is translated; ShouldStretchOnTranslation as Boolean |
| `.DisableOnClick(Mode)` | V.Enum.DisableOnClickModes | Prevents double-click issues. `DoNotDisable`, `DisableButton`, `DisableButtonWithReEnable`, `DisableFormWithReEnable` |

Full list: Anchor, AutoEllipsis, BackColor, BorderStyle, Caption, ControlType, CurrentX, CurrentY, DisableOnClick, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, ImageAlign, InternationalID, Left, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Visible, Width, WindowHandle.

#### CheckBox V.Screen Properties

Additional properties beyond common + common extended:

| Property | Returns | Description |
|----------|---------|-------------|
| `.Checked` | Long | Check state (0=Unchecked, 1=Checked, 2=Indeterminate) |
| `.CheckedAsBoolean` | Boolean | Check state as True/False |
| `.Value` | Long | Current value (same as Checked) |

> **CRITICAL — Checkbox comparison:** `.Value` and `.Checked` return `0` or `1` (Long), NOT True/False. **Always** compare explicitly with `=,1` or `=,0` in conditionals — **never** use a bare boolean check. Use `.CheckedAsBoolean` only when a True/False value is specifically needed. See `agents/AGENTS.GAB.md § Checkbox-Specific Rules`.
> ```
> F.Intrinsic.Control.If(V.Screen.frmMain!chkActive.Value,=,1)   ' Correct
> F.Intrinsic.Control.If(V.Screen.frmMain!chkActive.Value)        ' WRONG — bare boolean check
> ```

```
V.Screen.<Form>!chkActive.Checked            ' Returns 0 or 1
V.Screen.<Form>!chkActive.CheckedAsBoolean   ' Returns True or False
V.Screen.<Form>!chkActive.Value              ' Returns 0 or 1 (same as Checked)
```

Full list: Alignment, Anchor, AutoEllipsis, AutoSize, BackColor, Caption, Checked, CheckedAsBoolean, ControlType, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, Locked, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### ListBox / ComboBox / DropDownList V.Screen Properties (shared)

Properties common to all list-style controls:

| Property | Returns | Description |
|----------|---------|-------------|
| `.ItemData()` | String | Bound data value of the selected item |
| `.List()` | String | Text of the selected list item |
| `.ListCount()` | Long | Total number of items in the list |
| `.ListIndex()` | Long | Zero-based index of the selected item (-1 if none) |
| `.SelectionMode()` | Long | Selection mode (single, multi, extended) |

```
V.Screen.<Form>!lst1.ListCount()
V.Screen.<Form>!lst1.ListIndex()
V.Screen.<Form>!lst1.List()
V.Screen.<Form>!lst1.ItemData()
V.Screen.<Form>!ddlStatus.ListIndex()
V.Screen.<Form>!ddlStatus.Text()
```

#### ListBox V.Screen Properties

Additional properties specific to ListBox (beyond common, common extended, and shared list properties above). ListBox has `ListItemCount()` (alternative to `ListCount()`) and `Value()`. It does **not** have Locked, ExcludeFromUndo, or AutoSize.

| Property | Returns | Description |
|----------|---------|-------------|
| `.ListItemCount()` | Long | Total number of items (alternative to ListCount) |
| `.Value()` | String | Current value of the ListBox |

```
V.Screen.<Form>!lst1.ListCount()
V.Screen.<Form>!lst1.ListIndex()
V.Screen.<Form>!lst1.List()
V.Screen.<Form>!lst1.ItemData()
V.Screen.<Form>!lst1.ListItemCount()
V.Screen.<Form>!lst1.Value()
V.Screen.<Form>!lst1.Text()
```

Full list: Anchor, AutoEllipsis, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, ItemData, Left, List, ListCount, ListIndex, ListItemCount, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### ComboBox V.Screen Properties

Additional properties specific to ComboBox (beyond common, common extended, and shared list properties above):

| Property | Returns | Description |
|----------|---------|-------------|
| `.DroppedDown()` | Boolean | True if the dropdown list is currently open/expanded |
| `.ListItemCount()` | Long | Total number of items in the list |
| `.MaxDropDownItems()` | Long | Maximum number of items visible in the dropdown before scrolling |
| `.SelLength()` | Long | Length of the selected text in the edit portion |
| `.SelStart()` | Long | Starting position of text selection in the edit portion |
| `.SelText()` | String | Currently selected text in the edit portion |
| `.Value()` | String | Current value of the ComboBox |

```
V.Screen.<Form>!cboSearch.DroppedDown()
V.Screen.<Form>!cboSearch.MaxDropDownItems()
V.Screen.<Form>!cboSearch.ListItemCount()
V.Screen.<Form>!cboSearch.Value()
V.Screen.<Form>!cboSearch.SelStart()
V.Screen.<Form>!cboSearch.SelLength()
V.Screen.<Form>!cboSearch.SelText()
```

Full list: Anchor, AutoEllipsis, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, DroppedDown, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, ItemData, Left, List, ListCount, ListIndex, ListItemCount, Locked, MaxDropDownItems, MetaData0-9, SelLength, SelStart, SelText, TabIndex, TabStop, Text, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### DropDownList V.Screen Properties

Additional properties specific to DropDownList (beyond common, common extended, and shared list properties). DropDownList shares DroppedDown, MaxDropDownItems, ListItemCount, and Value with ComboBox, but does **not** have SelLength/SelStart/SelText (no editable text portion).

| Property | Returns | Description |
|----------|---------|-------------|
| `.DroppedDown()` | Boolean | True if the dropdown is currently open showing items |
| `.List(Index)` | String | Text of a specific item by zero-based index; `Index` as Long |
| `.ListItemCount()` | Long | Total number of items (alternative to ListCount) |
| `.MaxDropDownItems()` | Long | Maximum visible items before scrollbar appears |
| `.Value()` | String | Current value (typically same as Text for the selected item) |

The `List(Index)` variant allows retrieving any item's text by index, unlike the no-argument `List()` which returns only the selected item:

```
V.Screen.<Form>!ddlStatus.DroppedDown()
V.Screen.<Form>!ddlStatus.MaxDropDownItems()
V.Screen.<Form>!ddlStatus.ListItemCount()
V.Screen.<Form>!ddlStatus.Value()

' Retrieve item text by index
V.Local.iIndex.Declare(Long,0)
V.Local.sItemText.Declare(String)
V.Local.sItemText.Set(V.Screen.<Form>!ddlStatus.List(V.Local.iIndex))

' Iterate all items
F.Intrinsic.Control.For(V.Local.i,0,V.Screen.<Form>!ddlStatus.ListCount()--,1)
    V.Local.sItemText.Set(V.Screen.<Form>!ddlStatus.List(V.Local.i))
F.Intrinsic.Control.Next(V.Local.i)
```

Full list: Anchor, AutoEllipsis, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, DroppedDown, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, ItemData, Left, List(Index), ListCount, ListIndex, ListItemCount, Locked, MaxDropDownItems, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### DatePicker V.Screen Properties

Additional properties specific to DatePicker (beyond common + common extended):

| Property | Returns | Description |
|----------|---------|-------------|
| `.PervasiveDate()` | String | Selected date formatted for Pervasive SQL (yyyy-MM-dd) |
| `.Value()` | String | Current date value of the picker |

```
V.Screen.<Form>!dtpStart.Text()
V.Screen.<Form>!dtpStart.Value()
V.Screen.<Form>!dtpStart.PervasiveDate()
```

Full list: Anchor, AutoEllipsis, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, MetaData0-9, PervasiveDate, TabIndex, TabStop, Text, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### ListView V.Screen Properties

Additional properties beyond common base. ListView has Locked, ToolTip, and BorderStyle but does **not** have Caption, Text, InternationalID, AutoEllipsis, AutoSize, or ExcludeFromUndo.

| Property | Returns | Description |
|----------|---------|-------------|
| `.ListItemKey()` | String | Key of the currently selected list item |
| `.ListItemText()` | String | Text of the currently selected list item |
| `.ListItemTextExtended()` | String | Extended text for a list item (accepts optional Long argument for index/sub-item) |
| `.ListViewContents()` | String | Serialized contents of the entire ListView |
| `.Locked()` | Boolean | Whether the control is locked (read-only) |
| `.SelectedItemKey()` | String | Key of the selected item |
| `.SelectedItemSubItem()` | String | Sub-item text of the selected item |
| `.SelectedItemText()` | String | Display text of the selected item |
| `.View()` | Long | Current view mode (icon, detail, list, etc.) |

```
V.Screen.<Form>!lvw1.SelectedItemKey()
V.Screen.<Form>!lvw1.SelectedItemText()
V.Screen.<Form>!lvw1.SelectedItemSubItem()
V.Screen.<Form>!lvw1.ListItemKey()
V.Screen.<Form>!lvw1.ListItemText()
V.Screen.<Form>!lvw1.ListItemTextExtended()
V.Screen.<Form>!lvw1.ListViewContents()
V.Screen.<Form>!lvw1.View()
V.Screen.<Form>!lvw1.Locked()
```

Full list: Anchor, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, ListItemKey, ListItemText, ListItemTextExtended, ListViewContents, Locked, MetaData0-9, SelectedItemKey, SelectedItemSubItem, SelectedItemText, TabIndex, TabStop, ToolTip, Top, View, Visible, Width, WindowHandle.

#### TreeView V.Screen Properties

The TreeView displays hierarchical data as an expandable node tree. It exposes common base properties plus node-specific and selection-specific read-back properties. No Caption, Text, InternationalID, ExcludeFromUndo, AutoEllipsis, or AutoSize.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Key()` | String | Control's key identifier |
| `.Locked()` | Boolean | Whether the control is locked (read-only) |
| `.NodeCount()` | Long | Total number of nodes in the tree |
| `.NodeKey()` | String | Key of the currently selected node |
| `.NodeSelected()` | String | Selected node identifier |
| `.NodeText()` | String | Display text of the currently selected node |
| `.SelectedItemKey()` | String | Key of the selected item (alternate for NodeKey) |
| `.SelectedItemText()` | String | Text of the selected item (alternate for NodeText) |
| `.ToolTip()` | String | Tooltip text |

```
V.Screen.<Form>!trvMenu.NodeCount()
V.Screen.<Form>!trvMenu.NodeKey()
V.Screen.<Form>!trvMenu.NodeText()
V.Screen.<Form>!trvMenu.NodeSelected()
V.Screen.<Form>!trvMenu.SelectedItemKey()
V.Screen.<Form>!trvMenu.SelectedItemText()
V.Screen.<Form>!trvMenu.Key()
V.Screen.<Form>!trvMenu.Locked()
V.Screen.<Form>!trvMenu.ToolTip()
```

Full list: Anchor, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Key, Left, Locked, MetaData0-9, NodeCount, NodeKey, NodeSelected, NodeText, SelectedItemKey, SelectedItemText, TabIndex, TabStop, ToolTip, Top, Visible, Width, WindowHandle.

#### GSFlexGrid V.Screen Properties

Grid-specific properties beyond common base. The GSFlexGrid has `Busy()` to indicate whether the grid is processing. Reduced set: no Caption, Text, ToolTip, Locked, InternationalID, ExcludeFromUndo, AutoEllipsis, AutoSize.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Busy()` | Boolean | True if the grid is currently processing/loading |
| `.Col()` | Long | Current column index |
| `.Cols()` | Long | Total number of columns |
| `.Row()` | Long | Current row index |
| `.Rows()` | Long | Total number of rows |
| `.RowSel()` | Long | End row of current selection range |

```
V.Screen.<Form>!gsGCFlex.Busy()
V.Screen.<Form>!gsGCFlex.Row()
V.Screen.<Form>!gsGCFlex.Col()
V.Screen.<Form>!gsGCFlex.Rows()
V.Screen.<Form>!gsGCFlex.Cols()
V.Screen.<Form>!gsGCFlex.RowSel()
```

Full list: Anchor, BackColor, BorderStyle, Busy, Col, Cols, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, MetaData0-9, Row, Rows, RowSel, TabIndex, TabStop, Top, Visible, Width, WindowHandle.

#### GsGridControl V.Screen Properties

The GsGridControl (DevExpress grid) exposes only common base properties via V.Screen -- no grid-specific read-back properties like Row/Col/Rows. All grid state (focused row, cell values, column settings) is accessed through `Gui.*` methods and event `V.Args`. See `agents/gab/GRID.md` for the full GsGridControl API. Has `ExcludeFromUndo()` unlike the flex grids.

Full list: Anchor, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, MetaData0-9, TabIndex, TabStop, Top, Visible, Width, WindowHandle.

#### HFlexGrid V.Screen Properties

The HFlexGrid exposes additional column-level properties not available on GSFlexGrid:

| Property | Returns | Description |
|----------|---------|-------------|
| `.Col()` | Long | Current column index |
| `.ColAlignment()` | Long | Alignment of the current column |
| `.Cols()` | Long | Total number of columns |
| `.ColWidth()` | Long | Width of the current column |
| `.FixedCols()` | Long | Number of fixed (non-scrollable) columns |
| `.FixedRows()` | Long | Number of fixed (non-scrollable) header rows |
| `.Row()` | Long | Current row index |
| `.Rows()` | Long | Total number of rows |
| `.RowSel()` | Long | End row of current selection range |

```
V.Screen.<Form>!hflex1.Row()
V.Screen.<Form>!hflex1.Col()
V.Screen.<Form>!hflex1.Rows()
V.Screen.<Form>!hflex1.Cols()
V.Screen.<Form>!hflex1.RowSel()
V.Screen.<Form>!hflex1.FixedRows()
V.Screen.<Form>!hflex1.FixedCols()
V.Screen.<Form>!hflex1.ColWidth()
V.Screen.<Form>!hflex1.ColAlignment()
```

#### HScrollBar / VScrollBar V.Screen Properties

Scrollbar controls expose a minimal property set with `Value()` for the current scroll position. Reduced set: no BackColor, BorderStyle, ForeColor, Caption, Text, ToolTip, FontName, FontSize, InternationalID, ExcludeFromUndo, AutoEllipsis, AutoSize.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Locked()` | Boolean | Whether the scrollbar is locked (read-only) |
| `.Value()` | Long | Current scroll position value |

```
V.Screen.<Form>!hscroll1.Value()
V.Screen.<Form>!hscroll1.Locked()
V.Screen.<Form>!hscroll1.Enabled()
V.Screen.<Form>!hscroll1.Visible()
```

Full list: Anchor, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, Height, HWnd, Left, Locked, MetaData0-9, TabIndex, TabStop, Top, Value, Visible, Width, WindowHandle.

#### Frame V.Screen Properties

The Frame is a container/groupbox control. It exposes common + common extended properties plus `UseLayout()` for layout persistence.

| Property | Returns | Description |
|----------|---------|-------------|
| `.UseLayout()` | Boolean | Whether layout persistence is enabled for this frame |

```
V.Screen.<Form>!framePrimary.Caption()
V.Screen.<Form>!framePrimary.Visible()
V.Screen.<Form>!framePrimary.UseLayout()
V.Screen.<Form>!framePrimary.Enabled()
```

Full list: Anchor, AutoEllipsis, AutoSize, BackColor, BorderStyle, Caption, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, UseLayout, Visible, Width, WindowHandle.

#### FunctionLinks V.Screen Properties

The FunctionLinks control displays a set of clickable action links. It has a reduced property set (no BackColor, BorderStyle, Caption, Text, ToolTip, Locked, InternationalID). Its `MetaData0-9` methods accept an optional `LinkID` parameter to query metadata for a specific sub-link rather than the control itself.

| Property | Returns | Description |
|----------|---------|-------------|
| `.MetaData0([LinkID])` - `.MetaData9([LinkID])` | String | Metadata slots 0-9; when `LinkID` (String) is omitted, returns control-level metadata; when provided, returns metadata for the named sub-link |

```
' Control-level metadata
V.Screen.<Form>!functionlinks1.MetaData0()

' Sub-link metadata (pass LinkID as String)
V.Local.sLinkID.Declare(String,"myLink")
V.Screen.<Form>!functionlinks1.MetaData0(V.Local.sLinkID)
V.Screen.<Form>!functionlinks1.MetaData1(V.Local.sLinkID)
' ... MetaData2 through MetaData8 follow the same pattern ...
V.Screen.<Form>!functionlinks1.MetaData9(V.Local.sLinkID)

' Other common properties
V.Screen.<Form>!functionlinks1.Enabled()
V.Screen.<Form>!functionlinks1.Visible()
V.Screen.<Form>!functionlinks1.Height()
```

Full list: Anchor, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, MetaData0-9([LinkID]), TabIndex, TabStop, Top, Visible, Width, WindowHandle.

#### GsChart V.Screen Properties

The GsChart control exposes only common base properties via V.Screen (no chart-specific read-back properties). Chart configuration and data binding are done through `Gui.*` methods. Reduced set: no Caption, Text, ToolTip, Locked, InternationalID, ExcludeFromUndo, AutoEllipsis, AutoSize.

Full list: Anchor, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, MetaData0-9, TabIndex, TabStop, Top, Visible, Width, WindowHandle.

#### TextBox / TextBoxM / TextBoxR V.Screen Properties

The TextBox (single-line), TextBoxM (multiline), and TextBoxR (rich text) share a rich property set. Selection properties (SelStart, SelLength, SelText) also apply to ComboBox (see ComboBox section above). All three have cursor-position and line-counting properties, text selection, and MaxLength. TextBox adds numeric range properties (Min, Max) and UseLayout; TextBoxM does **not** have Min, Max, or UseLayout.

| Property | Returns | Applies To | Description |
|----------|---------|-----------|-------------|
| `.Alignment()` | Long | All | Content alignment |
| `.CurrentColumn()` | Long | All | Current cursor column position |
| `.CurrentLine()` | Long | All | Current cursor line number |
| `.ExcludeFromUndo()` | Boolean | All | Whether excluded from undo tracking |
| `.InternationalID()` | Long | All | Translation label ID |
| `.LineCount()` | Long | All | Total number of lines |
| `.Locked()` | Boolean | All | Whether the control is locked (read-only) |
| `.Max()` | Long | TextBox, TextBoxR | Maximum allowed numeric value |
| `.MaxLength()` | Long | All | Maximum number of characters allowed |
| `.Min()` | Long | TextBox, TextBoxR | Minimum allowed numeric value |
| `.SelectedText()` | String | All | Currently selected text (alternate for SelText) |
| `.SelLength()` | Long | All | Length of the selected text |
| `.SelStart()` | Long | All | Starting position of the text selection |
| `.SelText()` | String | All | Currently selected text content |
| `.Text()` | String | All | Text content of the control |
| `.ToolTip()` | String | All | Tooltip text |
| `.UseLayout()` | Boolean | TextBox, TextBoxR | Whether layout persistence is enabled |

```
V.Screen.<Form>!txtSearch.Text()
V.Screen.<Form>!txtSearch.SelStart()
V.Screen.<Form>!txtSearch.SelLength()
V.Screen.<Form>!txtSearch.SelText()
V.Screen.<Form>!txtSearch.SelectedText()
V.Screen.<Form>!txtSearch.MaxLength()
V.Screen.<Form>!txtSearch.Locked()

' Multiline cursor/line properties (TextBoxM)
V.Screen.<Form>!txtNotes.CurrentLine()
V.Screen.<Form>!txtNotes.CurrentColumn()
V.Screen.<Form>!txtNotes.LineCount()

' Numeric range (TextBox / TextBoxR only -- not TextBoxM)
V.Screen.<Form>!txtQty.Min()
V.Screen.<Form>!txtQty.Max()
V.Screen.<Form>!txtQty.UseLayout()
```

Full list (TextBox / TextBoxR): Alignment, Anchor, BackColor, BorderStyle, ControlType, CurrentColumn, CurrentLine, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, LineCount, Locked, Max, MaxLength, MetaData0-9, Min, SelectedText, SelLength, SelStart, SelText, TabIndex, TabStop, Text, ToolTip, Top, UseLayout, Visible, Width, WindowHandle.

Full list (TextBoxM): Alignment, Anchor, BackColor, BorderStyle, ControlType, CurrentColumn, CurrentLine, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, LineCount, Locked, MaxLength, MetaData0-9, SelectedText, SelLength, SelStart, SelText, TabIndex, TabStop, Text, ToolTip, Top, Visible, Width, WindowHandle.

#### Web Browser (legacy) V.Screen Properties

Properties for the legacy `web` control type (created with `Create(WebBrowser)`). For the newer GsWebBrowser, see below.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Busy()` | Boolean | True if the browser is currently loading/navigating |
| `.LocationName()` | String | Title/name of the current document |
| `.LocationURL()` | String | URL of the currently loaded page |

```
V.Screen.<Form>!web1.Busy()
V.Screen.<Form>!web1.LocationName()
V.Screen.<Form>!web1.LocationURL()
```

#### GsWebBrowser V.Screen Properties

Properties specific to the `GsWebBrowser` control. This is a distinct property set from the legacy web browser.

| Property | Returns | Description |
|----------|---------|-------------|
| `.IsLoading()` | Boolean | True if the browser is currently loading a page |
| `.IsReady()` | Boolean | True if the browser has finished loading and is ready for interaction |
| `.LocationUrl()` | String | URL of the currently loaded page |
| `.ZoomFactor()` | Float | Current zoom level of the browser |

```
V.Screen.<Form>!gsWebBrowser.LocationUrl()
V.Screen.<Form>!gsWebBrowser.IsLoading()
V.Screen.<Form>!gsWebBrowser.IsReady()
V.Screen.<Form>!gsWebBrowser.ZoomFactor()
```

#### HtmlContainer V.Screen Properties

Properties for the `htmlcontainer` control type (created with `Create(HtmlContainer)`). Similar to the legacy Web Browser, it exposes browser-related properties (Busy, LocationName, LocationURL) plus Path. Reduced set: no Caption, Text, ToolTip, Locked, InternationalID, ExcludeFromUndo, AutoEllipsis, AutoSize.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Busy()` | Boolean | True if the container is currently loading/rendering content |
| `.LocationName()` | String | Title/name of the currently loaded document |
| `.LocationURL()` | String | URL of the currently loaded page |
| `.Path()` | String | File path or URL source of the loaded content |

```
V.Screen.<Form>!htmlView.Busy()
V.Screen.<Form>!htmlView.LocationName()
V.Screen.<Form>!htmlView.LocationURL()
V.Screen.<Form>!htmlView.Path()
```

Full list: Anchor, BackColor, BorderStyle, Busy, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, LocationName, LocationURL, MetaData0-9, Path, TabIndex, TabStop, Top, Visible, Width, WindowHandle.

#### Hyperlink V.Screen Properties

The Hyperlink is a clickable text link control. It exposes the full common + common extended property set plus Caption, ImageAlign, InternationalID, Text, and ToolTip -- the same rich set as Button.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Alignment()` | Long | Content alignment |
| `.AutoEllipsis()` | Boolean | Whether text truncation shows ellipsis |
| `.AutoSize()` | Boolean | Whether control auto-sizes to content |
| `.Caption()` | String | Caption/display text of the hyperlink |
| `.ImageAlign(Alignment)` | V.Enum.ImageAlignToText | Image alignment within the control |
| `.InternationalID()` | Long | Translation label ID |
| `.Text()` | String | Text content of the hyperlink |
| `.ToolTip()` | String | Tooltip text |

```
V.Screen.<Form>!link1.Caption()
V.Screen.<Form>!link1.Text()
V.Screen.<Form>!link1.Enabled()
V.Screen.<Form>!link1.Visible()
V.Screen.<Form>!link1.ToolTip()
V.Screen.<Form>!link1.ImageAlign()
```

Full list: Alignment, Anchor, AutoEllipsis, AutoSize, BackColor, BorderStyle, Caption, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, ImageAlign, InternationalID, Left, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Visible, Width, WindowHandle.

#### ImageList V.Screen Properties

The ImageList is a **non-visual** component that holds a collection of images for use by other controls (TreeView, ListView, ToolBar, etc.). Because it has no visual representation on the form, it exposes only a minimal property set -- no positional, dimensional, font, color, or visibility properties.

```
V.Screen.<Form>!imgList1.ControlType()
V.Screen.<Form>!imgList1.Hwnd()
V.Screen.<Form>!imgList1.MetaData0()
V.Screen.<Form>!imgList1.WindowHandle()
```

Full list: ControlType, HWnd, MetaData0-9, WindowHandle.

#### KeyLabel V.Screen Properties

The KeyLabel is a label variant that highlights a keyboard shortcut character in a distinct color. It exposes the same property set as a standard Label (Caption, Text, ToolTip, InternationalID, AutoEllipsis, AutoSize) plus the unique `KeyColor()` property.

| Property | Returns | Description |
|----------|---------|-------------|
| `.AutoEllipsis()` | Boolean | Whether text truncation shows ellipsis |
| `.AutoSize()` | Boolean | Whether control auto-sizes to content |
| `.Caption()` | String | Caption/display text |
| `.InternationalID()` | Long | Translation label ID |
| `.KeyColor()` | Long | Color used to highlight the keyboard shortcut character |
| `.KeyDotSize()` | Long,Long | Width and Height of the keyboard shortcut color dot |
| `.Text()` | String | Text content |
| `.ToolTip()` | String | Tooltip text |

```
V.Screen.<Form>!klblOrder.Caption()
V.Screen.<Form>!klblOrder.Text()
V.Screen.<Form>!klblOrder.KeyColor()
V.Screen.<Form>!klblOrder.ToolTip()
V.Screen.<Form>!klblOrder.InternationalID()
```

Full list: Anchor, AutoEllipsis, AutoSize, BackColor, Caption, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, KeyColor, Left, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Visible, Width, WindowHandle.

#### Label V.Screen Properties

The Label is a standard text display control. It exposes the full common + common extended property set plus Alignment, Caption, ImageAlign, InternationalID, Text, and ToolTip. Unlike Hyperlink and Button, it does **not** have BorderStyle.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Alignment()` | Long | Content alignment |
| `.AutoEllipsis()` | Boolean | Whether text truncation shows ellipsis |
| `.AutoSize()` | Boolean | Whether control auto-sizes to content |
| `.Caption()` | String | Caption/display text |
| `.ImageAlign(Alignment)` | V.Enum.ImageAlignToText | Image alignment within the control |
| `.InternationalID()` | Long | Translation label ID |
| `.Text()` | String | Text content |
| `.ToolTip()` | String | Tooltip text |

```
V.Screen.<Form>!lblStatus.Caption()
V.Screen.<Form>!lblStatus.Text()
V.Screen.<Form>!lblStatus.Visible()
V.Screen.<Form>!lblStatus.ForeColor()
V.Screen.<Form>!lblStatus.ToolTip()
```

Full list: Alignment, Anchor, AutoEllipsis, AutoSize, BackColor, Caption, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, ImageAlign, InternationalID, Left, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Visible, Width, WindowHandle.

#### Tab V.Screen Properties

The Tab control provides tabbed page navigation. It exposes common base properties plus several unique properties. No BorderStyle, Locked, ExcludeFromUndo, AutoEllipsis, or AutoSize.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Caption` | String | Caption text of the tab control |
| `.InternationalID` | Long | Translation label ID |
| `.Tab` | Long | Index of the currently selected tab |
| `.Text` | String | Text content |
| `.ToolTip` | String | Tooltip text |
| `.UseLayout` | Boolean | Whether layout persistence is enabled |

```
V.Screen.<Form>!tab1.Tab
V.Screen.<Form>!tab1.Caption
V.Screen.<Form>!tab1.Text
V.Screen.<Form>!tab1.UseLayout
V.Screen.<Form>!tab1.ToolTip
V.Screen.<Form>!tab1.Visible
V.Screen.<Form>!tab1.Enabled
```

Full list: Anchor, BackColor, Caption, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, MetaData0-9, Tab, TabIndex, TabStop, Text, ToolTip, Top, UseLayout, Visible, Width, WindowHandle.

#### DockPanel V.Screen Properties

The DockPanel is a DevExpress-style docking panel container. It has unique properties for querying docked/undocked dimensions and layout state.

| Property | Returns | Description |
|----------|---------|-------------|
| `.DockedWidth()` | Long | Width of the panel when docked |
| `.DockedHeight()` | Long | Height of the panel when docked |
| `.DockPosition()` | Long | **Obsolete.** Dock position value |
| `.UndockedWidth()` | Long | Width of the panel when floating (undocked) |
| `.UndockedHeight()` | Long | Height of the panel when floating (undocked) |
| `.UseLayout()` | Boolean | Whether layout persistence is enabled |
| `.Visibility()` | Long | Panel visibility state (see `V.Enum.Visibility`: Visible, AutoHide, Hidden) |

```
V.Screen.<Form>!dockPanel1.Caption()
V.Screen.<Form>!dockPanel1.Visibility()
V.Screen.<Form>!dockPanel1.DockedWidth()
V.Screen.<Form>!dockPanel1.DockedHeight()
V.Screen.<Form>!dockPanel1.UndockedWidth()
V.Screen.<Form>!dockPanel1.UndockedHeight()
V.Screen.<Form>!dockPanel1.UseLayout()
V.Screen.<Form>!dockPanel1.Dock()
```

Full list: Caption, ControlType, CurrentX, CurrentY, Dock, DockedWidth, DockedHeight, DockPosition (obsolete), Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, UndockedHeight, UndockedWidth, UseLayout, Visibility, Visible, Width, WindowHandle.

#### Directory V.Screen Properties

The Directory control is a file-system listing control. It exposes a reduced set of common properties (no Anchor, AutoEllipsis, Caption, ControlType, CurrentX/Y, Dock, ExcludeFromUndo, Focused, FontName, FontSize, Locked, Text, WindowHandle) plus list-style and path properties.

| Property | Returns | Description |
|----------|---------|-------------|
| `.ItemData()` | String | Bound data value of the selected directory entry |
| `.List()` | String | Text of the selected directory entry |
| `.ListCount()` | Long | Total number of directory entries listed |
| `.ListIndex()` | Long | Zero-based index of the selected entry (-1 if none) |
| `.Path()` | String | Current directory path |

```
V.Screen.<Form>!dir1.Path()
V.Screen.<Form>!dir1.ListCount()
V.Screen.<Form>!dir1.ListIndex()
V.Screen.<Form>!dir1.List()
V.Screen.<Form>!dir1.ItemData()
```

Full list: BackColor, BorderStyle, Enabled, ForeColor, Height, HWnd, ItemData, Left, List, ListCount, ListIndex, MetaData0-9, Path, TabIndex, TabStop, ToolTip, Top, Visible, Width.

#### MonthView V.Screen Properties

The MonthView is a calendar date picker control. It exposes common base properties plus `Value()` for the selected date, `SelStart()` for the selection position, and `Locked()`.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Locked()` | Boolean | Whether the control is locked (read-only) |
| `.SelStart()` | Long | Starting position of the selection |
| `.Value()` | String | Current selected date value |

```
V.Screen.<Form>!monthView1.Value()
V.Screen.<Form>!monthView1.SelStart()
V.Screen.<Form>!monthView1.Locked()
V.Screen.<Form>!monthView1.Enabled()
V.Screen.<Form>!monthView1.Visible()
```

Full list: Anchor, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, FontName, FontSize, ForeColor, Height, HWnd, Left, Locked, MetaData0-9, SelStart, TabIndex, TabStop, Top, Value, Visible, Width, WindowHandle.

#### Option (Radio Button) V.Screen Properties [DEPRECATED]

> **DEPRECATED:** The Option (Radio Button) control is deprecated. Use DropDownList, ComboBox, GsToggleSwitch, or CheckBox instead depending on the use case.

The Option control is a radio button for mutually exclusive choices within a group. It exposes the full common + common extended property set plus Caption, Text, InternationalID, Value, and a parameterized `AutoSize(Value)`.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Alignment()` | Long | Content alignment |
| `.AutoEllipsis()` | Boolean | Whether text truncation shows ellipsis |
| `.AutoSize(Value)` | Long | Auto-size state; accepts a Long argument |
| `.Caption()` | String | Caption/display text |
| `.ExcludeFromUndo()` | Boolean | Whether excluded from undo tracking |
| `.InternationalID()` | Long | Translation label ID |
| `.Locked()` | Boolean | Whether the control is locked (read-only) |
| `.Text()` | String | Text content |
| `.ToolTip()` | String | Tooltip text |
| `.Value()` | Long | Current value (selected state) |

```
V.Screen.<Form>!optName.Value()
V.Screen.<Form>!optName.Caption()
V.Screen.<Form>!optName.Text()
V.Screen.<Form>!optName.Enabled()
V.Screen.<Form>!optName.Visible()
V.Screen.<Form>!optName.Locked()
V.Screen.<Form>!optName.ToolTip()

' AutoSize with argument
V.Local.iVal.Declare(Long)
V.Local.iVal.Set(V.Screen.<Form>!optName.AutoSize(V.Local.iVal))
```

Full list: Alignment, Anchor, AutoEllipsis, AutoSize(Value), BackColor, Caption, ControlType, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, FontName, FontSize, ForeColor, Height, HWnd, InternationalID, Left, Locked, MetaData0-9, TabIndex, TabStop, Text, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### PictureBox V.Screen Properties

The PictureBox displays images and can act as a drawing surface or clickable region. It exposes a reduced property set compared to text controls -- no Caption, Text, FontName, FontSize, ForeColor, InternationalID, ExcludeFromUndo, AutoEllipsis, or AutoSize. It does have `Locked()` and `ToolTip()`.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Locked()` | Boolean | Whether the control is locked (read-only) |
| `.ToolTip()` | String | Tooltip text |

```
V.Screen.<Form>!picLogo.Visible()
V.Screen.<Form>!picLogo.Enabled()
V.Screen.<Form>!picLogo.Locked()
V.Screen.<Form>!picLogo.ToolTip()
V.Screen.<Form>!picLogo.Height()
V.Screen.<Form>!picLogo.Width()
```

Full list: Anchor, BackColor, BorderStyle, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, Height, HWnd, Left, Locked, MetaData0-9, TabIndex, TabStop, ToolTip, Top, Visible, Width, WindowHandle.

#### ProgressBar V.Screen Properties

The ProgressBar displays a visual indicator of operation progress. It exposes a reduced property set -- no BackColor, BorderStyle, Caption, Text, FontName, FontSize, ForeColor, Locked, InternationalID, ExcludeFromUndo, AutoEllipsis, or AutoSize. It has unique progress-specific properties: `Min()`, `Max()`, `Value()`, and `Scrolling()`.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Max()` | Long | Maximum value of the progress range |
| `.Min()` | Long | Minimum value of the progress range |
| `.Scrolling()` | Long | Scrolling/animation style of the progress bar |
| `.ToolTip()` | String | Tooltip text |
| `.Value()` | Long | Current progress value |

```
V.Screen.<Form>!progressBar1.Value()
V.Screen.<Form>!progressBar1.Min()
V.Screen.<Form>!progressBar1.Max()
V.Screen.<Form>!progressBar1.Scrolling()
V.Screen.<Form>!progressBar1.Visible()
V.Screen.<Form>!progressBar1.Enabled()
V.Screen.<Form>!progressBar1.ToolTip()
```

Full list: Anchor, ControlType, CurrentX, CurrentY, Dock, Enabled, Focused, Height, HWnd, Left, Max, MetaData0-9, Min, Scrolling, TabIndex, TabStop, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### ProgressPanel V.Screen Properties

The ProgressPanel is a DevExpress-style overlay panel that displays a loading/progress indicator with descriptive text. It exposes the common base properties plus several unique font and detail properties for styling its multi-line display.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Caption()` | String | Primary caption text displayed on the panel |
| `.Detail()` | String | Secondary detail/description text |
| `.FontSizeDelta()` | Long | Font size delta offset from default |
| `.FontSizeDetail()` | Float | Font size for the detail text |
| `.FontStyle()` | Long | Font style for the caption (bold, italic, etc.) |
| `.FontStyleDetail()` | Long | Font style for the detail text |
| `.InternationalID()` | Long | Translation label ID |
| `.Offset()` | Long | Offset value for panel positioning |
| `.Text()` | String | Text content |
| `.ToolTip()` | String | Tooltip text |

```
V.Screen.<Form>!progressPanel1.Caption()
V.Screen.<Form>!progressPanel1.Detail()
V.Screen.<Form>!progressPanel1.Text()
V.Screen.<Form>!progressPanel1.FontStyle()
V.Screen.<Form>!progressPanel1.FontStyleDetail()
V.Screen.<Form>!progressPanel1.FontSizeDelta()
V.Screen.<Form>!progressPanel1.FontSizeDetail()
V.Screen.<Form>!progressPanel1.Offset()
V.Screen.<Form>!progressPanel1.Visible()
```

Full list: Anchor, BackColor, BorderStyle, Caption, ControlType, CurrentX, CurrentY, Detail, Dock, Enabled, Focused, FontName, FontSize, FontSizeDelta, FontSizeDetail, FontStyle, FontStyleDetail, ForeColor, Height, Hwnd, InternationalID, Left, MetaData0-9, Offset, TabIndex, TabStop, Text, ToolTip, Top, Visible, Width, WindowHandle.

#### Slider V.Screen Properties

The Slider (trackbar) allows users to select a value within a range by dragging a thumb. It exposes a reduced property set -- no Caption, Text, FontName, FontSize, ForeColor, BorderStyle, InternationalID, AutoEllipsis, or AutoSize. It has range-specific properties `Min()`, `Max()`, and `Value()`, plus `ExcludeFromUndo()`, `Locked()`, and `ToolTip()`.

| Property | Returns | Description |
|----------|---------|-------------|
| `.ExcludeFromUndo()` | Boolean | Whether excluded from undo tracking |
| `.Locked()` | Boolean | Whether the control is locked (read-only) |
| `.Max()` | Long | Maximum value of the slider range |
| `.Min()` | Long | Minimum value of the slider range |
| `.ToolTip()` | String | Tooltip text |
| `.Value()` | Long | Current slider position value |

```
V.Screen.<Form>!sld1.Value()
V.Screen.<Form>!sld1.Min()
V.Screen.<Form>!sld1.Max()
V.Screen.<Form>!sld1.Locked()
V.Screen.<Form>!sld1.ExcludeFromUndo()
V.Screen.<Form>!sld1.ToolTip()
V.Screen.<Form>!sld1.Enabled()
V.Screen.<Form>!sld1.Visible()
```

Full list: Anchor, BackColor, ControlType, CurrentX, CurrentY, Dock, Enabled, ExcludeFromUndo, Focused, Height, HWnd, Left, Locked, Max, MetaData0-9, Min, TabIndex, TabStop, ToolTip, Top, Value, Visible, Width, WindowHandle.

#### SplitContainer V.Screen Properties

The SplitContainer divides a form area into two resizable panels separated by a splitter bar. It exposes a reduced property set -- no Caption, Text, FontName, FontSize, ForeColor, BorderStyle, InternationalID, ExcludeFromUndo, AutoEllipsis, or AutoSize. It has several unique layout-specific properties.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Collapsed()` | Boolean | Whether the collapsible panel is currently collapsed |
| `.CollapsiblePanel()` | Long | Which panel is collapsible (0=None, 1=Panel1, 2=Panel2) |
| `.FixedPanel()` | Long | Which panel has a fixed size during resize (0=None, 1=Panel1, 2=Panel2) |
| `.Locked()` | Boolean | Whether the splitter is locked (cannot be moved) |
| `.Orientation()` | Long | Splitter orientation (0=Vertical, 1=Horizontal) |
| `.SplitterPosition()` | Long | Current position of the splitter bar in pixels/twips |
| `.ToolTip()` | String | Tooltip text |
| `.UseLayout()` | Boolean | Whether layout persistence is enabled |

```
V.Screen.<Form>!SplitContainer1.SplitterPosition()
V.Screen.<Form>!SplitContainer1.Collapsed()
V.Screen.<Form>!SplitContainer1.CollapsiblePanel()
V.Screen.<Form>!SplitContainer1.FixedPanel()
V.Screen.<Form>!SplitContainer1.Orientation()
V.Screen.<Form>!SplitContainer1.UseLayout()
V.Screen.<Form>!SplitContainer1.Locked()
V.Screen.<Form>!SplitContainer1.Visible()
```

Full list: Anchor, BackColor, Collapsed, CollapsiblePanel, ControlType, CurrentX, CurrentY, Dock, Enabled, FixedPanel, Focused, Height, Hwnd, Left, Locked, MetaData0-9, Orientation, SplitterPosition, TabIndex, TabStop, ToolTip, Top, UseLayout, Visible, Width, WindowHandle.

#### Timer V.Screen Properties

The Timer is a **non-visual** component that fires events at a set interval. It has a minimal property set -- no positional, dimensional, font, color, or visibility properties. Its unique property is `Interval()`.

| Property | Returns | Description |
|----------|---------|-------------|
| `.Enabled()` | Boolean | Whether the timer is currently running |
| `.Interval()` | Long | Timer interval in milliseconds |

```
V.Screen.<Form>!tmrRefresh.Enabled()
V.Screen.<Form>!tmrRefresh.Interval()
V.Screen.<Form>!tmrRefresh.ControlType()
```

Full list: ControlType, Enabled, Hwnd, Interval, MetaData0-9, WindowHandle.

## Form Runtime Methods — Usage Examples

> For the complete property/method reference, see **Common Form Properties & Methods** under Form Creation. This section shows usage patterns only.

```
' Lifecycle
Gui.<Form>..Show
Gui.<Form>..Close
Gui.<Form>..Visible(False)                     ' Hide form (used in UnLoad to hide instead of destroy)
Gui.<Form>..Enabled(False)                     ' Disable form (modal dialog pattern)
Gui.<Form>..WaitForDismiss                     ' Block execution until this form is closed
Gui.<Form>..SetFocus                           ' Set focus (no args)
Gui.<Form>..SetFocus(True)                     ' Set focus (explicit)
Gui.<Form>..WindowState(2)                     ' 0=Normal, 1=Minimized, 2=Maximized

' SetIcon — file path or enum sources
Gui.<Form>..Icon(sPath)                                            ' From file path string
Gui.<Form>..SetIcon("C:\path\icon.ico")                            ' From file path
Gui.<Form>..SetIcon(V.Enum.FormIconApplication!SupplyAndDemand)    ' Application descriptor
Gui.<Form>..SetIcon(V.Enum.FormIconLogo!GssIcon)                   ' GSS logo
Gui.<Form>..SetIcon(V.Enum.FormIconModule!Accounting)              ' Module icon
Gui.<Form>..SetIcon(V.Enum.FormIconMsgBox!Error)                   ' Message box icon
Gui.<Form>..SetIcon(V.Enum.FormIconWidget!CompletedProjects)       ' Widget icon

' Form-level Serialization (persist entire form layout, not just grid)
Gui.<Form>..Serialize(V.Local.sLayout)
Gui.<Form>..Deserialize(V.Local.sLayout)

' Wait/Progress dialog
Gui.<Form>..InvokeWait("Loading...", "Please Wait")
Gui.<Form>..UpdateWait("50% complete", "Processing")
Gui.<Form>..HideWait

' DialogForm-specific
Gui.<Form>..Prompt("Enter your selection:")
Gui.<Form>..DialogStyle(V.Enum.MsgBoxStyle!OKCancel)
Gui.<Form>..HasPrompt(True)
Gui.<Form>..CloseOnSelection(True)
```

For DashForm/DialogForm toolbar methods (BarSaveButton, BarHelpButton, BarSearchBox, BarShareButton, BarUndoButtons, ClearUndo, BarAddButton, BarAddTextBox, BarAddComboBox, BarRemove*, WhatsNew), see the **DashForm-Only Toolbar Properties** and **Dashboard and Dialog Form Toolbar** sections under Form Creation.

```
' BarToggleButton (adds a toggle switch to the form toolbar -- DashForm)
Gui.<Form>..BarToggleButton(True,"Caption Text",True,2,"Tahoma",12,True,"White")
Gui.<Form>..Event(ToggleStateChanged,Form_ToggleStateChanged)
```
ToggleStateChanged handler receives the standard 3 args plus: `V.Args.TOGGLENAME` (String, e.g. "BarToggle"), `V.Args.TOGGLED` (Boolean)

## Alert System (Non-Blocking Popups)

The Alert System shows non-blocking popup messages to the user without freezing the UI thread. Alerts are bound to a **visible form** -- they will not display if the form is hidden. Both Base Form and Dashboard Form are supported.

`ShowAlert` and `UpdateAlert` are aliases for the same function: it creates the alert if the AlertID doesn't exist yet, or updates it if already shown.

### Functions
```
' Show or create an alert (all params after Text are optional)
Gui.<Form>..ShowAlert(AlertID, Caption, Text, [SvgImage], [SvgWidth], [SvgHeight], [Image], [AutoCloseFormOnClick], [ProgressMode], [ProgressMin], [ProgressMax], [ProgressValue], [ShowPercentage], [ProgressVisible], [DurationInMS], [Pinned])

' Alias -- identical behavior to ShowAlert
Gui.<Form>..UpdateAlert(AlertID, Caption, Text, [SvgImage], [SvgWidth], [SvgHeight], [Image], [AutoCloseFormOnClick], [ProgressMode], [ProgressMin], [ProgressMax], [ProgressValue], [ShowPercentage], [ProgressVisible], [DurationInMS], [Pinned])

' Update specific properties on an already-shown alert (variadic name/value pairs)
Gui.<Form>..UpdateAlertProperty(AlertID, PropertyName1, PropertyValue1, ..., PropertyNameN, PropertyValueN)

' Hide/close a shown alert
Gui.<Form>..HideAlert(AlertID)
```

### ShowAlert / UpdateAlert Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| AlertID | String | (required) | Unique ID for the alert. Reusable once hidden. |
| Caption | String | (required) | Title text on the alert. |
| Text | String | (required) | Detail/clickable text on the alert. |
| SvgImage | V.Enum.Image | (none) | SVG icon at top-left, re-colored to match alert theme. Overrides Image. |
| SvgWidth | Long | 24 | Width of the SvgImage. |
| SvgHeight | Long | 24 | Height of the SvgImage. |
| Image | String | Nothing | Non-SVG image at top-left (max size determined by control). Overridden by SvgImage. |
| AutoCloseFormOnClick | Boolean | False | If True, closes the form when the alert is clicked. |
| ProgressMode | V.Enum.AlertProgressModes | None | Progress bar mode: `None`, `Progress`, or `Marquee`. |
| ProgressMin | Long | 0 | Minimum value of progress bar. |
| ProgressMax | Long | 100 | Maximum value of progress bar. |
| ProgressValue | Long | 0 | Current value of progress bar. |
| ShowPercentage | Boolean | False | Show percentage text (e.g. "46%") on the bar. |
| ProgressVisible | Boolean | True | Whether the progress bar is visible. |
| DurationInMS | Long | 5000 | Auto-close duration in milliseconds (ignored when Pinned). |
| Pinned | Boolean | False | If True, alert stays until explicitly hidden. |

### UpdateAlertProperty -- V.Enum.AlertPropertyNames
Use `UpdateAlertProperty` to change one or more properties on a shown alert without resupplying all values:
```
V.Enum.AlertPropertyNames!Caption
V.Enum.AlertPropertyNames!Text
V.Enum.AlertPropertyNames!SvgImage
V.Enum.AlertPropertyNames!SvgImageWidth
V.Enum.AlertPropertyNames!SvgImageHeight
V.Enum.AlertPropertyNames!Image
V.Enum.AlertPropertyNames!AutoCloseOnClick
V.Enum.AlertPropertyNames!ProgressMode
V.Enum.AlertPropertyNames!Min
V.Enum.AlertPropertyNames!Max
V.Enum.AlertPropertyNames!Value
V.Enum.AlertPropertyNames!ShowPercentage         ' maps to ProgressShowPercentage
V.Enum.AlertPropertyNames!ProgressVisible
V.Enum.AlertPropertyNames!DurationInMs
V.Enum.AlertPropertyNames!Pinned
```

### Alert Events
| Event | V.Args | Description |
|-------|--------|-------------|
| `AlertClick` | `V.Args.ALERTID` (String), `V.Args.ALERTTEXT` (String) | Raised when user clicks the alert text. |

Handler naming convention: `<FormName>_AlertClick`

### Alert Example
```
Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels

V.Local.i.Declare(Long)

Gui.Form..Show

' Show a basic alert with caption, text, and icon
Gui.Form..ShowAlert("myAlert","Caption","Put some of that sweet, sweet alert text here.",V.Enum.Image!BUG_BLACK)

' Pin it so it doesn't auto-close
Gui.Form..UpdateAlertProperty("myAlert","Pinned",True)

' Update caption, progress mode, and icon in one call
Gui.Form..UpdateAlertProperty("myAlert",V.Enum.AlertPropertyNames!Caption,"New Caption",V.Enum.AlertPropertyNames!ProgressMode,V.Enum.AlertProgressModes!Marquee,V.Enum.AlertPropertyNames!SvgImage,V.Enum.Image!ATTACH_BLACK)

F.Intrinsic.UI.SleepMS(2000)

' Switch from marquee to determinate progress bar
Gui.Form..UpdateAlertProperty("myAlert",V.Enum.AlertPropertyNames!ProgressMode,V.Enum.AlertProgressModes!Progress,V.Enum.AlertPropertyNames!Min,0,V.Enum.AlertPropertyNames!Max,100)

' Animate progress 0-100
F.Intrinsic.Control.For(V.Local.i,0,100,1)
    Gui.Form..UpdateAlertProperty("myAlert",V.Enum.AlertPropertyNames!Value,V.Local.i)
    F.Intrinsic.UI.SleepMS(50)
F.Intrinsic.Control.Next(V.Local.i)

' Done -- hide it
Gui.Form..HideAlert("myAlert")
Program.Sub.Main.End

Program.Sub.Form_AlertClick.Start
F.Intrinsic.UI.Msgbox(V.Args.ALERTID,"You Clicked")
Program.Sub.Form_AlertClick.End
```

## Event Types Reference

All events are registered with `.Event(EventType,HandlerSubName)`:
| Event | Applicable Controls |
|-------|-------------------|
| `Click` | Form, Button, Label, CheckBox, ComboBox, DatePicker, DateTimeOffset, DropDownList, FlowFrame, Frame, Hyperlink, ListView, ListBox, NavPage, PictureBox, Slider, SplitContainer, Tab, TextBox, TextBoxR, TreeView, GsCardView, BarDock |
| `DoubleClick` | TreeView |
| `DblClick` | Form, FlowFrame, Frame, Grid, Label, ListView, ListBox, PictureBox, SplitContainer, Tab, TextBox, TextBoxR, TreeView, BarDock |
| `Change` | CheckBox, ComboBox, DatePicker, DateTimeOffset, TextBox, TextBoxR, DropDownList, MonthView, Slider |
| `SelectedIndexChanged` | DropDownList, ComboBox, ListBox |
| `DropDown` | ComboBox, DropDownList |
| `DropDownClosed` | ComboBox, DropDownList |
| `GotFocus` | Form, Button, CheckBox, ComboBox, DatePicker, DateTimeOffset, FlowFrame, Frame, TextBox, TextBoxR, DropDownList, GsGridControl, GsAdvBandedGridControl, ListBox, MonthView, PictureBox, Slider, Tab, TreeView, GsCardView, GsChart, most controls |
| `LostFocus` | Form, Button, CheckBox, ComboBox, DatePicker, DateTimeOffset, FlowFrame, Frame, TextBox, TextBoxR, DropDownList, GsGridControl, GsAdvBandedGridControl, ListBox, MonthView, PictureBox, Slider, Tab, TreeView, GsCardView, GsChart, most controls |
| `KeyPress` | Form, TextBox, TextBoxR, ComboBox, GsGridControl, GsAdvBandedGridControl |
| `KeyPressEnter` | TextBox, GsGridControl, GsAdvBandedGridControl |
| `MouseDown` | Form, AccordionControl, Button, CheckBox, ComboBox, DatePicker, DropDownList, FlowFrame, Frame, GsGridControl, GsAdvBandedGridControl, Hyperlink, Label, ListBox, MonthView, NavPage, Slider, SplitContainer, Tab, TextBox, TextBoxR, TreeView, GsCardView, GsChart, PictureBox, BarDock, most controls |
| `MouseUp` | Form, AccordionControl, Button, CheckBox, ComboBox, DatePicker, DropDownList, FlowFrame, Frame, GsGridControl, GsAdvBandedGridControl, Hyperlink, Label, ListBox, MonthView, NavPage, PictureBox, Slider, SplitContainer, Tab, TextBox, TextBoxR, TreeView, GsCardView, GsChart, BarDock, most controls |
| `MouseClick` | AccordionControl, Button, CheckBox, ComboBox, DatePicker, DropDownList, FlowFrame, Frame, Hyperlink, Label, ListBox, MonthView, NavPage, PictureBox, Slider, SplitContainer, Tab, TextBox, TextBoxR, TreeView, Grid, BarDock, most controls |
| `MouseMove` | Form, AccordionControl, Button, CheckBox, ComboBox, DatePicker, DropDownList, FlowFrame, Frame, GsGridControl, GsAdvBandedGridControl, Hyperlink, Label, ListBox, MonthView, NavPage, Slider, SplitContainer, Tab, TextBox, TextBoxR, TreeView, GsCardView, GsChart, PictureBox, BarDock |
| `MouseHover` | CheckBox |
| `MouseCellEnter` | GsGridControl, GsAdvBandedGridControl |
| `MouseCellExit` | GsGridControl, GsAdvBandedGridControl |
| `RowCellClick` | GsGridControl, GsAdvBandedGridControl |
| `RowClick` | GsGridControl, GsAdvBandedGridControl |
| `CellValueChanged` | GsGridControl, GsAdvBandedGridControl |
| `FocusedRowChanged` | GsGridControl, GsAdvBandedGridControl |
| `ColumnFilterChanged` | GsGridControl, GsAdvBandedGridControl |
| `ColumnPositionChanged` | GsGridControl, GsAdvBandedGridControl |
| `ColumnSortingChanged` | GsGridControl |
| `NodeClick` | TreeView |
| `NodeDoubleClick` | TreeView |
| `DragDropFile` | TreeView |
| `SelectionMade` | GsLookUpControl, GsRepositoryLookup, Lookup |
| `ElementClick` | AccordionControl |
| `BorderButtonClick` | Frame |
| `ButtonClicked` | BarDock |
| `ComboBoxEditValueChange` | BarDock |
| `ComboBoxSelectedIndexChanged` | BarDock |
| `Drop` | Form, NavPage, TextBox, BarDock |
| `TextBoxEditValueChanged` | BarDock |
| `ItemClick` | BarDock |
| `Scroll` | Slider |
| `Toggled` | GsToggleSwitch |
| `ToggleStateChanged` | Form (BarToggleButton) |
| `Timer` | Timer |
| `UnLoad` | Form |
| `Activate` | Form (window activated/brought to front) |
| `Deactivate` | Form (window deactivated/lost foreground) |
| `DragDrop` | GsChart |
| `Resize` | Form, SplitContainer, GsChart |
| `SplitterMoved` | SplitContainer |
| `Panel1Click` / `Panel2Click` | SplitContainer (see SplitContainer Events Detail) |
| `Panel1DblClick` / `Panel2DblClick` | SplitContainer (see SplitContainer Events Detail) |
| `OLEDragDrop` | ListView |
| `UrlChanged` | GsWebBrowser, GsWebView2 |
| `RefreshClick` | Custom toolbar |
| `ExportClick` | Custom toolbar |
| `PrintClick` | Custom toolbar |
| `SaveButtonClick` | DashForm toolbar |
| `SaveAllButtonClick` | DashForm toolbar |
| `UserButtonClicked` | DashForm/DialogForm custom bar buttons |
| `UserTextBoxEditValueChanged` | DashForm/DialogForm custom bar textboxes |
| `UserComboBoxEditValueChanged` | DashForm/DialogForm custom bar comboboxes |
| `UserComboBoxSelectedIndexChanged` | DashForm/DialogForm custom bar comboboxes |
| `ShareButtonClick` | DashForm toolbar (Share menu opened) |
| `ShareEmailClick` | DashForm toolbar (Email in Share menu) |
| `ShareChatClick` | DashForm toolbar (Chat in Share menu) |
| `ShareImageClick` | DashForm toolbar (Screenshot in Share menu) |
| `SharePrintClick` | DashForm toolbar (Print in Share menu) |
| `HelpButtonClick` | DashForm toolbar (Help menu opened) |
| `PerformSearch` | DashForm toolbar (SearchBox) |
| `UndoButtonClick` | DashForm toolbar (OCTSRS handles undo) |
| `RedoButtonClick` | DashForm toolbar (OCTSRS handles redo) |
| `ResetButtonClick` | DashForm toolbar (OCTSRS handles reset) |
| `PageAdded` | NavFrame |
| `PageRemoved` | NavFrame |
| `SelectedPageChanging` | NavFrame |
| `SelectedPageChanged` | NavFrame |
| `RefreshRequested` | Dashboard/viewer, Lookup |
| `AlertClick` | Form (Alert System) |

### DashForm Toolbar Events Detail

All DashForm toolbar events receive these standard V.Args:

| V.Args | Type | Value |
|--------|------|-------|
| `V.Args.EVENTSOURCE` | String | `"FORM"` |
| `V.Args.SCREEN` | String | `"FORM"` (the form name) |
| `V.Args.EVENTTYPE` | String | The event name in uppercase (e.g. `"SAVEBUTTONCLICK"`, `"PERFORMSEARCH"`) |

#### Save Events
- `SaveButtonClick` -- Save button clicked (EVENTTYPE = `"SAVEBUTTONCLICK"`)
- `SaveAllButtonClick` -- Save All button clicked (EVENTTYPE = `"SAVEALLBUTTONCLICK"`)

#### Share Events
- `ShareButtonClick` -- Share menu opened (EVENTTYPE = `"SHAREBUTTONCLICK"`)
- `ShareEmailClick` -- Email button in Share menu (EVENTTYPE = `"SHAREEMAILCLICK"`)
- `ShareChatClick` -- Chat button in Share menu (live chat not currently supported)
- `ShareImageClick` -- Image button in Share menu (copies a screenshot)
- `SharePrintClick` -- Printer button in Share menu

#### Help Events
- `HelpButtonClick` -- Help menu opened. All help menu functions are handled by OCTSRS.

#### Search Events
- `PerformSearch` -- SearchBox value submitted (user hits Enter or clicks button) (EVENTTYPE = `"PERFORMSEARCH"`)
  - `V.Args.QUERY` (String) -- the search text (4 total args)

#### Undo Events (OCTSRS handles the actual operations)
- `UndoButtonClick` -- Undo clicked
- `RedoButtonClick` -- Redo clicked
- `ResetButtonClick` -- Reset clicked

#### Export / Print / Refresh Events
- `ExportClick` -- Export button clicked
- `PrintClick` -- Print button clicked
- `RefreshClick` -- Refresh button clicked

#### Toggle Events
- `ToggleStateChanged` -- BarToggleButton state changed (EVENTTYPE = `"TOGGLESTATECHANGED"`)
  - `V.Args.TOGGLENAME` (String) -- name of the toggle (e.g. `"BarToggle"`)
  - `V.Args.TOGGLED` (Boolean) -- new toggle state (`True`/`False`)

#### Custom Bar Item Events
- `UserButtonClicked` -- any custom bar button clicked
  - `V.Args.Button` (String) -- name of the button
- `UserTextBoxEditValueChanged` -- any custom bar textbox value changed
  - `V.Args.TextBox` (String) -- name of the textbox
  - `V.Args.Text` (String) -- the text value
- `UserComboBoxEditValueChanged` -- any custom bar combobox value edited
- `UserComboBoxSelectedIndexChanged` -- any custom bar combobox selection changed

### NavFrame Events Detail

| Event | V.Args | Description |
|-------|--------|-------------|
| `PageAdded` | `V.Args.Page` (String) | A NavPage was added to the NavFrame |
| `PageRemoved` | `V.Args.Page` (String) | A NavPage was removed from the NavFrame |
| `SelectedPageChanging` | `V.Args.PAGE` (String), `V.Args.OLDPAGE` (String) | Page is about to change; PAGE=destination, OLDPAGE=current |
| `SelectedPageChanged` | `V.Args.PAGE` (String), `V.Args.OLDPAGE` (String) | Page changed; PAGE=current, OLDPAGE=previous |

### SplitContainer Events Detail

All panel click events include:
- `V.Args.Panel` (Long) -- panel number (1 or 2)
- `V.Args.Clicks` (Long) -- number of clicks

| Event | Aliases | Description |
|-------|---------|-------------|
| `Panel1Click` | -- | Panel 1 (left/top) clicked |
| `Panel2Click` | -- | Panel 2 (right/bottom) clicked |
| `Panel1DblClick` | `Panel1DoubleClick` | Panel 1 double-clicked |
| `Panel2DblClick` | `Panel2DoubleClick` | Panel 2 double-clicked |

### GsGridControl Events Detail

> ControlType for all events: `"GSGRIDCONTROL"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and are omitted from individual tables below.

#### Grid Event Selection Guidance

Choose the right grid event for the task — production scripts rarely wire all three:

| Event | Use For | V.Args Available |
|-------|---------|-----------------|
| `RowCellClick` | Right-click context menu preparation, cell-level actions | `V.Args.RowHandle`, `V.Args.RowIndex`, `V.Args.Column`, `V.Args.CellValue` |
| `FocusedRowChanged` | Left-click navigation, loading detail data | `V.Args.FocusedRowHandle`, `V.Args.PrevFocusedRowHandle` |
| `CellValueChanged` | Inline editing, value validation | `V.Args.RowHandle`, `V.Args.Column`, `V.Args.Value` |

#### BlockEvents / UnBlockEvents in Grid and WebView2 Handlers

Wrap handler bodies that reload data or navigate to prevent re-entrant event firing. Place `BlockEvents` **after** variable declarations (never before):

```
Program.Sub.gvMain_FocusedRowChanged.Start
F.Intrinsic.Control.SetErrorHandler("gvMain_FocusedRowChanged_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")

F.Intrinsic.Control.BlockEvents
' ... load detail data ...
F.Intrinsic.Control.UnBlockEvents

F.Intrinsic.Control.ExitSub
Program.Sub.gvMain_FocusedRowChanged.End
```

Apply the same pattern in `UrlChanged` handlers for WebView2 — block while parsing hash fragments and calling subs that update the control, then unblock before exit (and in error paths).

#### GotFocus / LostFocus -- 6 args

Fired when the grid control gains or loses focus.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.View` | String | Name of the active gridview (may be empty) |

#### MouseDown / MouseMove / MouseUp -- 14 args

Fired on mouse button press, movement, or release over the grid.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.View` | String | Name of the active gridview (may be empty) |
| `V.Args.MouseRow` | Long | Row index under the mouse (0-based, -1 if not over a row) |
| `V.Args.MouseCol` | Long | Column index under the mouse (-1 if not over a column) |

**Event call chain:** When clicking the grid:
`FORM MouseDown` -> `GsGridControl1_MouseDown` -> `GsGridControl1_LostFocus` -> `GsGridControl1_MouseUp` -> `GsGridControl1_GotFocus` -> `GsGridControl1_MouseMove` (repeats on move)

#### RowClick -- 15 args

Fired when the user clicks on the very left column or beginning of a row.
If the user clicks the collapse/expand button, RowClick fires first, then RowCellClick fires after.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left"/"Right") |
| `V.Args.Clicks` | Long | Click count |
| `V.Args.Delta` | Long | Mouse wheel delta |
| `V.Args.Handled` | Boolean | Whether the event is handled |
| `V.Args.Location` | String | Mouse location string (e.g. "\{X=167,Y=31\}") |
| `V.Args.RowHandle` | Long | Row handle of clicked row |
| `V.Args.RowIndex` | Long | Row index of clicked row |
| `V.Args.IsGroupRow` | Boolean | True if the clicked row is a group row |
| `V.Args.X` | Long | Mouse X coordinate |
| `V.Args.Y` | Long | Mouse Y coordinate |

#### RowCellClick -- 16 args

Fired when the user clicks on a cell. If the user clicks the collapse/expand button, RowClick fires first, then RowCellClick fires after.
When the cell is not editable, the event fires when the user clicks the cell.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left"/"Right") |
| `V.Args.CellValue` | String | Value of the clicked cell |
| `V.Args.Clicks` | Long | Click count |
| `V.Args.Column` | String | Column name of the clicked cell |
| `V.Args.Delta` | Long | Mouse wheel delta |
| `V.Args.Handled` | Boolean | Whether the event is handled |
| `V.Args.Location` | String | Mouse location string (e.g. "\{X=167,Y=31\}") |
| `V.Args.RowHandle` | Long | Row handle of clicked row |
| `V.Args.RowIndex` | Long | Row index of clicked row |
| `V.Args.X` | Long | Mouse X coordinate |
| `V.Args.Y` | Long | Mouse Y coordinate |

#### CellValueChanged -- 9 args

Fired when the value of a cell is changed and focus moves from that cell to another object.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Column` | String | Column name of the changed cell |
| `V.Args.RowHandle` | Long | Row handle of the changed row |
| `V.Args.RowIndex` | Long | Row index of the changed row |
| `V.Args.Value` | String | New cell value |

#### FocusedRowChanged -- 8 args

Fired when the focused row changes.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.PrevFocusedRowHandle` | Long | Visual row index of the previously focused row (not a DataTable row handle) |
| `V.Args.FocusedRowHandle` | Long | Visual row index of the newly focused row (not a DataTable row handle) |
| `V.Args.ColumnName` | String | Name of the focused column |

> **CRITICAL — Filtered Grid Caveat:**  
> `V.Args.FocusedRowHandle` is a **visual row index**, NOT a DataTable row handle.  
> In filtered/sorted grids, it does NOT correspond to the underlying DataTable row.  
> **Use `GetSelectedRows` to obtain the true DataTable row handle** before calling `GetCellValueByColumnName`.  
> Guard: `If(V.Args.FocusedRowHandle,<,0)` — filter-row clicks return sentinel `-2147483646`.  
> See `GRID.md` § "Reading cell values in filtered grids" and `PITFALLS.md`.

#### ColumnFilterChanged -- 11 args

Fired when the filter value of a column is changed.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.ActiveFilterCriteria` | String | Active filter criteria expression (e.g. "[RunnerExperienced] = False") |
| `V.Args.ActiveFilterExpression` | String | Active filter expression string |
| `V.Args.ActiveFilterRowCount` | Long | Number of rows matching the filter |
| `V.Args.GridControlName` | String | Name of the grid control |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.TableName` | String | Name of the bound DataTable |

#### ColumnSortingChanged

Fired when column sorting is changed.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.ActiveSortString` | String | Current sort expression |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.GridControlName` | String | Name of the grid control |
| `V.Args.TableName` | String | Name of the bound DataTable |

#### MouseCellEnter -- 16 args

Fired when the mouse moves into (enters) a cell.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.TableName` | String | Name of the bound DataTable |
| `V.Args.Column` | Long | Column index (0-based) |
| `V.Args.Row` | Long | Row index |
| `V.Args.SourceRowIndex` | Long | Source row index in the underlying DataTable |
| `V.Args.Location` | String | Mouse location string (e.g. "\{X=44,Y=52\}") |
| `V.Args.Delta` | Long | Mouse wheel delta |
| `V.Args.X` | Long | Mouse X coordinate |
| `V.Args.Y` | Long | Mouse Y coordinate |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Click count |

#### MouseCellExit -- 16 args

Fired when the mouse moves out of (exits) a cell. When exiting the grid entirely, Column=-1, Row and SourceRowIndex=-2147483648 (Int32.MinValue).

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.TableName` | String | Name of the bound DataTable |
| `V.Args.Column` | Long | Column index (-1 if exiting grid) |
| `V.Args.Row` | Long | Row index (-2147483648 if exiting grid) |
| `V.Args.SourceRowIndex` | Long | Source row index (-2147483648 if exiting grid) |
| `V.Args.Location` | String | Mouse location string |
| `V.Args.Delta` | Long | Mouse wheel delta |
| `V.Args.X` | Long | Mouse X coordinate |
| `V.Args.Y` | Long | Mouse Y coordinate |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Click count |

#### ColumnPositionChanged -- 9 args

Fired when a column changes its position within its gridview.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.ColumnName` | String | Name of the column |
| `V.Args.ColumnIndex` | Long | Column index |
| `V.Args.ColumnVisibleIndex` | Long | Column visible index (default is -1) |
| `V.Args.GridViewName` | String | Name of the gridview |

#### KeyPress -- 14 args

Fired when a key is pressed within the gridview.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.GridControlName` | String | Name of the grid control |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.ColumnName` | String | Name of the focused column |
| `V.Args.ColumnIndex` | Long | Column index |
| `V.Args.RowHandle` | Long | Row handle |
| `V.Args.RowIndex` | Long | Row index |
| `V.Args.CellValue` | String | Current cell value |
| `V.Args.KeyPress` | Long | Key code of the pressed key |
| `V.Args.Character` | String | Character representation of the pressed key |

#### KeyPressEnter -- 12 args

Fired when the Enter key is pressed within the gridview.

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.GridControlName` | String | Name of the grid control |
| `V.Args.GridViewName` | String | Name of the gridview |
| `V.Args.ColumnName` | String | Name of the focused column |
| `V.Args.ColumnIndex` | Long | Column index |
| `V.Args.RowHandle` | Long | Row handle |
| `V.Args.RowIndex` | Long | Row index |
| `V.Args.CellValue` | String | Current cell value |

### Subtable / Child Gridview Event Remarks

Subtable gridview events are linked to the parent table. When a parent table event fires, use the gridview name to determine which grid (top-level vs child) raised the event and to obtain the correct values.

**Pattern to determine top-level vs child grid:**
```
Gui.F_WipToFg.gsGCWO.GetFocusedGridview(V.Local.sDT)
F.Intrinsic.Control.If(V.Local.sDT.UCase,<>,"DTWO")
  F.Intrinsic.String.Build("dtWO${0}",V.Local.sDT,V.Local.sDT)
F.Intrinsic.Control.EndIf
V.Local.sJob.Set(V.DataTable.[V.Local.sDT](V.Args.RowIndex).Job!FieldValTrim)
V.Local.sSuffix.Set(V.DataTable.[V.Local.sDT](V.Args.RowIndex).Suffix!FieldValTrim)
```

### DropDownList Events Detail

**Syntax:**
```
Gui.<Form>.<ddlName>.Event(EventName, SubName)
```

| Event | Description |
|-------|-------------|
| `Change` | Fires when the selected value changes |
| `Click` | Fires when the control is clicked |
| `DropDown` | Fires when the dropdown list opens |
| `DropDownClosed` | Fires when the dropdown list closes |
| `MouseClick` | Fires on mouse click |
| `MouseDown` | Fires on mouse button down |
| `MouseMove` | Fires on mouse movement over the control |
| `MouseUp` | Fires on mouse button up |
| `SelectedIndexChanged` | Fires when the selected index changes |
| `GotFocus` | Fires when the control receives focus |
| `LostFocus` | Fires when the control loses focus |

**Example:**
```
Gui.frmMain.ddlStatus.Create(DropDownList)
Gui.frmMain.ddlStatus.AddItem("Active")
Gui.frmMain.ddlStatus.AddItem("Inactive")
Gui.frmMain.ddlStatus.ListIndex(0)
Gui.frmMain.ddlStatus.Event(Change,ddlStatus_Change)
Gui.frmMain.ddlStatus.Event(DropDown,ddlStatus_DropDown)
Gui.frmMain.ddlStatus.Event(DropDownClosed,ddlStatus_DropDownClosed)

'---SUBROUTINES---
Sub.ddlStatus_Change
  V.Local.sSelected.Declare(String)
  V.Local.sSelected.Set(V.Screen.frmMain!ddlStatus.Text)
  F.Intrinsic.Control.CallSub(FilterByStatus,"sStatus",V.Local.sSelected)
Sub.End
```

## Context Menus

### Production Pattern (4-Parameter + ContextMenuAttach)

Production scripts at `C:\Apps\Global` use `F.Intrinsic.UI.*` APIs and attach the menu to a specific gridview. Right-click on the grid automatically shows the popup — no manual `ContextMenuShow` required when using `ContextMenuAttach`:

```
F.Intrinsic.UI.ContextMenuCreate("mnuGrid")
F.Intrinsic.UI.ContextMenuAddItem("mnuGrid","edit",0,"Edit Record")
F.Intrinsic.UI.ContextMenuAddItem("mnuGrid","delete",0,"Delete Record")
F.Intrinsic.UI.ContextMenuAddItem("mnuGrid","export",0,"Export to Excel")
F.Intrinsic.UI.SetItemEventHandler("mnuGrid","edit",HandleEdit)
F.Intrinsic.UI.SetItemEventHandler("mnuGrid","delete",HandleDelete)
F.Intrinsic.UI.SetItemEventHandler("mnuGrid","export",HandleExport)
Gui.frmMain.gsGC.ContextMenuAttach("gvMain","mnuGrid")
```

Wire `RowCellClick` when you need to capture the clicked row/column before a context-menu action runs. See the **Grid Event Selection Guidance** table above.

### Legacy / Form-Level Pattern

```
Gui.<Form>..ContextMenuCreate("ctxName")
Gui.<Form>.gsGC.ContextMenuAttach("ctxName")
Gui.<Form>..ContextMenuAddItem("ctxName","ItemID",V.Enum.MenuItemType!Button,"Display Text")
Gui.<Form>..ContextMenuSetItemEventHandler("ctxName","ItemID","HandlerSubName")
Gui.<Form>..ContextMenuShow("ctxName",V.Args.X,V.Args.Y)    ' Show context menu at position
```

---
