# Crystal Report Formula Fields & Variables

Formula fields are the logic layer of Crystal Reports. They enable calculated fields, conditional text, running totals, and data passing between main reports and subreports.

---

## Variable Scopes

Crystal syntax declares variables as: `Scope TypeVar Name`

| Scope | Visibility | Lifetime |
|-------|-----------|----------|
| `Local` | Only the formula where declared | Reset each time the formula evaluates |
| `Global` | All formulas in the **main report only** | Entire report run |
| `Shared` | All formulas in main report **and all subreports** | Entire report run |

```
Local NumberVar x;
Global StringVar customerName;
Shared CurrencyVar runningTotal;
```

### Variable Types

| Type Keyword | Crystal Type |
|-------------|-------------|
| `NumberVar` | Number (double) |
| `CurrencyVar` | Currency |
| `StringVar` | String |
| `BooleanVar` | Boolean |
| `DateVar` | Date |
| `DateTimeVar` | DateTime |

### Default Scope Trap

**Crystal syntax** defaults to `Global` when no scope keyword is specified.
**Basic syntax** defaults to `Local` (via `Dim`).

This is the opposite of what most programmers expect. Always specify the scope explicitly.

```
// Crystal syntax — this is GLOBAL, not local
NumberVar x;

// To make it local, you must say so
Local NumberVar x;
```

### Assignment Operator

Crystal syntax uses `:=` for assignment, **not** `=`.

```
// Correct
Shared NumberVar total;
total := total + {Table.Amount};

// WRONG — this is comparison, not assignment
total = total + {Table.Amount};
```

---

## Evaluation-Time Keywords

Crystal processes reports in multiple passes. Formulas evaluate at different times depending on their content. These keywords force a specific evaluation pass:

| Keyword | Pass | When It Runs |
|---------|------|-------------|
| `BeforeReadingRecords` | 1 | Before any database records are read |
| `WhileReadingRecords` | 2 | As each record is read from the database |
| `WhilePrintingRecords` | 3 | As records are formatted and printed |
| `EvaluateAfter({@OtherFormula})` | After dependency | After a specific other formula evaluates |

Place the keyword as the **first statement** in the formula, followed by a semicolon:

```
WhilePrintingRecords;
Shared NumberVar counter;
counter := counter + 1;
counter
```

### When to Use Each

- **BeforeReadingRecords**: Constants, static lookups, values that never change per record
- **WhileReadingRecords**: Accumulating across raw records when no grouping is involved
- **WhilePrintingRecords**: Anything involving groups, summaries, shared variables, or section-aware logic. **This is the most common keyword needed.**
- **EvaluateAfter**: When two formulas are in the same section and one depends on the other's result

### Critical Rules

1. **Groups require `WhilePrintingRecords`** — Groups are created during the printing pass (Pass 3). Any formula that references group boundaries, resets per group, or uses group-level data must use `WhilePrintingRecords`.
2. **Variable-only formulas evaluate only once** — A formula with no database fields defaults to `BeforeReadingRecords` and evaluates a single time. If the formula is cumulative (counter, running total), you must force it to `WhileReadingRecords` or `WhilePrintingRecords`.
3. **Shared variables require `WhilePrintingRecords`** — Shared variables between main report and subreport must use `WhilePrintingRecords` on both sides.

---

## Shared Variable Pattern (Main Report ↔ Subreport)

Shared variables are the **only** way to pass data from a subreport back to the main report. Subreport links (covered in `CREATION.md`) only pass data *down* to filter the subreport.

### Writing in the Subreport

Place this formula in the subreport (e.g., Report Footer or Group Footer):

```
WhilePrintingRecords;
Shared CurrencyVar SubTotal := Sum({OrderLines.AMOUNT});
```

### Reading in the Main Report

Place this formula in the main report in a section **below** the subreport:

```
WhilePrintingRecords;
Shared CurrencyVar SubTotal;
SubTotal
```

### Reset Formula

Place in the main report's Group Header (above the subreport) to prevent stale values when a group has no subreport data:

```
WhilePrintingRecords;
Shared CurrencyVar SubTotal := 0;
```

### Section Ordering Rule

Crystal processes sections top-to-bottom. The formula that **reads** a shared variable must be in a section that is physically **below** the section containing the subreport. If the read formula is above or at the same level, you get the previous record's value or zero.

| Placement | Result |
|-----------|--------|
| Subreport in Detail A, read formula in Detail B (below) | Correct |
| Subreport in Group Footer 1a, read formula in Group Footer 1b | Correct |
| Read formula in same section as subreport | Previous record's value |
| Read formula above subreport | Zero / uninitialized |

If you need the value displayed in a section above the subreport, use a suppressed section below the subreport to capture the value, then display it in a subsequent group footer or report footer.

---

## Running Totals via Formula

Running totals accumulate a value across records. The SDK does not have a dedicated `RunningTotalFieldController` in all versions, but running totals can always be implemented as formula fields:

```
WhilePrintingRecords;
CurrencyVar Amount;
Amount := Amount + {Customer.LAST_YEAR_SALES};
```

To reset per group:

```
WhilePrintingRecords;
CurrencyVar Amount;
If {Customer.REGION} <> Previous({Customer.REGION}) Then
    Amount := 0;
Amount := Amount + {Customer.LAST_YEAR_SALES};
```

---

## Common Formula Patterns

### Row Counter
```
WhilePrintingRecords;
NumberVar rowNum;
rowNum := rowNum + 1;
rowNum
```

### Conditional Text
```
If {ORDER_HEADER.STATUS} = "C" Then "Closed"
Else If {ORDER_HEADER.STATUS} = "O" Then "Open"
Else "Unknown"
```

### Date Math
```
DateDiff("d", {ORDER_HEADER.ORDER_DATE}, {ORDER_HEADER.SHIP_DATE})
```

### String Concatenation
```
{CUSTOMER_MASTER.FIRST_NAME} + " " + {CUSTOMER_MASTER.LAST_NAME}
```

### Conditional Accumulation
```
WhilePrintingRecords;
CurrencyVar openTotal;
If {ORDER_HEADER.STATUS} = "O" Then
    openTotal := openTotal + {ORDER_HEADER.AMOUNT};
openTotal
```

---

## Crystal Basic Syntax Reference

The sections above use **Crystal syntax**. Crystal Reports also supports **Basic syntax** — a VB-like language used by complex formulas such as barcode generators. The two syntaxes are not interchangeable within a single formula; you choose one per formula field.

### Syntax Comparison

| Operation | Crystal Syntax | Basic Syntax |
|-----------|---------------|--------------|
| Variable declaration | `NumberVar x;` | `Dim x As Number` |
| Assignment | `x := 5;` | `x = 5` |
| Default scope | `Global` (when omitted) | `Local` (via `Dim`) |
| String concatenation | `"A" + "B"` | `"A" & "B"` or `"A" + "B"` |
| If/else | `If x > 0 Then "Yes" Else "No"` | `If x > 0 Then`...`Else`...`End If` |
| For loop | `(not available — use While)` | `For i = 1 To N`...`Next` |
| Do loop | `While condition Do (...)` | `Do`...`Loop While condition` |
| Select case | `Select x Case 1: "A" Case 2: "B"` | `Select Case x`...`Case 1`...`End Select` |
| Return value | Last expression in formula | `Formula = result` |
| Statement separator | `;` (semicolon) | Newline |
| Array declaration | `NumberVar Array a := [1,2,3];` | `Dim a(3) As Number` |
| Array resize | Not supported | `ReDim arr(newSize)` |
| Loop limit override | Not available | `Option Loop 10000000` |
| Null check | `IsNull({field})` | `IsNull({field})` |

### Key Basic Syntax Constructs

**Variable declaration and assignment:**
```
Dim total As Number
Dim name As String
total = 0
name = "Test"
```

**Block If:**
```
If IsNull({Table.FIELD}) Then
  result = ""
Else
  result = Trim({Table.FIELD})
End If
```

**For/Next loop:**
```
Dim i As Number
For i = 1 To 10
  total = total + i
Next
```

**Do/Loop While:**
```
Dim counter As Number
counter = 0
Do
  counter = counter + 1
Loop While counter < 100
```

**Setting the formula return value:**
```
Formula = total
```

In Basic syntax, the return value is assigned to the special variable `Formula`. In Crystal syntax, the last expression evaluated is the return value.

**Option Loop (override loop limit):**
```
Option Loop 10000000
```

Crystal enforces a default limit of 100,000 total loop iterations across all loops in a formula. Complex formulas (e.g., barcode encoders) exceed this. Place `Option Loop N` at the top of the formula before any `Dim` statements.

---

## Barcode Formulas

### CRITICAL RULE: Allowed Barcode Symbologies

For **1D / linear barcodes**, use **Code 39** or **Code 128** only. No other 1D symbologies are permitted.

For **2D barcodes**, use **Data Matrix** (documented below).

### 1D Barcodes: Code 39 and Code 128

| Symbology | Character Set | Density | Check Digit | Font |
|-----------|--------------|---------|-------------|------|
| **Code 39** | A-Z, 0-9, space, `-` `.` `$` `/` `+` `%` `*` | Lower (wide bars) | Optional (self-checking) | `IDAutomationHC39M` |
| **Code 128** | Full ASCII (0-127) | Higher (compact bars) | Required (mod-103) | `IDAutomationC128` |

**When to use which:**

- **Code 39**: Simple alphanumeric data (part numbers, work order numbers). No check digit calculation needed — just wrap the data with start/stop asterisks. Widely supported by all barcode scanners.
- **Code 128**: Data that requires full ASCII characters, lowercase letters, or higher density. Produces shorter barcodes for the same data. Requires a checksum calculation formula.

#### Code 39 Formula (Crystal Syntax)

Code 39 is the simplest barcode to implement — the formula just wraps the data with asterisk start/stop characters:

```
"*" + {Table.FIELD} + "*"
```

The field displaying this formula must use the **IDAutomationHC39M** font (or equivalent IDAutomation Code 39 font). No check digit calculation is needed because Code 39 is self-checking.

#### Code 128 Formula (Basic Syntax)

Code 128 requires a mod-103 check digit appended to the encoded data. This formula uses Basic syntax:

```
Dim DataToEncode As String
Dim CheckDigit As Number
Dim WeightedSum As Number
Dim i As Number

If IsNull({Table.FIELD}) Then
  DataToEncode = ""
Else
  DataToEncode = Trim({Table.FIELD})
End If

If Len(DataToEncode) = 0 Then
  Formula = ""
Else
  ' Start with Code 128B start character (value 104)
  WeightedSum = 104
  For i = 1 To Len(DataToEncode)
    WeightedSum = WeightedSum + (Asc(Mid(DataToEncode, i, 1)) - 32) * i
  Next
  CheckDigit = WeightedSum Mod 103

  ' Build output: start char + data + check digit + stop char
  ' Chr(204) = Code 128B start, Chr(206) = stop
  Formula = Chr(204) & DataToEncode & Chr(CheckDigit + 32) & Chr(206)
End If
```

The field displaying this formula must use the **IDAutomationC128** font (or equivalent IDAutomation Code 128 font).

**Note**: The exact character mappings (start, stop, check digit offset) depend on the specific IDAutomation font version installed. Verify against the IDAutomation Code 128 font documentation for your installed version.

#### Prerequisites (1D Barcodes)

- **IDAutomationHC39M** (Code 39) or **IDAutomationC128** (Code 128) font installed on the machine rendering the report
- Valid IDAutomation license for the font
- Field displaying the formula must use the corresponding IDAutomation barcode font
- Code 39 formulas can use Crystal syntax; Code 128 formulas should use Basic syntax for the checksum loop

---

### 2D Barcodes: Data Matrix

Data Matrix barcodes can be generated natively in Crystal Reports using IDAutomation's barcode generator formula with the IDAutomation2D or IDAutomationDMatrix font.

#### Prerequisites

- **IDAutomation2D** or **IDAutomationDMatrix** font installed on the machine rendering the report
- Valid IDAutomation license for the font
- Formula uses **Basic syntax** (not Crystal syntax)
- Field displaying the formula must use the IDAutomation barcode font

#### Formula Structure Overview

The Data Matrix formula is ~2880 lines of Basic syntax that:

1. Reads input data from database fields with null-safe access
2. Encodes the data using the Data Matrix standard (ISO/IEC 16022)
3. Auto-selects the optimal encoding mode (ASCII, C40, Text, Base256)
4. Computes Reed-Solomon error correction codewords
5. Builds the 2D matrix with finder patterns
6. Renders the matrix as Unicode block characters for font output

#### Null-Safe Field Access Pattern

Crystal formulas return NULL if any referenced field is NULL. Barcode formulas must guard against this:

```
Dim PartNoValue As String
If IsNull({V_BI_BAR_HEAD.PARTNO}) Then
  PartNoValue = ""
Else
  PartNoValue = Trim({V_BI_BAR_HEAD.PARTNO})
End If
```

Always wrap each field reference in an `IsNull()` check. Concatenate the safe values afterward:

```
DataToEncode = Trim(Left(PartNoValue, 17) & "-" & Comments1Value)
```

#### Option Loop Override

The encoding algorithm contains deeply nested loops that exceed Crystal's 100,000 iteration default. The formula must start with:

```
Option Loop 10000000
```

Without this, the formula silently truncates or fails at runtime.

#### Array Chunking Pattern

Crystal has practical array size limits. The encoder splits large dynamic-programming arrays into three 1000-element chunks with index routing:

```
Dim mvCodeWords1(1000) As Number
Dim mvCodeWords2(1000) As Number
Dim mvCodeWords3(1000) As Number

' Writing to a position:
If pos <= 1000 Then
  mvCodeWords1(pos) = value
ElseIf pos <= 2000 Then
  mvCodeWords2(pos - 1000) = value
ElseIf pos <= 3000 Then
  mvCodeWords3(pos - 2000) = value
End If

' Reading from a position:
If pos <= 1000 Then
  value = mvCodeWords1(pos)
ElseIf pos <= 2000 Then
  value = mvCodeWords2(pos - 1000)
ElseIf pos <= 3000 Then
  value = mvCodeWords3(pos - 2000)
End If
```

This pattern repeats throughout the formula for codeword arrays, encoding cost arrays, and bit arrays. The 3000-element total also caps the maximum input data length.

#### Unicode Block Character Rendering

The formula outputs the barcode matrix using Unicode block elements. Each pair of matrix rows is combined into a single character row (2 rows per character height):

| Character | Code | Represents |
|-----------|------|-----------|
| ` ` (space) | `ChrW(32)` | Top white, bottom white |
| `▄` | `ChrW(9604)` | Top white, bottom black |
| `▀` | `ChrW(9600)` | Top black, bottom white |
| `█` | `ChrW(9608)` | Top black, bottom black |

Rows are separated by `ChrW(13) & ChrW(10)` (CR+LF). The formula field on the report must:

- Use the **IDAutomation2D** or **IDAutomationDMatrix** font
- Have `CanGrow` enabled (see `FORMATTING.md`) to accommodate variable barcode sizes
- Use a monospaced font if rendering without the barcode font for debugging

#### Configurable Parameters

These variables near the top of the formula control encoding behavior:

| Parameter | Default | Purpose |
|-----------|---------|---------|
| `ApplyTilde` | `1` | Enable tilde processing (`~1` for FNC1, `~dNNN` for ASCII values, etc.) |
| `PreferredFormat` | `1` | Preferred Data Matrix symbol size (0-29, or -1 for auto) |
| `UTF8` | `1` | Enable UTF-8 encoding of input data |
| `EncMode` | `E_AUTO` (-1) | Force encoding mode: `E_ASCII` (3), `E_C40` (1), `E_TEXT` (2), `E_BASE256` (0), or `E_AUTO` (-1) |

#### Tilde Commands

When `ApplyTilde = 1`, special tilde sequences in the input are interpreted:

| Sequence | Meaning |
|----------|---------|
| `~1` | FNC1 (GS1 separator) |
| `~2` | Structured Append marker |
| `~3` | Reader Programming |
| `~5` | Macro 05 |
| `~6` | Macro 06 |
| `~7NNNNNN` | ECI (Extended Channel Interpretation) |
| `~dNNN` | ASCII character by decimal value |
| `~mNN` | MOD10 check digit over last NN numeric digits |
| `~fNN` | MOD43 check digit (HIBC) over last NN characters |
| `~iNN` | MOD37 check digit (ISBT) over last NN alphanumeric characters |
| `~~` | Literal tilde |

#### Reference Formula

A working Data Matrix formula encodes `{V_BI_BAR_HEAD.PARTNO}` and `{V_BI_BAR_HEAD.COMMENTS_1}` into a Data Matrix barcode. Adapt the `DataToEncode` assignment to use different fields.

---

## SDK: Creating Formula Fields Programmatically (C#)

Formula fields are created via `FormulaFieldController` on the RAS InProc SDK. This requires the full Creation reference set (see `CREATION.md` for compile command and DLL references).

### Creating a FormulaField

```csharp
var formula = new CrystalDecisions.ReportAppServer.DataDefModel.FormulaField();
formula.Name = "MyFormula";
formula.Text = "WhilePrintingRecords; Shared CurrencyVar Amount; "
             + "Amount := Amount + {Customer.LAST_YEAR_SALES};";
formula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxCrystal;
formula.Type = CrFieldValueTypeEnum.crFieldValueTypeCurrencyField;

clientDoc.DataDefController.FormulaFieldController.Add(formula);
```

### Placing a FormulaField on the Report

After adding the formula to the data definition, place it as a `FieldObject`:

```csharp
var fieldObj = new FieldObject();
fieldObj.DataSourceName = formula.FormulaForm;
fieldObj.FieldValueType = formula.Type;
fieldObj.Left = 6200;
fieldObj.Top = 50;
fieldObj.Width = 2000;
fieldObj.Height = 250;
fieldObj.Kind = CrReportObjectKindEnum.crReportObjectKindField;

var section = clientDoc.ReportDefController.ReportDefinition
    .DetailArea.Sections[(object)0];
clientDoc.ReportDefController.ReportObjectController.Add(fieldObj, section, -1);
```

`FormulaForm` returns the Crystal formula reference string (e.g., `{@MyFormula}`) used as the `DataSourceName`.

### Creating a Shared Variable Formula for Subreport Communication

In the subreport's creation code:

```csharp
var setFormula = new FormulaField();
setFormula.Name = "SetSharedTotal";
setFormula.Text = "WhilePrintingRecords; "
                + "Shared CurrencyVar SubTotal := Sum({OrderLines.AMOUNT});";
setFormula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxCrystal;
setFormula.Type = CrFieldValueTypeEnum.crFieldValueTypeCurrencyField;
subClientDoc.DataDefController.FormulaFieldController.Add(setFormula);
```

In the main report's creation code (placed below the subreport section):

```csharp
var getFormula = new FormulaField();
getFormula.Name = "GetSharedTotal";
getFormula.Text = "WhilePrintingRecords; "
                + "Shared CurrencyVar SubTotal; SubTotal";
getFormula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxCrystal;
getFormula.Type = CrFieldValueTypeEnum.crFieldValueTypeCurrencyField;
clientDoc.DataDefController.FormulaFieldController.Add(getFormula);
```

### Creating a Reset Formula

Place this formula in the main report's Group Header (above the subreport):

```csharp
var resetFormula = new FormulaField();
resetFormula.Name = "ResetSharedTotal";
resetFormula.Text = "WhilePrintingRecords; "
                  + "Shared CurrencyVar SubTotal := 0;";
resetFormula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxCrystal;
resetFormula.Type = CrFieldValueTypeEnum.crFieldValueTypeCurrencyField;
clientDoc.DataDefController.FormulaFieldController.Add(resetFormula);
```

### FormulaField Properties Reference

| Property | Type | Purpose |
|----------|------|---------|
| `Name` | string | Formula name (referenced as `{@Name}`) |
| `Text` | string | Full Crystal formula text including evaluation keywords and variable declarations |
| `Syntax` | `CrFormulaSyntaxEnum` | `.crFormulaSyntaxCrystal` or `.crFormulaSyntaxBasic` |
| `Type` | `CrFieldValueTypeEnum` | Return type of the formula (String, Number, Currency, Date, etc.) |
| `FormulaForm` | string (read-only) | The reference string (e.g., `{@MyFormula}`) — use as `FieldObject.DataSourceName` |

### Controller Access

| Need | Access Path |
|------|-------------|
| Add formula field | `clientDoc.DataDefController.FormulaFieldController.Add(formulaField)` |
| Remove formula field | `clientDoc.DataDefController.FormulaFieldController.Remove("{@FormulaName}")` |

### Creating a Basic Syntax Formula (e.g., Barcode)

For formulas that use Basic syntax, set `Syntax` to `crFormulaSyntaxBasic`:

```csharp
var barcodeFormula = new FormulaField();
barcodeFormula.Name = "DataMatrixBarcode";
barcodeFormula.Syntax = CrFormulaSyntaxEnum.crFormulaSyntaxBasic;
barcodeFormula.Type = CrFieldValueTypeEnum.crFieldValueTypeStringField;

// Long formulas (e.g., barcode encoders) should be loaded from file
barcodeFormula.Text = System.IO.File.ReadAllText(
    @"C:\Formulas\DataMatrixFormula.txt");

clientDoc.DataDefController.FormulaFieldController.Add(barcodeFormula);
```

Barcode formulas can be thousands of lines. Loading from a file avoids unmanageable string concatenation in C#. The file contents must be the raw formula text exactly as it would appear in the Crystal formula editor.

When placing the barcode formula field on the report, set the font to the barcode font (e.g., IDAutomation2D) and enable `CanGrow` (see `FORMATTING.md`).

---

## Pitfalls

1. **Default scope confusion**: In Crystal syntax, omitting the scope keyword makes the variable `Global`. In Basic syntax, `Dim` makes it `Local`. Always specify scope explicitly.
2. **`:=` vs `=`**: Crystal syntax uses `:=` for assignment. Using `=` performs comparison and will not assign the value.
3. **Stale shared variables**: If a subreport returns no data, the shared variable retains its previous value. Always add a reset formula in the Group Header above the subreport.
4. **Variable-only formula evaluates once**: A formula containing only variables and no database fields defaults to `BeforeReadingRecords`. It will run exactly once. Use `WhileReadingRecords` or `WhilePrintingRecords` to force per-record evaluation.
5. **Evaluation-time mismatch**: You cannot summarize (Sum, Avg) a formula that uses `WhilePrintingRecords`. Use a separate accumulation formula or a running total approach instead.
6. **Section ordering for shared vars**: The read formula must be physically below the subreport in the report layout. Crystal processes top-to-bottom within each pass.
7. **Redeclare in every formula**: Global and Shared variables must be declared (with scope, type, and name) in **every** formula that uses them, even though they share the same value. Omitting the declaration in a consuming formula causes a compilation error.
8. **FormulaField.Text must be complete**: When creating formulas programmatically, the `Text` property must contain the entire formula including evaluation keywords and variable declarations — exactly as you would type it in the Crystal formula editor.
9. **Option Loop required for complex formulas**: Crystal enforces a default limit of 100,000 total loop iterations per formula evaluation. Barcode encoders, encryption, and other algorithmic formulas will silently fail or produce truncated output without `Option Loop N` at the top (Basic syntax only).
10. **Basic syntax `Dim` defaults to Local**: In Basic syntax, `Dim x As Number` creates a `Local` variable. To share across formulas, you must explicitly use `Global` or `Shared` scope. This is the opposite of Crystal syntax, where omitting the scope keyword defaults to `Global`.
11. **Basic syntax uses `=` for assignment**: Do not use `:=` in Basic syntax formulas — it causes a syntax error. Conversely, `=` in Crystal syntax performs comparison, not assignment. Match the operator to the formula's syntax setting.
12. **Long formula text and line endings**: When loading formula text from a file for `FormulaField.Text`, ensure the file uses CR+LF (`\r\n`) line endings. Crystal's Basic syntax parser expects Windows-style line endings; Unix-style LF-only can cause parse errors.
13. **Array size limits in Basic syntax**: Crystal Basic arrays have practical size limits. For large arrays (>1000 elements), split into multiple arrays and route by index (see the Array Chunking Pattern in the Barcode Formulas section).
