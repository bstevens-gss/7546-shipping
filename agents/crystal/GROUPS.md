# Crystal Report Groups & Sorting

Groups organize detail records into logical sections (e.g., orders grouped by customer, line items grouped by work order). Nearly every report beyond a flat listing uses groups.

---

## Creating a Group (RAS SDK)

Groups are created via `DataDefController.GroupController`. The SDK automatically creates GroupHeader and GroupFooter areas when a group is added.

### Step 1: Find the Database Field to Group On

```csharp
int tableIdx = clientDoc.DatabaseController.Database.Tables.FindByAlias("ORDER_HEADER");
var table = (CrystalDecisions.ReportAppServer.DataDefModel.Table)
    clientDoc.DatabaseController.Database.Tables[tableIdx];

var field = (CrystalDecisions.ReportAppServer.DataDefModel.Field)
    table.DataFields.FindField(
        "{ORDER_HEADER.CUSTOMER}",
        CrFieldDisplayNameTypeEnum.crFieldDisplayNameFormula,
        CeLocale.ceLocaleUserDefault);
```

`FindField` uses the Crystal formula-style name `{TABLE.FIELD}` with `crFieldDisplayNameFormula`. The locale parameter should be `ceLocaleUserDefault`.

### Step 2: Create and Add the Group

```csharp
var group = new CrystalDecisions.ReportAppServer.DataDefModel.Group();
group.ConditionField = field;

clientDoc.DataDefController.GroupController.Add(-1, group);
```

`GroupController.Add(int index, Group group)` — index `-1` appends. Index `0` inserts as the outermost group.

### Multiple Groups

Groups are nested by order of addition. The first group added is the outermost (Group 1), the second is nested inside it (Group 2), etc.

```csharp
// Group 1 (outermost): by Customer
clientDoc.DataDefController.GroupController.Add(-1, customerGroup);

// Group 2 (nested): by Order Number within Customer
clientDoc.DataDefController.GroupController.Add(-1, orderGroup);
```

---

## Sorting

Sorting controls the order of records within and across groups. Use `DataDefController.SortController`.

### Adding a Sort Field

```csharp
var sortField = (CrystalDecisions.ReportAppServer.DataDefModel.Field)
    table.DataFields.FindField(
        "{ORDER_HEADER.ORDER_DATE}",
        CrFieldDisplayNameTypeEnum.crFieldDisplayNameFormula,
        CeLocale.ceLocaleUserDefault);

var sort = new CrystalDecisions.ReportAppServer.DataDefModel.Sort();
sort.SortField = sortField;
sort.Direction = CrSortDirectionEnum.crSortDirectionAscendingOrder;

clientDoc.DataDefController.SortController.Add(-1, sort);
```

### Sort Direction Enum

| Value | Meaning |
|-------|---------|
| `crSortDirectionAscendingOrder` | A-Z, 0-9, earliest-latest |
| `crSortDirectionDescendingOrder` | Z-A, 9-0, latest-earliest |

### Sort vs. Group Order

When a report has groups, Crystal automatically sorts by the group field. Additional sorts via `SortController` control the order of records **within** the innermost group. You do not need to add a separate sort for the group field itself.

---

## Group-Level Summaries

Summary fields can be scoped to a group (subtotals) instead of the entire report (grand totals). The pattern extends what `CREATION.md` documents for grand totals.

### Creating a Group Summary

```csharp
// Find the field to summarize
int tblIdx = clientDoc.DatabaseController.Database.Tables.FindByAlias("ORDER_LINES");
var tbl = (CrystalDecisions.ReportAppServer.DataDefModel.Table)
    clientDoc.DatabaseController.Database.Tables[tblIdx];
ISCRField amountField = null;
for (int i = 0; i < tbl.DataFields.Count; i++)
{
    if (tbl.DataFields[i].Name == "AMOUNT")
    {
        amountField = tbl.DataFields[i];
        break;
    }
}

// Create the summary scoped to the group
var sumField = new SummaryField();
sumField.Operation = CrSummaryOperationEnum.crSummaryOperationSum;
sumField.SummarizedField = amountField;
sumField.Group = group;  // the Group object from GroupController.Add

clientDoc.DataDefController.SummaryFieldController.Add(-1, sumField);
```

The key difference from a grand total: setting `sumField.Group` to the `Group` object ties the summary to that group level.

### Placing the Group Summary on the Report

Group summaries belong in the GroupFooter section:

```csharp
var reportDef = clientDoc.ReportDefController.ReportDefinition;

// GroupFooterArea index matches group index (0-based)
var groupFooter = reportDef.GroupFooterArea.Sections[(object)0];

var fieldObj = new FieldObject();
fieldObj.DataSourceName = sumField.FormulaForm;
fieldObj.FieldValueType = sumField.Type;
fieldObj.Left = 6200;
fieldObj.Top = 50;
fieldObj.Width = 1500;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;

clientDoc.ReportDefController.ReportObjectController.Add(fieldObj, groupFooter, -1);
```

### Grand Total vs. Group Summary Comparison

| Aspect | Grand Total | Group Summary |
|--------|-------------|---------------|
| `sumField.Group` | Not set (null) | Set to the Group object |
| Placed in | ReportFooter | GroupFooter |
| Scope | All records | Records within the group |

---

## Accessing Group Sections

When a group is added, the SDK creates corresponding GroupHeader and GroupFooter areas in the report definition.

```csharp
var reportDef = clientDoc.ReportDefController.ReportDefinition;

// Group 1 header (index 0)
var gh1 = reportDef.GroupHeaderArea.Sections[(object)0];

// Group 1 footer (index 0)
var gf1 = reportDef.GroupFooterArea.Sections[(object)0];

// Group 2 header (index 1), if a second group exists
var gh2 = reportDef.GroupHeaderArea.Sections[(object)1];
```

Section indexes are **0-based** and match the group addition order. Remember the `(object)` cast on the indexer — `Sections[(object)0]` not `Sections[0]`.

### Placing a Group Name in the Group Header

To display the group field value in the GroupHeader:

```csharp
var groupNameField = new FieldObject();
groupNameField.DataSourceName = "{ORDER_HEADER.CUSTOMER}";
groupNameField.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeStringField;
groupNameField.Left = 100;
groupNameField.Top = 50;
groupNameField.Width = 3000;
groupNameField.Height = 250;
groupNameField.Kind = CrReportObjectKindEnum.crReportObjectKindField;

clientDoc.ReportDefController.ReportObjectController.Add(groupNameField, gh1, -1);
```

---

## Top N / Bottom N Group Sorting

Top N sorting limits the displayed groups to the N highest (or lowest) values of a summary field. Requires a group summary to already exist.

### Creating a Top N Sort

```csharp
// Assumes: group and groupSum (SummaryField) already added
var topN = new CrystalDecisions.ReportAppServer.DataDefModel.TopNSort();
topN.SortField = groupSum;
topN.Direction = CrSortDirectionEnum.crSortDirectionTopNOrder;
topN.NIndividualGroups = 10;
topN.DiscardOthers = false;
topN.NotInTopBottomName = "Others";

clientDoc.DataDefController.SortController.Add(-1, topN);
```

When `DiscardOthers = false`, records not in the top N are aggregated into a single "Others" group with the name specified in `NotInTopBottomName`. Set `DiscardOthers = true` to hide them entirely.

### Top N Direction Enum Values

| Value | Purpose |
|-------|---------|
| `crSortDirectionTopNOrder` | Top N by value (largest first) |
| `crSortDirectionBottomNOrder` | Bottom N by value (smallest first) |
| `crSortDirectionTopNPercentage` | Top N% by value |
| `crSortDirectionBottomNPercentage` | Bottom N% by value |

### TopNSort Properties

| Property | Type | Purpose |
|----------|------|---------|
| `SortField` | ISCRField | The summary field to sort by (must be a group summary) |
| `Direction` | CrSortDirectionEnum | Sort direction (Top N, Bottom N, or percentage variants) |
| `NIndividualGroups` | int | Number of groups to display (or percentage if using percentage direction) |
| `DiscardOthers` | bool | `true` = hide non-qualifying groups; `false` = aggregate into "Others" |
| `NotInTopBottomName` | string | Display name for the "Others" group (only when `DiscardOthers = false`) |

### Example: Top 5 Customers by Revenue

```csharp
// 1. Create customer group
var group = new Group();
group.ConditionField = customerField;
clientDoc.DataDefController.GroupController.Add(-1, group);

// 2. Create group summary (sum of amount per customer)
var groupSum = new SummaryField();
groupSum.Operation = CrSummaryOperationEnum.crSummaryOperationSum;
groupSum.SummarizedField = amountField;
groupSum.Group = group;
clientDoc.DataDefController.SummaryFieldController.Add(-1, groupSum);

// 3. Add Top N sort referencing the summary
var topN = new TopNSort();
topN.SortField = groupSum;
topN.Direction = CrSortDirectionEnum.crSortDirectionTopNOrder;
topN.NIndividualGroups = 5;
topN.DiscardOthers = false;
topN.NotInTopBottomName = "All Others";
clientDoc.DataDefController.SortController.Add(-1, topN);
```

---

## Date-Based Group Conditions

By default, grouping on a date field creates one group per unique date. For meaningful date-based reports (sales by month, orders by quarter), use `Group.Options` with `CrGroupConditionEnum`.

### Setting the Group Condition

```csharp
var group = new CrystalDecisions.ReportAppServer.DataDefModel.Group();
group.ConditionField = dateField;  // a DateTime field
group.Options = new CrystalDecisions.ReportAppServer.DataDefModel.GroupOptions();
group.Options.Condition = CrGroupConditionEnum.crGCMonthly;

clientDoc.DataDefController.GroupController.Add(-1, group);
```

### CrGroupConditionEnum Values (Date)

| Value | Groups by |
|-------|-----------|
| `crGCAnnually` | Year |
| `crGCSemiAnnually` | Half-year |
| `crGCQuarterly` | Quarter |
| `crGCMonthly` | Month |
| `crGCBiWeekly` | Two-week period |
| `crGCWeekly` | Week |
| `crGCDaily` | Day (default for date fields) |

### CrGroupConditionEnum Values (Non-Date)

These conditions apply to string fields:

| Value | Groups by |
|-------|-----------|
| `crGCAnyValue` | Each unique value (default) |
| `crGCFirstLetter` | First letter of the value |
| `crGCFirstTwoLetters` | First two letters |

### Example: Monthly Sales Report

```csharp
// Group by ORDER_DATE monthly
var monthGroup = new Group();
monthGroup.ConditionField = orderDateField;
monthGroup.Options = new GroupOptions();
monthGroup.Options.Condition = CrGroupConditionEnum.crGCMonthly;
clientDoc.DataDefController.GroupController.Add(-1, monthGroup);

// Sum of AMOUNT per month
var monthlySum = new SummaryField();
monthlySum.Operation = CrSummaryOperationEnum.crSummaryOperationSum;
monthlySum.SummarizedField = amountField;
monthlySum.Group = monthGroup;
clientDoc.DataDefController.SummaryFieldController.Add(-1, monthlySum);
```

---

## Group Selection Formula

Group selection filters **groups** (not individual records) after grouping is complete. For example, showing only customers with total orders > $10,000:

```csharp
clientDoc.DataDefController.GroupFilterController.SetFormulaText(
    "Sum({ORDER_LINES.AMOUNT}, {ORDER_HEADER.CUSTOMER}) > 10000");
```

This is different from record selection (`RecordFilterController.SetFormulaText`), which filters individual records before grouping.

---

## Complete Template: Grouped Report with Subtotals

```csharp
using System;
using System.IO;
using CrystalDecisions.ReportAppServer.ClientDoc;
using CrystalDecisions.ReportAppServer.Controllers;
using CrystalDecisions.ReportAppServer.DataDefModel;
using CrystalDecisions.ReportAppServer.ReportDefModel;
using EngineDoc = CrystalDecisions.CrystalReports.Engine.ReportDocument;

class CreateGroupedReport
{
    static int Main(string[] args)
    {
        string outputPath = args.Length > 0 ? args[0] : "GroupedReport.rpt";

        try
        {
            var doc = new EngineDoc();
            ISCDReportClientDocument clientDoc = doc.ReportClientDocument;
            clientDoc.New();

            var connInfo = CreateConnectionInfo();

            // Add tables
            var tbl = new Table();
            tbl.Name = "ORDER_HEADER";
            tbl.Alias = "ORDER_HEADER";
            tbl.QualifiedName = "ORDER_HEADER";
            tbl.ConnectionInfo = connInfo;
            clientDoc.DatabaseController.AddTable(tbl, null);

            // Record selection
            clientDoc.DataDefController.RecordFilterController.SetFormulaText(
                "{ORDER_HEADER.RECORD_TYPE} = \"A\"");

            // Find the group field
            int tableIdx = clientDoc.DatabaseController.Database.Tables
                .FindByAlias("ORDER_HEADER");
            var dbTable = (CrystalDecisions.ReportAppServer.DataDefModel.Table)
                clientDoc.DatabaseController.Database.Tables[tableIdx];

            var custField = (Field)dbTable.DataFields.FindField(
                "{ORDER_HEADER.CUSTOMER}",
                CrFieldDisplayNameTypeEnum.crFieldDisplayNameFormula,
                CeLocale.ceLocaleUserDefault);

            // Create group
            var group = new Group();
            group.ConditionField = custField;
            clientDoc.DataDefController.GroupController.Add(-1, group);

            // Add detail fields
            var objCtrl = clientDoc.ReportDefController.ReportObjectController;
            objCtrl.AddByName("{ORDER_HEADER.ORDER_NUMBER}", "Order #");
            objCtrl.AddByName("{ORDER_HEADER.ORDER_DATE}", "Date");
            objCtrl.AddByName("{ORDER_HEADER.AMOUNT}", "Amount");

            // Place customer name in Group Header
            var reportDef = clientDoc.ReportDefController.ReportDefinition;
            var gh = reportDef.GroupHeaderArea.Sections[(object)0];

            var custNameObj = new FieldObject();
            custNameObj.DataSourceName = "{ORDER_HEADER.CUSTOMER}";
            custNameObj.FieldValueType = CrFieldValueTypeEnum.crFieldValueTypeStringField;
            custNameObj.Left = 100;
            custNameObj.Top = 50;
            custNameObj.Width = 3000;
            custNameObj.Height = 250;
            custNameObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;
            objCtrl.Add(custNameObj, gh, -1);

            // Group summary (subtotal per customer)
            ISCRField amtField = null;
            for (int i = 0; i < dbTable.DataFields.Count; i++)
            {
                if (dbTable.DataFields[i].Name == "AMOUNT")
                {
                    amtField = dbTable.DataFields[i];
                    break;
                }
            }

            var groupSum = new SummaryField();
            groupSum.Operation = CrSummaryOperationEnum.crSummaryOperationSum;
            groupSum.SummarizedField = amtField;
            groupSum.Group = group;
            clientDoc.DataDefController.SummaryFieldController.Add(-1, groupSum);

            var gf = reportDef.GroupFooterArea.Sections[(object)0];
            var groupSumObj = new FieldObject();
            groupSumObj.DataSourceName = groupSum.FormulaForm;
            groupSumObj.FieldValueType = groupSum.Type;
            groupSumObj.Left = 6200;
            groupSumObj.Top = 50;
            groupSumObj.Width = 1500;
            groupSumObj.Height = 250;
            groupSumObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;
            objCtrl.Add(groupSumObj, gf, -1);

            // Grand total in Report Footer
            var grandSum = new SummaryField();
            grandSum.Operation = CrSummaryOperationEnum.crSummaryOperationSum;
            grandSum.SummarizedField = amtField;
            clientDoc.DataDefController.SummaryFieldController.Add(-1, grandSum);

            var rf = reportDef.ReportFooterArea.Sections[(object)0];
            var grandSumObj = new FieldObject();
            grandSumObj.DataSourceName = grandSum.FormulaForm;
            grandSumObj.FieldValueType = grandSum.Type;
            grandSumObj.Left = 6200;
            grandSumObj.Top = 50;
            grandSumObj.Width = 1500;
            grandSumObj.Height = 250;
            grandSumObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;
            objCtrl.Add(grandSumObj, rf, -1);

            // Save
            string dir = Path.GetDirectoryName(Path.GetFullPath(outputPath));
            string fileName = Path.GetFileName(outputPath);
            clientDoc.SaveAs(fileName, dir, 0);
            doc.Close();

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
}
```

---

## Enum Values Reference

| Enum | Values |
|------|--------|
| `CrFieldDisplayNameTypeEnum` | `crFieldDisplayNameFormula`, `crFieldDisplayNameName`, `crFieldDisplayNameAlias` |
| `CrSortDirectionEnum` | `crSortDirectionAscendingOrder`, `crSortDirectionDescendingOrder`, `crSortDirectionTopNOrder`, `crSortDirectionBottomNOrder`, `crSortDirectionTopNPercentage`, `crSortDirectionBottomNPercentage` |
| `CrGroupConditionEnum` (Date) | `crGCDaily`, `crGCWeekly`, `crGCBiWeekly`, `crGCMonthly`, `crGCQuarterly`, `crGCSemiAnnually`, `crGCAnnually` |
| `CrGroupConditionEnum` (String) | `crGCAnyValue`, `crGCFirstLetter`, `crGCFirstTwoLetters` |

---

## Controller Access Patterns

| Need | Access Path |
|------|-------------|
| Add group | `clientDoc.DataDefController.GroupController.Add(-1, group)` |
| Add sort | `clientDoc.DataDefController.SortController.Add(-1, sort)` |
| Group summary | `SummaryField.Group = group`, then `SummaryFieldController.Add(-1, sumField)` |
| Group selection | `clientDoc.DataDefController.GroupFilterController.SetFormulaText()` |
| Group Header section | `clientDoc.ReportDefController.ReportDefinition.GroupHeaderArea.Sections[(object)n]` |
| Group Footer section | `clientDoc.ReportDefController.ReportDefinition.GroupFooterArea.Sections[(object)n]` |
| Find field by formula name | `table.DataFields.FindField("{TABLE.FIELD}", CrFieldDisplayNameTypeEnum.crFieldDisplayNameFormula, CeLocale.ceLocaleUserDefault)` |
| Find table by alias | `clientDoc.DatabaseController.Database.Tables.FindByAlias("TABLE_ALIAS")` |
| Top N sort | `clientDoc.DataDefController.SortController.Add(-1, topNSort)` |
| Date-based grouping | `group.Options.Condition = CrGroupConditionEnum.crGCMonthly` |

---

## Pitfalls

1. **Field lookup format**: `FindField` with `crFieldDisplayNameFormula` expects the `{TABLE.FIELD}` format. Using just the field name without braces or table prefix will fail.
2. **Group index is 0-based**: `GroupHeaderArea.Sections[(object)0]` is the first group's header, `Sections[(object)1]` is the second group's header.
3. **Section indexer cast**: Always use `Sections[(object)n]` — without the cast, the wrong overload is called.
4. **GroupController.Add parameter order**: `Add(int index, Group group)` — index first, group second. Use `-1` to append.
5. **Automatic section creation**: `GroupController.Add()` automatically creates GroupHeader and GroupFooter areas. You do not need to create sections manually.
6. **Sort after group**: When a group exists, additional sorts via `SortController` apply within the innermost group. The group field itself is automatically sorted.
7. **Grand total has no Group property**: A `SummaryField` without `Group` set is a grand total across all records. Set `Group` to scope it to a group level.
8. **FindByAlias returns an index**: `Tables.FindByAlias()` returns an `int` index, not a `Table` object. You must index into `Tables[idx]` and cast.
9. **Top N requires a group summary**: The `SortField` of a `TopNSort` must be a `SummaryField` with a `Group` set. A grand total or a raw database field will not work.
10. **Top N overrides group sort order**: When a Top N sort is applied, the normal ascending/descending sort for that group is replaced by the Top N ranking.
11. **Date grouping and GroupNameField display**: When grouping monthly/quarterly, the GroupNameField still shows the raw date value. Use a formula field to display a formatted group name (e.g., `ToText({ORDER_HEADER.ORDER_DATE}, "MMM yyyy")`).
12. **GroupOptions must be instantiated**: `group.Options` must be set to a new `GroupOptions()` before setting `Condition`. Accessing `group.Options.Condition` on a null `Options` throws a null reference error.
