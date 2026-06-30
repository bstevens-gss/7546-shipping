# GAB GsGridControl Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with DevExpress grids
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# GSGRIDCONTROL (DevExpress Grid)

## Binding Data
```
Gui.<Form>.gsGC.AddGridviewFromDatatable("gvName","dtName")
Gui.<Form>.gsGC.AddGridviewFromDataview("gvName","dtName","dvName")
Gui.<Form>.gsGC.MainView("gvName")
```

> **CRITICAL -- DataSource vs MainView (binding paths):**
> - Do **not** use `DataSource("dtName")` and `MainView("gvName")` together on the same `GsGridControl`. Pick one binding approach per grid.
> - **`DataSource`** is a read-only display shortcut: it does not support configuring the grid or columns through `SetGridviewProperty`, `SetColumnProperty`, and other APIs that take a gridview name. Do **not** combine it with `MainView` for the same binding.
> - For **editable** grids, or whenever you must set grid/column properties by gridview name, use **`AddGridviewFromDatatable` / `AddGridviewFromDataview`** and **`MainView`** only (see Grid Operations for `DataSource` when read-only display is sufficient).

> **CRITICAL -- DataTable/DataView naming for grid relations** (from `agents/AGENTS.GAB.md`):
> - **Child DataTable naming:** When creating a child DataTable for `F.Data.DataTable.AddRelation`, the child MUST use the `$` naming convention: `dtParent$dtChild` (e.g., `F.Data.DataTable.CreateFromSQL("dtStaging$dtStagExpand",...)`). A standalone name like `"dtStagExpand"` will not link correctly.
> - **`ToDataTable*` source name:** When calling `F.Data.DataView.ToDataTable` or `ToDataTableDistinct`, do NOT include the `$ChildDT` suffix in `SourceDataTableName`. Pass only the parent DataTable name (e.g., `"dtSalesOrders"`, not `"dtSalesOrders$dtWorkOrders"`).
> - **Redundant `AddRelation`:** Do NOT call `Gui.<Form>.gsGC.AddRelation` if `F.Data.DataTable.AddRelation` has already been established between the same parent and child -- the grid inherits the DataTable-level relation automatically.

## SetGridviewProperty

### Syntax
```
Gui.<Form>.<GsGridControlName>.SetGridviewProperty(sGridviewName, sPropertyName, PropertyValue)
```
- `sGridviewName` (String) -- name of the gridview
- `sPropertyName` (String) -- property name as a string literal; `V.Enum.GridViewPropertyNames!<Name>` is also valid but requires GSSVersion >= 2023.1
- `PropertyValue` -- value to set (type depends on property; most are Boolean unless noted)

### Gridview Properties Reference

| Property | Value Type | Description |
|----------|-----------|-------------|
| `ActiveFilterString` | String | Gets or sets the total filter expression for the current View. Assigning clears any previously applied filters. |
| `ActiveSortString` | String | Gets or sets the gridview's sort string. Assigning clears any previously applied column sorts. |
| `AllowAddRows` | Boolean | Enables the Data Navigator's Append button. If True but data source doesn't support adding rows, clicking Append does nothing. |
| `AllowColumnMoving` | Boolean | Whether end-users can move columns by dragging headers. |
| `AllowColumnResizing` | Boolean | Whether end-users can change column widths. |
| `AllowDeleteRows` | Boolean | Enables the Data Navigator's Delete button. If True but data source doesn't support deleting, clicking Delete does nothing. |
| `AllowFilter` | Boolean | Turns filtering mode on/off for the gridview. |
| `AllowSort` | Boolean | Turns sorting on/off. **Note:** disabling sorting also disables grouping (grouping requires sort). |
| `CheckboxSelectorField` | String | Name of the data source field bound to the checkbox column. |
| `ColumnPanelRowHeight` | Long | Column header row height in pixels. `-1` for auto-height based on header content. Height cannot be less than the auto-calculated value. |
| `Editable` | Boolean | Enables cell editor invocation. **Must be paired with `ReadOnly = False` for cells to actually accept edits.** Setting `Editable = True` alone only allows cell selection/highlighting. |
| `EnableAppearanceEvenRow` | Boolean | True to paint even rows using custom appearance; False to use default. |
| `EnableAppearanceOddRow` | Boolean | True to paint odd rows using custom appearance; False to use default. |
| `EnterKeyNavigation` | String | Where focus moves on Enter key press. Values: `Vertical`, `Horizontal`, `none`. |
| `ExpandAllGroups` | Boolean | Expands or collapses all groups. |
| `MultiSelect` | Boolean | Whether multiple rows can be selected. |
| `MultiSelectMode` | Long | Selection mode when MultiSelect is on. `0` = RowSelect, `1` = CellSelect, `2` = CheckboxSelect. |
| `OptionsFindAlwaysVisible` | Boolean | Whether the Find Panel is always visible. |
| `OptionsFindAllowFindInExpandedDetails` | Boolean | Whether to expand all grids and search within expanded detail views. |
| `OptionsFilterUseNewCustomFilterDialog` | Boolean | Whether the advanced custom filter dialog is used instead of the standard one. |
| `OptionsMenuShowAutoFilterRowItem` | Boolean | Whether "Show Auto Filter Row" appears in column header context menu. Default True. |
| `OptionsSelectionEnableAppearanceFocusedRow` | Boolean | Whether the focused row is highlighted. |
| `OptionsViewColumnAutoWidth` | Boolean | Whether column widths auto-adjust to match the View's width. Set False to preserve other column sizes when widening one. |
| `OptionsViewRowAutoHeight` | Boolean | Whether row height auto-adjusts to display cell contents. |
| `OptionsViewShowAutoFilterRow` | Boolean | Whether the auto filter row is displayed. Default False. |
| `OptionsViewShowFilterPanelMode` | String | When the Filter Panel is visible. Values: `Default` (shown when filter applied), `Never`, `ShowAlways`. |
| `ReadOnly` | Boolean | Prevents data modification. **Must be `False` (along with `Editable = True`) for cells to accept edits.** Column-level `ReadOnly` inherits from this gridview setting. |
| `RowHeight` | Long | Cell height in pixels within data rows. |
| `ShowAddNewSummaryItem` | Boolean | Whether the footer menu contains an item for adding multiple total summaries at runtime. |
| `ShowConditionalFormattingItem` | Boolean | Whether "Conditional Formatting" appears in column header context menu. Default False. |
| `ShowDetailTabs` | Boolean | Whether detail tabs are shown in detail sections when master rows are expanded. Must be True when there are multiple relations. |
| `ShowGroupPanel` | Boolean | Whether the group panel is visible. |
| `ShowGroupSortSummaryItems` | Boolean | Whether grouping column context menu contains commands for sorting by group summary values. |
| `ShowGroupSummaryMenu` | Boolean | Whether end-users can invoke a Group Summary Editor via context menu. |
| `ShowSummaryItemMode` | Boolean | Whether to show a 'Mode' summary sub-menu for calculating summaries against all rows or selection. |
| `ShowTotalSummaryMenu` | Boolean | Whether the view footer is displayed. |
| `SuppressNothingDates` | Boolean | When True, suppresses date columns that have no assigned value. |

### Examples
```
Gui.<Form>.gsGC.SetGridviewProperty("gvName","Editable",True)     ' Both required for editing
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ReadOnly",False)    ' Both required for editing
Gui.<Form>.gsGC.SetGridviewProperty("gvName","AllowSort",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","AllowFilter",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","AllowColumnResizing",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","AllowColumnMoving",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","AllowAddRows",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","AllowDeleteRows",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","MultiSelect",False)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","MultiSelectMode",2)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ShowGroupPanel",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ShowDetailTabs",False)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","OptionsViewColumnAutoWidth",False)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","OptionsViewRowAutoHeight",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","OptionsViewShowAutoFilterRow",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","OptionsFindAlwaysVisible",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","OptionsViewShowFilterPanelMode","ShowAlways")
Gui.<Form>.gsGC.SetGridviewProperty("gvName","OptionsSelectionEnableAppearanceFocusedRow",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","EnableAppearanceEvenRow",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","EnableAppearanceOddRow",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","EnterKeyNavigation","Vertical")
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ColumnPanelRowHeight",30)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","RowHeight",25)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","SuppressNothingDates",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ExpandAllGroups",True)
Gui.<Form>.gsGC.SetGridviewProperty("gvName","CheckboxSelectorField","Selected")
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ActiveFilterString","[Col] > 3")
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ActiveFilterString","")   ' Clear filter
Gui.<Form>.gsGC.SetGridviewProperty("gvName","ActiveSortString","ColName ASC")
```

> **Version requirement:** The `V.Enum.GridViewPropertyNames!` form requires GSSVersion >= 2023.1. On older runtimes it causes Error 5150 ("The specified variable {GRIDVIEWPROPERTYNAMES} does not exist"). String literals (shown above) work universally. Only use the enum form after a version check:
>
> ```
> F.Intrinsic.Control.If(V.Caller.GSSVersion,>=,2023.1)
>     Gui.<Form>.gsGC.SetGridviewProperty("gvName",V.Enum.GridViewPropertyNames!AllowSort,True)
> F.Intrinsic.Control.EndIf
> ```

> **CRITICAL -- Editable Column Rules:**
> Making grid cells editable requires **two** properties set as a pair. Setting only one will NOT work.
>
> **GridviewProperty** (gridview-level editing):
> ```
> Gui.<Form>.gsGC.SetGridviewProperty("gvName","Editable",True)
> Gui.<Form>.gsGC.SetGridviewProperty("gvName","ReadOnly",False)
> ```
>
> **ColumnProperty** (per-column editing):
> ```
> Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowEdit",True)
> Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ReadOnly",False)
> ```
>
> `Editable`/`AllowEdit` enables the cell editor; `ReadOnly = False` allows the value to actually change. Both are required.

## SetColumnProperty

### Syntax
```
Gui.<Form>.<GsGridControlName>.SetColumnProperty(sGridviewName, sColumnName, sPropertyName, PropertyValue)
```
- `sGridviewName` (String) -- name of the gridview
- `sColumnName` (String) -- name of the column
- `sPropertyName` (String) -- property name as a string literal; `V.Enum.ColumnPropertyNames!<Name>` is also valid but requires GSSVersion >= 2023.1
- `PropertyValue` -- value to set (type depends on property; most are Boolean unless noted)

### Header Appearance Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `HeaderBackColor` | String | Header background color. Use color name or hex (`"#FF0000"`, `"Blue"`, `V.Color.Red`). |
| `HeaderForeColor` | String | Header text color. |
| `HeaderFontName` | String | Header font family name (e.g. `"Times New Roman"`). |
| `HeaderFontSize` | Long | Header text size. |
| `HeaderFontBold` | Boolean | Header bold text. |
| `HeaderFontItalic` | Boolean | Header italic text. |
| `HeaderFontStrikeOut` | Boolean | Header strikeout text. |
| `HeaderFontUnderline` | Boolean | Header underline text. |
| `HeaderImage` | String | File path to image displayed in header cell. Not available for Get command. |
| `HeaderHAlignment` | String | Header horizontal alignment. Values: `Far`, `Center`, `Near`, `Default`. |
| `HeaderHotkeyPrefix` | String | Hot key prefix for header text. Values: `None`, `Show`, `Hide`, `Default`. |
| `HeaderTrimming` | String | How header text is trimmed when it overflows. Values: `Default`, `None`, `Character`, `Word`, `EllipsisCharacter`, `EllipsisWord`, `EllipsisPath`. |
| `HeaderVAlignment` | String | Header vertical alignment. Values: `Top`, `Center`, `Bottom`, `Default`. |
| `HeaderWordWrap` | String | Header word wrapping. Values: `Default`, `Wrap`, `NoWrap`. Also increase `ColumnPanelRowHeight` on the gridview to accommodate wrapped text. |

### Cell Appearance Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `CellBackColor` | String | Cell background color. Use color name, hex, or `V.Color.*`. |
| `CellForeColor` | String | Cell text color. |
| `CellFontName` | String | Cell font family name. |
| `CellFontSize` | Long | Cell text size. |
| `CellFontBold` | Boolean | Cell bold text. |
| `CellFontItalic` | Boolean | Cell italic text. |
| `CellFontStrikeOut` | Boolean | Cell strikeout text. |
| `CellFontUnderline` | Boolean | Cell underline text. |
| `CellImage` | String | File path to image displayed in cell. Not available for Get command. |
| `CellHAlignment` | String | Cell horizontal alignment. Values: `Far`, `Center`, `Near`, `Default`. |
| `CellHotkeyPrefix` | String | Hot key prefix for cell text. Values: `None`, `Show`, `Hide`. |
| `CellTrimming` | String | How cell text is trimmed when it overflows. Values: `Default`, `None`, `Character`, `Word`, `EllipsisCharacter`, `EllipsisWord`, `EllipsisPath`. |
| `CellVAlignment` | String | Cell vertical alignment. Values: `Top`, `Center`, `Bottom`, `Default`. |
| `CellWordWrap` | String | Cell word wrapping. Values: `Default`, `Wrap`, `NoWrap`. Also set gridview `OptionsViewRowAutoHeight` to True. |

### Column Image Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `Image` | String | File path to image displayed in column header. Not available for Get command. |
| `ImageAlignment` | String | Column header image alignment. Values: `Center`, `Near`, `Far`. |
| `ImageIndex` | Long | Index of image displayed in column header. |
| `Icon` | String | Built-in icon for column header. Values: `DCS-ON`, `DCS-OFF`, `BROWSE`, `REFRESH`, or `V.Enum.Image!*`. |

### General Column Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `Visible` | Boolean | Whether the column is visible. |
| `ReadOnly` | Boolean | Whether end-users are prevented from editing cell values. |
| `Width` | Long | Column width in pixels. |
| `MinWidth` | Long | Column minimum width. |
| `MaxWidth` | Long | Column maximum width. |
| `Fixed` | String | Column anchoring during horizontal scroll. Values: `Left`, `None`, `Right`. |
| `ShowButtonMode` | String | Which cells display editor buttons. Values: `ShowAlways`, `ShowForFocusedRow`, `ShowForFocusedCell`, `ShowOnlyInEditor`. |
| `ToolTip` | String | Custom tooltip for the column. |
| `VisibleIndex` | Long | Column visible position within the View. Use `Visible` property to hide columns. |
| `IsHyperLink` | Boolean | Whether column cells render as hyperlinks. |
| `MaxLength` | Long | Maximum characters an end-user can enter. `0` disables the limit (default). Code can still assign longer values. |
| `Caption` | String | Column header caption text. |
| `GroupIndex` | Long | Column's position among grouping columns. `-1` = not grouped (default). |
| `SortOrder` | String | Column sort order. Values: `Ascending`, `Descending`. Default is `None`. Assigning adds to existing sort (does not clear previous). |
| `ShowCaption` | Boolean | Whether column caption is shown. |

### OptionsColumn Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `AllowEdit` | Boolean | Whether end-users can invoke cell editors. **Must be paired with `ReadOnly = False` for the column to actually accept edits.** Setting `AllowEdit = True` alone only allows cell selection/highlighting. |
| `AllowFocus` | Boolean | Whether the column can receive focus. |
| `AllowGroup` | Boolean/String | Whether column can be grouped. Values: `True`, `False`, `Default`. |
| `AllowIncrementalSearch` | Boolean | Whether to search all rows or from the cursor point. |
| `AllowMerge` | Boolean/String | Whether column cells can be merged. Values: `True`, `False`, `Default`. |
| `AllowMove` | Boolean | Whether column can be moved (dragged). |
| `AllowShowHide` | Boolean | Whether column appears in Show/Hide column chooser. |
| `AllowSize` | Boolean | Whether column width can be resized by users. |
| `AllowSort` | Boolean/String | Whether column sorting is allowed. Values: `True`, `False`, `Default`. |
| `FixedWidth` | Boolean | Whether column width is fixed (not adjustable). |
| `Printable` | Boolean/String | Whether column data is included when printing. Values: `True`, `False`, `Default`. |
| `TabStop` | Boolean | Whether column can be focused via TAB key. When False, cells can still be focused via mouse or arrow keys. |
| `ShowInColumnChooser` | Boolean | Whether column appears in the column chooser dialog. |

### OptionsFilter Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `AllowAutoFilter` | Boolean | Whether column auto filter is enabled. |
| `AllowFilter` | Boolean | Whether column filtering is enabled. |
| `ImmediateUpdateAutoFilter` | Boolean | Whether data updates immediately after filtering. |
| `ImmediateUpdatePopupDateFilterOnCheck` | Boolean/String | Whether data filters immediately when toggling calendar check boxes. Values: `True`, `False`, `Default`. |
| `ImmediateUpdatePopupDateFilterOnDateChange` | Boolean/String | Whether data filters immediately when selecting a date via calendar. Values: `True`, `False`, `Default`. |
| `FilterPopUpMode` | String | Column filter menu style. Values: `Default`, `List`, `CheckedList`, `Date`, `DateSmart`, `DateAlt`, `Excel`. |
| `ShowBlanksFilterItems` | Boolean/String | Whether filter dropdown shows "(Blanks)" and "(Non Blanks)" items. Values: `True`, `False`, `Default`. |
| `ShowEmptyDateFilter` | Boolean | Whether filter dropdown has a null-date filter item. |

### Display Format Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `DisplayFormatType` | String | Format type for the column. Values: `Numeric`, `DateTime`, `None`. |
| `DisplayCustomNumeric` | String | Numeric format string (e.g. `"$ #,##0.00"`). |
| `DisplayCustomDatetime` | String | DateTime format specifier. `d`=short date, `D`=long date, `t`=short time, `T`=long time, `f`=full (short time), `F`=full (long time), `g`=general (short time), `G`=general (long time). |
| `DisplayCustomString` | String | String display format (e.g. `"00#-#"`, `"{0:N2}"`). |

### Edit Mask Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `EditMaskType` | String | Mask type. Values: `DateTime`, `DateTimeAdvancingCaret`, `None`, `Numeric`, `RegEx`. |
| `EditMask` | String | Mask expression (syntax depends on `EditMaskType`). |
| `EditMaskAsDisplayFormat` | Boolean | Whether display values use the mask when editor is not focused. |

### Progress Bar Properties

| Property | Value Type | Description |
|----------|-----------|-------------|
| `ProgressBarEnabled` | Boolean | Enables progress bar display in column cells. |
| `ProgressBarMinimum` | Long | Progress bar minimum value. |
| `ProgressBarMaximum` | Long | Progress bar maximum value. |
| `ProgressBarShowTitle` | Boolean | Whether progress text is displayed. |
| `ProgressBarPercentView` | Boolean | Whether progress is shown as percentage. |
| `ProgressBarStartColor` | String | Progress bar starting color. |
| `ProgressBarEndColor` | String | Progress bar ending color. |

### Examples
```
' Header styling
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderBackColor","#FF0000")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderForeColor",V.Color.Red)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderFontName","Times New Roman")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderFontSize",10)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderFontBold",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderHAlignment","Center")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderVAlignment","Center")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderWordWrap","Wrap")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","HeaderTrimming","Word")

' Cell styling
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellBackColor",V.Color.LtGray)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellForeColor","Blue")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellFontBold",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellFontSize",10)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellHAlignment","Center")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellVAlignment","Top")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellWordWrap","Wrap")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","CellTrimming","EllipsisCharacter")

' General properties
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","Caption","Display Name")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","Visible",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowEdit",True)    ' Both required for editing
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ReadOnly",False)    ' Both required for editing
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","Width",100)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","MinWidth",50)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","MaxWidth",200)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","Fixed","Left")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","VisibleIndex",iIndex)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ToolTip","Tooltip text")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","IsHyperLink",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","MaxLength",120)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ShowButtonMode","ShowAlways")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ShowCaption",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","Icon",V.Enum.Image!EDIT_COLOR)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","GroupIndex",1)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","SortOrder","Ascending")

' OptionsColumn
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowEdit",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowFocus",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowGroup",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowIncrementalSearch",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowMerge",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowMove",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowShowHide",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowSize",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowSort",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","FixedWidth",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","Printable",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","TabStop",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ShowInColumnChooser",False)

' OptionsFilter
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowAutoFilter",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","AllowFilter",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ImmediateUpdateAutoFilter",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","FilterPopUpMode","DateSmart")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ShowBlanksFilterItems",False)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ShowEmptyDateFilter",False)

' Display formatting
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","DisplayFormatType","Numeric")
Gui.<Form>.gsGC.SetColumnProperty("gvName","AMT","DisplayCustomNumeric","$ #,##0.00")
Gui.<Form>.gsGC.SetColumnProperty("gvName","TRANS_DATE","DisplayCustomDatetime","d")
Gui.<Form>.gsGC.SetColumnProperty("gvName","RECORD_NO","DisplayCustomString","00#-#")

' Edit masks
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","EditMaskType","Numeric")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","EditMask","0000000")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","EditMaskAsDisplayFormat",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","EditMaskType","RegEx")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","EditMask","[0-9]+:[0-5][0-9]")

' Progress bar in column
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarEnabled",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarMinimum",0)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarMaximum",100)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarStartColor","Purple")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarEndColor","LimeGreen")
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarPercentView",True)
Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName","ProgressBarShowTitle",True)
```

> **Version requirement:** The `V.Enum.ColumnPropertyNames!` form requires GSSVersion >= 2023.1. On older runtimes it causes Error 5150 ("The specified variable {COLUMNPROPERTYNAMES} does not exist"). String literals (shown above) work universally. Only use the enum form after a version check:
>
> ```
> F.Intrinsic.Control.If(V.Caller.GSSVersion,>=,2023.1)
>     Gui.<Form>.gsGC.SetColumnProperty("gvName","ColName",V.Enum.ColumnPropertyNames!Caption,"Display Name")
> F.Intrinsic.Control.EndIf
> ```

## Grid Operations

> **CRITICAL -- Reading cell values in filtered grids:**
> `V.Args.FocusedRowHandle` from the `FocusedRowChanged` event is a **visual row index** (0 = first visible row), NOT a DataTable row handle. Both `GetCellValueByColumnName` and `GetCellValue` interpret the row parameter as a **DataTable index**. In unfiltered grids these are identical, so it works. In **filtered grids** they diverge — visual index 0 maps to a completely different DataTable row.
>
> **Fix:** Use `GetSelectedRows` to obtain the true DataTable row handle, then pass that handle to `GetCellValueByColumnName`:
> ```
> Gui.<Form>.gsGC.GetSelectedRows("gvName",V.Local.sSelectedRow)
> V.Local.iRow.Set(V.Local.sSelectedRow.Trim.Long)
> Gui.<Form>.gsGC.GetCellValueByColumnName("gvName","ColName",V.Local.iRow,V.Local.sResult)
> ```
> `GetRowHandle(visibleIndex)` does NOT work for this conversion (returns -1 in filtered grids). `GetSelectedRows` is the only reliable method. Verified 2026-05-25.

```
Gui.<Form>.gsGC.GetCellValueByColumnName("gvName","ColName",iDataTableRowHandle,V.Local.sResult)
Gui.<Form>.gsGC.GetFocusedGridview(V.Local.sDT)
Gui.<Form>.gsGC.CreateDataView("gvName","dtName","dvTemp")
Gui.<Form>.gsGC.BestFitColumns("gvName")
Gui.<Form>.gsGC.Export(sFilePath,"xlsx")
Gui.<Form>.gsGC.ShowRibbonPrintPreview()                                ' Print Preview with Ribbon UI
Gui.<Form>.gsGC.InvokeWait("Loading...")
Gui.<Form>.gsGC.HideWait
Gui.<Form>.gsGC.SuspendLayout
Gui.<Form>.gsGC.ResumeLayout
Gui.<Form>.gsGC.Serialize("gvName",V.Local.sLayout)
Gui.<Form>.gsGC.Deserialize(V.Local.sLayout)
Gui.<Form>.gsGC.SerializeChildView("gvChildName",V.Local.sChildLayout)
Gui.<Form>.gsGC.DeserializeChildView("gvChildName",V.Local.sChildLayout)
Gui.<Form>.gsGC.DataSource("dtName")                                   ' Read-only display binding only; do not use with MainView; not for editable or SetGridviewProperty/SetColumnProperty scenarios
Gui.<Form>.gsGC.Icon("C:\path\to\icon.ico")                            ' Set control icon
Gui.<Form>.gsGC.AddSummaryItem("gvName","ColName","SumID","Sum","Total: ","","n4")
Gui.<Form>.gsGC.RemoveSummaryItem("gvName","ColName","SumID")            ' Remove footer summary item
Gui.<Form>.gsGC.RemoveGridGroupSummaryItem("gvName","ColName","SumID")   ' Remove group summary item
Gui.<Form>.gsGC.ColumnEdit("gvName","ColName","EditorButton","BtnName")
Gui.<Form>.gsGC.ColumnEdit("gvName","ColName","lookup","RepoControlName")  ' Bind GsRepositoryLookup to column

' Cell-level appearance (set individual cell styling)
Gui.<Form>.gsGC.SetCellAppearance("gvName",iColIndex,iRowIndex,"BackColor",V.Enum.ThemeColors!ColorRed)
Gui.<Form>.gsGC.SetCellAppearance("gvName",iColIndex,iRowIndex,"BackColor",V.Enum.ThemeColors!ColorYellow)
Gui.<Form>.gsGC.SetCellAppearance("gvName",iColIndex,iRowIndex,"icon",V.Enum.Image!EDIT_COLOR)

' Cell-level appearance (read individual cell styling)
Gui.<Form>.gsGC.GetCellAppearance("gvName",iColIndex,iRowIndex,"BackColor",V.Local.sReturnValue)

' Cell-level property (read/write arbitrary cell properties)
Gui.<Form>.gsGC.GetCellProperty("gvName",iColIndex,iRowIndex,"PropertyName",V.Local.sResult)
Gui.<Form>.gsGC.SetCellProperty("gvName",iColIndex,iRowIndex,"PropertyName","PropertyValue")

' Grid Legend (color-coded legend displayed on grid)
Gui.<Form>.gsGC.GridLegendItem("gvName","ItemID","Display Text",V.Color.LtRed)
Gui.<Form>.gsGC.GridLegendItem("gvName","ItemID","Display Text",V.Enum.ThemeColors!ColorOrange)
Gui.<Form>.gsGC.GridLegendItem("gvName","ItemID","Display Text","58, 116, 194")   ' RGB string
Gui.<Form>.gsGC.AddGridLegend("gvName","Legend Title")

' Add column to grid at runtime (not from DataTable)
Gui.<Form>.gsGC.AddColumn("gvName","ColName","String")

' Per-row column editor (set different editors per row)
Gui.<Form>.gsGC.RowColumnEdit("gvName","ColName",iRow,"Dropdownlist","item1*!*item2*!*item3")

' Additional Grid Operations
Gui.<Form>.gsGC.AddGridview("gvName")                              ' Add empty gridview
Gui.<Form>.gsGC.AddRelation("gvParent","gvChild","PrimaryKey*!*Key2","ForeignKey*!*FK2","RelationName")  ' Master-detail (params: parentGV, childGV, PKs, FKs, name) -- REDUNDANT if F.Data.DataTable.AddRelation already established
Gui.<Form>.gsGC.ExpandMasterRow("gvName",iRowHandle)               ' Expand master-detail row
Gui.<Form>.gsGC.CollapseMasterRow("gvName",iRowHandle)
Gui.<Form>.gsGC.AddRow("gvName","val1*!*val2*!*val3")              ' Values must match column count (*!* delimited)
Gui.<Form>.gsGC.DeleteRow("gvName",iRow)                          ' Delete row
Gui.<Form>.gsGC.MoveRow("gvName",iFromRow,iToRow)
Gui.<Form>.gsGC.HideRow("gvName",iRow,True)                       ' 3 params: gridview, row, boolean (True=hide, False=show)
Gui.<Form>.gsGC.SelectRow("gvName",iRow)
Gui.<Form>.gsGC.FocusCell("gvName",iRow,iColIndex)  ' iColIndex = INTEGER column index (0-based), NOT a column name string. Use GetColumnIndexByName to resolve name→index.
Gui.<Form>.gsGC.GetCellValue("gvName",iColIndex,iRow,sResult)     ' 2nd param is INTEGER column index -- use GetCellValueByColumnName for string
Gui.<Form>.gsGC.SetCellValue("gvName",iColIndex,iRow,"value")     ' 2nd param is INTEGER column index -- use SetCellValueByColumnName for string
Gui.<Form>.gsGC.GetCellValueByColumnName("gvName","ColName",iRow,sResult)  ' Use THIS for column name lookup (string)
Gui.<Form>.gsGC.SetCellValueByColumnName("gvName","ColName",iRow,"value")
Gui.<Form>.gsGC.GetRowCount("gvName",iResult)
Gui.<Form>.gsGC.GetRowHandle("gvName",iVisibleIndex,iRowHandle)
Gui.<Form>.gsGC.GetRowValues("gvName",iRow,sResult)               ' Returns ALL columns as *!*-delimited string (no column filter param)
Gui.<Form>.gsGC.GetRowAppearance("gvName",iRow,"BackColor",sResult)
Gui.<Form>.gsGC.SetRowAppearance("gvName",iRow,"BackColor","Red")
Gui.<Form>.gsGC.SetRowProperty("gvName",iRow,"PropertyName",value)
Gui.<Form>.gsGC.GetColumnCount("gvName",iResult)
Gui.<Form>.gsGC.GetColumnIndexByName("gvName","ColName",iResult)
Gui.<Form>.gsGC.GetColumnNameByIndex("gvName",iIndex,sResult)
Gui.<Form>.gsGC.GetColumnProperty("gvName","ColName","PropertyName",sResult)
Gui.<Form>.gsGC.GetGridviewProperty("gvName","PropertyName",sResult)
Gui.<Form>.gsGC.GetSelectedRows("gvName",sResult)
Gui.<Form>.gsGC.GetSelectedRowsInFocus(sResult)                   ' 1 param ONLY (return var) -- uses currently focused view internally
Gui.<Form>.gsGC.FilterToWhereClause("gvName",sResult)             ' Convert active filter to SQL WHERE
Gui.<Form>.gsGC.ApplyFindFilter("gvName",sFilterString)           ' Set find panel filter programmatically
Gui.<Form>.gsGC.ClearFindFilter("gvName")                         ' Clear find panel filter
Gui.<Form>.gsGC.AllowMouseWheel(bValue)                            ' Enable/disable mouse wheel scrolling in editor
Gui.<Form>.gsGC.SetGridviewPrintOptions("gvName","Option",value)
Gui.<Form>.gsGC.ExportDetails("xlsx","C:\path\file.xlsx",0)       ' Params: format, filePath, mode (integer) -- NO gridview name
Gui.<Form>.gsGC.ClearGrouping("gvName")
Gui.<Form>.gsGC.ClearRows("gvName")

' Conditional formatting
Gui.<Form>.gsGC.AddStyleFormatCondition("gvName","ColName","condTag",V.Enum.ConditionalOperations!Greater,100)  ' Params: gv, COLUMN, tag, op, value
Gui.<Form>.gsGC.SetStyleFormatConditionProperty("gvName","ColName","condTag","BackColor","Red")  ' 5 params: gv, column, tag, property, value

' Summary items
Gui.<Form>.gsGC.AddGridGroupSummaryItem("gvName","ColName","SumID","Sum","","","n2")
```

## Grid Layout Persistence Pattern
```
' Save (Serialize)
Gui.<Form>.gsGC.Serialize("gvName",V.Local.sLayout)
F.Global.Registry.AddValue(V.Caller.User,V.Caller.CompanyCode,"PROGNAME",<RegID>,<Seq>,False,"Serialize",False,0,-999.0,1/1/1980,12:00:00 AM,V.Local.sLayout)

' Restore (Deserialize)
F.Global.Registry.ReadValue(V.Caller.User,V.Caller.CompanyCode,"PROGNAME",<RegID>,<Seq>,6,"",V.Local.sLayout)
F.Intrinsic.Control.If(V.Local.sLayout.Trim,<>,"")
    Gui.<Form>.gsGC.Deserialize(V.Local.sLayout)
F.Intrinsic.Control.EndIf
```

# GSADVBANDEDGRIDCONTROL (DevExpress Banded Grid)

The GsAdvBandedGridControl supports all standard GsGridControl operations (binding, column/row manipulation, serialization, export) plus banded-layout-specific methods. Use `Gui.<Form>.<BandedGridControlName>.*` syntax.

## Banded Grid -- Shared Methods
Methods shared with GsGridControl (same syntax, same behavior): `AddGridviewFromDatatable`, `AddGridviewFromDataview`, `MainView`, `AddColumn`, `AddGridview`, `AddRow`, `Datasource`, `Deserialize`, `GetCellValueByColumnName`, `SetColumnProperty`, `SetGridviewProperty`, `Serialize`, `Export`, `ExportDetails`. The same **DataSource vs MainView** rules as for `GsGridControl` apply: do not combine `Datasource` with `MainView` on the same control; use `AddGridviewFromDatatable` / `AddGridviewFromDataview` and `MainView` when you need named-view configuration or editing.

## Banded Grid -- Layout & Positioning
```
Gui.<Form>.<BandedGC>.Anchor(iAnchor)
Gui.<Form>.<BandedGC>.Dock(iDock)
Gui.<Form>.<BandedGC>.FlowBreak(bFlowBreak)
Gui.<Form>.<BandedGC>.Margin(fLeft,fTop,fRight,fBottom)
Gui.<Form>.<BandedGC>.Position(fX,fY)
Gui.<Form>.<BandedGC>.Size(fWidth,fHeight)
```

## Banded Grid -- Band Management
```
Gui.<Form>.<BandedGC>.AddGridBand("BandName","Caption")
Gui.<Form>.<BandedGC>.AddChildGridBand("ParentBandName","ChildBandName")
Gui.<Form>.<BandedGC>.AddBandedColumnToOwnerBand("FieldName","Caption",bVisible,"OwnerBandName",iRowIndex,bAutoFillDown,bReadOnly)
Gui.<Form>.<BandedGC>.AddBandedChildColumnToOwnerBand("FieldName","Caption",bVisible,"ParentBandName","ChildBandName",iRowIndex,bAutoFillDown,bReadOnly)
Gui.<Form>.<BandedGC>.BandedChildColumnEdit("ColName","ColumnStyle","Value")
```

---

# GRID CONTROL EVENTS

Wire events with `Gui.<Form>.<GridControl>.Event(<EventName>, <SubName>)`.
Subtable gridview events are linked to the parent table -- use the gridview name from V.Args to determine the source.

## GsGridControl Events

### Event(rowclick)
Fired when users click on the very left column or beginning of row. If users click the collapse/expand button, this fires first, then RowCellClick fires.
```
V.Args.Button
V.Args.Clicks
V.Args.Delta
V.Args.Handled
V.Args.Location
V.Args.RowHandle
V.Args.RowIndex
V.Args.IsGroupRow
V.Args.X
V.Args.Y
```

### Event(rowcellclick)
Fired when users click a data cell. If users click the collapse/expand button, RowClick fires first then this event. When the cell is not editable, fires on cell click.
```
V.Args.Button
V.Args.CellValue
V.Args.Clicks
V.Args.Column
V.Args.Delta
V.Args.Handled
V.Args.Location
V.Args.RowHandle
V.Args.RowIndex
V.Args.X
V.Args.Y
```

### Event(cellvaluechanged)
Fired when the value of a cell changes and focus moves to another object.
```
V.Args.Column
V.Args.RowHandle
V.Args.Value
V.Args.RowIndex
```

### Event(ColumnFilterChanged)
Fired when the filter value of a column changes.
```
V.Args.ActiveFilterCriteria
V.Args.ActiveFilterExpression
V.Args.ActiveFilterRowCount
V.Args.GridViewName
V.Args.GridControlName
V.Args.TableName
```

### Event(ColumnSortingChanged)
Fired when column sorting changes.
```
V.Args.ActiveSortString
V.Args.GridViewName
V.Args.GridControlName
V.Args.TableName
```

### Event(MouseCellEnter)
Fired when the mouse moves into (enters) a cell.
```
V.Args.GridViewName
V.Args.TableName
V.Args.Column
V.Args.Row
V.Args.SourceRowIndex
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
V.Args.Button
V.Args.Clicks
```

### Event(MouseCellExit)
Fired when the mouse moves out of (exits) a cell.
```
V.Args.GridViewName
V.Args.TableName
V.Args.Column
V.Args.Row
V.Args.SourceRowIndex
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
V.Args.Button
V.Args.Clicks
```

### Event(ColumnPositionChanged)
Fired when a column changes position within its gridview.
```
V.Args.GridViewName
V.Args.ColumnName
V.Args.ColumnIndex
V.Args.ColumnVisibleIndex          ' Default for Visible Index is -1
```

### Event(KeyPress)
Fired when a key is pressed within a gridview.
```
V.Args.GridControlName
V.Args.GridViewName
V.Args.ColumnName
V.Args.ColumnIndex
V.Args.RowHandle
V.Args.RowIndex
V.Args.CellValue
V.Args.KeyPress
V.Args.Character
```

### Event(KeyPressEnter)
Fired when the Enter key is pressed within a gridview.
```
V.Args.GridControlName
V.Args.GridViewName
V.Args.ColumnName
V.Args.ColumnIndex
V.Args.RowHandle
V.Args.RowIndex
V.Args.CellValue
```

### Event(focused row changed) / Event(FocusedRowChanged)
Fired when row focus changes.
> **CRITICAL:** The arg is `V.Args.FocusedRowHandle`, NOT `V.Args.RowHandle`. Using `V.Args.RowHandle` causes Error 5150 at runtime. Verified from production scripts (Johnson Bros 8319 series) and runtime testing (2026-05-24). Both GsGridControl and GsAdvBandedGridControl use the same arg names for this event.
> **CRITICAL:** `FocusedRowHandle` is a visual index — NOT a DataTable row handle. In filtered grids, use `GetSelectedRows` for the true DataTable handle. Guard with `If(V.Args.FocusedRowHandle,<,0)` for filter-row sentinel values. See § "Reading cell values in filtered grids" above.
```
V.Args.FocusedRowHandle
V.Args.PrevFocusedRowHandle
V.Args.ColumnName
```

## GsAdvBandedGridControl Events

Same event wiring pattern: `Gui.<Form>.<GsAdvBandedGridControl>.Event(<EventName>, <SubName>)`.

### Event(CellValueChanged)
Fired when a cell value changes and focus moves to another object.
```
V.Args.Column
V.Args.RowHandle
V.Args.Value
V.Args.RowIndex
```

### Event(ColumnFilterChanged)
Fired when the filter value of a column changes.
```
V.Args.ActiveFilterCriteria
V.Args.ActiveFilterExpression
V.Args.ActiveFilterRowCount
V.Args.GridViewName
V.Args.GridControlName
V.Args.TableName
```

### Event(ColumnPositionChanged)
Fired when a column changes position within its gridview.
```
V.Args.GridViewName
V.Args.ColumnName
V.Args.ColumnIndex
V.Args.ColumnVisibleIndex          ' Default for Visible Index is -1
```

### Event(KeyPress)
```
V.Args.GridControlName
V.Args.GridViewName
V.Args.ColumnName
V.Args.ColumnIndex
V.Args.RowHandle
V.Args.RowIndex
V.Args.CellValue
V.Args.KeyPress
V.Args.Character
```

### Event(KeyPressEnter)
```
V.Args.GridControlName
V.Args.GridViewName
V.Args.ColumnName
V.Args.ColumnIndex
V.Args.RowHandle
V.Args.RowIndex
V.Args.CellValue
```

### Event(MouseDown)
Fired when the mouse button is pressed.
```
V.Args.Button
V.Args.Clicks
V.Args.Shift
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
V.Args.GridViewName
V.Args.MouseRow
V.Args.MouseCol
```

### Event(MouseMove)
Fired when the mouse pointer moves over a view.
```
V.Args.Button
V.Args.Clicks
V.Args.Shift
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
V.Args.GridViewName
V.Args.MouseRow
V.Args.MouseCol
```

### Event(MouseUp)
Fired when the mouse button is released within a view.
```
V.Args.Button
V.Args.Clicks
V.Args.Shift
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
V.Args.GridViewName
V.Args.MouseRow
V.Args.MouseCol
```

### Event(RowCellClick)
Fired when a user clicks a data cell.
```
V.Args.Button
V.Args.CellValue
V.Args.Clicks
V.Args.Column
V.Args.Delta
V.Args.Handled
V.Args.Location
V.Args.RowHandle
V.Args.RowIndex
V.Args.IsGroupRow
V.Args.X
V.Args.Y
```

### Event(Rowclick)
Fired when users click on the very left column or beginning of row.
```
V.Args.Button
V.Args.Clicks
V.Args.Delta
V.Args.Handled
V.Args.Location
V.Args.RowHandle
V.Args.RowIndex
V.Args.IsGroupRow
V.Args.X
V.Args.Y
```

### Event(FocusedRowChanged)
Fired when row focus moves from one row to another.
> **Note:** Both GsGridControl and GsAdvBandedGridControl use the same arg names for this event.
```
V.Args.FocusedRowHandle
V.Args.PrevFocusedRowHandle
```

### Event(GotFocus)
Fired when a view receives focus.
```
V.Args.View
```

### Event(LostFocus)
Fired when a view loses focus.
```
V.Args.View
```

### Event(MouseCellEnter)
Fired when the mouse moves into (enters) a cell.
```
V.Args.GridViewName
V.Args.TableName
V.Args.MouseCol
V.Args.Row
V.Args.SourceRowIndex
V.Args.Button
V.Args.Clicks
V.Args.Shift
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
```

### Event(MouseCellExit)
Fired when the mouse moves out of (exits) a cell.
```
V.Args.GridViewName
V.Args.TableName
V.Args.MouseCol
V.Args.Row
V.Args.SourceRowIndex
V.Args.Button
V.Args.Clicks
V.Args.Shift
V.Args.Location
V.Args.Delta
V.Args.X
V.Args.Y
```

---

# Hierarchical Master-Detail Grid (Pattern I)

Queue-based iterative deepening for multi-level BOM explosions and similar tree structures.
Derived from production `Bom.g2u` pattern. See also `PITFALLS.md` "Multi-Level Grid Relation Rules" section for the full anti-pattern list.

## Critical Rules

1. **Root DT = DV = GV**: At root level, DataTable name, DataView name, and GridView name must ALL be identical. Using different names breaks the grid's internal view resolver.
2. **Child DT naming**: Child DataTables must use `$` separator: `rootDT$childDT` (e.g., `dtFullBOM$dtFullBOM_1`).
3. **AddGridViewFromDataView 2nd param**: ALWAYS the ROOT view name for ALL child levels (never the child's own DT name).
4. **AddRelation uniqueness**: The relation key column in the parent MUST have unique values. Use `SELECT DISTINCT` or composite keys.
5. **MainView after all children**: Call `MainView(rootName)` only after all child DataTables, relations, and gridviews are fully established.
6. **ExpandMasterRow per level**: Only expands direct children. Loop through `_1`, `_2`, `_3` suffixed views for deeper expansion.

## Complete Pattern

```
Program.Sub.Preflight.Start
V.Global.sDebugLogPath.Declare(String,"")
Program.Sub.Preflight.End

Program.Sub.Main.Start
V.Local.sSQL.Declare(String,"")
V.Local.sPart.Declare(String,"")
F.Intrinsic.UI.UsePixels

' --- Root query: level-0 children of the top part ---
V.Local.sPart.Set("210900")
F.Intrinsic.String.Build("SELECT DISTINCT RTRIM(PART) AS Part, RTRIM(PARENT) AS Parent, SEQUENCE_BOM AS Seq FROM V_BOM_MSTR WHERE PARENT='{0}' ORDER BY SEQUENCE_BOM",V.Local.sPart,V.Local.sSQL)
F.Data.DataTable.CreateFromSQL("dtFullBOM","",V.Local.sSQL)

' --- Bind root grid (DT = GV name, CRITICAL) ---
Gui.frmMain.gsGC.AddGridviewFromDatatable("dtFullBOM","dtFullBOM")

' --- Build tree via queue ---
F.Intrinsic.Control.CallSub(BuildFullBOM,"sRootDT","dtFullBOM")

' --- Activate grid ---
Gui.frmMain.gsGC.MainView("dtFullBOM")
Gui.frmMain..Show
Gui.frmMain..AlwaysOnTop(True)
Gui.frmMain..AlwaysOnTop(False)
Program.Sub.Main.End

Program.Sub.BuildFullBOM.Start
V.Local.sRootDT.Declare(String,"")
V.Local.sQueue.Declare(String,"")
V.Local.sParts.Declare(String,"")
V.Local.i.Declare(Long,0)
V.Local.iMax.Declare(Long,0)
V.Local.iLast.Declare(Long,0)
V.Local.iRow.Declare(Long,0)
V.Local.iRowMax.Declare(Long,0)
V.Local.iRowLast.Declare(Long,0)
V.Local.sChildDT.Declare(String,"")
V.Local.sChildPart.Declare(String,"")
V.Local.sSQL.Declare(String,"")
V.Local.iLevel.Declare(Long,1)
V.Local.sCurrentDT.Declare(String,"")
V.Local.sNewQueue.Declare(String,"")
F.Intrinsic.Variable.ArgToVar("sRootDT",V.Local.sRootDT)

' Seed queue with root DT name
V.Local.sQueue.Set(V.Local.sRootDT)

F.Intrinsic.Control.DoUntil(V.Local.sQueue,=,"")
    ' Process each DT in the current queue
    F.Intrinsic.String.Split(V.Local.sQueue,"*!*",V.Local.sParts)
    V.Local.iMax.Set(V.Local.sParts.UBound)
    F.Intrinsic.Math.Add(V.Local.iMax,1,V.Local.iMax)
    V.Local.sNewQueue.Set("")

    F.Intrinsic.Control.For(V.Local.i,0,V.Local.iMax,1)
        V.Local.sCurrentDT.Set(V.Local.sParts(V.Local.i))

        ' For each row in this DT, check if the Part has children
        V.Local.iRowMax.Set(V.DataTable.[V.Local.sCurrentDT].RowCount)
        F.Intrinsic.Math.Sub(V.Local.iRowMax,1,V.Local.iRowLast)

        F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iRowLast,1)
            V.Local.sChildPart.Set(V.DataTable.[V.Local.sCurrentDT](V.Local.iRow).Part!FieldValTrim)

            ' Query children of this part
            F.Intrinsic.String.Build("SELECT DISTINCT RTRIM(PART) AS Part, RTRIM(PARENT) AS Parent, SEQUENCE_BOM AS Seq FROM V_BOM_MSTR WHERE PARENT='{0}' ORDER BY SEQUENCE_BOM",V.Local.sChildPart,V.Local.sSQL)

            ' Child DT name uses $ convention
            F.Intrinsic.String.Build("{0}${1}_{2}",V.Local.sRootDT,V.Local.sRootDT,V.Local.iLevel,V.Local.sChildDT)

            F.Intrinsic.Control.Try
            F.Data.DataTable.CreateFromSQL(V.Local.sChildDT,"",V.Local.sSQL)

            ' Only proceed if child has rows
            F.Intrinsic.Control.If(V.DataTable.[V.Local.sChildDT].RowCount,>,0)
                ' Relation: parent Part column → child Parent column
                F.Data.DataTable.AddRelation(V.Local.sCurrentDT,V.Local.sChildDT,"Part","Parent")
                ' GridView: child DV name, ROOT name (always!), child DV name
                Gui.frmMain.gsGC.AddGridViewFromDataView(V.Local.sChildDT,V.Local.sRootDT,V.Local.sChildDT)
                ' Queue this child for deeper expansion
                F.Intrinsic.Control.If(V.Local.sNewQueue,=,"")
                    V.Local.sNewQueue.Set(V.Local.sChildDT)
                F.Intrinsic.Control.Else
                    F.Intrinsic.String.Build("{0}*!*{1}",V.Local.sNewQueue,V.Local.sChildDT,V.Local.sNewQueue)
                F.Intrinsic.Control.EndIf
            F.Intrinsic.Control.EndIf
            F.Intrinsic.Control.EndTry

            F.Intrinsic.Math.Add(V.Local.iLevel,1,V.Local.iLevel)
        F.Intrinsic.Control.Next(V.Local.iRow)
    F.Intrinsic.Control.Next(V.Local.i)

    ' Advance to next level
    V.Local.sQueue.Set(V.Local.sNewQueue)
F.Intrinsic.Control.Loop
Program.Sub.BuildFullBOM.End

Program.Sub.ExpandAllLevels.Start
V.Local.i.Declare(Long,0)
V.Local.iMax.Declare(Long,10)
V.Local.iRow.Declare(Long,0)
V.Local.iRowCount.Declare(Long,0)
V.Local.sViewName.Declare(String,"")
' Expand root level
V.Local.iRowCount.Set(V.DataTable.dtFullBOM.RowCount)
F.Intrinsic.Math.Sub(V.Local.iRowCount,1,V.Local.iRowCount)
F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iRowCount,1)
    Gui.frmMain.gsGC.ExpandMasterRow("dtFullBOM",V.Local.iRow)
F.Intrinsic.Control.Next(V.Local.iRow)
' Expand child levels (_1, _2, _3, ...)
F.Intrinsic.Control.For(V.Local.i,1,V.Local.iMax,1)
    F.Intrinsic.String.Build("dtFullBOM_{0}",V.Local.i,V.Local.sViewName)
    F.Intrinsic.Control.Try
    V.Local.iRowCount.Set(V.DataTable.[V.Local.sViewName].RowCount)
    F.Intrinsic.Math.Sub(V.Local.iRowCount,1,V.Local.iRowCount)
    F.Intrinsic.Control.For(V.Local.iRow,0,V.Local.iRowCount,1)
        Gui.frmMain.gsGC.ExpandMasterRow(V.Local.sViewName,V.Local.iRow)
    F.Intrinsic.Control.Next(V.Local.iRow)
    F.Intrinsic.Control.EndTry
F.Intrinsic.Control.Next(V.Local.i)
Program.Sub.ExpandAllLevels.End
```

## Key Takeaways

- The root DataTable/DataView/GridView share ONE name (e.g., `dtFullBOM`)
- Child DataTables use `$` naming: `dtFullBOM$dtFullBOM_1`, `dtFullBOM$dtFullBOM_2`...
- `AddGridViewFromDataView` second param is ALWAYS the root name
- `SELECT DISTINCT` on child queries prevents Error 21034 (duplicate key values)
- `MainView` comes AFTER all relations and child views are added
- `ExpandMasterRow` only works one level at a time -- loop through `_1`, `_2`, etc. for full expansion
- Use `Try/EndTry` around each child level to prevent one failed level from killing the whole tree
