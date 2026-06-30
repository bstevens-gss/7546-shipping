# GAB CallWrapper Reference -- Quality
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for quality programs
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

# Quality

## Quality.CreateStandAloneRMA
Creates a screenless stand-alone RMA. Uses a GAB GUI interface and an input file to: add a stand-alone RMA header, add associated lines, roll to a real RMA with service type and return quantity, and optionally print the new RMA.

**Core Program:** `RMAUPL`

**Required Properties:**

| Property | Type | Size | Required | Description |
|----------|------|------|----------|-------------|
| `CompanyCode` | String | 3 | Yes | Company code |
| `Mode` | String | 1 | Yes | Always set to `S` |
| `InvoiceNumber` | String | 7 | Yes | Invoice number |
| `OrderNumber` | String | 7 | Yes | Order number |
| `SequenceNumber` | String | 4 | Yes | Sequence number |
| `FileName` | String | | Yes | Pre-formatted input file (see layout below) |
| `CustomerCode` | String | 6 | Yes | Customer code |
| `OrderDate` | String | 10 | | Date format `CCYY-MM-DD` |
| `DueDate` | String | 10 | | Date format `CCYY-MM-DD` |
| `ShipDate` | String | 10 | | Date format `CCYY-MM-DD` |
| `SalesPerson` | String | | | Salesperson code |
| `User1` | String | | | User field 1 |
| `User2` | String | | | User field 2 |
| `User3` | String | | | User field 3 |
| `User4` | String | | | User field 4 |
| `User5` | String | | | User field 5 |
| `CustomerPO` | String | | | Customer PO |
| `PrintFlag` | Boolean | | | Defaults to `False`. Set to `True` to print the new RMA. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | `Success` or `Failed` (General Fail Error) |
| `ReturnRMAId` | String | RMA number created (when status is successful) |

**Input File Layout** (fixed-position format, 500 bytes per record):

| Level | Field Name | Type | Start | Length | Notes |
|-------|-----------|------|-------|--------|-------|
| 5 | WS-RMAUPL-KEY-SORT | Alpha | 1 | 22 | Key sort area |
| 10 | WS-RMAUPL-KEY-INVOICE | Alpha | 1 | 7 | Invoice number (*) |
| 10 | WS-RMAUPL-KEY-ORDER | Alpha | 8 | 7 | Order number (*) |
| 10 | WS-RMAUPL-KEY-ORDER-SEQ | Alpha | 15 | 4 | Order sequence (*) |
| 10 | WS-RMAUPL-KEY-LINE-NUM | Numeric | 19 | 3 | Line number (*) |
| 10 | WS-RMAUPL-KEY-LINE-TYPE | Alpha | 22 | 1 | Line type (**) |
| 5 | WS-RMAUPL-PART-NUM | Alpha | 23 | 20 | Part number (*) |
| 10 | WS-RMAUPL-PART | Alpha | 23 | 17 | Part (within part-num) (*) |
| 10 | WS-RMAUPL-REV | Alpha | 40 | 3 | Revision (*) |
| 5 | WS-RMAUPL-LOCN | Alpha | 43 | 2 | Location (*) |
| 5 | WS-RMAUPL-QTY-ORDERED | Signed Num | 45 | 15 | Quantity ordered (*) |
| 5 | WS-RMAUPL-QTY-SHIPPED | Signed Num | 60 | 15 | Quantity shipped (*) |
| 5 | WS-RMAUPL-COST | Signed Num | 75 | 16 | Cost (*) |
| 5 | WS-RMAUPL-GL-DIST | Alpha | 91 | 15 | GL distribution |
| 5 | WS-RMAUPL-TAX-STATUS | Alpha | 106 | 1 | Tax status |
| 5 | WS-RMAUPL-VAT-RULE | Numeric | 107 | 2 | VAT rule |
| 5 | WS-RMAUPL-LN-USER-AREA | Alpha | 109 | 150 | Line user area |
| 10 | WS-RMA-UPL-LN-USER(1) | Alpha | 109 | 30 | Line user 1 |
| 10 | WS-RMA-UPL-LN-USER(2) | Alpha | 139 | 30 | Line user 2 |
| 10 | WS-RMA-UPL-LN-USER(3) | Alpha | 169 | 30 | Line user 3 |
| 10 | WS-RMA-UPL-LN-USER(4) | Alpha | 199 | 30 | Line user 4 |
| 10 | WS-RMA-UPL-LN-USER(5) | Alpha | 229 | 30 | Line user 5 |
| 5 | WS-RMAUPL-LOT | Alpha | 259 | 15 | Lot |
| 5 | WS-RMAUPL-BIN | Alpha | 274 | 6 | Bin |
| 5 | WS-RMAUPL-HEAT | Alpha | 280 | 15 | Heat |
| 5 | WS-RMAUPL-SERIAL | Alpha | 295 | 30 | Serial |
| 5 | WS-RMAUPL-LOTBIN-QTY | Alpha | 325 | 13 | Lot/bin quantity |
| 5 | WS-RMAUPL-RMA-RET-QTY | Signed Num | 338 | 13 | RMA return quantity |
| 5 | WS-RMAUPL-RMA-SVC-REQ | Alpha | 351 | 3 | RMA service request |
| 5 | FILLER | Alpha | 354 | 147 | Filler |

> **Process Notes:**
> - Cost should only be passed for non-inventory parts. Non-zero cost for inventory parts will be overridden with inventory master cost (logged as warning, still returns success).
> - For lot/bin parts, `WS-RMAUPL-LOTBIN-QTY` is used as shipped qty and tallied to match `WS-RMAUPL-QTY-SHIPPED` of the main part.
> - Error log is written to the files directory as `RMAUPCCC.ERR` (where `CCC` is the company code).
> - View created RMAs at: *Quality > Transactions > RMA > Update RMA*.

```
F.Global.CallWrapper.New("Test","Quality.CreateStandAloneRMA")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","0CM")
F.Global.CallWrapper.SetProperty("Test","Mode","S")
F.Global.CallWrapper.SetProperty("Test","InvoiceNumber","323232 ")
F.Global.CallWrapper.SetProperty("Test","OrderNumber","0323232")
F.Global.CallWrapper.SetProperty("Test","SequenceNumber","0000")
F.Global.CallWrapper.SetProperty("Test","FileName","RMAUPLLOTBIN.TXT")
F.Global.CallWrapper.SetProperty("Test","CustomerCode","AMD   ")
F.Global.CallWrapper.SetProperty("Test","OrderDate","2026-01-01")
F.Global.CallWrapper.SetProperty("Test","DueDate","2026-01-01")
F.Global.CallWrapper.SetProperty("Test","ShipDate","2026-01-01")
F.Global.CallWrapper.SetProperty("Test","SalesPerson","MS")
F.Global.CallWrapper.SetProperty("Test","User1","ERIKA")
F.Global.CallWrapper.SetProperty("Test","User2","KEYLA")
F.Global.CallWrapper.SetProperty("Test","User3","MARIA")
F.Global.CallWrapper.SetProperty("Test","User4","BRENDA")
F.Global.CallWrapper.SetProperty("Test","User5","MANDY")
F.Global.CallWrapper.SetProperty("Test","CustomerPO","POSPE00")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sRMA.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ReturnRMAId",V.Local.sRMA)
```
---
## Quality.NewEngineeringChangeControl
Create a new Engineering Change Control record.

**Core Program:** `ENG002`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Prefix` | String | 2 | Prefix |
| `Number` | Long | 8 | Engineering control number |

```
F.Global.CallWrapper.New("Test","Quality.NewEngineeringChangeControl")
F.Global.CallWrapper.SetProperty("Test","Prefix","EC")
F.Global.CallWrapper.SetProperty("Test","Number","00001234")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Quality.OpenEngineeringChangeControl
Open an engineering change control record for editing.

**Core Program:** `ENG002`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Prefix` | String | 2 | Engineering change prefix |
| `Number` | Long | 8 | Engineering control number |

```
F.Global.CallWrapper.New("Test","Quality.OpenEngineeringChangeControl")
F.Global.CallWrapper.SetProperty("Test","Prefix","EC")
F.Global.CallWrapper.SetProperty("Test","Number","00012345")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Quality.OpenRejectDispositionControl
Opens Quality Reject/Disposition with the specified control number populated.

**Core Program:** `JB0027`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `QualityNumber` | Long | 7 | Quality control number |

```
F.Global.CallWrapper.New("Test","Quality.OpenRejectDispositionControl")
F.Global.CallWrapper.SetProperty("Test","QualityNumber","1234567")
F.Global.CallWrapper.Run("Test")
```
---
## Quality.OpenRejectDispositionControlHistory
Opens Quality Reject/Disposition in history mode with the specified control number populated.

**Core Program:** `JB0027`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `QualityNumber` | Long | 7 | Quality control number |

```
F.Global.CallWrapper.New("Test","Quality.OpenRejectDispositionControlHistory")
F.Global.CallWrapper.SetProperty("Test","QualityNumber","1234567")
F.Global.CallWrapper.Run("Test")
```
---
## Quality.ViewEngineeringChangeControl
View an engineering change control record.

**Core Program:** `ENG002`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Prefix` | String | 2 | Engineering change prefix |
| `Number` | Long | 8 | Engineering control number |

```
F.Global.CallWrapper.New("Test","Quality.ViewEngineeringChangeControl")
F.Global.CallWrapper.SetProperty("Test","Prefix","EC")
F.Global.CallWrapper.SetProperty("Test","Number","00012345")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Quality.ViewRejectDispositionControl
Opens Quality Reject/Disposition in view-only mode with the specified control number populated.

**Core Program:** `JB0027`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `QualityNumber` | Long | 7 | Quality control number |

```
F.Global.CallWrapper.New("Test","Quality.ViewRejectDispositionControl")
F.Global.CallWrapper.SetProperty("Test","QualityNumber","1234567")
F.Global.CallWrapper.Run("Test")
```
---
## Quality.ViewRejectDispositionControlHistory
Opens Quality Reject/Disposition in history view-only mode with the specified control number populated.

**Core Program:** `JB0027`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `QualityNumber` | Long | 7 | Quality control number |

```
F.Global.CallWrapper.New("Test","Quality.ViewRejectDispositionControlHistory")
F.Global.CallWrapper.SetProperty("Test","QualityNumber","1234567")
F.Global.CallWrapper.Run("Test")
```
---

