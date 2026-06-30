# GAB CallWrapper Reference -- Sales (Part 2 of 2)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for sales invoicing, shipping, and related programs
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

## Sales.Invoicing.CheckForDuplicateInvoiceNumber
Check whether an invoice number already exists.

**Core Program:** `ORD841`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `InvoiceNumber` | String | 7 | Invoice number to check |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program code |
| `BatchNumber` | String | 5 | Batch number |

**Returned Status:**

| Code | Description |
|------|-------------|
| `00` | Successful |
| `22` | Duplicate |
| `37` | ProgramNotFound |
| `99` | Cancel |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.CheckForDuplicateInvoiceNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","InvoiceNumber","0012345")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sReturnCode)
```
---
## Sales.Invoicing.EditInvoiceComments
Edit comments for an invoice.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `InvoiceNumber` | String | 7 | Invoice number |
| `OrderNumber` | Long | 7 | Order number |
| `OrderSequence` | Long | 4 | Order sequence |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Comments` | String | New value of the comments |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Comment was successfully changed |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.EditInvoiceComments")
F.Global.CallWrapper.SetProperty("Test","InvoiceNumber","0012345")
F.Global.CallWrapper.SetProperty("Test","OrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OrderSequence",1234)
F.Global.CallWrapper.SetProperty("Test","Comments","Updated invoice comment")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.Invoicing.EditInvoiceLineComments
Edit comments for a specific invoice line.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `InvoiceNumber` | String | 7 | Invoice number |
| `OrderNumber` | Long | 7 | Order number |
| `OrderSequence` | Long | 4 | Order sequence |
| `OrderLine` | String | 4 | Order line |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Comments` | String | New value of the comments |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Comment was successfully changed |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.EditInvoiceLineComments")
F.Global.CallWrapper.SetProperty("Test","InvoiceNumber","0012345")
F.Global.CallWrapper.SetProperty("Test","OrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OrderSequence",1234)
F.Global.CallWrapper.SetProperty("Test","OrderLine","0001")
F.Global.CallWrapper.SetProperty("Test","Comments","Updated line comment")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.Invoicing.EditPackingListComments
Edit comments for a packing list.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | Long | 7 | Order number |
| `OrderSuffix` | Long | 4 | Order suffix |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Comments` | String | Variable | New value of the comments |
| `CustomerNumber` | String | 7 | Customer number (populates title bar) |
| `CustomerName` | String | 30 | Customer name (populates title bar) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Comment was successfully changed |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.EditPackingListComments")
F.Global.CallWrapper.SetProperty("Test","OrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OrderSuffix",1234)
F.Global.CallWrapper.SetProperty("Test","Comments","Updated packing list comment")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","CustomerName","ACME Corp")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.Invoicing.EditPackingListLineComments
Edit comments for a specific packing list line.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | Long | 7 | Order number |
| `OrderSuffix` | Long | 4 | Order suffix |
| `OrderLine` | String | 4 | Order line |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Comments` | String | Variable | New value of the comments |
| `Part` | String | 20 | Part number (populates title bar) |
| `Revision` | String | 3 | Revision (populates title bar) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Comment was successfully changed |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.EditPackingListLineComments")
F.Global.CallWrapper.SetProperty("Test","OrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OrderSuffix",1234)
F.Global.CallWrapper.SetProperty("Test","OrderLine","0001")
F.Global.CallWrapper.SetProperty("Test","Comments","Updated line comment")
F.Global.CallWrapper.SetProperty("Test","Part","COMPUTER BOX")
F.Global.CallWrapper.SetProperty("Test","Revision","001")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.Invoicing.ReprintCreditMemo
Reprint a credit memo with a view screen and the correct title on the document.

**Core Program:** `QL3060`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CreditMemoNumber` | String | 6 | Credit memo number |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.ReprintCreditMemo")
F.Global.CallWrapper.SetProperty("Test","CreditMemoNumber","123456")
F.Global.CallWrapper.Run("Test")
```
---
## Sales.Invoicing.SelectOrdersToInvoiceByShipment
Uses an input text file to select orders for invoicing by shipment.

**Core Program:** `ORD109` > `ORD101`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `FilePath` | String | 256 | Full file path to the input text file |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process completed successfully |
| `ParmError` | Passed property `FilePath` is missing |
| `NoRecords` | Input file empty |
| `FileError` | Input file open failed/not found or ASLCT temp file open failed |
| `Cancel` | Other failure has occurred |

**Input Text File Layout** (comma-delimited):

| # | Field Name | Data Type | Size |
|---|-----------|-----------|------|
| 1 | Order | Int | 7 |
| 2 | Order Seq | Int | 4 |

```
F.Global.CallWrapper.New("Test","Sales.Invoicing.SelectOrdersToInvoiceByShipment")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","FilePath","C:\TestInputFiles\ORD109.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ReturnStatus",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Sales.MoveQuoteLine
Move an existing quote from one line number to another.

**Core Program:** `ORD896`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | String | 7 | Order number |
| `OrderLine` | Long | 4 | Source order line |
| `NewOrderLine` | Long | 4 | Destination order line |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | Long (2) | Return code (see table below) |
| `BusinessMessageNumber` | Long (9) | Business message number (set on non-successful status) |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `23` | Line Missing |
| `24` | Module Missing |
| `25` | Parameter Error |
| `29` | Order Number In Use |
| `35` | File Error |
| `40` | Failed |

```
F.Global.CallWrapper.New("Test","Sales.MoveQuoteLine")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","GABSCRIPT")
F.Global.CallWrapper.SetProperty("Test","OrderNumber","0012345")
F.Global.CallWrapper.SetProperty("Test","OrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","NewOrderLine",5678)
F.Global.CallWrapper.Run("Test")
V.Local.iStatus.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
V.Local.iBusinessMessageNumber.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","BusinessMessageNumber",V.Local.iBusinessMessageNumber)
```
---
## Sales.MoveSalesOrderLine
Move an existing sales order line from one line number to another.

**Core Program:** `ORD896`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | String | 7 | Order number |
| `OrderLine` | Long | 4 | Source order line |
| `NewOrderLine` | Long | 4 | Destination order line |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | Long (2) | Return code (see table below) |
| `BusinessMessageNumber` | Long (9) | Business message number (set on non-successful status) |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `23` | Line Missing |
| `24` | Module Missing |
| `25` | Parameter Error |
| `29` | Order Number In Use |
| `35` | File Error |
| `40` | Failed |

```
F.Global.CallWrapper.New("Test","Sales.MoveSalesOrderLine")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","GABSCRIPT")
F.Global.CallWrapper.SetProperty("Test","OrderNumber","0012345")
F.Global.CallWrapper.SetProperty("Test","OrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","NewOrderLine",5678)
F.Global.CallWrapper.Run("Test")
V.Local.iStatus.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
V.Local.iBusinessMessageNumber.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","BusinessMessageNumber",V.Local.iBusinessMessageNumber)
```
---
## Sales.NewShipments
Displays open items to be selected for shipment.

**Core Program:** `ORD098`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | String | 7 | Order number |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderLineNumber` | String | 4 | Order line number |

```
F.Global.CallWrapper.New("Test","Sales.NewShipments")
F.Global.CallWrapper.SetProperty("Test","OrderNumber","1234567")
F.Global.CallWrapper.SetProperty("Test","OrderLineNumber","1234")
F.Global.CallWrapper.Run("Test")
```
---
## Sales.OpenBlanketRelease
Open a blanket release for a sales order.

**Core Program:** `ORD221`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Order` | Long | 7 | Release order number |
| `ShipTo` | String | 6 | Ship-to number |
| `BlanketOrder` | Long | 7 | Blanket order number |
| `PurchaseOrder` | String | 30 | Purchase order number |
| `CustomerNumber` | String | 7 | Customer number |
| `CustomerName` | String | 30 | Customer name |

```
F.Global.CallWrapper.New("Test","Sales.OpenBlanketRelease")
F.Global.CallWrapper.SetProperty("Test","Order",1234567)
F.Global.CallWrapper.SetProperty("Test","ShipTo","000001")
F.Global.CallWrapper.SetProperty("Test","BlanketOrder",7654321)
F.Global.CallWrapper.SetProperty("Test","PurchaseOrder","PO-12345")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","CustomerName","ACME Corp")
F.Global.CallWrapper.Run("Test")
```
---
## Sales.OpenShipSchedule
Open Ship Schedule for maintenance.

**Core Program:** `ORD085`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |
| `FileType` | String | 1 | `S` = Schedule, `H` = Ship, `R` = RMA |
| `SalesOrder` | Long | 7 | Sales order number |
| `SalesOrderLine` | Long | 4 | Sales order line |
| `Quantity` | Double | 13 (9.4) | Quantity |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Long (1) | `00` = Successful, `35` = File Error |
| `FileName` | String (12) | File name |

```
F.Global.CallWrapper.New("Test","Sales.OpenShipSchedule")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","GABSCRIPT")
F.Global.CallWrapper.SetProperty("Test","FileType","S")
F.Global.CallWrapper.SetProperty("Test","SalesOrder",1234567)
F.Global.CallWrapper.SetProperty("Test","SalesOrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","Quantity",123456789.1234)
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
V.Local.sFileName.Declare(String)
F.Global.CallWrapper.GetProperty("Test","FileName",V.Local.sFileName)
```
---
## Sales.ProcessSalesOrderBookings
Writes bookings for SalesOrder changes.

**Core Program:** `ProcessSalesOrderBooking`

**Full Name:** `GSSEO.CallWrappers.Sales.ProcessSalesOrderBookings`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | Company code |
| `SalesOrderNumber` | Integer (7) | Sales order number |
| `OriginalSalesOrder` | Sales.SalesOrder Object | A copy of the original sales order object when it was first loaded |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `1` | ParameterError |
| `2` | FileError |
| `3` | DeadLock |
| `4` | Cancel |

```
F.Global.CallWrapper.New("Test","Sales.ProcessSalesOrderBookings")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OriginalSalesOrder",SampleSalesOrderObject)
F.Global.CallWrapper.Run("Test")
V.Local.eStatus.Declare(Enum)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.eStatus)
```
---
## Sales.ProcessSalesOrderShipToBookings
Writes bookings for SalesOrderShipTo changes.

**Core Program:** `ProcessSalesOrderBooking`

**Full Name:** `GSSEO.CallWrappers.Sales.ProcessSalesOrderShipToBookings`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | Company code |
| `SalesOrderNumber` | Integer (7) | Sales order number |
| `OriginalSalesOrderShipTo` | Sales.SalesOrderShipTo Object | A copy of the original sales order ship-to object when it was first loaded |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `1` | ParameterError |
| `2` | FileError |
| `3` | DeadLock |
| `4` | Cancel |

```
F.Global.CallWrapper.New("Test","Sales.ProcessSalesOrderShipToBookings")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OriginalSalesOrderShipTo",SampleSalesOrderShipToObject)
F.Global.CallWrapper.Run("Test")
V.Local.eStatus.Declare(Enum)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.eStatus)
```
---
## Sales.Quoting.EditQuoteComments
Edit comments for a quote. Optional header parameters populate the title bar.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `QuoteNumber` | Long | 7 | Quote number |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Comments` | String | Variable | New value of the comments |
| `CustomerNumber` | String | 7 | Customer number (populates title bar) |
| `CustomerName` | String | 30 | Customer name (populates title bar) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Comment was successfully changed |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.Quoting.EditQuoteComments")
F.Global.CallWrapper.SetProperty("Test","QuoteNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","CustomerName","ACME Corp")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.Quoting.EditQuoteLineComments
Edit comments for a specific quote line. Optional header parameters populate the title bar.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `QuoteNumber` | Long | 7 | Quote number |
| `QuoteLine` | String | 4 | Quote line |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Comments` | String | Variable | New value of the comments |
| `Part` | String | 20 | Part number (populates title bar) |
| `Description` | String | 30 | Description (populates title bar) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Comment was successfully changed |
| `FileError` | Error with accessing the comments file |
| `ParmError` | Invalid parameter passed |
| `Fail` | Other failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.Quoting.EditQuoteLineComments")
F.Global.CallWrapper.SetProperty("Test","QuoteNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","QuoteLine","0001")
F.Global.CallWrapper.SetProperty("Test","Part","COMPUTER BOX")
F.Global.CallWrapper.SetProperty("Test","Description","Standard enclosure")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.Quoting.OpenQuoteForEdit
Open a quote for editing.

**Core Program:** `QTE200`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `Quote` | Long | 7 | Quote number |

**Returned Properties:** None

```
F.Global.CallWrapper.New("Test","Sales.Quoting.OpenQuoteForEdit")
F.Global.CallWrapper.SetProperty("Test","Company","TST")
F.Global.CallWrapper.SetProperty("Test","Quote",1234567)
F.Global.CallWrapper.Run("Test")
```
---
## Sales.Quoting.OpenQuoteForView
Open a quote in view-only mode.

**Core Program:** `QTE200`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `Quote` | Long | 7 | Quote number |

**Returned Properties:** None

```
F.Global.CallWrapper.New("Test","Sales.Quoting.OpenQuoteForView")
F.Global.CallWrapper.SetProperty("Test","Company","TST")
F.Global.CallWrapper.SetProperty("Test","Quote",1234567)
F.Global.CallWrapper.Run("Test")
```
---
## Sales.Quoting.UpdateWonLossForFourDigitLine
Update a single quote line Won/Loss status. Must use the four-digit line number matching `QUOTE_LINES.RECORD_NO`.

**Core Program:** `QTE003GI`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `QuoteNumber` | Integer | 7 | Quote number |
| `QuoteLineNumber` | Integer | 4 | Must match 4-digit `QUOTE_LINES.RECORD_NO` |
| `WonLossStatus` | Enum | 1 | `W` = Won Line, `L` = Loss Line, `C` = Close Line |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process successfully updated quote line |
| `ParmError` | QuoteNumber, QuoteLineNumber or WonLossStatus not set correctly |
| `Failure` | Other failure; see error message displayed during processing |

```
F.Global.CallWrapper.New("Test","Sales.Quoting.UpdateWonLossForFourDigitLine")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","79R")
F.Global.CallWrapper.SetProperty("Test","QuoteNumber","7706")
F.Global.CallWrapper.SetProperty("Test","QuoteLineNumber","0021")
F.Global.CallWrapper.SetProperty("Test","WonLossStatus","W")
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
## Sales.RemoveVatTaxAuthorities
Removes any VAT tax authorities using the ProcessTax module. Tax data after removal is returned along with a status. Tax values may or may not change. This mode is not applicable to line-level data. Uses `SysParameterList` instead of linkage.

**Core Program:** `ProcessTax`

**Full Name:** `GSSEO.CallWrappers.Sales.RemoveVatTaxAuthorities`

> **Version Requirements:** Minimum `2020.1`. Make sure to override the `GLOBALVERSION` environment variable with `2020.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `Mode` | Integer | No | Hard-coded to `13` for this callwrapper |
| `SourceDataType` | Enum (Integer) | Yes | Data source for tax rules. See **SourceDataType** enum below. |
| `TaxState` | String | Yes | Tax state |
| `TaxAuthorities` | List Of AppliedTaxAuthority | Yes | `ApplyTaxes` is required for all data sources except Prospect, Customer, and Customer Ship To. Splits into `TaxAuthorityZones` (Strings), `TaxAuthorityCodes` (Strings), and `ApplyTaxes` (Booleans). |

**SourceDataType Enum:**

| Value | Name |
|-------|------|
| `0` | Order |
| `5` | InvoiceBatch |

> **Note:** The `SourceDataType` values for this callwrapper differ from the other ProcessTax callwrappers. Here Order = `0` (vs `1` in `EditTaxAuthorities`, `AssignTaxAuthorities`, and `GetTaxableStatus`), and only two data sources are supported.

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnTaxState` | String | Tax state |
| `ReturnTaxAuthority` | List Of AppliedTaxAuthority | Combined from `ReturnTaxAuthorityZones` (Strings), `ReturnTaxAuthorityCodes` (Strings), and `ReturnApplyTaxes` (Booleans) |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Successful | Operation completed successfully |
| `1` | InvalidParameter | A required parameter was missing or invalid |
| `2` | Failed | The operation failed |
| `3` | Cancel | The operation was cancelled |

```
F.Global.CallWrapper.New("Test","Sales.RemoveVatTaxAuthorities")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","Mode","13")
F.Global.CallWrapper.SetProperty("Test","SourceDataType","0")
F.Global.CallWrapper.SetProperty("Test","TaxState","TX")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sTaxState.Declare(String)
V.Local.sTaxAuth.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxState",V.Local.sTaxState)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxAuthority",V.Local.sTaxAuth)
```
---
## Sales.Shipping.PrintPackingList

Prints a packing list for a shipment. Supports options to suppress due dates, customs invoices, and errors, and can print labels only.

**Full Name:** `GSSEO.CallWrappers.Sales.Shipping.PrintPackingList`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code the callwrapper is executed in |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CallingProgram` | String | Calling program passed to the wrapped module (used for logging/auditing) |
| `InvoiceNumber` | String | Invoice number |
| `SalesOrderNumber` | Integer | Sales order number |
| `ShipmentSequence` | Integer | Shipment sequence number |
| `SuppressDueDate` | Boolean | Suppress due date on the packing list |
| `SuppressCustomsInvoice` | Boolean | Suppress customs invoice |
| `OnlyPrintLabels` | Boolean | Print labels only (skip the packing list document) |
| `SuppressErrors` | Boolean | Suppress error display |
| `PackingListNumber` | Integer | Packing list number |
| `ShippedDate` | DateTime | Shipped date |
| `Staged` | Boolean | Staged shipment flag |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success |
| `10` | DataAccessError |
| `24` | NoData |
| `55` | Failed |
| Other | Unknown — other general failure |

```
F.Global.CallWrapper.New("PL","Sales.Shipping.PrintPackingList")
F.Global.CallWrapper.SetProperty("PL","CompanyCode",V.Caller.CompanyCode)
F.Global.CallWrapper.SetProperty("PL","CallingProgram","CW")
F.Global.CallWrapper.SetProperty("PL","PackingListNumber",V.DataTable.dtLoadPL(V.Local.sSel(V.Local.i)).PACKING LIST!FieldVal)
F.Global.CallWrapper.SetProperty("PL","Staged",True)
F.Global.CallWrapper.Run("PL")
V.Local.eStatus.Declare(Enum)
F.Global.CallWrapper.GetProperty("PL","Status",V.Local.eStatus)
```

---
## Sales.UpdateOpenOrderBalance
Updates the open order balance on the customer master. If the new balance changes the credit or shipping hold settings for the customer, it will update the shipping hold for the sales order.

**Core Program:** `ORD804`

**Full Name:** `GSSEO.CallWrappers.Sales.UpdateOpenOrderBalance`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | Company code |
| `CustomerNumber` | String (6) | Sales order customer number |
| `SalesOrderValueDelta` | Double (16.2) | Change in gross sales for the sales order |
| `SalesOrderNumber` | Integer (7) | Sales order number |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `IsWebImporter` | Boolean | If `True`, passes `ORDUPL` as the calling program |
| `BuyingGroupCustomerNumber` | String (6) | Buying group customer number (if used for the sales order) |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | CustomerUpdateFailed |
| `2` | CustomerMissing |
| `3` | Failed |
| `4` | CustomerRecordLocked |

```
F.Global.CallWrapper.New("Test","Sales.UpdateOpenOrderBalance")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","IsWebImporter",True)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","123ABC")
F.Global.CallWrapper.SetProperty("Test","SalesOrderValueDelta",123.45)
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","BuyingGroupCustomerNumber","ABC123")
F.Global.CallWrapper.Run("Test")
V.Local.eStatus.Declare(Enum)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.eStatus)
```
---
## Sales.UpdateOrderHeaderAndLinesByFile
This callwrapper supports updating order header and order line data.

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Screenless` | Long | Set to `1` for screenless (background) operation |
| `InputFileName` | String | Path to the input file containing order update data |

**Returned Status:**

| Code | Status | Description |
|------|--------|-------------|
| `0` | Success | Order data was successfully updated |
| `1` | ParameterError | Invalid parameters |
| `2` | Failure | Order data was not updated |
| `23` | NoRecords | No records match the provided data |
| `35` | FileError | File I/O error |
| `99` | Cancel | The operation was canceled |
| Other | Fail | Other failure has occurred |

```
V.Local.sReturnCode.Declare(String)

F.Global.CallWrapper.New("Test","Sales.UpdateOrderHeaderAndLinesByFile")
F.Global.CallWrapper.SetProperty("Test","Screenless",1)
F.Global.CallWrapper.SetProperty("Test","InputFileName","SOUPDLINES.TXT")
F.Global.CallWrapper.Run("Test")
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sReturnCode)
F.Intrinsic.Control.If(V.Local.sReturnCode,=,"Success")
    F.Intrinsic.UI.Msgbox("Success")
F.Intrinsic.Control.Else
    F.Intrinsic.UI.Msgbox("Line update CallWrapper failed")
F.Intrinsic.Control.EndIf
```

---
## Sales.UpdateOrderLinesByFile
Updates order line data from a comma-delimited text file. Supports soft-locking and detailed logging.

**Core Program:** `ORD897`

**Full Name:** `GSSEO.CallWrappers.Sales.UpdateOrderLinesByFile`

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `Company` | String | No | Company the callwrapper is executing in |
| `CallingProgram` | String | No | Calling program |
| `Screenless` | Boolean | No | If `True`, ORD897 will not show screens during processing |
| `InputFileName` | String | Yes | Relative file name with extension (e.g. `Upload.txt`). Simple text, comma delimited. |
| `ProcessID` | Numeric | No | Pass the Process ID if executing from Sales Order Maintenance to recognize existing soft locks |

**Inbound Data for Line Updates** (comma delimited):

| Field Name | Size | Required | Notes |
|-----------|------|----------|-------|
| Header or Line | 1 | Yes | Value must be `L` |
| Order Number | 7 | Yes | Include leading zeroes (e.g. `0008925`) |
| Order Line Number | 3 | Yes | Include leading zeroes (e.g. `003`) |
| Order Quantity | 13 (up to 4 decimals) | No | May trigger repricing if default price type with quantity-based price |
| Unit Price | 16 (up to 6 decimals) | No | Price type will be set to Quoted |
| Cost | 16 (up to 6 decimals) | No | Cost per piece |
| Order Discount | 5 (up to 4 decimals) | No | Discount rate (e.g. `0.2000` for 20%) |
| Product Line | 3 | No | Must be valid; may affect product line discount or GL account |
| Weight | 10 (up to 3 decimals) | No | Total part weight for the line |
| Configurator Part | 20 | No | Replaces existing part without business logic |
| Configurator Part Location | 2 | No | Replaces existing part location |
| Configurator Part Description | 50 | No | Replaces existing part description |

> **Note:** Contract pricing and Quantity Updates to BOM Parents are not supported.

**Special Formatting Rules:**
- Each field must be followed by a comma, with these exceptions:
  - Two additional commas after Order Line Number
  - Six additional commas after Cost
  - Seven additional commas after Order Discount

**Sample Record** *(Order 8925, Line 3, Qty 125, Price 75.98, Cost 26.7894, 10% discount, PL FG1, Weight 250):*

`L,0008925,003,,,125,75.98,26.7894,,,,,,,0.1000,,,,,,,,FG1,250,,,`

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success - Order data was successfully updated |
| `1` | ParameterError - Invalid parameters |
| `2` | Failure - Order data was not updated |
| `23` | NoRecords - No records match the provided data |
| `35` | FileError - File I/O error |
| `99` | Cancel - The operation was canceled |
| Other | Fail - Other failure has occurred |

**SalesOrderUpdateLog** (`.txt` file written to the Files folder; existing file is renamed with appended date/time):

| Field Name | Columns | Description |
|-----------|---------|-------------|
| Record Type | 1 | `L` = line update, `H` = applies to entire order |
| Order Number | 2-8 | With leading zeroes |
| Order Line Number | 9-12 | With leading zeroes and trailing zero |
| Terminal Number | 13-15 | Terminal number of the update |
| Customer Ship To | 16-22 | Customer ship-to ID from the sales order line |
| Status (Boolean) | 23 | `0` = failed, `1` = successful |
| Error Reference | 14-30 | Error code for trapping (e.g. `REF: 10`) |
| Message | 32-259 | Detailed message or additional information |

```
F.Global.CallWrapper.New("Test","Sales.UpdateOrderLinesByFile")
F.Global.CallWrapper.SetProperty("Test","Screenless",1)
F.Global.CallWrapper.SetProperty("Test","InputFileName","SOUPDLINES.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sReturnCode)
F.Intrinsic.Control.If(V.Local.sReturnCode,=,"0")
    F.Intrinsic.UI.Msgbox("Success")
F.Intrinsic.Control.Else
    F.Intrinsic.UI.Msgbox("Line update CallWrapper failed")
F.Intrinsic.Control.EndIf
```
---
## Sales.UpdateShipmentLinePrice
Updates any open shipment lines with a price change. All inputs come from the SalesOrderLine object.

> **Note:** This callwrapper cannot currently be launched in-process since it can launch SP2 screens.

**Core Program:** `ORD869`

**Full Name:** `GSSEO.CallWrappers.Sales.UpdateShipmentLinePrice`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | Company code |
| `Username` | String (8) | Current username |
| `SalesOrderNumber` | UInteger (7) | Sales order number |
| `SalesOrderLineNumber` | UInteger (3) | Sales order line number |
| `PartNumber` | String (17) | Part number |
| `LocationCode` | String (2) | Part location code |
| `PricingCompanyUnit` | Double (10.6) | Unit price in company currency |
| `FreightPriceCompanyUnit` | Double (10.6) | Freight per piece in company currency |
| `PriceCustomerUnit` | Double (10.6) | Unit price in customer currency |
| `FreightPriceCustomerUnit` | Double (10.6) | Freight per piece in customer currency |
| `PriceCodeType` | Enum (2) | Price code type (`GSSEO.EOEnum.Sales.PricingType`) |
| `DiscountApply` | Enum (1) | `0` = NoDiscountApplied, `1` = AlwaysApplyDiscount, `2` = DiscountAppliedPerPriceCode |
| `PriceClassRate` | Double (1.4) | Price class discount rate |
| `ProductLineDiscountRate` | Double (1.4) | Product line discount rate |
| `DiscountRate` | Double (1.4) | Order discount rate |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `PartNumberRevision` | String (3) | Part number revision |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Successful |
| `1` | FileError |
| `2` | Failed |

```
F.Global.CallWrapper.New("Test","Sales.UpdateShipmentLinePrice")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","Username","TSTUSER")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","SalesOrderLineNumber",123)
F.Global.CallWrapper.SetProperty("Test","PartNumber","12345TESTPART")
F.Global.CallWrapper.SetProperty("Test","LocationCode","TX")
F.Global.CallWrapper.SetProperty("Test","PricingCompanyUnit",123.456)
F.Global.CallWrapper.SetProperty("Test","FreightPriceCompanyUnit",1234.567)
F.Global.CallWrapper.SetProperty("Test","PriceCustomerUnit",123.456)
F.Global.CallWrapper.SetProperty("Test","FreightPriceCustomerUnit",1234.567)
F.Global.CallWrapper.SetProperty("Test","PriceCodeType",5)
F.Global.CallWrapper.SetProperty("Test","DiscountApply",0)
F.Global.CallWrapper.SetProperty("Test","PriceClassRate",0.50)
F.Global.CallWrapper.SetProperty("Test","ProductLineDiscountRate",0.50)
F.Global.CallWrapper.SetProperty("Test","DiscountRate",0.50)
F.Global.CallWrapper.Run("Test")
V.Local.eStatus.Declare(Enum)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.eStatus)
```
---
## Sales.UploadFreightLine
Uses an upload text file to update or add freight charges to a sales order. The upload file can contain multiple orders.

**Core Program:** `ORD108` / `ORD0FRT`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `InputFileName` | String | 15 | Input file name (see file layout below) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Process completed successfully |
| `InvalidParameter` | Invalid or missing passed property |
| `ImportFileError` | Import file not found |
| `FileError` | File error |
| `Failure` | Other failure; see log file in temp directory |

**Input Text File Layout** (`*!*` delimited):

| # | Field Name | Data Type | Size | Notes |
|---|-----------|-----------|------|-------|
| 1 | Order Number | Int | 7 | Required |
| 2 | Freight Amount | Num | 8.2 | |
| 3 | Freight Cost | Num | 8.6 | Requires Freight Only Flag NOT set to `Y`. If `0` and Freight Only Flag not `Y`, uses Freight Amount |
| 4 | GL Account | String | 15 | Valid account required. Requires Freight Only Flag NOT set to `Y` |
| 5 | Tax Flag | String | 1 | Requires Freight Only Flag NOT set to `Y`. `Y` = Taxable, `D` = Use Default Taxes |
| 6 | Freight Only Flag | String | 1 | Space or `C` = Update Freight Cost, `Y` = Do Not Update Freight Cost |
| 7 | Freight Currency Flag | String | 1 | Space = Use Order Currency, `Y` = Use Company Currency |

```
F.Global.CallWrapper.New("Test","Sales.UploadFreightLine")
F.Global.CallWrapper.SetProperty("Test","InputFileName","FREIGHTUPLOAD.TXT")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sReturnCode)
```
---
## Sales.ViewShipSchedule
View Ship Schedule (read-only).

**Core Program:** `ORD085`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CallingProgram` | String | 8 | Calling program name |
| `FileType` | String | 1 | `S` = Schedule, `H` = Ship, `R` = RMA |
| `SalesOrder` | Long | 7 | Sales order number |
| `SalesOrderLine` | Long | 4 | Sales order line |
| `Quantity` | Double | 13 (9.4) | Quantity |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnCode` | Long (1) | `00` = Successful, `35` = File Error |
| `FileName` | String (12) | File name |

```
F.Global.CallWrapper.New("Test","Sales.ViewShipSchedule")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","GABSCRIPT")
F.Global.CallWrapper.SetProperty("Test","FileType","S")
F.Global.CallWrapper.SetProperty("Test","SalesOrder",1234567)
F.Global.CallWrapper.SetProperty("Test","SalesOrderLine",1234)
F.Global.CallWrapper.SetProperty("Test","Quantity",123456789.1234)
F.Global.CallWrapper.Run("Test")
V.Local.iReturnCode.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","ReturnCode",V.Local.iReturnCode)
V.Local.sFileName.Declare(String)
F.Global.CallWrapper.GetProperty("Test","FileName",V.Local.sFileName)
```
---

