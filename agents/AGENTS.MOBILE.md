---
AGENT_TITLE: GS Mobile Custom Transactions Agent
AGENT_DESCRIPTION: Designing and implementing custom GS Mobile site transactions backed by GAB (.g2u) scripts.
AGENT_USAGE: Load for GS Mobile, wireless/mobile custom transactions, F.Global.Mobile.* APIs, or mobile HTML result flows.
---

# GS Mobile Custom Transactions Agent

**Tier 2 sub-agent** for designing and implementing **custom Global Shop Solutions (GSS) GS Mobile site transactions** backed by **GAB (`.g2u`)** scripts. Use this file when the work involves **GS Mobile**, **wireless / mobile custom transactions**, **`F.Global.Mobile.*`**, **HTML results**, or **redirect-style mobile flows** (including traveler / **T-Card**–style receipts where mobile shows a confirmation or navigates after shop-floor processing).

> **Last verified:** 2026-05-14 (**also:** facts below from **GS Mobile Technical Workshop 2025** slide deck — **confirm** on the target GlobalShop/GS Mobile build). **§14** reproduces the Helpjuice **Wireless-Line Table Guide** (**published 2026-03-16**); re-validate against the live article if GSS revises it. **§15** documents production **`WIRELESS_HDR` / `WIRELESS_LINE`** write patterns (**`GAB_7640_Mobile_RollTransferPalletID.g2u`**, 2024-07-29). | **Product version:** unverified — confirm APIs against the site’s GlobalShop/OCTSRS build in `AGENTS.PROJECT.md`.

---

## When to load this file

| User intent | Load |
|-------------|------|
| New or changed **custom mobile transaction** | This file + bundles below |
| **Authentication / permissions** for a mobile GAB script | This file + `agents/gab/INTEGRATION.md` (**Security**) |
| **Redirect after post** (e.g., receipt page) | This file + `agents/gab/GUI_DIALOGS.md` → **MOBILE SCRIPT PATTERNS** |
| **Wireless / transaction storage** schema | `agents/schema/WIRELESS.md` + `agents/schema/MISC.md` (MOBILE_CUSTOM* relationships) |
| **SQL against company data** | `agents/AGENTS.ZEN.md` + `agents/AGENTS.GSSDB.md` |

**Parent router:** Always treat `agents/AGENTS.GAB.md` as the top-level GAB entry — file structure, GUI read/set rules, and the **golden rule** (never invent undocumented GAB APIs) apply to every mobile script.

---

## Cross-references (read for detail; do not duplicate)

| Topic | File |
|-------|------|
| `F.Global.Mobile.*` and `F.Global.Security.*` signatures | `agents/gab/INTEGRATION.md` |
| Mobile HTML result + redirect snippet | `agents/gab/GUI_DIALOGS.md` → `# MOBILE SCRIPT PATTERNS` |
| `V.Caller`, `V.Passed`, mobile transaction id | `agents/gab/VARIABLES.md` |
| Mobile-oriented error return (`SetCustomResult` with HTML) | `agents/gab/CORE.md` → **Mobile Error Pattern** |
| Headless / hook-style scaffolding | `agents/gab/PATTERNS.md` → **Pattern C: Headless Hook** |
| Pitfalls (PassedExists, Try/Catch, SQL, etc.) | `agents/gab/PITFALLS.md` |
| HTTP/REST side integrations from GAB | `agents/gab/API_HTTP.md` |
| WIRELESS_HDR / WIRELESS_LINE column detail | `agents/schema/WIRELESS.md` |
| **WIRELESS_LINE `Field_1`…`Field_25` semantics per `Trans_Type` (standard product)** | **§14** (source: GSS *Wireless-Line Table Guide*, Helpjuice — [wireless-line-table-guide](https://globalshopsolutions.helpjuice.com/GS-Mobile-/wireless-line-table-guide), last published **2026-03-16**) |
| **Writing `WIRELESS_HDR` / `WIRELESS_LINE` (concurrency, `ATTEMPTED_FLAG`, paired A10)** | **§15** (production pattern: **`GAB_7640_Mobile_RollTransferPalletID.g2u`**, Brady Stevens, DRC, **2024-07-29**) |

---

## 1. GS Mobile site architecture (conceptual)

Custom mobile transactions sit in the stack where **GS Mobile** (browser experience) **invokes a GAB program** on the GSS side. The script is responsible for **business logic** and for returning **HTML** (or HTML containing a **client-side redirect**) to the mobile tier.

**Typical flow:**

1. **Mobile UI** — User opens a company-configured **custom transaction** (often tied to wireless / mobile configuration and `MOBILE_CUSTOM_*` metadata — see `agents/schema/MISC.md` relationship notes).
2. **Runtime dispatches GAB** — The site passes context into the script. **`V.Passed.DATA-TRANSID`** is the canonical **mobile transaction id** hook for many mobile programs (see `agents/gab/VARIABLES.md`).
3. **Script reads transaction context** — **Primary (standard custom MobExt / `WIRELESS_LINE`):** Run SQL against **`WIRELESS_LINE`** keyed by **`TRANS_ID = V.Passed.DATA-TRANSID`**, reading **`FIELD_1`…`FIELD_N`** in **`DTLABELS.ORDERNO`** order (see §12.2). Read **`Trans_Type`** from the same row when you need the **custom transaction type** embedded for routing (§6). **Alternative:** **`F.Global.Mobile.GetCustomHeader`** / **`GetCustomLine`** with the **header/line definition strings** from GSS mobile setup — use when the site supplies the payload through those APIs instead of direct table access.
4. **Authentication & authorization** — Validate identity and **function access** with **`F.Global.Security.*`** (see §3).
5. **Processing** — Update/read ERP data via **entity objects**, **CallWrappers**, or **ODBC** per task (same GAB rules as desktop). **Standard custom** scripts often use **two connections**: **company** data (`OpenCompanyConnection` / company DSN) and **common** metadata (`OpenCommonConnection` on a second connection object) for **`MOBILE_CUSTOM_*`**, **`Mobile_Custom_Result`**, etc. — see §12.1.
6. **Response** — **Preferred for large HTML:** Write **`Mobile_Custom_Result`** on the **common** connection (DELETE stale row, then `DataTable.SaveToDB` with **`CoCode`**, **`TXID`**, **`Results`**) — see §4 and §12.3. **Simple / legacy / redirect-only:** Call **`F.Global.Mobile.SetCustomResult`** once with **`sResultData`** as HTML the device renders (including `<script>` redirects, §5). A given transaction may use **one** or **both** mechanisms depending on site behavior; **GAB_7730** moved large picklist HTML to **`Mobile_Custom_Result`** and left earlier **`SetCustomResult`** calls commented.
7. **Optional print path** — Resolve printer with **`GetCustomPrinter`** / **`GetPrinterNameFromId`** when the transaction defines label/receipt printing.

**Custom mobile limits & admin paths (GS Mobile Technical Workshop 2025):**

- **Transaction limit:** Up to **20** custom mobile transactions per company (**R&D-imposed** cap — **per workshop deck — confirm on target site**). GSS standard naming for those **user-defined** mobile forms is **`Trans_Type` = `C01`, `C02`, …** up to **`C20`** (two-digit suffix within the 20-slot cap — **confirm** the exact code each company assigns in mobile admin and in live **`WIRELESS_LINE`** samples).
- **Custom transaction hooks:** Hooks **39001–39020** fire the bound **GAB** program when the operator **submits** the custom mobile form. Assign bindings in **System Support > Administration > GAB Script Hook Maintenance** (workshop).
- **Input field limit:** Each mobile form input field is capped at **30 characters** (workshop).
- **Custom form design admin path:** **System Support > Administration > Company Options (Advanced) > GS Mobile** (workshop).
- **Common project types** (workshop taxonomy): **Query/Lookup**; **Post mobile transaction(s)**; **Write to a custom table**; **Print label**.
- **Returning results:** Use the **`Mobile_Custom_Result`** pattern on the **common** database (§4.1). The workshop deck also names **`Globalcommon.MOBILE_CUSTOM_RESULT` / Globalcommon** phrasing for the same conceptual store — **confirm exact table/column identifiers on the target site**.
- **Result display options** (workshop): show a **pass/fail** (or status) **message**; render an **HTML static table**; and use **expression columns** in the data-table to build **hyperlinks** and **color-code** rows.

**Headless default:** Mobile handler `.g2u` files are usually **headless** (no `ScreenSU` block): entry at **Preflight → Main**, then **`F.Intrinsic.Control.End`**. If the same program must sometimes show a WinForms UI (rare for pure mobile), add **ScreenSU** only when required; the patterns in `agents/gab/GUI.md` still apply.

---

## 2. Transaction lifecycle (checklist)

Use this ordered checklist when implementing or reviewing a custom mobile transaction:

| Step | Action |
|------|--------|
| 1 | **Resolve transaction id** — Prefer `V.Passed.DATA-TRANSID` when present; always **`PassedExists`** before read (`agents/gab/PITFALLS.md`). |
| 2 | **Company context** — Use **`V.Caller.CompanyCode`** for `SetCustomResult`, `GetCustomPrinter`, **and** **`Mobile_Custom_Result.CoCode`**, plus security calls. |
| 3 | **Load mobile payload** — **Standard:** `SELECT Field_1, …, Field_N, Trans_Type FROM WIRELESS_LINE WHERE TRANS_ID = '<V.Passed.DATA-TRANSID>'` (confirm `N` and column names in `agents/schema/WIRELESS.md`). Map **`FIELD_i`** to **`DTLABELS`** rows by **`ORDERNO`** (§12.2). **Alternative:** `GetCustomHeader` / `GetCustomLine` with **configured** definition strings. |
| 4 | **Authenticate** — If the transaction carries credentials or employee id fields, validate with **`ValidateUser`** or resolve **`GetUserId`** then **`CheckUserAccess`** (§3). |
| 5 | **Authorize** — Enforce **function permissions** with known **`iFunctionID`** values from the project — never hardcode undocumented IDs without customer confirmation. |
| 6 | **Process** — Apply ERP rules; use **`V.Caller.User`** and audit columns consistently with other GAB programs. |
| 7 | **Respond** — Build HTML (e.g. **`DataTable.ExportHTML`** for tables, §12.3) → **`Mobile_Custom_Result`** on the **common** connection **or** **`SetCustomResult`** (small pages, redirects, §5) per deployment. |
| 8 | **Fail safe** — On errors, return **HTML safe for mobile** (see §8 and **Mobile Error Pattern** in `CORE.md`), not desktop `Msgbox` alone. |

**Wireless tables:** Persistent shop-floor transaction headers/lines map conceptually to **`WIRELESS_HDR`** / **`WIRELESS_LINE`** (and related label tables). Field-level layout for custom lines often aligns with **`FIELD_1`…`FIELD_25`** on **`WIRELESS_LINE`** — verify every column name in `agents/schema/WIRELESS.md` before SQL.

---

## 3. Authentication & session context

Mobile scripts must not assume a full desktop Global Shop session. Use explicit APIs from **`agents/gab/INTEGRATION.md`**.

### 3.1 Credential validation

```
F.Global.Security.ValidateUser(sUsername,sPassword,bResult)
```

- **`bResult`** = True when credentials are valid for Global Shop.
- **Do not** embed plaintext passwords in `SetCustomResult` HTML or logs.

### 3.2 Identity resolution

```
F.Global.Security.GetUserId(sUsername,sResult)
F.Global.Security.GetFullName(sUserID,sResult)
F.Global.Security.GetUserNameFromId(sUserID,sResult)
```

Use these after a successful `ValidateUser` or when the mobile payload supplies a **trusted username** per customer integration rules.

### 3.3 Permission checks

```
F.Global.Security.CheckUserAccess(sUserID,iFunctionID,bResult)
F.Global.Security.CheckUserFunctionPermission(sUserID,iFunctionID,iPermissionID,bResult)
F.Global.Security.CheckUserFunctionFeatureToggle(sUserID,iFeatureID,bResult)
```

- Obtain **`iFunctionID`** / feature IDs from **GSS security documentation** or the implementing analyst — **do not invent IDs**.
- **`V.Caller.User`** may reflect the executing context when the mobile host runs the script under a service user; **do not blindly treat it as the shop-floor badge holder** unless the integration spec says so. Prefer **explicit validation** tied to scanned employee or mobile login when required.

### 3.4 “Session management” (practical guidance)

This kit does **not** document a separate mobile session object in GAB. **Session behavior is owned by GS Mobile / IIS / application configuration.** In GAB:

- Treat each script run as a **stateless request** completed by **`SetCustomResult`**, by **`Mobile_Custom_Result`** (host reads persisted HTML), or by both—depending on site configuration.
- Persist durable state in **ERP tables** or approved **registry** patterns (`F.Global.Registry.*` in `INTEGRATION.md`) — not in static globals across unrelated launches.

### 3.5 Custom transaction hook IDs (39001–39020)

GS Mobile reserves **20** hook IDs for **custom mobile transaction** submit handling:

| Hook range | When it runs |
|------------|----------------|
| **39001 – 39020** | **After submit:** executes the **`.g2u`** program bound to that hook when the operator submits the **custom mobile** form (workshop). |

**Binding:** Map each active custom mobile project to a hook in this range via **System Support > Administration > GAB Script Hook Maintenance** (workshop).

**Contrast — standard wireless (WIR200):** Inventory and shipping “standard” mobile posts use **different** pre/post/report hooks (e.g., **31908** for **A10** stand-alone issue/receipt — Avery **T-Card**). See **§13** for the workshop’s **WIR200** ID table.

---

## 4. `F.Global.Mobile.*` API surface (canonical)

Use **`agents/gab/INTEGRATION.md`** as the source of truth. Summarized here for routing convenience only:

```
F.Global.Mobile.GetCustomHeader(sTransID,sResult)
F.Global.Mobile.GetCustomLine(sTransID,sResult)
F.Global.Mobile.GetCustomPrinter(sCompanyCode,sTransID,sResult)
F.Global.Mobile.SetCustomResult(sCompanyCode,sTransID,sResultData)
F.Global.Mobile.GetPrinterNameFromId(iPrinterID,sResult)
```

**Semantics:**

- **`GetCustomHeader(sTransID, sResult)`** -- Returns **header info** from `WIRELESS_HDR` for the passed `TRANS_ID`. The result string contains **`Trans_Type*!*Successful_Flag*!*Attempted_Flag`** (three values delimited by `*!*`). If no connection name is specified, defaults to the `WIRELESS_HDR` table of the **company code** calling the script. Use `F.Intrinsic.String.Split(sResult,"*!*",sResult)` to parse into an array.
- **`GetCustomLine(sTransID, sResult)`** -- Returns **all field values** from `WIRELESS_LINE` for the passed `TRANS_ID`, separated by `*!*`. If no connection name is specified, defaults to the `WIRELESS_LINE` table of the company code calling the script. The field order matches `Field_1*!*Field_2*!*...Field_25` (verify field count against the transaction type's layout in section 14).
- **`SetCustomResult`** — **`sResultData`** is **`HTML`** returned to GS Mobile for the current operation. This may be simple markup or a full page fragment; embedded **`<script>`** may perform a **redirect** (§5).
- **`GetCustomPrinter(sTransID, sResult)`** — Returns **`DefaultPrinterID*!*LabelPrinterID`** (two values delimited by `*!*`). Index `0` = default/laser printer, index `1` = label printer. Split with `F.Intrinsic.String.Split(sResult,"*!*",sResult)` then resolve each ID to a printer name with `GetPrinterNameFromId`. Verified from 7563 (which uses both indices) and 7640 (which uses index 1).
- **`GetPrinterNameFromId(iPrinterID, sResult)`** — Converts a printer ID (from `GetCustomPrinter`) to a printer name string. For Sentinel-enabled environments, query `SERVER_PRINTERS` on the common connection for `SENTINELALIAS` if it exists (7563 pattern).

### 4.1 `Mobile_Custom_Result` table (large HTML — standard custom pattern)

Production scripts such as **`GAB_7730_Mobile_MatlPicklist.g2u`** deliver **large** mobile-safe HTML through the **`Mobile_Custom_Result`** table on the **common** database (second ODBC connection — e.g. **`F.ODBC.Connection!conC.OpenCommonConnection`** alongside **`OpenCompanyConnection`** on **`Con`**).

**Pattern (observed):**

1. `DELETE FROM Mobile_Custom_Result WHERE cocode = '<V.Caller.CompanyCode>' AND txid = '<mobile trans id>'`
2. Build a one-row **`DataTable`** with columns **`CoCode`**, **`TXID`**, **`Results`** (HTML string).
3. `F.Data.DataTable.SaveToDB("dtResult","conC","Mobile_Custom_Result","","128","CoCode@!@CoCode*!*TXID@!@TXID*!*Results@!@Results")`

**Semantics:**

- **`TXID`** correlates with the **mobile transaction id** passed as **`V.Passed.DATA-TRANSID`** for the current operation (same string the site uses when fetching results).
- **`Results`** holds the full HTML fragment; **`DataTable.ExportHTML`** is a practical way to emit **mobile-friendly** `<table>` markup from in-memory grids (stylesheet token e.g. **`t01`**, last arg = output string).
- Some deployments may still call **`SetCustomResult`** after writing the table, or rely on **`SHOW_RESULTS`** + table read alone — **verify on the target GS Mobile build** (7730 comments show prior **`SetCustomResult`** calls fully disabled).

> **Note:** Older internal excerpts in `agents/gab/API_MISC.md` / `API_AUTOMATION.md` may show partial or alternate overload sketches for some mobile helpers. **Prefer `INTEGRATION.md` signatures** and verify on-target if the compiler rejects an overload.

---

## 5. Redirect GAB script pattern (T-Card receipt / receipt-after-post style)

### 5.1 What “redirect” means here

GS Mobile renders the **`SetCustomResult`** HTML in its page host. If that HTML includes a **client-side navigation** (e.g., `window.location.href = ...`), the **browser** moves to another mobile URL — for example a **receipt** view, another **Custom.aspx** entry with a new `sTXID`, or a standard mobile page.

This matches the documented skeleton in `agents/gab/GUI_DIALOGS.md`:

```
' Redirect to another mobile page (example fragment — adjust URL and parameters per site)
F.Intrinsic.String.Build("<script type='text/javascript'> window.location.href ='Custom.aspx?sTXID={0}'; </script>",V.Global.iTXID,V.Local.sMobileResult)
F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Passed.DATA-TRANSID,V.Local.sMobileResult)
```

**Fixed URL (no `{0}`):** Some deployments build a **constant** `window.location.href` (relative path to an `.aspx`) and still pass **`V.Passed.DATA-TRANSID`** as the second argument to **`String.Build`** for API symmetry even when the template **omits placeholders** — the trans id affects **`SetCustomResult`** only. **Avery’s** canonical redirect is an example: **§11.8**.

### 5.2 T-Card receipt context (manufacturing)

A **T-Card** (traveler card) ties to **work order routing** or **shop-floor receipt** flows. Implementations split into two families:

1. **GAB-centric custom transaction** — GS Mobile invokes a `.g2u` program; the script uses `F.Global.Mobile.*`, `V.Passed.DATA-TRANSID`, direct **`WIRELESS_LINE`** reads for MobExt-driven **`FIELD_1…N`**, and either **`SetCustomResult`** HTML (optional JS redirect) **or** **`Mobile_Custom_Result`** for large grids (§4.1, §12). §5.1 and §9 emphasize **`GetCustom*` + `SetCustomResult`**; §12 documents the **picklist-style** evolution.
2. **Site-hosted ASP.NET page** (customer-specific) — A page under the wireless/mobile site uses **ODBC** (or ADO) to read/write company data and **inserts A10 (or other) rows directly into `WIRELESS_HDR` / `WIRELESS_LINE`**. The **GAB mobile APIs are not used** for the primary submit path; processing is completed by the normal wireless/GAB post pipeline (e.g., site hooks). See **§11 Avery T-Card (reference ZIP)** for a real example.

**Generic GAB responsibility** (when the transaction *is* a custom mobile GAB program — validate per implementation):

| Phase | GAB responsibility |
|-------|-------------------|
| **Validate scan** | Parse `WIRELESS_LINE.FIELD_i` (MobExt **`ORDERNO`**) **or** `GetCustomLine` fields for job/suffix/seq — mapping is customer-specific. |
| **Authorize** | `CheckUserAccess` for the manufacturing/mobile function. |
| **Post receipt** | Use **entity objects** or **manufacturing CallWrappers** / SQL per approved design (`agents/gab/CALLWRAPPERS.md`, `agents/gab/CW_MANUFACTURING.md` if loaded). |
| **Respond** | Either **inline HTML receipt** (qty, operation, timestamp) or **redirect** to a receipt route that reloads header/line via a new transaction id. |

If GS Mobile provides the **next TXID** in a header field after posting, use that in the redirect URL — **do not assume** without evidence.

**Avery (site-specific):** The analyzed **Tcard.zip** reference is pattern **(2)** for the **receipt submit** (ASP.NET → ODBC → `WIRELESS_*` A10). Separately, Avery deploys a **minimal headless redirect `.g2u`** (`GAB_XXXX_TCardReceiptRedirect.g2u`, **XXXX** = project/feature number) that returns **`SetCustomResult` HTML** containing a **`<script>`** with **`window.location.href`** to **`../TCardReceipt/TCardReceipt.aspx`** — the canonical source is captured in **§11.8**. Do not assume “T-Card at Avery” is only ASP.NET or only one `.g2u`; the **entry** from a custom mobile transaction can be this redirect stub while **processing** remains in the ASP.NET page.

### 5.3 Header / line / result data flow

```
Mobile host
   │ passes TRANSID via V.Passed.DATA-TRANSID (when applicable)
   ▼
GAB Main
   ├─► WIRELESS_LINE query (Field_1…Field_N, Trans_Type) by TRANS_ID ──┐
   ├─► OR GetCustomHeader / GetCustomLine(defFromConfig, …)           ─┼─► Parse per MobExt ORDERNO / analyst map
   ├─► Business logic + Security APIs                                 ─┤
   ├─► (optional) GetCustomPrinter / printer                          ─┤
   ├─► DELETE + INSERT Mobile_Custom_Result (common connection)        ─┤
   └─► SetCustomResult(Company, TRANSID, HTML) — when used (§4)     ─┘
```

**HTML outcomes**

| Outcome | Typical `sResultData` |
|---------|---------------------|
| Success detail | HTML table / div with receipt fields |
| Validation error | Short HTML message + safe styling |
| Navigation | Minimal HTML wrapping `window.location.href = '...'` |
| Unhandled fault | HTML error block (Mobile Error Pattern) |

### 5.4 Standard custom mobile URL patterns (`Custom.aspx`, `CustomResults.aspx`, GSS inventory pages)

Reference (**`GAB_7730_Mobile_MatlPicklist.g2u`**): multi-step flows build **relative** links inside HTML so the device can move between the **custom form**, **custom results**, and **standard** Global Shop mobile pages. Encode parameter values with **`F.Intrinsic.String.MakeURLFriendly`** when placing **paths or query fragments** into **`sReturnpath`**-style parameters.

| Route | Typical shape | Role |
|-------|---------------|------|
| **`Custom.aspx`** | `Custom.aspx?sTXID=<iCustomTransID>&field1=<url-friendly JOB>-<suffix>&…` | Return to **same** custom transaction form with **scanned/default field** values (`field1`, additional `Field2`… as designed). |
| **`CustomResults.aspx`** | `CustomResults.aspx?sTXID=<iCustomTransID>&sTransID=<TRANS_ID>&sReturnpath=<encoded return>` | **Drill-down** / secondary result view tied to a **child** wireless trans id (`sTransID`) and a **stack-safe return** URL. Case in source may be `Customresults.aspx`; follow the site’s existing pages. |
| **`IssuesFromInvtoWO.aspx`** | `<page>?sJob=<job>&sSuffix=<suffix>&sSeq=<seq>&sReturnpath=<encoded>[&sLot=…&sBin=…]` | **Issue from inventory** (standard mobile page). |
| **`IssuesFromInvtoWOL.aspx`** | Same query pattern | **Lot / SmartTrack** variant when company option enables it (7730 swaps **`Page`** column by option). |

**URL pre-fill / deep links (product patch):** Standard and **`Custom.aspx`** pages can honor **query-string** parameters (workshop baseline **12/16/2024**) — see **§5.5**.

**`sTXID` vs MobExt `TID`:** The query string **`sTXID`** must match the **`iCustomTransID`** the site expects for that **custom transaction menu** entry. In 7730, **`iCustomTransID`** is derived from **`WIRELESS_LINE.Trans_Type`** (§6), not copied blindly from **`DTTRANS.TID`**.

### 5.5 URL passed parameter support (12/16/2024 patch — workshop baseline)

**Source:** GS Mobile Technical Workshop 2025 — cites a **12/16/2024** product patch. **Per workshop deck — confirm** parameter names, casing, and page support on the **installed** GS Mobile build.

**Standard mobile `.aspx` pages** can accept **query-string** arguments that **pre-populate** the screen. Workshop example:

```
http://localhost/mobile/Pages/BinToBinTransfer.aspx?sPart=0025&sFromBin=1000&iQty=1
```

**`BinToBinTransfer.aspx` (and by-Lot variant) -- supported parameters:**

| Parameter | Description |
|-----------|-------------|
| `sUPC` | Scan UPC/UCC/Pallet |
| `sPart` | Part |
| `sFromLoc` | From Location |
| `sToLoc` | To Location |
| `iQty` | Quantity |
| `sFromBin` | From Bin |
| `sToBin` | To Bin |
| `sFromLot` | Lot |
| `sToLot` | To Lot |
| `sFromHeat` | Heat |
| `sToHeat` | To Heat |
| `sFromSerial` | From Serial |
| `sToSerial` | To Serial |
| `sRef` | Reference |

**`Custom.aspx` (custom form) — workshop conventions:**

| Control kinds | Query-string pattern (workshop) |
|---------------|----------------------------------|
| Text box / dropdown / label | `Field1=value` style pairs (the deck also shows lowercase `field1` in the **autosubmit** example — **normalize per target site**) |
| Checkbox | `Field2=true` (boolean pre-check pattern shown in deck) |

**`sReturnpath` on [Submit]** (workshop): Supported return targets for chained navigation include the **custom form**, **standard mobile PO receipts / by Lot**, **Bin to bin / by Lot**, **Issue to WO / by Lot**, and **Shipping / by Lot** — **verify** return-stack behavior on-site when upgrading.

**Autosubmit (NOT YET AVAILABLE -- future release, date TBD):** Workshop example: `Custom.aspx?sTXID=2&field1=000253-000&autosubmit=true` -- would auto-fill from parameters **and** submit automatically. **Do not implement or rely on `autosubmit`** -- the workshop deck explicitly marks this as a future release yet to be determined. Re-evaluate when GSS publishes a patch that includes it.

**Implementation note:** When emitting links from GAB, keep using **`F.Intrinsic.String.MakeURLFriendly`** for dynamic path/field segments (§5.4).

---

## 6. `V.Passed` and mobile variables

From `agents/gab/VARIABLES.md`:

```
V.Passed.DATA-TRANSID          ' Mobile transaction ID (when passed)
```

**`WIRELESS_LINE.Trans_Type` and `iCustomTransID` (standard custom):**

On **`WIRELESS_LINE`**, **`Trans_Type`** carries a **wireless / custom type** string whose **characters 2–3 (1-based)** are the **numeric custom transaction id** used in **`Custom.aspx?sTXID=`** / **`CustomResults.aspx?sTXID=`**.

**Observed in `GAB_7730_Mobile_MatlPicklist.g2u`:** after reading **`Trans_Type`** into **`sTransType`**, the script calls **`F.Intrinsic.String.Mid(sTransType, 2, 2, iCustomTransID)`** so **`iCustomTransID`** is a **`Long`** (two-character slice, parsed/Assignment into long — not a separate `Val()` call in source). **Confirm** the slice rule for other transaction families; do not assume all **`Trans_Type`** values follow the same layout.

**`Trans_Type` naming — standard vs custom (GSS product):**

- **Standard GS Mobile transactions** (shipped ASP.NET wireless pages) use **alphanumeric** codes such as **`P16`**, **`P19`**, **`O90`**, **`BSR`**, **`P10`**, **`J10`**, **`J55`**, **`S10`**, **`S15`**, **`S20`**, **`S30`**, **`S40`**, **`S50`**, **`CP1`**, **`CP2`**, **`L10`**, **`T10`**, **`A10`**, etc. For these, **§14** is the authoritative map from each code to **`WIRELESS_LINE.Field_N`** meaning.
- **Custom transactions** are **`C01`, `C02`, …** (and up to **`C20`** within the **20** custom-transaction cap in §1). The mobile host builds the operator form from **database-driven** labels and control metadata; submitted values still land on **`WIRELESS_LINE`** like any other wireless line — but **field meanings are defined by that company’s MobExt / DTLABELS mapping**, not by §14.

**Rules:**

- **`F.Intrinsic.Variable.PassedExists("DATA-TRANSID", bResult)`** before every read.
- Store the trans id in a **`V.Global.sTransID`** (string) or **`V.Global.iTXID`** / **`iCustomTransID`** (long) **only after parsing** — match the datatype the redirect URL expects.
- **`V.Caller.WirelessASPDir`** may matter when constructing ASP paths; combine with site-relative URLs only per deployment standards.

---

## 7. Task recipes (bundles)

| Task | Load these files | Cross-load |
|------|------------------|------------|
| **New headless mobile custom transaction** | `agents/gab/CORE.md`, `agents/gab/INTEGRATION.md`, `agents/gab/VARIABLES.md`, `agents/gab/GUI_DIALOGS.md` (Mobile section), `agents/gab/PATTERNS.md` (Pattern C), `agents/gab/PITFALLS.md` | — |
| **Mobile + SQL / schema** | Above + `agents/AGENTS.ZEN.md`, `agents/AGENTS.GSSDB.md`, relevant `agents/schema/*.md` | `schema/WIRELESS.md` for FIELD_* lines |
| **Mobile + manufacturing / T-Card** | Above + `agents/gab/CALLWRAPPERS.md` → `CW_MANUFACTURING.md` (or entity objects from `INTEGRATION.md`) | Job/operation tables via `AGENTS.GSSDB.md`; Avery T-Card **ASP.NET + A10** pattern: §11 |
| **Avery-style T-Card (ASP.NET, ODBC → WIRELESS_*)** | This file §11 + `agents/schema/WIRELESS.md` + `agents/AGENTS.ZEN.md` + `agents/AGENTS.GSSDB.md` | **Submit** is ASP.NET → `WIRELESS_*`; **mobile entry** may use redirect `.g2u` `SetCustomResult` (§11.8) |
| **Mobile + REST integration** | Mobile bundle + `agents/gab/API_HTTP.md`, `agents/gab/DATA_MISC.md` (JSON/XML as needed) | — |
| **Standard custom mobile (MobExt, `WIRELESS_LINE`, `Mobile_Custom_Result`)** | This file **§12** + bundles above | **§11.11** MobExt XML; **`GAB_7730`** reference script; **`TransIDX`** drill-down (**§12.8**) |
| **Custom mobile via URL parameters / deep links (`Custom.aspx`, standard pages)** | This file **§5.5** + **§5.4** + mobile URL escape rules in **`PITFALLS.md`** (if any) | Workshop cites **12/16/24** patch; **confirm** query keys and casing on site |
| **Round-trip custom mobile (linked transactions, e.g. picklist ↔ RTS)** | This file **§12.10** + **§5.4** / **§5.5** + **§12.5** (optional analyst table) | **ARC 7730** **Custom Material Picklist Maintenance** can map **another custom mobile** for return legs — **per workshop deck — confirm** on site |

Always load **`PITFALLS.md`** when writing new subroutines or error handling.

---

## 8. Anti-patterns (mobile-specific)

Add these to the general rules in `agents/gab/PITFALLS.md` and `agents/AGENTS.GAB.md`:

| Do not | Why |
|--------|-----|
| **Ship neither `SetCustomResult` nor `Mobile_Custom_Result` on a completion path** | Mobile page waits for **some** published result; blank or hung UI. **Table-only** flows are valid when the host reads **`Mobile_Custom_Result`** and **`SHOW_RESULTS`** is set appropriately — confirm on site. |
| **Use `Msgbox` as the only error path** | Desktop dialogs may not be appropriate for GS Mobile — return HTML via `SetCustomResult` (and/or **Mobile Error Pattern**). |
| **Read `V.Passed` without `PassedExists`** | Undefined data on alternate launch paths. |
| **Guess `sHeaderDef` / `sLineDef` strings** | Must match GSS mobile configuration. |
| **Guess `iFunctionID` for `CheckUserAccess`** | Security holes or false denials. |
| **Emit raw DB or stack traces to mobile HTML** | Security and UX failure. |
| **Assume T-Card field order** | Parse per documented transaction mapping or working sample from the customer environment. |
| **Assume `GetCustom*` is the only way to read MobExt fields** | **Standard:** `WIRELESS_LINE.FIELD_i` indexed by **`DTLABELS.ORDERNO`** (§12.2). |
| **Zip a `.g2u` without signing first** | **Always** sign in the GAB editor to produce a current `.g2u.sig` **before** creating the MobExt ZIP. An unsigned or stale-signed script will fail at runtime. |
| **Nested `Try` in one subroutine** | See `PITFALLS.md` — use `SetErrorHandler` + targeted `Try/Catch` only when needed. |
| **Trust `V.Caller.User` as operator** | Unless integration spec guarantees it matches the shop-floor user. |
| **INSERT into `WIRELESS_HDR` without retry / collision handling** | **Actian Zen/Btrieve** can raise **duplicate key (Error 5)** when concurrent mobile work picks the same next **`TRANS_ID`**. Use **Try/Catch** inside **`DoUntil`**, re-querying **`TRANS_ID`** each attempt — **§15**. |
| **INSERT into `WIRELESS_LINE` without audit columns** | Every `WIRELESS_LINE` insert **must** include **`DATE_LAST_CHG`**, **`TIME_LAST_CHG`**, and **`LAST_CHG_BY`**. Omitting them leaves rows without traceability. Derive date/time per **§15.4**; set `LAST_CHG_BY` to the mobile operator's `USER_ID`. |
| **INSERT into `MOBILE_CUSTOM_RESULT` without DELETE first** | Always `DELETE FROM MOBILE_CUSTOM_RESULT WHERE COCODE=... AND TXID=...` before inserting. Stale results from a prior submit will display outdated or misleading data to the operator — **§15.6**. |

---

## 9. Complete reference pattern — custom mobile transaction (headless)

**Purpose:** Single-file template combining **Passed guards**, **security checks**, **GetCustomHeader / GetCustomLine**, **business stub**, **HTML success**, **optional redirect**, and **mobile-aware error handling**. Replace the **string literals** for header/line defs, the **parsing** of `sUser`/`sPass`, and the **`iFunctionID`** literal after confirming them from GSS mobile + security configuration.

```
Program.Sub.Preflight.Start
V.Global.bError.Declare(Boolean,False)
V.Global.sTransID.Declare(String,"")
V.Global.sMobileHtml.Declare(String,"")
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.bExists.Declare(Boolean,False)
V.Local.bValidPw.Declare(Boolean,False)
V.Local.bAllowed.Declare(Boolean,False)
V.Local.sUserId.Declare(String,"")
V.Local.sHeader.Declare(String,"")
V.Local.sLine.Declare(String,"")
V.Local.sUser.Declare(String,"")
V.Local.sPass.Declare(String,"")
V.Local.iFunctionID.Declare(Long,0)

'-- 1. Transaction id from mobile host (canonical name per VARIABLES.md)
F.Intrinsic.Variable.PassedExists("DATA-TRANSID",V.Local.bExists)
F.Intrinsic.Control.If(V.Local.bExists.Not)
    V.Global.sMobileHtml.Set("<html><body><p>Missing mobile transaction id (DATA-TRANSID).</p></body></html>")
    F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,"",V.Global.sMobileHtml)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf

V.Global.sTransID.Set(V.Passed.DATA-TRANSID)

'-- 2. Load configured header/line packs (replace def strings with values from GSS mobile transaction setup)
F.Global.Mobile.GetCustomHeader("",V.Local.sHeader)
F.Global.Mobile.GetCustomLine("",V.Local.sLine)

'-- 3. Map credentials or identity from sHeader/sLine (implement ParseMobileIdentity or use field map from analyst)
V.Local.sUser.Set("")
V.Local.sPass.Set("")
F.Intrinsic.Control.CallSub(ParseMobileIdentity)

'-- 4. Authenticate (skip or adapt if mobile tier already enforced identity)
F.Global.Security.ValidateUser(V.Local.sUser,V.Local.sPass,V.Local.bValidPw)
F.Intrinsic.Control.If(V.Local.bValidPw,=,False)
    V.Global.sMobileHtml.Set("<html><body><p>Sign-in failed.</p></body></html>")
    F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,V.Global.sMobileHtml)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf

F.Global.Security.GetUserId(V.Local.sUser,V.Local.sUserId)

'-- 5. Authorize — set iFunctionID to the real GSS function id (0 is invalid placeholder)
V.Local.iFunctionID.Set(0)
F.Global.Security.CheckUserAccess(V.Local.sUserId,V.Local.iFunctionID,V.Local.bAllowed)
F.Intrinsic.Control.If(V.Local.bAllowed,=,False)
    V.Global.sMobileHtml.Set("<html><body><p>Not authorized for this function.</p></body></html>")
    F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,V.Global.sMobileHtml)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf

'-- 6. Business logic — ODBC / entity / CallWrapper (unique connection names; self-contained open/close)
' F.Intrinsic.Control.CallSub(ProcessMobileTransaction)

'-- 7a. Inline HTML result (receipt-style example)
F.Intrinsic.String.Build("<html><body><h3>Receipt</h3><p>Transaction {0} completed.</p><p>Header:{1}</p><p>Line:{2}</p></body></html>",V.Global.sTransID,V.Local.sHeader,V.Local.sLine,V.Global.sMobileHtml)

'-- 7b. OR redirect pattern — swap for 7a when product requires navigation (set base URL from deployment spec)
' F.Intrinsic.String.Build("<html><body><script type='text/javascript'>window.location.href='Custom.aspx?sTXID={0}';</script></body></html>",V.Global.sTransID,V.Global.sMobileHtml)

F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,V.Global.sMobileHtml)

F.Intrinsic.Control.End

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(CatchingMobile)
    F.Intrinsic.Control.End
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.CatchingMobile.Start
F.Intrinsic.Control.SetErrorHandler("CatchingMobile_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String)
F.Intrinsic.String.Build("PROJECT:{1}{0}{1}{1}SUBROUTINE:{1}{2}{1}{1}ERROR DESCRIPTION:{1}{3}{1}{1}ON LINE:{1}{4}",V.Caller.ScriptFile,"<br />",V.Ambient.SubroutineCalledFrom,V.Ambient.ErrorDescription,V.Ambient.ErrorLine,V.Local.sError)
F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,V.Local.sError)

F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("CatchingMobile_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    '-- Last resort: avoid recursion; minimal HTML
    F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,"<html><body><p>Unhandled error in mobile handler.</p></body></html>")
F.Intrinsic.Control.EndIf
Program.Sub.CatchingMobile.End

Program.Sub.ParseMobileIdentity.Start
F.Intrinsic.Control.SetErrorHandler("ParseMobileIdentity_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
'-- Parse V.Local.sHeader / V.Local.sLine into V.Local.sUser and V.Local.sPass (or set sUser from trusted mobile session per integration spec)

F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.Label("ParseMobileIdentity_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.Control.CallSub(CatchingMobile)
F.Intrinsic.Control.EndIf
Program.Sub.ParseMobileIdentity.End
```

**Template notes:**

- **Empty `GetCustomHeader` / `GetCustomLine` def args** — replace `""` with the real definition strings from GSS mobile configuration before deployment.
- **`V.Local.iFunctionID.Set(0)`** — replace `0` with the documented function id; **0 is a non-functional placeholder**.
- **Branches `7a` vs `7b`** are **mutually exclusive** — ship only one outcome path per version.
- Prefer **`SetErrorHandler`** for subroutine structure; keep **`Try/Catch`** scoped as in `agents/gab/PITFALLS.md` if used inside inner subs.

---

## 10. Assumptions & gaps (explicit)

This sub-agent is honest about kit limitations:

| Topic | Status in this repository |
|-------|---------------------------|
| Exact **“T-Card receipt”** GS Mobile URL sequence | **Varies by customer** — GAB HTML redirect vs dedicated `.aspx` (see §11; **Avery:** redirect `.g2u` + `TCardReceipt.aspx`, §11.8). |
|| **`GetCustomHeader` / `GetCustomLine` delimiter & field order** | **RESOLVED** -- `GetCustomHeader` returns `Trans_Type*!*Successful_Flag*!*Attempted_Flag` from `WIRELESS_HDR`; `GetCustomLine` returns `Field_1*!*Field_2*!*...Field_25` from `WIRELESS_LINE`. See section 4. |
| **`Trans_Type` → `iCustomTransID` rule** | **Verified only for the analyzed 7730 layout** (§6); re-validate for other wireless types. |
| **`GAB_7730` outer `Try/Catch`** | **Observed** outer **`Main`** uses **`Msgbox`** on fault — **not** ideal for GS Mobile; prefer **`CatchingMobile`**-style HTML (§9) for production mobile. |
| **Whether `Msgbox` appears on GS Mobile** | **Prefer HTML responses**; treat `Msgbox` as desktop-oriented unless proven otherwise. |
| **All `V.Passed` fields for every mobile hook** | **Hook-specific** — see `agents/gab/HOOKS.md` / customer binding docs. |

When any of the above is required for a correct implementation, **ask the user or implementation lead** rather than inventing values.

---

## 11. Avery T-Card receipt (reference implementation — ASP.NET + compiled DLL + wireless staging)

The Avery reference package (`Tcard.zip`, extracted for analysis) documents a **production-ready T-Card mobile receipt** whose **UI + ODBC + A10 insert + audit polling** ship as **ASP.NET** — the ZIP **does not** include that page as a `.g2u` / `.lib`. The README states it is **based on** `GAB_5611_Mobile_CustSupp_Receipt.g2u` (that GAB source is **not** in the ZIP). In **deployed** Global environments, a **separate** minimal **`GAB_XXXX_TCardReceiptRedirect.g2u`** (§11.8) hands GS Mobile off to `TCardReceipt.aspx` via **`SetCustomResult`**. Treat the ZIP as the **authoritative ASP.NET pattern** and §11.8 as the **authoritative redirect stub** unless superseded by a newer repo. **Avery-only file drop targets** (`WirelessASPX\…`, `PLUGINS\GAB\GAS\`) and a **deploy checklist** are in **§11.9** — do not treat those paths as generic GS Mobile standards.

**CRITICAL — DLL compilation rule:** All Avery custom mobile transactions **MUST** compile business logic into a **.NET Framework 4.6.2 DLL** (e.g., `Avery.dll`). **Never** deploy raw `.aspx.cs` code-behind files to the client. The `.aspx` markup page is deployed (it contains no business logic), and the compiled DLL goes into the `bin\` subfolder under the transaction's `WirelessASPX` folder. This protects Avery's intellectual property on the customer's server. See **§11.10** for the DLL project structure and build rules.

### 11.1 Architecture vs generic mobile doc

| Aspect | Generic assumption (§1–§5) | Avery reference ZIP |
|--------|---------------------------|---------------------|
| Entry technology | Headless GAB, `F.Global.Mobile.*` | **Primary UI:** ASP.NET `.aspx` markup + **compiled `Avery.dll`** in `bin\` (no `.aspx.cs` deployed — §11.10). **Optional mobile entry:** headless **`GAB_XXXX_TCardReceiptRedirect.g2u`** → `SetCustomResult` → JS to `.aspx` (§11.8) |
| Submit path | `SetCustomResult(… HTML …)` | **`INSERT` into `WIRELESS_LINE` + `WIRELESS_HDR`** (`TRANS_TYPE = 'A10'`) via ODBC from compiled DLL |
| Transaction id | Often `V.Passed.DATA-TRANSID` | **Generated in C#**: max `WIRELESS_HDR.TRANS_ID` + 1, **9-digit zero-padded** string |
| Redirect / navigation | HTML/JS from GAB | **Mobile entry:** small headless **redirect `.g2u`** uses **`SetCustomResult`** + **`window.location.href`** to `TCardReceipt.aspx` (§11.8). **Inside the ASP.NET flow:** session timeout → `Response.Redirect("../Index.aspx")`; success UX uses **polling**, not an extra receipt `window.location` |
| Identity | `F.Global.Security.ValidateUser` etc. | **ASP.NET `Session`** — `UserID` (default `MOBILE_USER`), `DefaultPrinter`, `LabelPrinter`, company keys (`CCC`, `Company`, …) |
| “Receipt” feedback | Inline HTML or redirect URL | **Step 1 → Step 2 → back to Step 1** with **client-side polling** of the **same** `.aspx` |

**Takeaway:** Avery’s **receipt work** is a **custom mobile ASP.NET page** that **feeds the standard wireless queue** (A10). A **companion redirect `.g2u`** (§11.8) **does** use **`SetCustomResult`** purely to hand off the browser to that page. Downstream processing, audit rows, and any **GAB hook** (their deploy notes mention post-process hook **31908**) are still part of the overall system.

### 11.2 Data sources and validation ( ODBC / Zen )

Production T-Card master data is staged in a customer table; inventory and history use standard GSS objects:

| Table / view | Role |
|--------------|------|
| `T_CARD_DATA` | **Bridge** from production (e.g., Glovia / ILS): `TCTCRD`, `TCWHSE`, `TCITEM`, `TCQTY`, `TCUOM`, … |
| `V_INVENTORY_MSTR` | **Exists** check for `PART` + `LOCATION` (`PART` = 17-char part + optional 3-char rev from `TCITEM`) |
| `INVENTORY_MST3` | **UOM → EA** factors: `PCS_PER_CNTNR`, `CNTNRS_PER_PALLET`, `CARTON_BAG_qTY` |
| `ITEM_HISTORY` | **Duplicate receipt** guard: `REFERENCE = 'TC#' \|\| T-CardNumber` |
| `WIRELESS_LINE` / `WIRELESS_HDR` | **A10 line + header** insert (staging for GSS wireless engine) |
| `WL_AUDIT_LOG` | **Async status**: `STATUS_FLAG`, `DESCR` for `TRANS_ID` (success = `'S'`) |

**Part parsing from `TCITEM`:** first **17** characters = base part; characters **18–20** = revision (if length ≥ 20). Inventory validation concatenates part + rev for `V_INVENTORY_MSTR.PART` when rev present.

**UOM conversion (verified qty is in T-Card UOM, line qty is EA):** `CA` / `CASE` → × `PCS_PER_CNTNR`; `PALLET` → × `CNTNRS_PER_PALLET` × `PCS_PER_CNTNR`; `BAG` → × `CARTON_BAG_qTY` × `PCS_PER_CNTNR`; `EA` → unchanged. Mismatch or missing factors **block** the insert.

### 11.3 A10 field mapping (template)

**Cross-reference — standard `A10` layout:** **§14** records the **authoritative** GSS **`A10`** `Field_1`…`Field_15` meanings from the *Wireless-Line Table Guide* (Helpjuice, last published **2026-03-16**). Use it to compare Avery’s **`FIELD_*`** population—especially **`FIELD_12`–`FIELD_15`** (GL / cost flags in the product mapping)—against this customer’s **`FIELD_1`–`FIELD_11`** insert pattern below.

Values below are the **reference** mapping from the Avery code; replace literals with project-specific rules where needed.

**`WIRELESS_LINE` (one line, `SEQ = '0000'`):**

| Column | Reference meaning |
|--------|-------------------|
| `TRANS_ID` | Generated id |
| `SEQ` | `'0000'` |
| `TRANS_TYPE` | `'A10'` |
| `FIELD_1` | Part (17-char base) |
| `FIELD_2` | Revision (3-char or empty) |
| `FIELD_3` | Warehouse / location (`TCWHSE`) |
| `FIELD_4` | Quantity **EA**, format `0.0000` |
| `FIELD_5` | Reference string `'TC#'` + T-Card number |
| `FIELD_6` | Lot = T-Card number |
| `FIELD_7` | Bin = `'RECV'` |
| `FIELD_8` | Heat — empty |
| `FIELD_9` | Serial — empty |
| `FIELD_10` | `'Receipt'` |
| `FIELD_11` | `'N'` |
| `ERROR_ID` | `0` |

**`WIRELESS_HDR`:**

| Column | Reference meaning |
|--------|-------------------|
| `TRANS_ID` | Same as line |
| `TRANS_TYPE` | `'A10'` |
| `ATTEMPTED_DATE` / `ATTEMPTED_TIME` | `'00000000'` (placeholder) |
| `DEFAULT_PRINTER` | `Session["DefaultPrinter"]` or `""` |
| `LABEL_PRINTER` | `Session["LabelPrinter"]` or `""` |
| `USER_ID` | `Session["UserID"]` or `'MOBILE_USER'` |
| `BATCH` | `0` |

### 11.4 UI flow and asynchronous status (ASP.NET steps — not the redirect `.g2u`)

1. **Step 1:** Operator enters/scans T-Card → validate against `T_CARD_DATA`, inventory, and **not** already in `ITEM_HISTORY` as `TC#…`.
2. **Step 2:** Show read-only header fields; operator must **manually** enter **verify qty** (match T-Card qty, **0.01** tolerance) and **verify item** (case-insensitive match to `TCITEM`).
3. On confirm: insert A10; **clear form to Step 1** immediately; show **PENDING** message with **T-Card** and **TRANS_ID**.
4. **Client JavaScript** polls `TCardReceipt.aspx?checkStatus=<TRANS_ID>` (same session) every **1s**, up to **10** polls (+ 10s safety timeout). Server returns plain text: `SUCCESS`, `FAILED|<descr>`, or `PENDING` from `WL_AUDIT_LOG`.
5. **XSS-safe display:** polling updates the message via JS with minimal escaping (`&`, `<`, `>`).

### 11.5 Connection string and session timeout pattern

The code-behind resolves ODBC similarly to other wireless pages (e.g., PackingListQuery): **Session → Application → parent `web.config` → `global.txt` → fallback** `DSN=global_<company>;UID=Master;PWD=master;` with **company** from session keys (`CCC`, `Company`, …) or default **`PLA`**. Literal **`CCC`** in a config string is replaced with session company.

**Timeout heuristic:** If the connection string matches the **`global_*` + Master/master** fallback **and** session has **no** company and **no** connection-related keys → **redirect `../Index.aspx`**.

### 11.6 Reference pseudo-code (compiled into `Avery.dll` — adapt placeholders)

All logic below lives in the code-behind class (e.g., `Avery.TCardReceipt : System.Web.UI.Page`) and compiles into `Avery.dll`. The `.aspx` markup deployed to the server contains no business logic.

```csharp
namespace Avery
{
    public partial class TCardReceipt : System.Web.UI.Page
    {
        // After validation: transactional insert
        // INSERT WIRELESS_LINE (... FIELD_5 = "TC#" + tcard, FIELD_6 = tcard, FIELD_4 = eaQty, TRANS_TYPE = 'A10' ...);
        // INSERT WIRELESS_HDR (... USER_ID from Session, printers from Session ...);
        // newTransId = (max(WIRELESS_HDR.TRANS_ID) + 1).ToString().PadLeft(9, '0');

        // AJAX poll handler on same page:
        // if (Request.QueryString["checkStatus"] != null) { Response.Write(AuditStatus(transId)); Response.End(); }
        // AuditStatus: SELECT STATUS_FLAG, DESCR FROM WL_AUDIT_LOG WHERE TRANS_ID = ? → SUCCESS / FAILED|descr / PENDING
    }
}
```

### 11.7 Differences to preserve when porting or documenting

- **Compile to DLL** -- all Avery business logic ships as `Avery.dll`, never as `.aspx.cs` source on the server (see 11.10).

- **Do not** conflate this flow with “must use `GetCustomHeader` / `GetCustomLine`” — those APIs are **irrelevant** to this page’s submit path.
- **Duplicate detection** is **not** only wireless rows; **`ITEM_HISTORY.REFERENCE`** is the business guard.
- **Operator authentication** is **delegated to the parent mobile site** session, not `ValidateUser` in this file.
- **README / DEPLOY** reference GAB hook **31908** for post-process behavior — confirm in the customer environment before relying on the number.

### 11.8 Avery-specific canonical redirect GAB (`TCardReceipt` handoff)

**Scope:** This subsection is **Avery-only** — it documents the **actual** headless program used in their environment to **redirect** GS Mobile from a **custom mobile transaction** to the **T-Card receipt** ASP.NET route. Example path from discovery: `c:\Apps\Global\PLUGINS\GAB\GAS\GAB_XXXX_TCardReceiptRedirect.g2u` (**XXXX** = project/feature number; name pattern **`GAB_XXXX_TCardReceiptRedirect.g2u`**).

**Deployment:** Ship the **`.g2u` source** and its **`.sig` companion** (same base name under **`PLUGINS\GAB\GAS\`**). **Full Avery folder layout, naming rules, and a deploy checklist:** §11.9. An observed `.sig` file hash (for identity checking in deploy manifests): `baf45c17b41816995db4adf9807d3529`.

**How it works:**

- **Headless scaffold** — **`Program.Sub.Preflight`** is **empty** (start/end only); **`Program.Sub.Main`** holds all logic (no `ScreenSU`).
- **Redirect payload** — **`F.Intrinsic.String.Build`** composes a single string: HTML **`<script type='text/javascript'>`** that sets **`window.location.href`** to the **site-relative** ASP.NET page **`../TCardReceipt/TCardReceipt.aspx`** (client-side navigation once GS Mobile renders the `SetCustomResult` HTML).
- **Mobile API** — **`F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode, V.Passed.DATA-TRANSID, V.Local.sMobileResult)`** publishes that HTML to the mobile host.
- **`V.Passed.DATA-TRANSID` in `String.Build`** — The call passes **`V.Passed.DATA-TRANSID`** as the format argument, but the **template string has no `{0}`** (or other placeholders), so **the trans id does not change the emitted script**; it is still passed through to **`SetCustomResult`** where it is **required** for correlating the result with the mobile transaction.

**Canonical Avery source (verbatim from deployment; do not hand-edit `Program.Sub.Comments` — see `agents/AGENTS.GAB.md`):**

```
Program.Sub.Preflight.Start
Program.Sub.Preflight.End

Program.Sub.Main.Start
	
	V.Local.sMobileResult.Declare(String)
	
	F.Intrinsic.String.Build("<script type='text/javascript'> window.location.href ='../TCardReceipt/TCardReceipt.aspx'; </script>",V.Passed.DATA-TRANSID,V.Local.sMobileResult)
	F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Passed.DATA-TRANSID,V.Local.sMobileResult)
	
Program.Sub.Main.End

Program.Sub.Comments.Start
${$5$}$23.1.9476.23167$}$1
${$6$}$bstevens$}$20251231110309681$}$3Pg7+K2MGztoXyjxMVZqWaM5g3GOUsSNfAH3eCSdO51lPcADCiX19rR21nSGSnL2VMsByTL8rFEpdDRF7WeDzA==
${$7$}$File Version:1.1.20251231190309.0
Program.Sub.Comments.End
```

**Generalized template** (copy for other **Avery-style** handoffs or customer-adapted mobile redirects; replace path segments; **`Program.Sub.Comments`** will be **generated by the GAB IDE** on save — **never** paste or edit signing/version lines by hand):

```
Program.Sub.Preflight.Start
Program.Sub.Preflight.End

Program.Sub.Main.Start
V.Local.sMobileResult.Declare(String)
F.Intrinsic.String.Build("<script type='text/javascript'> window.location.href ='../<YourAppFolder>/<YourPage>.aspx'; </script>",V.Passed.DATA-TRANSID,V.Local.sMobileResult)
F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Passed.DATA-TRANSID,V.Local.sMobileResult)
Program.Sub.Main.End
```

### 11.9 Avery deployment: custom mobile transactions (on-disk layout)

**Scope — Avery only:** The paths and conventions below describe **how Avery (this customer’s) Global environment lays out custom mobile work**. They are **not** generic GS Mobile or GSS standards—other sites may differ. When a task says “deploy the mobile transaction,” use **`AGENTS.PROJECT.md`** for the **actual** server root, then apply this layout.

**`<Global Directory>`:** Take the value from **`AGENTS.PROJECT.md`** → **Environment** → **Global Directory** (currently often still **`TODO`** in the template—replace it per environment before relying on examples). Example shapes in the field look like `C:\Apps\Global\`; **never assume** the path without confirming the project file or the target server.

#### Three on-disk targets

| What | Deploy under | Notes |
|------|----------------|------|
| **ASP.NET markup** (`.aspx` pages — UI only, **no** `.aspx.cs`) | **`<Global Directory>\WirelessASPX\<CustomMobileFolder>\`** | One **subfolder per** custom mobile app/transaction (e.g. **`TCardReceipt`**). |
| **Compiled DLL** (`Avery.dll` — all business logic) | **`<Global Directory>\WirelessASPX\<CustomMobileFolder>\bin\`** | The `bin\` subfolder under the transaction folder. Contains `Avery.dll` + any NuGet dependency DLLs. **Never** deploy `.aspx.cs` source files. See §11.10. |
| **GAB redirect handoff** (headless `.g2u` that returns `SetCustomResult` HTML with `window.location.href`) | **`<Global Directory>\PLUGINS\GAB\GAS\`** | Deploy the **`.g2u` and `.sig`** pair (**same base filename**, e.g. `GAB_XXXX_TCardReceiptRedirect.g2u` / `.g2u.sig`; **`XXXX`** = project/feature number per Avery naming). |

**Example (T-Card receipt on a site whose Global root is `C:\Apps\Global\`):**

```
C:\Apps\Global\WirelessASPX\TCardReceipt\TCardReceipt.aspx
C:\Apps\Global\WirelessASPX\TCardReceipt\bin\Avery.dll
C:\Apps\Global\PLUGINS\GAB\GAS\GAB_XXXX_TCardReceiptRedirect.g2u
C:\Apps\Global\PLUGINS\GAB\GAS\GAB_XXXX_TCardReceiptRedirect.g2u.sig
```

**Note:** The `.aspx` file's `CodeBehind` attribute still references the original `.aspx.cs` filename, but at runtime ASP.NET resolves the `Inherits` class from `Avery.dll` in `bin\`. No source code is needed on the server.

#### Folder name vs redirect URL

- **`WirelessASPX\<TransactionName>\`** — `<TransactionName>` is the folder for **this** custom flow (e.g. `TCardReceipt`, or whatever the **new** transaction is called). Keep it consistent across IIS content, build output, and documentation.
- **Redirect script** — In the `.g2u`, **`window.location.href`** must point at the deployed page using the **same** folder segment and page name, as a **site-relative** path from the mobile host, e.g. **`'../<FolderName>/<PageName>.aspx'`** (see §11.8). If you rename the folder or `.aspx`, **update the redirect** or the browser will 404.

#### Checklist: deploying a **new** Avery custom mobile transaction

1. **Build `Avery.dll`** — compile the solution targeting **.NET Framework 4.6.2** in **Release** configuration (see §11.10 for project structure).
2. Create **`<Global Directory>\WirelessASPX\<TransactionName>\`** and **`bin\`** subfolder.
3. Deploy **`.aspx`** markup files (no `.aspx.cs`) into the transaction subfolder.
4. Deploy **`Avery.dll`** (and any NuGet dependency DLLs) into the **`bin\`** subfolder.
5. Deploy the redirect **`.g2u`** and **`.g2u.sig`** to **`<Global Directory>\PLUGINS\GAB\GAS\`**.
6. **Verify** the **`window.location.href`** string in the `.g2u` matches **`../<FolderName>/<PageName>.aspx`** for the folder and page you deployed (§11.8).
7. Apply any **SQL scripts** (custom tables, indexes, grants) required by the transaction.
8. Configure **GS Mobile site admin** for the environment: **mobile transaction ID**, **hook assignment**, and other settings per GSS / site documentation.
9. **Verify** — confirm **no `.aspx.cs` files** are present on the deployed server.

### 11.10 Avery DLL project structure and build rules

**Scope — Avery only.** All custom mobile transaction business logic **MUST** be compiled into `Avery.dll`. This protects source code on the customer's server — only the `.aspx` markup and the compiled DLL are deployed.

#### Framework target (CRITICAL)

**Always target .NET Framework 4.6.2.** The GS Mobile wireless site runs under the .NET Framework CLR. SDK-style projects, .NET Core, .NET 5+, and .NET Standard are **not compatible**.

#### Solution structure

```
Avery/
├── Avery.sln
├── Avery/                              # Class Library (OutputType=Library)
│   ├── Avery.csproj
│   ├── TCardReceipt.aspx.cs            # Code-behind (compiles into DLL, NOT deployed as source)
│   ├── <OtherTransaction>.aspx.cs      # Additional transactions share the same DLL
│   ├── Properties/
│   │   └── AssemblyInfo.cs
│   └── packages.config                 # NuGet (classic restore, NOT PackageReference)
└── Avery.Test/                         # Console Test Harness (optional, OutputType=Exe)
    ├── Avery.Test.csproj
    ├── Program.cs
    └── packages.config
```

**Key points:**

- **One DLL for all Avery transactions** — each custom mobile transaction is a code-behind class compiled into the same `Avery.dll`. New transactions add a new `.aspx.cs` class to the project; they do **not** create separate DLLs.
- **NuGet:** Use `packages.config` (classic restore), **not** `PackageReference`. Deploy NuGet dependency DLLs (e.g., `System.Data.Odbc` extras) alongside `Avery.dll` in the `bin\` folder.
- **No `app.config`:** The IIS site's `web.config` and parent `web.config` chain handle configuration. Do not ship a standalone `app.config` for the DLL.
- **References:** Add `System.Web` (for `System.Web.UI.Page`, `HttpContext`, `Session`, etc.), `System.Data`, `System.Data.Odbc` as project references.

#### ASP.NET page wiring

Each `.aspx` file uses standard Web Forms directives to bind to the compiled class:

```aspx
<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="TCardReceipt.aspx.cs"
    Inherits="Avery.TCardReceipt" %>
```

- **`CodeBehind`** — references the source file name (used by Visual Studio at design time; **not needed at runtime**).
- **`Inherits`** — the **fully qualified class name** inside `Avery.dll` (e.g., `Avery.TCardReceipt`). At runtime, ASP.NET resolves this from `bin\Avery.dll`.
- The `.aspx` file contains **only markup, inline CSS, and client-side JavaScript** — no server-side business logic.

#### Build

```powershell
& "$msbuildPath" /t:Build /p:Configuration=Release "Avery.sln"
```

Output: `Avery\bin\Release\Avery.dll` (plus dependency DLLs). Deploy from the Release output folder.

#### What to deploy vs what stays in source control

| Deploy to server | Keep in source control only |
|------------------|-----------------------------|
| `*.aspx` (markup) | `*.aspx.cs` (code-behind source) |
| `bin\Avery.dll` | `*.csproj`, `*.sln` |
| `bin\<dependency>.dll` (NuGet DLLs) | `packages.config`, `Properties\` |
| SQL scripts (run once) | `Avery.Test\` (test harness) |
| `.g2u` + `.sig` (redirect) | `.pdb` files (debug only) |

#### Adding a new transaction to `Avery.dll`

1. Add a new `.aspx.cs` class to the `Avery` project (e.g., `NewTransaction.aspx.cs`) with `namespace Avery` and class inheriting `System.Web.UI.Page`.
2. Create the corresponding `.aspx` markup with `Inherits="Avery.NewTransaction"`.
3. Build the solution — `Avery.dll` now contains both the old and new transaction classes.
4. Create the redirect `.g2u` per §11.8 template, pointing to `../<NewFolder>/<NewTransaction>.aspx`.
5. Deploy per §11.9 checklist.

### 11.11 MobExt package format (`.g2u-MobExt.zip`)

GS Mobile imports a **MobExt** ZIP to register a **custom mobile transaction**—metadata ( **`DTTRANS`** ), form controls ( **`DTLABELS`** ), dropdown rows ( **`DTOPTION`** ), and the backing **`.g2u`** program.

#### 11.11.1 Import/export administration (workshop: ARC 5448 + runtime activation)

**Source:** GS Mobile Technical Workshop 2025 — **confirm** menu labels, ARC packaging, and service names on the target environment.

| Topic | Workshop detail |
|-------|-----------------|
| **ARC dependency** | **ARC 5448** is the **base ARC** for **GS Mobile Custom Trans Imp/Exp** |
| **Admin path** | **System Support > Administration > GS Mobile Custom Trans Imp/Exp** |
| **Export** | Packages the **mobile form + custom `.g2u`** into **`<ScriptName>.g2u-MobExt.zip`** (same naming as §11.11) |
| **Import** | Loads the **custom mobile project** from the ARC/package into the customer environment and **wires the custom mobile hook → custom script** activation for the company context used during import |
| **Company scope** | Import activation applies **only** to the **GSS company you load the project from** — operators must **manually activate** the corresponding hook → script mapping **in other companies** (**per workshop deck — confirm in admin**) |
| **WIREPOLL** | **Restart WIREPOLL on the application server** after hook activations so new bindings are picked up |
| **GAP Entry Wizard pattern** | Set **GAP dependency = 5448** and attach the export ZIP to **`plugins\gab\gas`** (path casing may vary — **confirm** server layout) |

- **Avery redirect-only** packages often contain **four** payload files: `.g2u` + three XMLs; the **`.sig`** may be deployed beside the `.g2u` under **`PLUGINS\GAB\GAS\`** per §11.8 / §11.9 instead of inside the ZIP.
- **Standard (non-Avery) GAB custom transactions** (e.g. **Material Picklist**, `GAB_7730_Mobile_MatlPicklist`) ship **five** members in the ZIP: **`.g2u`**, **`.g2u.sig`**, **`_DTTRANS.XML`**, **`_DTLABELS.XML`**, **`_DTOPTION.XML`**—so the signature required to run the compiled script travels with the import.

#### Package naming convention

```
<ScriptName>.g2u-MobExt.zip
```

Example: `GAB_XXXX_TCardReceiptRedirect.g2u-MobExt.zip` or `GAB_7730_Mobile_MatlPicklist.g2u-MobExt.zip`

#### Package contents (standard custom: 5 files)

All files share the base name of the `.g2u` script:

| File | Purpose |
|------|---------|
| `<name>.g2u` | The GAB program (**full logic** or **redirect-only**). |
| `<name>.g2u.sig` | **Signature** companion — **included in the MobExt ZIP** for standard site imports (differs from some **Avery** layouts where ops place `.sig` only on disk). |
| `<name>.g2u_DTTRANS.XML` | **Transaction registration** (`TID`, `TNAME`, `SHOW_RESULTS`, `TXID`). |
| `<name>.g2u_DTLABELS.XML` | **Label/control definitions** (`ORDERNO`, `CONTROLTYPE`, `FIELDLENGTH`, …). |
| `<name>.g2u_DTOPTION.XML` | **Option lists** for dropdown controls (`LID` ties each option to one label). |

**Redirect-only (Avery §11.8) ZIPs** may omit the **`.sig`** inside the archive if your deploy runbook copies the `.sig` separately—**match how your GS Mobile admin expects the import**.

#### DTTRANS.XML -- transaction definition

```xml
<?xml version="1.0" standalone="yes"?>
<NewDataSet>
  <xs:schema id="NewDataSet" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
    <xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:MainDataTable="DTTRANS" msdata:UseCurrentLocale="true">
      <xs:complexType>
        <xs:choice minOccurs="0" maxOccurs="unbounded">
          <xs:element name="DTTRANS">
            <xs:complexType>
              <xs:sequence>
                <xs:element name="TID" type="xs:int" minOccurs="0" />
                <xs:element name="TXID" type="xs:int" minOccurs="0" />
                <xs:element name="TNAME" type="xs:string" minOccurs="0" />
                <xs:element name="NOTES" type="xs:string" minOccurs="0" />
                <xs:element name="SHOW_RESULTS" type="xs:boolean" minOccurs="0" />
              </xs:sequence>
            </xs:complexType>
          </xs:element>
        </xs:choice>
      </xs:complexType>
    </xs:element>
  </xs:schema>
  <DTTRANS>
    <TID>7</TID>
    <TXID>1</TXID>
    <TNAME>T-Card Receipt (US)</TNAME>
    <NOTES />
    <SHOW_RESULTS>true</SHOW_RESULTS>
  </DTTRANS>
</NewDataSet>
```

| Field | Type | Purpose |
|-------|------|---------|
| `TID` | int | Transaction definition ID (unique within the mobile site) |
| `TXID` | int | **Logical transaction group** within this ZIP—all **`DTLABELS`** and **`DTOPTION`** rows **must repeat this `TXID`** so they bind to the same **`DTTRANS`** row (Material Picklist uses **`TXID = 2`** for all five labels). |
| `TNAME` | string | **Display name** shown on the GS Mobile menu (e.g., `"T-Card Receipt (US)"`) |
| `NOTES` | string | Optional notes/description |
| `SHOW_RESULTS` | boolean | If **`true`**, GS Mobile **displays the transaction result** to the operator (**required** for almost all standard custom flows). For **`SetCustomResult`**-only scripts, that means rendering the returned HTML. For **`Mobile_Custom_Result`** workflows (§4.1), the site still expects **`SHOW_RESULTS` = `true`** so the host can **pull and render** the stored HTML blob. **Redirect-only** Avery stubs (§11.8) also keep this **`true`**. |

#### DTLABELS.XML -- UI label/control definitions

```xml
<?xml version="1.0" standalone="yes"?>
<NewDataSet>
  <!-- schema omitted for brevity -->
  <DTLABELS>
    <LID>166</LID>
    <TXID>1</TXID>
    <ORDERNO>1</ORDERNO>
    <LABEL>Begin T-Card Receipt Process</LABEL>
    <CONTROLTYPE>1</CONTROLTYPE>
    <FIELDLENGTH>7</FIELDLENGTH>
    <DEFAULTTEXT>Black</DEFAULTTEXT>
  </DTLABELS>
</NewDataSet>
```

| Field | Type | Purpose |
|-------|------|---------|
| `LID` | int | Label ID (unique identifier for this control) |
| `TXID` | int | Ties this label to the transaction (matches `DTTRANS.TXID`) |
| `ORDERNO` | long | Display order on the mobile form |
| `LABEL` | string | Text displayed to the user (e.g., `"Begin T-Card Receipt Process"`) |
| `CONTROLTYPE` | int | See **CONTROLTYPE reference** table below (discovered from **T-Card** + **Material Picklist** MobExt). |
| `FIELDLENGTH` | int | Maximum field length for input controls (`CONTROLTYPE` 16); `0` when not applicable. |
| `DEFAULTTEXT` | string | Default or styling hint for labels (**`1`**); pre-selected dropdown caption (**`4`**); often empty for checkboxes. |

#### `CONTROLTYPE` reference (MobExt / `DTLABELS`)

| Value | Meaning | Notes |
|------:|---------|--------|
| **1** | **Label / static text** | e.g. T-Card prompt `"Begin T-Card Receipt Process"` — **no** `WIRELESS_LINE.FIELD_N` payload. |
| **2** | **Checkbox / toggle** | Submit stores **`"on"`** when checked (**7730** compares `Field_2` / `Field_3` to **`"on"`**), otherwise empty/falsey — normalize in GAB before use. |
| **4** | **Dropdown / select** | `DEFAULTTEXT` holds the **selected display** value; options come from **`DTOPTION`** rows sharing the label’s **`LID`**. |
| **16** | **Text / scan field** | Free text (and parsed scans) up to **`FIELDLENGTH`** — maps to the corresponding **`FIELD_i`**. |

#### Multi-field example — `GAB_7730_Mobile_MatlPicklist` (five controls, one `TXID`)

Sorted by **`ORDERNO`**, the DTLABELS rows drive **`FIELD_1` … `FIELD_5`** on **`WIRELESS_LINE`**:

| `ORDERNO` | `CONTROLTYPE` | Role | `WIRELESS_LINE` |
|-----------|----------------|------|-----------------|
| 1 | 16 | Job / suffix / seq scan | `Field_1` |
| 2 | 2 | Search closed material | `Field_2` (`"on"` / not) |
| 3 | 2 | Search issue history | `Field_3` (`"on"` / not) |
| 4 | 4 | Picklist sort dropdown | `Field_4` (selected option **text**, e.g. `Default`, `Bin`, `Part`, `Seq`) |
| 5 | 16 | Part filter | `Field_5` |

The physical order of `<DTLABELS>` elements inside the XML file is irrelevant—**`ORDERNO`** defines mapping to **`FIELD_N`**.

#### DTOPTION.XML — option list definitions

Schema-only when no dropdown controls are used. When **`CONTROLTYPE = 4`**, add one `<DTOPTION>` row per choice:

| Field | Type | Purpose |
|-------|------|---------|
| `OID` | int | Option row id (unique in file). |
| `TXID` | int | Must match **`DTTRANS.TXID`** / all sibling labels. |
| `LID` | int | **Foreign key to `DTLABELS.LID`** — ties this option row to **exactly one** dropdown label. |
| `OPTION` | string | Text shown in the mobile UI; becomes the value stored in **`WIRELESS_LINE.FIELD_n`** when selected. |

**7730 example:** dropdown label **`LID = 228`** (`PL Sort Order`) owns four option rows (`Default`, `Part`, `Bin`, `Seq`); unrelated labels do **not** reuse its `LID`.

#### Creating a MobExt package for a new transaction

1. Copy a known-good template ZIP (**T-Card** redirect or **`GAB_7730`** standard custom).
2. Rename all included files to the new script base name: `GAB_XXXX_<NewName>.g2u*`.
3. Update `DTTRANS.XML`: unique **`TID`**, human-readable **`TNAME`**, shared **`TXID`**, **`SHOW_RESULTS` = `true`** for standard/list flows.
4. Update `DTLABELS.XML`: one row per field; assign unique **`LID`** values; align **`TXID`** with `DTTRANS`; set **`ORDERNO` = 1…N** in mobile display order; choose **`CONTROLTYPE`** + **`FIELDLENGTH`** from the table above.
5. Update `DTOPTION.XML`: for each **`CONTROLTYPE = 4`** label, add options whose **`LID`** matches that label’s **`LID`**.
6. **MANDATORY — sign before zip:** Author / compile the `.g2u`, then **sign it in the GAB editor to produce a current `.g2u.sig`**. The `.sig` **must** exist and be up-to-date **before** you create the ZIP — an unsigned or stale-signed script will fail to launch at runtime.
7. ZIP **both** the **`.g2u` and `.g2u.sig`** together with the three XMLs (`5` files typical for standard custom) into `<ScriptName>.g2u-MobExt.zip`. **Never** zip the `.g2u` alone and add the `.sig` later.
8. Import the ZIP through **GS Mobile** administration — **or** **System Support > Administration > GS Mobile Custom Trans Imp/Exp** when using the **ARC 5448** import/export path (§11.11.1) — then complete **hook activation**, **company-by-company** mapping, and any required **WIREPOLL** restart (**workshop** — §11.11.1).
9. Still deploy **`PLUGINS\GAB\GAS\` copies** of `.g2u` / `.sig` per ops if your site mirrors Global’s plugin folder outside the importer (§12.7).

#### Reference template location

The canonical MobExt package template is at:
```
c:\Apps\Global\PLUGINS\GAB\GAS\GAB_XXXX_TCardReceiptRedirect.g2u-MobExt.zip
```

Standard custom multi-field reference: `c:\Apps\Global\PLUGINS\GAB\GAS\GAB_7730_Mobile_MatlPicklist.g2u-MobExt.zip`.

### 11.12 GS Mobile parent site session variables (Avery reference)

When a custom ASP.NET page runs under GS Mobile, it inherits the parent site's `Session` and `Application` objects. The custom page **does not authenticate on its own** -- it relies on the parent mobile site's login. Below is the complete session variable map discovered from the Avery T-Card implementation.

#### Identity and hardware (from parent site session)

| Session Key | Type | Purpose | Fallback if missing |
|-------------|------|---------|---------------------|
| `"UserID"` | String | The logged-in mobile user who performed the action | `"MOBILE_USER"` |
| `"DefaultPrinter"` | String | Default printer assigned to this mobile session | `""` (empty) |
| `"LabelPrinter"` | String | Label printer assigned to this mobile session | `""` (empty) |

#### Company resolution (from parent site session)

The parent site stores the active company code under **one** of these keys. Check them in priority order -- use the **first non-empty value**:

```csharp
string[] companyKeys = { "CCC", "Company", "CompanyCode", "SessionCompany", "CompanyCodeSession", "Comp" };
```

If **none** of these keys contain a value, default to `"PLA"` (or the site's known default company).

#### ODBC connection string resolution (from parent site session)

The parent site may store a pre-built connection string under one of these keys. Check in order -- use the **first non-empty value**:

```csharp
string[] sessionKeys = { "ConnectionString", "DBConnection", "GlobalPLA", "ConnString",
                         "Connection", "DBConn", "ODBCConnection", "DSNConnection" };
```

#### Application-level keys (from IIS Application object)

These are shared across all sessions and set by the parent site at startup:

| Application Key | Purpose |
|-----------------|---------|
| `"Server"` | Database server name |
| `"DSNfrag"` | DSN fragment for building connection strings |
| `"DSN"` | Full DSN name |
| `"PDBU"` | Database user |
| `"PDBP"` | Database password |
| `"ConnectionString"` | Pre-built connection string |

#### Connection string build order

The code-behind resolves the ODBC connection using this waterfall:

1. **Session connection key** -- check each `sessionKeys` entry for a pre-built string
2. **Application `DSNfrag`** -- build `DSN=<DSNfrag>_<company>;UID=<PDBU>;PWD=<PDBP>;` using Application keys
3. **Parent `web.config`** -- `ConfigurationManager.ConnectionStrings["GlobalPLA"]` or `["ABORIS"]`
4. **`global.txt`** -- read `<Global Directory>\global.txt` for DSN/UID/PWD values
5. **Fallback** -- `DSN=global_<company>;UID=Master;PWD=master;`

In all cases, the literal string **`CCC`** in a connection string is replaced with the resolved company code.

#### Session timeout / loss detection

If the connection falls through to the **fallback** (step 5) **and** none of the company or connection session keys are present, the session has expired. Redirect to `../Index.aspx` (the GS Mobile login page):

```csharp
if (IsSessionTimeout())
    Response.Redirect("../Index.aspx");
```

#### Transaction-specific session variables (created by the custom page)

These are **not** from the parent site -- each custom transaction creates its own workflow state between postbacks. Clear them when the transaction completes or the user starts over:

| Session Key | Purpose |
|-------------|---------|
| `"TCardData"` | The scanned/entered T-Card number |
| `"Part"` | Parsed part number (17-char base) |
| `"PartRev"` | Parsed revision (3-char, positions 18-20) |
| `"Location"` | Warehouse/location from `TCWHSE` |
| `"Quantity"` | T-Card quantity |
| `"UOM"` | Unit of measure |
| `"Item"` | Full item string (`TCITEM`) |
| `"ItemDescription"` | Inventory description from `V_INVENTORY_MSTR` |
| `"LastTransId"` | The generated `WIRELESS_HDR.TRANS_ID` after A10 insert |
| `"LastEaQty"` | EA quantity after UOM conversion |

**Naming convention:** When adding a new custom transaction, prefix your session keys with the transaction name (e.g., `"NewTx_Part"`, `"NewTx_Qty"`) to avoid collisions with other custom pages sharing the same session.

#### Key takeaway for new transactions

Any new Avery custom mobile page gets **identity**, **printers**, and **database connectivity for free** from the parent GS Mobile session. The parent site handles login; the custom page just needs to:

1. Read `"UserID"` (fallback `"MOBILE_USER"`) for audit columns
2. Read `"DefaultPrinter"` / `"LabelPrinter"` for printer fields
3. Call `GetConnectionString()` using the waterfall above for ODBC access
4. Check for session timeout before any database operation

### 11.13 AVY API V3 — database-queue integration layer (Avery)

**Scope — Avery only:** **AVY API V3** is **customer-specific integration infrastructure**. External systems drive GSS **without IIS, HTTP, or .NET compilation** by **INSERT**ing work into **Actian Zen** staging tables. A **Master Dashboard** GAB program launches **13** dedicated worker processes; each worker polls for its **`REQUEST_TYPE`**, executes via **CallWrapper** (direct GSS API) or **Wireless** (**`WIRELESS_HDR` / `WIRELESS_LINE`** + **wirepoll**), and records outcomes. **Cross-references:** wireless field semantics — **§14**; safe staging writes and retries — **§15**; T-Card mobile data — **`AVY_T_CARD_*`** ties to **§11.1–§11.8**.

**Source (distilled for agents; not a full reproduction):** *AVY_API_V3_Setup_Guide.docx* (**2026-05-14**).

#### Architecture overview

| Concern | Behavior |
|---------|----------|
| **Inbound** | External systems **INSERT** rows into **`AVY_API_REQUEST`**. |
| **Orchestration** | **`AVY_API_Master.g2u`** (Master Dashboard) starts monitors and the **13** workers. |
| **Execution** | Workers claim work, set status, invoke **CallWrapper** or build wireless rows for **wirepoll**. |
| **Outbound** | Workers **INSERT** into **`AVY_API_RESPONSE`** with status and payload text. |
| **Operations** | **`AVY_API_WORKER_STATUS`** holds registration, **`LAST_HEARTBEAT`** (typically **~10s**), counters, and last error; **`AVY_API_WORKER_LOG`** supports dashboard drill-down. |
| **Config / schema** | **`AVY_API_CONFIG`** key-value runtime settings; **`AVY_API_SQL_REV`** tracks schema revision for incremental upgrades (**`AVY_API_SQL_MAINT.lib`**). |

**Design note:** The queue is the **database** — not a web tier. Any new transaction type must align with the worker’s **polling**, **locking**, and **status** semantics on these tables.

#### Custom tables (summary)

| Table | Purpose |
|-------|---------|
| **`AVY_API_REQUEST`** | Inbound queue — external systems **INSERT** here. |
| **`AVY_API_RESPONSE`** | Outbound log — workers write results. |
| **`AVY_API_WORKER_STATUS`** | Worker id/type, **`STOPPED`/running** state, PID, **heartbeat**, processed/error counts, **`POLL_INTERVAL`** (default **10**). |
| **`AVY_API_WORKER_LOG`** | Structured per-worker log lines for dashboard drill-down. |
| **`AVY_API_CONFIG`** | Runtime configuration (key-value). |
| **`AVY_API_SQL_REV`** | Schema version for incremental DDL. |
| **`AVY_T_CARD_*`** | T-Card mobile workflow tables (e.g. **MASTER**, **AUDIT**, **HISTORY**, **WMS_CFG**) — see **§11.1–§11.8**. |

#### DDL reference (`AVY_API_*` core queue)

**`AVY_API_REQUEST`:**

```sql
CREATE TABLE AVY_API_REQUEST (
    RECORD_ID        IDENTITY         NOT NULL,
    REQUEST_ID       VARCHAR(50)      NOT NULL,
    REQUEST_TYPE     CHAR(30)         NOT NULL,
    INPUT_DATA       LONGVARCHAR      NOT NULL,
    STATUS           CHAR(20)         DEFAULT 'PENDING' NOT NULL,
    CREATED_DATE     TIMESTAMP        DEFAULT NOW() NOT NULL,
    CREATED_BY       VARCHAR(50),
    PROCESSED_DATE   TIMESTAMP,
    LOCKED_BY        VARCHAR(50),
    LOCKED_DATE      TIMESTAMP,
    RETRY_COUNT      INTEGER          DEFAULT 0 NOT NULL,
    PROCESSING_TIMEOUT TIMESTAMP
);
```

**`AVY_API_RESPONSE`:**

```sql
CREATE TABLE AVY_API_RESPONSE (
    RECORD_ID      IDENTITY         NOT NULL,
    REQUEST_ID     VARCHAR(50)      NOT NULL,
    STATUS_CODE    CHAR(20)         NOT NULL,
    RESPONSE_DATA  LONGVARCHAR      NOT NULL,
    LOG_FILE       VARCHAR(500),
    CREATED_DATE   TIMESTAMP        DEFAULT NOW() NOT NULL
);
```

**`AVY_API_WORKER_STATUS`:**

```sql
CREATE TABLE AVY_API_WORKER_STATUS (
    WORKER_ID       VARCHAR(50)     NOT NULL,
    WORKER_TYPE     VARCHAR(50)     NOT NULL,
    STATUS          VARCHAR(20)     DEFAULT 'STOPPED' NOT NULL,
    PID             VARCHAR(20),
    LAST_HEARTBEAT  TIMESTAMP,
    PROCESSED_COUNT INTEGER         DEFAULT 0 NOT NULL,
    ERROR_COUNT     INTEGER         DEFAULT 0 NOT NULL,
    LAST_ERROR      VARCHAR(500),
    STARTED_DATE    TIMESTAMP,
    HOST_NAME       VARCHAR(100),
    POLL_INTERVAL   INTEGER         DEFAULT 10 NOT NULL
);
```

Schema creation and upgrades: first run (or upgrade) is driven by **`AVY_API_SQL_MAINT.lib`** — do not assume tables exist on a blank database until that layer has executed successfully.

#### Transaction types (13 workers) — request type, worker id, fields, mechanism

| `REQUEST_TYPE` | Worker ID | Fields in `INPUT_DATA` | Mechanism | Notes |
|----------------|-----------|------------------------|-----------|-------|
| **`STANDALONE_ISSREC`** | `AVY_ISSREC_01` | **17** | CallWrapper | Direct GSS API. |
| **`PO_RECEIPT`** | `AVY_POREC_01` | **44** | CallWrapper | **Date format: `YYMMDD`**. |
| **`PO_RECEIPT_MOBILE`** | `AVY_P10_01` | **24** | Wireless **P10** | **Date format: `MMDDYY`** — **not** the same as CallWrapper **`PO_RECEIPT`**; wrong format → **silent failure**. |
| **`ISSREC_WIRELESS`** | `AVY_A10_01` | **14** | Wireless **A10** | Issue/receipt via wireless. |
| **`INVENTORY_TRANSFER`** | `AVY_INVTFR_01` | **14** | Wireless **O90** | Bin-to-bin transfer. |
| **`PHYSICAL_INVENTORY`** | `AVY_P16_01` | **12** | Wireless **P16** | Physical count. |
| **`MANUAL_ADJUSTMENT`** | `AVY_P19_01` | **11** | Wireless **P19** | Quantity adjustment. |
| **`LABOR_ENTRY`** | `AVY_L10_01` | **15** | Wireless **L10** | Job labor posting. |
| **`SHIP_ADD_PART`** | `AVY_S10_01` | **23** | Wireless **S10** | Add to shipment. |
| **`SHIP_B2B_ADD`** | `AVY_S15_01` | **24** | Wireless **S15** | B2B + add to shipment. |
| **`SHIP_MODIFY`** | `AVY_S20_01` | **25** | Wireless **S20** | Modify shipment. |
| **`SHIP_REMOVE`** | `AVY_S30_01` | **12** | Wireless **S30** | Remove from shipment. |
| **`SHIP_CHANGE_CARRIER`** | `AVY_S50_01` | **3** | Wireless **S50** | Change carrier. |

**Wirepoll:** All **Wireless** rows in the table above require **wirepoll** running so **`WIRELESS_HDR` / `WIRELESS_LINE`** are consumed. Map each code (P10, A10, O90, …) to **`FIELD_1…`** meanings using **§14**; when **authoring or debugging** inserts, follow **§15** (concurrency, **`ATTEMPTED_FLAG`**, audit columns).

#### `INPUT_DATA` encoding and status lifecycle

| Rule | Detail |
|------|--------|
| **Field delimiter** | **`*!*`** between fields inside **`INPUT_DATA`**. |
| **Row delimiter** | **`~!~`** between rows when the request carries **multiple** logical rows. |
| **Status flow** | **`PENDING`** → **`PROCESSING`** → **`COMPLETED`** or **`ERROR`**. |
| **Date pitfall** | **`PO_RECEIPT`** (CallWrapper) = **`YYMMDD`**; **`PO_RECEIPT_MOBILE`** (Wireless P10) = **`MMDDYY`**. |

#### GAB scripts and libraries

| Artifact | Role |
|----------|------|
| **`AVY_API_Master.g2u`** | Master Dashboard — orchestrates workers, monitors queue health. |
| **`AVY_API_Worker_*.g2u`** | Thirteen worker programs (one **`REQUEST_TYPE`** / worker id each). |
| **`AVY_API_SeedData.g2u`** | Test-data inserter GUI. |
| **`AVY_API_Shared.lib`** | Shared connection handling, lifecycle, errors, worker registration / heartbeat. |
| **`AVY_API_SQL_MAINT.lib`** | Base schema create, **`AVY_API_SQL_REV`**, incremental upgrade DDL. |

Every **`.g2u`** and **`.lib`** shipped to runtime needs a matching **`.sig`** signature file (same rules as other signed GAB artifacts — **§11.9** plugin layout when deploying beside Global).

#### Deployment and launch

| Topic | Detail |
|-------|--------|
| **Root path** | Deploy under **`C:\AVY_API_V3\`** (short path, **no spaces**). |
| **Setup** | **`SETUP.vbs`** generates launchers (**.gaf**, **.dir**, **.vbs**). |
| **Silent** | **`POC_CursorExecute.vbs`** with a **.dir** file using **`SILENT::1`**. |
| **Interactive** | Double-click **`AVY_API_Master.gaf`** inside a **GSS** session. |
| **First run** | **`AVY_API_SQL_MAINT.lib`** creates or upgrades Zen objects as needed. |

#### Validation queries (examples)

**Issue/receipt (CallWrapper `STANDALONE_ISSREC` or wireless `ISSREC_WIRELESS` / A10):**

```sql
SELECT TOP 5 * FROM ITEM_HISTORY WHERE PART_NUMBER = '0025' ORDER BY ID DESC;
-- Expect CODE_TRANSACTION = 'A10' (receipt) or 'A50' (issue) when matching the test case.
```

**PO receipt (either path):**

```sql
SELECT QTY_RECEIVED FROM V_PO_LINES WHERE PO_NUMBER = '0000046' AND RECORD_NO = '0010';
```

**Any wireless-backed type (after wirepoll):**

```sql
SELECT TOP 10 * FROM WIRELESS_HDR ORDER BY TRANS_ID DESC;
-- SUCCESSFUL_FLAG = 'Y' AND ERROR_ID = 0 indicates a clean post for many sites.
```

---

## 12. Standard custom mobile transaction pattern (GAB + MobExt + `WIRELESS_LINE`)

**Scope:** **Non-Avery** Global Shop deployments that register a **custom GS Mobile transaction** backed by a **headless `.g2u`**. This section distills **`GAB_7730_Mobile_MatlPicklist.g2u`** (~1,150 lines) into a maintainable mental model. **Always** confirm SQL, option flags, and URL casing on the **target** site. **Trans_Type convention:** custom deployments use **`C01`–`C20`**-style codes (within the §1 **20**-transaction cap); **fixed** product mobiles use the standard codes mapped in **§14**.

### 12.1 Architecture overview

| Layer | Responsibility |
|-------|----------------|
| **GS Mobile + MobExt** | Renders the control stack (`DTLABELS` / `DTOPTION`), posts operator input to **`WIRELESS_LINE`**, passes **`V.Passed.DATA-TRANSID`**. |
| **Headless `.g2u`** | `Preflight → Main` (no `ScreenSU` UI work); **dual ODBC**: **`F.ODBC.Connection!Con.OpenCompanyConnection(300)`** (company data) **and** **`F.ODBC.Connection!conC.OpenCommonConnection`** (shared metadata / `MOBILE_CUSTOM_*` / `Mobile_Custom_Result`). |
| **Input path** | **Primary:** `SELECT Field_1…Field_N, Trans_Type FROM WIRELESS_LINE WHERE TRANS_ID = …` using the passed trans id. |
| **Output path** | **Preferred for large grids:** `DELETE` + `DataTable.SaveToDB` into **`Mobile_Custom_Result`** on **`conC`** (§4.1). Optional **`SetCustomResult`** for tiny payloads or redirect stubs—**7730** comments show older `SetCustomResult` calls disabled after **03/25/26**. |
| **HTML shaping** | Build `<table>` fragments directly **or** call **`F.Data.DataTable.ExportHTML`** for readable mobile tables. |
| **Navigation** | Embed `<a href>` links and `<script>` redirects (`window.location`, §5.1) using **`F.Intrinsic.String.MakeURLFriendly`** on dynamic segments (§5.4). |

**Library includes:** **`GAB_7730`** declares globals only in **`Preflight`**—no `Program.External.Include.Library`. Add `.lib` references **only** when shared parsing/helpers justify them (`agents/AGENTS.GAB.md`).

### 12.2 Input: `WIRELESS_LINE` field mapping (MobExt `ORDERNO` → `FIELD_N`)

After **`PassedExists("DATA-TRANSID")`**, treat **`V.Passed.DATA-TRANSID`** as the **`WIRELESS_LINE.TRANS_ID`** for the line GS Mobile created for this submit.

**Query pattern (extend `N` per form):**

```
F.Intrinsic.String.Build("SELECT Field_1, Field_2, Field_3, Field_4, Field_5, Trans_Type FROM WIRELESS_LINE WHERE TRANS_ID='{0}'",V.Global.sTransID,V.Global.sSQL)
F.Data.DataTable.CreateFromSQL("dtWIR","Con",V.Global.sSQL,True)
```

**Control semantics (verified against 7730):**

| MobExt `CONTROLTYPE` | Stored `FIELD_i` content |
|----------------------|-------------------------|
| **16** (text / scan) | Raw operator text or parsed scan string. |
| **2** (checkbox) | **`"on"`** when checked; otherwise empty—compare explicitly in GAB. |
| **4** (dropdown) | The **`OPTION`** text that was selected (e.g., `Default`, `Bin`). |
| **1** (static label) | No independent field payload (does not advance `FIELD_N`). |

Sort **`DTLABELS` by `ORDERNO`** to know which business column is `FIELD_1`, `FIELD_2`, … (§11.11 multi-field table).

### 12.3 Output: `Mobile_Custom_Result` + `DataTable.ExportHTML`

**Write sequence (common connection):**

1. `DELETE FROM Mobile_Custom_Result WHERE cocode = '<company>' AND txid = '<V.Passed.DATA-TRANSID>'`.
2. `DataTable.Create` → add columns `CoCode`, `TXID`, `Results`.
3. `AddRow` with HTML (either hand-built or produced by **`ExportHTML`**).
4. `SaveToDB(..., "Mobile_Custom_Result", …)` using the delimiter map  
   `"CoCode@!@CoCode*!*TXID@!@TXID*!*Results@!@Results"`.

**`ExportHTML` usage:** `F.Data.DataTable.ExportHTML("dtGrid",fieldsCsv,headersCsv,"t01",True,V.Global.sHtml)` — the **`t01`** token selects the mobile-friendly stylesheet GSS ships for HTML exports; **`True`** enables the wrapper table. Populate computed link columns (e.g., `SEQlink`, `PARTLink`) **before** exporting so anchors survive into `Results`.

**Standard mobile HTML wrapper (from 7730 -- use as template):**

After `ExportHTML` produces the table markup, wrap it in a full HTML document with the standard mobile stylesheet:

```
F.Intrinsic.String.Build("<!DOCTYPE html><html><style>table { width:100%;}table, td { height: 15px; font-size: 12px; border: 1px solid black; border-collapse: collapse;}table#t01 tr:nth-child(even) { background-color: #D3D3D3;}table#t01 tr:nth-child(odd) { background-color: #FFFFFF;}table#t01 th { background-color: #95C26C; color: black;}</style><body>{0}</body></html>",V.Global.sHtml,V.Global.sHtml)
```

This produces:
- Full-width table with 1px solid black borders
- 12px font, 15px row height (mobile-friendly density)
- Alternating row colors: white (`#FFFFFF`) odd, light gray (`#D3D3D3`) even
- Green header row (`#95C26C`, black text)

**Always use this wrapper** when writing `ExportHTML` output to `Mobile_Custom_Result`. The `{0}` placeholder is the raw table HTML from `ExportHTML`; the output replaces the same variable. Copy verbatim -- do not restyle without customer approval.

### 12.4 URL navigation patterns

Cross-reference **§5.4** for full detail. **7730** idioms to copy verbatim:

- **Re-open custom form:** `Custom.aspx?sTXID=<iCustomTransID>&field1=<MakeURLFriendly job>-<suffix>` (additional `Field2…` / `sReturnpath` per design).
- **Drill-in results:** `CustomResults.aspx?sTXID=<iCustomTransID>&sTransID=<child TRANS_ID>&sReturnpath=<encoded prior URL>` (source often spells `Customresults.aspx`).
- **Standard issue screens:** `IssuesFromInvtoWO.aspx` vs `IssuesFromInvtoWOL.aspx` — query typically includes `sJob`, `sSuffix`, `sSeq`, `sReturnpath`, optional `sLot` / `sBin`.
- Always run untrusted path segments through **`F.Intrinsic.String.MakeURLFriendly`** before inserting into query strings—**especially** nested `sReturnpath` stacks.

### 12.5 Custom configuration table pattern

Long transactions accumulate tunables (feature toggles, sort orders, RTS transaction ids). Instead of hardcoding constants:

1. **Create a company-scoped table** (7730: **`GAB_7730_MATL_PICKLIST_MAINT`**) with descriptive columns—one logical row per deployment.
2. Ship a **small maintenance `.g2u`** for analysts (`SELECT *` grid + save) or document SQL seed scripts.
3. Read once near the top of `Main` via **`DataTable.CreateFromSQL`** on the **company** connection—**after** mobile fields are loaded if ordering matters.

This keeps MobExt lean (operator controls only) while preserving analyst-managed behavior separate from XML imports.

### 12.6 Annotated headless template (≤150 lines)

Use as a **starting skeleton**—replace SQL, field counts, and business subs. **Do not** paste/modify `Program.Sub.Comments` from production scripts. Follow `agents/gab/PATTERNS.md` **Pattern C** (`SetErrorHandler`, unique connection tags).

```
Program.Sub.Preflight.Start
	V.Global.sTransID.Declare(String)
	V.Global.sTransType.Declare(String)
	V.Global.sHtml.Declare(String)
	V.Global.iCustomTransID.Declare(Long)
	V.Global.sSQL.Declare(String)
Program.Sub.Preflight.End

Program.Sub.Main.Start
	F.Intrinsic.Control.SetErrorHandler("Main_Err")
	F.Intrinsic.Control.ClearErrors

	V.Local.bHaveId.Declare(Boolean,False)
	F.Intrinsic.Variable.PassedExists("DATA-TRANSID",V.Local.bHaveId)
	F.Intrinsic.Control.If(V.Local.bHaveId,=,False)
		V.Global.sHtml.Set("<html><body><p>Missing DATA-TRANSID.</p></body></html>")
		F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,"",V.Global.sHtml)
		F.Intrinsic.Control.End
	F.Intrinsic.Control.EndIf

	V.Global.sTransID.Set(V.Passed.DATA-TRANSID)
	F.ODBC.Connection!Con.OpenCompanyConnection(300)
	F.ODBC.Connection!conC.OpenCommonConnection

	'-- Load operator fields + routing token from WIRELESS_LINE (expand Field list to match DTLABELS count)
	F.Intrinsic.String.Build("SELECT Field_1, Field_2, Trans_Type FROM WIRELESS_LINE WHERE TRANS_ID='{0}'",V.Global.sTransID,V.Global.sSQL)
	F.Data.DataTable.CreateFromSQL("dtWL","Con",V.Global.sSQL,True)
	F.Intrinsic.Control.If(V.DataTable.dtWL.RowCount,>,0)
		V.Global.sTransType.Set(V.DataTable.dtWL(0).Trans_Type!FieldValTrim)
		F.Intrinsic.String.Mid(V.Global.sTransType,2,2,V.Global.iCustomTransID)
		'-- Map V.DataTable.dtWL(0).Field_1!FieldValTrim / Field_2 … into globals; validate inputs
	F.Intrinsic.Control.EndIf
	F.Data.DataTable.Close("dtWL")

	'-- TODO: company-data business logic on Con (queries, CallWrappers, etc.)

	F.Intrinsic.String.Build("<html><body><h3>OK</h3><p>TXID {0}</p></body></html>",V.Global.sTransID,V.Global.sHtml)
	F.Intrinsic.Control.CallSub(WriteMobileHtmlToCommon)
	'-- Optional small handoff still uses mobile API:
	F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,"<html><body></body></html>")

	F.ODBC.Connection!Con.Close
	F.ODBC.Connection!conC.Close
	F.Intrinsic.Control.End

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
	F.Intrinsic.Control.CallSub(CatchingMobile)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End

Program.Sub.WriteMobileHtmlToCommon.Start
	F.Intrinsic.String.Build("DELETE FROM Mobile_Custom_Result WHERE cocode='{0}' AND txid='{1}'",V.Caller.CompanyCode,V.Global.sTransID,V.Global.sSQL)
	F.ODBC.Connection!conC.Execute(V.Global.sSQL)
	F.Data.DataTable.Create("dtR",True)
	F.Data.DataTable.AddColumn("dtR","CoCode","String","")
	F.Data.DataTable.AddColumn("dtR","Txid","String","")
	F.Data.DataTable.AddColumn("dtR","Results","String","")
	F.Data.DataTable.AddRow("dtR","CoCode",V.Caller.CompanyCode,"TXID",V.Global.sTransID,"Results",V.Global.sHtml)
	F.Data.DataTable.SaveToDB("dtR","conC","Mobile_Custom_Result","","128","CoCode@!@CoCode*!*TXID@!@TXID*!*Results@!@Results")
	F.Data.DataTable.Close("dtR")
Program.Sub.WriteMobileHtmlToCommon.End

Program.Sub.CatchingMobile.Start
	F.Intrinsic.String.Build("<html><body style='color:red'><p>{0}</p><p>{1}</p></body></html>",V.Ambient.ErrorDescription,V.Ambient.CurrentSubroutine,V.Global.sHtml)
	F.Global.Mobile.SetCustomResult(V.Caller.CompanyCode,V.Global.sTransID,V.Global.sHtml)
Program.Sub.CatchingMobile.End
```

**Notes:**

- **7730 production** still wraps the outer body in **`Try/Catch`** ending in **`Msgbox`** — replace with **`CatchingMobile`** (or write an error row to **`Mobile_Custom_Result`**) when targeting GS Mobile operators.
- Drop the empty **`SetCustomResult`** line if your environment truly reads **only** `Mobile_Custom_Result`.
- This skeleton **reads** **`WIRELESS_LINE`** only. If the script must **create** new wireless rows (reserve a **`TRANS_ID`**, insert **`WIRELESS_HDR`** / **`WIRELESS_LINE`**, stage **`ATTEMPTED_FLAG`**, paired **A10** issue/receipt, etc.), follow **§15** (`GAB_7640_Mobile_RollTransferPalletID.g2u`).

### 12.7 Standard deployment checklist

1. **Sign first, then zip:** Compile the `.g2u` in the GAB editor, then **sign it** to produce a current **`.g2u.sig`**. Copy both **`.g2u` + `.sig`** to **`<Global>\PLUGINS\GAB\GAS\`**.
2. Assemble **`.g2u-MobExt.zip`** containing the **already-signed** `.g2u`, `.g2u.sig`, `DTTRANS`, `DTLABELS`, `DTOPTION`. The `.sig` must be the signature generated in step 1 -- never zip without it.
3. Import the ZIP via **GS Mobile admin** (registers `TID` / metadata).
4. Apply SQL for any supporting tables (`GAB_7730_MATL_PICKLIST_MAINT` style) and grant ODBC accordingly.
5. Smoke-test **`Custom.aspx`**, **`CustomResults.aspx`**, **`IssuesFromInvtoWO.aspx`**, and **`IssuesFromInvtoWOL.aspx`** links on-device; verify **`Mobile_Custom_Result`** rows contain the expected HTML.

### 12.8 Multi-result pattern: primary + child HTML via `TransIDX` (7730)

**Source:** production **`GAB_7730_Mobile_MatlPicklist.g2u`**.

**Overview:** The script writes **multiple** rows to **`Mobile_Custom_Result`** for one submit: a **primary** result keyed by the original wireless **`sTransID`** (picklist overview), and **one child result per material sequence** keyed by a synthetic **`TransIDX`**. The primary HTML table includes **`<a href>`** cells built from **expression columns**; each link targets **`CustomResults.aspx`** with that row’s **`TransIDX`** passed as **`sTransID`**, so the operator drills from the grid into line-level detail. GS Mobile’s **`CustomResults.aspx`** reads **`sTransID`**, finds **`Mobile_Custom_Result`** where **`TXID`** matches, and renders **`Results`** (same write/read contract as a single blob — **§12.3**). **`sReturnpath`** carries an encoded URL for back navigation (**§12.4**, **§5.4**).

| Row role | `TXID` | Typical `Results` |
|----------|--------|-------------------|
| **Primary** | **`sTransID`** (same as **`V.Passed.DATA-TRANSID`**) | Overview grid; link column(s) point at children. |
| **Child** (loop: one per sequence) | **`TransIDX`** (9 chars, deterministic) | Detail HTML (e.g. lot/bin/qty via **`ExportHTML`** on a working DataTable). |

#### TransIDX generation

For each row in the overview DataTable (7730: **`dtOpenMatl`**), build a **9-character** synthetic key from the loop index, the row’s **SEQ**, and the **last two characters** of the original **`TRANS_ID`**, then left-truncate:

```
f.Intrinsic.String.Build("{2}{0}{1}",V.DataTable.dtOpenMatl(v.Global.iCnt).SEQ!FieldValTrim,v.Global.sTransID.right2,v.Global.iCnt,v.Global.sTransIDX)
f.Intrinsic.String.Left(v.Global.sTransIDX,9,v.Global.sTransIDX)
```

Persist **`TransIDX`** on the grid DataTable so expression columns and SQL share the same value:

```
f.Data.DataTable.AddColumn("dtOpenMatl","TransIDX","String")
F.Data.DataTable.SetValue("dtOpenMatl",v.Global.iCnt,"TransIDX",v.Global.sTransIDX)
```

#### Expression columns: links to `CustomResults.aspx`

7730 builds a reusable format string (e.g. **`slinkpath`**) and attaches it as an **expression column** so exported HTML contains clickable anchors (populate any **`RETURNPATH`** / display columns **before** **`ExportHTML`** — **§12.3**):

```
f.Intrinsic.String.Build("'<a href=CustomResults.aspx?sTXID='+{1}+'&sTransID='+{2}+'&sReturnpath='+{3}+'>'+'<p style=""color:blue"">'+{5}+'</p>'",v.Ambient.DblQuote,v.Global.iCustomTransID,"TRANSIDX","RETURNPATH","PART","DISPLAY_PART",v.Global.slinkpath)
f.Data.DataTable.AddExpressionColumn("dtOpenMatl","PartLink","string",V.Global.slinkpath)
```

Operator flow: **`CustomResults.aspx?sTXID=<custom id>&sTransID=<TransIDX>&sReturnpath=<encoded picklist URL>`** → child row’s **`Results`**.

#### Child results: DELETE + `SaveToDB` in the loop

For each material sequence, **delete** the stale child row by **`TransIDX`**, assemble detail HTML (7730: **`ExportHTML`** on **`dtItem`**, then wrap in a small styled HTML document), and **`SaveToDB`** a one-row DataTable on the **common** connection — same delimiter map as **§12.3**. Always **DELETE before insert** per key (**§15.6**).

```
f.Intrinsic.String.Build("Delete from Mobile_Custom_Result where cocode = '{0}' and txid = '{1}'",v.Caller.CompanyCode,V.DataTable.dtOpenMatl(v.Global.iCnt).TransIDX!FieldValTrim,v.Global.sSQL)
f.ODBC.Connection!conC.Execute(v.Global.sSQL)
' … ExportHTML("dtItem", …) + document wrapper → v.Global.sResultsX …
f.Data.DataTable.Create("dtResult",True)
f.Data.DataTable.AddColumn("dtResult","CoCode","String","")
f.Data.DataTable.AddColumn("dtResult","Txid","String","")
f.Data.DataTable.AddColumn("dtResult","Results","String","")
f.Data.DataTable.AddRow("dtResult","CoCode",v.Caller.CompanyCode,"TXID",V.DataTable.dtOpenMatl(v.Global.iCnt).TransIDX!FieldValTrim,"Results",v.Global.sResultsX)
f.Data.DataTable.SaveToDB("dtResult","conC","Mobile_Custom_Result","","128","CoCode@!@CoCode*!*TXID@!@TXID*!*Results@!@Results")
f.Data.DataTable.Close("dtResult")
```

#### `sReturnpath` chain (form → picklist → detail)

7730 builds **stacked** return URLs and runs **`F.Intrinsic.String.MakeURLFriendly`** on each string before it is embedded in another URL:

1. **Back to the originating custom form** — e.g. `Custom.aspx?sTXID=…&field1=<job>-<suffix>` (intermediate “unfriendly” string, then **`MakeURLFriendly`**).
2. **Back to the picklist (primary result)** — e.g. `Customresults.aspx?sTXID=…&sTransID=<original sTransID>`; friendly-encode for use as **`RETURNPATH`** / nested **`sReturnpath`** on grid rows.
3. **Primary row links** pass the picklist URL (or next hop) as **`sReturnpath`** on **`CustomResults.aspx`** so the child screen can navigate backward without losing context.

7730 also materializes the first two hops explicitly — **unfriendly** string first, then **`MakeURLFriendly`** into globals consumed by expression columns (**`RETURNPATH`** on **`dtOpenMatl`**):

```
' Return to custom form
f.Intrinsic.String.Build("Custom.aspx?sTXID={0}&field1={1}-{2}",v.Global.iCustomTransID,v.Global.sJob,v.Global.sSuffix,v.Global.sReturnpathUnfriendly)
f.Intrinsic.String.MakeURLFriendly(v.Global.sReturnpathUnfriendly,v.Global.sReturnpath)

' Return to picklist (primary) results
f.Intrinsic.String.Build("Customresults.aspx?sTXID={0}&sTransID={1}",v.Global.iCustomTransID.Long,v.Global.sTransID,v.Global.sReturnpathpicklistunfriendly)
f.Intrinsic.String.MakeURLFriendly(v.Global.sReturnpathpicklistunfriendly,v.Global.sReturnpathpicklist)
```

**§12.4** lists the same URL idioms; **§5.4** covers encoding and deployment-specific casing.

#### Simplified template

1. Resolve **`WIRELESS_LINE`** / business data (**§12.2**); fill the overview DataTable and compute **`TransIDX`** per row in the material loop.
2. **`DELETE`** the **primary** **`Mobile_Custom_Result`** row for **`sTransID`**; in the loop, **`DELETE`** each **child** by **`TransIDX`** before writing (**§15.6**).
3. For each child: build detail HTML (**`ExportHTML`** per **§12.3**), **`SaveToDB`** with **`TXID = TransIDX`**.
4. After link/expression columns and **`RETURNPATH`** exist on the overview grid, build primary **`Results`** and **`SaveToDB`** with **`TXID = sTransID`**.
5. Run **`MakeURLFriendly`** on every dynamic segment used in **`href`** or **`sReturnpath`** (**§5.4**).

### 12.9 Custom WIP to finished goods (ARC 6588 — workshop)

**Source:** GS Mobile Technical Workshop 2025.

| Item | Detail |
|------|--------|
| **ARC** | **6588** |
| **Admin** | **System Support > Administration > GS Mobile – Custom WIP to FG Maintenance** |
| **Behavior** | Uses **per-company form field mapping** so each company can run a **custom-designed** WIP → FG mobile screen (**per workshop deck — confirm fields/options on site**) |

### 12.10 Custom material picklist maintenance notes (ARC 7730 — workshop)

**Source:** GS Mobile Technical Workshop 2025 — supplements the **`GAB_7730`** pattern elsewhere in this section.

| Topic | Workshop detail |
|-------|-----------------|
| **ARC** | **7730** (aligns with the standard **Material Picklist** implementation referenced throughout §12) |
| **Maintenance** | **Custom Material Picklist Maintenance** defines **custom transaction results** and **behavior** |
| **Round-trip / chained custom mobiles** | Maintenance can **map another custom mobile** (workshop example: **Return to Stock / RTS**) to support **round-trip** operator flows |
| **`CustomResults.aspx` refresh** | Workshop cites the page refresh interval **0.5 seconds** (**down from 5 seconds**) — **confirm on target build** (page casing may be `Customresults.aspx` on some sites; §5.4) |

---

## 13. WIR200 standard wireless hooks (post/pre/report — workshop reference)

**Purpose:** Quick map from **wireless transaction families** to **GAB Script Hook Maintenance** IDs **as presented** in GS Mobile Technical Workshop 2025. **Per workshop deck — confirm** hook IDs on the customer database (`agents/schema/HOOK.md`, live **GAB Script Hook Maintenance**, and any site-specific overrides).

**Admin path (workshop):** **System Support > Administration > GAB Script Hook Maintenance**.

### 13.1 Post-process hooks (WIR200)

| Hook ID | Transaction (workshop label) |
|--------:|-------------------------------|
| **31982** | **J55** — Issue to WO |
| **31981** | **O90** — Bin to Bin |
| **31954** | **S20** — Shipping/Modify |
| **31953** | **P16** — Manual/Physical Inventory |
| **31952** | **S10/S15** — Shipping/Add |
| **31908** | **A10** — Stand-alone issue/receipt (**Avery uses this hook for T-Card** — aligns with §11) |
| **31951** | **P10** — PO Receipt |

### 13.2 Pre-process hooks (WIR200)

| Hook ID | Transaction (workshop label) |
|--------:|-------------------------------|
| **31955** | **P10** — PO Receipt |

### 13.3 Bin Status `Wirepoll.exe` report hook

| Hook ID | Role (workshop) |
|--------:|------------------|
| **31980** | **Report hook** for **Bin Status** / **`Wirepoll.exe`** flows |

---

## 14. Wireless table reference (`WIRELESS_HDR` + `WIRELESS_LINE`)

**Purpose:** When a wireless line is staged in **`WIRELESS_HDR` / `WIRELESS_LINE`**, **the transaction type determines how the system interprets the `Field_X` values** in the **`WIRELESS_LINE`** row. This section is the **kit copy** of the official GSS **Global Shop Solutions — Wireless-Line Table Guide** (Helpjuice — [Wireless-Line Table Guide](https://globalshopsolutions.helpjuice.com/GS-Mobile-/wireless-line-table-guide), **last published 2026-03-16**). **Triangulate** wording and hook behavior with `agents/schema/WIRELESS.md`, live samples, and the installed GS Mobile build.

### 14.0 `WIRELESS_HDR` column reference

Every wireless transaction has exactly one `WIRELESS_HDR` row. The header carries routing, ownership, and processing-state columns -- the business payload lives in `WIRELESS_LINE` (sections 14.1+). Columns verified from live data and production insert patterns (section 15):

| Column | Type / Width | Description | Typical value |
|--------|-------------|-------------|---------------|
| `TRANS_ID` | String(9) | **Primary key** -- 9-digit zero-padded sequential id. Generated via `SELECT MAX + 1` inside a retry loop (section 15.2). | `000004837` |
| `TRANS_TYPE` | String | Transaction type code -- standard codes (`A10`, `P10`, `O90`, `J55`, ...) per section 14.1; custom codes **`C01`--`C20`** per section 14.20. | `C14`, `A10` |
| `SUCCESSFUL_FLAG` | String(1) | Set to **`'Y'`** by WIREPOLL after the transaction processes successfully. **Do not set** this on insert -- WIREPOLL owns it. | `Y` (after processing) |
| `ATTEMPTED_FLAG` | String(1) | **Staging gate for WIREPOLL.** Insert with **`'Y'`** to hold the row; clear to **`''`** (empty) after `WIRELESS_LINE` is written to release for processing (section 15.3). | `'Y'` on insert, `''` to release |
| `ATTEMPTED_DATE` | String(8) | Date the transaction was staged. Format **`YYYYMMDD`**. Use `'00000000'` as a placeholder on insert. | `20260514` |
| `ATTEMPTED_TIME` | String(8) | Time the transaction was staged. Format **`HHMMSShh`** (hours, minutes, seconds, hundredths). Use `'00000000'` as a placeholder on insert. | `08242400` |
| `DEFAULT_PRINTER` | String | Default printer for the transaction. Uses **`UPID:##`** format (printer id reference) from the mobile session. | `UPID:53` |
| `LABEL_PRINTER` | String | Label printer for the transaction. Same **`UPID:##`** format. Retrieved via `GetCustomPrinter` or from `Session["LabelPrinter"]`. | `UPID:52` |
| `USER_ID` | String | Mobile user who submitted the transaction. Sourced from the mobile session (`Session["UserID"]`) or the original `WIRELESS_HDR.USER_ID` when creating derived transactions. | `WBLS` |
| `BATCH` | Integer | Batch number. Typically **`0`** for custom mobile transactions. | `0` |

**Insert template** (from section 15.2 retry pattern):

```
INSERT INTO WIRELESS_HDR (TRANS_ID, TRANS_TYPE, ATTEMPTED_DATE, ATTEMPTED_TIME, USER_ID, BATCH, ATTEMPTED_FLAG, LABEL_PRINTER)
VALUES ('<transId>', '<type>', '00000000', '00000000', '<userId>', 0, 'Y', '<printer>')
```

**Printer format note:** Standard GS Mobile stores printer references as **`UPID:##`** (e.g., `UPID:53`). The Avery ASP.NET pattern (section 11) stores raw printer strings from `Session["DefaultPrinter"]` / `Session["LabelPrinter"]` -- both formats are valid depending on the integration path. Use `F.Global.Mobile.GetCustomPrinter` / `GetPrinterNameFromId` when resolving from GAB.

---


**Numeric convention (“`0000` always appended”):** For fields called out that way below, the stored wireless string carries **four implied decimal places** (the product **appends a `0000` scale** to the numeric payload — interpret quantities/weights/cost-like numerics accordingly in scripts and audits).

### 14.1 Transaction type overview (`Trans_Type` → primary ASP.NET pages)

| `Trans_Type` | Name | ASP.NET pages (representative `.aspx.vb` sources) |
|--------------|------|---------------------------------------------------|
| **P16** | Physical Inventory & Physical Inventory by Lot | `PhysicalInventory.aspx.vb`, `PhysicalInventoryL.aspx.vb` |
| **P19** | Manual Inventory Adjustment & Manual Inventory Adjustment by Lot | `ManualInventory.aspx.vb`, `ManualInventoryL.aspx.vb` |
| **O90** | Bin-to-Bin Transfer & Bin-to-Bin Transfer by Lot | `BinToBinTransfer.aspx.vb`, `BinToBinTransferL.aspx.vb` |
| **BSR** | Bin Status Report | `BinStatus-02.aspx.vb` |
| **P10** | PO Receipts | `PORcptToInv.aspx.vb`, `PORcptToInvL.aspx.vb`, `PORcptToInsp.aspx.vb` |
| **J10** | Standalone Receipt to Work Order | `StandAloneRcptToWO.aspx.vb` |
| **J55** | Issue from Inventory to Work Order | `IssuesFromInvtoWO.aspx.vb`, `IssuesFromInvtoWOL.aspx.vb` |
| **S10** | Add Part / Create Carton / Pallet | `Shipping-AddPart.aspx.vb`, `Shipping-Carton.aspx.vb`, `Shipping-Pallet.aspx.vb` (+ `L` variants) |
| **S15** | Bin-to-Bin & Add Part / Create Carton / Pallet | **Same family as S10** (guide cites **402681 / 402701** screen variants) |
| **S20** | Modify Shipment | `Shipping-Modify.aspx.vb`, `Shipping-Pallet.aspx.vb` (+ `L` variants) |
| **S30** | Remove Shipment | `Shipping-Review.aspx.vb` |
| **S40** | Complete Shipment | `Shipping-Review.aspx.vb` |
| **S50** | Change Carrier | `Shipping-02.aspx.vb`, `Shipping-03.aspx.vb`, `Shipping-Review.aspx.vb`, `ShippingL-03.aspx.vb` |
| **CP1** | Create Container | `CP-CreateContainer.aspx.vb` |
| **CP2** | Create Master (Add Container to Pallet/Master) | `CP-CreateMaster.aspx.vb` |
| **L10** | Labor Entry | `LaborTimeCard.aspx.vb`, `StdLabor.aspx.vb` |
| **T10** | Employee Clock In / Clock Out | `TimeClock.aspx.vb` |
| **A10** | Standalone Issue and Receipt | `StandAloneIssAndRcpt.aspx.vb` |
| **C01, C02, …** | Custom transactions | User-defined forms (DB labels / control types / options); persists like any wireless transaction — field semantics come from that company’s MobExt mapping (**not** the tables below). |

### 14.2 `P16` — Physical Inventory

| Field | Description |
|-------|-------------|
| `Field_1` | Part |
| `Field_2` | Location |
| `Field_3` | Quantity (numeric — “`0000`” always appended) |
| `Field_4` | Bin |
| `Field_5` | Lot |
| `Field_6` | Heat |
| `Field_7` | Serial |
| `Field_8` | Gross Weight (numeric — “`0000`” always appended) |
| `Field_9` | Tare Weight (numeric — “`0000`” always appended) |
| `Field_10` | Reference |
| `Field_11` | Label Quantity (integer) |
| `Field_12`–`Field_24` | Not Used |
| `Field_25` | Print Labels Flag (Y/N) |

### 14.3 `P19` — Manual Inventory Adjustment

| Field | Description |
|-------|-------------|
| `Field_1` | Part |
| `Field_2` | Location |
| `Field_3` | Quantity (numeric) |
| `Field_4` | Bin |
| `Field_5` | Lot |
| `Field_6` | Heat |
| `Field_7` | Serial |
| `Field_8` | Gross Weight (numeric — “`0000`” always appended) |
| `Field_9` | Tare Weight (numeric — “`0000`” always appended) |
| `Field_10` | Reference |
| `Field_11` | Label Quantity (integer — use **0** for no labels) |
| `Field_12`–`Field_25` | Not Used |

### 14.4 `O90` — Bin-to-Bin Transfer

| Field | Description |
|-------|-------------|
| `Field_1` | Part |
| `Field_2` | Location |
| `Field_3` | Quantity (numeric — “`0000`” always appended) |
| `Field_4` | From Bin |
| `Field_5` | To Bin |
| `Field_6` | Lot |
| `Field_7` | Heat |
| `Field_8` | Serial |
| `Field_9` | Gross Weight (numeric — “`0000`” always appended) |
| `Field_10` | Tare Weight (numeric — “`0000`” always appended) |
| `Field_11` | Reference |
| `Field_12` | Label Quantity (integer — **0** for no labels) |
| `Field_13` | To Location |
| `Field_14` | To Lot |
| `Field_15` | To Heat |
| `Field_16` | To Serial |
| `Field_17`–`Field_25` | Not Used |

### 14.5 `BSR` — Bin Status Report

| Field | Description |
|-------|-------------|
| `Field_1` | Bin |
| `Field_2`–`Field_25` | Not Used |

### 14.6 `P10` — PO Receipts

| Field | Description |
|-------|-------------|
| `Field_1` | PO Number |
| `Field_2` | PO Line |
| `Field_3` | Bin |
| `Field_4` | Lot |
| `Field_5` | Heat |
| `Field_6` | Serial |
| `Field_7` | Date (MMDDYY) |
| `Field_8` | Quantity (numeric — “`0000`” always appended) |
| `Field_9` | Receiver Number |
| `Field_10` | Cost (numeric) |
| `Field_11` | Close Flag (Y/N) |
| `Field_12` | Job |
| `Field_13` | Suffix |
| `Field_14` | Sequence |
| `Field_15` | SAP PO Number |
| `Field_16` | Packing List |
| `Field_17` | Receiver Text |
| `Field_18` | Label Quantity (integer — **0** for no labels) |
| `Field_19` | Rejected Quantity (numeric) |
| `Field_20` | Rejection Code |
| `Field_21` | To Inspection Flag (Y/N) |
| `Field_22` | Inventory Quantity (numeric — “`0000`” always appended) |
| `Field_23` | Inventory UM |
| `Field_24` | Purchase UM |
| `Field_25` | Not Used |

### 14.7 `J10` — Standalone Receipt to Work Order

| Field | Description |
|-------|-------------|
| `Field_1` | Part |
| `Field_2` | Description |
| `Field_3` | Receipt Date |
| `Field_4` | Receipt Time |
| `Field_5` | Employee Number |
| `Field_6` | Job |
| `Field_7` | Suffix |
| `Field_8` | Sequence |
| `Field_9` | Quantity |
| `Field_10` | Cost |
| `Field_11`–`Field_25` | Not Used |

### 14.8 `J55` — Issue from Inventory to Work Order

| Field | Description |
|-------|-------------|
| `Field_1` | Part |
| `Field_2` | Revision |
| `Field_3` | Location |
| `Field_4` | Quantity (numeric — “`0000`” always appended) |
| `Field_5` | Lot |
| `Field_6` | Bin |
| `Field_7` | Heat |
| `Field_8` | Serial |
| `Field_9` | Job |
| `Field_10` | Suffix |
| `Field_11` | Sequence |
| `Field_12` | Label Quantity (integer — **0** for no labels) |
| `Field_13`–`Field_25` | Not Used |

### 14.9 `S10` — Shipping: Add Part / Create Carton / Pallet

| Field | Description |
|-------|-------------|
| `Field_1` | Shipment ID |
| `Field_2` | Order Number |
| `Field_3` | Line |
| `Field_4` | Part |
| `Field_5` | Location |
| `Field_6` | Lot |
| `Field_7` | Bin |
| `Field_8` | Heat |
| `Field_9` | Serial |
| `Field_10` | Carton Number |
| `Field_11` | Pallet Number |
| `Field_12` | Carton Container Code |
| `Field_13` | Pallet Container Code |
| `Field_14` | Quantity |
| `Field_15` | Part Weight |
| `Field_16` | Carton Weight |
| `Field_17` | Carton Tracking Number |
| `Field_18` | Pallet Weight |
| `Field_19` | Pallet Tracking Number |
| `Field_20` | Complete Line Flag (0/1) |
| `Field_21`–`Field_22` | *(Not listed in the 2026-03-16 guide text transcribed here — confirm on-site if populated.)* |
| `Field_23` | Number of Cartons |
| `Field_24` | Print Labels Flag (Y/N) |
| `Field_25` | Label Quantity |

### 14.10 `S15` — Bin-to-Bin & Add Part / Create Carton / Pallet

Per the **2026-03-16** guide: **same layout as §14.9 (`S10`)** with these substitutions/additions:

- **`Field_7` = To Bin** (instead of **Bin** on `S10`).
- **`Field_22` = From Bin** (**added** versus the published `S10` excerpt, which jumps from `Field_20` to `Field_23`).

| Field | Description |
|-------|-------------|
| `Field_1` | Shipment ID |
| `Field_2` | Order Number |
| `Field_3` | Line |
| `Field_4` | Part |
| `Field_5` | Location |
| `Field_6` | Lot |
| `Field_7` | **To Bin** |
| `Field_8` | Heat |
| `Field_9` | Serial |
| `Field_10` | Carton Number |
| `Field_11` | Pallet Number |
| `Field_12` | Carton Container Code |
| `Field_13` | Pallet Container Code |
| `Field_14` | Quantity |
| `Field_15` | Part Weight |
| `Field_16` | Carton Weight |
| `Field_17` | Carton Tracking Number |
| `Field_18` | Pallet Weight |
| `Field_19` | Pallet Tracking Number |
| `Field_20` | Complete Line Flag (0/1) |
| `Field_21` | *(Not listed in the 2026-03-16 guide text transcribed here — confirm on-site if populated.)* |
| `Field_22` | **From Bin** |
| `Field_23` | Number of Cartons |
| `Field_24` | Print Labels Flag (Y/N) |
| `Field_25` | Label Quantity |

### 14.11 `S20` — Modify Shipment

| Field | Description |
|-------|-------------|
| `Field_1` | Shipment ID |
| `Field_2` | Order Number |
| `Field_3` | Line |
| `Field_4` | Part |
| `Field_5` | Location |
| `Field_6` | Lot |
| `Field_7` | Bin |
| `Field_8` | Heat |
| `Field_9` | Serial |
| `Field_10` | Carton Number |
| `Field_11` | Pallet Number |
| `Field_12` | Carton Container Code |
| `Field_13` | Pallet Container Code |
| `Field_14` | Quantity |
| `Field_15` | Part Weight |
| `Field_16` | Carton Weight |
| `Field_17` | Carton Tracking Number |
| `Field_18` | Pallet Weight |
| `Field_19` | Pallet Tracking Number |
| `Field_20` | New Carton Number |
| `Field_21` | New Pallet Number |
| `Field_22` | Remove from Carton (Y/N) |
| `Field_23` | Remove from Pallet (Y/N) |
| `Field_24` | Print Labels Flag (Y/N) |
| `Field_25` | Label Quantity |

### 14.12 `S30` — Remove Shipment

| Field | Description |
|-------|-------------|
| `Field_1` | Shipment ID |
| `Field_2` | Order Number |
| `Field_3` | Line |
| `Field_4` | Part |
| `Field_5` | Location |
| `Field_6` | Carton Number |
| `Field_7` | Pallet Number |
| `Field_8` | Quantity |
| `Field_9` | Lot |
| `Field_10` | Bin |
| `Field_11` | Heat |
| `Field_12` | Serial |
| `Field_13`–`Field_25` | Not Used |

### 14.13 `S40` — Complete Shipment

| Field | Description |
|-------|-------------|
| `Field_1` | Shipment ID |
| `Field_2` | Carrier |
| `Field_3`–`Field_23` | Not Used |
| `Field_24` | Print Labels Flag (Y/N) |
| `Field_25` | Label Quantity |

### 14.14 `S50` — Change Carrier

| Field | Description |
|-------|-------------|
| `Field_1` | Shipment ID |
| `Field_2` | Carrier Code (`Carrier_CD`) |
| `Field_3` | Service Type (`Srvc_Type`) |
| `Field_4`–`Field_25` | Not Used |

### 14.15 `CP1` — Create Container

| Field | Description |
|-------|-------------|
| `Field_1` | Customer |
| `Field_2` | Part |
| `Field_3` | Bin 1 |
| `Field_4` | Heat 1 |
| `Field_5` | Lot 1 |
| `Field_6` | Quantity 1 |
| `Field_7` | Bin 2 |
| `Field_8` | Heat 2 |
| `Field_9` | Lot 2 |
| `Field_10` | Quantity 2 |
| `Field_11` | Order |
| `Field_12` | Print Quantity |
| `Field_13`–`Field_25` | Not Used |

### 14.16 `CP2` — Create Master

| Field | Description |
|-------|-------------|
| `Field_1` | Customer |
| `Field_2` | Master (Pallet ID) |
| `Field_3` | Container |
| `Field_4`–`Field_25` | Not Used |

### 14.17 `L10` — Labor Entry

| Field | Description |
|-------|-------------|
| `Field_1` | Date (MMDDYY) |
| `Field_2` | Employee Number |
| `Field_3` | Job |
| `Field_4` | Suffix |
| `Field_5` | Sequence |
| `Field_6` | Workcenter |
| `Field_7` | Time Applied (minutes) |
| `Field_8` | Closed Flag (Y/N) |
| `Field_9` | Indirect Flag (D, I, S) |
| `Field_10` | Start Time (HHMM) |
| `Field_11` | Stop Time (HHMM) |
| `Field_12` | Rate Type (R, O, 2) |
| `Field_13` | Good Pieces (#0000) |
| `Field_14` | Scrap Pieces (#0000) |
| `Field_15` | Scrap Reason Code |
| `Field_16`–`Field_25` | Not Used |

### 14.18 `T10` — Employee Clock In / Clock Out

| Field | Description |
|-------|-------------|
| `Field_1` | Transaction Date |
| `Field_2` | Employee Number |
| `Field_3` | Employee Name |
| `Field_4` | Time In |
| `Field_5` | Time Out |
| `Field_6`–`Field_25` | Not Used |

### 14.19 `A10` — Standalone Issue and Receipt

| Field | Description |
|-------|-------------|
| `Field_1` | Part |
| `Field_2` | Revision |
| `Field_3` | Location |
| `Field_4` | Quantity |
| `Field_5` | Reference |
| `Field_6` | Lot |
| `Field_7` | Bin |
| `Field_8` | Heat |
| `Field_9` | Serial |
| `Field_10` | Issue/Receipt Flag |
| `Field_11` | Reserved Value (`"N"`) |
| `Field_12` | GL Account |
| `Field_13` | Cost |
| `Field_14` | Cost Flag |
| `Field_15`–`Field_25` | Not Used |

### 14.20 `C01`, `C02`, … — Custom transactions

Custom transactions are **user-defined** GS Mobile forms. You configure them in the database (labels, control types, options); the site renders the form from that configuration, captures values, and persists them as normal wireless transactions (for example **`C01`**, **`C02`**, …) on **`WIRELESS_HDR` / `WIRELESS_LINE`**. **Any `Trans_Type` containing this `Cxx` pattern should be treated as a custom-definition family** — map fields via **`DTLABELS.ORDERNO` → `FIELD_N`** (§12.2), not via §14.2–§14.19.

**Relationship to §13 (`WIR200` hooks):** Standard product codes in the left column of §14.1 align with the workshop hook examples in **§13**; **custom `Cxx` posts** still route through the **39001–39020** GAB bindings in §3.5 / §1 rather than the `WIR200` table (unless your site has a project-specific overlay — **confirm** on the customer system).

---

## 15. Writing `WIRELESS_HDR` / `WIRELESS_LINE` (best practice)

**Primary reference:** **`GAB_7640_Mobile_RollTransferPalletID.g2u`** — **Roll Transfer by Pallet ID** custom mobile transaction (Brady Stevens, **DRC**, **2024-07-29**). That script performs a two-step **A10** transfer (issue from source + receipt to destination) and is **production-proven** for concurrent wireless posting. **§14** documents what to **read** from **`WIRELESS_LINE`**; this section documents how to **write** header/line pairs safely.

Schema detail remains in **`agents/schema/WIRELESS.md`**.

### 15.1 The concurrency problem

A naïve pattern — **one** `SELECT MAX(TRANS_ID)+1` **outside** a retry loop, then `INSERT` — fails under concurrency: two sessions can read the same “next” id and the second **`INSERT INTO WIRELESS_HDR`** hits **Actian Zen / Btrieve duplicate key** (**Error 5**). Mobile and shop-floor traffic can overlap enough for this to occur in practice.

**Implication:** reserve **`TRANS_ID`** with a loop that **re-queries** the high key on every attempt and **catches** insert failures, backing off and retrying with a fresh candidate id.

### 15.2 Try/Catch/DoUntil retry pattern (`WIRELESS_HDR` insert)

Use a **`DoUntil`** that exits only after a successful insert. **Inside** the loop:

1. **`SELECT TOP 1`** the latest **`TRANS_ID`**, compute **+1**, and format as a **9-character zero-padded** string ( **`RIGHT(CONCAT('000000000', CAST(TRANS_ID AS INT)+1), 9)`** pattern in SQL, then **`LPad`** to 9 in GAB if needed).
2. Build the **`INSERT INTO WIRELESS_HDR`** (see **§15.3** for **`ATTEMPTED_FLAG = 'Y'`** on first insert).
3. **`Try`** — **`Execute`** the SQL; on success set **`bHdrInserted = True`** (or equivalent) so **`DoUntil`** exits.
4. **`Catch`** — increment a retry counter, **log** the collision (timestamp, retry #, candidate **`TRANS_ID`**, **`V.Ambient.ErrorDescription`**), **`Sleep` ~1000 ms**, and **continue** the loop (do **not** exit on first Error 5).
5. Cap retries (7640 uses **20**); then **`RaiseError`** with a clear message (7640: **20004**, “Failed to reserve … TRANS_ID after 20 retries”).

**Illustrative shape** (match connection/variable names to your program; expressions follow GAB conventions — e.g. **`V.Local.iRetry+1`** without extra staging):

```
V.Local.iRetry.Set(0)
V.Local.bHdrInserted.Set(False)
F.Intrinsic.Control.DoUntil(V.Local.bHdrInserted,=,True)
    F.ODBC.Connection!Con.ExecuteAndReturn("SELECT TOP 1 RIGHT(CONCAT('000000000',CAST(TRANS_ID AS INT)+1),9) AS TRANS_ID FROM WIRELESS_HDR ORDER BY TRANS_ID DESC",V.Local.sTransIDNew)
    F.Intrinsic.String.LPad(V.Local.sTransIDNew,"0",9,V.Local.sTransIDNew)
    F.Intrinsic.String.Build("INSERT INTO WIRELESS_HDR (TRANS_ID,TRANS_TYPE,ATTEMPTED_DATE,ATTEMPTED_TIME,USER_ID,BATCH,ATTEMPTED_FLAG,LABEL_PRINTER) VALUES ('{0}','A10','00000000','00000000','{1}',0,'Y','{2}')",V.Local.sTransIDNew,V.Local.sUserID,V.Local.sUPID,V.Local.sSQL)
    F.Intrinsic.Control.Try
        F.ODBC.Connection!Con.Execute(V.Local.sSQL)
        V.Local.bHdrInserted.Set(True)
    F.Intrinsic.Control.Catch
        V.Local.iRetry.Set(V.Local.iRetry+1)
        F.Intrinsic.String.Build("{0} | Issue HDR Retry {1} | TRANS_ID collision on {2} | Error: {3}",V.Ambient.Now,V.Local.iRetry,V.Local.sTransIDNew,V.Ambient.ErrorDescription,V.Local.sLogMsg)
        F.Intrinsic.File.Append2FileNewLine(V.Local.sLogPath,V.Local.sLogMsg)
        F.Intrinsic.Control.If(V.Local.iRetry,>=,20)
            F.Intrinsic.Control.RaiseError(20004,"Failed to reserve Issue TRANS_ID after 20 retries")
        F.Intrinsic.Control.EndIf
        F.Intrinsic.Control.Sleep(1000)
    F.Intrinsic.Control.EndTry
F.Intrinsic.Control.Loop
```

**Key elements:**

- **Re-select inside the loop** so each retry sees **`TRANS_ID`** values committed after other sessions.
- **`ATTEMPTED_FLAG = 'Y'`** on the successful **`WIRELESS_HDR`** insert until the line is complete (**§15.3**).
- **`Try`/`Catch`/`EndTry`** isolates duplicate-key handling without abandoning the outer subroutine error model.

### 15.3 `ATTEMPTED_FLAG` staging (three-step write)

**WIREPOLL** must not process a header until the **line** row exists. 7640 uses a **three-step** sequence:

1. **`INSERT WIRELESS_HDR`** with **`ATTEMPTED_FLAG = 'Y'`** — header exists but is **not** released to normal polling/processing.
2. **`INSERT WIRELESS_LINE`** with all required columns: **`TRANS_ID`**, **`SEQ`** (e.g. `'0000'`), **`TRANS_TYPE`**, **`FIELD_1`**...**`FIELD_N`**, **`ERROR_ID`**, and the **mandatory audit columns** **`DATE_LAST_CHG`** (YYYYMMDD), **`TIME_LAST_CHG`** (HHNNSShh), **`LAST_CHG_BY`** (mobile USER_ID) -- see **§15.4** for formatting. **Never omit audit columns.**
3. **`UPDATE WIRELESS_HDR SET ATTEMPTED_FLAG=''`** (empty string) **`WHERE TRANS_ID='…'`** — releases the transaction for **WIREPOLL**.

**Line insert / release (conceptual — expand placeholders to match your field map):**

```
F.Intrinsic.String.Build("insert into WIRELESS_LINE (TRANS_ID,SEQ,TRANS_TYPE,FIELD_1,FIELD_2,FIELD_3,FIELD_4,FIELD_5,FIELD_6,FIELD_7,FIELD_8,FIELD_9,FIELD_10,FIELD_11,FIELD_13,ERROR_ID,DATE_LAST_CHG,TIME_LAST_CHG,LAST_CHG_BY) values ('{0}','0000','A10','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','Issue','N','{10}',0,'{11}','{12}','{13}')",V.Local.sTransIDNew,...,V.Local.sSQL)
F.ODBC.Connection!Con.Execute(V.Local.sSQL)

F.Intrinsic.String.Build("update WIRELESS_HDR set ATTEMPTED_FLAG='' where TRANS_ID='{0}'",V.Local.sTransIDNew,V.Local.sSQL)
F.ODBC.Connection!Con.Execute(V.Local.sSQL)
```

Adapt **`FIELD_10`** values per operation (**`Issue`** vs **`Receipt`** — **§15.6**).

### 15.4 `WIRELESS_LINE` audit columns (MANDATORY)

**Every `WIRELESS_LINE` insert must include these three audit columns.** Verified across 7640 and 7563:

| Column | Format | Source |
|--------|--------|--------|
| `DATE_LAST_CHG` | `YYYYMMDD` (String 8) | `V.Ambient.Now` formatted and parsed via `Mid` |
| `TIME_LAST_CHG` | `HHNNSShh` (String 8) | `V.Ambient.Now` formatted, parsed, `"00"` appended for hundredths |
| `LAST_CHG_BY` | String | Mobile operator `USER_ID` (from `WIRELESS_HDR.USER_ID` or session) |

7640/7563 derive date/time from **`V.Ambient.Now`**; set **`LAST_CHG_BY`** from the **operator** (not from the clock) — confirm against **`WIRELESS.md`** and the source script.

1. **`V.Local.sNowStamp.Set(V.Ambient.Now.FormatYYYYMMDDHHNNSS)`**
2. **`Mid`** positions **1–8** → **`DATE_LAST_CHG`** (**YYYYMMDD**).
3. **`Mid`** positions **9–14** → base time; **`Concat`** **two trailing zeros** so **`TIME_LAST_CHG`** is **HHNNSS** + **hundredths** as **`00`** (eight characters in the 7640 pattern: **`HHNNSS` + `"00"`**).

```
V.Local.sNowStamp.Set(V.Ambient.Now.FormatYYYYMMDDHHNNSS)
F.Intrinsic.String.Mid(V.Local.sNowStamp,1,8,V.Local.sDateChg)
F.Intrinsic.String.Mid(V.Local.sNowStamp,9,6,V.Local.sTimeChg)
F.Intrinsic.String.Concat(V.Local.sTimeChg,"00",V.Local.sTimeChg)
```

Confirm exact width expectations against **`agents/schema/WIRELESS.md`** and site conventions before go-live; port the same approach to other scripts only after verification.

### 15.5 Error logging (retry diagnostics)

For the retry loop in §15.2, log each collision to a file under **`V.Caller.FilesDir`** so analysts can verify retries were transient. Verified against both **7640** and **7563**:

```
V.Local.sLogPath.Declare(String)
V.Local.bLogExists.Declare(Boolean)
V.Local.sLogMsg.Declare(String)

F.Intrinsic.String.Build("{0}\GAB_XXXX_YourScript_Errors.log",V.Caller.FilesDir,V.Local.sLogPath)
F.Intrinsic.File.Exists(V.Local.sLogPath,V.Local.bLogExists)
F.Intrinsic.Control.If(V.Local.bLogExists,=,False)
	F.Intrinsic.File.String2File(V.Local.sLogPath,"Timestamp | Type | Retry | TRANS_ID | Error")
F.Intrinsic.Control.EndIf
```

**Critical:** Use **`F.Intrinsic.File.String2File`** to create the log file -- **`Append2FileNewLine` cannot create new files**. After the file exists, use **`Append2FileNewLine`** inside the `Catch` block to add each retry record:

```
F.Intrinsic.String.Build("{0} | HDR Retry {1} | TRANS_ID collision on {2} | Error: {3}",V.Ambient.Now,V.Local.iRetry,V.Global.sTransID,V.Ambient.ErrorDescription,V.Local.sLogMsg)
F.Intrinsic.File.Append2FileNewLine(V.Local.sLogPath,V.Local.sLogMsg)
```

Place the log initialization **before** the `DoUntil` loop (either near the top of `Main` or at the start of a dedicated `GetNextTransID` subroutine).

### 15.6 Writing to `MOBILE_CUSTOM_RESULT` (MANDATORY: always DELETE first)

**Rule: Always `DELETE` the existing row before inserting.** A stale result from a prior submit of the same `TXID` will confuse the operator or display outdated data. This applies regardless of whether you use `DataTable.SaveToDB` or raw SQL.

**Standard pattern (raw SQL on common connection):**

```
F.Intrinsic.String.Build("DELETE FROM MOBILE_CUSTOM_RESULT WHERE COCODE='{0}' AND TXID='{1}'",V.Caller.CompanyCode,V.Local.sTransID,V.Local.sSQL)
F.ODBC.Connection!ConC.Execute(V.Local.sSQL)
F.Intrinsic.String.Build("INSERT INTO MOBILE_CUSTOM_RESULT (COCODE,TXID,RESULTS) VALUES ('{0}','{1}','{2}')",V.Caller.CompanyCode,V.Local.sTransID,V.Local.sResults,V.Local.sSQL)
F.ODBC.Connection!ConC.Execute(V.Local.sSQL)
```

**Alternative (DataTable.SaveToDB, 7730-style -- §4.1):**

```
F.Intrinsic.String.Build("DELETE FROM Mobile_Custom_Result WHERE cocode='{0}' AND txid='{1}'",V.Caller.CompanyCode,V.Local.sTransID,V.Local.sSQL)
F.ODBC.Connection!conC.Execute(V.Local.sSQL)
F.Data.DataTable.SaveToDB("dtResult","conC","Mobile_Custom_Result","","128","CoCode@!@CoCode*!*TXID@!@TXID*!*Results@!@Results")
```

Both approaches write to the **common** connection (`ConC` / `conC` via `OpenCommonConnection`).

**When to use which:** Use raw SQL for simple single-result writes. Use `DataTable.SaveToDB` when the HTML is already being built from DataTable operations (e.g. `ExportHTML`).

The 7640 source also **reads `USER_ID`** from **`WIRELESS_HDR`** for the inbound **`TRANS_ID`** when child posts must carry the same operator; uses a **`WIRELESS_LINE` INNER JOIN `WIRELESS_HDR`** query to include **`Label_Printer`** (and similar header-only columns) alongside line fields; and drives **Codesoft** labels via **`F.Global.BI.InitializeReport`** / **`F.Global.BI.PrintCodesoftLabel`** with **`*!*`-delimited** name/value arrays — see that script and **`agents/gab/INTEGRATION.md`** for BI details.

---

## Rules acknowledgement (for agents loading this file)

1. **`agents/AGENTS.GAB.md` golden rule** applies: only documented GAB APIs and patterns.
2. **Triangulate schema** with `agents/schema/*.md` and live metadata for SQL.
3. **Register security IDs and mobile config strings** from authoritative GSS sources — never fabricate.
