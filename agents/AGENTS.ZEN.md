---
AGENT_TITLE: Actian Zen v15 SQL Engine Reference
AGENT_DESCRIPTION: SQL engine reference for Actian Zen v15, the database engine behind Global Shop Solutions.
AGENT_USAGE: Load when writing Zen/Pervasive SQL or working with the Actian Zen database engine.
---

# Actian Zen v15 — SQL Engine Reference Agent

**Online docs:** https://docs.actian.com/zen/v15/

---

# CRITICAL! Zen SQL Is NOT Standard SQL
- Zen SQL is based on ODBC SQL grammar. It is **not** MySQL, PostgreSQL, or SQL Server.
- Always verify syntax against this reference. Do **not** assume standard SQL syntax works.
- Key differences: No ELSEIF, no REPEAT...UNTIL, variables prefixed with `:` or `@`, CASE only inside SELECT, IDENTITY uses 0 for auto-assign.

### SQL Editor and batch execution
- Zen Control Center SQL Editor may require **statement delimiters** (`#` or `;`) to run multiple statements in one batch.
- Many other SQL clients execute one statement at a time; **strip** delimiters when pasting examples there.

---

## SQL Syntax Reference — how this file maps to the manual

Official **SQL Engine Reference → SQL Syntax Reference** is alphabetical (ADD … WHILE) and very large. This file **distributes** the same material by task; use the online/PDF topic for full grammar, examples, and edge cases.

| Manual topic | Where it lives here |
|--------------|---------------------|
| **Literal Values** (strings, `N'…'`, date/time/timestamp, vendor escapes) | **Literal Formats**; **Data Types** for typing/conversion context |
| **Statements** (CREATE/ALTER/DROP, DML, CALL, transactions, …) | **DDL**, **DML**, **Stored Procedures**, **Triggers**, **Transactions**, **Security** |
| **Global Variables** | **Global Variables** |
| **SET** session statements | **SET Statements (Session)** |
| **Grammar Element Definitions** / **SQL Statement List** (BNF) | Actian **SQL Syntax Reference** only—too verbose to mirror here |
| **Other Characteristics** (temp files, NULL, binary literals, indexable widths, decimal comma) | **SQL Engine Performance Reference** (temp files), **Literal Formats** / **Data Types**, **CREATE INDEX**, **SET DECIMALSEPARATORCOMMA** |
| **COALESCE** (combination types), **SELECT** (**AS** aliases), **WHERE** (**ANY** / **ALL**) | **Logical Functions** → **COALESCE**; **SELECT** → **AS (aliases)**; **WHERE Clause Operators** → **Quantified ANY and ALL** |

---

## Relational Engine Limits

| Feature | V1 Metadata | V2 Metadata |
|---------|-------------|-------------|
| Column name | 20 bytes | 128 bytes |
| Table/View/Index/Procedure/Trigger/Function/Group/User name | 20–30 bytes | 128 bytes |
| Database name | 20 bytes | 20 bytes |
| CHAR/VARCHAR column size | 8,000 bytes | 8,000 bytes |
| NCHAR/NVARCHAR column size | 4,000 UCS-2 (8,000 bytes) | 4,000 UCS-2 |
| Columns in a table | 1,536 | 1,536 |
| SELECT list columns | 1,600 | 1,600 |
| Parameters in stored procedure | 300 | 300 |
| Stored procedure body size | 64 KB | 64 KB |
| SQL statement length | 512 KB | 512 KB |
| Max database objects | 65,536 | 4 billion |
| Max ANDed/ORed predicates | 3,000 | 3,000 |
| Max nested subqueries | 16 | 16 |
| Max fully-indexed column | 255 bytes | 255 bytes |
| Password | 8 bytes | 128 bytes |
| Data file path | 64 bytes | 250 bytes |
| Quoted literal | 14,997 chars (15,000 total) | same |

---

## Data Types — Complete Mapping

> Use `INTEGER` (not `INT`) in agent-generated SQL. While `INT` may parse, `INTEGER` is the canonical Zen type name.

### Transactional (Btrieve) → Relational (SQL) Type Map

`Mk` = MicroKernel metadata type code (see **Btrieve key types** below). **30** for DATETIME is a Relational Engine identifier, not an MK transactional code.

| Transactional Type | SQL Type | Mk | Size (bytes) | Parameters |
|--------------------|----------|-----|--------------|------------|
| AUTOINCREMENT(2) | SMALLIDENTITY | 15 | 2 | |
| AUTOINCREMENT(4) | IDENTITY | 15 | 4 | |
| AUTOINCREMENT(8) | BIGIDENTITY | 15 | 8 | |
| AUTOTIMESTAMP | AUTOTIMESTAMP | 32 | 8 | not null |
| BFLOAT(4) | BFLOAT4 | 9 | 4 | not null |
| BFLOAT(8) | BFLOAT8 | 9 | 8 | not null |
| BLOB | LONGVARBINARY | 21 | n/a | not null |
| BLOB(2) | NLONGVARCHAR | 21 | n/a | not null, case insensitive |
| CLOB | LONGVARCHAR | 21 | n/a | not null, case insensitive |
| CURRENCY | CURRENCY | 19 | 8 | not null |
| DATE | DATE | 3 | 4 | not null |
| DATETIME | DATETIME | 30 | 8 | not null; relational only |
| DECIMAL | DECIMAL | 5 | 1–64 | precision, scale, not null |
| FLOAT(4) | REAL | 2 | 4 | not null |
| FLOAT(8) | DOUBLE | 2 | 8 | not null |
| GUID | UNIQUEIDENTIFIER | 27 | 16 | not null |
| INTEGER(1) | TINYINT | 1 | 1 | not null |
| INTEGER(2) | SMALLINT | 1 | 2 | not null |
| INTEGER(4) | INTEGER | 1 | 4 | not null |
| INTEGER(8) | BIGINT | 1 | 8 | not null |
| MONEY | DECIMAL | 6 | 1–64 | precision, scale, not null |
| NUMERIC | NUMERIC | 8 | 1–37 | precision, scale, not null; not usable as **variable** or **procedure** parameter type (appendix A) |
| NUMERICSA | NUMERICSA | 18 | 1–37 | precision, scale, not null |
| NUMERICSLB | NUMERICSLB | 28 | 1–37 | precision, scale, not null |
| NUMERICSLS | NUMERICSLS | 29 | 1–37 | precision, scale, not null |
| NUMERICSTB | NUMERICSTB | 31 | 1–37 | precision, scale, not null |
| NUMERICSTS | NUMERICSTS | 17 | 1–37 | precision, scale, not null |
| STRING (binary, FIELD.DDF) | BINARY | 0 | 1–8000 | size, not null, case insensitive; zero-padded (see COLUMNMAP / column flags, DTI & DTO guides) |
| STRING (text, code page) | CHAR | 0 | 1–8000 | size, not null, case insensitive; space-padded |
| WSTRING / STRING(2) | NCHAR | 25 | 2–8000 (1–4000 UCS-2) | size in UCS-2 units, not null, case insensitive |
| TIME | TIME | 4 | 4 | not null |
| TIMESTAMP | TIMESTAMP | 20 | 8 | not null |
| TIMESTAMP2 | TIMESTAMP2 | 34 | 8 | not null |
| UNSIGNED(1) BINARY | UTINYINT | 14 | 1 | not null |
| UNSIGNED(2) BINARY | USMALLINT | 14 | 2 | not null |
| UNSIGNED(4) BINARY | UINTEGER | 14 | 4 | not null |
| UNSIGNED(8) BINARY | UBIGINT | 14 | 8 | not null |
| LVAR | VARCHAR | 11 | 2–8000 | size, not null, case |
| LVAR(2) | NVARCHAR | 26 | 2–8000 (1–4000 UCS-2) | size, not null, case |
| ZSTRING | VARCHAR | 11 | 2–8001 | size, not null, case insensitive |
| WZSTRING | NVARCHAR | 26 | 2–8000 (1–4000 UCS-2) | size, not null, case insensitive |
| (none) | BIT | 16 | 1 bit | Native SQL **BIT**; **`TRUEBITCREATE=ON`** (default) |
| LOGICAL(1) | BIT | 7 | 1 bit | Legacy transactional **LOGICAL(1)** mapped to **BIT**; **`TRUEBITCREATE=OFF`** (appendix A) |
| LOGICAL(2) | SMALLINT | 1 | 2 | not null; legacy **LOGICAL(2)** width |

**BIT vs LOGICAL:** Do not assume one **`TRUEBITCREATE`** rule for both. New **`BIT`** columns use relational metadata code **16** with **`TRUEBITCREATE=ON`**. Older **LOGICAL(1)** fields use Mk **7** on the transactional side and require **`TRUEBITCREATE=OFF`** to surface as **BIT** in SQL.

### Non-Indexable Types
BIT, BLOB, CLOB, LONGVARBINARY, LONGVARCHAR, NLONGVARCHAR

### Null Handling
- Each nullable column adds 1 null-indicator byte to the physical record
- `SET TRUENULLCREATE=OFF` suppresses the extra byte
- Cannot change to NOT NULL if column contains NULLs
- Cannot modify null attribute if column has PK/FK

### Legacy Types (Avoid)

| Legacy transactional | Legacy Mk | Replaced by (SQL) | New Mk |
|------------------------|-----------|-------------------|--------|
| LOGICAL(1) | 7 | BIT | 16 |
| LOGICAL(2) | 7 | SMALLINT | 1 |
| LSTRING | 10 | VARCHAR | 11 |
| LVAR | 13 | LONGVARCHAR | 21 |
| NOTE | 12 | LONGVARCHAR | 21 |

Existing databases using legacy types still work. For **new** DDL with legacy types: `SET LEGACYTYPESALLOWED=ON` before `CREATE TABLE` / `ALTER TABLE`, then `SET LEGACYTYPESALLOWED=OFF` (or let the session end). See **SET LEGACYTYPESALLOWED** in session statements.

### Data type notes (appendix A summary)

- **Parameters:** Required: **precision**, **size**. Optional: **case insensitive**, **not null**, **scale**.
- **CHAR/NCHAR:** space-padded; **NCHAR/WSTRING** padding uses Unicode spaces (2 bytes). **BINARY:** zero-padded. **VARCHAR**, **NVARCHAR**, **LONGVARCHAR**, **NLONGVARCHAR**: NULL-terminated; not padded with trailing blanks for storage.
- **STRING → BINARY:** flag in FIELD.DDF tells SQL to use binary (see COLUMNMAP flags, Distributed Tuning Interface / Objects guides).
- **BLOB(2) / NLONGVARCHAR:** FIELD.DDF flag for NLONGVARCHAR (same guides).
- **NUMERIC** variants **NUMERIC**, **NUMERICSA**, **NUMERICSLB**, **NUMERICSLS**, **NUMERICSTB**, **NUMERICSTS**: cannot be used as **procedure/variable** types in some contexts (see full appendix).
- **BLOB/CLOB/LONG***: cannot be indexed; large-object limits apply. **BLOB** and **CLOB** use an 8-byte header in the fixed record plus data in the variable portion; combined LOB/CLOB payload must respect the **2GB** variable-offset model (single max-sized LOB per record when storing ~2GB). See appendix A **Non-Key Data Types**.
- **AUTOTIMESTAMP:** sorts like **UBIGINT**. **DATETIME:** type code **30** is relational metadata, not an MK engine code.

### Value ranges (selected relational types)

| Type | Range / notes |
|------|----------------|
| AUTOTIMESTAMP | 1970-01-01 … 2554-07-21 (ns epoch); **0** on insert/update → current time |
| BIGIDENTITY, BIGINT | −9223372036854775808 … 9223372036854775807 |
| BFLOAT4 | −1.70141172e+38 … +1.70141173e+38; smallest increment ≈ 2.938736e−39 |
| BFLOAT8 | −1.70141173e+38 … +1.70141173e+38; smallest increment ≈ 2.93873588e−39 |
| CURRENCY | −922337203685477.5808 … 922337203685477.5807 |
| DATE | 0001-01-01 … 9999-12-31; **0000-00-00** invalid—legacy data may use it; query with `IS NULL` pattern per manual |
| DATETIME | 1753-01-01 00:00:00.000 … 9999-12-31 23:59:59.999 (1 ms) |
| DOUBLE | −1.7976931348623157e+308 … +1.7976931348623157e+308; smallest increment ≈ 2.2250738585072014e−308 |
| REAL (FLOAT 4) | −3.4028234E+38 … +3.4028234e+38; smallest increment ≈ 1.4E−45 |
| IDENTITY / INTEGER | −2147483648 … 2147483647 |
| MONEY | −99999999999999999.99 … 99999999999999999.99 |
| NUMERIC / DECIMAL | Precision/scale dependent (below) |
| SMALLIDENTITY / SMALLINT | −32768 … 32767 |
| TIME | 00:00:00 … 23:59:59 |
| TIMESTAMP | 0001-01-01 … 9999-12-31 UTC (7-digit fractional sec default; scale configurable) |
| TIMESTAMP2 | 1970-01-01 … 2554-07-21 UTC (nanoseconds) |
| TINYINT | −128 … 127 |
| UBIGINT | 0 … 18446744073709551615 |
| UINTEGER | 0 … 4294967295 |
| USMALLINT | 0 … 65535 |
| UTINYINT | 0 … 255 |

### Representation of infinity (FLOAT / DOUBLE)

When Zen must represent infinity (e.g. for C float/double interchange), values may appear in hexadecimal or character form:

| Value | Float (hex) | Float (char) | Double (hex) | Double (char) |
|-------|-------------|--------------|--------------|---------------|
| Max positive | — | — | `0x7FEFFFFFFFFFFFFF` | — |
| Max negative | — | — | `0xFFEFFFFFFFFFFFFF` | — |
| +Infinity | `0x7F800000` | `1E999` | `0x7FF0000000000000` | `1E999` |
| −Infinity | `0xFF800000` | `-1E999` | `0xFFF0000000000000` | `-1E999` |

### Operator precedence (expressions)

1. Unary `+`, `-`, `~`  
2. `*`, `/`, `%`  
3. `+`, `-`, `+` (concatenate), `&` (bitwise AND)  
4. `=`, `>`, `<`, `>=`, `<=`, `<>`, `!=`  
5. `^`, `|` (bitwise XOR, OR)  
6. `NOT`  
7. `AND`  
8. `ALL`, `ANY`, `BETWEEN`, `IN`, `LIKE`, `OR`, `SOME`  
9. `=` (assignment)

Equal precedence: left-to-right. Example: `SET :Counter = 12 / 4 * 7` → **21** (divide then multiply). Parentheses override; nested: innermost first.

### Data type precedence

**Numeric** (higher wins; lower type promoted): DOUBLE, FLOAT, BFLOAT8 → REAL, BFLOAT4 → DECIMAL, NUMERIC, NUMERICSA, NUMERICSTS → NUMERICSLS, NUMERICSTB, NUMERICSLB → CURRENCY, MONEY → BIGINT, UBIGINT, BIGIDENTITY → INTEGER, UINTEGER, IDENTITY → SMALLINT, USMALLINT, SMALLIDENTITY → TINYINT, UTINYINT → BIT.

**Character:** NLONGVARCHAR → NCHAR, NVARCHAR → LONGVARCHAR → CHAR, VARCHAR.

**Concatenation results:** NCHAR/NVARCHAR + NLONGVARCHAR → NLONGVARCHAR; NCHAR + LONGVARCHAR → NLONGVARCHAR; CHAR/VARCHAR + LONGVARCHAR → LONGVARCHAR; CHAR + VARCHAR → type of **left** operand; VARCHAR + CHAR → VARCHAR.

**No precedence / disallowed combinations:** BINARY, LONGVARBINARY, UNIQUEIDENTIFIER (no combining ops). **No** mixing one date/time type with another in `+`/`-` without functions—use **TIMESTAMPADD**, **DATEADD**, **TIMESTAMPDIFF**, **DATEDIFF** (required for **AUTOTIMESTAMP** / **TIMESTAMP2** in many cases).

### DECIMAL precision and scale

- **Precision** = total digits; **scale** = digits right of decimal (e.g. 909.777 → p=6, s=3).
- Max precision: **64** for NUMERIC, NUMERICSA, DECIMAL; **63** for NUMERICSTS, NUMERICSLS (one byte for sign).
- Same-type arithmetic keeps that type’s precision/scale; mixed types follow **numeric precedence**. Result is **DECIMAL** when both operands are DECIMAL, or one is DECIMAL and the other is lower precedence than DECIMAL.

| Operation | Precision | Scale |
|-----------|-----------|-------|
| + / − | max(s1,s2) + max(p1−s1, p2−s2) + 1 | max(s1, s2) |
| * | p1 + p2 + 1 | s1 + s2 |
| / | p1 − s1 + s2 + max(6, s1 + p2 + 1) | max(6, s1 + p2 + 1) |
| UNION | same as + | same as + |

Example: DECIMAL(8,2) + DECIMAL(7,4) → DECIMAL(11,4).

### Timestamp scale (Zen 14.10+)

| Type | Default scale | Notes |
|------|----------------|-------|
| AUTOTIMESTAMP | 9 (ns) | Format `yyyy-mm-dd hh:mm:ss.nnnnnnnnn` |
| DATETIME | 3 (ms) | |
| TIMESTAMP | 3 | `TIMESTAMP(n)` for **0–7** (septaseconds) |
| TIMESTAMP2 | 9 | `TIMESTAMP2(n)` for **0–9** (ns) |

Shortening scale **truncates** fractional seconds; it does **not** round. Function result scales: **CURRENT_TIMESTAMP()** / **NOW()** → ms (3); **SYSDATETIME()** / **SYSUTCDATETIME()** → ns (9). Writing a smaller-scale value into a larger-scale column zero-fills trailing fractional digits.

### Truncation vs other DBMS

Zen **truncates** numeric strings and true numerics on insert (e.g. 123.457 → column precision 2 → **123.45**); some other DBMS **round**. **SQL_SUCCESS_WITH_INFO** / truncation reporting timing also differs. Port carefully.

### CHAR, VARCHAR, LONG text

- **CHAR/NCHAR:** trailing blanks not counted in `=` / `LIKE` unless explicitly in pattern (e.g. `'abc %'` includes the space before `%`).
- **VARCHAR/NVARCHAR:** trailing blanks **are** significant in comparisons (`'Test '` ≠ `'Test'`).
- **LONGVARCHAR / NLONGVARCHAR / LONGVARBINARY:** `LIKE` uses first **65500** bytes; other predicates use first **256** bytes; `GROUP BY` / `DISTINCT` / `ORDER BY` sort on first **256** bytes (full data may still return). Max column ~2GB; **literal** in `INSERT` ~**15000** bytes—use **parameterized** insert for more. Variable-length column **physical order** on disk may differ from logical column order after `ALTER` (appendix A illustrates with altering a fixed column to **LONGVARCHAR**):

```sql
-- Simplified layout: after ALTER, existing rows may hold VL segments out of logical column order;
-- new inserts (all columns populated) tend to follow logical order. See SQL Engine Reference appendix A.
CREATE TABLE BlobDataTest (Nbr UINTEGER, Clob1 LONGVARCHAR, Clob2 LONGVARCHAR, Blob1 LONGVARBINARY);
-- ALTER TABLE BlobDataTest ALTER Nbr LONGVARCHAR;  -- VL heap order for old rows can differ from column list order
```

### BINARY and LONGVARBINARY

**BINARY:** trailing **zeros**. **LONGVARBINARY:** not blank-padded. Engine compares fixed **BINARY**; **LONGVARBINARY** is not compared by the engine like fixed binary. **Hex string literals:** odd-length hex gets a **leading zero** nibble when stored (see **Literal Formats**).

### DATETIME (relational only)

Two 4-byte parts: days vs **1900-01-01** and ms after midnight. Indexable; accuracy **1 ms**. Components: year 1753–9999, month 01–12, day 01–31, hour 00–23, minute 00–59, second 00–59, ms 000–999.

### Date/time arithmetic (examples)

Valid: `SELECT "Start_Date" + 5 FROM t`, `"Finish_Time" - "Start_Time"`, `current_timestamp() - "Log"`. Invalid / errors: date + float, time + time, timestamp + timestamp in ways that yield incompatible types—use **DATEADD** / **TIMESTAMPADD** / diffs. **CONVERT** / **CAST** for DATE, DATETIME, TIME, TIMESTAMP: see matrices below.

### TIMESTAMP / TIMESTAMP2 and wall-clock data

Values are stored in **UTC**; read back in **local** time using the **engine host** time zone. **DST** and engine moves between zones shift displayed local times—**bad for real-world appointments**. For external events use **DATE** + **TIME** (not UTC-converted). Use **TIMESTAMP** / **TIMESTAMP2** mainly for **ordering** rows in the database.

### CONVERT (from → permitted SQL_ types)

| From | To |
|------|-----|
| AUTOTIMESTAMP | SQL_CHAR, SQL_DATE, SQL_TIME, SQL_TIMESTAMP, SQL_VARCHAR |
| DATE | SQL_CHAR, SQL_DATE, SQL_TIMESTAMP, SQL_VARCHAR |
| DATETIME | All supported **SQL_** types except GUID, BINARY, LONGVARBINARY |
| TIME | SQL_CHAR, SQL_TIME, SQL_TIMESTAMP, SQL_VARCHAR |
| TIMESTAMP, TIMESTAMP2 | SQL_CHAR, SQL_DATE, SQL_TIME, SQL_TIMESTAMP, SQL_VARCHAR |
| VARCHAR | SQL_CHAR, SQL_DATE, SQL_TIME, SQL_TIMESTAMP, SQL_VARCHAR |

Use `CONVERT(expr, SQL_type [, style])`. Optional style can truncate DATETIME ms (see conversion functions topic).

### CAST (from → permitted relational types)

| From | To |
|------|-----|
| AUTOTIMESTAMP | DATE, DATETIME, TIME, TIMESTAMP, TIMESTAMP2, VARCHAR |
| DATE | DATE, DATETIME, TIMESTAMP, VARCHAR |
| DATETIME | Any relational type |
| TIME | TIME, DATETIME, TIMESTAMP, TIMESTAMP2, VARCHAR |
| TIMESTAMP, TIMESTAMP2 | DATE, DATETIME, TIME, TIMESTAMP, TIMESTAMP2, VARCHAR |
| VARCHAR | DATE, DATETIME, TIME, TIMESTAMP, TIMESTAMP2 |

### UNIQUEIDENTIFIER

16-byte GUID; file format **9.5+**. Initialize with **NEWID()** or full 32-hex string `'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'` (all digits required; engine does not pad partial strings). **Permitted comparison operators:** `=`, `<>`, `!=`, `<`, `>`, `<=`, `>=`, `IS NULL`, `IS NOT NULL`. Ordering is **not** raw bit-pattern compare (per appendix A). **CAST** / **CONVERT** to CHAR, VARCHAR, LONGVARCHAR.

```sql
DECLARE :Cust_ID UNIQUEIDENTIFIER DEFAULT NEWID();
SET :ISO_ID = '1129619D-772C-AAAB-B221-00FF00FF0099';
```

### Btrieve key types (pointer)

Indexable transactional types and **Mk** codes (AUTOINCREMENT 15, AUTOTIMESTAMP 32, BFLOAT 9, STRING 0, …) plus storage/colloquial details—**AUTOINCREMENT** sequencing, **NUMERIC** COBOL signs, **DECIMAL** packed format, registry **CommonCOBOLDecimalSign** / **DBCobolNumeric**, **GUID** sort byte order, etc.—are documented at length in **SQL Engine Reference appendix A**. Use the official PDF/HTML for key design and maintenance tools (**butil -stat**, Atstamp/TS2).

---

## DDL — Data Definition Language

### CREATE TABLE
```sql
CREATE TABLE table-name [DCOMPRESS | PCOMPRESS | PAGESIZE=size | LINKDUP=n | SYSDATA_KEY_2]
  [IN DICTIONARY] [USING 'path'] [WITH REPLACE]
  (column-def [, column-def | table-constraint]...)

column-def ::= col-name data-type [DEFAULT expr] [NOT NULL] [NOT MODIFIABLE]
  [UNIQUE | PRIMARY KEY] [CASE | COLLATE name]
  [REFERENCES table [(col)] [ON DELETE CASCADE|RESTRICT] [ON UPDATE RESTRICT]]
```
- Record size limit: fixed-length ≤ 65535 bytes
- PAGESIZE: 4096–16384 (v13.0+)
- Default file: `xxx.mkd`
- **`USING 'path'`:** Relative paths resolve from the database’s **first data path** (see official **CREATE TABLE**). For **CREATE TABLE**, if the relative path’s directory structure is missing, Zen **may create** directories as needed. (Contrast **ALTER TABLE … USING** below.)

### ALTER TABLE
```sql
ALTER TABLE table-name [IN DICTIONARY] [USING 'path'] [WITH REPLACE]
  ADD [COLUMN] col-def | ADD table-constraint
  | ALTER [COLUMN] col-def | MODIFY [COLUMN] col-def
  | DROP [COLUMN] col-name | DROP CONSTRAINT name | DROP PRIMARY KEY
  | PSQL_MOVE [COLUMN] col TO [PSQL_PHYSICAL] PSQL_POSITION n
  | RENAME COLUMN col TO new-col
```
- Exclusive lock required (status 88 if table open)
- MODIFY: target column cannot have PK/FK
- **`ADD`:** introduces column definitions, column constraints, or table constraints (see official **ALTER TABLE** topic).
- **`USING 'path'`:** Relative paths resolve from the **first data path**. The directory tree for the path **must already exist**; Zen **does not** create directories for **ALTER TABLE** `USING` (unlike **CREATE TABLE** `USING`).

### CREATE INDEX

Use **CREATE INDEX** to create a named index on a table. Authoritative topic: **SQL Engine Reference → CREATE INDEX** ([Zen v15](https://docs.actian.com/zen/v15/)).

```sql
CREATE [ UNIQUE | PARTIAL ] [ NOT MODIFIABLE ] INDEX index-name
  [ USING index-number ] [ IN DICTIONARY ]
  ON table-name ( index-definition )

index-name ::= user-defined-name
index-number ::= integer 0–118
table-name ::= user-defined-name
index-definition ::= index-segment-definition [, index-segment-definition ]...
index-segment-definition ::= column-name [ ASC | DESC ]
```

The parentheses in **`ON table-name ( … )`** wrap the comma-separated segment list.

**Remarks (column storage vs index bytes)** — **VARCHAR** reserves an extra byte (Btrieve lstring length or zstring terminator) vs **CHAR** fixed width; **NVARCHAR** reserves **2** bytes (zero terminator) vs **NCHAR** fixed width. Example: **CHAR(100)** uses 100 bytes in the record; **VARCHAR(100)** uses 101. **NCHAR(50)** uses 100 bytes; **NVARCHAR(50)** uses 102. Include overhead when reasoning about index segment size.

**How index creation applies (summary)**

| Statement shape | Where it is written | Result |
|-----------------|----------------------|--------|
| **CREATE INDEX** (neither **USING** nor **IN DICTIONARY**) | Data file **and** **X$Index** | New index number = **0** if the file had none; else **smallest unused** index number. **X$Index** gets a matching entry. |
| **CREATE INDEX** … **IN DICTIONARY** | **X$Index** only (not the data file) | Engine picks a number from the data file’s keys: if a data-file index matches columns/attributes, reuse it; else **largest data-file index number + 1**. An **X$Index** entry with no matching data-file key is a **phantom index** (not used by the engine). |
| **CREATE INDEX** … **USING** *n* | Data file **and** **X$Index** | Uses index number *n*. If *n* is already used in either place → error (status **5** duplicate in **X$Index**, **6** invalid key number on data file). |
| **CREATE INDEX** … **USING** *n* … **IN DICTIONARY** | **X$Index** only | Allowed only if the data file already has index *n* **and** its definition matches; then **X$Index** is updated. Otherwise error (e.g. *Btrieve key definition does not match the index definition*). |

**Index segments and page size** — Total segments across all indexes on a file depend on **page size** and **file version**. **How to read the table:** each row is a **page size** in bytes; columns are **file format / engine generation** labels (**8.x**, **9.0**, **9.5**, **13.0**) giving the **maximum key segments** for that combination. Footnotes explain **Rounded up** page sizes, **N/A**, and the **119** index cap vs. higher segment counts on newer files.

Maximum key segments (by page size × version):

| Page size (bytes) | 8.x and earlier | 9.0 | 9.5 | 13.0 |
|-------------------|-----------------|-----|-----|------|
| 512 | 8 | 8 | Rounded up¹ | Rounded up¹ |
| 1,024 | 23 | 23 | 97 | Rounded up¹ |
| 1,536 | 24 | 24 | Rounded up¹ | Rounded up¹ |
| 2,048 | 54 | 54 | 97 | Rounded up¹ |
| 2,560 | 54 | 54 | Rounded up¹ | Rounded up¹ |
| 3,072 | 54 | 54 | Rounded up¹ | Rounded up¹ |
| 3,584 | 54 | 54 | Rounded up¹ | Rounded up¹ |
| 4,096 | 119 | 119 | 2043³ | 1833³ |
| 8,192 | N/A² | 119 | 4203³ | 3783³ |
| 16,384 | N/A² | N/A² | 4203³ | 3783³ |

¹ **Rounded up:** page size is rounded up to the next size supported by the file version (e.g. 512 → 1,024). ² **N/A:** not applicable. ³ **9.5+** files may allow more than **119** segments in some cases, but the **number of indexes** is still limited to **119**.

**Nullable columns:** a nullable indexed column with **true null** support can consume **2** segments (null segment). Example: at **4,096** byte pages and **119** segments max, you cannot have more than **59** such indexed nullable columns on one table. Files need file version **7.x+** and **TRUENULLCREATE=ON** for true nulls; older formats / **TRUENULLCREATE=OFF** avoid that split-segment behavior.

**UNIQUE** — Guarantees uniqueness of the **combined** key values for the indexed columns (not each column alone in a multi-segment index). **UNIQUE** and **PARTIAL** are **mutually exclusive** (same statement).

**Types that cannot be indexed:** BIT, BLOB, CLOB, LONGVARBINARY, LONGVARCHAR, NLONGVARCHAR. Too many segments: status **6008** (*Too Many Segments*). **BIT** here means **indexed** columns; **`SQL_BIT`** operands are still defined in the **COALESCE** combination matrix (**Logical Functions** → **COALESCE**).

**PARTIAL** — For indexes whose segment width (columns + overhead) **equals or exceeds 255 bytes**, **PARTIAL** indexes only a **prefix** (up to **255** bytes including overhead) so **WHERE** filters on a prefix can use the index. If width + overhead **&lt; 255**, **PARTIAL** is **ignored** and a normal index is created.

- **PARTIAL** only on **CHAR** or **VARCHAR** columns.
- **PARTIAL** column must be the **last** segment, or the **only** segment.
- Sole-segment **PARTIAL** on a wide column: user-data segment is **255** bytes even if the column is up to **8,000** bytes.
- **PARTIAL** is **not** used for strict equality plans on that column in **ORDER BY**, **GROUP BY**, or **JOIN**; it **is** used for qualifying **WHERE** forms: `col = 'literal'`, `col LIKE 'literal%'`, `col = ?`, `col LIKE ?` (literal/parameter any length). **LIKE** must be **prefix** form (`'x%'`), not arbitrary patterns.
- If **ALTER TABLE** changes column length across the 255-byte boundary, **drop and recreate** the partial index as needed.

```sql
CREATE TABLE part_tbl (partid INTEGER, partname CHAR(50), serialno VARCHAR(200), description CHAR(300));
CREATE PARTIAL INDEX idx_01 ON part_tbl (description);
-- description is 300 bytes; index uses first ~255 bytes (including overhead) as prefix.

CREATE PARTIAL INDEX idx_02 ON part_tbl (partid, serialno, description);
```

| Column | Type | Size | Overhead | Size in index |
|--------|------|------|----------|----------------|
| PartID | INTEGER | 4 | | 4 |
| SerialNo | VARCHAR | 200 | 1 | 201 |
| Description | CHAR | 300 | | 50 |
| **Total** | | | | **255** |

**NOT MODIFIABLE** — Prevents changing the index; applies to **all** segments of a multi-segment index. Attempting to edit key segments → status **10** (*key field is not modifiable*).

```sql
CREATE NOT MODIFIABLE INDEX X_Person ON Person(ID, Last_Name);
```

**USING** — Sets the Btrieve index number (**0–118**). Use when the same files are accessed via SQL and MicroKernel. Number is written to the data file and **X$Index**. Conflicts → **5** (**X$Index** duplicate), **6** (invalid key number on data file).

```sql
CREATE INDEX "citizen-x" USING 3 ON Person (citizenship);
```

**IN DICTIONARY** — Updates **DDF** / dictionary without changing the physical file (repair mismatches, or define metadata for Btrieve-created files). **Advanced / admin only**—misuse can cause wrong results or poor performance. **Cannot** use **IN DICTIONARY** on a **bound** database. Dropping a **phantom** index without **IN DICTIONARY** can yield **6** (no key in data file). With **USING** + **IN DICTIONARY**, the engine verifies the data-file key at that number matches the definition or returns *Btrieve key definition does not match the index definition*.

```sql
CREATE TABLE t1 IN DICTIONARY (c1 INTEGER, c2 INTEGER);
CREATE INDEX idx_1 IN DICTIONARY ON t1(c1);
DROP INDEX t1.idx_1 IN DICTIONARY;
```

```sql
-- Data file already has key 1; not yet in X$Index:
CREATE INDEX idx_1 USING 1 IN DICTIONARY ON T1 (C2);
```

**Key width (relational, non-PARTIAL / general limits)** — Btrieve key length max **255** bytes total per key. Nullable indexed columns add a null segment. For **leading** index segments in normal (non-PARTIAL-prefix) designs, practical **column** widths: **VARCHAR** ≤ **254** bytes if **NOT NULL**, **253** if nullable; **CHAR** ≤ **255** if **NOT NULL**, **254** if nullable; **NVARCHAR** ≤ **126** UCS-2 units; **NCHAR** ≤ **127** UCS-2 units. **VARCHAR**/**NVARCHAR** pay **1**/**2** bytes overhead vs **CHAR**/**NCHAR** physical width.

### CREATE VIEW
```sql
CREATE VIEW view-name [(col-list)] [WITH EXECUTE AS 'MASTER'] AS query
  [ORDER BY ...]
```
- Max 256 columns, 64 KB definition
- ORDER BY requires TOP or LIMIT

### DROP statements

**DROP INDEX** — see **DROP INDEX** below.

```sql
DROP TABLE [IF EXISTS] name [IN DICTIONARY]
DROP INDEX [IF EXISTS] [table.]name [IN DICTIONARY]
DROP VIEW [IF EXISTS] name
DROP PROCEDURE [IF EXISTS] name
DROP FUNCTION [IF EXISTS] name
DROP TRIGGER [IF EXISTS] name
DROP USER [IF EXISTS] name [, name]...
DROP GROUP [IF EXISTS] name [, name]...
```

### DROP INDEX

Removes a named index from a table. Full topic: **SQL Engine Reference → DROP INDEX** ([Zen v15](https://docs.actian.com/zen/v15/)).

```sql
DROP INDEX [ IF EXISTS ] [ table-name. ] index-name [ IN DICTIONARY ]

table-name ::= user-defined-name
index-name ::= user-defined-name
```

**IF EXISTS** — If the index does not exist, the statement **succeeds** instead of failing. **IF EXISTS** does **not** suppress other errors.

**IN DICTIONARY** — Drops the index from the **DDF** (dictionary) **without** removing the key from the underlying data file—use only for admin/repair scenarios where dictionary and file must be forced into alignment. Misuse can cause incorrect results or serious consistency problems. For behavior, cautions, phantom indexes, and **bound database** rules, see **CREATE INDEX** → **IN DICTIONARY** above.

**Partial indexes** — The **PARTIAL** modifier is **not** used on **DROP INDEX**.

**Examples**

```sql
DROP INDEX Faculty.Dept
```

Detached table (no data file): index exists only in dictionary metadata.

```sql
CREATE TABLE t1 IN DICTIONARY (c1 INTEGER, c2 INTEGER);
CREATE INDEX idx_1 IN DICTIONARY ON t1 (c1);
DROP INDEX t1.idx_1 IN DICTIONARY;
```

### ALTER (rename any object)
```sql
ALTER object-type RENAME qualified-name TO new-name
-- object-type: INDEX | FUNCTION | PROCEDURE | TABLE | TRIGGER | VIEW
```

**Remarks (ALTER … RENAME):**
- **Pre-PSQL v9:** Renaming **PROCEDURE**, **TRIGGER**, or **VIEW** could fail because the system index on the object name was not modifiable; **v9+** fixed that for those object types.
- **Qualification:** `database-name` may qualify any `object-type`. For **INDEX** or **TRIGGER**, if you use `database-name`, you must also include `table-name` (e.g. `database.table.index`). `table-name` alone qualifies only **INDEX** and **TRIGGER**.
- Object in a database **not** currently connected: qualify with `database-name`; the renamed object remains in that database.
- **`new-name`** is never database-qualified (context matches the original object).
- **Dependencies:** The engine does not rewrite dependent objects—rename can invalidate triggers, views, or procedures that still reference the old name. You can also use **`psp_rename`** (see System Stored Procedures).

---

## DML — Data Manipulation Language

### SELECT (full syntax)
```sql
SELECT [ALL|DISTINCT] [TOP n] select-list
FROM table-ref [, table-ref]...
[WHERE condition]
[GROUP BY expr [, expr]... [HAVING condition]]
[ORDER BY expr [ASC|DESC] [, ...]]
[LIMIT [offset,] count | count OFFSET offset | ALL [OFFSET offset]]
[FOR UPDATE]

-- Window functions:
set-function OVER ([PARTITION BY expr] ORDER BY expr [ROWS frame])
-- set-function: AVG|COUNT|COUNT_BIG|LAG|MAX|MIN|STDEV|STDEVP|SUM|VAR|VARP
-- frame: UNBOUNDED PRECEDING | n PRECEDING | CURRENT ROW

-- Join types:
INNER JOIN | LEFT [OUTER] JOIN | RIGHT [OUTER] JOIN | FULL [OUTER] JOIN | CROSS JOIN

-- Table hints:
table WITH (INDEX(idx-name | 0))  -- 0 = force table scan

-- Set operations:
query UNION [ALL] query
```
- TOP and LIMIT: same effect, cannot use both. **GSS convention:** prefer TOP for compatibility across GlobalShop environments (see `agents/AGENTS.GSSDB.md`)
- FOR UPDATE: single table, inside transaction, no JOIN/GROUP BY/DISTINCT/UNION
- Max 16 nested subqueries

#### AS (aliases)

Use **AS** to name a **select-list** expression or a **FROM** table. That name is an **alias** for referencing the term elsewhere in the same statement. See **SELECT** / **AS** in the **SQL Engine Reference** ([Zen v15](https://docs.actian.com/zen/v15/)).

**Zen vs. other SQL:** Many products do **not** allow **`WHERE`** (or **`GROUP BY`** / **`HAVING`**) to reference **`SELECT`** list aliases. Zen allows a **non-aggregate** alias in **`WHERE`**, **`ORDER BY`**, **`GROUP BY`**, and **`HAVING`** as described below—do not assume portability to other engines.

**Column / select-term aliases**

- For a **non-aggregate** select term, you may reference the alias in **WHERE**, **ORDER BY**, **GROUP BY**, and **HAVING**.
- For an **aggregate** select term (e.g. `SUM(...)`), you may reference the alias **only** in **ORDER BY**.
- Alias names must be **unique** in the **SELECT** list.
- Aliases appear as result column names. Computed expressions (including group aggregates) **without** an alias get system-generated names such as **EXPR-1**, **EXPR-2**, …

**Table aliases**

- **AS** is **optional** in **FROM** (`FROM Person AS p` is the same as `FROM Person p`).
- After you define an alias, **do not mix** the base table name and the alias in the same clause (invalid):

```sql
-- Invalid: Person and p both refer to Person
SELECT DISTINCT c.Name, p.First_Name, c.Faculty_Id
FROM Person p, class c
WHERE Person.Id = c.Faculty_Id
ORDER BY c.Faculty_Id
```

**Examples**

```sql
SELECT Student_ID, SUM(Amount_Paid) AS Total
FROM Billing
GROUP BY Student_ID
ORDER BY Total;
```

```sql
SELECT DISTINCT c.Name, p.First_Name, c.Faculty_Id
FROM Person AS p, class AS c
WHERE p.Id = c.Faculty_Id
ORDER BY c.Faculty_Id;
```

Equivalent **FROM** without **AS**:

```sql
SELECT DISTINCT c.Name, p.First_Name, c.Faculty_Id
FROM Person p, class c
WHERE p.Id = c.Faculty_Id
ORDER BY c.Faculty_Id;
```

### INSERT
```sql
INSERT INTO table [(col-list)] VALUES (expr [, expr]...)
INSERT INTO table [(col-list)] SELECT ...
INSERT INTO table DEFAULT VALUES
INSERT INTO table ... ON DUPLICATE KEY UPDATE col=expr [, col=expr]...
```
- Atomic: all rows or none
- ON DUPLICATE KEY UPDATE: upsert (v13 R2+)
- IDENTITY columns: use 0 for auto-assign

### UPDATE
```sql
UPDATE table [alias] SET col=expr [, col=expr]...
  [FROM table-ref [, table-ref]...]
  [WHERE condition]
UPDATE table SET col=expr WHERE CURRENT OF cursor
```
- Atomic. Subquery in SET: must return single row.

### DELETE
```sql
DELETE [FROM] table [alias]
  [FROM table-ref [, table-ref]...]
  [WHERE condition]
DELETE WHERE CURRENT OF cursor
```

---

## WHERE Clause Operators

| Category | Operators |
|----------|-----------|
| Boolean | `AND`, `OR`, `NOT` |
| Comparison | `=`, `<>`, `!=`, `<`, `>`, `<=`, `>=` |
| Range | `BETWEEN a AND b`, `NOT BETWEEN`, `IN (list)`, `NOT IN` |
| Null | `IS NULL`, `IS NOT NULL` |
| Pattern | `LIKE` / `NOT LIKE`; **`ILIKE` / `NOT ILIKE`** (Zen **v15 SP1+**, case-insensitive) |
| Quantified | `ANY`, `ALL`, `EXISTS`, `NOT EXISTS` |

### `LIKE` / `ILIKE`

- **`LIKE`:** `%` = any run of characters, `_` = one character. Escape a literal `%` or `_` with **`\`**; use `\\` for `\`. In patterns, `''` inside quotes matches one apostrophe.
- **`ILIKE`:** Same wildcard/escape semantics; comparison is **case-insensitive**. **ILIKE cannot use a case-sensitive index** for optimization the way **`LIKE`** can on a case-sensitive column—often behaves like a scan or alternate plan (see **SQL Syntax Reference → LIKE and ILIKE**).
- **Pattern source:** Must be a **string constant**, **`USER`**, or dynamic **`?`** (applications—not ZenCC SQL Editor for `?`). You **cannot** use an arbitrary expression (e.g. `'%' + col + '%'`) as the pattern operand in the grammar; build the pattern into a variable in a procedure first.

### Quantified `ANY` and `ALL`

Quantified predicates with subqueries: **SQL Engine Reference** ([Zen v15](https://docs.actian.com/zen/v15/)).

#### `ANY`

The outer row is included if the comparison is **true for any** row in the subquery result (contrast **`ALL`**).

```sql
SELECT p.ID, p.Last_Name
FROM Person p
WHERE p.ID = ANY
  (SELECT f.ID FROM Faculty f WHERE f.Dept_Name = 'Chemistry')
```

#### `ALL`

Zen runs the subquery and uses its result to evaluate the outer predicate. For each outer row, that row is included if **all** rows returned by the subquery satisfy the comparison to that outer row. Prefer **`EXISTS`** / **`NOT EXISTS`** when they express the intent more clearly.

```sql
SELECT p.ID, p.Last_Name
FROM Person p
WHERE p.ID <> ALL
  (SELECT f.ID FROM Faculty f WHERE f.Dept_Name = 'Chemistry')
```

Equivalently: include **`Person`** rows whose **`ID`** is **not equal to any** **`ID`** from the subquery (no match to Chemistry faculty **`ID`**s in the sense of the comparison).

**Empty subquery:** If the subquery returns **no rows**, **`ALL`** / **`ANY`** semantics follow the SQL Engine Reference (e.g. comparisons involving **`<>` ALL** and an empty set are **vacuously** satisfied—outer rows may appear depending on the comparison). Confirm edge-case behavior for your Zen version in the manual.

### CASE Expression
```sql
-- Simple:
CASE expr WHEN val THEN result [...] [ELSE result] END
-- Searched:
CASE WHEN condition THEN result [...] [ELSE result] END
```
- Must be inside SELECT statement. ELSE NULL implied if omitted.

---

## Aggregate Functions

| Function | Description | Args | Return |
|----------|-------------|------|--------|
| AVG(expr) | Average | Numeric | FLOAT/DECIMAL |
| COUNT(expr) | Count rows | Any | INTEGER |
| COUNT_BIG(expr) | Count rows (large) | Any | BIGINT |
| MAX(expr) | Maximum | Any | Same |
| MIN(expr) | Minimum | Any | Same |
| SUM(expr) | Sum | Numeric | FLOAT/DECIMAL |
| STDEV(expr) | Std deviation (sample) | Numeric | FLOAT |
| STDEVP(expr) | Std deviation (population) | Numeric | FLOAT |
| VAR(expr) | Variance (sample) | Numeric | FLOAT |
| VARP(expr) | Variance (population) | Numeric | FLOAT |

- **DISTINCT**: `AVG(DISTINCT col)`, `COUNT(DISTINCT col)`, `SUM(DISTINCT col)`
- Cannot nest: `SUM(AVG(...))` is invalid
- With GROUP BY: non-grouped columns must use aggregates

---

## Scalar Functions (105 total)

### Scalar functions overview

Zen scalar functions and operators can appear as primary expressions in SQL. Categories below: **Bitwise**, **Date arithmetic** (in expressions), **String**, **Numeric**, **Time and Date**, **System**, **Logical**, **Conversion**. Full syntax, edge cases, and long examples: **SQL Engine Reference → Scalar Functions** (Time and Date Function Examples, Conversion Function Examples).

### Date arithmetic (in expressions)

- Add or subtract an **integer** from a **date** (days); subtract **date − date** → integer **day** count.
- Vendor date literal example: `{d '1995-05-08'} + 30` (see **Literal Formats** for `{d '...'}`).

### String Functions (27)

> **CRITICAL: `TRIM()` does NOT exist in Zen SQL.** Any query using `TRIM()` fails with "Invalid user-defined or scalar function." Only `LTRIM` and `RTRIM` exist. Note: `Trim()` IS valid inside .NET DataTable expression columns — this is the opposite behavior. Always use `RTRIM(column)` in SQL queries.

| Function | Syntax | Description |
|----------|--------|-------------|
| ASCII | `ASCII(string)` | Code page position of leftmost char |
| BIT_LENGTH | `BIT_LENGTH(string)` | Length in bits |
| CHAR | `CHAR(code)` | Character from code page position |
| CHAR_LENGTH | `CHAR_LENGTH(string)` | Length in bytes |
| CHAR_LENGTH2 | `CHAR_LENGTH2(string)` | Length in characters (multi-byte aware) |
| CHARACTER_LENGTH | `CHARACTER_LENGTH(string)` | Same as CHAR_LENGTH |
| CONCAT | `CONCAT(s1, s2)` | Concatenate two strings |
| ISNUMERIC | `ISNUMERIC(string)` | 1 if numeric, 0 otherwise |
| LCASE / LOWER | `LCASE(string)` | Convert to lowercase |
| LEFT | `LEFT(string, n)` | Leftmost n characters |
| LENGTH | `LENGTH(string)` | Character length |
| LOCATE | `LOCATE(find, in [, start])` | Position of find in string; 0 if not found |
| LTRIM | `LTRIM(string)` | Remove leading blanks |
| NCHAR | `NCHAR(code)` | Unicode character from codepoint |
| OCTET_LENGTH | `OCTET_LENGTH(string)` | Length in bytes |
| POSITION | `POSITION(find, in)` | Position; 0 if not found |
| REPLACE | `REPLACE(s, old, new)` | Replace all occurrences |
| REPLICATE | `REPLICATE(s, n)` | Repeat string n times |
| REVERSE | `REVERSE(string)` | Reverse characters |
| RIGHT | `RIGHT(string, n)` | Rightmost n characters |
| RTRIM | `RTRIM(string)` | Remove trailing blanks |
| SOUNDEX | `SOUNDEX(string)` | 4-char phonetic code |
| SPACE | `SPACE(n)` | String of n spaces |
| STUFF | `STUFF(s, start, len, insert)` | Replace len chars at start with insert |
| SUBSTRING | `SUBSTRING(s, start, len)` | Extract substring |
| UCASE / UPPER | `UCASE(string)` | Convert to uppercase |
| UNICODE | `UNICODE(string)` | Unicode codepoint of leftmost char |

**String semantics (manual)**
- Most string functions support **multi-byte** data; **`CASE (string)`** does **not** (assumes single-byte ASCII)—see CASE topic.
- Except **`CHAR_LENGTH`**, string functions apply to at most **65,500** bytes per argument.
- **`LENGTH`:** trailing **spaces** count for VARCHAR, NVARCHAR, LONGVARCHAR, NLONGVARCHAR; trailing **NULLs** count for CHAR, NCHAR, LONGVARCHAR, NLONGVARCHAR; string terminator not counted. With **`ANSI_PADDING = OFF`**, trailing NULLs on **CHAR** are treated like spaces and are **not** counted in LENGTH.
- **`CHAR_LENGTH`**, **`OCTET_LENGTH`**, **`LTRIM`**: all padding is significant for **CHAR** / **NCHAR** where the manual applies.
- **`REVERSE`:** **leading** spaces are significant; **trailing** spaces are not—wide **CHAR** columns often leave leading padding after reverse; compare with padded literal or use **`LTRIM(REVERSE(col))`**.
- **Predicate optimization:** **`RTRIM`** or **`LEFT`** in a **WHERE** clause can be optimized when both sides are suitable index keys; **`LTRIM`** / **`RIGHT`** inside complex expressions may not optimize.

### Numeric Functions (24)
| Function | Syntax | Description |
|----------|--------|-------------|
| ABS | `ABS(n)` | Absolute value |
| ACOS | `ACOS(f)` | Arc cosine (radians) |
| ASIN | `ASIN(f)` | Arc sine (radians) |
| ATAN | `ATAN(f)` | Arc tangent (radians) |
| ATAN2 | `ATAN2(y, x)` | Arc tangent of y/x |
| CEILING | `CEILING(n)` | Smallest integer >= n |
| COS | `COS(f)` | Cosine |
| COT | `COT(f)` | Cotangent |
| DEGREES | `DEGREES(n)` | Radians to degrees |
| EXP | `EXP(f)` | Exponential e^f |
| FLOOR | `FLOOR(n)` | Largest integer <= n |
| LOG | `LOG(f)` | Natural logarithm |
| LOG10 | `LOG10(f)` | Base-10 logarithm |
| MOD | `MOD(a, b)` | Remainder of a/b |
| PI | `PI()` | Pi constant |
| POWER | `POWER(n, p)` | n raised to power p |
| RADIANS | `RADIANS(n)` | Degrees to radians |
| RAND | `RAND([seed])` | Random float 0–1 |
| ROUND | `ROUND(n, places)` | Round to decimal places |
| SIGN | `SIGN(n)` | -1, 0, or 1 |
| SIN | `SIN(f)` | Sine |
| SQRT | `SQRT(f)` | Square root |
| TAN | `TAN(f)` | Tangent |
| TRUNCATE | `TRUNCATE(n, places)` | Truncate to decimal places |

- **`ROUND` / `TRUNCATE`:** negative **places** rounds or truncates **`|places|`** positions **left** of the decimal point.

### Date/Time Functions (37)
| Function | Syntax | Description |
|----------|--------|-------------|
| CURDATE | `CURDATE()` | Current local date |
| CURRENT_DATE | `CURRENT_DATE()` | Current UTC date |
| CURTIME | `CURTIME()` | Current local time |
| CURRENT_TIME | `CURRENT_TIME()` | Current UTC time |
| CURRENT_TIMESTAMP | `CURRENT_TIMESTAMP()` | Current UTC datetime |
| DATEADD | `DATEADD(part, interval, date)` | Add interval to date |
| DATEDIFF | `DATEDIFF(part, start, end)` | Difference in datepart units |
| **DATEFLOOR** | `DATEFLOOR(ts, unit)` | Round timestamp down to unit boundary **(v15)** |
| DATEFROMPARTS | `DATEFROMPARTS(y, m, d)` | Build date from parts |
| DATENAME | `DATENAME(part, date)` | English name of datepart |
| DATEPART | `DATEPART(part, date)` | Integer value of datepart |
| DATETIMEFROMPARTS | `DATETIMEFROMPARTS(y,m,d,h,mi,s,ms)` | Build datetime |
| DATETIMEOFFSETFROMPARTS | `DATETIMEOFFSETFROMPARTS(...)` | Build datetime with timezone |
| DAY | `DAY(date)` | Day of month |
| DAYNAME | `DAYNAME(date)` | Day name (Sunday–Saturday) |
| DAYOFMONTH | `DAYOFMONTH(date)` | Day of month (1–31) |
| DAYOFYEAR | `DAYOFYEAR(date)` | Day of year (1–366) |
| **EVERYN** | `EVERYN(unit, ts, round_unit, bucket)` | Round to time bucket start **(v15)** |
| EXTRACT | `EXTRACT(field, source)` | Extract YEAR/MONTH/DAY/HOUR/MINUTE/SECOND |
| HOUR | `HOUR(time)` | Hour (0–23) |
| MINUTE | `MINUTE(time)` | Minute (0–59) |
| MONTH | `MONTH(date)` | Month (1–12) |
| MONTHNAME | `MONTHNAME(date)` | Month name |
| NOW | `NOW()` | Current local datetime |
| QUARTER | `QUARTER(date)` | Quarter (1–4) |
| SECOND | `SECOND(time)` | Second (0–59) |
| SYSDATETIME | `SYSDATETIME()` | Local datetime (high precision) |
| SYSDATETIMEOFFSET | `SYSDATETIMEOFFSET()` | Datetime with TZ offset |
| SYSUTCDATETIME | `SYSUTCDATETIME()` | UTC datetime (high precision) |
| TIMEFROMPARTS | `TIMEFROMPARTS(h,mi,s,frac,scale)` | Build time |
| TIMESTAMPADD | `TIMESTAMPADD(interval, n, ts)` | Add intervals to timestamp |
| TIMESTAMPDIFF | `TIMESTAMPDIFF(interval, ts1, ts2)` | Interval count between timestamps |
| WEEK | `WEEK(date)` | Week of year (1–53) |
| WEEKDAY | `WEEKDAY(date)` | Day of week (1=Sun, 7=Sat) |
| YEAR | `YEAR(date)` | Year |

**DATEADD/DATEDIFF datepart values:** year, quarter, month, day, dayofyear, week, hour, minute, second, millisecond
**TIMESTAMPADD/DIFF intervals:** SQL_TSI_YEAR, SQL_TSI_QUARTER, SQL_TSI_MONTH, SQL_TSI_WEEK, SQL_TSI_DAY, SQL_TSI_HOUR, SQL_TSI_MINUTE, SQL_TSI_SECOND

**Time and date semantics (manual)**
- Display formats in this reference may differ from Zen Control Center **Text/Grid** views (fixed by the app).
- **`CURDATE()`**, **`CURTIME()`**, **`NOW()`:** based on local clock; if **`SET TIME ZONE`** is in effect, values follow UTC + session offset per engine rules (see **SET Statements**).
- **`CURRENT_DATE()`**, **`CURRENT_TIME()`**, **`CURRENT_TIMESTAMP()`:** UTC-oriented; manual documents **`CURRENT_DATE()`** as **`dd/mm/yyyy`**—do not assume ISO in all tools.
- **`DATEADD`:** returns **DATETIME**; **datepart** must be one of the list above; fractional **interval** is ignored.
- **`DATEDIFF`:** integer count of **datepart** boundaries crossed (**start** subtracted from **end** per manual); errors if the result is outside integer range.
- **`DATEPART`:** includes **`TZOFFSET`** (minutes); use with **`SYSDATETIMEOFFSET()`** or string literals with offset (**-14:00** … **+14:00**). Literal **without** offset → **0**.
- **`DATEFLOOR` / `EVERYN`:** **`EVERYN`** is meaningful when **rounding_unit** is a **larger** interval than **interval_unit** (bucket alignment); see Scalar Functions examples for grouping.
- **`SYSDATETIME()`**, **`SYSUTCDATETIME()`:** fractional resolution depends on **OS** (e.g. septaseconds on Windows 10, nanoseconds on Linux, microseconds on others); padded to **9** fractional digits; interact with **`SET TIME ZONE`** for local-style returns per manual.
- **`SYSDATETIMEOFFSET()`:** includes zone offset; **DST** handled for the engine host.
- **INSERT:** `VALUES (CURDATE())`, `(NOW())`, and `INSERT ... SELECT` with current date/time functions are supported as in the manual.

### System Functions (3)
| Function | Description |
|----------|-------------|
| DATABASE() | Current database name |
| NEWID() | New UNIQUEIDENTIFIER (GUID) |
| USER() | Current user login name |

### Logical Functions (6)
| Function | Syntax | Description |
|----------|--------|-------------|
| COALESCE | `COALESCE(e1, e2 [,...])` | First non-NULL — see **COALESCE** below |
| IF | `IF(pred, e1, e2)` | e1 if true, else e2 |
| IFNULL | `IFNULL(e, val)` | val if e is NULL |
| ISNULL | `ISNULL(e, val)` | val if e is NULL |
| NULL | `NULL()` | Explicit NULL |
| NULLIF | `NULLIF(e1, e2)` | NULL if equal, else e1 |

- **`IF`** and **`NULL()`** are Zen SQL extensions (not standard SQL).
- **`TRY_CAST` / `TRY_CONVERT`:** invalid conversion yields **NULL** for that value; the **statement continues**. **`CAST` / `CONVERT`:** invalid conversion **fails the query**.

### COALESCE

Returns the first non-NULL argument, scanning from the left.

**Syntax**

```sql
COALESCE ( expression, expression [, ...] )
```

`expression` ::= any valid expression.

**Returned value types** — The returned value is one of the expressions in the list. The result data type is determined by the **supported combination** of operand types (see matrix below). Full topic: **SQL Engine Reference → Scalar Functions → COALESCE** ([Zen v15](https://docs.actian.com/zen/v15/)).

**Restrictions**

- Minimum **two** arguments. Invalid: `COALESCE()`. Parse-time error: `"COALESCE must have at least 2 arguments."`
- The list must contain at least one argument that can yield a **non-NULL** value. Valid: `COALESCE(NULL, NULL, 20)`. Invalid: `COALESCE(NULL, NULL, NULL)`. Parse-time error: `"All arguments of COALESCE cannot be the NULL function."` (The manual uses the term *NULL function* for this rejected pattern; treat it as “no branch can produce a value other than NULL,” not as a requirement to avoid the literal token `NULL` in other valid examples.)
- **Implicit conversion** is not always possible. Example: **BINARY** and **VARCHAR** cannot be combined directly—use explicit **`CONVERT`** / **`CAST`** so each branch matches the same target type.

**Unsupported combination types** — Using operand pairs that are **blank** in the matrix below in `COALESCE` causes a parse-time error, for example: *Error in row*, *Error in assignment*, or *Expression evaluation error*.

**Chart element (legend)**

| Symbol / code | Meaning |
|---------------|---------|
| ↑ | Compatible; **result type = Operand 2** |
| ← | Compatible; **result type = Operand 1** |
| (blank) | Not compatible without explicit **CONVERT** |
| **D** | Result type **SQL_DOUBLE** |
| **B** | Result type **SIM_BCD** |
| **I** | Result type **SQL_INTEGER** |
| **S** | Result type **SQL_SMALLINT** |
| **·** | Diagonal: Operand 1 and Operand 2 are the same type |

**COALESCE supported combination types and result data types** (Operand 1 = rows, Operand 2 = columns in the SQL Engine Reference figure). The figure is a **31×31** matrix; **D**, **B**, **I**, **S**, **↑**, **←**, **·**, and **blank** are defined in **Chart element (legend)** above. Below is the same material as structured text (type order and category rules from the reference figure).

**Relational types vs. matrix names** — Columns in SQL use **relational** types (e.g. `SMALLINT`, `DECIMAL`). The matrix lists **SQL_*** / ODBC-style names (e.g. `SQL_SMALLINT`, `SIM_BCD`). Map your operands using the engine’s type correspondence (**Data Types** and **CONVERT SQL_ types** in this file). The **printed figure** in the SQL Engine Reference PDF is **authoritative** for the exact cell; the narrative tables are a **summary** and use words like “typically” where the figure is definitive.

**Operand type order (rows and columns 1–31)**

| # | Type |
|---|------|
| 1 | SQL_TIMESTAMP |
| 2 | SQL_DATE |
| 3 | SQL_TIME |
| 4 | SQL_DOUBLE |
| 5 | SQL_FLOAT |
| 6 | SQL_REAL |
| 7 | SIM_BCD |
| 8 | SQL_DECIMAL |
| 9 | SQL_NUMERIC |
| 10 | SIM_CURRENCY |
| 11 | SQL_BIGINT |
| 12 | SQL_C_UBIGINT |
| 13 | SQL_C_SBIGINT |
| 14 | SQL_INTEGER |
| 15 | SQL_C_SLONG |
| 16 | SQL_C_ULONG |
| 17 | SQL_SMALLINT |
| 18 | SQL_C_SSHORT |
| 19 | SQL_C_USHORT |
| 20 | SQL_C_STINYINT |
| 21 | SQL_TINYINT |
| 22 | SIM_BYTE |
| 23 | SQL_BIT |
| 24 | SQL_LONGVARCHAR |
| 25 | SQL_LONGVARBINARY |
| 26 | SQL_VARCHAR |
| 27 | SQL_CHAR |
| 28 | SQL_VARBINARY |
| 29 | SQL_NLONGVARCHAR |
| 30 | SQL_NVARCHAR |
| 31 | SQL_NCHAR |

**Date and time (types 1–3)**

| Op1 ↓ / Op2 → | SQL_TIMESTAMP | SQL_DATE | SQL_TIME |
|---------------|-----------------|----------|----------|
| **SQL_TIMESTAMP** | · | Result **SQL_TIMESTAMP** | (blank) |
| **SQL_DATE** | Result **SQL_TIMESTAMP** | · | (blank) |
| **SQL_TIME** | (blank) | (blank) | · |

**SQL_TIMESTAMP**/**SQL_DATE** vs character types (**26–27**, **30–31**, and long character types where supported): compatible; result is the **date/time** type. **SQL_DATE**/**SQL_TIME**/**SQL_TIMESTAMP** vs most **numeric** types (**4–23**): **blank** (use **CONVERT**).

**Floating point, decimal, currency (types 4–10)**

- **SQL_DOUBLE** with other numerics (**4–23**): typically **D** (result **SQL_DOUBLE**).
- **SQL_FLOAT** / **SQL_REAL** with **SIM_BCD**, **SQL_DECIMAL**, **SQL_NUMERIC**, **SIM_CURRENCY** and related mixes: often **D**, or **↑**/**←** per cell toward one operand’s type.
- **SIM_BCD**, **SQL_DECIMAL**, **SQL_NUMERIC**, **SIM_CURRENCY**: largely compatible with each other; result often **←** (Operand 1’s type family) where not **D**.

**Integers and related (types 11–22)**

- **SQL_BIGINT**/**SQL_C_SBIGINT**/**SQL_INTEGER**/**SQL_C_SLONG**/**SQL_C_ULONG** with the float/decimal group (**4–10**): typically **↑** (result toward Operand 2’s type in those cells).
- **SQL_C_UBIGINT** (**12**) with signed integer types (**13–21**): often **B** (**SIM_BCD**).
- **SQL_SMALLINT**, **SQL_C_SSHORT**, **SQL_C_USHORT**, **SQL_C_STINYINT**, **SQL_TINYINT**: mutual combinations often **I** (**SQL_INTEGER**); some pairs involving **SQL_TINYINT**/**SIM_BYTE** yield **S** (**SQL_SMALLINT**) per figure.

**SQL_BIT** (**23**) with other numerics: compatible; result follows the **non-BIT** operand (**↑**/**←** pattern in the figure). *(Indexing: **BIT** columns are not indexable—see **CREATE INDEX**.)*

**Character types (24, 26, 27, 29, 30, 31)**

- **SQL_VARCHAR**/**SQL_CHAR**/**SQL_NVARCHAR**/**SQL_NCHAR**: compatible with each other and with most **numeric** and **date/time** operands where the figure shows a cell; result is usually the **non-character** type (**numeric**/**date/time**). **VARCHAR**+**CHAR** tends to **VARCHAR**; **NVARCHAR**+**NCHAR** to **NVARCHAR**; mixing national and non-national character types tends toward the **national** type in the figure.
- **SQL_LONGVARCHAR** / **SQL_NLONGVARCHAR**: **limited** compatibility—mostly other **character** types; many cells with numerics or **binary** are **blank**.

**Binary (types 25, 28)**

- **SQL_LONGVARBINARY** and **SQL_VARBINARY**: compatible **with each other**; **blank** vs **numeric**, **date/time**, and **most character** types (use **CONVERT**).

**Patterns (summary)** — For an arbitrary pair, locate both types in the **Operand type order** table and consult the **31×31** matrix in the SQL Engine Reference PDF if you need the exact symbol. When the figure is **blank**, use explicit **CONVERT** so both branches share one type.

**Examples**

`10 + 2` is evaluated as **SMALLINT**; **ResultType(SMALLINT, SMALLINT)** is **SMALLINT**, so the result type of the whole `COALESCE` is **SMALLINT**. The first argument is NULL; the second evaluates to **12** (non-NULL). Return value: **12**.

```sql
SELECT COALESCE(NULL, 10 + 2, 15, NULL)
```

**10** is **SMALLINT**; **ResultType(SMALLINT, VARCHAR)** is **SMALLINT**. The first argument is non-NULL. Return value: **10**.

```sql
SELECT COALESCE(10, 'abc' + 'def')
```

### Conversion Functions (4)
| Function | Syntax | Description |
|----------|--------|-------------|
| CAST | `CAST(expr AS type)` | Convert type; fails on error |
| TRY_CAST | `TRY_CAST(expr AS type)` | Convert type; NULL on error |
| CONVERT | `CONVERT(expr, SQL_type [,style])` | Convert using SQL_ types |
| TRY_CONVERT | `TRY_CONVERT(expr, SQL_type [,style])` | Convert; NULL on error |

**CONVERT SQL_ types:** SQL_BIGINT, SQL_BINARY, SQL_BIT, SQL_CHAR, SQL_DATE, SQL_DECIMAL, SQL_DOUBLE, SQL_FLOAT, SQL_GUID, SQL_INTEGER, SQL_LONGVARBINARY, SQL_LONGVARCHAR, SQL_NUMERIC, SQL_REAL, SQL_SMALLINT, SQL_TIME, SQL_TIMESTAMP, SQL_TINYINT, SQL_VARCHAR, SQL_WCHAR, SQL_WLONGVARCHAR, SQL_WVARCHAR

- **`CAST`:** can convert strings that contain **binary zeros**, e.g. `CAST(c1 AS BINARY(10))`.
- Character-to-character **`CAST`/`CONVERT`:** output **collation** matches input.
- **CHAR/VARCHAR/LONGVARCHAR** ↔ **NCHAR/NVARCHAR/NLONGVARCHAR:** assumes non-Unicode side uses the **database code page**.
- **`CONVERT` style:** optional **style** applies only when converting **DATETIME** to **`SQL_CHAR`**; **20** or **120** → `yyyy-mm-dd hh:mm:ss` **without** milliseconds; omit **style** to retain ms. Other target types ignore **style**.
- For **`COALESCE`**, operand pairs that are **blank** in the combination matrix require explicit **`CONVERT`** so branches share one type—see **COALESCE** above.

### Bitwise Operators (4)
| Operator | Syntax | Description |
|----------|--------|-------------|
| AND | `expr & expr` | Bitwise AND |
| NOT | `~ expr` | Bitwise NOT |
| OR | `expr \| expr` | Bitwise OR |
| XOR | `expr ^ expr` | Bitwise XOR |

Supported on: BIT, TINYINT, SMALLINT, INTEGER, BIGINT, UTINYINT, USMALLINT, UINTEGER, UBIGINT

**Bitwise semantics**
- Operands are numeric; **smaller** integer type promotes to the **larger** (or next-larger) type before the operation.
- If **any** operand is **signed**, the **result is signed** (e.g. `SELECT ~12` → **-13** because the sign bit is complemented).
- **`~` and `^`** are operators in SQL text—the manual states they cannot be used as part of an **unquoted** user-defined name (use delimited identifiers if a name must contain such a character; see **Naming Conventions**).

| A | B | A & B | A \| B | A ^ B |
|---|---|-------|--------|-------|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 1 | 1 |
| 1 | 0 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 | 0 |

(`~` inverts a single operand; unary.)

Catalog bitmask example:

```sql
SELECT Xf$Name, IF(Xf$Flags & 16 = 16, 'System table', 'User table') FROM X$File
```

---

## Stored Procedures

### CREATE PROCEDURE
```sql
CREATE PROCEDURE name ([IN|OUT|INOUT|IN_OUT] :param type [DEFAULT val] [,...])
  [RETURNS (result-col type [, ...])]
  [WITH DEFAULT HANDLER] [WITH EXECUTE AS 'MASTER']
AS
BEGIN [ATOMIC]
  proc-statements
END;
```
- Variables/params prefixed with `:` or `@`
- Max 300 params, 64 KB body
- RETURNS: required if returning result set
- No ELSEIF; use nested IF...THEN...ELSE...END IF
- No REPEAT...UNTIL

### CREATE FUNCTION (UDF)
```sql
CREATE FUNCTION name ([IN :param type [DEFAULT val] [,...]])
RETURNS return-type
[AS]
BEGIN
  body
  RETURN scalar-expr
END;
```
- Scalar UDF only. Max 300 params, 64 KB body.
- Cannot contain: CREATE, ALTER, UPDATE, DELETE, INSERT, DDL

### Procedure Control Flow
```sql
-- IF:
IF condition THEN stmts [ELSE stmts] END IF;

-- WHILE:
label: WHILE condition DO stmts END WHILE;

-- LOOP:
label: LOOP stmts END LOOP;

-- LEAVE:
LEAVE label;

-- Variables:
DECLARE :var type [DEFAULT val];
SET :var = expr;
SET :var = (SELECT ...);

-- Compound:
BEGIN [ATOMIC] stmts END;

-- Signal error:
SIGNAL [ABORT] sqlstate-value;

-- Print (Windows only):
PRINT :var [, 'string'];
```

### CALL
```sql
CALL proc_name(arg1, arg2);
CALL proc_name(param => val, param2 => val2);
EXECUTE proc_name(args);
```

---

## Triggers

```sql
CREATE TRIGGER name BEFORE|AFTER INSERT|UPDATE|DELETE ON table
  [ORDER n]
  [REFERENCING OLD [AS] alias [NEW [AS] alias] | NEW [AS] alias [OLD [AS] alias]]
  FOR EACH ROW
  [WHEN condition]
  proc-stmt;
```
- OLD: prior row (DELETE, UPDATE). NEW: new row (INSERT, UPDATE).
- Cannot have parameters. Cannot be called directly.
- Cannot modify the subject table.
- Cannot use START TRANSACTION, COMMIT, ROLLBACK.

---

## Transactions

```sql
START TRANSACTION;
-- statements
COMMIT [WORK];
ROLLBACK [WORK] [TO SAVEPOINT name];
SAVEPOINT name;
RELEASE SAVEPOINT name;
```
- In stored procedures only (SQL Editor has AUTOCOMMIT on)
- Max 253 active savepoints

---

## Security

```sql
-- Enable/Disable:
SET SECURITY = 'master_password';
SET SECURITY = NULL;

-- Groups:
CREATE GROUP name [, name]...;
DROP GROUP [IF EXISTS] name;
ALTER GROUP name ADD USER user [, user]...;
ALTER GROUP name DROP USER user [, user]...;

-- Users:
CREATE USER name [WITH PASSWORD pwd] [IN GROUP group];
DROP USER [IF EXISTS] name;
ALTER USER name RENAME TO new-name;
ALTER USER name WITH PASSWORD new-pwd;

-- Permissions:
GRANT CREATETAB | CREATEVIEW | CREATESP TO user-or-group;
GRANT ALL|SELECT|INSERT|UPDATE|DELETE|ALTER|REFERENCES|EXECUTE
  ON [TABLE] table | VIEW view | PROCEDURE proc TO user-or-group;
GRANT LOGIN TO user:password [IN GROUP group];

REVOKE permission ON object FROM user-or-group;
REVOKE LOGIN FROM user;
```
- CREATETAB/CREATEVIEW/CREATESP not included in GRANT ALL
- Master user only for GRANT LOGIN, CREATE GROUP, DROP GROUP/USER
- Column-level: `GRANT SELECT (col1, col2) ON table TO user`

---

## System Stored Procedures (psp_*)

| Procedure | Purpose |
|-----------|---------|
| psp_columns | Column metadata for a table |
| psp_column_attributes | Column defaults, collation, positioning |
| psp_column_rights | Column-level permissions |
| psp_fkeys | Foreign key info |
| psp_groups | List groups |
| psp_help_sp | Stored procedure definition text |
| psp_help_trigger | Trigger definition text |
| psp_help_udf | UDF definition text |
| psp_help_view | View definition text |
| psp_indexes | Index info for a table |
| psp_pkeys | Primary key info |
| psp_procedure_rights | Procedure permissions (V2 only) |
| psp_rename | Rename COLUMN/INDEX/FUNCTION/PROCEDURE/TABLE/TRIGGER/VIEW |
| psp_stored_procedures | List stored procedures |
| psp_tables | List tables with metadata |
| psp_table_rights | Table permissions |
| psp_triggers | List triggers |
| psp_udfs | List UDFs |
| psp_users | List users/groups |
| psp_view_rights | View permissions (V2 only) |
| psp_views | List views |

**Do NOT create user procedures with the `psp_` prefix.**

## Catalog Functions (dbo.fSQL*)

| Function | Purpose |
|----------|---------|
| dbo.fSQLColumns | Column metadata |
| dbo.fSQLForeignKeys | Foreign keys |
| dbo.fSQLPrimaryKeys | Primary keys |
| dbo.fSQLProcedures | Procedures and UDFs |
| dbo.fSQLProcedureColumns | Procedure parameters |
| dbo.fSQLSpecialColumns | Row-identifying columns |
| dbo.fSQLStatistics | Statistics and indexes |
| dbo.fSQLTables | Tables with metadata |
| dbo.fSQLDBTableStat | Btrieve Stat info |

### System catalog functions overview

- **FROM clause only:** `dbo.fSQL*` functions are **table-valued**; reference them only in the **`FROM`** clause of **`SELECT`** (not general expressions).
- **JOIN / UNION:** Unlike **`psp_*`** procedures or raw catalog **APIs**, these produce a result shape you can **join** or **union** with user tables—required for many toolchains (**ADO.NET** entity/metadata scenarios).
- **Lifecycle:** A **temporary view schema** is created at **prepare**; rows are populated via the matching catalog **API** at **execute**.
- **Arguments:** **Literal constants** or **dynamic parameters (`?`)** only.
- **API return codes** (ODBC): `SQL_SUCCESS`, `SQL_SUCCESS_WITH_INFO`, `SQL_STILL_EXECUTING`, `SQL_ERROR`, `SQL_INVALID_HANDLE`.
- **ODBC-aligned** definitions; full column layouts: **ODBC Guide** (Supported Data Types, descriptors) and Zen **System Catalog Functions** topic.
- For metadata without join semantics, see **System Stored Procedures (`psp_*`)** above. Multi-statement scripts in ZenCC may need **`#` / `;`** delimiters (see **SQL Editor and batch execution**).

### Syntax reference

```sql
dbo.fSQLColumns(<'database_qualifier' | null>, <'table_name' | null>, <'column_name' | null>)
dbo.fSQLForeignKeys(<'table_qualifier' | null>, <'pkey_table_name' | null>, <'fkey_table_name' | null>)
dbo.fSQLPrimaryKeys(<'pkey_table_qualifier' | null>, <'table_name' | null>)
dbo.fSQLProcedures(<'database_qualifier' | null>, <'procedure_name' | null>)
dbo.fSQLProcedureColumns(<'database_qualifier' | null>, <'procedure_name' | null>, <'procedure_column_name' | null>)
dbo.fSQLSpecialColumns(<'database_qualifier' | null>, <'table_name' | null>, <nullable | null>)
  -- nullable: SMALLINT 0 = NO_NULLS (exclude NULL-capable special cols), 1 = NULLABLE (include them)
dbo.fSQLStatistics(<'database_qualifier' | null>, <'table_name' | null>, <unique | null>)
  -- unique: 0 = INDEX_UNIQUE only, 1 = INDEX_ALL
dbo.fSQLTables(<'database_qualifier' | null>, <'table_name' | null>, <'type' | null>)
  -- type: 'TABLE' | 'SYSTEM TABLE' | 'VIEW' | NULL (all types)
dbo.fSQLDBTableStat('table_name')   -- current database only; no database qualifier
```

`null` on a qualifier typically means **current database**.

### String search patterns

**`%`** = any run of characters; **`_`** = single character. Supported on **`fSQLForeignKeys`** (pkey/fkey table names), **`fSQLPrimaryKeys`** (table name), **`fSQLStatistics`** (table name).

```sql
SELECT * FROM dbo.fSQLStatistics(NULL, '%', 0);           -- all tables with a unique index, current DB
SELECT * FROM dbo.fSQLStatistics(NULL, 't%', 1);         -- tables starting with t, all index rows
SELECT * FROM dbo.fSQLPrimaryKeys(NULL, '%');             -- all tables with a primary key
SELECT * FROM dbo.fSQLPrimaryKeys(NULL, 't%');            -- PK metadata for tables starting with t
SELECT * FROM dbo.fSQLForeignKeys(NULL, '%', '%');        -- broad FK graph in current DB
```

### Per-function notes

**dbo.fSQLColumns** — Columns for one table; filter by optional DB qualifier and **`column_name`**. Key columns: `TABLE_*`, `COLUMN_NAME`, `DATA_TYPE`, `TYPE_NAME`, `PRECISION`, `LENGTH`, `SCALE`, `RADIX`, `NULLABLE` / `IS_NULLABLE`, `COLUMN_DEF` (literal **`NULL`** or **`TRUNCATED`** text when applicable), `SQL_DATA_TYPE` / `SQL_DATETIME_SUB` (date/time mapping differs from `TYPE_NAME` for DATE, TIME, TIMESTAMP family). Full list: Zen doc / ODBC.

**dbo.fSQLForeignKeys** — FKs where the named tables participate (outbound FKs from fkey table and/or inbound to PK). `KEY_SEQ`; **`UPDATE_RULE` / `DELETE_RULE`:** 0 = CASCADE, 1 = RESTRICT; deferrability codes 5/6/7 per manual.

**dbo.fSQLPrimaryKeys** — **One logical table** per invocation pattern (multi-row result when **`table_name`** pattern matches many tables). `COLUMN_NAME`, **`COLUMN_SEQ`**, `PK_NAME`.

**dbo.fSQLProcedures** — Lists **stored procedures and UDFs**. **`PROCEDURE_TYPE`:** 0 unknown, 1 procedure, 2 function. **`NUM_INPUT_PARAMS` / `NUM_OUTPUT_PARAMS` / `NUM_RESULT_SETS`:** reserved—**do not use**. System procedures live in internal **PERVASIVESYSDB** (often not visible in ZenCC).

**dbo.fSQLProcedureColumns** — Parameters and result-set columns for a proc/UDF. **`COLUMN_TYPE`:** 0 unknown, 1 input, 2 in/out, 3 result column, 4 output, 5 return value. Type/nullability columns parallel **fSQLColumns** where applicable.

**dbo.fSQLSpecialColumns** — Best rowid / transaction-timestamp columns (e.g. IDENTITY + row version). **`SCOPE`:** 0 current row, 1 transaction, 2 session; NULL when identifier is `SQL_ROWVER`. Zen: **`PSEUDO_COLUMN`** not used (no pseudo-columns).

**dbo.fSQLStatistics** — Returns a table-statistics row plus per-index rows; the **TYPE** column distinguishes table-level stats from index entries (ODBC **SQLStatistics** alignment). **`NON_UNIQUE`**, **`SEQ_IN_INDEX`**, **`COLLATION`** (A/D), **`CARDINALITY`**, **`PAGES`**, **`FILTER_CONDITION`** for filtered indexes.

**dbo.fSQLTables** — Catalog of tables/views/system tables; **`TABLE_TYPE`** is `TABLE`, `VIEW`, or `SYSTEM TABLE`.

**dbo.fSQLDBTableStat** — **Current DB only.** Btrieve-style **Stat (15)** snapshot: file path, dictionary path, file version, fixed length, page size, record count, index count, variable-length / compression / index balancing / ACS / system-data flags, etc. Details: **Btrieve API Guide** (Create 14, Stat 15).

---

## Global Variables

| Variable | Description |
|----------|-------------|
| @@IDENTITY | Last inserted IDENTITY value |
| @@BIGIDENTITY | Last inserted BIGIDENTITY value |
| @@ROWCOUNT | Rows affected by last INSERT/UPDATE/DELETE |
| @@SPID | Server process identifier |
| @@SESSIONID | Connection identifier |
| @@VERSION | Engine version info |

- **`@@IDENTITY` / `@@BIGIDENTITY`:** Return the last inserted **IDENTITY** / **BIGIDENTITY** value on this **connection**; initial **NULL**. If several IDENTITY columns exist, the variable tracks the one on the **PRIMARY KEY** IDENTITY column if present; otherwise the **first** IDENTITY column in the table. If the last insert targeted a table **without** IDENTITY, **`@@IDENTITY`** is **NULL** (use **`@@BIGIDENTITY`** for **BIGIDENTITY** columns).
- **`@@ROWCOUNT`:** Meaningful after **INSERT** / **UPDATE** / **DELETE** (not arbitrary statements).
- **`@@SESSIONID`:** Opaque connection identifier (eight-byte style value per manual examples).

---

## Literal Formats

| Type | Format | Example |
|------|--------|---------|
| String | `'text'` or `N'text'` (NVARCHAR) | `'Roberta''s Restaurant'` |
| Date | `'YYYY-MM-DD'` or `{d 'YYYY-MM-DD'}` | `'1995-06-05'` |
| Time | `'HH:MM:SS'` or `{t 'HH:MM:SS'}` | `'14:00:00'` |
| Timestamp | `'YYYY-MM-DD HH:MM:SS.MMM'` or `{ts '...'}` | `'1996-03-28 17:40:49'` |

**Strings**
- Escape a single quote in a string by doubling it (`''`).
- Plain quoted literals are **VARCHAR** (database **code page**). Prefix **`N`** for **NVARCHAR** (**UCS-2**).
- SQL text embedded in an application may pass through access-layer encoding before the engine; if that path cannot represent all Unicode characters, text can be **lost** before the engine sees `N'...'`.

**Date, time, timestamp**
- A value in plain quotes is typed as **CHAR** until converted; ODBC-style **`{d '...'}`**, **`{t '...'}`**, **`{ts '...'}`** are typed as **DATE**, **TIME**, and **SQL_TIMESTAMP** respectively—this matters for comparisons and conversions.
- Date literal **`'YYYY-MM-DD'`**; supported year range **0–9999**.
- Zen **partially** supports extended ODBC date/time grammar; confirm edge cases in the official SQL Syntax Reference / function topics.

**SQL NULL semantics**

- **`NULL = NULL`** evaluates **FALSE** (unknown ≠ unknown in comparisons); use **`IS NULL`** / **`IS NOT NULL`**.

**Binary literals (hex in quotes)**

- Hex data in single quotes for **BINARY**: if you supply an **odd** number of hex digits, Zen **prepends a leading `0`** to the value (SQL Server–like). No `0x` suffix form for constants—see **SQL Syntax Reference → Working with Binary Data**.

---

## SET Statements (Session)

| Statement | Syntax |
|-----------|--------|
| ANSI_PADDING | `SET ANSI_PADDING = ON \| OFF` |
| CACHED_PROCEDURES | `SET CACHED_PROCEDURES = n` |
| DECIMALSEPARATORCOMMA | `SET DECIMALSEPARATORCOMMA = ON \| OFF` |
| DEFAULTCOLLATE | `SET DEFAULTCOLLATE = NULL \| 'sort-order'` |
| LEGACYTYPESALLOWED | `SET LEGACYTYPESALLOWED = ON \| OFF` |
| OWNER | `SET OWNER = 'ownername' [, 'ownername']` |
| PASSWORD | `SET PASSWORD [FOR 'user'] = password` |
| PROCEDURES_CACHE | `SET PROCEDURES_CACHE = megabytes` |
| ROWCOUNT | `SET ROWCOUNT = n` |
| SECURITY | `SET SECURITY [USING auth_type] = 'pwd' \| NULL` |
| TIME ZONE | `SET TIME ZONE offset \| LOCAL` |
| TRUEBITCREATE | `SET TRUEBITCREATE = ON \| OFF` |
| TRUENULLCREATE | `SET TRUENULLCREATE = ON \| OFF` |

### `SET TRUEBITCREATE`

- **Default `ON`:** New **BIT** columns use relational type code **16** (single bit), **not** indexable, no transactional **LOGICAL** mapping.
- **`OFF`:** New **BIT** columns map to transactional **LOGICAL** (type code **7**), **wider** storage, **may be indexed**—use when emulating other DBMS **BIT** behavior.
- **Per connection** until changed or disconnect; **does not** alter existing columns. Pairs with **Data Types — BIT vs LOGICAL** and **`TRUEBITCREATE` in appendix A notes**.

---

## Performance Tuning Quick Reference

### Cache Sizing
- **MaxCache:** Sum of all data file sizes
- **Cache Allocation Size:** 20–70% of MaxCache (lower=read-heavy, higher=write-heavy)

### Minimize Disk I/O
1. Use Level 2 dynamic cache
2. Disable archival logging when not needed
3. Larger Transaction Log Buffer Size and Log Size
4. Logs on separate physical volume from data
5. Enable Index Balancing for read-heavy workloads
6. Disable tracing (MicroKernel and ODBC)

### Resource Allocation
- **I/O Threads:** ~1/8 of average open files
- **Protocols:** Only enable what you use
- **Allocate Resources at Startup:** Enable for production

---

## SQL Engine Performance Reference

Expert-oriented: how the Relational Engine analyzes **restrictions** (the `WHERE` clause) and uses **indexes**. For full definitions and examples, see **SQL Engine Reference → Performance Reference** and **Terminology** there. Complements **Performance Tuning Quick Reference** above (cache/I/O). Use `table WITH (INDEX(...))` hints when you must force a plan (see **SELECT**).

### Restriction analysis (Modified CNF)

- The engine tries to put Boolean `WHERE` logic into **Modified Conjunctive Normal Form (Modified CNF)** so it can systematically apply **index** optimizations.
- If conversion to Modified CNF is **not** possible or not chosen, the engine still optimizes, but may use indexes **less** effectively.
- **No Modified CNF conversion** when the restriction contains: a **subquery**, **`NOT`**, or a **dynamic parameter** (`?`).
- **Conversion skipped** when the engine prefers the original shape: e.g. **DNF** where every predicate uses only **`=`**, **LIKE**, or **IN**; or **AND**-connected DNF of those operators where **matching positions** in each conjunct reference the **same column**.

### Restriction optimization (single-table patterns)

Predicates must usually be **AND**-connected to the rest of the `WHERE` unless the topic says otherwise.

- **Single predicate:** One operand is a **column** that is a **leading index segment**; the other has **no column reference** (literal, parameter, or non-column expression). Operators: `<`, `<=`, `=`, `>=`, `>`, **LIKE**, **IN**. **LIKE** is optimized only if the pattern does **not** start with a wildcard (e.g. `'ABC%'` yes, `'%ABC'` no). **ILIKE** (v15 SP1+) does **not** use a case-sensitive index on a case-sensitive column for this style of optimization—see **WHERE Clause Operators**.
- **Closed range:** Same column; one bound with `<`/`<=`, the other with `>`/`>=`, **AND**-combined (includes **`BETWEEN`**).
- **Modified disjunct:** **OR** of predicates/ranges, each satisfying single-predicate or closed-range rules, all on the **same** column (e.g. `c1 = 1 OR (c1 > 5 AND c1 < 10) OR c1 > 20`).
- **Conjunct:** Multiple **AND** predicates on **leading segments** without **skipping** a segment; typically all but the **last** optimized segment use **`=`**; only **one** predicate per leading-segment “level”; **order of ANDs does not matter**. If a middle segment is missing (e.g. `c1 = 1 AND c3 = 1` with index c1,c2,c3), only **`c1 = 1`** may index-optimize.
- **DNF:** **OR** of **conjuncts**, each conjunct uses only **`=`**, same **index**, same **number of segments** used in every conjunct.
- **Modified CNF:** **AND** of **modified disjuncts** on **different** leading segments without skipping; disjuncts that are not on the **last** optimized segment must still contain at least one **`=`** predicate where required by the manual. Open-ended ranges on the same segment can sometimes be **closed** by combining disjuncts.

### Join-related optimization

- **Single join condition:** Same idea as a single predicate, but one operand is a column from **table A**, the other from **table B**. The **driven** table is processed after the **driving** table; the driving row’s value is used to seek on the other table’s index. If both sides have suitable indexes, the optimizer picks the cheaper direction.
- **Conjunct with joins:** Join predicates involve the **same two tables**; the rest satisfies **conjunct** rules for index use on the optimized table.
- **Modified CNF with joins:** Satisfies Modified CNF rules; disjuncts optimizing earlier segments are mostly **single join** or **single predicate**, with at least one **join** where required (see full doc).
- **Closing ranges with joins:** Same idea as single-table Modified CNF range closing, but bounds may be **join** comparisons (e.g. `t1.c1 > t2.c1 AND (t1.c1 < t2.c2 OR t1.c1 = 10)`).
- **Multi-index modified disjunct:** **OR** branches can use **different** columns each as the **first segment** of **some** index (e.g. index on `c1` and index on `c2`: `c1 = 1 OR (c1 > 5 AND c1 < 10) OR c2 = 1`).

### Push-down filters

Internal optimization: discard non-matching rows **before** building the full result. Eligible parts of `WHERE` are typically **AND**-linked.

- Predicate: column vs **literal** or **`?`**; operators `<`, `<=`, `=`, `>=`, `>`, `<>`; column type **not** BIT, FLOAT, DOUBLE, REAL, LONGVARCHAR, LONGVARBINARY, or BINARY.
- **One** **OR** **disjunct** may participate if its inner predicates meet push-down rules (they need not each be AND-linked to the whole `WHERE`).
- A push-down filter may combine that single disjunct with other eligible **AND** predicates.

### Efficient index use (DISTINCT, GROUP BY, ORDER BY)

- **`COUNT(DISTINCT col)`:** `col` must be a **single** column reference and a **leading** index segment.
- **`SELECT DISTINCT`:** Select list = **column references only** (no expressions/functions); columns must be **leading segments** of **one** index. **Order of columns in the index does not need to match** the select list order.
- **`GROUP BY`:** Same **relaxed** rule: listed columns must be **leading segments** of one index; **order may differ** from index segment order.
- **`ORDER BY`:** **Stricter:** sort columns must be **leading segments in the same order** as index segments. **ASC/DESC** per column must **match** index segment direction; **DESC** on an index segment requires the column to be **NOT NULL** (nullable OK for typical ascending `ORDER BY`). **Restriction / DISTINCT / GROUP BY** index use does **not** depend on segment ASC/DESC the same way—see manual.
- **UPDATE search optimization:** Updating a **leading** indexed column using the **same** index in `WHERE` can benefit from search optimization (engine uses separate sessions for update vs search per manual).

### Temporary sort tables

The engine may build internal temp tables when:

- **`SELECT DISTINCT`** and the select list is **not** covered by leading index segments.
- **`GROUP BY`** and the grouping columns are **not** leading segments of an index.
- **Static ODBC cursor** (e.g. `SQL_CURSOR_STATIC`).
- **Bookmarks** enabled on the result set.
- **`IN` / `= ANY`** with a **non-correlated** subquery on the right.

### Row prefetch

- Up to **two** rows may be prefetched to the client after `SELECT` when it helps small (0–1 row) result sets.
- Requires **Array Fetch** enabled (**Advanced Connection Attributes** in the ODBC DSN; see ODBC Guide).
- **No** prefetch when: result includes **LONGVARCHAR/LONGVARBINARY**, **bookmarks**, or cursor concurrency is **not** read-only (default is read-only).
- **Array fetch** differs in timing from prefetch (first explicit fetch may drive array behavior; see ODBC Guide).

### Terminology (compact)

| Term | Meaning |
|------|---------|
| **Restriction** | The entire **`WHERE`** clause |
| **Predicate** | Boolean comparison without **AND**/**OR** (except **BETWEEN**) |
| **Conjunct** | Predicates joined by **AND** |
| **Disjunct** | Predicates joined by **OR** |
| **CNF** | **AND** of **OR** groups (clauses) |
| **DNF** | **OR** of **AND** conjuncts |
| **Modified CNF** | Like CNF; each OR-group (**disjunct**) may include **closed ranges**, not only simple predicates |
| **Modified disjunct** | **OR** of predicates and/or **closed ranges** |
| **Closed range** | Same column; one side `<`/`<=`, other `>`/`>=`, **AND**’d (or **BETWEEN**) |
| **Open-ended range** | Single column vs literal or other column: `<`, `<=`, `>`, `>=` |
| **Leading segments** | First **n** columns of an index in definition order (cannot skip an intermediate segment) |
| **Join condition** | Predicate comparing columns from **two** tables with `< <= = >= >` |
| **Expression** | Boolean algebra fragment of a restriction containing complete predicate(s) |

### SQL temporary files (query execution)

Zen may create **temporary files** while processing queries (sorts, DISTINCT, some cursors, etc.).

- **Location resolution:** ODBC **`TempFileDirectory`** in **ODBC.INI** (Windows: `HKLM\SOFTWARE\ODBC\ODBC.INI`; Linux/macOS: e.g. `/usr/local/actianzen/etc` per install); else Zen engine **temp file directory** from ZenCC/bcfg (**Advanced Operations Guide → Temporary Files**); else on **Windows** try **TMP**, **TEMP**, **USERPROFILE**, then Windows directory; on **Linux/macOS** often the server process **current directory** (no TMP walk).
- **Lifetime:** Removed when the query finishes; for **SELECT**, temps can persist until the **result set** is released by the client.
- **Kinds (summary):** **In-memory** when small (e.g. under ~250k bytes) and plan allows (forward-only cursor, ORDER BY/GROUP BY/DISTINCT without BLOB/CLOB in those clauses, etc.); **on-disk** for larger same-shape plans; **Btrieve-style** temps when BLOB/CLOB participate in ORDER BY/GROUP BY/DISTINCT/UNION in select list, or for some **static/dynamic** cursor + sort combinations. Full rules: **SQL Syntax Reference → Other Characteristics → Temporary Files**.

---

## Naming Conventions
- Valid: `a-z`, `A-Z`, `0-9`, `_`, `^`, `~`, `$`
- Must begin with a letter
- Delimited identifiers: `"my-table"` for non-conforming names
- Case-sensitive when defining; case-insensitive when referencing
- Exception: user names, group names, passwords are case-sensitive

---

## SQL Reserved Words and Words to Avoid

Reserved words and symbols have special meaning to the Relational Engine unless **delimited with double quotation marks** (`"identifier"`). Using a reserved word as a database, table, column, variable, or other object name **without** quotes causes an error. See **Naming Conventions** above for valid characters; delimiters are how you **escape** these tokens when you must use such a name.

- **Best practice:** Double-quote all user-defined object names if you want zero collisions with current and future keywords.
- **Words to avoid:** The second list below comes from SQL-92/SQL-99 ANSI plus additional Zen keywords. Actian may add support for any of them in a future release (then they move toward the hard reserved list). Quoting all object names avoids future breakage.

### Reserved Words (Zen Relational Engine)

**Symbols:** `#`, `;`, `:`, `@`

- **A:** ABORT, ACCELERATED, ADD, AFTER, ALL, ALTER, AND, ANSI_PADDING, ANY, AS, ASC, ATOMIC, AVG
- **B:** BEFORE, BEGIN, BETWEEN, BORDER, BY
- **C:** CALL, CACHED_PROCEDURES, CASCADE, CASE, CAST, CHECK, CLOSE, COALESCE, COLLATE, COLUMN, COMMIT, COMMITTED, CONSTRAINT, CONVERT, COUNT, CREATE, CREATESP, CREATETAB, CREATEVIEW, CROSS, CS, CURDATE, CURRENT, CURSOR, CURTIME
- **D:** DATA_PATH, DATABASE, DATETIMEMILLISECONDS, DBO, DBSEC_AUTHENTICATION, DBSEC_AUTHORIZATION, DCOMPRESS, DDF, DECIMALSEPARATORCOMMA, DECLARE, DEFAULT, DEFAULTCOLLATE, DELETE, DENY, DESC, DIAGNOSTICS, DICTIONARY, DICTIONARY_PATH, DISTINCT, DO, DROP, DSN
- **E:** EACH, ELSE, ENCODING, END, ENFORCED, EX, EXCLUSIVE, EXEC, EXECUTE, EXISTING, EXISTS, EXPR
- **F:** FETCH, FILES, FN, FOR, FOREIGN, FROM, FULL, FUNCTION
- **G:** GLOBAL_QRYPLAN, GRANT, GROUP
- **H:** HANDLER, HAVING
- **I:** IF, IN, INDEX, INNER, INOUT, INSERT, INTEGRITY, INTERNAL, INTO, IS, ISOLATION
- **J:** JOIN
- **K:** KEY
- **L:** LEAVE, LEFT, LEGACYOWNERNAME, LEVEL, LIKE, LIMIT, LINKDUP, LOGIN, LOOP
- **M:** MAX, MIN, MODE, MODIFIABLE, MODIFY
- **N:** NEW, NEXT, NO, NO_REFERENTIAL_INTEGRITY, NORMAL, NOT, NOW, NULL
- **O:** OF, OFF, OFFSET, OLD, ON, ONLY, OPEN, OPTINNERJOIN, OR, ORDER, OUT, OUTER, OVER, OWNER
- **P:** PAGESIZE, PARTIAL, PARTITION, PASSWORD, PCOMPRESS, PRECEDING, PRED, PRIMARY, PRINT, PROCEDURE, PROCEDURES_CACHE, PSQL_MOVE, PSQL_PHYSICAL, PSQL_POSITION, PUBLIC
- **Q:** QRYPLAN, QRYPLANOUTPUT
- **R:** READ, REFERENCES, REFERENCING, RELATIONAL, RELEASE, RENAME, REPEAT, REPEATABLE, REPLACE, RESTRICT, RETURN, RETURNS, REUSE_DDF, REVERSE, REVOKE, RIGHT, ROLLBACK, ROW, ROWS, ROWCOUNT, ROWCOUNT2
- **S:** SAVEPOINT, SECURITY, SELECT, SERIALIZABLE, SESSIONID, SET, SIGNAL, SIZE, SPID, SQLSTATE, SSP_EXPR, SSP_PRED, START, STDEV, SUM, SVBEGIN, SVEND
- **T:** T, TABLE, THEN, TO, TOP, TRANSACTION, TRIGGER, TRIGGERSTAMPMISC, TRUEBITCREATE, TRUENULLCREATE, TRY_CAST, TS
- **U:** UNBOUNDED, UNCOMMITTED, UNION, UNIQUE, UNIQUEIDENTIFIER, UNTIL, UPDATE, USER, USING
- **V:** V1_METADATA, V2_METADATA, VALUES, VIEW
- **W:** WHEN, WHERE, WHILE, WITH, WORK, WRITE

### Words to Avoid

ANSI standard and additional Zen keywords—treat as **soft reserved**; delimit with `"..."` if used as names.

- **A:** ABSOLUTE, ACTION, ADD, ALL, ALLOCATE, ALTER, AND, ANY, ARE, AS, ASC, ASSERTION, AT, AUTHORIZATION, AVG
- **B:** BEGIN, BETWEEN, BIGIDENTITY, BIT, BIT_LENGTH, BOTH, BY
- **C:** CASCADE, CASCADED, CASE, CAST, CATALOG, CHAR, CHARACTER, CHAR_LENGTH, CHARACTER_LENGTH, CHECK, CLOSE, COALESCE, COLLATE, COLLATION, COLUMN, COMMIT, CONNECT, CONNECTION, CONSTRAINT, CONSTRAINTS, CONTINUE, CONVERT, CORRESPONDING, COUNT, CREATE, CROSS, CURRENT, CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP, CURRENT_USER, CURSOR
- **D:** DATE, DAY, DEALLOCATE, DEC, DECIMAL, DECLARE, DEFAULT, DEFERRABLE, DEFERRED, DELETE, DESC, DESCRIBE, DESCRIPTOR, DIAGNOSTICS, DISCONNECT, DISTINCT, DOMAIN, DOUBLE, DROP
- **E:** ELSE, END, END-EXEC, ESCAPE, EXCEPT, EXCEPTION, EXEC, EXECUTE, EXISTS, EXTERNAL, EXTRACT
- **F:** FALSE, FETCH, FIRST, FLOAT, FOR, FOREIGN, FOUND, FROM, FULL, FUNCTION
- **G:** GET, GLOBAL, GO, GOTO, GRANT, GROUP
- **H:** HAVING, HOUR
- **I:** IDENTITY, IMMEDIATE, IN, INDICATOR, INITIALLY, INNER, INPUT, INSENSITIVE, INSERT, INT, INTEGER, INTERSECT, INTERVAL, INTO, IS, ISOLATION
- **J:** JOIN
- **K:** KEY
- **L:** LANGUAGE, LAST, LEADING, LEFT, LEVEL, LIKE, LIMIT, LOCAL, LOWER
- **M:** MASK, MATCH, MAX, MIN, MINUTE, MODULE, MONTH
- **N:** NAMES, NATIONAL, NATURAL, NCHAR, NEXT, NO, NOT, NLONGVARCHAR, NULL, NULLIF, NUMERIC, NVARCHAR
- **O:** OCTET_LENGTH, OF, OFFSET, ON, ONLY, OPEN, OPTION, OR, ORDER, OUTER, OUTPUT, OVERLAPS
- **P:** PAD, PARTIAL, PASSWORD, POSITION, PRECISION, PREPARE, PRESERVE, PRIMARY, PRIOR, PRIVILEGES, PROCEDURE, PUBLIC
- **R:** READ, REAL, REFERENCES, RELATIVE, RESTRICT, REVERSE, REVOKE, RIGHT, ROLLBACK, ROWS
- **S:** SCHEMA, SCROLL, SECOND, SECTION, SELECT, SESSION, SESSION_USER, SET, SIZE, SMALLIDENTITY, SMALLINT, SOME, SPACE, SQL, SQLCODE, SQLERROR, SQLSTATE, STDEV, SUBSTRING, SUM, SYSDATETIME, SYSUTCDATETIME, SYSTEM_USER
- **T:** TABLE, TEMPORARY, THEN, TIME, TIMESTAMP, TIMESTAMP2, TIMEZONE_HOUR, TIMEZONE_MINUTE, TO, TRAILING, TRANSACTION, TRANSLATE, TRANSLATION, TRIM, TRUE, TRY_CAST
- **U:** UNION, UNIQUE, UNKNOWN, UPDATE, UPPER, USAGE, USER, USING
- **V:** VALUE, VALUES, VARCHAR, VARYING, VIEW
- **W:** WHEN, WHENEVER, WHERE, WITH, WORK, WRITE
- **Y:** YEAR
- **Z:** ZONE

---

## Metadata Versions
- **V1:** Default. Shorter name limits (20 bytes for most identifiers).
- **V2:** Longer identifiers (128 bytes), view/procedure permissions.
- Set at database creation. Cannot change after.

---

## IMPORTANT! Reference Sources
- Online: https://docs.actian.com/zen/v15/
- For topics not covered here, consult the **Zen SQL Engine Reference** and **Advanced Operations Guide**
- **SQL Syntax Reference** (**Literal Values**, **Grammar Element Definitions**, **Global Variables**, **Other Characteristics**; full alphabetical keyword topics ADD–WHILE)
- **Performance Reference** (restriction analysis, index optimization, push-down filters, DISTINCT/GROUP BY/ORDER BY, temp tables, row prefetch, **Terminology**)
- **Appendix A — Data Types** (**Zen Supported Data Types**, **Notes on Data Types**, **Legacy Types**, **Btrieve Key Data Types**, **Non-Key Data Types**; COBOL/decimal registry topics)
- **Scalar Functions** (bitwise, string/numeric/date details, **Conversion Function Examples**, **Time and Date Function Examples**)
- **System Catalog Functions** (`dbo.fSQL*`, **String Search Patterns**, full result-set column definitions; ODBC Guide for types)
- Authoritative **reserved words** and **words to avoid**: Zen SQL Engine Reference appendix **B. SQL Reserved Words** (same lists as above; check v15 docs if Zen adds keywords)
