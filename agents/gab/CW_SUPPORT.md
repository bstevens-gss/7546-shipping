# GAB CallWrapper Reference -- Support
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for support and troubleshooting programs
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

# Support

## Support.CreateSoftLock
Create a soft lock within the Global Shop system.

> **See also:** `agents/gab/INTEGRATION.md` documents `F.Global.General.CreateSoftLock` / `ReadSoftLock` / `DestroySoftLock`, which are a separate, simpler soft lock mechanism. The two approaches are not interchangeable.

**Core Program:** `SYS060`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `UserID` | String | 8 | User ID |
| `CallingProgram` | String | 8 | Calling program name |
| `LockType` | Enum | | See LockType enum below |
| `LockKey` | String | 50 | Lock key (varies depending on LockType) |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Reference` | String | Free-form reference metadata |

**LockType Enum:**

| Value | Description |
|-------|-------------|
| `0` | WorkOrder |
| `1` | Router |
| `2` | SalesOrder |
| `3` | PurchaseOrder |
| `4` | Quote |
| `5` | PurchaseReq |
| `6` | Contract |
| `7` | Transit |
| `8` | WorkOrderSequence |
| `9` | Batch |
| `10` | BillofMaterial |
| `11` | Project |
| `12` | FixedAssets |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Lock created successfully |
| `CurUserLocked` | Current user has the lock |
| `ParmError` | Invalid parameter |
| `Locked` | Resource is already locked |
| `LockNotFound` | Lock not found |
| `FileError` | File error |
| `PidError` | PID error |
| `PgmMissing` | Program missing |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("Test","Support.CreateSoftLock")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","AJN")
F.Global.CallWrapper.SetProperty("Test","UserID","SUPERVSR")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","CALLWRAP")
F.Global.CallWrapper.SetProperty("Test","LockType",10)
F.Global.CallWrapper.SetProperty("Test","LockKey","210900           -R1")
F.Global.CallWrapper.SetProperty("Test","Reference","Bom Lock Project")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Support.OPTEXCH
Launches the core Exchange Rate Maintenance screen to add or update exchange rates for customers supporting multiple currencies.

**Core Program:** `OPTEXCH`

> **Note:** No return parameters.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |

```
F.Global.CallWrapper.New("Test","Support.OPTEXCH")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.Run("Test")
```
---
## Support.ReleaseSoftLock
Release a previously initiated Global Shop soft lock.

**Core Program:** `SYS060`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `UserID` | String | 8 | User ID |
| `CallingProgram` | String | 8 | Calling program name |
| `LockType` | Enum | | See LockType enum below |
| `LockKey` | String | 50 | Must match the LockKey specified when the initial soft lock was created |

**LockType Enum:**

| Value | Description |
|-------|-------------|
| `0` | WorkOrder |
| `1` | Router |
| `2` | SalesOrder |
| `3` | PurchaseOrder |
| `4` | Quote |
| `5` | PurchaseReq |
| `6` | Contract |
| `7` | Transit |
| `8` | WorkOrderSequence |
| `9` | Batch |
| `10` | BillofMaterial |
| `11` | Project |
| `12` | FixedAssets |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Lock released successfully |
| `CurUserLocked` | Current user has the lock |
| `ParmError` | Invalid parameter |
| `Locked` | Resource is locked |
| `LockNotFound` | Lock not found |
| `FileError` | File error |
| `PidError` | PID error |
| `PgmMissing` | Program missing |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("Test","Support.ReleaseSoftLock")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","AJN")
F.Global.CallWrapper.SetProperty("Test","UserID","SUPERVSR")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","CALLWRAP")
F.Global.CallWrapper.SetProperty("Test","LockType",10)
F.Global.CallWrapper.SetProperty("Test","LockKey","210900           -R1")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Support.ValidateLocation
Validate a location code.

**Core Program:** `ORD846`

**Full Name:** `GSSEO.CallWrappers.Support.ValidateLocation`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code |
| `LocationCode` | String | Location code to validate |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `AllowBlankLocation` | Boolean | Set from inventory part maintenance / part number generator maintenance to allow a blank location. Set to `Y` in those programs |
| `IsShippingLocation` | Boolean | Passed by user security maintenance when the shipping location is changed. Formats the error message for invalid locations |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | Invalid Location |
| `2` | Invalid Blank Location |
| `3` | Failed |

```
F.Global.CallWrapper.New("Test","Support.ValidateLocation")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","LocationCode","GS")
F.Global.CallWrapper.SetProperty("Test","AllowBlankLocation",True)
F.Global.CallWrapper.SetProperty("Test","IsShippingLocation",True)
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
```
---

# Troubleshoot CallWrappers

Common issues when implementing CallWrappers:

1. **Status is empty or unexpected** -- Always call `GetProperty("alias","Status",...)` after `Run`. Check that the property names in `SetProperty` exactly match the documented required properties (case-insensitive, but spelling must be exact).
2. **"Module not found" / Core program missing** -- Ensure the GlobalShop version supports the CallWrapper. Some wrappers require specific modules to be installed.
3. **Silent failure (no error, no effect)** -- Missing required properties often cause the wrapper to exit without error. Double-check all Required Properties are set before `Run`.
4. **Wrong wrapper name in `New`** -- Verify the full namespace path (e.g., `Sales.UpdateShipmentLinePrice`, not `UpdateShipmentLinePrice`).
5. **Type mismatch** -- Numeric properties passed as strings (or vice versa) can cause unexpected behavior. Match the type documented in the property table.
6. **Soft lock conflicts** -- Some wrappers require `ProcessID` to recognize existing locks. Pass the process ID when running from Sales Order Maintenance or similar screens.

For CallWrapper usage patterns and naming conventions, see `agents/gab/CALLWRAPPERS.md`.

---

