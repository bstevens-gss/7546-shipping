# Schema PK/FK/Table Review Findings
# Reviewed 2026-05-11 — All 112 schema files audited
# Remediation applied 2026-05-11 — Doc-only fixes complete; DB-dependent items deferred

---

## Executive Summary

Reviewed all 112 `agents/schema/*.md` files against `agents/AGENTS.GSSDB.md`. Found **critical gaps** in hub table documentation, a **systemic date/time self-FK bug** across 15+ tables, numerous **missing PK documentation**, and **view count mismatches**. The most impactful finding is that 9 of the top 26 hub tables have no column-level schema documentation anywhere in the kit.

### Issue Counts by Severity

| Severity | Count | Description |
|----------|-------|-------------|
| **CRITICAL** | 1 | 9 hub tables missing from all schema files |
| **ERROR** | ~45 | Wrong FKs, missing PKs, missing views, structural defects |
| **WARNING** | ~70 | Incomplete relationships, non-#0 unique indexes, partial FK mappings |
| **INFO** | ~30 | Lowercase names, cosmetic formatting, redundant indexes |

---

## CRITICAL: Hub Tables Missing From Schema Files

The following tables are listed as the most-referenced in the database (hub tier, 50+ inbound FK references each) in `AGENTS.GSSDB.md`, but have **NO column-level schema documentation** (`## TABLE_NAME` section) in any `agents/schema/*.md` file:

| Table | Inbound FKs | Impact |
|-------|-------------|--------|
| USER_INFORMATION | 376 | Every table with LAST_CHG_BY references this |
| AR_TAX_TABLES | 295 | Documented in AR.md (OK) |
| GL_MASTER | 274 | Documented in GL.md (OK) |
| INVENTORY_MSTR | 254 | Documented in INVENTORY.md (OK) |
| JOB_HEADER | 210 | Documented in JOB.md (OK) |
| CUSTOMER_MASTER | 162 | Documented in CUSTOMER.md (OK) |
| **LOCATION_ADDRESS** | **143** | **NOT DOCUMENTED** |
| ORDER_HEADER | 137 | Documented in ORDER.md (OK) |
| ORDER_LINES | 120 | Documented in ORDER.md (OK) |
| ITEM_MASTER | 105 | Documented in ITEM.md (OK) |
| VENDOR_MASTER | 103 | Documented in VENDOR.md (OK) |
| **UM_CODES** | **97** | **NOT DOCUMENTED** |
| SHIPMENT_HEADER | 92 | Documented in SHIPMENT.md (OK) |
| JOB_OPERATIONS | 88 | Documented in JOB.md (OK) |
| OE_MULTI_SHIP | 74 | Documented in OE.md (OK) |
| ORDER_HIST_HEAD | 72 | Documented in ORDER.md (OK) |
| **DEPARTMENTS** | **64** | **NOT DOCUMENTED** |
| EMPLOYEE_MSTR | 61 | Documented in EMPLOYEE.md (OK) |
| PO_HEADER | 58 | Documented in PO.md (OK) |
| **SALESPERSONS** | **54** | **NOT DOCUMENTED** |
| **ACCTG_BRANCH** | **52** | **NOT DOCUMENTED** |
| **EXCHANGE_CURRENCY** | **52** | **NOT DOCUMENTED** |
| **BIN_MASTER** | **51** | **NOT DOCUMENTED** |
| PO_LINES | 51 | Documented in PO.md (OK) |
| **WORKCENTERS** | **51** | **NOT DOCUMENTED** |
| OE_CARRIER | 50 | Documented in OE.md (OK) |

**9 hub tables are missing.** These tables appear in `## Relationships` sections as FK targets but have no column definitions, index documentation, or view information. The GSSDB "Miscellaneous" row claims 249 tables / 194 views are "spread across schema files" but many are not actually defined.

**Recommendation:** Generate schema documentation for all missing hub tables. At minimum: USER_INFORMATION, LOCATION_ADDRESS, UM_CODES, DEPARTMENTS, SALESPERSONS, ACCTG_BRANCH, EXCHANGE_CURRENCY, BIN_MASTER, WORKCENTERS.

---

## ERROR: Systemic Date/Time Self-FK Bug

A recurring pattern across the schema where a table references ITSELF with date and time columns swapped. This is clearly a bug in the GSSDBAGENT export tool — these are not real FK relationships.

| File | Table | Bad Relationship |
|------|-------|-----------------|
| ORDER.md | ORDER_HIST_CHGS | `ORDER_HIST_CHGS (CHANGE_DATE->CHANGE_TIME, CHANGE_TIME->CHANGE_DATE)` |
| ORDER.md | ORDER_POS_ERR | `ORDER_POS_ERR (DATE->TIME, TIME->DATE)` |
| JOB.md | JOB_SERIAL | `JOB_SERIAL (DATE_SERIAL->TIME_SERIAL, TIME_SERIAL->DATE_SERIAL)` |
| JOB.md | JOB_SERIAL_HIS | Same pattern |
| JOB.md | JOB_TRANS_ERR | `JOB_TRANS_ERR (ERR_DATE->ERR_TIME, ERR_TIME->ERR_DATE)` |
| SHIPMENT.md | SHIPMENT_LOG | `SHIPMENT_LOG (DATE_SHIP->TIME_SHIP, TIME_SHIP->DATE_SHIP)` |
| ROUTER.md | ROUTER_CHANGES | `ROUTER_CHANGES (CHANGE_DATE->CHANGE_TIME, CHANGE_TIME->CHANGE_DATE)` |
| FORECAST.md | FORECAST_HISTORY | `FORECAST_HISTORY (LAST_CHG_TIME->LAST_CHG_DATE)` |
| FORECAST.md | FORECAST_IMPORT_HDR | KEY_DATE/KEY_TIME crossed |
| FORECAST.md | FORECAST_IMPORT_LINE | Same pattern |
| PROJ.md | PROJ_MSTR_H_NOTES | `PROJ_MSTR_H_NOTES (DATE->TIME, TIME->DATE)` |
| PROJ.md | PROJ_PHASE_NOTES | Same pattern |
| PROJ.md | PROJ_PHSE_H_NOTES | Same pattern |
| PROJECT.md | PROJECT_CHKPNT | `PROJECT_CHKPNT (CHK_DATE->CHK_TIME, CHK_TIME->CHK_DATE)` |
| RECEIVER.md | RECEIVER_LOG | `RECEIVER_LOG (LOG_DATE->LOG_TIME, LOG_TIME->LOG_DATE)` |
| EDI.md | EDI_PWK_NOTES | `EDI_PWK_NOTES (DATE->TIME, TIME->DATE)` |

**Recommendation:** Remove all self-referential date/time swapped FK entries. Fix the GSSDBAGENT export tool to not generate these.

---

## ERROR: Tables Missing PK / Unique Index Documentation

### No Index Documentation At All

| File | Table | Issue |
|------|-------|-------|
| CC.md | CC_OPTIONS | No `Indexed` column, no `### Indexes`, no PK |
| CC.md | CC_RESPONSE_HIST | No `Indexed` column, no `### Indexes`, no PK |
| PO.md | PO_SERVICE | No `Indexed` column, no `### Indexes`, no PK, no View |
| Y.md | Y_BOM_WO_COMPARE | No `Indexed` column, no `### Indexes` |
| ATG.md | ATG_APSV3_JBSORT | No `Indexed` column, no `### Indexes` |
| ATG.md | ATG_BRW_BOM | No `Indexed` column, no `### Indexes` |
| ATG.md | ATG_BRW_ROUTER | No `Indexed` column, no `### Indexes` |
| ATG.md | ATG_SI_ADD | No `Indexed` column, no `### Indexes` |
| ATG.md | ATG_SI_PACK | No `Indexed` column, no `### Indexes` |
| ATG.md | ATG_SI_VALID_ADD | No `Indexed` column, no `### Indexes` |
| EMP.md | EMP_BIO_REASON | No `Indexed` column, no `### Indexes` |
| EMP.md | EMP_BIO_TERMINAL | No `Indexed` column, no `### Indexes` |
| Z.md | ~183 tables | Short column header without `Indexed`, no `### Indexes` |

### Unique Index Exists But Not at #0

| File | Table | Actual Unique Index |
|------|-------|---------------------|
| JOB.md | JOB_CT_FLX_SCHD | #5 |
| JOB.md | JOB_SORT_COMMENTS | #1 |
| JOB.md | JOB_TRANS_ERR | #3 |
| AR.md | AR_VAT_TAX_INVC | #5 |
| AP.md | AP_CHECKS | #2 |
| BILL.md | BILL_LADING_H_TEXT | #1 |
| BILL.md | BILL_LADING_TEXT | #1 |
| OE.md | OE_PC_QUANTITY | #1 |
| OE.md | OE_USER_FLDS_HDR | Non-#0 |
| OE.md | OE_USER_FLDS_LN | Non-#0 |
| QUOTE.md | QUOTE_HF_TEXT | Non-#0 |
| SA.md | SA_RMA_HF_TEXT | Non-#0 |
| SHIPMENT.md | SHIPMENT_HF_TEXT | #1 |
| VEND.md | VEND_HF_COMMENTS | #1 |
| INVC.md | INVC_HF_TEXT | #1 |
| EMP.md | EMP_PAY_HOURS | #1 |
| EMPLOYEE.md | EMPLOYEE_MSTR | #3 |
| EMPLOYEE.md | EMPLOYEE_MSTR_W2 | #1 |
| PAY.md | PAY_HIST_DED | #4 |
| PAYROLL.md | PAYROLL_TC_EMPLR | #3 |
| PAYROLL.md | PAYROLL_TC_RATES | #1 |
| PYRL.md | PYRL_EMP_HIST | #1 |
| STAGING.md | STAGING_ORDERS | #2 |
| TIME.md | TIME_ATTENDANCE | #12 |
| TIME.md | TIME_ATTND_HIST | #12 |
| TIME.md | TIME_RECORD | #3 |
| VAT.md | VAT_TAX_RULE_CMNTS | #1 |
| VAT.md | VAT_VEND_RETN_TYPE | #2 |
| CNCA.md | CNCA_HISTORY | #7 |
| CNCA.md | CNCA_HIST_NOTES | #1 |
| CNCA.md | CNCA_NOTES | #1 |
| ATG.md | ATG_BRW_INVENTORY | #2 |

**Note:** Non-#0 unique indexes are valid in Pervasive/Zen (index numbering is arbitrary). This is an INFO-level documentation observation, not a correctness error.

---

## ERROR: Wrong FK Mappings

| File | Table | Issue |
|------|-------|-------|
| QUOTE.md | QUOTE_SHIP_TO | `RECORD_NO->QUOTE_NO` should be `RECORD_NO->RECORD_NO` (maps to wrong target column) |
| VEND.md | VEND_QTE_LINES | Only `(SEQ -> SEQ)` to parent; missing `PART -> PART` (parent PK is PART + SEQ) |
| LOT.md | LOT_TO_LOT | Only `(LOT_SUFF -> KEY_SUFFIX)` to header; missing `LOT -> KEY_LOT` |
| POHIST.md | POHIST_VEND_BUY | Only `(PURCHASE_ORDER -> PURCHASE_ORDER)` to header; missing `LINE` column |
| POHIST.md | POHIST_PAY_TO | Same: missing `LINE` in FK to header |
| FORECAST.md | FORECAST (orphan) | References a table `FORECAST` that does not exist in the file |
| FORECAST.md | FORECAST_DETAIL | FK omits `ID_SUFF` (detail PK is `ID, ID_SUFF`) |
| CRM.md | CRM_TASKS | `STATUS -> SEQ` maps CHAR(50) to integer key; should likely be `STATUS -> VALUE` |
| CNCA.md | CNCA_HISTORY/NOTES | Reference `CNCA` table that does not exist as a `##` section in the file |
| GUI.md | Relationships | Reference `GUI_GROUP_MEMBERSHIP` and `GUI_GROUP_SETTINGS` which do not exist in the file |
| QUALITY.md | Relationships | Reference `QUALITY` as a bare table but no `## QUALITY` section exists |
| WIP.md | WIP_BIN | `DESCRIPTION->DESCRIPTION` FK on free-text column is fragile/suspect |
| AR.md | AR_HISTORY | `DATE_INVOICE->INVOICE` and `DATE_INVOICE_CYMD->INVOICE` are suspicious date-to-PK mappings |

---

## ERROR: View Count Mismatches (Schema File vs AGENTS.GSSDB.md)

| File | Views in File | Views Expected | Gap |
|------|---------------|----------------|-----|
| AP.md | 34 | 35 | -1 |
| PO.md | 33 | 35 | -2 |
| VEND.md | 12 | 13 | -1 |
| JOB.md | 26 | 29 | -3 |
| RTR.md | 13 | 14 | -1 |
| BI.md | 150 | 156 | -6 |
| TIME.md | 6 | 8 | -2 |
| TASK.md | 6 | 7 | -1 |
| CON_GRP.md | 0 | 1 | -1 |
| PRT.md | 1 | 3 | -2 |

**Note:** Some gaps align with known truncated/broken views per GSSDB: V_BI_WOROUTER, V_CON_KPI_CALENDAR, V_PAYR_MAN_TC_DEDCT, V_PAYR_MAN_TC_EMPLR, V_PAYR_MAN_TC_RATES.

---

## ERROR: PAYR.md Is a Stub File

`PAYR.md` contains table headers but **no column definitions, no indexes, and no views** for its 3 tables. The file appears to need regeneration by GSSDBAGENT. It also contains garbled self-FK entries like `COMP_CODE_1->COMP_CODE_2` in its Relationships section.

---

## ERROR: Missing View Documentation

Tables that should have a `### View:` block (based on GSSDB convention) but don't:

| File | Table |
|------|-------|
| INVENTORY.md | INVENTORY_MASTERS (lowercase addon table) |
| ORDER.md | ORDER_LINE_ITEMS (lowercase addon table) |
| PO.md | PO_SERVICE |
| BOM.md | BOM_BACKUP_HEADER, BOM_BACKUP_MSTR |
| FORECAST.md | FORECAST_COMMENTS |
| ENG.md | V_ENG_TBL_DESC (column count mismatch: 2 vs 3) |
| MATL.md | V_MATL_OVHD_RATE (column count mismatch: 2 vs 3) |
| WIP.md | V_WIP_USER_HIDE (column count: 1 vs 2) |
| Y.md | Y_APS_DISPATCH, Y_BOM_WO_COMPARE |
| PRT.md | PRT_LASER_INVOICE, PRT_LASER_PO |

---

## ERROR: Incomplete Relationships Sections

Many tables exist in their schema files but have no corresponding `**TABLE** -> ...` entry in the `## Relationships` section. Key gaps by file:

| File | Tables Missing From Relationships |
|------|----------------------------------|
| AP.md | AP_IVC_HST_NOTES, AP_REPEAT_NOTES, AP_SHIP_FOB, AP_SHIP_VIA, AP_SUM_CR, AP_TERMS, AP_TERMS_INFO, AP_VI_ADDRESS, AP_VI_NAME, AP_VI_PAY_ADDR, AP_VI_PAY_NAME, AP_VIA_SHIP, AP_VOUCH (13+) |
| BOL.md | BOL_CART_NUM_SSCC, BOL_HIST_CARTON, BOL_HIST_COI, BOL_HIST_DETAIL, BOL_HIST_HEADER, BOL_HIST_ITEM, BOL_HIST_PALLET (7) |
| OE.md | OE_CARR_SRV_TYPE, OE_FREIGHT, OE_GRP_PRICE_CMT, OE_PC_QUANTITY, OE_PRICE_CODE, OE_PRICE_COMMENTS, OE_WARRANTY_TRMS (7) |
| RMA.md | RMA_H_LINE_NOTES, RMA_H_SVC_PF_NOTE, RMA_HIST_HEADER, RMA_HIST_LINES, RMA_LINE_NOTES, RMA_LNSVPF_H_NOTE, RMA_LNSVRQ_H_NOTE, RMA_SERVICES, RMA_SVC_PF_NOTE, RMA_SVC_REC (10) |
| ENG.md | ENG_CHG_OPT, ENG_CHG_PART_H, ENG_GROUP, ENG_TBL_DESC (4) |
| ATG.md | 16 tables missing |
| COMPANY.md | COMPANY_CURRENCY, COMPANY_MSTR, COMPANY_OPT, COMPANY_PAY_TO (4) |
| PL.md | PL_DISCOUNT, PL_LOCATION, PL_MASTER (3) |
| COMMENTS.md | 8 of 9 tables missing |
| WO.md | WO_USER_30, WO_USER_70, WO_USR_FLDS_30, WO_USR_FLDS_70 (4) |
| PART.md | PART_GEN_OPTIONS, PART_LOOKUP, PART_PRICE_CODE, PART_TOL_MAP, PART_TOLERANCE, PART_TRANS_NEXT_DATE, PART_TRANSACTION (7) |
| EDI.md | EDI_AEINV_DEDUCT, EDI_AUDIT_BRW, EDI_AUDIT_BRW_H, EDI_SO_COMMENTS, EDI_SO_EXTERNAL, EDI_SO_MQD (6) |

---

## WARNING: Redundant Indexes

| File | Table | Issue |
|------|-------|-------|
| NTP.md | NTP_UOM_MASTER | IDX #0 on UOM_CODE (unique) AND IDX #2 on UOM_CODE (non-unique) |
| NTP.md | NTP_QUOTE_PACKAGING | FK #1 on QUOTE_ID AND IDX #3 on QUOTE_ID |
| NTP.md | NTP_QUOTE_PRICE_BREAK | FK #1 on QUOTE_ID AND IDX #2 on QUOTE_ID |
| POHIST.md | POHIST_HEAD | IDX #0 and IDX #26 are duplicate definitions (same columns, both unique) |
| APSV3.md | APSV3_BEDETAIL | Indexes #2 and #5 both non-unique on EMPNO |
| WIP.md | WIP_BIN | Index #1 lists PART twice in column list |

---

## WARNING: View Naming Inconsistency

| File | View Name | Expected Pattern |
|------|-----------|-----------------|
| FORECAST.md | V_FORECST_IMPORT_HDR | Should be V_FORECAST_IMPORT_HDR (typo in base view name?) |

---

## INFO: Lowercase Table/Column Names (Normalize to UPPERCASE)

| File | Table | Details |
|------|-------|---------|
| INVENTORY.md | inventory_masters | All columns lowercase (id, smart_part_num, etc.) |
| ORDER.md | order_line_items | All columns lowercase (sales_order_id, item_num, etc.) |
| BILL.md | bill_of_materials | All columns lowercase (id, order_line_item_id, etc.) |
| SALES.md | sales_orders | All columns lowercase (id, quote_id, etc.) |
| Y.md | Y_APS_DISPATCH | CamelCase columns (JOBOPDESC, CUSTOMERNAME) |
| Y.md | Y_BOM_WO_COMPARE | CamelCase columns (LINEID, HASCHANGES) |
| ATG.md | Various ATG_BRW_* | Mixed case columns (CUSTNAME, CUSTNO, SCHEDSTART) |

**Recommendation:** When agent docs are regenerated, normalize all to UPPERCASE per the naming convention rule.

---

## INFO: Files With No Relationships Section (17 files)

| File | Reasonable? | Recommendation |
|------|-------------|----------------|
| APS.md | Yes | APS engine tables; optional links to WORKCENTERS/jobs |
| BI.md | Yes | 168 report tables; relationships would be massive |
| CC.md | Partial | CC_RESPONSE_HIST likely ties to orders; add at least that |
| CON_GRP.md | Yes | Small KPI/config set |
| CUSTOM.md | Yes | Key-value customization tables |
| EVENT.md | Yes | Standalone event system |
| FIN.md | **No** | 3 financial tables should reference GL_MASTER at minimum |
| KB.md | Partial | Clear logical links (KB_SUBTASK -> KB_STATUS_ENTRY) exist |
| NTP.md | Yes | FKs expressed as FOREIGN KEY indexes; narrative section would be duplicate |
| OPP.md | Yes | Standalone opportunity tables |
| PY.md | Yes | Payroll year-end tables |
| RVZ.md | **No** | Quote/BOM/item relationships exist but are undocumented |
| TMS.md | Yes | Very thin doc; isolated feature |
| VMS.md | Yes | Isolated feature |
| Y.md | Yes | 75 report tables |
| Z.md | Yes | 337 report tables |

---

## INFO: Structural Observations

1. **Z.md**: ~183 of 337 tables use a shortened column header without `Indexed` column and have no `### Indexes` block. Many Z_ tables only have non-unique "duplicate" indexes (not unique #0/PK). Only ~11 tables in Z.md use PRIMARY KEY.

2. **Blank-line formatting**: Most legacy GSS schema files have excessive blank lines between table rows (generator artifact). NTP and other modern tables are more compact.

3. **APSV3.md**: Uses PascalCase table names (APSV3_ActPerDef, APSV3_JBMaster, etc.) — valid naming, just different convention from the SCREAMING_SNAKE_CASE majority.

4. **KB.md type mismatch**: KB_USER.TEAM_ID is INTEGER while KB_TEAM_DESC.TEAM_ID is CHAR(20) — possible schema or doc drift.

---

## Recommended Actions (Priority Order) -- Status as of 2026-05-11

1. **CRITICAL** -- **DONE**: All 9 hub tables documented. LOCATION_ADDRESS, UM_CODES, DEPARTMENTS, SALESPERSONS, ACCTG_BRANCH, EXCHANGE_CURRENCY, BIN_MASTER added to MISC.md; WORKCENTERS added to WC.md; USER_INFORMATION added to USER.md (note: resides in Global_Common database, not company-specific).

2. **HIGH** -- **DONE**: Removed 17 self-referential date/time swapped FK entries across 11 files (ORDER, JOB, SHIPMENT, ROUTER, FORECAST, PROJ, PROJECT, RECEIVER, EDI, CUST). Bug documented in `AGENTS.GSSDB.md` to prevent re-introduction.

3. **HIGH** -- **DONE**: Fixed wrong FK mappings in VEND_QTE_LINES, LOT_TO_LOT, POHIST_VEND_BUY, POHIST_PAY_TO, FORECAST_DETAIL, CRM_TASKS. Added phantom-reference annotations to CNCA, GUI, QUALITY. QUOTE_SHIP_TO was already correct.

4. **HIGH** -- **DONE**: PAYR.md fully regenerated with column definitions, indexes, views, and cleaned Relationships (garbled self-FK removed).

5. **MEDIUM** -- **DONE**: Corrected view counts in `AGENTS.GSSDB.md` Table Groups table for AP, PO, VEND, JOB, RTR, BI, TIME, TASK, CON_GRP, PRT (10 groups updated).

6. **MEDIUM** -- _DEFERRED (requires GSSDBAGENT)_: Add missing Relationship entries for ~90+ tables across 12 files. Documented in `AGENTS.GSSDB.md` Known Issues section.

7. **LOW** -- _DEFERRED (requires database introspection)_: Add missing `### Indexes` and `Indexed` column for tables that lack them. Documented in `AGENTS.GSSDB.md` Known Issues section.

8. **LOW** -- **DONE**: Normalized lowercase table/column names to UPPERCASE in INVENTORY.md (INVENTORY_MASTERS), ORDER.md (ORDER_LINE_ITEMS), BILL.md (BILL_OF_MATERIALS), SALES.md (SALES_ORDERS).

9. **LOW** -- _DEFERRED (requires verification)_: Clean up redundant indexes in NTP, POHIST, APSV3, WIP. Documented in `AGENTS.GSSDB.md` Known Issues section.
