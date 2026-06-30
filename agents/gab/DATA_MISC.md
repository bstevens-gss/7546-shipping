# GAB Dictionary, LINQ, Data Objects & Related Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with Dictionary, LINQ, GSSXML, UDTs, StringBuilder, or variable utilities
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---
# DICTIONARY

Key-value lookup structure for efficient data mapping.

## Create / Populate
```
F.Data.Dictionary.Create("dictName")
F.Data.Dictionary.Create("dictName",bGlobalScope)
F.Data.Dictionary.CreateFromSQL("dictName","con","SELECT KeyCol, ValueCol FROM Table")
F.Data.Dictionary.CreateFromSQL("dictName","con","SELECT KeyCol, ValueCol FROM Table",iFormat)
F.Data.Dictionary.CreateFromDataTable("dictName","dtName","KeyCol","ValueCol")
F.Data.Dictionary.CreateFromDataTable("dictName","dtName","KeyCol","ValueCol",iFormat)
F.Data.Dictionary.CreateFromDataTable("dictName","dtName","KeyCol","ValueCol",iFormat,bCaseSensitive)
F.Data.Dictionary.CreateFromDataView("dictName","dtName","dvName","KeyCol","ValueCol")
F.Data.Dictionary.CreateFromDataView("dictName","dtName","dvName","KeyCol","ValueCol",iFormat)
F.Data.Dictionary.AddItem("dictName","key","value")
F.Data.Dictionary.AddItem("dictName","key","value",bIgnoreDuplicates)
```

### Create

Two overloads:
```
F.Data.Dictionary.Create(DictionaryName)
F.Data.Dictionary.Create(DictionaryName, GlobalScope)
```

- `DictionaryName` (String) -- name for the new empty dictionary
- `GlobalScope` (Boolean, optional) -- `True` for global scope (persists across subroutines), `False` (or omitted) for local scope

**Examples:**

```
V.Local.sDict.Declare(String,"MyLookup")
F.Data.Dictionary.Create(V.Local.sDict)                  ' Local scope
F.Data.Dictionary.Create("LookupCaptions",True)          ' Global scope
```

### Format Bitmask (used by CreateFromSQL, CreateFromDataTable, CreateFromDataView)

| Value | Effect |
|-------|--------|
| 1 | Left trim |
| 2 | Right trim |
| 4 | Full trim |
| 8 | Lowercase |
| 16 | Uppercase |
| 32 | Proper case |

Values can be summed (e.g., 18 = uppercase + right trim).

### CreateFromSQL

```
F.Data.Dictionary.CreateFromSQL(DictionaryName, ConnectionName, SQLString)
F.Data.Dictionary.CreateFromSQL(DictionaryName, ConnectionName, SQLString, Format)
```

- `DictionaryName` (String) -- name for the new dictionary
- `ConnectionName` (String) -- name of the database connection
- `SQLString` (String) -- SQL query whose first column becomes the key and second column becomes the value
- `Format` (Long, optional) -- bitmask controlling string formatting applied to values (see [Format Bitmask](#format-bitmask-used-by-createfromsql-createfromdatatable-createfromdataview))

**Example:**

```
V.Local.sDict.Declare(String,"PartLookup")
V.Local.sCon.Declare(String,"MyConnection")
V.Local.sSQL.Declare(String,"SELECT Part_Number, Description FROM Parts")

' Basic -- no formatting
F.Data.Dictionary.CreateFromSQL(V.Local.sDict, V.Local.sCon, V.Local.sSQL)

' With trim + uppercase (4 + 16 = 20)
V.Local.iFormat.Declare(Long,20)
F.Data.Dictionary.CreateFromSQL(V.Local.sDict, V.Local.sCon, V.Local.sSQL, V.Local.iFormat)
```

### AddItem

```
F.Data.Dictionary.AddItem(DictionaryName, Key, Value)
F.Data.Dictionary.AddItem(DictionaryName, Key, Value, IgnoreDuplicates)
```

- `DictionaryName` (String) -- name of the dictionary to add to
- `Key` (Any) -- the lookup key
- `Value` (Any) -- the value associated with the key
- `IgnoreDuplicates` (Boolean, optional) -- when `True`, silently skips the add if the key already exists. When `False` or omitted, adding a duplicate key raises an error.

**Example:**

```
V.Local.sDict.Declare(String,"StatusLookup")
F.Data.Dictionary.Create(V.Local.sDict)

' Basic add -- duplicate key will error
F.Data.Dictionary.AddItem(V.Local.sDict, "A", "Active")
F.Data.Dictionary.AddItem(V.Local.sDict, "I", "Inactive")

' Safe add -- duplicate key silently ignored
F.Data.Dictionary.AddItem(V.Local.sDict, "A", "Active", True)
```

### CreateFromDataTable

```
F.Data.Dictionary.CreateFromDataTable(DictionaryName, DataTableName, KeyField, ValueField)
F.Data.Dictionary.CreateFromDataTable(DictionaryName, DataTableName, KeyField, ValueField, Format)
F.Data.Dictionary.CreateFromDataTable(DictionaryName, DataTableName, KeyField, ValueField, Format, CaseSensitive)
```

- `DictionaryName` (String) -- name for the new dictionary
- `DataTableName` (String) -- name of the source DataTable
- `KeyField` (String) -- column whose values become dictionary keys
- `ValueField` (String) -- column whose values become dictionary values
- `Format` (Long, optional) -- bitmask controlling string formatting applied to values (see [Format Bitmask](#format-bitmask-used-by-createfromsql-createfromdatatable-createfromdataview))
- `CaseSensitive` (Boolean, optional) -- when `True`, key lookups are case-sensitive. Defaults to case-insensitive when omitted.

**Example:**

```
F.Data.Dictionary.CreateFromDataTable("Dict_CountryCapitals","DT_CountryCapitals","Country","Capital")
```

### CreateFromDataView

```
F.Data.Dictionary.CreateFromDataView(DictionaryName, DataTableName, DataViewName, KeyColumn, ValueColumn)
F.Data.Dictionary.CreateFromDataView(DictionaryName, DataTableName, DataViewName, KeyColumn, ValueColumn, Format)
```

- `DictionaryName` (String) -- name for the new dictionary
- `DataTableName` (String) -- name of the parent DataTable
- `DataViewName` (String) -- name of the DataView to read from
- `KeyColumn` (String) -- column whose values become dictionary keys
- `ValueColumn` (String) -- column whose values become dictionary values
- `Format` (Long, optional) -- bitmask controlling string formatting applied to values (see [Format Bitmask](#format-bitmask-used-by-createfromsql-createfromdatatable-createfromdataview))

Only rows visible in the DataView (after its filter/sort/row-view) are included.

**Example:**

```
F.ODBC.Connection!con.OpenCompanyConnection
F.Data.DataTable.CreateFromSQL("dtInventory","con","Select RTRIM(PART) as PART,RTRIM(LOCATION) as LOCATION,PRODUCT_LINE,DESCRIPTION,QTY_ONHAND from INVENTORY_MSTR",False)
F.ODBC.Connection!con.Close

F.Data.DataTable.AddExpressionColumn("dtInventory","PartLoc","String","[PART]+[LOCATION]")
F.Data.DataView.Create("dtInventory","dvInventory",22,"[QTY_ONHAND] < 1000","")

' Create dictionary from filtered view with uppercase + right trim (16 + 2 = 18)
F.Data.Dictionary.CreateFromDataView("dictPL","dtInventory","dvInventory","PartLoc","PRODUCT_LINE",18)
```

## Read / Lookup
```
F.Data.Dictionary.Exists("dictName",bResult)
V.Local.sResult.Set(V.Dictionary.dictName![keyLiteral])
V.Local.sResult.Set(V.Dictionary.dictName![V.Local.sKey])
F.Data.Dictionary.ReturnAllPairs("dictName",sResult)
F.Data.Dictionary.ReturnKeyFromValue("dictName","value",sKeyResult)
F.Data.Dictionary.ReturnKeyFromValue("dictName","value",bCaseSensitive,sKeyResult)
```
- `ReturnAllPairs` returns keys delimited with `*!*`, then `!*!`, then values delimited with `*!*`. Returns `***NORETURN***` if empty.
- `ReturnKeyFromValue` performs reverse lookup (value -> key). Optional `CaseSensitivity` param (Boolean) controls matching.
- Inline access via `V.Dictionary.dictName![key]` returns the default set by `SetDefaultReturn` when the key doesn't exist.

### Exists

```
F.Data.Dictionary.Exists(DictionaryName, Return)
```

- `DictionaryName` (String) -- name of the dictionary to check
- `Return` (Boolean) -- output; `True` if the dictionary exists, `False` otherwise

**Example:**

```
V.Local.sDictName.Declare(String)
V.Local.bExists.Declare(Boolean)
F.Data.Dictionary.Exists(V.Local.sDictName, V.Local.bExists)
```

### ReturnAllPairs

```
F.Data.Dictionary.ReturnAllPairs(DictionaryName, Return)
```

- `DictionaryName` (String) -- name of the dictionary
- `Return` (String) -- output; all keys delimited with `*!*`, then a delimiter of `!*!`, then all values delimited with `*!*`. Returns `***NORETURN***` if the dictionary contains no items.

**Example:**

```
F.Data.Dictionary.ReturnAllPairs("Dict_CountryCapitals", V.Local.sRet)
' V.Local.sRet might contain: "USA*!*India*!*Cuba!*!Washington D.C*!*New Delhi*!*Havana"
```

### ReturnKeyFromValue

```
F.Data.Dictionary.ReturnKeyFromValue(DictionaryName, Value, KeyReturn)
F.Data.Dictionary.ReturnKeyFromValue(DictionaryName, Value, CaseSensitivity, KeyReturn)
```

- `DictionaryName` (String) -- name of the dictionary
- `Value` (String) -- the value to search for (reverse lookup)
- `CaseSensitivity` (Boolean, optional) -- when `True`, the value comparison is case-sensitive. When `False`, comparison is case-insensitive. Omitting defaults to case-sensitive.
- `KeyReturn` (Any) -- output; the key associated with the matching value

**Example (case-sensitive, default):**

```
F.Data.DataTable.CreateFromString("Capitals_Datatable","India@New Delhi,China@Beijing","Country*!*Capital","String*!*String","@",",",True)
F.Data.Dictionary.CreateFromDataTable("Capitals_Dictionary","Capitals_Datatable","Country","Capital")

V.Local.sDictName.Declare(String,"Capitals_Dictionary")
V.Local.sValue.Declare(String,"Beijing")
V.Local.sKeyResult.Declare(String)

F.Data.Dictionary.ReturnKeyFromValue(V.Local.sDictName, V.Local.sValue, V.Local.sKeyResult)
' V.Local.sKeyResult = "China"
```

**Example (case-insensitive):**

```
F.Data.DataTable.CreateFromString("Capitals_Datatable","India@New Delhi,China@BEIJING","Country*!*Capital","String*!*String","@",",",True)
F.Data.Dictionary.CreateFromDataTable("Capitals_Dictionary","Capitals_Datatable","Country","Capital")

V.Local.sDictName.Declare(String,"Capitals_Dictionary")
V.Local.sValue.Declare(String,"Beijing")
V.Local.bCaseSensitive.Declare(Boolean,False)
V.Local.sKeyResult.Declare(String)

F.Data.Dictionary.ReturnKeyFromValue(V.Local.sDictName, V.Local.sValue, V.Local.bCaseSensitive, V.Local.sKeyResult)
' V.Local.sKeyResult = "China" (matches "BEIJING" case-insensitively)
```

### List

```
F.Data.Dictionary.List(Return)
```

- `Return` (String) -- output; names of all active dictionaries

**Example:**

```
V.Local.sAllDicts.Declare(String)
F.Data.Dictionary.List(V.Local.sAllDicts)
```

## Modify
```
F.Data.Dictionary.UpdateItem("dictName","key","newValue")
F.Data.Dictionary.RemoveItem("dictName","key")
F.Data.Dictionary.SetDefaultReturn("dictName","")
F.Data.Dictionary.SetDefaultKey("dictName","defaultKey")
```

### RemoveItem

```
F.Data.Dictionary.RemoveItem(DictionaryName, Key)
```

- `DictionaryName` (String) -- name of the dictionary
- `Key` (Any) -- the key of the entry to remove

**Example:**

```
V.Local.sDict.Declare(String,"StatusLookup")
V.Local.sKey.Declare(String,"I")
F.Data.Dictionary.RemoveItem(V.Local.sDict, V.Local.sKey)
```

### UpdateItem

```
F.Data.Dictionary.UpdateItem(DictionaryName, Key, Value)
```

- `DictionaryName` (String) -- name of the dictionary
- `Key` (Any) -- the key of the entry to update
- `Value` (Any) -- the new value to assign to the key

**Example:**

```
V.Local.sDict.Declare(String,"StatusLookup")
V.Local.sKey.Declare(String,"A")
V.Local.sNewVal.Declare(String,"Active - Current")
F.Data.Dictionary.UpdateItem(V.Local.sDict, V.Local.sKey, V.Local.sNewVal)
```

### SetDefaultReturn

```
F.Data.Dictionary.SetDefaultReturn(DictionaryName, DefaultValue)
```

- `DictionaryName` (String) -- name of the dictionary
- `DefaultValue` (Any) -- the value returned when a key lookup via `V.Dictionary.dictName![key]` does not find a match

**Example:**

```
F.Data.DataTable.CreateFromString("Capitals_Datatable","India@NewDelhi,Cuba@Havana,Denmark@Copenhagen,Canada@Ottawa,USA@Washington D.C","Country*!*Capital","String*!*String","@",",",True)
F.Data.Dictionary.CreateFromDataTable("Capitals_Dictionary","Capitals_Datatable","Country","Capital")
F.Data.Dictionary.SetDefaultReturn("Capitals_Dictionary","NOTFOUND")
F.Intrinsic.UI.Msgbox(V.Dictionary.Capitals_Dictionary![China])
' Displays "NOTFOUND" because "China" is not a key in the dictionary

F.Data.Dictionary.SetDefaultReturn("Capitals_Dictionary","")
' Resets the default return to blank
```

### SetDefaultKey

```
F.Data.Dictionary.SetDefaultKey(DictionaryName, DefaultKey)
```

- `DictionaryName` (String) -- name of the dictionary
- `DefaultKey` (Any) -- the default key to use

**Example:**

```
F.Data.Dictionary.SetDefaultKey("Dict_CountryCapitals","USA")
```

## Dictionary Lifecycle
```
F.Data.Dictionary.List(sResult)                       ' List all active dictionary names
F.Data.Dictionary.Clear("dictName")                   ' Remove all entries (keep dictionary)
F.Data.Dictionary.Close("dictName")                   ' Destroy dictionary
```

### Clear

```
F.Data.Dictionary.Clear(DictionaryName)
```

- `DictionaryName` (String) -- name of the dictionary to clear

Removes all key-value pairs from the dictionary but keeps the dictionary itself alive. The dictionary can be repopulated with `AddItem` or other populate functions after clearing. Use `Close` instead if you want to destroy the dictionary entirely.

**Example:**

```
V.Local.sDict.Declare(String,"MyLookup")
F.Data.Dictionary.Clear(V.Local.sDict)
```

### Close

```
F.Data.Dictionary.Close(DictionaryName)
```

- `DictionaryName` (String) -- name of the dictionary to destroy

Permanently removes the dictionary and all its key-value pairs from memory. After calling `Close`, the dictionary name is no longer valid and any attempt to access it will fail. Use `Clear` instead if you want to remove all entries but keep the dictionary available for reuse.

**Example:**

```
V.Local.sDict.Declare(String,"MyLookup")
F.Data.Dictionary.Close(V.Local.sDict)
```

---

# LINQ (F.Data.Linq.*)

## LINQ Operations (non-Join)

### Compute -- aggregate a field
```
F.Data.Linq.Compute(SourceObjectName, AggregateFunction, FieldName, FilterExpression, ReturnValue)
```
- `SourceObjectName` (String) -- object/DataTable name
- `AggregateFunction` (String) -- SUM, MIN, MAX, AVERAGE, COUNT
- `FieldName` (String) -- column to aggregate
- `FilterExpression` (String) -- row filter (empty string for all rows)
- `ReturnValue` (Any) -- output

### Where -- filter rows
```
F.Data.Linq.Where(ObjectName, FilterExpression, ReturnObject)
```
All String. Returns an object collection with rows matching the filter.

### Select -- project columns
```
F.Data.Linq.Select(ObjectName, ColumnNames, [FilterCondition], ReturnObjectName)
```
- `ColumnNames` (String) -- `*!*` delimited column list
- `FilterCondition` (String, optional) -- row filter
All String.

### Distinct -- unique rows
```
F.Data.Linq.Distinct(ObjectName, DistinctColumns, ReturnColumns)
```
- `DistinctColumns` (String) -- `*!*` delimited
- `ReturnColumns` (String)
All String.

### Merge -- combine two objects
```
F.Data.Linq.Merge(Object1, Object2, ReturnObject)
```
All String.

### OrderByReturn -- get first/last sorted value
```
F.Data.Linq.OrderByReturn(SourceType, SourceAndArguments, OrderBy, FirstLast, ReturnVariable)
```
- `SourceType` (String) -- source type
- `SourceAndArguments` (String) -- source name and args
- `OrderBy` (String) -- sort expression
- `FirstLast` (String) -- "First" or "Last"
- `ReturnVariable` (String) -- output

### ConvertToDatatable -- object to DataTable
```
F.Data.Linq.ConvertToDatatable(ObjectName, ColumnNames, ColumnTypes, ReturnDatatableName, [GlobalScope])
```
- `ColumnNames` (String) -- `*!*` delimited
- `ColumnTypes` (String) -- `*!*` delimited (String, Long, Float, Boolean, Date)
- `GlobalScope` (Boolean, optional) -- True for global DataTable scope

```
' Example: convert a Join result to a DataTable
F.Data.Linq.ConvertToDatatable("joinResult","ShipmentSequence*!*SalesOrderNumber*!*InvoiceNumber","String*!*String*!*String","dtFromJoinResult",True)
```

## LINQ Enums

| Enum | Values |
|------|--------|
| `V.Enum.LinqJoinType!` | `InnerJoin`, `LeftJoin`, `RightJoin`, `FullJoin` |
| `V.Enum.LinqSourceType!` | `DataTable`, `DataView`, `Object`, `ObjectOnly` |

## LINQ Join

### Syntax (2-source)
```
F.Data.Linq.Join(JoinType, SourceType0, SourceName0AndArguments, SourceType1, SourceName1AndArguments, JoinExpression, ColumnNames, FilterExpression, GroupByExpression, OrderByExpression, ReturnDataTable, GlobalDatatableScope)
```

### Syntax (N-source -- repeating middle groups)
```
F.Data.Linq.Join(JoinType, SourceType0, Source0Args, SourceType1, Source1Args, JoinExpr_0and1, [SourceTypeN, SourceNArgs, JoinExpr_NandPrevious, ...], ColumnNames, FilterExpression, GroupByExpression, OrderByExpression, ReturnDataTable, GlobalDatatableScope)
```

### Syntax (JoinQueryable -- returns Object instead of DataTable)
```
F.Data.Linq.JoinQueryable(JoinType, SourceType0, Source0Args, SourceType1, Source1Args, JoinExpr, [SourceTypeN, SourceNArgs, JoinExprN, ...], ColumnNames, FilterExpr, OrderByExpr, ReturnObjectName)
```
Same as `Join` but returns a queryable Object (no GroupBy, no GlobalScope). Use when the result will feed further LINQ operations rather than binding to a grid.

### Parameters
- `JoinType` -- `V.Enum.LinqJoinType!` or String: InnerJoin, LeftJoin, RightJoin, FullJoin
- `SourceTypeN` -- `V.Enum.LinqSourceType!` or String: DataTable, DataView, Object, ObjectOnly
- `SourceNameNAndArguments` (String) -- `*!*` delimited; format depends on source type (see below)
- `JoinExpression` (String) -- e.g., `"A.Key = B.Key"`. Multiple conditions with `AND`: `"A.Col1 = B.Col1 AND A.Col2 = B.Col2"`
- `ColumnNames` (String) -- `*!*` delimited. Use `"*"` for all columns. Supports aliases: `"A.Col1 AS MyAlias"`
- `FilterExpression` (String) -- row filter (empty string for none)
- `GroupByExpression` (String) -- group by columns (empty string for none)
- `OrderByExpression` (String) -- sort: `"ColName ASC"`, `"ColName DESC"` (empty string for none)
- `ReturnDataTable` (String) -- output DataTable name
- `GlobalDatatableScope` (Boolean) -- True for global scope

> **Note — Enum vs String:** `JoinType` and `SourceType` accept either the `V.Enum` form (e.g., `V.Enum.LinqJoinType!LeftJoin`) or a plain string literal (e.g., `"LeftJoin"`). Both are interchangeable.

> **Note — Alias names:** The alias portion of `"DataTableName*!*Alias"` is an arbitrary developer-chosen string. Any value is valid (e.g., `A`, `AB`, `Emp`, `XXX`). Column references in join expressions, column lists, filters, and order-by clauses use the format `Alias.ColumnName`.

### Source Type Naming Conventions

| Source Type | Arguments Format |
|-------------|-----------------|
| DataTable | `DataTableName` or `DataTableName*!*Alias` |
| DataView | `DataTableName*!*DataViewName` or `DataTableName*!*DataViewName*!*Alias` |
| Object | `ObjectName, Mode[int], ConnectionObjectName[string], ConnectionIndex[int]` |
| Object (aliased) | `ObjectName*!*Alias, Mode[int], ConnectionObjectName[string], ConnectionIndex[int]` |

### Basic Examples
```
' Inner join two DataTables
F.Data.Linq.Join("InnerJoin","DataTable","dt1*!*a","DataTable","dt2*!*b","a.Key = b.Key","a.Col1*!*b.Col2","","","","dtResult",True)

' Left join with 3 DataTables
F.Data.Linq.Join("LeftJoin","DataTable","dtA1*!*A1","DataTable","dtA2*!*A2","A1.Customer = A2.Vendor","DataTable","dtA3*!*A3","A1.GLAccount = A3.GLAccount","A1.Customer*!*A2.VendorNo*!*A1.PO*!*A3.AgencyCode","","","","dtFinal",True)

' Right join with multiple AND conditions
F.Data.Linq.Join("RightJoin","DataTable","Employee*!*E","DataTable","Department*!*D","E.DeptID=D.Dept_ID AND E.ID=D.ID AND E.DName=D.Name","DataTable","Manager*!*M","E.MgID=M.MID","E.Emp_ID*!*E.FirstName*!*D.DeptName*!*M.MgName","E.Emp_ID <48","D.DeptName","E.Emp_ID","DTJoinreturn",True)
```

### DataTable-DataView Join
```
F.Data.Linq.Join("LeftJoin","DataView","Employee*!*EmployeeDV*!*E","DataTable","Department*!*D","E.DeptID=D.Dept_ID","DataView","Manager*!*ManagerDV*!*M","E.MgID=M.MID","E.Emp_ID*!*E.FirstName*!*D.DeptName*!*M.MgName","E.Emp_ID <48","D.DeptName","E.Emp_ID","DVJoinreturn",True)
```

### DataTable-Object Join
```
F.Data.Linq.Join("InnerJoin","Object","oParts*!*oPt","Inventory.Parts","GlobalDB",V.Local.iCon,700,"Z-S","DataTable","PartTable*!*P","oPt.PartNumber=P.PartNumber","oPt.PartNumber*!*oPt.description.part*!*P.LocationCode","","","P.PartNumber","ObjectJoinreturn",True)
```

### Object-Object Join
```
F.Data.Linq.Join("InnerJoin","Object","oExcl*!*E",1,"GlobalDB",V.Local.iCon,1,90,"Object","oAcc*!*A",113,"GlobalDB",V.Local.iCon,"000000000000000","zzzzzzzzzzzzzzz","E.Information-AccountNumber = A.AccountNumber",V.Local.sProps,"","","","dtReturn",True)
```

### Wildcard and Alias Columns
```
' "*" returns all columns from all sources
F.Data.Linq.Join("RightJoin","DataTable","Employee*!*E","DataTable","Department*!*D","E.DeptID=D.Dept_ID","*","","","E.Emp_ID ASC","DTJoinreturn",True)

' AS aliases -- rename columns in the output
F.Data.Linq.Join("RightJoin","DataTable","Employee*!*E","DataTable","Department*!*D","E.DeptID=D.Dept_ID","E.Emp_ID AS EmployeeID*!*D.DeptName AS Department","","","","DTJoinreturn",True)
```

### Multi-Source Join (4 tables)

Additional sources are appended by repeating the `SourceType, "DataTable*!*Alias", "JoinCondition"` triplet for each extra source:

```
F.Data.Linq.Join(V.Enum.LinqJoinType!LeftJoin,V.Enum.LinqSourceType!DataTable,"dtInvBrowserA*!*A",V.Enum.LinqSourceType!DataTable,"dtInvBrowserB*!*B","A.PARTRev = B.PARTRev and A.Loc = B.Loc",V.Enum.LinqSourceType!DataTable,"dtInvBrowserC*!*C","A.PARTRev = C.PARTRev and A.Loc = C.Loc",V.Enum.LinqSourceType!DataTable,"dtInvBrowserD*!*D","A.PARTRev = D.PARTRev","A.PartRev*!*A.Loc*!*A.Description*!*B.Alt1Descr*!*B.Alt2Descr*!*D.TEXT*!*A.ProductLine*!*A.OnHand*!*A.OnOrder*!*A.Required*!*A.Net*!*A.CODE_ABC*!*A.BIN*!*A.UM_PURCHASING*!*A.UM_INVENTORY*!*A.OBSOLETE_FLAG*!*A.CODE_SORT*!*A.FLAG_INACTIVE*!*B.CODE_SOURCE*!*B.NAME_VENDOR*!*B.TEXT_INFO1*!*B.TEXT_INFO2*!*B.LENGTH*!*B.WIDTH*!*C.THICKNESS*!*C.STOCK_BIN","","","A.PartRev asc","dtInventoryBrowser",False)
```

### Aggregates with Group By
Supported: SUM, MIN, MAX, AVERAGE, COUNT. At least one space between column name and operator.
```
F.Data.Linq.Join("InnerJoin","DataTable","DtLeft*!*A","DataTable","DtRight*!*B","A.CompanyID=B.CompanyID","A.Location AS Loc*!*SUM(A.Amount + B.Amount) AS Total*!*MIN(A.Amount) AS MinA*!*MAX(B.Amount) AS MaxB*!*AVERAGE(A.Amount) AS AvgA*!*COUNT() AS TotalCount*!*B.Company","","A.Location,B.Company","Total ASC,Loc DESC","dtResult1",True)
```

### Expression Columns
Operators: `+` (add/concat), `-` (subtract), `*` (multiply), `/` (divide), `%` (modulus). At least one space between column name and operator.
```
F.Data.Linq.Join("InnerJoin","DataTable","DtLeft*!*A","DataTable","DtRight*!*B","A.CompanyID=B.CompanyID","B.Company + ':' + A.Location AS CompanyLocation*!*A.Amount + B.Amount + 4 AS TotalAmount","TotalAmount>3","","TotalAmount,B.Company","dtResult2",True)
```

### DATEPART
Extract part of a DateTime column: DAY, MONTH, YEAR, HOUR, MINUTE, SECOND.
```
F.Data.Linq.Join("InnerJoin","DataTable","DtLeft*!*A","DataTable","DtRight*!*B","A.CompanyID=B.CompanyID","DATEPART(B.DateShipped,Day) AS Day*!*DATEPART(B.DateShipped,Month) AS Month*!*DATEPART(B.DateShipped,Year) AS Year","","","","dtResult3",True)
```

---

# DATA OBJECTS (F.Data.Object.*)

Data Objects are lightweight in-memory property bags. They can be used for:
- Batch-setting properties on controls
- Dashboard export configuration
- General-purpose key/value storage during script execution

## Object Lifecycle

### Create -- create a named object
```
F.Data.Object.Create(ObjectName)
```
- `ObjectName` (String) -- name for the object instance

### AddProperty -- add a named property with an initial value
```
F.Data.Object.AddProperty(ObjectName, PropertyName, PropertyValue)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- property name (can be a string literal or a `V.Enum.*` value)
- `PropertyValue` (Boolean, Float, Long, or String) -- initial value for the property

### SetProperty -- set a property's value
```
F.Data.Object.SetProperty(ObjectName, PropertyName, PropertyValue)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- property name
- `PropertyValue` (Boolean, Float, Long, or String) -- value to assign

### GetProperty -- read a property's value
```
F.Data.Object.GetProperty(ObjectName, PropertyName, Return)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- property name
- `Return` (Boolean, Float, Long, or String) -- variable to receive the value

### Destroy -- destroy a property or the entire object
Two overloads:
```
F.Data.Object.Destroy(ObjectName, PropertyName)
F.Data.Object.Destroy(ObjectName)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- *(optional)* property to destroy. If omitted, the entire object is destroyed.

## Complete Example -- General-Purpose Property Bag
```
V.Local.GetPropertyResult.Declare(Long)

'create object
F.Data.Object.Create("SampleObject")

'add property with default value 0
F.Data.Object.AddProperty("SampleObject","UserID",0)

'set property value
F.Data.Object.SetProperty("SampleObject","UserID",62)

'get property value
F.Data.Object.GetProperty("SampleObject","UserID",V.Local.GetPropertyResult)
F.Intrinsic.UI.Msgbox(V.Local.GetPropertyResult)

'destroy single property
F.Data.Object.Destroy("SampleObject","UserID")

'destroy entire object
F.Data.Object.Destroy("SampleObject")
```

## Common Use -- Batch-Set Control Properties
```
F.Data.Object.Create("objectName")
F.Data.Object.AddProperty("objectName",V.Enum.GsCardView!CardWidth,800)
F.Data.Object.AddProperty("objectName",V.Enum.GsCardView!OptionsSelectionMultiSelect,True)
Gui.<Form>.GsCardView1.SetProperty("objectName")
```

## Common Use -- Dashboard Export Configuration
```
F.Data.Object.Create("DashboardExport")
F.Data.Object.AddProperty("DashboardExport",V.Enum.DashboardViewerExport!ExportType,V.Enum.DashboardViewerExportType!PDF)
F.Data.Object.AddProperty("DashboardExport",V.Enum.DashboardViewerExportPDF!UserId,62)
F.Data.Object.AddProperty("DashboardExport",V.Enum.DashboardViewerExportPDF!DashboardId,4)
F.Data.Object.AddProperty("DashboardExport",V.Enum.DashboardViewerExportPDF!ExportPath,sPath)
F.Data.Object.AddProperty("DashboardExport",V.Enum.DashboardViewerExportPDF!FileName,"ExportName")
```

## V.Object Inline Access

Data Objects can be accessed inline via the `V.Object` scope:

```
V.Object.myObj!IsNothing                                    ' True if object does not exist / is Nothing
V.Object.myObj.PropName!FieldVal                            ' Property value as string
V.Object.myObj.PropName!FieldValTrim                        ' Trimmed string
V.Object.myObj.PropName!FieldValFloat                       ' Float value
V.Object.myObj.PropName!FieldValLong                        ' Long value
V.Object.myObj.PropName!FieldValNot                         ' Negated boolean
V.Object.myObj.PropName!FieldValString                      ' Explicit string conversion
V.Object.myObj.PropName!FieldValIsNull                      ' True if property value is null
V.Object.myObj.PropName!FieldValLTrim                       ' Left-trimmed string
V.Object.myObj.PropName!FieldValRTrim                       ' Right-trimmed string
V.Object.myObj.PropName!FieldValLcTrim                      ' Lowercase + trimmed
V.Object.myObj.PropName!FieldValLcRTrim                     ' Lowercase + right-trimmed
V.Object.myObj.PropName!FieldValUcTrim                      ' Uppercase + trimmed
V.Object.myObj.PropName!FieldValUcRTrim                     ' Uppercase + right-trimmed
V.Object.myObj.PropName!FieldValPervasiveDate               ' Date formatted for Pervasive SQL
V.Object.myObj.PropName!FieldValPercentToDecimal            ' Percentage to decimal conversion
V.Object.myObj.PropName!FieldValStringPSqlFriendly          ' String escaped for Pervasive SQL
V.Object.myObj.PropName!FieldValStringMsSqlFriendly         ' String escaped for SQL Server
```

---

# STRINGBUILDER

```
F.Intrinsic.StringBuilder.Create("BuilderName")
F.Intrinsic.StringBuilder.Append("BuilderName",sText)         ' Append without newline
F.Intrinsic.StringBuilder.AppendLine("BuilderName",sLine)      ' Append with newline
F.Intrinsic.StringBuilder.Clear("BuilderName")                 ' Remove all content, keep builder
F.Intrinsic.StringBuilder.Insert("BuilderName",iPosition,sData)  ' Insert data at position
F.Intrinsic.StringBuilder.ReadLength("BuilderName",iReturn)    ' Get current content length
F.Intrinsic.StringBuilder.Remove("BuilderName",iStart,iLength) ' Remove characters at position
F.Intrinsic.StringBuilder.Replace("BuilderName",sMatch,sReplacement)  ' Find and replace text
F.Intrinsic.StringBuilder.ToString("BuilderName",sResult)
F.Intrinsic.StringBuilder.Dispose("BuilderName")
```

---

# GSSXML FILE FORMAT

GSSXML (`.gssxml`) is a GSS-specific XML format used for data interchange with Global Shop Solutions modules (e.g., BOM Compare). It encodes tabular data as rows of name-value pairs.

## Structure

```xml
<?xml version="1.0" encoding="utf-16"?>
<Table xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <Rows>
    <Row>
      <Values>
        <NameValuePair>
          <Name>ColumnName</Name>
          <Value>ColumnValue</Value>
        </NameValuePair>
        <NameValuePair>
          <Name>AnotherColumn</Name>
          <Value>AnotherValue</Value>
        </NameValuePair>
      </Values>
    </Row>
  </Rows>
</Table>
```

**Key rules:**
- Encoding is `utf-16`
- Root element is `<Table>` with `xsd` and `xsi` namespace declarations
- Each row is `<Row>` → `<Values>` → one or more `<NameValuePair>` elements
- Each `<NameValuePair>` has a `<Name>` (column name) and `<Value>` (column value)

## XML Escaping

All text values **must** have XML special characters escaped before insertion:

| Character | Entity |
|-----------|--------|
| `&` | `&#38;` |
| `<` | `&#60;` |
| `>` | `&#62;` |
| `'` | `&#39;` |
| `"` | `&#34;` |

Use repeated `F.Intrinsic.String.Replace` calls for each character.

## GAB Construction Pattern

Build the XML string with StringBuilder, then write to file:

```
F.Intrinsic.StringBuilder.Create("EXPORT")

'XML header
F.Intrinsic.String.Build("<?xml version={1}1.0{1} encoding={1}utf-16{1}?>{0}<Table xmlns:xsd={1}http://www.w3.org/2001/XMLSchema{1} xmlns:xsi={1}http://www.w3.org/2001/XMLSchema-instance{1}>{0}  <Rows>{0}",V.Ambient.NewLine,V.Ambient.DblQuote,V.Local.sHeader)
F.Intrinsic.StringBuilder.AppendLine("EXPORT",V.Local.sHeader)

'Build reusable XML fragments for row construction
F.Intrinsic.String.Build("    <Row>{0}      <Values>{0}        <NameValuePair>{0}          <Name>",V.Ambient.NewLine,V.Local.sBegRow)
F.Intrinsic.String.Build("</Name>{0}          <Value>",V.Ambient.NewLine,V.Local.sPairSep)
F.Intrinsic.String.Build("</Value>{0}        </NameValuePair>{0}        <NameValuePair>{0}          <Name>",V.Ambient.NewLine,V.Local.sColSep)
F.Intrinsic.String.Build("</Value>{0}        </NameValuePair>{0}      </Values>{0}    </Row>",V.Ambient.NewLine,V.Local.sEndRow)

'Loop through DataTable rows, building each row's XML
F.Intrinsic.Control.For(V.Local.i,0,V.DataTable.dtMyData.RowCount--,1)
    'First column uses sBegRow, middle columns use sColSep, last column uses sEndRow
    F.Intrinsic.String.Build("{0}Col1{1}{2}{3}",V.Local.sBegRow,V.Local.sPairSep,V.DataTable.dtMyData(V.Local.i).Col1!FieldValTrim,V.Local.sColSep,V.Local.sLine)
    F.Intrinsic.String.Build("{0}Col2{1}{2}{3}",V.Local.sLine,V.Local.sPairSep,V.DataTable.dtMyData(V.Local.i).Col2!FieldValTrim,V.Local.sColSep,V.Local.sLine)
    F.Intrinsic.String.Build("{0}LastCol{1}{2}{3}",V.Local.sLine,V.Local.sPairSep,V.DataTable.dtMyData(V.Local.i).LastCol!FieldValTrim,V.Local.sEndRow,V.Local.sLine)
    F.Intrinsic.StringBuilder.AppendLine("EXPORT",V.Local.sLine)
F.Intrinsic.Control.Next(V.Local.i)

'Close the XML
F.Intrinsic.String.Build("  </Rows>{0}</Table>",V.Ambient.NewLine,V.Local.sEndFile)
F.Intrinsic.StringBuilder.AppendLine("EXPORT",V.Local.sEndFile)

'Write to file
F.Intrinsic.StringBuilder.ToString("EXPORT",V.Local.sResult)
F.Intrinsic.File.String2File(V.Local.sFilePath,V.Local.sResult)
F.Intrinsic.StringBuilder.Dispose("EXPORT")
```

> **Note:** The first column in a row uses `sBegRow` as the prefix (opens `<Row><Values><NameValuePair><Name>`). Middle columns use `sColSep` (closes the previous pair and opens the next). The **last** column uses `sEndRow` instead of `sColSep` (closes the final pair, `</Values>`, and `</Row>`).

---

# USER-DEFINED TYPES (UDT)

> **LEGACY ONLY -- Do NOT use in new GAB projects.** Use DataTable instead. This reference exists only for maintaining older scripts that already use UDTs.

UDTs are structured arrays -- typed records with named fields.

## Define

### Inline Definition (all members at once)
```
Variable.Define(sTypeName,sMember1:Type,sMember2:Type,...)
' Example:
Variable.Define(OrderLine,PartNo:String,Qty:Long,Price:Float,Selected:Boolean)
V.Local.udtLines.Declare(OrderLine)
```

### Per-Member Definition (with recordset field mapping)
```
Variable.UDT.<typename>.Define(MemberName, DataType, RecordsetFieldName)
```
Defines a single member on a UDT type, explicitly mapping it to a recordset column name. Use this when `LoadUDTFromRecordset` is used and the UDT member names differ from the database column names.

| Argument | Type | Description |
|----------|------|-------------|
| MemberName | String | Name of the UDT member to define |
| DataType | String | Data type (String, Long, Float, Boolean, Date) |
| RecordsetFieldName | String | Database column name this member maps to |

```
V.Local.sMember.Declare(String)
V.Local.sType.Declare(String)
V.Local.sField.Declare(String)

V.Local.sMember.Set("PartNumber")
V.Local.sType.Set("String")
V.Local.sField.Set("PART_NO")
Variable.UDT.OrderLine.Define(V.Local.sMember, V.Local.sType, V.Local.sField)

V.Local.sMember.Set("Quantity")
V.Local.sType.Set("Long")
V.Local.sField.Set("QTY_ORDERED")
Variable.UDT.OrderLine.Define(V.Local.sMember, V.Local.sType, V.Local.sField)
```

## Load Data
```
F.Intrinsic.Variable.LoadUDTFromString(sUDTName,sData,sElements,sOuterDelim,sInnerDelim,bAppend)
F.Intrinsic.Variable.LoadUDTFromRecordset(sConnectionName,sRecordsetName,sUDTName,bPreserve,iGrowthFactor)
F.Intrinsic.Variable.SaveUDTToRecordset(sConnectionName,sRecordsetName,sUDTName)
```

## Access
```
V.Local.udtLines(0).PartNo                    ' Read first element's PartNo
V.Local.udtLines(0).PartNo.Set("ABC-123")     ' Write to first element
V.Local.udtLines.UBound                       ' Last index
```

UDT fields support the standard inline variable properties (see agents/AGENTS.GAB.md > Inline Variable Properties). This includes type conversion, string manipulation, formatting, and date comparison:
```
V.Local.udtLines(0).PartNo.Trim()
V.Local.udtLines(0).PartNo.UCase()
V.Local.udtLines(0).Price.String()
V.Local.udtLines(0).Price.Float()
V.UDT.udtLines.DateComp()                     ' Date comparison value on a UDT date field
V.UDT.udtLines.TimeComp()                     ' Time comparison value on a UDT date/time field
```

## Search & Sort
```
F.Intrinsic.Variable.UDTSeek(sUDTElement,sMatchValue,iMatchType,sResult)
F.Intrinsic.Variable.UDTMultiSeek(sElement0,sMatch0,...,sElementN,sMatchN,sResult)
F.Intrinsic.Variable.UDTMultiSeekSet(sElement0,sMatch0,...,sElementN,sMatchN,sResult)
F.Intrinsic.Variable.UDTMultiSeekSetNoTrim(sElement0,sMatch0,...,sElementN,sMatchN,sResult)
F.Intrinsic.Variable.UDTMultiQuickSort(sElement0,bDesc0,...,sElementN,bDescN)
```

### UDTSeek — Match Types

`UDTSeek` searches a UDT array element for matching values and returns a `!`-delimited string of matching ordinal indices.

| Argument | Type | Description |
|----------|------|-------------|
| UdtName!element | String | Fully-qualified UDT element to search (e.g., `V.Local.udtLines!PartNo`) |
| MatchValue | String | Value to match against |
| MatchType | Long | Match behavior (see table below) |
| ReturnDelimitedStringOfOrdinals | String | Result — `!`-delimited string of matching array indices |

| MatchType | Behavior |
|-----------|----------|
| `0` | Match entire term, case-insensitive text matching, multiple returns (default) |

> **Note:** When MatchType is `0`, the return is a string containing the array index (or indices) of all matches, delimited with `!`. If no match is found the return is empty.

### UDTMultiSeekSet vs UDTMultiSeek

`UDTMultiSeekSet` works like `UDTMultiSeek` but sets the found ordinals rather than returning them. `UDTMultiSeekSetNoTrim` is the same but does not trim values before comparing.

## Flag Operations (batch select/delete)
```
F.Intrinsic.Variable.UDTFlagAll(sUDTName)
F.Intrinsic.Variable.UDTUnFlagAll(sUDTName)
F.Intrinsic.Variable.UDTMultiFlag(sElement0,sMatch0,...,sElementN,sMatchN)
F.Intrinsic.Variable.UDTMultiUnFlag(sElement0,sMatch0,...,sElementN,sMatchN)
F.Intrinsic.Variable.UDTMultiFlagDuplicates(sElement0,sMatch0,...,sElementN,sMatchN)
F.Intrinsic.Variable.UDTMultiUnFlagNoTrim(sElement0,sMatch0,...,sElementN,sMatchN)
F.Intrinsic.Variable.UDTDeleteFlagged(sUDTName)
F.Intrinsic.Variable.UDTSetMemberValueFlagged(sUDTElement,sValue)
F.Intrinsic.Variable.UDTCopyFlagged(sSource,sTarget,bAppend)
F.Intrinsic.Variable.UDTCopyUnFlagged(sSource,sTarget,bAppend)
```

- `UDTMultiFlag` flags all entries matching the specified multi-element criteria.
- `UDTMultiUnFlag` unflags all entries matching the specified multi-element criteria.
- `UDTMultiFlagDuplicates` flags duplicate entries matching the specified criteria.
- `UDTMultiUnFlagNoTrim` unflags entries without trimming values before comparing.
- `UDTSetMemberValueFlagged` writes a value to a specific member on all **flagged** entries only.

**UDTMultiUnFlag example:**
```
F.Intrinsic.Variable.UDTMultiUnFlag(Variable.uLocal.uVendorObjCopy!VendorID,"100001")
```

### Checking Flag State (V.Scope.*var.Flagged)

The `.Flagged()` property checks whether a UDT element at a given ordinal is flagged. Use after calling `UDTFlagAll`, `UDTMultiFlag`, or `UDTFlagOrdinal`.

```
V.Local.udtLines(0).Flagged()          ' True if element at index 0 is flagged
V.Global.udtItems(V.Local.i).Flagged() ' Check flag state by variable index
```

## Serialization
```
F.Intrinsic.Variable.UDTToString(sUDTName,sElements,sResult)
F.Intrinsic.Variable.UDTToStringCSV(sUDTName,sElements,sResult)
F.Intrinsic.Variable.UDTCopy(sSource,sTarget,bAppend)
F.Intrinsic.Variable.UDTPositionToString(sUDTName,iPosition,sResult)
F.Intrinsic.Variable.UDTGetMembers(sUDTName,bFQN,sResult)
F.Intrinsic.Variable.UDTSetMemberValue(sUDTElement,sValue)
F.Intrinsic.Variable.UDTSetMemberFormat(sUDTElement,sFormat)
F.Intrinsic.Variable.UDTFlagOrdinal(sUDTName,bFlag,sOrdinals)
```

## UDT Variable Scopes: V.uLocal and V.uGlobal

> **LEGACY ONLY -- Do NOT use in new GAB projects.** Use DataTable instead. This reference exists only for maintaining older scripts that already use UDTs.

GAB provides two dedicated scopes for User-Defined Type variables. Both use `!` syntax for member access and share the same method set.

| Scope | Long Form | Short Form | Lifetime |
|-------|-----------|------------|----------|
| `V.uLocal` | `Variable.uLocal.<name>` | `V.uLocal.<name>` | Subroutine-scoped (destroyed when sub exits) |
| `V.uGlobal` | `Variable.uGlobal.<name>` | `V.uGlobal.<name>` | Program-scoped (persists across all subroutines) |

### Variable-Level Methods (Array Operations)

These operate on the UDT variable itself (not on individual members):

```
V.uLocal.udtData.Declare()                                ' Declare local UDT variable
V.uGlobal.udtData.Declare()                               ' Declare global UDT variable
V.uLocal.udtData.LBound()                                 ' Array lower bound
V.uLocal.udtData.UBound()                                 ' Array upper bound
V.uLocal.udtData.Redim(iLower, iUpper)                    ' Resize array (LowerBound as Long, UpperBound as Long)
V.uLocal.udtData.RedimPreserve(iLower, iUpper)            ' Resize preserving data
V.uGlobal.udtData.RedimPreserve(iLower, iUpper)           ' Resize preserving data
```

**RedimPreserve argument differences:**
- `V.uLocal.*var.RedimPreserve` -- both LowerBound and UpperBound are **optional**
- `V.uGlobal.*var.RedimPreserve` -- both LowerBound and UpperBound are **required**

### Property-Level Methods (UDT Member Operations)

These operate on individual UDT members via `!` accessor syntax. Identical for both scopes:

```
V.uLocal.udtData!MemberName.Declare()                     ' Declare member
V.uLocal.udtData!MemberName.Set(value)                    ' Set member value (Value as Any)
V.uLocal.udtData!MemberName.Set(value, iHook)             ' Set with optional hook# (Hook# as Long, optional)
V.uLocal.udtData!MemberName.Append(expression)            ' Append to member (Expression as Any)
```

### Property-Level Inline Properties

UDT members accessed via `V.uLocal.<var>!<member>` or `V.uGlobal.<var>!<member>` support the full set of standard inline properties:

| Category | Properties |
|----------|-----------|
| Type Conversion | `.String()`, `.Long()`, `.Float()` |
| String Manipulation | `.Trim()`, `.LTrim()`, `.RTrim()`, `.UCase()`, `.LCase()`, `.PCase()`, `.Length()`, `.Left#()`, `.Right#()`, `.StrLit()` |
| Validation | `.IsDate()`, `.IsNumeric()` |
| Boolean | `.Not()` |
| Formatting | `.Format*()`, `.DateComp()`, `.TimeComp()`, `.PervasiveDate()` |
| Database Escaping | `.PSQLFriendly`, `.SQLServerFriendly` |
| Array (on member) | `.LBound()`, `.UBound()`, `.Redim(iLower, iUpper)`, `.RedimPreserve(iLower, iUpper)` |

**Note:** `.RedimPreserve` on a member accepts optional arguments (both LowerBound and UpperBound are optional) for both scopes.

### V.uLocal Example
```
Variable.Define(LineItem,PartNo:String,Qty:Long,Price:Float)
V.uLocal.udtLines.Declare(LineItem)

V.uLocal.udtLines.Redim(0, 1)
V.uLocal.udtLines!PartNo.Set("WIDGET-A")
V.uLocal.udtLines!Qty.Set(5)
V.uLocal.udtLines!Price.Set(12.99)

V.Local.sPart.Set(V.uLocal.udtLines!PartNo.Trim())
V.Local.fPrice.Set(V.uLocal.udtLines!Price.Float())
V.Local.iLast.Set(V.uLocal.udtLines.UBound())
```

### V.uGlobal Example
```
Variable.Define(OrderData,OrderNo:String,Qty:Long,Price:Float,OrderDate:Date)
V.uGlobal.udtOrders.Declare(OrderData)

V.uGlobal.udtOrders.Redim(0, 2)
V.uGlobal.udtOrders!OrderNo.Set("ORD-001")
V.uGlobal.udtOrders!Qty.Set(10)
V.uGlobal.udtOrders!Price.Set(25.50)

V.Local.sOrderTrimmed.Set(V.uGlobal.udtOrders!OrderNo.Trim())
V.Local.sPriceStr.Set(V.uGlobal.udtOrders!Price.String())
V.Local.sDateSql.Set(V.uGlobal.udtOrders!OrderDate.PervasiveDate())
V.Local.sOrderUpper.Set(V.uGlobal.udtOrders!OrderNo.UCase())
V.Local.iLastIdx.Set(V.uGlobal.udtOrders.UBound())
```

---

# VARIABLE & ARRAY UTILITIES (F.Intrinsic.Variable.*)

## Subroutine Arguments (Passed Variables / Return Values)
```
F.Intrinsic.Variable.AddPV(sVariableName,value)              ' Add passed variable to a subroutine call
F.Intrinsic.Variable.ClearPV                                  ' Clear all passed arguments set with AddPV
F.Intrinsic.Variable.AddRV(sReturnVarName,value)             ' Return a value to the calling subroutine (caller reads via V.Args.Name)
F.Intrinsic.Variable.ArgExists(sArgName,bResult)             ' Check if a named argument was passed
F.Intrinsic.Variable.ArgToVar                                 ' Map passed arguments to local variables
F.Intrinsic.Variable.ListCallerVars(sResult)                  ' List all caller variables
F.Intrinsic.Variable.FindIDFromName(sName,sResult)            ' Return past ID for variable if name matches; "NONE" if not found
```

## Type Checking & Conversion
```
F.Intrinsic.Variable.IsNull(value,bResult)                   ' Check if field holds null value
F.Intrinsic.Variable.IsArray(sVarName,bResult)               ' Check if variable is an array
F.Intrinsic.Variable.SetNumeric(sInput,sResult)              ' Numeric representation of a string (strips non-numeric chars)
F.Intrinsic.Variable.SetProperty(sID,sProperty,value)        ' Set a property on a variable by ID
F.Intrinsic.Variable.GetMembers(sResult)                      ' Return fully-qualified UDT member callouts as a string
```

## Array Operations
```
F.Intrinsic.Variable.LBound(sArray,iResult)                  ' Lower bound of array
F.Intrinsic.Variable.UBound(sArray,iResult)                  ' Upper bound of array
F.Intrinsic.Variable.AddToArray(sFQVarName,value)            ' Append value to array
F.Intrinsic.Variable.PopArray(sArrayIn,sArrayOut)            ' Remove first element; shift remaining down
F.Intrinsic.Variable.PushArray(sArrayName)                   ' Add element to end of array
F.Intrinsic.Variable.RemoveArrayElementByOrdinal(sInput,iOrdinal,sResult)  ' Remove element by index
F.Intrinsic.Variable.RemoveArrayElementByValue(sArray,value,sResult)       ' Remove element by value
F.Intrinsic.Variable.ArrayTrim(sSource,sTarget)              ' Trim all elements in array
F.Intrinsic.Variable.ArrayAverage(sArray,fResult)            ' Average of array values
F.Intrinsic.Variable.ArrayMax(sArray,fResult)                ' Maximum value in array
F.Intrinsic.Variable.ArrayMin(sArray,fResult)                ' Minimum value in array
F.Intrinsic.Variable.Sort(sArray,sResult)                    ' Sort array by data type
```

## Bit Operations
```
F.Intrinsic.Variable.BitArrayToLong(baBoolArray,iResult)     ' Boolean array to Long
F.Intrinsic.Variable.BitArrayInStringToLong(sInput,iResult)  ' Bit string to Long
F.Intrinsic.Variable.LongtoBitArray(iValue,baResult)         ' Long to boolean array (0-31)
```

## UDT Recordset Integration
```
F.Intrinsic.Variable.LoadUDTFromRecordset(sConnectionName,sRecordsetName,sUDTName,bPreserve,iGrowthFactor)
F.Intrinsic.Variable.LoadUDTFromString(sUDTName,sData,sElements,sOuterDelim,sInnerDelim,bAppend)
F.Intrinsic.Variable.SaveUDTToRecordset(sConnectionName,sRecordsetName,sUDTName)
F.Intrinsic.Variable.SetUDTFieldReference(sUDTElement,sRstFieldName)  ' Remap UDT element to recordset field
F.Intrinsic.Variable.SetUDTFieldDateMask(sUDTElement,sDateMask)      ' Set date format mask for UDT load
```

## UDT Additional Flag/Seek Operations
```
F.Intrinsic.Variable.UDTMultiFlagNoTrim(sUDTName,value)      ' Flag entries without trimming before compare
F.Intrinsic.Variable.UDTMultiSeekNoTrim(sElement0,sMatch0,...,sElementN,sMatchN,sResult)  ' Seek without trimming
```


