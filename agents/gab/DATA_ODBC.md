# GAB ODBC / Database Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with ODBC connections, recordsets, or direct SQL
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---
# DATABASE (ODBC)

## Connections

### Global Shop Shorthand Connections
Use these when connecting to the current GSS company or common database:
```
F.ODBC.Connection!con.OpenCompanyConnection              ' Company DB (uses ambient DSN)
F.ODBC.Connection!con.OpenCompanyConnection(250)          ' With timeout (seconds)
F.ODBC.Connection!conC.OpenCommonConnection               ' GLOBALCOMMON shared DB
F.ODBC.Connection!con.Close                               ' ALWAYS close when done
```

### Pervasive DSN Connection
Use `OpenConnection` with `V.Ambient.PDSN/PUser/PPass` to connect to the Pervasive database via DSN:
```
F.ODBC.Connection!con.OpenConnection(V.Ambient.PDSN,V.Ambient.PUser,V.Ambient.PPass)
F.ODBC.Connection!con.OpenConnection(V.Ambient.PDSN,V.Ambient.PUser,V.Ambient.PPass,600)  ' With timeout
```

### External Database Connections (Non-GSS)
`OpenConnection` is typically used to connect to **external databases** that are not the Global Shop instance (e.g., SQL Server, Access, Excel). Build a connection string with `F.Intrinsic.String.Build`, then pass it as a single argument:
```
' SQL Server via SQLOLEDB provider
F.Intrinsic.String.Build("Provider=SQLOLEDB;Server={0};Database=IHOP_Net;Uid={1};Pwd={2};Connection Timeout=9999",V.Global.sServGrp,V.Global.sUser,V.Global.sKey,V.Global.sCon)
F.ODBC.Connection!con.OpenConnection(V.Global.sCon)

' SQL Server via trusted connection (Windows auth)
F.Intrinsic.String.Build("Provider={0};Trusted_Connection=yes;Server={1};Database={2};DataTypeCompatibility=80;",V.Local.sProvider,V.Local.sServer,V.Local.sDatabase,V.Local.sCon)
F.ODBC.Connection!ConPep.OpenConnection(V.Local.sCon)
```

Multiple named connections are supported: `con`, `conB`, `conC`, `conLoad`, `conDel`, `ConPep`, `common`, etc. Connection names are user-defined and case-insensitive.

**Connection name caveats:**
- Keep connection names **short** (~10 characters or less). Names like `conDeployAll` have caused **Error 20010** ("Invalid connection name") at runtime, while shorter names like `conHooks` work fine.
- Names must be **unique** across nested or concurrent subroutines (see `agents/gab/PITFALLS.md`).
- Use **alphanumeric characters only** in connection names.
- Connection lifecycle must be **self-contained per subroutine**: Open → Execute → Close, with **Close in the error handler too**.

## Execute SQL
```
F.ODBC.Connection!con.Execute(V.Local.sSQL)                              ' Execute (no return)
F.ODBC.Connection!con.ExecuteAndReturn(V.Local.sSQL,V.Local.sResult)     ' Execute and return single value
```

`ExecuteAndReturn` returns the first column of the first row as a **String**, even for `COUNT(*)` or numeric aggregates. Convert with `.Long`, `.Float`, etc. Check `V.Ambient.ExecuteAndReturnEOF` (**True** = no rows returned).

### ExecuteAndReturn Multi-Row Results

When `ExecuteAndReturn` returns multiple rows/columns, it uses specific delimiters:
- **`#$#`** = ROW delimiter (separates rows)
- **`*!*`** = COLUMN delimiter (separates columns within a row)

Always split on `#$#` FIRST to isolate each row, THEN split on `*!*` for individual columns:
```
F.ODBC.Connection!con.ExecuteAndReturn(V.Local.sSQL,V.Local.sResult)
'-- Split into rows first
F.Intrinsic.String.Split(V.Local.sResult,"#$#",V.Local.sRows)
'-- Get first row's columns
F.Intrinsic.String.Split(V.Local.sRows(0),"*!*",V.Local.sCols)
'-- sCols(0) = first column, sCols(1) = second column, etc.
```

### Date Column Formatting: PervasiveDate vs FormatYYYYMMDD

Use the correct format based on the **target column type**:
- **DATE/SQL columns** → `.PervasiveDate` — produces `'2026-05-01'` (with hyphens). Required for actual DATE-typed columns
- **CHAR date columns** (e.g., `post_date` fields stored as strings) → `FormatYYYYMMDD` — produces `'20260501'` (no hyphens)

Using the wrong format produces silent data mismatches or "Data type mismatch" errors.

### Table Existence Check

**NEVER** query `X$File`, `X$Table`, or any Pervasive system catalog table to check if a table exists. Use the built-in API:
```
F.ODBC.Connection!con.TableExists("MY_TABLE",V.Local.bExists)
```

### SQL String Building

**NEVER** use `.Append` to build SQL query strings. GAB strings have no line length limit. Use a single `.Set()` with the full query, or pass the SQL literal directly to `CreateFromSQL`:
```
'-- CORRECT: single .Set with full query
V.Local.sSQL.Set("SELECT RTRIM(PART) AS Part_Number, QTY_ONHAND FROM V_INVENTORY_ALL WHERE PRODUCT_LINE = 'FG' ORDER BY PART")
F.Data.DataTable.CreateFromSQL("dtParts","con",V.Local.sSQL,True)

'-- WRONG: fragmented .Append building
V.Local.sSQL.Set("SELECT RTRIM(PART) AS Part_Number,")
V.Local.sSQL.Append(" QTY_ONHAND FROM V_INVENTORY_ALL")
V.Local.sSQL.Append(" WHERE PRODUCT_LINE = 'FG'")
```

## Recordsets -- BANNED FOR NEW CODE

> **DO NOT USE.** All OpenRecordset* methods are **banned** for new scripts. Use `F.Data.DataTable.CreateFromSQL` for multi-row queries and `F.ODBC.Connection!con.ExecuteAndReturn` for scalar lookups. Lint rules E10/E11/DEP12 flag recordset usage as ERROR. The reference below is retained only for maintaining legacy scripts.

### Legacy Reference (do not use in new code)
```
F.ODBC.Connection!con.OpenRecordsetRO("rst",V.Local.sSQL)    ' Read-only
F.ODBC.Connection!con.OpenRecordsetRW("rst",V.Local.sSQL)    ' Read-write
F.ODBC.Connection!con.OpenLocalRecordsetRO("rst",V.Local.sSQL)
F.ODBC.Connection!con.OpenLocalRecordsetRW("rst",V.Local.sSQL)

' Navigate
F.ODBC.con!rst.MoveFirst                                     ' Jump to first record
F.ODBC.con!rst.MoveLast                                      ' Jump to last record
F.ODBC.con!rst.MoveNext                                      ' Advance to next record
F.ODBC.con!rst.MovePrevious                                  ' Move to previous record

F.Intrinsic.Control.DoUntil(V.ODBC.con!rst.EOF,=,True)
    V.Local.sVal.Set(V.ODBC.con!rst.FieldVal!ColumnName)
    F.ODBC.con!rst.MoveNext
F.Intrinsic.Control.Loop

' Insert
F.ODBC.con!rst.AddNew
F.ODBC.con!rst.Set!ColumnName("value")
F.ODBC.con!rst.Update

' Delete / Close
F.ODBC.con!rst.Delete                                        ' Delete current record
F.ODBC.con!rst.Close

' Utility
F.ODBC.con!rst.Requery                                       ' Re-execute the recordset query
F.ODBC.con!rst.Record2String(sResult)                        ' Current record as delimited string
F.ODBC.con!rst.RecordType2String(sResult)                    ' Field types as delimited string
F.ODBC.con!rst.InvokeSpy                                     ' Launch recordset spy/debugger
```

## Recordset Variable Accessors (V.ODBC.*con!*rst.*)

These are read-only properties available on any ODBC recordset variable (`V.ODBC.<connection>!<recordset>.*`).

### BOF
Returns True if the record is positioned before the first record (no records before current position).
```
V.ODBC.con!rst.BOF
```

### EOF
Returns True if the record is positioned after the last record (no more records to process).
```
V.ODBC.con!rst.EOF
```

### FieldCount
Returns the number of fields (columns) in the current record.
```
V.ODBC.con!rst.FieldCount
```

### FieldType!{FieldName}
Returns the ADO data type value of a specified field.

| Value | Constant | Description |
|-------|----------|-------------|
| 2 | adSmallInt | 16-bit signed integer |
| 3 | adInteger | 32-bit signed integer |
| 4 | adSingle | Single-precision floating-point |
| 5 | adDouble | Double-precision floating-point |
| 6 | adCurrency | Currency value |
| 7 | adDate | Date or time value |
| 11 | adBoolean | Boolean (True/False) |
| 13 | adDecimal | Exact numeric with fixed precision |
| 17 | adByte | Unsigned 8-bit integer |
| 20 | adBigInt | 64-bit signed integer |
| 129 | adChar | Fixed-length string |
| 130 | adWChar | Fixed-length Unicode string |
| 200 | adVarChar | Variable-length string |
| 201 | adLongVarChar | Long variable-length string (Memo) |
| 202 | adVarWChar | Variable-length Unicode string |
| 203 | adLongVarWChar | Long Unicode string (Memo) |
| 204 | adBinary | Fixed-length binary data |
| 205 | adLongVarBinary | Long binary data (BLOB) |

```
V.ODBC.con!rst.FieldType!ID            ' Returns 2 (adSmallInt) for a smallint column
V.ODBC.con!rst.FieldType!Name          ' Returns 129 (adChar) for a char column
```

### FieldVal!{FieldName}
Returns the value of a specified field as a string.
```
V.ODBC.con!rst.FieldVal!ID             ' Returns "1"
V.ODBC.con!rst.FieldVal!Name           ' Returns "John Doe"
```

### FieldValFloat!{FieldName}
Returns the value of a specified field as a floating-point number (double).
```
V.ODBC.con!rst.FieldValFloat!Total     ' Returns 1.79
```

### FieldValIsNull!{FieldName}
Returns True if the value of the specified field is Null; otherwise False.
```
V.ODBC.con!rst.FieldValIsNull!ID       ' Returns False
V.ODBC.con!rst.FieldValIsNull!Name     ' Returns True (when field is NULL)
```

### FieldValIsNumeric!{FieldName}
Returns True if the value of the specified field is numeric; otherwise False.
```
V.ODBC.con!rst.FieldValIsNumeric!ID    ' Returns True
V.ODBC.con!rst.FieldValIsNumeric!Name  ' Returns False
```

### FieldValLeft{nn}!{FieldName}
Returns the leftmost *nn* characters of the field value, where *nn* is a two-digit number embedded in the method name.
```
V.ODBC.con!rst.FieldValLeft05!Name     ' "John Doe" -> "John "
V.ODBC.con!rst.FieldValLeft10!Code     ' Returns first 10 characters of Code
```

### FieldValLong!{FieldName}
Returns the value of a specified field as a long integer.
```
V.ODBC.con!rst.FieldValLong!ID         ' Returns 1
```

### FieldValLTrim!{FieldName}
Returns the field value with leading spaces removed.
```
V.ODBC.con!rst.FieldValLTrim!Name      ' "     John Doe     " -> "John Doe     "
```

### FieldValNot!{FieldName}
Returns the bitwise NOT of the field value (numeric context). For DataTable rows, `FieldValNot` returns the boolean negation instead -- see `agents/gab/DATA_DATATABLE.md`.
```
V.ODBC.con!rst.FieldValNot!SampleColumnA   ' 0 -> -1  (bitwise NOT)
V.ODBC.con!rst.FieldValNot!SampleColumnB   ' 1 -> -2  (bitwise NOT)
```

### FieldValOrdinal!{Index}
Returns the field value by ordinal (zero-based) position instead of field name.
```
V.ODBC.con!rst.FieldValOrdinal!0       ' Value of first column
V.ODBC.con!rst.FieldValOrdinal!1       ' Value of second column
```

### FieldValPervasiveDate!{FieldName}
Returns a date field formatted as `yyyy-MM-dd`.
```
V.ODBC.con!rst.FieldValPervasiveDate!SampleDate   ' Returns "2024-09-27"
```

### FieldValRight{nn}!{FieldName}
Returns the rightmost *nn* characters of the field value, where *nn* is a two-digit number embedded in the method name.
```
V.ODBC.con!rst.FieldValRight05!Name    ' "John Doe" -> "n Doe"
V.ODBC.con!rst.FieldValRight03!Code    ' Returns last 3 characters of Code
```

### FieldValRTrim!{FieldName}
Returns the field value with trailing spaces removed.
```
V.ODBC.con!rst.FieldValRTrim!Name      ' "     John Doe     " -> "     John Doe"
```

### FieldValString!{FieldName}
Returns the field value explicitly converted to a string.
```
V.ODBC.con!rst.FieldValString!Name     ' Returns "John Doe"
```

### FieldValTrim!{FieldName}
Returns the field value with both leading and trailing spaces removed.
```
V.ODBC.con!rst.FieldValTrim!Name       ' "     John Doe     " -> "John Doe"
```

### Set!{FieldName}(Value)
Sets the value of a specified field on the current record. Used between `.AddNew` and `.Update` when inserting, or directly before `.Update` when editing.
```
F.ODBC.con!rst.AddNew
F.ODBC.con!rst.Set!CustomerName("Acme Corp")
F.ODBC.con!rst.Set!Status("Active")
F.ODBC.con!rst.Update
```

### State
Returns 1 if the recordset (or connection) is open and ready. Use to guard Close calls.

**Recordset close** — guard with `V.ODBC.<con>!<rst>.State`, then close the **recordset**:
```
' Check recordset state before closing
F.Intrinsic.Control.If(V.ODBC.con!rst.State,=,1)
    F.ODBC.con!rst.Close
F.Intrinsic.Control.EndIf
```

**Connection close** — guard with `V.ODBC.<con>.State`, then close the **connection**:
```
' Check connection state before closing
F.Intrinsic.Control.If(V.ODBC.con.State,=,1)
    F.ODBC.Connection!con.Close
F.Intrinsic.Control.EndIf
```

> **Warning:** Closing an already-closed connection in error handlers can overwrite the original error number.

### Quick Reference Table
| Accessor | Returns | Description |
|----------|---------|-------------|
| `.BOF` | Boolean | Before first record |
| `.EOF` | Boolean | After last record |
| `.FieldCount` | Long | Number of columns |
| `.FieldType!{Field}` | Long | ADO data type code |
| `.FieldVal!{Field}` | String | Field value |
| `.FieldValFloat!{Field}` | Float | Field as double |
| `.FieldValIsNull!{Field}` | Boolean | True if NULL |
| `.FieldValIsNumeric!{Field}` | Boolean | True if numeric |
| `.FieldValLeft{nn}!{Field}` | String | Leftmost nn characters |
| `.FieldValLong!{Field}` | Long | Field as long integer |
| `.FieldValLTrim!{Field}` | String | Left-trimmed value |
| `.FieldValNot!{Field}` | Long | Bitwise NOT of value |
| `.FieldValOrdinal!{Index}` | String | Field by zero-based index |
| `.FieldValPervasiveDate!{Field}` | String | Date as yyyy-MM-dd |
| `.FieldValRight{nn}!{Field}` | String | Rightmost nn characters |
| `.FieldValRTrim!{Field}` | String | Right-trimmed value |
| `.FieldValString!{Field}` | String | Explicit string conversion |
| `.FieldValTrim!{Field}` | String | Both-sides-trimmed value |
| `.Set!{Field}(value)` | (write) | Set field value before `.Update` |
| `.State` | Long | 1 = open/ready |

## Additional Connection Methods
```
F.ODBC.Connection!con.CloseRecordsets                         ' Close and destroy all recordsets for this connection
F.ODBC.Connection!con.OpenMDBConnection(sPath)                ' Open Microsoft Access (.mdb/.accdb) database
F.ODBC.Connection!con.StoredProcExistsPervasive(sProcName,bResult)  ' Check if a stored proc exists (Pervasive only)
```

## ODBC Utilities
```
F.ODBC.Misc.IsDSN(sDSNName,bResult)                ' Check if a DSN exists
F.ODBC.Misc.GetDSNList(sResult)                     ' Get array of all available DSNs
F.ODBC.Misc.GetDriverList(sResult)                  ' Get array of installed ODBC drivers
F.ODBC.Misc.GetGlobalDSNList(sResult)               ' Get array of system-level DSNs
F.ODBC.Misc.SwitchIHOPCreds(sToken)                 ' Switch IHOP credentials with token
```

## Transactions
```
F.ODBC.Connection!con.BeginTransaction
F.ODBC.Connection!con.CommitTransaction
F.ODBC.Connection!con.RollbackTransaction
```
Wrap multi-statement DB writes in transactions. Always rollback on error.

## Stored Procedures
```
F.ODBC.Connection!con.RunStoredProc(sProcName,sParamNames,sParamTypes,sParamDirections,sParamSizes,sParamValues,sResult)
F.ODBC.Connection!con.RunStoredProcNR(sProcName,sParamNames,sParamTypes,sParamDirections,sParamSizes,sParamValues)
F.ODBC.Connection!con.RunStoredProcRst(sRstName,sProcName,sParamNames,sParamTypes,sParamDirections,sParamSizes,sParamValues)
F.ODBC.Connection!con.RunStoredProcRstLocal(sRstName,sProcName,sParamNames,sParamTypes,sParamDirections,sParamSizes,sParamValues)
```
NR = no return, Rst = returns recordset, RstLocal = local recordset.

## ADO.NET Connections
```
F.ODBC.Connection!con.OpenADONetConnection(sConnectionString)
F.ODBC.Connection!con.OpenADONetConnection(sConnectionString,iTimeout)
F.ODBC.Connection!con.OpenADONetCompanyConnection
F.ODBC.Connection!con.OpenADONetCommonConnection
F.ODBC.Connection!con.OpenConnectionPSQL(sDSN,sUser,sPass)
F.ODBC.Connection!con.OpenConnectionPSQL(sDSN,sUser,sPass,iTimeout)
```

## Azure SQL Connections
```
F.Data.AzureSQL.OpenConnection(sServer,sDatabase,sUser,sPassword,[iCommandTimeout])
F.Data.AzureSQL.CloseConnection
```

## Schema Functions
```
F.ODBC.Connection!con.TableExists(sTableNames,bResult)
F.ODBC.Connection!con.FieldExists(sTable,sFieldNames,bResult)
F.ODBC.Connection!con.GetSchemaList(bTables,bViews,sResult)
F.ODBC.Connection!con.GetSchemaFieldList(sTable,sResult)
F.ODBC.Connection!con.GetID(sTable,sField,iResult)
```

## BLOB Operations
```
F.ODBC.con!rst.SaveFiletoBLOB(sFieldName,sFilePath)
F.ODBC.con!rst.SaveBLOBtoFile(sFieldName,sFilePath)
```

---

