# Crystal Report Advanced Objects

Specialized report objects used occasionally: cross-tabs, charts, rich text, and drawing objects. These features are complex and rarely created programmatically — this file provides reference patterns rather than full templates.

---

## Cross-Tab Objects

Cross-tabs are pivot tables that summarize data in a row/column grid. They are one of the most complex Crystal objects to create programmatically.

### Conceptual Structure

A cross-tab has three components:
- **Row fields**: define the rows (e.g., Customer)
- **Column fields**: define the columns (e.g., Month)
- **Summary fields**: the values in each cell (e.g., Sum of Amount)

### SDK Approach

Cross-tabs require the RAS InProc SDK. The general pattern:

```csharp
// Cross-tab creation uses the ReportObjectController
// with a CrossTabObject and its associated definition
var crossTab = new CrystalDecisions.ReportAppServer.ReportDefModel.CrossTabObject();
// ... configure rows, columns, summaries ...
```

Cross-tab creation via the SDK is fragile and poorly documented. Consider creating a template `.rpt` with the cross-tab structure in the Crystal Reports designer, then using the modification workflow to adjust field mappings and formatting programmatically.

### Alternative: Template Approach

1. Create the cross-tab layout in the Crystal Reports visual designer
2. Save as a template `.rpt`
3. Use the Engine API (`MODIFICATION.md`) to change database connections, record selection, or field formatting
4. This avoids the complexity of building a cross-tab from scratch via the SDK

---

## Charts

Charts display data graphically (bar, line, pie, area, etc.). Like cross-tabs, charts are complex to create programmatically.

### Chart Types Available

| Type | Use Case |
|------|----------|
| Bar | Comparing values across categories |
| Line | Trends over time |
| Pie | Proportions of a whole |
| Area | Cumulative trends |
| Doughnut | Proportions with center space |
| Scatter | Correlation between two values |

### SDK Approach

Charts are added as report objects but require extensive configuration of data mappings, axes, legends, and formatting. The SDK surface for charts is large and version-dependent.

### Recommended Approach

Use the template pattern:
1. Create the chart in the Crystal Reports designer with placeholder data
2. Save as a template `.rpt`
3. Modify the data source, record selection, and chart options programmatically via the Engine API

---

## Rich Text Objects (ParagraphElements)

Standard `TextObject` contains a single string with uniform formatting. For mixed formatting within one text block (e.g., bold + regular in the same line), use `ParagraphElements`.

### Creating Text and Rich Text via RAS SDK

Text objects require the `Paragraphs → ParagraphElements → ParagraphTextElement` structure. Setting `TextObject.Text` directly and calling `Add()` throws null reference errors — always use the paragraph structure instead.

The full working pattern with code examples is documented in `CREATION.md` under "Creating Text Objects". That section covers:

- Single text object with font formatting
- Mixed formatting (bold + regular in the same line) via multiple `ParagraphTextElement` objects
- Multi-line text via multiple `Paragraph` objects

Source: SAP KB 1306531

### Practical Alternative

For dynamic text, use formula fields with string concatenation and place them as regular `FieldObject` instances. For static labels, use the `ParagraphTextElement` pattern from `CREATION.md`.

---

## Box and Line Objects

Lines and boxes provide visual structure (horizontal rules, section borders).

### Line Objects via Engine API (Modification)

```csharp
foreach (ReportObject obj in section.ReportObjects)
{
    if (obj.Kind == ReportObjectKind.LineObject)
    {
        var line = (LineObject)obj;
        line.LineColor = Color.Black;
        line.LineThickness = 20;  // in twips
    }
}
```

### Line Objects via RAS SDK (Creation)

Lines can be created via `ReportObjectController.Add()`:

```csharp
var line = new CrystalDecisions.ReportAppServer.ReportDefModel.LineObject();
line.Left = 0;
line.Top = 0;
line.Right = 10800;    // ~7.5 inches
line.Bottom = 0;       // horizontal line (Top == Bottom)
line.LineThickness = 20;
line.Kind = CrReportObjectKindEnum.crReportObjectKindLine;

var section = reportDef.PageHeaderArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.Add(line, section, -1);
```

### Box Objects via RAS SDK (Creation)

Box objects frame a section or group of objects. They can be created programmatically via the RAS SDK using `BoxObject`.

```csharp
var box = new CrystalDecisions.ReportAppServer.ReportDefModel.BoxObject();
box.Kind = CrReportObjectKindEnum.crReportObjectKindBox;
box.Left = 100;
box.Top = 50;
box.Width = 10800;    // ~7.5 inches — spans printable width
box.Height = 400;
box.LineThickness = 20;
box.LineStyle = CrLineStyleEnum.crLineStyleSingle;
box.EnableExtendToBottomOfSection = false;
box.FillColor = new CrystalDecisions.ReportAppServer.ReportDefModel.FontColor();
box.FillColor.Red = 255;
box.FillColor.Green = 255;
box.FillColor.Blue = 255;

var section = clientDoc.ReportDefController.ReportDefinition.GroupHeaderArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.Add(box, section, -1);
```

### BoxObject Properties

| Property | Type | Purpose |
|----------|------|---------|
| `Left`, `Top`, `Width`, `Height` | int | Position and size (twips) |
| `LineThickness` | int | Border thickness (twips, 20 = 1 point) |
| `LineStyle` | `CrLineStyleEnum` | `crLineStyleSingle`, `crLineStyleDash`, `crLineStyleDot`, `crLineStyleNone` |
| `EnableExtendToBottomOfSection` | bool | Stretch box to fill section height |
| `FillColor` | `FontColor` | Background fill (RGB) |
| `CornerEllipseWidth`, `CornerEllipseHeight` | int | Rounded corners (0 = square) |
| `EnableCloseAtPageBreak` | bool | Close the box border at page breaks |

### Multi-Section Box (Spanning Sections)

A box can span from one section to another using `SectionCode` and `EndSectionName`:

```csharp
box.SectionCode = "GH";     // starts in Group Header
box.EndSectionName = "GF";  // ends in Group Footer
```

This creates a box that visually frames the entire group from header to footer. This is an advanced feature — see SAP KB 1306234 for additional detail on section code values.

---

## Image Import (File-Based Pictures)

To add a picture from a file (not a database blob), use `ReportObjectController.ImportPicture()`. This embeds the image directly into the report at the specified position.

### ImportPicture via RAS SDK

```csharp
var section = clientDoc.ReportDefController.ReportDefinition.ReportHeaderArea.Sections[(object)0];

clientDoc.ReportDefController.ReportObjectController.ImportPicture(
    @"C:\Images\CompanyLogo.png",
    section,
    100,     // left (twips)
    50       // top (twips)
);
```

`ImportPicture(string filePath, Section section, int left, int top)` — the image is placed at the specified position. Width and height default to the image's natural dimensions.

### Repositioning/Resizing After Import

After importing, find the picture object and resize via `Modify()`:

```csharp
var section = clientDoc.ReportDefController.ReportDefinition.ReportHeaderArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.ImportPicture(
    @"C:\Images\CompanyLogo.png", section, 100, 50);

for (int i = 0; i < section.ReportObjects.Count; i++)
{
    var obj = section.ReportObjects[i];
    if (obj.Kind == CrReportObjectKindEnum.crReportObjectKindPicture)
    {
        var newObj = (CrystalDecisions.ReportAppServer.ReportDefModel.ReportObject)obj.Clone(true);
        newObj.Width = 2160;   // 1.5 inches
        newObj.Height = 720;   // 0.5 inches
        newObj.Left = 100;
        newObj.Top = 50;
        clientDoc.ReportDefController.ReportObjectController.Modify(obj, newObj);
        break;
    }
}
```

### Supported Image Formats

Crystal supports BMP, JPEG, PNG, TIFF, and GIF for imported pictures.

### Image Import vs. Blob Field

| Approach | Use Case |
|----------|----------|
| `ImportPicture()` | Static image embedded in report (logos, headers) |
| Blob `FieldObject` | Dynamic image from database column (per-record) |

---

## OLE and Blob Objects

### OLE Objects

OLE (Object Linking and Embedding) objects embed external content (images, documents) in the report. They cannot be created programmatically via the SDK — they must be added in the Crystal Reports designer.

### Blob Fields

Blob (Binary Large Object) fields display images stored in database columns. They are placed as `FieldObject` instances with the blob field as the `DataSourceName`:

```csharp
var blobField = new FieldObject();
blobField.DataSourceName = "{TABLE.IMAGE_BLOB}";
blobField.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeBitmapField;
blobField.Kind = CrReportObjectKindEnum.crReportObjectKindField;
// ... set position ...
```

Blob rendering depends on the Crystal runtime's ability to interpret the binary data as an image format (BMP, JPEG, PNG).

---

## Pitfalls

1. **Cross-tabs and charts are best as templates**: Creating them from scratch via the SDK is fragile and poorly documented. Use the visual designer to create the structure, then modify programmatically.
2. **TextObject.Add() null reference**: Adding `SimpleTextObject` or `TextObject` via `ReportObjectController.Add()` frequently throws null reference errors. Use `AddByName()` or `FieldObject` with formula data sources instead.
3. **Line positioning**: Lines use `Left`/`Top`/`Right`/`Bottom` instead of `Left`/`Top`/`Width`/`Height`. A horizontal line has `Top == Bottom`.
4. **OLE objects are designer-only**: You cannot add OLE objects programmatically. They must exist in the template `.rpt`.
5. **Blob field type**: Use `crFieldValueTypeBitmapField` for image blobs, not `crFieldValueTypeStringField`.
6. **ImportPicture dimensions**: The imported picture initially has its natural pixel dimensions. Always follow up with `Modify()` to set explicit `Width` and `Height` in twips if you need a specific size.
7. **ImportPicture file path**: The file path must be accessible at the time of the SDK call. The image is embedded into the `.rpt` — the file is not needed at report runtime.
8. **BoxObject vs LineObject**: Boxes use `Width`/`Height` for sizing; lines use `Right`/`Bottom` as endpoints. Do not mix the two patterns.
9. **Multi-section boxes**: `SectionCode` / `EndSectionName` for spanning boxes are string identifiers, not section indices. Use the two-letter codes (`GH`, `GF`, `D`, `PH`, `PF`, `RH`, `RF`).
