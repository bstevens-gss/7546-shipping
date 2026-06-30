---
AGENT_TITLE: Crystal Reports Agent
AGENT_DESCRIPTION: Programmatic creation and modification of Crystal Reports .rpt files via C# against the SAP Crystal Reports SDK.
AGENT_USAGE: Load when working with Crystal Reports, .rpt files, or RptToXml.
---

# Crystal Reports Agent
# Programmatic Creation & Modification of .rpt Files

Crystal Report `.rpt` files are proprietary binary — they cannot be edited as text. All changes require C# programs compiled against the SAP Crystal Reports SDK.

---

## SUB-AGENT ROUTING

| When you need... | Read this file |
|------------------|----------------|
| Inspect and modify an **existing** .rpt (change fonts, text, colors, field properties, formulas, formatting, metadata/SummaryInfo) | `agents/crystal/MODIFICATION.md` |
| Create a **new** .rpt from scratch (tables, fields, subreports, summaries, text objects, font formatting, on-demand subreports) | `agents/crystal/CREATION.md` |
| Add **groups**, sorting, group-level summaries, Top N/Bottom N, date-based grouping | `agents/crystal/GROUPS.md` |
| Create **formula fields**, variables (Local/Global/Shared), running totals, or shared variable patterns | `agents/crystal/FORMULAS.md` |
| **Section formatting**, page setup, conditional formatting, field formatting, special fields, RAS section modification | `agents/crystal/FORMATTING.md` |
| **SQL commands**, parameters (multi-value/range), database swapping, table location, export, printing | `agents/crystal/DATASOURCES.md` |
| **Cross-tabs**, charts, rich text objects | `agents/crystal/ADVANCED.md` |

**Decision guide:**
- "Change the heading font on Report X" → MODIFICATION (Engine API)
- "Build a new sales order report" → CREATION + GROUPS (if grouped)
- "Add a subreport to an existing report" → MODIFICATION (EROM bridge) + CREATION (subreport technique)
- "Add a new field/group/formula to an existing report" → MODIFICATION (EROM bridge — loads existing .rpt, then uses RAS SDK to add new objects)
- "Remove a field from an existing report" → MODIFICATION (EROM bridge — Remove/Clone/Move)
- "Move a field from one section to another" → MODIFICATION (EROM bridge — clone → add → remove pattern)
- "Add a second Detail section (Detail a/b)" → CREATION (section management) or MODIFICATION (EROM bridge)
- "Group the report by customer with subtotals" → GROUPS
- "Add a running total that resets per group" → FORMULAS
- "Pass a value from a subreport back to the main report" → FORMULAS (shared variable pattern)
- "Make the total red if negative" → FORMATTING (conditional formatting, ConditionFormulas API, color constants)
- "Add a date range parameter" → DATASOURCES (parameters)
- "Export the report to PDF" → DATASOURCES (export)
- "Use a SQL query instead of tables" → DATASOURCES (command objects)
- "Feed the report data from a DataTable instead of a database" → DATASOURCES (push data model)
- "Suppress empty sections" → FORMATTING (section formatting)
- "Add page numbers" → FORMATTING (special fields)
- "Add a company logo image" → ADVANCED (ImportPicture)
- "Draw a box around a group" → ADVANCED (BoxObject)
- "Allow a memo field to grow" → FORMATTING (CanGrow)
- "Display HTML-formatted text from the database" → FORMATTING (TextInterpretation)
- "Add a Data Matrix barcode to a report" → FORMULAS (barcode formula pattern, Basic syntax, IDAutomation font)
- "Add a 1D barcode (Code 39, Code 128) to a report" → FORMULAS (1D barcode rules, font selection, Code 39 vs Code 128)
- "Use Basic syntax in a formula" → FORMULAS (Crystal Basic Syntax Reference)
- "Print the report directly to a printer" → DATASOURCES (printing — use PrintOutputController for performance)
- "Show the top 10 customers by revenue" → GROUPS (Top N / Bottom N sorting)
- "Group the report by month or quarter" → GROUPS (date-based group conditions, CrGroupConditionEnum)
- "Set the report title or author" → MODIFICATION (SummaryInfo)
- "Allow the user to select multiple values for a parameter" → DATASOURCES (multi-value parameters)
- "Create a date range parameter" → DATASOURCES (range parameters, CrDiscreteOrRangeKindEnum)
- "Add a dropdown list of values to a parameter" → DATASOURCES (discrete value lists)
- "Change which table the report reads from at runtime" → DATASOURCES (Table.Location / SetLocation)
- "Handle Crystal Reports exceptions" → AGENTS.CRYSTAL (error handling patterns)
- "Clean up report resources / prevent memory leaks" → AGENTS.CRYSTAL (Dispose / memory management)
- "Change section height or properties via RAS" → FORMATTING (ReportSectionController.Modify)
- "Add a static text label to a report" → CREATION (Text Objects — ParagraphElements pattern)
- "Set the font on a new field during creation" → CREATION (FontColor.Font pattern)
- "Change fonts on existing objects via EROM bridge" → MODIFICATION (EROM font modification)
- "Make a subreport on-demand (click to load)" → CREATION (on-demand subreports)

---

## Common Build Environment

All Crystal C# programs share these constraints:

| Setting | Value |
|---------|-------|
| Compiler | `C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe` (32-bit Framework) |
| Platform | `/platform:x86` (Crystal runtime is 32-bit only) |
| Target Framework | .NET Framework 4.8.1 |
| Language Level | C# 5 only (no pattern matching, no string interpolation, no null-conditional) |

### Required Runtime Dependency

`log4net.dll` with SAP public key `692fbea5521e1304` must be in the same folder as the compiled exe. It is included in the portable `Release` folder (`agents/crystal/Release/log4net.dll`).

Original source (if re-extraction is ever needed):
```
C:\Windows\assembly\GAC_32\log4net\1.2.10.0__692fbea5521e1304\log4net.dll
```

### App.config

A template `App.config` is included in the Release folder (`agents/crystal/Release/App.config`). When compiling a program, copy it next to the compiled exe and rename it to match the exe name:

```
copy Release\App.config MyProgram.exe.config
```

The file must be named `<YourExe>.exe.config` (e.g., `ModifyReport.exe.config`). Without it, the .NET runtime may not resolve the framework version correctly, causing Crystal COM interop failures.

Template content:
```xml
<?xml version="1.0"?>
<configuration>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.8.1"/>
  </startup>
</configuration>
```

---

## Important Constraints

- `.rpt` files are **binary only** — XML output from RptToXml is **read-only inspection**, not round-trippable
- Crystal runtime is **32-bit** — always compile with `/platform:x86` and use the 32-bit csc.exe at `Framework\v4.0.30319` (not `Framework64`)
- The csc.exe in .NET Framework supports **C# 5 only** — no `is Type variable` patterns, no `$""` interpolation, no `?.` null-conditional
- `log4net.dll` must be the **SAP-signed** version (PublicKeyToken `692fbea5521e1304`), found in legacy GAC
- Crystal DLLs in the `Release` folder are self-contained — reference those, not the GAC versions
- Always `doc.Close()` after `doc.SaveAs()` to release file handles
- Always `doc.Dispose()` in production code to release COM interop resources (see Dispose/Memory Management below)

---

## Error Handling Patterns

Crystal Reports uses COM interop internally. Errors surface as .NET exceptions from the `CrystalDecisions.Shared` namespace.

### Exception Hierarchy

```
System.Exception
  └─ CrystalDecisions.Shared.CrystalReportsException  (base for all Crystal exceptions)
       ├─ LogonException               (database connection / authentication failure)
       ├─ DataSourceException           (missing tables, bad SQL, schema mismatch)
       ├─ ExportException               (export failure — file locked, invalid format)
       ├─ InvalidArgumentException      (bad parameter value, type mismatch)
       ├─ InternalException             (Crystal runtime internal error)
       └─ EngineException               (general report processing error)
```

### Recommended Try/Catch Pattern

```csharp
ReportDocument doc = null;
try
{
    doc = new ReportDocument();
    doc.Load(rptPath);

    // ... set parameters, credentials, process report ...

    doc.ExportToDisk(ExportFormatType.PortableDocFormat, outputPath);
}
catch (CrystalDecisions.Shared.LogonException ex)
{
    Console.WriteLine("Database logon failed: " + ex.Message);
    return 1;
}
catch (CrystalDecisions.Shared.DataSourceException ex)
{
    Console.WriteLine("Data source error (missing table or bad SQL): " + ex.Message);
    return 1;
}
catch (CrystalDecisions.Shared.ExportException ex)
{
    Console.WriteLine("Export failed: " + ex.Message);
    return 1;
}
catch (CrystalDecisions.Shared.InvalidArgumentException ex)
{
    Console.WriteLine("Invalid parameter: " + ex.Message);
    return 1;
}
catch (CrystalDecisions.Shared.CrystalReportsException ex)
{
    Console.WriteLine("Crystal Reports error: " + ex.Message);
    return 1;
}
catch (System.Runtime.InteropServices.COMException ex)
{
    Console.WriteLine("COM interop error: " + ex.Message);
    return 1;
}
finally
{
    if (doc != null)
    {
        doc.Close();
        doc.Dispose();
    }
}
```

### Common Error Scenarios and Solutions

| Exception | Common Cause | Solution |
|-----------|-------------|----------|
| `LogonException` | Wrong DSN, credentials, or DB unreachable | Verify `ConnectionInfo` properties, check ODBC DSN exists |
| `DataSourceException` | Table renamed/removed, SQL syntax error | Check `Table.Name` matches actual DB, verify SQL in command objects |
| `ExportException` | Output file locked, invalid path, missing directory | Close file handles first, verify output directory exists |
| `InvalidArgumentException` | Parameter type mismatch (e.g., string for date param) | Match .NET value type to `CrFieldValueTypeEnum` |
| `COMException` | Crystal runtime not installed, 64-bit process | Compile with `/platform:x86`, verify Crystal runtime is installed |

### Retry Pattern for Transient Failures

```csharp
int maxRetries = 3;
for (int attempt = 1; attempt <= maxRetries; attempt++)
{
    try
    {
        // ... database operation ...
        break;
    }
    catch (CrystalDecisions.Shared.LogonException) when (attempt < maxRetries)
    {
        Console.WriteLine("Logon attempt " + attempt + " failed, retrying...");
        System.Threading.Thread.Sleep(2000 * attempt);
    }
}
```

**Note**: C# 5 does not support exception filters (`when`). For C# 5 compatibility, use a flag variable instead:

```csharp
int maxRetries = 3;
bool success = false;
for (int attempt = 1; attempt <= maxRetries && !success; attempt++)
{
    try
    {
        // ... database operation ...
        success = true;
    }
    catch (CrystalDecisions.Shared.LogonException ex)
    {
        if (attempt >= maxRetries) throw;
        Console.WriteLine("Logon attempt " + attempt + " failed, retrying...");
        System.Threading.Thread.Sleep(2000 * attempt);
    }
}
```

---

## Dispose / Memory Management

`ReportDocument` uses COM interop internally and holds unmanaged resources. Proper cleanup prevents memory leaks and file handle leaks, especially in long-running processes or batch operations.

### Close vs. Dispose

| Method | Purpose |
|--------|---------|
| `doc.Close()` | Releases the report data and database connections. The `ReportDocument` object remains usable (can `Load()` again). |
| `doc.Dispose()` | Releases all COM interop objects and unmanaged resources. The object is no longer usable after `Dispose()`. |

Always call both in production code. Call `Close()` first, then `Dispose()`.

### Using Pattern

`ReportDocument` implements `IDisposable`, so the `using` pattern works:

```csharp
using (var doc = new ReportDocument())
{
    doc.Load(rptPath);
    // ... process, export, print ...
    doc.Close();
}  // Dispose() called automatically
```

### Batch Processing Guidance

When processing many reports in a loop, create and dispose the `ReportDocument` inside the loop to avoid GC pressure:

```csharp
foreach (string rptFile in rptFiles)
{
    using (var doc = new ReportDocument())
    {
        doc.Load(rptFile);
        // ... process ...
        doc.Close();
    }
    // Forces cleanup between iterations
}
```

### GC Pressure Symptoms

If a long-running process creates many reports without proper disposal:
- Memory usage climbs steadily
- `OutOfMemoryException` or `COMException` eventually thrown
- File handles accumulate (visible in Process Explorer)

Mitigation: Always use `using` or `try/finally` with `Close()`/`Dispose()`.

---

## File Locations

The `Release` folder (`agents/crystal/Release/`) is the **portable SDK kit** that travels with the agent. It contains all Crystal DLLs (v13.0.4000.0), log4net.dll, and RptToXml.exe. All `/reference:` paths in compile commands are relative to this folder.

| Item | Path (relative to `agents/crystal/`) |
|------|------|
| RptToXml.exe | `Release\RptToXml.exe` |
| Crystal Engine DLL | `Release\CrystalDecisions.CrystalReports.Engine.dll` |
| Crystal Shared DLL | `Release\CrystalDecisions.Shared.dll` |
| RAS ClientDoc DLL | `Release\CrystalDecisions.ReportAppServer.ClientDoc.dll` |
| RAS Controllers DLL | `Release\CrystalDecisions.ReportAppServer.Controllers.dll` |
| RAS DataDefModel DLL | `Release\CrystalDecisions.ReportAppServer.DataDefModel.dll` |
| RAS ReportDefModel DLL | `Release\CrystalDecisions.ReportAppServer.ReportDefModel.dll` |
| RAS CommonObjectModel DLL | `Release\CrystalDecisions.ReportAppServer.CommonObjectModel.dll` |
| RAS CommLayer DLL | `Release\CrystalDecisions.ReportAppServer.CommLayer.dll` |
| RAS ObjectFactory DLL | `Release\CrystalDecisions.ReportAppServer.ObjectFactory.dll` |
| SAP log4net.dll | `Release\log4net.dll` |
| App.config template | `Release\App.config` (copy to `<YourExe>.exe.config` next to compiled exe) |
| 32-bit csc.exe | `C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe` (system-provided, not in Release) |
