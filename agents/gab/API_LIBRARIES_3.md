# GAB Standard Libraries Reference (Part 3 of 5)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with standard .lib includes (Part 3: lines 5001-7156)
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

## 6020.lib -- Router Master Upload

**Wraps:** CallWrapper `6020` — Router Master Upload

> **Important:** This library generates a **fixed-position flat file** (`ROUTERHD.txt`) from the `6020` DataTable and calls the callwrapper **once** for the entire file — not per row.

**Documentation:** [Router Master Upload File Format](http://www.gss-updates.com/site/GShelp/2015/000/INDEX.asp?addl_ref_data_conv_router_master.asp)

```
Program.External.Include.Library("6020.lib",False)
```

### Global Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s6020Error` | String | `""` | Error output. Format: `Sub*!*ErrNo*!*ErrDesc` |
| `V.Global.s6020Mode` | String | `"1"` | Upload mode passed as the first callwrapper parameter |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `6020Sync` | Pads fields, writes `ROUTERHD.txt`, calls `CallWrapperSync(6020, Mode!*!ROUTERHD)` |
| `6020Async` | Pads fields, writes `ROUTERHD.txt`, calls `CallWrapperAsync(6020, Mode!*!ROUTERHD)` |

> **Note:** The callwrapper parameter is built via `ConcatCallWrapperArgs(s6020Mode, "ROUTERHD")`. The second argument (`"ROUTERHD"`) is hardcoded in the library — only the mode is configurable.

### DataTable `6020` — Schema

> `*Parameter*` denotes a required field. All fields are `String` type. RPad = right-padded with spaces; LPad = left-padded with zeros. Implied decimal format: e.g., `8.4` means 8 integer digits and 4 decimal digits with no explicit decimal point in the file.

#### Router Header

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 1 | `RouterNum` | **\*Router Number\*** | | 20 | RPad | 20 spaces |
| 2 | `RouterDesc` | Router Description | | 30 | RPad | 30 spaces |
| 3 | `Seq` | **\*Sequence\*** | | 6 | LPad `"0"` | 6 spaces |
| 4 | `LineType` | Line Item Type | See **LineType** enum | 1 | — | `" "` |

#### Part / Work Center

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 5 | `PartNum` | Part Number (see Note 1) | | 20 | RPad | 20 spaces |
| 6 | `WC` | Work Center (see Note 2) | | 4 | RPad | 4 spaces |
| 7 | `PartStepDesc` | Part/Step Description | | 30 | RPad | 30 spaces |

#### Quantities / Rates

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 8 | `SetupQty` | Setup Quantity | 8.4 | 16 | LPad `"0"` | 16 spaces |
| 9 | `RunTimeMatlQty` | Run Time / Material Quantity | 8.4 or 8.6 | 16 | LPad `"0"` | 16 spaces |
| 10 | `CustID` | Customer ID | | 6 | RPad | 6 spaces |
| 11 | `OriginalDate` | Original Date | MMDDYY | 6 | RPad | 6 spaces |
| 12 | `OperationCodeVend` | Operation Code / Vendor | | 6 | RPad | 6 spaces |
| 13 | `RateUC` | Rate / Unit Cost | 8.4 | 16 | LPad `"0"` | 16 spaces |
| 14 | `UM` | Unit of Measure | | 2 | RPad | 2 spaces |

#### Extra Descriptions

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 15 | `ExtraDesc1` | Extra Description 1 | | 71 | RPad | 71 spaces |
| 16 | `ExtraDesc2` | Extra Description 2 | | 71 | RPad | 71 spaces |
| 17 | `ExtraDesc3` | Extra Description 3 | | 71 | RPad | 71 spaces |

#### Quantity Break Points (1–4)

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 18 | `Qty1` | Quantity 1 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 19 | `Qty2` | Quantity 2 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 20 | `Qty3` | Quantity 3 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 21 | `Qty4` | Quantity 4 | 8.0 | 16 | LPad `"0"` | 16 spaces |

#### Scheduling (Labor Sequences Only*)

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 22 | `PurgeFlag` | Purge Flag | Y/N | 1 | — | `" "` |
| 23 | `Freq` | Frequency | 6.0* | 16 | LPad `"0"` | 16 spaces |
| 24 | `Machine` | Machine | 6.0* | 16 | LPad `"0"` | 16 spaces |
| 25 | `Overlap` | Overlap | 2.0* | 16 | LPad `"0"` | 16 spaces |
| 26 | `WCFactor` | Work Center Factor | 2.0* | 16 | LPad `"0"` | 16 spaces |

#### Outside Processing

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 27 | `MinFlag` | Minimum Flag | Y/N | 1 | — | `" "` |
| 28 | `MinOutside` | Minimum Outside (see Note 3) | | 16 | LPad `"0"` | 16 spaces |
| 29 | `CrewSize` | Crew Size | 4.4* | 16 | LPad `"0"` | 16 spaces |
| 30 | `LeadTime` | Lead Time | 4.0** | 16 | LPad `"0"` | 16 spaces |

#### Part / Drawing

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 31 | `PartLoc` | Part Location | | 2 | RPad | 2 spaces |
| 32 | `ToolingFlag` | Tooling Flag | Y/N | 1 | — | `" "` |
| 33 | `SortCode` | Sort Code | | 20 | RPad | 20 spaces |
| 34 | `DrawingNum` | Drawing Number | | 20 | RPad | 20 spaces |

#### Advanced Scheduling

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 35 | `PostFloat` | Post Float | +-3.2 | 16 | LPad `"0"` | 16 spaces |
| 36 | `SubSetup` | Subsequent Setup | +-8.4 | 16 | LPad `"0"` | 16 spaces |
| 37 | `NonContiguousFlag` | Non-Contiguous Flag | Y/N | 1 | — | `" "` |
| 38 | `MinRunQty` | Minimum Run Quantity | +-8.4 | 16 | LPad `"0"` | 16 spaces |
| 39 | `MaxRunQty` | Maximum Run Quantity | +-8.4 | 16 | LPad `"0"` | 16 spaces |
| 40 | `MultipleOfRunQty` | Multiple of Run Quantity | +-8.4 | 16 | LPad `"0"` | 16 spaces |
| 41 | `ReSetupNonContiguous` | Re-setup Non-Contiguous | See **ReSetupNonContiguous** enum | 1 | — | `" "` |

#### Machine Utilization

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 42 | `PercMachineUtil` | Percent Machine Utilization | +-1.2 | 16 | LPad `"0"` | 16 spaces |
| 43 | `SchedulingPercMod` | Scheduling Percent Modifier | +-1.2 | 16 | LPad `"0"` | 16 spaces |

#### Machine Attribute Flags (26 columns)

| # | Columns | Description | Format | Size | Default |
|---|---------|-------------|--------|------|---------|
| 44–69 | `MachineAttrib1Flag` through `MachineAttrib26Flag` | Machine Attribute Flags 1–26 | Y/N | 1 each | `" "` each |

#### Employee Labor Constraints

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 70 | `EmpLaborConstraintOnSetup` | Employee Labor Constraint on Setup | Y/N | 1 | — | `" "` |
| 71 | `EmpsRequiredOnSetup` | Employees Required on Setup | 3.0 | 16 | LPad `"0"` | 16 spaces |
| 72 | `EmpLaborConstraintOnRuntime` | Employee Labor Constraint on Runtime | Y/N | 1 | — | `" "` |
| 73 | `EmpsRequiredOnRuntime` | Employees Required on Runtime | 3.0 | 16 | LPad `"0"` | 16 spaces |

#### Unattended Processing

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 74 | `UnattendedSetupFlag` | Unattended Setup Flag | Y/N | 1 | — | `" "` |
| 75 | `UnattendedSetupHours` | Unattended Setup Hours | +-2.3 | 16 | LPad `"0"` | 16 spaces |
| 76 | `UnattendedRuntimeFlag` | Unattended Runtime Flag | Y/N | 1 | — | `" "` |
| 77 | `UnattendedRuntimeHours` | Unattended Runtime Hours | +-2.3 | 16 | LPad `"0"` | 16 spaces |

#### Setup Labor Attribute Flags (26 columns)

| # | Columns | Description | Format | Size | Default |
|---|---------|-------------|--------|------|---------|
| 78–103 | `SetupLaborAttrib1` through `SetupLaborAttrib26` | Setup Labor Attribute Flags 1–26 | Y/N | 1 each | `" "` each |

#### Run Labor Attribute Flags (26 columns)

| # | Columns | Description | Format | Size | Default |
|---|---------|-------------|--------|------|---------|
| 104–129 | `RunLaborAttrib1` through `RunLaborAttrib26` | Run Labor Attribute Flags 1–26 | Y/N | 1 each | `" "` each |

#### Scrap / Customer / User

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 130 | `Scrap` | Scrap | 0.4 | 16 | LPad `"0"` | 16 spaces |
| 131 | `CustPartNum` | Customer Part Number | | 20 | RPad | 20 spaces |
| 132 | `User1` | User Field 1 | | 20 | RPad | 20 spaces |
| 133 | `User2` | User Field 2 | | 20 | RPad | 20 spaces |

#### Commission / Extended Quantity Break Points (5–10)

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 134 | `Commission` | Commission | 3.4 | 16 | LPad `"0"` | 16 spaces |
| 135 | `Qty5` | Quantity 5 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 136 | `Qty6` | Quantity 6 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 137 | `Qty7` | Quantity 7 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 138 | `Qty8` | Quantity 8 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 139 | `Qty9` | Quantity 9 | 8.0 | 16 | LPad `"0"` | 16 spaces |
| 140 | `Qty10` | Quantity 10 | 8.0 | 16 | LPad `"0"` | 16 spaces |

#### Signoff / Misc

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 141 | `SignoffGroupUser` | Signoff Group / User | | 8 | RPad | 8 spaces |
| 142 | `SignoffType` | Signoff Type | See **SignoffType** enum | 1 | — | `" "` |
| 143 | `PL` | Product Line | | 2 | RPad | 2 spaces |
| 144 | `OmitFromRouterRepricingFlag` | Omit from Router Repricing Flag | Y/N | 1 | — | `" "` |
| 145 | `RouterYieldPerc` | Router Yield Percent | 1.5 (see Note 4) | 16 | LPad `"0"` | 16 spaces |
| 146 | `MainCommentFlag` | Main Comment Flag | Y/N (see Note 5) | 1 | — | `" "` |

### Enums

**LineType** — Line Item Type

| Value | Meaning |
|-------|---------|
| `"L"` | Labor |
| `"M"` | Material |
| `"O"` | Outside |
| `"C"` | Comment |

**ReSetupNonContiguous** — Re-setup Non-Contiguous

| Value | Meaning |
|-------|---------|
| `"0"` | No Setup |
| `"1"` | Initial Setup |
| `"2"` | Subsequent Setup |

**SignoffType**

| Value | Meaning |
|-------|---------|
| `"U"` | User |
| `"G"` | Group |

### Notes

1. If LineType is `"O"` (Outside), `PartNum` represents the **Outside Code** instead of a part number.
2. Use `WC` (Work Center) for **labor steps only**. The value must match an entry in the Work Center Master table or the Work Group table.
3. `MinFlag` must be `"Y"` to enter a `MinOutside` amount (minimum charged by a vendor for outside processing).
4. `RouterYieldPerc` is only visible on a Labor or Outside sequence if the Advanced Estimating/Routing option **"Use Router Yield"** is active.
5. The sequence (`Seq`) must be divisible by the **Operations Sequence Multiple** found in Manufacturing Standard Company Options.

### How It Works

1. **Include** the library: `Program.External.Include.Library("6020.lib",False)`
2. Optionally set `V.Global.s6020Mode` (default `"1"`)
3. **Add rows** to the `6020` DataTable — one row per router sequence line
4. Call **`6020Sync`** or **`6020Async`**
5. The library:
   - Iterates all rows, **RPad**-ing text fields with spaces and **LPad**-ing numeric fields with `"0"` to their fixed widths
   - Creates a DataView (style 22 — all columns), converts to a newline-delimited string
   - Writes the string to `{V.Caller.FilesDir}\ROUTERHD.txt`
   - Concatenates `Mode` and `"ROUTERHD"` via `ConcatCallWrapperArgs` and calls `CallWrapperSync(6020, params)` or `CallWrapperAsync`
   - Deletes all rows from the DataTable after processing
6. On error, `V.Global.s6020Error` is set to `Sub*!*ErrNo*!*ErrDesc`

### Usage Example

```
Program.External.Include.Library("6020.lib",False)

'Labor sequence
F.Data.DataTable.AddRow("6020")
F.Data.DataTable.SetValue("6020","RouterNum","RT-WIDGET-100",0)
F.Data.DataTable.SetValue("6020","RouterDesc","Widget Standard Router",0)
F.Data.DataTable.SetValue("6020","Seq","10",0)
F.Data.DataTable.SetValue("6020","LineType","L",0)
F.Data.DataTable.SetValue("6020","WC","MC01",0)
F.Data.DataTable.SetValue("6020","PartStepDesc","CNC Milling",0)
F.Data.DataTable.SetValue("6020","SetupQty","1",0)
F.Data.DataTable.SetValue("6020","RunTimeMatlQty","0.25",0)
F.Data.DataTable.SetValue("6020","OperationCodeVend","MILL",0)
F.Data.DataTable.SetValue("6020","RateUC","55",0)

'Material sequence
F.Data.DataTable.AddRow("6020")
F.Data.DataTable.SetValue("6020","RouterNum","RT-WIDGET-100",1)
F.Data.DataTable.SetValue("6020","Seq","20",1)
F.Data.DataTable.SetValue("6020","LineType","M",1)
F.Data.DataTable.SetValue("6020","PartNum","RAW-STEEL-304",1)
F.Data.DataTable.SetValue("6020","PartStepDesc","Steel Bar Stock",1)
F.Data.DataTable.SetValue("6020","RunTimeMatlQty","2.5",1)
F.Data.DataTable.SetValue("6020","RateUC","12",1)
F.Data.DataTable.SetValue("6020","UM","LB",1)

'Outside sequence
F.Data.DataTable.AddRow("6020")
F.Data.DataTable.SetValue("6020","RouterNum","RT-WIDGET-100",2)
F.Data.DataTable.SetValue("6020","Seq","30",2)
F.Data.DataTable.SetValue("6020","LineType","O",2)
F.Data.DataTable.SetValue("6020","PartNum","PLATING",2)
F.Data.DataTable.SetValue("6020","PartStepDesc","Chrome Plating",2)
F.Data.DataTable.SetValue("6020","OperationCodeVend","VENDOR1",2)
F.Data.DataTable.SetValue("6020","RateUC","8",2)
F.Data.DataTable.SetValue("6020","LeadTime","5",2)

F.Intrinsic.Control.CallSub(6020Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\ROUTERHD.txt` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is **3-part** (`Sub*!*ErrNo*!*ErrDesc`). The callwrapper parameters are built using `ConcatCallWrapperArgs(Mode, "ROUTERHD")` — the second parameter is hardcoded. The `Seq` field uses LPad `"0"` (zero-padded). Fields marked with `*` in the Format column apply to **Labor sequences only**; fields marked `**` apply to **Material and Outside sequences only**. The three 26-element attribute flag arrays (`MachineAttrib1-26Flag`, `SetupLaborAttrib1-26`, `RunLaborAttrib1-26`) are individually named columns, not indexed arrays.

---

## 6021.lib -- Router Master Upload (Alternate)

**Wraps:** CallWrapper `6021` — Router Master Upload

> **Important:** This library is **structurally identical** to `6020.lib`. It uses the same DataTable schema (146 columns), generates the same fixed-position flat file (`ROUTERHD.txt`), applies the same padding logic, and passes the same callwrapper parameters. The only difference is the callwrapper ID (`6021` instead of `6020`). See **6020.lib** for the full DataTable schema, enums, and notes.

**Documentation:** [Router Master Upload File Format](http://www.gss-updates.com/site/GShelp/2015/000/INDEX.asp?addl_ref_data_conv_router_master.asp)

```
Program.External.Include.Library("6021.lib",False)
```

### Global Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s6021Error` | String | `""` | Error output. Format: `Sub*!*ErrNo*!*ErrDesc` |
| `V.Global.s6021Mode` | String | `"1"` | Upload mode passed as the first callwrapper parameter |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `6021Sync` | Pads fields, writes `ROUTERHD.txt`, calls `CallWrapperSync(6021, Mode!*!ROUTERHD)` |
| `6021Async` | Pads fields, writes `ROUTERHD.txt`, calls `CallWrapperAsync(6021, Mode!*!ROUTERHD)` |

### DataTable `6021` — Schema

The `6021` DataTable has the **same 146 columns**, defaults, padding, enums, and notes as `6020`. See the **6020.lib** documentation above for the full schema.

Required fields: `RouterNum`, `Seq`.

### Differences from 6020.lib

| Aspect | 6020.lib | 6021.lib |
|--------|----------|----------|
| CallWrapper ID | `6020` | `6021` |
| DataTable name | `"6020"` | `"6021"` |
| Global variables | `s6020Error`, `s6020Mode` | `s6021Error`, `s6021Mode` |
| Subroutines | `6020Sync`, `6020Async` | `6021Sync`, `6021Async` |
| Output file | `ROUTERHD.txt` | `ROUTERHD.txt` (same) |
| CallWrapper args | `Mode!*!ROUTERHD` | `Mode!*!ROUTERHD` (same) |
| Schema | 146 columns | 146 columns (identical) |

### How It Works

Same as 6020.lib — see above. The only difference is the callwrapper ID used (`6021` instead of `6020`).

### Usage Example

```
Program.External.Include.Library("6021.lib",False)

F.Data.DataTable.AddRow("6021")
F.Data.DataTable.SetValue("6021","RouterNum","RT-BRACKET-200",0)
F.Data.DataTable.SetValue("6021","RouterDesc","Bracket Standard Router",0)
F.Data.DataTable.SetValue("6021","Seq","10",0)
F.Data.DataTable.SetValue("6021","LineType","L",0)
F.Data.DataTable.SetValue("6021","WC","MC02",0)
F.Data.DataTable.SetValue("6021","PartStepDesc","Laser Cutting",0)
F.Data.DataTable.SetValue("6021","SetupQty","0.5",0)
F.Data.DataTable.SetValue("6021","RunTimeMatlQty","0.15",0)
F.Data.DataTable.SetValue("6021","OperationCodeVend","LASER",0)
F.Data.DataTable.SetValue("6021","RateUC","75",0)

F.Intrinsic.Control.CallSub(6021Sync)
```

> **Note:** This library is functionally identical to `6020.lib` except for the callwrapper ID. Both write to `ROUTERHD.txt` and pass `ConcatCallWrapperArgs(Mode, "ROUTERHD")`. The existence of two separate callwrapper IDs (`6020` and `6021`) for the same router master upload format suggests they may target different processing modes or versions within the core program. Use whichever ID your GSS environment expects.

---

## 7041.lib -- Transfer/Moved Orders (ORD743)

**Wraps:** CallWrapper `7041` — Transfer/Moved Orders / ORD743

> **Important:** This library uses **two linked DataTables** (`7041` for headers and `7041Lines` for line items) linked by `Order`. Unlike most upload libraries, the callwrapper is invoked **per header row** — not once for the entire file. For each header row, the library filters matching lines, writes a CSV line file, and calls the callwrapper with all header fields as parameters.

```
Program.External.Include.Library("7041.lib",False)
```

### Global Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s7041Error` | String | `""` | Error output. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |
| `V.Global.s7041FileName` | String | `"{CompanyCode}{Terminal}7041.txt"` | Line file name — dynamically built from `V.Caller.CompanyCode` and `V.Caller.Terminal` |
| `V.Global.s7041FilePath` | String | `"{FilesDir}\{FileName}"` | Full line file path — dynamically built from `V.Caller.FilesDir` and `s7041FileName` |

> **Note:** `s7041FileName` and `s7041FilePath` are computed in Preflight. The `LineFile` column in the `7041` DataTable defaults to `s7041FilePath`. Override these globals **after** the Include if you need a custom path, and update existing rows' `LineFile` column accordingly.

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `7041Sync` | For each header row: writes line file, calls `CallWrapperSync(7041, Order!*!NewLoc!*!MoveFlag!*!LineFile!*!ShipTo!*!HeaderDueDate)` |
| `7041Async` | For each header row: writes line file, calls `CallWrapperAsync(7041, ...)` |

### DataTable `7041` — Header Schema

| # | Column | Description | Format | Max Size |
|---|--------|-------------|--------|----------|
| 1 | `Order` | Order Number (links to `7041Lines`) | `X(7)` | 7 |
| 2 | `NewLoc` | New Location | `X(2)` | 2 |
| 3 | `MoveFlag` | Move Flag | See **MoveFlag** enum | 1 |
| 4 | `LineFile` | Line File path | Defaults to `s7041FilePath` | — |
| 5 | `ShipTo` | Ship To | `X(8)` | 8 |
| 6 | `HeaderDueDate` | Header Due Date | YYYYMMDD | 8 |

### DataTable `7041Lines` — Line Item Schema

| # | Column | Description | Format | Max Size |
|---|--------|-------------|--------|----------|
| 1 | `Order` | Order Number (links to `7041` header) | `X(7)` | 7 |
| 2 | `Line` | Line Number | `9(3)` | 3 |
| 3 | `Qty` | Quantity | Numeric | — |
| 4 | `Date` | Date | YYYYMMDD | 8 |

### MoveFlag Enum

| Value | Meaning |
|-------|---------|
| `"Y"` | Move |
| `" "` | Transfer |
| `"B"` | Blanket |

### How It Works

1. **Include** the library: `Program.External.Include.Library("7041.lib",False)`
2. Preflight computes `s7041FileName` and `s7041FilePath`; the `LineFile` column defaults to `s7041FilePath`
3. **Add rows** to the `7041` DataTable — one row per order to transfer/move
4. **Add rows** to the `7041Lines` DataTable — one row per order line; set `Order` to match the header
5. Call **`7041Sync`** or **`7041Async`**
6. The library iterates each header row:
   a. Filters `7041Lines` by `Order = '{currentOrder}'`
   b. If matching lines exist, creates a DataView with columns `Line`, `Qty`, `Date` (excluding `Order`) and writes a **comma-delimited** CSV to `s7041FilePath`
   c. Concatenates all 6 header columns via `ConcatCallWrapperArgs` and calls `CallWrapperSync(7041, params)` or `CallWrapperAsync`
7. After processing all rows, both DataTables are cleared
8. On error, `V.Global.s7041Error` is set to `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` for wrapper-level errors)

### Usage Example

```
Program.External.Include.Library("7041.lib",False)

'Header - Transfer order 1234567 to location 02
F.Data.DataTable.AddRow("7041")
F.Data.DataTable.SetValue("7041","Order","1234567",0)
F.Data.DataTable.SetValue("7041","NewLoc","02",0)
F.Data.DataTable.SetValue("7041","MoveFlag"," ",0)
F.Data.DataTable.SetValue("7041","HeaderDueDate","20260415",0)

'Lines for order 1234567
F.Data.DataTable.AddRow("7041Lines")
F.Data.DataTable.SetValue("7041Lines","Order","1234567",0)
F.Data.DataTable.SetValue("7041Lines","Line","1",0)
F.Data.DataTable.SetValue("7041Lines","Qty","100",0)
F.Data.DataTable.SetValue("7041Lines","Date","20260415",0)

F.Data.DataTable.AddRow("7041Lines")
F.Data.DataTable.SetValue("7041Lines","Order","1234567",1)
F.Data.DataTable.SetValue("7041Lines","Line","2",1)
F.Data.DataTable.SetValue("7041Lines","Qty","50",1)
F.Data.DataTable.SetValue("7041Lines","Date","20260420",1)

F.Intrinsic.Control.CallSub(7041Sync)
```

**Usage Pattern (multiple orders — move and transfer):**

```
Program.External.Include.Library("7041.lib",False)

'Order 1 - Move
F.Data.DataTable.AddRow("7041")
F.Data.DataTable.SetValue("7041","Order","5551234",0)
F.Data.DataTable.SetValue("7041","NewLoc","03",0)
F.Data.DataTable.SetValue("7041","MoveFlag","Y",0)
F.Data.DataTable.SetValue("7041","ShipTo","SHIP001",0)

F.Data.DataTable.AddRow("7041Lines")
F.Data.DataTable.SetValue("7041Lines","Order","5551234",0)
F.Data.DataTable.SetValue("7041Lines","Line","1",0)
F.Data.DataTable.SetValue("7041Lines","Qty","200",0)
F.Data.DataTable.SetValue("7041Lines","Date","20260501",0)

'Order 2 - Transfer
F.Data.DataTable.AddRow("7041")
F.Data.DataTable.SetValue("7041","Order","5559876",1)
F.Data.DataTable.SetValue("7041","NewLoc","05",1)
F.Data.DataTable.SetValue("7041","MoveFlag"," ",1)

F.Data.DataTable.AddRow("7041Lines")
F.Data.DataTable.SetValue("7041Lines","Order","5559876",1)
F.Data.DataTable.SetValue("7041Lines","Line","1",1)
F.Data.DataTable.SetValue("7041Lines","Qty","75",1)
F.Data.DataTable.SetValue("7041Lines","Date","20260510",1)

F.Intrinsic.Control.CallSub(7041Sync)
```

> **Note:** Both DataTables are cleared after processing. The callwrapper is invoked **per header row** (not once for the entire file). The line file is written as **CSV** (comma-delimited) with columns `Line`, `Qty`, `Date` — the `Order` column is excluded from the file since it is the linking field. The line file is **overwritten** for each header row, so all matching lines for a given order are written together. No field padding is applied. The date format is **YYYYMMDD** (not MMDDYY). The `LineFile` column defaults to `{FilesDir}\{CompanyCode}{Terminal}7041.txt` but can be overridden per row.

---

## 7070.lib -- Order Entry History Inquiry - by Order Number (ORD193GI)

**Wraps:** CallWrapper `7070` — Order Entry History Inquiry - by Order Number / ORD193GI

```
Program.External.Include.Library("7070.lib",False)
```

This library invokes the `7070` callwrapper to perform Order Entry History Inquiry by Order Number. It is a **direct callwrapper invoker** — it does not generate any file or apply any field padding. Each row in the `7070` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `7070`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Order | Order Number | String | `9(7)` — 7-digit numeric |
| Customer | Customer Number | String | `X(6)` — up to 6 characters |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s7070Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `7070Sync` | Calls `F.Global.General.CallWrapperSync(7070, ...)` per row |
| `7070Async` | Calls `F.Global.General.CallWrapperAsync(7070, ...)` per row |

### How It Works

1. The library creates a `7070` DataTable with columns `Order` and `Customer`.
2. When `7070Sync` or `7070Async` is called, it loops through each row in the DataTable.
3. For each row, it concatenates `Order` and `Customer` via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `7070` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s7070Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `7070Sync`/`7070Async`).

**Usage Pattern (single inquiry):**

```
Program.External.Include.Library("7070.lib",False)

F.Data.DataTable.AddRow("7070")
F.Data.DataTable.SetValue("7070","Order","1234567",0)
F.Data.DataTable.SetValue("7070","Customer","ABC123",0)

F.Intrinsic.Control.CallSub(7070Sync)
```

**Usage Pattern (multiple inquiries):**

```
Program.External.Include.Library("7070.lib",False)

F.Data.DataTable.AddRow("7070")
F.Data.DataTable.SetValue("7070","Order","1234567",0)
F.Data.DataTable.SetValue("7070","Customer","ABC123",0)

F.Data.DataTable.AddRow("7070")
F.Data.DataTable.SetValue("7070","Order","7654321",1)
F.Data.DataTable.SetValue("7070","Customer","XYZ456",1)

F.Intrinsic.Control.CallSub(7070Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables are used. The error variable follows the 4-part format with a 1-based row index.

---

## 7100.lib -- Update Allocations (INV060)

**Wraps:** CallWrapper `7100` — Update Allocations / INV060

```
Program.External.Include.Library("7100.lib",False)
```

This library invokes the `7100` callwrapper to update inventory allocations. It is a **direct callwrapper invoker** — it does not generate any file or apply any field padding. Each row in the `7100` DataTable triggers a separate callwrapper invocation with all 11 column values concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `7100`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Type | Allocation type | String | See `Type` enum below |
| Part | Part number (excluding revision) | String | `X(17)` max |
| Rev | Part revision | String | `X(3)` max |
| Loc | Location | String | `X(2)` max |
| OrderQty | Order quantity | String | Numeric `8.4` |
| SO | Sales order number | String | `9(7)` max |
| SOLine | Sales order line number | String | `9(3)` max |
| Lot | Lot number | String | `X(15)` max |
| Bin | Bin number | String | `X(6)` max |
| Heat | Heat number | String | `X(15)` max |
| Serial | Serial number | String | `X(30)` max |

### Type Enum

| Value | Meaning |
|-------|---------|
| `"S"` | Sales Order |
| `"W"` | Work Order |
| `"X"` | Auto Work Order |
| `"C"` | Customer Number |
| `"M"` | Auto Customer Number |
| `"T"` | Staging |
| `"A"` | Auto Staging |
| `"R"` | RMA |
| `"E"` | Auto User Allocation |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s7100Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `7100Sync` | Calls `F.Global.General.CallWrapperSync(7100, ...)` per row |
| `7100Async` | Calls `F.Global.General.CallWrapperAsync(7100, ...)` per row |

### How It Works

1. The library creates a `7100` DataTable with 11 columns (`Type` through `Serial`).
2. When `7100Sync` or `7100Async` is called, it loops through each row in the DataTable.
3. For each row, all 11 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `7100` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s7100Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `7100Sync`/`7100Async`).

**Usage Pattern (allocate a sales order):**

```
Program.External.Include.Library("7100.lib",False)

F.Data.DataTable.AddRow("7100")
F.Data.DataTable.SetValue("7100","Type","S",0)
F.Data.DataTable.SetValue("7100","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("7100","Rev","A",0)
F.Data.DataTable.SetValue("7100","Loc","01",0)
F.Data.DataTable.SetValue("7100","OrderQty","25.0000",0)
F.Data.DataTable.SetValue("7100","SO","1234567",0)
F.Data.DataTable.SetValue("7100","SOLine","001",0)
F.Data.DataTable.SetValue("7100","Lot","LOT-2026-001",0)
F.Data.DataTable.SetValue("7100","Bin","A01",0)
F.Data.DataTable.SetValue("7100","Heat","",0)
F.Data.DataTable.SetValue("7100","Serial","",0)

F.Intrinsic.Control.CallSub(7100Sync)
```

**Usage Pattern (multiple allocations — work order and staging):**

```
Program.External.Include.Library("7100.lib",False)

'Work order allocation
F.Data.DataTable.AddRow("7100")
F.Data.DataTable.SetValue("7100","Type","W",0)
F.Data.DataTable.SetValue("7100","Part","BRACKET-500",0)
F.Data.DataTable.SetValue("7100","Rev","",0)
F.Data.DataTable.SetValue("7100","Loc","02",0)
F.Data.DataTable.SetValue("7100","OrderQty","100.0000",0)
F.Data.DataTable.SetValue("7100","SO","",0)
F.Data.DataTable.SetValue("7100","SOLine","",0)
F.Data.DataTable.SetValue("7100","Lot","",0)
F.Data.DataTable.SetValue("7100","Bin","B12",0)
F.Data.DataTable.SetValue("7100","Heat","",0)
F.Data.DataTable.SetValue("7100","Serial","",0)

'Staging allocation
F.Data.DataTable.AddRow("7100")
F.Data.DataTable.SetValue("7100","Type","T",1)
F.Data.DataTable.SetValue("7100","Part","PLATE-200",1)
F.Data.DataTable.SetValue("7100","Rev","B",1)
F.Data.DataTable.SetValue("7100","Loc","01",1)
F.Data.DataTable.SetValue("7100","OrderQty","50.0000",1)
F.Data.DataTable.SetValue("7100","SO","",1)
F.Data.DataTable.SetValue("7100","SOLine","",1)
F.Data.DataTable.SetValue("7100","Lot","LOT-2026-050",1)
F.Data.DataTable.SetValue("7100","Bin","",1)
F.Data.DataTable.SetValue("7100","Heat","HT-9988",1)
F.Data.DataTable.SetValue("7100","Serial","",1)

F.Intrinsic.Control.CallSub(7100Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables are used. All 11 columns are always passed to `ConcatCallWrapperArgs` regardless of the `Type` selected — unused fields can be set to empty strings. The error variable follows the 4-part format with a 1-based row index.

---

## 7101.lib -- Update Allocations with Action (INV060)

**Wraps:** CallWrapper `7101` — Update Allocations / INV060

```
Program.External.Include.Library("7101.lib",False)
```

This library is **structurally identical to `7100.lib`** with one addition: a 12th column `Action` that specifies whether to view or delete the allocation. It invokes callwrapper `7101` (not `7100`). Like `7100.lib`, it is a **direct callwrapper invoker** — no file generation, no field padding, per-row invocation.

### Differences from `7100.lib`

| Aspect | `7100.lib` | `7101.lib` |
|--------|-----------|-----------|
| CallWrapper ID | `7100` | `7101` |
| DataTable name | `7100` | `7101` |
| Columns | 11 (`Type` through `Serial`) | 12 (`Type` through `Serial` + `Action`) |
| Global variable | `V.Global.s7100Error` | `V.Global.s7101Error` |
| Subroutines | `7100Sync` / `7100Async` | `7101Sync` / `7101Async` |

The first 11 columns (`Type`, `Part`, `Rev`, `Loc`, `OrderQty`, `SO`, `SOLine`, `Lot`, `Bin`, `Heat`, `Serial`) and the `Type` enum are identical to `7100.lib`. See [`7100.lib`](#7100lib----update-allocations-inv060) for the full schema.

### Additional Column — `Action`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Action | Action to perform | String | See `Action` enum below |

### Action Enum

| Value | Meaning |
|-------|---------|
| `"V"` | View |
| `"D"` | Delete |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s7101Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `7101Sync` | Calls `F.Global.General.CallWrapperSync(7101, ...)` per row |
| `7101Async` | Calls `F.Global.General.CallWrapperAsync(7101, ...)` per row |

### How It Works

1. The library creates a `7101` DataTable with 12 columns (`Type` through `Serial` + `Action`).
2. When `7101Sync` or `7101Async` is called, it loops through each row in the DataTable.
3. For each row, all 12 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `7101` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s7101Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `7101Sync`/`7101Async`).

**Usage Pattern (view an allocation):**

```
Program.External.Include.Library("7101.lib",False)

F.Data.DataTable.AddRow("7101")
F.Data.DataTable.SetValue("7101","Type","S",0)
F.Data.DataTable.SetValue("7101","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("7101","Rev","A",0)
F.Data.DataTable.SetValue("7101","Loc","01",0)
F.Data.DataTable.SetValue("7101","OrderQty","25.0000",0)
F.Data.DataTable.SetValue("7101","SO","1234567",0)
F.Data.DataTable.SetValue("7101","SOLine","001",0)
F.Data.DataTable.SetValue("7101","Lot","LOT-2026-001",0)
F.Data.DataTable.SetValue("7101","Bin","A01",0)
F.Data.DataTable.SetValue("7101","Heat","",0)
F.Data.DataTable.SetValue("7101","Serial","",0)
F.Data.DataTable.SetValue("7101","Action","V",0)

F.Intrinsic.Control.CallSub(7101Sync)
```

**Usage Pattern (delete an allocation):**

```
Program.External.Include.Library("7101.lib",False)

F.Data.DataTable.AddRow("7101")
F.Data.DataTable.SetValue("7101","Type","W",0)
F.Data.DataTable.SetValue("7101","Part","BRACKET-500",0)
F.Data.DataTable.SetValue("7101","Rev","",0)
F.Data.DataTable.SetValue("7101","Loc","02",0)
F.Data.DataTable.SetValue("7101","OrderQty","100.0000",0)
F.Data.DataTable.SetValue("7101","SO","",0)
F.Data.DataTable.SetValue("7101","SOLine","",0)
F.Data.DataTable.SetValue("7101","Lot","",0)
F.Data.DataTable.SetValue("7101","Bin","B12",0)
F.Data.DataTable.SetValue("7101","Heat","",0)
F.Data.DataTable.SetValue("7101","Serial","",0)
F.Data.DataTable.SetValue("7101","Action","D",0)

F.Intrinsic.Control.CallSub(7101Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. All 12 columns are always passed to `ConcatCallWrapperArgs` — unused fields can be set to empty strings. The only difference from `7100.lib` is the additional `Action` column (12th parameter) and the use of callwrapper ID `7101`.

---

## 7200.lib -- Supply and Demand (INV500GI)

**Wraps:** CallWrapper `7200` — Supply and Demand / INV500GI

```
Program.External.Include.Library("7200.lib",False)
```

This library invokes the `7200` callwrapper to run the Supply and Demand inquiry. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `7200` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `7200`

| Column | Description | Type | Default | Values |
|--------|-------------|------|---------|--------|
| Part | Part number | String | `""` | `X(20)` |
| Loc | Location | String | `""` | `X(2)` |
| Mode | Mode | String | `"MR"` | See `Mode` enum below |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"MR"` | Show MRP |

> **Note:** `"MR"` is the **only valid option** for `Mode`. The column defaults to `"MR"` at DataTable creation, so it can be omitted from your `SetValue` calls.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s7200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `7200Sync` | Calls `F.Global.General.CallWrapperSync(7200, ...)` per row |
| `7200Async` | Calls `F.Global.General.CallWrapperAsync(7200, ...)` per row |

### How It Works

1. The library creates a `7200` DataTable with columns `Part`, `Loc`, and `Mode` (defaulting to `"MR"`).
2. When `7200Sync` or `7200Async` is called, it loops through each row in the DataTable.
3. For each row, `Part`, `Loc`, and `Mode` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `7200` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s7200Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `7200Sync`/`7200Async`).

**Usage Pattern (single part inquiry):**

```
Program.External.Include.Library("7200.lib",False)

F.Data.DataTable.AddRow("7200")
F.Data.DataTable.SetValue("7200","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("7200","Loc","01",0)
'Mode defaults to "MR" — no need to set it

F.Intrinsic.Control.CallSub(7200Sync)
```

**Usage Pattern (multiple parts):**

```
Program.External.Include.Library("7200.lib",False)

F.Data.DataTable.AddRow("7200")
F.Data.DataTable.SetValue("7200","Part","BRACKET-500",0)
F.Data.DataTable.SetValue("7200","Loc","01",0)

F.Data.DataTable.AddRow("7200")
F.Data.DataTable.SetValue("7200","Part","PLATE-200",1)
F.Data.DataTable.SetValue("7200","Loc","02",1)

F.Intrinsic.Control.CallSub(7200Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. The `Mode` column defaults to `"MR"` (the only valid value) and does not need to be explicitly set. No file generation, no field padding, and no additional global option/mode variables beyond the error variable.

---

## 8101.lib -- Sales Analysis in Detail Reports Preprocessor (PSA000P)

**Wraps:** CallWrapper `8101` — All Sales Analysis in Detail Reports Preprocessor / PSA000P

```
Program.External.Include.Library("8101.lib",False)
```

This library invokes the `8101` callwrapper to run Sales Analysis in Detail report preprocessing. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `8101` DataTable triggers a separate callwrapper invocation with all 17 column values concatenated via `ConcatCallWrapperArgs`.

Unlike most standard libraries, this library exposes **4 invocation subroutines** — the standard Sync/Async pair plus Bio (Business Intelligence Online) variants that use `CallWrapperSyncBio` and `CallWrapperAsyncBio`.

### DataTable Schema — `8101`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| RunID | Run ID | String | |
| ReportID | Report ID | String | See `ReportID` enum below |
| AllDates | All dates flag | String | `"0"` No / `"1"` Yes |
| StartDate | Start date | String | `YYYYMMDD` |
| EndDate | End date | String | `YYYYMMDD` |
| AllParts | All parts flag | String | `"0"` No / `"1"` Yes |
| PartRangeFileName | Part range file name | String | File in `%temp%\GSS` |
| AllPLs | All product lines flag | String | `"0"` No / `"1"` Yes |
| PLRangeFileName | Product line range file name | String | File in `%temp%\GSS` |
| AllCusts | All customers flag | String | `"0"` No / `"1"` Yes |
| CustRangeFileName | Customer range file name | String | File in `%temp%\GSS` |
| AllSalesRep | All sales reps flag | String | `"0"` No / `"1"` Yes |
| SalesRepRangeFileName | Sales rep range file name | String | File in `%temp%\GSS` |
| AllBranches | All branches flag | String | `"0"` No / `"1"` Yes |
| BranchRangeFileName | Branch range file name | String | File in `%temp%\GSS` |
| AllOrders | All orders flag | String | `"0"` No / `"1"` Yes |
| OrderRangeFileName | Order range file name | String | File in `%temp%\GSS` |

> **Note:** Each "All" flag / "RangeFileName" pair works together. When the flag is `"1"` (all), the range file name is ignored. When the flag is `"0"`, a range file **must** be provided and **must** be located in `%temp%\GSS`.

### ReportID Enum

| Value | Meaning |
|-------|---------|
| `"1301"` | By Part |
| `"1302"` | By Product Line |
| `"1303"` | By Product Line Part |
| `"1304"` | By Customer Part |
| `"1305"` | By Sales Rep |
| `"1306"` | By Sales Rep Product Line Part |
| `"1307"` | By Sales Rep Customer Part |
| `"1308"` | By Sales Rep Shipment Part |
| `"1309"` | By Branch Customer Part |
| `"9034"` | By Order |
| `"9040"` | By Product Line Part Cost |
| `"9041"` | By Customer Part Cost |
| `"9999"` | Custom |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s8101Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `8101Sync` | Calls `F.Global.General.CallWrapperSync(8101, ...)` per row |
| `8101Async` | Calls `F.Global.General.CallWrapperAsync(8101, ...)` per row |
| `8101SyncBio` | Calls `F.Global.General.CallWrapperSyncBio(8101, ...)` per row |
| `8101AsyncBio` | Calls `F.Global.General.CallWrapperAsyncBio(8101, ...)` per row |

### How It Works

1. The library creates an `8101` DataTable with 17 columns (`RunID` through `OrderRangeFileName`).
2. When any of the 4 subroutines is called, it loops through each row in the DataTable.
3. For each row, all 17 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `8101` is invoked using the selected method (Sync, Async, SyncBio, or AsyncBio) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s8101Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors).

**Usage Pattern (run "By Part" report for all dates and all parts):**

```
Program.External.Include.Library("8101.lib",False)

F.Data.DataTable.AddRow("8101")
F.Data.DataTable.SetValue("8101","RunID","RUN001",0)
F.Data.DataTable.SetValue("8101","ReportID","1301",0)
F.Data.DataTable.SetValue("8101","AllDates","1",0)
F.Data.DataTable.SetValue("8101","StartDate","",0)
F.Data.DataTable.SetValue("8101","EndDate","",0)
F.Data.DataTable.SetValue("8101","AllParts","1",0)
F.Data.DataTable.SetValue("8101","PartRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllPLs","1",0)
F.Data.DataTable.SetValue("8101","PLRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllCusts","1",0)
F.Data.DataTable.SetValue("8101","CustRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllSalesRep","1",0)
F.Data.DataTable.SetValue("8101","SalesRepRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllBranches","1",0)
F.Data.DataTable.SetValue("8101","BranchRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllOrders","1",0)
F.Data.DataTable.SetValue("8101","OrderRangeFileName","",0)

F.Intrinsic.Control.CallSub(8101Sync)
```

**Usage Pattern (date-range report with customer range file, using Bio):**

```
Program.External.Include.Library("8101.lib",False)

F.Data.DataTable.AddRow("8101")
F.Data.DataTable.SetValue("8101","RunID","RUN002",0)
F.Data.DataTable.SetValue("8101","ReportID","1304",0)
F.Data.DataTable.SetValue("8101","AllDates","0",0)
F.Data.DataTable.SetValue("8101","StartDate","20260101",0)
F.Data.DataTable.SetValue("8101","EndDate","20260331",0)
F.Data.DataTable.SetValue("8101","AllParts","1",0)
F.Data.DataTable.SetValue("8101","PartRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllPLs","1",0)
F.Data.DataTable.SetValue("8101","PLRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllCusts","0",0)
F.Data.DataTable.SetValue("8101","CustRangeFileName","CustRange.txt",0)
F.Data.DataTable.SetValue("8101","AllSalesRep","1",0)
F.Data.DataTable.SetValue("8101","SalesRepRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllBranches","1",0)
F.Data.DataTable.SetValue("8101","BranchRangeFileName","",0)
F.Data.DataTable.SetValue("8101","AllOrders","1",0)
F.Data.DataTable.SetValue("8101","OrderRangeFileName","",0)

F.Intrinsic.Control.CallSub(8101SyncBio)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. This library uniquely supports **4 invocation modes** including Bio (Business Intelligence Online) variants. All range file names must reference files located in `%temp%\GSS`. When an "All" flag is `"1"`, the corresponding range file name is ignored. No field padding is applied.

---

## 9200.lib -- Start Job (OLL304W)

**Wraps:** CallWrapper `9200` — Start Job / OLL304W

```
Program.External.Include.Library("9200.lib",False)
```

This library invokes the `9200` callwrapper to start a job on the shop floor. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `9200` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `9200`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| WO | Work order number | String | `9(6)` — 6-digit numeric |
| WOSuffix | Work order suffix | String | `9(3)` — 3-digit numeric |
| WOSeq | Work order sequence | String | `9(6)` — 6-digit numeric |
| WC | Work center | String | `9(4)` — 4-digit numeric |
| Employee | Employee number | String | `9(5)` — 5-digit numeric |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s9200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `9200Sync` | Calls `F.Global.General.CallWrapperSync(9200, ...)` per row |
| `9200Async` | Calls `F.Global.General.CallWrapperAsync(9200, ...)` per row |

### How It Works

1. The library creates a `9200` DataTable with columns `WO`, `WOSuffix`, `WOSeq`, `WC`, and `Employee`.
2. When `9200Sync` or `9200Async` is called, it loops through each row in the DataTable.
3. For each row, all 5 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `9200` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s9200Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `9200Sync`/`9200Async`).

**Usage Pattern (start a single job):**

```
Program.External.Include.Library("9200.lib",False)

F.Data.DataTable.AddRow("9200")
F.Data.DataTable.SetValue("9200","WO","123456",0)
F.Data.DataTable.SetValue("9200","WOSuffix","000",0)
F.Data.DataTable.SetValue("9200","WOSeq","000010",0)
F.Data.DataTable.SetValue("9200","WC","0100",0)
F.Data.DataTable.SetValue("9200","Employee","00042",0)

F.Intrinsic.Control.CallSub(9200Sync)
```

**Usage Pattern (start multiple jobs):**

```
Program.External.Include.Library("9200.lib",False)

F.Data.DataTable.AddRow("9200")
F.Data.DataTable.SetValue("9200","WO","123456",0)
F.Data.DataTable.SetValue("9200","WOSuffix","000",0)
F.Data.DataTable.SetValue("9200","WOSeq","000010",0)
F.Data.DataTable.SetValue("9200","WC","0100",0)
F.Data.DataTable.SetValue("9200","Employee","00042",0)

F.Data.DataTable.AddRow("9200")
F.Data.DataTable.SetValue("9200","WO","654321",1)
F.Data.DataTable.SetValue("9200","WOSuffix","001",1)
F.Data.DataTable.SetValue("9200","WOSeq","000020",1)
F.Data.DataTable.SetValue("9200","WC","0200",1)
F.Data.DataTable.SetValue("9200","Employee","00042",1)

F.Intrinsic.Control.CallSub(9200Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables are used. The error variable follows the 4-part format with a 1-based row index.

---

## 9201.lib -- Start Job with Terminal (OLL304W)

**Wraps:** CallWrapper `9201` — Start Job / OLL304W

```
Program.External.Include.Library("9201.lib",False)
```

This library is closely related to [`9200.lib`](#9200lib----start-job-oll304w) — both wrap a Start Job callwrapper for OLL304W. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `9201` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### Differences from `9200.lib`

| Aspect | `9200.lib` | `9201.lib` |
|--------|-----------|-----------|
| CallWrapper ID | `9200` | `9201` |
| DataTable name | `9200` | `9201` |
| Columns | 5 (`WO`, `WOSuffix`, `WOSeq`, `WC`, `Employee`) | 6 (`WO`, `Suffix`, `Seq`, `WC`, `Employee`, `Terminal`) |
| WO Suffix column name | `WOSuffix` | `Suffix` |
| WO Sequence column name | `WOSeq` | `Seq` |
| WC format | `9(4)` — 4-digit numeric | `X(2)` — 2-character alphanumeric |
| Terminal column | Not present | Defaults to `V.Caller.Terminal` |
| Global variable | `V.Global.s9200Error` | `V.Global.s9201Error` |
| Subroutines | `9200Sync` / `9200Async` | `9201Sync` / `9201Async` |

### DataTable Schema — `9201`

| Column | Description | Type | Default | Values |
|--------|-------------|------|---------|--------|
| WO | Work order number | String | `""` | `9(6)` |
| Suffix | Work order suffix | String | `""` | `9(3)` |
| Seq | Work order sequence | String | `""` | `9(6)` |
| WC | Work center | String | `""` | `X(2)` |
| Employee | Employee number | String | `""` | `9(5)` |
| Terminal | Terminal number | String | `V.Caller.Terminal` | Caller's terminal number |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s9201Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `9201Sync` | Calls `F.Global.General.CallWrapperSync(9201, ...)` per row |
| `9201Async` | Calls `F.Global.General.CallWrapperAsync(9201, ...)` per row |

### How It Works

1. The library creates a `9201` DataTable with 6 columns (`WO`, `Suffix`, `Seq`, `WC`, `Employee`, `Terminal`). The `Terminal` column defaults to `V.Caller.Terminal`.
2. When `9201Sync` or `9201Async` is called, it loops through each row in the DataTable.
3. For each row, all 6 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `9201` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s9201Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `9201Sync`/`9201Async`).

**Usage Pattern (start a job using default terminal):**

```
Program.External.Include.Library("9201.lib",False)

F.Data.DataTable.AddRow("9201")
F.Data.DataTable.SetValue("9201","WO","123456",0)
F.Data.DataTable.SetValue("9201","Suffix","000",0)
F.Data.DataTable.SetValue("9201","Seq","000010",0)
F.Data.DataTable.SetValue("9201","WC","01",0)
F.Data.DataTable.SetValue("9201","Employee","00042",0)
'Terminal defaults to V.Caller.Terminal — no need to set it

F.Intrinsic.Control.CallSub(9201Sync)
```

**Usage Pattern (start a job with explicit terminal override):**

```
Program.External.Include.Library("9201.lib",False)

F.Data.DataTable.AddRow("9201")
F.Data.DataTable.SetValue("9201","WO","654321",0)
F.Data.DataTable.SetValue("9201","Suffix","001",0)
F.Data.DataTable.SetValue("9201","Seq","000020",0)
F.Data.DataTable.SetValue("9201","WC","02",0)
F.Data.DataTable.SetValue("9201","Employee","00042",0)
F.Data.DataTable.SetValue("9201","Terminal","005",0)

F.Intrinsic.Control.CallSub(9201Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. The `Terminal` column defaults to `V.Caller.Terminal` and does not need to be explicitly set unless you want to override it. The main differences from `9200.lib` are the additional `Terminal` column, different column names (`Suffix`/`Seq` vs `WOSuffix`/`WOSeq`), and a shorter `WC` format (`X(2)` vs `9(4)`).

---

## 100000.lib -- Customer/Prospect Master

**Wraps:** CallWrapper `100000`

> **Note:** The source library uses placeholder text for the description and core program name (`*DESCRIPTION*` / `*PROGRAM*`). Based on the parameters (Mode with CRUD operations, Customer/Prospect flag, Customer number), this callwrapper operates on the Customer/Prospect Master.

```
Program.External.Include.Library("100000.lib",False)
```

This library invokes the `100000` callwrapper for Customer/Prospect Master operations. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `100000` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `100000`

| Column | Description | Type | Default | Values |
|--------|-------------|------|---------|--------|
| Mode | Operation mode | String | `""` | See `Mode` enum below |
| ProspectFlag | Customer or Prospect flag | String | `" "` (space = Customer) | See `ProspectFlag` enum below |
| Customer | Customer number | String | `""` | `X(7)` |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"F"` | Find |
| `"O"` | Open |
| `"N"` | New |
| `"D"` | Delete |
| `"V"` | View |
| `"E"` | Edit |

### ProspectFlag Enum

| Value | Meaning |
|-------|---------|
| `" "` | Customer (default) |
| `"P"` | Prospect |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s100000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `100000Sync` | Calls `F.Global.General.CallWrapperSync(100000, ...)` per row |
| `100000Async` | Calls `F.Global.General.CallWrapperAsync(100000, ...)` per row |

### How It Works

1. The library creates a `100000` DataTable with columns `Mode`, `ProspectFlag` (defaulting to `" "`), and `Customer`.
2. When `100000Sync` or `100000Async` is called, it loops through each row in the DataTable.
3. For each row, `Mode`, `ProspectFlag`, and `Customer` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `100000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s100000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `100000Sync`/`100000Async`).

**Usage Pattern (open a customer record):**

```
Program.External.Include.Library("100000.lib",False)

F.Data.DataTable.AddRow("100000")
F.Data.DataTable.SetValue("100000","Mode","O",0)
F.Data.DataTable.SetValue("100000","Customer","ABC1234",0)
'ProspectFlag defaults to " " (Customer) — no need to set it

F.Intrinsic.Control.CallSub(100000Sync)
```

**Usage Pattern (view a prospect record):**

```
Program.External.Include.Library("100000.lib",False)

F.Data.DataTable.AddRow("100000")
F.Data.DataTable.SetValue("100000","Mode","V",0)
F.Data.DataTable.SetValue("100000","ProspectFlag","P",0)
F.Data.DataTable.SetValue("100000","Customer","PRO5678",0)

F.Intrinsic.Control.CallSub(100000Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. The `ProspectFlag` column defaults to `" "` (space, meaning Customer) and does not need to be explicitly set for customer operations. No file generation, no field padding, and no additional global option/mode variables beyond the error variable.

---

## 100200.lib -- View Open AR (AR0170GI)

**Wraps:** CallWrapper `100200` — View Open AR / AR0170GI

```
Program.External.Include.Library("100200.lib",False)
```

This library invokes the `100200` callwrapper to view Open Accounts Receivable for a customer. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `100200` DataTable triggers a separate callwrapper invocation.

Unlike most standard libraries, this library has only **a single column** and passes the `Customer` value directly to the callwrapper without using `ConcatCallWrapperArgs`.

### DataTable Schema — `100200`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Customer | Customer number | String | `X(6)` |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s100200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `100200Sync` | Calls `F.Global.General.CallWrapperSync(100200, ...)` per row |
| `100200Async` | Calls `F.Global.General.CallWrapperAsync(100200, ...)` per row |

### How It Works

1. The library creates a `100200` DataTable with a single column `Customer`.
2. When `100200Sync` or `100200Async` is called, it loops through each row in the DataTable.
3. For each row, the `Customer` FieldVal is passed **directly** to the callwrapper (no `ConcatCallWrapperArgs` needed for a single parameter).
4. The callwrapper `100200` is invoked (sync or async) with the customer number.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s100200Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `100200Sync`/`100200Async`).

**Usage Pattern (view open AR for a single customer):**

```
Program.External.Include.Library("100200.lib",False)

F.Data.DataTable.AddRow("100200")
F.Data.DataTable.SetValue("100200","Customer","ABC123",0)

F.Intrinsic.Control.CallSub(100200Sync)
```

**Usage Pattern (view open AR for multiple customers):**

```
Program.External.Include.Library("100200.lib",False)

F.Data.DataTable.AddRow("100200")
F.Data.DataTable.SetValue("100200","Customer","ABC123",0)

F.Data.DataTable.AddRow("100200")
F.Data.DataTable.SetValue("100200","Customer","XYZ456",1)

F.Intrinsic.Control.CallSub(100200Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. This library passes the single `Customer` value directly to the callwrapper rather than using `ConcatCallWrapperArgs`. No file generation, no field padding, and no global option/mode variables.

---

## 175100.lib -- Generate Purchase Order from File (PURA64GI)

**Wraps:** CallWrapper `175100` — Generate Purchase Order from File / PURA64GI

```
Program.External.Include.Library("175100.lib",False)
```

This library invokes the `175100` callwrapper to generate Purchase Orders from a tab-delimited file. It uses **two linked DataTables** — `175100` (header/control) and `175100File` (PO line items) — linked by a common `ID` field. For each header row, the library filters the line DataTable by `ID`, writes the matching lines to a **tab-delimited flat file**, then calls the callwrapper with the file path and control flags.

The core program (PURA64GI) generates **one PO per unique Vendor** found in the file. If the file contains lines for multiple vendors, multiple POs are created from a single callwrapper invocation.

### DataTable Schema — `175100` (Header/Control)

| Column | Description | Type | Default | Values |
|--------|-------------|------|---------|--------|
| ID | Linkage ID to `175100File` | Long | `1` | Any integer |
| File | Output file path | String | `{FilesDir}\{CompanyCode}{Terminal}175100.txt` | Full file path |
| AutoNumber | Auto-number PO flag | String | `""` | `Y` / `N` |
| AddComments | Add comments flag | String | `""` | `Y` / `N` |
| OpenPO | Open PO flag | String | `""` | `Y` / `N` |

### DataTable Schema — `175100File` (Line Items)

| Column | Description | Type | Default | Values |
|--------|-------------|------|---------|--------|
| ID | Linkage ID to `175100` | Long | `1` | Must match a header `ID` |
| Vendor | Vendor number | String | `""` | `X(7)` |
| Part | Part number | String | `""` | `X(20)` |
| Loc | Location | String | `""` | `X(2)` |
| DueDate | Due date | String | `""` | `YYYYMMDD` |
| Description | Part description | String | `""` | `X(50)` |
| InvUM | Inventory unit of measure | String | `""` | `X(2)` |
| InvCost | Inventory cost | String | `""` | Numeric `10.6` |
| InvQty | Inventory quantity | String | `""` | Numeric `9.4` |
| POUM | PO unit of measure | String | `""` | `X(2)` |
| POCost | PO cost | String | `""` | Numeric `10.6` |
| POQty | PO quantity | String | `""` | Numeric `9.4` |
| GLAccount | GL account | String | `""` | `X(15)` |
| Extension | Extension | String | `""` | Numeric `8.2` |

> **Note:** The source comments reference the column name `PartDesc`, but the actual `AddColumn` call uses `Description`. Use `Description` when setting values.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s175100Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |
| `V.Global.s175100FileName` | File name only | `{CompanyCode}{Terminal}175100.txt` |
| `V.Global.s175100FilePath` | Full file path | `{FilesDir}\{s175100FileName}` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `175100Sync` | Calls `F.Global.General.CallWrapperSync(175100, ...)` per header row |
| `175100Async` | Calls `F.Global.General.CallWrapperAsync(175100, ...)` per header row |

### How It Works

1. The library creates two DataTables: `175100` (header with `ID`, `File`, `AutoNumber`, `AddComments`, `OpenPO`) and `175100File` (lines with `ID` + 13 line-item columns). Both default `ID` to `1`.
2. `s175100FileName` and `s175100FilePath` are dynamically built from `V.Caller.CompanyCode`, `V.Caller.Terminal`, and `V.Caller.FilesDir`.
3. When `175100Sync` or `175100Async` is called, it loops through each row in the `175100` header DataTable.
4. For each header row, a **DataView** is created on `175100File` filtering by `ID = '{header ID}'`.
5. The filtered lines are written to the file path as a **tab-delimited** flat file using `DataView.ToString(... , V.Ambient.Tab, V.Ambient.NewLine)` with columns: `Vendor`, `Part`, `Loc`, `DueDate`, `Description`, `InvUM`, `InvCost`, `InvQty`, `POUM`, `POCost`, `POQty`, `GLAccount`, `Extension` (the `ID` column is excluded from the file).
6. The callwrapper parameters (`File`, `AutoNumber`, `AddComments`, `OpenPO`) are concatenated via `ConcatCallWrapperArgs` and the callwrapper `175100` is invoked.
7. The DataView is closed after each header row iteration.
8. After all header rows are processed, both DataTables' rows are deleted.
9. On error, `V.Global.s175100Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors).

**Usage Pattern (single PO with multiple lines):**

```
Program.External.Include.Library("175100.lib",False)

'Header — use defaults (ID=1, dynamic file path)
F.Data.DataTable.AddRow("175100")
F.Data.DataTable.SetValue("175100","AutoNumber","Y",0)
F.Data.DataTable.SetValue("175100","AddComments","N",0)
F.Data.DataTable.SetValue("175100","OpenPO","Y",0)

'Line 1
F.Data.DataTable.AddRow("175100File")
F.Data.DataTable.SetValue("175100File","Vendor","VEND001",0)
F.Data.DataTable.SetValue("175100File","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("175100File","Loc","01",0)
F.Data.DataTable.SetValue("175100File","DueDate","20260501",0)
F.Data.DataTable.SetValue("175100File","Description","Widget Assembly",0)
F.Data.DataTable.SetValue("175100File","InvUM","EA",0)
F.Data.DataTable.SetValue("175100File","InvCost","12.500000",0)
F.Data.DataTable.SetValue("175100File","InvQty","100.0000",0)
F.Data.DataTable.SetValue("175100File","POUM","EA",0)
F.Data.DataTable.SetValue("175100File","POCost","12.500000",0)
F.Data.DataTable.SetValue("175100File","POQty","100.0000",0)
F.Data.DataTable.SetValue("175100File","GLAccount","5000-00",0)
F.Data.DataTable.SetValue("175100File","Extension","1250.00",0)

'Line 2
F.Data.DataTable.AddRow("175100File")
F.Data.DataTable.SetValue("175100File","Vendor","VEND001",1)
F.Data.DataTable.SetValue("175100File","Part","BRACKET-500",1)
F.Data.DataTable.SetValue("175100File","Loc","01",1)
F.Data.DataTable.SetValue("175100File","DueDate","20260501",1)
F.Data.DataTable.SetValue("175100File","Description","Steel Bracket",1)
F.Data.DataTable.SetValue("175100File","InvUM","EA",1)
F.Data.DataTable.SetValue("175100File","InvCost","3.750000",1)
F.Data.DataTable.SetValue("175100File","InvQty","200.0000",1)
F.Data.DataTable.SetValue("175100File","POUM","EA",1)
F.Data.DataTable.SetValue("175100File","POCost","3.750000",1)
F.Data.DataTable.SetValue("175100File","POQty","200.0000",1)
F.Data.DataTable.SetValue("175100File","GLAccount","5000-00",1)
F.Data.DataTable.SetValue("175100File","Extension","750.00",1)

F.Intrinsic.Control.CallSub(175100Sync)
```

**Usage Pattern (multiple POs via separate IDs):**

```
Program.External.Include.Library("175100.lib",False)

'Header row 1 — ID 1
F.Data.DataTable.AddRow("175100")
F.Data.DataTable.SetValue("175100","AutoNumber","Y",0)
F.Data.DataTable.SetValue("175100","AddComments","N",0)
F.Data.DataTable.SetValue("175100","OpenPO","N",0)

'Header row 2 — ID 2
F.Data.DataTable.AddRow("175100")
F.Data.DataTable.SetValue("175100","ID","2",1)
F.Data.DataTable.SetValue("175100","AutoNumber","Y",1)
F.Data.DataTable.SetValue("175100","AddComments","Y",1)
F.Data.DataTable.SetValue("175100","OpenPO","Y",1)

'Lines for ID 1
F.Data.DataTable.AddRow("175100File")
F.Data.DataTable.SetValue("175100File","Vendor","VEND001",0)
F.Data.DataTable.SetValue("175100File","Part","PLATE-200",0)
F.Data.DataTable.SetValue("175100File","Loc","02",0)
F.Data.DataTable.SetValue("175100File","DueDate","20260601",0)
F.Data.DataTable.SetValue("175100File","Description","Steel Plate",0)
F.Data.DataTable.SetValue("175100File","InvUM","EA",0)
F.Data.DataTable.SetValue("175100File","InvCost","25.000000",0)
F.Data.DataTable.SetValue("175100File","InvQty","50.0000",0)
F.Data.DataTable.SetValue("175100File","POUM","EA",0)
F.Data.DataTable.SetValue("175100File","POCost","25.000000",0)
F.Data.DataTable.SetValue("175100File","POQty","50.0000",0)
F.Data.DataTable.SetValue("175100File","GLAccount","5100-00",0)
F.Data.DataTable.SetValue("175100File","Extension","1250.00",0)

'Lines for ID 2
F.Data.DataTable.AddRow("175100File")
F.Data.DataTable.SetValue("175100File","ID","2",1)
F.Data.DataTable.SetValue("175100File","Vendor","VEND002",1)
F.Data.DataTable.SetValue("175100File","Part","BOLT-100",1)
F.Data.DataTable.SetValue("175100File","Loc","01",1)
F.Data.DataTable.SetValue("175100File","DueDate","20260615",1)
F.Data.DataTable.SetValue("175100File","Description","Hex Bolt M10",1)
F.Data.DataTable.SetValue("175100File","InvUM","BX",1)
F.Data.DataTable.SetValue("175100File","InvCost","0.150000",1)
F.Data.DataTable.SetValue("175100File","InvQty","1000.0000",1)
F.Data.DataTable.SetValue("175100File","POUM","BX",1)
F.Data.DataTable.SetValue("175100File","POCost","0.150000",1)
F.Data.DataTable.SetValue("175100File","POQty","1000.0000",1)
F.Data.DataTable.SetValue("175100File","GLAccount","5200-00",1)
F.Data.DataTable.SetValue("175100File","Extension","150.00",1)

F.Intrinsic.Control.CallSub(175100Sync)
```

> **Note:** Both DataTables are cleared after processing. The callwrapper is invoked **per header row** — each header triggers its own file write and callwrapper call. The file is written as **tab-delimited** (not CSV, not fixed-position) using `DataView.ToString` with `V.Ambient.Tab` as the column separator. The `ID` column links the two DataTables but is excluded from the output file. The core program generates **one PO per unique Vendor** in the file — if a single file contains lines for multiple vendors, multiple POs are created from that one callwrapper call. The file path defaults to `{FilesDir}\{CompanyCode}{Terminal}175100.txt` but can be overridden via the `File` column or by setting `V.Global.s175100FilePath` before adding rows.

---

## 175200.lib -- Open Purchase Order (PUR064GH)

**Wraps:** CallWrapper `175200` — Open Purchase Order / PUR064GH

```
Program.External.Include.Library("175200.lib",False)
```

This library invokes the `175200` callwrapper to open, create, delete, view, view history, or copy a Purchase Order. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `175200` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `175200`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Mode | Operation mode | String | See `Mode` enum below |
| PONum | Purchase order number | String | `9(7)` — 7-digit numeric |
| VendNum | Vendor number | String | `9(6)` — 6-digit numeric |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"O"` | Open |
| `"N"` | New |
| `"D"` | Delete |
| `"V"` | View |
| `"H"` | View History |
| `"C"` | Copy |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s175200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `175200Sync` | Calls `F.Global.General.CallWrapperSync(175200, ...)` per row |
| `175200Async` | Calls `F.Global.General.CallWrapperAsync(175200, ...)` per row |

### How It Works

1. The library creates a `175200` DataTable with columns `Mode`, `PONum`, and `VendNum`.
2. When `175200Sync` or `175200Async` is called, it loops through each row in the DataTable.
3. For each row, `Mode`, `PONum`, and `VendNum` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `175200` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s175200Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `175200Sync`/`175200Async`).

**Usage Pattern (open an existing PO):**

```
Program.External.Include.Library("175200.lib",False)

F.Data.DataTable.AddRow("175200")
F.Data.DataTable.SetValue("175200","Mode","O",0)
F.Data.DataTable.SetValue("175200","PONum","0012345",0)
F.Data.DataTable.SetValue("175200","VendNum","001234",0)

F.Intrinsic.Control.CallSub(175200Sync)
```

**Usage Pattern (create new PO and view history of another):**

```
Program.External.Include.Library("175200.lib",False)

'New PO
F.Data.DataTable.AddRow("175200")
F.Data.DataTable.SetValue("175200","Mode","N",0)
F.Data.DataTable.SetValue("175200","PONum","",0)
F.Data.DataTable.SetValue("175200","VendNum","005678",0)

'View history
F.Data.DataTable.AddRow("175200")
F.Data.DataTable.SetValue("175200","Mode","H",1)
F.Data.DataTable.SetValue("175200","PONum","0054321",1)
F.Data.DataTable.SetValue("175200","VendNum","005678",1)

F.Intrinsic.Control.CallSub(175200Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables are used. The error variable follows the 4-part format with a 1-based row index.

---

## 200000.lib -- Sales Orders (ORD200)

**Wraps:** CallWrapper `200000` — Sales Orders / ORD200

```
Program.External.Include.Library("200000.lib",False)
```

This library invokes the `200000` callwrapper to view, open, create, copy, or delete a Sales Order. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `200000` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `200000`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| OrdNum | Order number | String | `9(7)` — 7-digit numeric |
| Mode | Operation mode | String | See `Mode` enum below |
| CustNum | Customer number | String | `9(6)` — 6-digit numeric |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"V"` | View |
| `"O"` | Open |
| `"N"` | New |
| `"C"` | Copy |
| `"D"` | Delete |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s200000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `200000Sync` | Calls `F.Global.General.CallWrapperSync(200000, ...)` per row |
| `200000Async` | Calls `F.Global.General.CallWrapperAsync(200000, ...)` per row |

### How It Works

1. The library creates a `200000` DataTable with columns `OrdNum`, `Mode`, and `CustNum`.
2. When `200000Sync` or `200000Async` is called, it loops through each row in the DataTable.
3. For each row, `OrdNum`, `Mode`, and `CustNum` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `200000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s200000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `200000Sync`/`200000Async`).

**Usage Pattern (open an existing sales order):**

```
Program.External.Include.Library("200000.lib",False)

F.Data.DataTable.AddRow("200000")
F.Data.DataTable.SetValue("200000","OrdNum","1234567",0)
F.Data.DataTable.SetValue("200000","Mode","O",0)
F.Data.DataTable.SetValue("200000","CustNum","001234",0)

F.Intrinsic.Control.CallSub(200000Sync)
```

**Usage Pattern (create new order and view another):**

```
Program.External.Include.Library("200000.lib",False)

'New order
F.Data.DataTable.AddRow("200000")
F.Data.DataTable.SetValue("200000","OrdNum","",0)
F.Data.DataTable.SetValue("200000","Mode","N",0)
F.Data.DataTable.SetValue("200000","CustNum","005678",0)

'View existing order
F.Data.DataTable.AddRow("200000")
F.Data.DataTable.SetValue("200000","OrdNum","7654321",1)
F.Data.DataTable.SetValue("200000","Mode","V",1)
F.Data.DataTable.SetValue("200000","CustNum","005678",1)

F.Intrinsic.Control.CallSub(200000Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables are used. The error variable follows the 4-part format with a 1-based row index.

---

## 200700.lib -- Sales Order History by Invoice (QL3060)

**Wraps:** CallWrapper `200700` — Sales Order History by Invoice / QL3060

```
Program.External.Include.Library("200700.lib",False)
```

This library invokes the `200700` callwrapper to view Sales Order History by Invoice number. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `200700` DataTable triggers a separate callwrapper invocation.

Like [`100200.lib`](#100200lib----view-open-ar-ar0170gi), this library has only **a single column** and passes the `Invoice` value directly to the callwrapper without using `ConcatCallWrapperArgs`.

### DataTable Schema — `200700`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Invoice | Invoice number | String | `9(6)` — 6-digit numeric |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s200700Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `200700Sync` | Calls `F.Global.General.CallWrapperSync(200700, ...)` per row |
| `200700Async` | Calls `F.Global.General.CallWrapperAsync(200700, ...)` per row |

### How It Works

1. The library creates a `200700` DataTable with a single column `Invoice`.
2. When `200700Sync` or `200700Async` is called, it loops through each row in the DataTable.
3. For each row, the `Invoice` FieldVal is passed **directly** to the callwrapper (no `ConcatCallWrapperArgs` needed for a single parameter).
4. The callwrapper `200700` is invoked (sync or async) with the invoice number.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s200700Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `200700Sync`/`200700Async`).

**Usage Pattern (view history for a single invoice):**

```
Program.External.Include.Library("200700.lib",False)

F.Data.DataTable.AddRow("200700")
F.Data.DataTable.SetValue("200700","Invoice","123456",0)

F.Intrinsic.Control.CallSub(200700Sync)
```

**Usage Pattern (view history for multiple invoices):**

```
Program.External.Include.Library("200700.lib",False)

F.Data.DataTable.AddRow("200700")
F.Data.DataTable.SetValue("200700","Invoice","123456",0)

F.Data.DataTable.AddRow("200700")
F.Data.DataTable.SetValue("200700","Invoice","654321",1)

F.Intrinsic.Control.CallSub(200700Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. This library passes the single `Invoice` value directly to the callwrapper rather than using `ConcatCallWrapperArgs`. No file generation, no field padding, and no global option/mode variables.

---

## 200800.lib -- Create WO from Sales Order (ORD880)

**Wraps:** CallWrapper `200800` — Create WO from Sales Order / ORD880

```
Program.External.Include.Library("200800.lib",False)
```

This library invokes the `200800` callwrapper to create a Work Order from a Sales Order. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `200800` DataTable triggers a separate callwrapper invocation with the row's parameters concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `200800`

| Column | Description | Type | Default | Values |
|--------|-------------|------|---------|--------|
| Type | Type | String | `"O"` | See `Type` enum below |
| OrdNum | Order number | String | `""` | `9(7)` — 7-digit numeric |

### Type Enum

| Value | Meaning |
|-------|---------|
| `"O"` | Order |

> **Note:** `"O"` is the **only valid option** for `Type`. The column defaults to `"O"` at DataTable creation, so it can be omitted from your `SetValue` calls.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s200800Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `200800Sync` | Calls `F.Global.General.CallWrapperSync(200800, ...)` per row |
| `200800Async` | Calls `F.Global.General.CallWrapperAsync(200800, ...)` per row |

### How It Works

1. The library creates a `200800` DataTable with columns `Type` (defaulting to `"O"`) and `OrdNum`.
2. When `200800Sync` or `200800Async` is called, it loops through each row in the DataTable.
3. For each row, `Type` and `OrdNum` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `200800` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s200800Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `200800Sync`/`200800Async`).

**Usage Pattern (create WO from a single sales order):**

```
Program.External.Include.Library("200800.lib",False)

F.Data.DataTable.AddRow("200800")
F.Data.DataTable.SetValue("200800","OrdNum","1234567",0)
'Type defaults to "O" — no need to set it

F.Intrinsic.Control.CallSub(200800Sync)
```

**Usage Pattern (create WOs from multiple sales orders):**

```
Program.External.Include.Library("200800.lib",False)

F.Data.DataTable.AddRow("200800")
F.Data.DataTable.SetValue("200800","OrdNum","1234567",0)

F.Data.DataTable.AddRow("200800")
F.Data.DataTable.SetValue("200800","OrdNum","7654321",1)

F.Intrinsic.Control.CallSub(200800Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. The `Type` column defaults to `"O"` (the only valid value) and does not need to be explicitly set. No file generation, no field padding, and no additional global option/mode variables beyond the error variable.

---

## 200801.lib -- Sales Order to Work Order (ORD880)

**Wraps:** CallWrapper `200801` — Sales Order to Work Order / ORD880

```
Program.External.Include.Library("200801.lib",False)
```

This library invokes the `200801` callwrapper for Sales Order to Work Order conversion. It shares the same core program (ORD880) as [`200800.lib`](#200800lib----create-wo-from-sales-order-ord880) but provides more granular control with order type, line number, and line flag parameters. It is a **direct callwrapper invoker** — no file generation, no field padding. Each row in the `200801` DataTable triggers a separate callwrapper invocation with all 4 column values concatenated via `ConcatCallWrapperArgs`.

### DataTable Schema — `200801`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| OrderType | Order type | String | See `OrderType` enum below |
| Order | Order number | String | `9(7)` — 7-digit numeric |
| Line | Line number | String | `9(3)` — 3-digit numeric |
| LineFlag | Line flag | String | `"Y"` / `"N"` |

### OrderType Enum

| Value | Meaning |
|-------|---------|
| `"C"` | Cycle |
| `"D"` | Detail |
| `"O"` | Order |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s200801Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `200801Sync` | Calls `F.Global.General.CallWrapperSync(200801, ...)` per row |
| `200801Async` | Calls `F.Global.General.CallWrapperAsync(200801, ...)` per row |

### How It Works

1. The library creates a `200801` DataTable with columns `OrderType`, `Order`, `Line`, and `LineFlag`.
2. When `200801Sync` or `200801Async` is called, it loops through each row in the DataTable.
3. For each row, all 4 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `200801` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s200801Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `200801Sync`/`200801Async`).

**Usage Pattern (convert a specific order line):**

```
Program.External.Include.Library("200801.lib",False)

F.Data.DataTable.AddRow("200801")
F.Data.DataTable.SetValue("200801","OrderType","O",0)
F.Data.DataTable.SetValue("200801","Order","1234567",0)
F.Data.DataTable.SetValue("200801","Line","001",0)
F.Data.DataTable.SetValue("200801","LineFlag","Y",0)

F.Intrinsic.Control.CallSub(200801Sync)
```

**Usage Pattern (convert multiple order lines):**

```
Program.External.Include.Library("200801.lib",False)

'Detail type, line 1
F.Data.DataTable.AddRow("200801")
F.Data.DataTable.SetValue("200801","OrderType","D",0)
F.Data.DataTable.SetValue("200801","Order","1234567",0)
F.Data.DataTable.SetValue("200801","Line","001",0)
F.Data.DataTable.SetValue("200801","LineFlag","Y",0)

'Cycle type, line 2
F.Data.DataTable.AddRow("200801")
F.Data.DataTable.SetValue("200801","OrderType","C",1)
F.Data.DataTable.SetValue("200801","Order","1234567",1)
F.Data.DataTable.SetValue("200801","Line","002",1)
F.Data.DataTable.SetValue("200801","LineFlag","N",1)

F.Intrinsic.Control.CallSub(200801Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. Unlike `200800.lib` (which only supports `"O"` type), this library supports three order types (`"C"`, `"D"`, `"O"`) and allows specifying individual line numbers with a line flag. No file generation, no field padding, and no global option/mode variables.

---

## 200803.lib -- Create WO from Sales Order - Extended (ORD880)

**Wraps:** CallWrapper `200803` — Create WO from Sales Order / ORD880

```
Program.External.Include.Library("200803.lib",False)
```

This library invokes the `200803` callwrapper for extended Work Order creation from a Sales Order. It shares the same core program (ORD880) as [`200800.lib`](#200800lib----create-wo-from-sales-order-ord880) and [`200801.lib`](#200801lib----sales-order-to-work-order-ord880), but provides the most comprehensive set of parameters with **14 columns** including control flags for screenless operation, router/BOM bypass, date bypass, and order quantity override. It is a **direct callwrapper invoker** — no file generation, no field padding.

### DataTable Schema — `200803`

| Column | Description | Type | Values |
|--------|-------------|------|--------|
| Type | Order type | String | See `Type` enum below |
| Order | Order number | String | `9(7)` — 7-digit numeric |
| Line | Line number | String | `9(3)` — 3-digit numeric |
| LineFlag | Line flag | String | `1` Yes / `0` No |
| GenWOFlag | Generate work order flag | String | `1` Yes / `0` No |
| DueDate | Due date | String | `YYYYMMDD` |
| Part | Part number | String | |
| Router | Router | String | |
| NoRouterBOMFlag | No router/BOM flag | String | `1` Yes / `0` No |
| NODateBypassFlag | No date bypass flag | String | `1` Yes / `0` No |
| ScreenlessFlag | Screenless flag | String | `1` Yes / `0` No |
| ProcessNoOrderFlag | Process no order flag | String | `1` Yes / `0` No |
| Location | Location | String | `9(3)` |
| OrderQty | Order quantity | String | Numeric |

> **Note:** The `NODateBypassFlag` column uses uppercase `NO` in the `AddColumn` call but mixed-case `No` in the `ConcatCallWrapperArgs` reference. GAB column names are case-insensitive, so both forms work. The source comments use `NoDateBypassFlag`. Additionally, this library uses `1`/`0` for flag values (unlike `200801.lib` which uses `Y`/`N`).

### Type Enum

| Value | Meaning |
|-------|---------|
| `"C"` | Cycle Billing Order |
| `"D"` | Detail Billing Order |
| `"O"` | Sales Order |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s200803Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `200803Sync` | Calls `F.Global.General.CallWrapperSync(200803, ...)` per row |
| `200803Async` | Calls `F.Global.General.CallWrapperAsync(200803, ...)` per row |

### How It Works

1. The library creates a `200803` DataTable with 14 columns (`Type` through `OrderQty`).
2. When `200803Sync` or `200803Async` is called, it loops through each row in the DataTable.
3. For each row, all 14 column values are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `200803` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s200803Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `200803Sync`/`200803Async`).

### Comparison with Related ORD880 Libraries

| Aspect | `200800.lib` | `200801.lib` | `200803.lib` |
|--------|-------------|-------------|-------------|
| CallWrapper ID | `200800` | `200801` | `200803` |
| Columns | 2 | 4 | 14 |
| Order types | `"O"` only (default) | `"C"`, `"D"`, `"O"` | `"C"`, `"D"`, `"O"` |
| Line control | No | Yes (`Line`, `LineFlag`) | Yes (`Line`, `LineFlag`) |
| Flag format | N/A | `Y`/`N` | `1`/`0` |
| Extended flags | No | No | Yes (GenWO, NoRouterBOM, NoDateBypass, Screenless, ProcessNoOrder) |
| Part/Router | No | No | Yes |
| DueDate/Location/Qty | No | No | Yes |

**Usage Pattern (screenless WO creation from a sales order):**

```
Program.External.Include.Library("200803.lib",False)

F.Data.DataTable.AddRow("200803")
F.Data.DataTable.SetValue("200803","Type","O",0)
F.Data.DataTable.SetValue("200803","Order","1234567",0)
F.Data.DataTable.SetValue("200803","Line","001",0)
F.Data.DataTable.SetValue("200803","LineFlag","1",0)
F.Data.DataTable.SetValue("200803","GenWOFlag","1",0)
F.Data.DataTable.SetValue("200803","DueDate","20260501",0)
F.Data.DataTable.SetValue("200803","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("200803","Router","STD-ROUTE",0)
F.Data.DataTable.SetValue("200803","NoRouterBOMFlag","0",0)
F.Data.DataTable.SetValue("200803","NODateBypassFlag","0",0)
F.Data.DataTable.SetValue("200803","ScreenlessFlag","1",0)
F.Data.DataTable.SetValue("200803","ProcessNoOrderFlag","0",0)
F.Data.DataTable.SetValue("200803","Location","01",0)
F.Data.DataTable.SetValue("200803","OrderQty","100",0)

F.Intrinsic.Control.CallSub(200803Sync)
```

**Usage Pattern (batch WO creation — multiple lines):**

```
Program.External.Include.Library("200803.lib",False)

'Line 1
F.Data.DataTable.AddRow("200803")
F.Data.DataTable.SetValue("200803","Type","O",0)
F.Data.DataTable.SetValue("200803","Order","1234567",0)
F.Data.DataTable.SetValue("200803","Line","001",0)
F.Data.DataTable.SetValue("200803","LineFlag","1",0)
F.Data.DataTable.SetValue("200803","GenWOFlag","1",0)
F.Data.DataTable.SetValue("200803","DueDate","20260501",0)
F.Data.DataTable.SetValue("200803","Part","",0)
F.Data.DataTable.SetValue("200803","Router","",0)
F.Data.DataTable.SetValue("200803","NoRouterBOMFlag","0",0)
F.Data.DataTable.SetValue("200803","NODateBypassFlag","1",0)
F.Data.DataTable.SetValue("200803","ScreenlessFlag","1",0)
F.Data.DataTable.SetValue("200803","ProcessNoOrderFlag","0",0)
F.Data.DataTable.SetValue("200803","Location","01",0)
F.Data.DataTable.SetValue("200803","OrderQty","50",0)

'Line 2
F.Data.DataTable.AddRow("200803")
F.Data.DataTable.SetValue("200803","Type","O",1)
F.Data.DataTable.SetValue("200803","Order","1234567",1)
F.Data.DataTable.SetValue("200803","Line","002",1)
F.Data.DataTable.SetValue("200803","LineFlag","1",1)
F.Data.DataTable.SetValue("200803","GenWOFlag","1",1)
F.Data.DataTable.SetValue("200803","DueDate","20260515",1)
F.Data.DataTable.SetValue("200803","Part","",1)
F.Data.DataTable.SetValue("200803","Router","",1)
F.Data.DataTable.SetValue("200803","NoRouterBOMFlag","0",1)
F.Data.DataTable.SetValue("200803","NODateBypassFlag","1",1)
F.Data.DataTable.SetValue("200803","ScreenlessFlag","1",1)
F.Data.DataTable.SetValue("200803","ProcessNoOrderFlag","0",1)
F.Data.DataTable.SetValue("200803","Location","01",1)
F.Data.DataTable.SetValue("200803","OrderQty","75",1)

F.Intrinsic.Control.CallSub(200803Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row**. All 14 columns are always passed to `ConcatCallWrapperArgs` — unused fields can be set to empty strings. This is the most comprehensive of the three ORD880 libraries (`200800`, `200801`, `200803`), adding extended flags for screenless processing, router/BOM bypass, and order quantity override. Flag values use `1`/`0` (not `Y`/`N`).

---

## 200900.lib -- Reprint Invoice - Screenless (QL3060)

**Wraps:** CallWrapper `200900` — Reprint Invoice (Screenless) / QL3060

```
Program.External.Include.Library("200900.lib",False)
```

This library invokes the `200900` callwrapper to reprint an invoice screenlessly. It shares the core program (QL3060) with [`200700.lib`](#200700lib----sales-order-history-by-invoice-ql3060), but serves a different purpose — reprinting rather than viewing history. It is one of the simplest library patterns: a single-column DataTable with the column value passed **directly** to the callwrapper (no `ConcatCallWrapperArgs`).

### DataTable Schema — `200900`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| InvNum | Invoice number | String | `9(6)` — 6-digit numeric | |

> **Warning:** The source author notes: *"For whatever reason, the file only takes a 6 character invoice number."* If your invoice numbers exceed 6 characters, this library may truncate or reject them. Verify against your environment before relying on this.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s200900Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `200900Sync` | Calls `F.Global.General.CallWrapperSync(200900, ...)` per row |
| `200900Async` | Calls `F.Global.General.CallWrapperAsync(200900, ...)` per row |

### How It Works

1. The library creates a `200900` DataTable with a single `InvNum` column.
2. When `200900Sync` or `200900Async` is called, it loops through each row in the DataTable.
3. For each row, the `InvNum` value is passed **directly** to the callwrapper — no `ConcatCallWrapperArgs` is used.
4. The callwrapper `200900` is invoked (sync or async) with the invoice number.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s200900Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `200900Sync`/`200900Async`).

### Comparison with `200700.lib`

| Aspect | `200700.lib` | `200900.lib` |
|--------|-------------|-------------|
| CallWrapper ID | `200700` | `200900` |
| Core program | QL3060 | QL3060 |
| Purpose | View sales order history by invoice | Reprint invoice (screenless) |
| Column name | `Invoice` | `InvNum` |
| Format | `9(6)` | `9(6)` |
| Uses `ConcatCallWrapperArgs` | No | No |

**Usage Pattern (reprint a single invoice):**

```
Program.External.Include.Library("200900.lib",False)

F.Data.DataTable.AddRow("200900")
F.Data.DataTable.SetValue("200900","InvNum","123456",0)

F.Intrinsic.Control.CallSub(200900Sync)
```

**Usage Pattern (batch reprint multiple invoices):**

```
Program.External.Include.Library("200900.lib",False)

F.Data.DataTable.AddRow("200900")
F.Data.DataTable.SetValue("200900","InvNum","100001",0)

F.Data.DataTable.AddRow("200900")
F.Data.DataTable.SetValue("200900","InvNum","100002",1)

F.Data.DataTable.AddRow("200900")
F.Data.DataTable.SetValue("200900","InvNum","100003",2)

F.Intrinsic.Control.CallSub(200900Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. The `InvNum` value is passed directly to the callwrapper without concatenation.

---


# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: AdvancedPlanningSchedulingComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\AdvancedPlanningSchedulingComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\AdvancedPlanningSchedulingComponent.vb`
- **Feature toggle:** `8206e084-432f-4b79-9630-00a247416474`
- **OCTSRS conversion status:** Partially Converted (ADO.NET methods exist)
- **Implementation size:** ~436 lines

### Runtime purpose
The Advanced Planning and Scheduling (APS) Component provides job scheduling and status tracking functionality for manufacturing operations.

### Implementation notes (OCTSRS)
#### Feature Toggle
- Uses feature toggle `8206e084-432f-4b79-9630-00a247416474`
- ADO.NET methods: `JobStartedAdoNet`, `JobStatusAdoNet`, `PSCAdoNet`
- Legacy methods: `GAJobStarted`, `JobStatus`, `GAPSC`

#### ADO.NET Conversion Status
- `JOBSTARTED` - Has ADO.NET version
- `JOBSTATUS` - Has ADO.NET version
- `PSC` - Has ADO.NET version
- Other methods - Still using ADODB

#### Migration Notes
- Uses ADODB Recordset in legacy methods
- ADO.NET versions use parameterized queries
- Connection type: Company database

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration

#### External Dependencies
- gsrpm.exe - Report printing utility
- APS database files (.mdb)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `JOBSTARTED` | Check if a job has started |
| `JOBSTATUS` | Get job status information |
| `PRINTAPS3REPORT` | Print APS3 report |
| `PSC` | Production Scheduling Control operations |
| `SCHEDULEJOB` | Schedule a job |
| `ADDLOCKEDJOBSEQUENCE` | Add a locked job sequence |
| `REMOVELOCKEDJOBSEQUENCE` | Remove a locked job sequence |

### Key method signatures & edge cases
#### `JOBSTATUS`
**GAB Syntax:** `Function.Global.Aps.JobStatus(JobSequence, Variable.Local.Status, Variable.Local.Details)`

**Purpose:** Returns the status of a job from the APS system.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | JobSequence | String | Yes | Job sequence identifier (JS) |
| R1 | Status | Long | Yes | Return - Status bitmask |
| R2 | Details | String | No | Return - Additional details |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| APSV3_JBMaster | SELECT | Job master data |

**Status Bitmask:**

| Bit | Value | Meaning |
|-----|-------|---------|
| 0 | 1 | Job exists |
| 1 | 2 | Job started |
| 2 | 4 | Job completed |
| 3 | 8 | Job on hold |

#### `JOBSTARTED`
**GAB Syntax:** `Function.Global.Aps.JobStarted(JobSequence, Variable.Local.Started)`

**Purpose:** Checks if a job has started.

**Returns:** Boolean - True if job has started

#### `PSC`
**GAB Syntax:** `Function.Global.Aps.PSC(Operation, Parameters...)`

**Purpose:** Production Scheduling Control operations.

#### `PRINTAPS3REPORT`
**GAB Syntax:** `Subroutine.Global.Aps.PrintAPS3Report(ReportNumber)`

**Purpose:** Prints an APS3 report using gsrpm.exe.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ReportNumber | Integer | Yes | Report number to print |

**Business Rules:**
- Uses gsrpm.exe from PluginsDir
- Requires aps{CompanyCode}.mdb file

---
