# V.Enum Catalog
# Last verified: 2026-05-26 | Source: OCTSRS GabEnumDefinitions.vb + GabDefs.vb | Agent kit audit pass

> **This file is ~1,500 lines. Do NOT read it in full.** Use the guide below to load only what you need.

**Provenance:** Extracted from `agents/gab/VARIABLES.md`. Edit enum documentation here; `VARIABLES.md` links back to this file.

**Structure:** Two sections, both authoritative:
1. **Quick Reference** (lines 49-591) -- A single code block with the most common values for every enum type, grouped by category. **Read this first; it covers most coding needs.**
2. **Complete Member Lists** (lines 595+) -- One `## EnumType` section per enum with every member. Read only the section(s) you need via the TOC below.

---

## TOC: Find Enum Sections by Topic

| When working with... | Lines | Enum types |
|-----------------------|-------|-----------|
| **Grid view properties** | 914-926, 1487-1493 | GridViewPropertyNames, GridFindMode |
| **Grid column properties** | 1495-1507 | ColumnPropertyNames (additional members beyond quick-ref) |
| **Grid formatting & conditional** | 677-704, 884-890, 906-912 | ConditionalOperations, ConditionalPropertyNames, FormatTypes, GradientModes |
| **Grid selection & navigation** | 869-876, 1335-1354, 1382-1396 | EnterKeyNavigationMode, MultiselectMode, ShowButtonModes, ShowFilterPanelMode, Orientation |
| **Grid fixed/sort/filter** | 876-882 | FixedStyles |
| **Theme colors & accents** | 657-666, 1416-1453 | AccentColorCodes, ThemeColors (.Plus/.Minus/.Highlight) |
| **SVG icons (Image)** | 1029-1186 | Image -- 160-line icon catalog |
| **Image alignment** | 1188-1203 | ImageAlignToText |
| **Lookup controls** | 1236-1281 | LookupModes, LookupPopulateModes, LookupPreferredStyles |
| **Barcode controls** | 633-655, 1405-1414 | BarcodeOrientation, BarcodeText*, Symbology |
| **Date/time & mask** | 847-867, 1283-1291, 1342-1348 | DateTimeMask, MaskTypes, NumericOnlyMode |
| **PDF viewer** | 950-990, 1356-1360 | GsPdfViewer (36 props), PdfViewerToolBarType |
| **RichEdit & Spreadsheet** | 1369-1380, 1398-1403 | RichEditToolBarType, RichTextViewTypes, SpreadSheetToolBarType |
| **Toggle switch** | 992-1011 | GsToggleSwitch + related |
| **Accordion** | 595-605 | AccordionControlProperties, AccordionElementStyle |
| **Alerts / notifications** | 607-631 | AlertProgressModes, AlertPropertyNames |
| **Message box dialogs** | 1300-1333 | MsgBoxResult, MsgBoxStyle |
| **Form types & frames** | 892-904 | FormTypes, FrameBorderStyle |
| **Docking & layout** | 668-675, 729-747, 1205-1211, 1473-1485 | BeakLocation, DockingStyle, DockStyle, LabelAutoSizeModes, Visibility, WordWrap |
| **Text alignment & trimming** | 1013-1027, 1455-1471 | HorizontalAlignment, HotkeyPrefixModes, Trimming, VerticalAlignment |
| **Dashboard export** | 749-843 | DashboardViewerExport* (all formats) |
| **Decode / encoding** | 706-719 | DecodeFormats |
| **LINQ** | 1213-1227 | LinqJoinType, LinqSourceType |
| **GSSEO status codes** | 928-948 | GsseoStatusCodes |
| **Misc controls** | 721-727, 1229-1234, 1293-1298, 1362-1367 | DisableOnClickModes, LongPartType, MenuItemType, PictureBoxSizeMode |
| **Split containers** | 1515+ | SplitOrientation |
| **Variable types** | 1522+ | GabVariableTypes |
| **Banded grid** | 1530+ | GsAdvBandedGridViewPropertyNames, GsAdvBandedGridColumnPropertyNames |
| **Command protocol** | 1538+ | CommandProtocolPayloads |
| **Form icons** | 1544+ | FormIconApplication, FormIconModule, FormIconLogo |
| **Progress panel** | 1560+ | GsProgressPanelContentAlignment |

> **Line numbers are approximate** -- if they drift after edits, search for `## EnumTypeName` instead.

---

# V.Enum REFERENCE

```
' AccordionControl
V.Enum.AccordionControlProperties!AllowItemSelection   ' Enables item selection highlight on navigation panel

' LINQ
V.Enum.LinqJoinType!InnerJoin
V.Enum.LinqJoinType!LeftJoin
V.Enum.LinqSourceType!DataTable

' Grid (common -- see full list below under Grid View Property Names)
' NOTE: Grid enums (GridViewPropertyNames, ColumnPropertyNames, GsAdvBandedGrid*PropertyNames)
' require GSSVersion >= 2023.1. Prefer string literals unless the runtime version is verified.
V.Enum.GridViewPropertyNames!Editable
V.Enum.GridViewPropertyNames!ReadOnly
V.Enum.GridViewPropertyNames!AllowSort
V.Enum.GridViewPropertyNames!AllowFilter
V.Enum.ColumnPropertyNames!Caption
V.Enum.ColumnPropertyNames!Visible

' Theme Colors (cell/control appearance)
V.Enum.ThemeColors!ColorRed
V.Enum.ThemeColors!ColorRed.Highlight
V.Enum.ThemeColors!ColorYellow
V.Enum.ThemeColors!ColorBlue
V.Enum.ThemeColors!ColorOrange
V.Enum.ThemeColors!ColorBlack
V.Enum.ThemeColors!ColorGreen
V.Enum.ThemeColors!ColorGray
V.Enum.ThemeColors!ColorLightGray
V.Enum.ThemeColors!ColorPurple
V.Enum.ThemeColors!ColorWhite
V.Enum.ThemeColors!Red
V.Enum.ThemeColors!AccentColor
V.Enum.ThemeColors!AccentColorText
V.Enum.ThemeColors!AccentMinorColor
V.Enum.ThemeColors!ControlBackground
V.Enum.ThemeColors!GssGray
V.Enum.ThemeColors!GssGreen
V.Enum.ThemeColors!GssWhite
V.Enum.ThemeColors!TextHigh
V.Enum.ThemeColors!TextOnThemeColor
V.Enum.ThemeColors!ThemeColorDark

' ThemeColors Inline Transforms (chainable -- see full docs in "## ThemeColors" section below)
V.Enum.ThemeColors!ColorRed.Highlight              ' Highlight variant for grid cell/row coloring
V.Enum.ThemeColors!AccentColor.Plus(25)            ' 25% toward white (light themes) / black (dark themes)
V.Enum.ThemeColors!AccentColor.Minus(25)           ' 25% toward black (light themes) / white (dark themes)

' Images (SVG icons -- see full catalog in "## Image" section below)
' Use V.Enum.Image!NAME at runtime; use "icon_name" strings in ScreenSU
V.Enum.Image!ADD_BLACK
V.Enum.Image!EXPORT_COLOR
V.Enum.Image!ENTER_BLACK
V.Enum.Image!WARNING_BLACK

' BarDock
V.Enum.BarItemLinkAlignment!Left
V.Enum.BarItemLinkAlignment!Right
V.Enum.BarItemPaintStyle!CaptionGlyph

' GsBreadCrumb
V.Enum.GsBreadCrumb!BackColor
V.Enum.GsBreadCrumb!BorderStyle
V.Enum.GsBreadCrumb!ForeColor
V.Enum.GsBreadCrumb!Font
V.Enum.GsBreadCrumbColor!BlanchedAlmond
V.Enum.GsBreadCrumbColor!Blue
V.Enum.GsBreadCrumbBorderStyles!Style3D
V.Enum.GsBreadCrumbFontStyle!Bold
V.Enum.GsBreadCrumbFontGraphicsUnit!Pixel

' GsCardView
V.Enum.GsCardView!BorderStyle
V.Enum.GsCardView!ShowButtonMode
V.Enum.GsCardView!OptionsBehaviorFieldAutoHeight
V.Enum.GsCardView!CardWidth
V.Enum.GsCardView!OptionsSelectionMultiSelect
V.Enum.GsCardView!OptionsViewShowFieldCaptions
V.Enum.GsCardViewBorderStyle!Simple
V.Enum.GsCardViewShowButtonMode!ShowOnlyInEditor

' GsAdvBandedGrid -- Gridview Properties
' WARNING: These enums require GSSVersion >= 2023.1. Prefer string literals unless runtime version is verified.
V.Enum.GsAdvBandedGridViewPropertyNames!Editable
V.Enum.GsAdvBandedGridViewPropertyNames!EditingMode
V.Enum.GridEditingMode!Inplace

' GsAdvBandedGrid -- Column Properties
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowEdit
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowFocus
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowGroup
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowSort
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowMerge
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowMove
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowShowHide
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowSize
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowIncrementalSearch
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowFilter
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowAutoFilter
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowInHeaderSearch
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowFilterModeChanging
V.Enum.GsAdvBandedGridColumnPropertyNames!AllowSummaryMenu
V.Enum.GsAdvBandedGridColumnPropertyNames!AutoFillDown
V.Enum.GsAdvBandedGridColumnPropertyNames!AutoFilterCondition
V.Enum.GsAdvBandedGridColumnPropertyNames!Caption
V.Enum.GsAdvBandedGridColumnPropertyNames!CaptionLocation
V.Enum.GsAdvBandedGridColumnPropertyNames!ColIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!ColVIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!ColumnSpan
V.Enum.GsAdvBandedGridColumnPropertyNames!FieldName
V.Enum.GsAdvBandedGridColumnPropertyNames!FieldNameSortGroup
V.Enum.GsAdvBandedGridColumnPropertyNames!FilterBySortField
V.Enum.GsAdvBandedGridColumnPropertyNames!FilterMode
V.Enum.GsAdvBandedGridColumnPropertyNames!FilterPopupMode
V.Enum.GsAdvBandedGridColumnPropertyNames!FixedStyle
V.Enum.GsAdvBandedGridColumnPropertyNames!FixedWidth
V.Enum.GsAdvBandedGridColumnPropertyNames!GroupIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!GroupInterval
V.Enum.GsAdvBandedGridColumnPropertyNames!ImageAlignment
V.Enum.GsAdvBandedGridColumnPropertyNames!ImageIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!ImmediateUpdateAutoFilter
V.Enum.GsAdvBandedGridColumnPropertyNames!ImmediateUpdatePopupDateFilterOnCheck
V.Enum.GsAdvBandedGridColumnPropertyNames!ImmediateUpdatePopupDateFilterOnDateChange
V.Enum.GsAdvBandedGridColumnPropertyNames!ImmediateUpdatePopupExcelFilter
V.Enum.GsAdvBandedGridColumnPropertyNames!ImmediateUpdateRowPosition
V.Enum.GsAdvBandedGridColumnPropertyNames!InHeaderSearchPrompt
V.Enum.GsAdvBandedGridColumnPropertyNames!MaxWidth
V.Enum.GsAdvBandedGridColumnPropertyNames!MinWidth
V.Enum.GsAdvBandedGridColumnPropertyNames!Name
V.Enum.GsAdvBandedGridColumnPropertyNames!PopupExcelFilterDefaultTab
V.Enum.GsAdvBandedGridColumnPropertyNames!PopupExcelFilterDateTimeValuesTabFilterType
V.Enum.GsAdvBandedGridColumnPropertyNames!PopupExcelFilterEnumFilters
V.Enum.GsAdvBandedGridColumnPropertyNames!PopupExcelFilterGrouping
V.Enum.GsAdvBandedGridColumnPropertyNames!PopupExcelFilterNumericValuesTabFilterType
V.Enum.GsAdvBandedGridColumnPropertyNames!PopupExcelFilterTextFilters
V.Enum.GsAdvBandedGridColumnPropertyNames!Printable
V.Enum.GsAdvBandedGridColumnPropertyNames!ReadOnly
V.Enum.GsAdvBandedGridColumnPropertyNames!RowCount
V.Enum.GsAdvBandedGridColumnPropertyNames!RowIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!RowSpan
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowBlanksFilterItems
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowButtonMode
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowCaption
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowEmptyDateFilter
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowInCustomizationForm
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowInExpressionEditor
V.Enum.GsAdvBandedGridColumnPropertyNames!ShowUnboundExpressionMenu
V.Enum.GsAdvBandedGridColumnPropertyNames!SortIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!SortMode
V.Enum.GsAdvBandedGridColumnPropertyNames!SortOrder
V.Enum.GsAdvBandedGridColumnPropertyNames!StartNewRow
V.Enum.GsAdvBandedGridColumnPropertyNames!TabStop
V.Enum.GsAdvBandedGridColumnPropertyNames!ToolTip
V.Enum.GsAdvBandedGridColumnPropertyNames!UnboundExpression
V.Enum.GsAdvBandedGridColumnPropertyNames!UnboundType
V.Enum.GsAdvBandedGridColumnPropertyNames!UseEditorColRowSpan
V.Enum.GsAdvBandedGridColumnPropertyNames!Visible
V.Enum.GsAdvBandedGridColumnPropertyNames!VisibleIndex
V.Enum.GsAdvBandedGridColumnPropertyNames!Width

' GsAdvBandedGrid -- Related Enum Types
V.Enum.FixedStyle!None
V.Enum.FixedStyle!Left
V.Enum.FixedStyle!Right
V.Enum.ShowButtonMode!ShowAlways
V.Enum.ShowButtonMode!ShowForFocusedRow
V.Enum.ShowButtonMode!ShowForFocusedCell
V.Enum.ShowButtonMode!ShowOnlyInEditor
V.Enum.AutoFilterCondition!Default
V.Enum.AutoFilterCondition!Contains
V.Enum.AutoFilterCondition!Equals
V.Enum.FilterPopupMode!Default
V.Enum.FilterPopupMode!List
V.Enum.FilterPopupMode!CheckedList
V.Enum.FilterPopupMode!Date
V.Enum.FilterPopupMode!DateSmart
V.Enum.FilterPopupMode!DateAlt
V.Enum.FilterPopupMode!Excel
V.Enum.ColumnSortOrder!Ascending
V.Enum.ColumnSortOrder!Descending
V.Enum.ColumnSortOrder!None
V.Enum.ColumnSortMode!Default
V.Enum.ColumnSortMode!Value
V.Enum.ColumnSortMode!DisplayText
V.Enum.ColumnSortMode!Custom
V.Enum.ColumnFilterMode!Value
V.Enum.ColumnFilterMode!DisplayText
V.Enum.ColumnGroupInterval!Default
V.Enum.ColumnGroupInterval!Value
V.Enum.ColumnGroupInterval!Date
V.Enum.ColumnGroupInterval!DateMonth
V.Enum.ColumnGroupInterval!DateYear
V.Enum.ColumnGroupInterval!DateRange
V.Enum.StringAlignment!Near
V.Enum.StringAlignment!Center
V.Enum.StringAlignment!Far
V.Enum.UnboundColumnType!String
V.Enum.UnboundColumnType!Integer
V.Enum.UnboundColumnType!Decimal
V.Enum.UnboundColumnType!DateTime
V.Enum.UnboundColumnType!Boolean
V.Enum.UnboundColumnType!Object
V.Enum.UnboundColumnType!Bound

' GsTileView
V.Enum.GsTileView!OptionsTilesRowCount
V.Enum.GsTileView!OptionsTilesPadding
V.Enum.GsTileView!OptionsTilesItemPadding
V.Enum.GsTileView!OptionsTilesIndentBetweenItems
V.Enum.GsTileView!OptionsTilesItemSize
V.Enum.GsTileView!OptionsTilesOrientation
V.Enum.GsTileView!AppearanceItemNormalForeColor
V.Enum.GsTileView!AppearanceItemNormalBorderColor
V.Enum.GsTileView!AppearanceItemNormalBackColor
V.Enum.GsTileView!AppearanceNormalBackColor
V.Enum.GsTileView!AppearanceNormalFontSizeDelta
V.Enum.GsTileView!AppearanceNormalFontStyleDelta
V.Enum.GsTileView!AppearanceNormalFont
V.Enum.GsTileView!Text
V.Enum.GsTileView!TextLocation
V.Enum.GsTileView!AnchorIndent
V.Enum.GsTileView!ImageSize
V.Enum.GsTileView!ImageAlignment
V.Enum.GsTileView!ImageScaleMode
V.Enum.GsTileView!ImageLocation
V.Enum.GsTileViewOptionsTilesOrientation!Horizontal
V.Enum.GsTileViewOptionsTilesOrientation!Vertical
V.Enum.GsTileViewAppearanceColor!White
V.Enum.GsTileViewAppearanceColor!Transparent
V.Enum.GsTileViewAppearanceColor!Green
V.Enum.GsTileViewAppearanceColor!Red
V.Enum.GsTileViewItemElements!StretchVertical
V.Enum.GsTileViewItemElements!Width
V.Enum.GsTileViewItemElements!TextAlignment
V.Enum.GsTileViewItemElements!MaxWidth
V.Enum.GsTileViewItemElements!ColumnIndex
V.Enum.GsTileViewItemElementsTextAlignment!MiddleRight
V.Enum.GsTileViewItemElementsTextAlignment!TopLeft
V.Enum.GsTileViewItemElementsTextAlignment!BottomLeft
V.Enum.GsTileViewImageAlignment!MiddleRight
V.Enum.GsTileViewImageScaleMode!Stretch
V.Enum.GsTileViewAppearanceNormalFontStyleDelta!Bold
V.Enum.GsTileViewAppearanceNormalFontStyle!Regular
V.Enum.GsTileViewAppearanceNormalFontGraphicsUnit!Point

' Form Icons
V.Enum.FormIconApplication!SupplyAndDemand
V.Enum.FormIconLogo!GssIcon
V.Enum.FormIconModule!Accounting
V.Enum.FormIconMsgBox!Error
V.Enum.FormIconWidget!CompletedProjects

' Dashboard Viewer Export
V.Enum.DashboardViewerExport!ExportType
V.Enum.DashboardViewerExportType!PDF
V.Enum.DashboardViewerExportType!Excel
V.Enum.DashboardViewerExportType!Image
V.Enum.DashboardViewerExportPDF!UserId
V.Enum.DashboardViewerExportPDF!DashboardId
V.Enum.DashboardViewerExportPDF!ExportPath
V.Enum.DashboardViewerExportPDF!FileName
V.Enum.DashboardViewerExportPDF!AutoFitPageCount
V.Enum.DashboardViewerExportPDF!Height
V.Enum.DashboardViewerExportPDF!IncludeFilters
V.Enum.DashboardViewerExportPDF!IncludeParameters
V.Enum.DashboardViewerExportPDF!PageLayout
V.Enum.DashboardViewerExportPDF!PageSize
V.Enum.DashboardViewerExportPDF!Position
V.Enum.DashboardViewerExportPDF!ScaleFactor
V.Enum.DashboardViewerExportPDF!ScaleMode
V.Enum.DashboardViewerExportPDF!ShowTitle
V.Enum.DashboardViewerExportPDF!Width
V.Enum.DashboardViewerExportPDFPageLayout!Landscape
V.Enum.DashboardViewerExportPDFPageLayout!Portrait
V.Enum.DashboardViewerExportPDFPageSize!Letter
V.Enum.DashboardViewerExportPDFPageSize!Legal
V.Enum.DashboardViewerExportPDFPageSize!A4
V.Enum.DashboardViewerExportPDFPageSize!Custom          ' + 113 more sizes (see ## DashboardViewerExportPDFPageSize section)
V.Enum.DashboardViewerExportPDFPosition!Below
V.Enum.DashboardViewerExportPDFPosition!SeparatePage
V.Enum.DashboardViewerExportPDFScaleMode!AutoFitToPagesWidth
V.Enum.DashboardViewerExportPDFScaleMode!None
V.Enum.DashboardViewerExportPDFScaleMode!UseScaleFactor
V.Enum.DashboardViewerExportExcel!DashboardId
V.Enum.DashboardViewerExportExcel!ExportPath
V.Enum.DashboardViewerExportExcel!FileName
V.Enum.DashboardViewerExportExcel!Format
V.Enum.DashboardViewerExportExcel!IncludeFilters
V.Enum.DashboardViewerExportExcel!IncludeParameters
V.Enum.DashboardViewerExportExcel!Position
V.Enum.DashboardViewerExportExcel!UserId
V.Enum.DashboardViewerExportExcelFormat!Xls
V.Enum.DashboardViewerExportExcelFormat!Xlsx
V.Enum.DashboardViewerExportExcelPosition!Below
V.Enum.DashboardViewerExportExcelPosition!SeparateSheet
V.Enum.DashboardViewerExportImage!DashboardId
V.Enum.DashboardViewerExportImage!ExportPath
V.Enum.DashboardViewerExportImage!FileName
V.Enum.DashboardViewerExportImage!Format
V.Enum.DashboardViewerExportImage!Height
V.Enum.DashboardViewerExportImage!IncludeFilters
V.Enum.DashboardViewerExportImage!IncludeParameters
V.Enum.DashboardViewerExportImage!Resolution
V.Enum.DashboardViewerExportImage!ShowTitle
V.Enum.DashboardViewerExportImage!UserId
V.Enum.DashboardViewerExportImage!Width
V.Enum.DashboardViewerExportImageFormat!Gif
V.Enum.DashboardViewerExportImageFormat!Jpeg
V.Enum.DashboardViewerExportImageFormat!Png

' Content Alignment
V.Enum.ContentAlignment!MiddleCenter
V.Enum.VerticalAlignment!Center

' Grid View Property Names (enum-style for SetGridviewProperty)
' WARNING: These enums require GSSVersion >= 2023.1. Prefer string literals unless runtime version is verified.
V.Enum.GridViewPropertyNames!ActiveFilterString
V.Enum.GridViewPropertyNames!ActiveSortString
V.Enum.GridViewPropertyNames!AllowAddRows
V.Enum.GridViewPropertyNames!AllowColumnMoving
V.Enum.GridViewPropertyNames!AllowColumnResizing
V.Enum.GridViewPropertyNames!AllowDeleteRows
V.Enum.GridViewPropertyNames!AllowFilter
V.Enum.GridViewPropertyNames!AllowSort
V.Enum.GridViewPropertyNames!CheckboxSelectorField
V.Enum.GridViewPropertyNames!ColumnAutoWidth
V.Enum.GridViewPropertyNames!ColumnPanelRowHeight
V.Enum.GridViewPropertyNames!Editable
V.Enum.GridViewPropertyNames!EnableAppearanceEvenRow
V.Enum.GridViewPropertyNames!EnableAppearanceOddRow
V.Enum.GridViewPropertyNames!EnterKeyNavigation
V.Enum.GridViewPropertyNames!ExpandAllGroups
V.Enum.GridViewPropertyNames!Multiselect
V.Enum.GridViewPropertyNames!MultiSelectMode
V.Enum.GridViewPropertyNames!OptionsFindAllowFindInExpandedDetails
V.Enum.GridViewPropertyNames!OptionsFindAlwaysVisible
V.Enum.GridViewPropertyNames!OptionsFilterUseNewCustomFilterDialog
V.Enum.GridViewPropertyNames!OptionsMenuShowAutoFilterRowItem
V.Enum.GridViewPropertyNames!OptionsSelectionEnableAppearanceFocusedRow
V.Enum.GridViewPropertyNames!OptionsViewColumnAutoWidth
V.Enum.GridViewPropertyNames!OptionsViewRowAutoHeight
V.Enum.GridViewPropertyNames!OptionsViewShowAutoFilterRow
V.Enum.GridViewPropertyNames!OptionsViewShowFilterPanelMode
V.Enum.GridViewPropertyNames!ReadOnly
V.Enum.GridViewPropertyNames!RowHeight
V.Enum.GridViewPropertyNames!ShowAddNewSummaryItem
V.Enum.GridViewPropertyNames!ShowConditionalFormattingItem
V.Enum.GridViewPropertyNames!ShowDetailTabs
V.Enum.GridViewPropertyNames!ShowGroupPanel
V.Enum.GridViewPropertyNames!ShowGroupSortSummaryItems
V.Enum.GridViewPropertyNames!ShowGroupSummaryMenu
V.Enum.GridViewPropertyNames!ShowSummaryItemMode
V.Enum.GridViewPropertyNames!ShowTotalSummaryMenu
V.Enum.GridViewPropertyNames!SuppressNothingDates

' Column Property Names (enum-style for SetColumnProperty)
' WARNING: These enums require GSSVersion >= 2023.1. Prefer string literals unless runtime version is verified.
' -- Header Appearance
V.Enum.ColumnPropertyNames!HeaderBackColor
V.Enum.ColumnPropertyNames!HeaderForeColor
V.Enum.ColumnPropertyNames!HeaderFontName
V.Enum.ColumnPropertyNames!HeaderFontSize
V.Enum.ColumnPropertyNames!HeaderFontBold
V.Enum.ColumnPropertyNames!HeaderFontItalic
V.Enum.ColumnPropertyNames!HeaderFontStrikeOut
V.Enum.ColumnPropertyNames!HeaderFontUnderline
V.Enum.ColumnPropertyNames!HeaderImage
V.Enum.ColumnPropertyNames!HeaderHAlignment
V.Enum.ColumnPropertyNames!HeaderHotkeyPrefix
V.Enum.ColumnPropertyNames!HeaderTrimming
V.Enum.ColumnPropertyNames!HeaderVAlignment
V.Enum.ColumnPropertyNames!HeaderWordWrap
' -- Cell Appearance
V.Enum.ColumnPropertyNames!CellBackColor
V.Enum.ColumnPropertyNames!CellForeColor
V.Enum.ColumnPropertyNames!CellFontName
V.Enum.ColumnPropertyNames!CellFontSize
V.Enum.ColumnPropertyNames!CellFontBold
V.Enum.ColumnPropertyNames!CellFontItalic
V.Enum.ColumnPropertyNames!CellFontStrikeOut
V.Enum.ColumnPropertyNames!CellFontUnderline
V.Enum.ColumnPropertyNames!CellImage
V.Enum.ColumnPropertyNames!CellHAlignment
V.Enum.ColumnPropertyNames!CellHotkeyPrefix
V.Enum.ColumnPropertyNames!CellTrimming
V.Enum.ColumnPropertyNames!CellVAlignment
V.Enum.ColumnPropertyNames!CellWordWrap
' -- Column Image
V.Enum.ColumnPropertyNames!Image
V.Enum.ColumnPropertyNames!ImageAlignment
V.Enum.ColumnPropertyNames!ImageIndex
V.Enum.ColumnPropertyNames!Icon
' -- General
V.Enum.ColumnPropertyNames!Caption
V.Enum.ColumnPropertyNames!Visible
V.Enum.ColumnPropertyNames!ReadOnly
V.Enum.ColumnPropertyNames!Width
V.Enum.ColumnPropertyNames!MinWidth
V.Enum.ColumnPropertyNames!MaxWidth
V.Enum.ColumnPropertyNames!Fixed
V.Enum.ColumnPropertyNames!ShowButtonMode
V.Enum.ColumnPropertyNames!ToolTip
V.Enum.ColumnPropertyNames!VisibleIndex
V.Enum.ColumnPropertyNames!IsHyperlink
V.Enum.ColumnPropertyNames!MaxLength
V.Enum.ColumnPropertyNames!GroupIndex
V.Enum.ColumnPropertyNames!SortOrder
V.Enum.ColumnPropertyNames!ShowCaption
' -- OptionsColumn
V.Enum.ColumnPropertyNames!AllowEdit
V.Enum.ColumnPropertyNames!AllowFocus
V.Enum.ColumnPropertyNames!AllowGroup
V.Enum.ColumnPropertyNames!AllowIncrementalSearch
V.Enum.ColumnPropertyNames!AllowMerge
V.Enum.ColumnPropertyNames!AllowMove
V.Enum.ColumnPropertyNames!AllowShowHide
V.Enum.ColumnPropertyNames!AllowSize
V.Enum.ColumnPropertyNames!AllowSort
V.Enum.ColumnPropertyNames!FixedWidth
V.Enum.ColumnPropertyNames!Printable
V.Enum.ColumnPropertyNames!TabStop
V.Enum.ColumnPropertyNames!ShowInColumnChooser
' -- OptionsFilter
V.Enum.ColumnPropertyNames!AllowAutoFilter
V.Enum.ColumnPropertyNames!AllowFilter
V.Enum.ColumnPropertyNames!ImmediateUpdateAutoFilter
V.Enum.ColumnPropertyNames!ImmediateUpdatePopupDateFilterOnCheck
V.Enum.ColumnPropertyNames!ImmediateUpdatePopupDateFilterOnDateChange
V.Enum.ColumnPropertyNames!FilterPopUpMode
V.Enum.ColumnPropertyNames!ShowBlanksFilterItems
V.Enum.ColumnPropertyNames!ShowEmptyDateFilter
' -- Display Format
V.Enum.ColumnPropertyNames!DisplayFormatType
V.Enum.ColumnPropertyNames!DisplayCustomNumeric
V.Enum.ColumnPropertyNames!DisplayCustomDateTime
V.Enum.ColumnPropertyNames!DisplayCustomString
' -- Edit Mask
V.Enum.ColumnPropertyNames!EditMaskType
V.Enum.ColumnPropertyNames!EditMask
V.Enum.ColumnPropertyNames!EditMaskAsDisplayFormat
' -- Progress Bar
V.Enum.ColumnPropertyNames!ProgressBarEnabled
V.Enum.ColumnPropertyNames!ProgressBarMinimum
V.Enum.ColumnPropertyNames!ProgressBarMaximum
V.Enum.ColumnPropertyNames!ProgressBarShowTitle
V.Enum.ColumnPropertyNames!ProgressBarPercentView
V.Enum.ColumnPropertyNames!ProgressBarStartColor
V.Enum.ColumnPropertyNames!ProgressBarEndColor

' Conditional Formatting
V.Enum.ConditionalOperations!Between
V.Enum.ConditionalOperations!Equal
V.Enum.ConditionalOperations!Greater
V.Enum.ConditionalOperations!Less
V.Enum.ConditionalOperations!LessOrEqual
V.Enum.ConditionalPropertyNames!BackColor

' Decode Formats
V.Enum.DecodeFormats!Base64

' Message Box
V.Enum.MsgBoxStyle!YesNo
V.Enum.MsgBoxResult!Yes

' Barcode
V.Enum.Symbology!Code128
V.Enum.Symbology!QRCode
V.Enum.Symbology!DataMatrix
V.Enum.Symbology!GS1
V.Enum.Symbology!PDF417
V.Enum.Symbology!UPC
V.Enum.BarcodeOrientation!Normal
V.Enum.BarcodeOrientation!RotateLeft
V.Enum.BarcodeOrientation!RotateRight
V.Enum.BarcodeOrientation!UpsideDown
V.Enum.BarcodeTextHorizontalAlignment!Center
V.Enum.BarcodeTextHorizontalAlignment!Default
V.Enum.BarcodeTextHorizontalAlignment!Far
V.Enum.BarcodeTextHorizontalAlignment!Near
V.Enum.BarcodeTextVerticalAlignment!Bottom
V.Enum.BarcodeTextVerticalAlignment!Center
V.Enum.BarcodeTextVerticalAlignment!Default
V.Enum.BarcodeTextVerticalAlignment!Top

' PictureBox
V.Enum.PictureBoxSizeMode!Stretch

' Menu
V.Enum.MenuItemType!Button

' Part
V.Enum.LongPartType!Part

' Accordion
V.Enum.AccordionElementStyle!Item

' PDF Viewer (see ## GsPdfViewer section for full 36-property list)
V.Enum.GsPdfViewer!ZoomMode
V.Enum.GsPdfViewer!DocumentFilePath
V.Enum.GsPdfViewer!CurrentPageNumber
V.Enum.GsPdfViewer!ReadOnly
V.Enum.GsPdfViewer!Visible
V.Enum.GsPdfViewer!ZoomFactor
V.Enum.GsPdfViewerZoomMode!FitToWidth
V.Enum.PdfViewerToolBarType!All
V.Enum.PdfViewerToolBarType!None

' RichEdit Toolbar
V.Enum.RichEditToolBarType!All
V.Enum.RichEditToolBarType!None

' GsToggleSwitch
V.Enum.GsToggleSwitch!Font
V.Enum.GsToggleSwitch!ForeColor
V.Enum.GsToggleSwitchColor!Green
V.Enum.GsToggleSwitchFontGraphicsUnit!Pixel
V.Enum.GsToggleSwitchFontStyle!Bold

' DateTimeMask (DateTimeOffset control)
V.Enum.DateTimeMask!ShortDate
V.Enum.DateTimeMask!LongDate
V.Enum.DateTimeMask!ShortTime
V.Enum.DateTimeMask!LongTime
V.Enum.DateTimeMask!Custom                              ' see ## DateTimeMask section for full list

' Scheduler Control
V.Enum.SchedulerControlProperties!ActiveViewType
V.Enum.SchedulerControlActiveViewType!Day           ' 0
V.Enum.SchedulerControlActiveViewType!Week          ' 1
V.Enum.SchedulerControlActiveViewType!Month         ' 2
V.Enum.SchedulerControlActiveViewType!WorkWeek      ' 3
V.Enum.SchedulerControlActiveViewType!Timeline      ' 4
V.Enum.SchedulerControlActiveViewType!Gantt         ' 5
V.Enum.SchedulerControlActiveViewType!FullWeek      ' 6
V.Enum.SchedulerControlActiveViewType!Agenda        ' 7
V.Enum.SchedulerControlAppearanceProperties!AppointmentForeColor
V.Enum.AppointmentStatuses!Free
V.Enum.AppointmentStatuses!Tentative
V.Enum.AppointmentStatuses!WorkingElsewhere
V.Enum.AppointmentLabels!MustAttend
V.Enum.AppointmentLabels!Important
V.Enum.AppointmentType!Normal
```

---

## AccordionControlProperties
```
V.Enum.AccordionControlProperties!AllowItemSelection   ' Enables item selection highlight on navigation panel
```
Used with `Gui.form.accordioncontrol.SetAccordionControlProperty(PropertyName, PropertyValue)` where PropertyValue is Boolean.

## AccordionElementStyle
```
V.Enum.AccordionElementStyle!Group
V.Enum.AccordionElementStyle!Item
```

## AlertProgressModes
```
V.Enum.AlertProgressModes!None
V.Enum.AlertProgressModes!Progress
V.Enum.AlertProgressModes!Marquee
```

## AlertPropertyNames
```
V.Enum.AlertPropertyNames!Caption
V.Enum.AlertPropertyNames!Text
V.Enum.AlertPropertyNames!Min
V.Enum.AlertPropertyNames!Max
V.Enum.AlertPropertyNames!Value
V.Enum.AlertPropertyNames!ProgressVisible
V.Enum.AlertPropertyNames!ProgressMode
V.Enum.AlertPropertyNames!ProgressShowPercentage
V.Enum.AlertPropertyNames!DurationInMs
V.Enum.AlertPropertyNames!Pinned
V.Enum.AlertPropertyNames!SvgImage
V.Enum.AlertPropertyNames!SvgImageWidth
V.Enum.AlertPropertyNames!SvgImageHeight
V.Enum.AlertPropertyNames!Image
V.Enum.AlertPropertyNames!AutoCloseOnClick
```

## BarcodeOrientation
```
V.Enum.BarcodeOrientation!Normal
V.Enum.BarcodeOrientation!RotateLeft
V.Enum.BarcodeOrientation!RotateRight
V.Enum.BarcodeOrientation!UpsideDown
```

## BarcodeTextHorizontalAlignment
```
V.Enum.BarcodeTextHorizontalAlignment!Center
V.Enum.BarcodeTextHorizontalAlignment!Default
V.Enum.BarcodeTextHorizontalAlignment!Far
V.Enum.BarcodeTextHorizontalAlignment!Near
```

## BarcodeTextVerticalAlignment
```
V.Enum.BarcodeTextVerticalAlignment!Bottom
V.Enum.BarcodeTextVerticalAlignment!Center
V.Enum.BarcodeTextVerticalAlignment!Default
V.Enum.BarcodeTextVerticalAlignment!Top
```

## AccentColorCodes
The available accent colors for the form (title bar, highlight, etc.). Colors alter slightly based on the user's selected theme.
```
V.Enum.AccentColorCodes!UseDefault       ' 0
V.Enum.AccentColorCodes!Red              ' 1
V.Enum.AccentColorCodes!Blue             ' 2
V.Enum.AccentColorCodes!Green            ' 3
V.Enum.AccentColorCodes!Yellow           ' 4
V.Enum.AccentColorCodes!Orange           ' 5
```

## BeakLocation
```
V.Enum.BeakLocation!Default
V.Enum.BeakLocation!Top
V.Enum.BeakLocation!Bottom
V.Enum.BeakLocation!Left
V.Enum.BeakLocation!Right
```

## ConditionalOperations
```
V.Enum.ConditionalOperations!Between
V.Enum.ConditionalOperations!Equal
V.Enum.ConditionalOperations!Greater
V.Enum.ConditionalOperations!Less
V.Enum.ConditionalOperations!LessOrEqual
V.Enum.ConditionalOperations!NotBetween
V.Enum.ConditionalOperations!Expression
V.Enum.ConditionalOperations!NotEqual
V.Enum.ConditionalOperations!GreaterOrEqual
V.Enum.ConditionalOperations!None
```

## ConditionalPropertyNames
```
V.Enum.ConditionalPropertyNames!BackColor2
V.Enum.ConditionalPropertyNames!ForeColor
V.Enum.ConditionalPropertyNames!GradientMode
V.Enum.ConditionalPropertyNames!ApplyToRow
V.Enum.ConditionalPropertyNames!FontName
V.Enum.ConditionalPropertyNames!FontSize
V.Enum.ConditionalPropertyNames!FontBold
V.Enum.ConditionalPropertyNames!FontItalic
V.Enum.ConditionalPropertyNames!FontStrikeout
V.Enum.ConditionalPropertyNames!FontUnderline
V.Enum.ConditionalPropertyNames!IsHyperlink
```

## DecodeFormats
```
V.Enum.DecodeFormats!UUEncode
V.Enum.DecodeFormats!QuotedPrintable
V.Enum.DecodeFormats!URL
V.Enum.DecodeFormats!JIS
V.Enum.DecodeFormats!YEnc
V.Enum.DecodeFormats!MD5
V.Enum.DecodeFormats!SHA1
V.Enum.DecodeFormats!Hex
V.Enum.DecodeFormats!SystemOption
V.Enum.DecodeFormats!Database
V.Enum.DecodeFormats!HTML
```

## DisableOnClickModes
```
V.Enum.DisableOnClickModes!DoNotDisable
V.Enum.DisableOnClickModes!DisableButton
V.Enum.DisableOnClickModes!DisableButtonWithReEnable
V.Enum.DisableOnClickModes!DisableFormWithReEnable
```

## DockingStyle
```
V.Enum.DockingStyle!Float
V.Enum.DockingStyle!Top
V.Enum.DockingStyle!Bottom
V.Enum.DockingStyle!Left
V.Enum.DockingStyle!Right
V.Enum.DockingStyle!Fill
```

## DockStyle
```
V.Enum.DockStyle!None
V.Enum.DockStyle!Top
V.Enum.DockStyle!Bottom
V.Enum.DockStyle!Left
V.Enum.DockStyle!Right
V.Enum.DockStyle!Fill
```

## DashboardViewerExportExcel
```
V.Enum.DashboardViewerExportExcel!DashboardId
V.Enum.DashboardViewerExportExcel!ExportPath
V.Enum.DashboardViewerExportExcel!FileName
V.Enum.DashboardViewerExportExcel!Format
V.Enum.DashboardViewerExportExcel!IncludeFilters
V.Enum.DashboardViewerExportExcel!IncludeParameters
V.Enum.DashboardViewerExportExcel!Position
V.Enum.DashboardViewerExportExcel!UserId
```

## DashboardViewerExportExcelFormat
```
V.Enum.DashboardViewerExportExcelFormat!Xls
V.Enum.DashboardViewerExportExcelFormat!Xlsx
```

## DashboardViewerExportExcelPosition
```
V.Enum.DashboardViewerExportExcelPosition!Below
V.Enum.DashboardViewerExportExcelPosition!SeparateSheet
```

## DashboardViewerExportImage
```
V.Enum.DashboardViewerExportImage!DashboardId
V.Enum.DashboardViewerExportImage!ExportPath
V.Enum.DashboardViewerExportImage!FileName
V.Enum.DashboardViewerExportImage!Format
V.Enum.DashboardViewerExportImage!Height
V.Enum.DashboardViewerExportImage!IncludeFilters
V.Enum.DashboardViewerExportImage!IncludeParameters
V.Enum.DashboardViewerExportImage!Resolution
V.Enum.DashboardViewerExportImage!ShowTitle
V.Enum.DashboardViewerExportImage!UserId
V.Enum.DashboardViewerExportImage!Width
```

## DashboardViewerExportImageFormat
```
V.Enum.DashboardViewerExportImageFormat!Gif
V.Enum.DashboardViewerExportImageFormat!Jpeg
V.Enum.DashboardViewerExportImageFormat!Png
```

## DashboardViewerExportPDFPageLayout
```
V.Enum.DashboardViewerExportPDFPageLayout!Landscape
V.Enum.DashboardViewerExportPDFPageLayout!Portrait
```

## DashboardViewerExportPDFPageSize
Common sizes shown; 117 total values available (standard paper sizes).
```
V.Enum.DashboardViewerExportPDFPageSize!Letter
V.Enum.DashboardViewerExportPDFPageSize!Legal
V.Enum.DashboardViewerExportPDFPageSize!Executive
V.Enum.DashboardViewerExportPDFPageSize!Tabloid
V.Enum.DashboardViewerExportPDFPageSize!Ledger
V.Enum.DashboardViewerExportPDFPageSize!Statement
V.Enum.DashboardViewerExportPDFPageSize!Folio
V.Enum.DashboardViewerExportPDFPageSize!A2
V.Enum.DashboardViewerExportPDFPageSize!A3
V.Enum.DashboardViewerExportPDFPageSize!A4
V.Enum.DashboardViewerExportPDFPageSize!A5
V.Enum.DashboardViewerExportPDFPageSize!A6
V.Enum.DashboardViewerExportPDFPageSize!B4
V.Enum.DashboardViewerExportPDFPageSize!B5
V.Enum.DashboardViewerExportPDFPageSize!B6Jis
V.Enum.DashboardViewerExportPDFPageSize!Custom
V.Enum.DashboardViewerExportPDFPageSize!Note
V.Enum.DashboardViewerExportPDFPageSize!Quarto
V.Enum.DashboardViewerExportPDFPageSize!Standard10x14
V.Enum.DashboardViewerExportPDFPageSize!Standard11x17
```
Additional sizes: A3Extra, A3ExtraTransverse, A3Rotated, A3Transverse, A4Extra, A4Plus, A4Rotated, A4Small, A4Transverse, A5Extra, A5Rotated, A5Transverse, A6Rotated, APlus, B4Envelope, B4JisRotated, B5Envelope, B5Extra, B5JisRotated, B5Transverse, B6Envelope, B6JisRotated, BPlus, C3Envelope, C4Envelope, C5Envelope, C6Envelope, C65Envelope, CSheet, DLEnvelope, DSheet, ESheet, GermanLegalFanfold, GermanStandardFanfold, InviteEnvelope, IsoB4, ItalyEnvelope, JapaneseDoublePostcard, JapaneseDoublePostcardRotated, JapaneseEnvelopeChouNumber3, JapaneseEnvelopeChouNumber3Rotated, JapaneseEnvelopeChouNumber4, JapaneseEnvelopeChouNumber4Rotated, JapaneseEnvelopeKakuNumber2, JapaneseEnvelopeKakuNumber2Rotated, JapaneseEnvelopeKakuNumber3, JapaneseEnvelopeKakuNumber3Rotated, JapaneseEnvelopeYouNumber4, JapaneseEnvelopeYouNumber4Rotated, JapanesePostcard, JapanesePostcardRotated, LegalExtra, LetterExtra, LetterExtraTransverse, LetterPlus, LetterRotated, LetterSmall, LetterTransverse, MonarchEnvelope, Number9Envelope, Number10Envelope, Number11Envelope, Number12Envelope, Number14Envelope, PersonalEnvelope, Prc16K, Prc16KRotated, Prc32K, Prc32KBig, Prc32KBigRotated, Prc32KRotated, PrcEnvelopeNumber1 through PrcEnvelopeNumber10 (and Rotated variants), Standard9x11, Standard10x11, Standard12x11, Standard15x11, TabloidExtra, USStandardFanfold.

## DashboardViewerExportPDFPosition
```
V.Enum.DashboardViewerExportPDFPosition!Below
V.Enum.DashboardViewerExportPDFPosition!SeparatePage
```

## DashboardViewerExportPDFScaleMode
```
V.Enum.DashboardViewerExportPDFScaleMode!AutoFitToPagesWidth
V.Enum.DashboardViewerExportPDFScaleMode!None
V.Enum.DashboardViewerExportPDFScaleMode!UseScaleFactor
```

## DashboardViewerExportType
```
V.Enum.DashboardViewerExportType!Excel
V.Enum.DashboardViewerExportType!Image
V.Enum.DashboardViewerExportType!PDF
```

## DateTimeMask
Used with `Gui.*form.*datetimeoffset.Mask(V.Enum.DateTimeMask!value)`.
```
V.Enum.DateTimeMask!Custom
V.Enum.DateTimeMask!DateTimeGMT
V.Enum.DateTimeMask!DateTimeLongTime
V.Enum.DateTimeMask!DateTimeShortTime
V.Enum.DateTimeMask!FullDateTimeLongTime
V.Enum.DateTimeMask!FullDateTimeShortTime
V.Enum.DateTimeMask!LongDate
V.Enum.DateTimeMask!LongTime
V.Enum.DateTimeMask!LongTimeGMT
V.Enum.DateTimeMask!MonthDay
V.Enum.DateTimeMask!None
V.Enum.DateTimeMask!RoundTripDateTime
V.Enum.DateTimeMask!ShortDate
V.Enum.DateTimeMask!ShorTimeGMT                  ' Note: identifier spelling is ShorTimeGMT (not ShortTimeGMT) in the runtime
V.Enum.DateTimeMask!ShortTime
V.Enum.DateTimeMask!SortableDateTime
V.Enum.DateTimeMask!YearMonth
```

## EnterKeyNavigationMode
```
V.Enum.EnterKeyNavigationMode!None
V.Enum.EnterKeyNavigationMode!Vertical
V.Enum.EnterKeyNavigationMode!Horizontal
```

## FixedStyles
> **Note:** `V.Enum.FixedStyle` (singular, used in GsAdvBandedGrid context) and `V.Enum.FixedStyles` (plural, general) are both valid enums with the same values. Use `FixedStyle` for GsAdvBandedGridColumnPropertyNames contexts and `FixedStyles` for general column property contexts.
```
V.Enum.FixedStyles!Left
V.Enum.FixedStyles!None
V.Enum.FixedStyles!Right
```

## FormatTypes
```
V.Enum.FormatTypes!Numeric
V.Enum.FormatTypes!DateTime
V.Enum.FormatTypes!Custom
V.Enum.FormatTypes!None
```

## FormTypes
```
V.Enum.FormTypes!BaseForm
V.Enum.FormTypes!DashForm
V.Enum.FormTypes!DialogForm
```

## FrameBorderStyle
```
V.Enum.FrameBorderStyle!No_Border
V.Enum.FrameBorderStyle!Title
V.Enum.FrameBorderStyle!Light
V.Enum.FrameBorderStyle!Card
```

## GradientModes
```
V.Enum.GradientModes!BackwardDiagonal
V.Enum.GradientModes!ForwardDiagonal
V.Enum.GradientModes!Horizontal
V.Enum.GradientModes!Vertical
```

## GridViewPropertyNames
> **WARNING:** These enums require GSSVersion >= 2023.1. Prefer string literals unless you have verified the runtime version.
```
V.Enum.GridViewPropertyNames!MultiselectMode
V.Enum.GridViewPropertyNames!RowAutoHeight
V.Enum.GridViewPropertyNames!ShowAutoFilterRowItem
V.Enum.GridViewPropertyNames!EnableAppearanceFocusedRow
V.Enum.GridViewPropertyNames!FindAlwaysVisible
V.Enum.GridViewPropertyNames!FindMode
V.Enum.GridViewPropertyNames!ShowAutoFilterRow
V.Enum.GridViewPropertyNames!UseNewCustomFilterDialog
V.Enum.GridViewPropertyNames!ShowFilterPanelMode
```

## GsseoStatusCodes
```
V.Enum.GsseoStatusCodes!CannotPerformUpdateRecordReadOutsideThisTransaction
V.Enum.GsseoStatusCodes!ConflictCouldNotUpdateModifiedByAnotherApplication
V.Enum.GsseoStatusCodes!DataBufferTooShortInFile
V.Enum.GsseoStatusCodes!DuplicateKey
V.Enum.GsseoStatusCodes!FileNotFound
V.Enum.GsseoStatusCodes!FileReadBeforeOpened
V.Enum.GsseoStatusCodes!InvalidDescriptorInFile
V.Enum.GsseoStatusCodes!InvalidFileName
V.Enum.GsseoStatusCodes!InvalidFilePosition
V.Enum.GsseoStatusCodes!InvalidKey
V.Enum.GsseoStatusCodes!InvalidOperationOnFile
V.Enum.GsseoStatusCodes!IoErrorOnFile
V.Enum.GsseoStatusCodes!IoExceptionDiskFull
V.Enum.GsseoStatusCodes!KeyBufferTooShortInFile
V.Enum.GsseoStatusCodes!KeyChangedInFile
V.Enum.GsseoStatusCodes!KeyDoesNotExist
V.Enum.GsseoStatusCodes!KeyNotModifiable
V.Enum.GsseoStatusCodes!MicroKernalDatabaseEngineOrBtrieveIsInactive
```

## GsPdfViewer
Properties for `Gui.*form.*gspdfviewer.SetProperty(V.Enum.GsPdfViewer!prop, value)`.
```
V.Enum.GsPdfViewer!AcceptsTab
V.Enum.GsPdfViewer!AllowCommentFiltering
V.Enum.GsPdfViewer!AllowCommentReplies
V.Enum.GsPdfViewer!AllowCommentSorting
V.Enum.GsPdfViewer!ContentMinMargin
V.Enum.GsPdfViewer!CurrentPageNumber
V.Enum.GsPdfViewer!DefaultDocumentDirectory
V.Enum.GsPdfViewer!DetachStreamAfterLoadComplete
V.Enum.GsPdfViewer!DocumentCreator
V.Enum.GsPdfViewer!DocumentFilePath
V.Enum.GsPdfViewer!DocumentProducer
V.Enum.GsPdfViewer!HandTool
V.Enum.GsPdfViewer!HasSelection
V.Enum.GsPdfViewer!HighlightFormFields
V.Enum.GsPdfViewer!HorizontalScrollPosition
V.Enum.GsPdfViewer!ImageCacheSize
V.Enum.GsPdfViewer!IsDocumentChanged
V.Enum.GsPdfViewer!IsDocumentOpened
V.Enum.GsPdfViewer!IsFindDialogVisible
V.Enum.GsPdfViewer!MaxPrintingDpi
V.Enum.GsPdfViewer!MaxZoomFactor
V.Enum.GsPdfViewer!MinZoomFactor
V.Enum.GsPdfViewer!Name
V.Enum.GsPdfViewer!NavigationPaneMinWidth
V.Enum.GsPdfViewer!NavigationPaneWidth
V.Enum.GsPdfViewer!PasswordAttemptsLimit
V.Enum.GsPdfViewer!ReadOnly
V.Enum.GsPdfViewer!RenderPageContentWithDirectX
V.Enum.GsPdfViewer!RotationAngle
V.Enum.GsPdfViewer!ShowImagePlaceholder
V.Enum.GsPdfViewer!ShowPrintStatusDialog
V.Enum.GsPdfViewer!ShowSavingProgressDialog
V.Enum.GsPdfViewer!Text
V.Enum.GsPdfViewer!VerticalScrollPosition
V.Enum.GsPdfViewer!Visible
V.Enum.GsPdfViewer!ZoomFactor
V.Enum.GsPdfViewer!ZoomMode
```

## GsToggleSwitch
```
V.Enum.GsToggleSwitch!Font
V.Enum.GsToggleSwitch!ForeColor
```

## GsToggleSwitchColor
```
V.Enum.GsToggleSwitchColor!Green
```

## GsToggleSwitchFontGraphicsUnit
```
V.Enum.GsToggleSwitchFontGraphicsUnit!Pixel
```

## GsToggleSwitchFontStyle
```
V.Enum.GsToggleSwitchFontStyle!Bold
```

## HorizontalAlignment
```
V.Enum.HorizontalAlignment!Center
V.Enum.HorizontalAlignment!Near
V.Enum.HorizontalAlignment!Far
V.Enum.HorizontalAlignment!Default
```

## HotkeyPrefixModes
```
V.Enum.HotkeyPrefixModes!Hide
V.Enum.HotkeyPrefixModes!None
V.Enum.HotkeyPrefixModes!Show
V.Enum.HotkeyPrefixModes!Default
```

## Image (V.Enum.Image!)

Standard application SVG icons. No external image files needed -- set in the designer or programmatically.

**Usage contexts:**
- At runtime: `V.Enum.Image!ADD_BLACK` (enum syntax)
- In ScreenSU: `"icon_add_black"` (lowercase string with `icon_` prefix)

**Supported controls for SvgPicture:** PictureBox, Button, Hyperlink, Label (and any control with a Picture property).

### Icon Catalog
```
' Actions
V.Enum.Image!ADD_BLACK                    V.Enum.Image!ADD_COLOR
V.Enum.Image!ADD_PLAIN_BLACK              V.Enum.Image!ADD_PLAIN_COLOR
V.Enum.Image!ATTACH_BLACK                 V.Enum.Image!ATTACH_COLOR
V.Enum.Image!CHECK_BLACK                  V.Enum.Image!CHECK_COLOR
V.Enum.Image!CLEAR_BLACK                  V.Enum.Image!CLEAR_COLOR
V.Enum.Image!COPY_BLACK                   V.Enum.Image!COPY_COLOR
V.Enum.Image!CUT_BLACK                    V.Enum.Image!CUT_COLOR
V.Enum.Image!DELETE_BLACK                 V.Enum.Image!DELETE_COLOR
V.Enum.Image!DELETE_PLAIN_BLACK           V.Enum.Image!DELETE_PLAIN_COLOR
V.Enum.Image!EDIT_BLACK                   V.Enum.Image!EDIT_COLOR
V.Enum.Image!ENTER_BLACK                  V.Enum.Image!ENTER_COLOR
V.Enum.Image!EXPORT_BLACK                 V.Enum.Image!EXPORT_COLOR
V.Enum.Image!FILTER_BLACK                 V.Enum.Image!FILTER_COLOR
V.Enum.Image!GO_BLACK                     V.Enum.Image!GO_COLOR
V.Enum.Image!INSERT_ABOVE_BLACK           V.Enum.Image!INSERT_ABOVE_COLOR
V.Enum.Image!INSERT_BELOW_BLACK           V.Enum.Image!INSERT_BELOW_COLOR
V.Enum.Image!MINUS_BLACK                  V.Enum.Image!MINUS_COLOR
V.Enum.Image!MINUS_PLAIN_BLACK            V.Enum.Image!MINUS_PLAIN_COLOR
V.Enum.Image!NEW_BLACK                    V.Enum.Image!NEW_COLOR
V.Enum.Image!OPEN_BLACK                   V.Enum.Image!OPEN_COLOR
V.Enum.Image!PASTE_BLACK                  V.Enum.Image!PASTE_COLOR
V.Enum.Image!REDO_BLACK                   V.Enum.Image!REDO_COLOR
V.Enum.Image!REFRESH_BLACK                V.Enum.Image!REFRESH_COLOR
V.Enum.Image!RESET_BLACK                  V.Enum.Image!RESET_COLOR
V.Enum.Image!RESTORE_BLACK                V.Enum.Image!RESTORE_COLOR
V.Enum.Image!SAVE_BLACK                   V.Enum.Image!SAVE_COLOR
V.Enum.Image!SAVE_ALL_BLACK               V.Enum.Image!SAVE_ALL_COLOR
V.Enum.Image!SELECT_ALL_BLACK             V.Enum.Image!SELECT_ALL_COLOR
V.Enum.Image!SELECT_NONE_BLACK            V.Enum.Image!SELECT_NONE_COLOR
V.Enum.Image!UNDO_BLACK                   V.Enum.Image!UNDO_COLOR
V.Enum.Image!UNDO_ALL_BLACK               V.Enum.Image!UNDO_ALL_COLOR

' Navigation
V.Enum.Image!BEST_FIT_BLACK               V.Enum.Image!BEST_FIT_COLOR
V.Enum.Image!BROWSER_BLACK                V.Enum.Image!BROWSER_COLOR
V.Enum.Image!COLLAPSE_SIDEBAR_BLACK       V.Enum.Image!COLLAPSE_SIDEBAR_COLOR
V.Enum.Image!EXPAND_BLACK                 V.Enum.Image!EXPAND_COLOR
V.Enum.Image!EXPAND_SIDEBAR_BLACK         V.Enum.Image!EXPAND_SIDEBAR_COLOR
V.Enum.Image!HAMBURGER_BLACK              V.Enum.Image!HAMBURGER_COLOR
V.Enum.Image!NAVIGATE_BLACK               V.Enum.Image!NAVIGATE_COLOR
V.Enum.Image!SKIP_LEFT_BLACK              V.Enum.Image!SKIP_LEFT_COLOR
V.Enum.Image!SKIP_RIGHT_BLACK             V.Enum.Image!SKIP_RIGHT_COLOR

' Arrows
V.Enum.Image!ARROW_CIRCLE_LEFT_BLACK      V.Enum.Image!ARROW_CIRCLE_LEFT_UP_BLACK
V.Enum.Image!ARROW_CIRCLE_LEFT_DOWN_BLACK V.Enum.Image!ARROW_CIRCLE_UP_BLACK
V.Enum.Image!ARROW_CIRCLE_DOWN_BLACK      V.Enum.Image!ARROW_CIRCLE_RIGHT_BLACK
V.Enum.Image!ARROW_CIRCLE_RIGHT_UP_BLACK  V.Enum.Image!ARROW_CIRCLE_RIGHT_DOWN_BLACK

' UI / System
V.Enum.Image!BUG_BLACK                    V.Enum.Image!BUG_COLOR
V.Enum.Image!CALENDAR_BLACK               V.Enum.Image!CALENDAR_COLOR
V.Enum.Image!COMBO_BLACK                  V.Enum.Image!COMBO_COLOR
V.Enum.Image!DEV_BLACK                    V.Enum.Image!DEV_COLOR
V.Enum.Image!DOCK_BLACK                   V.Enum.Image!DOCK_COLOR
V.Enum.Image!ERROR_BLACK                  V.Enum.Image!ERROR_COLOR
V.Enum.Image!FUNCTIONS_BLACK              V.Enum.Image!FUNCTIONS_COLOR
V.Enum.Image!GAB_BLACK                    V.Enum.Image!GAB_COLOR
V.Enum.Image!HELP_BLACK                   V.Enum.Image!HELP_COLOR
V.Enum.Image!HIDE_BLACK                   V.Enum.Image!HIDE_COLOR
V.Enum.Image!HOTKEY_BLACK                 V.Enum.Image!HOTKEY_COLOR
V.Enum.Image!IDEA_BLACK                   V.Enum.Image!IDEA_COLOR
V.Enum.Image!INFO_BLACK                   V.Enum.Image!INFO_COLOR
V.Enum.Image!KEY_BLACK                    V.Enum.Image!KEY_COLOR
V.Enum.Image!LEGEND_BLACK                 V.Enum.Image!LEGEND_COLOR
V.Enum.Image!LINK_BLACK                   V.Enum.Image!LINK_COLOR
V.Enum.Image!MAIL_BLACK                   V.Enum.Image!MAIL_COLOR
V.Enum.Image!MESSAGE_BLACK                V.Enum.Image!MESSAGE_COLOR
V.Enum.Image!PICTURE_BLACK                V.Enum.Image!PICTURE_COLOR
V.Enum.Image!PIN_BLACK                    V.Enum.Image!PIN_COLOR
V.Enum.Image!PRINTER_BLACK                V.Enum.Image!PRINTER_COLOR
V.Enum.Image!QUERY_BLACK                  V.Enum.Image!QUERY_COLOR
V.Enum.Image!QUERY_BUILDER_BLACK          V.Enum.Image!QUERY_BUILDER_COLOR
V.Enum.Image!QUERY_CUSTOM_BLACK           V.Enum.Image!QUERY_CUSTOM_COLOR
V.Enum.Image!SETTINGS_BLACK               V.Enum.Image!SETTINGS_COLOR
V.Enum.Image!SHARE_BLACK                  V.Enum.Image!SHARE_COLOR
V.Enum.Image!SHOW_BLACK                   V.Enum.Image!SHOW_COLOR
V.Enum.Image!UNDER_CONSTRUCTION_BLACK     V.Enum.Image!UNDER_CONSTRUCTION_COLOR
V.Enum.Image!UNDOCK_BLACK                 V.Enum.Image!UNDOCK_COLOR
V.Enum.Image!USER_BLACK                   V.Enum.Image!USER_COLOR
V.Enum.Image!WARNING_BLACK                V.Enum.Image!WARNING_COLOR
V.Enum.Image!WRENCH_BLACK                 V.Enum.Image!WRENCH_COLOR

' Company / Group
V.Enum.Image!COMPANY_BLACK                V.Enum.Image!COMPANY_COLOR
V.Enum.Image!COMPANY_CLEAR_BLACK          V.Enum.Image!COMPANY_CLEAR_COLOR
V.Enum.Image!COMPANY_SAVE_BLACK           V.Enum.Image!COMPANY_SAVE_COLOR
V.Enum.Image!GROUP_BLACK                  V.Enum.Image!GROUP_COLOR
V.Enum.Image!GROUP_CLEAR_BLACK            V.Enum.Image!GROUP_CLEAR_COLOR
V.Enum.Image!GROUP_SAVE_BLACK             V.Enum.Image!GROUP_SAVE_COLOR

' Layout
V.Enum.Image!LAYOUT_BLACK                 V.Enum.Image!LAYOUT_COLOR
V.Enum.Image!LAYOUT_CLEAR_BLACK           V.Enum.Image!LAYOUT_CLEAR_COLOR
V.Enum.Image!LAYOUT_EXPORT_BLACK          V.Enum.Image!LAYOUT_EXPORT_COLOR
V.Enum.Image!LAYOUT_OPEN_BLACK            V.Enum.Image!LAYOUT_OPEN_COLOR
V.Enum.Image!LAYOUT_RESET_BLACK           V.Enum.Image!LAYOUT_RESET_COLOR
V.Enum.Image!LAYOUT_SAVE_BLACK            V.Enum.Image!LAYOUT_SAVE_COLOR

' View Modes
V.Enum.Image!VIEW_BANDED_BLACK            V.Enum.Image!VIEW_BANDED_COLOR
V.Enum.Image!VIEW_CARD_BLACK              V.Enum.Image!VIEW_CARD_COLOR
V.Enum.Image!VIEW_GRID_BLACK              V.Enum.Image!VIEW_GRID_COLOR

' Status Dots
V.Enum.Image!DOT_ACCENT_COLOR             V.Enum.Image!DOT_BLACK_COLOR
V.Enum.Image!DOT_BLUE_COLOR               V.Enum.Image!DOT_GRAY_COLOR
V.Enum.Image!DOT_GREEN_COLOR              V.Enum.Image!DOT_ORANGE_COLOR
V.Enum.Image!DOT_PURPLE_COLOR             V.Enum.Image!DOT_RED_COLOR
V.Enum.Image!DOT_THEME_COLOR              V.Enum.Image!DOT_WHITE_COLOR
V.Enum.Image!DOT_YELLOW_COLOR

' DCS Status
V.Enum.Image!DCS_BLACK_COLOR              V.Enum.Image!DCS_GRAY_COLOR
V.Enum.Image!DCS_GREEN_COLOR              V.Enum.Image!DCS_RED_COLOR

' Canny
V.Enum.Image!CANNY_ON_BLACK               V.Enum.Image!CANNY_ON_COLOR
V.Enum.Image!CANNY_OFF_BLACK              V.Enum.Image!CANNY_OFF_COLOR

' AI
V.Enum.Image!BLACK_AI                     V.Enum.Image!COLOR_AI
V.Enum.Image!DECORATION_BLACK_AI          V.Enum.Image!DECORATION_COLOR_AI
V.Enum.Image!MONOCHROME_AI

' GSS Logos
V.Enum.Image!LOGO_G_BRUSH_SM32            V.Enum.Image!LOGO_G_GREEN_SM32
V.Enum.Image!LOGO_G_WHITE_SM32            V.Enum.Image!LOGO_G_BRUSH_LG64
V.Enum.Image!LOGO_G_GREEN_LG64            V.Enum.Image!LOGO_G_WHITE_LG64
V.Enum.Image!LOGO_HORZ_2_LINE_G_GREEN_TEXT_BRUSH_SM48
V.Enum.Image!LOGO_HORZ_2_LINE_G_GREEN_TEXT_WHITE_SM48
V.Enum.Image!LOGO_HORZ_2_LINE_G_WHITE_TEXT_WHITE_SM48
V.Enum.Image!LOGO_HORZ_3_LINE_G_GREEN_TEXT_BRUSH_LG80
V.Enum.Image!LOGO_HORZ_3_LINE_G_GREEN_TEXT_WHITE_LG80
V.Enum.Image!LOGO_HORZ_3_LINE_G_WHITE_TEXT_WHITE_LG80
V.Enum.Image!LOGO_VERT_2_LINE_G_GREEN_TEXT_BRUSH_SM136
V.Enum.Image!LOGO_VERT_2_LINE_G_GREEN_TEXT_WHITE_SM136
V.Enum.Image!LOGO_VERT_2_LINE_G_WHITE_TEXT_WHITE_SM136
V.Enum.Image!LOGO_VERT_3_LINE_G_WHITE_TEXT_WHITE_LG150
V.Enum.Image!LOGO_VERT_3_LINE_G_GREEN_TEXT_WHITE_LG150
V.Enum.Image!LOGO_VERT_3_LINE_G_GREEN_TEXT_BRUSH_LG150
V.Enum.Image!LOGO_HORZ_WIDE_1_LINE_G_GREEN_TEXT_BRUSH_SM24
V.Enum.Image!LOGO_HORZ_WIDE_1_LINE_G_GREEN_TEXT_WHITE_SM24
V.Enum.Image!LOGO_HORZ_WIDE_1_LINE_G_WHITE_TEXT_WHITE_SM24
```

## ImageAlignToText
```
V.Enum.ImageAlignToText!None
V.Enum.ImageAlignToText!LeftTop
V.Enum.ImageAlignToText!LeftCenter
V.Enum.ImageAlignToText!LeftBottom
V.Enum.ImageAlignToText!RightTop
V.Enum.ImageAlignToText!RightCenter
V.Enum.ImageAlignToText!RightBottom
V.Enum.ImageAlignToText!TopLeft
V.Enum.ImageAlignToText!TopCenter
V.Enum.ImageAlignToText!TopRight
V.Enum.ImageAlignToText!BottomLeft
V.Enum.ImageAlignToText!BottomCenter
V.Enum.ImageAlignToText!BottomRight
```

## LabelAutoSizeModes
```
V.Enum.LabelAutoSizeModes!Default
V.Enum.LabelAutoSizeModes!Horizontal
V.Enum.LabelAutoSizeModes!None
V.Enum.LabelAutoSizeModes!Vertical
```

## LinqJoinType
```
V.Enum.LinqJoinType!InnerJoin
V.Enum.LinqJoinType!LeftJoin
V.Enum.LinqJoinType!RightJoin
V.Enum.LinqJoinType!FullJoin
```

## LinqSourceType
```
V.Enum.LinqSourceType!DataTable
V.Enum.LinqSourceType!DataView
V.Enum.LinqSourceType!Object
V.Enum.LinqSourceType!ObjectOnly
```

## LongPartType
```
V.Enum.LongPartType!Part
V.Enum.LongPartType!Customer
V.Enum.LongPartType!Manufacturing
V.Enum.LongPartType!User
```

## LookupModes
The mode ID that the Lookup uses to populate when `LookupPopulateMode` is set to `LookupMode`. Each mode maps to a standard GSS entity browser.
```
V.Enum.LookupModes!Custom
V.Enum.LookupModes!InventoryPart
V.Enum.LookupModes!InventoryActivePart
V.Enum.LookupModes!InventoryCrossRef
V.Enum.LookupModes!InvoiceLines
V.Enum.LookupModes!InventoryHistory
V.Enum.LookupModes!InventoryLongPart
V.Enum.LookupModes!Salesperson
V.Enum.LookupModes!Employee
V.Enum.LookupModes!Customer
V.Enum.LookupModes!SalesOrder
V.Enum.LookupModes!Vendor
V.Enum.LookupModes!CustomerShipTo
V.Enum.LookupModes!CashAccount
V.Enum.LookupModes!Contact
V.Enum.LookupModes!InventoryLongPartCrossRef
V.Enum.LookupModes!CheckBatches
V.Enum.LookupModes!Carrier
V.Enum.LookupModes!InventoryActiveLongPart
V.Enum.LookupModes!InventoryActiveCrossRef
V.Enum.LookupModes!InventoryActiveLongPartCrossRef
V.Enum.LookupModes!ManufacturingBom
V.Enum.LookupModes!ManufacturingRouter
```

## LookupPopulateModes
The method in which the Lookup control populates its data.
```
V.Enum.LookupPopulateModes!LookupMode             ' Uses LookupModes to select a standard GSS entity browser
V.Enum.LookupPopulateModes!PopulateFromSql         ' Populates from a SQL query
V.Enum.LookupPopulateModes!PopulateFromString      ' Populates from StringBasis with ColumnDelim/RowDelim
V.Enum.LookupPopulateModes!PopulateFromFile        ' Populates from a file
V.Enum.LookupPopulateModes!PopulateFromDataTable   ' Populates from a DataTable
V.Enum.LookupPopulateModes!PopulateFromGSSEO       ' Populates from a GSS Entity Object
```

## LookupPreferredStyles
Controls how the Lookup browser is displayed.
```
V.Enum.LookupPreferredStyles!AttachToControl       ' 0 - Beak panel pointing at the AssociatedControl (preferred)
V.Enum.LookupPreferredStyles!DockableWindow        ' 2 - DockPanel to hold the browser
V.Enum.LookupPreferredStyles!ExternalWindow        ' 3 - Separate form to hold the browser
```

## MaskTypes
```
V.Enum.MaskTypes!DateTime
V.Enum.MaskTypes!DateTimeAdvancingCaret
V.Enum.MaskTypes!None
V.Enum.MaskTypes!Numeric
V.Enum.MaskTypes!Regex
V.Enum.MaskTypes!Custom
```

## MenuItemType
```
V.Enum.MenuItemType!Combobox
V.Enum.MenuItemType!Textbox
V.Enum.MenuItemType!Separator
```

## MsgBoxResult
```
V.Enum.MsgBoxResult!OK
V.Enum.MsgBoxResult!Cancel
V.Enum.MsgBoxResult!Abort
V.Enum.MsgBoxResult!Retry
V.Enum.MsgBoxResult!Ignore
V.Enum.MsgBoxResult!No
V.Enum.MsgBoxResult!Save
```

## MsgBoxStyle
Values can be added together to change the icon or button combinations. Custom buttons are displayed after the standard ones. When `Critical`, `Question`, `Exclamation`, or `Information` are combined with button styles, the buttons come from the button style while the form image comes from the icon style.

```
' Button styles
V.Enum.MsgBoxStyle!NoButtons
V.Enum.MsgBoxStyle!OkOnly
V.Enum.MsgBoxStyle!OkCancel
V.Enum.MsgBoxStyle!AbortRetryIgnore
V.Enum.MsgBoxStyle!YesNoCancel
V.Enum.MsgBoxStyle!RetryCancel
V.Enum.MsgBoxStyle!Save
V.Enum.MsgBoxStyle!SaveCancel

' Icon styles (combinable with button styles)
V.Enum.MsgBoxStyle!Critical
V.Enum.MsgBoxStyle!Exclamation
V.Enum.MsgBoxStyle!Information
V.Enum.MsgBoxStyle!Question

' Other
V.Enum.MsgBoxStyle!MsgBoxHelp
```

## MultiselectMode
```
V.Enum.MultiselectMode!RowSelect
V.Enum.MultiselectMode!CellSelect
V.Enum.MultiselectMode!CheckBoxRowSelect
```

## NumericOnlyMode
```
V.Enum.NumericOnlyMode!Disabled
V.Enum.NumericOnlyMode!SignedFloat
V.Enum.NumericOnlyMode!UnsignedFloat
V.Enum.NumericOnlyMode!UnsignedLong
```

## Orientation
```
V.Enum.Orientation!Horizontal
V.Enum.Orientation!Vertical
```

## PdfViewerToolBarType
```
V.Enum.PdfViewerToolBarType!All
V.Enum.PdfViewerToolBarType!None
```

## PictureBoxSizeMode
```
V.Enum.PictureBoxSizeMode!Normal
V.Enum.PictureBoxSizeMode!Stretch
V.Enum.PictureBoxSizeMode!Center
V.Enum.PictureBoxSizeMode!Zoom
```

## RichEditToolBarType
```
V.Enum.RichEditToolBarType!All
V.Enum.RichEditToolBarType!None
```

## RichTextViewTypes
```
V.Enum.RichTextViewTypes!Simple
V.Enum.RichTextViewTypes!Print
V.Enum.RichTextViewTypes!Draft
```

## ShowButtonModes
```
V.Enum.ShowButtonModes!Default
V.Enum.ShowButtonModes!ShowAlways
V.Enum.ShowButtonModes!ShowForFocusedCell
V.Enum.ShowButtonModes!ShowForFocusedRow
V.Enum.ShowButtonModes!ShowOnlyInEditor
```

## ShowFilterPanelMode
```
V.Enum.ShowFilterPanelMode!Default
V.Enum.ShowFilterPanelMode!Never
V.Enum.ShowFilterPanelMode!ShowAlways
```

## SpreadSheetToolBarType
Used with `GsSpreadsheetControl.CreateRibbon()` to control which ribbon toolbar elements appear. Numeric values can also be passed directly (e.g., `8191` for All).
```
V.Enum.SpreadSheetToolBarType!All
V.Enum.SpreadSheetToolBarType!None
```

## Symbology
Used with `Gui.*form.*gsbarcode.GetBarcodeImage(...)`.
```
V.Enum.Symbology!Code128
V.Enum.Symbology!DataMatrix
V.Enum.Symbology!GS1
V.Enum.Symbology!PDF417
V.Enum.Symbology!QRCode
V.Enum.Symbology!UPC
```

## ThemeColors
Returns a color based on the current theme. For example, "Black" would be a dark color on light themes and a light color on dark themes -- the color adapts automatically.

### Transforms (chainable on any ThemeColor value)
```
V.Enum.ThemeColors!<Color>.Plus(iPercent)    ' 0-100: X% toward white on light themes, X% toward black on dark themes
V.Enum.ThemeColors!<Color>.Minus(iPercent)   ' 0-100: X% toward black on light themes, X% toward white on dark themes
V.Enum.ThemeColors!<Color>.Highlight         ' Modified for use as a grid cell/row highlight color
```

**Examples:**
```
V.Enum.ThemeColors!ColorRed                  ' Returns Red
V.Enum.ThemeColors!ColorRed.Plus(50)         ' Returns Red, 50% lighter (light themes) / darker (dark themes)
V.Enum.ThemeColors!ColorRed.Minus(25)        ' Returns Red, 25% darker (light themes) / lighter (dark themes)
V.Enum.ThemeColors!ColorRed.Highlight        ' Returns Red, appropriate for grid highlighting
```

### Additional Values
```
V.Enum.ThemeColors!GssBlue
V.Enum.ThemeColors!GssBlack
V.Enum.ThemeColors!ControlBackgroundHigh
V.Enum.ThemeColors!MenuBackground
V.Enum.ThemeColors!TextLight
V.Enum.ThemeColors!BorderMajor
V.Enum.ThemeColors!BorderMinor
V.Enum.ThemeColors!ThemeColorHigh
V.Enum.ThemeColors!ThemeColorHot
V.Enum.ThemeColors!ThemeColorText
V.Enum.ThemeColors!AccentColorLight
V.Enum.ThemeColors!AccentColorHot
V.Enum.ThemeColors!TextOnAccentColor
V.Enum.ThemeColors!AccentMinorColorLight
V.Enum.ThemeColors!AccentMinorColorHot
V.Enum.ThemeColors!Text
V.Enum.ThemeColors!ThemeColor
```

## Trimming
```
V.Enum.Trimming!Character
V.Enum.Trimming!EllipsisCharacter
V.Enum.Trimming!EllipsisPath
V.Enum.Trimming!EllipsisWord
V.Enum.Trimming!None
V.Enum.Trimming!Word
V.Enum.Trimming!Default
```

## VerticalAlignment
```
V.Enum.VerticalAlignment!Bottom
V.Enum.VerticalAlignment!Top
V.Enum.VerticalAlignment!Default
```

## Visibility
```
V.Enum.Visibility!Visible
V.Enum.Visibility!AutoHide
V.Enum.Visibility!Hidden
```

## WordWrap
```
V.Enum.WordWrap!Default
V.Enum.WordWrap!NoWrap
V.Enum.WordWrap!Wrap
```

## GridFindMode
Used to set the value of the gridview property V.Enum.GridViewPropertyNames!FindMode
```
V.Enum.GridFindMode!Always
V.Enum.GridFindMode!Default
V.Enum.GridFindMode!FindClick
```

## ColumnPropertyNames
> **WARNING:** These enums require GSSVersion >= 2023.1. Prefer string literals unless you have verified the runtime version.
```
V.Enum.ColumnPropertyNames!HeaderBorderColor
V.Enum.ColumnPropertyNames!HeaderFontStrikeout
V.Enum.ColumnPropertyNames!CellBorderColor
V.Enum.ColumnPropertyNames!CellFontStrikeout
V.Enum.ColumnPropertyNames!Tooltip
V.Enum.ColumnPropertyNames!ImmediateUpdatePopupDateFilterOnCheck
V.Enum.ColumnPropertyNames!ImmediateUpdatePopupDateFilterOnDateChange
V.Enum.ColumnPropertyNames!SuppressNothingDates
```

---

## SplitOrientation
Orientation for SplitContainer controls.
```
V.Enum.SplitOrientation!Horizontal     ' 0 — panels side by side
V.Enum.SplitOrientation!Vertical       ' 1 — panels stacked top/bottom
```

## GabVariableTypes
Core variable type identifiers used in V.*.Declare() and type-checking.
```
V.Enum.GabVariableTypes!Long       ' 0
V.Enum.GabVariableTypes!String     ' 1
V.Enum.GabVariableTypes!Boolean    ' 2
V.Enum.GabVariableTypes!Date       ' 3
V.Enum.GabVariableTypes!Float      ' 4
```

## GsAdvBandedGridViewPropertyNames
Property names for GsAdvBandedGridControl view-level configuration. Extends GridViewPropertyNames with banded-grid-specific options.
> Populated via reflection from DevExpress `AdvBandedGridView` at runtime. Members overlap with GridViewPropertyNames; additional banded-specific members available.

## GsAdvBandedGridColumnPropertyNames
Column-level properties for GsAdvBandedGridControl. Extends ColumnPropertyNames with banding support.
> Populated via reflection from DevExpress `BandedGridColumn` at runtime.

## CommandProtocolPayloads
Payload types for inter-process command protocol communication.
```
V.Enum.CommandProtocolPayloads!PartInformation
V.Enum.CommandProtocolPayloads!CoreData
```

## FormIconApplication
Application-level icon presets for form icons.
> Populated via reflection from `GssLibrary.Icons.FormIconDescriptors.Application` at runtime.

## FormIconModule
Module-level icon presets for form icons.
> Populated via reflection from `GssLibrary.Icons.FormIconDescriptors.Module` at runtime.

## FormIconLogo
Logo icon presets for form branding.
> Populated via reflection from `GssLibrary.Icons.FormIconDescriptors.Logo` at runtime.

## GsProgressPanelContentAlignment
Content alignment for ProgressPanel controls.
> Populated via reflection from `System.Drawing.ContentAlignment` at runtime: TopLeft, TopCenter, TopRight, MiddleLeft, MiddleCenter, MiddleRight, BottomLeft, BottomCenter, BottomRight.
