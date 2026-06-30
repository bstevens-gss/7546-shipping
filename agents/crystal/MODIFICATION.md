# Crystal Report Modification Workflow

Modify existing `.rpt` files using a 3-step workflow: **Inspect (XML) → Plan → Modify (C#)**.

---

## Step 1: Inspect the Report with RptToXml

Dump the `.rpt` to XML to understand its structure:

```
.\Release\RptToXml.exe "Report1.rpt" "Report1.xml"
```

The XML shows the full report definition: Areas, Sections, ReportObjects (fields, headings, text, lines), fonts, positions, database tables, formulas, parameters, and groups.

### Key XML Elements

| Element | Description |
|---------|-------------|
| `FieldHeadingObject` | Column header text in PageHeader |
| `FieldObject` | Database field or special field placed on report |
| `TextObject` | Static text |
| `FormulaFieldObject` | Formula field |
| `SummaryFieldObject` | Aggregate/summary field |
| `LineObject` | Horizontal/vertical line |

### Report Object Identification

Each object has `Name` (e.g. `Text2`), `Kind`, and positional attributes (`Top`, `Left`, `Width`, `Height`). Use these to locate the target object in C#. Font properties are nested: `Bold`, `Italic`, `Underline`, `Style`, `Size`, `Name`.

---

## Step 2: Write a C# Modifier

### Required References (Modification Only)

```
/reference:"Release\CrystalDecisions.CrystalReports.Engine.dll"
/reference:"Release\CrystalDecisions.Shared.dll"
/reference:System.Drawing.dll
```

### Compile Command

```powershell
& "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe" `
  /platform:x86 /target:exe `
  /out:"Release\MyModifier.exe" `
  /reference:"Release\CrystalDecisions.CrystalReports.Engine.dll" `
  /reference:"Release\CrystalDecisions.Shared.dll" `
  /reference:System.Drawing.dll `
  "MyModifier.cs"
```

### C# Template for Report Modification

```csharp
using System;
using System.Drawing;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

class ReportModifier
{
    static int Main(string[] args)
    {
        string rptPath = args[0];
        var doc = new ReportDocument();
        doc.Load(rptPath);

        foreach (Area area in doc.ReportDefinition.Areas)
        {
            // Filter by area.Kind:
            //   AreaSectionKind.ReportHeader
            //   AreaSectionKind.PageHeader
            //   AreaSectionKind.Detail
            //   AreaSectionKind.ReportFooter
            //   AreaSectionKind.PageFooter
            //   AreaSectionKind.GroupHeader1..5
            //   AreaSectionKind.GroupFooter1..5

            foreach (Section section in area.Sections)
            {
                foreach (ReportObject obj in section.ReportObjects)
                {
                    // Cast by obj.Kind:
                    //   ReportObjectKind.FieldHeadingObject → (FieldHeadingObject)
                    //   ReportObjectKind.FieldObject → (FieldObject)
                    //   ReportObjectKind.TextObject → (TextObject)

                    // Match by obj.Name (e.g. "Text2") or text content
                }
            }
        }

        doc.SaveAs(rptPath);
        doc.Close();
        return 0;
    }
}
```

---

## Common Modifications

**Change font (bold, italic, size):**
```csharp
var heading = (FieldHeadingObject)obj;
var font = new Font("Arial", 10f, FontStyle.Bold | FontStyle.Underline);
heading.ApplyFont(font);
```

**Change text content:**
```csharp
var textObj = (TextObject)obj;
textObj.Text = "New Header Text";
```

**Change field object font:**
```csharp
var field = (FieldObject)obj;
field.ApplyFont(new Font("Arial", 9f, FontStyle.Regular));
```

**Change object color:**
```csharp
var textObj = (TextObject)obj;
textObj.Color = Color.DarkBlue;
```

---

## Report Metadata (SummaryInfo)

Every `.rpt` file has metadata properties (title, author, comments) accessible via `SummaryInfo`. These values power the special fields `ReportTitle`, `FileAuthor`, etc. in `FORMATTING.md`.

### Reading Metadata

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

string title = doc.SummaryInfo.ReportTitle;
string author = doc.SummaryInfo.ReportAuthor;
string comments = doc.SummaryInfo.ReportComments;
string subject = doc.SummaryInfo.ReportSubject;
string keywords = doc.SummaryInfo.KeywordsInReport;
```

### Setting Metadata

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

doc.SummaryInfo.ReportTitle = "Monthly Sales Report";
doc.SummaryInfo.ReportAuthor = "Automated";
doc.SummaryInfo.ReportComments = "Generated " + DateTime.Now.ToString("yyyy-MM-dd HH:mm");
doc.SummaryInfo.ReportSubject = "Sales Analysis";
doc.SummaryInfo.KeywordsInReport = "sales;monthly;revenue";

doc.SaveAs(outputPath);
doc.Close();
```

### SummaryInfo Properties

| Property | Type | Maps to Special Field |
|----------|------|----------------------|
| `ReportTitle` | string | `{ReportTitle}` |
| `ReportAuthor` | string | `{FileAuthor}` |
| `ReportComments` | string | (no built-in field; access via API) |
| `ReportSubject` | string | (no built-in field; access via API) |
| `KeywordsInReport` | string | (no built-in field; access via API) |
| `LastSavedBy` | string (read-only) | `{FileCreationDate}` |
| `RevisionNumber` | string (read-only) | (internal tracking) |

**Note**: `SummaryInfo` is Engine API only. It does not require the RAS SDK.

---

## EROM Bridge: Adding New Objects to an Existing Report

The Engine API (above) can only modify properties on **existing** objects. To **add new** objects, fields, groups, formulas, or sections to an existing report, use the EROM bridge — load the report via Engine, then access the full RAS SDK through `ReportClientDocument`.

### Required References (EROM Bridge)

The EROM bridge requires the full RAS DLL set (same as creation):

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

### Accessing the RAS SDK from an Existing Report

```csharp
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.ReportAppServer.ClientDoc;
using CrystalDecisions.ReportAppServer.Controllers;
using CrystalDecisions.ReportAppServer.DataDefModel;
using CrystalDecisions.ReportAppServer.ReportDefModel;

var doc = new ReportDocument();
doc.Load("Existing.rpt");

// EROM bridge — access the full RAS SDK
ISCDReportClientDocument clientDoc = doc.ReportClientDocument;

// Now use ALL RAS APIs on the existing report:
// clientDoc.DatabaseController, clientDoc.DataDefController,
// clientDoc.ReportDefController, clientDoc.SubreportController, etc.
```

After the bridge is established, every RAS pattern from `CREATION.md`, `GROUPS.md`, `FORMULAS.md`, etc. works on this existing report.

### Example: Add a New Formula Field to an Existing Report

```csharp
var doc = new ReportDocument();
doc.Load("Existing.rpt");
ISCDReportClientDocument clientDoc = doc.ReportClientDocument;

var formula = new FormulaField();
formula.Name = "DaysToShip";
formula.Text = "DateDiff(\"d\", {ORDER_HEADER.ORDER_DATE}, {ORDER_HEADER.SHIP_DATE})";
formula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxCrystal;
formula.Type = CrFieldValueTypeEnum.crFieldValueTypeNumberField;
clientDoc.DataDefController.FormulaFieldController.Add(formula);

var fieldObj = new CrystalDecisions.ReportAppServer.ReportDefModel.FieldObject();
fieldObj.DataSourceName = formula.FormulaForm;
fieldObj.FieldValueType = formula.Type;
fieldObj.Left = 8000;
fieldObj.Top = 50;
fieldObj.Width = 1500;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;

var detail = clientDoc.ReportDefController.ReportDefinition.DetailArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.Add(fieldObj, detail, -1);

doc.SaveAs("Existing.rpt");
doc.Close();
```

### Example: Add a Group to an Existing Report

```csharp
var doc = new ReportDocument();
doc.Load("FlatListing.rpt");
ISCDReportClientDocument clientDoc = doc.ReportClientDocument;

int tableIdx = clientDoc.DatabaseController.Database.Tables.FindByAlias("ORDER_HEADER");
var table = (Table)clientDoc.DatabaseController.Database.Tables[tableIdx];
var field = (Field)table.DataFields.FindField(
    "{ORDER_HEADER.CUSTOMER}",
    CrFieldDisplayNameTypeEnum.crFieldDisplayNameFormula,
    CeLocale.ceLocaleUserDefault);

var group = new Group();
group.ConditionField = field;
clientDoc.DataDefController.GroupController.Add(-1, group);

doc.SaveAs("GroupedReport.rpt");
doc.Close();
```

### Object Removal and Movement

The EROM bridge also enables removing and moving objects — operations not possible with the Engine API alone.

**Remove an object:**
```csharp
var allObjects = clientDoc.ReportDefController.ReportObjectController.GetAllReportObjects();
for (int i = 0; i < allObjects.Count; i++)
{
    if (allObjects[i].Name == "Text2")
    {
        clientDoc.ReportDefController.ReportObjectController.Remove(allObjects[i]);
        break;
    }
}
```

**Move an object between sections** (clone → add to new → remove from old):
```csharp
var section = clientDoc.ReportDefController.ReportDefinition.DetailArea.Sections[(object)0];
var targetSection = clientDoc.ReportDefController.ReportDefinition.ReportFooterArea.Sections[(object)0];

for (int i = 0; i < section.ReportObjects.Count; i++)
{
    var obj = section.ReportObjects[i];
    if (obj.Name == "Field1")
    {
        var clone = (CrystalDecisions.ReportAppServer.ReportDefModel.ReportObject)obj.Clone(true);
        clientDoc.ReportDefController.ReportObjectController.Add(clone, targetSection, -1);
        clientDoc.ReportDefController.ReportObjectController.Remove(obj);
        break;
    }
}
```

**Get all objects across all sections:**
```csharp
var allObjects = clientDoc.ReportDefController.ReportObjectController.GetAllReportObjects();
for (int i = 0; i < allObjects.Count; i++)
{
    Console.WriteLine(allObjects[i].Name + " : " + allObjects[i].Kind);
}
```

### Changing Fonts via EROM Bridge (RAS Pattern)

The Engine API uses `ApplyFont()` (shown in Common Modifications above). The EROM bridge uses the RAS `FontColor.Font` pattern instead:

```csharp
var doc = new ReportDocument();
doc.Load("Existing.rpt");
ISCDReportClientDocument clientDoc = doc.ReportClientDocument;

var allObjects = clientDoc.ReportDefController.ReportObjectController.GetAllReportObjects();
for (int i = 0; i < allObjects.Count; i++)
{
    if (allObjects[i].Name == "Field1")
    {
        var oldObj = allObjects[i];
        var newObj = (CrystalDecisions.ReportAppServer.ReportDefModel.FieldObject)oldObj.Clone(true);
        newObj.FontColor.Font.Name = "Courier New";
        newObj.FontColor.Font.Size = 9;
        newObj.FontColor.Font.Bold = false;
        newObj.FontColor.Color = 0;  // black
        clientDoc.ReportDefController.ReportObjectController.Modify(oldObj, newObj);
        break;
    }
}

doc.SaveAs("Existing.rpt");
doc.Close();
```

Use the EROM bridge for font changes when you are **also** adding/removing objects in the same operation (avoids loading the report twice). For simple font-only changes, the Engine API `ApplyFont()` is simpler. See `CREATION.md` for the full `FontColor.Font` property reference and RGB color values.

### When to Use Engine API vs. EROM Bridge

| Task | API |
|------|-----|
| Change font, color, text on existing objects | Engine API (simple, fewer DLL references) |
| Change font via `FontColor.Font` with Clone/Modify | EROM bridge (when combining with other RAS operations) |
| Change formula text on existing formulas | Engine API |
| Change section formatting (suppress, page break) | Engine API |
| **Add** new fields, formulas, groups, sections | EROM bridge (RAS SDK required) |
| **Remove** objects from the report | EROM bridge |
| **Move** objects between sections | EROM bridge |
| **Add** new database tables or links | EROM bridge |

### Pitfalls

1. **SaveAs after EROM bridge**: Use `doc.SaveAs(path)` (Engine method), not `clientDoc.SaveAs()` (RAS method). The Engine SaveAs handles the EROM bridge state correctly.
2. **Do not mix Engine and RAS object references**: The `ReportObject` from `doc.ReportDefinition.Sections[].ReportObjects[]` (Engine) is a different type than from `clientDoc.ReportDefController.ReportDefinition...ReportObjects[]` (RAS). Do not pass Engine objects to RAS methods or vice versa.
3. **EROM bridge requires all RAS DLLs**: Even though you are modifying an existing report, the full RAS reference set is needed for the bridge.

---

## Modifying Formula Fields

Access existing formula fields through `DataDefinition.FormulaFields`:

```csharp
foreach (FormulaFieldDefinition formula in doc.DataDefinition.FormulaFields)
{
    Console.WriteLine("Formula: @" + formula.Name + " = " + formula.Text);

    if (formula.Name == "TargetFormula")
    {
        formula.Text = "WhilePrintingRecords; "
                     + "Shared CurrencyVar NewTotal := Sum({Table.AMOUNT});";
    }
}
```

`FormulaFieldDefinition.Text` is read/write — set the full Crystal formula text including evaluation-time keywords and variable declarations. See `FORMULAS.md` for variable scoping and evaluation-time rules.

---

## Modifying Section Formatting

Access section format properties to change suppress, page break, and keep-together behavior:

```csharp
foreach (Section section in doc.ReportDefinition.Sections)
{
    // Suppress a section
    if (section.Name == "GroupFooterSection1")
    {
        section.SectionFormat.EnableSuppress = true;
    }

    // Add page break before Group Header
    if (section.Name == "GroupHeaderSection1")
    {
        section.SectionFormat.EnableNewPageBefore = true;
        section.SectionFormat.EnableKeepTogether = true;
    }
}
```

### Setting a Conditional Suppress Formula

```csharp
var section = doc.ReportDefinition.Sections["DetailSection1"];
section.SectionFormat.SuppressFormula.Text = "{ORDER_HEADER.STATUS} = \"C\"";
```

When the formula evaluates to `True`, the section is hidden. See `FORMATTING.md` for the full list of `SectionFormat` properties.

---

## Modifying Field Formatting

Change number, date, and currency formats on existing field objects:

```csharp
foreach (Area area in doc.ReportDefinition.Areas)
{
    foreach (Section section in area.Sections)
    {
        foreach (ReportObject obj in section.ReportObjects)
        {
            if (obj.Kind == ReportObjectKind.FieldObject && obj.Name == "Field1")
            {
                var field = (FieldObject)obj;

                // Number formatting
                field.FieldFormat.NumericFormat.DecimalPlaces = 2;
                field.FieldFormat.NumericFormat.HasThousandsSeparators = true;

                // Alignment
                field.ObjectFormat.HorizontalAlignment = Alignment.RightAlign;
            }
        }
    }
}
```

### Suppress If Duplicated

```csharp
var field = (FieldObject)obj;
field.ObjectFormat.SuppressIfDuplicated = true;
```

See `FORMATTING.md` for date formatting, currency formatting, and conditional color patterns.

---

## Cross-References to Other Crystal Sub-Files

| Feature | Sub-File |
|---------|----------|
| Formula variable scoping, evaluation times, shared variables | `FORMULAS.md` |
| Section formatting, page setup, special fields, twips reference | `FORMATTING.md` |
| Groups, sorting, group summaries | `GROUPS.md` |
| Parameters, database swapping, export, push data model | `DATASOURCES.md` |
| Creating new reports from scratch (all RAS SDK patterns) | `CREATION.md` |
| Cross-tabs, charts, image import, box objects | `ADVANCED.md` |

---

## Step 3: Verify the Change

Re-dump to XML and compare:

```
.\Release\RptToXml.exe "Report1.rpt" "Report1_after.xml"
```

Check the target element's attributes changed as expected (e.g. `Bold="True"`, `Style="Bold, Underline"`).
