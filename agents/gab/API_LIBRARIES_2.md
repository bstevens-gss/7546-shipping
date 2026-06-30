# GAB Standard Libraries Reference (Part 2 of 5)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with standard .lib includes (Part 2: lines 3375-5000)
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

## 6002.lib -- Upload Quote/Quote Lines

**Wraps:** CallWrapper `6002` — Upload New Quote / Quote Lines

> **Important:** This library generates a **fixed-position flat file** (`QUOTE.txt`) from four DataTables and calls the callwrapper **once** for the entire file — not per row. All fields are automatically padded (`RPad`/`LPad`) to their required widths. There are four DataTables representing different record types:
> - `6002A` — Record Type A (Quote Header)
> - `6002B` — Record Type B (Bill-To Address)
> - `6002C` — Record Type C (Ship-To Address)
> - `6002L` — Record Type L (Line Items, 001–999)
>
> Customer/Prospect numbers must be valid IDs in the customer or prospect master. Filler fields and padding are handled automatically. Only A and L records are required for a basic quote upload; B and C records are optional.

> **Reference:** [Upload file layout](http://www.gss-updates.com/site/GShelp/2016/000/INDEX.asp?addl_ref_data_conv_quote_master.asp)

**Include:**

```
Program.External.Include.Library("6002.lib",False)
```

**DataTable `6002A` Schema — Record Type A (Quote Header):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `QuoteNo` | String | | 7 | LPad `0` | **Required.** Quote Number |
| `Filler1` | String | 3 spaces | 3 | — | Auto-managed filler |
| `RecordType` | String | `"A"` | 1 | — | **Required.** Always `"A"` |
| `CustProspNum` | String | | 6 | RPad space | **Required.** Customer/Prospect Number (must exist in master) |
| `ShipToID` | String | 6 spaces | 6 | RPad space | **Required.** Ship-To ID (blank = default ship-to address) |
| `QuoteDate` | String | 6 spaces | 6 | RPad space | Quote Date (`MMDDYY`) |
| `DueDate` | String | 6 spaces | 6 | RPad space | Due Date (`MMDDYY`) |
| `PurchaseOrder` | String | 15 spaces | 15 | RPad space | Purchase Order / Reference |
| `MarkInfo` | String | 30 spaces | 30 | RPad space | Mark Information |
| `FOBInfo` | String | 14 spaces | 14 | RPad space | FOB Information |
| `Terms` | String | 10 spaces | 10 | RPad space | Terms |
| `LastItemNo` | String | 4 spaces | 4 | LPad `0` | Last Item Number (last line number) |
| `SortCode1` | String | 20 spaces | 20 | RPad space | Sort Code 1 |
| `WhoGotIt` | String | 20 spaces | 20 | RPad space | Who Got It |
| `UserField1` | String | 30 spaces | 30 | RPad space | User Field 1 |
| `UserField2` – `UserField5` | String | 30 spaces | 30 | RPad space | User Fields 2–5 (same schema as UserField1) |
| `SalesRepCode` | String | 3 spaces | 3 | RPad space | Sales Representative Code |
| `Branch` | String | 2 spaces | 2 | RPad space | Branch |
| `Area` | String | 2 spaces | 2 | RPad space | Area |
| `FreightZone` | String | 10 spaces | 10 | RPad space | Freight Zone |
| `ShipVia` | String | 20 spaces | 20 | RPad space | Ship Via |
| `QuoteDiscPercent` | String | 16 spaces | 16 | LPad `0` | Quote Discount Percentage (1.4) |
| `PriceClassDiscCode` | String | `" "` | 1 | — | Price Class Discount Code |
| `PriceClassDiscPercent` | String | 16 spaces | 16 | LPad `0` | Price Class Discount Percentage (1.4) |
| `CommRateType` | String | 5 spaces | 5 | RPad space | Commission Rate Type |
| `GLAccount` | String | 15 spaces | 15 | RPad space | GL Account |
| `TaxState` | String | 2 spaces | 2 | RPad space | Tax State |
| `TaxAuthority1` | String | 3 spaces | 3 | RPad space | Tax Authority 1 |
| `TaxAuthority2` – `TaxAuthority10` | String | 3 spaces | 3 | RPad space | Tax Authorities 2–10 (same schema as TaxAuthority1) |
| `TaxApplyFlag1` | String | `"N"` | 1 | — | Tax Apply Flag 1 (`Y`/`N`) |
| `TaxApplyFlag2` – `TaxApplyFlag10` | String | `"N"` | 1 | — | Tax Apply Flags 2–10 (same schema as TaxApplyFlag1) |
| `SortCode2` | String | 30 spaces | 30 | RPad space | Sort Code 2 |
| `TimeMatFlag` | String | `"N"` | 1 | — | Time & Material Flag (`Y`/`N`) |
| `CompanyCurrCode` | String | | 3 | RPad space | **Required.** Company Currency Code |
| `CatalogCurrCode` | String | | 3 | RPad space | **Required.** Catalog Currency Code |
| `QuoteCurrCode` | String | | 3 | RPad space | **Required.** Quote Currency Code |
| `ExchangeDate1` | String | 8 spaces | 8 | RPad space | Exchange Date 1 (`CCYYMMDD`) — order currency to company currency |
| `ExchangeRate1` | String | 16 spaces | 16 | LPad `0` | Exchange Rate 1 (5.5) |
| `ExchangeDate2` | String | 8 spaces | 8 | RPad space | Exchange Date 2 (`CCYYMMDD`) |
| `ExchangeRate2` | String | 16 spaces | 16 | LPad `0` | Exchange Rate 2 (5.5) |
| `ExchangeDate3` | String | 8 spaces | 8 | RPad space | Exchange Date 3 (`CCYYMMDD`) — catalog currency to order currency |
| `ExchangeRate3` | String | 16 spaces | 16 | LPad `0` | Exchange Rate 3 (5.5) |
| `ExchangeDate4` | String | 8 spaces | 8 | RPad space | Exchange Date 4 (`CCYYMMDD`) — catalog currency to company currency |
| `ExchangeRate4` | String | 16 spaces | 16 | LPad `0` | Exchange Rate 4 (5.5) |
| `CarrierCode` | String | 6 spaces | 6 | RPad space | Carrier Code |
| `3rdPartyFreightCust` | String | 7 spaces | 7 | RPad space | 3rd Party Freight Customer (validated against customer master) |
| `ServiceType` | String | 3 spaces | 3 | RPad space | Service Type (see Service Type enum below) |

**DataTable `6002B` Schema — Record Type B (Bill-To Address):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `QuoteNo` | String | | 7 | LPad `0` | **Required.** Quote Number (must match A record) |
| `Filler1` | String | 3 spaces | 3 | — | Auto-managed filler |
| `RecordType` | String | `"B"` | 1 | — | **Required.** Always `"B"` |
| `CustProspNum` | String | 6 spaces | 6 | RPad space | Customer/Prospect Number |
| `ShipToID` | String | 6 spaces | 6 | RPad space | **Required.** Ship-To ID (blank = default) |
| `BillToName` | String | 30 spaces | 30 | RPad space | Bill-To Name |
| `BillToAddress1` | String | 30 spaces | 30 | RPad space | Bill-To Address Line 1 |
| `BillToAddress2` – `BillToAddress5` | String | 30 spaces | 30 | RPad space | Bill-To Address Lines 2–5 (same schema as BillToAddress1) |
| `BillToCity` | String | 15 spaces | 15 | RPad space | Bill-To City |
| `BillToState` | String | 2 spaces | 2 | RPad space | Bill-To State |
| `BillToZip` | String | 13 spaces | 13 | RPad space | Bill-To Zip |
| `BillToCountry` | String | 12 spaces | 12 | RPad space | Bill-To Country |
| `BillToAttention` | String | 30 spaces | 30 | RPad space | Bill-To Attention |
| `ContactName` | String | 30 spaces | 30 | RPad space | Contact Name |
| `ContactPhone` | String | 20 spaces | 20 | RPad space | Contact Phone (no dashes) |
| `ContactEmail` | String | 100 spaces | 100 | RPad space | Contact Email |
| `InternationalAddressFlag` | String | `"N"` | 1 | — | International Address Flag (`Y`/`N`) |
| `Filler2` | String | | 431 | RPad space | Auto-managed filler (padded to 431 at runtime) |

**DataTable `6002C` Schema — Record Type C (Ship-To Address):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `QuoteNo` | String | | 7 | LPad `0` | **Required.** Quote Number (must match A record) |
| `Filler1` | String | 3 spaces | 3 | — | Auto-managed filler |
| `RecordType` | String | `"C"` | 1 | — | **Required.** Always `"C"` |
| `CustProspNum` | String | 6 spaces | 6 | RPad space | Customer/Prospect Number |
| `ShipToID` | String | 6 spaces | 6 | RPad space | **Required.** Ship-To ID |
| `ShipToName` | String | 30 spaces | 30 | RPad space | Ship-To Name |
| `ShipToAddress1` | String | 30 spaces | 30 | RPad space | Ship-To Address Line 1 |
| `ShipToAddress2` – `ShipToAddress5` | String | 30 spaces | 30 | RPad space | Ship-To Address Lines 2–5 (same schema as ShipToAddress1) |
| `ShipToCity` | String | 15 spaces | 15 | RPad space | Ship-To City |
| `ShiptoState` | String | 2 spaces | 2 | RPad space | Ship-To State (note: lowercase `t` in column name) |
| `ShipToZip` | String | 13 spaces | 13 | RPad space | Ship-To Zip |
| `ShipToCountry` | String | 12 spaces | 12 | RPad space | Ship-To Country |
| `ShipToAttention` | String | 30 spaces | 30 | RPad space | Ship-To Attention |
| `SalesRepCode` | String | 3 spaces | 3 | RPad space | Sales Representative Code |
| `Branch` | String | 2 spaces | 2 | RPad space | Branch |
| `Area` | String | 2 spaces | 2 | RPad space | Area |
| `FreightZone` | String | 10 spaces | 10 | RPad space | Freight Zone |
| `ShipVia` | String | 20 spaces | 20 | RPad space | Ship Via |
| `QuoteDiscPercent` | String | 16 spaces | 16 | LPad `0` | Quote Discount Percentage (1.4) |
| `PriceClassDiscCode` | String | `" "` | 1 | — | Price Class Code |
| `PriceClassDiscPercent` | String | 16 spaces | 16 | LPad `0` | Price Class Discount Percentage (1.4) |
| `CommRateType` | String | 5 spaces | 5 | RPad space | Commission Rate Type |
| `GLAccount` | String | 15 spaces | 15 | RPad space | GL Account (only 10 chars usable at this time) |
| `Filler2` | String | 42 spaces | 42 | — | Auto-managed filler |
| `InternationalAddressFlag` | String | `"N"` | 1 | — | International Address Flag (`Y`/`N`) — enter `Y` if ship-to is international |
| `Filler3` | String | 448 spaces | 448 | — | Auto-managed filler |

**DataTable `6002L` Schema — Record Type L (Line Items, 001–999):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `QuoteNo` | String | | 7 | LPad `0` | **Required.** Quote Number (no dashes) |
| `LineNo` | String | | 3 | LPad `0` | **Required.** Line Number (001–999) |
| `RecordType` | String | `"L"` | 1 | — | **Required.** Always `"L"` |
| `CustProspNum` | String | 6 spaces | 6 | RPad space | Customer/Prospect Number (blank = populated from A record) |
| `ShipToID` | String | 6 spaces | 6 | RPad space | Customer Ship-To ID (blank = populated from A record) |
| `Type` | String | `"S"` | 1 | — | Line Type: `S` = Standard, `F` = Freight |
| `QuantityOrdered` | String | 19 spaces | 19 | LPad `0` | Quantity Ordered (9.4) |
| `QuantityFractionWgt` | String | 16 spaces | 16 | LPad `0` | Quantity Fraction / Weight (7.3) |
| `UM` | String | 2 spaces | 2 | RPad space | Unit of Measure |
| `PartNo` | String | 20 spaces | 20 | RPad space | Part Number |
| `QuoteWL` | String | `" "` | 1 | — | Quote Won/Loss: `W` = Won, `L` = Loss |
| `Price` | String | 19 spaces | 19 | LPad `0` | Price (10.6) |
| `Cost` | String | 19 spaces | 19 | LPad `0` | Cost (10.6) |
| `SortCode` | String | 12 spaces | 12 | RPad space | Sort Code |
| `PartDesc` | String | 30 spaces | 30 | RPad space | Part Description |
| `UserField1` | String | 30 spaces | 30 | RPad space | User Field 1 |
| `UserField2` – `UserField5` | String | 30 spaces | 30 | RPad space | User Fields 2–5 (same schema as UserField1) |
| `PartLoc` | String | 2 spaces | 2 | RPad space | Part Location |
| `GotItPrice` | String | 19 spaces | 19 | LPad `0` | Got It Price (10.6) |
| `QuoteOrdDiscPerc` | String | 16 spaces | 16 | LPad `0` | Quote (Order) Discount % (1.4). If populated, `DiscAmt`, `QuoteDiscAmount`, and `DiscPrice` are required |
| `UsesShipCode` | String | `"N"` | 1 | — | Uses Ship Code (`Y`/`N`) |
| `PriceClassDiscPercent` | String | 16 spaces | 16 | LPad `0` | Price Class Discount Percentage (1.4) |
| `CommRateType` | String | 5 spaces | 5 | RPad space | Commission Rate Type |
| `NormGLAcct` | String | 15 spaces | 15 | RPad space | Normal GL Account (only 10 chars usable) |
| `Filler1` | String | 32 spaces | 32 | — | Auto-managed filler |
| `TaxApplyFlag1` | String | `"N"` | 1 | — | Tax Apply Flag 1 |
| `TaxApplyFlag2` – `TaxApplyFlag10` | String | `"N"` | 1 | — | Tax Apply Flags 2–10 (same schema as TaxApplyFlag1) |
| `OrigQuantity` | String | 19 spaces | 19 | LPad `0` | Original Quantity (9.4) |
| `InventoryBin` | String | 4 spaces | 4 | RPad space | Inventory Bin |
| `Group` | String | 10 spaces | 10 | RPad space | Group |
| `OrderDate` | String | 8 spaces | 8 | RPad space | Order Date (`CCYYMMDD`) |
| `ItemPromDate` | String | 6 spaces | 6 | RPad space | Item Promise Date (`MMDDYY`) |
| `TaxStatusFlag` | String | `" "` | 1 | — | Tax Status: `E` = Exempt, `T` = Taxable |
| `CustPartNo` | String | 32 spaces | 32 | RPad space | Customer Part Number |
| `InfoField1` | String | 20 spaces | 20 | RPad space | Info Field 1 |
| `InfoField2` | String | 20 spaces | 20 | RPad space | Info Field 2 |
| `OrdCurrCode` | String | | 3 | RPad space | **Required.** Order Currency Code |
| `ExtendedPrice` | String | 19 spaces | 19 | LPad `0` | **Required.** Extended Price / Extension (14.2) |
| `BOMSwitch` | String | `"C"` | 1 | — | BOM Switch: `C` = Component, `N` = Non-BOM, `Y` = BOM Parent |
| `BOMParent` | String | 4 spaces | 4 | RPad space | BOM Parent (line number of parent) |
| `ProdLine` | String | 2 spaces | 2 | RPad space | Product Line |
| `Filler2` | String | `" "` | 1 | — | Auto-managed filler |
| `ProdLineDiscPerc` | String | 16 spaces | 16 | LPad `0` | Product Line Discount % (1.4). If populated, `DiscAmt`, `PLDiscAmt`, and `DiscPrice` are required |
| `DiscAmt` | String | 19 spaces | 19 | LPad `0` | Total Discount Amount (10.2) — sum of Order, Price Class, and Product Line discount amounts |
| `DiscPrice` | String | 19 spaces | 19 | LPad `0` | Discounted Price (10.6) — actual price after all discounts applied |
| `QuoteDiscAmount` | String | 19 spaces | 19 | LPad `0` | Quote (Order) Discount Amount (10.2) — required if `QuoteOrdDiscPerc` populated |
| `PriceClassDiscAmt` | String | 19 spaces | 19 | LPad `0` | Price Class Discount Amount (10.2) — required if `PriceClassDiscPercent` populated |
| `PLDiscAmt` | String | 19 spaces | 19 | LPad `0` | Product Line Discount Amount (10.2) — required if `ProdLineDiscPerc` populated |
| `CurFreightPerPiece` | String | 16 spaces | 16 | LPad `0` | Cur Freight Per Piece (5.6) — in order currency |
| `CurPrice` | String | 19 spaces | 19 | LPad `0` | Cur Price (1.6) — in order currency |
| `CurDiscPrice` | String | 19 spaces | 19 | LPad `0` | Cur Discount Price (10.6) — in order currency |
| `CurPricePerPound` | String | 19 spaces | 19 | LPad `0` | Cur Price per Pound (10.6) — in order currency |
| `CurExtension` | String | 19 spaces | 19 | LPad `0` | Cur Extension (14.2) — in order currency |
| `CurDiscAmt` | String | 19 spaces | 19 | LPad `0` | Cur Discount Amount (10.2) — in order currency |
| `CurOrderDiscAmt` | String | 19 spaces | 19 | LPad `0` | Cur Order Discount Amount (10.2) — in order currency |
| `CurPriceClassDiscAmt` | String | 19 spaces | 19 | LPad `0` | Cur Price Class Discount Amount (10.2) — in order currency |
| `CurPLDiscAmt` | String | 19 spaces | 19 | LPad `0` | Cur Product Line Discount Amount (10.2) — in order currency |

> **Discount Fields Note:** If any discount percentages are entered on a line item (`QuoteOrdDiscPerc`, `PriceClassDiscPercent`, or `ProdLineDiscPerc`), then `DiscAmt` (total discount), the corresponding individual discount amount field(s), and `DiscPrice` (final price after all discounts) are all required.

**Service Type Enum (for `6002A.ServiceType`):**

| Code | Description |
|---|---|
| `901` | Next Day Air Early AM |
| `902` | Next Day Air |
| `903` | Next Day Air Saver |
| `904` | 2nd Day Air AM |
| `905` | 2nd Day Air |
| `906` | 3 Day Select |
| `907` | Ground |
| `908` | Worldwide Express Plus |
| `909` | Worldwide Express |
| `910` | Worldwide Expedited |

> The combination of Carrier Code and Service Type should exist in the Carrier Code Table.

**Global Variables:**

| Variable | Default | Description |
|---|---|---|
| `V.Global.s6002Error` | | `Sub*!*ErrNo*!*ErrDesc` (3-part, no row index) |
| `V.Global.s6002Option` | `"50"` | Upload option: `"50"` = Append, `"51"` = Delete, `"52"` = Append and Update |
| `V.Global.s6002ScreenMode` | `"NS"` | Screen mode: `"NS"` = Screenless |

**Option Enum (V.Global.s6002Option):**

| Value | Description |
|---|---|
| `"50"` | Append (default) |
| `"51"` | Delete |
| `"52"` | Append and Update |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `6002Sync` | Builds QUOTE.txt and runs callwrapper `6002` synchronously |
| `6002Async` | Builds QUOTE.txt and runs callwrapper `6002` asynchronously |

**How It Works:**

1. On include, `V.Global.s6002Error`, `V.Global.s6002Option` (default `"50"`), and `V.Global.s6002ScreenMode` (default `"NS"`) are declared. Four DataTables (`6002A`, `6002B`, `6002C`, `6002L`) are created with their respective columns and defaults.
2. When `6002Sync` or `6002Async` is called, the library processes each DataTable that contains rows:
   - **6002A** (header records): pads all fields to fixed widths, exports via DataView to a newline-delimited string.
   - **6002B** (bill-to records): same padding and export process.
   - **6002C** (ship-to records): same padding and export process.
   - **6002L** (line item records): same padding and export process.
3. Non-empty record strings are concatenated with newlines into a single file string (A records first, then B, C, L).
4. The combined string is written to `{FilesDir}\QUOTE.txt`.
5. The callwrapper is called **once** with parameters `{ScreenMode}!*!{Option}` (e.g., `NS!*!50`).
6. All four DataTables are cleared (`DeleteRow`) after processing. On error, `V.Global.s6002Error` is set with a 3-part `*!*`-delimited string.

**Usage Pattern (append mode — header + line items only):**

```
Program.External.Include.Library("6002.lib",False)

'Add a quote header (A record)
F.Data.DataTable.AddRow("6002A")
F.Data.DataTable.SetValue("6002A","QuoteNo","1234",0)
F.Data.DataTable.SetValue("6002A","CustProspNum","ABC123",0)
F.Data.DataTable.SetValue("6002A","QuoteDate","032126",0)
F.Data.DataTable.SetValue("6002A","DueDate","042126",0)
F.Data.DataTable.SetValue("6002A","CompanyCurrCode","USD",0)
F.Data.DataTable.SetValue("6002A","CatalogCurrCode","USD",0)
F.Data.DataTable.SetValue("6002A","QuoteCurrCode","USD",0)

'Add a line item (L record)
F.Data.DataTable.AddRow("6002L")
F.Data.DataTable.SetValue("6002L","QuoteNo","1234",0)
F.Data.DataTable.SetValue("6002L","LineNo","1",0)
F.Data.DataTable.SetValue("6002L","PartNo","WIDGET-100",0)
F.Data.DataTable.SetValue("6002L","QuantityOrdered","10.0000",0)
F.Data.DataTable.SetValue("6002L","Price","25.500000",0)
F.Data.DataTable.SetValue("6002L","ExtendedPrice","255.00",0)
F.Data.DataTable.SetValue("6002L","OrdCurrCode","USD",0)

F.Intrinsic.Control.CallSub(6002Sync)
```

**Usage Pattern (append and update — with bill-to and ship-to records):**

```
Program.External.Include.Library("6002.lib",False)

V.Global.s6002Option.Set("52")

'A record (header)
F.Data.DataTable.AddRow("6002A")
F.Data.DataTable.SetValue("6002A","QuoteNo","5678",0)
F.Data.DataTable.SetValue("6002A","CustProspNum","XYZ789",0)
F.Data.DataTable.SetValue("6002A","PurchaseOrder","PO-2026-001",0)
F.Data.DataTable.SetValue("6002A","CompanyCurrCode","USD",0)
F.Data.DataTable.SetValue("6002A","CatalogCurrCode","USD",0)
F.Data.DataTable.SetValue("6002A","QuoteCurrCode","USD",0)
F.Data.DataTable.SetValue("6002A","SalesRepCode","JD",0)
F.Data.DataTable.SetValue("6002A","Branch","01",0)

'B record (bill-to address)
F.Data.DataTable.AddRow("6002B")
F.Data.DataTable.SetValue("6002B","QuoteNo","5678",0)
F.Data.DataTable.SetValue("6002B","BillToName","Acme Corporation",0)
F.Data.DataTable.SetValue("6002B","BillToAddress1","123 Main Street",0)
F.Data.DataTable.SetValue("6002B","BillToCity","Springfield",0)
F.Data.DataTable.SetValue("6002B","BillToState","IL",0)
F.Data.DataTable.SetValue("6002B","BillToZip","62701",0)

'C record (ship-to address)
F.Data.DataTable.AddRow("6002C")
F.Data.DataTable.SetValue("6002C","QuoteNo","5678",0)
F.Data.DataTable.SetValue("6002C","ShipToID","SHIP01",0)
F.Data.DataTable.SetValue("6002C","ShipToName","Acme Warehouse",0)
F.Data.DataTable.SetValue("6002C","ShipToAddress1","456 Industrial Blvd",0)
F.Data.DataTable.SetValue("6002C","ShipToCity","Chicago",0)
F.Data.DataTable.SetValue("6002C","ShiptoState","IL",0)
F.Data.DataTable.SetValue("6002C","ShipToZip","60601",0)

'L record (line item)
F.Data.DataTable.AddRow("6002L")
F.Data.DataTable.SetValue("6002L","QuoteNo","5678",0)
F.Data.DataTable.SetValue("6002L","LineNo","1",0)
F.Data.DataTable.SetValue("6002L","PartNo","PART-A",0)
F.Data.DataTable.SetValue("6002L","QuantityOrdered","100.0000",0)
F.Data.DataTable.SetValue("6002L","Price","15.000000",0)
F.Data.DataTable.SetValue("6002L","ExtendedPrice","1500.00",0)
F.Data.DataTable.SetValue("6002L","OrdCurrCode","USD",0)

F.Intrinsic.Control.CallSub(6002Sync)
```

> **Note:** All four DataTables are cleared after processing. The file is written to `{FilesDir}\QUOTE.txt` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is 3-part (`Sub*!*ErrNo*!*ErrDesc`) with no row index. B and C records are optional — only A and L records are needed for a basic quote upload. The `QuoteNo` must match across all record types for the same quote. The `ShiptoState` column in `6002C` has a lowercase `t` — use `ShiptoState`, not `ShipToState`.

---

## 6004.lib -- Upload Sales Orders (ORDUPCM3)

**Wraps:** CallWrapper `6004` — Upload Sales Orders / ORDUPCM3

> **Important:** This library generates a **fixed-position flat file** from two linked DataTables (`6004Header` and `6004Lines`) and calls the callwrapper **once** for the entire file. Each line in the output file consists of a header record concatenated with a line-item record — the header is **repeated** before every line item belonging to it. The `OrderNum` column in `6004Lines` is used **only** for linking lines to their parent header; it is **not** written to the output file.
>
> All fields are automatically padded to their required fixed widths. **Numeric fields use implied decimal format** — no actual decimal point is included. For a format of `n.m`, the left `n` characters are the integer part and the right `m` characters are the fractional part (e.g., for format `8.2` with size 10, a value of $100.50 is entered as `"10050"` and padded to `"0000010050"`).
>
> The output filename defaults to `LD{CompanyCode}{Terminal}` (e.g., `LDAB1234`). You can override the company code, user, and filename via global variables before calling the library.

**Include:**

```
Program.External.Include.Library("6004.lib",False)
```

**DataTable `6004Header` Schema (40 columns):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `Type` | String | | 1 | RPad space | Upload Type: `O` = Order, `Q` = Quote |
| `CustNum` | String | | 7 | RPad space | Customer Number |
| `OrderNum` | String | | 7 | RPad space | Order Number (links to `6004Lines.OrderNum`) |
| `Freight` | String | | 10 | LPad `0` | Freight (8.2 implied decimal) |
| `TaxFreightFlag` | String | | 1 | RPad space | Tax Freight Flag (`Y`/`N`) |
| `FreightPerPiece` | String | | 1 | RPad space | Freight Per Piece Flag (`Y`/`N`) |
| `DueDate` | String | | 8 | RPad space | Order Due Date (`YYYYMMDD`) |
| `OrdDate` | String | | 8 | RPad space | Order Date (`YYYYMMDD`) |
| `User1` | String | | 30 | RPad space | User Field 1 |
| `User2` – `User5` | String | | 30 | RPad space | User Fields 2–5 (same schema as User1) |
| `UserID` | String | | 8 | RPad space | User ID |
| `PO` | String | | 15 | RPad space | Purchase Order |
| `Filler1` | String | | 15 | RPad space | Filler (auto-managed) |
| `FreightCurrFlag` | String | | 1 | RPad space | Freight Currency Flag (`Y`/`N`) |
| `Filler2` | String | `"S"` | 1 | RPad space | Filler (defaults to `"S"`) |
| `ShipVia` | String | | 20 | RPad space | Ship Via |
| `Carrier` | String | | 6 | RPad space | Carrier |
| `ShipName` | String | | 30 | RPad space | Ship-To Name |
| `ShipAddr1` | String | | 30 | RPad space | Ship-To Address 1 |
| `ShipAddr2` – `ShipAddr3` | String | | 30 | RPad space | Ship-To Address 2–3 (same schema as ShipAddr1) |
| `ShipCity` | String | | 25 | RPad space | Ship-To City |
| `ShipState` | String | | 2 | RPad space | Ship-To State |
| `ShipZip` | String | | 13 | RPad space | Ship-To Zip |
| `ShipCountry` | String | | 3 | RPad space | Ship-To Country |
| `ShipAttn` | String | | 30 | RPad space | Ship-To Attention |
| `Filler3` | String | | 11 | RPad space | Filler (auto-managed) |
| `OrderType` | String | | 1 | RPad space | Order Type (see enum below) |
| `OrderDiscountPer` | String | | 5 | RPad space | Order Discount Percent (1.4 implied decimal) |
| `Salesman` | String | | 3 | RPad space | Salesman |
| `Filler5` | String | | 75 | RPad space | Filler (auto-managed) |
| `OverrideAutoNum` | String | | 1 | RPad space | Override Auto Numbering: `1` = Yes, `0` = No |
| `ShipToId` | String | | 6 | RPad space | Ship-To ID |
| `MarkShipment` | String | | 30 | RPad space | Mark Shipment |
| `ContactName` | String | | 30 | RPad space | Contact Name |
| `FromLocation` | String | | 2 | RPad space | From Location |
| `Filler6` | String | | 85 | RPad space | Filler (auto-managed) |

**DataTable `6004Lines` Schema (37 columns):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `OrderNum` | String | | 7 | RPad space | Order Number — **linking only**, not written to output file |
| `LineNumber` | String | | 3 | LPad `0` | Line Number |
| `Filler1` | String | | 1 | RPad space | Filler (auto-managed) |
| `QtyOrdered` | String | | 13 | LPad `0` | Quantity Ordered (9.4 implied decimal) |
| `Weight` | String | | 10 | LPad `0` | Weight (7.3 implied decimal) |
| `UM` | String | | 2 | RPad space | Unit of Measure |
| `Part` | String | | 17 | RPad space | Part Number |
| `Rev` | String | | 3 | RPad space | Part Revision |
| `Filler2` | String | | 18 | RPad space | Filler (auto-managed) |
| `Location` | String | | 2 | RPad space | Location |
| `QuotedPrice` | String | | 16 | LPad `0` | Quoted Price (10.6 implied decimal) |
| `OverridePrice` | String | | 16 | LPad `0` | Override Price (10.6 implied decimal) |
| `Cost` | String | | 16 | LPad `0` | Cost (10.6 implied decimal) |
| `PartDescription` | String | | 30 | RPad space | Part Description |
| `PL` | String | | 3 | RPad space | Product Line |
| `OrderDate` | String | | 8 | RPad space | Order Date (`YYYYMMDD`) |
| `PromiseDate` | String | | 8 | RPad space | Promise Date (`YYYYMMDD`) |
| `User1` | String | | 30 | RPad space | User Field 1 |
| `User2` – `User5` | String | | 30 | RPad space | User Fields 2–5 (same schema as User1) |
| `ExtendedAmount` | String | | 16 | LPad `0` | Extended Amount (10.6 implied decimal) |
| `NoDeliveryBeforeDate` | String | | 8 | RPad space | No Delivery Before Date (`YYYYMMDD`) |
| `MustDeliverByDate` | String | | 8 | RPad space | Must Deliver By Date (`YYYYMMDD`) |
| `Filler3` | String | `"T"` | 1 | RPad space | Filler (defaults to `"T"`) |
| `Text1` | String | | 30 | RPad space | User Text Field 1 |
| `Text2` – `Text10` | String | | 30 | RPad space | User Text Fields 2–10 (same schema as Text1) |
| `TaxStatusFlag` | String | | 1 | RPad space | Tax Status: `E` = Exempt, `T` = Taxable |
| `LineType` | String | | 1 | RPad space | Line Type: `B` = Buyout, `D` = Dropship, `S` = Standard |
| `Filler4` | String | | 165 | RPad space | Filler (auto-managed) |

**Upload Type Enum (`6004Header.Type`):**

| Value | Description |
|---|---|
| `"O"` | Order (Sales Order) |
| `"Q"` | Quote |

**Order Type Enum (`6004Header.OrderType`):**

| Value | Description |
|---|---|
| `""` (blank) | Regular |
| `"X"` | Invoice |
| `"T"` | Transfer |
| `"B"` | Blanket |

**Line Type Enum (`6004Lines.LineType`):**

| Value | Description |
|---|---|
| `"B"` | Buyout |
| `"D"` | Dropship |
| `"S"` | Standard |

**Global Variables:**

| Variable | Default | Description |
|---|---|---|
| `V.Global.s6004Error` | | `Sub*!*ErrNo*!*ErrDesc` (3-part, no row index) |
| `V.Global.s6004Company` | `V.Caller.CompanyCode` | Company code passed to callwrapper |
| `V.Global.s6004User` | `V.Caller.User` | User ID passed to callwrapper |
| `V.Global.s6004FileName` | `"LD{CompanyCode}{Terminal}"` | Output filename (e.g., `LDAB1234`) |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `6004Sync` | Builds the upload file and runs callwrapper `6004` synchronously |
| `6004Async` | Builds the upload file and runs callwrapper `6004` asynchronously |

**How It Works:**

1. On include, `V.Global.s6004Error`, `V.Global.s6004Company` (defaults to `V.Caller.CompanyCode`), `V.Global.s6004User` (defaults to `V.Caller.User`), and `V.Global.s6004FileName` (defaults to `"LD" + CompanyCode + Terminal`) are declared. Two DataTables are created: `6004Header` (40 columns) and `6004Lines` (37 columns).
2. When `6004Sync` or `6004Async` is called, the library pads every field in both DataTables to the required fixed width.
3. For each header row, the library:
   - Exports the header as a fixed-position string.
   - Filters `6004Lines` by matching `OrderNum`.
   - Strips `OrderNum` from the line field list (it is not part of the file format).
   - Exports matching lines using `NewLine + HeaderString` as the row delimiter, so each line in the output file is a header record concatenated with a line-item record.
4. All header/line groups are concatenated into a single file string.
5. The file is written to `{FilesDir}\{s6004FileName}`.
6. The callwrapper is called **once** with parameters `{Company}!*!{User}!*!{FileName}`.
7. Both DataTables are cleared after processing. On error, `V.Global.s6004Error` is set with a 3-part `*!*`-delimited string.

> **Implied Decimal Note:** All numeric fields use implied decimal format. For a format of `n.m`, provide the value **without** a decimal point — the last `m` characters are treated as the fractional part. For example, to enter $100.50 in an `8.2` field (size 10), provide `"10050"` (the library pads it to `"0000010050"`; the system reads this as `00000100.50`).

**Usage Pattern (upload a sales order with two line items):**

```
Program.External.Include.Library("6004.lib",False)

'Add header
F.Data.DataTable.AddRow("6004Header")
F.Data.DataTable.SetValue("6004Header","Type","O",0)
F.Data.DataTable.SetValue("6004Header","CustNum","ABC123",0)
F.Data.DataTable.SetValue("6004Header","OrderNum","1000001",0)
F.Data.DataTable.SetValue("6004Header","OrdDate","20260321",0)
F.Data.DataTable.SetValue("6004Header","DueDate","20260421",0)
F.Data.DataTable.SetValue("6004Header","PO","PO-2026-100",0)

'Add line 1
F.Data.DataTable.AddRow("6004Lines")
F.Data.DataTable.SetValue("6004Lines","OrderNum","1000001",0)
F.Data.DataTable.SetValue("6004Lines","LineNumber","1",0)
F.Data.DataTable.SetValue("6004Lines","QtyOrdered","100000",0)
F.Data.DataTable.SetValue("6004Lines","UM","EA",0)
F.Data.DataTable.SetValue("6004Lines","Part","WIDGET-100",0)
F.Data.DataTable.SetValue("6004Lines","QuotedPrice","0000000025500000",0)
F.Data.DataTable.SetValue("6004Lines","ExtendedAmount","0000000255000000",0)

'Add line 2
F.Data.DataTable.AddRow("6004Lines")
F.Data.DataTable.SetValue("6004Lines","OrderNum","1000001",1)
F.Data.DataTable.SetValue("6004Lines","LineNumber","2",1)
F.Data.DataTable.SetValue("6004Lines","QtyOrdered","50000",1)
F.Data.DataTable.SetValue("6004Lines","UM","EA",1)
F.Data.DataTable.SetValue("6004Lines","Part","BOLT-200",1)
F.Data.DataTable.SetValue("6004Lines","QuotedPrice","0000000005000000",1)
F.Data.DataTable.SetValue("6004Lines","ExtendedAmount","0000000025000000",1)

F.Intrinsic.Control.CallSub(6004Sync)
```

**Usage Pattern (upload a quote with custom filename):**

```
Program.External.Include.Library("6004.lib",False)

'Override the default filename
V.Global.s6004FileName.Set("MYQUOTES")

'Add header for a quote
F.Data.DataTable.AddRow("6004Header")
F.Data.DataTable.SetValue("6004Header","Type","Q",0)
F.Data.DataTable.SetValue("6004Header","CustNum","XYZ789",0)
F.Data.DataTable.SetValue("6004Header","OrderNum","5000001",0)
F.Data.DataTable.SetValue("6004Header","OrdDate","20260321",0)
F.Data.DataTable.SetValue("6004Header","Salesman","JD",0)

'Add a line item
F.Data.DataTable.AddRow("6004Lines")
F.Data.DataTable.SetValue("6004Lines","OrderNum","5000001",0)
F.Data.DataTable.SetValue("6004Lines","LineNumber","1",0)
F.Data.DataTable.SetValue("6004Lines","QtyOrdered","250000",0)
F.Data.DataTable.SetValue("6004Lines","UM","EA",0)
F.Data.DataTable.SetValue("6004Lines","Part","ASSEMBLY-500",0)
F.Data.DataTable.SetValue("6004Lines","QuotedPrice","0000000150000000",0)
F.Data.DataTable.SetValue("6004Lines","ExtendedAmount","0000003750000000",0)
F.Data.DataTable.SetValue("6004Lines","LineType","S",0)

F.Intrinsic.Control.CallSub(6004Async)
```

> **Note:** Both DataTables are cleared after processing. The file is written to `{FilesDir}\{s6004FileName}` and the callwrapper is called once with parameters `{Company}!*!{User}!*!{FileName}`. Each header row must have at least one matching line in `6004Lines` with the same `OrderNum`. The `OrderNum` in `6004Lines` is used only for linking and is not written to the output file. Override `V.Global.s6004Company`, `V.Global.s6004User`, or `V.Global.s6004FileName` before calling to customize callwrapper parameters. The `Filler2` column in `6004Header` defaults to `"S"` and `Filler3` in `6004Lines` defaults to `"T"` — these are meaningful defaults.

---

## 6006.lib -- Payroll (Employee) Master Upload (UPLEMPL)

**Wraps:** CallWrapper `6006` — Payroll (Employee) Master Upload / UPLEMPL

> **Important:** This library generates a **fixed-position flat file** (`EMPLOYEE.txt`) from the `6006` DataTable and calls the callwrapper **once** for the entire file — not per row. All fields are automatically padded to their required widths. Only `EmpNum` and `EmpName` are required; all other fields can be left at defaults if not needed. Most numeric fields are size 16 with LPad `0` and use implied decimal format (no actual decimal point — see format column for `n.m` breakdown).

> **Reference:** [Upload file layout](http://www.gss-updates.com/site/GShelp/2015/000/INDEX.asp?addl_ref_data_conv_payroll_empl_master.asp)

**Include:**

```
Program.External.Include.Library("6006.lib",False)
```

**DataTable `6006` Schema — Employee Information:**

| Column | Type | Default | Size | Pad | Format | Description |
|---|---|---|---|---|---|---|
| `EmpNum` | String | | 5 | LPad `0` | Numeric | **Required.** Employee Number |
| `EmpName` | String | | 30 | RPad space | | **Required.** Employee Name |
| `Address` | String | 30 spaces | 30 | RPad space | | Address |
| `City` | String | 24 spaces | 24 | RPad space | | City |
| `State` | String | 2 spaces | 2 | RPad space | | State |
| `Zip` | String | 9 spaces | 9 | RPad space | No dashes | Zip |
| `Sex` | String | `" "` | 1 | — | `M`/`F` | Sex |
| `SSN` | String | 9 spaces | 9 | RPad space | No dashes | Social Security Number |
| `HireDate` | String | 6 spaces | 6 | RPad space | `MMDDYY` | Employee Hire Date |
| `TermDate` | String | 6 spaces | 6 | RPad space | `MMDDYY` | Employee Termination Date |
| `BirthDate` | String | 6 spaces | 6 | RPad space | `MMDDYY` | Birth Date |
| `Phone` | String | 10 spaces | 10 | RPad space | No dashes | Phone |
| `LastRaiseDate` | String | 6 spaces | 6 | RPad space | `MMDDYY` | Employee Last Raise Date |
| `PrevRate` | String | 16 spaces | 16 | LPad `0` | 6.3 | Employee Previous Rate |
| `Sort` | String | 12 spaces | 12 | RPad space | | Alpha Sort |
| `Initials` | String | 3 spaces | 3 | RPad space | | Employee Initials |
| `Comment1` | String | 40 spaces | 40 | RPad space | | Comment 1 |
| `Comment2` | String | 30 spaces | 30 | RPad space | | Comment 2 |
| `Comment3` | String | 20 spaces | 20 | RPad space | | Comment 3 |
| `Department` | String | 4 spaces | 4 | RPad space | | Department |
| `WCCode` | String | 4 spaces | 4 | RPad space | | Workers' Compensation Code |
| `Shift` | String | `" "` | 1 | — | | Shift |
| `PayRate` | String | 16 spaces | 16 | LPad `0` | 6.3 | Pay Rate |
| `ShiftDiff` | String | 16 spaces | 16 | LPad `0` | 2.2 | Shift Differential |
| `PayFreq` | String | `" "` | 1 | — | | Pay Frequency (see enum) |
| `PayType` | String | `" "` | 1 | — | | Pay Type (see enum) |
| `StateCode` | String | 2 spaces | 2 | RPad space | | State Code |
| `SUIDistrict` | String | 2 spaces | 2 | RPad space | | SUI District |
| `401kMatch` | String | 16 spaces | 16 | LPad `0` | 6.2 | 401K Match |
| `401kMatchPercent` | String | `" "` | 1 | — | | 401K Match Percent: `Y` = %, `N` = $ |
| `FedExempt` | String | 2 spaces | 2 | RPad space | | Federal Exemptions |
| `FedAddAmt` | String | 16 spaces | 16 | LPad `0` | 5.2 | Federal Additional Amount |
| `MaritalStatus` | String | `" "` | 1 | — | | Marital Status (see enum) |
| `StateExempt` | String | 2 spaces | 2 | RPad space | | State Exemptions |
| `StateAddAmt` | String | 16 spaces | 16 | LPad `0` | 4.2 | State Additional Amount |
| `Local1Code` | String | 3 spaces | 3 | RPad space | | Local 1 Code |
| `Local2Code` | String | 3 spaces | 3 | RPad space | | Local 2 Code |
| `StateExemptAmt` | String | 16 spaces | 16 | LPad `0` | 6.0 | State Exempt Amount |
| `PersonalExempt` | String | `" "` | 1 | — | | Personal Exempt |

**DataTable `6006` Schema — Deductions (Amt/Bal):**

| Column | Type | Default | Size | Pad | Format | Description |
|---|---|---|---|---|---|---|
| `DeducAmt1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Amount 1 |
| `DeducAmt2` – `DeducAmt6` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Amounts 2–6 (same schema) |
| `DeducAmt7` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Amount 7 |
| `DeducBal7` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Balance 7 |
| `DeducAmt8` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Amount 8 |
| `DeducBal8` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Balance 8 |
| `DeducAmt9` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Amount 9 |
| `DeducBal9` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Balance 9 |
| `DeducAmt10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Amount 10 |
| `DeducBal10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Deduction Balance 10 |
| `IRAPerc` | String | 16 spaces | 16 | LPad `0` | 1.4 | IRA Percent |

> **Note:** Deductions 1–6 have amounts only (no balance). Deductions 7–10 have both amount and balance columns.

**DataTable `6006` Schema — Additional Deductions:**

| Column | Type | Default | Size | Pad | Format | Description |
|---|---|---|---|---|---|---|
| `AddDeducAmt1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Additional Deduction Amount 1 |
| `AddDeducBal1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Additional Deduction Balance 1 |
| `AddDeducAmt2` – `AddDeducAmt10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Additional Deduction Amounts 2–10 (same schema; each has matching `AddDeducBal` column) |
| `AddDeducBal2` – `AddDeducBal10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Additional Deduction Balances 2–10 |
| `AddDeducAmt11` | String | 16 spaces | 16 | LPad `0` | 3.4 | Additional Deduction Amount 11 |
| `AddDeducAmt12` | String | 16 spaces | 16 | LPad `0` | 3.4 | Additional Deduction Amount 12 |

> **Note:** Additional Deductions 1–10 have both amount and balance columns (paired). Additional Deductions 11–12 have amounts only (no balance) and use format 3.4 instead of 6.2.

**DataTable `6006` Schema — Pre-Tax Deductions & Garnishments:**

| Column | Type | Default | Size | Pad | Format | Description |
|---|---|---|---|---|---|---|
| `PreTaxDeducAmt1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Pre-Tax Deduction Amount 1 |
| `PreTaxDeducAmt2` – `PreTaxDeducAmt10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Pre-Tax Deduction Amounts 2–10 (same schema) |
| `GarnAmt1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Garnishment Amount 1 |
| `GarnAmt2` – `GarnAmt5` | String | 16 spaces | 16 | LPad `0` | 6.2 | Garnishment Amounts 2–5 (same schema) |
| `Filler` | String | 34 spaces | 34 | — | | Filler (not in use) |

**DataTable `6006` Schema — Scheduling, Earnings & Misc:**

| Column | Type | Default | Size | Pad | Format | Description |
|---|---|---|---|---|---|---|
| `VacaHoursRem` | String | 16 spaces | 16 | LPad `0` | 3.2 | Vacation Hours Remaining |
| `SickHrsRem` | String | 16 spaces | 16 | LPad `0` | 3.2 | Sick Hours Remaining |
| `BalGroup` | String | 8 spaces | 8 | RPad space | | Balancing Group |
| `FixedEarnAmt1` | String | 16 spaces | 16 | LPad `0` | +-6.2 | Fixed Earnings Amount 1 |
| `FixedEarnAmt2` – `FixedEarnAmt3` | String | 16 spaces | 16 | LPad `0` | +-6.2 | Fixed Earnings Amounts 2–3 (same schema) |
| `BillingRate` | String | 16 spaces | 16 | LPad `0` | 8.5 | Billing Rate |
| `Grouping` | String | 3 spaces | 3 | LPad `0` | 3.0 | Grouping |
| `Prototype` | String | 5 spaces | 5 | RPad space | | Prototype |
| `PurgeDays` | String | 3 spaces | 3 | LPad `0` | 3.0 | Purge Days |
| `UserID` | String | 8 spaces | 8 | RPad space | | User ID |
| `EmpVacSickStatus` | String | 2 spaces | 2 | RPad space | | Employee Vacation/Sick Status |
| `UseInSched` | String | `" "` | 1 | — | `Y`/`N` | Use in Scheduling |
| `CarryOverDate` | String | 6 spaces | 6 | RPad space | `YYMMDD` | Carry Over Date |
| `RateScaleCode` | String | 2 spaces | 2 | RPad space | | Rate Scale Code |
| `ResidentAlien` | String | `" "` | 1 | — | `Y`/`N` | Resident Alien Flag |
| `ExcludeFromPieceRateCalc` | String | `" "` | 1 | — | `Y`/`N` | Exclude from Piece Rate Calc |
| `NotEligibleForHolidayPay` | String | `" "` | 1 | — | `Y`/`N` | Not Eligible for Holiday Pay |
| `DateEligibleForHolidayPay` | String | 6 spaces | 6 | RPad space | `MMDDYY` | Date Eligible for Holiday Pay |
| `PayGroup` | String | `" "` | 1 | — | | Pay Group |
| `FUTAExempt` | String | `" "` | 1 | — | `Y`/`N` | FUTA Exempt |
| `PrimLangCode` | String | 3 spaces | 3 | RPad space | Numeric | Primary Language Code |
| `SecondLangCode` | String | 3 spaces | 3 | RPad space | Numeric | Secondary Language Code |
| `Email` | String | 100 spaces | 100 | RPad space | | Email |

**DataTable `6006` Schema — Garnishment Balances & Employer Healthcare:**

| Column | Type | Default | Size | Pad | Format | Description |
|---|---|---|---|---|---|---|
| `GarnBal1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Garnishment Balance 1 |
| `GarnBal2` – `GarnBal5` | String | 16 spaces | 16 | LPad `0` | 6.2 | Garnishment Balances 2–5 (same schema) |
| `EmplrHC1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Employer Healthcare 1 |
| `EmplrHC2` – `EmplrHC10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Employer Healthcare 2–10 (same schema) |
| `EmplrHCAdl1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Employer Healthcare Additional 1 |
| `EmplrHCAdl2` – `EmplrHCAdl10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Employer Healthcare Additional 2–10 (same schema) |
| `EmplrHCPT1` | String | 16 spaces | 16 | LPad `0` | 6.2 | Employer Healthcare PT 1 |
| `EmplrHCPT2` – `EmplrHCPT10` | String | 16 spaces | 16 | LPad `0` | 6.2 | Employer Healthcare PT 2–10 (same schema) |
| `ContractEmp` | String | `" "` | 1 | — | `Y`/`N` | Contract Employee |

**Pay Frequency Enum (`PayFreq`):**

| Value | Description |
|---|---|
| `"M"` | Monthly |
| `"W"` | Weekly |
| `"B"` | Bi-Weekly |
| `"S"` | Semi-Monthly |

**Pay Type Enum (`PayType`):**

| Value | Description |
|---|---|
| `"H"` | Hourly |
| `"S"` | Salary |

**Marital Status Enum (`MaritalStatus`):**

| Value | Description |
|---|---|
| `"M"` | Married |
| `"S"` | Single |
| `"H"` | Head of Household |

**Global Variables:**

| Variable | Default | Description |
|---|---|---|
| `V.Global.s6006Error` | | `Sub*!*ErrNo*!*ErrDesc` (3-part, no row index) |
| `V.Global.s6006Option` | `"50"` | Upload option: `"50"` = Append, `"51"` = Delete, `"52"` = Append and Update |
| `V.Global.s6006ScreenMode` | `"NS"` | Screen mode: `"NS"` = Screenless (only valid option) |

**Option Enum (V.Global.s6006Option):**

| Value | Description |
|---|---|
| `"50"` | Append (default) |
| `"51"` | Delete |
| `"52"` | Append and Update |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `6006Sync` | Builds EMPLOYEE.txt and runs callwrapper `6006` synchronously |
| `6006Async` | Builds EMPLOYEE.txt and runs callwrapper `6006` asynchronously |

**How It Works:**

1. On include, `V.Global.s6006Error`, `V.Global.s6006Option` (default `"50"`), and `V.Global.s6006ScreenMode` (default `"NS"`) are declared. The `6006` DataTable is created with all columns and appropriate space/default values.
2. When `6006Sync` or `6006Async` is called, the library pads every field in every row to the required fixed width using `RPad` (space) for text fields or `LPad` (`0`) for numeric fields.
3. A `DataView` converts the entire DataTable into a newline-delimited string (one fixed-position record per row).
4. The string is written to `{FilesDir}\EMPLOYEE.txt`.
5. The callwrapper is called **once** with parameters `{ScreenMode}!*!{Option}` (e.g., `NS!*!50`).
6. After processing, all rows are deleted from the `6006` DataTable. On error, `V.Global.s6006Error` is set with a 3-part `*!*`-delimited string.

**Usage Pattern (append — basic employee record):**

```
Program.External.Include.Library("6006.lib",False)

F.Data.DataTable.AddRow("6006")
F.Data.DataTable.SetValue("6006","EmpNum","123",0)
F.Data.DataTable.SetValue("6006","EmpName","Smith, John",0)
F.Data.DataTable.SetValue("6006","Address","456 Oak Lane",0)
F.Data.DataTable.SetValue("6006","City","Springfield",0)
F.Data.DataTable.SetValue("6006","State","IL",0)
F.Data.DataTable.SetValue("6006","Zip","627010000",0)
F.Data.DataTable.SetValue("6006","HireDate","032126",0)
F.Data.DataTable.SetValue("6006","PayRate","0000000000025000",0)
F.Data.DataTable.SetValue("6006","PayFreq","B",0)
F.Data.DataTable.SetValue("6006","PayType","H",0)
F.Data.DataTable.SetValue("6006","Department","PROD",0)
F.Data.DataTable.SetValue("6006","MaritalStatus","M",0)

F.Intrinsic.Control.CallSub(6006Sync)
```

**Usage Pattern (append and update — with deductions and garnishments):**

```
Program.External.Include.Library("6006.lib",False)

V.Global.s6006Option.Set("52")

F.Data.DataTable.AddRow("6006")
F.Data.DataTable.SetValue("6006","EmpNum","456",0)
F.Data.DataTable.SetValue("6006","EmpName","Doe, Jane",0)
F.Data.DataTable.SetValue("6006","HireDate","010125",0)
F.Data.DataTable.SetValue("6006","PayRate","0000000000065000",0)
F.Data.DataTable.SetValue("6006","PayFreq","S",0)
F.Data.DataTable.SetValue("6006","PayType","S",0)
F.Data.DataTable.SetValue("6006","FedExempt","02",0)
F.Data.DataTable.SetValue("6006","MaritalStatus","S",0)
F.Data.DataTable.SetValue("6006","DeducAmt1","0000000000050000",0)
F.Data.DataTable.SetValue("6006","401kMatch","0000000000006000",0)
F.Data.DataTable.SetValue("6006","401kMatchPercent","Y",0)
F.Data.DataTable.SetValue("6006","GarnAmt1","0000000000015000",0)
F.Data.DataTable.SetValue("6006","Email","jane.doe@example.com",0)

F.Intrinsic.Control.CallSub(6006Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\EMPLOYEE.txt` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is 3-part (`Sub*!*ErrNo*!*ErrDesc`) with no row index. Only `EmpNum` and `EmpName` are required — all other fields default to spaces or zeros. Numeric fields use implied decimal format (e.g., `PayRate` with format `6.3` means 6 digits left of the implied decimal and 3 digits right, so `$25.000` is entered as `"25000"` and padded to `"0000000000025000"`). The `ScreenMode` is fixed to `"NS"` (screenless) — this is the only valid option.

---

## 6008.lib -- Upload Job Cost Sequence Lines to Router Header (UPLJOBST)

**Wraps:** CallWrapper `6008` — Upload Job Cost Sequence Lines to Router Header Master / UPLJOBST

> **Important:** This library generates a **fixed-position flat file** (`JOBCOST.TXT`) from the `6008` DataTable and calls the callwrapper **once** for the entire file — not per row. All fields are automatically padded to their required widths. Numeric fields (+-8.4 format) include an **explicit decimal point** in the default value (e.g., `"00000000000.0000"`). Required fields are `WONo` and `LMO`.

**Include:**

```
Program.External.Include.Library("6008.lib",False)
```

**DataTable `6008` Schema (25 columns):**

| Column | Type | Default | Size | Pad | Description |
|---|---|---|---|---|---|
| `WONo` | String | 6 spaces | 6 | RPad space | **Required.** Work Order Number |
| `Suffix` | String | 3 spaces | 3 | RPad space | Work Order Suffix |
| `Seq` | String | 6 spaces | 6 | LPad `0` | Work Order Sequence |
| `OpCode` | String | 6 spaces | 6 | RPad space | Operation Code |
| `SetUp` | String | `" "` | 1 | RPad space | `Y` if step contains Setup |
| `LMO` | String | `" "` | 1 | RPad space | **Required.** LMOCT code |
| `OpDesc` | String | 30 spaces | 30 | RPad space | Description of Operation |
| `UM` | String | 2 spaces | 2 | RPad space | Unit of Measure |
| `PWC` | String | 20 spaces | 20 | RPad space | Dept/WC/Part/OS Code etc. (Machine 1–5 share this 20-char space, 4 chars each) |
| `RouterNo` | String | 20 spaces | 20 | RPad space | Router Number |
| `RouterSeq` | String | 6 spaces | 6 | RPad `0` | Router Sequence |
| `SetupTime` | String | `"00000000000.0000"` | 16 | LPad `0` | Setup Time (+-8.4) |
| `Unit` | String | `"00000000000.0000"` | 16 | LPad `0` | Unit — Quantity to make 1 (+-8.4) |
| `Burden` | String | `"00000000000.0000"` | 16 | LPad `0` | Burden Rate (+-8.4) |
| `EstHrs` | String | `"00000000000.0000"` | 16 | LPad `0` | Estimated Hours (+-8.4) |
| `StartDate` | String | `"000000"` | 6 | RPad space | Start Date (`MMDDYY`) |
| `DueDate` | String | `"000000"` | 6 | RPad space | Due Date (`MMDDYY`) |
| `OrderDate` | String | `"999999"` | 6 | RPad space | Order Date (`MMDDYY`) — defaults to `999999` |
| `Rate` | String | `"00000000000.0000"` | 16 | LPad `0` | Rate (+-8.4) |
| `SortCode` | String | 20 spaces | 20 | RPad space | Sort Code |
| `ProjGrp` | String | 6 spaces | 6 | RPad space | Project Group |
| `SignoffUser` | String | 8 spaces | 8 | RPad space | Signoff User/Group ID |
| `ComplReq` | String | `" "` | 1 | RPad space | Completion Required for next step (`Y`/`N`) |
| `SaveBack2Rt` | String | `" "` | 1 | RPad space | Do Not Save Changes to Router (`Y`/`N`) |
| `Overlap` | String | 16 spaces | 16 | LPad `0` | Overlap — decimal percentage without decimal point (2.0) |

> **Numeric Format Note:** The +-8.4 fields default to `"00000000000.0000"` — these include an explicit decimal point in the 16-character field. When providing values, include the decimal point (e.g., `"00000000001.5000"` for 1.5 hours). The `Overlap` field uses format 2.0 (whole number percentage, no decimal).

**Global Variables:**

| Variable | Default | Description |
|---|---|---|
| `V.Global.s6008Error` | `""` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part with 1-based row index; `-1` for wrapper-level error) |
| `V.Global.s6008Mode` | `"NS"` | Screen mode: `"NS"` = Screenless |
| `V.Global.s6008Option` | `"50"` | Upload option: `"50"` = Append, `"51"` = Delete, `"52"` = Append and Update |

**Option Enum (V.Global.s6008Option):**

| Value | Description |
|---|---|
| `"50"` | Append (default) |
| `"51"` | Delete |
| `"52"` | Append and Update |

**Exposed Subroutines:**

| Subroutine | Description |
|---|---|
| `6008Sync` | Builds JOBCOST.TXT and runs callwrapper `6008` synchronously |
| `6008Async` | Builds JOBCOST.TXT and runs callwrapper `6008` asynchronously |

**How It Works:**

1. On include, `V.Global.s6008Error` (default `""`), `V.Global.s6008Mode` (default `"NS"`), and `V.Global.s6008Option` (default `"50"`) are declared. The `6008` DataTable is created with 25 columns, each with appropriate defaults — notably, numeric +-8.4 fields default to `"00000000000.0000"`.
2. When `6008Sync` or `6008Async` is called, the library pads every field in every row to the required fixed width using `RPad` (space or `0`) or `LPad` (`0`) as appropriate.
3. A `DataView` converts the entire DataTable into a newline-delimited string (one fixed-position record per row).
4. The string is written to `{FilesDir}\JOBCOST.TXT`.
5. The callwrapper is called **once** with parameters `{Mode}!*!{Option}` (e.g., `NS!*!50`).
6. After processing, all rows are deleted from the `6008` DataTable. On error, `V.Global.s6008Error` is set with a **4-part** `*!*`-delimited string including a 1-based row index (or `-1` for wrapper-level errors).

**Usage Pattern (append — add sequences to a work order):**

```
Program.External.Include.Library("6008.lib",False)

F.Data.DataTable.AddRow("6008")
F.Data.DataTable.SetValue("6008","WONo","100200",0)
F.Data.DataTable.SetValue("6008","Suffix","001",0)
F.Data.DataTable.SetValue("6008","Seq","10",0)
F.Data.DataTable.SetValue("6008","OpCode","LATHE",0)
F.Data.DataTable.SetValue("6008","LMO","L",0)
F.Data.DataTable.SetValue("6008","OpDesc","Rough Turning",0)
F.Data.DataTable.SetValue("6008","UM","HR",0)
F.Data.DataTable.SetValue("6008","PWC","MC01",0)
F.Data.DataTable.SetValue("6008","SetupTime","00000000000.5000",0)
F.Data.DataTable.SetValue("6008","EstHrs","00000000002.0000",0)
F.Data.DataTable.SetValue("6008","Rate","00000000045.0000",0)
F.Data.DataTable.SetValue("6008","StartDate","032126",0)
F.Data.DataTable.SetValue("6008","DueDate","040126",0)

F.Intrinsic.Control.CallSub(6008Sync)
```

**Usage Pattern (multiple sequences with router reference):**

```
Program.External.Include.Library("6008.lib",False)

'Sequence 10 - Setup step
F.Data.DataTable.AddRow("6008")
F.Data.DataTable.SetValue("6008","WONo","200300",0)
F.Data.DataTable.SetValue("6008","Seq","10",0)
F.Data.DataTable.SetValue("6008","OpCode","SETUP",0)
F.Data.DataTable.SetValue("6008","SetUp","Y",0)
F.Data.DataTable.SetValue("6008","LMO","L",0)
F.Data.DataTable.SetValue("6008","OpDesc","Machine Setup",0)
F.Data.DataTable.SetValue("6008","PWC","MC02",0)
F.Data.DataTable.SetValue("6008","RouterNo","RT-WIDGET-100",0)
F.Data.DataTable.SetValue("6008","RouterSeq","10",0)
F.Data.DataTable.SetValue("6008","SetupTime","00000000001.0000",0)

'Sequence 20 - Production step
F.Data.DataTable.AddRow("6008")
F.Data.DataTable.SetValue("6008","WONo","200300",1)
F.Data.DataTable.SetValue("6008","Seq","20",1)
F.Data.DataTable.SetValue("6008","OpCode","MILL",1)
F.Data.DataTable.SetValue("6008","LMO","M",1)
F.Data.DataTable.SetValue("6008","OpDesc","CNC Milling",1)
F.Data.DataTable.SetValue("6008","PWC","MC02",1)
F.Data.DataTable.SetValue("6008","RouterNo","RT-WIDGET-100",1)
F.Data.DataTable.SetValue("6008","RouterSeq","20",1)
F.Data.DataTable.SetValue("6008","Unit","00000000000.2500",1)
F.Data.DataTable.SetValue("6008","EstHrs","00000000005.0000",1)
F.Data.DataTable.SetValue("6008","Rate","00000000055.0000",1)

F.Intrinsic.Control.CallSub(6008Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\JOBCOST.TXT` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is **4-part** (`Sub*!*ErrNo*!*ErrDesc*!*Row`) with a 1-based row index (or `-1` for wrapper-level errors). The `OrderDate` defaults to `"999999"` (unlike `StartDate`/`DueDate` which default to `"000000"`). The `RouterSeq` field uses RPad `"0"` rather than LPad. The `PWC` field shares its 20-character space with Machine 1–5 (4 characters each).

---

## 6013.lib -- Upload Customer Master (UPLCUST)

**Wraps:** CallWrapper `6013` — Upload Customer Master / UPLCUST

> **Important:** This library generates a **fixed-position flat file** (`CUSTOMER.TXT`) from the `6013` DataTable and calls the callwrapper **once** for the entire file — not per row.

**Documentation:** [Customer Master Upload File Format](https://docs.gss-service.com/en_US/data-conversion-upload-tables/customer-master)

```
Program.External.Include.Library("6013.lib",False)
```

### Global Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s6013Error` | String | `""` | Error output. Format: `Sub*!*ErrNo*!*ErrDesc` |
| `V.Global.s6013Mode` | String | `"50"` | Upload mode — see **Mode** enum below |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"1"` | Append (Default) |
| `"2"` | Delete — removes all customers with **no** open items |
| `"3"` | Append and Update |
| `"4"` | Delete From File — deletes only customers listed in the upload file |

> **Note:** The declared default for `s6013Mode` is `"50"`, which is passed as the callwrapper parameter. The comment block states `"1"` (Append) is the logical default mode. Set `V.Global.s6013Mode` explicitly before calling.

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `6013Sync` | Pads fields, writes `CUSTOMER.TXT`, calls `CallWrapperSync(6013, s6013Mode)` |
| `6013Async` | Pads fields, writes `CUSTOMER.TXT`, calls `CallWrapperAsync(6013, s6013Mode)` |

### DataTable `6013` — Schema

> `*Parameter*` denotes a required field. All fields are `String` type. RPad = right-padded with spaces; LPad = left-padded with zeros.

#### General / Bill-To Information

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 1 | `CustNum` | **\*Customer Number\*** | | 6 | RPad | `""` |
| 2 | `CustName` | **\*Customer Name\*** | | 30 | RPad | `""` |
| 3 | `Address1` | Address Line 1 | | 30 | RPad | 30 spaces |
| 4 | `Address2` | Address Line 2 | | 30 | RPad | 30 spaces |
| 5 | `City` | City | | 15 | RPad | 15 spaces |
| 6 | `State` | State | | 2 | RPad | 2 spaces |
| 7 | `Zip` | Zip | | 13 | RPad | 13 spaces |
| 8 | `Country` | Country | | 12 | RPad | 12 spaces |
| 9 | `County` | County | | 12 | RPad | 12 spaces |
| 10 | `Attention` | Attention | | 30 | RPad | 30 spaces |
| 11 | `SalesRep` | Sales Rep | | 3 | RPad | 3 spaces |
| 12 | `IntlAddressFlag` | International Address Flag | Y/N | 1 | — | `" "` |
| 13 | `Branch` | Branch | | 2 | RPad | 2 spaces |
| 14 | `AreaCode` | Area Code | | 2 | RPad | 2 spaces |
| 15 | `CreditCode` | Credit Code | | 2 | RPad | 2 spaces |
| 16 | `PhoneNum` | Phone Number | No Dashes | 13 | RPad | 13 spaces |

#### Tax / GL

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 17 | `TaxCode1` | Tax Code 1 | | 3 | RPad | 3 spaces |
| 18 | `TaxCode2` | Tax Code 2 | | 3 | RPad | 3 spaces |
| 19 | `TaxCode3` | Tax Code 3 | | 3 | RPad | 3 spaces |
| 20 | `TaxCode4` | Tax Code 4 | | 3 | RPad | 3 spaces |
| 21 | `GLAccount` | Normal GL Account | | 15 | RPad | 15 spaces |

#### Account Flags

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 22 | `BalanceFwdFlag` | Balance Forward Flag | `"B"` Balance Forward / `"O"` Open Items | 1 | — | `" "` |
| 23 | `StatementFlag` | Statement Indicator Flag | Y/N | 1 | — | `" "` |
| 24 | `CreditHoldFlag` | Credit Hold Flag | Y/N | 1 | — | `" "` |
| 25 | `TaxState` | Tax State | | 2 | RPad | 2 spaces |
| 26 | `IntercompanyCustFlag` | Intercompany Customer Flag | Y/N | 1 | — | `" "` |
| 27 | `SalesTaxExemptNum` | Sales Tax Exempt Number | | 20 | RPad | 20 spaces |

#### Financial History

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 28 | `LastCashReceiptDate` | Last Cash Receipt Date | MMDDYY | 6 | RPad | 6 spaces |
| 29 | `LastCashReceiptAmt` | Last Cash Receipt Amount | +-9.2 | 16 | LPad `"0"` | 16 spaces |
| 30 | `LastSaleDate` | Last Sale Date | MMDDYY | 6 | RPad | 6 spaces |
| 31 | `LastSaleAmt` | Last Sale Amount | +-9.2 | 16 | LPad `"0"` | 16 spaces |
| 32 | `InvoiceCount` | Number of Invoices Paid | +-6.0 | 16 | LPad `"0"` | 16 spaces |
| 33 | `AvgDaysPayment` | Average Days Payment | +-6.0 | 16 | LPad `"0"` | 16 spaces |

#### Pricing / Terms / Dates

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 34 | `FinanceChargeCode` | Finance Charge Code | | 1 | — | `" "` |
| 35 | `ContractMasterFlag` | Contract Master | Y/N | 1 | — | `" "` |
| 36 | `PriceClassCode` | Price Class Code | | 1 | — | `" "` |
| 37 | `NoBackorderFlag` | No Backorder Flag | Y/N | 1 | — | `" "` |
| 38 | `CustInceptionDate` | Customer Inception Date | MMDDYY | 6 | RPad | 6 spaces |
| 39 | `SICCode` | SIC Code | | 4 | RPad | 4 spaces |
| 40 | `TermsCode` | Terms Code | | 1 | — | `" "` |
| 41 | `UseGvmtPricingFlag` | Use Government Pricing Flag | Y/N | 1 | — | `" "` |

#### Balances / Sort / Contact

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 42 | `OpenItemBal` | Open Item Balance | +-9.2 | 16 | LPad `"0"` | 16 spaces |
| 43 | `OpenOrderBal` | Open Order Balance | +-9.2 | 16 | LPad `"0"` | 16 spaces |
| 44 | `AlphaSort` | Alpha Sort | | 30 | RPad | 30 spaces |
| 45 | `FaxNum` | Fax Number | No Dashes | 13 | RPad | 13 spaces |
| 46 | `SortField` | Sort Field | | 15 | RPad | 15 spaces |
| 47 | `CommRateType` | Commission Rate Type | | 5 | RPad | 5 spaces |
| 48 | `Email` | Email Address | | 43 | RPad | 43 spaces |
| 49 | `DateLastUpdated` | Date Last Updated | MMDDYY | 6 | RPad | 6 spaces |

#### Ship-To Information

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 50 | `ShipName` | Ship Name | | 30 | RPad | 14 spaces |
| 51 | `ShipAddress1` | Ship Address 1 | | 30 | RPad | 30 spaces |
| 52 | `ShipAddress2` | Ship Address 2 | | 30 | RPad | 30 spaces |
| 53 | `ShipCity` | Ship City | | 15 | RPad | 15 spaces |
| 54 | `ShipState` | Ship State | | 2 | RPad | 2 spaces |
| 55 | `ShipZip` | Ship Zip | | 13 | RPad | 13 spaces |
| 56 | `ShipCountry` | Ship Country | | 12 | RPad | 12 spaces |
| 57 | `ShipCounty` | Ship County | | 12 | RPad | 12 spaces |
| 58 | `ShipAttention` | Ship Attention | | 30 | RPad | 30 spaces |
| 59 | `ShipViaCode` | Ship Via Code | | 1 | — | `" "` |
| 60 | `ShipCollectCode` | Ship Collect Code | | 1 | — | `" "` |

#### EDI / Shipping

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 61 | `SendEDIFlag` | Send EDI 856 (ASN) Flag | Y/N | 1 | — | `" "` |
| 62 | `CreateEDIInvoiceFlag` | Create EDI Invoice Flag | Y/N | 1 | — | `" "` |
| 63 | `FreightZone` | Freight Zone | | 10 | RPad | 10 spaces |
| 64 | `IntlShipAddressFlag` | International Ship Address Flag | Y/N | 1 | — | `" "` |
| 65 | `ShipPhone` | Ship Phone | No Dashes | 13 | RPad | 13 spaces |
| 66 | `ShipFax` | Ship Fax | No Dashes | 13 | RPad | 13 spaces |
| 67 | `GeoCode` | Geo Code | | 2 | RPad | 2 spaces |
| 68 | `OrderDiscPerc` | Order Discount Percent | 1.4 | 16 | LPad `"0"` | 16 spaces |

#### Extended Address Lines

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 69 | `Address3` | Address 3 | | 30 | RPad | 30 spaces |
| 70 | `Address4` | Address 4 | | 30 | RPad | 30 spaces |
| 71 | `Address5` | Address 5 | | 30 | RPad | 30 spaces |
| 72 | `ShipAddress3` | Ship Address 3 | | 30 | RPad | 30 spaces |
| 73 | `ShipAddress4` | Ship Address 4 | | 30 | RPad | 30 spaces |
| 74 | `ShipAddress5` | Ship Address 5 | | 30 | RPad | 30 spaces |

#### Tax / Currency Extensions

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 75 | `TaxZipCode` | Tax Zip Code | | 13 | RPad | 13 spaces |
| 76 | `DefaultCurrCode` | Default Currency Code | | 3 | RPad | 3 spaces |
| 77 | `CatalogCurrCode` | Catalog Currency Code | | 3 | RPad | 3 spaces |
| 78 | `TaxCode5` | Tax Code 5 | | 3 | RPad | 3 spaces |
| 79 | `TaxCode6` | Tax Code 6 | | 3 | RPad | 3 spaces |
| 80 | `TaxCode7` | Tax Code 7 | | 3 | RPad | 3 spaces |
| 81 | `TaxCode8` | Tax Code 8 | | 3 | RPad | 3 spaces |
| 82 | `TaxCode9` | Tax Code 9 | | 3 | RPad | 3 spaces |
| 83 | `TaxCode10` | Tax Code 10 | | 3 | RPad | 3 spaces |
| 84 | `PriceCategoryCode` | Price Category Code | | 2 | RPad | 2 spaces |
| 85 | `AlwaysTakesTermsDiscFlag` | Always Takes Terms Discount Flag | Y/N | 1 | — | `" "` |

#### Reports / Credit Card

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 86 | `PackingListReportID` | Packing List Report ID | Numeric | 6 | RPad | 6 spaces |
| 87 | `AckReportID` | Acknowledgment Report ID | Numeric | 6 | RPad | 6 spaces |
| 88 | `CCNum` | Credit Card Number | | 25 | RPad | 21 spaces |
| 89 | `CCType` | Credit Card Type | See **CCType** enum | 2 | — | 2 spaces |
| 90 | `CCRequestType` | Credit Card Request Type | See **CCRequestType** enum | 1 | — | `" "` |
| 91 | `Filler1` | Filler — Ignore | | 3 | — | 3 spaces |
| 92 | `ExpDate` | Expiration Date | MMYY | 4 | RPad | 4 spaces |
| 93 | `ValidatingBillingAddressFlag` | Validating Billing Address | Y/N | 1 | — | `" "` |
| 94 | `ShipInvoiceWhenCCRejectsFlag` | Ship and Invoice when CC Rejects | Y/N | 1 | — | `" "` |
| 95 | `SuppressInvoicePrintForCCFlag` | Suppress Invoice Print for Credit Cards | Y/N | 1 | — | `" "` |
| 96 | `OrderAmtOnHoldFlag` | Order Amount on Hold | Y/N | 1 | — | `" "` |
| 97 | `NonBackAmtOnHoldFlag` | Non-Back Amount on Hold | Y/N | 1 | — | `" "` |
| 98 | `Length` | Length | Numeric | 2 | RPad | 2 spaces |

#### Filler / SO / Reports (Extended)

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 99 | `Filler2` | Filler — Ignore | | 190 | — | 190 spaces |
| 100 | `SONumberRangeCode` | Sales Order Number Range Code | | 2 | RPad | 2 spaces |
| 101 | `RMAReportID` | RMA Report ID | Numeric | 6 | RPad | 6 spaces |
| 102 | `QuoteReportID` | Quote Report ID | Numeric | 6 | RPad | 6 spaces |
| 103 | `InvoiceCreditMemoReportID` | Invoice/Credit Memo Report ID | Numeric | 6 | RPad | 6 spaces |
| 104 | `Filler3` | Filler — Ignore | | 6 | — | 6 spaces |
| 105 | `MfgName` | Manufacturer Name | | 40 | RPad | 40 spaces |
| 106 | `SingleGroupQuote` | Single Group Quote | | 1 | — | `" "` |
| 107 | `Filler4` | Filler — Ignore | | 3 | — | 3 spaces |

#### Carrier / Shipping

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 108 | `CarrierCode` | Carrier Code | | 6 | RPad | 6 spaces |
| 109 | `Filler5` | Filler — Ignore | | 1 | — | `" "` |
| 110 | `ShippingHoldFlag` | Shipping Hold Flag | Y/N | 1 | — | `" "` |
| 111 | `Filler6` | Filler — Ignore | | 2 | — | 2 spaces |
| 112 | `ThirdPartyFreightCust` | Third Party Freight Customer | | 7 | RPad | 7 spaces |
| 113 | `UPSAcctNum` | UPS Account Number | | 10 | RPad | 10 spaces |
| 114 | `FedExAcctNum` | FedEx Account Number | | 25 | RPad | 25 spaces |
| 115 | `ConfiguratorDisc` | Configurator Discount | 1.4 | 16 | LPad `"0"` | 16 spaces |
| 116 | `BoLLabelReportID` | Bill of Lading Label Report ID | Numeric | 6 | RPad | 6 spaces |
| 117 | `ExternalID` | External ID | | 12 | RPad | 12 spaces |
| 118 | `ServiceType` | Service Type | See **Note 1** | 3 | RPad | 3 spaces |
| 119 | `BuyingGroupFlag` | Buying Group Flag | See **BuyingGroupFlag** enum | 1 | — | `" "` |
| 120 | `BoLMultipageReportID` | Bill of Lading Multipage Report ID | Numeric | 6 | RPad | 6 spaces |
| 121 | `ShipSoftwareCityFrom` | Shipping Software extracts City from | See **ShipSoftwareCityFrom** enum | 1 | — | `" "` |
| 122 | `ShipSoftwareCountyFrom` | Shipping Software extracts County from | See **ShipSoftwareCountyFrom** enum | 1 | — | `" "` |
| 123 | `BoLReportID` | Bill of Lading Report ID | Numeric | 6 | RPad | 6 spaces |

#### Localization / Credit Policies

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 124 | `Language` | Language Code | | 3 | RPad | 3 spaces |
| 125 | `SetCreditHoldWhenLimitExceededFlag` | Set Credit Hold When Limit Exceeded | Y/N | 1 | — | `" "` |
| 126 | `SetShipHoldWhenCreditLimitExceededFlag` | Set Ship Hold When Credit Limit Exceeded | Y/N | 1 | — | `" "` |
| 127 | `AllowShipHoldChangeAtOrderLevelFlag` | Allow Shipping Hold Modified at Order Level | | 1 | — | `" "` |
| 128 | `SOLabelsReportID` | Sales Order Labels Report ID | Numeric | 6 | RPad | 6 spaces |
| 129 | `MatlSurchageMarkupPerc` | Material Surcharge Markup Percent | 1.4 | 16 | LPad `"0"` | 16 spaces |

#### Invoice / EDI Hold Flags

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 130 | `SetInvoiceHoldFlag` | Set Invoice Hold Flag | Y/N | 1 | — | `" "` |
| 131 | `RemoveInvoiceHoldShipmentLevelFlag` | Remove Invoice Hold at Shipment Level | Y/N | 1 | — | `" "` |
| 132 | `EDIASNNotGeneratedFlag` | EDI ASN Not Generated Flag | Y/N | 1 | — | `" "` |
| 133 | `MissingTrackingAndWaybillNumFlag` | Missing Tracking and Waybill Number | Y/N | 1 | — | `" "` |
| 134 | `FreightMissingFlag` | Freight is Missing Flag | Y/N | 1 | — | `" "` |
| 135 | `InvoiceHoldShipmentManualFlag` | Invoice Hold at Shipment (Manual) | Y/N | 1 | — | `" "` |
| 136 | `ContainsConsignmentLinesFlag` | Contains Consignment Lines Flag | Y/N | 1 | — | `" "` |
| 137 | `Filler7` | Filler — Ignore | | 14 | — | 14 spaces |

#### Packing / Transfer / Misc

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 138 | `PrintPackingListHeaderTextInvoiceFlag` | Print Packing List Header Text on Invoice | Y/N | 1 | — | `" "` |
| 139 | `PrintPackingListHeadetTextBOLFlag` | Print Packing List Header Text on BOL | Y/N | 1 | — | `" "` |
| 140 | `UseAcctShipToUPSFlag` | Use Account per Ship To (UPS) | Y/N | 1 | — | `" "` |
| 141 | `UseAcctShipToFedExFlag` | Use Account per Ship To (FedEx) | Y/N | 1 | — | `" "` |
| 142 | `ConsignmentBin` | Consignment Bin | | 6 | RPad | 6 spaces |
| 143 | `SuppressInvoicePrintFlag` | Suppress Invoice Print Flag | Y/N | 1 | — | `" "` |
| 144 | `WOLabelsReportID` | Work Order Labels Report ID | Numeric | 6 | RPad | 6 spaces |
| 145 | `Loc` | Location | | 2 | RPad | 3 spaces |
| 146 | `AgingDays` | Aging Days | | 3 | RPad | 3 spaces |
| 147 | `PrintPackingListLineTextInvoiceFlag` | Print Packing List Line Text on Invoice | Y/N | 1 | — | `" "` |
| 148 | `BOLLineEntry` | Bill of Lading Line Entry | See **BOLLineEntry** enum | 1 | — | `" "` |
| 149 | `ExtendedBarCodeWOReportID` | Extended Bar Code WO Report ID | Numeric | 6 | RPad | 6 spaces |

#### Transfer Options

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 150 | `TransferOrdersOnlyFlag` | Transfer Orders Only Flag | Y/N | 1 | — | `" "` |
| 151 | `AutoReceiveInTransitLinesFlag` | Auto Receive In-Transit Lines | Y/N | 1 | — | `" "` |
| 152 | `PrintTransitFormFlag` | Print Transit Form Flag | Y/N | 1 | — | `" "` |
| 153 | `TransferUsingFromBinFlag` | Transfer Using From Bin Flag | Y/N | 1 | — | `" "` |
| 154 | `TransferUsingDefaultBinFlag` | Transfer Using Default Bin Flag | Y/N | 1 | — | `" "` |
| 155 | `TransferToBin` | Transfer to Bin | | 6 | RPad | 6 spaces |
| 156 | `AllowChangeLotBinXferOptAtShipmentFlag` | Allow Change to Lot/Bin Transfer Options at Shipment | Y/N | 1 | — | `" "` |

#### Delivery / Web

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 157 | `InvoiceDelivery` | Invoice Delivery | See **InvoiceDelivery** enum | 1 | — | `" "` |
| 158 | `WebAddress` | Web Address | | 255 | RPad | 255 spaces |

### Enums

**CCType** — Credit Card Type

| Value | Meaning |
|-------|---------|
| `"MC"` | MasterCard |
| `"VI"` | Visa |
| `"DC"` | Discover |
| `"DI"` | Diners |
| `"AM"` | American Express |
| `"CB"` | Carte Blanche |
| `"JB"` | JCB |

**CCRequestType** — Credit Card Request Type

| Value | Meaning |
|-------|---------|
| `"1"` | Pre-Authorized |
| `"2"` | Approved |
| `"3"` | Payment |
| `"4"` | Refund |

**BuyingGroupFlag**

| Value | Meaning |
|-------|---------|
| `"G"` | Group |
| `"M"` | Member |

**ShipSoftwareCityFrom** — Shipping Software extracts City from

| Value | Meaning |
|-------|---------|
| `" "` | Ship To City (default) |
| `"2"` | Ship To Adr2 |
| `"3"` | Ship To Adr3 |
| `"4"` | Ship To Adr4 |
| `"5"` | Ship To Adr5 |

**ShipSoftwareCountyFrom** — Shipping Software extracts County from

| Value | Meaning |
|-------|---------|
| `" "` | Ship To City (default) |
| `"2"` | Ship To Adr2 |
| `"3"` | Ship To Adr3 |
| `"4"` | Ship To Adr4 |
| `"5"` | Ship To Adr5 |

**BOLLineEntry** — Bill of Lading Line Entry

| Value | Meaning |
|-------|---------|
| `" "` | Default Company |
| `"M"` | Manual Entry |
| `"P"` | Use Packing Data |

**InvoiceDelivery**

| Value | Meaning |
|-------|---------|
| `"1"` | Print |
| `"2"` | Email |
| `"3"` | Both |

### Note 1 — Carrier Service Types

The combination of `CarrierCode` and `ServiceType` must exist in the Carrier Code Table. Standard service types:

| Code | Service |
|------|---------|
| `901` | Next Day Air Early AM |
| `902` | Next Day Air |
| `903` | Next Day Air Saver |
| `904` | 2nd Day Air AM |
| `905` | 2nd Day Air |
| `906` | 3 Day Select |
| `907` | Ground |
| `908` | Worldwide Express Plus |
| `909` | Worldwide Express |
| `910` | Worldwide Expedited |

### How It Works

1. **Include** the library: `Program.External.Include.Library("6013.lib",False)`
2. **Add rows** to the `6013` DataTable — one row per customer
3. Optionally set `V.Global.s6013Mode` (defaults to `"50"` as declared; set `"1"` for Append, `"3"` for Append+Update, etc.)
4. Call **`6013Sync`** or **`6013Async`**
5. The library:
   - Iterates all rows, **RPad**-ing text fields with spaces and **LPad**-ing numeric fields with `"0"` to their fixed widths
   - Creates a DataView (style 22 — all columns), converts to a newline-delimited string
   - Writes the string to `{V.Caller.FilesDir}\CUSTOMER.TXT`
   - Calls `CallWrapperSync(6013, V.Global.s6013Mode)` or `CallWrapperAsync`
   - Deletes all rows from the DataTable after processing
6. On error, `V.Global.s6013Error` is set to `Sub*!*ErrNo*!*ErrDesc`

### Usage Example

```
Program.External.Include.Library("6013.lib",False)

V.Global.s6013Mode.Set("3")

F.Data.DataTable.AddRow("6013")
F.Data.DataTable.SetValue("6013","CustNum","ABC123",0)
F.Data.DataTable.SetValue("6013","CustName","Acme Manufacturing",0)
F.Data.DataTable.SetValue("6013","Address1","123 Industrial Pkwy",0)
F.Data.DataTable.SetValue("6013","City","Houston",0)
F.Data.DataTable.SetValue("6013","State","TX",0)
F.Data.DataTable.SetValue("6013","Zip","77001",0)
F.Data.DataTable.SetValue("6013","SalesRep","JDM",0)
F.Data.DataTable.SetValue("6013","TermsCode","2",0)
F.Data.DataTable.SetValue("6013","AlphaSort","ACME MANUFACTURING",0)
F.Data.DataTable.SetValue("6013","Email","orders@acmemfg.com",0)
F.Data.DataTable.SetValue("6013","CarrierCode","UPS",0)
F.Data.DataTable.SetValue("6013","ServiceType","907",0)

F.Intrinsic.Control.CallSub(6013Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\CUSTOMER.TXT` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is **3-part** (`Sub*!*ErrNo*!*ErrDesc`). The `ShipName` column has a default of only 14 spaces but is RPad-ded to 30 in the output file. The `PrintPackingListHeadetTextBOLFlag` column name contains a typo (`Headet` instead of `Header`) — this matches the library source and must be used as-is. Mode `"2"` (Delete) will remove all customers with no open items — use with extreme caution. Mode `"4"` (Delete From File) only removes customers listed in the upload file.

---

## 6016.lib -- PO Receipts Upload (PUR102)

**Wraps:** CallWrapper `6016` — PO Receipts Upload / PUR102

> **Important:** Unlike most upload libraries, this library generates a **CSV file** (comma-delimited) — not a fixed-position flat file. Fields are constrained by `MaxLength` on the DataTable columns rather than RPad/LPad. The callwrapper parameter is the **filename** (not a mode).

```
Program.External.Include.Library("6016.lib",False)
```

### Global Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s6016Error` | String | `""` | Error output. Format: `Sub*!*ErrNo*!*ErrDesc` |
| `V.Global.s6016FileName` | String | `"P{CompanyCode}RCPTS{Terminal}.txt"` | Output filename — dynamically built from `V.Caller.CompanyCode` and `V.Caller.Terminal` |
| `V.Global.s6016FilePath` | String | `"{FilesDir}\{FileName}"` | Full output path — dynamically built from `V.Caller.FilesDir` and `s6016FileName` |

> **Note:** `s6016FileName` and `s6016FilePath` are computed in Preflight. Override them **after** the Include if you need a custom path. If you override `s6016FileName`, also override `s6016FilePath` to match.

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `6016Sync` | Writes CSV file to `s6016FilePath`, calls `CallWrapperSync(6016, s6016FileName)` |
| `6016Async` | Writes CSV file to `s6016FilePath`, calls `CallWrapperAsync(6016, s6016FileName)` |

### DataTable `6016` — Schema

All columns are `String` type with a `MaxLength` constraint (5th parameter of `AddColumn`). No padding is applied — fields are written as-is in CSV format.

| # | Column | Description | Format | Max Size |
|---|--------|-------------|--------|----------|
| 1 | `PO` | Purchase Order Number | `#######` | 7 |
| 2 | `Line` | Purchase Order Line | `###` | 3 |
| 3 | `Bin` | Bin | | 6 |
| 4 | `Lot` | Lot | | 15 |
| 5 | `Heat` | Heat | | 15 |
| 6 | `Serial` | Serial Number | | 30 |
| 7 | `RcvdDate` | Received Date | YYMMDD | 6 |
| 8 | `Qty` | Quantity | Number | 16 |
| 9 | `Receiver` | Receiver | | 6 |
| 10 | `Price` | Price | Number | 15 |
| 11 | `Closed` | Closed | Y/N | 1 |
| 12 | `WO` | Work Order | `######` | 6 |
| 13 | `WOSuffix` | Work Order Suffix | `###` | 3 |
| 14 | `WOSeq` | Work Order Sequence | `######` | 6 |
| 15 | `SAPPO` | SAP Purchase Order | | 10 |
| 16 | `RcvrText` | Receiver Text | | 30 |
| 17 | `PackList` | Packing List | | 16 |
| 18 | `PrintQty` | Print Quantity | `####` | 4 |
| 19 | `PrintFlag` | Print Flag | Y/N | 1 |
| 20 | `TransID` | Transaction ID | `##########` | 9 |
| 21 | `LineSeq` | Line Sequence | `####` | 4 |
| 22 | `RejectQty` | Rejection Quantity | Number — see note below | 12 |
| 23 | `RejectCode` | Rejection Code | | 3 |
| 24 | `RcvToInspection` | Receive to Inspection | Y/N | 1 |
| 25 | `POUMOverrideQty` | PO UM Override Quantity | | 16 |
| 26 | `User1` | User Field 1 | | 15 |
| 27 | `User2` | User Field 2 | | 15 |
| 28 | `User3` | User Field 3 | | 15 |
| 29 | `User4` | User Field 4 | | 15 |
| 30 | `User5` | User Field 5 | | 15 |
| 31 | `User6` | User Field 6 | | 15 |
| 32 | `User7` | User Field 7 | | 15 |
| 33 | `User8` | User Field 8 | | 15 |
| 34 | `User9` | User Field 9 | | 15 |

> **RejectQty behavior:** If passed as a whole number (e.g., `"50"`), the value is **divided by 10,000** by the core program (so `50` becomes `0.005`). If passed as a float (e.g., `"50.0"`), the value is left as-is. Always include a decimal point to avoid unexpected division.

### How It Works

1. **Include** the library: `Program.External.Include.Library("6016.lib",False)`
2. Preflight computes `s6016FileName` = `P{CompanyCode}RCPTS{Terminal}.txt` and `s6016FilePath` = `{FilesDir}\{FileName}`
3. Optionally override `V.Global.s6016FileName` and `V.Global.s6016FilePath` after the Include
4. **Add rows** to the `6016` DataTable — one row per receipt line
5. Call **`6016Sync`** or **`6016Async`**
6. The library:
   - Creates a DataView (style 22 — all columns), converts to a **comma-delimited, newline-separated** string
   - Writes the string to `V.Global.s6016FilePath`
   - Calls `CallWrapperSync(6016, V.Global.s6016FileName)` or `CallWrapperAsync` — the callwrapper receives the **filename** as its parameter
   - Deletes all rows from the DataTable after processing
7. On error, `V.Global.s6016Error` is set to `Sub*!*ErrNo*!*ErrDesc`

### Usage Example

```
Program.External.Include.Library("6016.lib",False)

F.Data.DataTable.AddRow("6016")
F.Data.DataTable.SetValue("6016","PO","1234567",0)
F.Data.DataTable.SetValue("6016","Line","1",0)
F.Data.DataTable.SetValue("6016","RcvdDate","260321",0)
F.Data.DataTable.SetValue("6016","Qty","100.0",0)
F.Data.DataTable.SetValue("6016","Receiver","JSMITH",0)
F.Data.DataTable.SetValue("6016","Price","25.50",0)
F.Data.DataTable.SetValue("6016","Bin","A01",0)

F.Intrinsic.Control.CallSub(6016Sync)
```

**Usage Pattern (custom file path):**

```
Program.External.Include.Library("6016.lib",False)

V.Global.s6016FileName.Set("MyPOReceipts.txt")
F.Intrinsic.String.Build("{0}\{1}",V.Caller.FilesDir,V.Global.s6016FileName,V.Global.s6016FilePath)

F.Data.DataTable.AddRow("6016")
F.Data.DataTable.SetValue("6016","PO","9876543",0)
F.Data.DataTable.SetValue("6016","Line","1",0)
F.Data.DataTable.SetValue("6016","RcvdDate","260321",0)
F.Data.DataTable.SetValue("6016","Qty","50.0",0)
F.Data.DataTable.SetValue("6016","Receiver","MJONES",0)
F.Data.DataTable.SetValue("6016","Price","12.75",0)
F.Data.DataTable.SetValue("6016","RejectQty","5.0",0)
F.Data.DataTable.SetValue("6016","RejectCode","DMG",0)

F.Intrinsic.Control.CallSub(6016Sync)
```

**Usage Pattern (with work order and inspection):**

```
Program.External.Include.Library("6016.lib",False)

F.Data.DataTable.AddRow("6016")
F.Data.DataTable.SetValue("6016","PO","5551234",0)
F.Data.DataTable.SetValue("6016","Line","1",0)
F.Data.DataTable.SetValue("6016","RcvdDate","260321",0)
F.Data.DataTable.SetValue("6016","Qty","200.0",0)
F.Data.DataTable.SetValue("6016","Receiver","ASMITH",0)
F.Data.DataTable.SetValue("6016","Price","8.00",0)
F.Data.DataTable.SetValue("6016","WO","100200",0)
F.Data.DataTable.SetValue("6016","WOSuffix","001",0)
F.Data.DataTable.SetValue("6016","WOSeq","10",0)
F.Data.DataTable.SetValue("6016","RcvToInspection","Y",0)

F.Intrinsic.Control.CallSub(6016Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written as **CSV** (comma-delimited) to `V.Global.s6016FilePath` and the callwrapper receives the **filename** (not a mode) as its parameter. No field padding is applied — columns use `MaxLength` constraints on the DataTable. The `RejectQty` field has special behavior: whole numbers are divided by 10,000 by the core program — always include a decimal point (e.g., `"50.0"` not `"50"`) to avoid unexpected results. The date format for `RcvdDate` is **YYMMDD** (not MMDDYY like other libraries).

---

## 6017.lib -- Job Master Upload (UPLJBMUL)

**Wraps:** CallWrapper `6017` — Job Master Upload / UPLJBMUL

> **Important:** This library generates a **fixed-position flat file** (`JBMDLA.TXT`) from the `6017` DataTable and calls the callwrapper **once** for the entire file — not per row.

```
Program.External.Include.Library("6017.lib",False)
```

### Global Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `V.Global.s6017Error` | String | `""` | Error output. Format: `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` = wrapper-level error) |
| `V.Global.s6017Mode` | String | `"NS"` | Screen mode — see **Mode** enum below |
| `V.Global.s6017Option` | String | `"50"` | Upload option — see **Option** enum below |

### Mode Enum

| Value | Meaning |
|-------|---------|
| `"NS"` | Screenless mode (default) |
| `"PS"` | Populate the screen (interactive) |

### Option Enum

| Value | Meaning |
|-------|---------|
| `"50"` | Append (default) |
| `"51"` | Delete |
| `"52"` | Append and Update |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `6017Sync` | Pads fields, writes `JBMDLA.TXT`, calls `CallWrapperSync(6017, Mode!*!Option)` |
| `6017Async` | Pads fields, writes `JBMDLA.TXT`, calls `CallWrapperAsync(6017, Mode!*!Option)` |

### DataTable `6017` — Schema

> `*Parameter*` denotes a required field. All fields are `String` type. RPad = right-padded with spaces; LPad = left-padded with zeros. Implied decimal format: `8.4` means 8 digits before and 4 after the implied decimal (no explicit decimal point in the file).

| # | Column | Description | Format | Size | Pad | Default |
|---|--------|-------------|--------|------|-----|---------|
| 1 | `WO` | **\*Work Order\*** | | 6 | RPad | `""` |
| 2 | `WOSuffix` | Work Order Suffix | | 3 | RPad | 3 spaces |
| 3 | `Part` | Part | | 20 | RPad | 20 spaces |
| 4 | `Loc` | Location | | 2 | RPad | 2 spaces |
| 5 | `Router` | Router | | 20 | RPad | 20 spaces |
| 6 | `WODesc` | Work Order Description | | 30 | RPad | 30 spaces |
| 7 | `CustNum` | Customer Number | | 6 | RPad | 6 spaces |
| 8 | `PONum` | Purchase Order Number | | 20 | RPad | 20 spaces |
| 9 | `RunQty` | Run Quantity | 8.4 | 16 | LPad `"0"` | 16 spaces |
| 10 | `DateOpened` | **\*Date Opened\*** | MMDDYY | 6 | RPad | `""` |
| 11 | `DueDate` | Due Date | MMDDYY | 6 | RPad | 6 spaces |
| 12 | `StartDate` | Start Date | MMDDYY | 6 | RPad | 6 spaces |
| 13 | `OriginalStartDate` | Original Start Date | MMDDYY | 6 | RPad | 6 spaces |
| 14 | `AddDesc1` | Additional Description 1 | | 70 | RPad | 70 spaces |
| 15 | `AddDesc2` | Additional Description 2 | | 70 | RPad | 70 spaces |
| 16 | `UserCode` | User Code | | 30 | RPad | 30 spaces |
| 17 | `QtyCompleted` | Quantity Completed | 8.4 | 16 | LPad `"0"` | 16 spaces |
| 18 | `Salesman` | Salesman | | 3 | RPad | 3 spaces |
| 19 | `CloseDate` | Date Closed | MMDDYY | 6 | RPad | 6 spaces |
| 20 | `PL` | Product Line | | 2 | RPad | 2 spaces |
| 21 | `PricePerUnit` | Price Per Unit | | 16 | LPad `"0"` | 16 spaces |
| 22 | `CustQty` | Customer Quantity | 8.4 | 16 | LPad `"0"` | 16 spaces |
| 23 | `PartDesc` | Part Description | | 30 | RPad | 30 spaces |
| 24 | `Priority` | Priority | | 3 | LPad `"0"` | 3 spaces |
| 25 | `Project` | Project | Numeric | 7 | RPad | 7 spaces |
| 26 | `AddDesc3` | Additional Description 3 | | 70 | RPad | 70 spaces |
| 27 | `ParentWO` | Parent Work Order | | 6 | RPad | 6 spaces |
| 28 | `ParentWOSuffix` | Parent Work Order Suffix | | 3 | RPad | 3 spaces |

### How It Works

1. **Include** the library: `Program.External.Include.Library("6017.lib",False)`
2. Optionally set `V.Global.s6017Mode` (default `"NS"`) and `V.Global.s6017Option` (default `"50"`)
3. **Add rows** to the `6017` DataTable — one row per work order
4. Call **`6017Sync`** or **`6017Async`**
5. The library:
   - Iterates all rows, **RPad**-ing text fields with spaces and **LPad**-ing numeric fields with `"0"` to their fixed widths
   - Creates a DataView (style 22 — all columns), converts to a newline-delimited string
   - Writes the string to `{V.Caller.FilesDir}\JBMDLA.TXT`
   - Concatenates `Mode` and `Option` via `ConcatCallWrapperArgs` and calls `CallWrapperSync(6017, params)` or `CallWrapperAsync`
   - Deletes all rows from the DataTable after processing
6. On error, `V.Global.s6017Error` is set to `Sub*!*ErrNo*!*ErrDesc*!*Row` (Row is 1-based; `-1` for wrapper-level errors)

### Usage Example

```
Program.External.Include.Library("6017.lib",False)

F.Data.DataTable.AddRow("6017")
F.Data.DataTable.SetValue("6017","WO","100500",0)
F.Data.DataTable.SetValue("6017","Part","WIDGET-100",0)
F.Data.DataTable.SetValue("6017","Loc","01",0)
F.Data.DataTable.SetValue("6017","Router","RT-WIDGET-100",0)
F.Data.DataTable.SetValue("6017","WODesc","Widget Assembly",0)
F.Data.DataTable.SetValue("6017","RunQty","500",0)
F.Data.DataTable.SetValue("6017","DateOpened","032126",0)
F.Data.DataTable.SetValue("6017","DueDate","040126",0)
F.Data.DataTable.SetValue("6017","StartDate","032126",0)
F.Data.DataTable.SetValue("6017","Priority","10",0)

F.Intrinsic.Control.CallSub(6017Sync)
```

**Usage Pattern (with parent work order and customer):**

```
Program.External.Include.Library("6017.lib",False)

V.Global.s6017Option.Set("52")

F.Data.DataTable.AddRow("6017")
F.Data.DataTable.SetValue("6017","WO","100501",0)
F.Data.DataTable.SetValue("6017","WOSuffix","001",0)
F.Data.DataTable.SetValue("6017","Part","SUB-ASSY-200",0)
F.Data.DataTable.SetValue("6017","Router","RT-SUB-200",0)
F.Data.DataTable.SetValue("6017","WODesc","Sub-Assembly Build",0)
F.Data.DataTable.SetValue("6017","CustNum","ABC123",0)
F.Data.DataTable.SetValue("6017","PONum","PO-2026-0455",0)
F.Data.DataTable.SetValue("6017","RunQty","250",0)
F.Data.DataTable.SetValue("6017","DateOpened","032126",0)
F.Data.DataTable.SetValue("6017","DueDate","041526",0)
F.Data.DataTable.SetValue("6017","PricePerUnit","25",0)
F.Data.DataTable.SetValue("6017","CustQty","250",0)
F.Data.DataTable.SetValue("6017","ParentWO","100500",0)

F.Intrinsic.Control.CallSub(6017Sync)
```

> **Note:** The DataTable is cleared after processing. The file is written to `{FilesDir}\JBMDLA.TXT` and the callwrapper is called once for the entire file. All fields are auto-padded. The error format is **4-part** (`Sub*!*ErrNo*!*ErrDesc*!*Row`) with a 1-based row index (or `-1` for wrapper-level errors). The callwrapper parameters are built using `ConcatCallWrapperArgs(Mode, Option)`. The `Priority` field uniquely uses LPad `"0"` (zero-padded) rather than RPad spaces. The `WO` and `DateOpened` columns have no default value — they are required fields.

---

