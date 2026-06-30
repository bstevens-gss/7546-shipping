# GAB CallWrapper Reference -- Purchasing
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for purchasing, payroll, and object programs
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

> **PARTIALLY UNDOCUMENTED FILE**
>
> Several sections in this file are marked `UNDOCUMENTED` because they have not been verified against the GSS Object Browser. **Do NOT generate code** from UNDOCUMENTED sections without first consulting the GSS Object Browser or asking the user. The Payroll and most Purchasing procedural CallWrapper sections are verified and correct.

---

# CALLWRAPPER USAGE PATTERN

```
F.Global.CallWrapper.New("alias","Namespace.ClassName")
F.Global.CallWrapper.SetProperty("alias","PropertyName",sValue)
F.Global.CallWrapper.Run("alias")
F.Global.CallWrapper.GetProperty("alias","PropertyName",sResult)
```

---

# Object CallWrappers

> **UNDOCUMENTED:** The Object CallWrapper API surface for Purchasing is not yet documented here. Consult the GSS Object Browser or ask the user for the specific object wrapper details needed.

---

# Payroll

## Payroll.ADPImport
Creates a batch for ADP records from a tab-delimited text file. Always defaults to screenless.

**Core Program:** `XPR095`

**Full Name:** `GSSEO.CallWrappers.Payroll.ADPImport`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `FileName` | String | 255 | Full file path of the upload file |
| `PostDate` | String | 8 | Post date in `YYYYMMDD` format |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `BatchNumber` | String | 5 | Batch number (only used if *Autonumber Journal Entries* option is off) |
| `BatchReference` | String | 15 | Description of the batch |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success |
| `35` | ParmError — Invalid parameters passed |
| `99` | Failure — Process failed |
| Other | Failure |

**ADP Import File Layout (tab-delimited):**

| Field | Size | Description |
|-------|------|-------------|
| Account Number | 15 | GL account number |
| Date | 10 | Format `mm/dd/yyyy` |
| Amount | 12 | Amount |
| Account Description | 30 | *Not used* |
| Description | 30 | Transaction description |
| Branch Code | 2 | Branch code |

```
F.Global.CallWrapper.New("AdpImport","Payroll.ADPImport")
F.Global.CallWrapper.SetProperty("AdpImport","Company","297")
F.Global.CallWrapper.SetProperty("AdpImport","FileName",V.Local.sFilePath)
F.Global.CallWrapper.SetProperty("AdpImport","BatchNumber",V.Local.sBatchNumber)
F.Global.CallWrapper.SetProperty("AdpImport","BatchReference",V.Local.sBatchReference)
F.Global.CallWrapper.SetProperty("AdpImport","PostDate",V.Local.sBatchDate)
F.Global.CallWrapper.Run("AdpImport")
```
---
## Payroll.GenerateElectronicW2
Generate electronic W-2 forms.

**Core Program:** `PR0053S`

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `W2FilePath` | String | Alternate path to the file `W2REPORTUS.TXT`. Defaults to `..\Global\Files\` when left blank |
| `UsePriorYear` | Boolean | Use prior year data |

```
V.Local.bUsePriorYear.Declare(Boolean)
V.Local.bUsePriorYear.Set(True)
F.Global.CallWrapper.New("Test","Payroll.GenerateElectronicW2")
F.Global.CallWrapper.SetProperty("Test","W2FilePath","C:\GlobalShop\Files\")
F.Global.CallWrapper.SetProperty("Test","UsePriorYear",V.Local.bUsePriorYear)
F.Global.CallWrapper.Run("Test")
```
---
## Payroll.UploadEmployees
Uploads a fixed-position flat text file into the Employee master database. Pay extra attention to the boolean flags -- `PurgePrior` will erase the entire employee master before import, and `AllowUpdates` controls whether duplicate keys overwrite existing records.

**Core Program:** `UPLEMPL`

**Full Name:** `GSSEO.CallWrappers.Payroll.UploadEmployees`

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `Company` | String | Yes | Company code to upload the employee data into |
| `Terminal` | String | No | Terminal number uploading the data (for auditing) |
| `CallingProgram` | String | Yes | Calling program name |
| `PurgePrior` | Boolean | Yes | If `True`, the employee master file is erased before uploading. After upload, the master will contain only the data from the file. |
| `AllowUpdates` | Boolean | Yes | If `True`, overwrites existing employee data when duplicate keys are found. If `False`, skips employees whose keys already exist in the master. |
| `Screenless` | Boolean | No | If `True`, runs in screenless mode (no/fewer screens). Defaults to `False`. |
| `ImportRootFileName` | String | No | Relative filename without directory or extension. Assumes `%company%\FILES\` directory and `.txt` extension. If the file is `Employee.txt` (the default), do **not** provide a value. |

> **`ImportRootFileName` example:** If your file is `%company%\FILES\UploadEmployees.txt`, set this to `"UploadEmployees"`. If your file is the default `Employee.txt`, leave this property unset.

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `FilePathImported` | String | Full path of the file that was imported. Use to verify the correct file was uploaded. |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | The employee data was successfully uploaded |
| `30` | InputFileError | The file to import was not found, or the data was not as expected |
| `35` | ParmError | Invalid parameters passed to program |
| `99` | Failure | Process failed |
| Other | Failure | Process failed |

**Example — update employees, do not purge master (file: UploadEmployees.txt):**

```
F.Global.CallWrapper.New("Test","Payroll.UploadEmployees")
F.Global.CallWrapper.SetProperty("Test","Company","297")
F.Global.CallWrapper.SetProperty("Test","Terminal","001")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","PurgePrior",False)
F.Global.CallWrapper.SetProperty("Test","AllowUpdates",True)
F.Global.CallWrapper.SetProperty("Test","Screenless",True)
F.Global.CallWrapper.SetProperty("Test","ImportRootFileName","UploadEmployees")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sFilePath.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","FilePathImported",V.Local.sFilePath)
```

**Example — purge master, minimum required properties (default Employee.txt):**

```
F.Global.CallWrapper.New("Test","Payroll.UploadEmployees")
F.Global.CallWrapper.SetProperty("Test","Company","297")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","PurgePrior",True)
F.Global.CallWrapper.SetProperty("Test","AllowUpdates",False)
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```

---

# Purchasing

## Purchasing.AutomatedPurchaseOrderGeneration
Launches the Automated Purchase Order Generation process.

**Core Program:** `PURA60GI`

> **Note:** Status is not used at this time.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |

```
F.Global.CallWrapper.New("Test","Purchasing.AutomatedPurchaseOrderGeneration")
F.Global.CallWrapper.SetProperty("Test","Company","ABC")
F.Global.CallWrapper.Run("Test")
```
---
## Purchasing.CreateDropPurchaseOrder
Create a drop-ship purchase order from a sales order.

**Core Program:** `PUR108`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `SalesOrderNumber` | String | 7 | Sales order number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | String (2) | `00` = Successful, `10` = NotSuccessful |

```
F.Global.CallWrapper.New("Test","Purchasing.CreateDropPurchaseOrder")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber","0012345")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.sReturnCode)
```
---
## Purchasing.GenerateMultilineRfq
Generate a multiline RFQ (Request for Quote) using the AutoPur object.

**Core Program:** `PURA65N`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `Username` | String | 8 | User name |

> **Note:** `Mode` is set to `A` (Use AutoPur Object) inside the callwrapper.

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `RFQ Not Licensed` | RFQ module is not licensed |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("Test","Purchasing.GenerateMultilineRfq")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","Username","GABUSER")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Purchasing.GetAccountByProductLine
Get the purchasing GL account by product line. Internally calls `Purchasing.UpdatePurchaseRequisition` with Mode `6`.

**Core Program:** `PUR828`

> **Note:** `Mode` is set to `6` (Get Account by ProductLine) inside the callwrapper.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `ProductLineCode` | String | 3 | Product line code |
| `FileType` | String | 1 | File type |
| `DoNotOverrideProductLineFromWorkOrder` | String | 1 | Flag to prevent product line override from work order |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ShowErrors` | String | 1 | Show errors flag |
| `VendorNumber` | String | 6 | Vendor number |
| `WorkOrderNumber` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 1 | Work order sequence |
| `PurchaseOrderNumber` | String | 7 | Purchase order number |
| `PurchaseOrderLineNumber` | String | 4 | Purchase order line number |
| `ReceiveToWorkOrder` | String | 1 | Receive to work order flag |
| `RequisitionNumber` | String | 6 | Requisition number |
| `RequisitionLineNumber` | String | 3 | Requisition line number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | See status table below |
| `PurchasingAccountTypeSelected` | String (1) | Purchasing account type selected |
| `AccountNumber` | String (15) | Account number |
| `ProductLineCodeUsed` | String (3) | Product line code used |
| `IsInventoryProductLine` | String (1) | Is inventory product line flag |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Invalid Parameter` | Invalid parameter passed |
| `Obsolete Part` | Part is obsolete |
| `Invalid WO` | Invalid work order |
| `Invalid WO Seq` | Invalid work order sequence |
| `Invalid PO` | Invalid purchase order |
| `Invalid Part` | Invalid part |
| `Inactive Acct` | Inactive account |
| `Prd Ln Req Inv Part` | Product line requires inventory part |
| `Not Found` | Not found |

```
F.Global.CallWrapper.New("Test","Purchasing.GetAccountByProductLine")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.SetProperty("Test","ProductLineCode","ABC")
F.Global.CallWrapper.SetProperty("Test","FileType","I")
F.Global.CallWrapper.SetProperty("Test","DoNotOverrideProductLineFromWorkOrder","N")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sAcctType.Declare(String)
F.Global.CallWrapper.GetProperty("Test","PurchasingAccountTypeSelected",V.Local.sAcctType)
V.Local.sAcctNum.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountNumber",V.Local.sAcctNum)
V.Local.sProdLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ProductLineCodeUsed",V.Local.sProdLine)
V.Local.sIsInvPL.Declare(String)
F.Global.CallWrapper.GetProperty("Test","IsInventoryProductLine",V.Local.sIsInvPL)
```
---
## Purchasing.GetAccountNumberByDefault
Get the purchasing GL account by default logic. Internally calls `Purchasing.UpdatePurchaseRequisition` with Mode `5`.

**Core Program:** `PUR828`

> **Note:** `Mode` is set to `5` (Get Account by Default) inside the callwrapper.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `FileType` | String | 1 | File type |
| `DoNotOverrideProductLineFromWorkOrder` | String | 1 | Flag to prevent product line override from work order |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ShowErrors` | String | 1 | Show errors flag |
| `WorkOrderNumber` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 1 | Work order sequence |
| `PurchaseOrderNumber` | String | 7 | Purchase order number |
| `PurchaseOrderLineNumber` | String | 4 | Purchase order line number |
| `ProductLineCode` | String | 3 | Product line code |
| `ReceiveToWorkOrder` | String | 1 | Receive to work order flag |
| `VendorNumber` | String | 6 | Vendor number |
| `RequisitionNumber` | String | 6 | Requisition number |
| `RequisitionLineNumber` | String | 3 | Requisition line number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | See status table below |
| `PurchasingAccountTypeSelected` | String (1) | Purchasing account type selected |
| `AccountNumber` | String (15) | Account number |
| `ProductLineCodeUsed` | String (3) | Product line code used |
| `IsInventoryProductLine` | String (1) | Is inventory product line flag |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Invalid Parameter` | Invalid parameter passed |
| `Obsolete Part` | Part is obsolete |
| `Invalid WO` | Invalid work order |
| `Invalid WO Seq` | Invalid work order sequence |
| `Invalid PO` | Invalid purchase order |
| `Invalid Part` | Invalid part |
| `Inactive Acct` | Inactive account |
| `Prd Ln Req Inv Part` | Product line requires inventory part |
| `Not Found` | Not found |

```
F.Global.CallWrapper.New("Test","Purchasing.GetAccountNumberByDefault")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.SetProperty("Test","FileType","I")
F.Global.CallWrapper.SetProperty("Test","DoNotOverrideProductLineFromWorkOrder","N")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sAcctType.Declare(String)
F.Global.CallWrapper.GetProperty("Test","PurchasingAccountTypeSelected",V.Local.sAcctType)
V.Local.sAcctNum.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountNumber",V.Local.sAcctNum)
V.Local.sProdLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ProductLineCodeUsed",V.Local.sProdLine)
V.Local.sIsInvPL.Declare(String)
F.Global.CallWrapper.GetProperty("Test","IsInventoryProductLine",V.Local.sIsInvPL)
```
---
## Purchasing.GetAccountNumberByWorkOrder
Get the purchasing GL account by work order. Internally calls `Purchasing.UpdatePurchaseRequisition` with Mode `2`.

**Core Program:** `PUR828`

> **Note:** `Mode` is set to `2` (Get Account by WorkOrder) inside the callwrapper.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `WorkOrderNumber` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 1 | Work order sequence |
| `FileType` | String | 1 | File type |
| `DoNotOverrideProductLineFromWorkOrder` | String | 1 | Flag to prevent product line override from work order |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ShowErrors` | String | 1 | Show errors flag |
| `PurchaseOrderNumber` | String | 7 | Purchase order number |
| `PurchaseOrderLineNumber` | String | 4 | Purchase order line number |
| `ProductLineCode` | String | 3 | Product line code |
| `ReceiveToWorkOrder` | String | 1 | Receive to work order flag |
| `VendorNumber` | String | 6 | Vendor number |
| `RequisitionNumber` | String | 6 | Requisition number |
| `RequisitionLineNumber` | String | 3 | Requisition line number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | See status table below |
| `PurchasingAccountTypeSelected` | String (1) | Purchasing account type selected |
| `AccountNumber` | String (15) | Account number |
| `ProductLineCodeUsed` | String (3) | Product line code used |
| `IsInventoryProductLine` | String (1) | Is inventory product line flag |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Invalid Parameter` | Invalid parameter passed |
| `Obsolete Part` | Part is obsolete |
| `Invalid WO` | Invalid work order |
| `Invalid WO Seq` | Invalid work order sequence |
| `Invalid PO` | Invalid purchase order |
| `Invalid Part` | Invalid part |
| `Inactive Acct` | Inactive account |
| `Prd Ln Req Inv Part` | Product line requires inventory part |
| `Not Found` | Not found |

```
F.Global.CallWrapper.New("Test","Purchasing.GetAccountNumberByWorkOrder")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.SetProperty("Test","WorkOrderNumber","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","1")
F.Global.CallWrapper.SetProperty("Test","FileType","I")
F.Global.CallWrapper.SetProperty("Test","DoNotOverrideProductLineFromWorkOrder","N")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sAcctType.Declare(String)
F.Global.CallWrapper.GetProperty("Test","PurchasingAccountTypeSelected",V.Local.sAcctType)
V.Local.sAcctNum.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountNumber",V.Local.sAcctNum)
V.Local.sProdLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ProductLineCodeUsed",V.Local.sProdLine)
V.Local.sIsInvPL.Declare(String)
F.Global.CallWrapper.GetProperty("Test","IsInventoryProductLine",V.Local.sIsInvPL)
```
---
## Purchasing.GetAccountProductLine
Returns the account product line for a given part, product line, and purchase order/line number.

**Core Program:** `PUR828`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Part` | String | 20 | Part number |
| `Location` | String | 2 | Part location |
| `PurchaseOrderNumber` | Long | 7 | Purchase order number |
| `PurchaseOrderLine` | Long | 4 | Purchase order line |
| `ProductLine` | String | 3 | Product line |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Integer (2) | Status code (see table below) |
| `AccountTypeSelected` | String (1) | Account type code (see enum below) |
| `Account` | String (15) | Account name/number |
| `ReturnProductLine` | String (3) | Product line |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `1` | Invalid Parameter |
| `2` | Obsolete Part |
| `3` | Invalid Work Order |
| `4` | Invalid Work Order Sequence |
| `5` | Invalid Purchase Order |
| `6` | Invalid Part |
| `7` | Invalid Inactive Account |
| `8` | Invalid Product Line Requisition Inventory Part |
| `23` | Account Not Found |

**AccountTypeSelected Enum:**

| Code | Description |
|------|-------------|
| `W` | WIP |
| `L` | Lot |
| `A` | Advance Fixture |
| `P` | Product Line |
| `G` | General Ledger |
| `H` | Work Order Product Line |
| `O` | Location |
| `V` | Vendor |
| `I` | Purchasing Inventory |
| `1` | Purchase Order Header |
| `U` | Product Line Purchasing |
| `2` | Product Line WIP |

```
F.Global.CallWrapper.New("Test","Purchasing.GetAccountProductLine")
F.Global.CallWrapper.SetProperty("Test","Part","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","Location","TX")
F.Global.CallWrapper.SetProperty("Test","PurchaseOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","PurchaseOrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","ProductLine","ABC")
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
V.Local.sAccountTypeSelected.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountTypeSelected",V.Local.sAccountTypeSelected)
V.Local.sAccount.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Account",V.Local.sAccount)
V.Local.sReturnProductLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnProductLine",V.Local.sReturnProductLine)
```
---
## Purchasing.GetAccountPurchaseOrder
Returns the GL account number for a given part, product line, and purchase order/line number.

**Core Program:** `PUR828`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Part` | String | 20 | Part number |
| `Location` | String | 2 | Part location |
| `PurchaseOrderNumber` | Long | 7 | Purchase order number |
| `PurchaseOrderLine` | Long | 4 | Purchase order line |
| `ProductLine` | String | 3 | Product line |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Integer (2) | Status code (see table below) |
| `AccountTypeSelected` | String (1) | Account type code (see enum below) |
| `Account` | String (15) | Account name/number |
| `ReturnProductLine` | String (3) | Product line |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `1` | Invalid Parameter |
| `2` | Obsolete Part |
| `3` | Invalid Work Order |
| `4` | Invalid Work Order Sequence |
| `5` | Invalid Purchase Order |
| `6` | Invalid Part |
| `7` | Invalid Inactive Account |
| `8` | Invalid Product Line Requisition Inventory Part |
| `23` | Account Not Found |

**AccountTypeSelected Enum:**

| Code | Description |
|------|-------------|
| `W` | WIP |
| `L` | Lot |
| `A` | Advance Fixture |
| `P` | Product Line |
| `G` | General Ledger |
| `H` | Work Order Product Line |
| `O` | Location |
| `V` | Vendor |
| `I` | Purchasing Inventory |
| `1` | Purchase Order Header |
| `U` | Product Line Purchasing |
| `2` | Product Line WIP |

```
F.Global.CallWrapper.New("Test","Purchasing.GetAccountPurchaseOrder")
F.Global.CallWrapper.SetProperty("Test","Part","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","Location","TX")
F.Global.CallWrapper.SetProperty("Test","PurchaseOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","PurchaseOrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","ProductLine","ABC")
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
V.Local.sAccountTypeSelected.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountTypeSelected",V.Local.sAccountTypeSelected)
V.Local.sAccount.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Account",V.Local.sAccount)
V.Local.sReturnProductLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnProductLine",V.Local.sReturnProductLine)
```
---
## Purchasing.GetAccountSelection
Returns the account selection for a given part, product line, and purchase order/line number.

**Core Program:** `PUR828`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Part` | String | 20 | Part number |
| `Location` | String | 2 | Part location |
| `PurchaseOrderNumber` | Long | 7 | Purchase order number |
| `PurchaseOrderLine` | Long | 4 | Purchase order line |
| `ProductLine` | String | 3 | Product line |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Integer (2) | Status code (see table below) |
| `AccountTypeSelected` | String (1) | Account type code (see enum below) |
| `Account` | String (15) | Account name/number |
| `ReturnProductLine` | String (3) | Product line |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `1` | Invalid Parameter |
| `2` | Obsolete Part |
| `3` | Invalid Work Order |
| `4` | Invalid Work Order Sequence |
| `5` | Invalid Purchase Order |
| `6` | Invalid Part |
| `7` | Invalid Inactive Account |
| `8` | Invalid Product Line Requisition Inventory Part |
| `23` | Account Not Found |

**AccountTypeSelected Enum:**

| Code | Description |
|------|-------------|
| `W` | WIP |
| `L` | Lot |
| `A` | Advance Fixture |
| `P` | Product Line |
| `G` | General Ledger |
| `H` | Work Order Product Line |
| `O` | Location |
| `V` | Vendor |
| `I` | Purchasing Inventory |
| `1` | Purchase Order Header |
| `U` | Product Line Purchasing |
| `2` | Product Line WIP |

```
F.Global.CallWrapper.New("Test","Purchasing.GetAccountSelection")
F.Global.CallWrapper.SetProperty("Test","Part","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","Location","TX")
F.Global.CallWrapper.SetProperty("Test","PurchaseOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","PurchaseOrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","ProductLine","ABC")
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
V.Local.sAccountTypeSelected.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountTypeSelected",V.Local.sAccountTypeSelected)
V.Local.sAccount.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Account",V.Local.sAccount)
V.Local.sReturnProductLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnProductLine",V.Local.sReturnProductLine)
```
---
## Purchasing.GetPartPurchaseCost
Retrieve purchased cost for a supplied part (and optional vendor) from a variety of sources.

**Core Program:** `PUR080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallType` | Long | 3 | Associated call type (defaults to `1` if not set). `1` = Default, `2` = Vendor Quote, `3` = Purchase Order History |
| `Part` | String | 20 | Part number |
| `Location` | String | 2 | Part location |
| `Quantity` | Double | 16.6 | Quantity (required for Default and Vendor Quote call types) |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Vendor` | String | 6 | Vendor number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Long (4) | `0` = Successful, `1` = No Cost Found |
| `ReturnCost` | Double (16.6) | Retrieved cost in vendor currency |
| `ReturnVendor` | String (6) | Returned vendor number |

```
F.Global.CallWrapper.New("Test","Purchasing.GetPartPurchaseCost")
F.Global.CallWrapper.SetProperty("Test","CallType",1)
F.Global.CallWrapper.SetProperty("Test","Part","COMPUTER BOX")
F.Global.CallWrapper.SetProperty("Test","Location","GS")
F.Global.CallWrapper.SetProperty("Test","Vendor","CCVEN1")
F.Global.CallWrapper.SetProperty("Test","Quantity",1234567890.123456)
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
V.Local.fReturnCost.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","ReturnCost",V.Local.fReturnCost)
V.Local.sReturnVendor.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnVendor",V.Local.sReturnVendor)
```
---
## Purchasing.GetPurchaseOrderLineCostAndVendor
Retrieves the cost and vendor information for a purchase order line. This callwrapper uses an object-passing pattern rather than individual properties -- the `AutomatedPurchaseOrderCost` object is passed in, populated by the core program, and returned.

**Core Program:** `PUR834`

**Full Name:** `GSSEO.CallWrappers.Purchasing.GetPurchaseOrderLineCostAndVendor`

**Required Passed Object:**

| Object | Description |
|--------|-------------|
| `AutomatedPurchaseOrderCost` | The cost/vendor object to populate. Passed to the callwrapper for processing. |

**Returned Object:**

| Object | Description |
|--------|-------------|
| `AutomatedPurchaseOrderCost` | The same object is returned with cost and vendor data populated by the core program. |

> **Note:** This callwrapper operates on the `AutomatedPurchaseOrderCost` object directly rather than exposing individual `SetProperty`/`GetProperty` fields. Consult GSS documentation for the full schema of the `AutomatedPurchaseOrderCost` object.

---
## Purchasing.MaintainVendorQuotesByPart
Opens the vendor quote maintenance screen filtered by part number. Unlike `Purchasing.ViewVendorQuoteByPart` (read-only), this opens in edit mode.

**Core Program:** `PUR021GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `PartNumber` | String | Part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `NotFound` | No records found |
| `Failed` | The change failed |

```
F.Global.CallWrapper.New("Test","Purchasing.MaintainVendorQuotesByPart")
F.Global.CallWrapper.SetProperty("Test","PartNumber","COMPUTER BOX")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Purchasing.OpenPurchaseRequisition
Open a purchase requisition for editing. Internally calls `Purchasing.UpdatePurchaseRequisition` with Mode `O`.

**Core Program:** `PUR011GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `CallingProgram` | String | 8 | Calling program name |
| `RequisitionNumber` | String | 6 | Requisition number |

> **Note:** Mode is set to `O` (Open) inside the callwrapper.

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Parm Error` | Invalid parameter |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("Test","Purchasing.OpenPurchaseRequisition")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","RequisitionNumber","123456")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Purchasing.PurchaseOrderReceipt
Receive purchase order lines using a text file. Supports lot/bin, work order receipts, drop shipment, freight/other cost allocation, and audit trail printing.

**Core Program:** `PUR102` > `PUR100GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `FileName` | String | 18 | Text file name (must be a `.txt` file in `Global\Files`, no sub-folders) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process completed successfully |
| `Errors` | Record(s) in text file failed (see returned error file) |
| `InvalidFileName` | Passed `FileName` not found |
| `Failed` | Other failure has occurred |

**Error File:** Written to `Global/Files` folder using the same `FileName`. Layout: `Original Line From Input Text File ==> Error: Error Title and Message`

**Input Text File Layout** (comma delimited, `.txt` in `Global\Files`, no sub-folders):

> **Note:** Fields marked N/A are not used but must still be included as empty CSV values to maintain field positions.

| # | Field | Required | Type | Size | Notes |
|---|-------|----------|------|------|-------|
| 1 | Purchase Order Number | Yes | Int | 9 | |
| 2 | Purchase Order Line | Yes | Int | 3 | |
| 3 | Bin | | String | 6 | For lot/bin parts. Required if *Do Not Allow Blank Bin* option enabled. |
| 4 | Lot | | String | 15 | For lot/bin parts |
| 5 | Heat | | String | 15 | For lot/bin parts |
| 6 | Serial | | String | 30 | For lot/bin parts |
| 7 | Received Date | Yes | Date | 6 | Format `YYMMDD` |
| 8 | Received Quantity | Yes | Num | -10.4 | Requires decimal |
| 9 | Receiver Number | | String | 6 | If blank, gets next automatically |
| 10 | N/A | | | | Not used |
| 11 | Close PO Line | | Boolean | | `Y` or `N`/blank. Set `Y` to close PO line. |
| 12 | Work Order | | String | 6 | Must be valid if used |
| 13 | Work Order Suffix | | String | 3 | Must be valid if used |
| 14 | Work Order Sequence | | Int | 6 | Must be valid if used. Must be Material or Outside Sequence. |
| 15 | N/A | | | | Not used |
| 16 | Receiver Text | | String | 30 | Requires Receiver Number |
| 17 | N/A | | | | Not used |
| 18 | N/A | | | | Not used |
| 19 | Print Receipts Audit Trail | | String | 1 | `P` to print. Prints for entire file run if set on any line. |
| 20 | N/A | | | | Not used |
| 21 | N/A | | | | Not used |
| 22 | Quantity Rejected | | Num | -8.4 | Rejected quantity (not for drop ship) |
| 23 | Scrap Code | | String | 3 | Must be valid (not for drop ship) |
| 24 | Quantity To Inspection | | Boolean | | `Y` or `N`. Receive to inspection (not for drop ship). |
| 25 | N/A | | | | Not used |
| 26 | User 1 Text | | String | 15 | For lot/bin parts |
| 27 | User 2 Text | | String | 15 | For lot/bin parts |
| 28 | User 3 Text | | String | 15 | For lot/bin parts |
| 29 | User 4 Text | | String | 15 | For lot/bin parts |
| 30 | User 5 Text | | String | 15 | For lot/bin parts |
| 31 | User 6 Text | | String | 15 | For lot/bin parts |
| 32 | User 7 Text | | String | 15 | For lot/bin parts |
| 33 | User 8 Text | | String | 15 | For lot/bin parts |
| 34 | User 9 Text | | String | 15 | For lot/bin parts |
| 35 | Expiration Date | | Date | 8 | Format `YYYYMMDD`. For lot/bin parts. |
| 36 | N/A | | | | Not used |
| 37 | N/A | | | | Not used |
| 38 | N/A | | | | Not used |
| 39 | N/A | | | | Not used |
| 40 | Freight Vendor | | String | 6 | Required when entering a Freight Amount |
| 41 | Freight Amount | | Num | 6.2 | Enter full amount on first line only (allocated among parts). For drop ship, applied to Vendor Cost only. |
| 42 | Other Vendor | | String | 6 | Required when entering an Other Amount |
| 43 | Other Amount | | Num | 6.2 | Enter full amount on first line only (allocated among parts). For drop ship, applied to Vendor Cost only. |
| 44 | Ship Drop Ship Line | | Boolean | | `Y`/`N`. Set `Y` to auto-ship drop-ship PO line. Requires *Auto Relieve Lot/Bin During Shipping* option. |

**Option Dependencies:**

| Option | Location |
|--------|----------|
| Auto Relieve Lot/Bin During Shipping | *System Support > Company Options (Standard) > Inventory Accounting Options* |
| Do Not Allow Blank Bin on Lot/Bin Records | *System Support > Admin > Company Options (Standard) > Inventory* |
| Do NOT Allow Allocation of Freight & Tax on Receipts | *System Support > Admin > Company Options (Adv) > Purchasing* (blocks Freight/Other) |
| Standard Inventory Cost - Purchasing | *System Support > Admin > Company Options (Standard) > Inventory Accounting Options* (blocks Freight/Other) |
| Obtain Material Overhead % from Vendor | *System Support > Admin > Company Options (Standard) > Inventory* (blocks Other) |
| Utilize "Other" Inventory Cost Element to Add Surcharge | *System Support > Transactions > Run 1SHOT > CUSTOM* (blocks Other) |

```
F.Global.CallWrapper.New("Test","Purchasing.PurchaseOrderReceipt")
F.Global.CallWrapper.SetProperty("Test","FileName","TEST.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
```
---
## Purchasing.PurchaseOrderUpload
Upload purchase orders from a file.

**Core Program:** `UPLPUROR`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Mode` | String | -- | `"Append"` or `"Delete"` |
| `FileName` | String | 256 | File name |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | `Success`, `ParmError` (invalid parameter), or `Fail` (other failure) |
| `ReturnFileName` | String | Returned file name |

```
F.Global.CallWrapper.New("Test","Purchasing.PurchaseOrderUpload")
F.Global.CallWrapper.SetProperty("Test","Mode","Append")
F.Global.CallWrapper.SetProperty("Test","FileName","C:\Global Shop Solutions\Files\po_upload.txt")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sReturnFileName.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnFileName",V.Local.sReturnFileName)
```
---
## Purchasing.UpdatePurchaseRequisition
Get the purchasing GL account for a purchase requisition by work order (Mode 2), by default (Mode 5), or by product line (Mode 6).

**Core Program:** `PUR828`

### Mode 2 — Get Account by Work Order

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `Mode` | Long | 1 | `2` — Get Account by WorkOrder (set inside the callwrapper) |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `WorkOrderNumber` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 1 | Work order sequence |
| `FileType` | String | 1 | File type |
| `DoNotOverrideProductLineFromWorkOrder` | String | 1 | Flag to prevent product line override from work order |

**Optional Properties (Mode 2):**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ShowErrors` | String | 1 | Show errors flag |
| `PurchaseOrderNumber` | String | 7 | Purchase order number |
| `PurchaseOrderLineNumber` | String | 4 | Purchase order line number |
| `ProductLineCode` | String | 3 | Product line code |
| `ReceiveToWorkOrder` | String | 1 | Receive to work order flag |
| `VendorNumber` | String | 6 | Vendor number |
| `RequisitionNumber` | String | 6 | Requisition number |
| `RequisitionLineNumber` | String | 3 | Requisition line number |

### Mode 5 — Get Account by Default

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `Mode` | Long | 1 | `5` — Get Account by Default (set inside the callwrapper) |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `FileType` | String | 1 | File type |
| `DoNotOverrideProductLineFromWorkOrder` | String | 1 | Flag to prevent product line override from work order |

**Optional Properties (Mode 5):**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ShowErrors` | String | 1 | Show errors flag |
| `WorkOrderNumber` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 1 | Work order sequence |
| `PurchaseOrderNumber` | String | 7 | Purchase order number |
| `PurchaseOrderLineNumber` | String | 4 | Purchase order line number |
| `ProductLineCode` | String | 3 | Product line code |
| `ReceiveToWorkOrder` | String | 1 | Receive to work order flag |
| `VendorNumber` | String | 6 | Vendor number |
| `RequisitionNumber` | String | 6 | Requisition number |
| `RequisitionLineNumber` | String | 3 | Requisition line number |

### Mode 6 — Get Account by Product Line

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `Mode` | Long | 1 | `6` — Get Account by ProductLine (set inside the callwrapper) |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `ProductLineCode` | String | 3 | Product line code |
| `FileType` | String | 1 | File type |
| `DoNotOverrideProductLineFromWorkOrder` | String | 1 | Flag to prevent product line override from work order |

**Optional Properties (Mode 6):**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `ShowErrors` | String | 1 | Show errors flag |
| `VendorNumber` | String | 6 | Vendor number |
| `WorkOrderNumber` | String | 6 | Work order number |
| `WorkOrderSuffix` | String | 3 | Work order suffix |
| `WorkOrderSequence` | String | 1 | Work order sequence |
| `PurchaseOrderNumber` | String | 7 | Purchase order number |
| `PurchaseOrderLineNumber` | String | 4 | Purchase order line number |
| `ReceiveToWorkOrder` | String | 1 | Receive to work order flag |
| `RequisitionNumber` | String | 6 | Requisition number |
| `RequisitionLineNumber` | String | 3 | Requisition line number |

### Returned Properties (All Modes)

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String | See status table below |
| `PurchasingAccountTypeSelected` | String (1) | Purchasing account type selected |
| `AccountNumber` | String (15) | Account number |
| `ProductLineCodeUsed` | String (3) | Product line code used |
| `IsInventoryProductLine` | String (1) | Is inventory product line flag |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Invalid Parameter` | Invalid parameter passed |
| `Obsolete Part` | Part is obsolete |
| `Invalid WO` | Invalid work order |
| `Invalid WO Seq` | Invalid work order sequence |
| `Invalid PO` | Invalid purchase order |
| `Invalid Part` | Invalid part |
| `Inactive Acct` | Inactive account |
| `Prd Ln Req Inv Part` | Product line requires inventory part |
| `Not Found` | Not found |

```
F.Global.CallWrapper.New("Test","Purchasing.UpdatePurchaseRequisition")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.SetProperty("Test","WorkOrderNumber","500041")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSuffix","001")
F.Global.CallWrapper.SetProperty("Test","WorkOrderSequence","1")
F.Global.CallWrapper.SetProperty("Test","FileType","I")
F.Global.CallWrapper.SetProperty("Test","DoNotOverrideProductLineFromWorkOrder","N")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sAcctType.Declare(String)
F.Global.CallWrapper.GetProperty("Test","PurchasingAccountTypeSelected",V.Local.sAcctType)
V.Local.sAcctNum.Declare(String)
F.Global.CallWrapper.GetProperty("Test","AccountNumber",V.Local.sAcctNum)
V.Local.sProdLine.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ProductLineCodeUsed",V.Local.sProdLine)
V.Local.sIsInvPL.Declare(String)
F.Global.CallWrapper.GetProperty("Test","IsInventoryProductLine",V.Local.sIsInvPL)
```
---
## Purchasing.ViewPurchaseOrderHistoryByPart
View purchase order history by part number. Menu path: *Purchasing > View > Purchase Orders by Part/Vendor > Choose by Part Number*.

**Core Program:** `PUR183GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `PartNumber` | String | Part number |
| `PartNumberRevision` | String | Part number revision. Used when *Use Revision Level/Engineering Change* is enabled. |
| `LocationCode` | String | Part number location |

```
F.Global.CallWrapper.New("Test","Purchasing.ViewPurchaseOrderHistoryByPart")
F.Global.CallWrapper.SetProperty("Test","PartNumber","WIDGET-A")
F.Global.CallWrapper.SetProperty("Test","PartNumberRevision","001")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.Run("Test")
```
---
## Purchasing.ViewPurchaseRequisition
View a purchase requisition in read-only mode. Internally calls `Purchasing.UpdatePurchaseRequisition` with Mode `V`.

**Core Program:** `PUR011GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `CallingProgram` | String | 8 | Calling program name |
| `RequisitionNumber` | String | 6 | Requisition number |

> **Note:** Mode is set to `V` (View) inside the callwrapper.

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Parm Error` | Invalid parameter |
| `Failed` | General failure |

```
F.Global.CallWrapper.New("Test","Purchasing.ViewPurchaseRequisition")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","RequisitionNumber","123456")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Purchasing.ViewVendorQuoteByPart
View vendor quotes filtered by part number.

**Core Program:** `PUR021GI`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `PartNumber` | String | Part number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `NotFound` | No records found |
| `Failed` | The change failed |

```
F.Global.CallWrapper.New("Test","Purchasing.ViewVendorQuoteByPart")
F.Global.CallWrapper.SetProperty("Test","PartNumber","COMPUTER BOX")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---

