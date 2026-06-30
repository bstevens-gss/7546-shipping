# Crystal Report Data Sources, Parameters & Export

This file covers alternative data sources (SQL commands, stored procedures), parameter fields, database connection swapping, and programmatic export to PDF/Excel/CSV.

---

## Command Objects (Raw SQL as Data Source)

Instead of adding individual tables and letting Crystal build the SQL, you can provide a raw SQL statement as the data source. This is useful for complex queries, unions, or CTEs that Crystal's visual linker cannot express.

### Adding a Command via RAS SDK

```csharp
var connInfo = CreateConnectionInfo();

var command = new CrystalDecisions.ReportAppServer.DataDefModel.CommandTable();
command.CommandText = "SELECT OH.ORDER_NUMBER, OH.CUSTOMER, OH.ORDER_DATE, "
                    + "OL.PART_NUMBER, OL.QUANTITY, OL.AMOUNT "
                    + "FROM ORDER_HEADER OH "
                    + "INNER JOIN ORDER_LINES OL "
                    + "ON OH.ORDER_NUMBER = OL.ORDER_NUMBER "
                    + "WHERE OH.RECORD_TYPE = 'A' AND OL.RECORD_TYPE = 'L'";
command.Name = "Command";
command.Alias = "Command";
command.ConnectionInfo = connInfo;

clientDoc.DatabaseController.AddTable(command, null);
```

`CommandTable` extends `Table` — use `AddTable()` with the same method as a regular table. Crystal executes the SQL and treats the result set as a single table named `"Command"`.

### Referencing Command Fields

After adding the command, fields are referenced as `{Command.COLUMN_NAME}`:

```csharp
objCtrl.AddByName("{Command.ORDER_NUMBER}", "Order #");
objCtrl.AddByName("{Command.CUSTOMER}", "Customer");
objCtrl.AddByName("{Command.AMOUNT}", "Amount");
```

### Command with Parameters

Embed parameter placeholders in the SQL using `{?ParamName}` syntax:

```csharp
command.CommandText = "SELECT * FROM ORDER_HEADER "
                    + "WHERE CUSTOMER = '{?CustomerCode}'";
```

Then create a matching parameter field (see Parameters section below) so Crystal prompts for or receives the value.

---

## Stored Procedures

Stored procedures can be added similarly to command tables. Set the command text to the procedure call:

```csharp
var command = new CommandTable();
command.CommandText = "CALL GetOrdersByCustomer('{?CustomerCode}')";
command.Name = "Command";
command.Alias = "Command";
command.ConnectionInfo = connInfo;

clientDoc.DatabaseController.AddTable(command, null);
```

For Zen/Pervasive databases, stored procedure support depends on the ODBC driver version. If the procedure returns a result set, Crystal treats it like a regular command table.

---

## Parameters

Parameter fields prompt users for input at runtime (e.g., date range, customer code). They are also used in record selection formulas and command objects.

### Creating a Parameter Field (RAS SDK)

```csharp
var param = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterField();
param.Name = "StartDate";
param.Type = CrFieldValueTypeEnum.crFieldValueTypeDateField;
param.CurrentValues = new ParameterFieldCurrentValues();
param.DefaultValues = new ParameterFieldDefaultValues();
param.PromptText = "Enter start date:";
param.ReportName = "";
param.ParameterType = CrParameterTypeEnum.crParameterTypeQueryParameter;

clientDoc.DataDefController.ParameterFieldController.Add(param);
```

### Parameter Types

| `CrParameterTypeEnum` | Purpose |
|-----------------------|---------|
| `crParameterTypeReportParameter` | Used in record selection formulas |
| `crParameterTypeQueryParameter` | Passed into SQL command text |

### Using Parameters in Record Selection

Reference parameters in record selection formulas with `{?ParamName}`:

```csharp
clientDoc.DataDefController.RecordFilterController.SetFormulaText(
    "{ORDER_HEADER.ORDER_DATE} >= {?StartDate} "
    + "AND {ORDER_HEADER.ORDER_DATE} <= {?EndDate}");
```

### Setting Parameter Values at Runtime (Engine API)

When running/exporting a report, set parameter values before processing:

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

doc.SetParameterValue("StartDate", new DateTime(2025, 1, 1));
doc.SetParameterValue("EndDate", new DateTime(2025, 12, 31));
doc.SetParameterValue("CustomerCode", "ACME");
```

`SetParameterValue(string name, object value)` uses the parameter name (without `{?}` prefix) and a .NET value matching the parameter type.

### Common Parameter Patterns

**Date range:**
```csharp
// Create two date parameters
var startParam = new ParameterField();
startParam.Name = "StartDate";
startParam.Type = CrFieldValueTypeEnum.crFieldValueTypeDateField;
startParam.PromptText = "Enter start date:";
startParam.ParameterType = CrParameterTypeEnum.crParameterTypeReportParameter;
clientDoc.DataDefController.ParameterFieldController.Add(startParam);

var endParam = new ParameterField();
endParam.Name = "EndDate";
endParam.Type = CrFieldValueTypeEnum.crFieldValueTypeDateField;
endParam.PromptText = "Enter end date:";
endParam.ParameterType = CrParameterTypeEnum.crParameterTypeReportParameter;
clientDoc.DataDefController.ParameterFieldController.Add(endParam);

// Use in record selection
clientDoc.DataDefController.RecordFilterController.SetFormulaText(
    "{ORDER_HEADER.ORDER_DATE} >= {?StartDate} "
    + "AND {ORDER_HEADER.ORDER_DATE} <= {?EndDate}");
```

**String filter:**
```csharp
var custParam = new ParameterField();
custParam.Name = "CustomerCode";
custParam.Type = CrFieldValueTypeEnum.crFieldValueTypeStringField;
custParam.PromptText = "Enter customer code:";
custParam.ParameterType = CrParameterTypeEnum.crParameterTypeReportParameter;
clientDoc.DataDefController.ParameterFieldController.Add(custParam);

clientDoc.DataDefController.RecordFilterController.SetFormulaText(
    "{ORDER_HEADER.CUSTOMER} = {?CustomerCode}");
```

### Multi-Value Parameters

Allow the user to select multiple values for a single parameter (e.g., multiple customer codes):

**Creating a multi-value parameter (RAS SDK):**
```csharp
var param = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterField();
param.Name = "CustomerCodes";
param.Type = CrFieldValueTypeEnum.crFieldValueTypeStringField;
param.PromptText = "Select customer code(s):";
param.ParameterType = CrParameterTypeEnum.crParameterTypeReportParameter;
param.AllowMultipleValue = true;

clientDoc.DataDefController.ParameterFieldController.Add(param);
```

**Setting multi-value parameters at runtime (Engine API):**
```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

var values = new CrystalDecisions.Shared.ParameterValues();
values.Add(new ParameterDiscreteValue { Value = "ACME" });
values.Add(new ParameterDiscreteValue { Value = "GLOBEX" });
values.Add(new ParameterDiscreteValue { Value = "INITECH" });

doc.DataDefinition.ParameterFields["CustomerCodes"].ApplyCurrentValues(values);
```

**Using multi-value parameters in record selection:**

Crystal handles multi-value params automatically in formulas — the `=` operator tests membership when the parameter is multi-value:

```
{ORDER_HEADER.CUSTOMER} = {?CustomerCodes}
```

This is equivalent to `IN (value1, value2, ...)` in SQL.

### Range Parameters

A range parameter captures a start and end value as a single parameter (e.g., a date range):

**Creating a range parameter (RAS SDK):**
```csharp
var param = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterField();
param.Name = "DateRange";
param.Type = CrFieldValueTypeEnum.crFieldValueTypeDateField;
param.PromptText = "Enter date range:";
param.ParameterType = CrParameterTypeEnum.crParameterTypeReportParameter;
param.DiscreteOrRangeKind = CrDiscreteOrRangeKindEnum.crDiscreteOrRangeKindRangeValue;

clientDoc.DataDefController.ParameterFieldController.Add(param);
```

**Setting range parameters at runtime (Engine API):**
```csharp
var rangeValue = new ParameterRangeValue();
rangeValue.StartValue = new DateTime(2025, 1, 1);
rangeValue.EndValue = new DateTime(2025, 12, 31);
rangeValue.LowerBoundType = RangeBoundType.BoundInclusive;
rangeValue.UpperBoundType = RangeBoundType.BoundInclusive;

var values = new ParameterValues();
values.Add(rangeValue);
doc.DataDefinition.ParameterFields["DateRange"].ApplyCurrentValues(values);
```

### Discrete Value Lists (Predefined Dropdown)

Supply a list of valid values that appear as a dropdown in the parameter prompt:

```csharp
var param = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterField();
param.Name = "Status";
param.Type = CrFieldValueTypeEnum.crFieldValueTypeStringField;
param.PromptText = "Select status:";
param.ParameterType = CrParameterTypeEnum.crParameterTypeReportParameter;

// Add predefined default values
var val1 = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterFieldDiscreteValue();
val1.Value = "Open";
val1.Description = "Open Orders";
param.DefaultValues.Add(val1);

var val2 = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterFieldDiscreteValue();
val2.Value = "Closed";
val2.Description = "Closed Orders";
param.DefaultValues.Add(val2);

var val3 = new CrystalDecisions.ReportAppServer.DataDefModel.ParameterFieldDiscreteValue();
val3.Value = "Cancelled";
val3.Description = "Cancelled Orders";
param.DefaultValues.Add(val3);

clientDoc.DataDefController.ParameterFieldController.Add(param);
```

### CrDiscreteOrRangeKindEnum

| Value | Purpose |
|-------|---------|
| `crDiscreteOrRangeKindDiscreteValue` | Single discrete value (default) |
| `crDiscreteOrRangeKindRangeValue` | Range with start/end |
| `crDiscreteOrRangeKindDiscreteAndRangeValue` | Allows both discrete and range |

---

## Push Data Model (SetDataSource with DataSet/DataTable)

Instead of having the report connect directly to a database (pull model), you can supply data from an in-memory `DataSet` or `DataTable` (push model). This is useful for reports driven by application-computed data, API responses, custom aggregations, or when the data source is not a traditional database.

### Pull vs. Push Comparison

| Aspect | Pull Model | Push Model |
|--------|-----------|------------|
| Connection | Report connects to DB directly via ODBC/OLE DB | Application provides data in memory |
| Schema | Crystal discovers schema from DB at design time | Application provides schema via XSD or DataTable structure |
| Credentials | Crystal needs DB credentials | Not needed — data already fetched |
| Flexibility | SQL runs at report time | Any data source (API, file, computed, etc.) |
| Performance | DB queried each time report runs | Data can be cached or pre-computed |
| Subreports | Each subreport can connect independently | Each subreport needs its own DataTable |
| Design | Design against live DB or field definitions | Design against XSD or field definitions, then push at runtime |

### Providing Data via DataSet

```csharp
using System.Data;
using CrystalDecisions.CrystalReports.Engine;

var doc = new ReportDocument();
doc.Load("PushReport.rpt");

var ds = new DataSet();
var dt = ds.Tables.Add("OrderData");
dt.Columns.Add("ORDER_NUMBER", typeof(string));
dt.Columns.Add("CUSTOMER", typeof(string));
dt.Columns.Add("AMOUNT", typeof(decimal));
dt.Columns.Add("ORDER_DATE", typeof(DateTime));

dt.Rows.Add("1001", "ACME Corp", 1500.00m, new DateTime(2025, 6, 1));
dt.Rows.Add("1002", "Widget Inc", 2750.50m, new DateTime(2025, 6, 15));

doc.SetDataSource(ds);
doc.ExportToDisk(ExportFormatType.PortableDocFormat, @"C:\Output\PushReport.pdf");
doc.Close();
```

### Providing Data via DataTable

```csharp
doc.SetDataSource(dataTable);
```

When using a single `DataTable`, Crystal maps it to the first (or only) table in the report definition. If the report has multiple tables, use a `DataSet` with matching table names.

### Creating the Report for Push Model

A push-model report is designed against field definitions (not a live database). Two approaches:

**Approach 1: XSD Schema**
1. Create an `.xsd` schema file defining the table and column structure
2. In the Crystal Reports designer, add the XSD as a data source
3. Design the report against the XSD fields
4. At runtime, populate a `DataSet`/`DataTable` with columns matching the XSD and call `SetDataSource()`

**Approach 2: Programmatic (RAS SDK)**
1. Create a new report via the RAS SDK (see `CREATION.md`)
2. Add tables with the field definitions you will push
3. At runtime, load the report, create a matching `DataTable`, and call `SetDataSource()`

### Pushing Data to Subreports

Each subreport needs its own `SetDataSource()` call:

```csharp
doc.SetDataSource(mainDataTable);

foreach (ReportDocument subDoc in doc.Subreports)
{
    if (subDoc.Name == "InvoiceDetail")
    {
        subDoc.SetDataSource(detailDataTable);
    }
}
```

### Column Name Matching

The `DataTable` column names must match the field names in the report. Crystal matches by name (case-insensitive). If the report expects `{OrderData.ORDER_NUMBER}`, the DataTable needs a column named `ORDER_NUMBER` in a table named (or aliased as) `OrderData`.

### Pitfalls (Push Model)

1. **Table name must match**: If the report was designed against a table named `OrderData`, the `DataSet` must contain a `DataTable` with the same name. Use `ds.Tables.Add("OrderData")` or `dt.TableName = "OrderData"`.
2. **Column types must match**: A report field defined as `NumberField` expects a numeric column (`int`, `decimal`, `double`). Type mismatches cause runtime errors.
3. **SetDataSource before export**: Call `SetDataSource()` before `ExportToDisk()` or any print/preview method. Crystal buffers the data at the time of the call.
4. **No record selection formula needed**: With push model, data is already filtered by the application. Record selection formulas still work but operate on the pushed data, not on a database.
5. **Subreport data must be pushed separately**: `doc.SetDataSource()` only sets data for the main report. Access each subreport via `doc.Subreports` and push data individually.

---

## Database Swapping (Changing Connection at Runtime)

Database swapping changes the data source connection on an existing report. This is used to point a report from one DSN to another (e.g., test to production).

### Via Engine API

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

var connInfo = new CrystalDecisions.Shared.ConnectionInfo();
connInfo.ServerName = "NEW_DSN";
connInfo.UserID = "Master";
connInfo.Password = "master";

foreach (CrystalDecisions.CrystalReports.Engine.Table table in doc.Database.Tables)
{
    var logonInfo = table.LogOnInfo;
    logonInfo.ConnectionInfo = connInfo;
    table.ApplyLogOnInfo(logonInfo);
}

doc.SaveAs(outputPath);
doc.Close();
```

### Swapping Subreport Connections

Subreports have their own database connections that must be swapped separately:

```csharp
foreach (ReportDocument subDoc in doc.Subreports)
{
    foreach (CrystalDecisions.CrystalReports.Engine.Table table in subDoc.Database.Tables)
    {
        var logonInfo = table.LogOnInfo;
        logonInfo.ConnectionInfo = connInfo;
        table.ApplyLogOnInfo(logonInfo);
    }
}
```

---

## Export (PDF, Excel, CSV)

Programmatic export converts a report to a file format without opening a viewer.

### Export via Engine API

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

// Set parameter values if the report has parameters
doc.SetParameterValue("StartDate", new DateTime(2025, 1, 1));
doc.SetParameterValue("EndDate", new DateTime(2025, 12, 31));

// Set database credentials
foreach (CrystalDecisions.CrystalReports.Engine.Table table in doc.Database.Tables)
{
    var logonInfo = table.LogOnInfo;
    logonInfo.ConnectionInfo.UserID = "Master";
    logonInfo.ConnectionInfo.Password = "master";
    table.ApplyLogOnInfo(logonInfo);
}

// Export
doc.ExportToDisk(ExportFormatType.PortableDocFormat, @"C:\Output\Report.pdf");
doc.Close();
```

### Export Format Enum

| `ExportFormatType` | Output |
|-------------------|--------|
| `PortableDocFormat` | PDF |
| `Excel` | XLS (legacy) |
| `ExcelRecord` | XLS (data-only, one row per record) |
| `ExcelWorkbook` | XLSX |
| `WordForWindows` | DOC |
| `RichText` | RTF |
| `CharacterSeparatedValues` | CSV |
| `HTML32` | HTML 3.2 |
| `HTML40` | HTML 4.0 |
| `XML` | XML |
| `Text` | Plain text |

### Export with Options

For more control, use `ExportOptions`:

```csharp
var exportOpts = new ExportOptions();
exportOpts.ExportFormatType = ExportFormatType.ExcelWorkbook;

var xlsOpts = new ExcelFormatOptions();
xlsOpts.ExcelUseConstantColumnWidth = false;

exportOpts.ExportFormatOptions = xlsOpts;

var diskOpts = new DiskFileDestinationOptions();
diskOpts.DiskFileName = @"C:\Output\Report.xlsx";

exportOpts.ExportDestinationOptions = diskOpts;
exportOpts.ExportDestinationType = ExportDestinationType.DiskFile;

doc.Export(exportOpts);
```

### Required Namespaces for Export

```csharp
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
```

Export uses the Engine API only — it does not require the RAS InProc SDK DLLs. The compile command only needs:

```
/reference:"Release\CrystalDecisions.CrystalReports.Engine.dll"
/reference:"Release\CrystalDecisions.Shared.dll"
```

---

## Printing (Direct to Printer)

Crystal Reports can print directly to a physical or network printer without exporting to a file first.

### PrintToPrinter (Engine API)

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

doc.SetParameterValue("StartDate", new DateTime(2025, 1, 1));
// ... set all params and credentials ...

doc.PrintOptions.PrinterName = @"\\SERVER\PrinterName";
doc.PrintOptions.PaperSize = PaperSize.PaperLetter;
doc.PrintOptions.PaperOrientation = PaperOrientation.Portrait;

doc.PrintToPrinter(
    nCopies: 1,
    collated: true,
    startPageN: 0,  // 0 = all pages
    endPageN: 0     // 0 = all pages
);

doc.Close();
```

### PrintOutputController (RAS API — Recommended)

SAP recommends `PrintOutputController` over `PrintToPrinter` for significantly better performance (5-10x faster in Crystal Reports 13+ basic runtime). `PrintToPrinter` has a known slowness issue in the basic runtime.

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

// ... set all params and credentials ...

ISCDReportClientDocument clientDoc = doc.ReportClientDocument;

var printOpts = new CrystalDecisions.ReportAppServer.Controllers.PrintReportOptions();
printOpts.PrinterName = @"\\SERVER\PrinterName";
printOpts.NumberOfCopies = 1;
printOpts.Collated = true;
printOpts.StartPageNumber = 0;  // 0 = all pages
printOpts.EndPageNumber = 0;

clientDoc.PrintOutputController.PrintReport(printOpts);

doc.Close();
```

### PrintReportOptions Properties

| Property | Type | Purpose |
|----------|------|---------|
| `PrinterName` | string | Full printer name or UNC path |
| `NumberOfCopies` | int | Number of copies to print |
| `Collated` | bool | Collate copies |
| `StartPageNumber` | int | First page to print (0 = all) |
| `EndPageNumber` | int | Last page to print (0 = all) |

### When to Use Each

| Scenario | Method |
|----------|--------|
| Simple print, no RAS SDK loaded | `PrintToPrinter()` (Engine API) |
| Performance-critical printing | `PrintOutputController.PrintReport()` (RAS) |
| Already using EROM bridge | `PrintOutputController.PrintReport()` (RAS) |
| Print preview needed | Export to PDF and open in viewer instead |

---

## Table Location Changes (SetLocation)

Different from database swapping (which changes the DSN/connection). `Table.Location` changes which **table within the same database** a report reads from. Useful for dynamic table names (e.g., archive vs. current tables) or table name remapping across environments.

### Changing Table Location

```csharp
var doc = new ReportDocument();
doc.Load(rptPath);

foreach (CrystalDecisions.CrystalReports.Engine.Table t in doc.Database.Tables)
{
    if (t.Name == "ORDER_HEADER")
    {
        t.Location = "ORDER_HEADER_ARCHIVE";
    }
}

// Subreport tables need separate handling
foreach (ReportDocument subDoc in doc.Subreports)
{
    foreach (CrystalDecisions.CrystalReports.Engine.Table t in subDoc.Database.Tables)
    {
        if (t.Name == "ORDER_HEADER")
        {
            t.Location = "ORDER_HEADER_ARCHIVE";
        }
    }
}

doc.SaveAs(outputPath);
doc.Close();
```

### SetLocation vs Database Swapping

| Feature | `Table.Location` | Database Swapping (`ApplyLogOnInfo`) |
|---------|-------------------|--------------------------------------|
| Changes | Table/view name within same DB | DSN, credentials, database server |
| Use case | Archive tables, renamed tables | Dev → prod, different environments |
| Scope | Per table | Per table (but usually same for all) |
| Credentials | Unchanged | New credentials applied |

### Location Format

`Table.Location` accepts:

- Simple table name: `"ORDER_HEADER_ARCHIVE"`
- Schema-qualified name: `"dbo.ORDER_HEADER_ARCHIVE"`
- Fully qualified: `"DATABASE.dbo.ORDER_HEADER_ARCHIVE"`

The format must match how the database engine expects table references.

---

## Controller Access Patterns

| Need | Access Path |
|------|-------------|
| Add command table | `clientDoc.DatabaseController.AddTable(commandTable, null)` |
| Add parameter | `clientDoc.DataDefController.ParameterFieldController.Add(param)` |
| Set parameter value | `doc.SetParameterValue("Name", value)` (Engine API) |
| Record selection with params | `clientDoc.DataDefController.RecordFilterController.SetFormulaText("{TABLE.FIELD} >= {?Param}")` |
| Database swap | `table.ApplyLogOnInfo(logonInfo)` per table (Engine API) |
| Export to disk | `doc.ExportToDisk(ExportFormatType, path)` (Engine API) |
| Export with options | `doc.Export(exportOptions)` (Engine API) |
| Print (Engine) | `doc.PrintToPrinter(copies, collated, start, end)` (Engine API) |
| Print (RAS, faster) | `clientDoc.PrintOutputController.PrintReport(printOpts)` (RAS) |
| Change table name | `table.Location = "NEW_TABLE_NAME"` (Engine API) |
| Push data (DataSet) | `doc.SetDataSource(dataSet)` (Engine API) |
| Push data (DataTable) | `doc.SetDataSource(dataTable)` (Engine API) |
| Push to subreport | `doc.Subreports["SubName"].SetDataSource(dataTable)` (Engine API) |

---

## Pitfalls

1. **CommandTable vs Table**: `CommandTable` inherits from `Table`. Use `AddTable()` for both — do not look for an `AddCommand()` method.
2. **Command field references**: Fields from a command are referenced as `{Command.COLUMN_NAME}`, not `{TABLE.COLUMN_NAME}`. The alias defaults to `"Command"`.
3. **Parameter name matching**: `SetParameterValue("Name", value)` uses the bare name without `{?}`. The record selection formula uses `{?Name}` with the braces and question mark.
4. **Export requires credentials**: Before exporting, you must apply database logon info to all tables. Without credentials, export fails with a logon error.
5. **Export requires parameter values**: If the report has parameters, set all values before exporting. Unset parameters cause a prompt dialog (or failure in a headless environment).
6. **Subreport connections are separate**: Database swapping the main report does not affect subreports. You must iterate `doc.Subreports` and swap each one individually.
7. **ExportToDisk overwrites**: The method overwrites the target file without warning. Ensure the output path is correct.
8. **ExcelWorkbook vs Excel**: `ExcelWorkbook` produces modern `.xlsx` format. `Excel` produces legacy `.xls`. Use `ExcelWorkbook` for new exports.
9. **CSV export has no column headers by default**: The `CharacterSeparatedValues` format exports data only. Column headers come from the report's PageHeader, which may not map cleanly to CSV columns.
10. **PrintToPrinter slowness in CR 13+ basic runtime**: Use `PrintOutputController.PrintReport()` instead for production printing. The Engine API `PrintToPrinter` has a known performance issue in Crystal Reports 13 and later basic runtime.
11. **Table.Location must match the DB engine format**: If the database expects `dbo.TABLE_NAME` but you set `Location = "TABLE_NAME"`, the query may fail or target the wrong table.
12. **Multi-value param and record selection**: When using a multi-value parameter in a record selection formula, the `=` operator automatically tests membership. Do not manually construct `IN` logic in the formula.
13. **Range parameter requires both bounds**: If you create a `crDiscreteOrRangeKindRangeValue` parameter but only set `StartValue`, the report may fail or include unexpected data. Always set both `StartValue` and `EndValue`.
14. **ApplyCurrentValues vs SetParameterValue**: `SetParameterValue()` works for simple discrete values. For multi-value or range parameters, use `ParameterFields["Name"].ApplyCurrentValues(parameterValues)` instead.
