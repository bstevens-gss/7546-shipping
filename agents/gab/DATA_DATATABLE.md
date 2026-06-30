# GAB DataTable & DataView Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with DataTables, DataViews, or in-memory tabular data
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---
# DATATABLE SYSTEM

DataTables are in-memory tables -- the primary data structure in GAB.

**Note on quoting:** String-literal parameters like DataTable names, column names, and connection names may appear quoted (`"con"`) or unquoted (`con`) in existing code. Both forms work. When generating code, prefer quoted form for consistency.

## Create
```
F.Data.DataTable.Create("dtName",True)                              ' Empty, global scope
F.Data.DataTable.CreateFromSQL("dtName","con",V.Local.sSQL,True)    ' From SQL query, global scope
F.Data.DataTable.CreateFromCSV("dtName",sFilePath,"Col1*!*Col2","String*!*Float",False)  ' Local scope
F.Data.DataTable.CreateFromString("dtName",sData,"Col1*!*Col2","String*!*Long",V.Ambient.Tab,"*!*",True)
F.Data.DataTable.CreateFromXML("dtName",sFilePath,True)                ' From XML file
F.Data.DataTable.CreateFromJson("dtName",sJsonString,bGlobal)
F.Data.DataTable.CreateFromRecordset("dtName","con","rst",bGlobal)
F.Data.DataTable.CreateFromStoredProcedure("dtName","con",sProcName,sParamNames,sParamTypes,sParamSizes,sParamValues,bGlobal)
F.Data.DataTable.CreateFromProtobuf("dtName",sFilePath)
F.Data.DataTable.CreateFromCSV("dtName",sFilePath,sFieldNames,sDataTypes,bGlobal)  ' 5-param with field names
F.Data.DataTable.CreateDatasetFromJson("dtName",sFilePath,bGlobal)
F.Data.DataTable.CreateDatasetFromXML("dsName",sFilePath,bGlobal)
```

**Scope parameter (`True` / `False`):** The last Boolean parameter on most Create functions controls the DataTable's scope:
- **`True` (Global)** -- the DataTable persists across all subroutines for the lifetime of the program. Use this when the DataTable will be accessed from other subroutines (e.g., grid binding, cross-sub data sharing, event handlers).
- **`False` (Local)** -- the DataTable is destroyed when the creating subroutine exits. Use this only for temporary, single-subroutine work (e.g., building a throwaway table for a one-shot SaveToDB).

**Rule of thumb:** If in doubt, use `True`. A DataTable created with `False` that is referenced from another subroutine will not exist and will cause a runtime error.

### Create

```
F.Data.DataTable.Create(DataTableName, [GlobalScope])
```

**Parameters:**
- `DataTableName` (String) -- name for the new DataTable
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` (or omitted) for local scope

**Examples:**
```
F.Data.DataTable.Create("dtOrders")          ' Local scope (destroyed when subroutine exits)
F.Data.DataTable.Create("dtOrders", True)    ' Global scope (persists across subroutines)
```

### CreateFromSQL

```
F.Data.DataTable.CreateFromSQL(DataTableName, ConnectionName, SQLQuery, [GlobalScope])
```

**Parameters:**
- `DataTableName` (String) -- name for the new DataTable
- `ConnectionName` (String) -- name of an open ODBC connection
- `SQLQuery` (String) -- SQL SELECT statement whose result set populates the DataTable
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` (or omitted) for local scope

**Examples:**
```
V.Local.sSql.Set("select customer, Name_Customer, City, State from Customer_Master where Rec = '1';")

'Local scope (no GlobalScope parameter)
F.Data.DataTable.CreateFromSQL("Customer", "conx", V.Local.sSql)

'Global scope
F.Data.DataTable.CreateFromSQL("Customer", "conx", V.Local.sSql, True)
```

### CreateFromString

Two overloads:
```
F.Data.DataTable.CreateFromString(DataTableName, Data, FieldNames, DataTypes, InnerDelimiter, OuterDelimiter)
F.Data.DataTable.CreateFromString(DataTableName, Data, FieldNames, DataTypes, InnerDelimiter, OuterDelimiter, GlobalScope)
```

**Parameters:**
- `DataTableName` (String) -- name for the new DataTable
- `Data` (String) -- the raw data string containing all rows and columns
- `FieldNames` (String) -- column names, delimited by `*!*` (e.g. `"Col1*!*Col2*!*Col3"`)
- `DataTypes` (String) -- column data types, delimited by `*!*` (e.g. `"String*!*Long*!*Float"`)
- `InnerDelimiter` (String) -- character that separates fields **within** a single row (e.g. `V.Ambient.Tab`, a comma)
- `OuterDelimiter` (String) -- character that separates **rows** from each other (e.g. `"*!*"`, `V.Ambient.NewLine`)
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` (or omitted) for local scope

**Example:**
```
V.Local.sData.Declare(String)
V.Local.sFields.Declare(String,"PartNo*!*Location*!*Qty")
V.Local.sTypes.Declare(String,"String*!*String*!*Long")

'Build a data string: Tab separates fields, *!* separates rows
F.Intrinsic.String.Build("0025{0}Florida{0}10*!*0026{0}Texas{0}5",V.Ambient.Tab,V.Local.sData)

F.Data.DataTable.CreateFromString("dtParts", V.Local.sData, V.Local.sFields, V.Local.sTypes, V.Ambient.Tab, "*!*", True)
```

### CreateFromProtobuf

```
F.Data.DataTable.CreateFromProtobuf(DataTableName, FilePath)
```

- `DataTableName` (String) -- name for the new DataTable
- `FilePath` (String) -- fully qualified path to the `.protobuf` file previously created by `SaveToProtobuf`

**Example:**

```
V.Local.sFile.Declare(String)
F.Intrinsic.String.Concat(V.Caller.LocalGSSTempDir,"MyData.protobuf",V.Local.sFile)
F.Data.DataTable.CreateFromProtobuf("dtRestored",V.Local.sFile)
```

### CreateFromJson

```
F.Data.DataTable.CreateFromJson(DataTableName, JsonString, [GlobalScope])
```

- `DataTableName` (String) -- name for the new DataTable
- `JsonString` (String) -- a JSON string containing the data (typically loaded from a file with `F.Intrinsic.File.File2String`)
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` for local scope

**Example:**

```
V.Local.sJson.Declare(String)
F.Intrinsic.File.File2String("C:\Users\abc\Desktop\jsonFile.json", V.Local.sJson)
F.Data.DataTable.CreateFromJson("CustomerDt", V.Local.sJson, True)
```

### CreateFromXML

```
F.Data.DataTable.CreateFromXML(DataTableName, FullyQualifiedFileName, GlobalScope)
```

- `DataTableName` (String) -- name for the new DataTable
- `FullyQualifiedFileName` (String) -- fully qualified path to the XML file
- `GlobalScope` (Boolean) -- `True` for global scope, `False` for local scope

**Example:**

```
V.Local.sDT.Declare(String,"dtImported")
V.Local.sFile.Declare(String,"C:\Data\Export.xml")
F.Data.DataTable.CreateFromXML(V.Local.sDT, V.Local.sFile, True)
```

### CreateFromRecordset

```
F.Data.DataTable.CreateFromRecordset(DataTableName, ConnectionName, RecordsetName, [GlobalScope])
```

- `DataTableName` (String) -- name for the new DataTable
- `ConnectionName` (String) -- name of the open ODBC connection
- `RecordsetName` (String) -- name of the open recordset to populate from
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` for local scope

**Example:**

```
V.Local.sDT.Declare(String,"dtFromRS")
V.Local.sCon.Declare(String,"MyConnection")
V.Local.sRst.Declare(String,"MyRecordset")
F.Data.DataTable.CreateFromRecordset(V.Local.sDT, V.Local.sCon, V.Local.sRst, True)
```

### CreateFromStoredProcedure

```
F.Data.DataTable.CreateFromStoredProcedure(DataTableName, ConnectionName, StoredProcedureName, ParamNames, ParamTypes, ParamSizes, ParamValues, [GlobalScope])
```

- `DataTableName` (String) -- name for the new DataTable
- `ConnectionName` (String) -- name of the open ODBC connection
- `StoredProcedureName` (String) -- name of the stored procedure to execute
- `ParamNames` (String) -- parameter names, `*!*` delimited
- `ParamTypes` (String) -- parameter types, `*!*` delimited
- `ParamSizes` (String) -- parameter sizes, `*!*` delimited
- `ParamValues` (String) -- parameter values, `*!*` delimited
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` for local scope

**Example:**

```
V.Local.sDT.Declare(String,"dtResults")
V.Local.sCon.Declare(String,"MyConnection")
V.Local.sProc.Declare(String,"sp_GetOrders")
V.Local.sNames.Declare(String,"@CustomerID")
V.Local.sTypes.Declare(String,"String")
V.Local.sSizes.Declare(String,"10")
V.Local.sValues.Declare(String,"CUST001")
F.Data.DataTable.CreateFromStoredProcedure(V.Local.sDT, V.Local.sCon, V.Local.sProc, V.Local.sNames, V.Local.sTypes, V.Local.sSizes, V.Local.sValues, True)
```

### CreateFromCSV

```
F.Data.DataTable.CreateFromCSV(DataTableName, CsvFilePath, DataTypes, GlobalScope)
F.Data.DataTable.CreateFromCSV(DataTableName, CsvFilePath, FieldNames, DataTypes, GlobalScope)
```

- `DataTableName` (String) -- name for the new DataTable
- `CsvFilePath` (String) -- fully qualified path to the CSV file
- `FieldNames` (String, optional) -- column names, `*!*` delimited. When omitted (4-param overload), column names are taken from the CSV header row.
- `DataTypes` (String) -- column data types, `*!*` delimited (e.g. `"String*!*Long*!*Float"`)
- `GlobalScope` (Boolean) -- `True` for global scope, `False` for local scope

**Example:**

```
' 4-param: use CSV header row for column names
V.Local.sDT.Declare(String,"dtImport")
V.Local.sFile.Declare(String,"C:\Data\parts.csv")
V.Local.sTypes.Declare(String,"String*!*String*!*Float")
F.Data.DataTable.CreateFromCSV(V.Local.sDT, V.Local.sFile, V.Local.sTypes, True)

' 5-param: specify field names explicitly
V.Local.sFields.Declare(String,"PartNo*!*Description*!*Price")
F.Data.DataTable.CreateFromCSV(V.Local.sDT, V.Local.sFile, V.Local.sFields, V.Local.sTypes, True)
```

### CreateDatasetFromJson

```
F.Data.DataTable.CreateDatasetFromJson(DataTableName, FilePath, [GlobalScope])
```

- `DataTableName` (String) -- name for the new DataTable/dataset
- `FilePath` (String) -- fully qualified path to the JSON file
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` for local scope

Creates a dataset (including all tables and relationships) from a JSON file previously saved with `SaveDatasetToJson`.

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
V.Local.sFile.Declare(String,"C:\Data\OrdersDataset.json")
F.Data.DataTable.CreateDatasetFromJson(V.Local.sDT, V.Local.sFile, True)
```

### CreateDatasetFromXML

```
F.Data.DataTable.CreateDatasetFromXML(DataSetName, FullyQualifiedFileName, GlobalScope)
```

- `DataSetName` (String) -- name for the new dataset
- `FullyQualifiedFileName` (String) -- fully qualified path to the XML file
- `GlobalScope` (Boolean) -- `True` for global scope, `False` for local scope

Reads all tables and relationships from the specified XML file into a dataset.

**Example:**

```
F.Data.DataTable.CreateDatasetFromXML("Sample","C:\Users\abc\Desktop\SampleDt.xml",True)
```

## Columns
```
F.Data.DataTable.AddColumn("dtName","ColName","String")
F.Data.DataTable.AddColumn("dtName","ColName","Long",0)              ' With default value
F.Data.DataTable.AddColumn("dtName","ColName","String","Hello",15)   ' With default + max length
F.Data.DataTable.AddExpressionColumn("dtName","Computed","Float","[ColA] + [ColB]")
F.Data.DataTable.RemoveColumn("dtName","ColName")
F.Data.DataTable.CopyColumn("dtName","SourceCol","TargetCol",True)   ' Copy column (create target if needed)
F.Data.DataTable.AddTranslationColumn("dtName","TransIDCol","TransLabelCol") ' Add translated label column
F.Data.DataTable.AddDisplayPartColumn("dtName",iPartType,"ShortPart","LongPart")
```

### AddColumn

```
F.Data.DataTable.AddColumn(DataTableName, ColumnName, ColumnDataType, [DefaultValue], [MaximumLength])
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `ColumnName` (String) -- name for the new column
- `ColumnDataType` (String) -- one of the following data type names:

| Type | Description |
|------|-------------|
| `String` | Text / character data |
| `Long` | Integer (whole number) |
| `Float` | Decimal / floating-point number |
| `Date` | Date / DateTime value |
| `Boolean` | True / False |

- `DefaultValue` (optional) -- default value assigned to every new row; must match the column's data type
- `MaximumLength` (Long, optional) -- maximum character length (applies to `String` columns)

**Example:**
```
F.Data.DataTable.AddColumn("dtExample","NewColumn","String","Hello World!",15)
```

### AddExpressionColumn

```
F.Data.DataTable.AddExpressionColumn(DataTableName, ColumnName, ColumnDataType, Expression)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `ColumnName` (String) -- name for the computed column
- `ColumnDataType` (String) -- result data type (`Boolean`, `Date`, `Float`, `String`, `Long`)
- `Expression` (String) -- a DataTable expression that is evaluated for every row. Refer to other columns by name; enclose names containing special characters or reserved words in square brackets (`[ColName]`) or grave accents (`` `ColName` ``). See [Expression Syntax](#expression-syntax) below for the full reference.

**Example:**
```
F.Data.DataTable.AddExpressionColumn("dtOrders","Total","Float","[UnitPrice] * [Quantity]")
```

### RemoveColumn

```
F.Data.DataTable.RemoveColumn(DataTableName, ColumnName)
```

- `DataTableName` (String) -- name of the DataTable
- `ColumnName` (String) -- name of the column to remove

**Example:**

```
V.Local.sDT.Declare(String,"dtExample")
V.Local.sCol.Declare(String,"OldColumn")
F.Data.DataTable.RemoveColumn(V.Local.sDT, V.Local.sCol)
```

### AddDisplayPartColumn

```
F.Data.DataTable.AddDisplayPartColumn(DataTableName, PartType, ShortPartColumnName, LongPartColumnName)
F.Data.DataTable.AddDisplayPartColumn(DataTableName, PartType, ShortPartColumnName, LongPartColumnName, LongRevisionColumnName)
```

- `DataTableName` (String) -- name of the DataTable
- `PartType` (Enum / Long) -- the part type, using `V.Enum.LongPartType`:

| Value | Part Type |
|-------|-----------|
| 0 | Standard part number |
| 1 | Customer's part number |
| 2 | Manufacturer's part number |
| 3 | User's part number |

- `ShortPartColumnName` (String) -- column containing the short (truncated) part number
- `LongPartColumnName` (String) -- column containing the long (full) part number
- `LongRevisionColumnName` (String, optional) -- column containing the long revision number

Adds a display column that combines short and long part numbers into a formatted display value based on the system's part numbering configuration.

**Example:**

```
V.Local.sDT.Declare(String,"dtParts")
V.Local.iPartType.Declare(Long,0)
F.Data.DataTable.AddDisplayPartColumn(V.Local.sDT, V.Local.iPartType, "ShortPart", "LongPart", "LongRevision")
```

### CopyColumn

```
F.Data.DataTable.CopyColumn(DataTableName, SourceColumnName, TargetColumnName, [CreateTargetColumnFlag])
```

- `DataTableName` (String) -- name of the DataTable
- `SourceColumnName` (String) -- column to copy data from
- `TargetColumnName` (String) -- column to copy data to
- `CreateTargetColumnFlag` (Boolean, optional) -- `True` to automatically create the target column if it does not exist

Only copies raw data values; expression columns are **not** duplicated (the target receives the evaluated values, not the expression itself).

**Example:**

```
F.Data.DataTable.CopyColumn("dt","SourceColumn","TargetColumn",True)
```

### AddTranslationColumn

```
F.Data.DataTable.AddTranslationColumn(DataTableName, TranslationIDColumnName, TranslationLabelColumnName)
```

- `DataTableName` (String) -- name of the DataTable
- `TranslationIDColumnName` (String) -- column containing the translation ID
- `TranslationLabelColumnName` (String) -- name for the new column that will receive the translated label text

Adds a column to the DataTable that automatically populates with the translated label corresponding to each row's translation ID.

**Example:**

```
V.Local.sDT.Declare(String,"DTLabelTranslation")
V.Local.sIDCol.Declare(String,"TranslationID")
V.Local.sLabelCol.Declare(String,"TranslatedLabel_ByTranslationID")
F.Data.DataTable.AddTranslationColumn(V.Local.sDT, V.Local.sIDCol, V.Local.sLabelCol)
```

## Rows
```
F.Data.DataTable.AddRow("dtName","Col1","val1","Col2","val2")
F.Data.DataTable.DeleteRow("dtName")                                ' Mark all rows as deleted
F.Data.DataTable.DeleteRow("dtName",3)                              ' Mark specific row as deleted
F.Data.DataTable.SetValue("dtName",-1,"Col","value")                ' -1 = all rows
F.Data.DataTable.SetValue("dtName",0,"Col","value")                 ' Specific row
F.Data.DataTable.SetValue("dtName",-1,"Col1","val1","Col2","val2")  ' Multi-column set
F.Data.DataTable.SetSeries("dtName","ID",1,1)                      ' Auto-increment (numeric)
F.Data.DataTable.SetSeries("dtName","DateCol",4/19/2023,1,"yyyy")  ' Auto-increment (date)
F.Data.DataTable.SetValueFormat("dtName",-1,"SourceCol","TargetCol","00")
F.Data.DataTable.AcceptChanges("dtName")
F.Data.DataTable.Select("dtName","filter",sResult)
F.Data.DataTable.Clear("dtName")                                       ' Remove all rows (keep structure)
F.Data.DataTable.Clone("dtName","newDTName",True)                      ' Copy structure + data
F.Data.DataTable.CopyColumn("dtName","SourceCol","DestCol",True)       ' Copy column values (create target)
F.Data.DataTable.Compute("dtName","SUM(ColName)","filter",fResult)     ' Aggregate computation
F.Data.DataTable.MoveRow("dtName",iFromRow,iToRow)                     ' Move row position
F.Data.DataTable.RunningTotal("dtName","SourceCol",0,"+","DestCol")    ' Cumulative running total
F.Data.DataTable.AddRunningTotalColumn("dtName","SourceCol",0,"+","DestCol")  ' Alias for RunningTotal
F.Data.DataTable.DateAdd("dtName","DateCol","d","IntervalCol","TargetCol")    ' Add date interval to column
F.Data.DataTable.DateDiff("dtName","DateCol1","DateCol2","D","TargetCol")  ' Diff between date columns
F.Data.DataTable.DateDiff("dtName","DateCol1","DateCol2","W","TargetCol",64) ' Weekday diff (Saturday mask)
F.Data.DataTable.ColumnToString("dtName","ColName",sResult)            ' Column values to *!* delimited string
F.Data.DataTable.SetPK("dtName","KeyCol1","KeyCol2")                     ' Set primary key (multi-column)
F.Data.DataTable.SetPK()                                                  ' Remove all primary keys
F.Data.DataTable.SetValueOnNextLine("dtName","SrcCol","TgtCol","KeyCol")  ' Copy next row's value into current row
F.Data.DataTable.CaseSensitive("dtName",True)                          ' Set case sensitivity
F.Data.DataTable.AddRowByMap("dtName","Col1*!*Col2","val1","val2")      ' Add row by field map
F.Data.DataTable.AddRowChangedEventHandler("dtName","SubName")         ' Trigger sub on row change
F.Data.DataTable.AddTable("dtName","childDTName")                      ' Add child table
F.Data.DataTable.AddDisplayPartColumn("dtName",iPartType,"ShortPart","LongPart")        ' Add formatted part display
F.Data.DataTable.AddDisplayPartColumn("dtName",iPartType,"ShortPart","LongPart","LongRev") ' With revision column
F.Data.DataTable.AddTranslationColumn("dtName","SourceCol","TransCol") ' Add translated column
```

**`DeleteRow` note:** `DeleteRow` marks rows as deleted (RowState = 8) rather than physically removing them. This allows `SaveToDB` with a mode that includes flag 4 (delete) to synchronize the deletions back to the database. Call `AcceptChanges` after `SaveToDB` to finalize and physically purge deleted rows from the DataTable.

### AddRow

```
F.Data.DataTable.AddRow(DataTableName, Column0Name, Column0Value [, ColumnNName, ColumnNValue ...])
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `Column0Name` (String) -- name of the first column to populate
- `Column0Value` (Any) -- value for the first column
- `ColumnNName` (String) -- name of an additional column *(repeat as needed)*
- `ColumnNValue` (Any) -- value for that column *(repeat as needed)*

Column name/value pairs repeat for as many columns as you want to populate on the new row. Columns not specified receive their default value (or null).

**Example:**
```
V.Local.sDT.Declare(String)
V.Local.sCol.Declare(String)
V.Local.sVal.Declare(String)
F.Data.DataTable.AddRow(V.Local.sDT, V.Local.sCol, V.Local.sVal)
```

### AddRowByMap

```
F.Data.DataTable.AddRowByMap(DataTableName, FieldMap, Column0Value [, ColumnNValue ...])
```

- `DataTableName` (String) -- name of the DataTable
- `FieldMap` (String) -- `*!*` delimited list of column names (e.g. `"Column1*!*Column2*!*Column3"`)
- `Column0Value` (Any) -- value for the first column in the FieldMap
- `ColumnNValue` (Any) -- values for subsequent columns *(repeat as needed)*

The number of value arguments must match the number of columns in the FieldMap, otherwise a runtime error is raised. The order of values corresponds exactly to the order of column names in the FieldMap.

**Example:**

```
F.Data.DataTable.Create("DataTableName")
F.Data.DataTable.AddColumn("DataTableName","Column1","String")
F.Data.DataTable.AddColumn("DataTableName","Column2","String")
F.Data.DataTable.AddColumn("DataTableName","Column3","Long")

V.Local.sDT.Declare(String,"DataTableName")
V.Local.sMap.Declare(String,"Column1*!*Column2*!*Column3")
V.Local.sVal1.Declare(String,"Column1_Value")
V.Local.sVal2.Declare(String,"Column2_Value")
V.Local.iVal3.Declare(Long,100)

F.Data.DataTable.AddRowByMap(V.Local.sDT, V.Local.sMap, V.Local.sVal1, V.Local.sVal2, V.Local.iVal3)
```

### SetValue

```
F.Data.DataTable.SetValue(DataTableName, RowNumber, Column0Name, Column0Value [, ColumnNName, ColumnNValue ...])
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `RowNumber` (Long) -- zero-based row index, or **`-1` to update all rows**
- `Column0Name` (String) -- name of the first column to update
- `Column0Value` (Any) -- new value for the first column
- `ColumnNName` (String) -- name of an additional column *(repeat as needed)*
- `ColumnNValue` (Any) -- new value for that column *(repeat as needed)*

Column name/value pairs repeat for as many columns as you want to update in a single call.

**Example:**
```
F.Data.DataTable.Create("dtName")
F.Data.DataTable.AddColumn("dtName","PartNumber","String")
F.Data.DataTable.AddColumn("dtName","Location","String")
F.Data.DataTable.AddRow("dtName","PartNumber","0025","Location","Florida")
F.Data.DataTable.AddRow("dtName","PartNumber","0026","Location","Colorado")

'Set PartNumber to "Abc123" on ALL rows
F.Data.DataTable.SetValue("dtName",-1,"PartNumber","Abc123")

'Set PartNumber and Location on row 0 only
F.Data.DataTable.SetValue("dtName",0,"PartNumber","0025","Location","Texas")
```

### SetValueFormat

```
F.Data.DataTable.SetValueFormat(DataTableName, RowNumber, SourceColumn, TargetColumn, FormatMask)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `RowNumber` (Long) -- zero-based row index, or `-1` for all rows
- `SourceColumn` (String) -- column whose value is read
- `TargetColumn` (String) -- column that receives the formatted result
- `FormatMask` (String) -- VB-style format string (see tables below)

**Example** -- force `Vendor` to lowercase and write to `VendorSetValueFormat`:
```
F.Data.DataTable.Create("testdt_1",False)
F.Data.DataTable.AddColumn("testdt_1","Vendor","String")
F.Data.DataTable.AddColumn("testdt_1","VendorSetValueFormat","String")
F.Data.DataTable.AddRow("testdt_1","Vendor","VENDORCELLVALUESAMPLE","VendorSetValueFormat","")

V.Local.sMask.Declare(String,"<")
F.Data.DataTable.SetValueFormat("testdt_1",0,"Vendor","VendorSetValueFormat",V.Local.sMask)
```

#### Format Mask -- DateTime

| Mask | Description |
|------|-------------|
| `:` | Time separator (system-defined) |
| `/` | Date separator (system-defined) |
| `h` | Hour without leading zero (0-23) |
| `Hh` | Hour with leading zero (00-23) |
| `N` | Minute without leading zero (0-59) |
| `Nn` | Minute with leading zero (00-59) |
| `S` | Second without leading zero (0-59) |
| `Ss` | Second with leading zero (00-59) |
| `tttt` | Complete time (h:mm:ss, system format) |
| `am/pm` | 12-hour clock, lowercase am/pm |
| `A/P` | 12-hour clock, uppercase A/P |
| `a/p` | 12-hour clock, lowercase a/p |
| `AMPM` | 12-hour clock, system-defined AM/PM literal |
| `c` | Date as `ddddd` + time as `ttttt` |
| `d` | Day without leading zero (1-31) |
| `dd` | Day with leading zero (01-31) |
| `ddd` | Day abbreviation (Sun-Sat) |
| `dddd` | Day full name (Sunday-Saturday) |
| `ddddd` | Short date (system format, default `m/d/y`) |
| `dddddd` | Long date (system format, default `mmmm dd, yyyy`) |
| `aaaa` | Localized full day name |
| `w` | Day of week number (1=Sunday - 7=Saturday) |
| `ww` | Week of year (1-52) |
| `m` | Month without leading zero (1-12). If after `h`/`hh`, displays minute instead |
| `mm` | Month with leading zero (01-12). If after `h`/`hh`, displays minute instead |
| `mmm` | Month abbreviation (Jan-Dec) |
| `mmmm` | Month full name (January-December) |
| `oooo` | Localized full month name |
| `q` | Quarter (1-4) |
| `y` | Day of year (1-365) |
| `yy` | 2-digit year (00-99) |
| `yyyy` | 4-digit year (1000-9999) |

#### Format Mask -- String

| Mask | Description |
|------|-------------|
| `@` | Character placeholder -- display character or space. Fills right-to-left unless `!` is present |
| `&` | Character placeholder -- display character or nothing. Fills right-to-left unless `!` is present |
| `<` | Force all characters to **lowercase** |
| `>` | Force all characters to **UPPERCASE** |
| `!` | Force left-to-right fill of placeholders (default is right-to-left) |

#### Format Mask -- Numeric

| Mask | Description |
|------|-------------|
| `0` | Digit placeholder -- display digit or zero. Shows leading/trailing zeros as needed |
| `#` | Digit placeholder -- display digit or nothing. No leading/trailing zeros |
| `.` | Decimal separator (system-defined). Controls digits shown left and right of decimal |
| `%` | Percentage placeholder -- multiplies value by 100 and inserts `%` |
| `,` | Thousands separator. Two adjacent commas or comma before decimal = divide by 1000 |
| `E-` `E+` `e-` `e+` | Scientific notation. Digit placeholders after `E`/`e` control exponent digits |
| `-` `+` `$` `(` `)` | Displayed as literal characters |
| `\` | Escape -- display the next character literally |
| `"ABC"` | Display enclosed string literally. Use `Chr(34)` in code to embed quotes |

### AcceptChanges

```
F.Data.DataTable.AcceptChanges(DataTableName)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable

When `AcceptChanges` is called:
- Rows still in edit mode automatically end their edits
- **Added** and **Modified** rows become **Unchanged**
- **Deleted** rows are **permanently removed** from the DataTable

Typically called after `SaveToDB` to confirm that changes have been successfully persisted to the database.

**Example:**
```
F.Data.DataTable.SaveToDB("dtOrders","con","ORDERS","ORDER_NO",7)
F.Data.DataTable.AcceptChanges("dtOrders")
```

### SaveToProtobuf

```
F.Data.DataTable.SaveToProtobuf(DataTableName, FilePath)
```

- `DataTableName` (String) -- name of the DataTable to serialize
- `FilePath` (String) -- fully qualified path for the output `.protobuf` file

Serializes the DataTable to a Protocol Buffers binary file. The file can later be reloaded with `CreateFromProtobuf`. This is useful for high-performance persistence/transfer of DataTable data without a database.

**Example:**

```
V.Local.protoBufFile.Declare(String)
F.Intrinsic.String.Concat(V.Caller.LocalGSSTempDir,"ProtoBufFile.protobuf",V.Local.protoBufFile)

F.Data.DataTable.Create("SampleTable",False)
F.Data.DataTable.AddColumn("SampleTable","First Name","String")
F.Data.DataTable.AddColumn("SampleTable","Last Name","String")
F.Data.DataTable.AddColumn("SampleTable","Age","Long")

F.Data.DataTable.AddRow("SampleTable","First Name","John","Last Name","Smith","Age","20")
F.Data.DataTable.AddRow("SampleTable","First Name","Ethan","Last Name","Reynolds","Age","30")
F.Data.DataTable.AddRow("SampleTable","First Name","Lily","Last Name","Harrington","Age","40")

F.Data.DataTable.SaveToProtobuf("SampleTable",V.Local.protoBufFile)
F.Data.DataTable.CreateFromProtobuf("SampleTable2",V.Local.protoBufFile)
```

### SaveDatasetToJson

```
F.Data.DataTable.SaveDatasetToJson(DataTableName, FilePath)
```

- `DataTableName` (String) -- name of the DataTable (and its associated dataset) to save
- `FilePath` (String) -- fully qualified path for the output JSON file

Saves the entire dataset (including related tables and relationships) to a JSON file.

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
V.Local.sFile.Declare(String,"C:\Exports\OrdersDataset.json")
F.Data.DataTable.SaveDatasetToJson(V.Local.sDT, V.Local.sFile)
```

### SaveDatasetToXml

```
F.Data.DataTable.SaveDatasetToXml(DataTableName, Mode, FilePath)
```

- `DataTableName` (String) -- name of the DataTable (and its associated dataset) to save
- `Mode` (Long) -- XML write mode:

| Value | Mode | Description |
|-------|------|-------------|
| 0 | WriteSchema | Include schema definition in the output |
| 1 | IgnoreSchema | Write data only, omit schema |

- `FilePath` (String) -- fully qualified path for the output XML file

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
V.Local.iMode.Declare(Long,0)
V.Local.sFile.Declare(String,"C:\Exports\OrdersDataset.xml")
F.Data.DataTable.SaveDatasetToXml(V.Local.sDT, V.Local.iMode, V.Local.sFile)
```

### SaveToXML

```
F.Data.DataTable.SaveToXML(DataTableName, Mode, Hierarchy, FullyQualifiedFileName)
```

- `DataTableName` (String) -- name of the DataTable
- `Mode` (Long) -- XML write mode (0 = WriteSchema, 1 = IgnoreSchema)
- `Hierarchy` (Boolean) -- whether to include hierarchical/nested table structure
- `FullyQualifiedFileName` (String) -- fully qualified path for the output XML file

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
V.Local.iMode.Declare(Long,0)
V.Local.bHierarchy.Declare(Boolean,False)
V.Local.sFile.Declare(String,"C:\Exports\Orders.xml")
F.Data.DataTable.SaveToXML(V.Local.sDT, V.Local.iMode, V.Local.bHierarchy, V.Local.sFile)
```

### ExportHTML

```
F.Data.DataTable.ExportHTML(DataTableName, ColumnNames, ColumnTitles, TableId, DateNull, Return)
```

- `DataTableName` (String) -- name of the DataTable or sub-table
- `ColumnNames` (String) -- `!`-delimited list of column names to include, in order. Empty string includes all columns in no particular order.
- `ColumnTitles` (String) -- `!`-delimited list of column titles for the header row. Empty string omits the header. `"USETABLE"` uses the DataTable column names as titles.
- `TableId` (String) -- HTML `id` attribute for the `<table>` element. Can be empty, but an ID is required for CSS formatting when multiple tables exist in a document.
- `DateNull` (Boolean) -- when `True`, dates equal to `1/1/1900` or null are returned as blank values
- `Return` (String) -- output; the HTML block for the table

**Example:**

```
V.Local.sDT.Declare(String,"dtReport")
V.Local.sCols.Declare(String,"PartNo!Description!Qty")
V.Local.sTitles.Declare(String,"Part Number!Description!Quantity")
V.Local.sTableId.Declare(String,"tblReport")
V.Local.bDateNull.Declare(Boolean,True)
V.Local.sHTML.Declare(String)
F.Data.DataTable.ExportHTML(V.Local.sDT, V.Local.sCols, V.Local.sTitles, V.Local.sTableId, V.Local.bDateNull, V.Local.sHTML)
```

### SaveToCSV

```
F.Data.DataTable.SaveToCSV(DataTableName, FullyQualifiedPath, IncludeHeaderTitles)
```

- `DataTableName` (String) -- name of the DataTable
- `FullyQualifiedPath` (String) -- fully qualified path for the output CSV file
- `IncludeHeaderTitles` (Boolean) -- `True` to include column names as the first row

**Example:**

```
F.Data.DataTable.Create("dtClass",True)
F.Data.DataTable.AddColumn("dtClass","ClassName","String")
F.Data.DataTable.AddColumn("dtClass","ClassID","Long")
F.Data.DataTable.AddColumn("dtClass","ClassScore","Float")
F.Data.DataTable.AddColumn("dtClass","ClassDate","DateTime")
F.Data.DataTable.AddColumn("dtClass","ClassCert","Boolean")
F.Data.DataTable.AddColumn("dtClass","ClassCurve","Float")

F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",1,"ClassScore",90.3,"ClassDate",01/31/2023,"ClassCert",True,"ClassCurve",0)
F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",2,"ClassScore",88.5,"ClassDate",02/20/2023,"ClassCert",True,"ClassCurve",5)
F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",3,"ClassScore",93.2,"ClassDate",03/29/2023,"ClassCert",True,"ClassCurve",7)
F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",4,"ClassScore",95.0,"ClassDate",04/11/2023,"ClassCert",True,"ClassCurve",3.5)

F.Data.DataTable.SaveToCSV("dtClass","C:\Global\TEMP\ClassToCSV.csv",True)
```

### SaveToJson

```
F.Data.DataTable.SaveToJson(DataTableName, FileName)
```

- `DataTableName` (String) -- name of the DataTable
- `FileName` (String) -- fully qualified path for the output JSON file

**Example:**

```
F.Data.DataTable.Create("CustomerDt",True)
F.Data.DataTable.AddColumn("CustomerDt","CustomerID","Long")
F.Data.DataTable.AddColumn("CustomerDt","Name","String")
F.Data.DataTable.AddRow("CustomerDt","CustomerID",1,"Name","John")
F.Data.DataTable.AddRow("CustomerDt","CustomerID",2,"Name","Paul")
F.Data.DataTable.AddRow("CustomerDt","CustomerID",3,"Name","Joe")
F.Data.DataTable.SaveToJson("CustomerDt","C:\Users\abc\Desktop\jsonfile.json")
```

### SaveBLOBToFile

```
F.Data.DataTable.SaveBLOBToFile(DataTableName, RowIndex, FieldName, FileName)
```

- `DataTableName` (String) -- name of the DataTable
- `RowIndex` (Long) -- zero-based row index
- `FieldName` (String) -- name of the BLOB column
- `FileName` (String) -- fully qualified path for the output file

**Example:**

```
V.Local.sDT.Declare(String,"dtDocuments")
V.Local.iRow.Declare(Long,0)
V.Local.sField.Declare(String,"FileData")
V.Local.sFile.Declare(String,"C:\Exports\document.pdf")
F.Data.DataTable.SaveBLOBToFile(V.Local.sDT, V.Local.iRow, V.Local.sField, V.Local.sFile)
```

### SaveFileToBLOB

```
F.Data.DataTable.SaveFileToBLOB(DataTableName, RowIndex, FieldName, FileName)
```

- `DataTableName` (String) -- name of the DataTable
- `RowIndex` (Long) -- zero-based row index
- `FieldName` (String) -- name of the BLOB column to write to
- `FileName` (String) -- fully qualified path of the file to load into the BLOB

**Example:**

```
V.Local.sDT.Declare(String,"dtDocuments")
V.Local.iRow.Declare(Long,0)
V.Local.sField.Declare(String,"FileData")
V.Local.sFile.Declare(String,"C:\Imports\document.pdf")
F.Data.DataTable.SaveFileToBLOB(V.Local.sDT, V.Local.iRow, V.Local.sField, V.Local.sFile)
```

### Replace

```
F.Data.DataTable.Replace(DataTableName, SearchString, ReplaceString)
F.Data.DataTable.Replace(DataTableName, ColumnNames, SearchString, ReplaceString)
```

- `DataTableName` (String) -- name of the DataTable
- `ColumnNames` (String, optional) -- `*!*` delimited list of column names to search. When omitted (3-param overload), all columns are searched.
- `SearchString` (String) -- the value to find
- `ReplaceString` (String) -- the replacement value

**Example:**

```
' Replace in all columns
F.Data.DataTable.Replace("dtOrders","N/A","")

' Replace in specific columns only
F.Data.DataTable.Replace("dtOrders","Description*!*Notes","N/A","")
```

## Access Data
```
V.DataTable.dtName.Exists                       ' True if datatable exists
V.DataTable.dtName.FieldNames                   ' Returns list of field names in the datatable
V.DataTable.dtName.RowCount                     ' Count of ALL rows (including deleted)
V.DataTable.dtName.RowCount--                   ' Count of ALL rows minus 1 (last 0-based index)
V.DataTable.dtName.ActiveRowCount               ' Count of active rows only (excludes deleted row states)
V.DataTable.dtName.ActiveRowCount--             ' Count of active rows minus 1 (excludes deleted row states)
V.DataTable.dtName(0).FullRow                   ' Entire row data, columns delimited with *!*
V.DataTable.dtName(0).RowState                  ' Row state: 1=Detached, 2=Unchanged, 4=Added, 8=Deleted, 16=Modified
V.DataTable.dtName(0).ColName!FieldVal                       ' String value at row 0
V.DataTable.dtName(0).ColName!FieldValTrim                   ' Trimmed string
V.DataTable.dtName(0).ColName!FieldValFloat                  ' Float value
V.DataTable.dtName(0).ColName!FieldValLong                   ' Long value
V.DataTable.dtName(0).ColName!FieldValNot                    ' Negated boolean
V.DataTable.dtName(0).ColName!FieldValString                 ' Explicit string conversion
V.DataTable.dtName(0).ColName!FieldValIsNull                 ' True if value is null
V.DataTable.dtName(0).ColName!FieldValLTrim                  ' Left-trimmed string
V.DataTable.dtName(0).ColName!FieldValRTrim                  ' Right-trimmed string
V.DataTable.dtName(0).ColName!FieldValLcTrim                 ' Lowercase + trimmed
V.DataTable.dtName(0).ColName!FieldValLcRTrim                ' Lowercase + right-trimmed
V.DataTable.dtName(0).ColName!FieldValUcTrim                 ' Uppercase + trimmed
V.DataTable.dtName(0).ColName!FieldValUcRTrim                ' Uppercase + right-trimmed
V.DataTable.dtName(0).ColName!FieldValPervasiveDate          ' Date formatted for Pervasive SQL
V.DataTable.dtName(0).ColName!FieldValPercentToDecimal       ' Percentage to decimal conversion
V.DataTable.dtName(0).ColName!FieldValStringPSqlFriendly     ' String escaped for Pervasive SQL
V.DataTable.dtName(0).ColName!FieldValStringMsSqlFriendly    ' String escaped for SQL Server
V.DataTable.[V.Local.sDT](V.Local.i).[V.Args.Column]!FieldValTrim  ' Dynamic access
```

**Bracket `[ ]` syntax -- variable indirection:** Brackets are used **only** when the DataTable name or column name is stored in a variable. Do not use brackets for literal names.
```
' Literal names -- NO brackets
V.DataTable.dtOrders(0).PartNumber!FieldValTrim

' DataTable name from variable -- bracket the name
V.DataTable.[V.Local.sDT](V.Local.i).PartNumber!FieldValTrim

' Column name from variable -- bracket the column
V.DataTable.dtOrders(V.Local.i).[V.Local.sField]!FieldValTrim

' Both from variables
V.DataTable.[V.Local.sDT](V.Local.i).[V.Local.sField]!FieldValTrim
```

## Persistence
```
F.Data.DataTable.SaveToDB("dtName","con","TableName","KeyCol")
F.Data.DataTable.SaveToDB("dtName","con","TableName","KeyCol",iMode)
F.Data.DataTable.SaveToDB("dtName","con","TableName","Key1*!*Key2",iMode,"DTCol@!@DBCol*!*DTCol2@!@DBCol2")
F.Data.DataTable.SaveToCSV("dtName","C:\path\file.csv",True)
F.Data.DataTable.SaveToXML("dtName",0,False,sFilePath)                  ' Save to XML file
F.Data.DataTable.SaveBLOBToFile("dtName",iRow,"BlobCol",sFilePath)       ' Save BLOB column to file
F.Data.DataTable.ExportHTML("dtName",sCols,sTitles,sTableId,bDateNull,sReturn)  ' Export as HTML table
F.Data.DataTable.SaveToJson("dtName",sFilePath)
F.Data.DataTable.SaveToProtobuf("dtName",sFilePath)
F.Data.DataTable.SaveDatasetToJson("dtName",sFilePath)
F.Data.DataTable.SaveDatasetToXml("dtName",iMode,sFilePath)
F.Data.DataTable.SaveFileToBLOB("dtName",iRow,"BlobCol",sFilePath)       ' Load file into BLOB column
F.Data.DataTable.Compute("dtName",sAggregateExpr,sFilter,sResult)
F.Data.DataTable.Replace("dtName",sFind,sReplace)                         ' Replace in all columns
F.Data.DataTable.Replace("dtName",sColumns,sFind,sReplace)                ' Replace in specific columns
```

### SaveToDB

Three overloads:
```
F.Data.DataTable.SaveToDB(DataTableName, ConnectionName, DBTableName, KeyFields)
F.Data.DataTable.SaveToDB(DataTableName, ConnectionName, DBTableName, KeyFields, Mode)
F.Data.DataTable.SaveToDB(DataTableName, ConnectionName, DBTableName, KeyFields, Mode, FieldMap)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable to save
- `ConnectionName` (String) -- open ODBC connection name
- `DBTableName` (String) -- target database table name
- `KeyFields` (String) -- primary key field(s) of the database table; multiple keys delimited with `*!*`
- `Mode` (Long) -- controls which operations are performed (see table below)
- `FieldMap` (String) -- maps DataTable column names to database column names when they differ; format: `DTCol@!@DBCol` pairs delimited with `*!*`

**Mode flags:**

| Flag | Meaning |
|------|---------|
| *(none)* | Default: add + modify + delete (all DataTable changes reconciled against the database table; equivalent to 1+2+4) |
| 1 | Add records |
| 2 | Modify records |
| 4 | Delete records |
| 128 | Treat all current records as new inserts; KeyFields parameter excludes identity field(s) from the insert |
| 256 | Upsert: modify existing records matching key, insert all unmatched records |

Flags 1, 2, and 4 are combinable (sum the values):
| Combined | Value | Operations |
|----------|-------|------------|
| Add + Modify | 3 | Insert new and update changed rows |
| Add + Delete | 5 | Insert new and remove deleted rows |
| Modify + Delete | 6 | Update changed and remove deleted rows |
| Add + Modify + Delete | 7 | Full reconciliation (same as default/no mode) |

**Identity Column Requirement:** When the target table has an identity/auto-increment column, the DataTable MUST include that column. Set it to `0` for new rows — the database assigns the actual value. If the identity column is missing, SaveToDB fails.

**Field Map Format:** When DataTable column names differ from database column names, use the FieldMap parameter. Format is `DTCol@!@DBCol` pairs delimited by `*!*`:
```
F.Data.DataTable.SaveToDB("dtOrders","con","ORDERS","ORDER_ID",7,"DT_PartNum@!@PART*!*DT_Qty@!@QTY_ORDERED")
```

**Prefer Mode 256 (Upsert):** For most write-back scenarios, prefer mode 256 over DELETE + INSERT patterns. Mode 256 modifies existing records matching the business key and inserts unmatched rows in a single atomic operation. The KeyFields parameter for mode 256 should be the BUSINESS key (e.g., `PART*!*LOCATION`), NOT the identity column. DELETE + INSERT introduces race condition risk and may trigger referential integrity violations.

**Example:**
```
F.ODBC.Connection!con.OpenCompanyConnection
F.Data.DataTable.CreateFromSQL("dtExample","con","select PART,LOCATION,AMT_PRICE from INVENTORY_MSTR where AMT_PRICE = 0 and PRODUCT_LINE = 'RM'",True)
F.Data.DataTable.SetValue("dtExample",-1,"AMT_PRICE",10.50)
F.Data.DataTable.SaveToDB("dtExample","con","INVENTORY_MSTR","PART*!*LOCATION",256)
F.ODBC.Connection!con.Close
```

### DeleteRow

Two overloads:
```
F.Data.DataTable.DeleteRow(DataTableName)
F.Data.DataTable.DeleteRow(DataTableName, RowNumber)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `RowNumber` (Long) -- zero-based row index to delete. When omitted, **all rows** are marked for deletion.

`DeleteRow` marks the specified row(s) as deleted but does not physically remove them from the DataTable. This is intentional -- the deleted RowState is preserved so that `SaveToDB` with a mode that includes flag 4 (delete) can synchronize the deletions back to the source database table.

After `SaveToDB` completes, call `AcceptChanges` to finalize and physically purge the deleted rows from the in-memory DataTable.

**Example -- delete a specific row:**
```
V.Local.sDT.Declare(String)
V.Local.iRow.Declare(Long)
F.Data.DataTable.DeleteRow(V.Local.sDT, V.Local.iRow)
```

**Example -- delete all rows then sync to DB:**
```
F.Data.DataTable.DeleteRow("dtExample")
F.Data.DataTable.SaveToDB("dtExample","con","MY_TABLE","ID",4)
F.Data.DataTable.AcceptChanges("dtExample")
```

### MoveRow

```
F.Data.DataTable.MoveRow(DataTableName, SourceRow, TargetRow)
```

- `DataTableName` (String) -- name of the DataTable
- `SourceRow` (Long) -- row index to move
- `TargetRow` (Long) -- destination row index

> **CRITICAL:** Calling `MoveRow` before `SaveToDB` will cause issues with any SaveToDB mode that includes flag 2 (modify). For example, mode 7 (add + modify + delete) will not work properly after a MoveRow.

To move a row one position at a time, use `.++` or `.--` inline to avoid a separate math step:
```
F.Data.DataTable.MoveRow("dt",V.Local.iRow,V.Local.iRow.++)   ' Move down one position
F.Data.DataTable.MoveRow("dt",V.Local.iRow,V.Local.iRow.--)   ' Move up one position
```

### SetSeries

Two overloads -- numeric and date:
```
F.Data.DataTable.SetSeries(DataTableName, ColumnName, InitialValue, Interval)
F.Data.DataTable.SetSeries(DataTableName, ColumnName, InitialValue, Interval, IntervalType)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `ColumnName` (String) -- column to populate with the series
- `InitialValue` (Float or Date) -- starting value for the first row
- `Interval` (Float) -- increment applied to each successive row
- `IntervalType` (String) -- **required for date columns only**; specifies the date-part unit for the interval:

| Code | Unit | Rounding |
|------|------|----------|
| `d` | Day | Truncated to integral value |
| `y` | Day | Truncated to integral value |
| `h` | Hour | Rounded to nearest millisecond |
| `n` | Minute | Rounded to nearest millisecond |
| `m` | Month | Truncated to integral value |
| `q` | Quarter | Truncated to integral value |
| `s` | Second | Rounded to nearest millisecond |
| `w` | Weekday | Truncated to integral value |
| `ww` | Week | Truncated to integral value |
| `yyyy` | Year | Truncated to integral value |

**Example -- numeric series** (sets ClassID to 101, 201, 301, 401):
```
F.Data.DataTable.Create("dtClass",True)
F.Data.DataTable.AddColumn("dtClass","ClassName","String")
F.Data.DataTable.AddColumn("dtClass","ClassID","Long")
F.Data.DataTable.AddColumn("dtClass","ClassScore","Float")
F.Data.DataTable.AddColumn("dtClass","ClassDate","DateTime")
F.Data.DataTable.AddColumn("dtClass","ClassCert","Boolean")
F.Data.DataTable.AddColumn("dtClass","ClassCurve","Float")

F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",1,"ClassScore",90.3,"ClassDate",4/19/2023,"ClassCert",True,"ClassCurve",0)
F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",2,"ClassScore",88.5,"ClassDate",4/26/2023,"ClassCert",True,"ClassCurve",5)
F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",3,"ClassScore",93.2,"ClassDate",5/3/2023,"ClassCert",True,"ClassCurve",7)
F.Data.DataTable.AddRow("dtClass","ClassName","GAB 201","ClassID",4,"ClassScore",95.0,"ClassDate",5/10/2023,"ClassCert",True,"ClassCurve",3.5)

F.Data.DataTable.SetSeries("dtClass","ClassID",101,100)
```

**Example -- date series** (sets ClassDate to 4/19/2023, 4/19/2024, 4/19/2025, 4/19/2026):
```
F.Data.DataTable.SetSeries("dtClass","ClassDate",4/19/2023,1,"yyyy")
```

### Compute

```
F.Data.DataTable.Compute(DataTableName, Expression, Filter, ReturnValue)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `Expression` (String) -- aggregate expression to evaluate (e.g. `SUM(ColName)`, `COUNT(ColName)`, `MIN(ColName)`, `MAX(ColName)`, `AVG(ColName)`)
- `Filter` (String) -- row filter using DataTable filter syntax; use empty string `""` for no filter. String literals inside the filter use single quotes (e.g. `"Title = 'Consultant'"`)
- `ReturnValue` (Any) -- variable that receives the computed result

**Example:**
```
V.Local.fTotal.Declare(Float)

F.Data.DataTable.Create("Instructors",True)
F.Data.DataTable.AddColumn("Instructors","Name","String")
F.Data.DataTable.AddColumn("Instructors","Title","String")
F.Data.DataTable.AddColumn("Instructors","Classes","Long")

F.Data.DataTable.AddRow("Instructors","Name","Ryan Young","Title","Manager","Classes",2)
F.Data.DataTable.AddRow("Instructors","Name","Jan Ortiz","Title","Consultant","Classes",1)
F.Data.DataTable.AddRow("Instructors","Name","Josh Withrow","Title","Consultant","Classes",4)
F.Data.DataTable.AddRow("Instructors","Name","Sarah Crow","Title","Programmer/Analyst","Classes",4)
F.Data.DataTable.AddRow("Instructors","Name","Chris Okamuro","Title","Chief Technology Officer","Classes",3)

'Sum of Classes where Title = 'Consultant' → returns 5
F.Data.DataTable.Compute("Instructors","SUM(Classes)","Title = 'Consultant'",V.Local.fTotal)
F.Intrinsic.UI.Msgbox(V.Local.fTotal)

F.Data.DataTable.Close("Instructors")
```

### Select

```
F.Data.DataTable.Select(DataTableName, Expression, Return)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `Expression` (String) -- filter expression using [Expression Syntax](#expression-syntax) (e.g. `"Order_No = '0000005'"`)
- `Return` (String) -- receives the matching row data, delimited by `*!*`

**Example:**
```
V.Local.sFilter.Declare(String)
V.Local.sResult.Declare(String)
V.Local.sFilter.Set("Order_No='0000005'")

F.Data.DataTable.Select("dtOrderHeader", V.Local.sFilter, V.Local.sResult)
```

### ColumnToString

```
F.Data.DataTable.ColumnToString(DataTableName, ColumnName, Return)
```

- `DataTableName` (String) -- name of the DataTable
- `ColumnName` (String) -- name of the column to serialize
- `Return` (String) -- output; all values from the specified column, delimited with `*!*`

Serializes every value in a single column into a `*!*`-delimited string.

**Example:**

```
V.Local.sDT.Declare(String,"dtParts")
V.Local.sCol.Declare(String,"PartNo")
V.Local.sResult.Declare(String)
F.Data.DataTable.ColumnToString(V.Local.sDT, V.Local.sCol, V.Local.sResult)
' V.Local.sResult might contain: "0025*!*0026*!*0027"
```

### RunningTotal / AddRunningTotalColumn

```
F.Data.DataTable.RunningTotal(DataTableName, SourceColumn, InitialValue, Operator, TargetColumn)
F.Data.DataTable.AddRunningTotalColumn(DataTableName, SourceColumn, InitialValue, Operator, TargetColumn)
```

`AddRunningTotalColumn` is an exact alias -- both route to the same runtime function.

- `DataTableName` (String) -- name of the DataTable
- `SourceColumn` (String) -- column to evaluate against
- `InitialValue` (Float) -- starting value for the running total
- `Operator` (String) -- arithmetic operator: `"+"`, `"-"`, `"*"`, or `"/"`
- `TargetColumn` (String) -- column that receives the cumulative running total. The target column **must be created beforehand** with `AddColumn`; this function does not create it.

> **Notes:**
> - `DBNull` values in the source column are treated as `0` for `+` and `-`. For `*`, a null zeros out the accumulator. For `/`, a null or zero resets the accumulator to `0` (no division-by-zero error).
> - Non-numeric values in the source column raise runtime error 20460.
> - Invalid operator values (anything other than `+`, `-`, `*`, `/`) raise runtime error 1019.
> - Deleted rows (from `DeleteRow`) are skipped during calculation.

**Example:**

```
F.Data.DataTable.CreateFromSQL("dtOrders","con","SELECT ORDER_ID, ORDER_TOTAL FROM ORDERS WHERE STATUS = 'SHIPPED' ORDER BY ORDER_DATE")
F.Data.DataTable.AddColumn("dtOrders","RunningTotal","Float")
F.Data.DataTable.AddRunningTotalColumn("dtOrders","ORDER_TOTAL",0,"+","RunningTotal")

' dtOrders now has a RunningTotal column:
'   Row 0: ORDER_TOTAL=100, RunningTotal=100
'   Row 1: ORDER_TOTAL=250, RunningTotal=350
'   Row 2: ORDER_TOTAL=75,  RunningTotal=425

F.Data.DataTable.Close("dtOrders")
```

### DateDiff

```
F.Data.DataTable.DateDiff(DataTableName, DateColumn1, DateColumn2, Interval, TargetColumn, [iVWD])
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `DateColumn1` (String) -- first date column name (start date)
- `DateColumn2` (String) -- second date column name (end date)
- `Interval` (String) -- unit of measurement for the difference:

| Code | Unit |
|------|------|
| `YYYY` | Year |
| `Q` | Quarter |
| `M` | Month |
| `Y` | Day of Year |
| `D` | Day |
| `W` | Weekday |
| `WW` | Week |
| `H` | Hour |
| `N` | Minute |
| `S` | Second |

- `TargetColumn` (String) -- column that receives the computed difference
- `iVWD` (Long, optional) -- weekday mask, used only when `Interval` is `"W"`. Sum the values to include multiple days:

| Value | Day |
|-------|-----|
| 1 | Sunday |
| 2 | Monday |
| 4 | Tuesday |
| 8 | Wednesday |
| 16 | Thursday |
| 32 | Friday |
| 64 | Saturday |

**Example -- count Saturdays between two dates:**
```
F.Data.DataTable.Create("dtExample", True)
F.Data.DataTable.AddColumn("dtExample","Date1","String")
F.Data.DataTable.AddColumn("dtExample","Date2","String")
F.Data.DataTable.AddColumn("dtExample","Saturdays","Long")

F.Data.DataTable.AddRow("dtExample","Date1","03/01/2024","Date2","3/30/2024")
F.Data.DataTable.AddRow("dtExample","Date1","04/01/2024","Date2","5/30/2024")
F.Data.DataTable.AddRow("dtExample","Date1","05/01/2024","Date2","05/10/2024")

F.Data.DataTable.DateDiff("dtExample","Date1","Date2","W","Saturdays",64)
```

### DateAdd

```
F.Data.DataTable.DateAdd(DataTableName, DateColumn, IntervalType, IntervalColumn, TargetColumn, [WorkDayMask])
```

- `DataTableName` (String) -- name of the DataTable
- `DateColumn` (String) -- column containing the base date
- `IntervalType` (String) -- unit of the interval to add:

| Code | Unit |
|------|------|
| `yyyy` | Year |
| `q` | Quarter |
| `m` | Month |
| `y` | Day of Year |
| `d` | Day |
| `w` | Weekday |
| `ww` | Week |
| `h` | Hour |
| `n` | Minute |
| `s` | Second |

- `IntervalColumn` (String) -- column containing the number of intervals to add
- `TargetColumn` (String) -- column that receives the resulting date
- `WorkDayMask` (Long, optional) -- used only when `IntervalType` is `"w"`. Specifies which days count as workdays by summing:

| Value | Day |
|-------|-----|
| 1 | Sunday |
| 2 | Monday |
| 4 | Tuesday |
| 8 | Wednesday |
| 16 | Thursday |
| 32 | Friday |
| 64 | Saturday |

Monday--Friday (value 62) is the default when no mask is specified.

**Example:**

```
F.Data.DataTable.Create("DtEmployee", True)
F.Data.DataTable.AddColumn("DtEmployee","Name","String")
F.Data.DataTable.AddColumn("DtEmployee","JoinDate","Date")
F.Data.DataTable.AddColumn("DtEmployee","IntervalColumn","Long")
F.Data.DataTable.AddColumn("DtEmployee","TargetColumn","Date")

F.Data.DataTable.AddRow("DtEmployee","Name","James","JoinDate",V.Ambient.Now,"IntervalColumn",1)

F.Data.DataTable.DateAdd("DtEmployee","JoinDate","d","IntervalColumn","TargetColumn")
```

### AddRowChangedEventHandler

```
F.Data.DataTable.AddRowChangedEventHandler(DataTableName, SubroutineName)
```

- `DataTableName` (String) -- name of the DataTable (or `TableName$SubTableName` for sub-tables)
- `SubroutineName` (String) -- name of the subroutine to call when a row changes

The event handler subroutine receives the following `V.Args`:

| V.Args | Type | Description |
|--------|------|-------------|
| `V.Args.Name` | String | Table name (or `Table$SubTable`) |
| `V.Args.UID` | Long | Callstack ID of the DataTable (`-1` for global scope) |
| `V.Args.RowState` | Long | Row state of the changed row |
| `V.Args.Index` | Long | Row ordinal within the DataTable |
| `V.Args.Action` | Long | The action that triggered the event |

**RowState values:**

| Value | State |
|-------|-------|
| 1 | Detached |
| 2 | Unchanged |
| 4 | Added |
| 8 | Deleted |
| 16 | Modified |

**Action values:**

| Value | Action |
|-------|--------|
| 0 | Nothing -- the row has not changed |
| 1 | Delete -- the row was deleted from the table |
| 2 | Change -- the row has changed |
| 4 | Rollback -- the most recent change has been rolled back |
| 8 | Commit -- the changes have been committed |
| 16 | Add -- the row has been added to the table |
| 32 | ChangeOriginal -- the original version has been changed |
| 64 | ChangeCurrentAndOriginal -- both original and current versions have been changed |

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
F.Data.DataTable.AddRowChangedEventHandler(V.Local.sDT, "OnRowChanged")
```

### AddTable

```
F.Data.DataTable.AddTable(DataTableName, SubTableName)
```

- `DataTableName` (String) -- name of the parent DataTable
- `SubTableName` (String) -- name for the child/sub-table

Adds a child table to the DataTable, creating a hierarchical `TableName$SubTableName` structure.

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
V.Local.sSub.Declare(String,"dtOrderLines")
F.Data.DataTable.AddTable(V.Local.sDT, V.Local.sSub)
```

### SetValueOnNextLine

```
F.Data.DataTable.SetValueOnNextLine(DataTableName, SourceColumn, TargetColumn, [KeyColumn])
```

- `DataTableName` (String) -- name of the DataTable
- `SourceColumn` (String) -- column whose value is copied from the next row
- `TargetColumn` (String) -- column that receives the value
- `KeyColumn` (String, optional) -- when specified, the "next line" lookup resets within each group defined by this column

For each row, copies the value of `SourceColumn` from the *next* row into `TargetColumn` on the current row. Useful for calculating differences between consecutive rows (e.g. time gaps, running deltas).

**Example:**

```
V.Local.sDT.Declare(String,"dtSchedule")
V.Local.sSrc.Declare(String,"StartDate")
V.Local.sTgt.Declare(String,"NextStartDate")
V.Local.sKey.Declare(String,"DeptCode")
F.Data.DataTable.SetValueOnNextLine(V.Local.sDT, V.Local.sSrc, V.Local.sTgt, V.Local.sKey)
```

### CaseSensitive

```
F.Data.DataTable.CaseSensitive(DataTableName, CaseSensitive)
```

- `DataTableName` (String) -- name of the DataTable
- `CaseSensitive` (Boolean) -- `True` to make string comparisons case-sensitive, `False` for case-insensitive (default)

Controls whether string operations (Select, Compute, expression filters) on this DataTable are case-sensitive.

**Example:**

```
V.Local.sDT.Declare(String,"dtParts")
F.Data.DataTable.CaseSensitive(V.Local.sDT, True)
```

### SetPK

```
F.Data.DataTable.SetPK(DataTableName, Column0 [, ColumnN ...])
F.Data.DataTable.SetPK()
```

- `DataTableName` (String) -- name of the DataTable
- `Column0` (String) -- first primary-key column name
- `ColumnN` (String, optional) -- additional primary-key column names (repeatable)

Designates one or more columns as the primary key. The no-argument overload `SetPK()` removes primary keys from all DataTables.

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
V.Local.sCol1.Declare(String,"OrderNo")
V.Local.sCol2.Declare(String,"LineNo")
F.Data.DataTable.SetPK(V.Local.sDT, V.Local.sCol1, V.Local.sCol2)

' Remove all primary keys
F.Data.DataTable.SetPK()
```

### Clear

```
F.Data.DataTable.Clear(DataTableName)
```

- `DataTableName` (String) -- name of the DataTable

Removes all rows from the DataTable. RowState will **not** be updated to `Deleted` -- rows are simply removed.

**Example:**

```
V.Local.sDT.Declare(String,"dtOrders")
F.Data.DataTable.Clear(V.Local.sDT)
```

## Merge & Relations
```
F.Data.DataTable.Merge("srcDT","destDT",False,2)
F.Data.DataTable.AddRelation("dtParent","ParentKey","dtChild","ChildKey",sRelName)
F.Data.DataTable.FillFromDictionary("dtName","dictName","SrcCol")           ' Replace source in-place
F.Data.DataTable.FillFromDictionary("dtName","dictName","SrcCol","TargetCol") ' Write to separate column
F.Data.DataTable.Close("dtName")
```

### Merge

```
F.Data.DataTable.Merge(SourceDataTableName, TargetDataTableName, PreserveChanges, MergeMode)
```

**Parameters:**
- `SourceDataTableName` (String) -- DataTable to merge **from**
- `TargetDataTableName` (String) -- DataTable to merge **into**
- `PreserveChanges` (Boolean) -- `True` to preserve pending changes in the target DataTable; `False` to overwrite them
- `MergeMode` (Long) -- controls how schema mismatches between source and target are handled:

| Mode | Name | Behavior |
|------|------|----------|
| 1 | Add | Adds the necessary columns to complete the schema |
| 2 | Ignore | Ignores extra columns in the source |
| 3 | Error | Raises a runtime error if a column mapping is missing |
| 4 | AddWithKey | Adds necessary columns **and** primary key information. Incoming records that match existing records by key are updated instead of appended |

**Example:**
```
V.Local.sSrc.Declare(String,"SourceDataTable")
V.Local.sTgt.Declare(String,"TargetDataTable")
V.Local.bPreserve.Declare(Boolean,True)
V.Local.iMode.Declare(Long,1)

F.Data.DataTable.Merge(V.Local.sSrc, V.Local.sTgt, V.Local.bPreserve, V.Local.iMode)
```

### AddRelation

```
F.Data.DataTable.AddRelation(ParentDataTable, ParentColumn, ChildDataTable, ChildColumn, [RelationshipName])
```

**Parameters:**
- `ParentDataTable` (String) -- name of the parent DataTable
- `ParentColumn` (String) -- key column(s) in the parent table. Delimit multiple columns with `*!*`
- `ChildDataTable` (String) -- name of the child DataTable. **Must** use the `dtParent$dtChild` naming convention (see note below)
- `ChildColumn` (String) -- key column(s) in the child table. Delimit multiple columns with `*!*`
- `RelationshipName` (String, optional) -- name for the relationship

> **CRITICAL — Child DataTable naming:** A DataTable that will be used as a child in `AddRelation` **must** be created with the `$` prefix naming convention: `dtParent$dtChild`. The `$` links the child to its parent and must be present at creation time — not added later.
>
> ```
> F.Data.DataTable.CreateFromSQL("dtStaging$dtStagExpand","conInit",V.Local.sSQL,True)
> ```
>
> **Incorrect** — creating the child without the `$` prefix will not establish the parent-child link:
> ```
> F.Data.DataTable.CreateFromSQL("dtStagExpand","conInit",V.Local.sSQL,True)
> ```

**Example** -- composite key relation from the Standard Shipping Dashboard:
```
F.Data.DataTable.AddRelation("dtStaging","PCK_NO*!*ORDER_NO","dtStaging$dtStagExpand","PCK_NO*!*ORDER_NO")
```

> **CRITICAL:** When `F.Data.DataTable.AddRelation` has been established between a parent and child DataTable, the grid-level `Gui.<Form>.gsGC.AddRelation` is **redundant** and should **not** be used. The DataTable-level relation is sufficient; the grid automatically inherits it. Adding both will cause unexpected behavior.

> **CRITICAL -- Referential Integrity:** `AddRelation` enforces a foreign-key constraint: every child row MUST have a matching parent row on the relation columns. If even one orphan child row exists, the call fails with `Error 21034 - DDataTableAddRelation error: This constraint cannot be enabled as not all values have corresponding parent values`. When the child data source may contain orphan rows, use an `INNER JOIN` in the child `CreateFromSQL` query to pre-filter to only matching parent records:
> ```
> ' Wrong -- child may contain orphan rows not in parent:
> F.Data.DataTable.CreateFromSQL("dtParent$dtChild","con","SELECT * FROM CHILD_TABLE",True)
>
> ' Correct -- INNER JOIN guarantees every child row has a parent:
> F.Data.DataTable.CreateFromSQL("dtParent$dtChild","con","SELECT C.* FROM CHILD_TABLE C INNER JOIN PARENT_TABLE P ON C.KEY_COL = P.KEY_COL",True)
> ```

### FillFromDictionary

Two overloads:
```
F.Data.DataTable.FillFromDictionary(DataTableName, DictionaryName, SourceField)
F.Data.DataTable.FillFromDictionary(DataTableName, DictionaryName, SourceField, TargetField)
```

**Parameters:**
- `DataTableName` (String) -- name of the DataTable
- `DictionaryName` (String) -- name of the Dictionary to look up values from
- `SourceField` (String) -- column whose values are used as dictionary keys. With the 3-param overload, the looked-up values **replace** the source column in-place
- `TargetField` (String, optional) -- column that receives the looked-up values, leaving the source column unchanged

**Example -- in-place replacement** (3-param: `WeekDay` "4" becomes "Wednesday"):
```
F.Data.DataTable.Create("datatable")
F.Data.DataTable.AddColumn("datatable","WeekDay","String")
F.Data.DataTable.AddRow("datatable","WeekDay","4")
F.Data.DataTable.AddRow("datatable","WeekDay","7")
F.Data.DataTable.AddRow("datatable","WeekDay","5")
F.Data.DataTable.AddRow("datatable","WeekDay","3")
F.Data.DataTable.AddRow("datatable","WeekDay","1")
F.Data.DataTable.AddRow("datatable","WeekDay","4")

F.Data.Dictionary.Create("dictionary")
F.Data.Dictionary.AddItem("dictionary",1,"Sunday")
F.Data.Dictionary.AddItem("dictionary",2,"Monday")
F.Data.Dictionary.AddItem("dictionary",3,"Tuesday")
F.Data.Dictionary.AddItem("dictionary",4,"Wednesday")
F.Data.Dictionary.AddItem("dictionary",5,"Thursday")
F.Data.Dictionary.AddItem("dictionary",6,"Friday")
F.Data.Dictionary.AddItem("dictionary",7,"Saturday")

F.Data.DataTable.FillFromDictionary("datatable","dictionary","WeekDay")
```

**Example -- separate target column** (4-param: `WeekDay` stays numeric, `WeekName` gets the day name):
```
F.Data.DataTable.Create("datatable")
F.Data.DataTable.AddColumn("datatable","WeekDay","Long")
F.Data.DataTable.AddColumn("datatable","WeekName","String")
F.Data.DataTable.AddRow("datatable","WeekDay",4)
F.Data.DataTable.AddRow("datatable","WeekDay",7)
F.Data.DataTable.AddRow("datatable","WeekDay",5)
F.Data.DataTable.AddRow("datatable","WeekDay",3)
F.Data.DataTable.AddRow("datatable","WeekDay",1)
F.Data.DataTable.AddRow("datatable","WeekDay",4)

F.Data.Dictionary.Create("dictionary")
F.Data.Dictionary.AddItem("dictionary",1,"Sunday")
F.Data.Dictionary.AddItem("dictionary",2,"Monday")
F.Data.Dictionary.AddItem("dictionary",3,"Tuesday")
F.Data.Dictionary.AddItem("dictionary",4,"Wednesday")
F.Data.Dictionary.AddItem("dictionary",5,"Thursday")
F.Data.Dictionary.AddItem("dictionary",6,"Friday")
F.Data.Dictionary.AddItem("dictionary",7,"Saturday")

F.Data.DataTable.FillFromDictionary("datatable","dictionary","WeekDay","WeekName")
```

### Clone

```
F.Data.DataTable.Clone(SourceDataTableName, TargetDataTableName)
F.Data.DataTable.Clone(SourceDataTableName, TargetDataTableName, GlobalScope)
```

- `SourceDataTableName` (String) -- name of the DataTable to clone from
- `TargetDataTableName` (String) -- name for the new DataTable copy
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` for local scope

Copies the structure and data of the source DataTable into a new DataTable.

**Example:**

```
V.Local.sSrc.Declare(String,"dtOriginal")
V.Local.sTgt.Declare(String,"dtCopy")
F.Data.DataTable.Clone(V.Local.sSrc, V.Local.sTgt, True)
```

### Close

```
F.Data.DataTable.Close(DataTableName)
```

- `DataTableName` (String) -- name of the DataTable to destroy

Permanently removes the DataTable and all its data from memory. After calling `Close`, the DataTable name is no longer valid.

**Example:**

```
V.Local.sDT.Declare(String,"dtTemp")
F.Data.DataTable.Close(V.Local.sDT)
```

## Expression Syntax

Expressions are used by `AddExpressionColumn`, `Compute`, `Select`, and filter parameters. The syntax follows the .NET `DataColumn.Expression` rules.

> **IMPORTANT:** This expression mini-language is **NOT GAB statement syntax**. Operators like `+`, `-`, `*`, `/`, `%` are valid **only inside expression strings** passed to DataTable/DataView filter, sort, compute, and expression column APIs. In GAB statements (outside expression strings), arithmetic operators are prohibited -- use `F.Intrinsic.Math.*` functions instead. See `agents/AGENTS.GAB.md` > ANTI-PATTERNS.

### Column References

Refer to columns by name. If the name contains non-alphanumeric characters, starts with a digit, or matches a reserved word (`And`, `Between`, `Child`, `False`, `In`, `Is`, `Like`, `Not`, `Null`, `Or`, `Parent`, `True`), wrap it in square brackets or grave accents:
```
[UnitPrice] * [Quantity]
Total * [Column#]
Total * `Column#`
```

Inside square brackets, escape `]` and `\` with a backslash: `[Column[\]\\]`. Grave-accent-wrapped names must not contain grave accents.

### Literals

| Kind | Format | Examples |
|------|--------|----------|
| String | Single quotes (double-up internal quotes) | `'John'`, `'O''Brien'` |
| Date | `#` delimiters or single quotes | `#1/31/82#`, `'1/31/82'` |
| Boolean | Unquoted keywords | `True`, `False` |
| Integer | Optional sign + digits | `42`, `-7` |
| Decimal | Digits with decimal point | `142526.14` |
| Scientific | Mantissa + E + exponent | `4.42372E-30` |

All literal expressions use the **invariant culture** locale regardless of the current culture.

### Comparison Operators

`<`  `>`  `<=`  `>=`  `<>`  `=`  `IN`  `LIKE`

### Arithmetic Operators

`+` (addition / string concatenation)  `-` (subtraction)  `*` (multiplication)  `/` (division)  `%` (modulus)

### Logical Operators

`AND`  `OR`  `NOT` -- use parentheses to force precedence. `AND` binds tighter than `OR`:
```
(LastName = 'Smith' OR LastName = 'Jones') AND FirstName = 'John'
```

### Wildcard Characters (LIKE)

`*` and `%` are interchangeable wildcards. Allowed at the start and/or end of a pattern, **not** in the middle. Escape literal `*` or `%` with brackets:
```
"ItemName LIKE '*product*'"
"ItemName LIKE '*product'"
"ItemName LIKE 'product*'"
```

String comparison case-sensitivity is controlled by the DataTable's `CaseSensitive` property.

### Aggregate Functions

| Function | Description |
|----------|-------------|
| `Sum` | Sum |
| `Avg` | Average |
| `Min` | Minimum |
| `Max` | Maximum |
| `Count` | Count |
| `StDev` | Statistical standard deviation |
| `Var` | Statistical variance |

Aggregates can operate on a single table (`Sum(Price)`) or across parent/child relations (`Avg(Child.Price)`). On a single table, all rows return the same aggregated value (no group-by). If the table has no rows, aggregates return null.

### Parent / Child Relation Referencing

```
Parent.ColumnName                         ' Single parent relation
Parent(RelationName).ColumnName           ' Disambiguate multiple parents
Sum(Child.ColumnName)                     ' Child column (must use aggregate)
Avg(Child(RelationName).ColumnName)       ' Disambiguate multiple children
```

### Built-in Functions

**CONVERT** -- cast to a .NET type:
```
Convert(expression, 'System.Int32')
```

**LEN** -- string length:
```
Len(ItemName)
```

**ISNULL** -- null coalescing:
```
IsNull(price, -1)
```

**IIF** -- conditional:
```
IIF(total > 1000, 'expensive', 'dear')
```

**TRIM** -- remove leading/trailing whitespace (`\r`, `\n`, `\t`, space):
```
Trim(ItemName)
```

**SUBSTRING** -- extract sub-string (**1-based** start index):
```
SUBSTRING([phone], 1, 3)    ' "123-4567" → "123"
```

---

# DATAVIEW SYSTEM

DataViews are filtered/sorted views of DataTables.

**CRITICAL: DataView filter strings use single quotes for string values. If data values may contain single quotes (e.g., part numbers like `ABC'S`), escape them by doubling: `''`. Use `F.Intrinsic.String.Replace(sValue, "'", "''", sEscaped)` before embedding in a filter expression. Unescaped quotes cause error 21056 "Syntax error: Missing operand".**

Supported filter operators: `<`, `>`, `<=`, `>=`, `<>`, `=`, `IN`, `LIKE`, `AND`, `OR`, `NOT`

```
F.Data.DataView.Create("dtName","dvName",22,"FilterExpr","SortCol")
F.Data.DataView.Create("dtName","dvName",22,"Col1 = 'value' AND Col2 > 0","Col1 ASC")
F.Data.DataView.SetFilter("dtName","dvName","NewFilter")
F.Data.DataView.SetSort("dtName","dvName","ColName ASC")
F.Data.DataView.SetRowView("dtName","dvName",22)                      ' Change visible row states
F.Data.DataView.SetValue("dtName","dvName",iRow,"ColName","value")
F.Data.DataView.SetValue("dtName","dvName",-1,"ColName","value")    ' All rows
F.Data.DataView.SetSeries("dtName","dvName","ColName",1,1,1)           ' Numeric auto-increment in view
F.Data.DataView.SetSeries("dtName","dvName","DateCol",4/1/2024,4/1/2024,1,"yyyy") ' Date series in view
F.Data.DataView.DeleteRow("dtName","dvName",iRow)                   ' Delete row from view
F.Data.DataView.FillFromDictionary("dtName","dvName","dictName","SrcCol","TargetCol") ' Dictionary lookup
F.Data.DataView.Close("dtName","dvName")

' Access
V.DataView.dtName!dvName.Exists                        ' True if dataview exists
V.DataView.dtName!dvName.RowCount                      ' Count of rows in the view
V.DataView.dtName!dvName.RowCount--                    ' Count of rows minus 1 (last 0-based index)
V.DataView.dtName!dvName(0).ColName!FieldVal                       ' String value at row 0
V.DataView.dtName!dvName(0).ColName!FieldValTrim                   ' Trimmed string
V.DataView.dtName!dvName(0).ColName!FieldValFloat                  ' Float value
V.DataView.dtName!dvName(0).ColName!FieldValLong                   ' Long value
V.DataView.dtName!dvName(0).ColName!FieldValNot                    ' Negated boolean
V.DataView.dtName!dvName(0).ColName!FieldValString                 ' Explicit string conversion
V.DataView.dtName!dvName(0).ColName!FieldValIsNull                 ' True if value is null
V.DataView.dtName!dvName(0).ColName!FieldValLTrim                  ' Left-trimmed string
V.DataView.dtName!dvName(0).ColName!FieldValRTrim                  ' Right-trimmed string
V.DataView.dtName!dvName(0).ColName!FieldValLcTrim                 ' Lowercase + trimmed
V.DataView.dtName!dvName(0).ColName!FieldValLcRTrim                ' Lowercase + right-trimmed
V.DataView.dtName!dvName(0).ColName!FieldValUcTrim                 ' Uppercase + trimmed
V.DataView.dtName!dvName(0).ColName!FieldValUcRTrim                ' Uppercase + right-trimmed
V.DataView.dtName!dvName(0).ColName!FieldValPervasiveDate          ' Date formatted for Pervasive SQL
V.DataView.dtName!dvName(0).ColName!FieldValPercentToDecimal       ' Percentage to decimal conversion
V.DataView.dtName!dvName(0).ColName!FieldValStringPSqlFriendly     ' String escaped for Pervasive SQL
V.DataView.dtName!dvName(0).ColName!FieldValStringMsSqlFriendly    ' String escaped for SQL Server
V.DataView.[V.Args.DataTable]![V.Local.sDV](V.Local.i).[V.Local.sCol]!FieldValTrim  ' Dynamic access

' Convert
F.Data.DataView.ToDataTable("dtName","dvName","newDTName")
F.Data.DataView.ToDataTableDistinct("dtName","dvName","newDTName","Col1*!*Col2",True)
F.Data.DataView.ToString("dtName","dvName",V.Ambient.NewLine,"','",sResult)         ' All columns
F.Data.DataView.ToString("dtName","dvName","Col1*!*Col2",V.Ambient.NewLine,"','",sResult) ' Specific columns
```

**Bracket `[ ]` syntax -- variable indirection:** Same rule as DataTable. Use brackets **only** when the DataTable name, DataView name, or column name is stored in a variable.
```
' Literal names -- NO brackets
V.DataView.dtOrders!dvFiltered(0).PartNumber!FieldValTrim

' Names from variables -- bracket each variable segment
V.DataView.[V.Args.DataTable]![V.Local.sDV](V.Local.i).[V.Local.sCol]!FieldValTrim
```

### Create

```
F.Data.DataView.Create(DataTableName, DataViewName, RowViewMask, [Filter], [Sort])
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name for the new DataView
- `RowViewMask` (Long, **required**) -- bitmask controlling which row states are visible (see [SetRowView](#setrowview) for the full value table; `22` = CurrentRows is the standard default). Always pass this parameter explicitly -- use `22` when you want all current rows.
- `Filter` (String, optional) -- filter expression using [Expression Syntax](#expression-syntax). String literals use single quotes; escape embedded quotes by doubling (`''`). Pass `""` for no filter.
- `Sort` (String, optional) -- sort expression: column name + `ASC` or `DESC` (e.g. `"[Class_Date] DESC"`). Pass `""` for no sort.

**Example:**
```
F.Data.DataTable.Create("Instructors",True)
F.Data.DataTable.AddColumn("Instructors","Name","String")
F.Data.DataTable.AddColumn("Instructors","Title","String")
F.Data.DataTable.AddColumn("Instructors","Class_Date","Date")

F.Data.DataTable.AddRow("Instructors","Name","Ryan Young","Title","Manager","Class_Date","04/04/2023")
F.Data.DataTable.AddRow("Instructors","Name","Jan Ortiz","Title","Consultant","Class_Date","04/04/2023")
F.Data.DataTable.AddRow("Instructors","Name","Josh Withrow","Title","Consultant","Class_Date","04/06/2023")
F.Data.DataTable.AddRow("Instructors","Name","Sarah Crow","Title","Programmer/Analyst","Class_Date","04/06/2023")
F.Data.DataTable.AddRow("Instructors","Name","John Davis","Title","Chief Technology Officer","Class_Date","04/06/2016")

F.Data.DataView.Create("Instructors","InstructorsDV",22,"[TITLE] = 'Consultant'","[Class_Date] desc")
```

> **Apostrophe escaping:** If a data value contains an apostrophe, double it in the filter string. For example, to filter for `Title` = `Consultant'`:
> ```
> F.Data.DataView.Create("Instructors","InstructorsDV",22,"[TITLE] = 'Consultant'''","[Class_Date] DESC")
> ```
> The `''` inside the filter is interpreted as a literal single quote.

### SetFilter

```
F.Data.DataView.SetFilter(DataTableName, DataViewName, Filter)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `Filter` (String) -- new filter expression, replacing the current filter. Uses the same [Expression Syntax](#expression-syntax) as DataTable expressions

**Literal value rules:**
- Strings: enclose in single quotes -- `"FirstName = 'John'"`
- Dates: enclose in `#` signs -- `"Birthdate < #1/31/82#"`
- Numerics: decimals and scientific notation are valid -- `"Price <= 50.00"`

Supports all comparison operators (`<`, `>`, `<=`, `>=`, `<>`, `=`, `IN`, `LIKE`), logical operators (`AND`, `OR`, `NOT`), arithmetic operators (`+`, `-`, `*`, `/`, `%`), wildcards (`*`/`%` with `LIKE`), and aggregate functions (`Sum`, `Avg`, `Min`, `Max`, `Count`, `StDev`, `Var`).

**Example:**
```
F.Data.DataView.SetFilter("dtName","dvName","FirstName = 'John'")
```

### SetSort

```
F.Data.DataView.SetSort(DataTableName, DataViewName, Sort)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `Sort` (String) -- sort expression: column name followed by `ASC` (ascending) or `DESC` (descending). Multiple columns can be comma-separated (e.g. `"Col1 ASC, Col2 DESC"`)

**Example:**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
V.Local.sSort.Declare(String,"PartNo ASC")
F.Data.DataView.SetSort(V.Local.sDT, V.Local.sDV, V.Local.sSort)
```

### SetRowView

```
F.Data.DataView.SetRowView(DataTableName, DataViewName, RowViewMask)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `RowViewMask` (Long) -- bitmask controlling which row states are visible in the DataView. This is the same value used as the third parameter of `DataView.Create`. Standard values (based on .NET `DataViewRowState`):

| Value | Name | Shows |
|-------|------|-------|
| 0 | None | No rows |
| 2 | Unchanged | Unchanged rows |
| 4 | New | Newly added rows |
| 8 | Deleted | Deleted rows |
| 16 | ModifiedCurrent | Modified rows (current values) |
| 22 | CurrentRows | All current rows -- Unchanged + New + ModifiedCurrent (default) |
| 32 | ModifiedOriginal | Modified rows (original values) |
| 42 | OriginalRows | Unchanged + Deleted + ModifiedOriginal |

Values are combinable by summing (e.g. `22` = 2 + 4 + 16 = all current, non-deleted rows).

**Example:**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
V.Local.iMask.Declare(Long,22)
F.Data.DataView.SetRowView(V.Local.sDT, V.Local.sDV, V.Local.iMask)
```

### SetValue

```
F.Data.DataView.SetValue(DataTableName, ViewName, RowNumber, Column0Name, Column0Value [, ColumnNName, ColumnNValue ...])
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `ViewName` (String) -- name of the DataView
- `RowNumber` (Long) -- zero-based row index within the view, or **`-1` to update all rows** in the view
- `Column0Name` (String) -- name of the first column to update
- `Column0Value` (Any) -- new value for the first column
- `ColumnNName` (String) -- name of an additional column *(repeat as needed)*
- `ColumnNValue` (Any) -- new value for that column *(repeat as needed)*

Column name/value pairs repeat for as many columns as you want to update in a single call.

**Example:**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
V.Local.iRow.Declare(Long)
V.Local.sCol.Declare(String)
V.Local.sVal.Declare(String)

'Update a specific row
F.Data.DataView.SetValue(V.Local.sDT, V.Local.sDV, V.Local.iRow, V.Local.sCol, V.Local.sVal)

'Update ALL rows in the view
F.Data.DataView.SetValue(V.Local.sDT, V.Local.sDV, -1, "Status", "Processed")
```

### SetSeries

Two overloads -- numeric and date:
```
F.Data.DataView.SetSeries(DataTableName, ViewName, ColumnName, InitialValue, StartingValue, Interval)
F.Data.DataView.SetSeries(DataTableName, ViewName, ColumnName, InitialValue, StartingValue, Interval, IntervalType)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `ViewName` (String) -- name of the DataView
- `ColumnName` (String) -- column to populate with the series
- `InitialValue` (Float, Long, or Date) -- starting value for the first row
- `StartingValue` (Float, Long, or Date) -- base value for series computation
- `Interval` (Float or Long) -- increment applied to each successive row
- `IntervalType` (String) -- **required for date columns only**; same codes as `DataTable.SetSeries`:

| Code | Unit | Rounding |
|------|------|----------|
| `d` | Day | Truncated to integral value |
| `y` | Day | Truncated to integral value |
| `h` | Hour | Rounded to nearest millisecond |
| `n` | Minute | Rounded to nearest millisecond |
| `m` | Month | Truncated to integral value |
| `q` | Quarter | Truncated to integral value |
| `s` | Second | Rounded to nearest millisecond |
| `w` | Weekday | Truncated to integral value |
| `ww` | Week | Truncated to integral value |
| `yyyy` | Year | Truncated to integral value |

> **CRITICAL:** `SetSeries` writes values **only** to rows within the DataView, overwriting existing column values. Rows in the underlying DataTable that are not in the DataView are **unaffected** and will have no value for the column unless a default was set via `AddColumn` or `SetValue` with row `-1` was used beforehand.

**Example -- numeric (Float):**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
V.Local.sCol.Declare(String)
V.Local.fInit.Declare(Float)
V.Local.fStart.Declare(Float)
V.Local.fInterval.Declare(Float)
F.Data.DataView.SetSeries(V.Local.sDT, V.Local.sDV, V.Local.sCol, V.Local.fInit, V.Local.fStart, V.Local.fInterval)
```

**Example -- date (yearly increment):**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
V.Local.sCol.Declare(String)
V.Local.dInit.Declare(Date)
V.Local.dStart.Declare(Date)
V.Local.iInterval.Declare(Long)
V.Local.sType.Declare(String,"yyyy")
F.Data.DataView.SetSeries(V.Local.sDT, V.Local.sDV, V.Local.sCol, V.Local.dInit, V.Local.dStart, V.Local.iInterval, V.Local.sType)
```

### DeleteRow

```
F.Data.DataView.DeleteRow(DataTableName, DataViewName, RowNumber)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `RowNumber` (Long) -- zero-based row index within the view to delete

The row is marked as deleted in the underlying DataTable (same RowState behavior as `DataTable.DeleteRow`). Use `SaveToDB` with a mode including flag 4 to synchronize the deletion to the database, then `AcceptChanges` to finalize.

**Example:**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
V.Local.iRow.Declare(Long)
F.Data.DataView.DeleteRow(V.Local.sDT, V.Local.sDV, V.Local.iRow)
```

### FillFromDictionary

```
F.Data.DataView.FillFromDictionary(DataTableName, DataViewName, DictionaryName, Source, Target)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `DictionaryName` (String) -- name of the Dictionary to look up values from
- `Source` (String) -- column whose values are used as dictionary keys
- `Target` (String) -- column that receives the looked-up dictionary values

Only rows visible in the DataView are updated; the source column is preserved and the looked-up value is written to the target column.

**Example:**
```
F.Data.DataTable.CreateFromString("Capitals_Datatable","INDIA@New Delji,CHINA@BEIJING","Country*!*Capital","String*!*String","@",",",False)

F.Data.Dictionary.Create("Capitals_Dictionary")
F.Data.Dictionary.AddItem("Capitals_Dictionary","INDIA","New Delji--CHANGED")
F.Data.Dictionary.AddItem("Capitals_Dictionary","CHINA","Beijing--CHANGED")

F.Data.DataView.Create("Capitals_Datatable","Capitals_Dataview",22,"","")

'Capital column is overwritten with the dictionary value for each Country key
F.Data.DataView.FillFromDictionary("Capitals_Datatable","Capitals_Dataview","Capitals_Dictionary","Country","Capital")
```

### ToDataTable

> **Warning — Child DataTable source:** When the DataView was created from a child DataTable (e.g., `dtSalesOrders$dtWorkOrders`), the `SourceDataTableName` argument must be the **parent DataTable name only** -- do **not** include the `$ChildDT` suffix. This applies to all `F.Data.DataView.ToDataTable*` functions (`ToDataTable`, `ToDataTableDistinct`). It does **not** apply to `F.Data.DataView.Create`.
>
> **Incorrect:** `F.Data.DataView.ToDataTableDistinct("dtSalesOrders$dtWorkOrders", "dvConcY", "dtConcKeys", "ORDER_NO_LINE", True)`
>
> **Correct:** `F.Data.DataView.ToDataTableDistinct("dtSalesOrders", "dvConcY", "dtConcKeys", "ORDER_NO_LINE", True)`

Two overloads:
```
F.Data.DataView.ToDataTable(SourceDataTableName, DataViewName, TargetDataTableName)
F.Data.DataView.ToDataTable(SourceDataTableName, DataViewName, TargetDataTableName, GlobalScope)
```

**Parameters:**
- `SourceDataTableName` (String) -- name of the parent DataTable (do not include `$ChildDT` suffix even if the view is from a child table)
- `DataViewName` (String) -- name of the DataView to materialize
- `TargetDataTableName` (String) -- name for the new DataTable (or sub-table) created from the view's rows
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` (or omitted) for local scope

**Sub-table support:** The target name can create a sub-table using the format `TableName$SubTableName`. The primary table (`TableName`) must already exist.

**Examples:**
```
'Local scope -- create a standalone DataTable from the view
V.Local.sSrc.Declare(String)
V.Local.sDV.Declare(String)
V.Local.sTgt.Declare(String)
F.Data.DataView.ToDataTable(V.Local.sSrc, V.Local.sDV, V.Local.sTgt)

'Global scope -- create a sub-table under an existing parent
V.Local.sSrc.Declare(String)
V.Local.sDV.Declare(String)
V.Local.sTgt.Declare(String)
V.Local.bGlobal.Declare(Boolean,True)
F.Data.DataView.ToDataTable(V.Local.sSrc, V.Local.sDV, "dtStaging$dtFiltered", V.Local.bGlobal)
```

### ToDataTableDistinct

```
F.Data.DataView.ToDataTableDistinct(SourceDataTableName, DataViewName, TargetDataTableName, ColumnNames, [GlobalScope])
```

**Parameters:**
- `SourceDataTableName` (String) -- name of the parent DataTable (do not include `$ChildDT` suffix even if the view is from a child table)
- `DataViewName` (String) -- name of the DataView
- `TargetDataTableName` (String) -- name for the new DataTable containing only distinct rows
- `ColumnNames` (String) -- columns to include in the distinct check, delimited by `*!*`
- `GlobalScope` (Boolean, optional) -- `True` for global scope, `False` (or omitted) for local scope

**Example** -- get distinct first/last name combinations:
```
F.Data.DataTable.Create("dtSource",True)
F.Data.DataTable.AddColumn("dtSource","FirstName","String")
F.Data.DataTable.AddColumn("dtSource","LastName","String")
F.Data.DataTable.AddColumn("dtSource","Age","String")

F.Data.DataTable.AddRow("dtSource","FirstName","John","LastName","Doe","Age",26)
F.Data.DataTable.AddRow("dtSource","FirstName","John","LastName","Doe","Age",45)
F.Data.DataTable.AddRow("dtSource","FirstName","Aaron","LastName","Smith","Age",45)
F.Data.DataTable.AddRow("dtSource","FirstName","Tyler","LastName","Smith","Age",45)
F.Data.DataTable.AddRow("dtSource","FirstName","Shawn","LastName","Smith","Age",45)
F.Data.DataTable.AddRow("dtSource","FirstName","George","LastName","Smith","Age",45)

F.Data.DataView.Create("dtSource","dvSource",22,"","")
'dtTarget will have 5 rows (the duplicate "John Doe" is collapsed to one)
F.Data.DataView.ToDataTableDistinct("dtSource","dvSource","dtTarget","FirstName*!*LastName")
```

### ToString

Two overloads:
```
F.Data.DataView.ToString(DataTableName, DataViewName, InnerDelimiter, OuterDelimiter, Return)
F.Data.DataView.ToString(DataTableName, DataViewName, FieldList, InnerDelimiter, OuterDelimiter, Return)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView
- `FieldList` (String, optional) -- column names to include, delimited by `*!*`. When omitted (5-param form), all columns are included
- `InnerDelimiter` (String) -- character that separates fields **within** each row
- `OuterDelimiter` (String) -- character that separates **rows** from each other
- `Return` (String) -- variable that receives the serialized result

**Example -- all columns:**
```
V.Local.sResult.Declare(String)
F.Data.DataView.ToString("dtOrders","dvFiltered",V.Ambient.NewLine,"','",V.Local.sResult)
```

**Example -- specific columns:**
```
V.Local.sResult.Declare(String)
V.Local.sFields.Declare(String,"PartNo*!*Location")
F.Data.DataView.ToString("dtOrders","dvFiltered",V.Local.sFields,V.Ambient.NewLine,"','",V.Local.sResult)
```

### Close

```
F.Data.DataView.Close(DataTableName, DataViewName)
```

**Parameters:**
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView to destroy

**Example:**
```
V.Local.sDT.Declare(String)
V.Local.sDV.Declare(String)
F.Data.DataView.Close(V.Local.sDT, V.Local.sDV)
```

---

