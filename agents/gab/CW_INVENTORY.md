# GAB CallWrapper Reference -- Inventory
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for inventory programs
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

# Inventory

## Inventory.AddItemMaintenance
Launches the Item Maintenance screen to allow adding additional Item Master records for an existing Lot/Bin part.

**Core Program:** `INV014GI`

> **Requirements:**
> - Valid inventory part
> - Inventory part must have Lot/Bin set to `'Y'`
> - If Lot/Bin flag is NOT `'Y'`, use `Inventory.AddNewItemMaintenance` instead
> - Inventory On Hand Quantity > 0 **or** existing Item Master records for the part

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Item maintenance record added successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `PartNotLotBin` | Part not flagged as Lot/Bin in Inventory Master |
| `PartOnHandZero` | Inventory Master OnHand is zero and does not exist in Item Master |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.AddItemMaintenance")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TEST PART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","TX")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```

---
## Inventory.AddNewItemMaintenance
Launches the Item Maintenance screen to add the first lot/bin record for a non-Lot/Bin part.

**Core Program:** `INV021GI`

> **Requirements:**
> - Valid inventory part
> - Inventory part must **NOT** have Lot/Bin set to `'Y'`
> - If Lot/Bin flag IS `'Y'`, use `Inventory.AddItemMaintenance` to add additional Item Master records
> - Inventory On Hand Quantity > 0
> - If using LIFO/FIFO, Inventory Cost > 0

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | First lot/bin record added successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `PartLotBin` | Inventory part Lot/Bin set to `'Y'`, Item Master records exist |
| `PartOnHandZero` | Inventory Master OnHand is zero |
| `PartLifoError` | Using LIFO/FIFO and cost is zero |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.AddNewItemMaintenance")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TEST PART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","TX")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Inventory.CreateNcmrFromInventory
Process NCMRs (Non-Conforming Material Reports) from a comma-delimited text file.

**Core Program:** `INV220GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `FileName` | String | 18 | File name (extension `.TXT`). See input file layout below. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ErrorCount` | Integer | Count of records that had errors and did not process |

```
F.Global.CallWrapper.New("TEST","Inventory.CreateNcmrFromInventory")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("TEST","FileName","NCMR_IMPORT.TXT")
F.Global.CallWrapper.Run("TEST")
V.Local.tErrorCount.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","ErrorCount",V.Local.tErrorCount)
F.Intrinsic.UI.Msgbox(V.Local.tErrorCount,"Error Count")
```

### Input Text File Layout

Comma-delimited text file (`.TXT`).

| # | Field Name | Size | Notes |
|---|-----------|------|-------|
| 1 | Part | 20 | |
| 2 | Rev | 3 | If used |
| 3 | Location | 2 | |
| 4 | Date | 8 | `CCYYMMDD` |
| 5 | Reference | 15 | |
| 6 | Quantity | 16 | Include decimal point and up to 6 decimals |
| 7 | Cost | 16 | Include decimal point and up to 6 decimals |
| 8 | GL Account | 15 | |
| 9 | WO In History | 1 | `Y` if history WO, `N` otherwise |
| 10 | Job | 6 | |
| 11 | Job Suffix | 3 | |
| 12 | Job Sequence | 6 | |
| 13 | Scrap Code | 2 | |
| 14 | Lot | 15 | |
| 15 | Bin | 6 | |
| 16 | Heat | 15 | |
| 17 | Serial | 30 | |
| 18 | Do Not Remove Part From Inventory | 1 | `Y` = do not remove, `N` = remove |
| 19 | Customer NCMR | 15 | Optional |
| 20 | PO Number | 7 | |
| 21 | PO Line | 3 | |

### Returned Files

- **NCMRs Created:** Same filename with `.DONE` appended. Layout: `NCMR number 9(7), Part X(20), Rev X(3), Locn X(2)`
- **Records with Errors:** Same filename with `.ERROR` appended. Layout: `Original Record X(250), Error Tag X(20), Error Message X(50)`
---
## Inventory.DeleteItemMaintenance
Launches the Item Maintenance screen to allow deleting existing Item Master records. Initially launches the item master browser to select a record to delete.

**Core Program:** `INV014GI`

> **Requirements:**
> - Valid inventory part
> - Inventory part must have Lot/Bin set to `'Y'`
> - Inventory On Hand Quantity > 0 **or** existing Item Master records for the part

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Item maintenance record deleted successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `PartNotLotBin` | Part not flagged as Lot/Bin in Inventory Master |
| `PartOnHandZero` | Inventory Master OnHand is zero and does not exist in Item Master |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.DeleteItemMaintenance")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TEST PART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","TX")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Inventory.GetLongCustomerPartNumber
Return the displayable Long Customer Part Number from the `LPART_CUST_XREF` table (`cccLONGCUSTPARTXREF-V0` file) given a GSS Internal Short Customer Number.

When the Advanced Inventory option *Use Long XRef* is enabled, any customer part entry longer than 20 characters is automatically added to a cross-reference table with a shortened version used throughout the system.

**Core Program:** `ProcessLongPart`

**Full Name:** `GSSEO.CallWrappers.Inventory.GetLongCustomerPartNumber`

> **Version Requirements:** Minimum `2019.1`. Make sure to override the `GLOBALVERSION` environment variable with `2019.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `ShortPartNumber` | String | Yes | GSS Internal Short Customer Number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `LongPartNumber` | String | Displayable Long Customer Part Number |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `35` | ParameterError | The parameters were not valid |
| `99` | Failed | Unable to open cross-reference file |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Inventory.GetLongCustomerPartNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","ShortPartNumber","THISISAREALL001||")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sLongPart.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","LongPartNumber",V.Local.sLongPart)
```
---
## Inventory.GetLongManufacturerPartNumber
Return the displayable Long Manufacturer Part Number from the `LPART_MFG_XREF` table (`cccLONGMFGPARTXREF-V0` file) given a GSS Internal Short Manufacturer Number.

When the Advanced Inventory option *Use Long XRef* is enabled, any manufacturer part entry longer than 20 characters is automatically added to a cross-reference table with a shortened version used throughout the system.

**Core Program:** `ProcessLongPart`

**Full Name:** `GSSEO.CallWrappers.Inventory.GetLongManufacturerPartNumber`

> **Version Requirements:** Minimum `2019.1`. Make sure to override the `GLOBALVERSION` environment variable with `2019.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `ShortPartNumber` | String | Yes | GSS Internal Short Manufacturer Number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `LongPartNumber` | String | Displayable Long Manufacturer Part Number |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `35` | ParameterError | The parameters were not valid |
| `99` | Failed | Unable to open cross-reference file |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Inventory.GetLongManufacturerPartNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","466")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","ShortPartNumber","THISISAREALL001||")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sLongMfgPart.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","LongPartNumber",V.Local.sLongMfgPart)
' Expected: V.Local.sLongMfgPart = "THISISAREALLYREALLYLONGPARTNUMBER"
```

---
## Inventory.GetLongPartNumber
Return the displayable Long Part/Rev from the `INV_LXR` table (`cccLONGPARTXREF-V0` file) given an internal GSS Short Part/Rev.

When the Advanced Inventory option *Use Long Part* is enabled, any part entry longer than 20 characters (or 17 with *Use Revision Levels*) is automatically added to a cross-reference table with a shortened version used throughout the system.

**Core Program:** `ProcessLongPart`

**Full Name:** `GSSEO.CallWrappers.Inventory.GetLongPartNumber`

> **Version Requirements:** Minimum `2019.1`. Make sure to override the `GLOBALVERSION` environment variable with `2019.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `ShortPartNumber` | String | Yes | GSS internal short part number |
| `ShortPartNumberRevision` | String | No | GSS internal short part number revision |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `LongPartNumber` | String | Displayable long part number |
| `LongPartNumberRevision` | String | Displayable long part number revision |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `35` | ParameterError | The parameters were not valid |
| `99` | Failed | Unable to open cross-reference file |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Inventory.GetLongPartNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","ShortPartNumber","THISISAREALL001||")
F.Global.CallWrapper.SetProperty("Test","ShortPartNumberRevision","123")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sLongPart.Declare(String)
V.Local.sLongPartRev.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","LongPartNumber",V.Local.sLongPart)
F.Global.CallWrapper.GetProperty("Test","LongPartNumberRevision",V.Local.sLongPartRev)
```
---
## Inventory.GetShortCustomerPartNumber
Return the internal GSS short customer part from the `LPART_CUST_XREF` table (`cccLONGCUSTPARTXREF-V0` file) given a long customer part number.

When the Advanced Inventory option *Use Long XRef* is enabled, any customer part entry longer than 20 characters is automatically added to a cross-reference table with a shortened version used throughout the system.

**Core Program:** `ProcessLongPart`

**Full Name:** `GSSEO.CallWrappers.Inventory.GetShortCustomerPartNumber`

> **Version Requirements:** Minimum `2019.1`. Make sure to override the `GLOBALVERSION` environment variable with `2019.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `LongPartNumber` | String | Yes | The long customer part number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ShortPartNumber` | String | Internal GSS shortened part number |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `35` | ParameterError | The parameters were not valid |
| `99` | Failed | Unable to open cross-reference file |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Inventory.GetShortCustomerPartNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","LongPartNumber","THISISAREALLYREALLYLONGPARTNUMBER")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sShortPart.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ShortPartNumber",V.Local.sShortPart)
```
---
## Inventory.GetShortManufacturerPartNumber
Return the internal GSS short manufacturer part from the `LPART_MFG_XREF` table (`cccLONGMFGPARTXREF-V0` file) given a long manufacturer part number.

When the Advanced Inventory option *Use Long XRef* is enabled, any manufacturer part entry longer than 20 characters is automatically added to a cross-reference table with a shortened version used throughout the system.

**Core Program:** `ProcessLongPart`

**Full Name:** `GSSEO.CallWrappers.Inventory.GetShortManufacturerPartNumber`

> **Version Requirements:** Minimum `2019.1`. Make sure to override the `GLOBALVERSION` environment variable with `2019.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `LongPartNumber` | String | Yes | The long manufacturer part number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ShortPartNumber` | String | Internal GSS shortened part number |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `35` | ParameterError | The parameters were not valid |
| `99` | Failed | Unable to open cross-reference file |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Inventory.GetShortManufacturerPartNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","LongPartNumber","THISISAREALLYREALLYLONGPARTNUMBER")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sShortPart.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ShortPartNumber",V.Local.sShortPart)
```
---
## Inventory.GetShortPartNumber
Return the internal GSS short Part/Rev from the `INV_LXR` table (`cccLONGPARTXREF-V0` file) given a long Part/Rev.

When the Advanced Inventory option *Use Long Part* is enabled, any part entry longer than 20 characters (or 17 with *Use Revision Levels*) is automatically added to a cross-reference table with a shortened version used throughout the system.

**Core Program:** `ProcessLongPart`

**Full Name:** `GSSEO.CallWrappers.Inventory.GetShortPartNumber`

> **Version Requirements:** Minimum `2019.1`. Make sure to override the `GLOBALVERSION` environment variable with `2019.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `LongPartNumber` | String | Yes | The long part number |
| `LongPartNumberRevision` | String | No | The long part number revision |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ShortPartNumber` | String | Internal GSS shortened part number |
| `ShortPartNumberRevision` | String | Internal GSS shortened part number revision |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `35` | ParameterError | The parameters were not valid |
| `99` | Failed | Unable to open cross-reference file |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Inventory.GetShortPartNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","LongPartNumber","THISISAREALLYREALLYLONGPARTNUMBER")
F.Global.CallWrapper.SetProperty("Test","LongPartNumberRevision","123456")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sShortPart.Declare(String)
V.Local.sShortPartRev.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ShortPartNumber",V.Local.sShortPart)
F.Global.CallWrapper.GetProperty("Test","ShortPartNumberRevision",V.Local.sShortPartRev)
```
---
## Inventory.InventoryTransfer
Screenless inventory transfer process. Transfers one inventory item per call. Lot/bin parts can be transferred bin-to-bin or location-to-location. Non lot/bin parts can only be transferred location-to-location.

**Core Program:** `LOT054GI`

**Passed Properties:**

| Property | Type | Size | Required | Description |
|----------|------|------|----------|-------------|
| `Company` | String | 3 | Yes | Company code |
| `FromPart` | String | 20 | Yes | From part (if using revision: 17 chars + 3 char rev) |
| `FromLocation` | String | 2 | Yes | From location |
| `FromBin` | String | 6 | | For lot/bin parts |
| `FromLot` | String | 15 | | For lot/bin parts |
| `FromHeat` | String | 15 | | For lot/bin parts |
| `FromSerial` | String | 30 | | For lot/bin parts |
| `ToPart` | String | 20 | Yes | To part (if using revision: 17 chars + 3 char rev). Can only change when option *Allow Transfer to a New Part* is enabled. |
| `ToLocation` | String | 2 | Yes | To location |
| `ToBin` | String | 6 | Conditional | Required if option *Do Not Allow Blank Bins* is enabled |
| `ToUnitOfMeasure` | String | 2 | | Defaults to from-part UM if not set |
| `Reference` | String | 15 | Conditional | Required if option *Require Reference Field on Inventory Transfer* is enabled |
| `TransferDate` | Date | 8 | Yes | Transfer date (format `CCYYMMDD`). Must be a valid date. |
| `TransferQuantity` | Double | 14.6 | Yes | Transfer quantity. Must be > 0. |
| `PrintAudit` | String | 1 | | Controls audit trail printing. Set `Y` on the last transfer in a series to print a consolidated audit trail. Set `N` to defer. To clear records without printing, delete file `IV703(TRMNL#)` from `global/files`. |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Process completed successfully |
| `InvalidFromPart` | FromPart is invalid |
| `InvalidFromBin` | FromPart with FromBin/FromLot/FromHeat/FromSerial is invalid (not found in Item Master) |
| `InvalidFromQty` | Transfer quantity exceeds quantity on hand. Requires `INVENTORY_MSTR.QTY_ONHAND` >= TransferQty. For lot/bin parts, requires `ITEM_MASTER.QTY_AVAILABLE_SHIP` >= TransferQty. |
| `InvalidTransferQty` | Transfer quantity is invalid (requires > 0) |
| `InvalidTransferDate` | TransferDate is not a valid date |
| `InvalidToPart` | ToPart is invalid |
| `InvalidToBin` | To Bin at To Location not found in Bin Master. If *Do Not Allow Blank Bins* is enabled, requires ToBin. |
| `AddNewPartFailed` | If *Allow Transfer to a New Part* is enabled, ToPart add failed |
| `InvalidReference` | If *Require Reference Field on Inventory Transfer* is enabled, Reference must be set |
| `Failed` | Other failure has occurred |

**Option Dependencies:**

| Option | Location |
|--------|----------|
| Allow Transfer to a New Part | *System Support > Admin > Company Options (Advanced) > Inventory* |
| Do Not Allow Blank Bin on Lot/Bin Records | *System Support > Admin > Company Options (Standard) > Inventory* |
| Require Reference Field on Inventory Transfer | *System Support > Admin > Company Options (Advanced) > Inventory* |

```
F.Global.CallWrapper.New("Test","Inventory.InventoryTransfer")
F.Global.CallWrapper.SetProperty("Test","Company","81C")
F.Global.CallWrapper.SetProperty("Test","FromPart","ATSO")
F.Global.CallWrapper.SetProperty("Test","FromLocation"," ")
F.Global.CallWrapper.SetProperty("Test","FromBin","J1")
F.Global.CallWrapper.SetProperty("Test","FromLot"," ")
F.Global.CallWrapper.SetProperty("Test","FromHeat","H1")
F.Global.CallWrapper.SetProperty("Test","FromSerial"," ")
F.Global.CallWrapper.SetProperty("Test","ToPart","JCPART          003")
F.Global.CallWrapper.SetProperty("Test","ToLocation","10")
F.Global.CallWrapper.SetProperty("Test","ToBin","1")
F.Global.CallWrapper.SetProperty("Test","ToUnitOfMeasure","EA")
F.Global.CallWrapper.SetProperty("Test","Reference","TransferMe")
F.Global.CallWrapper.SetProperty("Test","TransferDate","20260110")
F.Global.CallWrapper.SetProperty("Test","TransferQuantity","1.000000")
F.Global.CallWrapper.SetProperty("Test","PrintAudit","1")
F.Global.CallWrapper.Run("Test")
```
---
## Inventory.OpenItemMaintenance
Launches the Item Maintenance screen to allow editing existing Item Master records. Initially launches the item master browser to select a record to edit.

**Core Program:** `INV014GI`

> **Requirements:**
> - Valid inventory part
> - Inventory part must have Lot/Bin set to `'Y'`
> - If Lot/Bin flag is NOT `'Y'`, use `Inventory.AddNewItemMaintenance` to add the first lot/bin record
> - Inventory On Hand Quantity > 0 **or** existing Item Master records for the part

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Screen launched successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `PartNotLotBin` | Part not flagged as Lot/Bin in Inventory Master |
| `PartOnHandZero` | Inventory Master OnHand is zero and does not exist in Item Master |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.OpenItemMaintenance")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TEST PART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","TX")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Inventory.OpenPartCrossReference
Launches the Part Cross Reference screen to allow adding, modifying, and deleting part cross reference records.

**Core Program:** `INV010XR`

> **Requirements:**
> - Valid inventory part

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Screen launched successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.OpenPartCrossReference")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TESTPART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","002")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","GS")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Inventory.OpenStagingShipments
Opens the menu item *Shipping & Receiving > Staging Shipments > Open* with the specified packing list.

**Core Program:** `SHP700`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `PackingList` | String | 7 | Packing list number |

```
F.Global.CallWrapper.New("Test","Inventory.OpenStagingShipments")
F.Global.CallWrapper.SetProperty("Test","PackingList","1234567")
F.Global.CallWrapper.Run("Test")
```
---
## Inventory.PartAutoAllocationCustomer
Automatically allocate inventory for a customer order, specifying part, lot/bin/heat/serial details, and order quantity.

**Core Program:** `INV060`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Part` | String | 17 | Part number |
| `Revision` | String | 3 | Part revision |
| `Location` | String | 2 | Location code |
| `OrderQuantity` | Double | 12 (8.4) | Order quantity (max 8 digit whole, 4 digit decimal) |
| `CustomerNumber` | String | 6 | Customer number |
| `Lot` | String | 15 | Lot number |
| `Bin` | String | 6 | Bin number |
| `Heat` | String | 15 | Heat number |
| `Serial` | String | 30 | Serial number |

```
F.Global.CallWrapper.New("Test","Inventory.PartAutoAllocationCustomer")
F.Global.CallWrapper.SetProperty("Test","Part","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","Revision","001")
F.Global.CallWrapper.SetProperty("Test","Location","TX")
F.Global.CallWrapper.SetProperty("Test","OrderQuantity",12345678.1234)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","CUST01")
F.Global.CallWrapper.SetProperty("Test","Lot","LOT001")
F.Global.CallWrapper.SetProperty("Test","Bin","BIN01")
F.Global.CallWrapper.SetProperty("Test","Heat","HEAT001")
F.Global.CallWrapper.SetProperty("Test","Serial","SER00001")
F.Global.CallWrapper.Run("Test")
```

---
## Inventory.PartUpload
Upload inventory items and their on-hand status from a CSV-delimited file.

**Core Program:** `INV516UL`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `FileName` | String | Fully qualified path to a CSV-delimited file of inventory items and their current on-hand status |

**CSV File Format:**

For **Lot/Bin/Heat/Serial** items:
```
P16,Part,Location,OnHand,Bin,Lot,Heat,Serial,Reference
```

For **Non-Lot/Bin** items:
```
P17,Part,Location,OnHand,Reference
```

`Reference` is a user-supplied comment.

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Long | `0` = Successful, `1` = Fail |

```
F.Global.CallWrapper.New("Test","Inventory.PartUpload")
F.Global.CallWrapper.SetProperty("Test","FileName","C:\Temp\PartUpload.csv")
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
```

---
## Inventory.StandAloneIssueReceipts
Process stand-alone inventory issue/receipt transactions from a file.

**Core Program:** `INV220GI`

> **Note:** No status is returned.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `FileName` | String | 18 | File name (program assumes this file resides in the `global\files` directory) |

**Input File Layout** (comma or `","` delimited):

| Field | Description |
|-------|-------------|
| `PART` | Part number |
| `REV` | Revision |
| `LOCN` | Location |
| `QTY` | Quantity |
| `REFERENCE` | Reference |
| `LOT` | Lot |
| `BIN` | Bin |
| `HEAT` | Heat |
| `SERIAL` | Serial |
| `ISS-REC` | `I` = Issue, `R` = Receipt |
| `GL-ACCT` | GL Account |
| `COST` | Cost |
| `ALLOW-ZERO-COST-FLAG` | `Y` = Allow Zero Cost |
| `WIDTH` | Width |
| `LENGTH` | Length |
| `UM-WIDTH` | Unit of Measure - Width |
| `UM-LENGTH` | Unit of Measure - Length |

```
F.Global.CallWrapper.New("Test","Inventory.StandAloneIssueReceipts")
F.Global.CallWrapper.SetProperty("Test","FileName","ISSREC.TXT")
F.Global.CallWrapper.Run("Test")
```
---
## Inventory.ViewItemMaintenance
Launches the Item Maintenance screen in **view-only** mode for existing Item Master records. Initially launches the item master browser to select a record to view.

**Core Program:** `INV014GI`

> **Requirements:**
> - Valid inventory part
> - Inventory part must have Lot/Bin set to `'Y'`
> - Inventory On Hand Quantity > 0 **or** existing Item Master records for the part

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Screen launched successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `PartNotLotBin` | Part not flagged as Lot/Bin in Inventory Master |
| `PartOnHandZero` | Inventory Master OnHand is zero and does not exist in Item Master |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.ViewItemMaintenance")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TEST PART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","TX")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```

---
## Inventory.ViewItemTransactionsByPart
Opens the Item Transactions screen for a specific part. The date range defaults to one year prior to the current date through the current date.

**Core Program:** `INV018GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | Company code |
| `PartNumber` | String | Part number |
| `PartNumberRevision` | String | Part number revision. Used when option *Use Revision Level/Engineering Change* is turned on. |
| `LocationCode` | String | Part number location |

```
F.Global.CallWrapper.New("Test","Inventory.ViewItemTransactionsByPart")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.Run("Test")
```

---
## Inventory.ViewPartCrossReference
Launches the Part Cross Reference screen in view-only mode.

**Core Program:** `INV010XR`

> **Requirements:**
> - Valid inventory part

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 17/20 | Part number |
| `PartNumberRevision` | String | 3 | Part number revision |
| `LocationCode` | String | 2 | Location code |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Screen launched successfully |
| `PartInvalid` | Part not found in Inventory Master |
| `ParmError` | Invalid passed property |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("TEST","Inventory.ViewPartCrossReference")
F.Global.CallWrapper.SetProperty("TEST","CompanyCode","@@@")
F.Global.CallWrapper.SetProperty("TEST","PartNumber","TESTPART")
F.Global.CallWrapper.SetProperty("TEST","PartNumberRevision","002")
F.Global.CallWrapper.SetProperty("TEST","LocationCode","GS")
F.Global.CallWrapper.Run("TEST")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Inventory.ViewPartHistory
Opens the Part History screen for a specified part, allowing users to view historical transaction data.

**Core Program:** `INV870GI`

**Required Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String (3) | Yes | Company code |
| `PartNumber` | String | Yes | Part number |
| `PartNumberRevision` | String | No | Part number revision. Used when *Use Revision Level/Engineering Change* is enabled. |
| `LocationCode` | String | Yes | Part number location |
| `HideCurrency` | Boolean | No | True to hide dollar amounts (for users without functional security to view dollars). Default is False. |

> **Note:** If the customer is not using the Revision option and the part number exceeds 17 bytes (max 20 bytes), use the optional Revision field to populate bytes 18-20.

**Returned Properties:** None.

```
F.Global.CallWrapper.New("ViewPartHistory","Inventory.ViewPartHistory")
F.Global.CallWrapper.SetProperty("ViewPartHistory","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("ViewPartHistory","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("ViewPartHistory","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("ViewPartHistory","LocationCode","TX")
F.Global.CallWrapper.SetProperty("ViewPartHistory","HideCurrency",False)
F.Global.CallWrapper.Run("ViewPartHistory")
```
---

