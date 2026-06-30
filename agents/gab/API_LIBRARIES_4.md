# GAB Standard Libraries Reference (Part 4 of 5)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with standard .lib includes (Part 4: lines 7157-9246)
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

## 251000.lib -- Quote Header Screen (QTE200)

**Wraps:** CallWrapper `251000` — Quote Header Screen / QTE200

```
Program.External.Include.Library("251000.lib",False)
```

This library invokes the `251000` callwrapper to open, view, copy, delete, or create quote headers via the QTE200 program. It follows the standard entity-screen pattern with a two-column DataTable (`QuoteNo` + `Mode`), similar to [`175200.lib`](#175200lib----open-purchase-order-pur064gh) and [`200000.lib`](#200000lib----sales-orders-ord200). Parameters are concatenated via `ConcatCallWrapperArgs` and the callwrapper is invoked **per row**.

### DataTable Schema — `251000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| QuoteNo | Quote number | String | `9(7)` — 7-digit numeric | |
| Mode | Action mode | String | See `Mode` enum below | |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"O"` | Open |
| `"V"` | View |
| `"C"` | Copy |
| `"D"` | Delete |
| `"N"` | New |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s251000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `251000Sync` | Calls `F.Global.General.CallWrapperSync(251000, ...)` per row |
| `251000Async` | Calls `F.Global.General.CallWrapperAsync(251000, ...)` per row |

### How It Works

1. The library creates a `251000` DataTable with two columns (`QuoteNo`, `Mode`).
2. When `251000Sync` or `251000Async` is called, it loops through each row in the DataTable.
3. For each row, `QuoteNo` and `Mode` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `251000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s251000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `251000Sync`/`251000Async`).

**Usage Pattern (open an existing quote):**

```
Program.External.Include.Library("251000.lib",False)

F.Data.DataTable.AddRow("251000")
F.Data.DataTable.SetValue("251000","QuoteNo","0001234",0)
F.Data.DataTable.SetValue("251000","Mode","O",0)

F.Intrinsic.Control.CallSub(251000Sync)
```

**Usage Pattern (create a new quote):**

```
Program.External.Include.Library("251000.lib",False)

F.Data.DataTable.AddRow("251000")
F.Data.DataTable.SetValue("251000","QuoteNo","",0)
F.Data.DataTable.SetValue("251000","Mode","N",0)

F.Intrinsic.Control.CallSub(251000Async)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. The `QuoteNo` parameter is passed first, followed by `Mode`.

---

## 300000.lib -- Inventory Maintenance/View (INVMAIN)

**Wraps:** CallWrapper `300000` — Inventory Maintenance/View / INVMAIN

```
Program.External.Include.Library("300000.lib",False)
```

This library invokes the `300000` callwrapper to open the Inventory Maintenance/View screen (INVMAIN). It follows the standard entity-screen pattern with a three-column DataTable (`Mode`, `Part`, `Loc`) and uses `ConcatCallWrapperArgs`. The `Mode` parameter is unusually rich, supporting 10 distinct mode values including specialized view modes that selectively unlock specific fields for editing. The callwrapper is invoked **per row**.

### DataTable Schema — `300000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Mode | Action mode | String | See `Mode` enum below | |
| Part | Part number | String | `X(20)` | |
| Loc | Location | String | `X(2)` | |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"N"` | New |
| `"C"` | Copy |
| `"D"` | Delete |
| `"V"` | View |
| `"O"` | Open |
| `"L"` | View Part with Lead Time Not Protected |
| `"E"` | View Part with PL, Desc, UM, and Pur UM Not Protected |
| `"P"` | View Part with Source, Order Qty, Sort, and Re-Order Not Protected |
| `"X"` | Allow the Extra Description to be Updated in QTE020LD |
| `"U"` | Prevent Cost from Updating on Std. Cost Button Click and Override Disabling Reorder |

> **Warning — Duplicate `"D"` in source:** The source comments list `"D"` twice — once as *"Delete"* and once as *"View Part Options."* This is a conflict in the library's own documentation. The code itself simply passes whatever `Mode` value is in the DataTable to the callwrapper; interpretation is handled by INVMAIN. If `"D"` means "Delete" at the callwrapper level, the "View Part Options" mapping may be a documentation error. Verify the intended behavior in your environment before relying on `"D"` for anything other than Delete.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s300000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `300000Sync` | Calls `F.Global.General.CallWrapperSync(300000, ...)` per row |
| `300000Async` | Calls `F.Global.General.CallWrapperAsync(300000, ...)` per row |

### How It Works

1. The library creates a `300000` DataTable with three columns (`Mode`, `Part`, `Loc`).
2. When `300000Sync` or `300000Async` is called, it loops through each row in the DataTable.
3. For each row, `Mode`, `Part`, and `Loc` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `300000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s300000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `300000Sync`/`300000Async`).

**Usage Pattern (open a part for editing):**

```
Program.External.Include.Library("300000.lib",False)

F.Data.DataTable.AddRow("300000")
F.Data.DataTable.SetValue("300000","Mode","O",0)
F.Data.DataTable.SetValue("300000","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300000","Loc","01",0)

F.Intrinsic.Control.CallSub(300000Sync)
```

**Usage Pattern (view a part with lead time unprotected):**

```
Program.External.Include.Library("300000.lib",False)

F.Data.DataTable.AddRow("300000")
F.Data.DataTable.SetValue("300000","Mode","L",0)
F.Data.DataTable.SetValue("300000","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300000","Loc","01",0)

F.Intrinsic.Control.CallSub(300000Async)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `Mode`, `Part`, `Loc`. The specialized view modes (`"L"`, `"E"`, `"P"`) open the part in view mode but selectively unlock specific field groups for editing.

---

## 300010.lib -- Inventory by Part and Location

**Wraps:** CallWrapper `300010`

```
Program.External.Include.Library("300010.lib",False)
```

This library invokes the `300010` callwrapper for a part at a specific location. The source contains placeholder text for both the description (`*DESCRIPTION*`) and the core program (`*PROGRAM*`), so the exact screen or function is unknown. Given its ID proximity to [`300000.lib`](#300000lib----inventory-maintenanceview-invmain) (Inventory Maintenance/View) and its two parameters (`Part` + `Loc` with no `Mode`), it likely opens or queries an inventory-related view for a specific part-location combination. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

> **Note:** The source description and program name are placeholders. The inferred description "Inventory by Part and Location" is based on the parameters and the adjacent callwrapper ID range.

### DataTable Schema — `300010`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Part | Part number | String | `X(20)` | |
| Loc | Location | String | `X(2)` | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s300010Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `300010Sync` | Calls `F.Global.General.CallWrapperSync(300010, ...)` per row |
| `300010Async` | Calls `F.Global.General.CallWrapperAsync(300010, ...)` per row |

### How It Works

1. The library creates a `300010` DataTable with two columns (`Part`, `Loc`).
2. When `300010Sync` or `300010Async` is called, it loops through each row in the DataTable.
3. For each row, `Part` and `Loc` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `300010` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s300010Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `300010Sync`/`300010Async`).

**Usage Pattern:**

```
Program.External.Include.Library("300010.lib",False)

F.Data.DataTable.AddRow("300010")
F.Data.DataTable.SetValue("300010","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300010","Loc","01",0)

F.Intrinsic.Control.CallSub(300010Sync)
```

**Usage Pattern (batch — multiple parts):**

```
Program.External.Include.Library("300010.lib",False)

F.Data.DataTable.AddRow("300010")
F.Data.DataTable.SetValue("300010","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300010","Loc","01",0)

F.Data.DataTable.AddRow("300010")
F.Data.DataTable.SetValue("300010","Part","WIDGET-002",1)
F.Data.DataTable.SetValue("300010","Loc","02",1)

F.Intrinsic.Control.CallSub(300010Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, no mode selection, and no global option/mode variables. Parameters are passed in order: `Part`, `Loc`.

---

## 300011.lib -- Supply and Demand w/ Switch (INV500GI)

**Wraps:** CallWrapper `300011` — Supply and Demand w/ Switch / INV500GI

```
Program.External.Include.Library("300011.lib",False)
```

This library invokes the `300011` callwrapper to open the Supply and Demand screen (INV500GI) with a configurable display switch. It shares the core program INV500GI with [`7200.lib`](#7200lib----supply-and-demand-inv500gi) (callwrapper `7200`), but adds a `Switch` parameter that controls the presentation mode — edit, forecast, router update, dollar suppression, and more. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `300011`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Part | Part number | String | | |
| Location | Location | String | | |
| Switch | Display switch | String | See `Switch` enum below | |

### Switch Enum

| Value | Meaning |
|-------|---------|
| `"M"` | Edit Mode |
| `"F"` | With Forecast |
| `"U"` | With Router Update |
| `"Z"` | No Dollars WO |
| `"W"` | No Dollars |
| `"L"` | No Dollars, Sales Order |
| `"G"` | Suppress Price and Cost |
| `"A"` | Issue Material, Open WO |
| `""` (blank) | General Supply and Demand |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s300011Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `300011Sync` | Calls `F.Global.General.CallWrapperSync(300011, ...)` per row |
| `300011Async` | Calls `F.Global.General.CallWrapperAsync(300011, ...)` per row |

### How It Works

1. The library creates a `300011` DataTable with three columns (`Part`, `Location`, `Switch`).
2. When `300011Sync` or `300011Async` is called, it loops through each row in the DataTable.
3. For each row, `Part`, `Location`, and `Switch` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `300011` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s300011Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `300011Sync`/`300011Async`).

### Comparison with `7200.lib`

| Aspect | `7200.lib` | `300011.lib` |
|--------|-----------|-------------|
| CallWrapper ID | `7200` | `300011` |
| Core program | INV500GI | INV500GI |
| Columns | 3 (`Part`, `Loc`, `Mode`) | 3 (`Part`, `Location`, `Switch`) |
| Switch/Mode values | `"MR"` only | 9 values (M/F/U/Z/W/L/G/A/blank) |
| Uses `ConcatCallWrapperArgs` | Yes | Yes |

**Usage Pattern (general supply and demand — blank switch):**

```
Program.External.Include.Library("300011.lib",False)

F.Data.DataTable.AddRow("300011")
F.Data.DataTable.SetValue("300011","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300011","Location","01",0)
F.Data.DataTable.SetValue("300011","Switch","",0)

F.Intrinsic.Control.CallSub(300011Sync)
```

**Usage Pattern (edit mode with suppress price and cost):**

```
Program.External.Include.Library("300011.lib",False)

F.Data.DataTable.AddRow("300011")
F.Data.DataTable.SetValue("300011","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300011","Location","01",0)
F.Data.DataTable.SetValue("300011","Switch","G",0)

F.Intrinsic.Control.CallSub(300011Async)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `Part`, `Location`, `Switch`. The column is named `Location` (not `Loc` as in other inventory libraries like `300000.lib` and `300010.lib`).

---

## 300060.lib -- Update Item Master For Issued Parts (LOT155GI)

**Wraps:** CallWrapper `300060` — Update Item Master For Issued Parts / LOT155GI

```
Program.External.Include.Library("300060.lib",False)
```

This library invokes the `300060` callwrapper to update the item master for issued parts via LOT155GI. It uses **two linked DataTables** — a header table (`300060`) and a file-lines table (`300060File`) linked by `Part` + `Loc`. For each header row, the library filters the file-lines table, generates a **tab-delimited file** of lot/bin/heat/serial/quantity data, writes it to disk, and then calls the callwrapper with the header parameters. This is structurally similar to [`175100.lib`](#175100lib----generate-purchase-order-from-file-pura64gi), which also uses linked DataTables and tab-delimited file generation.

### DataTable Schema — `300060` (Header)

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Part | Part number | String | `X(20)` | |
| Loc | Location | String | `X(2)` | |
| QtyIssued | Quantity issued | String | Numeric | |
| Seq | Sequence | String | `9(6)` | |
| Order | Order number | String | `9(7)` | |
| FileName | File path for the lot/serial data file | String | | `{CompanyCode}{Terminal}300060.txt` in `V.Caller.FilesDir` |
| Line | Line number | String | `9(4)` | |

### DataTable Schema — `300060File` (Lines)

| Column | Description | Type | Format | Link |
|--------|-------------|------|--------|------|
| Part | Part number (must match header) | String | `X(20)` | Links to `300060.Part` |
| Loc | Location (must match header) | String | `X(2)` | Links to `300060.Loc` |
| Lot | Lot number | String | `X(15)` | |
| Bin | Bin location | String | `X(6)` | |
| Heat | Heat number | String | `X(15)` | |
| Serial | Serial number | String | `X(30)` | |
| Qty | Quantity | String | Numeric | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s300060Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |
| `V.Global.s300060FileName` | Dynamic filename | `{CompanyCode}{Terminal}300060.txt` |
| `V.Global.s300060FilePath` | Full file path | `{V.Caller.FilesDir}\{s300060FileName}` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `300060Sync` | Calls `F.Global.General.CallWrapperSync(300060, ...)` per header row |
| `300060Async` | Calls `F.Global.General.CallWrapperAsync(300060, ...)` per header row |

### How It Works

1. The library creates two DataTables: `300060` (header, 7 columns) and `300060File` (lines, 7 columns).
2. The `FileName` column in `300060` defaults to a dynamic path: `{V.Caller.FilesDir}\{CompanyCode}{Terminal}300060.txt`.
3. When `300060Sync` or `300060Async` is called, it loops through each row in the `300060` header DataTable.
4. For each header row:
   a. A DataView filter is created on `300060File` matching `Part` and `Loc` from the header row.
   b. If matching file-lines exist, they are written to disk as a **tab-delimited file** using `DataView.ToString` with columns `Lot`, `Bin`, `Heat`, `Serial`, `Qty` (tab-separated columns, newline-separated rows).
   c. All 7 header columns (`Part`, `Loc`, `QtyIssued`, `Seq`, `Order`, `FileName`, `Line`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs`.
   d. The callwrapper `300060` is invoked (sync or async) with the concatenated parameters.
5. After all header rows are processed, the `300060` DataTable rows are deleted.
6. On error, `V.Global.s300060Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row`.

### Tab-Delimited File Format

The generated file contains one row per `300060File` line matching the header's `Part`+`Loc`:

```
{Lot}\t{Bin}\t{Heat}\t{Serial}\t{Qty}
{Lot}\t{Bin}\t{Heat}\t{Serial}\t{Qty}
...
```

Where `\t` represents a tab character and each line is separated by a newline.

**Usage Pattern (single part with lot/serial data):**

```
Program.External.Include.Library("300060.lib",False)

'Header row
F.Data.DataTable.AddRow("300060")
F.Data.DataTable.SetValue("300060","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300060","Loc","01",0)
F.Data.DataTable.SetValue("300060","QtyIssued","10",0)
F.Data.DataTable.SetValue("300060","Seq","000001",0)
F.Data.DataTable.SetValue("300060","Order","1234567",0)
F.Data.DataTable.SetValue("300060","Line","0001",0)

'File lines (lot/serial detail for the same Part+Loc)
F.Data.DataTable.AddRow("300060File")
F.Data.DataTable.SetValue("300060File","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("300060File","Loc","01",0)
F.Data.DataTable.SetValue("300060File","Lot","LOT-A",0)
F.Data.DataTable.SetValue("300060File","Bin","BIN01",0)
F.Data.DataTable.SetValue("300060File","Heat","",0)
F.Data.DataTable.SetValue("300060File","Serial","SN-001",0)
F.Data.DataTable.SetValue("300060File","Qty","5",0)

F.Data.DataTable.AddRow("300060File")
F.Data.DataTable.SetValue("300060File","Part","WIDGET-001",1)
F.Data.DataTable.SetValue("300060File","Loc","01",1)
F.Data.DataTable.SetValue("300060File","Lot","LOT-B",1)
F.Data.DataTable.SetValue("300060File","Bin","BIN02",1)
F.Data.DataTable.SetValue("300060File","Heat","",1)
F.Data.DataTable.SetValue("300060File","Serial","SN-002",1)
F.Data.DataTable.SetValue("300060File","Qty","5",1)

F.Intrinsic.Control.CallSub(300060Sync)
```

> **Note:** The `300060File` DataTable rows are **not** automatically deleted by the library — only the `300060` header rows are cleared after processing. The file is written to the path in the `FileName` column (which defaults to `{CompanyCode}{Terminal}300060.txt` in `V.Caller.FilesDir`). The callwrapper is invoked **per header row**. The file is overwritten for each header row, so all file-lines for a given `Part`+`Loc` combination should be present before calling the subroutine.

---

## 300070.lib -- Update Inventory Usage (INV756)

**Wraps:** CallWrapper `300070` — Update Inventory Usage / INV756

```
Program.External.Include.Library("300070.lib",False)
```

This library invokes the `300070` callwrapper to update inventory usage statistics for a given date range via the INV756 program. It takes a beginning and ending month/year pair, all as 2-digit numeric strings. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `300070`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| BegMonth | Beginning month | String | `9(2)` — 01-12 | |
| BegYear | Beginning year | String | `9(2)` — last two digits | |
| EndMonth | Ending month | String | `9(2)` — 01-12 | |
| EndYear | Ending year | String | `9(2)` — last two digits | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s300070Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `300070Sync` | Calls `F.Global.General.CallWrapperSync(300070, ...)` per row |
| `300070Async` | Calls `F.Global.General.CallWrapperAsync(300070, ...)` per row |

### How It Works

1. The library creates a `300070` DataTable with four columns (`BegMonth`, `BegYear`, `EndMonth`, `EndYear`).
2. When `300070Sync` or `300070Async` is called, it loops through each row in the DataTable.
3. For each row, all four columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `300070` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s300070Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `300070Sync`/`300070Async`).

**Usage Pattern (update usage for a single date range):**

```
Program.External.Include.Library("300070.lib",False)

F.Data.DataTable.AddRow("300070")
F.Data.DataTable.SetValue("300070","BegMonth","01",0)
F.Data.DataTable.SetValue("300070","BegYear","26",0)
F.Data.DataTable.SetValue("300070","EndMonth","03",0)
F.Data.DataTable.SetValue("300070","EndYear","26",0)

F.Intrinsic.Control.CallSub(300070Sync)
```

**Usage Pattern (update usage for multiple date ranges):**

```
Program.External.Include.Library("300070.lib",False)

F.Data.DataTable.AddRow("300070")
F.Data.DataTable.SetValue("300070","BegMonth","01",0)
F.Data.DataTable.SetValue("300070","BegYear","25",0)
F.Data.DataTable.SetValue("300070","EndMonth","06",0)
F.Data.DataTable.SetValue("300070","EndYear","25",0)

F.Data.DataTable.AddRow("300070")
F.Data.DataTable.SetValue("300070","BegMonth","07",1)
F.Data.DataTable.SetValue("300070","BegYear","25",1)
F.Data.DataTable.SetValue("300070","EndMonth","12",1)
F.Data.DataTable.SetValue("300070","EndYear","25",1)

F.Intrinsic.Control.CallSub(300070Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. All date components use 2-digit format (month `01`-`12`, year as last two digits). Parameters are passed in order: `BegMonth`, `BegYear`, `EndMonth`, `EndYear`.

---

## 400000.lib -- Estimating/Standard Routers (RE0010GI)

**Wraps:** CallWrapper `400000` — Estimating/Standard Routers / RE0010GI

```
Program.External.Include.Library("400000.lib",False)
```

This library invokes the `400000` callwrapper to open, view, create, delete, copy, or load estimating/standard routers via the RE0010GI program. It follows the standard entity-screen pattern with a two-column DataTable (`Mode` + `Router`), similar to [`251000.lib`](#251000lib----quote-header-screen-qte200). The `Mode` enum includes 6 values, notably `"L"` (Load) which is unique to this library. Parameters are concatenated via `ConcatCallWrapperArgs` and the callwrapper is invoked **per row**.

### DataTable Schema — `400000`

| Column | Description | Type | Default |
|--------|-------------|------|---------|
| Mode | Action mode | String | |
| Router | Router ID | String | |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"O"` | Open |
| `"V"` | View |
| `"N"` | New |
| `"D"` | Delete |
| `"C"` | Copy |
| `"L"` | Load |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s400000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `400000Sync` | Calls `F.Global.General.CallWrapperSync(400000, ...)` per row |
| `400000Async` | Calls `F.Global.General.CallWrapperAsync(400000, ...)` per row |

### How It Works

1. The library creates a `400000` DataTable with two columns (`Mode`, `Router`).
2. When `400000Sync` or `400000Async` is called, it loops through each row in the DataTable.
3. For each row, `Mode` and `Router` are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `400000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s400000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `400000Sync`/`400000Async`).

**Usage Pattern (open an existing router):**

```
Program.External.Include.Library("400000.lib",False)

F.Data.DataTable.AddRow("400000")
F.Data.DataTable.SetValue("400000","Mode","O",0)
F.Data.DataTable.SetValue("400000","Router","STD-ROUTE-001",0)

F.Intrinsic.Control.CallSub(400000Sync)
```

**Usage Pattern (load a router):**

```
Program.External.Include.Library("400000.lib",False)

F.Data.DataTable.AddRow("400000")
F.Data.DataTable.SetValue("400000","Mode","L",0)
F.Data.DataTable.SetValue("400000","Router","STD-ROUTE-001",0)

F.Intrinsic.Control.CallSub(400000Async)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `Mode`, `Router`.

---

## 410000.lib -- Exploded BOM/Router File Generator (BOM0048)

**Wraps:** CallWrapper `410000` — Exploded BOM/Router File Generator / BOM0048

```
Program.External.Include.Library("410000.lib",False)
```

This library invokes the `410000` callwrapper to generate an exploded BOM (Bill of Materials) or Router file. It has a **unique invocation pattern** unlike any other standard library: the library builds a **tab-delimited input file** from the DataTable columns, writes it to disk, and then passes the **file path** directly to the callwrapper (no `ConcatCallWrapperArgs`). The callwrapper processes the input file and appends the path to the generated exploded BOM/Router output file as a fourth field. After invocation, you can read the file back to retrieve the output file path.

### DataTable Schema — `410000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| FilePath | Directory for the input/output file | String | Path (e.g., `V.Caller.PluginsDir`) | |
| FileName | Name of the input/output file | String | Any valid filename | |
| BOMType | BOM or Router | String | See `BOMType` enum below | |
| Part | Part number | String | `X(20)` | |
| Quantity | Quantity | String | `12.4` (XXXXXXXXXXXX.XXXX) | |

### BOMType Enum

| Value | Meaning |
|-------|---------|
| `"0"` | BOM (Bill of Materials) |
| `"1"` | Router |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s410000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `410000Sync` | Calls `F.Global.General.CallWrapperSync(410000, ...)` per row |
| `410000Async` | Calls `F.Global.General.CallWrapperAsync(410000, ...)` per row |

### How It Works

1. The library creates a `410000` DataTable with five columns (`FilePath`, `FileName`, `BOMType`, `Part`, `Quantity`).
2. When `410000Sync` or `410000Async` is called, it loops through each row in the DataTable.
3. For each row:
   a. The full file path is built: `{FilePath}\{FileName}`.
   b. A tab-delimited string is constructed: `{BOMType}\t{Part}\t{Quantity}`.
   c. If the file already exists, it is deleted.
   d. The tab-delimited string is written to disk at the full path.
   e. The callwrapper `410000` is invoked with the **file path** as the sole parameter (no `ConcatCallWrapperArgs`).
4. After all rows are processed, the DataTable rows are deleted.
5. On error, `V.Global.s410000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row`.

### Input File Format (Written by Library)

```
{BOMType}\t{Part}\t{Quantity}
```

Where `\t` represents a tab character. For example: `0\tWIDGET-001\t100.0000`

### Output File Format (After CallWrapper Execution)

After the callwrapper processes the file, it appends the path to the generated exploded BOM/Router file as a fourth tab-delimited field:

```
{BOMType}\t{Part}\t{Quantity}\t{ExplodedBOMFilePath}
```

To retrieve the exploded BOM/Router file path after invocation, read the file back and extract the fourth field.

**Usage Pattern (generate an exploded BOM):**

```
Program.External.Include.Library("410000.lib",False)

F.Data.DataTable.AddRow("410000")
F.Data.DataTable.SetValue("410000","FilePath",V.Caller.PluginsDir,0)
F.Data.DataTable.SetValue("410000","FileName","bom_explode.txt",0)
F.Data.DataTable.SetValue("410000","BOMType","0",0)
F.Data.DataTable.SetValue("410000","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("410000","Quantity","100.0000",0)

F.Intrinsic.Control.CallSub(410000Sync)

'Read the file back to get the exploded BOM file path
V.Local.sFileContents.Declare(String)
V.Local.sExplodedPath.Declare(String)
F.Intrinsic.String.Build("{0}\{1}",V.Caller.PluginsDir,"bom_explode.txt",V.Local.sFullPath)
F.Intrinsic.File.File2String(V.Local.sFullPath,V.Local.sFileContents)
F.Intrinsic.String.Split(V.Local.sFileContents,V.Ambient.Tab,V.Local.sParts)
'V.Local.sParts(3) now contains the exploded BOM/Router file path
```

**Usage Pattern (generate an exploded Router):**

```
Program.External.Include.Library("410000.lib",False)

F.Data.DataTable.AddRow("410000")
F.Data.DataTable.SetValue("410000","FilePath",V.Caller.PluginsDir,0)
F.Data.DataTable.SetValue("410000","FileName","router_explode.txt",0)
F.Data.DataTable.SetValue("410000","BOMType","1",0)
F.Data.DataTable.SetValue("410000","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("410000","Quantity","50.0000",0)

F.Intrinsic.Control.CallSub(410000Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. This library uses a unique file-based invocation pattern: it writes a tab-delimited input file and passes the file path (not field values) to the callwrapper. The callwrapper then appends the exploded BOM/Router output file path as a fourth field in the same file. No `ConcatCallWrapperArgs` is used. The file is deleted and recreated for each row.

---

## 450000.lib -- Work Order Query (WOQUERY)

**Wraps:** CallWrapper `450000` — Work Order Query / WOQUERY

```
Program.External.Include.Library("450000.lib",False)
```

This library invokes the `450000` callwrapper to query work orders via the WOQUERY program. It supports 9 query modes — from interactive selection (by customer, PO, user code, description, or part) to direct display of a specific work order with configurable cost/labor visibility. The `Mode` parameter uses numeric strings (`"1"` through `"9"`) rather than letter codes. An active/history switch controls which work order pool is queried. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `450000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Mode | Query mode | String | See `Mode` enum below | |
| WONum | Work order number | String | `9(6)` | |
| WOSuffix | Work order suffix | String | `9(3)` | |
| ActOrHist | Active or history switch | String | See `ActOrHist` enum below | |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"1"` | Select work order |
| `"2"` | Choose work order by customer |
| `"3"` | Choose work order by PO |
| `"4"` | Choose work order by user code |
| `"5"` | Choose work order by work order description |
| `"6"` | Choose work order by part |
| `"7"` | Show specific work order |
| `"8"` | Show specific work order without cost |
| `"9"` | Show specific work order without labor dollars |

### ActOrHist Enum

| Value | Meaning |
|-------|---------|
| `"A"` | Active work orders |
| `"H"` | History work orders |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s450000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `450000Sync` | Calls `F.Global.General.CallWrapperSync(450000, ...)` per row |
| `450000Async` | Calls `F.Global.General.CallWrapperAsync(450000, ...)` per row |

### How It Works

1. The library creates a `450000` DataTable with four columns (`Mode`, `WONum`, `WOSuffix`, `ActOrHist`).
2. When `450000Sync` or `450000Async` is called, it loops through each row in the DataTable.
3. For each row, all four columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `450000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s450000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `450000Sync`/`450000Async`).

**Usage Pattern (show a specific active work order):**

```
Program.External.Include.Library("450000.lib",False)

F.Data.DataTable.AddRow("450000")
F.Data.DataTable.SetValue("450000","Mode","7",0)
F.Data.DataTable.SetValue("450000","WONum","123456",0)
F.Data.DataTable.SetValue("450000","WOSuffix","000",0)
F.Data.DataTable.SetValue("450000","ActOrHist","A",0)

F.Intrinsic.Control.CallSub(450000Sync)
```

**Usage Pattern (select work order by part from history):**

```
Program.External.Include.Library("450000.lib",False)

F.Data.DataTable.AddRow("450000")
F.Data.DataTable.SetValue("450000","Mode","6",0)
F.Data.DataTable.SetValue("450000","WONum","",0)
F.Data.DataTable.SetValue("450000","WOSuffix","",0)
F.Data.DataTable.SetValue("450000","ActOrHist","H",0)

F.Intrinsic.Control.CallSub(450000Async)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `Mode`, `WONum`, `WOSuffix`, `ActOrHist`. Modes 1-6 are interactive selection modes (WONum/WOSuffix may be empty); modes 7-9 display a specific work order (WONum required).

---

## 450100.lib -- Issue Material to Job From File (WIR100)

**Wraps:** CallWrapper `450100` — Issue Material to Job From File / WIR100

```
Program.External.Include.Library("450100.lib",False)
```

This library invokes the `450100` callwrapper to issue material to a job from a CSV file via the WIR100 program. It has several **unique architectural differences** from other standard libraries:

1. **Single callwrapper invocation** — All DataTable rows are written to one CSV file and the callwrapper is called **once** (not per-row).
2. **CSV file generation** — Uses `DataView.ToString` with a configurable delimiter controlled by `V.Global.bCommasInPart`.
3. **Filename-only parameter** — The callwrapper receives just the filename (not the full path and not via `ConcatCallWrapperArgs`).
4. **3-part error format** — `Sub*!*ErrNo*!*ErrDesc` (no Row component, unlike most other libraries).
5. **Quantity quirk** — Whole numbers are interpreted differently from decimals by the callwrapper (see warning below).

### DataTable Schema — `450100`

| Column | Description | Type | Max Size | Default |
|--------|-------------|------|----------|---------|
| Part | Part number | String | `X(20)` (17-20 chars) | |
| Rev | Revision | String | `X(3)` | |
| Location | Location | String | | |
| Quantity | Quantity | String | See Quantity warning | |
| Lot | Lot number | String | | |
| Bin | Bin location | String | | |
| Heat | Heat number | String | | |
| Serial | Serial number | String | | |
| WONumber | Work order number | String | `9(6)` | |
| WOSuffix | Work order suffix | String | `9(3)` | |
| WOSeq | Work order sequence | String | `9(6)` | |

> **Warning — Quantity Handling:** The callwrapper interprets whole numbers and floats differently. A whole number (e.g., `"5"`) must be **multiplied by 10000** to get the correct issued quantity (i.e., pass `"50000"` to issue 5). A float value, even with just `.0` (e.g., `"5.0"`), is read as-is. **Always use decimal notation** (e.g., `"5.0"`, `"10.5"`) to avoid unexpected quantity scaling.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s450100Error` | `Sub*!*ErrNo*!*ErrDesc` (3-part; no Row component) | `""` |
| `V.Global.bCommasInPart` | Boolean — controls CSV delimiter | `False` |

When `bCommasInPart` is `False` (default), fields are separated by `,`. When `True`, fields are wrapped in double quotes and separated by `","` to protect commas within field values (e.g., part numbers containing commas).

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `450100Sync` | Calls `F.Global.General.CallWrapperSync(450100, ...)` once for all rows |
| `450100Async` | Calls `F.Global.General.CallWrapperAsync(450100, ...)` once for all rows |

### How It Works

1. The library creates a `450100` DataTable with 11 columns.
2. When `450100Sync` or `450100Async` is called:
   a. A filename is built dynamically: `L{CompanyCode}{Terminal}MOPEN.txt`.
   b. The full path is built: `{V.Caller.FilesDir}\{filename}`.
   c. If `bCommasInPart` is `True`, the delimiter is set to `","` (quoted comma); otherwise plain `,`.
   d. A DataView is created over all rows and serialized to a CSV string via `DataView.ToString`.
   e. The CSV string is written to disk at the full path.
   f. The callwrapper `450100` is invoked **once** with the **filename only** (not the full path).
3. After the callwrapper call, the DataTable rows are deleted.
4. On error, `V.Global.s450100Error` is set with the 3-part format `Sub*!*ErrNo*!*ErrDesc`.

### CSV File Format

Each row in the DataTable becomes one line in the CSV file:

**Default delimiter (`,`):**
```
WIDGET-001,001,01,5.0,LOT-A,BIN01,,SN-001,123456,000,000001
WIDGET-002,,02,10.0,,,,,123456,000,000002
```

**Quoted delimiter (`","`) when `bCommasInPart = True`:**
```
"WIDGET,PART-001","001","01","5.0","LOT-A","BIN01","","SN-001","123456","000","000001"
```

The file is written to `{V.Caller.FilesDir}\L{CompanyCode}{Terminal}MOPEN.txt`.

**Usage Pattern (issue material — standard delimiter):**

```
Program.External.Include.Library("450100.lib",False)

F.Data.DataTable.AddRow("450100")
F.Data.DataTable.SetValue("450100","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("450100","Rev","001",0)
F.Data.DataTable.SetValue("450100","Location","01",0)
F.Data.DataTable.SetValue("450100","Quantity","5.0",0)
F.Data.DataTable.SetValue("450100","Lot","LOT-A",0)
F.Data.DataTable.SetValue("450100","Bin","BIN01",0)
F.Data.DataTable.SetValue("450100","Heat","",0)
F.Data.DataTable.SetValue("450100","Serial","SN-001",0)
F.Data.DataTable.SetValue("450100","WONumber","123456",0)
F.Data.DataTable.SetValue("450100","WOSuffix","000",0)
F.Data.DataTable.SetValue("450100","WOSeq","000001",0)

F.Data.DataTable.AddRow("450100")
F.Data.DataTable.SetValue("450100","Part","WIDGET-002",1)
F.Data.DataTable.SetValue("450100","Rev","",1)
F.Data.DataTable.SetValue("450100","Location","02",1)
F.Data.DataTable.SetValue("450100","Quantity","10.0",1)
F.Data.DataTable.SetValue("450100","Lot","",1)
F.Data.DataTable.SetValue("450100","Bin","",1)
F.Data.DataTable.SetValue("450100","Heat","",1)
F.Data.DataTable.SetValue("450100","Serial","",1)
F.Data.DataTable.SetValue("450100","WONumber","123456",1)
F.Data.DataTable.SetValue("450100","WOSuffix","000",1)
F.Data.DataTable.SetValue("450100","WOSeq","000002",1)

F.Intrinsic.Control.CallSub(450100Sync)
```

**Usage Pattern (commas in part numbers):**

```
Program.External.Include.Library("450100.lib",False)

V.Global.bCommasInPart.Set(True)

F.Data.DataTable.AddRow("450100")
F.Data.DataTable.SetValue("450100","Part","WIDGET,SPECIAL-001",0)
F.Data.DataTable.SetValue("450100","Rev","",0)
F.Data.DataTable.SetValue("450100","Location","01",0)
F.Data.DataTable.SetValue("450100","Quantity","3.0",0)
F.Data.DataTable.SetValue("450100","Lot","",0)
F.Data.DataTable.SetValue("450100","Bin","",0)
F.Data.DataTable.SetValue("450100","Heat","",0)
F.Data.DataTable.SetValue("450100","Serial","",0)
F.Data.DataTable.SetValue("450100","WONumber","654321",0)
F.Data.DataTable.SetValue("450100","WOSuffix","000",0)
F.Data.DataTable.SetValue("450100","WOSeq","000001",0)

F.Intrinsic.Control.CallSub(450100Sync)
```

> **Note:** Unlike most standard libraries, the callwrapper is invoked **once** for all rows (not per-row). All DataTable rows are serialized into a single CSV file and processed in batch. The filename — not the full path — is passed to the callwrapper. The error format is 3-part (`Sub*!*ErrNo*!*ErrDesc`) with no Row component. Always use decimal notation for Quantity to avoid the integer-scaling quirk.

---

## 450101.lib -- Issue Material to Job From File - Tab Delimited (WIR100/T)

**Wraps:** CallWrapper `450101` — Issue Material to Job From File (Tab) / WIR100/T

```
Program.External.Include.Library("450101.lib",False)
```

This library is the **tab-delimited variant** of [`450100.lib`](#450100lib----issue-material-to-job-from-file-wir100). It invokes the `450101` callwrapper to issue material to a job via the WIR100/T program. The DataTable schema, single-invocation architecture, filename pattern, quantity quirk, and 3-part error format are identical to `450100.lib`. The only difference is the file format: **tab-delimited** instead of CSV.

### Differences from `450100.lib`

| Aspect | `450100.lib` | `450101.lib` |
|--------|-------------|-------------|
| CallWrapper ID | `450100` | `450101` |
| Core program | WIR100 | WIR100/T |
| File format | CSV (comma or quoted-comma) | Tab-delimited |
| Delimiter | `,` or `","` (configurable) | `V.Ambient.Tab` (always) |
| `bCommasInPart` global | Yes (`V.Global.bCommasInPart`) | No — not needed |
| `String2File` overwrite flag | Yes (passes `1`) | No (default behavior) |

### DataTable Schema — `450101`

Identical to `450100.lib` — 11 columns:

| Column | Description | Type | Max Size |
|--------|-------------|------|----------|
| Part | Part number | String | `X(20)` (17-20 chars) |
| Rev | Revision | String | `X(3)` |
| Location | Location | String | |
| Quantity | Quantity | String | See Quantity warning in [`450100.lib`](#450100lib----issue-material-to-job-from-file-wir100) |
| Lot | Lot number | String | |
| Bin | Bin location | String | |
| Heat | Heat number | String | |
| Serial | Serial number | String | |
| WONumber | Work order number | String | `9(6)` |
| WOSuffix | Work order suffix | String | `9(3)` |
| WOSeq | Work order sequence | String | `9(6)` |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s450101Error` | `Sub*!*ErrNo*!*ErrDesc` (3-part; no Row component) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `450101Sync` | Calls `F.Global.General.CallWrapperSync(450101, ...)` once for all rows |
| `450101Async` | Calls `F.Global.General.CallWrapperAsync(450101, ...)` once for all rows |

### How It Works

1. The library creates a `450101` DataTable with 11 columns (identical to `450100.lib`).
2. When `450101Sync` or `450101Async` is called:
   a. A filename is built dynamically: `L{CompanyCode}{Terminal}MOPEN.txt`.
   b. The full path is built: `{V.Caller.FilesDir}\{filename}`.
   c. A DataView is created over all rows and serialized to a **tab-delimited** string via `DataView.ToString` with `V.Ambient.Tab` / `V.Ambient.NewLine`.
   d. The tab-delimited string is written to disk.
   e. The callwrapper `450101` is invoked **once** with the **filename only**.
3. After the callwrapper call, the DataTable rows are deleted.
4. On error, `V.Global.s450101Error` is set with the 3-part format `Sub*!*ErrNo*!*ErrDesc`.

### Tab-Delimited File Format

```
WIDGET-001\t001\t01\t5.0\tLOT-A\tBIN01\t\tSN-001\t123456\t000\t000001
WIDGET-002\t\t02\t10.0\t\t\t\t\t123456\t000\t000002
```

Where `\t` represents a tab character and each line is separated by a newline.

**Usage Pattern:**

```
Program.External.Include.Library("450101.lib",False)

F.Data.DataTable.AddRow("450101")
F.Data.DataTable.SetValue("450101","Part","WIDGET-001",0)
F.Data.DataTable.SetValue("450101","Rev","001",0)
F.Data.DataTable.SetValue("450101","Location","01",0)
F.Data.DataTable.SetValue("450101","Quantity","5.0",0)
F.Data.DataTable.SetValue("450101","Lot","LOT-A",0)
F.Data.DataTable.SetValue("450101","Bin","BIN01",0)
F.Data.DataTable.SetValue("450101","Heat","",0)
F.Data.DataTable.SetValue("450101","Serial","SN-001",0)
F.Data.DataTable.SetValue("450101","WONumber","123456",0)
F.Data.DataTable.SetValue("450101","WOSuffix","000",0)
F.Data.DataTable.SetValue("450101","WOSeq","000001",0)

F.Intrinsic.Control.CallSub(450101Sync)
```

> **Note:** Like `450100.lib`, the callwrapper is invoked **once** for all rows (not per-row). All DataTable rows are serialized into a single tab-delimited file. The filename — not the full path — is passed to the callwrapper. The error format is 3-part (`Sub*!*ErrNo*!*ErrDesc`) with no Row component. The same Quantity integer-scaling quirk applies — always use decimal notation. Use this library instead of `450100.lib` when parts or other fields may contain commas, since tab delimiters avoid the comma-escaping issue entirely.

---

## 450150.lib -- Reverse Issue Material From Job (JB0075GI)

**Wraps:** CallWrapper `450150` — Reverse Issue Material From Job / JB0075GI

```
Program.External.Include.Library("450150.lib",False)
```

This library invokes the `450150` callwrapper to reverse a material issue from a job via the JB0075GI program. It identifies the specific issue to reverse by work order number, suffix, sequence, date, and time. The `PrvIssueMade` flag controls whether previous reversal issues in the same thread are preserved. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `450150`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| WONum | Work order number | String | `9(6)` | |
| WOSuffix | Work order suffix | String | `9(3)` | |
| WOSeq | Work order sequence | String | `9(6)` | |
| Date | Issue date | String | `YYYYMMDD` | |
| Time | Issue time | String | `HHMMSShh` (including hundredths of a second) | |
| xDate | Transaction date | String | `YYYYMMDD` | |
| PrvIssueMade | Previous issue made flag | String | `"Y"` / `"N"` | |

> **Note:** The `Time` field uses an 8-character format `HHMMSShh` where `hh` represents hundredths of a second. The `PrvIssueMade` flag: `"Y"` preserves previous issues made in the same thread; `"N"` deletes them.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s450150Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `450150Sync` | Calls `F.Global.General.CallWrapperSync(450150, ...)` per row |
| `450150Async` | Calls `F.Global.General.CallWrapperAsync(450150, ...)` per row |

### How It Works

1. The library creates a `450150` DataTable with seven columns (`WONum`, `WOSuffix`, `WOSeq`, `Date`, `Time`, `xDate`, `PrvIssueMade`).
2. When `450150Sync` or `450150Async` is called, it loops through each row in the DataTable.
3. For each row, all seven columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `450150` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s450150Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `450150Sync`/`450150Async`).

**Usage Pattern (reverse a single material issue):**

```
Program.External.Include.Library("450150.lib",False)

F.Data.DataTable.AddRow("450150")
F.Data.DataTable.SetValue("450150","WONum","123456",0)
F.Data.DataTable.SetValue("450150","WOSuffix","000",0)
F.Data.DataTable.SetValue("450150","WOSeq","000001",0)
F.Data.DataTable.SetValue("450150","Date","20260321",0)
F.Data.DataTable.SetValue("450150","Time","14300000",0)
F.Data.DataTable.SetValue("450150","xDate","20260321",0)
F.Data.DataTable.SetValue("450150","PrvIssueMade","N",0)

F.Intrinsic.Control.CallSub(450150Sync)
```

**Usage Pattern (batch reverse — preserve previous issues):**

```
Program.External.Include.Library("450150.lib",False)

F.Data.DataTable.AddRow("450150")
F.Data.DataTable.SetValue("450150","WONum","123456",0)
F.Data.DataTable.SetValue("450150","WOSuffix","000",0)
F.Data.DataTable.SetValue("450150","WOSeq","000001",0)
F.Data.DataTable.SetValue("450150","Date","20260321",0)
F.Data.DataTable.SetValue("450150","Time","14300000",0)
F.Data.DataTable.SetValue("450150","xDate","20260321",0)
F.Data.DataTable.SetValue("450150","PrvIssueMade","Y",0)

F.Data.DataTable.AddRow("450150")
F.Data.DataTable.SetValue("450150","WONum","123456",1)
F.Data.DataTable.SetValue("450150","WOSuffix","000",1)
F.Data.DataTable.SetValue("450150","WOSeq","000002",1)
F.Data.DataTable.SetValue("450150","Date","20260321",1)
F.Data.DataTable.SetValue("450150","Time","14350000",1)
F.Data.DataTable.SetValue("450150","xDate","20260321",1)
F.Data.DataTable.SetValue("450150","PrvIssueMade","Y",1)

F.Intrinsic.Control.CallSub(450150Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `WONum`, `WOSuffix`, `WOSeq`, `Date`, `Time`, `xDate`, `PrvIssueMade`. When reversing multiple issues in the same thread, set `PrvIssueMade` to `"Y"` on subsequent rows to preserve earlier reversals.

---

## 500000.lib -- APS Scheduling Information Download (SQLGSLOD)

**Wraps:** CallWrapper `500000` — APS Scheduling Information Download / SQLGSLOD

```
Program.External.Include.Library("500000.lib",False)
```

This library invokes the `500000` callwrapper to download APS (Advanced Planning and Scheduling) scheduling information via the SQLGSLOD program. It supports three display modes (interactive, progress bar, or silent) and configurable lead-time reread flags. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `500000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Mode | Display mode | String | `X(2)` — See `Mode` enum below | |
| Date | Default date | String | `YYYYMMDD` | |
| Flags | ReRead-Lead-Flags | String | See `Flags` enum below | |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"  "` (two spaces) | Accept Input — interactive mode |
| `"SP"` | Show Progress — displays progress bar |
| `"SI"` | Silent — no visible screens |

### Flags Enum

| Value | Meaning |
|-------|---------|
| `"1"` | Reread for lead time when zero box is checked |
| `"2"` | Reread for lead time when zero on seq is checked |
| `"3"` | Both checkboxes are checked |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s500000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `500000Sync` | Calls `F.Global.General.CallWrapperSync(500000, ...)` per row |
| `500000Async` | Calls `F.Global.General.CallWrapperAsync(500000, ...)` per row |

### How It Works

1. The library creates a `500000` DataTable with three columns (`Mode`, `Date`, `Flags`).
2. When `500000Sync` or `500000Async` is called, it loops through each row in the DataTable.
3. For each row, all three columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `500000` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s500000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `500000Sync`/`500000Async`).

**Usage Pattern (silent download with both reread flags):**

```
Program.External.Include.Library("500000.lib",False)

F.Data.DataTable.AddRow("500000")
F.Data.DataTable.SetValue("500000","Mode","SI",0)
F.Data.DataTable.SetValue("500000","Date","20260321",0)
F.Data.DataTable.SetValue("500000","Flags","3",0)

F.Intrinsic.Control.CallSub(500000Sync)
```

**Usage Pattern (show progress with lead-time-when-zero reread):**

```
Program.External.Include.Library("500000.lib",False)

F.Data.DataTable.AddRow("500000")
F.Data.DataTable.SetValue("500000","Mode","SP",0)
F.Data.DataTable.SetValue("500000","Date","20260321",0)
F.Data.DataTable.SetValue("500000","Flags","1",0)

F.Intrinsic.Control.CallSub(500000Async)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `Mode`, `Date`, `Flags`. The `Mode` value `"  "` (two spaces) triggers the interactive Accept Input screen — use `"SI"` for fully automated/screenless operation.

---

## 500030.lib -- Schedule Job (JB0011CL)

**Wraps:** CallWrapper `500030` — Schedule Job / JB0011CL

```
Program.External.Include.Library("500030.lib",False)
```

This library invokes the `500030` callwrapper to schedule a job via the JB0011CL program. It supports forward scheduling, backward scheduling, and scheduling from the current sequence. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `500030`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| StartDate | Start date | String | `MMDDYY` | |
| DueDate | Due date | String | `MMDDYY` | |
| WONum | Work order number | String | `9(6)` | |
| Suffix | Work order suffix | String | `9(3)` | |
| Seq | Work order sequence | String | `9(6)` | |
| Schedule | Schedule direction | String | See `Schedule` enum below | |

> **Warning — Date Format:** This library uses `MMDDYY` (6-character) date format, **not** the `YYYYMMDD` (8-character) format used by most other standard libraries (e.g., `450150.lib`, `500000.lib`, `8101.lib`). Ensure dates are formatted correctly before populating the DataTable.

### Schedule Enum

| Value | Meaning |
|-------|---------|
| `"F"` | Forward Schedule |
| `"B"` | Backward Schedule |
| `"H"` | Scheduling from Current Sequence |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s500030Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `500030Sync` | Calls `F.Global.General.CallWrapperSync(500030, ...)` per row |
| `500030Async` | Calls `F.Global.General.CallWrapperAsync(500030, ...)` per row |

### How It Works

1. The library creates a `500030` DataTable with six columns (`StartDate`, `DueDate`, `WONum`, `Suffix`, `Seq`, `Schedule`).
2. When `500030Sync` or `500030Async` is called, it loops through each row in the DataTable.
3. For each row, all six columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `500030` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s500030Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `500030Sync`/`500030Async`).

**Usage Pattern (forward schedule a job):**

```
Program.External.Include.Library("500030.lib",False)

F.Data.DataTable.AddRow("500030")
F.Data.DataTable.SetValue("500030","StartDate","032126",0)
F.Data.DataTable.SetValue("500030","DueDate","040126",0)
F.Data.DataTable.SetValue("500030","WONum","123456",0)
F.Data.DataTable.SetValue("500030","Suffix","000",0)
F.Data.DataTable.SetValue("500030","Seq","000001",0)
F.Data.DataTable.SetValue("500030","Schedule","F",0)

F.Intrinsic.Control.CallSub(500030Sync)
```

**Usage Pattern (backward schedule multiple jobs):**

```
Program.External.Include.Library("500030.lib",False)

F.Data.DataTable.AddRow("500030")
F.Data.DataTable.SetValue("500030","StartDate","032126",0)
F.Data.DataTable.SetValue("500030","DueDate","040126",0)
F.Data.DataTable.SetValue("500030","WONum","123456",0)
F.Data.DataTable.SetValue("500030","Suffix","000",0)
F.Data.DataTable.SetValue("500030","Seq","000001",0)
F.Data.DataTable.SetValue("500030","Schedule","B",0)

F.Data.DataTable.AddRow("500030")
F.Data.DataTable.SetValue("500030","StartDate","032126",1)
F.Data.DataTable.SetValue("500030","DueDate","041526",1)
F.Data.DataTable.SetValue("500030","WONum","654321",1)
F.Data.DataTable.SetValue("500030","Suffix","000",1)
F.Data.DataTable.SetValue("500030","Seq","000001",1)
F.Data.DataTable.SetValue("500030","Schedule","B",1)

F.Intrinsic.Control.CallSub(500030Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `StartDate`, `DueDate`, `WONum`, `Suffix`, `Seq`, `Schedule`. Dates use `MMDDYY` format (not `YYYYMMDD`).

---

## 600002.lib -- Activate Hook w/ Widget and Runtime (HOOK02)

**Wraps:** CallWrapper `600002` — Activate Hook w/ Widget and Runtime / HOOK02

```
Program.External.Include.Library("600002.lib",False)
```

This library invokes the `600002` callwrapper to programmatically activate or deactivate hooks and configure their sequence scripts via the HOOK02 program. Each row represents a single hook configuration call — specifying the hook number, its active state, an optional description, the script filename, sync/async execution mode, widget flag, and runtime version. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `600002`

| Column | Description | Type | Default | Notes |
|--------|-------------|------|---------|-------|
| Hook | Hook number | String | | Numeric value as string |
| Active | Hook active state | String | | See `Active` enum below |
| Description | Hook description | String | | User-defined hooks only; max 255 characters |
| SeqScript | Sequence script filename | String | | Include file extension (e.g., `"MyHook.g2u"`) |
| SeqSync | Sequence sync/async mode | String | | See `SeqSync` enum below |
| SeqWidget | Sequence widget flag | String | | See `SeqWidget` enum below |
| SeqRTVersion | Sequence runtime version | String | | See `SeqRTVersion` enum below |

### Enums

**Active:**

| Value | Meaning |
|-------|---------|
| `"A"` | Active |
| `"N"` | Not active |

**SeqSync:**

| Value | Meaning |
|-------|---------|
| `"S"` | Synchronous |
| `"A"` | Asynchronous |

**SeqWidget:**

| Value | Meaning |
|-------|---------|
| `"0"` | False (not a widget) |
| `"1"` | True (is a widget) |

**SeqRTVersion:**

| Value | Meaning |
|-------|---------|
| `"1"` | Runtime version 1 |
| `"2"` | Runtime version 2 |
| `"Prompt"` | Prompt user to select runtime version |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s600002Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `600002Sync` | Calls `F.Global.General.CallWrapperSync(600002, ...)` per row |
| `600002Async` | Calls `F.Global.General.CallWrapperAsync(600002, ...)` per row |

### How It Works

1. The library creates a `600002` DataTable with seven columns (`Hook`, `Active`, `Description`, `SeqScript`, `SeqSync`, `SeqWidget`, `SeqRTVersion`).
2. When `600002Sync` or `600002Async` is called, it loops through each row in the DataTable.
3. For each row, all seven columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `600002` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s600002Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `600002Sync`/`600002Async`).

**Usage Pattern (activate a hook with a synchronous script):**

```
Program.External.Include.Library("600002.lib",False)

F.Data.DataTable.AddRow("600002")
F.Data.DataTable.SetValue("600002","Hook","1042",0)
F.Data.DataTable.SetValue("600002","Active","A",0)
F.Data.DataTable.SetValue("600002","Description","Custom PO Validation",0)
F.Data.DataTable.SetValue("600002","SeqScript","POValidation.g2u",0)
F.Data.DataTable.SetValue("600002","SeqSync","S",0)
F.Data.DataTable.SetValue("600002","SeqWidget","0",0)
F.Data.DataTable.SetValue("600002","SeqRTVersion","2",0)

F.Intrinsic.Control.CallSub(600002Sync)
```

**Usage Pattern (deactivate a hook):**

```
Program.External.Include.Library("600002.lib",False)

F.Data.DataTable.AddRow("600002")
F.Data.DataTable.SetValue("600002","Hook","1042",0)
F.Data.DataTable.SetValue("600002","Active","N",0)
F.Data.DataTable.SetValue("600002","Description","",0)
F.Data.DataTable.SetValue("600002","SeqScript","",0)
F.Data.DataTable.SetValue("600002","SeqSync","S",0)
F.Data.DataTable.SetValue("600002","SeqWidget","0",0)
F.Data.DataTable.SetValue("600002","SeqRTVersion","1",0)

F.Intrinsic.Control.CallSub(600002Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `Hook`, `Active`, `Description`, `SeqScript`, `SeqSync`, `SeqWidget`, `SeqRTVersion`. The `Description` field applies only to user-defined hooks and is capped at 255 characters.

---

## 900100.lib -- Print Barcode Work Order Extended (BJ020LZ)

**Wraps:** CallWrapper `900100` — Print Barcode Work Order Extended / BJ020LZ

```
Program.External.Include.Library("900100.lib",False)
```

This library invokes the `900100` callwrapper to print barcode work order labels via the BJ020LZ program. It accepts any number of jobs in the DataTable and supports **report collation** — call it multiple times, each time with the information for the report you want to print, to collate multiple reports in a single print run. It is invoked **per row** and exposes **four invocation modes** (Sync, Async, SyncBio, AsyncBio).

> **Implementation Note:** Unlike most standard libraries, this library uses `F.Intrinsic.String.Build` with the `!*!` delimiter to concatenate parameters (not `ConcatCallWrapperArgs`). It also uses `FieldValTrim` (trimmed values) rather than `FieldVal`.

### DataTable Schema — `900100`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| WO_Num | Work order number | String | `9(6)` | |
| WO_Suf | Work order suffix | String | `9(3)` | |
| WO_RPTID | Work order report ID | String | | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s900100Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `900100Sync` | Calls `F.Global.General.CallWrapperSync(900100, ...)` per row |
| `900100Async` | Calls `F.Global.General.CallWrapperAsync(900100, ...)` per row |
| `900100SyncBio` | Calls `F.Global.General.CallWrapperSyncBio(900100, ...)` per row |
| `900100AsyncBio` | Calls `F.Global.General.CallWrapperAsyncBio(900100, ...)` per row |

### How It Works

1. The library creates a `900100` DataTable with three columns (`WO_Num`, `WO_Suf`, `WO_RPTID`).
2. When any of the four exposed subroutines is called, it loops through each row in the DataTable.
3. For each row, the three column values are **trimmed** (`FieldValTrim`) and concatenated via `F.Intrinsic.String.Build` using the `!*!` delimiter into a single parameter string.
4. The callwrapper `900100` is invoked (Sync, Async, SyncBio, or AsyncBio depending on the subroutine called) with the built parameter string.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s900100Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in the exposed subroutines).

**Usage Pattern (print a single barcode label):**

```
Program.External.Include.Library("900100.lib",False)

F.Data.DataTable.AddRow("900100")
F.Data.DataTable.SetValue("900100","WO_Num","123456",0)
F.Data.DataTable.SetValue("900100","WO_Suf","000",0)
F.Data.DataTable.SetValue("900100","WO_RPTID","",0)

F.Intrinsic.Control.CallSub(900100Sync)
```

**Usage Pattern (collate multiple reports — call the library multiple times):**

```
Program.External.Include.Library("900100.lib",False)

'--- First report batch ---
F.Data.DataTable.AddRow("900100")
F.Data.DataTable.SetValue("900100","WO_Num","100001",0)
F.Data.DataTable.SetValue("900100","WO_Suf","000",0)
F.Data.DataTable.SetValue("900100","WO_RPTID","",0)

F.Data.DataTable.AddRow("900100")
F.Data.DataTable.SetValue("900100","WO_Num","100002",1)
F.Data.DataTable.SetValue("900100","WO_Suf","000",1)
F.Data.DataTable.SetValue("900100","WO_RPTID","",1)

F.Intrinsic.Control.CallSub(900100SyncBio)

'--- Second report batch (collated) ---
F.Data.DataTable.AddRow("900100")
F.Data.DataTable.SetValue("900100","WO_Num","200001",0)
F.Data.DataTable.SetValue("900100","WO_Suf","001",0)
F.Data.DataTable.SetValue("900100","WO_RPTID","",0)

F.Intrinsic.Control.CallSub(900100SyncBio)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. Parameters are built via `String.Build` with `!*!` delimiter (not `ConcatCallWrapperArgs`) and values are trimmed. This library supports **four invocation modes** including Bio variants for report collation scenarios. Parameters are passed in order: `WO_Num`, `WO_Suf`, `WO_RPTID`.

---

## 900200.lib -- Print Work Order Pick List (JB0053)

**Wraps:** CallWrapper `900200` — Print Work Order Pick List / JB0053

```
Program.External.Include.Library("900200.lib",False)
```

This library invokes the `900200` callwrapper to print work order pick lists via the JB0053 program. It accepts a **range** of work orders — you specify a beginning and ending work order number and suffix. Each row in the DataTable represents one range to print. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `900200`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| BegWO | Beginning work order number | String | `9(6)` | |
| BegWOSuffix | Beginning work order suffix | String | `9(3)` | |
| EndWO | Ending work order number | String | `9(6)` | |
| EndWOSuffix | Ending work order suffix | String | `9(3)` | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s900200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `900200Sync` | Calls `F.Global.General.CallWrapperSync(900200, ...)` per row |
| `900200Async` | Calls `F.Global.General.CallWrapperAsync(900200, ...)` per row |

### How It Works

1. The library creates a `900200` DataTable with four columns (`BegWO`, `BegWOSuffix`, `EndWO`, `EndWOSuffix`).
2. When `900200Sync` or `900200Async` is called, it loops through each row in the DataTable.
3. For each row, all four columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `900200` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s900200Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `900200Sync`/`900200Async`).

**Usage Pattern (print pick list for a single work order):**

```
Program.External.Include.Library("900200.lib",False)

F.Data.DataTable.AddRow("900200")
F.Data.DataTable.SetValue("900200","BegWO","123456",0)
F.Data.DataTable.SetValue("900200","BegWOSuffix","000",0)
F.Data.DataTable.SetValue("900200","EndWO","123456",0)
F.Data.DataTable.SetValue("900200","EndWOSuffix","000",0)

F.Intrinsic.Control.CallSub(900200Sync)
```

**Usage Pattern (print pick lists for a range of work orders):**

```
Program.External.Include.Library("900200.lib",False)

F.Data.DataTable.AddRow("900200")
F.Data.DataTable.SetValue("900200","BegWO","100000",0)
F.Data.DataTable.SetValue("900200","BegWOSuffix","000",0)
F.Data.DataTable.SetValue("900200","EndWO","100050",0)
F.Data.DataTable.SetValue("900200","EndWOSuffix","999",0)

F.Intrinsic.Control.CallSub(900200Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no global option/mode variables. Parameters are passed in order: `BegWO`, `BegWOSuffix`, `EndWO`, `EndWOSuffix`. To print a single work order, set the beginning and ending values to the same work order number and suffix.

---

## 900300.lib -- Print Flex Schedule (JB0095N)

**Wraps:** CallWrapper `900300` — Print Flex Schedule / JB0095N

```
Program.External.Include.Library("900300.lib",False)
```

This library invokes the `900300` callwrapper to print flex schedule reports via the JB0095N program. It accepts a **date range**, a **flex schedule number range**, and two option flags (show material, use extended barcode). Each row in the DataTable represents one report request. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `900300`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| StartDate | Starting date | String | `YYYYMMDD` | |
| EndDate | Ending date | String | `YYYYMMDD` | |
| StartFSNum | Starting flex schedule number | String | `9(6)` | |
| StartFSSuffix | Starting flex schedule suffix | String | `9(3)` | |
| EndFSNum | Ending flex schedule number | String | `9(6)` | |
| EndFSSuffix | Ending flex schedule suffix | String | `9(3)` | |
| ShowMatl | Show material on report | String | `Y`/`N` | |
| UseExtBarcode | Use extended barcode | String | `Y`/`N` | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s900300Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `900300Sync` | Calls `F.Global.General.CallWrapperSync(900300, ...)` per row |
| `900300Async` | Calls `F.Global.General.CallWrapperAsync(900300, ...)` per row |

### How It Works

1. The library creates a `900300` DataTable with eight columns (`StartDate`, `EndDate`, `StartFSNum`, `StartFSSuffix`, `EndFSNum`, `EndFSSuffix`, `ShowMatl`, `UseExtBarcode`).
2. When `900300Sync` or `900300Async` is called, it loops through each row in the DataTable.
3. For each row, all eight columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `900300` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s900300Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `900300Sync`/`900300Async`).

**Usage Pattern (print flex schedule for a date range with material):**

```
Program.External.Include.Library("900300.lib",False)

F.Data.DataTable.AddRow("900300")
F.Data.DataTable.SetValue("900300","StartDate","20260301",0)
F.Data.DataTable.SetValue("900300","EndDate","20260331",0)
F.Data.DataTable.SetValue("900300","StartFSNum","100000",0)
F.Data.DataTable.SetValue("900300","StartFSSuffix","000",0)
F.Data.DataTable.SetValue("900300","EndFSNum","100050",0)
F.Data.DataTable.SetValue("900300","EndFSSuffix","999",0)
F.Data.DataTable.SetValue("900300","ShowMatl","Y",0)
F.Data.DataTable.SetValue("900300","UseExtBarcode","N",0)

F.Intrinsic.Control.CallSub(900300Sync)
```

**Usage Pattern (print a single flex schedule with extended barcode, no material):**

```
Program.External.Include.Library("900300.lib",False)

F.Data.DataTable.AddRow("900300")
F.Data.DataTable.SetValue("900300","StartDate","20260321",0)
F.Data.DataTable.SetValue("900300","EndDate","20260321",0)
F.Data.DataTable.SetValue("900300","StartFSNum","123456",0)
F.Data.DataTable.SetValue("900300","StartFSSuffix","000",0)
F.Data.DataTable.SetValue("900300","EndFSNum","123456",0)
F.Data.DataTable.SetValue("900300","EndFSSuffix","000",0)
F.Data.DataTable.SetValue("900300","ShowMatl","N",0)
F.Data.DataTable.SetValue("900300","UseExtBarcode","Y",0)

F.Intrinsic.Control.CallSub(900300Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `StartDate`, `EndDate`, `StartFSNum`, `StartFSSuffix`, `EndFSNum`, `EndFSSuffix`, `ShowMatl`, `UseExtBarcode`. Dates use `YYYYMMDD` format. To print a single flex schedule, set the starting and ending number/suffix to the same values.

---

## 910050.lib -- Print Sales Order (ORD0ACKN)

**Wraps:** CallWrapper `910050` — Print Sales Order / ORD0ACKN

```
Program.External.Include.Library("910050.lib",False)
```

This library invokes the `910050` callwrapper to print a sales order acknowledgement via the ORD0ACKN program. Each row in the DataTable represents one order to print. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `910050`

| Column | Description | Type | Default | Notes |
|--------|-------------|------|---------|-------|
| Order | Order number | String | | `9(7)` — 7-digit order number |
| Mode | Print mode | String | `"P"` | Only valid value is `"P"`. Defaults automatically; callers do not need to set this. |
| Title | Acknowledgement title | String | | Free-text string printed on the acknowledgement |
| Filler | Filler / placeholder | String | `""` | No data should be placed here. Required by the callwrapper parameter position. |

> **Note:** The `Mode` column defaults to `"P"` (the only valid mode) at DataTable creation. You do not need to set `Mode` when adding rows. The `Filler` column is a positional placeholder — leave it empty.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s910050Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `910050Sync` | Calls `F.Global.General.CallWrapperSync(910050, ...)` per row |
| `910050Async` | Calls `F.Global.General.CallWrapperAsync(910050, ...)` per row |

### How It Works

1. The library creates a `910050` DataTable with four columns (`Order`, `Mode`, `Title`, `Filler`). `Mode` defaults to `"P"` and `Filler` defaults to `""`.
2. When `910050Sync` or `910050Async` is called, it loops through each row in the DataTable.
3. For each row, all four columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `910050` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s910050Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `910050Sync`/`910050Async`).

**Usage Pattern (print a single sales order acknowledgement):**

```
Program.External.Include.Library("910050.lib",False)

F.Data.DataTable.AddRow("910050")
F.Data.DataTable.SetValue("910050","Order","1234567",0)
F.Data.DataTable.SetValue("910050","Title","Order Confirmation",0)

F.Intrinsic.Control.CallSub(910050Sync)
```

**Usage Pattern (print multiple sales order acknowledgements):**

```
Program.External.Include.Library("910050.lib",False)

F.Data.DataTable.AddRow("910050")
F.Data.DataTable.SetValue("910050","Order","1000001",0)
F.Data.DataTable.SetValue("910050","Title","Revised Order",0)

F.Data.DataTable.AddRow("910050")
F.Data.DataTable.SetValue("910050","Order","1000002",1)
F.Data.DataTable.SetValue("910050","Title","New Order",1)

F.Intrinsic.Control.CallSub(910050Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `Order`, `Mode`, `Title`, `Filler`. You do not need to set `Mode` (defaults to `"P"`) or `Filler` (defaults to `""`) — only `Order` and optionally `Title` are needed.

---

## 910200.lib -- Print Sales Order Pick List (ORD054)

**Wraps:** CallWrapper `910200` — Print Sales Order Pick List / ORD054

```
Program.External.Include.Library("910200.lib",False)
```

This library invokes the `910200` callwrapper to print sales order pick lists via the ORD054 program. It accepts an **order number range** and a **date range**, each with an "all" flag that bypasses the respective range filter. Each row in the DataTable represents one report request. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

### DataTable Schema — `910200`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| BegOrdNum | Beginning order number | String | `9(7)` | |
| EndOrdNum | Ending order number | String | `9(7)` | |
| AllOrders | All orders flag | String | `Y`/`N` | |
| StartDate | Start date | String | `YYYYMMDD` | |
| EndDate | End date | String | `YYYYMMDD` | |
| AllDates | All dates flag | String | `Y`/`N` | |

> **Note:** When `AllOrders` is `"Y"`, the `BegOrdNum`/`EndOrdNum` range is bypassed (all orders are included). When `AllDates` is `"Y"`, the `StartDate`/`EndDate` range is bypassed (all dates are included). Set the respective flag to `"N"` to filter by the specified range.

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s910200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `910200Sync` | Calls `F.Global.General.CallWrapperSync(910200, ...)` per row |
| `910200Async` | Calls `F.Global.General.CallWrapperAsync(910200, ...)` per row |

### How It Works

1. The library creates a `910200` DataTable with six columns (`BegOrdNum`, `EndOrdNum`, `AllOrders`, `StartDate`, `EndDate`, `AllDates`).
2. When `910200Sync` or `910200Async` is called, it loops through each row in the DataTable.
3. For each row, all six columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `910200` is invoked (sync or async) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s910200Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `910200Sync`/`910200Async`).

**Usage Pattern (print pick list for a specific order range and date range):**

```
Program.External.Include.Library("910200.lib",False)

F.Data.DataTable.AddRow("910200")
F.Data.DataTable.SetValue("910200","BegOrdNum","1000001",0)
F.Data.DataTable.SetValue("910200","EndOrdNum","1000050",0)
F.Data.DataTable.SetValue("910200","AllOrders","N",0)
F.Data.DataTable.SetValue("910200","StartDate","20260301",0)
F.Data.DataTable.SetValue("910200","EndDate","20260321",0)
F.Data.DataTable.SetValue("910200","AllDates","N",0)

F.Intrinsic.Control.CallSub(910200Sync)
```

**Usage Pattern (print pick list for all orders, all dates):**

```
Program.External.Include.Library("910200.lib",False)

F.Data.DataTable.AddRow("910200")
F.Data.DataTable.SetValue("910200","BegOrdNum","",0)
F.Data.DataTable.SetValue("910200","EndOrdNum","",0)
F.Data.DataTable.SetValue("910200","AllOrders","Y",0)
F.Data.DataTable.SetValue("910200","StartDate","",0)
F.Data.DataTable.SetValue("910200","EndDate","",0)
F.Data.DataTable.SetValue("910200","AllDates","Y",0)

F.Intrinsic.Control.CallSub(910200Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `BegOrdNum`, `EndOrdNum`, `AllOrders`, `StartDate`, `EndDate`, `AllDates`. Dates use `YYYYMMDD` format. Use the `AllOrders` and `AllDates` flags (`"Y"`) to bypass the respective range filters.

---

## 910201.lib -- Print Shipment Pick List (ORD055)

**Wraps:** CallWrapper `910201` — Print Shipment Pick List / ORD055

```
Program.External.Include.Library("910201.lib",False)
```

This library invokes the `910201` callwrapper to print shipment pick lists via the ORD055 program. It is structurally identical to [`910200.lib`](#910200lib----print-sales-order-pick-list-ord054) (same 6-column schema with order range, date range, and "all" bypass flags) but targets shipment pick lists instead of sales order pick lists. It uses `ConcatCallWrapperArgs` and is invoked **per row**.

> **Warning — Async Bug:** The source code contains a bug in the `SelectCase` dispatch: both `Case(0)` (Sync) and `Case(1)` (Async) call `CallWrapperSync`. The `910201Async` subroutine will therefore execute **synchronously**, not asynchronously. Use `910201Sync` to avoid confusion until this is fixed in a future library version.

### DataTable Schema — `910201`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| BegOrdNum | Beginning order number | String | `9(7)` | `" "` |
| EndOrdNum | Ending order number | String | `9(7)` | `" "` |
| AllOrders | All orders flag | String | `Y`/`N` | |
| StartDate | Start date | String | `YYYYMMDD` | `" "` |
| EndDate | End date | String | `YYYYMMDD` | `" "` |
| AllDates | All dates flag | String | `Y`/`N` | |

> **Note:** When `AllOrders` is `"Y"`, the `BegOrdNum`/`EndOrdNum` range is bypassed (all orders are included) and those columns do not need to be set. When `AllDates` is `"Y"`, the `StartDate`/`EndDate` range is bypassed (all dates are included) and those columns do not need to be set. The range columns default to `" "` (single space).

### Comparison with 910200.lib

| Feature | 910200.lib (Sales Order Pick List) | 910201.lib (Shipment Pick List) |
|---------|------------------------------------|---------------------------------|
| CallWrapper ID | `910200` | `910201` |
| Core program | ORD054 | ORD055 |
| DataTable schema | Same 6 columns | Same 6 columns |
| Range column defaults | (none) | `" "` (single space) |
| Async support | Yes (`CallWrapperAsync`) | **Broken** — `Case(1)` calls `CallWrapperSync` |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s910201Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `910201Sync` | Calls `F.Global.General.CallWrapperSync(910201, ...)` per row |
| `910201Async` | **Intended** to call Async, but **actually calls Sync** due to source bug |

### How It Works

1. The library creates a `910201` DataTable with six columns (`BegOrdNum`, `EndOrdNum`, `AllOrders`, `StartDate`, `EndDate`, `AllDates`). The range columns (`BegOrdNum`, `EndOrdNum`, `StartDate`, `EndDate`) default to `" "` (single space).
2. When `910201Sync` or `910201Async` is called, it loops through each row in the DataTable.
3. For each row, all six columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `910201` is invoked with the concatenated parameters. **Both sync and async paths call `CallWrapperSync`** due to a bug in the source.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s910201Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `910201Sync`/`910201Async`).

**Usage Pattern (print shipment pick list for a specific order range and date range):**

```
Program.External.Include.Library("910201.lib",False)

F.Data.DataTable.AddRow("910201")
F.Data.DataTable.SetValue("910201","BegOrdNum","1000001",0)
F.Data.DataTable.SetValue("910201","EndOrdNum","1000050",0)
F.Data.DataTable.SetValue("910201","AllOrders","N",0)
F.Data.DataTable.SetValue("910201","StartDate","20260301",0)
F.Data.DataTable.SetValue("910201","EndDate","20260321",0)
F.Data.DataTable.SetValue("910201","AllDates","N",0)

F.Intrinsic.Control.CallSub(910201Sync)
```

**Usage Pattern (print shipment pick list for all orders, all dates):**

```
Program.External.Include.Library("910201.lib",False)

F.Data.DataTable.AddRow("910201")
F.Data.DataTable.SetValue("910201","AllOrders","Y",0)
F.Data.DataTable.SetValue("910201","AllDates","Y",0)

F.Intrinsic.Control.CallSub(910201Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `BegOrdNum`, `EndOrdNum`, `AllOrders`, `StartDate`, `EndDate`, `AllDates`. Dates use `YYYYMMDD` format. When using the "all" flags, the range columns retain their `" "` defaults and do not need to be set. **Caution:** `910201Async` does not actually run asynchronously — use `910201Sync`.

---

## 915000.lib -- Print PO (PUR1LZ)

**Wraps:** CallWrapper `915000` — Print PO / PUR1LZ

```
Program.External.Include.Library("915000.lib",False)
```

This library invokes the `915000` callwrapper to print purchase orders via the PUR1LZ program. It supports two operating modes via the `Switch` parameter: screenless (fully automated) and screen mode (adds the PO to the print grid). It uses `ConcatCallWrapperArgs`, is invoked **per row**, and exposes **four invocation modes** (Sync, Async, SyncBio, AsyncBio).

### DataTable Schema — `915000`

| Column | Description | Type | Default | Notes |
|--------|-------------|------|---------|-------|
| PONum | Purchase order number | String | | `9(7)` — 7-digit PO number |
| Switch | Operating mode | String | | See `Switch` enum below |
| ScreenlessHistory | Screenless history flag | String | | `Y`/`N` |
| PrintOpenQty | Print open quantity only flag | String | | `Y`/`N` |
| UseVendCurr | Use vendor currency flag | String | | `Y`/`N` |

### Switch Enum

| Value | Meaning |
|-------|---------|
| `"S"` | Screenless — prints the PO directly without user interaction |
| `" "` | Screen mode — adds the PO to the grid of ranges as a beginning and ending PO number for interactive printing |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s915000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `915000Sync` | Calls `F.Global.General.CallWrapperSync(915000, ...)` per row |
| `915000Async` | Calls `F.Global.General.CallWrapperAsync(915000, ...)` per row |
| `915000SyncBio` | Calls `F.Global.General.CallWrapperSyncBio(915000, ...)` per row |
| `915000AsyncBio` | Calls `F.Global.General.CallWrapperAsyncBio(915000, ...)` per row |

### How It Works

1. The library creates a `915000` DataTable with five columns (`PONum`, `Switch`, `ScreenlessHistory`, `PrintOpenQty`, `UseVendCurr`).
2. When any of the four exposed subroutines is called, it loops through each row in the DataTable.
3. For each row, all five columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `915000` is invoked (Sync, Async, SyncBio, or AsyncBio depending on the subroutine called) with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s915000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in the exposed subroutines).

**Usage Pattern (print a PO screenlessly):**

```
Program.External.Include.Library("915000.lib",False)

F.Data.DataTable.AddRow("915000")
F.Data.DataTable.SetValue("915000","PONum","1234567",0)
F.Data.DataTable.SetValue("915000","Switch","S",0)
F.Data.DataTable.SetValue("915000","ScreenlessHistory","N",0)
F.Data.DataTable.SetValue("915000","PrintOpenQty","N",0)
F.Data.DataTable.SetValue("915000","UseVendCurr","N",0)

F.Intrinsic.Control.CallSub(915000Sync)
```

**Usage Pattern (print multiple POs with open qty only, vendor currency):**

```
Program.External.Include.Library("915000.lib",False)

F.Data.DataTable.AddRow("915000")
F.Data.DataTable.SetValue("915000","PONum","1000001",0)
F.Data.DataTable.SetValue("915000","Switch","S",0)
F.Data.DataTable.SetValue("915000","ScreenlessHistory","N",0)
F.Data.DataTable.SetValue("915000","PrintOpenQty","Y",0)
F.Data.DataTable.SetValue("915000","UseVendCurr","Y",0)

F.Data.DataTable.AddRow("915000")
F.Data.DataTable.SetValue("915000","PONum","1000002",1)
F.Data.DataTable.SetValue("915000","Switch","S",1)
F.Data.DataTable.SetValue("915000","ScreenlessHistory","N",1)
F.Data.DataTable.SetValue("915000","PrintOpenQty","Y",1)
F.Data.DataTable.SetValue("915000","UseVendCurr","Y",1)

F.Intrinsic.Control.CallSub(915000SyncBio)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `PONum`, `Switch`, `ScreenlessHistory`, `PrintOpenQty`, `UseVendCurr`. Use `Switch` = `"S"` for fully automated screenless printing. This library supports **four invocation modes** including Bio variants for report collation scenarios.

---

## 920000.lib -- Print Quote (QTL010)

**Wraps:** CallWrapper `920000` — Print Quote / QTL010

```
Program.External.Include.Library("920000.lib",False)
```

This library invokes the `920000` callwrapper to print a quote via the QTL010 program. Each row in the DataTable contains a single quote number. It is a **direct callwrapper invoker** — the `Quote` field value is passed directly to the callwrapper. It is invoked **per row**.

### DataTable Schema — `920000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| Quote | Quote number | String | `9(7)` | |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s920000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `920000Sync` | Calls `F.Global.General.CallWrapperSync(920000, ...)` per row |
| `920000Async` | Calls `F.Global.General.CallWrapperAsync(920000, ...)` per row |

### How It Works

1. The library creates a `920000` DataTable with a single column (`Quote`).
2. When `920000Sync` or `920000Async` is called, it loops through each row in the DataTable.
3. For each row, the `Quote` field value is passed **directly** to the callwrapper.
4. The callwrapper `920000` is invoked (sync or async) with the quote number.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s920000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in `920000Sync`/`920000Async`).

**Usage Pattern (print a single quote):**

```
Program.External.Include.Library("920000.lib",False)

F.Data.DataTable.AddRow("920000")
F.Data.DataTable.SetValue("920000","Quote","1234567",0)

F.Intrinsic.Control.CallSub(920000Sync)
```

**Usage Pattern (print multiple quotes):**

```
Program.External.Include.Library("920000.lib",False)

F.Data.DataTable.AddRow("920000")
F.Data.DataTable.SetValue("920000","Quote","1000001",0)

F.Data.DataTable.AddRow("920000")
F.Data.DataTable.SetValue("920000","Quote","1000002",1)

F.Data.DataTable.AddRow("920000")
F.Data.DataTable.SetValue("920000","Quote","1000003",2)

F.Intrinsic.Control.CallSub(920000Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation, no field padding, and no parameter concatenation. The single `Quote` value is passed directly to the callwrapper.

---

