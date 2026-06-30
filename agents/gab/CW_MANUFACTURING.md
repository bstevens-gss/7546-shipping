# GAB CallWrapper Reference -- Manufacturing
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for manufacturing programs
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# CALLWRAPPER USAGE PATTERN

```
F.Global.CallWrapper.New("alias","Namespace.ClassName")
F.Global.CallWrapper.SetProperty("alias","PropertyName",sValue)
F.Global.CallWrapper.Run("alias")
F.Global.CallWrapper.GetProperty("alias","PropertyName",sResult)
```

---

# Manufacturing

## Table of Contents

- [AutomatedWorkOrderGeneration](#manufacturingautomatedworkordergeneration)
- [BOM.AddBOMMaintenance](#manufacturingbomaddbommaintenance)
- [BOM.AttachWorkOrderToBOM](#manufacturingbomattachworkordertobom)
- [BOM.BOMCompare](#manufacturingbombomcompare-gssxml-import)
- [BOM.BOMWorkOrderScheduling](#manufacturingbombomworkorderscheduling)
- [BOM.CopyBOMMaintenance](#manufacturingbomcopybommaintenance)
- [BOM.CostBuildup](#manufacturingbomcostbuildup)
- [BOM.DeleteBOMMaintenance](#manufacturingbomdeletebommaintenance)
- [BOM.GetInventoryStatus](#manufacturingbomgetinventorystatus)
- [BOM.OpenBOMMaintenance](#manufacturingbomopenbommaintenance)
- [BOM.ViewBOMMaintenance](#manufacturingbomviewbommaintenance)
- [BOM.WorkOrderDueDateReschedule](#manufacturingbomworkorderduedatereschedule)
- [CacheWipToFinishedGoodsLabel](#manufacturingcachewiptofinishedgoodslabel)
- [ChargeMaterialExpense](#manufacturingchargematerialexpense)
- [CheckIfDetailLocked](#manufacturingcheckifdetaillocked)
- [CloseWorkOrder](#manufacturingcloseworkorder)
- [CloseWorkOrderSequence](#manufacturingcloseworkordersequence)
- [CopyRouter](#manufacturingcopyrouter)
- [CreateTaskComments](#manufacturingcreatetaskcomments)
- [CreateWorkOrderFinishedGoodPart](#manufacturingcreateworkorderfinishedgoodpart)
- [DeleteSerialNumber](#manufacturingdeleteserialnumber)
- [EmployeeLaborBalancing](#manufacturingemployeelaborbalancing)
- [Estimating.GetRouterInventoryStatus](#manufacturingestimatinggetrouterinventorystatus)
- [Estimating.OpenMaterialQuantityDiscount](#manufacturingestimatingopenmaterialquantitydiscount)
- [IssueMaterialLotToLot](#manufacturingissuemateriallottolot)
- [IssueMaterialToWip](#manufacturingissuematerialtowip)
- [LotToLotTracking](#manufacturinglottolottracking)
- [ManualTimeCard](#manufacturingmanualtimecard)
- [MicroEstimatingSystemLoad](#manufacturingmicroestimatingsystemload)
- [ModifyJobDetailComments](#manufacturingmodifyjobdetailcomments)
- [ModifyTaskComments](#manufacturingmodifytaskcomments)
- [NewSerialNumber](#manufacturingnewserialnumber)
- [NewSerialNumberNoMessage](#manufacturingnewserialnumbernomessage)
- [OpenCutList](#manufacturingopencutlist)
- [PrintWIPToFinishedGoodsLabels](#manufacturingprintwiptofinishedgoodslabels)
- [ProjectCrossReference](#manufacturingprojectcrossreference)
- [PromoteSerialNumber](#manufacturingpromoteserialnumber)
- [PromoteSerialNumberToFinishedGoods](#manufacturingpromoteserialnumbertofinishedgoods)
- [PromoteSerialNumberToFinishedGoodsOnly](#manufacturingpromoteserialnumbertofinishedgoodsonly)
- [ReverseWipToFinishedGood](#manufacturingreversewiptofinishedgood)
- [ScheduleExistingWorkOrder](#manufacturingscheduleexistingworkorder)
- [SerializationDetailView](#manufacturingserializationdetailview)
- [SerialNumberReversal](#manufacturingserialnumberreversal)
- [StandaloneSerialNumber](#manufacturingstandaloneserialnumber)
- [TaskSignoff](#manufacturingtasksignoff)
- [TimeAndAttendance](#manufacturingtimeandattendance)
- [UnattendedForecastMaintenance](#manufacturingunattendedforecastmaintenance)
- [UpdateWorkOrderSequences](#manufacturingupdateworkordersequences)
- [VerifyOnHandMaterial](#manufacturingverifyonhandmaterial)
- [ViewSerialNumber](#manufacturingviewserialnumber)
- [WipToFinishedGoodsLotToLot](#manufacturingwiptofinishedgoodslottolot)
- [WipToWipTransfer](#manufacturingwiptowiptransfer)
- [WorkOrderHistoryByPart](#manufacturingworkorderhistorybypart)

---

## Manufacturing.AutomatedWorkOrderGeneration
Launches the Automated Work Order Generation process.

**Core Program:** `INV950`

> **Note:** Status is not used at this time.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |

```
F.Global.CallWrapper.New("Test","Manufacturing.AutomatedWorkOrderGeneration")
F.Global.CallWrapper.SetProperty("Test","Company","ABC")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.BOM.AddBOMMaintenance
Opens BOM Maintenance in add-record mode for the specified parent.

**Core Program:** `BM0020GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Parent` | String | 20 | BOM Parent part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The program ran successfully |
| `Fail` | The program failed |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.AddBOMMaintenance")
F.Global.CallWrapper.SetProperty("Test","Parent","WIDGET-ASSY-001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```
---
## Manufacturing.BOM.AttachWorkOrderToBOM
Attach an existing work order to a BOM work order set under a specified parent work order.

**Core Program:** `BMJ506`

**Required Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | GSS Company Code |
| `WorkOrder` | String | Yes | Existing work order number to attach |
| `WorkOrderSuffix` | String | Yes | Suffix for the WorkOrder parameter |
| `ParentWorkOrder` | String | Yes | Existing parent work order number for the BOM work order set |
| `ParentWorkOrderSuffix` | String | Yes | Suffix for the ParentWorkOrder. Usually tied to the suffix that has a 990* sequence representing the work order you are attaching to. |
| `IsMfgToStock` | Boolean | No | If True, creates a 990* record on the parent work order |
| `IsScreenless` | Boolean | No | If True, runs as automated screenless process. Default is False (interactive). |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | The attach work order process completed successfully |
| `Failed` | The process failed |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.AttachWorkOrderToBOM")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","75I")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","TEST")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","000")
F.Global.CallWrapper.SetProperty("Test","ParentWorkOrder","RUBY")
F.Global.CallWrapper.SetProperty("Test","ParentWorkOrderSuffix","000")
F.Global.CallWrapper.SetProperty("Test","IsScreenless",True)
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
```
---
## Manufacturing.BOM.BOMCompare (GSSXML Import)
BOM Compare is launched by opening a `.gssxml` file. GSSXBAR must be registered as the default handler for the `.gssxml` extension so that `F.Intrinsic.Task.ShellExec` with `"Open"` triggers it automatically.

The `.gssxml` file uses the standard GSSXML format documented in `agents/gab/DATA.md` under **GSSXML FILE FORMAT**. Each `<Row>` represents a BOM line with name-value pairs for the columns below.

**GSSXML Column Schema (27 columns):**

| Column | Description |
|--------|-------------|
| `PartNo` | Part number |
| `Revision` | Part revision (empty string if not applicable; use `""` not `"-"`) |
| `Description` | Part description |
| `AltDescription1` | Alternate description 1 |
| `AltDescription2` | Alternate description 2 |
| `DescExtra` | Extended description |
| `Quantity` | Quantity needed |
| `IssueUM` | Issue unit of measure |
| `ConsumptionConv` | Consumption conversion |
| `UM` | Unit of measure |
| `Cost` | Cost |
| `Source` | Source code (`MJ`, `MS`, `PS`, `PJ`, etc.) |
| `Drawing` | Drawing reference |
| `Leadtime` | Lead time |
| `Level` | BOM level (0-based; top-level parent = `0`) |
| `Location` | Inventory location |
| `Memo1` | Memo field 1 |
| `Memo2` | Memo field 2 |
| `Parent` | Parent part number (empty for the top-level parent row) |
| `Productline` | Product line |
| `Sequence` | Sequence number (incremented per row) |
| `SortCode` | Sort code |
| `Tag` | Tag |
| `Category` | Part category |
| `BomComplete` | BOM complete flag |
| `BomComments` | BOM comments |
| `Router` | Router reference |
| `Weight` | Weight |

**Parent Tracking with Revision Levels:**

When the GSS option *Use Revision Levels* (`070008`) is enabled, parent references are formatted as `{PartNo RPad to 17}{Revision}` (part number right-padded with spaces to 17 characters, followed by the revision). Track the parent at each BOM level using an array indexed by level. Child rows reference the parent from the level above:

```
V.Local.sLvlParents.Redim(0,20)
V.Local.sLvlParents(0).Set(V.Local.sTopParent)

'For each child row at level N, set its Parent to sLvlParents(N-1)
F.Data.DataTable.SetValue("GSSIMPORT",V.Local.iRow,"Parent",V.Local.sLvlParents(V.Local.iPrevLvl))

'Then store this row's part as the parent for the next level down
V.Local.sLvlParents(V.Local.iNewLvl).Set(V.Local.sParent)
```

**Launching BOM Compare:**

```
F.Intrinsic.File.String2File(V.Local.sFilePath,V.Local.sGssXmlContent)
F.Intrinsic.Task.ShellExec(0,"Open",V.Local.sFilePath,"","",0)
```

> **Note:** All text values in the GSSXML must be XML-escaped before insertion. See the escaping table in `agents/gab/DATA.md` under **GSSXML FILE FORMAT → XML Escaping**.

---
## Manufacturing.BOM.BOMWorkOrderScheduling
Schedule BOM work orders by specifying quantity, due date, part, and location.

**Core Program:** `BMJ501`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Quantity` | Double | 14 (8.6) | Quantity for the work order (max 8 digit whole, 6 digit decimal) |
| `WorkOrder` | String | 6 | Work order number |
| `DueDate` | Date/String | 6 | Due date in `MMDDYY` format |
| `PartNumber` | String | 20 | Part number (20 chars, includes both part number and revision) |
| `PartLocation` | String | 2 | Part location |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.BOMWorkOrderScheduling")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.123456)
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","DueDate","013117")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","PartLocation","TX")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.BOM.CopyBOMMaintenance
Opens BOM Maintenance in copy mode with the specified BOM parent pre-populated.

**Core Program:** `BM0020GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Parent` | String | 20 | BOM Parent part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The program ran successfully |
| `Fail` | The program failed |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CopyBOMMaintenance")
F.Global.CallWrapper.SetProperty("Test","Parent","WIDGET-ASSY-001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```
---
## Manufacturing.BOM.CostBuildup
Print a multi-level/explosion and cost buildup for a BOM parent part. Behavior varies based on the combination of `Program` and `Flags` parameters.

**Core Program:** `BMR060E`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Program` | String | 8 | Program name (see behavior matrix below) |
| `Parent` | String | 20 | BOM parent part number |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Flags` | String | 2 | Defaults to `00`. `01` = Screenless, `02` = Screenless without report. |
| `UseBestOrderQty` | Boolean | | Set to `True` to use best order quantity |
| `UseStandardCostQty` | Boolean | | Set to `True` to use; requires `UseBestOrderQty` also set to `True` |
| `UseLastPOCost` | Boolean | | Set to `True` to use Std Cost rules but look for Last Purchased Cost on material lines first |
| `CostingQuantity` | Double | | Override the pricing/quoting quantity for the parent |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Cost buildup was successful for the passed parent part |
| `Fail` | Other failure has occurred |

**Returned Properties** (available when `Program` = `RE0100` or `JB0308`):

| Property | Type | Description |
|----------|------|-------------|
| `LaborHours` | Double (14.2) | Total labor hours |
| `LaborCost` | Double (14.2) | Total labor cost |
| `MaterialCost` | Double (14.2) | Total material cost |
| `OutsideCost` | Double (14.2) | Total outside cost |
| `FreightCost` | Double (14.2) | Total freight cost |
| `OtherCost` | Double (14.2) | Total other cost |
| `OverheadCost` | Double (14.2) | Total overhead cost |
| `TotalCost` | Double (14.2) | Total cost (returned with `RE0100` only) |

**Program / Flag Behavior Matrix:**

*Build costs based on BOM/Router costs:*

| Program | Flag | Behavior |
|---------|------|----------|
| `RE0100` | `01` | Screenless, builds BI data |
| `RE0100` | `02` | Screenless, builds BI data |
| *(blank)* | `00` | Screen prompts, BI data, and prints report |
| *(blank)* | `01` | Screenless, builds BI data, and prints report |
| *(blank)* | `02` | Screenless, builds BI data, no report |

*Build costs based on inventory costs:*

| Program | Flag | Behavior |
|---------|------|----------|
| `JB0308` | `00` | Screenless, passes return values through callwrapper properties |
| `JB0308` | `01` | Screenless, BI data, prints report, passes return values through callwrapper properties |
| `JB0308` | `02` | Screenless, BI data, no report, passes return values through callwrapper properties |

**Example 1** *(same as running Bill Of Material > Reports > BOM Cost Buildup):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

**Example 2** *(screenless, requires Parent):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.SetProperty("Test","Flags","01")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

**Example 3** *(screenless, no report, requires Parent):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.SetProperty("Test","Flags","02")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

**Example 4** *(RE0100 screenless, TotalCost returned):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","RE0100")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.SetProperty("Test","Flags","01")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.fTotalCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","TotalCost",V.Local.fTotalCost)
```

**Example 5** *(RE0100 screenless, no report, TotalCost returned):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","RE0100")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.SetProperty("Test","Flags","02")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.fTotalCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","TotalCost",V.Local.fTotalCost)
```

**Example 6** *(JB0308 inventory costs, individual cost components returned):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","JB0308")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.fLaborCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","LaborCost",V.Local.fLaborCost)
V.Local.fMaterialCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","MaterialCost",V.Local.fMaterialCost)
V.Local.fOutsideCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OutsideCost",V.Local.fOutsideCost)
V.Local.fFreightCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","FreightCost",V.Local.fFreightCost)
V.Local.fOtherCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OtherCost",V.Local.fOtherCost)
V.Local.fOverheadCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OverheadCost",V.Local.fOverheadCost)
```

**Example 7** *(JB0308 with report):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","JB0308")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.SetProperty("Test","Flags","01")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.fLaborCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","LaborCost",V.Local.fLaborCost)
V.Local.fMaterialCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","MaterialCost",V.Local.fMaterialCost)
V.Local.fOutsideCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OutsideCost",V.Local.fOutsideCost)
V.Local.fFreightCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","FreightCost",V.Local.fFreightCost)
V.Local.fOtherCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OtherCost",V.Local.fOtherCost)
V.Local.fOverheadCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OverheadCost",V.Local.fOverheadCost)
```

**Example 8** *(JB0308 no report):*

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.CostBuildup")
F.Global.CallWrapper.SetProperty("Test","Program","JB0308")
F.Global.CallWrapper.SetProperty("Test","Parent","210900-7")
F.Global.CallWrapper.SetProperty("Test","Flags","02")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.fLaborCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","LaborCost",V.Local.fLaborCost)
V.Local.fMaterialCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","MaterialCost",V.Local.fMaterialCost)
V.Local.fOutsideCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OutsideCost",V.Local.fOutsideCost)
V.Local.fFreightCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","FreightCost",V.Local.fFreightCost)
V.Local.fOtherCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OtherCost",V.Local.fOtherCost)
V.Local.fOverheadCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","OverheadCost",V.Local.fOverheadCost)
```
---
## Manufacturing.BOM.DeleteBOMMaintenance
Opens BOM Maintenance in delete record mode for the specified parent.

**Core Program:** `BM0020GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Parent` | String | 20 | BOM Parent part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The program ran successfully |
| `Fail` | The program failed |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.DeleteBOMMaintenance")
F.Global.CallWrapper.SetProperty("Test","Parent","WIDGET-ASSY-001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```
---
## Manufacturing.BOM.GetInventoryStatus
Return the inventory status of a BOM, including material requirements and on-hand/on-order data.

**Core Program:** `BomRtrInvSts`

**Full Name:** `GSSEO.CallWrappers.Manufacturing.BOM.GetInventoryStatus`

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | No | Company code |
| `Caller` | String | No | Calling program name (for logging/auditing) |
| `ParentNumber` | String | Yes | Parent number to retrieve data from |
| `ParentNumberRevision` | String | Yes | Parent number revision. Empty string if revision not enabled. |
| `Quantity` | Double | No | Parent quantity for computing material requirements |
| `LocationCodes` | String | No | Delimited location codes (`*!*` delimiter). Pass empty string for blank locations (default). |
| `SubtractOnOrderFromNet` | Boolean | No | If True, subtract On Order Qty from BOM/Router Net |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | Enum (Integer) | See table below |
| `BomRouterData` | StringList | Tab-delimited tabular data for the parent number. See column schema below. |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `1` | UnableToAccessOptions | Options were not successfully loaded |
| `2` | BOMNotFound | The BOM does not exist |
| `3` | BomTempFileNotFound | The temp file(s) used in BomRtrInvSts does not exist |
| `35` | ParmError | Invalid parameter passed |
| Other | Fail | Other failure has occurred |

**`BomRouterData` Column Schema (tab-delimited):**

| Column | Type | Description |
|--------|------|-------------|
| Level | `[n]` | BOM level number |
| Long Part Number | `[s]` | Use if Using Long Part, else use Normal Part Number |
| Part Description | `[s]` | Part description |
| Part Category | `[s]` | `Normal`, `Phantom`, `Exclude`, `Setup`, `Reference` |
| Source | `[s]` | `MJ` (Manufacture to Job), `MS` (Manufacture to Stock), `PS` (Purchase to Stock), `PJ` (Purchase to Job), `CS` (Consign to Stock), `CJ` (Consign to Job), or spaces (Other) |
| Quantity | `[d]` | Qty of this part needed for BOM/Router |
| Current Inventory On Hand | `[d]` | |
| Current Inventory On Order | `[d]` | |
| Current Inventory Required | `[d]` | |
| Inventory Net | `[d]` | |
| BOM/Router Net | `[d]` | If BOM, this is a computed field based on options |
| BOM Parent | `[s]` | |
| Lead Time | `[n]` | Lead time in days |
| Lead Date | `[date]` | `MMDDYYYY`, zeroes for null date |
| Normal/Short Part Number | `[s]` | |
| Sort | `[s]` | |
| Inventory Cost | `[d]` | |
| BOM Setup Qty | `[d]` | |
| Non-Inventory Part Flag | `[boolean]` | |

Type legend: `[n]` = Numeric (int, no decimal), `[s]` = String, `[d]` = Double

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.GetInventoryStatus")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","Caller","Callwrap")
F.Global.CallWrapper.SetProperty("Test","ParentNumber","076-006783-002")
F.Global.CallWrapper.SetProperty("Test","ParentNumberRevision","E")
F.Global.CallWrapper.SetProperty("Test","Quantity",1)
F.Global.CallWrapper.SetProperty("Test","LocationCodes","")
F.Global.CallWrapper.SetProperty("Test","SubtractOnOrderFromNet",False)
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sBomData.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","BomRouterData",V.Local.sBomData)
```
---
## Manufacturing.BOM.OpenBOMMaintenance
Opens BOM Maintenance in open/edit mode with the specified BOM parent pre-populated.

**Core Program:** `BM0020GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Parent` | String | 20 | BOM Parent part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The program ran successfully |
| `Fail` | The program failed |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.OpenBOMMaintenance")
F.Global.CallWrapper.SetProperty("Test","Parent","WIDGET-ASSY-001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```
---
## Manufacturing.BOM.ViewBOMMaintenance
Opens BOM Maintenance in view-only mode with the specified BOM parent pre-populated.

**Core Program:** `BM0020GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Parent` | String | 20 | BOM Parent part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The program ran successfully |
| `Fail` | The program failed |

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.ViewBOMMaintenance")
F.Global.CallWrapper.SetProperty("Test","Parent","WIDGET-ASSY-001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```
---
## Manufacturing.BOM.WorkOrderDueDateReschedule
Reschedule a work order to a new due date with a specified quantity.

**Core Program:** `BMJ501`

**Full Name:** `Manufacturing.BOM.WorkOrderDueDateReschedule`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Quantity` | Double | -- | Quantity for the rescheduled work order |
| `DueDate` | String | 6 | Date to reschedule to in `MMDDYY` format (e.g. `"120119"`) |
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix to start with |
| `PartNumber` | String | 20 | Part number being rescheduled (20 chars includes part + revision) |
| `PartLocation` | String | 2 | Part location |
| `PrintReport` | String | 1 | `"Y"` to print report at end, `"N"` to skip |

**Returned Properties:** None.

```
F.Global.CallWrapper.New("Test","Manufacturing.BOM.WorkOrderDueDateReschedule")
F.Global.CallWrapper.SetProperty("Test","Quantity",10)
F.Global.CallWrapper.SetProperty("Test","DueDate","110124")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","000")
F.Global.CallWrapper.SetProperty("Test","PartNumber","210900")
F.Global.CallWrapper.SetProperty("Test","PartLocation","")
F.Global.CallWrapper.SetProperty("Test","PrintReport","N")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.CacheWipToFinishedGoodsLabel
Cache a WIP to Finished Goods label for a work order sequence.

**Core Program:** `JB0640`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `ClearTemp` | String | 1 | `"Y"` for True, blank for False (default) |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |
| `ExplicitWIPToFinishedGoods` | String | 1 | `"Y"` for True, blank for False |
| `XRefID` | Long | 16 | Cross Reference ID for `JOBS_IN_PROC_AUX` table |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | See table below |

**Returned Status:**

| Code | Description |
|------|-------------|
| `00` | Successful |
| `05` | Zero quantity, no label processed |
| `10` | Parameter error |
| `15` | Cache overflow |
| `23` | Work order not found |
| `24` | Detail not found |
| `35` | File error |
| `50` | Program missing |

```
F.Global.CallWrapper.New("Test","Manufacturing.CacheWipToFinishedGoodsLabel")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence",123456)
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","ExplicitWIPToFinishedGoods"," ")
F.Global.CallWrapper.SetProperty("Test","XRefID",1234567890123456)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.ChargeMaterialExpense
Run the Charge Material/Expenses (Stand-Alone) process screenless using an input text file.

**Core Program:** `JB0081`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `FileName` | String | 256 | Full path to the input text file (see Input Text File section below) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | See table below |
| `ReturnErrorFileName` | String | Full path to the error log file |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process successfully updated all records |
| `ParmError` | Import file name (`FileName`) is not set |
| `InvalidImportFile` | Failed to open or read import file |
| `ImportRecordErrors` | One or more import file records failed; see error log file `ReturnErrorFileName` |
| `Failure` | Other failure caused process not to finish successfully |

**Error Log File Record Layout:**

| Field | Size | Description |
|-------|------|-------------|
| Original Record | 150 | The original input record |
| Status Title | 20 | `Successful`, `Work Order Status`, `Work Order Error`, `Write Error`, `Rewrite Error`, or `Failed` |
| Status Message | 80 | Detail message |

> **Note:** `Work Order Status` is informational only for closed work orders and does not stop the process. Depending on options, posting to a closed work order may not be allowed.

**Input Text File:**

Fields are delimited by `*!*`.

Example record:
```
20230907*!*VENDOR1*!*TestVendor1*!*InvoiceTest1*!*900000*!*001*!*997000*!*N*!*FakePart*!*234*!*TS *!*546.85*!*785485.45*!*Description For Testing
```

| # | Field Name | Data Type | Size | Notes |
|---|-----------|-----------|------|-------|
| 1 | Date | Date | 8 | Format `YYYYMMDD` |
| 2 | Vendor | String | 6 | Optional |
| 3 | Vendor Name | String | 30 | Optional. Defaults to name in Vendor Master if blank |
| 4 | Invoice Number | String | 15 | Optional. Will be set to uppercase |
| 5 | Work Order | String | 6 | Requires valid work order |
| 6 | Work Order Suffix | String | 3 | |
| 7 | Work Order Sequence | Integer | 6 | Requires valid Miscellaneous Material or Miscellaneous Outside sequence |
| 8 | Close | String | 1 | `"Y"` to close work order sequence |
| 9 | Part Number | String | 20 (17**) | Optional. Only for Misc. Material sequence. **17 if Rev option is on |
| 10 | Part Number Rev | String | 3 | Only used if Rev option is on |
| 11 | Product Line | String | 2 | Optional. Requires valid Product Line if set |
| 12 | Quantity | Double | 7.2 | Optional |
| 13 | Dollars | Double | 8.2 | Optional |
| 14 | Description | String | 30 | Optional |

```
F.Global.CallWrapper.New("Test","Manufacturing.ChargeMaterialExpense")
F.Global.CallWrapper.SetProperty("Test","Company","66N")
F.Global.CallWrapper.SetProperty("Test","FileName","\\gss2k19clinic4\apps\66N\files\CWTEST.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
V.Local.ReturnFileName.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
F.Global.CallWrapper.GetProperty("Test","ReturnErrorFileName",V.Local.ReturnFileName)
V.Local.FullText.Declare(String)
F.Intrinsic.String.Concat("Status: ",V.Local.tStatus," , ReturnFileName: ",V.Local.ReturnFileName,V.Local.FullText)
F.Intrinsic.UI.Msgbox(V.Local.FullText,"Return Values")
```
---
## Manufacturing.CheckIfDetailLocked
Check if a given work order detail record is locked and whether it can be edited.

**Core Program:** `JB0642`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |
| `WorkOrderDetailKey` | String | 25 | Job Detail record key: 6-char WO + 3-char Suffix + 6-digit Sequence + 1-char (always blank) + 6-digit Date (`YYMMDD`) + 4-digit Key Sequence |
| `AllowBatchUpdate` | String | 1 | `"Y"` for True, blank for False |
| `SkipBatchPrompt` | String | 1 | `"Y"` for True, blank for False |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | See table below |

**Returned Status:**

| Code | Description |
|------|-------------|
| `00` | Successful (record is not locked) |
| `01` | Record locked |
| `10` | Parameter error |
| `22` | Duplicate error |
| `23` | Record not found |
| `35` | File error |
| `50` | Program missing |

```
F.Global.CallWrapper.New("Test","Manufacturing.CheckIfDetailLocked")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","WorkOrderDetailKey","123456001000001 9901011234")
F.Global.CallWrapper.SetProperty("Test","AllowBatchUpdate","Y")
F.Global.CallWrapper.SetProperty("Test","SkipBatchPrompt","Y")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.CloseWorkOrder
Close a work order with a specified close date.

**Core Program:** `JB0019GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `BeginningWorkOrder` | String | 6 | Work order number |
| `BeginningWorkOrderSuffix` | String | 3 | Work order suffix |
| `CloseDate` | Date/String | 8 | Close date (GAB Date or `"YYYYMMDD"`) |

```
F.Global.CallWrapper.New("Test","Manufacturing.CloseWorkOrder")
F.Global.CallWrapper.SetProperty("Test","BeginningWorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","BeginningWorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","CloseDate","20260101")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.CloseWorkOrderSequence
Close a specific work order sequence with a given close date.

**Core Program:** `JB0019GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `BeginningWorkOrder` | String | 6 | Work order number |
| `BeginningWorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 6 | Work order sequence |
| `CloseDate` | Date/String | 8 | Close date (GAB Date or `"YYYYMMDD"`) |

```
F.Global.CallWrapper.New("Test","Manufacturing.CloseWorkOrderSequence")
F.Global.CallWrapper.SetProperty("Test","BeginningWorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","BeginningWorkOrderSuffix","000")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000001")
F.Global.CallWrapper.SetProperty("Test","CloseDate","20260101")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.CopyRouter
Copy an existing estimate or standard router to a new router number with optional BOM inclusion and cost flags.

**Core Program:** `RE0010GI`

**Required Properties:**

| Property | Type | Size | Required | Description |
|----------|------|------|----------|-------------|
| `CompanyCode` | String | 3 | Yes | Company code |
| `RouterNumber` | String | 17 | Yes | Source router number |
| `Revision` | String | 3 | No | Source router revision |
| `ToRouterNumber` | String | 17 | Yes | Target router number |
| `ToRevision` | String | 3 | No | Target router revision |
| `IncludeBomFlag` | String | 1 | No | `"Y"` to include BOM |
| `ExecZeroRunFlag` | String | 1 | No | `"Y"` to exclude 0 runtime/quantity sequences |
| `UpdMatlCostFlag` | String | 1 | No | `"Y"` to update material cost with inventory cost |

> **Note:** If the customer is not using the Revision option and the router number exceeds 17 bytes (max 20 bytes), use the optional Revision field to populate bytes 18-20.

**Returned Properties:** None.

```
F.Global.CallWrapper.New("CopyRouter","Manufacturing.CopyRouter")
F.Global.CallWrapper.SetProperty("CopyRouter","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("CopyRouter","RouterNumber","RTR-SOURCE-001")
F.Global.CallWrapper.SetProperty("CopyRouter","Revision","001")
F.Global.CallWrapper.SetProperty("CopyRouter","ToRouterNumber","RTR-DEST-001")
F.Global.CallWrapper.SetProperty("CopyRouter","ToRevision","001")
F.Global.CallWrapper.SetProperty("CopyRouter","IncludeBomFlag","Y")
F.Global.CallWrapper.SetProperty("CopyRouter","ExecZeroRunFlag","Y")
F.Global.CallWrapper.SetProperty("CopyRouter","UpdMatlCostFlag","Y")
F.Global.CallWrapper.Run("CopyRouter")
```
---
## Manufacturing.CreateTaskComments
Create a comment associated with a task (job sequence). Use `Manufacturing.ModifyTaskComments` to modify an existing comment.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Job` | String | 6 | Job number |
| `JobSuffix` | String | 3 | Job suffix |
| `JobSequence` | Long | 6 | Job sequence |
| `DateTime` | String | 16 | Date/time in `YYYYMMDDHHMMSSFF` format (year, month, day, hour, minute, second, hundredths of second) |
| `User` | String | 8 | GSS username |
| `Comments` | String | Variable | Comment text |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The comment was successfully created |
| `RecordAlreadyExists` | Comment could not be created because it already exists (use `Manufacturing.ModifyTaskComments` instead) |
| `FileError` | Error accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("CreateComments","Manufacturing.CreateTaskComments")
F.Global.CallWrapper.SetProperty("CreateComments","Job","000155")
F.Global.CallWrapper.SetProperty("CreateComments","JobSuffix","001")
F.Global.CallWrapper.SetProperty("CreateComments","JobSequence",2000)
F.Global.CallWrapper.SetProperty("CreateComments","DateTime","2017012012345599")
F.Global.CallWrapper.SetProperty("CreateComments","User","LML")
F.Global.CallWrapper.SetProperty("CreateComments","Comments","Here are the comments for this task.")
F.Global.CallWrapper.Run("CreateComments")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("CreateComments","Status",V.Local.sStatus)
```
---
## Manufacturing.CreateWorkOrderFinishedGoodPart
Create work orders for finished good parts from a file. Supports multiple lines per file.

**Core Program:** `JB0010GB`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `FileName` | String | 256 | Fully qualified file path |

**Returned Properties:** None directly. A return file is created.

**Input File Format** (ASCII, `*!*` delimited, all fields on a single line):

| Field | Description |
|-------|-------------|
| Finished Good Part | FG part number (can also be a BOM part) |
| FG Part Rev | FG part revision (if any) |
| FG Part Location | FG part location |
| Due Date | Desired work order due date (`mm/dd/yyyy`) |
| Run Qty | Desired work order run quantity |
| Work Order Type | *(Optional)* Blank = Normal WO, `M` = Manual (set WO Seed and Suffix Seed), `T` = Temporary (no commitments, forward scheduled) |
| Work Order Seed | *(Optional)* Used with type `M` or `T` (e.g. `TEMP01`) |
| Sales Order | *(Optional)* Tie normal WO to a sales order |
| Sales Order Line | *(Optional)* Tie normal WO to a sales order line |
| Work Order Suffix Seed | *(Optional)* Used with type `M` (e.g. `001`) |

**Return File Format** (ASCII, `*!*` delimited, all fields on a single line):

| Field | Description |
|-------|-------------|
| Finished Good Part | FG part number |
| FG Part Rev | FG part revision (if any) |
| FG Part Location | FG part location |
| Status | `Y` = WO Created, `R` = Bad RTR, `A` = Bad RTR Alt, `B` = Good Call Process Failed, `X` = Bad Call Return |
| Work Order | Work order number (if status `Y`) |
| Work Order Suffix | Work order suffix (if status `Y`) |

```
F.Global.CallWrapper.New("Test","Manufacturing.CreateWorkOrderFinishedGoodPart")
F.Global.CallWrapper.SetProperty("Test","FileName","C:\Global\Files\WOCREATE.TXT")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.DeleteSerialNumber
Delete all serial number records for a given work order and suffix.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.DeleteSerialNumber")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.EmployeeLaborBalancing
Runs the Daily Balancing Process for employees. If `ProcessMethod` is set to Manual, opens directly to labor balancing screens. If set to Automatic, runs the Automatic Daily Balancing process screenless.

**Core Program:** `JB032BGI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `BalancingDate` | Date | | Balancing date |
| `ProcessMethod` | Enum | | `0` = Automatic (requires `AdditionalMode` = `0`), `1` = Manual (requires `AdditionalMode` = `0`) |
| `AdditionalMode` | Enum | | `0` = None, `1` = Get Balancing Hours, `2` = Get Pay Hours, `3` = Get All Hours. Set to non-zero to get returned properties only with no updates. |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `StartingEmployeeNumber` | Integer | 5 | Starting employee number (defaults to `00000`) |
| `EndingEmployeeNumber` | Integer | 5 | Ending employee number (defaults to `99999`) |
| `BalancingHours` | Integer | HHMM | Override balancing hours (use with `AdditionalMode` `1`) |
| `PayHours` | Integer | HHMM | Override pay hours (use with `AdditionalMode` `2`) |
| `IsBatchMode` | Boolean | | Set to `True` only when also supplying `BatchFileName`. Set `ProcessMethod` to Automatic, plus `BalancingDate` and `CompanyCode`. `StartingEmployeeNumber`, `EndingEmployeeNumber`, and `AdditionalMode` are not needed in batch mode. |
| `BatchFileName` | String | 12 | File name (must reside in `\Global\Files`). Only set if `IsBatchMode` is `True`. |

**Batch File Format** (comma delimited):

`EmployeeNum, BatchMode, PayHours, BalancingHours`

| Field | Description |
|-------|-------------|
| `EmployeeNum` | 5-byte employee number |
| `BatchMode` | `B` = GetBalancingHours (pass PayHours, set BalancingHours to `0`), `P` = GetPayHours (pass BalancingHours, set PayHours to `0`), `A` = GetAllHours (pass `0` for both) |
| `PayHours` | HHMM format |
| `BalancingHours` | HHMM format |

> **Note:** When `IsBatchMode` is `True` and `BatchFileName` is passed, an output file is created by appending `.RET` to the batch file name (e.g. `MYFILE001` produces `MYFILE001.RET`). The output file contains: `EmployeeNum, BatchMode, PayHours, BalancingHours, ActualHoursIn, ActualHoursOut, UsedHoursIn, UsedHoursOut, TotalJobHours, TotalTimatHours`. Be sure to clean up input and output files as necessary.

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process completed successfully |
| `InvalidDate` | Invalid `BalancingDate` |
| `NoRecordsFound` | No records found for criteria |
| `ProcessInUse` | Daily Balancing Process is in use by another user |
| `Failure` | Other failure has occurred |

**Returned Properties** (not returned if `IsBatchMode` is set):

| Property | Type | Format | Description |
|----------|------|--------|-------------|
| `ActualHoursIn` | Integer | HHMM | Actual hours in |
| `ActualHoursOut` | Integer | HHMM | Actual hours out |
| `UsedHoursIn` | Integer | HHMM | Used hours in |
| `UsedHoursOut` | Integer | HHMM | Used hours out |
| `TotalJobHours` | Integer | HHMM | Total job hours |
| `TotalTimatHours` | Integer | HHMM | Total TIMAT hours |

```
V.Local.tDate.Declare(Date)
V.Local.tDate.Set(05/05/2021)
V.Local.eProcessType.Declare(Long)
V.Local.eProcessType.Set(1)
F.Global.CallWrapper.New("Test","Manufacturing.EmployeeLaborBalancing")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","BalancingDate",V.Local.tDate)
F.Global.CallWrapper.SetProperty("Test","StartingEmployeeNumber",58000)
F.Global.CallWrapper.SetProperty("Test","EndingEmployeeNumber",58002)
F.Global.CallWrapper.SetProperty("Test","ProcessMethod",V.Local.eProcessType)
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
```
---
## Manufacturing.Estimating.GetRouterInventoryStatus
Return the inventory status of a Router, including material requirements and on-hand/on-order data.

**Core Program:** `BomRtrInvSts`

**Full Name:** `GSSEO.CallWrappers.Manufacturing.Estimating.GetRouterInventoryStatus`

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | No | Company code |
| `Caller` | String | No | Calling program name (for logging/auditing) |
| `RouterNumber` | String | Yes | Router number to retrieve data from |
| `RouterNumberRevision` | String | Yes | Router number revision. Empty string if revision not enabled. |
| `Quantity` | Double | No | Parent quantity for computing material requirements |
| `LocationCodes` | String | No | Delimited location codes (`*!*` delimiter). Pass empty string for blank locations (default). |
| `SubtractOnOrderFromNet` | Boolean | No | If True, subtract On Order Qty from BOM/Router Net |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | Enum (Integer) | See table below |
| `BomRouterData` | StringList | Tab-delimited tabular data for the router. See column schema below. |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `1` | UnableToAccessOptions | Options were not successfully loaded |
| `2` | BOMNotFound | The BOM/Router does not exist |
| `3` | BomTempFileNotFound | The temp file(s) used in BomRtrInvSts does not exist |
| `35` | ParmError | Invalid parameter passed |
| Other | Fail | Other failure has occurred |

**`BomRouterData` Column Schema (tab-delimited):**

| Column | Type | Description |
|--------|------|-------------|
| Level | `[n]` | BOM level number |
| Long Part Number | `[s]` | Use if Using Long Part, else use Normal Part Number |
| Part Description | `[s]` | Part description |
| Part Category | `[s]` | `Normal`, `Phantom`, `Exclude`, `Setup`, `Reference` |
| Source | `[s]` | `MJ` (Manufacture to Job), `MS` (Manufacture to Stock), `PS` (Purchase to Stock), `PJ` (Purchase to Job), `CS` (Consign to Stock), `CJ` (Consign to Job), or spaces (Other) |
| Quantity | `[d]` | Qty of this part needed for BOM/Router |
| Current Inventory On Hand | `[d]` | |
| Current Inventory On Order | `[d]` | |
| Current Inventory Required | `[d]` | |
| Inventory Net | `[d]` | |
| BOM/Router Net | `[d]` | If BOM, this is a computed field based on options |
| BOM Parent | `[s]` | |
| Lead Time | `[n]` | Lead time in days |
| Lead Date | `[date]` | `MMDDYYYY`, zeroes for null date |
| Normal/Short Part Number | `[s]` | |
| Sort | `[s]` | |
| Inventory Cost | `[d]` | |
| BOM Setup Qty | `[d]` | |
| Non-Inventory Part Flag | `[boolean]` | |

Type legend: `[n]` = Numeric (int, no decimal), `[s]` = String, `[d]` = Double

```
F.Global.CallWrapper.New("Test","Manufacturing.Estimating.GetRouterInventoryStatus")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","Caller","Callwrap")
F.Global.CallWrapper.SetProperty("Test","RouterNumber","076-006783-002")
F.Global.CallWrapper.SetProperty("Test","RouterNumberRevision","E")
F.Global.CallWrapper.SetProperty("Test","Quantity",1)
F.Global.CallWrapper.SetProperty("Test","LocationCodes","")
F.Global.CallWrapper.SetProperty("Test","SubtractOnOrderFromNet",False)
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sBomData.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","BomRouterData",V.Local.sBomData)
```
---
## Manufacturing.Estimating.OpenMaterialQuantityDiscount
Open the Material Quantity Discount screen for a specified part. Menu path: *ERQ > File > Estimating/Standard Routers > Open > Lines button > Matl Qty button*.

**Core Program:** `RE0190`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Company` | String | Company code |
| `PartNumber` | String | Part number |
| `Revision` | String | Part number revision. Used when *Use Revision Level/Engineering Change* is enabled. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `DiscountPresent` | String | `"Y"` when a discount record exists |

```
F.Global.CallWrapper.New("Test","Manufacturing.Estimating.OpenMaterialQuantityDiscount")
F.Global.CallWrapper.SetProperty("Test","Company","@@@")
F.Global.CallWrapper.SetProperty("Test","PartNumber","COMPUTER BOX")
F.Global.CallWrapper.SetProperty("Test","Revision","001")
F.Global.CallWrapper.Run("Test")
V.Local.sDiscountPresent.Declare(String)
F.Global.CallWrapper.GetProperty("Test","DiscountPresent",V.Local.sDiscountPresent)
F.Intrinsic.UI.Msgbox(V.Local.sDiscountPresent,"DiscountPresent")
```
---
## Manufacturing.IssueMaterialLotToLot
Issue material for lots with lot-to-lot tracking.

**Core Program:** `JB0252`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `PartNumber` | String | 20 | Part number |
| `PartLocation` | String | 2 | Part location |
| `PartDescription` | String | 30 | Part description |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |
| `GoodPieces` | Double | 12 (8.4) | Good pieces (max 8 digit whole, 4 digit decimal) |
| `ScrapPieces` | Double | 12 (8.4) | Scrap pieces (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Close` | String (1) | `"Y"` if closed |
| `Quantity` | Double (12, 8.4) | Lot quantity selected |

```
F.Global.CallWrapper.New("Test","Manufacturing.IssueMaterialLotToLot")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence",123456)
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","PartLocation","TX")
F.Global.CallWrapper.SetProperty("Test","PartDescription","Widget Assembly A")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","ScrapPieces",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sClose.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Close",V.Local.sClose)
V.Local.fQuantity.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","Quantity",V.Local.fQuantity)
```
---
## Manufacturing.IssueMaterialToWip
Issue material to WIP for a work order.

**Core Program:** `JB0075GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Suffix` | String | 3 | Work order suffix |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Material issued successfully |
| `IssueMade` | Issue was made |
| `Failed` | Failure occurred |
| `Unknown` | Unknown result |

```
F.Global.CallWrapper.New("Test","Manufacturing.IssueMaterialToWip")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","Suffix","001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Manufacturing.LotToLotTracking
Lot-to-lot tracking for when the option *Access Lot-to-Lot Tracking from within GUI by Opcode* is used and the work order already has existing lot-to-lot records.

**Core Program:** `JB0252`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `PartNumber` | String | 20 | Part number |
| `PartLocation` | String | 2 | Part location |
| `PartDescription` | String | 30 | Part description |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |
| `GoodPieces` | Double | 12 (8.4) | Good pieces (max 8 digit whole, 4 digit decimal) |
| `ScrapPieces` | Double | 12 (8.4) | Scrap pieces (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Close` | String (1) | `"Y"` if closed |
| `Quantity` | Double (12, 8.4) | Lot quantity selected |

```
F.Global.CallWrapper.New("Test","Manufacturing.LotToLotTracking")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence",123456)
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","PartLocation","TX")
F.Global.CallWrapper.SetProperty("Test","PartDescription","Widget Assembly A")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","ScrapPieces",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sClose.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Close",V.Local.sClose)
V.Local.fQuantity.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","Quantity",V.Local.fQuantity)
```
---
## Manufacturing.ManualTimeCard
Run Manual Time Card Input process screenless using an input text file.

**Core Program:** `JB0080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `Mode` | String | 1 | `"I"` = Inquiry (returns Hours, DirectCost, Overhead; no updates; supports single record only). `"H"` = Update (processes and updates). |
| `FileName` | String | 256 | Full path to the input text file (see layout below) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnHours` | Double (8.4) | Total hours |
| `ReturnDirectCost` | Double (8.4) | Direct cost |
| `ReturnOverHead` | Double (8.4) | Overhead cost |
| `ReturnStatus` | String | `Successful`, `ParmError` (missing FileName), or `Files` (other failure) |

```
F.Global.CallWrapper.New("Test","Manufacturing.ManualTimeCard")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","58S")
F.Global.CallWrapper.SetProperty("Test","Mode","I")
F.Global.CallWrapper.SetProperty("Test","FileName","\\gss2k19clinic2\apps\58S\files\JB0080VALUE.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.Hours.Declare(Float)
V.Local.DirectCost.Declare(Float)
V.Local.Overhead.Declare(Float)
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnHours",V.Local.Hours)
F.Global.CallWrapper.GetProperty("Test","ReturnDirectCost",V.Local.DirectCost)
F.Global.CallWrapper.GetProperty("Test","ReturnOverHead",V.Local.Overhead)
F.Global.CallWrapper.GetProperty("Test","ReturnStatus",V.Local.tStatus)
```

### Input Text File Layout

Comma-delimited file.

| # | Field Name | Data Type | Size | Notes |
|---|-----------|-----------|------|-------|
| 1 | Action | Enum | -- | `"A"` = Add, `"R"` = Reverse |
| 2 | Employee Number | Int | 5 | Requires leading zeroes (e.g., `00001`) |
| 3 | Work Order | String | 6 | |
| 4 | Work Order Suffix | String | 3 | |
| 5 | Work Order Sequence | Int | 6 | |
| 6 | Charge Date | Date | 8 | `CCYYMMDD` |
| 7 | WO Detail Key Sequence | Int | 6 | Only needed for Reversal |
| 8 | Start Time | Int | 4 | `HHMM` |
| 9 | End Time | Int | 4 | `HHMM` |
| 10 | Closed | String | 1 | `"Y"` on Add closes the operation and marks detail as closed |
| 11 | WorkCenter | String | 4 | Not needed for Reversal |
| 12 | Good Pieces | Num | 12.4 | Explicit decimal required (e.g., `10.0`). Not needed for Reversal. |
| 13 | Scrap Pieces | Num | 10.4 | Explicit decimal required (e.g., `0.0`). Not needed for Reversal. |
| 14 | Scrap Code | String | 2 | Scrap code for any scrap pieces. Leave blank if none. Not needed for Reversal. |
| 15 | Labor Type | String | 1 | `D` = Direct, `I` = Indirect, `S` = Setup. Not needed for Reversal. |
| 16 | Time Type | String | 1 | `R` = Regular, `O` = Overtime, `2` = Double Time. Not needed for Reversal. |
---
## Manufacturing.MicroEstimatingSystemLoad
Load the Micro Estimating System for a given company.

**Core Program:** `MESLOAD`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Company` | String (3) | Company code |

```
F.Global.CallWrapper.New("MicroEstimatingSystemLoad","Manufacturing.MicroEstimatingSystemLoad")
F.Global.CallWrapper.SetProperty("MicroEstimatingSystemLoad","Company","10T")
F.Global.CallWrapper.Run("MicroEstimatingSystemLoad")
```
---
## Manufacturing.ModifyJobDetailComments
Modify an existing comment associated with a job detail record.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Job` | String | 6 | Job number |
| `JobSuffix` | String | 3 | Job suffix |
| `JobSequence` | Long | 6 | Job sequence |
| `Date` | String | 6 | Date in `YYMMDD` format (can also use GAB Date type) |
| `KeySequence` | Long | 4 | Key sequence |
| `Comments` | String | Variable | New value of the comments |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The comment was successfully changed |
| `RecordNotFound` | The comment does not exist |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("ModifyComments","Manufacturing.ModifyJobDetailComments")
F.Global.CallWrapper.SetProperty("ModifyComments","Job","000155")
F.Global.CallWrapper.SetProperty("ModifyComments","JobSuffix","001")
F.Global.CallWrapper.SetProperty("ModifyComments","JobSequence",2000)
F.Global.CallWrapper.SetProperty("ModifyComments","Date","20170120")
F.Global.CallWrapper.SetProperty("ModifyComments","KeySequence",0)
F.Global.CallWrapper.SetProperty("ModifyComments","Comments","Here are the comments for this job detail.")
F.Global.CallWrapper.Run("ModifyComments")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("ModifyComments","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```
---
## Manufacturing.ModifyTaskComments
Modify an existing comment associated with a task (job sequence). Use `Manufacturing.CreateTaskComments` to create a new comment.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Job` | String | 6 | Job number |
| `JobSuffix` | String | 3 | Job suffix |
| `JobSequence` | Long | 6 | Job sequence |
| `DateTime` | String | 16 | Date/time in `YYYYMMDDHHMMSSFF` format (year, month, day, hour, minute, second, hundredths of second) |
| `User` | String | 8 | GSS username |
| `Comments` | String | Variable | New comment text |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The comment was successfully modified |
| `RecordNotFound` | The comment does not exist |
| `FileError` | Error accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("ModifyComments","Manufacturing.ModifyTaskComments")
F.Global.CallWrapper.SetProperty("ModifyComments","Job","000155")
F.Global.CallWrapper.SetProperty("ModifyComments","JobSuffix","001")
F.Global.CallWrapper.SetProperty("ModifyComments","JobSequence",2000)
F.Global.CallWrapper.SetProperty("ModifyComments","DateTime","2017012012345599")
F.Global.CallWrapper.SetProperty("ModifyComments","User","LML")
F.Global.CallWrapper.SetProperty("ModifyComments","Comments","Updated comments for this task.")
F.Global.CallWrapper.Run("ModifyComments")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("ModifyComments","Status",V.Local.sStatus)
```
---
## Manufacturing.NewSerialNumber
Create new serial numbers for a passed work order and suffix. Automatically moves serial numbers from sequence zero to the passed work order sequence.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence (defaulted to `0`) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (1) | `00` = Successful, other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.NewSerialNumber")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","000155")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence",123456)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.NewSerialNumberNoMessage
Create new serial numbers for a work order and suffix. Automatically moves serial numbers from sequence zero to the passed work order sequence. No confirmation message is produced (unlike `Manufacturing.NewSerialNumber`).

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.NewSerialNumberNoMessage")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.OpenCutList
Opens the cutlist maintenance program (`RE1053`) in open mode for the specified parent and component parts.

**Core Program:** `RE1053`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 8 | Company code |
| `ParentPart` | String | 20 | Parent part number |
| `ComponentPart` | String | 20 | Component part number |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CallingProgram` | String | Calling program name. Useful for debugging. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnedQuantity` | Float | The effect of the cutlist calculations on the component material quantity |

```
F.Global.CallWrapper.New("Test","Manufacturing.OpenCutList")
F.Global.CallWrapper.SetProperty("Test","Company","10T")
F.Global.CallWrapper.SetProperty("Test","ParentPart","0025")
F.Global.CallWrapper.SetProperty("Test","ComponentPart","1321")
F.Global.CallWrapper.Run("Test")
V.Local.fReturnedQty.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","ReturnedQuantity",V.Local.fReturnedQty)
```
---
## Manufacturing.PrintWIPToFinishedGoodsLabels
Print WIP to Finished Goods labels.

**Core Program:** `JB0640`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |
| `ClearTemp` | String | 1 | `"Y"` = True, blank = False (defaults to blank) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | Return code (see table below) |

**Returned Status:**

| Code | Description |
|------|-------------|
| `00` | Successful |
| `05` | Zero Quantity, No Label Processed |
| `10` | Parameter Error |
| `15` | Cache Overflow |
| `23` | Work Order Not Found |
| `24` | Detail Not Found |
| `35` | File Error |
| `50` | Program Missing |

```
F.Global.CallWrapper.New("Test","Manufacturing.PrintWIPToFinishedGoodsLabels")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","ClearTemp","Y")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.ProjectCrossReference
Add or update a record in the `Project_Xref` table using the passed Project, Phase, Group, Work Order, Work Order Suffix, and Work Order Sequence. Requires the Project Phase and Work Order Sequence to already exist.

**Core Program:** `PRJ800`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `Project` | String | 7 | Project number |
| `Phase` | String | 4 | Phase code |
| `Group` | String | 6 | Group code |
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Integer | 6 | Work order sequence |

**Returned Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ReturnStatus` | Enum | -- | `Success`, `ParmError`, `FileError`, `Fail` |
| `ReturnMessage` | String | 80 | Error messages: `"Invalid Project Phase"`, `"Invalid Work Order Sequence"`, `"Missing Group"`, `"Missing WO"` |
| `ReturnKey` | String | 80 | Record key if process was not successful |

```
F.Global.CallWrapper.New("Test","Manufacturing.ProjectCrossReference")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("Test","Project","PROJTST")
F.Global.CallWrapper.SetProperty("Test","Phase","PH1")
F.Global.CallWrapper.SetProperty("Test","Group","TEST2")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","TEST")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","002")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","007000")
F.Global.CallWrapper.Run("Test")
V.Local.Status.Declare(String)
V.Local.Message.Declare(String)
V.Local.Key.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnStatus",V.Local.Status)
F.Global.CallWrapper.GetProperty("Test","ReturnMessage",V.Local.Message)
F.Global.CallWrapper.GetProperty("Test","ReturnKey",V.Local.Key)
V.Local.FullText.Declare(String)
F.Intrinsic.String.Concat(V.Local.Status," ",V.Local.Message," ",V.Local.Key,V.Local.FullText)
F.Intrinsic.UI.Msgbox(V.Local.FullText,"Return Values")
```
---
## Manufacturing.PromoteSerialNumber
Promote serial numbers from the passed sequence to the next sequence.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `Quantity` | Double | 12 (8.4) | Quantity |
| `GoodPieces` | Double | 12 (8.4) | Good pieces |
| `ScrapPieces` | Double | 12 (8.4) | Scrap pieces |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `User` | String | 8 | User ID to override audit trail (e.g. `SUPERVSR`) |
| `QualityNumber` | UInteger | 7 | Only pass when also passing scrap pieces and intending to create an NCMR within JB0343 |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.PromoteSerialNumber")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000010")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","ScrapPieces",0.0)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.PromoteSerialNumberToFinishedGoods
Promote serial numbers from the passed sequence to the Finished Goods sequence. Also allows serial numbers on the Finished Goods sequence to be reversed back to a prior sequence.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |
| `GoodPieces` | Double | 12 (8.4) | Good pieces (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.PromoteSerialNumberToFinishedGoods")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000001")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.PromoteSerialNumberToFinishedGoodsOnly
Promote serial numbers to the Finished Goods sequence. Only used when the option to *Serialize but Not Track* is enabled.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `GoodPieces` | Double | 12 (8.4) | Good pieces (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.PromoteSerialNumberToFinishedGoodsOnly")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.ReverseWipToFinishedGood
Reverses a WIP-to-Finished-Good transaction screenlessly. Requires a Work Order Detail Record key. Will reopen work orders that were set as Closed on the Job Header.

**Core Program:** `JB0052GI`

> **Prerequisites:**
> - Sequence must be `999999`
> - Sequence must not have already been reversed
> - `IsNegativeWIP` (`JOB_DETAIL.NEG_WIP_FG_DONE`) must NOT be `Y`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `WorkOrder` | String | 6 | Work order number |
| `Suffix` | String | 3 | Work order suffix |
| `Sequence` | Integer | 6 | Work order sequence |
| `DetailDate` | Date | 6 | Detail date (format `YYMMDD`) |
| `DetailKeySequence` | Integer | 4 | Detail key sequence |
| `TransferDate` | Date | 8 | Transfer date (format `YYYYMMDD`) |
| `PrintAudit` | Enum | | `0` = No report, `1` = Print audit report, `2` = Populate BI table only (no report) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | Enum | Return status (see table below) |
| `ErrorMessage` | String (256) | Error details when status is not successful |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Process completed successfully |
| `Failed` | Invalid Sequence (requires `999999`), Sequence already reversed, or other error (see `ErrorMessage`) |
| `InvalidTransferDate` | Date in `TransferDate` is invalid |
| `NotFound` | WO Detail record not found, WO Header not found, or WO Header flagged as Lot-to-Lot (reversal not supported). See `ErrorMessage`. |

```
F.Global.CallWrapper.New("Test","Manufacturing.ReverseWipToFinishedGood")
F.Global.CallWrapper.SetProperty("Test","Company","32B")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500003")
F.Global.CallWrapper.SetProperty("Test","Suffix","000")
F.Global.CallWrapper.SetProperty("Test","Sequence",999999)
F.Global.CallWrapper.SetProperty("Test","DetailDate",171031)
F.Global.CallWrapper.SetProperty("Test","DetailKeySequence",0001)
F.Global.CallWrapper.SetProperty("Test","TransferDate",20251206)
F.Global.CallWrapper.SetProperty("Test","PrintAudit",1)
F.Global.CallWrapper.Run("Test")
V.Local.Status.Declare(String)
V.Local.ReturnMessage.Declare(String)
V.Local.StatusMessage.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.Status)
F.Global.CallWrapper.GetProperty("Test","ErrorMessage",V.Local.ReturnMessage)
F.Intrinsic.String.Concat(V.Local.Status," - ",V.Local.ReturnMessage,V.Local.StatusMessage)
F.Intrinsic.UI.Msgbox(V.Local.StatusMessage,"Return Status Message")
```
---
## Manufacturing.ScheduleExistingWorkOrder
Schedule an existing work order using forward, backward, or from-current-sequence scheduling.

**Core Program:** `JB0011CL`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `Scheduling` | String | 1 | `0` = None, `1` = Forward, `2` = Backward, `3` = FromCurrentSequence |
| `StartDate` | String | -- | Start date in regional date format (`MM/DD/CCYY`) |
| `DueDate` | String | -- | Due date in regional date format (`MM/DD/CCYY`) |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `HideWindow` | Boolean | `True` to hide window, `False` to display window |

> **Note:** Regional date setting is `MM/DD/CCYY` format.

```
F.Global.CallWrapper.New("Test","Manufacturing.ScheduleExistingWorkOrder")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000001")
F.Global.CallWrapper.SetProperty("Test","Scheduling","1")
F.Global.CallWrapper.SetProperty("Test","StartDate","12/01/2021")
F.Global.CallWrapper.SetProperty("Test","DueDate","12/01/2021")
F.Global.CallWrapper.SetProperty("Test","HideWindow",True)
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.SerializationDetailView
Launch the serialization detail view screen for a job.

**Core Program:** `JB0353`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Job` | String | 6 | Job number |
| `JobSuffix` | String | 3 | Job suffix |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Serial` | String | 30 | Serial number |

```
F.Global.CallWrapper.New("Test","Manufacturing.SerializationDetailView")
F.Global.CallWrapper.SetProperty("Test","Job","000155")
F.Global.CallWrapper.SetProperty("Test","JobSuffix","001")
F.Global.CallWrapper.SetProperty("Test","Serial","SER00001")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.SerialNumberReversal
Demote or reverse serial numbers from the passed sequence to the prior sequence.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.SerialNumberReversal")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000001")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.StandaloneSerialNumber
Standalone serial number entry. Functions like Administrator Mode.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `GoodPieces` | Double | 12 (8.4) | Good pieces (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.StandaloneSerialNumber")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000001")
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.TaskSignoff
Sign off tasks for all jobs within a specified beginning-to-ending range.

**Core Program:** `JB0028`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `BeginningJob` | String | 6 | Beginning job number |
| `BeginningJobSuffix` | String | 3 | Beginning job suffix |
| `BeginningJobSequence` | Long | 6 | Beginning job sequence |
| `EndingJob` | String | 6 | Ending job number |
| `EndingJobSuffix` | String | 3 | Ending job suffix |
| `EndingJobSequence` | Long | 6 | Ending job sequence |
| `SignoffUser` | String | 8 | GSS username |

```
F.Global.CallWrapper.New("Test","Manufacturing.TaskSignoff")
F.Global.CallWrapper.SetProperty("Test","BeginningJob","000155")
F.Global.CallWrapper.SetProperty("Test","BeginningJobSuffix","001")
F.Global.CallWrapper.SetProperty("Test","BeginningJobSequence","002000")
F.Global.CallWrapper.SetProperty("Test","EndingJob","000155")
F.Global.CallWrapper.SetProperty("Test","EndingJobSuffix","001")
F.Global.CallWrapper.SetProperty("Test","EndingJobSequence","003000")
F.Global.CallWrapper.SetProperty("Test","SignoffUser","JSMITH")
F.Global.CallWrapper.Run("Test")
```
---
## Manufacturing.TimeAndAttendance
Run the Time and Attendance process screenless using an input text file.

**Core Program:** `JB033A`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `FileName` | String | 256 | Full path to the input text file (see layout below) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Process completed successfully |
| `ParmError` | Process cancelled due to missing FileName |
| `Files` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Manufacturing.TimeAndAttendance")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","FileName","D:\apps\global\files\JB033ATEST.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.Status.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnStatus",V.Local.Status)
F.Intrinsic.UI.Msgbox(V.Local.Status,"Return Status")
```

### Input Text File Layout

Comma-delimited file.

| # | Field Name | Data Type | Size | Notes |
|---|-----------|-----------|------|-------|
| 1 | Action | String | 1 | `"A"` = New, `"U"` = Update, `"D"` = Delete |
| 2 | Employee | String | 5 | Requires leading zeroes (e.g., `00001`). Employee master is read for the name. **Note:** If an active termination date precedes the charge date, the status returns failed. |
| 3 | Record Type | String | 1 | `T` = Time/Attendance, `A` = Absentee |
| 4 | Shift | String | 1 | Leave blank to pull from Employee master |
| 5 | Department | String | 4 | Leave blank to pull from Employee master |
| 6 | Group | String | 8 | Leave blank to pull from Employee master |
| 7 | Full Days | String | 1 | `"Y"` or blank. If `"Y"`, pulls FULL day schedule from Employee/Shift record (*On Line System > File > Employee Shift Maintenance*) and the associated shift schedule (*On Line System > File > Shift Maintenance > Open*). If `"Y"`, only fields 8 and 9 (Start Date/Time) are needed. |
| 8 | Start Date | Date | 8 | `CCYYMMDD` |
| 9 | Start Time | Integer | 6 | `HHMMSS` |
| 10 | End Date | Date | 8 | `CCYYMMDD` |
| 11 | End Time | Integer | 6 | `HHMMSS` |
| 12 | Hours | Integer | 4 | `HHMM` format. Leave blank to auto-calculate from Start/End Date/Time. |
| 13 | Charge Date | Date | 8 | **Required.** `CCYYMMDD` |
| 14 | Paid | String | 1 | `"Y"` or blank. Absentee records only. |
| 15 | Excused | String | 1 | `"Y"` or blank. Absentee records only. |
| 16 | Absentee Type | String | 2 | Absence type code (e.g., `00`, `01`). Derived from *System Support > Administration > Company Options (Standard) > Payroll*. Usually `"00"` = Unpaid. Absentee records only. |
| 17 | Absence Description | String | 20 | Absentee records only. |
---
## Manufacturing.UnattendedForecastMaintenance
Call the Forecast Maintenance System to import and/or schedule Forecast Work Orders.

**Required Properties:** None

**Optional Properties:** None

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Forecast maintenance ran successfully |
| `NoMoreRequirements` | No Forecast records to schedule |

```
F.Global.CallWrapper.New("Test","Manufacturing.UnattendedForecastMaintenance")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Manufacturing.UpdateWorkOrderSequences
Add, edit, or delete work order sequences using an input text file. Supports Material, Labor, Outside, Comment, and Task sequence types.

**Core Program:** `JB0012`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `SchedulingDirection` | Enum | | `0` = Forward, `1` = Backward, `2` = Forward With Material |
| `StartDate` | Date | | Start date |
| `DueDate` | Date | | Due date |
| `UpdateRouter` | Boolean | | Update router |
| `HideWindow` | String | | `Screenless` or empty |
| `InputFileName` | String | 15 | Text file in `Global\Files` (no sub-folders). Do not include file extension. |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process completed successfully |
| `InvalidParameter` | Invalid or missing passed property |
| `ImportFileError` | Import file not found |
| `FileError` | File error |
| `Failure` | Other failure has occurred |

**Input Text File** (`*!*` delimited, `.txt` in `Global\Files`, no sub-folders):

**Legend:** `R` = Required, `RN` = Required in New Mode, `X` = Available to set

| # | Field Name | Data Type | Size | Material | Labor | Outside | Comment | Task |
|---|-----------|-----------|------|----------|-------|---------|---------|------|
| 1 | Mode | Enum | `N`/`O`/`D` | R | R | R | R | R |
| 2 | Work Order Seq | Int | 6 | R | R | R | R | R |
| 3 | LMO (Sequence Type) | Enum | `M`/`L`/`O`/`C`/`T` | RN | RN | RN | RN | RN |
| 4 | Part | String | 17 (rev on) / 20 (rev off) | X | | | | |
| 5 | Part Rev | String | 3 | X | | | | |
| 6 | Op Code | String | 6 | X | X | X | X | X |
| 7 | Set Up Quantity/Hours | Num | 8.4 | X | X | X | | |
| 8 | Quantity | Num | 8.4 | X | | X | | |
| 9 | UM | String | 2 | X | | X | | |
| 10 | Rate | Num | 8.4 | X | X | X | | |
| 11 | Min | Num | 8.2 | X | | X | | |
| 12 | Lead Time | Int | 4 | X | | X | | |
| 13 | Frequency | Num | 6.4 | X | X | X | | |
| 14 | Description | String | 30 | X | X | X | X | X |
| 15 | Vendor | String | 6 | | | X | | |
| 16 | Tooling Flag | String | 1 (`Y`/space) | X | | | | |
| 17 | WorkCenter | String | 4 | | R | | | |
| 18 | RunTime | Num | 7.4 | | X | | | |
| 19 | Crew Size | Num | 4.4 | | X | | | |
| 20 | Overlap | Int | 2 | X | X | | | X |
| 21 | WC Factor | Int | 2 | X | X | | | |
| 22 | Duration | Num | 7.4 | | | | | X |
| 23 | Sort Code | String | 20 | X | X | X | | X |
| 24 | Comp Req Flag | String | 1 (`Y`/space) | | | | | X |
| 25 | Start Date | Date | CCYYMMDD | X | X | X | | X |
| 26 | Task Signoff User | String | 8 | | | | | R |
| 27 | Project Group | String | 6 | X | X | X | | X |
| 28 | Hold, No PO | String | 1 (`Y`/space) | X | | | | |

**Record Layout Examples** (in `*!*` delimited file):

*Material Sequence:*
`Mode(N,O,D)*!*Seq*!*LMO(M)*!*Part*!*PartRev*!*OpCode*!*SetUpQty*!*Qty*!*UM*!*Rate*!*Min*!*LeadTime*!*Freq*!*Description*!* *!*ToolingFlag*!* *!* *!* *!*Overlap*!*WCFactor*!* *!*SortCode*!* *!*StartDateYYYYMMDD*!* *!**!*HoldPOFlag`

*Labor Sequence:*
`Mode(N,O,D)*!*Seq*!*LMO(L)*!* *!* *!*StdOper*!*SetUpHours*!* *!* *!*Rate*!* *!* *!*Freq*!*Description*!* *!* *!*WorkCenter*!*RunTime*!*CrewSize*!*Overlap*!*WCFactor*!* *!*SortCode*!* *!*StartDateYYYYMMDD*!* *!*ProjectGroup*!*`

*Outside Sequence:*
`Mode(N,O,D)*!*Seq*!*LMO(O)*!* *!* *!*OpCode/OutsideCode*!*SetUpQty*!*Quantity*!*UM*!*Rate*!*Min*!*LeadTime*!*Freq*!*Description*!*Vendor*!* *!* *!* *!* *!* *!* *!* *!*SortCode*!* *!*StartDateYYYYMMDD*!* *!*ProjectGroup*!*`

*Task Sequence:*
`Mode(N,O,D)*!*Seq*!*LMO(T)*!* *!* *!*OpCode/TaskList*!* *!* *!* *!* *!* *!* *!**!*Description*!* *!* *!* *!* *!* *!*Overlap*!* *!*Duration*!*SortCode*!*CompletionReqFlag*!*StartDateYYYYMMDD*!*TaskSignOffUser*!*ProjectGroup*!*`

*Comment Sequence:*
`Mode(N,O,D)*!*Seq*!*LMO(C)*!* *!* *!*OpCode/StdOper*!* *!* *!* *!* *!* *!* *!* *!*Description/Comments*!* *!* *!* *!* *!* *!* *!* *!* *!* *!* *!* *!* *!*`

```
V.Local.tDate1.Declare(Date)
V.Local.tDate2.Declare(Date)
V.Local.tDate1.Set(01/01/1900)
V.Local.tDate2.Set(12/25/2021)
V.Local.Router.Declare(Boolean)
V.Local.Screenless.Declare(Boolean)
V.Local.Router.Set(False)
V.Local.Screenless.Set(False)
F.Global.CallWrapper.New("Test","Manufacturing.UpdateWorkOrderSequences")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","TEST")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","SchedulingDirection","1")
F.Global.CallWrapper.SetProperty("Test","StartDate",V.Local.tDate1)
F.Global.CallWrapper.SetProperty("Test","DueDate",V.Local.tDate2)
F.Global.CallWrapper.SetProperty("Test","UpdateRouter",V.Local.Router)
F.Global.CallWrapper.SetProperty("Test","HideWindow",V.Local.Screenless)
F.Global.CallWrapper.SetProperty("Test","InputFileName","SampleFile")
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
```
---
## Manufacturing.VerifyOnHandMaterial
Verify on-hand material availability for a work order sequence.

**Core Program:** `JB0660`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 6 | Work order sequence |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |
| `IssueData` | Double (12, 8.4) | The lowest material quantity that can be issued |

```
F.Global.CallWrapper.New("Test","Manufacturing.VerifyOnHandMaterial")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","000001")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
V.Local.fIssueData.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","IssueData",V.Local.fIssueData)
```
---
## Manufacturing.ViewSerialNumber
View serial numbers for a work order.

**Core Program:** `JB0343`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, Other = Failure |

```
F.Global.CallWrapper.New("Test","Manufacturing.ViewSerialNumber")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Manufacturing.WipToFinishedGoodsLotToLot
Normal mode WIP to Finished Goods with lot-to-lot tracking.

**Core Program:** `JB0252`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `WorkOrder` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | Long | 6 | Work order sequence |
| `PartNumber` | String | 20 | Part number |
| `PartLocation` | String | 2 | Part location |
| `PartDescription` | String | 30 | Part description |
| `Quantity` | Double | 12 (8.4) | Quantity (max 8 digit whole, 4 digit decimal) |
| `GoodPieces` | Double | 12 (8.4) | Good pieces (max 8 digit whole, 4 digit decimal) |
| `ScrapPieces` | Double | 12 (8.4) | Scrap pieces (max 8 digit whole, 4 digit decimal) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Close` | String (1) | `"Y"` if closed |
| `Quantity` | Double (12, 8.4) | Lot quantity selected |

```
F.Global.CallWrapper.New("Test","Manufacturing.WipToFinishedGoodsLotToLot")
F.Global.CallWrapper.SetProperty("Test","WorkOrder","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence",123456)
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","PartLocation","TX")
F.Global.CallWrapper.SetProperty("Test","PartDescription","Widget Assembly A")
F.Global.CallWrapper.SetProperty("Test","Quantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","GoodPieces",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","ScrapPieces",12345678.1234)
F.Global.CallWrapper.Run("Test")
V.Local.sClose.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Close",V.Local.sClose)
V.Local.fQuantity.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","Quantity",V.Local.fQuantity)
```
---
## Manufacturing.WipToWipTransfer
WIP-to-WIP transfer using a comma-delimited file.

**Core Program:** `JB0066`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `FileName` | String | 15 | Comma-delimited file. Layout: `From Work Order, From WO Suffix, To Work Order, To WO Suffix, To WO Sequence, Transfer Date (optional), Closed Flag, Quantity, Cost (if not closing), Price (optional)` |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `PrintAuditTrail` | Boolean | When running screenless, set to `True` to print the WIP-to-WIP transfer audit trail report. `False` to suppress. No effect in interactive mode. |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Transfer completed successfully |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Manufacturing.WipToWipTransfer")
F.Global.CallWrapper.SetProperty("Test","FileName","WIPTRANSFER.TXT")
F.Global.CallWrapper.SetProperty("Test","PrintAuditTrail","True")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Manufacturing.WorkOrderHistoryByPart
View work order history by part (calls `INV503` from Supply and Demand).

**Core Program:** `INV503`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 20 | Part number |
| `PartLocn` | String | 2 | Part location |
| `PartDesc` | String | 30 | Part description |
| `UseRev` | String | 1 | Use revision flag |
| `Switch` | String | 1 | Switch flag |

**Returned Properties:** None

```
F.Global.CallWrapper.New("WorkOrderHistoryByPart","Manufacturing.WorkOrderHistoryByPart")
F.Global.CallWrapper.SetProperty("WorkOrderHistoryByPart","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("WorkOrderHistoryByPart","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("WorkOrderHistoryByPart","PartLocn","TX")
F.Global.CallWrapper.SetProperty("WorkOrderHistoryByPart","PartDesc","Widget Assembly A")
F.Global.CallWrapper.SetProperty("WorkOrderHistoryByPart","UseRev","Y")
F.Global.CallWrapper.SetProperty("WorkOrderHistoryByPart","Switch","Y")
F.Global.CallWrapper.Run("WorkOrderHistoryByPart")
```
---

