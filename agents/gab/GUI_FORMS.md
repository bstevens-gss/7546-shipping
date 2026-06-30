# GAB GUI Forms & Early Controls Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with form types, creation, and standard controls through GsLookUpControl
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---
# GUI (ScreenSU)

## Form Types
| Type | Purpose | Menu Bar | DockPanels |
|------|---------|----------|------------|
| `BaseForm` | Standard blank form with colored title bar | No | No |
| `DashForm` | Dashboard form with toolbar and extended features | Yes | Yes |
| `DialogForm` | Modal dialog with prompt area and result buttons | No | No |

**BaseForm** is the standard blank GAB form. It has a colored title bar but no main menu bar and cannot use DockPanels. Choose DashForm or DialogForm if you need those features.

**DashForm** (Dashboard Form) enables the menu/toolbar bar and DockPanels. Some control types require a DashForm; the GAB IDE will prompt to change the form type when adding them.

**DialogForm** is a modal dialog with a built-in prompt area and standard result buttons (OK, Cancel, Yes, No, etc.). Use `DialogStyle` to configure the icon/buttons, `Prompt` for the header text, and `CloseOnSelection` to auto-close on button click.

## Form Creation

> **CRITICAL:** Every form MUST specify a form type in `.Create()`: `BaseForm` for standard forms, `DashForm` for dashboard/toolbar forms, `DialogForm` for modal dialogs. A bare `Gui.<Form>..Create` or `Gui.<Form>..Create,` without a type parameter is **invalid**.

### BaseForm (Standard)
```
Gui.<FormName>..Create(BaseForm)
Gui.<FormName>..Caption("Form")
Gui.<FormName>..Size(1024,720)
Gui.<FormName>..MinX(0)
Gui.<FormName>..MinY(0)
Gui.<FormName>..Position(0,0)
Gui.<FormName>..AlwaysOnTop(False)
Gui.<FormName>..FontName("Tahoma")
Gui.<FormName>..FontSize(8.25)
Gui.<FormName>..ControlBox(True)
Gui.<FormName>..MaxButton(True)
Gui.<FormName>..MinButton(True)
Gui.<FormName>..MousePointer(0)
Gui.<FormName>..Moveable(True)
Gui.<FormName>..Sizeable(True)
Gui.<FormName>..ShowInTaskBar(True)
Gui.<FormName>..TitleBar(True)

' Form-level events (standard)
Gui.<FormName>..Event(Click,<FormName>_Click)
Gui.<FormName>..Event(DblClick,<FormName>_DblClick)
Gui.<FormName>..Event(Drop,<FormName>_Drop)
Gui.<FormName>..Event(KeyPress,<FormName>_KeyPress)
Gui.<FormName>..Event(MouseDown,<FormName>_MouseDown)
Gui.<FormName>..Event(MouseMove,<FormName>_MouseMove)
Gui.<FormName>..Event(MouseUp,<FormName>_MouseUp)
Gui.<FormName>..Event(Resize,<FormName>_Resize)
Gui.<FormName>..Event(UnLoad,<FormName>_UnLoad)
Gui.<FormName>..Event(Activate,<FormName>_Activate)
Gui.<FormName>..Event(Deactivate,<FormName>_Deactivate)
Gui.<FormName>..Event(GotFocus,<FormName>_GotFocus)
Gui.<FormName>..Event(LostFocus,<FormName>_LostFocus)
```

### DashForm (Dashboard)
Includes all BaseForm properties plus toolbar bar configuration:
```
Gui.<FormName>..Create(DashForm)
Gui.<FormName>..Caption("Form")
Gui.<FormName>..Size(1024,720)
Gui.<FormName>..MinX(0)
Gui.<FormName>..MinY(0)
Gui.<FormName>..Position(0,0)
Gui.<FormName>..AlwaysOnTop(False)
Gui.<FormName>..FontName("Tahoma")
Gui.<FormName>..FontSize(8.25)
Gui.<FormName>..ControlBox(True)
Gui.<FormName>..MaxButton(True)
Gui.<FormName>..MinButton(True)
Gui.<FormName>..MousePointer(0)
Gui.<FormName>..Moveable(True)
Gui.<FormName>..Sizeable(True)
Gui.<FormName>..ShowInTaskBar(True)
Gui.<FormName>..TitleBar(True)

' DashForm-only toolbar buttons
Gui.<FormName>..BarInternalButton(True)
Gui.<FormName>..BarPrintButton(True)
Gui.<FormName>..BarRefreshButton(True)
Gui.<FormName>..BarSaveButton(True,True)
Gui.<FormName>..BarSearchBox(True)
Gui.<FormName>..BarToggleButton(True,"",True,0,"Tahoma",12,False,"White")
Gui.<FormName>..BarUndoButtons(True,True,True,True)
Gui.<FormName>..BarShareButton(True,True,True,True,True)
Gui.<FormName>..BarExportButton(True)

' Form-level events (standard)
Gui.<FormName>..Event(Click,<FormName>_Click)
Gui.<FormName>..Event(DblClick,<FormName>_DblClick)
Gui.<FormName>..Event(Drop,<FormName>_Drop)
Gui.<FormName>..Event(KeyPress,<FormName>_KeyPress)
Gui.<FormName>..Event(MouseDown,<FormName>_MouseDown)
Gui.<FormName>..Event(MouseMove,<FormName>_MouseMove)
Gui.<FormName>..Event(MouseUp,<FormName>_MouseUp)
Gui.<FormName>..Event(Resize,<FormName>_Resize)
Gui.<FormName>..Event(UnLoad,<FormName>_UnLoad)
Gui.<FormName>..Event(Activate,<FormName>_Activate)
Gui.<FormName>..Event(Deactivate,<FormName>_Deactivate)
Gui.<FormName>..Event(GotFocus,<FormName>_GotFocus)
Gui.<FormName>..Event(LostFocus,<FormName>_LostFocus)

' DashForm toolbar events
Gui.<FormName>..Event(AlertClick,<FormName>_AlertClick)
Gui.<FormName>..Event(ExportClick,<FormName>_ExportClick)
Gui.<FormName>..Event(HelpButtonClick,<FormName>_HelpButtonClick)
Gui.<FormName>..Event(PerformSearch,<FormName>_PerformSearch)
Gui.<FormName>..Event(PrintClick,<FormName>_PrintClick)
Gui.<FormName>..Event(RedoButtonClick,<FormName>_RedoButtonClick)
Gui.<FormName>..Event(RefreshClick,<FormName>_RefreshClick)
Gui.<FormName>..Event(ResetButtonClick,<FormName>_ResetButtonClick)
Gui.<FormName>..Event(SaveAllButtonClick,<FormName>_SaveAllButtonClick)
Gui.<FormName>..Event(SaveButtonClick,<FormName>_SaveButtonClick)
Gui.<FormName>..Event(ShareButtonClick,<FormName>_ShareButtonClick)
Gui.<FormName>..Event(ShareChatClick,<FormName>_ShareChatClick)
Gui.<FormName>..Event(ShareEmailClick,<FormName>_ShareEmailClick)
Gui.<FormName>..Event(ShareImageClick,<FormName>_ShareImageClick)
Gui.<FormName>..Event(ToggleStateChanged,<FormName>_ToggleStateChanged)
Gui.<FormName>..Event(UndoButtonClick,<FormName>_UndoButtonClick)
Gui.<FormName>..Event(UserButtonClicked,<FormName>_UserButtonClicked)
Gui.<FormName>..Event(UserComboBoxEditValueChanged,<FormName>_UserComboBoxEditValueChanged)
Gui.<FormName>..Event(UserComboBoxSelectedIndexChanged,<FormName>_UserComboBoxSelectedIndexChanged)
Gui.<FormName>..Event(UserTextBoxEditValueChanged,<FormName>_UserTextBoxEditValueChanged)
```

### Form-Level Event V.Args
All form-level events receive the standard 3 args (`EVENTSOURCE`, `SCREEN`, `EVENTTYPE`).
Some events receive additional args:

| Event | Additional V.Args | Description |
|-------|------------------|-------------|
| `KeyPress` | `V.Args.KEYPRESS` (Long, ASCII code), `V.Args.CHARACTER` (String, the character) | 5 total args |
| `MouseDown` / `MouseUp` / `MouseMove` | `V.Args.BUTTON` (String, e.g. `"Left"`), `V.Args.CLICKS` (Long), `V.Args.SHIFT` (Long), `V.Args.X` (Long), `V.Args.Y` (Long) | 8 total args |
| `Drop` | `V.Args.FILENAME` (String) | File dropped on form |
| `Resize` | (standard 3 only) | Form resized |
| `Click` / `DblClick` | (standard 3 only) | Form clicked |
| `Activate` / `Deactivate` | (standard 3 only) | Form gained/lost foreground |
| `GotFocus` / `LostFocus` | (standard 3 only) | Form gained/lost focus |
| `UnLoad` | `V.Args.CLOSEREASON` (String, e.g. `"UserClosing"`) | 4 total args. Form closing |

### Common Form Properties & Methods (all types)

This is the **single source of truth** for all form-level properties and methods. For form runtime usage examples, see `agents/gab/GUI_EVENTS.md` > "Form Runtime Usage Examples".

| Property / Method | Description |
|-------------------|-------------|
| `.AccentColor(i)` | Form accent color: 0=UseDefault, 1=Red, 2=Blue, 3=Green, 4=Yellow, 5=Orange (or `V.Enum.AccentColorCodes!`). **WARNING:** The `V.Enum.AccentColorCodes!` form is invalid in ScreenSU -- the form designer cannot parse enum references in ScreenSU blocks. Use the raw integer value in ScreenSU (e.g., `.AccentColor(2)` for Blue) |
| `.AlwaysOnTop(b)` | Keep form on top of other windows |
| `.ApplySavedSettings` | Restores form settings from the user's last session. No arguments |
| `.AutoScaleMode(n)` | Sets form auto-scale mode; n as Long |
| `.BackColor(Color)` | Sets form background color; accepts Long, String, or V.Color |
| `.Caption(s)` | Title bar text |
| `.Close` | Closes the form. No arguments |
| `.ContextMenuAddComboItem(MenuName, ItemName, ItemText)` | Adds a combo item to a context menu combo; all String |
| `.ContextMenuAddItem(MenuName, ItemName, ItemType, [ItemText])` | Adds item to context menu; MenuName/ItemName as String, ItemType as V.Enum.MenuItemType (Button/Combobox/Separator/Textbox), ItemText as String (opt) |
| `.ContextMenuCreate(MenuName)` | Creates a context menu; MenuName as String |
| `.ContextMenuRemoveItem(MenuName, ItemName)` | Removes an item from a context menu; both String |
| `.ContextMenuSetItemEventHandler(MenuName, ItemName, SubroutineName)` | Sets the event handler for a context menu item; all String |
| `.ContextMenuSetItemText(MenuName, ItemName, Text)` | Sets the text of a context menu item; all String |
| `.ContextMenuShow(MenuName, X, Y)` | Shows a context menu at position; MenuName as String, X as Long, Y as Long |
| `.ControlBox(b)` | Show system menu (close/min/max) |
| `.Create(type)` | Form type: `BaseForm`, `DashForm`, or `DialogForm` (or `V.Enum.FormTypes!`) |
| `.CurrentX(n)` | Set current X drawing position; n as Long |
| `.CurrentY(n)` | Set current Y drawing position; n as Long |
| `.Deserialize(sLayout)` | Restores form layout from a serialized string; sLayout as String |
| `.DockWidget` | Docks the form into the parent widget panel. No arguments |
| `.Enabled(b)` | Enables or disables the form; b as Boolean |
| `.FontName(s)` | Default font name for form controls |
| `.FontSize(f)` | Default font size (Float, not Long) |
| `.FontStyle(Bold, Italic, Underline, Strikethrough, Shadow)` | Sets form font style; all Boolean |
| `.ForeColor(Color)` | Sets form foreground (text) color; accepts Long, String, or V.Color |
| `.GetControlList` | Returns a list of all controls on the form. No arguments |
| `.GroupChanged(n)` | Signals that a control group has changed; n as Long (group number) |
| `.HideWait` | Closes the wait/progress dialog shown by InvokeWait. No arguments |
| `.Icon(sPath)` | Set form icon from file path; sPath as String |
| `.InvokeWait(Desc, Title)` | Shows a wait/progress dialog; both String, both optional |
| `.KeyPreview(b)` | When True, form receives key events before controls |
| `.Left(n)` | Sets form left position; n as Long |
| `.Line(X1, Y1, X2, Y2, Color)` | Draws a line; X1/Y1/X2/Y2 as Float; Color overloads: V.Enum.ThemeColors, Long, String (#RRGGBB / #AARRGGBB), or KnownColorName String |
| `.MaxButton(b)` / `.MinButton(b)` | Enable maximize/minimize buttons |
| `.MenuColumn` | Menu column management. No arguments |
| `.MenuColumnVisible(Col, Row, b)` | Sets menu column visibility; Col/Row as Long, b as Boolean |
| `.MenuItemCheck(Column, Row, Checked)` | Check/uncheck a menu item; Column as Long, Row as Long, Checked as Boolean |
| `.MenuItemEnabled(b)` | Enable/disable a menu item; b as Boolean |
| `.MenuItemText(Column, Row, Text)` | Set menu item text; Column as Long, Row as Long, Text as String |
| `.MenuItemVisible(Col, Row, b)` | Sets menu item visibility; Col/Row as Long, b as Boolean |
| `.MinX(n)` / `.MinY(n)` | Minimum form dimensions |
| `.MousePointer(Style)` | Default mouse cursor; Style as Long (0 = default) |
| `.Moveable(b)` | Allow form to be dragged |
| `.PaintPicture(File, X1, Y1, ...)` | Paints an image on the form at specified coordinates |
| `.PlotPoint(X1, Y1, Color)` | Plots a single point; X1/Y1 as Float, Color as Enumeration |
| `.Point(X1, Y1, ReturnColor)` | Gets the color at a point; X1/Y1 as Float, ReturnColor as Long |
| `.PopupMenu` | Displays the form's popup menu at the cursor position. No arguments |
| `.Position(x,y)` | Initial form position |
| `.PrintNRet(Expression)` | Prints text at CurrentX/CurrentY without carriage return |
| `.PrintRet(Expression)` | Prints text at CurrentX/CurrentY with carriage return |
| `.ReadBarTextBoxValue(Name, Return)` | Reads a toolbar textbox value; Name as String, Return as String |
| `.RequestDockWidth(Width)` | Requests a dock width for the form; Width as Long |
| `.SaveSettings` | Persists form layout/position for the current user. No arguments |
| `.Serialize(sLayout)` | Serializes the form layout to a string; sLayout as String (output) |
| `.SetBarTextBoxValue(Name, Value)` | Sets a toolbar textbox value; Name as String, Value as String |
| `.SetFocus` | Sets focus to the form. Optional Boolean argument: `.SetFocus(True)` |
| `.SetIcon(Source)` | Set form icon from file path, or `V.Enum.FormIconApplication!`, `V.Enum.FormIconLogo!`, `V.Enum.FormIconModule!`, `V.Enum.FormIconMsgBox!`, `V.Enum.FormIconWidget!` |
| `.SetItemText(MenuName, ItemName, ItemText)` | Sets text of a toolbar menu item; all String |
| `.SetMetaData(Data#)` | Sets form-level metadata slots (variadic, maps to MetaData0-9) |
| `.SetMinWidgetSize(Width, Height)` | Sets minimum widget size; Width as Long, Height as Long |
| `.SetMonitor(n)` | Moves the form to a specific monitor; n as Long |
| `.SetWidgetSize` | Sets widget sizing based on current state. No arguments |
| `.Show` | Displays the form. No arguments |
| `.ShowCompanyCode(b)` | Shows/hides the company code in the title bar |
| `.ShowInTaskBar(Expression)` | Show in Windows taskbar; Expression as Boolean |
| `.Size(w,h)` | Form width and height in pixels (UsePixels is mandatory) |
| `.Sizeable(Expression)` | Allow form to be resized; Expression as Boolean |
| `.TakeScreenshot(Filename)` | Captures a screenshot of the form; Filename as String |
| `.TitleBar(Expression)` | Show the title bar; Expression as Boolean |
| `.ToolWindow(Expression)` | Sets form as a tool window; Expression as Boolean |
| `.Top(n)` | Sets form top position; n as Long |
| `.UnDockWidget` | Undocks the form from the parent widget panel. No arguments |
| `.UpdateWait(Desc, Title)` | Updates the wait dialog text; both String, both optional |
| `.Visible(b)` | Shows or hides the form; b as Boolean. Used in UnLoad to hide instead of destroy |
| `.WaitForDismiss` | Blocks execution until the form is closed; used for modal dialog patterns. No arguments |
| `.WindowState(n)` | Sets window state; n as Long (0=Normal, 1=Minimized, 2=Maximized) |

**DialogForm-only methods:**

| Property / Method | Description |
|-------------------|-------------|
| `.CloseOnSelection(b)` | Auto-close form when a result button is clicked; b as Boolean |
| `.DialogStyle(Style)` | Set dialog icon/buttons; Style as V.Enum.MsgBoxStyle |
| `.HasPrompt(b)` | Show/hide the prompt area; b as Boolean |
| `.Prompt(s)` | Set prompt text; s as String |

### DashForm-Only Toolbar Properties

| Property | Description |
|----------|-------------|
| `.BarInternalButton(b)` | Show the internal (GSS HQ only) button |
| `.BarPrintButton(b)` | Show the Print button |
| `.BarRefreshButton(b)` | Show the Refresh button |
| `.BarExportButton(b)` | Show the Export button |

**BarSaveButton:**
```
Gui.<Form>..BarSaveButton(Visible, [HasSaveAllSubItem])
```
| Parameter | Type | Description |
|-----------|------|-------------|
| Visible | Boolean | Show/hide the Save button |
| HasSaveAllSubItem | Boolean (optional) | Show "Save All" sub-item in the Save menu |

**BarSearchBox:**
```
Gui.<Form>..BarSearchBox(bVisible)
```

**BarShareButton:**
```
Gui.<Form>..BarShareButton(Visible, ShowEmailButton, ShowChatButton, ShowImageButton, ShowPrintButton)
```
| Parameter | Type | Description |
|-----------|------|-------------|
| Visible | Boolean | Show/hide the Share button and menu |
| ShowEmailButton | Boolean | Show Email option in Share menu |
| ShowChatButton | Boolean | Show Chat option in Share menu |
| ShowImageButton | Boolean | Show Screenshot option in Share menu |
| ShowPrintButton | Boolean | Show Print option in Share menu |

**BarUndoButtons / ClearUndo:**
```
Gui.<Form>..BarUndoButtons(Visible, [HasUndoButton], [HasRedoButton], [HasResetButton])
Gui.<Form>..ClearUndo                             ' Clear all undo/redo states
Gui.<Form>..ClearUndo(bClearUndo, bClearRedo)     ' Selective clear
```
| Parameter | Type | Description |
|-----------|------|-------------|
| Visible | Boolean | Show/hide the Undo buttons group |
| HasUndoButton | Boolean (optional) | Show the Undo button |
| HasRedoButton | Boolean (optional) | Show the Redo button |
| HasResetButton | Boolean (optional) | Show the Reset button |

**BarHelpButton:**
```
Gui.<Form>..BarHelpButton(Visible, ProgramName, ProgramDescription, [HelpId], [Version], [BuildDate], [CannyId], [NameIntlId], [DescIntlId])
```
| Parameter | Type | Description |
|-----------|------|-------------|
| Visible | Boolean | Show/hide the Help button and menu |
| ProgramName | String | Program name displayed in the help UI |
| ProgramDescription | String | Program description text |
| HelpId | String (optional) | Help page identifier for the program |
| Version | String (optional) | Version string formatted as "Major.Minor.Revision.Build" |
| BuildDate | String (optional) | Build date of the program |
| CannyId | String (optional) | The part of the Canny URL after the last slash |
| NameIntlId | Long (optional) | Internationalization ID for the program name |
| DescIntlId | Long (optional) | Internationalization ID for the program description |

**BarToggleButton:**
```
Gui.<Form>..BarToggleButton(bVisible, sCaption, bChecked, iStyle, sFontName, fFontSize, bBold, sColor)
```

**What's New Overlay** (on the About Overlay, accessed from the Help menu):
```
Gui.<Form>..AddWhatsNew(sWhatsNewItem, [InternationalID])    ' Add a line to the What's New overlay; InternationalID is optional
Gui.<Form>..ClearWhatsNew                 ' Remove all What's New items
```

**GAB Scripts in Bar:** If you have an AccordionControl with items that have a Hook number and their "Show In Bar" property set to True, those items also appear as a GAB Script menu in the bar. Clicking the menu option acts like clicking the AccordionControl link.

### Dashboard and Dialog Form Toolbar (Shared)

Custom bar items available on both DashForm and DialogForm:

**BarAddButton:**
```
Gui.<Form>..BarAddButton(Name, Caption, [SvgImage], [ParentMenu], [BeginsGroup])
```
| Parameter | Type | Description |
|-----------|------|-------------|
| Name | String | Unique control name for the button |
| Caption | String | Text (no image) or tooltip (with image) |
| SvgImage | V.Enum.Image (optional) | Icon via `V.Enum.Image!` |
| ParentMenu | String (optional) | Parent button name for dropdown menus |
| BeginsGroup | Boolean (optional) | Show a divider line before this item |

**BarAddTextBox:**
```
Gui.<Form>..BarAddTextBox(Name, Caption, Width, [EmptyPrompt], [BeginsGroup])
' Name as String, Caption as String, Width as Long, EmptyPrompt as String (opt), BeginsGroup as Boolean (opt)
```

**BarAddComboBox:**
```
Gui.<Form>..BarAddComboBox(Name, Caption, Width, [InitialValue], [DisableEditor], [BeginsGroup])
' Name as String, Caption as String, Width as Long, InitialValue as String (opt), DisableEditor as Boolean (opt), BeginsGroup as Boolean (opt)
```
When `bDisableEditor` is True, the user can only select from the dropdown list (no typing).

**BarAddComboBoxItem / BarAddComboBoxItems:**
```
Gui.<Form>..BarAddComboBoxItem(sComboBoxName, sItemName, anyDisplayValue, [lDataValue])
Gui.<Form>..BarAddComboBoxItems(ComboBoxName, CollectionType, DictionaryName)  ' All String; CollectionType="Dictionary"
Gui.<Form>..BarAddComboBoxItems(ComboBoxName, CollectionType, DataTableName, KeyColumn, ValueColumn)  ' All String; CollectionType="DataTable"
Gui.<Form>..BarAddComboBoxItems(ComboBoxName, CollectionType, DataTableName, DataViewName, KeyColumn, ValueColumn)  ' All String; CollectionType="DataView"
```

**BarRemove*:**
```
Gui.<Form>..BarRemoveButton(Name)  ' Name as String
Gui.<Form>..BarRemoveTextBox(Name)  ' Name as String
Gui.<Form>..BarRemoveComboBox(Name)  ' Name as String
Gui.<Form>..BarRemoveComboBoxItem(ComboBoxName, ItemOrdinal)  ' ComboBoxName as String, ItemOrdinal as Long
```

### DialogForm-Only Properties
| Property | Description |
|----------|-------------|
| `.DialogStyle(MsgBoxStyle)` | Sets the form icon, prompt area image, and default buttons (uses `V.Enum.MsgBoxStyle!`) |
| `.Prompt(Expression)` | Sets the prompt text at the top of the form; Expression as String |
| `.HasPrompt(b)` | Gets/sets whether the prompt area is displayed |
| `.CloseOnSelection(b)` | When True, form closes when a result button is clicked (OK, Cancel, Abort, Retry, Yes, No, Save) and raises a result event |

## Form Layout & Anchoring

GAB forms support two complementary layout mechanisms: **Anchor** (margin-to-edge resize behavior) and **Dock** (edge-filling layout regions). Use them together for professional, resizable dashboards.

### Anchor Property — `.Anchor(n)`
Sets which edges of the parent container a control is anchored to. Uses .NET `AnchorStyles` bit flags as a Long integer. **Default is 5 (Top+Left)** if not set.

| Value | Edges | Use case |
|------:|-------|----------|
| 0 | None | Floating, no resize tracking |
| 5 | Top+Left | Fixed position (default) |
| 6 | Bottom+Left | Bottom-left buttons |
| 9 | Top+Right | Top-right aligned buttons |
| 10 | Bottom+Right | Close/Save bottom-right corner |
| 13 | Top+Left+Right | Header/toolbar band -- stretches width, pinned to top |
| 14 | Bottom+Left+Right | Status bar -- stretches width at bottom |
| 15 | All (Top+Bottom+Left+Right) | Fill/stretch with container (grids, tabs, main content) |

**Bit values:** Top=1, Bottom=2, Left=4, Right=8. Combine by addition.

### Dock Property — `.Dock(n)`
Docks a control to an edge of its parent container. Controls fill the entire edge they dock to.

| Value | `V.Enum.DockStyle!` | Behavior |
|------:|---------------------|----------|
| 0 | None | Manual positioning via `.Position()` |
| 1 | Top | Fill top edge (full width, specified height) |
| 2 | Bottom | Fill bottom edge |
| 3 | Left | Fill left edge (full height, specified width) |
| 4 | Right | Fill right edge |
| 5 | Fill | Fill all remaining space |

**Order matters:** First docked control claims its edge. Dock `Top` and `Bottom` bands first, then `Fill` last.

### Control Parenting — `.Parent("containerName")`
By default, controls are children of their form. Use `.Parent()` to nest inside a Frame, Tab, SplitContainer, or NavPage.

```
Gui.<Form>.gsGC.Parent("frameMain")              ' Inside a Frame
Gui.<Form>.gsGC.Parent("tabControl1",0)           ' Inside a Tab (page index)
Gui.<Form>.gsGC.Parent("SplitContainer1",1)       ' Inside SplitContainer (panel index)
```

### Resizable Form Setup
```
Gui.<Form>..Sizeable(True)
Gui.<Form>..MaxButton(True)
Gui.<Form>..MinX(700)
Gui.<Form>..MinY(500)
```

### Production Layout Patterns

**Pattern A — Anchor-based (most common):**
```
Gui.Form_frmMain.fraHeader.Create(Frame)
Gui.Form_frmMain.fraHeader.Size(910,70)
Gui.Form_frmMain.fraHeader.Position(15,10)
Gui.Form_frmMain.fraHeader.Anchor(13)         ' Stretch width with form
Gui.Form_frmMain.gsGCMain.Create(GsGridControl)
Gui.Form_frmMain.gsGCMain.Size(910,500)
Gui.Form_frmMain.gsGCMain.Position(15,90)
Gui.Form_frmMain.gsGCMain.Anchor(15)          ' Fill remaining area
Gui.Form_frmMain.lblStatus.Create(Label)
Gui.Form_frmMain.lblStatus.Position(15,600)
Gui.Form_frmMain.lblStatus.Anchor(14)         ' Status bar stretches at bottom
```

**Pattern B — Dock-based (toolbar + fill):**
```
Gui.Form_frmMain.fraToolbar.Create(Frame)
Gui.Form_frmMain.fraToolbar.Dock(1)            ' Top band
Gui.Form_frmMain.fraToolbar.Size(0,80)
Gui.Form_frmMain.gsGC.Create(GsGridControl)
Gui.Form_frmMain.gsGC.Dock(5)                  ' Fill remaining
```

**Pattern C — Frame with nested child using Parent + Dock(5):**
```
Gui.Form_frmMain.fraViewer.Create(Frame)
Gui.Form_frmMain.fraViewer.Anchor(15)
Gui.Form_frmMain.wvConfig.Create(GsWebView2)
Gui.Form_frmMain.wvConfig.Parent("fraViewer")
Gui.Form_frmMain.wvConfig.Dock(5)              ' Fill the frame
```

**Pattern D — Left sidebar + content area:**
```
Gui.Form_frmMain.accNav.Create(AccordionControl)
Gui.Form_frmMain.accNav.Dock(3)                ' Left sidebar
Gui.Form_frmMain.navMain.Create(NavFrame)
Gui.Form_frmMain.navMain.Dock(5)               ' Fill remaining
```

## Control Types & Creation

### Button
```
Gui.<Form>.cmdName.Create(Button)
Gui.<Form>.cmdName.Enabled(True)
Gui.<Form>.cmdName.Visible(True)
Gui.<Form>.cmdName.Zorder(0)
Gui.<Form>.cmdName.Size(80,25)
Gui.<Form>.cmdName.Position(800,22)
Gui.<Form>.cmdName.Caption("Refresh")
Gui.<Form>.cmdName.FontName("Tahoma")
Gui.<Form>.cmdName.FontSize(8.25)
Gui.<Form>.cmdName.FontStyle(True,False,False,False,False)
Gui.<Form>.cmdName.Event(Click,cmdName_Click)
Gui.<Form>.cmdName.Event(GotFocus,cmdName_GotFocus)
Gui.<Form>.cmdName.Event(LostFocus,cmdName_LostFocus)
Gui.<Form>.cmdName.Event(MouseClick,cmdName_MouseClick)
Gui.<Form>.cmdName.Event(MouseDown,cmdName_MouseDown)
Gui.<Form>.cmdName.Event(MouseMove,cmdName_MouseMove)
Gui.<Form>.cmdName.Event(MouseUp,cmdName_MouseUp)
Gui.<Form>.cmdName.Parent("frameName")
Gui.<Form>.cmdName.LabelStretch(True)  ' ShouldStretchOnTranslation as Boolean
Gui.<Form>.cmdName.Locked(False)  ' Locked as Boolean
Gui.<Form>.cmdName.DisableOnClick(V.Enum.DisableOnClickModes!DisableButtonWithReEnable)  ' Prevents double-clicks; Mode as V.Enum.DisableOnClickModes
```

#### Button Events V.Args

**Mouse events** (Click, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the button control (e.g. "CMD1") |
| `V.Args.ControlType` | String | "BUTTON" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK", "MOUSECLICK", "MOUSEDOWN") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Focus events** (GotFocus, LostFocus) -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the button control (e.g. "CMD1") |
| `V.Args.ControlType` | String | "BUTTON" |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

### Label
A static text display control.

**ScreenSU setup:**
```
Gui.<Form>.lbl1.Create(Label,"Label",True,25,13,0,66,67,True,0,"Tahoma",8.25,,0,0)
Gui.<Form>.lbl1.BorderStyle(0)
Gui.<Form>.lbl1.Event(Click,lbl1_Click)
Gui.<Form>.lbl1.Event(DblClick,lbl1_DblClick)
Gui.<Form>.lbl1.Event(MouseClick,lbl1_MouseClick)
Gui.<Form>.lbl1.Event(MouseDown,lbl1_MouseDown)
Gui.<Form>.lbl1.Event(MouseMove,lbl1_MouseMove)
Gui.<Form>.lbl1.Event(MouseUp,lbl1_MouseUp)
```

> **Font styling:** To make a label bold, use `.FontStyle()` in ScreenSU or at runtime. There is no `.FontBold()` property. The correct call is:
> ```
> Gui.<Form>.lbl1.FontStyle(True,False,False,False,False)   ' Bold only
> ```
> Parameters: `FontStyle(Bold, Italic, Underline, Strikethrough, Shadow)` -- all Boolean.

**Label Create parameters:**
`Create(Label, Text, Visible, Width, Height, BorderStyle, X, Y, Enabled, TabIndex, FontName, FontSize, [unused], ForeColor, BackColor)`

#### Label Events V.Args

> ControlType: `"LABEL"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below. All 6 events share the same 11-arg signature.

**Click / DblClick / MouseClick / MouseDown / MouseMove / MouseUp events** -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("None" for MouseMove, "Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove, 1 for single-click events, 2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Event chain:** MouseDown -> MouseUp (direct call chain). Click, MouseClick, and DblClick fire independently from their own FORM events.

### TextBox
Two Create types: `TextBox` (single-line) and `TextboxM` (multiline). Both share the same events and V.Args. ControlType is `"TEXTBOX"` for single-line and `"TEXTBOXM"` for multiline.
```
Gui.<Form>.txtName.Create(TextBox,"",True,<Width>,<Height>,0,<X>,<Y>,True,0,"Tahoma",8.25,,1)
Gui.<Form>.txtName.Create(TextboxM)     ' Multiline variant (separate Create syntax)
Gui.<Form>.txtName.Enabled(True)
Gui.<Form>.txtName.Visible(True)
Gui.<Form>.txtName.Zorder(0)
Gui.<Form>.txtName.Size(300,230)
Gui.<Form>.txtName.Position(72,135)
Gui.<Form>.txtName.FontName("Tahoma")
Gui.<Form>.txtName.FontSize(8.25)
Gui.<Form>.txtName.Locked(True)
Gui.<Form>.txtName.MaxLength(200)
Gui.<Form>.txtName.NumericOnly(2)
Gui.<Form>.txtName.Mask("%")
Gui.<Form>.txtName.CharacterCasing(1)                          ' 0=Normal, 1=Upper, 2=Lower
Gui.<Form>.txtName.PasswordChar("*")
Gui.<Form>.txtName.Min(0)
Gui.<Form>.txtName.Max(100)
Gui.<Form>.txtName.SelectionStart(0)
Gui.<Form>.txtName.SelectionLength(5)
Gui.<Form>.txtName.AddAutoCompleteItem("SuggestionText")
Gui.<Form>.txtName.ClearAutoCompleteItems()
Gui.<Form>.txtName.Event(Change,txtName_Change)
Gui.<Form>.txtName.Event(Click,txtName_Click)
Gui.<Form>.txtName.Event(DblClick,txtName_DblClick)
Gui.<Form>.txtName.Event(Drop,txtName_Drop)
Gui.<Form>.txtName.Event(GotFocus,txtName_GotFocus)
Gui.<Form>.txtName.Event(KeyPress,txtName_KeyPress)
Gui.<Form>.txtName.Event(KeyPressEnter,txtName_KeyPressEnter)
Gui.<Form>.txtName.Event(LostFocus,txtName_LostFocus)
Gui.<Form>.txtName.Event(MouseClick,txtName_MouseClick)
Gui.<Form>.txtName.Event(MouseDown,txtName_MouseDown)
Gui.<Form>.txtName.Event(MouseMove,txtName_MouseMove)
Gui.<Form>.txtName.Event(MouseUp,txtName_MouseUp)
```

#### TextBox Events V.Args

> ControlType: `"TEXTBOX"` (single-line) or `"TEXTBOXM"` (multiline). Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**KeyPress event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.KeyPress` | Long | ASCII key code of the pressed key (e.g. 97 for "a") |
| `V.Args.Character` | String | Character representation of the key (e.g. "a") |

**LostFocus event** -- 8 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.SelectionStart` | Long | Cursor position in the text (0-based) |
| `V.Args.CurrentLine` | Long | Current line number (0-based, relevant for TextboxM) |
| `V.Args.CurrentColumn` | Long | Current column number (0-based) |

**GotFocus event** -- 5 args (standard args only)

**Change event** -- 5 args (standard args only)

**KeyPressEnter event** -- 5 args (standard args only)

**Drop event** -- 5 args (standard args only)

> **Note:** TextBox LostFocus uniquely includes cursor position args (`SelectionStart`, `CurrentLine`, `CurrentColumn` -- 8 total). KeyPress includes `KeyPress` (ASCII code) and `Character` (7 total). All other events are standard 5 args or 11-arg mouse events.

### DropDownList / ComboBox
```
Gui.<Form>.ddlName.Create(DropDownList)
Gui.<Form>.ddlName.Enabled(True)
Gui.<Form>.ddlName.Visible(True)
Gui.<Form>.ddlName.Zorder(0)
Gui.<Form>.ddlName.Size(100,20)
Gui.<Form>.ddlName.Position(91,71)
Gui.<Form>.ddlName.FontName("Tahoma")
Gui.<Form>.ddlName.FontSize(8.25)
Gui.<Form>.ddlName.AddItem("Option 1")
Gui.<Form>.ddlName.ListIndex(0)
Gui.<Form>.ddlName.Event(Change,ddlName_Change)
Gui.<Form>.ddlName.Event(Click,ddlName_Click)
Gui.<Form>.ddlName.Event(DropDown,ddlName_DropDown)
Gui.<Form>.ddlName.Event(DropDownClosed,ddlName_DropDownClosed)
Gui.<Form>.ddlName.Event(GotFocus,ddlName_GotFocus)
Gui.<Form>.ddlName.Event(LostFocus,ddlName_LostFocus)
Gui.<Form>.ddlName.Event(MouseClick,ddlName_MouseClick)
Gui.<Form>.ddlName.Event(MouseDown,ddlName_MouseDown)
Gui.<Form>.ddlName.Event(MouseMove,ddlName_MouseMove)
Gui.<Form>.ddlName.Event(MouseUp,ddlName_MouseUp)
Gui.<Form>.ddlName.Event(SelectedIndexChanged,ddlName_SelectedIndexChanged)

' DropDownList-specific methods
Gui.<Form>.ddlName.ClearSelected()                              ' Clears the current selection (deselects)
Gui.<Form>.ddlName.FindItemByData(Value, Exact, ReturnIndex)    ' Finds item by data value; Value as String, Exact as Boolean, ReturnIndex as Long
Gui.<Form>.ddlName.AddItems("Dictionary","DictName")            ' Bulk-add from Dictionary
Gui.<Form>.ddlName.AddItems("DataTable","DTName","ValueCol","DisplayCol")  ' Bulk-add from DataTable
Gui.<Form>.ddlName.AddItems("DataView","DTName","DVName","ValueCol","DisplayCol")  ' Bulk-add from DataView

Gui.<Form>.cboName.Create(ComboBox)
Gui.<Form>.cboName.Enabled(True)
Gui.<Form>.cboName.Visible(True)
Gui.<Form>.cboName.Zorder(0)
Gui.<Form>.cboName.Size(100,20)
Gui.<Form>.cboName.Position(91,71)
Gui.<Form>.cboName.FontName("Tahoma")
Gui.<Form>.cboName.FontSize(8.25)
Gui.<Form>.cboName.Event(Change,cboName_Change)
Gui.<Form>.cboName.Event(Click,cboName_Click)
Gui.<Form>.cboName.Event(DropDown,cboName_DropDown)
Gui.<Form>.cboName.Event(DropDownClosed,cboName_DropDownClosed)
Gui.<Form>.cboName.Event(GotFocus,cboName_GotFocus)
Gui.<Form>.cboName.Event(LostFocus,cboName_LostFocus)
Gui.<Form>.cboName.Event(MouseClick,cboName_MouseClick)
Gui.<Form>.cboName.Event(MouseDown,cboName_MouseDown)
Gui.<Form>.cboName.Event(MouseMove,cboName_MouseMove)
Gui.<Form>.cboName.Event(MouseUp,cboName_MouseUp)
Gui.<Form>.cboName.Event(SelectedIndexChanged,cboName_SelectedIndexChanged)

' ComboBox-specific methods
Gui.<Form>.cboName.ClearSelected()                          ' Clears the current selection (deselects)
Gui.<Form>.cboName.FindItemByData(Value, Exact, ReturnIndex)  ' Finds item by data value; Value as String, Exact as Boolean, ReturnIndex as Long (returns -1 if not found)
```

> DropDownList is pick-from-list only; ComboBox is editable (allows typing). Both controls share the same 11 events and identical V.Args. ControlType is "DROPDOWNLIST" or "COMBOBOX" respectively.

#### DropDownList / ComboBox Events V.Args

**Mouse/Click events** (Click, MouseClick, MouseDown, MouseMove, MouseUp) -- 15 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "DDL1" or "CBO1") |
| `V.Args.ControlType` | String | "DROPDOWNLIST" or "COMBOBOX" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK", "MOUSECLICK", "MOUSEDOWN") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.SelectedIndex` | Long | Currently selected index (-1 if none) |
| `V.Args.SelectedItem` | String | Text of selected item |
| `V.Args.SelectedValue` | String | Value of selected item |
| `V.Args.SelectedText` | String | Display text of selected item |

**SelectedIndexChanged event** -- 9 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "DROPDOWNLIST" or "COMBOBOX" |
| `V.Args.EventType` | String | "SELECTEDINDEXCHANGED" |
| `V.Args.SelectedIndex` | Long | Newly selected index |
| `V.Args.SelectedItem` | String | Text of newly selected item |
| `V.Args.SelectedValue` | String | Value of newly selected item |
| `V.Args.SelectedText` | String | Display text of newly selected item |

**Change, DropDown, DropDownClosed, GotFocus, LostFocus events** -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "DROPDOWNLIST" or "COMBOBOX" |
| `V.Args.EventType` | String | "CHANGE", "DROPDOWN", "DROPDOWNCLOSED", "GOTFOCUS", or "LOSTFOCUS" |

> **Note:** DropDownList and ComboBox mouse/click events carry 4 extra selection args (SelectedIndex, SelectedItem, SelectedValue, SelectedText) that standard mouse events on other controls do not have.

**Event chain:** MouseDown -> LostFocus -> MouseUp; DropDown -> DropDownClosed

### CheckBox / Option (Radio) [DEPRECATED]

> **DEPRECATED:** The Option (Radio Button) control is deprecated. Use DropDownList, ComboBox, GsToggleSwitch, or CheckBox instead depending on the use case.

```
Gui.<Form>.chkName.Create(CheckBox)
Gui.<Form>.chkName.Enabled(True)
Gui.<Form>.chkName.Visible(True)
Gui.<Form>.chkName.Zorder(0)
Gui.<Form>.chkName.Size(75,20)
Gui.<Form>.chkName.Position(106,50)
Gui.<Form>.chkName.Caption("Label Text")
Gui.<Form>.chkName.FontName("Tahoma")
Gui.<Form>.chkName.FontSize(8.25)
Gui.<Form>.chkName.Event(Change,chkName_Change)
Gui.<Form>.chkName.Event(Click,chkName_Click)
Gui.<Form>.chkName.Event(MouseClick,chkName_MouseClick)
Gui.<Form>.chkName.Event(MouseDown,chkName_MouseDown)
Gui.<Form>.chkName.Event(MouseHover,chkName_MouseHover)
Gui.<Form>.chkName.Event(MouseMove,chkName_MouseMove)
Gui.<Form>.chkName.Event(MouseUp,chkName_MouseUp)
Gui.<Form>.chkName.Event(GotFocus,chkName_GotFocus)
Gui.<Form>.chkName.Event(LostFocus,chkName_LostFocus)

Gui.<Form>.optName.Create(Option)  ' DEPRECATED -- use DropDownList, ComboBox, GsToggleSwitch, or CheckBox instead
```

#### CheckBox Events V.Args

**Mouse events** (MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "CHK1") |
| `V.Args.ControlType` | String | "CHECKBOX" |
| `V.Args.EventType` | String | Event name (e.g. "MOUSECLICK", "MOUSEDOWN") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Click, Change, MouseHover, GotFocus, LostFocus events** -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "CHK1") |
| `V.Args.ControlType` | String | "CHECKBOX" |
| `V.Args.EventType` | String | "CLICK", "CHANGE", "MOUSEHOVER", "GOTFOCUS", or "LOSTFOCUS" |

> **Note:** CheckBox Click fires with only 5 args (no Button/Clicks/Shift/Delta/X/Y), unlike Button Click which fires with 11 args.

**Event chain:** MouseDown -> LostFocus -> MouseUp -> Click -> Change

### DatePicker
```
Gui.<Form>.dtpName.Create(DatePicker)
Gui.<Form>.dtpName.Enabled(True)
Gui.<Form>.dtpName.Visible(True)
Gui.<Form>.dtpName.Zorder(0)
Gui.<Form>.dtpName.Size(100,20)
Gui.<Form>.dtpName.Position(62,55)
Gui.<Form>.dtpName.CheckBox(False)
Gui.<Form>.dtpName.FontName("Tahoma")
Gui.<Form>.dtpName.FontSize(8.25)
Gui.<Form>.dtpName.Value(dDate)
Gui.<Form>.dtpName.Event(Change,dtpName_Change)
Gui.<Form>.dtpName.Event(Click,dtpName_Click)
Gui.<Form>.dtpName.Event(MouseClick,dtpName_MouseClick)
Gui.<Form>.dtpName.Event(MouseDown,dtpName_MouseDown)
Gui.<Form>.dtpName.Event(MouseMove,dtpName_MouseMove)
Gui.<Form>.dtpName.Event(MouseUp,dtpName_MouseUp)
Gui.<Form>.dtpName.Event(GotFocus,dtpName_GotFocus)
Gui.<Form>.dtpName.Event(LostFocus,dtpName_LostFocus)
Gui.<Form>.dtpName.AllowBlank(True)    ' Allows the datepicker to have a blank/empty value; Flag as Boolean
Gui.<Form>.dtpName.CustomFormat()       ' Used with .Format to set a custom date/time display format
```

#### DatePicker Events V.Args

**Mouse events** (Click, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "DTP1") |
| `V.Args.ControlType` | String | "DATEPICKER" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK", "MOUSECLICK", "MOUSEDOWN") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Change, GotFocus, LostFocus events** -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "DTP1") |
| `V.Args.ControlType` | String | "DATEPICKER" |
| `V.Args.EventType` | String | "CHANGE", "GOTFOCUS", or "LOSTFOCUS" |

**Event chain:** MouseDown -> LostFocus -> MouseUp

### DateTimeOffset
```
Gui.<Form>.dtoName.Create(DateTimeOffset)
Gui.<Form>.dtoName.Enabled(True)
Gui.<Form>.dtoName.Visible(True)
Gui.<Form>.dtoName.Zorder(0)
Gui.<Form>.dtoName.Size(100,20)
Gui.<Form>.dtoName.Position(151,75)
Gui.<Form>.dtoName.FontName("Tahoma")
Gui.<Form>.dtoName.FontSize(8.25)
Gui.<Form>.dtoName.Event(Change,dtoName_Change)
Gui.<Form>.dtoName.Event(Click,dtoName_Click)
Gui.<Form>.dtoName.Event(GotFocus,dtoName_GotFocus)
Gui.<Form>.dtoName.Event(LostFocus,dtoName_LostFocus)
```

#### DateTimeOffset Events V.Args

**Click event** -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "DATETIMEOFFSET1") |
| `V.Args.ControlType` | String | "DATETIMEOFFSET" |
| `V.Args.EventType` | String | "CLICK" |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Change, GotFocus, LostFocus events** -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "DATETIMEOFFSET" |
| `V.Args.EventType` | String | "CHANGE", "GOTFOCUS", or "LOSTFOCUS" |

### DockPanel
DockPanels are DevExpress-style dockable panel containers. Requires a DashForm.
```
Gui.<Form>.dockPanel1.Create(DockPanel)
Gui.<Form>.dockPanel1.Enabled(True)
Gui.<Form>.dockPanel1.Caption("Panel Title")
Gui.<Form>.dockPanel1.DockPosition(V.Enum.DockingStyle!Left)   ' DockingStyle as V.Enum.DockingStyle
Gui.<Form>.dockPanel1.DockedSize(200, 400)                     ' OBSOLETE. Width as Long, Height as Long
Gui.<Form>.dockPanel1.UndockedSize(300, 500)                   ' OBSOLETE. Width as Long, Height as Long
Gui.<Form>.dockPanel1.HasCloseButton(True)                     ' Shows/hides the close button; HasCloseButton as Boolean
Gui.<Form>.dockPanel1.Visibility(V.Enum.Visibility!Visible)    ' V.Enum.Visibility: Visible, AutoHide, Hidden
Gui.<Form>.dockPanel1.UseLayout(True)                          ' Enable layout persistence; UseLayout as Boolean
Gui.<Form>.dockPanel1.UpdateLayout("layoutFile.xml", True)     ' Load layout from file; FileName as String, [KeepVisibility as Boolean, default True]
Gui.<Form>.dockPanel1.SetLayoutGroupVisible("GroupName", True)   ' Show/hide a named layout group
Gui.<Form>.dockPanel1.SetLayoutGroupCollapsed("GroupName", False)  ' Collapse/expand a named layout group
```

### Frame (Container)
```
Gui.<Form>.frameName.Create(Frame)
Gui.<Form>.frameName.Enabled(True)
Gui.<Form>.frameName.Visible(True)
Gui.<Form>.frameName.Zorder(0)
Gui.<Form>.frameName.Size(343,229)
Gui.<Form>.frameName.Position(7,6)
Gui.<Form>.frameName.Caption("Section Title")
Gui.<Form>.frameName.FontName("Tahoma")
Gui.<Form>.frameName.FontSize(8.25)
Gui.<Form>.frameName.FontStyle(True,False,False,False,False)
Gui.<Form>.frameName.BorderStyle(3)
Gui.<Form>.frameName.Event(Click,frameName_Click)
Gui.<Form>.frameName.Event(DblClick,frameName_DblClick)
Gui.<Form>.frameName.Event(MouseClick,frameName_MouseClick)
Gui.<Form>.frameName.Event(MouseDown,frameName_MouseDown)
Gui.<Form>.frameName.Event(MouseMove,frameName_MouseMove)
Gui.<Form>.frameName.Event(MouseUp,frameName_MouseUp)
Gui.<Form>.frameName.Event(GotFocus,frameName_GotFocus)
Gui.<Form>.frameName.Event(LostFocus,frameName_LostFocus)
Gui.<Form>.frameName.Event(BorderButtonClick,frameName_BorderButtonClick)
Gui.<Form>.childControl.Parent("frameName")

' Frame button (shown in the frame border when HasButton is True)
Gui.<Form>.frameName.ButtonCaption("Go")           ' Sets the caption on the frame's border button; Caption as String
Gui.<Form>.frameName.ButtonInternationalID(1234)    ' Sets the translation ID for the border button caption; ID as Long
```

#### Frame Events V.Args

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "FRAME1") |
| `V.Args.ControlType` | String | "FRAME" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK", "DBLCLICK", "MOUSEDOWN") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks (2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Focus events** (GotFocus, LostFocus) -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "FRAME" |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

**BorderButtonClick** -- fires when a border button on the frame is clicked.

### Tab Control
A tabbed container control for organizing child controls into pages. ControlType is `"TAB"`.
```
Gui.<Form>.tab1.Create(Tab)
Gui.<Form>.tab1.Enabled(True)
Gui.<Form>.tab1.Visible(True)
Gui.<Form>.tab1.Zorder(0)
Gui.<Form>.tab1.Size(736,300)
Gui.<Form>.tab1.Position(119,70)
Gui.<Form>.tab1.FontName("Tahoma")
Gui.<Form>.tab1.FontSize(8.25)
Gui.<Form>.tab1.Tabs(2)
Gui.<Form>.tab1.SetTab(0)
Gui.<Form>.tab1.Caption("Tab 0")
Gui.<Form>.tab1.SetTab(1)
Gui.<Form>.tab1.Caption("Tab 1")
Gui.<Form>.tab1.TabColor(0,V.Color!Blue)                      ' Set color for tab at index
Gui.<Form>.tab1.TabEnabled(1,False)                            ' Enable/disable tab at index
Gui.<Form>.tab1.TabVisible(1,True)                             ' Show/hide tab at index
Gui.<Form>.tab1.ClearMetaData()
Gui.<Form>.tab1.UseLayout(True)
Gui.<Form>.tab1.UpdateLayout(sFileName)
Gui.<Form>.tab1.Event(Click,tab1_Click)
Gui.<Form>.tab1.Event(DblClick,tab1_DblClick)
Gui.<Form>.tab1.Event(MouseClick,tab1_MouseClick)
Gui.<Form>.tab1.Event(MouseDown,tab1_MouseDown)
Gui.<Form>.tab1.Event(MouseMove,tab1_MouseMove)
Gui.<Form>.tab1.Event(MouseUp,tab1_MouseUp)
Gui.<Form>.tab1.Event(GotFocus,tab1_GotFocus)
Gui.<Form>.tab1.Event(LostFocus,tab1_LostFocus)

' Child controls use Parent("tab1",0) for tab page 0, ("tab1",1) for tab page 1
Gui.<Form>.childControl.Parent("tab1",0)
```

#### Tab Events V.Args

> Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks (1 for single, 2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**GotFocus, LostFocus events** -- 5 args (standard args only)

**Event chain on single click:** MouseDown -> LostFocus -> MouseUp -> Click -> MouseClick

**Event chain on double click:** DblClick fires from the MouseMove chain with Clicks=2

**Event chain on initial focus:** GotFocus -> LostFocus

### Timer
```
Gui.<Form>.tmrName.Create(Timer)
Gui.<Form>.tmrName.Interval(1000)
Gui.<Form>.tmrName.Enabled(True)
Gui.<Form>.tmrName.Event(Timer,tmrName_Timer)
```

### ProgressBar
```
Gui.<Form>.pbName.Create(ProgressBar)
Gui.<Form>.pbName.Min(0)
Gui.<Form>.pbName.Max(100)
Gui.<Form>.pbName.Value(50)
Gui.<Form>.pbName.Visible(True)
Gui.<Form>.pbName.Scrolling(True)     ' True=marquee/scrolling (no specific value), False=shows value
```

### PictureBox
```
Gui.<Form>.pic1.Create(PictureBox)
Gui.<Form>.pic1.Enabled(True)
Gui.<Form>.pic1.Visible(True)
Gui.<Form>.pic1.Zorder(0)
Gui.<Form>.pic1.Size(396,162)
Gui.<Form>.pic1.Position(81,105)
Gui.<Form>.pic1.SvgPicture("icon_browser_black")
Gui.<Form>.pic1.SizeMode(V.Enum.PictureBoxSizeMode!Stretch)
Gui.<Form>.pic1.SvgPictureSize(16,16)
Gui.<Form>.pic1.Picture(sFilePath)
Gui.<Form>.pic1.PaintPicture(sFilePath,iX,iY)
Gui.<Form>.pic1.ClearMetaData()
Gui.<Form>.pic1.CLS()                                         ' Clear the drawing surface
Gui.<Form>.pic1.DrawWidth(2)                                   ' Set pen width
Gui.<Form>.pic1.SetDrawParameters(iStyle,iWidth)               ' Set pen style and width
Gui.<Form>.pic1.Circle(fX,fY,fRadius,V.Color!Red,fAspect)     ' Draw circle/ellipse
Gui.<Form>.pic1.Line(fX0,fY0,fX1,fY1,V.Color!Blue,bFill)     ' Draw line/box
Gui.<Form>.pic1.PSet(iX,iY,V.Color!Black)                     ' Plot a single pixel
Gui.<Form>.pic1.Point(fX,fY,lReturnColor)                     ' Read color at coordinates
Gui.<Form>.pic1.Print("Text",V.Color!Black)                   ' Print text on the surface
Gui.<Form>.pic1.Event(Click,pic1_Click)
Gui.<Form>.pic1.Event(DblClick,pic1_DblClick)
Gui.<Form>.pic1.Event(MouseClick,pic1_MouseClick)
Gui.<Form>.pic1.Event(MouseDown,pic1_MouseDown)
Gui.<Form>.pic1.Event(MouseMove,pic1_MouseMove)
Gui.<Form>.pic1.Event(MouseUp,pic1_MouseUp)
Gui.<Form>.pic1.Event(GotFocus,pic1_GotFocus)
Gui.<Form>.pic1.Event(LostFocus,pic1_LostFocus)
```

#### PictureBox Events V.Args

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp):

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "PIC1") |
| `V.Args.ControlType` | String | "PICTUREBOX" |
| `V.Args.EventType` | String | Event name (e.g. "MOUSECLICK", "CLICK", "DBLCLICK") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks (1 for single, 2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**GotFocus, LostFocus events:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "PICTUREBOX" |
| `V.Args.EventType` | String | Event name (e.g. "GOTFOCUS") |

**Event chain on single click:** MouseDown -> LostFocus -> MouseMove -> MouseUp -> Click -> MouseClick

**Event chain on double click:** DblClick fires from MouseDown (second press) with Clicks=2

**Event chain on initial focus:** GotFocus -> LostFocus

### TextboxM (Multiline TextBox)

> **Note:** `.Scrolling()` is NOT valid on TextBox or TextboxM controls (see `agents/AGENTS.GAB.md` anti-patterns). `.Scrolling()` is only valid on ProgressBar controls.

```
Gui.<Form>.txtBody.Create(TextboxM)
Gui.<Form>.txtBody.Size(5000,3000)
Gui.<Form>.txtBody.Position(100,100)
Gui.<Form>.txtBody.Text(sValue)                                ' Set the text content
Gui.<Form>.txtBody.SelectAll()                                 ' Select all text
```

### TextBoxR (Rich TextBox)
A rich text editing control. ControlType is `"TEXTBOXR"`. Shares most events with TextBox/TextboxM but has different LostFocus args.
```
Gui.<Form>.txt1.Create(TextBoxR)
Gui.<Form>.txt1.Enabled(True)
Gui.<Form>.txt1.Visible(True)
Gui.<Form>.txt1.Zorder(0)
Gui.<Form>.txt1.Size(400,200)
Gui.<Form>.txt1.Position(59,71)
Gui.<Form>.txt1.FontName("Tahoma")
Gui.<Form>.txt1.FontSize(8.25)
Gui.<Form>.txt1.RtfText(sFormattedRtf)                         ' Set rich text (RTF formatted string)
Gui.<Form>.txt1.ViewType(V.Enum.ViewType!Rtf)                  ' Set view mode
Gui.<Form>.txt1.SelectAll()                                    ' Select all text
Gui.<Form>.txt1.Event(Change,txt1_Change)
Gui.<Form>.txt1.Event(Click,txt1_Click)
Gui.<Form>.txt1.Event(DblClick,txt1_DblClick)
Gui.<Form>.txt1.Event(GotFocus,txt1_GotFocus)
Gui.<Form>.txt1.Event(KeyPress,txt1_KeyPress)
Gui.<Form>.txt1.Event(LostFocus,txt1_LostFocus)
Gui.<Form>.txt1.Event(MouseClick,txt1_MouseClick)
Gui.<Form>.txt1.Event(MouseDown,txt1_MouseDown)
Gui.<Form>.txt1.Event(MouseMove,txt1_MouseMove)
Gui.<Form>.txt1.Event(MouseUp,txt1_MouseUp)
```

#### TextBoxR Events V.Args

> ControlType: `"TEXTBOXR"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks (1 for single, 2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**KeyPress event** -- 7 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.KeyPress` | Long | ASCII key code of the pressed key (e.g. 13 for Enter) |
| `V.Args.Character` | String | Character representation (empty for non-printable keys) |

**LostFocus event** -- 6 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.SelectionStart` | Long | Cursor position in the text (0-based) |

> **Note:** TextBoxR LostFocus includes `SelectionStart` only (6 args total). This differs from TextBox/TextboxM which also include `CurrentLine` and `CurrentColumn` (8 args total).

**GotFocus, Change events** -- 5 args (standard args only)

**Event chain on single click:** MouseDown -> LostFocus -> MouseUp -> Click -> MouseClick

**Event chain on double click:** DblClick fires from FORM Event DBLCLICK with Clicks=2

**Event chain on initial focus:** GotFocus -> LostFocus

### Hyperlink
A clickable text link control.

**ScreenSU setup:**
```
' Standard multi-line creation
Gui.<Form>.link1.Create(Hyperlink)
Gui.<Form>.link1.Enabled(True)
Gui.<Form>.link1.Visible(True)
Gui.<Form>.link1.Zorder(0)
Gui.<Form>.link1.Size(75,14)
Gui.<Form>.link1.Position(37,140)
Gui.<Form>.link1.Caption("Hyperlink")
Gui.<Form>.link1.FontName("Tahoma")
Gui.<Form>.link1.FontSize(8.25)
Gui.<Form>.link1.Event(Click,link1_Click)
Gui.<Form>.link1.Event(MouseClick,link1_MouseClick)
Gui.<Form>.link1.Event(MouseDown,link1_MouseDown)
Gui.<Form>.link1.Event(MouseMove,link1_MouseMove)
Gui.<Form>.link1.Event(MouseUp,link1_MouseUp)

' Compact single-line creation (all properties inline)
Gui.<Form>.link1.Create(Hyperlink, sText, bVisible, iWidth, iHeight, NOT_USED, iLeft, iTop, bEnabled, sFontName, fFontSize)
```

#### Hyperlink Events V.Args

> ControlType: `"HYPERLINK"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below. All 5 events share the same 11-arg signature.

**Click / MouseClick / MouseDown / MouseMove / MouseUp events** -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("None" for MouseMove, "Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Event chain:** MouseDown -> MouseUp (MouseUp is called from MouseDown in the call stack). Click and MouseClick fire independently from their own FORM events.

> **Note:** Click and MouseClick are distinct events that fire separately. Both carry the full mouse arg signature. Click fires from `FORM Event CLICK`; MouseClick fires from `FORM Event MOUSECLICK`. Use Click for simple click handling; use MouseClick when you need to distinguish it from other mouse interactions.

### ListView
```
Gui.<Form>.lvw1.Create(ListView)
Gui.<Form>.lvw1.View(0)                             ' 0=Details, 1=LargeIcon, etc.
Gui.<Form>.lvw1.Multiselect(False)
Gui.<Form>.lvw1.CheckBoxes(False)
Gui.<Form>.lvw1.Event(OLEDragDrop,lvw1_OLEDragDrop)
Gui.<Form>.lvw1.Event(Click,lvw1_Click)

' Runtime methods
Gui.<Form>.lvw1.addlistviewcolumn("Header",iWidth)
Gui.<Form>.lvw1.AddListItem("Key","Text")
Gui.<Form>.lvw1.SetListItemSubItemText("Key",iSubIndex,"Text")
Gui.<Form>.lvw1.SetListItemProps("Key","Icon",sIconName)
Gui.<Form>.lvw1.RetrieveSelectedListitems(sResult)
Gui.<Form>.lvw1.RetrieveCheckedListItems(sResult)
Gui.<Form>.lvw1.RetrieveallListItems(sResult)
Gui.<Form>.lvw1.RetrieveItemOrdinal("Key",iResult)
Gui.<Form>.lvw1.ListitemKeyToOrdinal("Key",iResult)
Gui.<Form>.lvw1.SetSelectedItemByKey("Key")
Gui.<Form>.lvw1.SetSelectedItemByOrdinal(iOrdinal)          ' Select item by zero-based ordinal
Gui.<Form>.lvw1.KeyExist("Key",bResult)
Gui.<Form>.lvw1.RemoveItem("Key")
Gui.<Form>.lvw1.ClearItems
Gui.<Form>.lvw1.EnsureVisible                                ' Scroll selected item into view
Gui.<Form>.lvw1.ListItemCheck("Key",bChecked)                ' Set/clear checkbox for an item
Gui.<Form>.lvw1.MultiSelect(bFlag)                           ' Enable/disable multi-select
Gui.<Form>.lvw1.SetListViewColumnWidth(iCol, fWidth)         ' Set column width
```

### ListBox
A simple list control for displaying and selecting items.

**ScreenSU setup:**
```
Gui.<Form>.lst1.Create(ListBox)
Gui.<Form>.lst1.Enabled(True)
Gui.<Form>.lst1.Visible(True)
Gui.<Form>.lst1.Zorder(0)
Gui.<Form>.lst1.Size(178,196)
Gui.<Form>.lst1.Position(91,35)
Gui.<Form>.lst1.FontName("Tahoma")
Gui.<Form>.lst1.FontSize(8.25)
Gui.<Form>.lst1.Event(Click,lst1_Click)
Gui.<Form>.lst1.Event(DblClick,lst1_DblClick)
Gui.<Form>.lst1.Event(GotFocus,lst1_GotFocus)
Gui.<Form>.lst1.Event(LostFocus,lst1_LostFocus)
Gui.<Form>.lst1.Event(MouseClick,lst1_MouseClick)
Gui.<Form>.lst1.Event(MouseDown,lst1_MouseDown)
Gui.<Form>.lst1.Event(MouseMove,lst1_MouseMove)
Gui.<Form>.lst1.Event(MouseUp,lst1_MouseUp)
Gui.<Form>.lst1.Event(SelectedIndexChanged,lst1_SelectedIndexChanged)
```

**Runtime methods:**
```
Gui.<Form>.lst1.AddItem(sItemText)                          ' Add a single item (optional index)
Gui.<Form>.lst1.AddItem(sItemText, iIndex)                  ' Add item at specific position
Gui.<Form>.lst1.AddItems("Dictionary", "dictName")          ' Add all items from a Dictionary collection
Gui.<Form>.lst1.ClearItems                                   ' Remove all items
Gui.<Form>.lst1.ClearSelected                                ' Deselect all selected items
Gui.<Form>.lst1.RemoveItem(iIndex)                           ' Remove item at zero-based index
Gui.<Form>.lst1.ListIndex(iIndex)                            ' Set the selected item by index
Gui.<Form>.lst1.Mask("##/##/####")                           ' Apply an input mask

' Search methods
Gui.<Form>.lst1.FindItem(sValue, bExact, iReturnIndex)       ' Find item by display text; returns index
Gui.<Form>.lst1.FindItemByData(sValue, bExact, iReturnIndex) ' Find item by data value; returns index
Gui.<Form>.lst1.ContainsItem(sValue, bExact, iReturnIndex)   ' Check if item exists; returns index

' Reading the selected value
F.Intrinsic.Control.If(V.Screen.<Form>!lst1.Text,=,"")
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
```

#### ListBox Events V.Args

> ControlType: `"LISTBOX"`. Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("None" for MouseMove, "Left", "Right", "Middle") |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove, 1 for single-click events, 2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**GotFocus / LostFocus events** -- 5 args (standard args only)

**SelectedIndexChanged event** -- 5 args (standard args only)

**Event chain:** GotFocus -> (user clicks) -> MouseDown -> LostFocus -> MouseUp. Click, MouseClick, and DblClick fire independently from their own FORM events.

> **Note:** `SelectedIndexChanged` fires during both user interaction AND programmatic changes (e.g. `AddItem` calls from Main). Use `BlockEvents`/`UnBlockEvents` if you need to suppress it during programmatic population.

### Lookup (Browser)
A pop-up browser dialog for entity search and selection. Distinct from `GsLookUpControl` (autocomplete).
Supports 4 populate modes; results are returned via an auto-generated `_Result` DataTable or Object.

#### PopulateMode Reference
| Value | Mode | Data Source |
|-------|------|-------------|
| `0` | GSS Entity Lookup | Uses `LookupMode(n)` to select a standard GSS entity browser |
| `2` | String-based | Populates from `StringBasis` with `ColumnDelim` / `RowDelim` |
| `3` | File-based | Populates from `FileBasis` with `ColumnDelim` / `RowDelim` |
| `4` | DataTable-based | Set `DataTableBasis("dtName")` at runtime before `.Show` |

#### Creation Properties
```
Gui.<Form>.lookupName.Create(Lookup)
Gui.<Form>.lookupName.Enabled(True)
Gui.<Form>.lookupName.PopulateMode(0)
Gui.<Form>.lookupName.Title("GSS Lookup")
Gui.<Form>.lookupName.StringBasis("")
Gui.<Form>.lookupName.FileBasis("")
Gui.<Form>.lookupName.ColumnDelim("")
Gui.<Form>.lookupName.RowDelim("")
Gui.<Form>.lookupName.PreferredStyle(0)
Gui.<Form>.lookupName.LookupMode(10)             ' GSS entity type ID (PopulateMode 0 only)
Gui.<Form>.lookupName.AssociatedControl("txtName") ' TextBox or Button that triggers the lookup
Gui.<Form>.lookupName.MultiSelect(bFlag)            ' Enable/disable multi-row selection
Gui.<Form>.lookupName.ColumnNames("Col1","Col2")    ' Set column header names (variadic)
Gui.<Form>.lookupName.ColumnVisibility(True,False)   ' Set column visibility per column (variadic)
Gui.<Form>.lookupName.ColumnVisibleIndices(0,2)      ' Set visible columns by new index order (variadic)
Gui.<Form>.lookupName.BeakLocation(V.Enum.BeakLocation) ' Set beak/callout position (Enumeration)
Gui.<Form>.lookupName.Event(SelectionMade,lookupName_SelectionMade)
Gui.<Form>.lookupName.Event(RefreshRequested,lookupName_RefreshRequested)
```

#### PreferredStyle Values
| Value | Style |
|-------|-------|
| `0` | Default |
| `1` | Grid-style browser |
| `2` | Alternate style |

#### Runtime Methods
```
Gui.<Form>.lookupName.DataTableBasis("dtName")   ' Bind DataTable (PopulateMode 4)
Gui.<Form>.lookupName.Show                        ' Display the lookup dialog
Gui.<Form>.lookupName.Initialize                  ' Reinitialize the control
Gui.<Form>.lookupName.Enabled(False)              ' Disable at runtime
```

#### Result Retrieval
When a selection is made, GAB auto-generates a result set named `<LookupName>_Result`:

**PopulateMode 0 (GSS Entity) -- results in V.Object:**
```
V.Object.<LookupName>_Result(0).<Column>!FieldValTrim
```

**PopulateMode 4 (DataTable) -- results in V.DataTable:**
```
V.DataTable.<LookupName>_Result(0).<Column>!FieldValTrim
```

**FullRow access (raw delimited data):**
```
V.DataTable.<LookupName>_Result(0).FullRow
```

#### Example: PopulateMode 0 (GSS Entity -- Customer Lookup)
```
' ScreenSU
Gui.<Form>.lookupCust.Create(Lookup)
Gui.<Form>.lookupCust.Enabled(True)
Gui.<Form>.lookupCust.PopulateMode(0)
Gui.<Form>.lookupCust.Title("Customer Lookup")
Gui.<Form>.lookupCust.StringBasis("")
Gui.<Form>.lookupCust.FileBasis("")
Gui.<Form>.lookupCust.ColumnDelim("")
Gui.<Form>.lookupCust.RowDelim("")
Gui.<Form>.lookupCust.PreferredStyle(0)
Gui.<Form>.lookupCust.LookupMode(18)
Gui.<Form>.lookupCust.Event(SelectionMade,lookupCust_SelectionMade)
Gui.<Form>.lookupCust.AssociatedControl("txtCust")

' Runtime -- show the lookup
Gui.<Form>.lookupCust.Show

' SelectionMade handler -- read result from V.Object
Gui.<Form>.txtCust.Text(V.Object.LookupCust_Result(0).CustomerNumber!FieldValTrim)
```

#### Example: PopulateMode 2 (String-based)
```
' ScreenSU
Gui.<Form>.lookupString.Create(Lookup)
Gui.<Form>.lookupString.Enabled(True)
Gui.<Form>.lookupString.PopulateMode(2)
Gui.<Form>.lookupString.Title("GSS Lookup")
Gui.<Form>.lookupString.StringBasis("")
Gui.<Form>.lookupString.FileBasis("")
Gui.<Form>.lookupString.ColumnDelim("")
Gui.<Form>.lookupString.RowDelim("")
Gui.<Form>.lookupString.PreferredStyle(0)
Gui.<Form>.lookupString.Event(SelectionMade,lookupString_SelectionMade)
```

#### Example: PopulateMode 3 (File-based)
```
' ScreenSU
Gui.<Form>.lookupFile.Create(Lookup)
Gui.<Form>.lookupFile.Enabled(True)
Gui.<Form>.lookupFile.PopulateMode(3)
Gui.<Form>.lookupFile.Title("GSS Lookup")
Gui.<Form>.lookupFile.StringBasis("")
Gui.<Form>.lookupFile.FileBasis("")
Gui.<Form>.lookupFile.ColumnDelim("")
Gui.<Form>.lookupFile.RowDelim("")
Gui.<Form>.lookupFile.PreferredStyle(0)
Gui.<Form>.lookupFile.Event(SelectionMade,lookupFile_SelectionMade)
```

#### Example: PopulateMode 4 (DataTable-based -- Inventory Lookup)
```
' ScreenSU
Gui.<Form>.lookupPart.Create(Lookup)
Gui.<Form>.lookupPart.Enabled(True)
Gui.<Form>.lookupPart.PopulateMode(4)
Gui.<Form>.lookupPart.Title("Inventory Lookup")
Gui.<Form>.lookupPart.StringBasis("")
Gui.<Form>.lookupPart.FileBasis("")
Gui.<Form>.lookupPart.ColumnDelim("")
Gui.<Form>.lookupPart.RowDelim("")
Gui.<Form>.lookupPart.PreferredStyle(1)
Gui.<Form>.lookupPart.AssociatedControl("txtPartNo")
Gui.<Form>.lookupPart.Event(SelectionMade,lookupPart_SelectionMade)

' Runtime -- bind DataTable then show
Gui.<Form>.lookupPart.DataTableBasis("dtInventoryBrowser")
Gui.<Form>.lookupPart.Show

' SelectionMade handler -- read result from V.DataTable
Gui.<Form>.txtPartNo.Text(V.DataTable.lookupPart_Result(0).Part!FieldValTrim)
```

### MonthView
A calendar date picker control for selecting dates.
```
Gui.<Form>.monthView1.Create(MonthView)
Gui.<Form>.monthView1.Enabled(True)
Gui.<Form>.monthView1.Visible(True)
Gui.<Form>.monthView1.Zorder(0)
Gui.<Form>.monthView1.Size(3480,3285)
Gui.<Form>.monthView1.Position(120,270)
Gui.<Form>.monthView1.Event(Change,monthView1_Change)
Gui.<Form>.monthView1.Event(MouseClick,monthView1_MouseClick)
Gui.<Form>.monthView1.Event(MouseDown,monthView1_MouseDown)
Gui.<Form>.monthView1.Event(MouseMove,monthView1_MouseMove)
Gui.<Form>.monthView1.Event(MouseUp,monthView1_MouseUp)
Gui.<Form>.monthView1.Event(GotFocus,monthView1_GotFocus)
Gui.<Form>.monthView1.Event(LostFocus,monthView1_LostFocus)
```

#### MonthView Events V.Args

**Mouse events** (MouseClick, MouseDown, MouseMove, MouseUp):

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "MONTHVIEW1") |
| `V.Args.ControlType` | String | "MONTHVIEW" |
| `V.Args.EventType` | String | Event name (e.g. "MOUSECLICK") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Change, GotFocus, LostFocus events:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "MONTHVIEW" |
| `V.Args.EventType` | String | Event name (e.g. "CHANGE") |

**Event chain when clicking a date:** MouseDown -> LostFocus -> MouseUp -> Change -> MouseClick

**Event chain on initial focus:** GotFocus -> LostFocus

### NavFrame
A navigation frame container that hosts NavPage children for tabbed/paged navigation.
```
Gui.<Form>.nav1.Create(NavFrame)
Gui.<Form>.nav1.Enabled(True)
Gui.<Form>.nav1.Visible(True)
Gui.<Form>.nav1.Zorder(0)
Gui.<Form>.nav1.Size(3000,3000)
Gui.<Form>.nav1.Position(120,195)
```

#### NavFrame Runtime Methods
```
Gui.<Form>.nav1.Enabled(Boolean)                ' Enable/disable the control
Gui.<Form>.nav1.TabStop(Boolean)                 ' Set whether tab stops on this control
Gui.<Form>.nav1.UseAnimations(Boolean)           ' Enable/disable slide/fade transition animations
Gui.<Form>.nav1.AnimationLengthInMS(iDuration)   ' Animation duration in milliseconds
Gui.<Form>.nav1.SelectedIndex(iPageIndex)        ' Set the active page by index
```

#### NavFrame V.Screen Properties

Access via `V.Screen.<Form>!nav1.<Property>` or `V.Screen.<Form>.nav1.<Property>`

| Property | Description |
|----------|-------------|
| `Anchor` | Anchor setting |
| `AnimationLengthInMS` | Animation duration in milliseconds |
| `ControlType` | Returns the control type |
| `CurrentX` | Current X position |
| `CurrentY` | Current Y position |
| `Dock` | Dock setting |
| `Enabled` | Enabled state |
| `Focused` | Whether the control has focus |
| `Height` | Control height |
| `Hwnd` | Window handle |
| `Left` | Left position |
| `MetaData0`-`MetaData9` | 10 metadata storage slots |
| `SelectedIndex` | Currently selected page index |
| `Tab` | Tab value |
| `TabIndex` | Tab order index |
| `TabStop` | Whether tab stops on this control |
| `Top` | Top position |
| `Visible` | Visibility state |
| `Width` | Control width |
| `WindowHandle` | Window handle (alternate) |

### NavPage
A navigation page that lives inside a NavFrame. Each page acts as a container panel.
```
Gui.<Form>.navpage1.Create(NavPage,"Page 1","",240,240,)
Gui.<Form>.navpage1.Parent("nav1")
Gui.<Form>.navpage1.Event(Click,navpage1_Click)
Gui.<Form>.navpage1.Event(Drop,navpage1_Drop)
Gui.<Form>.navpage1.Event(MouseClick,navpage1_MouseClick)
Gui.<Form>.navpage1.Event(MouseDown,navpage1_MouseDown)
Gui.<Form>.navpage1.Event(MouseMove,navpage1_MouseMove)
Gui.<Form>.navpage1.Event(MouseUp,navpage1_MouseUp)
```

Create params: `Create(NavPage, Caption, ImageKey, Width, Height,)`

#### NavPage Events V.Args

**Mouse events** (MouseClick, MouseDown, MouseMove, MouseUp):

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "NAVPAGE1") |
| `V.Args.ControlType` | String | "NAVPAGE" |
| `V.Args.EventType` | String | Event name (e.g. "MOUSECLICK") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Click, Drop events:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "NAVPAGE" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK") |

#### NavPage Runtime Methods
```
Gui.<Form>.navpage1.Caption(String)                         ' Set page caption text
Gui.<Form>.navpage1.Locked(Boolean)                         ' Lock/unlock the page
Gui.<Form>.navpage1.Padding(Left, Top, Right, Bottom)       ' Set inner padding (all Long)
Gui.<Form>.navpage1.Picture(String)                         ' Set page icon/image by path or key
Gui.<Form>.navpage1.SvgPicture(V.Enum.Image [, W, H])      ' Set SVG image; Width/Height optional
Gui.<Form>.navpage1.ToolTip(String)                         ' Set tooltip text
Gui.<Form>.navpage1.UpdateLayout(FileName [, KeepVis])      ' Update layout from file; KeepVisibility defaults True
Gui.<Form>.navpage1.UseLayout(Boolean)                      ' Enable/disable layout usage
Gui.<Form>.navpage1.SetLayoutGroupVisible(Name, Boolean)    ' Show/hide a named layout group
Gui.<Form>.navpage1.SetLayoutGroupCollapsed(Name, Boolean)  ' Collapse/expand a named layout group
Gui.<Form>.navpage1.TabIndex(Long)                          ' Set tab order index
Gui.<Form>.navpage1.TabStop(Boolean)                        ' Set whether tab stops on this page
Gui.<Form>.navpage1.BackColor(color)                        ' Set background color (see overloads below)
```

**BackColor overloads:**
```
Gui.<Form>.navpage1.BackColor(V.Enum.ThemeColors!<color>)   ' Theme color enum
Gui.<Form>.navpage1.BackColor(Long)                         ' Color as Long
Gui.<Form>.navpage1.BackColor("#RRGGBB")                    ' Hex string
Gui.<Form>.navpage1.BackColor("#AARRGGBB")                  ' Hex string with alpha
Gui.<Form>.navpage1.BackColor("Red")                        ' Known color name
Gui.<Form>.navpage1.BackColor(R, G, B)                      ' RGB (Long, Long, Long)
Gui.<Form>.navpage1.BackColor(A, R, G, B)                   ' ARGB (Long, Long, Long, Long)
```

#### NavPage V.Screen Properties

Access via `V.Screen.<Form>!navpage1.<Property>` or `V.Screen.<Form>.navpage1.<Property>`

| Property | Description |
|----------|-------------|
| `BackColor` | Background color |
| `Caption` | Page caption text |
| `ControlType` | Returns the control type |
| `CurrentX` | Current X position |
| `CurrentY` | Current Y position |
| `Dock` | Dock setting |
| `Enabled` | Enabled state |
| `Focused` | Whether the control has focus |
| `Height` | Control height |
| `Hwnd` | Window handle |
| `InternationalID` | International ID value |
| `IsSelectedPage` | Whether this page is the currently selected page |
| `Left` | Left position |
| `MetaData0`-`MetaData9` | 10 metadata storage slots |
| `TabIndex` | Tab order index |
| `TabStop` | Whether tab stops on this control |
| `Text` | Text content |
| `ToolTip` | Tooltip text |
| `UseLayout` | Layout usage setting |
| `Visible` | Visibility state |
| `Width` | Control width |
| `WindowHandle` | Window handle (alternate) |

### Slider
A trackbar control for selecting a value within a range.
```
Gui.<Form>.sld1.Create(Slider)
Gui.<Form>.sld1.Enabled(True)
Gui.<Form>.sld1.Visible(True)
Gui.<Form>.sld1.Zorder(0)
Gui.<Form>.sld1.Size(2250,375)
Gui.<Form>.sld1.Position(120,450)
Gui.<Form>.sld1.Min(0)
Gui.<Form>.sld1.Max(100)
Gui.<Form>.sld1.Value(50)
Gui.<Form>.sld1.ExcludeFromUndo(True)
Gui.<Form>.sld1.Event(Change,sld1_Change)
Gui.<Form>.sld1.Event(Click,sld1_Click)
Gui.<Form>.sld1.Event(GotFocus,sld1_GotFocus)
Gui.<Form>.sld1.Event(LostFocus,sld1_LostFocus)
Gui.<Form>.sld1.Event(MouseClick,sld1_MouseClick)
Gui.<Form>.sld1.Event(MouseDown,sld1_MouseDown)
Gui.<Form>.sld1.Event(MouseMove,sld1_MouseMove)
Gui.<Form>.sld1.Event(MouseUp,sld1_MouseUp)
Gui.<Form>.sld1.Event(Scroll,sld1_Scroll)
```

#### Slider Events V.Args

**Mouse events** (Click, MouseClick, MouseDown, MouseMove, MouseUp):

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "SLD1") |
| `V.Args.ControlType` | String | "SLIDER" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Change, Scroll, GotFocus, LostFocus events:**

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "SLIDER" |
| `V.Args.EventType` | String | Event name (e.g. "SCROLL", "CHANGE") |

**Event chain when dragging:** MouseDown -> LostFocus -> MouseMove -> Scroll -> Change

### TreeView
A hierarchical tree control for displaying parent-child node structures. ControlType is `"TREEVIEW"`.
```
Gui.<Form>.trvName.Create(TreeView)
Gui.<Form>.trvName.Enabled(True)
Gui.<Form>.trvName.Visible(True)
Gui.<Form>.trvName.Zorder(0)
Gui.<Form>.trvName.Size(400,200)
Gui.<Form>.trvName.Position(13,9)
Gui.<Form>.trvName.FontName("Tahoma")
Gui.<Form>.trvName.FontSize(8.25)
Gui.<Form>.trvName.Event(Click,trvName_Click)
Gui.<Form>.trvName.Event(DoubleClick,trvName_DoubleClick)
Gui.<Form>.trvName.Event(DragDropFile,trvName_DragDropFile)
Gui.<Form>.trvName.Event(GotFocus,trvName_GotFocus)
Gui.<Form>.trvName.Event(LostFocus,trvName_LostFocus)
Gui.<Form>.trvName.Event(MouseClick,trvName_MouseClick)
Gui.<Form>.trvName.Event(MouseDown,trvName_MouseDown)
Gui.<Form>.trvName.Event(MouseMove,trvName_MouseMove)
Gui.<Form>.trvName.Event(MouseUp,trvName_MouseUp)
Gui.<Form>.trvName.Event(NodeClick,trvName_NodeClick)
Gui.<Form>.trvName.Event(NodeDoubleClick,trvName_NodeDoubleClick)

' Runtime methods
Gui.<Form>.trvName.AddTreeNode("Key","Text","ParentKey",sImageKey)
Gui.<Form>.trvName.SetNodeProps("Key","Bold",True)
Gui.<Form>.trvName.SetNodeProps("Key","ForeColor","Blue")
Gui.<Form>.trvName.CheckBoxes(True)
Gui.<Form>.trvName.ClearItems()
Gui.<Form>.trvName.RemoveItem("Key")
Gui.<Form>.trvName.KeyExist("Key",bReturn)
Gui.<Form>.trvName.RetrieveItemOrdinal("Key",lIndex)
Gui.<Form>.trvName.SetSelectedItemByKey("Key")
Gui.<Form>.trvName.SetSelectedItemByOrdinal(0)
```

#### TreeView Events V.Args

> Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Standard mouse events** (Click, DoubleClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None" for MouseMove) |
| `V.Args.Clicks` | Long | Number of clicks (0 for MouseMove, 1 for click, 2 for DoubleClick) |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Focus events** (GotFocus, LostFocus) -- 5 args:

Standard args only (EventSource, Screen, ControlName, ControlType, EventType). No additional args.

**NodeClick** -- 13 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Checked` | Boolean | Whether the clicked node's checkbox is checked (True/False) |
| `V.Args.FullPath` | String | Full path from root to clicked node (backslash-delimited, e.g. "inbox\unread") |
| `V.Args.Index` | Long | Zero-based index of the clicked node |
| `V.Args.Key` | String | Key of the clicked node |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.Button` | String | Mouse button ("Left", "Right") |
| `V.Args.Clicks` | Long | Number of clicks (1) |

**NodeDoubleClick** -- 13 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right") |
| `V.Args.Clicks` | Long | Number of clicks (2) |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.Checked` | Boolean | Whether the double-clicked node's checkbox is checked |
| `V.Args.FullPath` | String | Full path from root to the node (backslash-delimited) |
| `V.Args.Index` | Long | Zero-based index of the node |
| `V.Args.Key` | String | Key of the double-clicked node |

> **Note:** NodeClick and NodeDoubleClick have different arg ordering. NodeClick leads with Checked/FullPath/Index/Key then mouse args; NodeDoubleClick leads with Button/Clicks/X/Y then node args.

**DragDropFile** -- see DragDropFile event reference for args.

**Event chain on single click:** MouseDown -> LostFocus -> MouseUp -> Click -> MouseClick -> NodeClick
**Event chain on double click:** MouseDown -> DoubleClick -> NodeDoubleClick
**Event chain on focus gain:** GotFocus (previous control fires LostFocus)

### SplitContainer
A resizable split panel that divides the form into two sections. ControlType is `"SPLITCONTAINER"`.
```
Gui.<Form>.SplitContainer1.Create(SplitContainer)
Gui.<Form>.SplitContainer1.Enabled(True)
Gui.<Form>.SplitContainer1.Visible(True)
Gui.<Form>.SplitContainer1.Zorder(0)
Gui.<Form>.SplitContainer1.Size(483,258)
Gui.<Form>.SplitContainer1.Position(54,62)
Gui.<Form>.SplitContainer1.Orientation(0)            ' 0=Vertical, 1=Horizontal (or V.Enum.Orientation!)
Gui.<Form>.SplitContainer1.SplitterPosition(50)
Gui.<Form>.SplitContainer1.Collapsed(False)
Gui.<Form>.SplitContainer1.CollapsiblePanel(0)       ' 0=Panel1, 1=Panel2, other=None
Gui.<Form>.SplitContainer1.FixedPanel(0)             ' 0=Panel1, 1=Panel2, other=None (fixed on resize)
Gui.<Form>.SplitContainer1.Event(Click,SplitContainer1_Click)
Gui.<Form>.SplitContainer1.Event(DblClick,SplitContainer1_DblClick)
Gui.<Form>.SplitContainer1.Event(MouseClick,SplitContainer1_MouseClick)
Gui.<Form>.SplitContainer1.Event(MouseDown,SplitContainer1_MouseDown)
Gui.<Form>.SplitContainer1.Event(MouseMove,SplitContainer1_MouseMove)
Gui.<Form>.SplitContainer1.Event(MouseUp,SplitContainer1_MouseUp)
Gui.<Form>.SplitContainer1.Event(Panel1Click,SplitContainer1_Panel1Click)
Gui.<Form>.SplitContainer1.Event(Panel1DblClick,SplitContainer1_Panel1DblClick)
Gui.<Form>.SplitContainer1.Event(Panel2Click,SplitContainer1_Panel2Click)
Gui.<Form>.SplitContainer1.Event(Panel2DblClick,SplitContainer1_Panel2DblClick)
Gui.<Form>.SplitContainer1.Event(SplitterMoved,SplitContainer1_SplitterMoved)

' Child controls use Parent("SplitContainer1",0) for panel 1, ("SplitContainer1",1) for panel 2
```

#### SplitContainer Events V.Args

> Standard args (`V.Args.EventSource`, `V.Args.Screen`, `V.Args.ControlName`, `V.Args.ControlType`, `V.Args.EventType`) are present in every event and omitted from tables below.

**Standard mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Panel click events** (Panel1Click, Panel2Click, Panel1DblClick, Panel2DblClick) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Button` | String | Mouse button ("Left", "Right") |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.Panel` | Long | Which panel was clicked (1 or 2) |
| `V.Args.Clicks` | Long | Number of clicks (1 for click, 2 for dblclick) |

> **Note:** Panel events have a different arg layout than standard mouse events: they include `Panel` but exclude `Delta`, and the arg order differs (Button, Shift, X, Y, Panel, Clicks).

**SplitterMoved event** -- 5 args (standard args only)

**Event chain on single click:** MouseDown -> MouseMove -> MouseUp -> Click -> MouseClick

**Panel click events fire independently** from their own FORM events (e.g. FORM Event PANEL1CLICK).

### FlowFrame
A flow-layout container that auto-arranges child controls.
```
Gui.<Form>.flowName.Create(FlowFrame)
Gui.<Form>.flowName.Enabled(True)
Gui.<Form>.flowName.Visible(True)
Gui.<Form>.flowName.Zorder(0)
Gui.<Form>.flowName.Size(268,156)
Gui.<Form>.flowName.Position(18,27)
Gui.<Form>.flowName.WrapContents(False)
Gui.<Form>.flowName.AutoScroll(True)
Gui.<Form>.flowName.Dock(0)
Gui.<Form>.flowName.Event(Click,flowName_Click)
Gui.<Form>.flowName.Event(DblClick,flowName_DblClick)
Gui.<Form>.flowName.Event(MouseClick,flowName_MouseClick)
Gui.<Form>.flowName.Event(MouseDown,flowName_MouseDown)
Gui.<Form>.flowName.Event(MouseMove,flowName_MouseMove)
Gui.<Form>.flowName.Event(MouseUp,flowName_MouseUp)
Gui.<Form>.flowName.Event(GotFocus,flowName_GotFocus)
Gui.<Form>.flowName.Event(LostFocus,flowName_LostFocus)

' FlowFrame-specific methods
Gui.<Form>.flowName.FlowDirection(0)                ' 0=LeftToRight, 1=TopDown, 2=RightToLeft, 3=BottomUp; Direction as Long
Gui.<Form>.flowName.Clear(True)                     ' Removes all child controls; [DisposeControls as Boolean, default True]
Gui.<Form>.flowName.GetChildIndex("childName", iRet)  ' Gets index of a child control; ChildName as String, Return as Long
Gui.<Form>.flowName.SetChildIndex("childName", 0)   ' Sets index (display order) of a child; ChildName as String, Index as Long

' Child controls use FlowBreak to force a new row
Gui.<Form>.childControl.FlowBreak(True)
```

#### FlowFrame Events V.Args

**Mouse events** (Click, DblClick, MouseClick, MouseDown, MouseMove, MouseUp) -- 11 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "FLOW1") |
| `V.Args.ControlType` | String | "FLOWFRAME" |
| `V.Args.EventType` | String | Event name (e.g. "CLICK", "DBLCLICK", "MOUSEDOWN") |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks (2 for DblClick) |
| `V.Args.Shift` | Long | Shift key state |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |

**Focus events** (GotFocus, LostFocus) -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control |
| `V.Args.ControlType` | String | "FLOWFRAME" |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

### GsBarcode
A barcode image generator control. Does not render visually on the form; used to produce barcode
images as ByteArrays for storage in DataTables and display in GsGridControl image columns.

```
' ScreenSU -- create the control (no size/position needed)
Gui.<Form>.GsBarcodeControl1.Create(GsBarcode)

' Runtime -- generate a barcode image into a ByteArray variable
Gui.<Form>.GsBarcodeControl1.GetBarcodeImage(V.Enum.Symbology!Code128, sValue, bShowText, baReturnImage)
Gui.<Form>.GsBarcodeControl1.GetBarcodeImage(V.Enum.Symbology!QRCode, sValue, bShowText, baReturnImage)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| Symbology | V.Enum.Symbology | `Code128` or `QRCode` |
| Value | String | The data to encode |
| ShowText | Boolean | Whether to render human-readable text below the barcode |
| ReturnImage | ByteArray | Output variable that receives the barcode image bytes |

**Typical pattern -- generate barcodes into a DataTable for grid display:**
```
' 1. Add a ByteArray column to hold the images
F.Data.DataTable.AddColumn("dt", "Barcode", "ByteArray")

' 2. Loop rows and generate a barcode for each
V.Local.ImageByteArray.Declare(ByteArray)
V.Local.sKey.Declare(String,"")
F.Intrinsic.Control.For(V.Local.i, 0, V.DataTable.dt.RowCount--, 1)
    F.Intrinsic.String.Build("{0}-{1}", V.DataTable.dt(V.Local.i).Col1!FieldValTrim, V.DataTable.dt(V.Local.i).Col2!FieldValTrim, V.Local.sKey)
    Gui.<Form>.GsBarcodeControl1.GetBarcodeImage(V.Enum.Symbology!Code128, V.Local.sKey, False, V.Local.ImageByteArray)
    F.Data.DataTable.SetValue("dt", V.Local.i, "Barcode", V.Local.ImageByteArray)
F.Intrinsic.Control.Next(V.Local.i)

' 3. Bind to grid -- the ByteArray column renders as an image automatically
Gui.<Form>.gsGC1.AddGridviewFromDatatable("gv1","dt")
```

### GsChart
A charting control for data visualization (DevExpress ChartControl wrapper).
```
Gui.<Form>.gsChart1.Create(GsChart)
Gui.<Form>.gsChart1.Enabled(True)
Gui.<Form>.gsChart1.Visible(True)
Gui.<Form>.gsChart1.Zorder(0)
Gui.<Form>.gsChart1.Size(383,263)
Gui.<Form>.gsChart1.Position(36,64)
Gui.<Form>.gsChart1.Parent("frameName")
Gui.<Form>.gsChart1.Event(DragDrop,gsChart1_DragDrop)
Gui.<Form>.gsChart1.Event(MouseDown,gsChart1_MouseDown)
Gui.<Form>.gsChart1.Event(MouseMove,gsChart1_MouseMove)
Gui.<Form>.gsChart1.Event(MouseUp,gsChart1_MouseUp)
Gui.<Form>.gsChart1.Event(Resize,gsChart1_Resize)
Gui.<Form>.gsChart1.Event(GotFocus,gsChart1_GotFocus)
Gui.<Form>.gsChart1.Event(LostFocus,gsChart1_LostFocus)

' Runtime methods
Gui.<Form>.gsChart1.ClearChart
Gui.<Form>.gsChart1.CreatePieChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateFunnelChart("chartTitle",sSeries,iArg1,iArg2,iArg3,iArg4,bArg1,bArg2)
Gui.<Form>.gsChart1.CreateVertBarChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateHorzBarChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateVertLineChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateStackedLineChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateVertStackedBarChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateHorzStackedBarChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.CreateGanttChart("chartTitle","chartName",sSeries)
Gui.<Form>.gsChart1.SetChartProperty("PropertyGroup","SubGroup","PropertyName",iIndex,value)

' Appearance / labels
Gui.<Form>.gsChart1.SetSeriesColor(iSeriesIndex, V.Color.Red)     ' Sets series color; SeriesIndex as Long, Color as V.Color/Long
Gui.<Form>.gsChart1.ShowPointLabels(True)                          ' Shows/hides data point labels; Flag as Boolean

' Gantt-specific
Gui.<Form>.gsChart1.LinkGanttPoints(True)                          ' Shows/hides linking lines between Gantt bars; Flag as Boolean
Gui.<Form>.gsChart1.ShowConstantLn(True, "PROGRESS", "09/22/2014") ' Shows/hides a constant line; Visible as Boolean, LineName as String, Value as String
Gui.<Form>.gsChart1.SetScrollbarVisibility(True, True)             ' Shows/hides scrollbars; HorzVisible as Boolean, VertVisible as Boolean

' Context menu support
Gui.<Form>..ContextMenuCreate("ctxChart")
Gui.<Form>.gsChart1.ContextMenuAttach("ctxChart")
```

#### GsChart Events V.Args

> ControlType for all events: `"GSCHART"`

**Resize event** -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "GSCHART1") |
| `V.Args.ControlType` | String | "GSCHART" |
| `V.Args.EventType` | String | "RESIZE" |

**Focus events** (GotFocus, LostFocus) -- 5 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "GSCHART1") |
| `V.Args.ControlType` | String | "GSCHART" |
| `V.Args.EventType` | String | "GOTFOCUS" or "LOSTFOCUS" |

**Mouse events** (MouseDown, MouseMove, MouseUp) -- 12 args:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source of the event (e.g. "FORM") |
| `V.Args.Screen` | String | Name of the form |
| `V.Args.ControlName` | String | Name of the control (e.g. "GSCHART1") |
| `V.Args.ControlType` | String | "GSCHART" |
| `V.Args.EventType` | String | "MOUSEDOWN", "MOUSEMOVE", or "MOUSEUP" |
| `V.Args.Button` | String | Mouse button ("Left", "Right", "None") |
| `V.Args.Clicks` | Long | Number of clicks |
| `V.Args.Shift` | Long | Shift key state (0 = none) |
| `V.Args.Delta` | Long | Scroll delta |
| `V.Args.X` | Long | Mouse x-coordinate |
| `V.Args.Y` | Long | Mouse y-coordinate |
| `V.Args.Series` | String | Chart series under the mouse |

### GsLookUpControl
An auto-complete lookup control bound to GSS entity lookups. Uses `F.Global.Object.LoadLookUp` to load the entity catalog, then binds it to the control.

**ScreenSU setup:**
```
Gui.<Form>.luPart.Create(GsLookUpControl)
Gui.<Form>.luPart.Title("Parts")
Gui.<Form>.luPart.Size(647,24)
Gui.<Form>.luPart.Position(15,78)
Gui.<Form>.luPart.LookupMode(1154)                  ' GSS entity type ID
Gui.<Form>.luPart.Enabled(True)
Gui.<Form>.luPart.Visible(True)
Gui.<Form>.luPart.Zorder(0)
Gui.<Form>.luPart.Dock(0)
```

**Runtime configuration:**
```
Gui.<Form>.luPart.DisplayProperty("LongPartNumber") ' Property shown in the control's text area
Gui.<Form>.luPart.MultiSelect(False)                 ' Allow multiple selections (default: False)
Gui.<Form>.luPart.IsForcePopup(False)                ' True = always show popup; False = auto-complete only
Gui.<Form>.luPart.HookSequence(-1)                   ' GAB override hook sequence (-1 = first active sequence)
Gui.<Form>.luPart.UseHook(False)                     ' Set False to prevent GAB override scripts from running
Gui.<Form>.luPart.TabIndex(1)                        ' Tab order index
Gui.<Form>.luPart.TextEditStyle(0)                   ' 0 = editable text, 1 = non-editable (use with IsForcePopup)
Gui.<Form>.luPart.Enabled(True)
Gui.<Form>.luPart.PopulateMode(0)
Gui.<Form>.luPart.DataSource("oObjectName")          ' Bind to an entity object (for custom LookupMode 0)
Gui.<Form>.luPart.SetGridColumnCaptions("DictName")  ' Set column headers from a Dictionary
Gui.<Form>.luPart.Event(SelectionMade,luPart_SelectionMade)
```

**Hook override behavior:** Each lookup object has an assigned hook number. If a GAB override script is active on that hook, it will be called when the lookup is invoked -- even from within other GAB scripts. `HookSequence(-1)` runs the first active sequence on that hook. Set `UseHook(False)` to suppress override scripts.

**TextEditStyle + IsForcePopup:** Use these together. `TextEditStyle(1)` disables typing in the text box, so pair it with `IsForcePopup(True)` to ensure the popup always opens for selection.

**Runtime methods:**
```
Gui.<Form>.luPart.AddAutoCompleteItem("DisplayText","Value")
```

**SetGridColumnCaptions:** Pass the name of a Dictionary whose keys are property names and values are display captions. The lookup popup grid columns are renamed accordingly:
```
F.Data.Dictionary.Create("LookupCaptions",True)
F.Data.Dictionary.AddItem("LookupCaptions","PartNumber","PartNumber")
F.Data.Dictionary.AddItem("LookupCaptions","PartNumberRevision","Rev")
F.Data.Dictionary.AddItem("LookupCaptions","LocationCode","Location")
F.Data.Dictionary.AddItem("LookupCaptions","Description","Description")
Gui.<Form>.luPart.SetGridColumnCaptions("LookupCaptions")
```

**SelectionMade handler:** The `V.Args.lookupReturn` value is the name of the entity object containing the selected row(s). Use bracket notation to access properties dynamically. The key properties of the lookup object are always accessible in the handler, even if the lookup is overridden by a GAB hook script. Non-overridden lookups provide access to all displayed properties.
```
Program.Sub.luPart_SelectionMade.Start
F.Intrinsic.UI.Msgbox(V.Object.[V.Args.lookupReturn]!GetCount)
F.Intrinsic.UI.Msgbox(V.Object.[V.Args.lookupReturn](0).LongPartNumber!FieldVal)
Program.Sub.luPart_SelectionMade.End
```

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.EventSource` | String | Source identifier |
| `V.Args.Screen` | String | Form name |
| `V.Args.ControlName` | String | Control name (e.g., `"luPart"`) |
| `V.Args.ControlType` | String | Control type |
| `V.Args.EventType` | String | `"SelectionMade"` |
| `V.Args.lookupReturn` | String | Entity object instance name containing the selected result |

