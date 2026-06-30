# Crystal Report Formatting

Formatting controls the visual presentation of report sections, fields, and objects. This includes section-level behaviors (suppress, page breaks), field-level display (number formats, date formats), conditional formatting, page setup, and special fields.

---

## Section Formatting

Each section in a Crystal report has a `SectionFormat` object controlling its behavior.

### Accessing Section Format (Engine API — Modification)

When modifying an existing report via the Engine API (see `MODIFICATION.md`):

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

// Access a specific section by index
var detail = doc.ReportDefinition.Sections["DetailSection1"];
detail.SectionFormat.EnableSuppress = true;
detail.SectionFormat.EnableKeepTogether = true;

doc.SaveAs(rptPath);
doc.Close();
```

### Accessing Section Format (RAS API — Creation)

When creating a report via the RAS InProc SDK (see `CREATION.md`):

```csharp
var reportDef = clientDoc.ReportDefController.ReportDefinition;
var detail = reportDef.DetailArea.Sections[(object)0];
```

### Modifying Section Properties via RAS (ReportSectionController.Modify)

RAS section objects are immutable — you cannot set properties directly. Use the `Clone → Modify` pattern through `ReportSectionController`:

```csharp
var reportDef = clientDoc.ReportDefController.ReportDefinition;
var section = reportDef.DetailArea.Sections[(object)0];

var newSection = (CrystalDecisions.ReportAppServer.ReportDefModel.Section)section.Clone(true);
newSection.Height = 500;  // in twips
newSection.Format.EnableSuppress = false;
newSection.Format.EnableKeepTogether = true;
newSection.Format.EnableNewPageBefore = false;

clientDoc.ReportDefController.ReportSectionController.Modify(section, newSection);
```

### Modifiable Section Properties (RAS)

| Property | Type | Purpose |
|----------|------|---------|
| `Height` | int | Section height in twips |
| `Format.EnableSuppress` | bool | Suppress the section |
| `Format.EnableKeepTogether` | bool | Keep section on one page |
| `Format.EnableNewPageBefore` | bool | Page break before section |
| `Format.EnableNewPageAfter` | bool | Page break after section |
| `Format.EnableResetPageNumberAfter` | bool | Reset page number after section |
| `Format.EnablePrintAtBottomOfPage` | bool | Print at page bottom |
| `Format.EnableUnderlaySection` | bool | Underlay next section |
| `Format.BackgroundColor` | int | Background color (packed RGB) |

### Setting Conditional Suppress on a Section (RAS)

```csharp
var section = reportDef.GroupFooterArea.Sections[(object)0];
var newSection = (Section)section.Clone(true);
newSection.Format.EnableSuppress = true;
newSection.Format.SuppressConditionFormula.Text = "{ORDER_HEADER.TOTAL} = 0";

clientDoc.ReportDefController.ReportSectionController.Modify(section, newSection);
```

### SectionFormat Properties

| Property | Type | Purpose |
|----------|------|---------|
| `EnableSuppress` | bool | Hide the section entirely (data still processes) |
| `EnableKeepTogether` | bool | Prevent page break within the section |
| `EnableNewPageBefore` | bool | Force a page break before this section |
| `EnableNewPageAfter` | bool | Force a page break after this section |
| `EnableResetPageNumberAfter` | bool | Reset page numbering after this section |
| `EnablePrintAtBottomOfPage` | bool | Print the section at the bottom of the page |
| `EnableUnderlaySection` | bool | Allow the section to underlay the next section |
| `BackgroundColor` | Color | Section background color |

### Common Section Formatting Patterns

**Suppress blank sections:**
```csharp
// Suppress the section when a field is empty
section.SectionFormat.EnableSuppress = true;
```

**Page break per group:**
```csharp
// Force a new page before each Group Header
var gh = doc.ReportDefinition.Sections["GroupHeaderSection1"];
gh.SectionFormat.EnableNewPageBefore = true;
```

**Keep group together:**
```csharp
var gh = doc.ReportDefinition.Sections["GroupHeaderSection1"];
gh.SectionFormat.EnableKeepTogether = true;
```

---

## Conditional Formatting via Formulas

Conditional formatting applies dynamic visual changes based on data values. In Crystal Reports, this is driven by formula conditions set on object or section properties.

### Conditional Suppress (Engine API)

To suppress a section conditionally, set a suppress condition formula:

```csharp
var section = doc.ReportDefinition.Sections["DetailSection1"];
section.SectionFormat.EnableSuppress = false;
section.SectionFormat.SuppressFormula.Text = "{ORDER_HEADER.STATUS} = \"C\"";
```

When the formula evaluates to `True`, the section is suppressed.

### Conditional Object Color (Engine API)

```csharp
foreach (ReportObject obj in section.ReportObjects)
{
    if (obj.Kind == ReportObjectKind.FieldObject && obj.Name == "Field1")
    {
        var field = (FieldObject)obj;
        field.Color = Color.Red;
    }
}
```

For true conditional coloring (red if negative, black if positive), set the color condition formula via the object's format conditions. The Engine API exposes this through `ObjectFormat.ConditionFormulas`.

### Conditional Formatting via ConditionFormulas API (Engine)

The `ObjectFormat.ConditionFormulas` collection allows setting Crystal formula expressions on any formattable property. The formula must evaluate to the appropriate type for that property.

**Conditional font color:**
```csharp
var field = (FieldObject)obj;
field.ObjectFormat.ConditionFormulas["Color"].Text =
    "If {ORDER_HEADER.AMOUNT} < 0 Then crRed Else crBlack";
```

**Conditional background color:**
```csharp
field.ObjectFormat.ConditionFormulas["BackColor"].Text =
    "If {ORDER_HEADER.STATUS} = \"OVERDUE\" Then crYellow Else crNoColor";
```

**Conditional font style (bold):**
```csharp
field.ObjectFormat.ConditionFormulas["FontBold"].Text =
    "If {ORDER_HEADER.AMOUNT} > 10000 Then True Else False";
```

### Common ConditionFormulas Keys (Engine API)

| Key | Controls | Formula Returns |
|-----|----------|----------------|
| `"Color"` | Font color | Color constant (e.g., `crRed`) |
| `"BackColor"` | Background color | Color constant |
| `"FontBold"` | Bold style | Boolean |
| `"FontItalic"` | Italic style | Boolean |
| `"FontSize"` | Font size | Number (points) |
| `"SuppressIfZero"` | Suppress zero values | Boolean |
| `"EnableSuppress"` | Suppress object | Boolean |

### Crystal Color Constants Reference

Use these constants in conditional formatting formulas:

| Constant | Color | RGB |
|----------|-------|-----|
| `crRed` | Red | 255, 0, 0 |
| `crBlack` | Black | 0, 0, 0 |
| `crBlue` | Blue | 0, 0, 255 |
| `crGreen` | Green | 0, 128, 0 |
| `crWhite` | White | 255, 255, 255 |
| `crYellow` | Yellow | 255, 255, 0 |
| `crAqua` | Aqua | 0, 255, 255 |
| `crSilver` | Silver | 192, 192, 192 |
| `crMaroon` | Maroon | 128, 0, 0 |
| `crNavy` | Navy | 0, 0, 128 |
| `crOlive` | Olive | 128, 128, 0 |
| `crTeal` | Teal | 0, 128, 128 |
| `crPurple` | Purple | 128, 0, 128 |
| `crFuchsia` | Fuchsia | 255, 0, 255 |
| `crNoColor` | Transparent | — |

**Custom RGB color:** `Color(r, g, b)` where each component is 0–255:
```
Color(64, 128, 255)
```

### Conditional Color Examples

**Red/black based on sign:**
```
If {Table.AMOUNT} < 0 Then crRed Else crBlack
```

**Traffic light (red/yellow/green):**
```
If {Table.DAYS_LATE} > 30 Then crRed
Else If {Table.DAYS_LATE} > 7 Then Color(255, 165, 0)
Else crGreen
```

**Alternating row background:**
```
If RecordNumber Mod 2 = 0 Then Color(240, 240, 240) Else crWhite
```

### Conditional Formatting Approach in RAS SDK

The RAS SDK handles conditional formatting through the `ConditionFormulas` collection on object format properties, using `CrObjectFormatConditionFormulaTypeEnum` values:

```csharp
var fieldObj = section.ReportObjects[i];
var formula = fieldObj.Format.ConditionFormulas.Formula(
    CrObjectFormatConditionFormulaTypeEnum
        .crObjectFormatConditionFormulaTypeEnableSuppress);
formula.Text = "{ORDER_HEADER.STATUS} = \"C\"";
```

### Common CrObjectFormatConditionFormulaTypeEnum Values

| Enum Value | Controls |
|-----------|----------|
| `crObjectFormatConditionFormulaTypeEnableSuppress` | Suppress the object |
| `crObjectFormatConditionFormulaTypeColor` | Font color |
| `crObjectFormatConditionFormulaTypeBackColor` | Background color |
| `crObjectFormatConditionFormulaTypeFontBold` | Bold style |
| `crObjectFormatConditionFormulaTypeFontItalic` | Italic style |
| `crObjectFormatConditionFormulaTypeFontSize` | Font size |
| `crObjectFormatConditionFormulaTypeHorizontalAlignment` | Alignment |

---

## Field Formatting

Field formatting controls how data values display: number of decimal places, date format, currency symbols, etc.

### Number Formatting (Engine API)

```csharp
var field = (FieldObject)obj;
field.FieldFormat.NumericFormat.DecimalPlaces = 2;
field.FieldFormat.NumericFormat.HasThousandsSeparators = true;
field.FieldFormat.NumericFormat.NegativeFormat =
    NegativeFormat.NegativeSignBefore;
```

### Date Formatting (Engine API)

```csharp
var field = (FieldObject)obj;
field.FieldFormat.DateFormat.DateOrder = DateOrder.MonthDayYear;
field.FieldFormat.DateFormat.DayFormat = DayFormat.LeadingZeroNumericDay;
field.FieldFormat.DateFormat.MonthFormat = MonthFormat.LeadingZeroNumericMonth;
field.FieldFormat.DateFormat.YearFormat = YearFormat.LongYear;
field.FieldFormat.DateFormat.DateSeparator = "/";
```

### Currency Formatting (Engine API)

```csharp
field.FieldFormat.NumericFormat.CurrencySymbolFormat.ShowSymbol = true;
field.FieldFormat.NumericFormat.CurrencySymbolFormat.CurrencySymbol = "$";
field.FieldFormat.NumericFormat.CurrencySymbolFormat.OneCurrencySymbolPerPage = false;
```

### Suppress If Duplicated (Engine API)

```csharp
var field = (FieldObject)obj;
field.ObjectFormat.EnableSuppress = false;
field.ObjectFormat.SuppressIfDuplicated = true;
```

### Horizontal Alignment (Engine API)

```csharp
var field = (FieldObject)obj;
field.ObjectFormat.HorizontalAlignment = Alignment.RightAlign;
```

| Alignment Value | Meaning |
|----------------|---------|
| `Alignment.DefaultAlign` | Default for data type |
| `Alignment.LeftAlign` | Left-aligned |
| `Alignment.CenterAlign` | Center-aligned |
| `Alignment.RightAlign` | Right-aligned |
| `Alignment.Justified` | Justified |

---

## Page Setup

Page setup controls paper size, orientation, and margins.

### Via Engine API (Modification)

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

doc.PrintOptions.PaperSize = PaperSize.PaperLetter;
doc.PrintOptions.PaperOrientation = PaperOrientation.Landscape;

doc.SaveAs(rptPath);
doc.Close();
```

### Paper Size Enum

| Value | Size |
|-------|------|
| `PaperSize.PaperLetter` | 8.5 x 11 in |
| `PaperSize.PaperLegal` | 8.5 x 14 in |
| `PaperSize.PaperA4` | 210 x 297 mm |
| `PaperSize.PaperLedger` | 11 x 17 in |

### Paper Orientation Enum

| Value | Meaning |
|-------|---------|
| `PaperOrientation.DefaultPaperOrientation` | Printer default |
| `PaperOrientation.Portrait` | Portrait |
| `PaperOrientation.Landscape` | Landscape |

### Margins

Crystal Reports margins are set in twips (1440 twips = 1 inch):

```csharp
doc.PrintOptions.PageMargins = new PageMargins(
    720,   // left (0.5 in)
    720,   // right (0.5 in)
    720,   // top (0.5 in)
    720    // bottom (0.5 in)
);
```

---

## Special Fields

Special fields display report metadata. They are placed using specific `DataSourceName` values.

### Via RAS SDK (Creation)

```csharp
var pageNumField = new FieldObject();
pageNumField.DataSourceName = "PageNumber";
pageNumField.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeNumberField;
pageNumField.Left = 100;
pageNumField.Top = 50;
pageNumField.Width = 1000;
pageNumField.Height = 250;
pageNumField.Kind = CrReportObjectKindEnum.crReportObjectKindField;

var pageFooter = reportDef.PageFooterArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.Add(pageNumField, pageFooter, -1);
```

### Common Special Field DataSourceName Values

| DataSourceName | Displays |
|---------------|----------|
| `"PageNumber"` | Current page number |
| `"TotalPageCount"` | Total number of pages |
| `"PrintDate"` | Date the report is printed |
| `"PrintTime"` | Time the report is printed |
| `"DataDate"` | Date the data was last refreshed |
| `"DataTime"` | Time the data was last refreshed |
| `"RecordNumber"` | Current record number |
| `"GroupNumber"` | Current group number |
| `"FileCreationDate"` | Date the .rpt file was created |
| `"FileAuthor"` | Author metadata from the .rpt file |
| `"ReportTitle"` | Title metadata from the .rpt file |
| `"ReportComments"` | Comments metadata from the .rpt file |

### Page N of M Pattern

To display "Page 1 of 5", create a formula field:

```
"Page " + ToText(PageNumber, 0, "") + " of " + ToText(TotalPageCount, 0, "")
```

Add this as a `FormulaField` via `FormulaFieldController.Add()` (see `FORMULAS.md` for the SDK pattern).

---

## CanGrow and Text Interpretation (HTML/RTF)

### CanGrow

`EnableCanGrow` allows a field object to expand vertically to fit its content. Without it, text that exceeds the field height is truncated.

**Engine API (Modification):**
```csharp
var field = (FieldObject)obj;
field.ObjectFormat.EnableCanGrow = true;
```

When `EnableCanGrow` is `true`, the section height automatically expands to accommodate the field. This is essential for memo/description fields with variable-length content.

**Maximum number of lines** can be set via the Crystal designer but is not easily accessible through the Engine API. Use the designer to set a cap if needed, then modify other properties programmatically.

### Text Interpretation (HTML/RTF)

Crystal can interpret field content as HTML or RTF for rich formatting within a single field.

**Engine API:**
```csharp
var field = (FieldObject)obj;
field.FieldFormat.StringFormat.TextFormat = CrTextFormatEnum.crTextFormatHTMLText;
```

| `CrTextFormatEnum` Value | Interpretation |
|-------------------------|----------------|
| `crTextFormatPlainText` | Plain text (default) |
| `crTextFormatHTMLText` | HTML — supports `<b>`, `<i>`, `<font>`, `<br>`, basic tags |
| `crTextFormatRTFText` | RTF — supports Rich Text Format markup |

**HTML text example** — the database field contains:
```html
<b>URGENT:</b> Ship by <font color="red">Friday</font>
```

Crystal renders this with bold and color formatting when `TextFormat` is set to `crTextFormatHTMLText`.

**CanGrow + HTML**: When using HTML text interpretation, enable `CanGrow` to accommodate variable-length formatted content:
```csharp
field.ObjectFormat.EnableCanGrow = true;
field.FieldFormat.StringFormat.TextFormat = CrTextFormatEnum.crTextFormatHTMLText;
```

---

## Positioning Units

Crystal Reports uses **twips** for all position and size values:

| Twips | Physical |
|-------|----------|
| 1440 | 1 inch |
| 720 | 0.5 inch |
| 567 | 1 cm |
| 20 | 1 point |

When setting `Left`, `Top`, `Width`, `Height` on `FieldObject` or margins on `PrintOptions`, values are in twips.

---

## Controller Access Patterns

| Need | Access Path |
|------|-------------|
| Section format (Engine) | `doc.ReportDefinition.Sections["SectionName"].SectionFormat` |
| Section format (RAS read) | `clientDoc.ReportDefController.ReportDefinition.DetailArea.Sections[(object)0]` |
| Section modify (RAS) | `clientDoc.ReportDefController.ReportSectionController.Modify(oldSection, newSection)` |
| Print options | `doc.PrintOptions` (Engine API) |
| Object format (Engine) | `reportObject.ObjectFormat` |
| Field format (Engine) | `((FieldObject)obj).FieldFormat` |
| Suppress condition | `section.SectionFormat.SuppressFormula.Text = "..."` |
| Conditional color (Engine) | `field.ObjectFormat.ConditionFormulas["Color"].Text = "If ... Then crRed Else crBlack"` |
| Conditional formatting (RAS) | `obj.Format.ConditionFormulas.Formula(CrObjectFormatConditionFormulaTypeEnum....)` |
| CanGrow | `field.ObjectFormat.EnableCanGrow = true` |
| HTML text interpretation | `field.FieldFormat.StringFormat.TextFormat = CrTextFormatEnum.crTextFormatHTMLText` |

---

## Pitfalls

1. **Twips not pixels**: All positioning is in twips (1440/inch). A common mistake is using pixel values, resulting in objects that are microscopic or off-page.
2. **Section names**: The Engine API uses string-based section names like `"DetailSection1"`, `"GroupHeaderSection1"`. Use the RptToXml dump to discover exact names.
3. **Conditional formatting scope**: Suppress formulas on sections evaluate per-record. A section suppressed by formula still processes its data — the visual output is simply hidden.
4. **Margin PageMargins constructor**: The constructor order is `(left, right, top, bottom)` — not the CSS order (top, right, bottom, left).
5. **PrintOptions vs RAS**: Page setup via `PrintOptions` is available on the Engine `ReportDocument`. The RAS `ISCDReportClientDocument` uses a different path for some print properties.
6. **Special field names**: The `DataSourceName` values for special fields (e.g., `"PageNumber"`) are case-sensitive string constants, not enum values.
7. **ConditionFormulas key names**: The Engine API string keys (e.g., `"Color"`, `"BackColor"`) are case-sensitive. A typo silently creates a formula that is never evaluated.
8. **Color constants are formula-only**: `crRed`, `crBlack`, etc. are Crystal formula constants, not .NET values. They are used inside formula text strings, not as C# variables.
9. **CanGrow expands section height**: Enabling `CanGrow` on a field causes the entire section to grow. If multiple fields have `CanGrow`, the section height is determined by the tallest field's expanded content.
10. **HTML support is limited**: Crystal's HTML text interpretation only supports basic tags (`<b>`, `<i>`, `<font>`, `<br>`, `<p>`). CSS styling, JavaScript, and advanced HTML are ignored.
11. **RAS section properties are immutable**: You cannot set `section.Height` directly on a RAS section. Always use `Clone(true)` → set properties → `ReportSectionController.Modify(old, new)`.
12. **Clone(true) is deep clone**: When cloning sections, use `Clone(true)` (deep) to copy all sub-objects including format properties. `Clone(false)` (shallow) may lose format settings.
