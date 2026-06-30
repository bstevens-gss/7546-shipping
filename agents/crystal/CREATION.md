# Crystal Report Creation from Scratch

Create **new** Crystal Report `.rpt` files programmatically using the RAS InProc SDK (ReportAppServer).

---

## Architecture: Two-Phase Approach for Subreports

Crystal Reports SDK does NOT support adding `SubreportObject` via `ReportObjectController.Add()` — it throws "Adding or changing this kind of report object is not supported."

The correct approach:
1. **Create the subreport as a standalone .rpt file first**
2. **Create the main report and import the subreport** using `SubreportController.ImportSubreport()`

---

## Required References (Creation)

Report creation requires the full RAS InProc SDK (more DLLs than modification):

```
/reference:"Release\CrystalDecisions.CrystalReports.Engine.dll"
/reference:"Release\CrystalDecisions.Shared.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.ClientDoc.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.Controllers.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.DataDefModel.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.ReportDefModel.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.CommonObjectModel.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.CommLayer.dll"
/reference:"Release\CrystalDecisions.ReportAppServer.ObjectFactory.dll"
/reference:System.Drawing.dll
```

### Compile Command

```powershell
& "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe" `
  /platform:x86 /target:exe `
  /out:"Release\CreateReport.exe" `
  /reference:"Release\CrystalDecisions.CrystalReports.Engine.dll" `
  /reference:"Release\CrystalDecisions.Shared.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.ClientDoc.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.Controllers.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.DataDefModel.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.ReportDefModel.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.CommonObjectModel.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.CommLayer.dll" `
  /reference:"Release\CrystalDecisions.ReportAppServer.ObjectFactory.dll" `
  /reference:System.Drawing.dll `
  "CreateReport.cs"
```

---

## Key API Types and Namespaces

```csharp
using CrystalDecisions.ReportAppServer.ClientDoc;       // ISCDReportClientDocument
using CrystalDecisions.ReportAppServer.Controllers;     // DatabaseController, ReportObjectController, SubreportController
using CrystalDecisions.ReportAppServer.DataDefModel;    // Table, TableLink, ConnectionInfo, PropertyBag, SummaryField, Strings
using CrystalDecisions.ReportAppServer.ReportDefModel;  // FieldObject, SimpleTextObject, SubreportObject, SubreportLink(s), Section
using EngineDoc = CrystalDecisions.CrystalReports.Engine.ReportDocument;  // Alias to avoid ambiguity
```

**IMPORTANT**: `ReportDocument` exists in BOTH `CrystalDecisions.CrystalReports.Engine` and `CrystalDecisions.ReportAppServer.ReportDefModel`. Always use an alias for the Engine one.

---

## ODBC Connection Info (Zen/Pervasive)

The ODBC DSN name on this machine is `GLOBAL_PLA` (32-bit Pervasive ODBC Client Interface).
Credentials: `UserName = "Master"`, `Password = "master"`.

```csharp
static ConnectionInfo CreateConnectionInfo()
{
    var connInfo = new ConnectionInfo();
    var attrs = new PropertyBag();
    attrs.Add("Database DLL", "crdb_odbc.dll");
    attrs.Add("QE_DatabaseName", "");
    attrs.Add("QE_DatabaseType", "ODBC (RDO)");
    var logonProps = new PropertyBag();
    logonProps.Add("DSN", "GLOBAL_PLA");
    attrs.Add("QE_LogonProperties", logonProps);
    attrs.Add("QE_ServerDescription", "GLOBAL_PLA");
    attrs.Add("QE_SQLDB", "True");
    connInfo.Attributes = attrs;
    connInfo.Kind = CrConnectionInfoKindEnum.crConnectionInfoKindCRQE;
    connInfo.UserName = "Master";
    connInfo.Password = "master";
    return connInfo;
}
```

### PropertyBag API

`PropertyBag` uses `Add(string PropertyID, object value)` directly. There is NO `.Collection` property.

---

## Creating a New Report Document

```csharp
var doc = new EngineDoc();
ISCDReportClientDocument clientDoc = doc.ReportClientDocument;
clientDoc.New();
```

---

## Adding Database Tables

```csharp
var connInfo = CreateConnectionInfo();
var tbl = new Table();
tbl.Name = "TABLE_NAME";
tbl.Alias = "TABLE_NAME";
tbl.QualifiedName = "TABLE_NAME";
tbl.ConnectionInfo = connInfo;
clientDoc.DatabaseController.AddTable(tbl, null);
```

`AddTable` connects to the database and discovers all columns automatically. After calling it, you can access the table's fields via `clientDoc.DatabaseController.Database.Tables`.

---

## Adding Table Links (Joins)

```csharp
var link = new TableLink();
link.SourceTableAlias = "ORDER_HEADER";
link.TargetTableAlias = "CUSTOMER_MASTER";
link.JoinType = CrTableJoinTypeEnum.crTableJoinTypeEqualJoin;
var srcFields = new Strings();
srcFields.Add("CUSTOMER");
link.SourceFieldNames = srcFields;
var tgtFields = new Strings();
tgtFields.Add("CUSTOMER");
link.TargetFieldNames = tgtFields;
clientDoc.DatabaseController.AddTableLink(link);
```

`Strings` is `CrystalDecisions.ReportAppServer.DataDefModel.Strings` (not `System.String[]`).

---

## Adding Fields to the Report (Easiest Method)

`ReportObjectController.AddByName()` automatically places the field in Detail and creates a heading in PageHeader:

```csharp
var objCtrl = clientDoc.ReportDefController.ReportObjectController;
objCtrl.AddByName("{TABLE.FIELD_NAME}", "Column Heading Text");
```

Fields are placed left-to-right in the order you call `AddByName`.

---

## Adding Fields Manually (Precise Positioning)

For manual control, use `FieldObject` added via `ReportObjectController.Add()`:

```csharp
var reportDef = clientDoc.ReportDefController.ReportDefinition;
var footer = reportDef.ReportFooterArea.Sections[(object)0];

var fieldObj = new FieldObject();
fieldObj.DataSourceName = "{TABLE.FIELD}";   // or sumField.FormulaForm
fieldObj.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeNumberField;
fieldObj.Left = 6200;
fieldObj.Top = 50;
fieldObj.Width = 1500;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;
objCtrl.Add(fieldObj, footer, -1);
```

**IMPORTANT**: Section indexer requires `(object)0` cast: `Sections[(object)0]`.

**NOTE**: For `TextObject` creation, see the "Creating Text Objects" section below — the `Paragraphs/ParagraphElements` pattern avoids the null reference errors.

---

## Setting Fonts on RAS-Created Objects

The RAS SDK uses a different font model than the Engine API. Instead of `ApplyFont()`, set properties on the `FontColor.Font` object:

### Setting Font on a FieldObject

```csharp
var fieldObj = new FieldObject();
fieldObj.DataSourceName = "{TABLE.FIELD}";
fieldObj.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeStringField;
fieldObj.Left = 100;
fieldObj.Top = 50;
fieldObj.Width = 3000;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;

fieldObj.FontColor.Font.Name = "Arial";
fieldObj.FontColor.Font.Size = 10;
fieldObj.FontColor.Font.Bold = true;
fieldObj.FontColor.Font.Italic = false;
fieldObj.FontColor.Color = 0;  // black (RGB as packed int)

objCtrl.Add(fieldObj, section, -1);
```

### FontColor Properties

| Property | Type | Purpose |
|----------|------|---------|
| `FontColor.Font.Name` | string | Font family (e.g., `"Arial"`, `"Courier New"`) |
| `FontColor.Font.Size` | int | Font size in points |
| `FontColor.Font.Bold` | bool | Bold style |
| `FontColor.Font.Italic` | bool | Italic style |
| `FontColor.Font.Underline` | bool | Underline style |
| `FontColor.Font.Strikeout` | bool | Strikethrough style |
| `FontColor.Color` | int | Font color as packed RGB integer |

### RGB Color Values

The `FontColor.Color` property uses a packed integer format: `R + (G * 256) + (B * 65536)`:

| Color | Value | Calculation |
|-------|-------|-------------|
| Black | `0` | 0 + 0 + 0 |
| Red | `255` | 255 + 0 + 0 |
| Green | `32768` | 0 + (128 * 256) + 0 |
| Blue | `16711680` | 0 + 0 + (255 * 65536) |
| White | `16777215` | 255 + (255 * 256) + (255 * 65536) |

### Changing Font via EROM Bridge (Existing Reports)

When modifying fonts on existing objects via the EROM bridge (see `MODIFICATION.md`), use the `Clone → Modify` pattern:

```csharp
var allObjects = clientDoc.ReportDefController.ReportObjectController.GetAllReportObjects();
for (int i = 0; i < allObjects.Count; i++)
{
    if (allObjects[i].Name == "Field1")
    {
        var oldObj = allObjects[i];
        var newObj = (CrystalDecisions.ReportAppServer.ReportDefModel.FieldObject)oldObj.Clone(true);
        newObj.FontColor.Font.Name = "Arial";
        newObj.FontColor.Font.Size = 12;
        newObj.FontColor.Font.Bold = true;
        clientDoc.ReportDefController.ReportObjectController.Modify(oldObj, newObj);
        break;
    }
}
```

Source: SAP KB 1517511

---

## Creating Text Objects

Static text labels (not bound to a database field) require the `Paragraphs/ParagraphElements/ParagraphTextElement` structure. The simpler `TextObject.Text` property throws null reference errors when adding via `ReportObjectController.Add()`.

### Working Pattern (SAP KB 1306531)

```csharp
var textObj = new CrystalDecisions.ReportAppServer.ReportDefModel.TextObject();
textObj.Kind = CrReportObjectKindEnum.crReportObjectKindText;
textObj.Left = 100;
textObj.Top = 50;
textObj.Width = 3000;
textObj.Height = 250;

var paragraph = new CrystalDecisions.ReportAppServer.ReportDefModel.Paragraph();
var element = new CrystalDecisions.ReportAppServer.ReportDefModel.ParagraphTextElement();
element.Text = "My Label Text";
element.Kind = CrParagraphElementKindEnum.crParagraphElementKindText;

element.FontColor = new CrystalDecisions.ReportAppServer.ReportDefModel.FontColor();
element.FontColor.Font.Name = "Arial";
element.FontColor.Font.Size = 10;
element.FontColor.Font.Bold = true;
element.FontColor.Color = 0;  // black

paragraph.ParagraphElements.Add(element);
textObj.Paragraphs.Add(paragraph);

var section = clientDoc.ReportDefController.ReportDefinition.PageHeaderArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.Add(textObj, section, -1);
```

### Mixed Formatting in a Single Text Object

Add multiple `ParagraphTextElement` objects to the same `Paragraph` for mixed formatting (bold + regular in the same line):

```csharp
var boldElement = new ParagraphTextElement();
boldElement.Text = "Total: ";
boldElement.Kind = CrParagraphElementKindEnum.crParagraphElementKindText;
boldElement.FontColor = new FontColor();
boldElement.FontColor.Font.Name = "Arial";
boldElement.FontColor.Font.Size = 10;
boldElement.FontColor.Font.Bold = true;
boldElement.FontColor.Color = 0;

var valueElement = new ParagraphTextElement();
valueElement.Text = "$1,500.00";
valueElement.Kind = CrParagraphElementKindEnum.crParagraphElementKindText;
valueElement.FontColor = new FontColor();
valueElement.FontColor.Font.Name = "Arial";
valueElement.FontColor.Font.Size = 10;
valueElement.FontColor.Font.Bold = false;
valueElement.FontColor.Color = 0;

paragraph.ParagraphElements.Add(boldElement);
paragraph.ParagraphElements.Add(valueElement);
```

### Multi-Line Text

For multiple lines, add multiple `Paragraph` objects to the `TextObject`:

```csharp
var line1 = new Paragraph();
var elem1 = new ParagraphTextElement();
elem1.Text = "Line 1";
elem1.Kind = CrParagraphElementKindEnum.crParagraphElementKindText;
line1.ParagraphElements.Add(elem1);

var line2 = new Paragraph();
var elem2 = new ParagraphTextElement();
elem2.Text = "Line 2";
elem2.Kind = CrParagraphElementKindEnum.crParagraphElementKindText;
line2.ParagraphElements.Add(elem2);

textObj.Paragraphs.Add(line1);
textObj.Paragraphs.Add(line2);
```

---

## Cross-References to Other Crystal Sub-Files

The base creation workflow is in this file. For specific features, load the relevant sub-file:

| Feature | Sub-File |
|---------|----------|
| Groups, sorting, group-level summaries | `GROUPS.md` |
| Formula fields, variables (Local/Global/Shared), running totals, shared variable patterns | `FORMULAS.md` |
| Section formatting, page setup, conditional formatting, field formatting, special fields | `FORMATTING.md` |
| SQL commands, parameters, database swapping, export to PDF/Excel | `DATASOURCES.md` |
| Cross-tabs, charts, rich text objects | `ADVANCED.md` |

---

## Page Setup at Creation Time

Set paper size and orientation after creating the report document:

```csharp
var doc = new EngineDoc();
ISCDReportClientDocument clientDoc = doc.ReportClientDocument;
clientDoc.New();

// Set page orientation and size via the Engine document
doc.PrintOptions.PaperOrientation =
    CrystalDecisions.Shared.PaperOrientation.Landscape;
doc.PrintOptions.PaperSize =
    CrystalDecisions.Shared.PaperSize.PaperLetter;
```

See `FORMATTING.md` for margin configuration, twips reference, and additional PrintOptions.

---

## Export After Creation

After saving a report, export it to PDF or other formats via the Engine API:

```csharp
// Save the report first
SaveReport(clientDoc, doc, outputPath);

// Reopen and export
var exportDoc = new EngineDoc();
exportDoc.Load(outputPath);

// Apply credentials
foreach (CrystalDecisions.CrystalReports.Engine.Table table in exportDoc.Database.Tables)
{
    var logonInfo = table.LogOnInfo;
    logonInfo.ConnectionInfo.UserID = "Master";
    logonInfo.ConnectionInfo.Password = "master";
    table.ApplyLogOnInfo(logonInfo);
}

exportDoc.ExportToDisk(
    CrystalDecisions.Shared.ExportFormatType.PortableDocFormat,
    @"C:\Output\Report.pdf");
exportDoc.Close();
```

See `DATASOURCES.md` for full export options, Excel/CSV formats, and ExportOptions configuration.

---

## Record Selection Formula

```csharp
clientDoc.DataDefController.RecordFilterController.SetFormulaText(
    "{TABLE.FIELD} = \"value\"");
```

Use `SetFormulaText` (NOT `Modify` with a Filter object).

---

## Summary Fields (SUM, AVG, etc.)

```csharp
// Find the field in the database model
var tables = clientDoc.DatabaseController.Database.Tables;
ISCRField extField = null;
for (int i = 0; i < tables.Count; i++)
{
    var tbl = tables[i];
    if (tbl.Alias == "TABLE_NAME")
    {
        var fields = tbl.DataFields;
        for (int j = 0; j < fields.Count; j++)
        {
            if (fields[j].Name == "FIELD_NAME")
            {
                extField = fields[j];
                break;
            }
        }
    }
}

// Create and register the summary
var sumField = new SummaryField();
sumField.Operation = CrSummaryOperationEnum.crSummaryOperationSum;
sumField.SummarizedField = extField;
clientDoc.DataDefController.SummaryFieldController.Add(-1, sumField);

// Place it on the report (e.g., ReportFooter)
var fieldObj = new FieldObject();
fieldObj.DataSourceName = sumField.FormulaForm;
fieldObj.FieldValueType = sumField.Type;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;
// ... set Left, Top, Width, Height ...
objCtrl.Add(fieldObj, footerSection, -1);
```

`SummaryFieldController.Add(int indexToAdd, SummaryField)` — index first, then field. Use `-1` to append.

---

## Subreports

### Step 1: Create subreport as standalone .rpt

Build it as a complete report with its own tables, fields, and record selection, then save it.

### Step 2: Import into main report

`ImportSubreport` places a subreport object into any section — Detail, GroupHeader, GroupFooter, ReportHeader, etc.:

```csharp
var reportDef = clientDoc.ReportDefController.ReportDefinition;

// Place in Detail
var detail = reportDef.DetailArea.Sections[(object)0];
string subName = "MySubreport";
clientDoc.SubreportController.ImportSubreport(subName, subReportFilePath, detail);

// Or place in Group Header
var groupHeader = reportDef.GroupHeaderArea.Sections[(object)0];
clientDoc.SubreportController.ImportSubreport(subName, subReportFilePath, groupHeader);
```

### Step 3: Reposition and resize the subreport

`ImportSubreport` drops the subreport at a default position. To control placement, find the subreport object in the section and modify its position via `ReportObjectController.Modify()`:

```csharp
// Twips reference: 1440 twips = 1 inch
// Letter portrait printable area (0.5" margins): 10800 twips wide

var section = reportDef.GroupHeaderArea.Sections[(object)0];
for (int i = 0; i < section.ReportObjects.Count; i++)
{
    var obj = section.ReportObjects[i];
    if (obj.Kind == CrReportObjectKindEnum.crReportObjectKindSubreport)
    {
        obj.Left = 7560;     // 70% from left (top-right placement)
        obj.Top = 0;
        obj.Width = 3240;    // 30% of printable width
        obj.Height = 2000;   // max display height (~1.4 inches)

        clientDoc.ReportDefController.ReportObjectController.Modify(
            section.ReportObjects[i], obj);
        break;
    }
}
```

### Common Subreport Placement Calculations

All values assume 0.5" margins (720 twips each side).

| Page Layout | Printable Width | 30% Width | 70% Left Offset | 50% Width | 50% Left Offset |
|-------------|----------------|-----------|-----------------|-----------|-----------------|
| Letter Portrait | 10,800 | 3,240 | 7,560 | 5,400 | 5,400 |
| Letter Landscape | 14,400 | 4,320 | 10,080 | 7,200 | 7,200 |
| Legal Portrait | 10,800 | 3,240 | 7,560 | 5,400 | 5,400 |
| A4 Portrait | 10,467 | 3,140 | 7,327 | 5,234 | 5,234 |

The `Height` property is a **maximum display height** — Crystal shrinks the subreport if it produces less content, but will not grow beyond this value.

### Step 4: Set subreport links

```csharp
var subLinks = new SubreportLinks();
var sLink = new SubreportLink();
sLink.MainReportFieldName = "{MAIN_TABLE.LINK_FIELD}";
sLink.SubreportFieldName = "{SUB_TABLE.LINK_FIELD}";
subLinks.Add(sLink);
clientDoc.SubreportController.SetSubreportLinks(subName, subLinks);
```

`SubreportLink` properties are strings (`MainReportFieldName`, `SubreportFieldName`), NOT field objects.

### Passing Data Back from Subreport (Shared Variables)

Subreport links only pass data **down** (main → sub) to filter the subreport. To pass data **back** from a subreport to the main report, use **shared variables**. See `FORMULAS.md` for the complete shared variable pattern, including:

- Writing a shared variable in the subreport
- Reading it in the main report (must be in a section below the subreport)
- Resetting the variable per group to prevent stale values

### Modifying Subreport Internals (SubreportClientDocument)

After importing a subreport, you can access its full internal definition — add fields, formulas, groups, etc. inside the subreport — via `SubreportController.GetSubreport()`:

```csharp
var subDoc = clientDoc.SubreportController.GetSubreport("SubreportName");

// subDoc has the same controllers as the main clientDoc:
// subDoc.DataDefController, subDoc.ReportDefController, etc.
```

**Example: Add a formula field inside a subreport:**
```csharp
clientDoc.SubreportController.ImportSubreport("InvoiceDetail", subPath, detail);

var subDoc = clientDoc.SubreportController.GetSubreport("InvoiceDetail");

var formula = new FormulaField();
formula.Name = "LineTotal";
formula.Text = "{INVOICE_DET.QTY} * {INVOICE_DET.UNIT_PRICE}";
formula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxCrystal;
formula.Type = CrFieldValueTypeEnum.crFieldValueTypeCurrencyField;
subDoc.DataDefController.FormulaFieldController.Add(formula);

var fieldObj = new FieldObject();
fieldObj.DataSourceName = formula.FormulaForm;
fieldObj.FieldValueType = formula.Type;
fieldObj.Left = 6000;
fieldObj.Top = 50;
fieldObj.Width = 2000;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;

var subDetail = subDoc.ReportDefController.ReportDefinition.DetailArea.Sections[(object)0];
subDoc.ReportDefController.ReportObjectController.Add(fieldObj, subDetail, -1);
```

**Finding the subreport name**: Use `SubreportController.GetSubreportNames()` if the name is unknown. The name is what was passed to `ImportSubreport()`.

### On-Demand Subreports

By default, imported subreports process their data whenever the main report runs — even if the user never looks at them. For large detail-level subreports, this causes significant performance overhead. On-demand subreports only process when the user clicks the subreport hyperlink in a viewer.

**Setting a subreport to on-demand:**

After importing the subreport, find the `SubreportObject` in the section and set `IsOnDemand`:

```csharp
clientDoc.SubreportController.ImportSubreport("OrderDetails", subPath, detail);

var allObjects = clientDoc.ReportDefController.ReportObjectController.GetAllReportObjects();
for (int i = 0; i < allObjects.Count; i++)
{
    if (allObjects[i].Kind == CrReportObjectKindEnum.crReportObjectKindSubreport
        && allObjects[i].Name == "OrderDetails")
    {
        var oldSub = (CrystalDecisions.ReportAppServer.ReportDefModel.SubreportObject)allObjects[i];
        var newSub = (CrystalDecisions.ReportAppServer.ReportDefModel.SubreportObject)oldSub.Clone(true);
        newSub.IsOnDemand = true;
        newSub.OnDemandCaption = "Click to view order details";
        clientDoc.ReportDefController.ReportObjectController.Modify(oldSub, newSub);
        break;
    }
}
```

**On-Demand Properties:**

| Property | Type | Purpose |
|----------|------|---------|
| `IsOnDemand` | bool | `true` = subreport only processes when clicked |
| `OnDemandCaption` | string | Hyperlink text displayed in place of the subreport |

**When to use on-demand:**

| Scenario | Use On-Demand? |
|----------|---------------|
| Detail-level subreport with many records | Yes — avoids processing every row |
| Subreport shown for every record (always visible) | No — on-demand adds click overhead |
| Group header/footer subreport | Usually no — fewer instances |
| Drill-down detail from summary report | Yes — classic use case |

**Note**: On-demand subreports display as a hyperlink in Crystal Report Viewer (WinForms/WebForms). In headless export (PDF, Excel), the subreport content is always included regardless of `IsOnDemand`.

---

## Adding Sections (Detail a/b, Multiple Group Sections)

Reports can have multiple sections within the same area (e.g., Detail a, Detail b). This is useful for placing a subreport in one section and fields in another, or for creating suppressed calculation sections.

### Creating a New Section

```csharp
var newSection = new CrystalDecisions.ReportAppServer.ReportDefModel.Section();
newSection.Kind = CrAreaSectionKindEnum.crAreaSectionKindDetail;
newSection.Name = "DetailB";
newSection.Height = 400;
newSection.Width = 11520;   // ~8 inches

var detailArea = clientDoc.ReportDefController.ReportDefinition.DetailArea;
clientDoc.ReportDefController.ReportSectionController.Add(newSection, detailArea, -1);
```

`ReportSectionController.Add(section, area, index)` — index `-1` appends. Index `0` inserts before existing sections.

### Section Kind Enum

Use `CrAreaSectionKindEnum` to match the area you are adding to:

| Enum Value | Area |
|-----------|------|
| `crAreaSectionKindReportHeader` | Report Header |
| `crAreaSectionKindPageHeader` | Page Header |
| `crAreaSectionKindDetail` | Detail |
| `crAreaSectionKindReportFooter` | Report Footer |
| `crAreaSectionKindPageFooter` | Page Footer |
| `crAreaSectionKindGroupHeader` | Group Header |
| `crAreaSectionKindGroupFooter` | Group Footer |

### Setting Section Height

Section height is set in twips (1440 = 1 inch). The `Width` typically matches the printable page width.

```csharp
newSection.Height = 720;   // 0.5 inches
newSection.Width = 10800;  // letter portrait printable width
```

### Common Multi-Section Pattern: Subreport in Detail A, Fields in Detail B

```csharp
// Detail A already exists — place subreport there
var detailA = clientDoc.ReportDefController.ReportDefinition.DetailArea.Sections[(object)0];
clientDoc.SubreportController.ImportSubreport("MySub", subPath, detailA);

// Create Detail B for additional fields
var detailB = new CrystalDecisions.ReportAppServer.ReportDefModel.Section();
detailB.Kind = CrAreaSectionKindEnum.crAreaSectionKindDetail;
detailB.Name = "DetailB";
detailB.Height = 300;
detailB.Width = 11520;
clientDoc.ReportDefController.ReportSectionController.Add(
    detailB, clientDoc.ReportDefController.ReportDefinition.DetailArea, -1);

// Add fields to Detail B
var fieldObj = new FieldObject();
fieldObj.DataSourceName = "{TABLE.FIELD}";
fieldObj.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeStringField;
fieldObj.Left = 100;
fieldObj.Top = 50;
fieldObj.Width = 3000;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;

var detailBSection = clientDoc.ReportDefController.ReportDefinition
    .DetailArea.Sections[(object)1];
clientDoc.ReportDefController.ReportObjectController.Add(fieldObj, detailBSection, -1);
```

---

## Saving the Report

`SaveAs` takes filename and directory as SEPARATE parameters:

```csharp
string dir = Path.GetDirectoryName(Path.GetFullPath(outputPath));
string fileName = Path.GetFileName(outputPath);
clientDoc.SaveAs(fileName, dir, 0);
doc.Close();
```

Do NOT pass a full path as the first argument — it will fail with "Value does not fall within the expected range."

---

## Enum Values Reference

| Enum | Values |
|------|--------|
| `CrConnectionInfoKindEnum` | `crConnectionInfoKindCRQE`, `crConnectionInfoKindSQL`, `crConnectionInfoKindQuery` |
| `CrTableJoinTypeEnum` | `crTableJoinTypeEqualJoin`, `crTableJoinTypeLeftOuterJoin`, `crTableJoinTypeRightOuterJoin` |
| `CrReportObjectKindEnum` | `crReportObjectKindField`, `crReportObjectKindText`, `crReportObjectKindSubreport`, `crReportObjectKindLine` |
| `CrSummaryOperationEnum` | `crSummaryOperationSum`, `crSummaryOperationAverage`, `crSummaryOperationCount`, `crSummaryOperationMaximum`, `crSummaryOperationMinimum` |
| `CrFieldValueTypeEnum` | `crFieldValueTypeStringField`, `crFieldValueTypeNumberField`, `crFieldValueTypeCurrencyField`, `crFieldValueTypeDateField` |

---

## Controller Access Patterns

| Need | Access Path | Details In |
|------|-------------|-----------|
| Add/remove tables | `clientDoc.DatabaseController` | This file |
| Table links | `clientDoc.DatabaseController.AddTableLink()` | This file |
| Add report objects | `clientDoc.ReportDefController.ReportObjectController.Add(obj, section, -1)` | This file |
| Reposition/resize objects | `clientDoc.ReportDefController.ReportObjectController.Modify(oldObj, newObj)` | This file |
| Remove objects | `clientDoc.ReportDefController.ReportObjectController.Remove(obj)` | `MODIFICATION.md` |
| Clone objects (for move) | `obj.Clone(true)` then Add to new section, Remove from old | `MODIFICATION.md` |
| Get all objects | `clientDoc.ReportDefController.ReportObjectController.GetAllReportObjects()` | `MODIFICATION.md` |
| Add result field | `clientDoc.DataDefController.ResultFieldController.Add(-1, field)` | This file |
| Add new section | `clientDoc.ReportDefController.ReportSectionController.Add(section, area, -1)` | This file |
| Record selection | `clientDoc.DataDefController.RecordFilterController.SetFormulaText()` | This file |
| Summary fields | `clientDoc.DataDefController.SummaryFieldController.Add()` | This file |
| Subreports | `clientDoc.SubreportController` | This file |
| Report sections | `clientDoc.ReportDefController.ReportDefinition.DetailArea.Sections[(object)0]` | This file |
| Groups | `clientDoc.DataDefController.GroupController.Add()` | `GROUPS.md` |
| Sorting | `clientDoc.DataDefController.SortController.Add()` | `GROUPS.md` |
| Formula fields | `clientDoc.DataDefController.FormulaFieldController.Add()` | `FORMULAS.md` |
| Parameters | `clientDoc.DataDefController.ParameterFieldController.Add()` | `DATASOURCES.md` |
| Group selection | `clientDoc.DataDefController.GroupFilterController.SetFormulaText()` | `GROUPS.md` |

Note: `ReportDefController` actually returns type `ReportDefController2` (not `ReportDefController`).

---

## Common Pitfalls

1. **Ambiguous types**: `ReportDocument`, `Section`, `TableLink` exist in multiple namespaces. Use aliases or fully-qualified names.
2. **SubreportObject cannot be added directly** — always use `ImportSubreport`.
3. **SaveAs requires separate filename and directory** — not a full path.
4. **Section indexer needs (object) cast** — `Sections[(object)0]` not `Sections[0]`.
5. **AddTable requires live database connection** — it connects to discover schema. Ensure DSN, credentials, and Zen engine are running.
6. **PropertyBag.Add(string, object)** — no `.Collection` accessor, no `NameValuePair2`.
7. **Credentials required** — Zen DB needs `UserName="Master"` / `Password="master"` on this system.
8. **32-bit ODBC DSN** — The DSN `GLOBAL_PLA` is 32-bit only. The exe MUST be compiled `/platform:x86`.
9. **Repositioning after Add/Import** — `ReportObjectController.Add()` and `SubreportController.ImportSubreport()` place objects at default positions. To reposition, find the object in `section.ReportObjects` and call `ReportObjectController.Modify(oldObj, newObj)` with updated `Left`/`Top`/`Width`/`Height`.
10. **Subreport Height is a max** — The `Height` on a subreport object is a maximum display height. Crystal shrinks it if the subreport produces less content but will not grow beyond this value.
11. **On-demand subreports in exports** — `IsOnDemand` only affects interactive viewers. PDF and Excel exports always include subreport content regardless of the on-demand setting.
12. **TextObject requires ParagraphElements** — Do NOT set `TextObject.Text` directly and call `Add()`. Use the `Paragraphs → ParagraphElements → ParagraphTextElement` structure (see "Creating Text Objects" section). SAP KB 1306531.
13. **FontColor.Font must be set before Add()** — Font properties on RAS objects (FieldObject, TextObject elements) must be set before calling `ReportObjectController.Add()`. Setting them after add has no effect.

---

## Database Discovery (Zen/Pervasive)

To find tables in the Zen database (schema `GLOBALPLA`):
```sql
SELECT Xf$Name FROM X$File WHERE Xf$Name LIKE '%keyword%'
```

The MCP server `user-zen-db` can query this database. Key tables for ERP:
- `ORDER_HEADER` (RECORD_TYPE='A' for header records)
- `ORDER_LINES` (RECORD_TYPE='L' for line records)
- `CUSTOMER_MASTER` (REC='1' for name record)
- `OPEN_SALES_ORDER`, `ORDER_HIST_HEAD`, `ORDER_HIST_LINE`

---

## Complete Template: Report with Subreport

```csharp
using System;
using System.IO;
using CrystalDecisions.ReportAppServer.ClientDoc;
using CrystalDecisions.ReportAppServer.Controllers;
using CrystalDecisions.ReportAppServer.DataDefModel;
using CrystalDecisions.ReportAppServer.ReportDefModel;
using EngineDoc = CrystalDecisions.CrystalReports.Engine.ReportDocument;

class CreateReport
{
    static int Main(string[] args)
    {
        string outputPath = args.Length > 0 ? args[0] : "MyReport.rpt";
        string subPath = Path.Combine(
            Path.GetDirectoryName(Path.GetFullPath(outputPath)), "SubReport.rpt");

        try
        {
            CreateSubreport(subPath);
            CreateMainReport(outputPath, subPath);
            Console.WriteLine("Done: " + outputPath);
            return 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex.Message);
            Console.WriteLine(ex.StackTrace);
            return 1;
        }
    }

    static ConnectionInfo CreateConnectionInfo()
    {
        var connInfo = new ConnectionInfo();
        var attrs = new PropertyBag();
        attrs.Add("Database DLL", "crdb_odbc.dll");
        attrs.Add("QE_DatabaseName", "");
        attrs.Add("QE_DatabaseType", "ODBC (RDO)");
        var logonProps = new PropertyBag();
        logonProps.Add("DSN", "GLOBAL_PLA");
        attrs.Add("QE_LogonProperties", logonProps);
        attrs.Add("QE_ServerDescription", "GLOBAL_PLA");
        attrs.Add("QE_SQLDB", "True");
        connInfo.Attributes = attrs;
        connInfo.Kind = CrConnectionInfoKindEnum.crConnectionInfoKindCRQE;
        connInfo.UserName = "Master";
        connInfo.Password = "master";
        return connInfo;
    }

    static void SaveReport(ISCDReportClientDocument clientDoc, EngineDoc doc, string path)
    {
        string dir = Path.GetDirectoryName(Path.GetFullPath(path));
        string fileName = Path.GetFileName(path);
        clientDoc.SaveAs(fileName, dir, 0);
        doc.Close();
    }

    static void CreateSubreport(string path)
    {
        var doc = new EngineDoc();
        ISCDReportClientDocument clientDoc = doc.ReportClientDocument;
        clientDoc.New();

        var connInfo = CreateConnectionInfo();
        var tbl = new Table();
        tbl.Name = "SUB_TABLE";
        tbl.Alias = "SUB_TABLE";
        tbl.QualifiedName = "SUB_TABLE";
        tbl.ConnectionInfo = connInfo;
        clientDoc.DatabaseController.AddTable(tbl, null);

        clientDoc.DataDefController.RecordFilterController.SetFormulaText(
            "{SUB_TABLE.FILTER_FIELD} = \"value\"");

        var objCtrl = clientDoc.ReportDefController.ReportObjectController;
        objCtrl.AddByName("{SUB_TABLE.FIELD1}", "Heading1");
        objCtrl.AddByName("{SUB_TABLE.FIELD2}", "Heading2");

        SaveReport(clientDoc, doc, path);
    }

    static void CreateMainReport(string outputPath, string subPath)
    {
        var doc = new EngineDoc();
        ISCDReportClientDocument clientDoc = doc.ReportClientDocument;
        clientDoc.New();

        var connInfo = CreateConnectionInfo();

        var tbl1 = new Table();
        tbl1.Name = "MAIN_TABLE";
        tbl1.Alias = "MAIN_TABLE";
        tbl1.QualifiedName = "MAIN_TABLE";
        tbl1.ConnectionInfo = connInfo;
        clientDoc.DatabaseController.AddTable(tbl1, null);

        clientDoc.DataDefController.RecordFilterController.SetFormulaText(
            "{MAIN_TABLE.TYPE} = \"A\"");

        var objCtrl = clientDoc.ReportDefController.ReportObjectController;
        objCtrl.AddByName("{MAIN_TABLE.FIELD1}", "Heading1");
        objCtrl.AddByName("{MAIN_TABLE.FIELD2}", "Heading2");

        var detail = clientDoc.ReportDefController.ReportDefinition
            .DetailArea.Sections[(object)0];
        string subName = "MySubreport";
        clientDoc.SubreportController.ImportSubreport(subName, subPath, detail);

        var subLinks = new SubreportLinks();
        var sLink = new SubreportLink();
        sLink.MainReportFieldName = "{MAIN_TABLE.KEY}";
        sLink.SubreportFieldName = "{SUB_TABLE.FK}";
        subLinks.Add(sLink);
        clientDoc.SubreportController.SetSubreportLinks(subName, subLinks);

        SaveReport(clientDoc, doc, outputPath);
    }
}
```
