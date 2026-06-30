# GAB CallWrapper Reference -- Accounting
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for accounting programs
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

# Accounting

## Accounting.AccountsPayable.VendorMaintenanceNewVendor
Create a new vendor record in AP Vendor Maintenance.

**Core Program:** `AP0020GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | 3-character company code |
| `VendorNumber` | String (6) | 6-character vendor number |

**Returned Status:** `Successful`, `NotFound`, `Failed`

| Status | Description |
|--------|-------------|
| `Successful` | The vendor was added successfully |
| `NotFound` | No records found |
| `Failed` | The change failed |

```
F.Global.CallWrapper.New("Test","Accounting.AccountsPayable.VendorMaintenanceNewVendor")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","CCC")
F.Global.CallWrapper.SetProperty("Test","VendorNumber",6)
F.Global.CallWrapper.Run("Test")
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

---
## Accounting.AccountsPayable.VendorMaintenanceOpenVendor
Open an existing vendor record in AP Vendor Maintenance for editing.

**Core Program:** `AP0020GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `VendorNumber` | String (6) | 6-character vendor number |

**Returned Status:** `Successful`, `NotFound`, `Failed`

| Status | Description |
|--------|-------------|
| `Successful` | The change completed successfully |
| `NotFound` | No records found |
| `Failed` | The change failed |

```
F.Global.CallWrapper.New("Test","Accounting.AccountsPayable.VendorMaintenanceOpenVendor")
F.Global.CallWrapper.SetProperty("Test","VendorNumber",6)
F.Global.CallWrapper.Run("Test")
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

---
## Accounting.AccountsPayable.VendorMaintenanceViewVendor
View an existing vendor record in AP Vendor Maintenance (read-only).

**Core Program:** `AP0020GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `VendorNumber` | String (6) | 6-character vendor number |

**Returned Status:** `Successful`, `NotFound`, `Failed`

| Status | Description |
|--------|-------------|
| `Successful` | The change completed successfully |
| `NotFound` | No records found |
| `Failed` | The change failed |

```
F.Global.CallWrapper.New("Test","Accounting.AccountsPayable.VendorMaintenanceViewVendor")
F.Global.CallWrapper.SetProperty("Test","VendorNumber",6)
F.Global.CallWrapper.Run("Test")
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

---
## Accounting.ConvertProspectToCustomer
Convert a prospect to a customer.

**Core Program:** `AR0180`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Prospect` | String (6) | 6-character prospect ID |
| `Screenless` | String (1) | Set to `"Y"` to run in screenless mode |

**Returned Status:** `Success`, `ParmError`, `Fail`

| Status | Description |
|--------|-------------|
| `Success` | The conversion completed successfully |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Accounting.ConvertProspectToCustomer")
F.Global.CallWrapper.SetProperty("Test","Prospect","123456")
F.Global.CallWrapper.SetProperty("Test","Screenless","Y")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```

---
## Accounting.GeneralLedger.GLBatchPosterNonBranch
Launches the General Ledger Poster Screen to update "GL" Application types of Journal Batches as non-branch/single updates only. Batches must be manually selected from the poster screen to post.

**Core Program:** `GL0004`

> **Note:** This callwrapper is only available in version 23.1 and later.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `BatchNumber` | String | 5 | Batch number. Blanks = display all open GL batches per user security. Specific batch = display that batch (must be created by requester's User ID). |

**Returned Status:**

| Code | Status | Description |
|------|--------|-------------|
| `00` | Success | Successful |
| `01` | Empty Table | No batches in `GL_JRNL_ENTRY` |
| `98` | Module Not Found | Core module not found |
| `99` | Failed | Call failed |

```
F.Global.CallWrapper.New("Test","Accounting.GeneralLedger.GLBatchPosterNonBranch")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","02Q")
F.Global.CallWrapper.SetProperty("Test","BatchNumber","    ")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Accounting.GetNextBatchNumberAP
Retrieve the next batch number, validate it is not a duplicate, and update options with the new next batch number for Accounts Payable batch processing.

**Core Program:** `GetNextBatchNumberAP`

> **Note:** This callwrapper is only available in version 23.1 and later.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PostDate` | String | 8 | Post date |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | `Success(00)`, `Failed(90)`, or `Cancelled(99)` |
| `BatchNumber` | String (5) | Batch number in format `#nnnn` where `#` is the literal stored in options: *System Support > Administration > Company Options (Standard) > Accounts Payable* and `n` = digits 0-9 |

```
F.Global.CallWrapper.New("Test","Accounting.GetNextBatchNumberAP")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PostDate","05/03/2023")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sBatchNumber.Declare(String)
F.Global.CallWrapper.GetProperty("Test","BatchNumber",V.Local.sBatchNumber)
```
---
## Accounting.GetNextBatchNumberCK
Retrieve the next batch number for Check Processing, validate it is not a duplicate, and update options with the new next batch number.

**Core Program:** `GetNextBatchNumberCK`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | 3-character company code |
| `PostDate` | String (8) | Post date (e.g. `"12/04/2020"`) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | Execution status (see below) |
| `BatchNumber` | String (5) | Batch number in format `Knnnn` (K = literal, n = digit 0-9) |

**Returned Status:** `Success(00)`, `Failed(90)`, `Cancelled(99)`

| Status | Description |
|--------|-------------|
| `Success(00)` | Next batch number returned to caller |
| `Failed(90)` | Call failed |
| `Cancelled(99)` | Call was cancelled |

```
F.Global.CallWrapper.New("Test","Accounting.GetNextBatchNumberCK")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PostDate","12/04/2020")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sBatchNumber.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","BatchNumber",V.Local.sBatchNumber)
F.Intrinsic.UI.Msgbox(V.Local.sBatchNumber,"Complete!")
```

---
## Accounting.GetNextBatchNumberGL
Retrieve the next batch number, validate it is not a duplicate, and update options with the new next batch number for General Ledger Journal Batches.

**Core Program:** `GetNextBatchNumberGL`

> **Note:** This callwrapper is only available in version 23.1 and later.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PostDate` | String | 8 | Post date |
| `BatchPrefix` | String | 1 | Batch prefix: `J` = Journal Entry, `B` = Bank Reconciliation, `D` = Simple Inventory Accounting, `L` = Labor and Overhead, `M` = Late Cost to Jobs, `C` = Allocations, `W` = Payroll, `I` = Indirect Labor, `F` = Depreciation Fixed Assets |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | Return status (see table below) |
| `BatchNumber` | String (5) | Batch number in format `#nnnn` where `#` is the literal stored in options: *System Support > Administration > Company Options (Standard) > General Ledger* and `n` = digits 0-9 |

**Returned Status:**

| Code | Status | Description |
|------|--------|-------------|
| `00` | Success | Next batch number returned to caller |
| `89` | Post Date Missing | Missing `PostDate` parameter |
| `90` | Failed | Call failed |
| `99` | Cancelled | Call was cancelled |

```
F.Global.CallWrapper.New("Test","Accounting.GetNextBatchNumberGL")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PostDate","06/04/2024")
F.Global.CallWrapper.SetProperty("Test","BatchPrefix","B")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(UInteger)
V.Local.sIsAutoBatch.Declare(String)
V.Local.sBatchNumber.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","IsAutoBatch",V.Local.sIsAutoBatch)
F.Global.CallWrapper.GetProperty("Test","BatchNumber",V.Local.sBatchNumber)
```
---
## Accounting.Support.DeleteLockOnStartingCheckNumber
Delete the lock on a starting check number. Only use **before** the starting check number has been updated via `UpdateStartingCheckNumber`. The Checks In Use Next Check Number must be blank.

**Core Program:** `CK0800` (Mode 4)

> **Option dependency:** Check prefix usage and check number size are based on *System Support > Administration > Company Options (Standard) > Accounts Payable > Use Extended Check Numbers*.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable, `1` = Payroll |
| `CheckType` | Enum (Long) | -- | See CheckType table below |
| `StartingCheckPrefix` | String | 5 | Optional -- only used when *Use Extended Check Numbers* is on |
| `StartingCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 digits when extended on |

**CheckType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Status:** The core program always sets the `Status` property, but values other than `Success` indicate a problem. Check the returned status.

| Status | Description |
|--------|-------------|
| `Success` | Lock removed successfully |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.DeleteLockOnStartingCheckNumber")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.SetProperty("TEST","CheckType",1)
F.Global.CallWrapper.SetProperty("TEST","StartingCheckPrefix",1)
F.Global.CallWrapper.SetProperty("TEST","StartingCheckNumber",100)
F.Global.CallWrapper.Run("TEST")
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
```

---
## Accounting.Support.DeleteStartingCheckInUse
Remove the InUse record for a starting check number. Use after the starting check number has been updated via `UpdateStartingCheckNumber`.

**Core Program:** `CK0800` (Mode 5)

> **Option dependency:** Check prefix usage and check number size are based on *System Support > Administration > Company Options (Standard) > Accounts Payable > Use Extended Check Numbers*.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable, `1` = Payroll |
| `CheckType` | Enum (Long) | -- | See CheckType table below |
| `StartingCheckPrefix` | String | 5 | Optional -- only used when *Use Extended Check Numbers* is on |
| `StartingCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 digits when extended on |

**CheckType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Status:** The core program always sets the `Status` property, but values other than `Success` indicate a problem. Check the returned status.

| Status | Description |
|--------|-------------|
| `Success` | InUse record removed successfully |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.DeleteStartingCheckInUse")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.SetProperty("TEST","CheckType",1)
F.Global.CallWrapper.SetProperty("TEST","StartingCheckPrefix",1)
F.Global.CallWrapper.SetProperty("TEST","StartingCheckNumber",100)
F.Global.CallWrapper.Run("TEST")
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
```

---
## Accounting.Support.GetCashAccount
Retrieve a cash account record for a given account number.

**Core Program:** `CK0800` (Mode 8)

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable, `1` = Payroll |

**Returned Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Status` | Enum | -- | Execution status (see below) |
| `ReturnIsoCurrencyCode` | String | 3 | Currency code of the account |
| `ReturnAccountNumber` | String | 15 | Cash account number |
| `ReturnCashAccountType` | Enum | -- | See CashAccountType enum below |
| `ReturnDescription` | String | 100 | Account description |
| `ReturnStartingCheckPrefix` | String | 5 | Only populated when *Use Extended Check Numbers* is on |
| `ReturnStartingCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 when extended on |
| `ReturnIsDefaultAccount` | Boolean | -- | Whether this is the default cash account |
| `ReturnBankAccountNumber` | String (Encrypted) | 40 | Encrypted bank account number -- use `F.Global.Encryption.Decrypt` to get plain text |

**ReturnCashAccountType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Cash account retrieved successfully |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)
V.Local.tCurrency.Declare(String)
V.Local.tCashAccountNumber.Declare(String)
V.Local.tCashAcctType.Declare(String)
V.Local.tDescription.Declare(String)
V.Local.tStartCheckPrefix.Declare(String)
V.Local.tStartCheckNum.Declare(String)
V.Local.bIsDefaultAccount.Declare(Boolean)
V.Local.tBankAccountNumber.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.GetCashAccount")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.Run("TEST")

F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Global.CallWrapper.GetProperty("TEST","ReturnIsoCurrencyCode",V.Local.tCurrency)
F.Global.CallWrapper.GetProperty("TEST","ReturnAccountNumber",V.Local.tCashAccountNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnCashAccountType",V.Local.tCashAcctType)
F.Global.CallWrapper.GetProperty("TEST","ReturnDescription",V.Local.tDescription)
F.Global.CallWrapper.GetProperty("TEST","ReturnStartingCheckPrefix",V.Local.tStartCheckPrefix)
F.Global.CallWrapper.GetProperty("TEST","ReturnStartingCheckNumber",V.Local.tStartCheckNum)
F.Global.CallWrapper.GetProperty("TEST","ReturnIsDefaultAccount",V.Local.bIsDefaultAccount)
F.Global.CallWrapper.GetProperty("TEST","ReturnBankAccountNumber",V.Local.tBankAccountNumber)
```

---
## Accounting.Support.GetStartingCheckNumberAndLock
Retrieve the starting check number from a cash account and create a Check In Use record to lock it.

**Core Program:** `CK0800` (Mode 1)

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable, `1` = Payroll |
| `CheckType` | Enum (Long) | -- | See CheckType table below |

**CheckType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Status` | Enum | -- | Execution status (see below) |
| `ReturnIsoCurrencyCode` | String | 3 | Currency code of the account |
| `ReturnAccountNumber` | String | 15 | Cash account number |
| `ReturnCashAccountType` | Enum | -- | See ReturnCashAccountType enum below |
| `ReturnDescription` | String | 100 | Account description |
| `ReturnStartingCheckPrefix` | String | 5 | Only populated when *Use Extended Check Numbers* is on |
| `ReturnStartingCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 when on |
| `ReturnIsDefaultAccount` | Boolean | -- | Whether this is the default cash account |
| `ReturnBankAccountNumber` | String (Encrypted) | 40 | Encrypted bank account number |
| `ReturnedInUseCheckPrefix` | String | 5 | Only populated when *Use Extended Check Numbers* is on |
| `ReturnedInUseCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 when on |
| `ReturnedCheckType` | Enum | -- | See ReturnedCheckType enum below |

**ReturnCashAccountType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**ReturnedCheckType Enum:**

| Value | Type |
|-------|------|
| 0 | AccountsPayableOrAccountsReceivable |
| 1 | Payroll |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Starting check retrieved and locked successfully |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)
V.Local.tCurrency.Declare(String)
V.Local.tCashAccountNumber.Declare(String)
V.Local.tCashAcctType.Declare(String)
V.Local.tDescription.Declare(String)
V.Local.tStartCheckPrefix.Declare(String)
V.Local.tStartCheckNum.Declare(String)
V.Local.bIsDefaultAccount.Declare(Boolean)
V.Local.tBankAccountNumber.Declare(String)
V.Local.tInUseCheckPrefix.Declare(String)
V.Local.tInUseCheckNumber.Declare(String)
V.Local.tCheckType.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.GetStartingCheckNumberAndLock")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.SetProperty("TEST","CheckType",1)
F.Global.CallWrapper.Run("TEST")

F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Global.CallWrapper.GetProperty("TEST","ReturnIsoCurrencyCode",V.Local.tCurrency)
F.Global.CallWrapper.GetProperty("TEST","ReturnAccountNumber",V.Local.tCashAccountNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnCashAccountType",V.Local.tCashAcctType)
F.Global.CallWrapper.GetProperty("TEST","ReturnDescription",V.Local.tDescription)
F.Global.CallWrapper.GetProperty("TEST","ReturnStartingCheckPrefix",V.Local.tStartCheckPrefix)
F.Global.CallWrapper.GetProperty("TEST","ReturnStartingCheckNumber",V.Local.tStartCheckNum)
F.Global.CallWrapper.GetProperty("TEST","ReturnIsDefaultAccount",V.Local.bIsDefaultAccount)
F.Global.CallWrapper.GetProperty("TEST","ReturnBankAccountNumber",V.Local.tBankAccountNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnedInUseCheckPrefix",V.Local.tInUseCheckPrefix)
F.Global.CallWrapper.GetProperty("TEST","ReturnedInUseCheckNumber",V.Local.tInUseCheckNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnedCheckType",V.Local.tCheckType)
```

---
## Accounting.Support.UpdateStartingCheckNumber
Update the cash account starting check number and the Check In Use next check number.

**Core Program:** `CK0800` (Mode 3)

> **Prerequisites:** Requires a Check In Use record whose check number matches `StartingCheckPrefix`/`StartingCheckNumber`. The `NextCheckPrefix`/`NextCheckNumber` values are used to update the cash account starting check and Check In Use next check number.
>
> **Option dependency:** Check prefix usage and check number size are based on *System Support > Administration > Company Options (Standard) > Accounts Payable > Use Extended Check Numbers*.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable, `1` = Payroll |
| `CheckType` | Enum (Long) | -- | See CheckType table below |
| `StartingCheckPrefix` | String | 5 | Optional -- only used when *Use Extended Check Numbers* is on |
| `StartingCheckNumber` | String | 6 or 15 | Current starting check number (6 digits when extended off, 15 when on) |
| `NextCheckPrefix` | String | 5 | Optional -- only used when *Use Extended Check Numbers* is on |
| `NextCheckNumber` | String | 6 or 15 | New next check number (6 digits when extended off, 15 when on) |

**CheckType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Starting check number updated successfully |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.UpdateStartingCheckNumber")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.SetProperty("TEST","CheckType",1)
F.Global.CallWrapper.SetProperty("TEST","StartingCheckPrefix",1)
F.Global.CallWrapper.SetProperty("TEST","StartingCheckNumber",100)
F.Global.CallWrapper.SetProperty("TEST","NextCheckPrefix",1)
F.Global.CallWrapper.SetProperty("TEST","NextCheckNumber",101)
F.Global.CallWrapper.Run("TEST")
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
```

---
## Accounting.Support.ValidateDuplicateChecks
Verify a check number does not exist in AP Open Items or AP History.

**Core Program:** `CK0800` (Mode 6)

> **Option dependencies:**
> - Number of days to look for duplicates in AP History is based on *System Support > Administration > Company Options (Standard) > Accounts Payable > # of Days to Look for Duplicate Check Numbers*.
> - Check prefix usage and check number size are based on *System Support > Administration > Company Options (Standard) > Accounts Payable > Use Extended Check Numbers*.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable (required), `1` = Payroll (future) |
| `CheckType` | Enum (Long) | -- | See CheckType table below |
| `NextCheckPrefix` | String | 5 | Optional -- only used when *Use Extended Check Numbers* is on |
| `NextCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 digits when extended on |

**CheckType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Check number is valid (no duplicates found) |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.ValidateDuplicateChecks")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.SetProperty("TEST","CheckType",1)
F.Global.CallWrapper.SetProperty("TEST","NextCheckPrefix",1)
F.Global.CallWrapper.SetProperty("TEST","NextCheckNumber",101)
F.Global.CallWrapper.Run("TEST")
F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
```

---
## Accounting.Support.ValidateStartingCheckNumberLocked
Check if a cash account is locked and retrieve the starting check record **without** locking it.

**Core Program:** `CK0800` (Mode 2)

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CallingProgram` | String | -- | Name of the calling program |
| `IsoCurrencyCode` | String | 3 | ISO currency code (e.g. `"USD"`) |
| `AccountNumber` | String | 15 | Cash account number |
| `CashAccountType` | Enum (Long) | -- | `0` = AccountsPayableOrAccountsReceivable, `1` = Payroll |
| `CheckType` | Enum (Long) | -- | See CheckType table below |

**CheckType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**Returned Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Status` | Enum | -- | Execution status (see below) |
| `ReturnIsoCurrencyCode` | String | 3 | Currency code of the account |
| `ReturnAccountNumber` | String | 15 | Cash account number |
| `ReturnCashAccountType` | Enum | -- | See ReturnCashAccountType enum below |
| `ReturnDescription` | String | 100 | Account description |
| `ReturnStartingCheckPrefix` | String | 5 | Only populated when *Use Extended Check Numbers* is on |
| `ReturnStartingCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 when on |
| `ReturnIsDefaultAccount` | Boolean | -- | Whether this is the default cash account |
| `ReturnBankAccountNumber` | String (Encrypted) | 40 | Encrypted bank account number |
| `ReturnedInUseCheckPrefix` | String | 5 | Only populated when *Use Extended Check Numbers* is on |
| `ReturnedInUseCheckNumber` | String | 6 or 15 | 6 digits when extended off, 15 when on |
| `ReturnedCheckType` | Enum | -- | See ReturnedCheckType enum below |

**ReturnCashAccountType Enum:**

| Value | Type |
|-------|------|
| 0 | CheckRegister |
| 1 | Manual |
| 2 | Quick |
| 3 | Refund |
| 4 | Payroll |

**ReturnedCheckType Enum:**

| Value | Type |
|-------|------|
| 0 | AccountsPayableOrAccountsReceivable |
| 1 | Payroll |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Cash account retrieved; not locked |
| `CheckInuse` | Check number is currently in use |
| `DuplicateCheck` | Duplicate check number found |
| `UpdateFailedForNextCheckNumber` | Failed to update next check number |
| `Failed` | General failure |
| `MultipleRecords` | Multiple matching records found |
| `CheckRecordLocked` | Check record is locked by another process |
| `MissingParameters` | Required parameters were not provided |

```
V.Local.tStatus.Declare(String)
V.Local.tCurrency.Declare(String)
V.Local.tCashAccountNumber.Declare(String)
V.Local.tCashAcctType.Declare(String)
V.Local.tDescription.Declare(String)
V.Local.tStartCheckPrefix.Declare(String)
V.Local.tStartCheckNum.Declare(String)
V.Local.bIsDefaultAccount.Declare(Boolean)
V.Local.tBankAccountNumber.Declare(String)
V.Local.tInUseCheckPrefix.Declare(String)
V.Local.tInUseCheckNumber.Declare(String)
V.Local.tCheckType.Declare(String)

F.Global.CallWrapper.New("TEST","Accounting.Support.ValidateStartingCheckNumberLocked")
F.Global.CallWrapper.SetProperty("TEST","Company","10T")
F.Global.CallWrapper.SetProperty("TEST","CallingProgram","CheckTest")
F.Global.CallWrapper.SetProperty("TEST","IsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("TEST","AccountNumber","100")
F.Global.CallWrapper.SetProperty("TEST","CashAccountType",0)
F.Global.CallWrapper.SetProperty("TEST","CheckType",1)
F.Global.CallWrapper.Run("TEST")

F.Global.CallWrapper.GetProperty("TEST","Status",V.Local.tStatus)
F.Global.CallWrapper.GetProperty("TEST","ReturnIsoCurrencyCode",V.Local.tCurrency)
F.Global.CallWrapper.GetProperty("TEST","ReturnAccountNumber",V.Local.tCashAccountNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnCashAccountType",V.Local.tCashAcctType)
F.Global.CallWrapper.GetProperty("TEST","ReturnDescription",V.Local.tDescription)
F.Global.CallWrapper.GetProperty("TEST","ReturnStartingCheckPrefix",V.Local.tStartCheckPrefix)
F.Global.CallWrapper.GetProperty("TEST","ReturnStartingCheckNumber",V.Local.tStartCheckNum)
F.Global.CallWrapper.GetProperty("TEST","ReturnIsDefaultAccount",V.Local.bIsDefaultAccount)
F.Global.CallWrapper.GetProperty("TEST","ReturnBankAccountNumber",V.Local.tBankAccountNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnedInUseCheckPrefix",V.Local.tInUseCheckPrefix)
F.Global.CallWrapper.GetProperty("TEST","ReturnedInUseCheckNumber",V.Local.tInUseCheckNumber)
F.Global.CallWrapper.GetProperty("TEST","ReturnedCheckType",V.Local.tCheckType)
```

---
## Accounting.Support.ApPaymentProcessor

AP Payments Processor -- automates processing of Accounts Payable invoice payments via `F.Global.Object` (not the CallWrapper pattern).

> **Invocation:** Uses `F.Global.Object.CreateDB` / `F.Global.Object.Create` / `F.Global.Object.GetMethod` / `F.Global.Object.InvokeMethod` rather than `F.Global.CallWrapper`.

**Method:** `ImportAndProcessPaymentBatch(jsonString)`

**Returns:** `String` -- the batch number used to process the payments.

### JSON Input Schema

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code to run the upload for |
| `AccountNumber` | String | AP General Ledger cash account number |
| `AccountCurrencyCode` | String | Currency code of the account (e.g. `"USD"`) |
| `BatchNumber` | String | Batch number for the payment batch (can be omitted if Automatic Batch Numbering is enabled) |
| `PostDate` | String (date) | Date to post the batch (e.g. `"2024-01-09"`) |
| `InvoicePayments` | Array | Collection of invoice payment objects |

**InvoicePayments[] properties:**

| Property | Type | Description |
|----------|------|-------------|
| `InvoiceNumber` | String | ID of the invoice to be paid |
| `VendorNumber` | String | Vendor ID the invoice will be paid to |
| `PayAmount` | Decimal | Amount in company currency to pay |
| `CheckNumberPrefix` | String (optional) | Check number prefix (only with extended check numbering) |
| `CheckNumber` | Long | Check number of the payment check |
| `CheckDate` | String (date) | Date of the check |

**Example JSON:**

```json
{
  "CompanyCode": "PSC",
  "AccountNumber": "100",
  "AccountCurrencyCode": "USD",
  "BatchNumber": "N900",
  "PostDate": "2024-01-09",
  "InvoicePayments": [
    {
      "InvoiceNumber": "98756465",
      "VendorNumber": "CCVEN2",
      "PayAmount": 55.00,
      "CheckNumberPrefix": "",
      "CheckNumber": 250000,
      "CheckDate": "2024-01-09"
    },
    {
      "InvoiceNumber": "7184",
      "VendorNumber": "CCVEN3",
      "PayAmount": 80.00,
      "CheckNumberPrefix": "",
      "CheckNumber": 250001,
      "CheckDate": "2024-01-09"
    }
  ]
}
```

### Requirements

- Open items for the invoice must exist in the AP Open Items table.
- The cash account used for payment must be set up within Global Shop.
- The post date must fall within a valid General Ledger Calendar period.

### Validation Rules

**Batch:**
- The batch number must be valid.

**Invoice:**
- No open items for the invoice may be marked as On Hold.
- Payment on the invoice cannot exceed the net invoice amount.
- Discount amount may not exceed the total invoice amount.

**Check:**
- Check total may not be negative.
- Check total may not be zero unless the option for net zero checks is enabled.
- Check dates must fall within the same calendar period as the post date.
- All invoices on a check must be for the same vendor.
- Check total must not leave a vendor with a credit balance unless the option is enabled.
- Check number cannot be a duplicate from a past check unless past the cutoff date.

### Check Numbering

**Extended check numbering enabled:**
- `CheckNumberPrefix`: Alphanumeric string up to 5 characters
- `CheckNumber`: Numerical value up to 15 digits

**Extended check numbering disabled:**
- `CheckNumberPrefix`: Not used -- will throw an exception if a non-empty value is provided
- `CheckNumber`: Numerical value up to 6 digits

### Other Behavioral Notes

- Invoices automatically take discounts on open items unless past the due date.
- Invoices with partial payments will not take discounts.
- Batch numbers are optional if Automatic Batch Numbering is enabled; if omitted, the next automatic batch number is used.
- Exceptions are logged to `%Temp%\gss\ApPaymentProcessorLog[yyyyMMddHmmsssss].glog`.

### Exceptions

| Exception | Cause |
|-----------|-------|
| `JsonSerializationException` | Incorrect JSON format |
| `EoException` | Global Shop datalayer error |
| `ApInvoiceValidationException` | Invalid payment encountered |
| `ProcessPaymentsException` | Unsuccessful core call to process payments |
| `Exception` | General unexpected error |

### GAB Example

```
V.Global.iCon.Declare(Long)
V.Local.sBatchNumberCreated.Declare(String)
V.Local.sJSON.Declare(String)

F.Intrinsic.Control.Try
    F.Intrinsic.File.File2String("C:\path\to\json\file.json", V.Local.sJSON)

    ' Create a DB object
    F.Global.Object.CreateDB("GlobalDB", V.Caller.CompanyCode, V.Ambient.DBServerName, True, V.Global.iCon)

    ' Create the AP Payment Processor object
    F.Global.Object.Create("apPaymentProcessor", "Accounting.Support.ApPaymentProcessor", "GlobalDB", V.Global.iCon)

    ' Get an instance of the ImportAndProcessPaymentBatch method
    F.Global.Object.GetMethod("apPaymentProcessor", "ImportAndProcessPaymentBatch", "string", "processorMethod")

    ' Invoke the method -- returns the batch number
    F.Global.Object.InvokeMethod("apPaymentProcessor", "processorMethod", V.Local.sJSON, V.Local.sBatchNumberCreated)
F.Intrinsic.Control.Catch
    F.Intrinsic.UI.Msgbox(V.Ambient.ErrorDescription)
F.Intrinsic.Control.EndTry
```

> **Tip:** Always wrap the invocation in `Try`/`Catch` as processing errors throw exceptions with details in `V.Ambient.ErrorDescription`.

---
## Accounting.ValidateBatchNumber
Validate an accounting batch number as unique (not already in use).

**Core Program:** `ValidateBatchNumber`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | 3-character company code |
| `PostDate` | String | 8 | Post date (e.g. `"12/04/2020"`) |
| `BatchNumber` | String | 5 | 5-character batch number to validate |

**Returned Status:** `Success(00)`, `DuplicateBatch(10)`, `Failed(90)`, `Cancelled(99)`

| Status | Description |
|--------|-------------|
| `Success(00)` | Batch number is valid (no duplicates) |
| `DuplicateBatch(10)` | Batch number already exists |
| `Failed(90)` | Call failed |
| `Cancelled(99)` | Call was cancelled |

```
F.Global.CallWrapper.New("Test","Accounting.ValidateBatchNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PostDate","12/04/2020")
F.Global.CallWrapper.SetProperty("Test","BatchNumber","P0003")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Intrinsic.UI.Msgbox(V.Local.sStatus,"Complete!")
```

---
## Accounting.VATTaxReportingExtract
Extract VAT Tax Reporting data based on run parameters, date range, country, and tax group.

**Core Program:** `TX0800`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `RunID` | Double | 18 digits | Unique Run identifier |
| `RunType` | Enum (Long) | -- | `0` = Preliminary, `1` = Final, `2` = Reprint |
| `VATReturnReport` | Long | 1 | `0` = No, `1` = Yes -- flag to return the VAT report |
| `VATDetailReport` | Long | 1 | `0` = No, `1` = Yes -- flag to return the VAT detail report |
| `ECSalesReport` | Long | 1 | `0` = No, `1` = Yes -- flag to return the EC Sales report |
| `StartDate` | Date/String | 8 | Start date (GAB Date or `"YYYYMMDD"`) |
| `EndDate` | Date/String | 8 | End date (GAB Date or `"YYYYMMDD"`) |
| `CountryCode` | String | 3 | Country code |
| `TaxGroup` | String | 5 | Tax group |
| `IncludeUnreconciled` | Long | 1 | `0` = No, `1` = Yes -- include unreconciled records |
| `ReportID` | Long | 9 | Report identifier |
| `IsTransaction` | String | 1 | `" "` = Yes (caller already started transaction, default), `"N"` = No, `"S"` = Start (module manages the transaction) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | The extract completed successfully |
| `ParmError` | Invalid parameter passed |
| `NoRecords` | No records found |
| `FileError` | File error occurred |
| `Cancel` | The process was canceled |

```
F.Global.CallWrapper.New("Test","Accounting.VATTaxReportingExtract")
F.Global.CallWrapper.SetProperty("Test","RunID",123456789012345678)
F.Global.CallWrapper.SetProperty("Test","RunType",0)
F.Global.CallWrapper.SetProperty("Test","VATReturnReport",1)
F.Global.CallWrapper.SetProperty("Test","VATDetailReport",1)
F.Global.CallWrapper.SetProperty("Test","ECSalesReport",1)
F.Global.CallWrapper.SetProperty("Test","StartDate","20000131")
F.Global.CallWrapper.SetProperty("Test","EndDate","20000201")
F.Global.CallWrapper.SetProperty("Test","CountryCode","GBR")
F.Global.CallWrapper.SetProperty("Test","TaxGroup","VAT01")
F.Global.CallWrapper.SetProperty("Test","IncludeUnreconciled",1)
F.Global.CallWrapper.SetProperty("Test","ReportID",123456789)
F.Global.CallWrapper.SetProperty("Test","IsTransaction"," ")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

---
## Accounting.VATTaxReportingUpdate
Update a VAT Tax Reporting record.

**Core Program:** `TX0800`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `RunID` | Double | 18 | 18-digit Run ID |
| `Category` | Enum (Long) | -- | See Category enum below |
| `Type` | Enum (Long) | -- | See Type enum below |
| `DataSource` | Enum (Long) | -- | See DataSource enum below |
| `GeneralLedgerAccount` | String | 15 | GL account number |
| `OrderEntryInvoice` | String | 7 | OE invoice number |
| `SalesOrder` | String | 7 | Sales order number |
| `SalesOrderSequence` | Long | 4 | Sales order sequence number |
| `Vendor` | String | 7 | Vendor number |
| `InvoiceNumber` | String | 15 | Invoice number |
| `ARAPCode` | String | 2 | AR/AP code |
| `Batch` | String | 5 | Batch number |
| `InvoiceDate` | String/Date | -- | Date in `YYYYMMDD` format (or GAB Date type) |
| `Box` | String | 2 | Box number |
| `Reference` | String | 30 | Reference text |
| `Description` | String | 30 | Description text |
| `Amount` | Double | 18 | Amount (max 14-digit whole number + 2-digit decimal) |
| `IsTransaction` | String | 1 | Transaction flag (see below) |

**Category Enum:**

| Value | Category |
|-------|----------|
| 0 | Journals |
| 1 | Sales |
| 2 | Purchasing |

**Type Enum:**

| Value | Type |
|-------|------|
| 0 | Invoice |
| 1 | Credit |
| 2 | JournalDebit |

**DataSource Enum:**

| Value | Source |
|-------|--------|
| 0 | OEInvoice |
| 1 | ARMnlInvoice |
| 2 | APAcrInvoice |
| 3 | APMnlInvoice |
| 4 | GLJournal |
| 5 | ARMnlHistory |
| 6 | APMnlHistory |

**IsTransaction Values:**

| Value | Meaning |
|-------|---------|
| `" "` (space) | The calling program has already started a transaction (default) |
| `"N"` | Not processed as part of a transaction |
| `"S"` | The module will start and commit/rollback a transaction |

**Returned Status:** `Success`, `ParmError`, `NoRecords`, `FileError`, `Cancel`

| Status | Description |
|--------|-------------|
| `Success` | The update completed successfully |
| `ParmError` | Invalid parameter passed |
| `NoRecords` | No records found |
| `FileError` | File error occurred |
| `Cancel` | The process was canceled |

```
F.Global.CallWrapper.New("Test","Accounting.VATTaxReportingUpdate")
F.Global.CallWrapper.SetProperty("Test","RunID",123456)
F.Global.CallWrapper.SetProperty("Test","Category",0)
F.Global.CallWrapper.SetProperty("Test","Type",0)
F.Global.CallWrapper.SetProperty("Test","DataSource",0)
F.Global.CallWrapper.SetProperty("Test","GeneralLedgerAccount","100-00-000")
F.Global.CallWrapper.SetProperty("Test","OrderEntryInvoice","0001234")
F.Global.CallWrapper.SetProperty("Test","SalesOrder","0005678")
F.Global.CallWrapper.SetProperty("Test","SalesOrderSequence",1234)
F.Global.CallWrapper.SetProperty("Test","Vendor","VEND01")
F.Global.CallWrapper.SetProperty("Test","InvoiceNumber","INV-001")
F.Global.CallWrapper.SetProperty("Test","ARAPCode","AP")
F.Global.CallWrapper.SetProperty("Test","Batch","P0003")
F.Global.CallWrapper.SetProperty("Test","InvoiceDate","20000131")
F.Global.CallWrapper.SetProperty("Test","Box","01")
F.Global.CallWrapper.SetProperty("Test","Reference","Payment Reference")
F.Global.CallWrapper.SetProperty("Test","Description","Invoice Description")
F.Global.CallWrapper.SetProperty("Test","Amount",1500.50)
F.Global.CallWrapper.SetProperty("Test","IsTransaction"," ")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

---

