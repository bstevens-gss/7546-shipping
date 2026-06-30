# GAB CallWrapper Reference -- Sales (Part 1 of 2)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with CallWrappers for sales order, quote, and general sales programs
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

# Sales

## Table of Contents (Part 1)

- [AdjustSlidingPriceClassDiscountForLine](#salesadjustslidingpriceclassdiscountforline)
- [AssignTaxAuthorities](#salesassigntaxauthorities)
- [CalculateExtendedValues](#salescalculateextendedvalues)
- [CalculateFreightPerPiece](#salescalculatefreightperpiece)
- [CalculateMargin](#salescalculatemargin)
- [CalculateSalesOrderTotals](#salescalculatesalesordertotals)
- [CheckForDuplicateSalesOrderNumber](#salescheckforduplicatesalesordernumber)
- [Configurator.GetQuoteConfiguration](#salesconfiguratorgetquoteconfiguration)
- [Configurator.GetSalesOrderConfiguration](#salesconfiguratorgetsalesorderconfiguration)
- [DeleteSalesOrder](#salesdeletesalesorder)
- [EditOrderComments](#saleseditordercomments)
- [EditOrderLineComments](#saleseditorderlinecomments)
- [EditSalesOrderInClassicScreen](#saleseditsalesorderinclassicscreen)
- [EditTaxAuthorities](#salesedittaxauthorities)
- [GetBuyingGroupBalance](#salesgetbuyinggroupbalance)
- [GetCarrierAccount](#salesgetcarrieraccount)
- [GetDefaultSalesOrderLineUserValues](#salesgetdefaultsalesorderlineuservalues)
- [GetDefaultSalesOrderUserValues](#salesgetdefaultsalesorderuservalues)
- [GetNextSalesOrderNumber](#salesgetnextsalesordernumber)
- [GetNextSalesOrderNumberByDate](#salesgetnextsalesordernumberbydate)
- [GetSalesOrderExchangeRates](#salesgetsalesorderexchangerates)
- [GetSalesOrderText](#salesgetsalesordertext)
- [GetSlidingPriceClassDiscount](#salesgetslidingpriceclassdiscount)
- [GetTaxableStatus](#salesgettaxablestatus)
- [IntercompanySalesOrderEvent](#salesintercompanysalesorderevent)

> **Note:** This is Part 1. For invoicing, quoting, shipments, freight, and remaining Sales entries, see `CW_SALES_2.md`.

---

## Sales.AdjustSlidingPriceClassDiscountForLine
Calculates the sliding price class discount when a sales order line is being modified. The order total used to determine the discount is computed as: (existing order total) minus (the current value of the passed line number) plus (the passed `GrossExtended` value). This allows recalculating the discount based on a proposed line change.

**Core Program:** `ORD823`

**Full Name:** `GSSEO.CallWrappers.Sales.AdjustSlidingPriceClassDiscountForLine`

> **Version Requirements:** Minimum `2019.2`. Make sure to override the `GLOBALVERSION` environment variable with `2019.2` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `CustomerNumber` | String | No | Customer number for the sales order |
| `PriceClassCode` | String | Yes | Price class code for the sales order |
| `SalesOrderNumber` | Integer | Yes | Sales order number applicable to the price class discount |
| `SalesOrderLineNumber` | Integer | Yes | Three-digit sales order line number. The trailing zero is appended by the callwrapper internally. |
| `GrossExtended` | Double | Yes | Gross value for the sales order line (quantity x price, no discounts). Added to the remaining order lines to compute the total used for the discount. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Rate` | Double | Sliding price class discount returned as a decimal value |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | The sliding price class discount was successfully retrieved |
| `23` | NotFound | Options were not successfully loaded |
| `25` | ParameterError | The parameters were not valid |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.AdjustSlidingPriceClassDiscountForLine")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","PriceClassCode","J")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",307)
F.Global.CallWrapper.SetProperty("Test","SalesOrderLineNumber",3)
F.Global.CallWrapper.SetProperty("Test","GrossExtended",0)
F.Global.CallWrapper.Run("Test")
V.Local.fRate.Declare(String)
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Rate",V.Local.fRate)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.AssignTaxAuthorities
Assign tax authorities using the ProcessTax module. Tax data after assignment is returned along with a status. This callwrapper uses `SysParameterList` instead of linkage.

**Core Program:** `ProcessTax`

**Full Name:** `GSSEO.CallWrappers.Sales.AssignTaxAuthorities`

> **Version Requirements:** Minimum `2020.1`. Make sure to override the `GLOBALVERSION` environment variable with `2020.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `Mode` | Integer | No | Hard-coded to `21` for this callwrapper |
| `SourceDataType` | Enum (Integer) | Yes | Data source for tax rules/criteria. See **SourceDataType** enum below. |
| `TaxAssignEvent` | Enum (Integer) | Yes | Activity or reason causing tax authority reassignment. See **TaxAssignEvent** enum below. |
| `Username` | String | No | Current user ID. Defaulted from the current process if not provided. |
| `TaxState` | String | Yes | Tax state |
| `TaxZipCode` | String | Yes | Tax zip code |
| `TaxImport` | Enum (Integer) | Yes | See **TaxImport** enum below. |
| `TaxAuthorities` | List Of AppliedTaxAuthority | Yes | Splits into `TaxAuthorityZones` (Strings), `TaxAuthorityCodes` (Strings), and `ApplyTaxes` (Booleans) |
| `UsedAuthorityIndex` | Boolean | Yes | Flag denoting if taxes are assigned from index |
| `ShippingState` | String | Yes | Ship-to state |
| `ShippingZipCode` | String | Yes | Ship-to zip code |
| `VatExemptType` | Enum (Integer) | Conditional | Required for all data sources except Origin Location. See **VatExemptType** enum below. |
| `VatRuleID` | Integer | Conditional | Required for all data sources except Origin Location. VAT rule ID. |
| `CustomerNumber` | String | Conditional | Required for all data sources except Origin Location |
| `TaxSource` | Enum (Integer) | Conditional | Required for all data sources except Origin Location. See **TaxSource** enum below. |
| `CustomerShipToNumber` | String | Conditional | Required for all data sources except Prospect, Customer, and Origin Location |
| `SalesOrderNumber` | Integer | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location |
| `OrderType` | Enum (Integer) | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location. See **OrderType** enum below. |
| `OriginAddressTaxCode` | Integer | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location. Tax code of the origin address. |
| `PreviousShippingState` | String | Conditional | Required for StateChange or ZipCodeOnlyChange tax assignment events. Ship-to state before the change. |
| `PreviousShippingZipCode` | String | Conditional | Required for StateChange or ZipCodeOnlyChange tax assignment events. Ship-to zip code before the change. |
| `SuppressTaxMessage` | Boolean | No | Optional for StateChange/ZipCodeOnlyChange events. When `True`, suppresses the message asking whether to refresh taxes. |
| `PartNumber` | String | Conditional | Required for line-level data sources. Part number on the line. |
| `PartNumberRevision` | String | Conditional | Required for line-level data sources. Part number revision on the line. |
| `PartLocationCode` | String | Conditional | Required for line-level data sources. Part location on the line. |
| `DiscountCompanyPrice` | Double | Conditional | Required for line-level data sources. Discounted price in company currency. |
| `DiscountCustomerPrice` | Double | Conditional | Required for line-level data sources. Discounted price in customer currency. |
| `LineType` | Integer | Conditional | Required for line-level data sources. The line type. |
| `TaxAssignSource` | Enum (Integer) | Conditional | Required for line-level data sources. See **TaxAssignSource** enum below. |
| `ShipmentSequence` | Integer | Conditional | Required for Shipment, Open Invoice, Invoice Batch, and Invoice History data sources. |
| `InvoiceNumber` | String | Conditional | Required for Invoice History data source. Invoice number. |

**SourceDataType Enum:**

| Value | Name |
|-------|------|
| `1` | Order |
| `3` | Shipment |
| `4` | OpenInvoice |
| `5` | InvoiceBatch |

**TaxAssignEvent Enum:**

| Value | Name | Notes |
|-------|------|-------|
| `0` | Assign | Default. Use when creating a new entity where taxes are not defaulted from another entity. |
| `1` | Reassign | Use when creating a new entity where taxes default from another entity (e.g., order) to apply current changes. |
| `2` | StateChange | Use when ship-to state is manually changed. Not applicable to lines. |
| `3` | ZipCodeOnlyChange | Use when ship-to zip code is manually changed but state is not. Not applicable to lines. |

**TaxImport Enum:**

| Value | Name |
|-------|------|
| `0` | None |
| `1` | Used |
| `2` | NotUsed |

**VatExemptType Enum:**

| Value | Name |
|-------|------|
| `0` | None |
| `1` | Import |
| `2` | Export |
| `3` | Product |
| `4` | Company |

**TaxSource Enum:**

| Value | Name | Notes |
|-------|------|-------|
| `0` | None | |
| `1` | Manual | |
| `2` | ShipTo | |
| `3` | Order | |
| `4` | Origin | Current value (replaces legacy `Location` which also used `4`) |

> **Note:** Value `4` was previously `Location` in older modules. It has been replaced by `Origin`. Both names resolve to the same numeric code. Use `Origin` for new code.

**OrderType Enum:**

| Value | Name |
|-------|------|
| `0` | Regular |
| `1` | CycleBilling |
| `2` | DetailBilling |
| `3` | Repair |
| `4` | InvoiceOnly |
| `5` | Blanket |
| `6` | Transfer |

**TaxAssignSource Enum:**

| Value | Name |
|-------|------|
| `0` | Standard |
| `1` | Buyout |
| `2` | Consignment |
| `3` | DropShip |
| `4` | Freight |
| `5` | ProgressBill |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnTaxSource` | Enum (Integer) | Tax source (same enum as `TaxSource` above) |
| `ReturnTaxState` | String | Tax state |
| `ReturnTaxZipCode` | String | Tax zip code |
| `ReturnTaxAuthorities` | List Of AppliedTaxAuthorityInformation | Combined from `ReturnTaxAuthorityZones` (Strings), `ReturnTaxAuthorityCodes` (Strings), `ReturnApplyTaxes` (Booleans), and `ReturnAuthorityTypeTaxes` (Integers) |
| `ReturnTaxImport` | Enum (Integer) | Tax import (same enum as `TaxImport` above) |
| `ReturnUsedAuthorityIndex` | Boolean | Flag for if taxes were assigned from the index |
| `ReturnOriginAddressTaxCode` | Integer | Origin address tax code |
| `ReturnAssignSourceTax` | Integer | Method used to assign (provided for line-level data sources only) |
| `ReturnAuthorityCount` | Integer | Number of tax authorities |
| `ReturnAuthoritySalesCount` | Integer | Number of sales tax authorities |
| `ReturnAuthorityVatCount` | Integer | Number of VAT tax authorities |
| `ReturnIsChanged` | Boolean | `True` if tax values were updated by the module |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Successful | Operation completed successfully |
| `1` | InvalidParameter | A required parameter was missing or invalid |
| `2` | Failed | The operation failed |
| `3` | Cancel | The operation was cancelled |

```
F.Global.CallWrapper.New("Test","Sales.AssignTaxAuthorities")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","Mode","21")
F.Global.CallWrapper.SetProperty("Test","SourceDataType","1")
F.Global.CallWrapper.SetProperty("Test","TaxAssignEvent",0)
F.Global.CallWrapper.SetProperty("Test","Username","Username")
F.Global.CallWrapper.SetProperty("Test","TaxState","TX")
F.Global.CallWrapper.SetProperty("Test","TaxZipCode","77339")
F.Global.CallWrapper.SetProperty("Test","TaxImport",0)
F.Global.CallWrapper.SetProperty("Test","UsedAuthorityIndex",True)
F.Global.CallWrapper.SetProperty("Test","ShippingState","TX")
F.Global.CallWrapper.SetProperty("Test","ShippingZipCode","77339")
F.Global.CallWrapper.SetProperty("Test","VatRuleID",0)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","000006")
F.Global.CallWrapper.SetProperty("Test","TaxSource",0)
F.Global.CallWrapper.SetProperty("Test","CustomerShipToNumber","01")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",5)
F.Global.CallWrapper.SetProperty("Test","OrderType",0)
F.Global.CallWrapper.SetProperty("Test","OriginAddressTaxCode",0)
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sTaxSource.Declare(String)
V.Local.sTaxState.Declare(String)
V.Local.sTaxZip.Declare(String)
V.Local.sTaxAuth.Declare(String)
V.Local.sTaxImport.Declare(String)
V.Local.bUsedIdx.Declare(String)
V.Local.iOriginCode.Declare(String)
V.Local.iAssignSrc.Declare(String)
V.Local.iAuthCount.Declare(String)
V.Local.iSalesCount.Declare(String)
V.Local.iVatCount.Declare(String)
V.Local.bChanged.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxSource",V.Local.sTaxSource)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxState",V.Local.sTaxState)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxZipCode",V.Local.sTaxZip)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxAuthorities",V.Local.sTaxAuth)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxImport",V.Local.sTaxImport)
F.Global.CallWrapper.GetProperty("Test","ReturnUsedAuthorityIndex",V.Local.bUsedIdx)
F.Global.CallWrapper.GetProperty("Test","ReturnOriginAddressTaxCode",V.Local.iOriginCode)
F.Global.CallWrapper.GetProperty("Test","ReturnAssignSourceTax",V.Local.iAssignSrc)
F.Global.CallWrapper.GetProperty("Test","ReturnAuthorityCount",V.Local.iAuthCount)
F.Global.CallWrapper.GetProperty("Test","ReturnAuthoritySalesCount",V.Local.iSalesCount)
F.Global.CallWrapper.GetProperty("Test","ReturnAuthorityVatCount",V.Local.iVatCount)
F.Global.CallWrapper.GetProperty("Test","ReturnIsChanged",V.Local.bChanged)
```
---
## Sales.CalculateExtendedValues
Calculate the extended values for a sales order line applying discounts. Returns gross extended price, discounted price, discount totals for each of three discount types, and extended price. The `AlwaysApplyDiscount` flag is returned for uploads.

**Core Program:** `ORD810`

**Full Name:** `GSSEO.CallWrappers.Sales.CalculateExtendedValues`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code |
| `OrderedQuantity` | Double | Quantity ordered |
| `PricingUnit` | Double | Price in company or customer currency |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CallingProgram` | String | Calling program name |
| `Weight` | Double | Total weight for the sales order line |
| `UnitOfMeasureCode` | String | Sales unit of measure code |
| `FreightPerPiece` | Double | Freight per piece in company or customer currency |
| `PriceCodeType` | Enum | Price code type (`SalesPricingType`) |
| `PriceClassRate` | Double | Price class discount rate |
| `ProductLineDiscount` | Double | Product line discount rate |
| `DiscountRate` | Double | Order discount rate |
| `DiscountApply` | Enum | Whether discount is always applied, never applied, or applied based on options (`SalesDiscountApply`) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `TotalDiscount` | Double | Total discount amount in company or customer currency |
| `ExtendedPrice` | Double | Extended price in company or customer currency |
| `AlwaysApplyDiscount` | Boolean | Used by uploads to set `DiscountApply` on the line |
| `Status` | Enum | `0` = Successful, `1` = InvalidPrice, `2` = InvalidQuantity, `3` = FileError |
| `ExtendedGrossPrice` | Double | Gross extended price in company or customer currency |
| `SalesOrderDiscount` | Double | Sales order discount amount in company or customer currency |
| `ProductLineDiscount` | Double | Product line discount amount in company or customer currency |
| `PriceClassDiscount` | Double | Price class discount amount in company or customer currency |
| `DiscountedPrice` | Double | Discounted price in company or customer currency |

```
F.Global.CallWrapper.New("Test","Sales.CalculateExtendedValues")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","MYPROGRAM")
F.Global.CallWrapper.SetProperty("Test","OrderedQuantity",100.000)
F.Global.CallWrapper.SetProperty("Test","Weight",50.000)
F.Global.CallWrapper.SetProperty("Test","UnitOfMeasureCode","EA")
F.Global.CallWrapper.SetProperty("Test","PricingUnit",25.50)
F.Global.CallWrapper.SetProperty("Test","FreightPerPiece",1.25)
F.Global.CallWrapper.SetProperty("Test","PriceCodeType","1")
F.Global.CallWrapper.SetProperty("Test","PriceClassRate",5.0)
F.Global.CallWrapper.SetProperty("Test","ProductLineDiscount",2.5)
F.Global.CallWrapper.SetProperty("Test","DiscountRate",10.0)
F.Global.CallWrapper.SetProperty("Test","DiscountApply","1")
F.Global.CallWrapper.Run("Test")
V.Local.dTotalDiscount.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","TotalDiscount",V.Local.dTotalDiscount)
V.Local.dExtendedPrice.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","ExtendedPrice",V.Local.dExtendedPrice)
V.Local.bAlwaysApplyDiscount.Declare(Boolean)
F.Global.CallWrapper.GetProperty("Test","AlwaysApplyDiscount",V.Local.bAlwaysApplyDiscount)
V.Local.iStatus.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
V.Local.dExtendedGrossPrice.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","ExtendedGrossPrice",V.Local.dExtendedGrossPrice)
V.Local.dSalesOrderDiscount.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","SalesOrderDiscount",V.Local.dSalesOrderDiscount)
V.Local.dProductLineDiscount.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","ProductLineDiscount",V.Local.dProductLineDiscount)
V.Local.dPriceClassDiscount.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","PriceClassDiscount",V.Local.dPriceClassDiscount)
V.Local.dDiscountedPrice.Declare(Float)
F.Global.CallWrapper.GetProperty("Test","DiscountedPrice",V.Local.dDiscountedPrice)
```
---
## Sales.CalculateFreightPerPiece
Returns the freight charged per piece. When a freight zone is added to the order, the freight can be included in the price per piece.

**Core Program:** `ORD812`

**Full Name:** `GSSEO.CallWrappers.Sales.CalculateFreightPerPiece`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code |
| `OrderedQuantity` | Double | Quantity ordered |
| `Weight` | Double | Total weight for the sales order line |
| `FreightRate` | Double | Rate for the freight zone from `FreightZone` |
| `CompanyIsoCurrencyCode` | String | Company currency code from the SalesOrder |
| `CustomerIsoCurrencyCode` | String | Customer currency code from the SalesOrder |

**Conditionally Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ExchangeCompanyFromCustomerDate` | DateTime | Required if company and customer currency differ. Exchange date for Company from Customer from the SalesOrder |
| `ExchangeCompanyFromCustomerRate` | Double | Required if company and customer currency differ. Exchange rate for Company from Customer from the SalesOrder |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `UnitOfMeasureCode` | String | Sales unit of measure code |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `FreightPerPiece` | Double | Freight per piece in company currency |
| `CustomerFreightPerPiece` | Double | Freight per piece in customer currency |
| `Status` | Enum | See status table below |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | InvalidFreightZone |
| `2` | InvalidQuantity |
| `3` | InvalidWeight |
| `4` | InvalidCurrency |
| `5` | InvalidExchangeDate |
| `6` | InvalidExchangeRate |

```
F.Global.CallWrapper.New("Test","Sales.CalculateFreightPerPiece")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","OrderedQuantity",123.123)
F.Global.CallWrapper.SetProperty("Test","UnitOfMeasureCode","EA")
F.Global.CallWrapper.SetProperty("Test","Weight",123.123)
F.Global.CallWrapper.SetProperty("Test","FreightRate",123.123)
F.Global.CallWrapper.SetProperty("Test","CompanyIsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("Test","CustomerIsoCurrencyCode","CAD")
F.Global.CallWrapper.SetProperty("Test","ExchangeCompanyFromCustomerDate",20201231)
F.Global.CallWrapper.SetProperty("Test","ExchangeCompanyFromCustomerRate",123.123)
F.Global.CallWrapper.Run("Test")
V.Local.dFreightPerPiece.Declare(Double)
V.Local.dCustomerFreightPerPiece.Declare(Double)
V.Local.iStatus.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","FreightPerPiece",V.Local.dFreightPerPiece)
F.Global.CallWrapper.GetProperty("Test","CustomerFreightPerPiece",V.Local.dCustomerFreightPerPiece)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
```
---
## Sales.CalculateMargin
Calculates the profit margin for the sales order line. Passed the value of the option to use weight to calculate price and several line item properties used in the calculation.

**Core Program:** `ORD817`

**Full Name:** `GSSEO.CallWrappers.Sales.CalculateMargin`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code |
| `DiscountedPrice` | Double | Discounted unit price |
| `UnitCost` | Double | Cost per piece |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `UseWeightToCalculateExtendedPrice` | Boolean | Value of the use-weight-to-calculate-extended-price option (Ophdr ID 90000) |
| `OrderedQuantity` | Double | Sales order line ordered quantity |
| `Weight` | Double | Total weight for the line item |
| `UnitOfMeasureCode` | String | Sales unit of measure |
| `FreightPerPiece` | Double | Freight per piece |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Margin` | Double | Profit margin |
| `Status` | Enum | `0` = Success, `1` = InvalidCost, `2` = InvalidPrice |

```
F.Global.CallWrapper.New("Test","Sales.CalculateMargin")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","UseWeightToCalculateExtendedPrice",True)
F.Global.CallWrapper.SetProperty("Test","OrderedQuantity",123.123)
F.Global.CallWrapper.SetProperty("Test","Weight",123.123)
F.Global.CallWrapper.SetProperty("Test","UnitOfMeasureCode","EA")
F.Global.CallWrapper.SetProperty("Test","DiscountedPrice",123.123)
F.Global.CallWrapper.SetProperty("Test","UnitCost",123.123)
F.Global.CallWrapper.SetProperty("Test","FreightPerPiece",123.123)
F.Global.CallWrapper.Run("Test")
V.Local.dMargin.Declare(Double)
V.Local.iStatus.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","Margin",V.Local.dMargin)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
```
---
## Sales.CalculateSalesOrderTotals
Returns a summation of the total values for a sales order. An optional line number may be passed to exclude from totals.

**Core Program:** `CLCSOTOT`

**Full Name:** `GSSEO.CallWrappers.Sales.CalculateSalesOrderTotals`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String (3) | Company code |
| `SalesOrderNumber` | Integer (7) | Sales order number |
| `UseWeightToCalculateExtendedPrice` | Boolean | Use weight to calculate extended price option |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ExcludedSalesOrderLineNumber` | Integer (4) | Line number to exclude from totals (useful when modifying a line and adding its total manually) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyGross` | Double (16.2) | Extended price of all lines except freight (company currency) |
| `CompanyFreight` | Double (16.2) | Total of all freight lines (company currency) |
| `CompanyTax` | Double (16.2) | Total tax for all lines (company currency) |
| `CompanyDiscount` | Double (16.2) | Total discount for all lines, negative value (company currency) |
| `CompanyNet` | Double (16.2) | Net value = gross + taxes + freight + discount (company currency) |
| `CustomerGross` | Double (16.2) | Extended price of all lines except freight (customer currency) |
| `CustomerFreight` | Double (16.2) | Total of all freight lines (customer currency) |
| `CustomerTax` | Double (16.2) | Total tax for all lines (customer currency) |
| `CustomerDiscount` | Double (16.2) | Total discount for all lines (customer currency) |
| `CustomerNet` | Double (16.2) | Net value (customer currency) |
| `ProfitPercentage` | Double (3.4) | Percent profit on the total sales order |
| `Status` | Enum | `0` = Successful, `1` = Failed |
| `CompanySlidingPriceClass` | Double (16.2) | Total for sliding price class discount (company, discounted lines only) |
| `CustomerSlidingPriceClass` | Double (16.2) | Total for sliding price class discount (customer, discounted lines only) |
| `Weight` | Double (12.3) | Total weight of all sales order lines |

```
F.Global.CallWrapper.New("Test","Sales.CalculateSalesOrderTotals")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","ExcludedSalesOrderLineNumber",1)
F.Global.CallWrapper.SetProperty("Test","UseWeightToCalculateExtendedPrice",True)
F.Global.CallWrapper.Run("Test")
V.Local.fCompanyGross.Declare(Float)
V.Local.fCompanyFreight.Declare(Float)
V.Local.fCompanyTax.Declare(Float)
V.Local.fCompanyDiscount.Declare(Float)
V.Local.fCompanyNet.Declare(Float)
V.Local.fCustomerGross.Declare(Float)
V.Local.fCustomerFreight.Declare(Float)
V.Local.fCustomerTax.Declare(Float)
V.Local.fCustomerDiscount.Declare(Float)
V.Local.fCustomerNet.Declare(Float)
V.Local.fProfitPercentage.Declare(Float)
V.Local.eStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","CompanyGross",V.Local.fCompanyGross)
F.Global.CallWrapper.GetProperty("Test","CompanyFreight",V.Local.fCompanyFreight)
F.Global.CallWrapper.GetProperty("Test","CompanyTax",V.Local.fCompanyTax)
F.Global.CallWrapper.GetProperty("Test","CompanyDiscount",V.Local.fCompanyDiscount)
F.Global.CallWrapper.GetProperty("Test","CompanyNet",V.Local.fCompanyNet)
F.Global.CallWrapper.GetProperty("Test","CustomerGross",V.Local.fCustomerGross)
F.Global.CallWrapper.GetProperty("Test","CustomerFreight",V.Local.fCustomerFreight)
F.Global.CallWrapper.GetProperty("Test","CustomerTax",V.Local.fCustomerTax)
F.Global.CallWrapper.GetProperty("Test","CustomerDiscount",V.Local.fCustomerDiscount)
F.Global.CallWrapper.GetProperty("Test","CustomerNet",V.Local.fCustomerNet)
F.Global.CallWrapper.GetProperty("Test","ProfitPercentage",V.Local.fProfitPercentage)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.eStatus)
```
---
## Sales.CheckForDuplicateSalesOrderNumber
Checks whether a sales order number already exists. Returns a status code indicating the type of duplicate found, if any.

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `SalesOrderNumber` | String | 7 | Sales order number to check |
| `CustomerNumber` | String | 6 | Customer number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | String (2) | Return code (see below) |
| `ShipmentSequence` | String (4) | Sequence number (when shipments exist) |

**Return Codes:**

| Code | Description |
|------|-------------|
| `00` | Successful (no duplicate) |
| `22` | Duplicate sales order number |
| `24` | Shipments exist for sales order number |
| `25` | Invoice exists for sales order number |
| `40` | Sales order number exists for same customer |
| `41` | Sales order number exists for different customer |

```
F.Global.CallWrapper.New("Test","Sales.CheckForDuplicateSalesOrderNumber")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber","1234567")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","123456")
F.Global.CallWrapper.Run("Test")
V.Local.sReturnCode.Declare(String)
V.Local.sShipSeq.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sReturnCode)
F.Global.CallWrapper.GetProperty("Test","ShipmentSequence",V.Local.sShipSeq)
```

---
## Sales.Configurator.GetQuoteConfiguration
Launches the part configurator screen for quotes and returns the configured part information once the user finishes.

**Core Program:** `GetQuoteConfiguration`

**Full Name:** `GSSEO.CallWrappers.Sales.Configurator.GetQuoteConfiguration`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `QuoteNumber` | Integer | 7 | Quote number |
| `QuoteLineNumber` | Integer | 4 | Quote line number |
| `IsCrossReferenceActive` | Boolean | 1 | Cross-reference active flag |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `PartNumber` | String | 20 | Part number |
| `PartDescription` | String | 30 | Part description |
| `CompanyUnitPrice` | Double | 13 (5 precision) | Unit price in company currency |
| `QuoteQuantity` | Double | 13 (4 precision) | Quote quantity |
| `ProductLineCode` | String | 3 | Product line code |
| `PartWeight` | Double | 10 (3 precision) | Part weight |
| `PriceClassCode` | String | 1 | Price class code |
| `LocationCode` | String | 2 | Location code |
| `CustomerNumber` | String | 6 | Customer number |

**Returned Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Status` | Enum | | `Successful` or `Failed` |
| `ConfiguredPartNumber` | String | 20 | Configured part number (use `PartNumber` if returned blank) |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `ProductLineCode` | String | 3 | Product line code |
| `PartWeight` | Double | 10 (3 precision) | Part weight |
| `PartDescription` | String | 30 | Part description |
| `MaterialCostTotal` | Double | 12 (4 precision) | Material cost total |
| `LaborCostTotal` | Double | 12 (4 precision) | Labor cost total |
| `CompanyUnitPrice` | Double | 13 (5 precision) | Unit price in company currency |

```
F.Global.CallWrapper.New("Test","Sales.Configurator.GetQuoteConfiguration")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","QuoteNumber",123)
F.Global.CallWrapper.SetProperty("Test","QuoteLineNumber",1)
F.Global.CallWrapper.SetProperty("Test","PartNumber","PART")
F.Global.CallWrapper.SetProperty("Test","PartDescription","Test Description")
F.Global.CallWrapper.SetProperty("Test","CompanyUnitPrice",123.123)
F.Global.CallWrapper.SetProperty("Test","IsCrossReferenceActive",True)
F.Global.CallWrapper.SetProperty("Test","QuoteQuantity",123.123)
F.Global.CallWrapper.SetProperty("Test","ProductLineCode","Test")
F.Global.CallWrapper.SetProperty("Test","PartWeight",123.123)
F.Global.CallWrapper.SetProperty("Test","PriceClassCode","Test")
F.Global.CallWrapper.SetProperty("Test","LocationCode","Test")
F.Global.CallWrapper.Run("Test")
V.Local.iStatus.Declare(Long)
V.Local.sConfiguredPartNumber.Declare(String)
V.Local.sLocationCode.Declare(String)
V.Local.sProductLineCode.Declare(String)
V.Local.dPartWeight.Declare(Double)
V.Local.sPartDescription.Declare(String)
V.Local.dCompanyUnitPrice.Declare(Double)
V.Local.dMaterialCostTotal.Declare(Double)
V.Local.dLaborCostTotal.Declare(Double)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
F.Global.CallWrapper.GetProperty("Test","ConfiguredPartNumber",V.Local.sConfiguredPartNumber)
F.Global.CallWrapper.GetProperty("Test","LocationCode",V.Local.sLocationCode)
F.Global.CallWrapper.GetProperty("Test","ProductLineCode",V.Local.sProductLineCode)
F.Global.CallWrapper.GetProperty("Test","PartWeight",V.Local.dPartWeight)
F.Global.CallWrapper.GetProperty("Test","PartDescription",V.Local.sPartDescription)
F.Global.CallWrapper.GetProperty("Test","CompanyUnitPrice",V.Local.dCompanyUnitPrice)
F.Global.CallWrapper.GetProperty("Test","MaterialCostTotal",V.Local.dMaterialCostTotal)
F.Global.CallWrapper.GetProperty("Test","LaborCostTotal",V.Local.dLaborCostTotal)
```
---
## Sales.Configurator.GetSalesOrderConfiguration
Launches the part configurator screen for sales orders and returns the configured part information once the user finishes.

**Core Program:** `GetSalesOrderConfiguration`

**Full Name:** `GSSEO.CallWrappers.Sales.Configurator.GetSalesOrderConfiguration`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `SalesOrderNumber` | Integer | 7 | Sales order number |
| `SalesOrderLineNumber` | Integer | 4 | Sales order line number |
| `IsCrossReferenceActive` | Boolean | 1 | Cross-reference active flag |

**Optional Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `PartNumber` | String | 20 | Part number |
| `PartDescription` | String | 30 | Part description |
| `CompanyUnitPrice` | Double | 13 (5 precision) | Unit price in company currency |
| `OrderQuantity` | Double | 13 (4 precision) | Order quantity |
| `ProductLineCode` | String | 3 | Product line code |
| `PartWeight` | Double | 10 (3 precision) | Part weight |
| `PriceClassCode` | String | 1 | Price class code |
| `LocationCode` | String | 2 | Location code |
| `CustomerNumber` | String | 6 | Customer number |

**Returned Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Status` | Enum | | `Successful` or `Failed` |
| `ConfiguredPartNumber` | String | 20 | Configured part number (use `PartNumber` if returned blank) |
| `PartNumber` | String | 20 | Part number |
| `LocationCode` | String | 2 | Location code |
| `ProductLineCode` | String | 3 | Product line code |
| `PartWeight` | Double | 10 (3 precision) | Part weight |
| `PartDescription` | String | 30 | Part description |
| `MaterialCostTotal` | Double | 12 (4 precision) | Material cost total |
| `LaborCostTotal` | Double | 12 (4 precision) | Labor cost total |
| `CompanyUnitPrice` | Double | 13 (5 precision) | Unit price in company currency |

```
F.Global.CallWrapper.New("Test","Sales.Configurator.GetSalesOrderConfiguration")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","TST")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",123)
F.Global.CallWrapper.SetProperty("Test","SalesOrderLineNumber",1)
F.Global.CallWrapper.SetProperty("Test","PartNumber","PART")
F.Global.CallWrapper.SetProperty("Test","PartDescription","Test Description")
F.Global.CallWrapper.SetProperty("Test","CompanyUnitPrice",123.123)
F.Global.CallWrapper.SetProperty("Test","IsCrossReferenceActive",True)
F.Global.CallWrapper.SetProperty("Test","OrderQuantity",123.123)
F.Global.CallWrapper.SetProperty("Test","ProductLineCode","Test")
F.Global.CallWrapper.SetProperty("Test","PartWeight",123.123)
F.Global.CallWrapper.SetProperty("Test","PriceClassCode","Test")
F.Global.CallWrapper.SetProperty("Test","LocationCode","Test")
F.Global.CallWrapper.Run("Test")
V.Local.iStatus.Declare(Long)
V.Local.sConfiguredPartNumber.Declare(String)
V.Local.sLocationCode.Declare(String)
V.Local.sProductLineCode.Declare(String)
V.Local.dPartWeight.Declare(Double)
V.Local.sPartDescription.Declare(String)
V.Local.dCompanyUnitPrice.Declare(Double)
V.Local.dMaterialCostTotal.Declare(Double)
V.Local.dLaborCostTotal.Declare(Double)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
F.Global.CallWrapper.GetProperty("Test","ConfiguredPartNumber",V.Local.sConfiguredPartNumber)
F.Global.CallWrapper.GetProperty("Test","LocationCode",V.Local.sLocationCode)
F.Global.CallWrapper.GetProperty("Test","ProductLineCode",V.Local.sProductLineCode)
F.Global.CallWrapper.GetProperty("Test","PartWeight",V.Local.dPartWeight)
F.Global.CallWrapper.GetProperty("Test","PartDescription",V.Local.sPartDescription)
F.Global.CallWrapper.GetProperty("Test","CompanyUnitPrice",V.Local.dCompanyUnitPrice)
F.Global.CallWrapper.GetProperty("Test","MaterialCostTotal",V.Local.dMaterialCostTotal)
F.Global.CallWrapper.GetProperty("Test","LaborCostTotal",V.Local.dLaborCostTotal)
```
---
## Sales.DeleteSalesOrder
Delete a sales order or a specific sales order line.

**Core Program:** `ORD805`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `SalesOrderNumber` | String | 7 | Sales order number (enter with no leading zeros, e.g. `225` instead of `0000225`) |
| `SalesOrderLineNumber` | String | 4 | Sales order line number (enter with no leading zeros, e.g. `1` instead of `0001`) |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Successful` | Completed successfully |
| `Shipments` | Shipments exist |
| `Failed` | General failure |
| `ShipmentComponents` | Shipment components exist |
| `OrderMissing` | Order not found |
| `MissingProgram` | Required program not found |
| `FileError` | File error |
| `ReportError` | Report error |
| `StagedShipments` | Staged shipments exist |
| `Unknown` | Unknown error |

```
F.Global.CallWrapper.New("Test","Sales.DeleteSalesOrder")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber","225")
F.Global.CallWrapper.SetProperty("Test","SalesOrderLineNumber","1")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.EditOrderComments
Edit comments for a sales order. Optional header parameters populate the title bar.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | Long | 7 | Order number |

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
F.Global.CallWrapper.New("Test","Sales.EditOrderComments")
F.Global.CallWrapper.SetProperty("Test","OrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","CustomerName","ACME Corp")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.EditOrderLineComments
Edit comments for a specific sales order line. Optional header parameters populate the title bar.

**Core Program:** `SYS080`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `OrderNumber` | Long | 7 | Order number |
| `OrderLine` | String | 4 | Order line |

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
F.Global.CallWrapper.New("Test","Sales.EditOrderLineComments")
F.Global.CallWrapper.SetProperty("Test","OrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","OrderLine","0001")
F.Global.CallWrapper.SetProperty("Test","Part","COMPUTER BOX")
F.Global.CallWrapper.SetProperty("Test","Description","Standard computer enclosure")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.EditSalesOrderInClassicScreen
Open a sales order for editing in the classic screen.

**Core Program:** `ORD200`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `SalesOrder` | Long | 8 | Sales order number |

**Returned Properties:** None

```
F.Global.CallWrapper.New("Test","Sales.EditSalesOrderInClassicScreen")
F.Global.CallWrapper.SetProperty("Test","Company","TST")
F.Global.CallWrapper.SetProperty("Test","SalesOrder",1234567)
F.Global.CallWrapper.Run("Test")
```
---
## Sales.EditTaxAuthorities
Displays the tax authority editing screen for the passed entity, allowing the user to manually modify tax assignments.

**Core Program:** `ProcessTax`

**Full Name:** `GSSEO.CallWrappers.Sales.EditTaxAuthorities`

> **Version Requirements:** Minimum `2020.1`. Make sure to override the `GLOBALVERSION` environment variable with `2020.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `Mode` | Integer | No | Hard-coded to `1` for this callwrapper |
| `SourceDataType` | Enum (Integer) | Yes | Data source used to apply specific rules within the tax module. See **SourceDataType** enum below. |
| `Username` | String | No | Current user ID. Defaulted from the current process if not provided. |
| `TaxState` | String | Yes | Tax state |
| `TaxZipCode` | String | Yes | Tax zip code |
| `TaxImport` | Enum (Integer) | Yes | See **TaxImport** enum below. |
| `TaxAuthorities` | List Of AppliedTaxAuthority | Yes | Splits into `TaxAuthorityZones` (Strings), `TaxAuthorityCodes` (Strings), and `ApplyTaxes` (Booleans) |
| `UsedAuthorityIndex` | Boolean | Yes | Flag for if taxes are assigned from index |
| `ShippingState` | String | Yes | Ship-to state |
| `ShippingZipCode` | String | Yes | Ship-to zip code |
| `VatExemptType` | Enum (Integer) | Conditional | Required for all data sources except Origin Location. See **VatExemptType** enum below. |
| `VatRuleID` | Integer | Conditional | Required for all data sources except Origin Location. VAT rule ID. |
| `CustomerNumber` | String | Conditional | Required for all data sources except Origin Location |
| `TaxSource` | Enum (Integer) | Conditional | Required for all data sources except Origin Location. See **TaxSource** enum below. |
| `CustomerShipToNumber` | String | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location |
| `SalesOrderNumber` | Integer | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location |
| `OrderType` | Enum (Integer) | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location. See **OrderType** enum below. |
| `OriginAddressTaxCode` | Integer | Conditional | Required for all data sources except Prospect, Customer, Customer Ship To, and Origin Location |
| `SalesExemptNumber` | String | Conditional | Only required for Prospect, Customer, and Customer Ship To data sources |

**SourceDataType Enum:**

| Value | Name |
|-------|------|
| `1` | Order |
| `5` | InvoiceBatch |

**TaxImport Enum:**

| Value | Name |
|-------|------|
| `0` | None |
| `1` | Used |
| `2` | NotUsed |

**VatExemptType Enum:**

| Value | Name |
|-------|------|
| `0` | None |
| `1` | Import |
| `2` | Export |
| `3` | Product |
| `4` | Company |

**TaxSource Enum:**

| Value | Name | Notes |
|-------|------|-------|
| `0` | None | |
| `1` | Manual | |
| `2` | ShipTo | |
| `3` | Order | |
| `4` | Origin | Current value (replaces legacy `Location` which also used `4`) |

> **Note:** Value `4` was previously `Location` in older modules. It has been replaced by `Origin`. Both names resolve to the same numeric code. Use `Origin` for new code.

**OrderType Enum:**

| Value | Name |
|-------|------|
| `0` | Regular |
| `1` | CycleBilling |
| `2` | DetailBilling |
| `3` | Repair |
| `4` | InvoiceOnly |
| `5` | Blanket |
| `6` | Transfer |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnTaxSource` | Enum (Integer) | Tax source (same enum as `TaxSource` above) |
| `ReturnTaxState` | String | Tax state |
| `ReturnTaxZipCode` | String | Tax zip code |
| `ReturnTaxAuthorities` | List Of AppliedTaxAuthority | Combined from `ReturnTaxAuthorityZones` (Strings), `ReturnTaxAuthorityCodes` (Strings), and `ReturnApplyTaxes` (Booleans) |
| `ReturnTaxImport` | Enum (Integer) | Tax import (same enum as `TaxImport` above) |
| `ReturnUsedAuthorityIndex` | Boolean | Flag for if taxes were assigned from the index |
| `ReturnOriginAddressTaxCode` | Integer | Origin address tax code |
| `ReturnSalesExemptNumber` | String | Only for Prospect, Customer, and Customer Ship To data sources |
| `ReturnAuthorityCount` | Integer | Number of tax authorities |
| `ReturnAuthoritySalesCount` | Integer | Number of sales tax authorities |
| `ReturnAuthorityVatCount` | Integer | Number of VAT tax authorities |
| `ReturnIsChanged` | Boolean | `True` if tax values were updated by the module |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Successful | Operation completed successfully |
| `1` | InvalidParameter | A required parameter was missing or invalid |
| `2` | Failed | The operation failed |
| `3` | Cancel | The user cancelled the tax authority edit |

```
F.Global.CallWrapper.New("Test","Sales.EditTaxAuthorities")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","Mode","1")
F.Global.CallWrapper.SetProperty("Test","SourceDataType","1")
F.Global.CallWrapper.SetProperty("Test","Username","Username")
F.Global.CallWrapper.SetProperty("Test","TaxState","TaxState")
F.Global.CallWrapper.SetProperty("Test","TaxZipCode","TaxZipCode")
F.Global.CallWrapper.SetProperty("Test","TaxImport",0)
F.Global.CallWrapper.SetProperty("Test","UsedAuthorityIndex",True)
F.Global.CallWrapper.SetProperty("Test","ShippingState","ShippingState")
F.Global.CallWrapper.SetProperty("Test","ShippingZipCode","ShippingZipCode")
F.Global.CallWrapper.SetProperty("Test","VatRuleID",0)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","CustomerNumber")
F.Global.CallWrapper.SetProperty("Test","TaxSource",0)
F.Global.CallWrapper.SetProperty("Test","CustomerShipToNumber","CustomerShipToNumber")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",5)
F.Global.CallWrapper.SetProperty("Test","OrderType",0)
F.Global.CallWrapper.SetProperty("Test","OriginAddressTaxCode",0)
F.Global.CallWrapper.SetProperty("Test","SalesExemptNumber","SalesExemptNumber")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sTaxSource.Declare(String)
V.Local.sTaxState.Declare(String)
V.Local.sTaxZip.Declare(String)
V.Local.sTaxAuth.Declare(String)
V.Local.sTaxImport.Declare(String)
V.Local.bUsedIdx.Declare(String)
V.Local.iOriginCode.Declare(String)
V.Local.sExempt.Declare(String)
V.Local.iAuthCount.Declare(String)
V.Local.iSalesCount.Declare(String)
V.Local.iVatCount.Declare(String)
V.Local.bChanged.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxSource",V.Local.sTaxSource)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxState",V.Local.sTaxState)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxZipCode",V.Local.sTaxZip)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxAuthorities",V.Local.sTaxAuth)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxImport",V.Local.sTaxImport)
F.Global.CallWrapper.GetProperty("Test","ReturnUsedAuthorityIndex",V.Local.bUsedIdx)
F.Global.CallWrapper.GetProperty("Test","ReturnOriginAddressTaxCode",V.Local.iOriginCode)
F.Global.CallWrapper.GetProperty("Test","ReturnSalesExemptNumber",V.Local.sExempt)
F.Global.CallWrapper.GetProperty("Test","ReturnAuthorityCount",V.Local.iAuthCount)
F.Global.CallWrapper.GetProperty("Test","ReturnAuthoritySalesCount",V.Local.iSalesCount)
F.Global.CallWrapper.GetProperty("Test","ReturnAuthorityVatCount",V.Local.iVatCount)
F.Global.CallWrapper.GetProperty("Test","ReturnIsChanged",V.Local.bChanged)
```
---
## Sales.GetBuyingGroupBalance
Receives the buying group customer number and returns the credit limit and outstanding balances as well as credit and shipping hold information.

**Core Program:** `ORD878`

**Full Name:** `GSSEO.CallWrappers.Sales.GetBuyingGroupBalance`

**Version Requirements:** Minimum `2020.1`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code |
| `BuyingGroupCustomerNumber` | String | Buying group customer number applied to this order |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Status` | Enum | `0` = Success, `1` = InvalidParameter, `2` = CustomerNotFound |
| `CreditLimitTotal` | Double | Credit limit value from the credit limit code on the buying group customer |
| `OpenItemBalanceTotal` | Double | Open item balance for the buying group customer |
| `OpenOrderBalanceTotal` | Double | Open order balance for the buying group customer |
| `OutstandingBalanceTotal` | Double | Total of open item balance and open order balance |
| `OnCreditHold` | Boolean | `True` if the buying group customer is in credit hold |
| `ShippingHoldAllorders` | Boolean | `True` if the buying group customer is on shipping hold |
| `ShippingHoldSetManually` | Boolean | `True` if the buying group customer allows shipping hold modification at order level by an approved user |

```
F.Global.CallWrapper.New("Test","Sales.GetBuyingGroupBalance")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","BuyingGroupCustomerNumber","001000")
F.Global.CallWrapper.Run("Test")
V.Local.iStatus.Declare(Long)
V.Local.dCreditLimitTotal.Declare(Double)
V.Local.dOpenItemBalanceTotal.Declare(Double)
V.Local.dOpenOrderBalanceTotal.Declare(Double)
V.Local.dOutstandingBalanceTotal.Declare(Double)
V.Local.bOnCreditHold.Declare(Boolean)
V.Local.bShippingHoldAllOrders.Declare(Boolean)
V.Local.bShippingHoldSetManually.Declare(Boolean)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
F.Global.CallWrapper.GetProperty("Test","CreditLimitTotal",V.Local.dCreditLimitTotal)
F.Global.CallWrapper.GetProperty("Test","OpenItemBalanceTotal",V.Local.dOpenItemBalanceTotal)
F.Global.CallWrapper.GetProperty("Test","OpenOrderBalanceTotal",V.Local.dOpenOrderBalanceTotal)
F.Global.CallWrapper.GetProperty("Test","OutstandingBalanceTotal",V.Local.dOutstandingBalanceTotal)
F.Global.CallWrapper.GetProperty("Test","OnCreditHold",V.Local.bOnCreditHold)
F.Global.CallWrapper.GetProperty("Test","ShippingHoldAllOrders",V.Local.bShippingHoldAllOrders)
F.Global.CallWrapper.GetProperty("Test","ShippingHoldSetManually",V.Local.bShippingHoldSetManually)
```
---
## Sales.GetCarrierAccount
Returns the default carrier account number for a shipment. The account is resolved in this order: (1) the passed third-party freight customer number, (2) the passed customer number, (3) if the carrier record is marked for third-party pay, the third-party freight customer on the customer master record (if populated).

**Core Program:** `ORD864`

**Full Name:** `GSSEO.CallWrappers.Sales.GetCarrierAccount`

> **Version Requirements:** Minimum `2019.2`. Make sure to override the `GLOBALVERSION` environment variable with `2019.2` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `CarrierNumber` | String | Yes | Carrier code used for shipping the product to the customer |
| `CustomerNumber` | String | Yes | Customer ordering the products |
| `CustomerShipToNumber` | String | No | Ship-to ID. Blanks = default customer address. Non-blank = the address on the matching customer ship-to record. |
| `ServiceTypeNumber` | Integer | No | Three-digit number representing the carrier service type (e.g., Overnight, Ground). GSS assigns a numeric equivalent. |
| `ThirdPartyFreightCustomerNumber` | String | No | Customer number of the third-party customer paying for freight |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ARShipViaDescription` | String | Ship-via description (returned if the carrier record contains a ship-via code) |
| `CarrierAccountNumber` | String | Default carrier account number given the information passed |
| `CarrierAccountNumberStatus` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Information received successfully, or no error encountered |
| `23` | CarrierAccountNotFound | The carrier account record was not found |
| `40` | CarrierAccountDataError | File error for the carrier account record |
| `90` | Failed | Company code, carrier number, or customer number was not passed |
| Other | Failed | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.GetCarrierAccount")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","CarrierNumber","UPS")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","CustomerShipToNumber","000001")
F.Global.CallWrapper.SetProperty("Test","ServiceTypeNumber",111)
F.Global.CallWrapper.SetProperty("Test","ThirdPartyFreightCustomerNumber","")
F.Global.CallWrapper.Run("Test")
V.Local.sShipVia.Declare(String)
V.Local.sAcctNum.Declare(String)
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","ARShipViaDescription",V.Local.sShipVia)
F.Global.CallWrapper.GetProperty("Test","CarrierAccountNumber",V.Local.sAcctNum)
F.Global.CallWrapper.GetProperty("Test","CarrierAccountNumberStatus",V.Local.sStatus)
```
---
## Sales.GetDefaultSalesOrderLineUserValues
Return the default user field value for a sales order line. Called for each line user field (1-5). Searches for a match on customer number + customer ship-to (or `*ALL` for all ship-to IDs), part number, and location. If no match, falls back to a default where customer/ship-to/part/location are all spaces.

**Core Program:** `ORD829`

**Full Name:** `GSSEO.CallWrappers.Sales.GetDefaultSalesOrderLineUserValues`

> **Version Requirements:** Minimum `2019.2`. Make sure to override the `GLOBALVERSION` environment variable with `2019.2` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `SalesUserFieldIndex` | Integer | Yes | User field index (`1`-`5`). The sales order line contains five user fields; this specifies which one to default. |
| `CustomerNumber` | String | No | Customer number for the sales order line |
| `CustomerShipToNumber` | String | No | Customer ship-to number. Spaces = default customer address. `*ALL` = all ship-to IDs for the customer. |
| `PartNumber` | String | No | Part number for the sales order line |
| `PartNumberRevision` | String | No | Part number revision (if *Use Revision Level* is enabled) |
| `LocationCode` | String | No | Location for the part number. Spaces are valid. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `UserField` | String | Default value for this user line field |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `1` | NotFound | A default user value was not found |
| `35` | ParameterError | The parameters were not valid |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.GetDefaultSalesOrderLineUserValues")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","SalesUserFieldIndex",1)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","000006")
F.Global.CallWrapper.SetProperty("Test","CustomerShipToNumber","01")
F.Global.CallWrapper.SetProperty("Test","PartNumber","0025")
F.Global.CallWrapper.SetProperty("Test","PartNumberRevision","")
F.Global.CallWrapper.SetProperty("Test","LocationCode","")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sUser.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","UserField",V.Local.sUser)
```
---
## Sales.GetDefaultSalesOrderUserValues
Returns the default user field value for a sales order header. Called for each user field (1-5). Searches for a match on customer number + customer ship-to (or `*ALL` for all ship-to IDs). If no match, falls back to a default where customer and customer ship-to are both spaces. User values are not required, so returns may be null or spaces.

**Core Program:** `ORD829`

**Full Name:** `GSSEO.CallWrappers.Sales.GetDefaultSalesOrderUserValues`

> **Version Requirements:** Minimum `2019.2`. Make sure to override the `GLOBALVERSION` environment variable with `2019.2` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `SalesUserFieldIndex` | Integer | Yes | User field index (`1`-`5`). The sales order contains five user fields; this specifies which one to default. |
| `CustomerNumber` | String | No | Customer number for the sales order |
| `CustomerShipToNumber` | String | No | Customer ship-to number. Spaces = default customer address. `*ALL` = all ship-to IDs for the customer. |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `UserField` | String | Default value for this user field |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | Successful |
| `1` | NotFound | A default user value was not found |
| `35` | ParameterError | The parameters were not valid |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.GetDefaultSalesOrderUserValues")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","SalesUserFieldIndex",1)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","000006")
F.Global.CallWrapper.SetProperty("Test","CustomerShipToNumber","01")
F.Global.CallWrapper.Run("Test")
V.Local.sUser.Declare(String)
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","UserField",V.Local.sUser)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.GetNextSalesOrderNumber
Get the next available sales order number for a customer.

**Core Program:** `ORD827`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `Company` | String | 3 | Company code |
| `CustomerNumber` | String | 6 | Customer number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `SalesOrderNumber` | String (7) | Next available sales order number |
| `Status` | String (2) | Return code (see table below) |

**Returned Status:**

| Code | Description |
|------|-------------|
| `00` | Successful |
| `37` | RangeNotFound |

```
F.Global.CallWrapper.New("Test","Sales.GetNextSalesOrderNumber")
F.Global.CallWrapper.SetProperty("Test","Company","10T")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sSalesOrderNumber.Declare(String)
F.Global.CallWrapper.GetProperty("Test","SalesOrderNumber",V.Local.sSalesOrderNumber)
```
---
## Sales.GetNextSalesOrderNumberByDate
Get the next available sales order number by date for a customer.

**Core Program:** `ORD827`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Company code |
| `CustomerNumber` | String | 6 | Customer number |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `SalesOrderNumber` | String (7) | Sales order number |
| `Status` | String (2) | Return code (see table below) |

**Returned Status:**

| Code | Description |
|------|-------------|
| `00` | Successful |
| `23` | OrderSequenceExceeded |

```
F.Global.CallWrapper.New("Test","Sales.GetNextSalesOrderNumberByDate")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
V.Local.sSalesOrderNumber.Declare(String)
F.Global.CallWrapper.GetProperty("Test","SalesOrderNumber",V.Local.sSalesOrderNumber)
```
---
## Sales.GetSalesOrderExchangeRates
Populates the four exchange rates and dates carried in the SalesOrder object.

**Core Program:** `ORD833`

**Full Name:** `GSSEO.CallWrappers.Sales.GetSalesOrderExchangeRates`

> **Version Requirements:** Minimum `2019.2`. Make sure to override the `GLOBALVERSION` environment variable with `2019.2` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `CompanyIsoCurrencyCode` | String | Yes | Company currency code. If the company is single currency, this value populates the catalog and customer currency on the sales order. |
| `CatalogIsoCurrencyCode` | String | Yes | Catalog currency code (populated on the SalesOrder from the customer) |
| `CustomerIsoCurrencyCode` | String | Yes | Customer currency code (populated on the SalesOrder from the customer) |
| `OrderDate` | DateTime | Yes | Order date (COBOL `ccyymmdd` format; VB `#MM/DD/YYYY#` format) |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyFromCustomerDate` | DateTime | Exchange date from Customer to Company (COBOL `ccyymmdd` / VB `#MM/DD/YYYY#`) |
| `CompanyFromCustomerRate` | Double | Exchange rate from Customer to Company |
| `CustomerFromCompanyDate` | DateTime | Exchange date from Company to Customer (COBOL `ccyymmdd` / VB `#MM/DD/YYYY#`) |
| `CustomerFromCompanyRate` | Double | Exchange rate from Company to Customer |
| `CustomerFromCatalogDate` | DateTime | Exchange date from Catalog to Customer (COBOL `ccyymmdd` / VB `#MM/DD/YYYY#`) |
| `CustomerFromCatalogRate` | Double | Exchange rate from Catalog to Customer |
| `CompanyFromCatalogDate` | DateTime | Exchange date from Catalog to Company (COBOL `ccyymmdd` / VB `#MM/DD/YYYY#`) |
| `CompanyFromCatalogRate` | Double | Exchange rate from Catalog to Company |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | The exchange rates were successfully retrieved |
| `1` | InvalidCurrency | Company, catalog, or customer currency was not passed |
| `2` | InvalidDate | Order date was not passed |
| `23` | NotFound | No exchange rate was found |
| Other | NotFound | No exchange rate was found |

```
F.Global.CallWrapper.New("Test","Sales.GetSalesOrderExchangeRates")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","CompanyIsoCurrencyCode","CAD")
F.Global.CallWrapper.SetProperty("Test","CatalogIsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("Test","CustomerIsoCurrencyCode","USD")
F.Global.CallWrapper.SetProperty("Test","OrderDate","06/11/2019")
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.sCoFromCustDate.Declare(String)
V.Local.fCoFromCustRate.Declare(String)
V.Local.sCustFromCoDate.Declare(String)
V.Local.fCustFromCoRate.Declare(String)
V.Local.sCustFromCatDate.Declare(String)
V.Local.fCustFromCatRate.Declare(String)
V.Local.sCoFromCatDate.Declare(String)
V.Local.fCoFromCatRate.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","CompanyFromCustomerDate",V.Local.sCoFromCustDate)
F.Global.CallWrapper.GetProperty("Test","CompanyFromCustomerRate",V.Local.fCoFromCustRate)
F.Global.CallWrapper.GetProperty("Test","CustomerFromCompanyDate",V.Local.sCustFromCoDate)
F.Global.CallWrapper.GetProperty("Test","CustomerFromCompanyRate",V.Local.fCustFromCoRate)
F.Global.CallWrapper.GetProperty("Test","CustomerFromCatalogDate",V.Local.sCustFromCatDate)
F.Global.CallWrapper.GetProperty("Test","CustomerFromCatalogRate",V.Local.fCustFromCatRate)
F.Global.CallWrapper.GetProperty("Test","CompanyFromCatalogDate",V.Local.sCoFromCatDate)
F.Global.CallWrapper.GetProperty("Test","CompanyFromCatalogRate",V.Local.fCoFromCatRate)
```
---
## Sales.GetSalesOrderText
Writes the customer text to the SalesOrderComment object.

**Core Program:** `GetSalesOrderText`

**Full Name:** `GSSEO.CallWrappers.Sales.GetSalesOrderText`

**Version Requirements:** Minimum `2019.2`

**Required Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CompanyCode` | String | Company code |
| `SalesOrderNumber` | Integer | Sales order number |
| `CustomerNumber` | String | Customer number from the sales order |

**Optional Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `CallingProgram` | String | Program that called this module |

**Returned Status:**

| Code | Description |
|------|-------------|
| `0` | Success |
| `1` | NoComments |
| `2` | FileError |

```
F.Global.CallWrapper.New("Test","Sales.GetSalesOrderText")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","GABSCRIPT")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",1234567)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.Run("Test")
V.Local.iStatus.Declare(Long)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.iStatus)
```
---
## Sales.GetSlidingPriceClassDiscount
Returns the sliding price class discount for a sales order. The discount is determined based on the gross value of the sales order.

**Core Program:** `ORD823`

**Full Name:** `GSSEO.CallWrappers.Sales.GetSlidingPriceClassDiscount`

> **Version Requirements:** Minimum `2019.2`. Make sure to override the `GLOBALVERSION` environment variable with `2019.2` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `CallingProgram` | String | No | Calling program name (for logging/auditing) |
| `CustomerNumber` | String | No | Customer number for the sales order |
| `PriceClassCode` | String | Yes | Price class code for the sales order |
| `SalesOrderNumber` | Integer | Yes | Sales order number applicable to the price class discount |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `Rate` | Double | Sliding price class discount returned as a decimal value |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Success | The sliding price class discount was successfully retrieved |
| `23` | NotFound | Options were not successfully loaded |
| `25` | ParameterError | The parameters were not valid |
| Other | ParameterError | Other general failure has occurred |

```
F.Global.CallWrapper.New("Test","Sales.GetSlidingPriceClassDiscount")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","PLA")
F.Global.CallWrapper.SetProperty("Test","CallingProgram","Callwrap")
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","001000")
F.Global.CallWrapper.SetProperty("Test","PriceClassCode","F")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber",231)
F.Global.CallWrapper.Run("Test")
V.Local.fRate.Declare(String)
V.Local.sStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Rate",V.Local.fRate)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
```
---
## Sales.GetTaxableStatus
Determines whether the sales tax on a line is taxable using the ProcessTax module. If the line is a freight line with multiple tax zones, the tax apply flags may be updated to enforce taxability across the zones. Uses `SysParameterList` instead of linkage.

**Core Program:** `ProcessTax`

**Full Name:** `GSSEO.CallWrappers.Sales.GetTaxableStatus`

> **Version Requirements:** Minimum `2020.1`. Make sure to override the `GLOBALVERSION` environment variable with `2020.1` if not on that version, otherwise version validation will fail.

**Passed Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `CompanyCode` | String | Yes | Company code the callwrapper executes in |
| `Mode` | Integer | No | Hard-coded to `14` for this callwrapper |
| `SourceDataType` | Enum (Integer) | Yes | Data source for tax rules. See **SourceDataType** enum below. |
| `TaxState` | String | Yes | Tax state |
| `TaxAuthorities` | List Of AppliedTaxAuthority | Yes | Splits into `TaxAuthorityZones` (Strings), `TaxAuthorityCodes` (Strings), and `ApplyTaxes` (Booleans) |
| `VatRuleID` | Integer | Yes | VAT rule ID |
| `CustomerNumber` | String | Yes | Customer number |
| `CustomerShipToNumber` | String | Yes | Customer ship-to number |
| `OrderType` | Enum (Integer) | No | Sales order type. See **OrderType** enum below. |
| `PartNumber` | String | Yes | Part number on the line |
| `PartNumberRevision` | String | Yes | Part number revision on the line |
| `PartLocationCode` | String | Yes | Part location on the line |
| `IsFreightLine` | Boolean | Yes | Flag to denote if the line type is freight |
| `LineType` | Enum (Integer) | Yes | Sales order line type. See **LineType** enum below. |
| `ShipmentSequence` | Integer | Conditional | Required for Shipment, Open Invoice, Invoice Batch, and Credit Memo data sources |
| `InvoiceNumber` | String | Conditional | Required for Credit Memo data source |

**SourceDataType Enum:**

| Value | Name |
|-------|------|
| `1` | Order |
| `3` | Shipment |
| `4` | OpenInvoice |
| `5` | InvoiceBatch |

**OrderType Enum:**

| Value | Name |
|-------|------|
| `0` | Regular |
| `1` | CycleBilling |
| `2` | DetailBilling |
| `3` | Repair |
| `4` | InvoiceOnly |
| `5` | Blanket |
| `6` | Transfer |

**LineType Enum:**

| Value | Name |
|-------|------|
| `0` | Standard |
| `1` | Buyout |
| `2` | Consignment |
| `3` | DropShip |
| `4` | Freight |
| `5` | ProgressBill |

**Returned Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `ReturnIsTaxable` | Boolean | Taxable status |
| `ReturnTaxAuthorities` | List Of AppliedTaxAuthority | Only returned if required for a freight line with multiple tax zones |
| `Status` | Enum (Integer) | See table below |

**Returned Status:**

| Value | Name | Description |
|-------|------|-------------|
| `0` | Successful | Operation completed successfully |
| `1` | InvalidParameter | A required parameter was missing or invalid |
| `2` | Failed | The operation failed |
| `3` | Cancel | The operation was cancelled |

```
F.Global.CallWrapper.New("Test","Sales.GetTaxableStatus")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","10T")
F.Global.CallWrapper.SetProperty("Test","Mode","14")
F.Global.CallWrapper.SetProperty("Test","SourceDataType","1")
F.Global.CallWrapper.SetProperty("Test","TaxState","TX")
F.Global.CallWrapper.SetProperty("Test","VatRuleID",0)
F.Global.CallWrapper.SetProperty("Test","CustomerNumber","000006")
F.Global.CallWrapper.SetProperty("Test","CustomerShipToNumber","01")
F.Global.CallWrapper.SetProperty("Test","OrderType",0)
F.Global.CallWrapper.SetProperty("Test","PartNumber","0025")
F.Global.CallWrapper.SetProperty("Test","PartNumberRevision","")
F.Global.CallWrapper.SetProperty("Test","PartLocationCode","")
F.Global.CallWrapper.SetProperty("Test","IsFreightLine",False)
F.Global.CallWrapper.SetProperty("Test","LineType",0)
F.Global.CallWrapper.Run("Test")
V.Local.sStatus.Declare(String)
V.Local.bTaxable.Declare(String)
V.Local.sTaxAuth.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.sStatus)
F.Global.CallWrapper.GetProperty("Test","ReturnIsTaxable",V.Local.bTaxable)
F.Global.CallWrapper.GetProperty("Test","ReturnTaxAuthorities",V.Local.sTaxAuth)
```
---
## Sales.IntercompanySalesOrderEvent
Initiate the intercompany new sales order event for the passed sales order number.

**Core Program:** `ICE800`

**Required Properties:**

| Property | Type | Size | Description |
|----------|------|------|-------------|
| `CompanyCode` | String | 3 | Origin company code |
| `SalesOrderNumber` | String | 7 | Sales order number |

**Returned Status:**

| Status | Description |
|--------|-------------|
| `Success` | Completed successfully |
| `InvalidParameter` | Invalid parameter |
| `Failed` | General failure |
| `Cancel` | Cancelled |

```
F.Global.CallWrapper.New("Test","Sales.IntercompanySalesOrderEvent")
F.Global.CallWrapper.SetProperty("Test","CompanyCode","ABC")
F.Global.CallWrapper.SetProperty("Test","SalesOrderNumber","1234567")
F.Global.CallWrapper.Run("Test")
V.Local.tStatus.Declare(String)
F.Global.CallWrapper.GetProperty("Test","Status",V.Local.tStatus)
F.Intrinsic.UI.Msgbox(V.Local.tStatus,"Return Status")
```
---
