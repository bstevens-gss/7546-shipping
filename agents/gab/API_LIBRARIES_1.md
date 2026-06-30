# GAB Standard Libraries Reference (Part 1 of 5)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with standard .lib includes (Part 1: through line 3374)
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# STANDARD LIBRARIES

Standard libraries (`.lib` files) ship with Global Shop Solutions and are available for inclusion in any GAB project. They provide reusable DataTable-driven wrappers around common callwrapper operations.

## 1000.lib -- Fix BOM (REBLDALL)

Wraps the numeric callwrapper ID `1000` (Fix BOM / REBLDALL). Populate the `1000` DataTable with one row per call, then invoke `1000Sync` or `1000Async`.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("1000.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Default | Description |
|--------|-----------|------|---------|-------------|
| `CompCode` | Company Code | String | `V.Caller.CompanyCode` | 3-character company code |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s1000Error` | String | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `1000Sync` | Runs the 1000 callwrapper synchronously for each row in the DataTable |
| `1000Async` | Runs the 1000 callwrapper asynchronously for each row in the DataTable |

**Usage Pattern:**

```
F.Data.DataTable.SetValue("1000","CompCode","10T",0)
F.Intrinsic.Control.CallSub(1000Sync)
F.Intrinsic.Control.If(V.Global.s1000Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s1000Error,"1000 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** The DataTable rows are automatically deleted after processing. If an error occurs mid-loop, `V.Global.s1000Error` contains the subroutine name, error number, error description, and the 1-based row index where the failure occurred.

## 1010.lib -- Update Inventory Description to BOM (BM0050)

Wraps the numeric callwrapper ID `1010` (Update Inventory Description to BOM / BM0050). Populate the `1010` DataTable with one row per call, then invoke `1010Sync` or `1010Async`.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("1010.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Values / Description |
|--------|-----------|------|----------------------|
| `Process` | Process | String | `01` = Unit Cost Updates, `02` = Rebuild Browser Index |
| `BegBOMParent` | Beginning BOM Parent | String | Part number |
| `BegBOMRev` | Beginning BOM Rev | String | Revision |
| `EndBOMParent` | End BOM Parent | String | Part number |
| `EndBOMRev` | End BOM Rev | String | Revision |
| `AllBOMs` | All BOMs Flag | String | `Y` / `N` |
| `UpdateCost` | Update Cost | String | `01` = Zero Unit Cost For All Parents, `02` = No Change To Unit Cost For Any Parents, `03` = No Unit Cost Update, `04` = Update All Costs From Alt Cost |
| `RefreshDescForRawMatl` | Refresh Descriptions For Raw Materials | String | `Y` / `N` |
| `RefreshDescForParentParts` | Refresh Descriptions For Parent Parts | String | `Y` / `N` |
| `RefreshUM` | Refresh Unit Of Measure Fields | String | `Y` / `N` |
| `RefreshSource` | Refresh Source Code | String | `Y` / `N` |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s1010Error` | String | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `1010Sync` | Runs the 1010 callwrapper synchronously for each row in the DataTable |
| `1010Async` | Runs the 1010 callwrapper asynchronously for each row in the DataTable |

**Usage Pattern:**

```
F.Data.DataTable.AddRow("1010")
F.Data.DataTable.SetValue("1010","Process","01",0)
F.Data.DataTable.SetValue("1010","BegBOMParent","210900-7",0)
F.Data.DataTable.SetValue("1010","BegBOMRev","",0)
F.Data.DataTable.SetValue("1010","EndBOMParent","210900-7",0)
F.Data.DataTable.SetValue("1010","EndBOMRev","",0)
F.Data.DataTable.SetValue("1010","AllBOMs","N",0)
F.Data.DataTable.SetValue("1010","UpdateCost","03",0)
F.Data.DataTable.SetValue("1010","RefreshDescForRawMatl","Y",0)
F.Data.DataTable.SetValue("1010","RefreshDescForParentParts","Y",0)
F.Data.DataTable.SetValue("1010","RefreshUM","Y",0)
F.Data.DataTable.SetValue("1010","RefreshSource","N",0)
F.Intrinsic.Control.CallSub(1010Sync)
F.Intrinsic.Control.If(V.Global.s1010Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s1010Error,"1010 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** The DataTable rows are automatically deleted after processing. Parameters are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` before being passed to the callwrapper.

## 1500.lib -- Reprice Routers (RE0071CW)

Wraps the numeric callwrapper ID `1500` (Reprice Routers / RE0071CW). Unlike the simpler libraries, `1500.lib` generates an input file from the DataTable, passes the input and output file paths to the callwrapper, and the callwrapper produces an output file with pricing results.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("1500.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Description |
|--------|-----------|------|-------------|
| `Router` | Router number | String | Router for input file |
| `Quantity` | Quantity | Float | Quantity for input file |

**Global Variables:**

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s1500Error` | String | `""` | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |
| `V.Global.s1500InputFile` | String | `{FilesDir}\{User}{Terminal}PRICING.IN` | Fully qualified path for the input file. Override before calling if needed. |
| `V.Global.s1500OutputFile` | String | `{FilesDir}\{User}{Terminal}PRICING.OUT` | Fully qualified path for the output file. Override before calling if needed. |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `1500Sync` | Creates the input file from the DataTable, then runs the 1500 callwrapper synchronously |
| `1500Async` | Creates the input file from the DataTable, then runs the 1500 callwrapper asynchronously |

**How It Works:**

1. The DataTable rows are exported to the input file (`*!*` delimited, one row per line) using DataView.ToString and String2File.
2. The input and output file paths are concatenated and passed to the callwrapper.
3. The callwrapper processes the input file and writes results to the output file.
4. The DataTable rows are deleted after processing.

**Usage Pattern:**

```
F.Data.DataTable.AddRow("1500")
F.Data.DataTable.SetValue("1500","Router","210900-7",0)
F.Data.DataTable.SetValue("1500","Quantity",100.0,0)
F.Intrinsic.Control.CallSub(1500Sync)
F.Intrinsic.Control.If(V.Global.s1500Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s1500Error,"1500 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** After the callwrapper completes, read the output file at `V.Global.s1500OutputFile` to retrieve the pricing results. The input/output file paths default to `{V.Caller.FilesDir}\{V.Caller.User.Trim}{V.Caller.Terminal}PRICING.IN` and `.OUT` respectively, but can be overridden by setting the globals before calling.

## 1510.lib -- Admin Reprice Routers/Estimates (RE0019)

Wraps the numeric callwrapper ID `1510` (Admin Reprice Routers/Estimates / RE0019). Populate the `1510` DataTable with one row per call, then invoke `1510Sync` or `1510Async`.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("1510.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Values / Description |
|--------|-----------|------|----------------------|
| `Mode` | Mode | String | `PS` = Populate the Screen, `NS` = Screenless Mode |
| `BegRouter` | Beginning Router | String | Router number |
| `EndRouter` | End Router | String | Router number |
| `AllRouter` | All Routers Flag | String | `Y` / `N` |
| `SetupFromWC` | Pull Setup from Workcenter | String | `Y` / `N` |
| `RuntimeFromWC` | Pull Runtime from Workcenter | String | `Y` / `N` |
| `DescFromWC` | Pull Description from Workcenter | String | `Y` / `N` |
| `DescFromInvMatl` | Pull Description from Inventory (Material) | String | `Y` / `N` |
| `DescFromInvRouter` | Pull Description from Inventory (Router) | String | `Y` / `N` |
| `PLFromInvRouter` | Pull Product Line from Inventory (Router) | String | `Y` / `N` |
| `RepriceLaborOnly` | Reprice Labor Steps Only | String | `Y` / `N` |
| `RepriceMatlOnly` | Reprice Material Steps Only | String | `Y` / `N` |
| `UpdateAltCostRouter` | Update Alternate Cost Router | String | `Y` / `N` |
| `AltCostRepriceQty` | Alternate Cost Reprice Quantity | String | Numeric. Only used when `UpdateAltCostRouter` = `Y`. |
| `ZeroUCForMfgParts` | Zero Unit Cost for Manufactured Parts | String | `Y` / `N` |
| `RefreshLeadTimeMatl` | Refresh Lead Time on Material Sequences | String | `Y` / `N` |
| `RefreshLeadTimeOutside` | Refresh Lead Time on Outside Sequences | String | `Y` / `N` |
| `UpdateRateWithInvCostIfZero` | Update Rate with Inventory Cost Even if Zero | String | `Y` / `N` |
| `UpdateRateWithWCRateIfZero` | Update Rate with Workcenter Rate Even if Zero | String | `Y` / `N` |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s1510Error` | String | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `1510Sync` | Runs the 1510 callwrapper synchronously for each row in the DataTable |
| `1510Async` | Runs the 1510 callwrapper asynchronously for each row in the DataTable |

**Usage Pattern:**

```
F.Data.DataTable.AddRow("1510")
F.Data.DataTable.SetValue("1510","Mode","NS",0)
F.Data.DataTable.SetValue("1510","BegRouter","210900-7",0)
F.Data.DataTable.SetValue("1510","EndRouter","210900-7",0)
F.Data.DataTable.SetValue("1510","AllRouter","N",0)
F.Data.DataTable.SetValue("1510","SetupFromWC","Y",0)
F.Data.DataTable.SetValue("1510","RuntimeFromWC","Y",0)
F.Data.DataTable.SetValue("1510","DescFromWC","N",0)
F.Data.DataTable.SetValue("1510","DescFromInvMatl","Y",0)
F.Data.DataTable.SetValue("1510","DescFromInvRouter","Y",0)
F.Data.DataTable.SetValue("1510","PLFromInvRouter","N",0)
F.Data.DataTable.SetValue("1510","RepriceLaborOnly","N",0)
F.Data.DataTable.SetValue("1510","RepriceMatlOnly","N",0)
F.Data.DataTable.SetValue("1510","UpdateAltCostRouter","N",0)
F.Data.DataTable.SetValue("1510","AltCostRepriceQty","0",0)
F.Data.DataTable.SetValue("1510","ZeroUCForMfgParts","N",0)
F.Data.DataTable.SetValue("1510","RefreshLeadTimeMatl","N",0)
F.Data.DataTable.SetValue("1510","RefreshLeadTimeOutside","N",0)
F.Data.DataTable.SetValue("1510","UpdateRateWithInvCostIfZero","N",0)
F.Data.DataTable.SetValue("1510","UpdateRateWithWCRateIfZero","N",0)
F.Intrinsic.Control.CallSub(1510Sync)
F.Intrinsic.Control.If(V.Global.s1510Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s1510Error,"1510 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** The DataTable rows are automatically deleted after processing. Parameters are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` before being passed to the callwrapper.

## 2000.lib -- Scrap Reason Code Maintenance (JB0082)

Wraps the numeric callwrapper ID `2000` (Scrap Reason Code Maintenance / JB0082). Manages scrap reason codes and quantities for work order sequences. Displays existing scrap entries in the repeat group (if any) and allows add/update/delete of reason codes and quantity combinations.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("2000.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Description |
|--------|-----------|------|-------------|
| `Mode` | Mode | String | Operating mode |
| `Job` | Work Order | String | 6-character work order number |
| `Suffix` | Suffix | String | 3-character work order suffix |
| `Sequence` | Sequence | String | 6-digit work order sequence |
| `TotalScrap` | Total Scrap Quantity | String | Total scrap quantity |
| `ScrapReference` | Scrap Reference | String | Scrap reference |
| `SCRDTDate` | Scrap Detail Date | String | Scrap detail date |
| `SCRDTTime` | Scrap Detail Time | String | Scrap detail time |
| `SCRDTSeq` | Scrap Detail Sequence | String | Scrap detail sequence |
| `SCRDTDTLJob` | Scrap Detail - Detail Job | String | Detail job number |
| `SCRDTDTLSuffix` | Scrap Detail - Detail Suffix | String | Detail suffix |
| `SCRDTDTLSeq` | Scrap Detail - Detail Sequence | String | Detail sequence |
| `SCRDTDTLDate` | Scrap Detail - Detail Date | String | Detail date |
| `SCRDTDTLKeySeq` | Scrap Detail - Detail Key Sequence | String | Detail key sequence |
| `SCRDTStat` | Scrap Detail Status | String | Detail status |
| `SCRDTQuality` | Scrap Detail Quality | String | Quality number |
| `SCRDTReasonCode` | Scrap Detail Reason Code | String | Reason code |
| `SCRDTQty` | Scrap Detail Quantity | String | Scrap quantity for this reason |
| `SCRDTScrapRef` | Scrap Detail Scrap Reference | String | Detail scrap reference |
| `StatusOnSave` | Status On Save | String | Status to apply on save |
| `DestDtlKey` | Destination Detail Key | String | Destination detail key |
| `DestScrapRef` | Destination Scrap Reference | String | Destination scrap reference |
| `GetQualityFlag` | Get Quality Flag | String | Flag to retrieve quality info |
| `UpdateQualityFlag` | Update Quality Flag | String | Flag to update quality info |
| `Status` | Status | String | Status parameter |
| `RetPrimaryReason` | Return Primary Reason | String | Returned primary reason code |
| `RetPrimaryQty` | Return Primary Quantity | String | Returned primary quantity |
| `RetPrimaryQuality` | Return Primary Quality | String | Returned primary quality number |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s2000Error` | String | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `2000Sync` | Runs the 2000 callwrapper synchronously for each row in the DataTable |
| `2000Async` | Runs the 2000 callwrapper asynchronously for each row in the DataTable |

**Usage Pattern:**

```
F.Data.DataTable.AddRow("2000")
F.Data.DataTable.SetValue("2000","Mode","",0)
F.Data.DataTable.SetValue("2000","Job","500003",0)
F.Data.DataTable.SetValue("2000","Suffix","001",0)
F.Data.DataTable.SetValue("2000","Sequence","000010",0)
F.Data.DataTable.SetValue("2000","TotalScrap","5",0)
F.Data.DataTable.SetValue("2000","ScrapReference","",0)
F.Intrinsic.Control.CallSub(2000Sync)
F.Intrinsic.Control.If(V.Global.s2000Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s2000Error,"2000 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** The DataTable rows are automatically deleted after processing. All 28 columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to the callwrapper. The `SCRDT*` columns correspond to scrap detail record fields, and the `Ret*` columns capture returned values.

## 2001.lib -- Quality Reject/Disposition (JB0027)

Wraps the numeric callwrapper ID `2001` (Quality Reject/Disposition / JB0027). Populate the `2001` DataTable with one row per call, then invoke `2001Sync` or `2001Async`.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("2001.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Default | Description |
|--------|-----------|------|---------|-------------|
| `CompCode` | Company Code | String | `V.Caller.CompanyCode` | 3-character company code |
| `QualityNum` | Quality Number | String | | 7-digit quality number |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s2001Error` | String | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `2001Sync` | Runs the 2001 callwrapper synchronously for each row in the DataTable |
| `2001Async` | Runs the 2001 callwrapper asynchronously for each row in the DataTable |

**Usage Pattern:**

```
F.Data.DataTable.AddRow("2001")
F.Data.DataTable.SetValue("2001","QualityNum","0001234",0)
F.Intrinsic.Control.CallSub(2001Sync)
F.Intrinsic.Control.If(V.Global.s2001Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s2001Error,"2001 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** The DataTable rows are automatically deleted after processing. The `CompCode` column defaults to the current company code and only needs to be set if targeting a different company.

## 2002.lib -- Shop Floor Control Tasks (JB0028)

Wraps the numeric callwrapper ID `2002` (Shop Floor Control Tasks / JB0028). Populate the `2002` DataTable with one row per call, then invoke `2002Sync` or `2002Async`.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("2002.lib",False)
Program.Sub.Preflight.End
```

**DataTable Schema** (created automatically in Preflight):

| Column | Parameter | Type | Default | Description |
|--------|-----------|------|---------|-------------|
| `CompCode` | Company Code | String | `V.Caller.CompanyCode` | 3-character company code |
| `Type` | Type | String | | `W` = Work Orders, `S` = Single Job |
| `BegWO` | Beginning Work Order | String | | 6-character work order number |
| `BegSuf` | Beginning Suffix | String | | 3-character work order suffix |
| `EndWO` | Ending Work Order | String | | 6-character work order number |
| `EndSuf` | Ending Suffix | String | | 3-character work order suffix |
| `Term` | Terminal | String | `V.Caller.Terminal` | 3-character terminal number |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s2002Error` | String | Error details if an exception occurs. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (row is 1-based, `-1` if error occurred before row processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `2002Sync` | Runs the 2002 callwrapper synchronously for each row in the DataTable |
| `2002Async` | Runs the 2002 callwrapper asynchronously for each row in the DataTable |

**Usage Pattern:**

```
F.Data.DataTable.AddRow("2002")
F.Data.DataTable.SetValue("2002","Type","W",0)
F.Data.DataTable.SetValue("2002","BegWO","500001",0)
F.Data.DataTable.SetValue("2002","BegSuf","001",0)
F.Data.DataTable.SetValue("2002","EndWO","500010",0)
F.Data.DataTable.SetValue("2002","EndSuf","001",0)
F.Intrinsic.Control.CallSub(2002Sync)
F.Intrinsic.Control.If(V.Global.s2002Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s2002Error,"2002 Error")
F.Intrinsic.Control.EndIf
```

> **Note:** The DataTable rows are automatically deleted after processing. `CompCode` defaults to the current company and `Term` defaults to the current terminal -- only set them if overriding.

## 2003.lib -- WIP to Finished Goods (JB0052GI)

Wraps the numeric callwrapper ID `2003` (WIP to Finished Goods / JB0052GI). Emulates *Shop Floor Control > Transactions > WIP To Finished Goods*. Uses **two linked DataTables**: `2003` for the main WIP-to-FG parameters and `2003File` for lot/bin detail records (screenless mode only).

> **Important:** The file portion (DataTable `2003File`) is for lot/bin records only. You cannot mix lot/bin parts with non-lot/bin parts in the same run.

**Include:**

```
Program.Sub.Preflight.Start
Program.External.Include.Library("2003.lib",False)
Program.Sub.Preflight.End
```

### Main DataTable `2003`

| Column | Parameter | Type | Default | Notes |
|--------|-----------|------|---------|-------|
| `CompanyCode` | Company Code | String | `V.Caller.CompanyCode` | 3-character company code |
| `Terminal` | Terminal | String | `V.Caller.Terminal` | Terminal number |
| `Program` | Calling Program | String | `V.Caller.Caller` | Calling program name |
| `Mode` | Mode | String | `NS` | `NS` = Screenless, `OS` = Open Screen |
| `PassDetailJob` | Pass Detail Job | String | `""` | Used only when no mode specified |
| `PassDetailSuffix` | Pass Detail Suffix | String | `""` | Used only when no mode specified |
| `PassDetailSequence` | Pass Detail Sequence | String | `""` | |
| `PassDetailFill` | Pass Detail Fill | String | `""` | Used only when no mode specified |
| `PassDetailDate` | Pass Detail Date | String | `""` | Used only when no mode specified |
| `PassDetailKeySeq` | Pass Detail Key Sequence | String | `""` | Used only when no mode specified |
| `WONum` | Work Order | String | `""` | 6-character WO number (screenless) |
| `WOSuffix` | Work Order Suffix | String | `""` | 3-character suffix (screenless) |
| `XferYear` | Transfer Date Year | String | `""` | Optional in screenless mode |
| `XferMonth` | Transfer Date Month | String | `""` | Optional in screenless mode |
| `XferDay` | Transfer Date Day | String | `""` | Optional in screenless mode |
| `CloseWO` | Close Work Order Flag | String | `""` | `Y` = Close, `N` = Do not close (screenless) |
| `PartDesc` | Part Description | String | `""` | Optional in screenless mode |
| `Quantity` | Quantity | String | `""` | Screenless mode |
| `Cost` | Cost | String | `""` | Screenless mode |
| `Price` | Price | String | `""` | Screenless mode |
| `PrintLabels` | Print Labels Flag | String | `""` | `Y` / `N` (screenless) |
| `CostMethod` | Cost Method | String | `""` | `E` = Estimate, `P` = Percentage, `I` = Inventory, `L` = Alt Cost, `A` = Actual, `R` = Remaining, `U` = Entered (screenless) |
| `UpdateInv` | Update Inventory Flag | String | `""` | `Y` / `N` (screenless) |
| `InvDebitAcct` | Inventory Debit Account | String | `""` | Screenless mode |

### File DataTable `2003File` (Lot/Bin Detail -- Screenless Mode Only)

Linked to the main `2003` DataTable by `WONum` + `WOSuffix`. Multiple rows can share the same WO/Suffix. Specific quantities must sum to the `Quantity` in the parent `2003` row.

| Column | Type | Description |
|--------|------|-------------|
| `WONum` | String | Work order number (links to `2003` row) |
| `WOSuffix` | String | Work order suffix (links to `2003` row) |
| `Lot` | String | Lot number |
| `Bin` | String | Bin number (valid or empty required) |
| `Heat` | String | Heat number |
| `Serial` | String | Serial number |
| `SpecificQuantity` | String | Quantity for this lot/bin (must sum to parent Quantity) |
| `ExpDate` | String | Expiration date |
| `WarrantyMonths` | String | Warranty months |
| `UserField1` - `UserField9` | String | User-defined fields 1 through 9 |

**Global Variables:**

| Variable | Type | Description |
|----------|------|-------------|
| `V.Global.s2003Error` | String | Error details. Format: `Sub*!*ErrNo*!*ErrDesc*!*MainRow*!*SubRow` (1-based rows, `-1` if before processing). |

**Exposed Subroutines:**

| Subroutine | Description |
|------------|-------------|
| `2003Sync` | Runs the 2003 callwrapper synchronously for each row in the DataTable |
| `2003Async` | Runs the 2003 callwrapper asynchronously for each row in the DataTable |

**How It Works:**

1. For each row in `2003`, if `Mode` = `NS`, the library filters `2003File` by matching `WONum` + `WOSuffix`.
2. If matching file rows exist, they are exported to a tab-delimited file at `{FilesDir}\{Terminal}_2003lib.txt`.
3. The file path (or empty string if no file rows) is appended to the callwrapper parameters.
4. Both DataTables are cleared after processing.
5. In screenless mode, errors are suppressed and returned via `V.Ambient.CallWrapperReturn`.

**Usage Pattern (screenless, no lot/bin file):**

```
F.Data.DataTable.AddRow("2003")
F.Data.DataTable.SetValue("2003","WONum","500003",0)
F.Data.DataTable.SetValue("2003","WOSuffix","001",0)
F.Data.DataTable.SetValue("2003","XferYear","2025",0)
F.Data.DataTable.SetValue("2003","XferMonth","12",0)
F.Data.DataTable.SetValue("2003","XferDay","15",0)
F.Data.DataTable.SetValue("2003","CloseWO","N",0)
F.Data.DataTable.SetValue("2003","Quantity","100",0)
F.Data.DataTable.SetValue("2003","Cost","25.50",0)
F.Data.DataTable.SetValue("2003","Price","50.00",0)
F.Data.DataTable.SetValue("2003","PrintLabels","N",0)
F.Data.DataTable.SetValue("2003","CostMethod","A",0)
F.Data.DataTable.SetValue("2003","UpdateInv","Y",0)
F.Data.DataTable.SetValue("2003","InvDebitAcct","",0)
F.Intrinsic.Control.CallSub(2003Sync)
F.Intrinsic.Control.If(V.Global.s2003Error,<>,"")
    F.Intrinsic.UI.Msgbox(V.Global.s2003Error,"2003 Error")
F.Intrinsic.Control.EndIf
```

**Usage Pattern (screenless, with lot/bin file):**

```
F.Data.DataTable.AddRow("2003")
F.Data.DataTable.SetValue("2003","WONum","500003",0)
F.Data.DataTable.SetValue("2003","WOSuffix","001",0)
F.Data.DataTable.SetValue("2003","Quantity","100",0)
F.Data.DataTable.SetValue("2003","CostMethod","A",0)
F.Data.DataTable.SetValue("2003","UpdateInv","Y",0)
F.Data.DataTable.SetValue("2003","CloseWO","N",0)
F.Data.DataTable.SetValue("2003","PrintLabels","N",0)

F.Data.DataTable.AddRow("2003File")
F.Data.DataTable.SetValue("2003File","WONum","500003",0)
F.Data.DataTable.SetValue("2003File","WOSuffix","001",0)
F.Data.DataTable.SetValue("2003File","Lot","LOT001",0)
F.Data.DataTable.SetValue("2003File","Bin","A1",0)
F.Data.DataTable.SetValue("2003File","SpecificQuantity","60",0)

F.Data.DataTable.AddRow("2003File")
F.Data.DataTable.SetValue("2003File","WONum","500003",1)
F.Data.DataTable.SetValue("2003File","WOSuffix","001",1)
F.Data.DataTable.SetValue("2003File","Lot","LOT002",1)
F.Data.DataTable.SetValue("2003File","Bin","B2",1)
F.Data.DataTable.SetValue("2003File","SpecificQuantity","40",1)

F.Intrinsic.Control.CallSub(2003Sync)
```

> **Note:** Both DataTables are cleared after processing. The error format includes both `MainRow` and `SubRow` indices. In screenless mode, error text is also available via `V.Ambient.CallWrapperReturn`.

---

## 2004.lib

**Wraps:** CallWrapper `2004` — WIP to FG / JB0052GI

> **Important:** This library is an extended variant of `2003.lib`. It adds **Action** support (Normal, Reverse, Auto Reverse) with detail-level fields for reversal, a configurable **FileName** column, and per-row control of costing method and inventory updates. Do **not** mix lot/bin and non-lot/bin parts in the same `2004File` DataTable for a given work order.

**Include:**

```
Program.External.Include.Library("2004.lib",False)
```

**DataTable `2004` Schema (26 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `CompanyCode` | String | `V.Caller.CompanyCode` | Company code |
| `Terminal` | String | `V.Caller.Terminal` | Terminal identifier |
| `CallingProgram` | String | `V.Caller.Caller` | Calling program name |
| `Mode` | String | | `"NS"` = Screenless, `"OS"` = Open Screen |
| `DtlWO` | String | | Detail work order — used when Action = `"R"` |
| `DtlWOSuffix` | String | | Detail work order suffix — used when Action = `"R"` |
| `DtlWOSeq` | String | | Detail work order sequence — used when Action = `"R"` |
| `DtlFill` | String | | Detail fill — used when Action = `"R"` |
| `DtlDate` | String | | Detail date (MMDDYY) — used when Action = `"R"` |
| `DtlKeySeq` | String | | Detail key sequence — used when Action = `"R"` |
| `WO` | String | | Work order number X(6) |
| `WOSuffix` | String | | Work order suffix X(3) |
| `XferYear` | String | | Transfer year (YYYY) |
| `XferMonth` | String | | Transfer month (MM) |
| `XferDay` | String | | Transfer day (DD) |
| `CloseWOFlag` | String | | `"Y"` / `"N"` — close work order after transfer |
| `PartDesc` | String | | Part description X(30) |
| `Qty` | String | | Quantity (8.4) |
| `Cost` | String | | Cost (8.4) |
| `Price` | String | | Price (8.4) |
| `PrintLabelsFlag` | String | | `"Y"` / `"N"` — print labels |
| `CostMethod` | String | | Costing method enum (see below) |
| `UpdateInventoryFlag` | String | | `"Y"` / `"N"` — update inventory |
| `InventoryDebitAccount` | String | | Inventory debit GL account X(15) |
| `FileName` | String | `{FilesDir}\{CCC}{TTT}2004.txt` | Lot/bin file path (auto-built from CompanyCode + Terminal) |
| `Action` | String | | `" "` = Normal, `"R"` = Reverse, `"A"` = Auto Reverse |

**CostMethod Enum:**

| Value | Description |
|---|---|
| `"E"` | Estimate |
| `"P"` | Percentage |
| `"I"` | Inventory |
| `"L"` | Alternate |
| `"A"` | Actual |
| `"R"` | Remaining |
| `"U"` | Manual |

**DataTable `2004File` Schema (18 columns):**

The `2004File` DataTable links to `2004` on `WO` + `WOSuffix`. For each lot/bin detail line, add a row to `2004File`.

| Column | Type | Description |
|---|---|---|
| `WO` | String | Work order X(6) — matches `2004.WO` |
| `WOSuffix` | String | Work order suffix X(3) — matches `2004.WOSuffix` |
| `Lot` | String | Lot number X(15) |
| `Bin` | String | Bin number X(6) |
| `Heat` | String | Heat number X(15) |
| `Serial` | String | Serial number X(30) |
| `Qty` | String | Quantity (8.4) |
| `ExpDate` | String | Expiration date (YYYYMMDD) |
| `Warranty` | String | Warranty months 9(3) |
| `UserField1` | String | User field 1 X(15) |
| `UserField2` | String | User field 2 X(15) |
| `UserField3` | String | User field 3 X(15) |
| `UserField4` | String | User field 4 X(15) |
| `UserField5` | String | User field 5 X(15) |
| `UserField6` | String | User field 6 X(15) |
| `UserField7` | String | User field 7 X(15) |
| `UserField8` | String | User field 8 X(15) |
| `UserField9` | String | User field 9 X(15) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s2004Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |
| `V.Global.s2004FileName` | Auto-built filename: `{CompanyCode}{Terminal}2004.txt` |
| `V.Global.s2004FilePath` | Auto-built full path: `{FilesDir}\{s2004FileName}` |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `2004Sync` | Runs callwrapper `2004` synchronously for each DataTable row |
| `2004Async` | Runs callwrapper `2004` asynchronously for each DataTable row |

**How It Works:**

1. On include, the library declares `V.Global.s2004Error`, `V.Global.s2004FileName`, and `V.Global.s2004FilePath`. It auto-builds the default file path as `{FilesDir}\{CompanyCode}{Terminal}2004.txt`.
2. DataTables `2004` (26 columns) and `2004File` (18 columns) are created. `CompanyCode`, `Terminal`, `CallingProgram`, and `FileName` receive automatic defaults.
3. When `2004Sync` or `2004Async` is called, the library iterates each row of the `2004` DataTable.
4. For each row, a `DataView` filters `2004File` by matching `WO` and `WOSuffix`. If matching file rows exist, they are written as a tab-delimited file (columns: `Lot` through `UserField9`) to the path in `FileName`.
5. All 26 columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `2004`.
6. After processing, all rows are deleted from the `2004` DataTable. On error, `V.Global.s2004Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (screenless, normal transfer, no lot/bin file):**

```
Program.External.Include.Library("2004.lib",False)

F.Data.DataTable.AddRow("2004")
F.Data.DataTable.SetValue("2004","Mode","NS",0)
F.Data.DataTable.SetValue("2004","WO","100200",0)
F.Data.DataTable.SetValue("2004","WOSuffix","001",0)
F.Data.DataTable.SetValue("2004","XferYear","2026",0)
F.Data.DataTable.SetValue("2004","XferMonth","03",0)
F.Data.DataTable.SetValue("2004","XferDay","21",0)
F.Data.DataTable.SetValue("2004","CloseWOFlag","Y",0)
F.Data.DataTable.SetValue("2004","Qty","50",0)
F.Data.DataTable.SetValue("2004","CostMethod","A",0)
F.Data.DataTable.SetValue("2004","UpdateInventoryFlag","Y",0)
F.Data.DataTable.SetValue("2004","Action"," ",0)

F.Intrinsic.Control.CallSub(2004Sync)
```

**Usage Pattern (reverse a prior transaction):**

```
Program.External.Include.Library("2004.lib",False)

F.Data.DataTable.AddRow("2004")
F.Data.DataTable.SetValue("2004","Mode","NS",0)
F.Data.DataTable.SetValue("2004","DtlWO","100200",0)
F.Data.DataTable.SetValue("2004","DtlWOSuffix","001",0)
F.Data.DataTable.SetValue("2004","DtlWOSeq","000001",0)
F.Data.DataTable.SetValue("2004","DtlFill","A",0)
F.Data.DataTable.SetValue("2004","DtlDate","032126",0)
F.Data.DataTable.SetValue("2004","DtlKeySeq","0001",0)
F.Data.DataTable.SetValue("2004","WO","100200",0)
F.Data.DataTable.SetValue("2004","WOSuffix","001",0)
F.Data.DataTable.SetValue("2004","Action","R",0)

F.Intrinsic.Control.CallSub(2004Sync)
```

**Usage Pattern (with lot/bin file):**

```
Program.External.Include.Library("2004.lib",False)

F.Data.DataTable.AddRow("2004")
F.Data.DataTable.SetValue("2004","Mode","NS",0)
F.Data.DataTable.SetValue("2004","WO","500003",0)
F.Data.DataTable.SetValue("2004","WOSuffix","001",0)
F.Data.DataTable.SetValue("2004","XferYear","2026",0)
F.Data.DataTable.SetValue("2004","XferMonth","03",0)
F.Data.DataTable.SetValue("2004","XferDay","21",0)
F.Data.DataTable.SetValue("2004","CloseWOFlag","N",0)
F.Data.DataTable.SetValue("2004","Qty","100",0)
F.Data.DataTable.SetValue("2004","CostMethod","E",0)
F.Data.DataTable.SetValue("2004","UpdateInventoryFlag","Y",0)
F.Data.DataTable.SetValue("2004","Action"," ",0)

F.Data.DataTable.AddRow("2004File")
F.Data.DataTable.SetValue("2004File","WO","500003",0)
F.Data.DataTable.SetValue("2004File","WOSuffix","001",0)
F.Data.DataTable.SetValue("2004File","Lot","LOT001",0)
F.Data.DataTable.SetValue("2004File","Bin","A1",0)
F.Data.DataTable.SetValue("2004File","Qty","60",0)

F.Data.DataTable.AddRow("2004File")
F.Data.DataTable.SetValue("2004File","WO","500003",1)
F.Data.DataTable.SetValue("2004File","WOSuffix","001",1)
F.Data.DataTable.SetValue("2004File","Lot","LOT002",1)
F.Data.DataTable.SetValue("2004File","Bin","B2",1)
F.Data.DataTable.SetValue("2004File","Qty","40",1)

F.Intrinsic.Control.CallSub(2004Sync)
```

> **Note:** Both DataTables are cleared after processing. The `FileName` column defaults to `{FilesDir}\{CompanyCode}{Terminal}2004.txt` but can be overridden per row. On error, `V.Global.s2004Error` is set; row index is 1-based (or `-1` for a wrapper-level error). In screenless mode, error text is also available via `V.Ambient.CallWrapperReturn`.

---

## 2005.lib -- Commit Router Material (JB0056GI)

**Wraps:** CallWrapper `2005` — Commit Router Material / JB0056GI

**Include:**

```
Program.External.Include.Library("2005.lib",False)
```

**DataTable `2005` Schema (3 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `Job` | String | | Job number — 6 characters |
| `Suffix` | String | | Job suffix — 3 characters |
| `Seq` | String | | Sequence number — 6 characters |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s2005Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `2005Sync` | Runs callwrapper `2005` synchronously for each DataTable row |
| `2005Async` | Runs callwrapper `2005` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s2005Error` is declared and the `2005` DataTable is created with 3 columns.
2. When `2005Sync` or `2005Async` is called, the library iterates each row of the `2005` DataTable.
3. For each row, the three columns (`Job`, `Suffix`, `Seq`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `2005`.
4. After processing, all rows are deleted from the `2005` DataTable. On error, `V.Global.s2005Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("2005.lib",False)

F.Data.DataTable.AddRow("2005")
F.Data.DataTable.SetValue("2005","Job","100200",0)
F.Data.DataTable.SetValue("2005","Suffix","001",0)
F.Data.DataTable.SetValue("2005","Seq","000010",0)

F.Data.DataTable.AddRow("2005")
F.Data.DataTable.SetValue("2005","Job","100200",1)
F.Data.DataTable.SetValue("2005","Suffix","001",1)
F.Data.DataTable.SetValue("2005","Seq","000020",1)

F.Intrinsic.Control.CallSub(2005Sync)
```

> **Note:** The DataTable is cleared after processing. On error, `V.Global.s2005Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 2007.lib -- New/Edit/View Work Order (JB0010GI)

**Wraps:** CallWrapper `2007` — New/Edit/View Work Order / JB0010GI

**Include:**

```
Program.External.Include.Library("2007.lib",False)
```

**DataTable `2007` Schema (3 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `WO` | String | | Work order number — 6 digits |
| `WOSuffix` | String | | Work order suffix — 3 digits |
| `Switch` | String | | Program switch enum (see below) |

**Switch Enum:**

| Value | Description |
|---|---|
| `"O"` | Open (edit) an existing work order |
| `"N"` | Create a new work order |
| `"V"` | View an existing work order (read-only) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s2007Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `2007Sync` | Runs callwrapper `2007` synchronously for each DataTable row |
| `2007Async` | Runs callwrapper `2007` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s2007Error` is declared and the `2007` DataTable is created with 3 columns.
2. When `2007Sync` or `2007Async` is called, the library iterates each row of the `2007` DataTable.
3. For each row, the three columns (`WO`, `WOSuffix`, `Switch`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `2007`.
4. After processing, all rows are deleted from the `2007` DataTable. On error, `V.Global.s2007Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (open a work order for editing):**

```
Program.External.Include.Library("2007.lib",False)

F.Data.DataTable.AddRow("2007")
F.Data.DataTable.SetValue("2007","WO","100200",0)
F.Data.DataTable.SetValue("2007","WOSuffix","001",0)
F.Data.DataTable.SetValue("2007","Switch","O",0)

F.Intrinsic.Control.CallSub(2007Sync)
```

**Usage Pattern (view a work order read-only):**

```
Program.External.Include.Library("2007.lib",False)

F.Data.DataTable.AddRow("2007")
F.Data.DataTable.SetValue("2007","WO","100200",0)
F.Data.DataTable.SetValue("2007","WOSuffix","001",0)
F.Data.DataTable.SetValue("2007","Switch","V",0)

F.Intrinsic.Control.CallSub(2007Sync)
```

> **Note:** The DataTable is cleared after processing. For `"N"` (new), `WO` and `WOSuffix` identify the work order to create. For `"O"` (open) and `"V"` (view), they identify the existing work order to open or view. On error, `V.Global.s2007Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 2009.lib -- New/Edit/Copy/View Work Order (JB0010GI)

**Wraps:** CallWrapper `2009` — New/Edit/Copy/View Work Order / JB0010GI

> **Note:** This library wraps the same core program (JB0010GI) as `2007.lib` but adds a `"C"` (Copy) switch value. The first DataTable column is named `WONum` (not `WO` as in `2007.lib`).

**Include:**

```
Program.External.Include.Library("2009.lib",False)
```

**DataTable `2009` Schema (3 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `WONum` | String | | Work order number — 6 digits |
| `WOSuffix` | String | | Work order suffix — 3 digits |
| `Switch` | String | | Program switch enum (see below) |

**Switch Enum:**

| Value | Description |
|---|---|
| `"O"` | Open (edit) an existing work order |
| `"N"` | Create a new work order |
| `"C"` | Copy an existing work order |
| `"V"` | View an existing work order (read-only) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s2009Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `2009Sync` | Runs callwrapper `2009` synchronously for each DataTable row |
| `2009Async` | Runs callwrapper `2009` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s2009Error` is declared and the `2009` DataTable is created with 3 columns.
2. When `2009Sync` or `2009Async` is called, the library iterates each row of the `2009` DataTable.
3. For each row, the three columns (`WONum`, `WOSuffix`, `Switch`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `2009`.
4. After processing, all rows are deleted from the `2009` DataTable. On error, `V.Global.s2009Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (open a work order for editing):**

```
Program.External.Include.Library("2009.lib",False)

F.Data.DataTable.AddRow("2009")
F.Data.DataTable.SetValue("2009","WONum","100200",0)
F.Data.DataTable.SetValue("2009","WOSuffix","001",0)
F.Data.DataTable.SetValue("2009","Switch","O",0)

F.Intrinsic.Control.CallSub(2009Sync)
```

**Usage Pattern (copy a work order):**

```
Program.External.Include.Library("2009.lib",False)

F.Data.DataTable.AddRow("2009")
F.Data.DataTable.SetValue("2009","WONum","100200",0)
F.Data.DataTable.SetValue("2009","WOSuffix","001",0)
F.Data.DataTable.SetValue("2009","Switch","C",0)

F.Intrinsic.Control.CallSub(2009Sync)
```

> **Note:** The DataTable is cleared after processing. The column name is `WONum` (not `WO`). On error, `V.Global.s2009Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3000.lib -- Customer Order Notes (AR002CN)

**Wraps:** CallWrapper `3000` — Customer Order Notes / AR002CN

**Include:**

```
Program.External.Include.Library("3000.lib",False)
```

**DataTable `3000` Schema (4 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `CustID` | String | | Customer ID |
| `CustName` | String | | Customer name |
| `Mode` | String | | Access mode enum (see below) |
| `Type` | String | | Record type enum (see below) |

**Mode Enum:**

| Value | Description |
|---|---|
| `"CU"` | Customer Update — open notes for editing |
| `"CV"` | Customer View — open notes read-only |
| `"OV"` | Order View — view order-level notes |

**Type Enum:**

| Value | Description |
|---|---|
| `"C"` | Customer |
| `"P"` | Prospect |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3000Sync` | Runs callwrapper `3000` synchronously for each DataTable row |
| `3000Async` | Runs callwrapper `3000` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3000Error` is declared and the `3000` DataTable is created with 4 columns.
2. When `3000Sync` or `3000Async` is called, the library iterates each row of the `3000` DataTable.
3. For each row, all four columns (`CustID`, `CustName`, `Mode`, `Type`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3000`.
4. After processing, all rows are deleted from the `3000` DataTable. On error, `V.Global.s3000Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (update customer notes):**

```
Program.External.Include.Library("3000.lib",False)

F.Data.DataTable.AddRow("3000")
F.Data.DataTable.SetValue("3000","CustID","ACME01",0)
F.Data.DataTable.SetValue("3000","CustName","Acme Corporation",0)
F.Data.DataTable.SetValue("3000","Mode","CU",0)
F.Data.DataTable.SetValue("3000","Type","C",0)

F.Intrinsic.Control.CallSub(3000Sync)
```

**Usage Pattern (view prospect order notes):**

```
Program.External.Include.Library("3000.lib",False)

F.Data.DataTable.AddRow("3000")
F.Data.DataTable.SetValue("3000","CustID","PROS01",0)
F.Data.DataTable.SetValue("3000","CustName","Prospect Industries",0)
F.Data.DataTable.SetValue("3000","Mode","OV",0)
F.Data.DataTable.SetValue("3000","Type","P",0)

F.Intrinsic.Control.CallSub(3000Sync)
```

> **Note:** The DataTable is cleared after processing. All four columns (`CustID`, `CustName`, `Mode`, `Type`) are required for each row. On error, `V.Global.s3000Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3010.lib -- Contract Part Pricing (ORD231)

**Wraps:** CallWrapper `3010` — Contract Part Pricing / ORD231

> **Important:** When `AllCustomersFlag` is set to `"I"` (Include Ranges) or `"X"` (Exclude Ranges), screenless mode is automatically disabled and the screen opens so the user can specify the customer ranges interactively. Only `"A"` (All Customers) keeps execution fully screenless.

**Include:**

```
Program.External.Include.Library("3010.lib",False)
```

**DataTable `3010` Schema (6 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `Mode` | String | | Execution mode enum (see below) |
| `Date` | String | | Effective date in MMDDYYYY format; if `"0"` or empty, current date is used |
| `PrintFlag` | String | | Print modified rate tables — `"Y"` / `"N"` |
| `NumDates` | String | | Number of effective dates to print |
| `GenerateFlag` | String | | Generate open order price update transactions — `"Y"` / `"N"` |
| `AllCustomersFlag` | String | | Customer selection enum (see below) |

**Mode Enum:**

| Value | Description |
|---|---|
| `"PS"` | Populate the screen (interactive) |
| `"NS"` | Screenless mode |

**AllCustomersFlag Enum:**

| Value | Description |
|---|---|
| `"A"` | All Customers — fully screenless when Mode = `"NS"` |
| `"I"` | Include Ranges — forces screen open for range selection (overrides `"NS"`) |
| `"X"` | Exclude Ranges — forces screen open for range selection (overrides `"NS"`) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3010Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3010Sync` | Runs callwrapper `3010` synchronously for each DataTable row |
| `3010Async` | Runs callwrapper `3010` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3010Error` is declared and the `3010` DataTable is created with 6 columns.
2. When `3010Sync` or `3010Async` is called, the library iterates each row of the `3010` DataTable.
3. For each row, all six columns (`Mode`, `Date`, `PrintFlag`, `NumDates`, `GenerateFlag`, `AllCustomersFlag`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3010`.
4. After processing, all rows are deleted from the `3010` DataTable. On error, `V.Global.s3010Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (screenless, all customers):**

```
Program.External.Include.Library("3010.lib",False)

F.Data.DataTable.AddRow("3010")
F.Data.DataTable.SetValue("3010","Mode","NS",0)
F.Data.DataTable.SetValue("3010","Date","03212026",0)
F.Data.DataTable.SetValue("3010","PrintFlag","Y",0)
F.Data.DataTable.SetValue("3010","NumDates","1",0)
F.Data.DataTable.SetValue("3010","GenerateFlag","Y",0)
F.Data.DataTable.SetValue("3010","AllCustomersFlag","A",0)

F.Intrinsic.Control.CallSub(3010Sync)
```

**Usage Pattern (populate screen, include ranges):**

```
Program.External.Include.Library("3010.lib",False)

F.Data.DataTable.AddRow("3010")
F.Data.DataTable.SetValue("3010","Mode","PS",0)
F.Data.DataTable.SetValue("3010","Date","0",0)
F.Data.DataTable.SetValue("3010","PrintFlag","N",0)
F.Data.DataTable.SetValue("3010","NumDates","3",0)
F.Data.DataTable.SetValue("3010","GenerateFlag","N",0)
F.Data.DataTable.SetValue("3010","AllCustomersFlag","I",0)

F.Intrinsic.Control.CallSub(3010Sync)
```

> **Note:** The DataTable is cleared after processing. Setting `Date` to `"0"` uses the current date. On error, `V.Global.s3010Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3050.lib -- Print Customer Statements (AR0140GI)

**Wraps:** CallWrapper `3050` — Print Customer Statements / AR0140GI

**Include:**

```
Program.External.Include.Library("3050.lib",False)
```

**DataTable `3050` Schema (11 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `Start` | String | | Beginning customer ID (7 characters) |
| `End` | String | | Ending customer ID (7 characters) |
| `Date` | String | | Aging date (MMDDYY) |
| `Attn` | String | | Print attention line — `"Y"` / `"N"` |
| `Country` | String | | Print country — `"Y"` / `"N"` |
| `Total` | String | | Print total page — `"Y"` / `"N"` |
| `HdgDate` | String | | Report heading date (MMDDYY) |
| `BegBranch` | String | | Beginning branch code (2 characters) |
| `EndBranch` | String | | Ending branch code (2 characters) |
| `BranchFlag` | String | | Select by branch — `"Y"` / `"N"` |
| `PrintZero` | String | | Print zero balance statements — `"Y"` / `"N"` |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3050Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3050Sync` | Runs callwrapper `3050` synchronously for each DataTable row |
| `3050Async` | Runs callwrapper `3050` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3050Error` is declared and the `3050` DataTable is created with 11 columns.
2. When `3050Sync` or `3050Async` is called, the library iterates each row of the `3050` DataTable.
3. For each row, all eleven columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3050`.
4. After processing, all rows are deleted from the `3050` DataTable. On error, `V.Global.s3050Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (all customers, no branch filter):**

```
Program.External.Include.Library("3050.lib",False)

F.Data.DataTable.AddRow("3050")
F.Data.DataTable.SetValue("3050","Start","0000001",0)
F.Data.DataTable.SetValue("3050","End","9999999",0)
F.Data.DataTable.SetValue("3050","Date","032126",0)
F.Data.DataTable.SetValue("3050","Attn","Y",0)
F.Data.DataTable.SetValue("3050","Country","N",0)
F.Data.DataTable.SetValue("3050","Total","Y",0)
F.Data.DataTable.SetValue("3050","HdgDate","032126",0)
F.Data.DataTable.SetValue("3050","BegBranch","",0)
F.Data.DataTable.SetValue("3050","EndBranch","",0)
F.Data.DataTable.SetValue("3050","BranchFlag","N",0)
F.Data.DataTable.SetValue("3050","PrintZero","N",0)

F.Intrinsic.Control.CallSub(3050Sync)
```

**Usage Pattern (branch-filtered range):**

```
Program.External.Include.Library("3050.lib",False)

F.Data.DataTable.AddRow("3050")
F.Data.DataTable.SetValue("3050","Start","ACME001",0)
F.Data.DataTable.SetValue("3050","End","ACME999",0)
F.Data.DataTable.SetValue("3050","Date","033126",0)
F.Data.DataTable.SetValue("3050","Attn","N",0)
F.Data.DataTable.SetValue("3050","Country","N",0)
F.Data.DataTable.SetValue("3050","Total","Y",0)
F.Data.DataTable.SetValue("3050","HdgDate","033126",0)
F.Data.DataTable.SetValue("3050","BegBranch","01",0)
F.Data.DataTable.SetValue("3050","EndBranch","05",0)
F.Data.DataTable.SetValue("3050","BranchFlag","Y",0)
F.Data.DataTable.SetValue("3050","PrintZero","Y",0)

F.Intrinsic.Control.CallSub(3050Sync)
```

> **Note:** The DataTable is cleared after processing. When `BranchFlag` is `"N"`, `BegBranch` and `EndBranch` are ignored. On error, `V.Global.s3050Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3200.lib -- Purchase Order Receipt (PUR100GI)

**Wraps:** CallWrapper `3200` — Purchase Order Receipt / PUR100GI

> **Note:** This library passes the PO number directly to the callwrapper without `ConcatCallWrapperArgs` since there is only a single parameter.

**Include:**

```
Program.External.Include.Library("3200.lib",False)
```

**DataTable `3200` Schema (1 column):**

| Column | Type | Default | Description |
|---|---|---|---|
| `PO` | String | | Purchase order number (7 characters) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3200Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3200Sync` | Runs callwrapper `3200` synchronously for each DataTable row |
| `3200Async` | Runs callwrapper `3200` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3200Error` is declared and the `3200` DataTable is created with 1 column.
2. When `3200Sync` or `3200Async` is called, the library iterates each row of the `3200` DataTable.
3. For each row, the `PO` value is passed directly to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3200`.
4. After processing, all rows are deleted from the `3200` DataTable. On error, `V.Global.s3200Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("3200.lib",False)

F.Data.DataTable.AddRow("3200")
F.Data.DataTable.SetValue("3200","PO","0012345",0)

F.Data.DataTable.AddRow("3200")
F.Data.DataTable.SetValue("3200","PO","0012346",1)

F.Intrinsic.Control.CallSub(3200Sync)
```

> **Note:** The DataTable is cleared after processing. On error, `V.Global.s3200Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3500.lib -- Inventory Maintenance (INVMAIN)

**Wraps:** CallWrapper `3500` — Inventory Maintenance / INVMAIN

**Include:**

```
Program.External.Include.Library("3500.lib",False)
```

**DataTable `3500` Schema (6 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `CompanyCode` | String | | Company code |
| `Mode` | String | | Part operation mode enum (see below) |
| `Switch2` | String | | Secondary switch enum (see below) |
| `Switch3` | String | | Tertiary switch enum (see below) |
| `Part` | String | | Part number |
| `Loc` | String | `"  "` (two spaces) | Part location — leave default if part has no location |

**Mode Enum:**

| Value | Description |
|---|---|
| `"N"` | New part |
| `"C"` | Copy part |
| `"D"` | Delete part |
| `"V"` | View part |
| `"O"` | Open (edit) part |
| `"L"` | View mode with lead time unprotected |
| `"E"` | View mode with product line, description, UM, and Pur UM unprotected |
| `"P"` | View mode with source, order qty, sort, and reorder unprotected |

**Switch2 Enum:**

| Value | Description |
|---|---|
| `"D"` | Pull up the part options screen |
| `"U"` | Prevent reorder from being disabled |
| `"N"` | Screenless mode (for delete only) |

**Switch3 Enum:**

| Value | Description |
|---|---|
| `"S"` | Show cost regardless of company option setting |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3500Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3500Sync` | Runs callwrapper `3500` synchronously for each DataTable row |
| `3500Async` | Runs callwrapper `3500` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3500Error` is declared and the `3500` DataTable is created with 6 columns. The `Loc` column defaults to two spaces.
2. When `3500Sync` or `3500Async` is called, the library iterates each row of the `3500` DataTable.
3. For each row, all six columns (`CompanyCode`, `Mode`, `Switch2`, `Switch3`, `Part`, `Loc`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3500`.
4. After processing, all rows are deleted from the `3500` DataTable. On error, `V.Global.s3500Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (open a part for editing):**

```
Program.External.Include.Library("3500.lib",False)

F.Data.DataTable.AddRow("3500")
F.Data.DataTable.SetValue("3500","CompanyCode","01",0)
F.Data.DataTable.SetValue("3500","Mode","O",0)
F.Data.DataTable.SetValue("3500","Switch2","",0)
F.Data.DataTable.SetValue("3500","Switch3","",0)
F.Data.DataTable.SetValue("3500","Part","WIDGET-100",0)
F.Data.DataTable.SetValue("3500","Loc","WH",0)

F.Intrinsic.Control.CallSub(3500Sync)
```

**Usage Pattern (screenless delete, no location):**

```
Program.External.Include.Library("3500.lib",False)

F.Data.DataTable.AddRow("3500")
F.Data.DataTable.SetValue("3500","CompanyCode","01",0)
F.Data.DataTable.SetValue("3500","Mode","D",0)
F.Data.DataTable.SetValue("3500","Switch2","N",0)
F.Data.DataTable.SetValue("3500","Switch3","",0)
F.Data.DataTable.SetValue("3500","Part","OBSOL-999",0)

F.Intrinsic.Control.CallSub(3500Sync)
```

> **Note:** The DataTable is cleared after processing. The `Loc` column defaults to two spaces and does not need to be set if the part has no location. Switch2 `"N"` (screenless) is only valid when Mode is `"D"` (delete). On error, `V.Global.s3500Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3550.lib -- Stand-Alone Issue/Receipts (INV220GI)

**Wraps:** CallWrapper `3550` — Stand-Alone Issue/Receipts / INV220GI

**Include:**

```
Program.External.Include.Library("3550.lib",False)
```

**DataTable `3550` Schema (7 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `CompanyCode` | String | | Company code |
| `Terminal` | String | | Terminal identifier |
| `CallingProgram` | String | | Calling program name |
| `UserID` | String | | User ID |
| `Mode` | String | `""` | Reserved for future use — leave empty |
| `Order` | String | | Sales order number |
| `Line` | String | | Sales order line number |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3550Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3550Sync` | Runs callwrapper `3550` synchronously for each DataTable row |
| `3550Async` | Runs callwrapper `3550` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3550Error` is declared and the `3550` DataTable is created with 7 columns. The `Mode` column defaults to an empty string.
2. When `3550Sync` or `3550Async` is called, the library iterates each row of the `3550` DataTable.
3. For each row, all seven columns (`CompanyCode`, `Terminal`, `CallingProgram`, `UserID`, `Mode`, `Order`, `Line`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3550`.
4. After processing, all rows are deleted from the `3550` DataTable. On error, `V.Global.s3550Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("3550.lib",False)

F.Data.DataTable.AddRow("3550")
F.Data.DataTable.SetValue("3550","CompanyCode",V.Caller.CompanyCode,0)
F.Data.DataTable.SetValue("3550","Terminal",V.Caller.Terminal,0)
F.Data.DataTable.SetValue("3550","CallingProgram",V.Caller.Caller,0)
F.Data.DataTable.SetValue("3550","UserID",V.Caller.UserID,0)
F.Data.DataTable.SetValue("3550","Order","123456",0)
F.Data.DataTable.SetValue("3550","Line","001",0)

F.Intrinsic.Control.CallSub(3550Sync)
```

> **Note:** The DataTable is cleared after processing. The `Mode` column is reserved for future use and can be left at its empty default. On error, `V.Global.s3550Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3600.lib -- Engineering Change Control (ENG002)

**Wraps:** CallWrapper `3600` — Maintain Engineering Change Control / ENG002

**Include:**

```
Program.External.Include.Library("3600.lib",False)
```

**DataTable `3600` Schema (3 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `CompanyCode` | String | `V.Caller.CompanyCode` | Company code |
| `Prefix` | String | | ECC prefix — 1 character |
| `Num` | String | | ECC number — 8 characters |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3600Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3600Sync` | Runs callwrapper `3600` synchronously for each DataTable row |
| `3600Async` | Runs callwrapper `3600` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3600Error` is declared and the `3600` DataTable is created with 3 columns. `CompanyCode` defaults to `V.Caller.CompanyCode`.
2. When `3600Sync` or `3600Async` is called, the library iterates each row of the `3600` DataTable.
3. For each row, all three columns (`CompanyCode`, `Prefix`, `Num`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3600`.
4. After processing, all rows are deleted from the `3600` DataTable. On error, `V.Global.s3600Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("3600.lib",False)

F.Data.DataTable.AddRow("3600")
F.Data.DataTable.SetValue("3600","Prefix","E",0)
F.Data.DataTable.SetValue("3600","Num","00001234",0)

F.Intrinsic.Control.CallSub(3600Sync)
```

> **Note:** The DataTable is cleared after processing. `CompanyCode` defaults to the current company code and typically does not need to be set. On error, `V.Global.s3600Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3601.lib -- Engineering Change Control Signoff (ENG003)

**Wraps:** CallWrapper `3601` — Engineering Change Control Signoff / ENG003

**Include:**

```
Program.External.Include.Library("3601.lib",False)
```

**DataTable `3601` Schema (4 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `CompCode` | String | `V.Caller.CompanyCode` | Company code |
| `Prefix` | String | | ECC prefix |
| `Num` | String | | ECC number |
| `Part` | String | | Part number to sign off |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3601Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3601Sync` | Runs callwrapper `3601` synchronously for each DataTable row |
| `3601Async` | Runs callwrapper `3601` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3601Error` is declared and the `3601` DataTable is created with 4 columns. `CompCode` defaults to `V.Caller.CompanyCode`.
2. When `3601Sync` or `3601Async` is called, the library iterates each row of the `3601` DataTable.
3. For each row, all four columns (`CompCode`, `Prefix`, `Num`, `Part`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3601`.
4. After processing, all rows are deleted from the `3601` DataTable. On error, `V.Global.s3601Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("3601.lib",False)

F.Data.DataTable.AddRow("3601")
F.Data.DataTable.SetValue("3601","Prefix","E",0)
F.Data.DataTable.SetValue("3601","Num","00001234",0)
F.Data.DataTable.SetValue("3601","Part","WIDGET-100",0)

F.Intrinsic.Control.CallSub(3601Sync)
```

> **Note:** The DataTable is cleared after processing. `CompCode` defaults to the current company code and typically does not need to be set. The column is named `CompCode` (not `CompanyCode` as in `3600.lib`). On error, `V.Global.s3601Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 3801.lib -- Update Quote (QTE003GI)

**Wraps:** CallWrapper `3801` — Update Quote / QTE003GI

**Include:**

```
Program.External.Include.Library("3801.lib",False)
```

**DataTable `3801` Schema (4 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `Quote` | String | | Quote number (7 characters) |
| `Line` | String | | Line number (3 characters) |
| `Screenless` | String | | Screenless mode enum (see below) |
| `WLCloseMode` | String | | Win/Loss/Close mode enum (see below) |

**Screenless Enum:**

| Value | Description |
|---|---|
| `"Y"` | Screenless mode |
| `"G"` | GAB screen mode |
| `"N"` | Not screenless (interactive) |

**WLCloseMode Enum:**

| Value | Description |
|---|---|
| `"W"` | Won — mark all lines as won |
| `"L"` | Lost — mark all lines as lost |
| `"C"` | Close — close all lines |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s3801Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `3801Sync` | Runs callwrapper `3801` synchronously for each DataTable row |
| `3801Async` | Runs callwrapper `3801` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s3801Error` is declared and the `3801` DataTable is created with 4 columns.
2. When `3801Sync` or `3801Async` is called, the library iterates each row of the `3801` DataTable.
3. For each row, all four columns (`Quote`, `Line`, `Screenless`, `WLCloseMode`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `3801`.
4. After processing, all rows are deleted from the `3801` DataTable. On error, `V.Global.s3801Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (screenless, mark quote as won):**

```
Program.External.Include.Library("3801.lib",False)

F.Data.DataTable.AddRow("3801")
F.Data.DataTable.SetValue("3801","Quote","0001234",0)
F.Data.DataTable.SetValue("3801","Line","001",0)
F.Data.DataTable.SetValue("3801","Screenless","Y",0)
F.Data.DataTable.SetValue("3801","WLCloseMode","W",0)

F.Intrinsic.Control.CallSub(3801Sync)
```

**Usage Pattern (interactive, close all lines):**

```
Program.External.Include.Library("3801.lib",False)

F.Data.DataTable.AddRow("3801")
F.Data.DataTable.SetValue("3801","Quote","0005678",0)
F.Data.DataTable.SetValue("3801","Line","001",0)
F.Data.DataTable.SetValue("3801","Screenless","N",0)
F.Data.DataTable.SetValue("3801","WLCloseMode","C",0)

F.Intrinsic.Control.CallSub(3801Sync)
```

> **Note:** The DataTable is cleared after processing. `WLCloseMode` applies to all lines on the quote. On error, `V.Global.s3801Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 4010.lib -- New Shipments (ORD098)

**Wraps:** CallWrapper `4010` — New Shipments / ORD098

> **Note:** This library passes the order number directly to the callwrapper without `ConcatCallWrapperArgs` since there is only a single parameter.

**Include:**

```
Program.External.Include.Library("4010.lib",False)
```

**DataTable `4010` Schema (1 column):**

| Column | Type | Default | Description |
|---|---|---|---|
| `OrdNo` | String | | Sales order number (7 characters) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s4010Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `4010Sync` | Runs callwrapper `4010` synchronously for each DataTable row |
| `4010Async` | Runs callwrapper `4010` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s4010Error` is declared and the `4010` DataTable is created with 1 column.
2. When `4010Sync` or `4010Async` is called, the library iterates each row of the `4010` DataTable.
3. For each row, the `OrdNo` value is passed directly to `F.Global.General.CallWrapperSync` (or `Async`) with ID `4010`.
4. After processing, all rows are deleted from the `4010` DataTable. On error, `V.Global.s4010Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("4010.lib",False)

F.Data.DataTable.AddRow("4010")
F.Data.DataTable.SetValue("4010","OrdNo","0012345",0)

F.Data.DataTable.AddRow("4010")
F.Data.DataTable.SetValue("4010","OrdNo","0012346",1)

F.Intrinsic.Control.CallSub(4010Sync)
```

> **Note:** The DataTable is cleared after processing. On error, `V.Global.s4010Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 5000.lib -- Edit Flex Schedule (JB0098)

**Wraps:** CallWrapper `5000` — Edit Flex Schedule / JB0098

> **Important:** When called synchronously via `5000Sync`, this library captures the `V.Ambient.CallWrapperReturn` value from each row and accumulates them in `V.Global.s5000Return`, delimited by `&5000R&`. When called asynchronously via `5000Async`, return values are not captured.

**Include:**

```
Program.External.Include.Library("5000.lib",False)
```

**DataTable `5000` Schema (3 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `Mode` | String | | Access mode enum (see below) |
| `Schedule` | String | | Schedule number (6 digits) |
| `Suffix` | String | | Schedule suffix (3 digits) |

**Mode Enum:**

| Value | Description |
|---|---|
| `"VW"` | View only (read-only) |
| `"OP"` or `" "` | Open (edit) |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s5000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |
| `V.Global.s5000Return` | `&5000R&`-delimited string of `V.Ambient.CallWrapperReturn` values (sync only) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `5000Sync` | Runs callwrapper `5000` synchronously for each DataTable row; captures return values |
| `5000Async` | Runs callwrapper `5000` asynchronously for each DataTable row; no return capture |

**How It Works:**

1. On include, `V.Global.s5000Error` and `V.Global.s5000Return` are declared, and the `5000` DataTable is created with 3 columns.
2. When `5000Sync` or `5000Async` is called, the library iterates each row of the `5000` DataTable.
3. For each row, all three columns (`Mode`, `Schedule`, `Suffix`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `5000`.
4. **Sync only:** After each synchronous call, `V.Ambient.CallWrapperReturn` is appended to `V.Global.s5000Return`. Multiple return values are separated by the `&5000R&` delimiter.
5. After processing, all rows are deleted from the `5000` DataTable. On error, `V.Global.s5000Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern (open a schedule for editing):**

```
Program.External.Include.Library("5000.lib",False)

F.Data.DataTable.AddRow("5000")
F.Data.DataTable.SetValue("5000","Mode","OP",0)
F.Data.DataTable.SetValue("5000","Schedule","001234",0)
F.Data.DataTable.SetValue("5000","Suffix","001",0)

F.Intrinsic.Control.CallSub(5000Sync)

'V.Global.s5000Return now contains the return value from the call
```

**Usage Pattern (view multiple schedules, parse returns):**

```
Program.External.Include.Library("5000.lib",False)

F.Data.DataTable.AddRow("5000")
F.Data.DataTable.SetValue("5000","Mode","VW",0)
F.Data.DataTable.SetValue("5000","Schedule","001234",0)
F.Data.DataTable.SetValue("5000","Suffix","001",0)

F.Data.DataTable.AddRow("5000")
F.Data.DataTable.SetValue("5000","Mode","VW",1)
F.Data.DataTable.SetValue("5000","Schedule","005678",1)
F.Data.DataTable.SetValue("5000","Suffix","001",1)

F.Intrinsic.Control.CallSub(5000Sync)

'V.Global.s5000Return contains: "ReturnVal1&5000R&ReturnVal2"
V.Local.sReturns.Declare(String*)
F.Intrinsic.String.Split(V.Global.s5000Return,"&5000R&",V.Local.sReturns)
```

> **Note:** The DataTable is cleared after processing. `V.Global.s5000Return` is accumulated across all rows in a single `5000Sync` call; clear it manually before calling if you need a fresh result. On error, `V.Global.s5000Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 5100.lib -- Add Router Lines to Work Order (JBUTL001)

**Wraps:** CallWrapper `5100` — Add Router Lines to a Work Order / JBUTL001

**Include:**

```
Program.External.Include.Library("5100.lib",False)
```

**DataTable `5100` Schema (4 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `WO` | String | | Work order number X(6) |
| `WOSuffix` | String | | Work order suffix X(3) |
| `Router` | String | | Router number X(20) |
| `Schedule` | String | | Schedule direction enum (see below) |

**Schedule Enum:**

| Value | Description |
|---|---|
| `"B"` | Backwards scheduling |
| `"F"` | Forwards scheduling |
| `"H"` | Here (current date) scheduling |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s5100Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `5100Sync` | Runs callwrapper `5100` synchronously for each DataTable row |
| `5100Async` | Runs callwrapper `5100` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s5100Error` is declared and the `5100` DataTable is created with 4 columns.
2. When `5100Sync` or `5100Async` is called, the library iterates each row of the `5100` DataTable.
3. For each row, all four columns (`WO`, `WOSuffix`, `Router`, `Schedule`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `5100`.
4. After processing, all rows are deleted from the `5100` DataTable. On error, `V.Global.s5100Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("5100.lib",False)

F.Data.DataTable.AddRow("5100")
F.Data.DataTable.SetValue("5100","WO","100200",0)
F.Data.DataTable.SetValue("5100","WOSuffix","001",0)
F.Data.DataTable.SetValue("5100","Router","MAIN-ROUTER-01",0)
F.Data.DataTable.SetValue("5100","Schedule","F",0)

F.Intrinsic.Control.CallSub(5100Sync)
```

> **Note:** The DataTable is cleared after processing. On error, `V.Global.s5100Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 5101.lib -- Delete All Sequences from Work Order (JBUTL001)

**Wraps:** CallWrapper `5101` — Delete All Sequences from a Work Order / JBUTL001

> **Note:** This library shares the same core program (JBUTL001) as `5100.lib` but performs a different operation -- it deletes all sequences from the specified work order rather than adding router lines.

**Include:**

```
Program.External.Include.Library("5101.lib",False)
```

**DataTable `5101` Schema (2 columns):**

| Column | Type | Default | Description |
|---|---|---|---|
| `WO` | String | | Work order number — 6 digits |
| `WOSuffix` | String | | Work order suffix — 3 digits |

**Global Variables:**

| Variable | Format |
|---|---|
| `V.Global.s5101Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `5101Sync` | Runs callwrapper `5101` synchronously for each DataTable row |
| `5101Async` | Runs callwrapper `5101` asynchronously for each DataTable row |

**How It Works:**

1. On include, `V.Global.s5101Error` is declared and the `5101` DataTable is created with 2 columns.
2. When `5101Sync` or `5101Async` is called, the library iterates each row of the `5101` DataTable.
3. For each row, both columns (`WO`, `WOSuffix`) are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` and passed to `F.Global.General.CallWrapperSync` (or `Async`) with ID `5101`.
4. After processing, all rows are deleted from the `5101` DataTable. On error, `V.Global.s5101Error` is set with a 4-part `*!*`-delimited string.

**Usage Pattern:**

```
Program.External.Include.Library("5101.lib",False)

F.Data.DataTable.AddRow("5101")
F.Data.DataTable.SetValue("5101","WO","100200",0)
F.Data.DataTable.SetValue("5101","WOSuffix","001",0)

F.Intrinsic.Control.CallSub(5101Sync)
```

> **Note:** The DataTable is cleared after processing. This operation deletes **all** sequences from the work order -- use with caution. On error, `V.Global.s5101Error` is set; row index is 1-based (or `-1` for a wrapper-level error).

---

## 6000.lib -- Flex Schedule Upload (UPLSCHED)

**Wraps:** CallWrapper `6000` — Flex Schedule Upload / UPLSCHED

> **Important:** Unlike most libraries, `6000.lib` generates a **fixed-position file** (`SCHED.TXT`) from the DataTable and calls the callwrapper **once** for the entire file (not per-row). All fields are automatically padded to their required widths. Fields marked with `*` in the source are required for each row.

**Reference:** [Upload File Documentation](http://www.gss-updates.com/site/GShelp/2015/000/INDEX.asp?addl_ref_data_conv_flex_sched_master.asp)

**Include:**

```
Program.External.Include.Library("6000.lib",False)
```

**DataTable `6000` Schema (19 columns):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `SchedNumber` | String | | 6 | RPad space | **Required.** Schedule key number |
| `SchedSuffix` | String | `"   "` | 3 | RPad space | Schedule key suffix |
| `SchedIncrement` | String | | 6 | LPad `0` | **Required.** Schedule key increment |
| `MatWO` | String | | 6 | RPad space | **Required.** Material work order |
| `MatSuff` | String | | 3 | RPad space | **Required.** Material work order suffix |
| `MatSeq` | String | | 6 | LPad `0` | **Required.** Material work order sequence |
| `Filler1` | String | `"     "` | 5 | — | Reserved filler (not in use) |
| `LabWO` | String | | 6 | RPad space | **Required.** Labor work order |
| `LabSuff` | String | | 3 | RPad space | **Required.** Labor work order suffix |
| `LabSeq` | String | | 6 | LPad `0` | **Required.** Labor work order sequence |
| `SchedFromDate` | String | `"000000"` | 6 | RPad space | Schedule from date (MMDDYY) |
| `SchedToDate` | String | `"999999"` | 6 | RPad space | Schedule to date (MMDDYY) |
| `Filler2` | String | 25 spaces | 25 | — | Reserved filler (not in use) |
| `LabWorkCenter` | String | `"    "` | 4 | RPad space | Labor work center |
| `LabWOPart` | String | 20 spaces | 20 | RPad space | Labor work order finished good part |
| `LabWOLoc` | String | `"  "` | 2 | RPad space | Labor work order location |
| `SchedSortOrder` | String | `"   "` | 3 | LPad `0` | Schedule sort order |
| `SchedFromDueDate` | String | `"000000"` | 6 | RPad space | Schedule from due date (MMDDYY) |
| `SchedToDueDate` | String | `"999999"` | 6 | RPad space | Schedule to due date (MMDDYY) |

**Global Variables:**

| Variable | Default | Description |
|---|---|---|
| `V.Global.s6000Error` | | `Sub*!*ErrNo*!*ErrDesc` (3-part, no row index) |
| `V.Global.s6000Mode` | `"50"` | Upload mode: `"50"` = Append, `"51"` = Delete, `"52"` = Append and Update |
| `V.Global.s6000ScreenMode` | `"NS"` | Screen mode: `"NS"` = Screenless |

**Mode Enum (V.Global.s6000Mode):**

| Value | Description |
|---|---|
| `"50"` | Append |
| `"51"` | Delete |
| `"52"` | Append and Update |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `6000Sync` | Builds SCHED.TXT and runs callwrapper `6000` synchronously |
| `6000Async` | Builds SCHED.TXT and runs callwrapper `6000` asynchronously |

**How It Works:**

1. On include, `V.Global.s6000Error`, `V.Global.s6000Mode` (default `"50"`), and `V.Global.s6000ScreenMode` (default `"NS"`) are declared. The `6000` DataTable is created with 19 columns, each with appropriate defaults.
2. When `6000Sync` or `6000Async` is called, the library first pads every field in every row to the required fixed width using `RPad` (space) or `LPad` (`0`) as appropriate.
3. A `DataView` converts the entire DataTable into a newline-delimited string (one fixed-position record per row).
4. The string is written to `{FilesDir}\SCHED.TXT`.
5. The callwrapper is called **once** with parameters `{ScreenMode}!*!{Mode}` (e.g., `NS!*!50`).
6. After processing, all rows are deleted from the `6000` DataTable. On error, `V.Global.s6000Error` is set with a 3-part `*!*`-delimited string (no row index).

**Usage Pattern (append mode, screenless):**

```
Program.External.Include.Library("6000.lib",False)

'Optionally set mode (defaults to "50" = Append)
V.Global.s6000Mode.Set("50")

F.Data.DataTable.AddRow("6000")
F.Data.DataTable.SetValue("6000","SchedNumber","001234",0)
F.Data.DataTable.SetValue("6000","SchedIncrement","1",0)
F.Data.DataTable.SetValue("6000","MatWO","100200",0)
F.Data.DataTable.SetValue("6000","MatSuff","001",0)
F.Data.DataTable.SetValue("6000","MatSeq","10",0)
F.Data.DataTable.SetValue("6000","LabWO","100200",0)
F.Data.DataTable.SetValue("6000","LabSuff","001",0)
F.Data.DataTable.SetValue("6000","LabSeq","10",0)

F.Intrinsic.Control.CallSub(6000Sync)
```

**Usage Pattern (append and update, with optional fields):**

```
Program.External.Include.Library("6000.lib",False)

V.Global.s6000Mode.Set("52")

F.Data.DataTable.AddRow("6000")
F.Data.DataTable.SetValue("6000","SchedNumber","005678",0)
F.Data.DataTable.SetValue("6000","SchedSuffix","001",0)
F.Data.DataTable.SetValue("6000","SchedIncrement","1",0)
F.Data.DataTable.SetValue("6000","MatWO","200300",0)
F.Data.DataTable.SetValue("6000","MatSuff","001",0)
F.Data.DataTable.SetValue("6000","MatSeq","20",0)
F.Data.DataTable.SetValue("6000","LabWO","200300",0)
F.Data.DataTable.SetValue("6000","LabSuff","001",0)
F.Data.DataTable.SetValue("6000","LabSeq","20",0)
F.Data.DataTable.SetValue("6000","SchedFromDate","032126",0)
F.Data.DataTable.SetValue("6000","SchedToDate","063026",0)
F.Data.DataTable.SetValue("6000","LabWorkCenter","MC01",0)
F.Data.DataTable.SetValue("6000","LabWOPart","WIDGET-100",0)
F.Data.DataTable.SetValue("6000","LabWOLoc","WH",0)
F.Data.DataTable.SetValue("6000","SchedSortOrder","10",0)

F.Intrinsic.Control.CallSub(6000Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\SCHED.TXT` and the callwrapper is called once for the entire file. All fields are auto-padded -- you do not need to pad values yourself. The error format is 3-part (`Sub*!*ErrNo*!*ErrDesc`) with no row index. Set `V.Global.s6000Mode` before calling to control append/delete/update behavior.

---

## 6001.lib -- Upload PL/Discounts (UPLPLDSC)

**Wraps:** CallWrapper `6001` — Upload PL/Discounts / UPLPLDSC

> **Important:** Like `6000.lib`, this library generates a **fixed-position file** (`PLDISC.txt`) from the DataTable and calls the callwrapper **once** for the entire file (not per-row). All fields are automatically padded. All four columns are required for each row.

> **Prerequisite:** The customer master must be uploaded prior to running UPLPLDSC, because the program verifies the customer exists on the customer master.

**Reference:** [Upload File Documentation](http://www.gss-updates.com/site/GShelp/2015/000/INDEX.asp?addl_ref_data_conv_pl_disc_master.asp)

**Include:**

```
Program.External.Include.Library("6001.lib",False)
```

**DataTable `6001` Schema (4 columns — all required):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `CustNum` | String | | 6 | RPad space | Customer number |
| `PL` | String | | 2 | RPad space | Product line |
| `LineDisc` | String | | 16 | LPad space | Line discount (format 1.4) |
| `Desc` | String | | 30 | RPad space | Description |

**Global Variables:**

| Variable | Default | Description |
|---|---|---|
| `V.Global.s6001Error` | | `Sub*!*ErrNo*!*ErrDesc` (3-part, no row index) |
| `V.Global.s6001Option` | `"50"` | Upload option: `"50"` = Append, `"51"` = Delete, `"52"` = Append and Update |
| `V.Global.s6001ScreenMode` | `"NS"` | Screen mode — `"NS"` is the only valid option at this time |

**Option Enum (V.Global.s6001Option):**

| Value | Description |
|---|---|
| `"50"` | Append |
| `"51"` | Delete |
| `"52"` | Append and Update |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `6001Sync` | Builds PLDISC.txt and runs callwrapper `6001` synchronously |
| `6001Async` | Builds PLDISC.txt and runs callwrapper `6001` asynchronously |

**How It Works:**

1. On include, `V.Global.s6001Error`, `V.Global.s6001Option` (default `"50"`), and `V.Global.s6001ScreenMode` (hardcoded `"NS"`) are declared. The `6001` DataTable is created with 4 columns.
2. When `6001Sync` or `6001Async` is called, the library first pads every field in every row to the required fixed width: `CustNum` RPad 6, `PL` RPad 2, `LineDisc` LPad 16, `Desc` RPad 30.
3. A `DataView` converts the entire DataTable into a newline-delimited string.
4. The string is written to `{FilesDir}\PLDISC.txt`.
5. The callwrapper is called **once** with parameters concatenated from `{Option}` and `{ScreenMode}` (e.g., `50!*!NS`).
6. After processing, all rows are deleted from the `6001` DataTable. On error, `V.Global.s6001Error` is set with a 3-part `*!*`-delimited string (no row index).

**Usage Pattern (append mode):**

```
Program.External.Include.Library("6001.lib",False)

F.Data.DataTable.AddRow("6001")
F.Data.DataTable.SetValue("6001","CustNum","ACME01",0)
F.Data.DataTable.SetValue("6001","PL","01",0)
F.Data.DataTable.SetValue("6001","LineDisc","10.5000",0)
F.Data.DataTable.SetValue("6001","Desc","Standard Product Discount",0)

F.Data.DataTable.AddRow("6001")
F.Data.DataTable.SetValue("6001","CustNum","ACME01",1)
F.Data.DataTable.SetValue("6001","PL","02",1)
F.Data.DataTable.SetValue("6001","LineDisc","15.0000",1)
F.Data.DataTable.SetValue("6001","Desc","Premium Product Discount",1)

F.Intrinsic.Control.CallSub(6001Sync)
```

**Usage Pattern (append and update):**

```
Program.External.Include.Library("6001.lib",False)

V.Global.s6001Option.Set("52")

F.Data.DataTable.AddRow("6001")
F.Data.DataTable.SetValue("6001","CustNum","ACME01",0)
F.Data.DataTable.SetValue("6001","PL","01",0)
F.Data.DataTable.SetValue("6001","LineDisc","12.7500",0)
F.Data.DataTable.SetValue("6001","Desc","Updated Standard Discount",0)

F.Intrinsic.Control.CallSub(6001Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\PLDISC.txt` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is 3-part (`Sub*!*ErrNo*!*ErrDesc`) with no row index. The customer master must exist before running this upload.

---


# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: AccountingComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\AccountingComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\AccountingComponent.vb`
- **Feature toggle:** `57b11393-cef5-42a3-ae29-320cbd00e95a`
- **OCTSRS conversion status:** Done

### Runtime purpose
Handles Global Shop Solutions accounting operations, specifically for Accounts Receivable (AR) item status retrieval.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- The original ADODB implementation uses a Recordset to iterate through AR_Detail records
- Amounts are summed in VB code rather than using SQL SUM()

#### Known Issues
- None documented

#### Migration Notes
- ADO.NET version uses parameterized queries to prevent SQL injection
- Uses DataTable instead of Recordset
- SQL aggregation (SUM) used instead of VB iteration for better performance

### Dependencies
#### Components Called
- None

#### Called By
- Customer inquiry screens
- AR aging reports
- Payment processing modules

---

### Key method signatures & edge cases
#### `GETARITEMSTATUS`
**GAB Syntax:** `Function.Global.Accounting.GetARItemStatus(CustomerCode, InvoiceNumber, Variable.Local.Result)`

**Purpose:** Retrieves the payment status of an Accounts Receivable item for a specific customer and invoice.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | CustomerCode | String | Yes | The customer code to look up |
| 2 | InvoiceNumber | String | Yes | The invoice number to check |
| R | Result | String | Yes | Return value - Pipe-delimited status string |

**Returns:** A pipe-delimited string containing: `Debit|Credit|Remaining|Status`
- **Debit:** Total debit amount for the invoice
- **Credit:** Total credit/payment amount received
- **Remaining:** Outstanding balance (Debit - Credit)
- **Status:** "PAID", "PARTIAL", or "OPEN"

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| AR_Master | SELECT | Retrieves invoice header information |
| AR_Detail | SELECT | Retrieves line item details and payment history |
| Customer_Master | SELECT | Validates customer code exists |

**Business Rules:**
- If customer code not found, returns empty string
- If invoice not found for customer, returns empty string
- Status is "PAID" when Remaining = 0
- Status is "PARTIAL" when Remaining > 0 and Credit > 0
- Status is "OPEN" when Credit = 0

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 405 | Wrong argument count (not 3) | "Different argument count" |
| 999000 | Invalid method name | "Invalid method specified" |

**Example Usage:**
```
// GAB code example
Variable.Local.ARStatus.Declare(String)
Function.Global.Accounting.GetARItemStatus("CUST001", "INV-2024-001", Variable.Local.ARStatus)
// ARStatus might contain: "1500.00|500.00|1000.00|PARTIAL"
```

**Notes:**
- Dollar amounts are returned without currency symbols
- Amounts use 2 decimal places
- Empty result indicates customer or invoice not found (not an error condition)

---
