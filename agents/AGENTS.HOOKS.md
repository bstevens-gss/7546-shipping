---
AGENT_TITLE: GSS Hook System Navigation Guide
AGENT_DESCRIPTION: Reference for the Global Shop Solutions hook system — which program a hook belongs to, hook types, hook ID structure, and where to attach GAB scripts.
AGENT_USAGE: Load when working with GSS hooks, V.Caller/V.Passed, or attaching scripts to hooks.
---

# GSS Hook System Navigation Guide

Agent reference for the Global Shop Solutions hook system. Use this file to determine **which program** a hook belongs to, **what hook types** are available, **how hook IDs are structured**, and **where to attach GAB scripts**.

> **When to use this file:** Activity = Developing (hooks, features, integrations)

**Cross-references (do not duplicate -- read these for detail):**
- GAB hook API (V.Caller, V.Passed, dispatch patterns, coding patterns): [`agents/gab/HOOKS.md`](agents/gab/HOOKS.md)
- Schema detail: [`agents/schema/HOOK.md`](agents/schema/HOOK.md)
- Database dialect: [`agents/AGENTS.ZEN.md`](agents/AGENTS.ZEN.md)
- Database connection: See `AGENTS.PROJECT.md` for DSN

---

## 1. Hook System Overview

### The Five Tables

| Table | Purpose | Rows | Key |
|-------|---------|------|-----|
| `HOOK_GLOBAL` | Master catalog -- every hook point GSS defines | 4,884 | `ID` (CHAR 9) |
| `HOOK_HEADER` | Activation registry -- is a hook turned on? | 140 | `HOOK` (CHAR 9) |
| `HOOK_ASSOCIATION` | Script bindings -- which `.g2u`/`.gas` runs for a hook | 90 | `ID + SEQ` |
| `HOOK_USER` | User-defined standalone hooks (customer-created) | 51 | `ID` (CHAR 9) |
| `HOOK_MAINT_LOG` | Audit trail for hook changes | 3 | `CHG_DATE + CHG_TIME + HOOK + ACTION` |

### Entity Relationship

```
HOOK_GLOBAL (4,884 hook points)
    │
    ├──► HOOK_HEADER (140 activation records)
    │       HOOK_GLOBAL.ID = HOOK_HEADER.HOOK
    │       ACTIVE_FLAG: "A" = active, "N" = inactive
    │
    └──► HOOK_ASSOCIATION (90 script bindings)
            HOOK_GLOBAL.ID = HOOK_ASSOCIATION.ID
            Multiple scripts per hook via SEQ ordering
            ACTIVE_FLAG: "A" = active, anything else = inactive
            SYNC_FLAG: "S" = synchronous, "A" = asynchronous

HOOK_USER (51 user-defined hooks)
    └──► Standalone entries -- not in HOOK_GLOBAL
         ID range: 001000000+
```

### Hook Lifecycle

1. **Definition** -- GSS ships hook points in `HOOK_GLOBAL` (system range `000000000`-`000999999`)
2. **Activation** -- A row in `HOOK_HEADER` with `ACTIVE_FLAG = 'A'` enables the hook
3. **Binding** -- A row in `HOOK_ASSOCIATION` links a `.g2u`/`.gas` script at a sequence number
4. **Execution** -- At runtime the program fires the hook -> runtime checks header -> runs associated scripts in sequence order
5. **Audit** -- Changes logged to `HOOK_MAINT_LOG`

### Key Fields Quick Reference

| Field | Table | What It Tells You |
|-------|-------|-------------------|
| `PROGRAM` | HOOK_GLOBAL | Which GSS program/screen owns this hook |
| `HOOK_TYPE` | HOOK_GLOBAL | When this hook fires (see Section 2) |
| `SCRIPT_DESC` | HOOK_GLOBAL | Canonical description (naming: `PROGRAM-TYPE-HOOK`) |
| `ACTIVE_FLAG` | HOOK_HEADER | Whether the hook is turned on |
| `SCRIPT_NAME` | HOOK_ASSOCIATION | The `.g2u` or `.gas` file bound to this hook |
| `SCRIPT_PATH` | HOOK_ASSOCIATION | Path to the script (`#SCRIPT-PATH#` = default GAB path) |
| `SEQ` | HOOK_ASSOCIATION | Execution order (lower runs first; `000100`, `000200`, ...) |
| `SYNC_FLAG` | HOOK_ASSOCIATION | `S` = sync (blocks caller), `A` = async (fire-and-forget) |

---

## 2. Hook Types Reference

Eight hook types exist. Distribution from this environment's 4,884 hooks:

| Hook Type | Count | % | When It Fires | Can Cancel? |
|-----------|-------|---|---------------|-------------|
| **Execute** | 1,803 | 36.9% | Script 1/2/3 button clicks or custom triggers | No |
| **Post-Process** | 917 | 18.8% | After a save, OK, or action completes | No |
| **Pre-Process** | 685 | 14.0% | Before a save or action -- can cancel the operation | **Yes** |
| **Populate** | 661 | 13.5% | When a screen loads/refreshes data | No |
| **Browsers** | 316 | 6.5% | Before/after browser lookup windows open | No |
| **Entry** | 304 | 6.2% | On screen entry/initialization | No |
| **Custom Field Hooks** | 178 | 3.6% | On custom field button clicks or value changes | No |
| **Field Change** | 20 | 0.4% | When a specific tracked field value changes | No |

### When to Use Each Type

| I need to... | Use this hook type |
|--------------|--------------------|
| Run code when a screen first opens | **Entry** |
| Inject/modify data as a screen loads | **Populate** |
| Validate or block a save/action | **Pre-Process** |
| React after a save/action succeeds | **Post-Process** |
| Add functionality to Script 1/2/3 buttons | **Execute** |
| Customize browser/lookup behavior | **Browsers** |
| React to a specific field value change | **Field Change** |
| Add custom field button logic | **Custom Field Hooks** |

---

## 3. Hook ID Numbering Scheme

### System vs User Ranges

| Range | Owner | Source Table |
|-------|-------|-------------|
| `000000000` - `000999999` | GSS (system-defined) | `HOOK_GLOBAL` |
| `001000000` - `001999999` | Customer/developer (user-created) | `HOOK_USER` |

All 4,884 hooks in `HOOK_GLOBAL` fall in the system range. The 51 user hooks in `HOOK_USER` start at `001000000`.

### Reading a Hook ID

Hook IDs are 9-character zero-padded strings. GSS assigns contiguous blocks per program:

| Program | Min ID | Max ID | Hook Count |
|---------|--------|--------|------------|
| CRM.exe | 000051000 | 000056662 | 188 |
| ORD201 | 000012000 | 000051598 | 120 |
| SFDC2 | 000048610 | 000050790 | 101 |
| JB0011GI | 000016760 | 000047499 | 91 |
| INVMAIN | 000010110 | 000049399 | 81 |
| ORD200 | 000011550 | 000015230 | 77 |
| OLG002 | 000015700 | 000028414 | 76 |
| Global_Shop_CRM.exe | 000042900 | 000042974 | 75 |
| GA_CRM01.exe | 000030600 | 000030669 | 70 |
| QTE200 | 000010700 | 000012670 | 59 |

### The `SCRIPT_DESC` Naming Convention

System hooks follow the pattern: **`PROGRAM-TYPE-HOOK`**

Examples:
- `OES0200A-SCRIPT-1-HOOK` -> ORD200, Execute (Script 1)
- `OES0200A-PRE-SAVE-HOOK` -> ORD200, Pre-Process
- `OES0200A-POPULATE-HOOK` -> ORD200, Populate
- `PUS064LN-SCRIPT-1-HOOK` -> PUR064GI, Execute (line-level)
- `INS010B-LOAD-PART-HOOK` -> INVMAIN, Post-Process (load part)
- `JBS0085C-POPULATE-HOOK` -> JB0085, Populate

The internal program code (e.g., `OES0200A`) may differ from the `PROGRAM` field (e.g., `ORD200`). Use `SCRIPT_DESC` to understand the hook's purpose; use `PROGRAM` for module mapping.

---

## 4. Module Routing -- Program-to-Hook Catalogs

438 distinct programs organized by GSS module. **Read the sub-file for the module you are working with:**

| Module Area | Programs | Sub-File |
|-------------|----------|----------|
| Sales Orders & Quotes | ORD*, QTE*, OrderEntry.exe | [`agents/hooks/SALES_ORDER.md`](agents/hooks/SALES_ORDER.md) |
| Work Orders & SFDC | JB*, SFDC*, WOQUERY | [`agents/hooks/WORK_ORDER.md`](agents/hooks/WORK_ORDER.md) |
| Inventory & Lots | INV*, LOT* | [`agents/hooks/INVENTORY.md`](agents/hooks/INVENTORY.md) |
| Purchasing | PUR*, AutoPOGen*, Picklist_MRP | [`agents/hooks/PURCHASING.md`](agents/hooks/PURCHASING.md) |
| Quality | QL*, OLS00-Misc | [`agents/hooks/QUALITY.md`](agents/hooks/QUALITY.md) |
| Shipping | SHP*, GSS_ShipStatus | [`agents/hooks/SHIPPING.md`](agents/hooks/SHIPPING.md) |
| Financial (AP/AR/GL) | AP*, AR*, GL*, OLG*, OLL* | [`agents/hooks/AR_AP_GL.md`](agents/hooks/AR_AP_GL.md) |
| All Other Modules | BOM, CRM, CFG, ENG, FA, RE, PR, PRJ, SCP, MENU, MSG, WIR, BRWRC, APP, etc. | [`agents/hooks/MISC.md`](agents/hooks/MISC.md) |

For the **complete hook catalog** (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`agents/hooks/all_hooks_table.md`](agents/hooks/all_hooks_table.md).

For **GAB hook coding patterns** (V.Caller, V.Passed, dispatch, cancellation, BDF, security, error handling), see [`agents/gab/HOOKS.md`](agents/gab/HOOKS.md).

---

## CRITICAL RULES

> **V.Passed element numbers are program-specific.** NEVER assume the same element number maps to the same field across different programs. For example, QTE200 passes quote number at `000003`, while QTE201 passes it at `000060`. Always verify the element mapping for the specific hook point you are targeting.

> **RUNTIME_VER must always be `'2.00'`** when inserting HOOK_ASSOCIATION rows for `.g2u` scripts. Runtime version `'1.00'` is legacy for `.gas` compiled binaries only — never use it for new hook associations. This is non-negotiable.

---

## 5. Quick-Reference SQL Queries

**Connection:** See `AGENTS.PROJECT.md` for DSN.

**Zen SQL reminders:** Use `RTRIM()` on CHAR columns. Use `SELECT TOP N` (no `LIMIT`). No `TRIM()` -- use `RTRIM(LTRIM(...))`. See [`agents/AGENTS.ZEN.md`](agents/AGENTS.ZEN.md).

### Find All Hooks for a Program

```sql
SELECT TOP 100
    g.ID, RTRIM(g.PROGRAM) AS PROGRAM, RTRIM(g.HOOK_TYPE) AS HOOK_TYPE,
    RTRIM(g.SCRIPT_DESC) AS SCRIPT_DESC
FROM HOOK_GLOBAL g
WHERE RTRIM(g.PROGRAM) = 'ORD200'
ORDER BY g.HOOK_TYPE, g.ID
```

### Find All Active Hooks with Scripts

```sql
SELECT
    g.ID, RTRIM(g.PROGRAM) AS PROGRAM, RTRIM(g.HOOK_TYPE) AS HOOK_TYPE,
    RTRIM(g.SCRIPT_DESC) AS SCRIPT_DESC,
    RTRIM(a.SCRIPT_NAME) AS SCRIPT_NAME, a.SEQ
FROM HOOK_GLOBAL g
INNER JOIN HOOK_HEADER h ON g.ID = h.HOOK
INNER JOIN HOOK_ASSOCIATION a ON g.ID = a.ID
WHERE RTRIM(h.ACTIVE_FLAG) = 'A'
  AND RTRIM(a.ACTIVE_FLAG) = 'A'
ORDER BY RTRIM(g.PROGRAM), g.ID, a.SEQ
```

### Find Hooks by Type for a Module

```sql
SELECT TOP 50
    g.ID, RTRIM(g.PROGRAM) AS PROGRAM,
    RTRIM(g.SCRIPT_DESC) AS SCRIPT_DESC
FROM HOOK_GLOBAL g
WHERE RTRIM(g.PROGRAM) LIKE 'ORD%'
  AND RTRIM(g.HOOK_TYPE) = 'Pre-Process'
ORDER BY g.PROGRAM, g.ID
```

### Count Hooks per Program

```sql
SELECT RTRIM(g.PROGRAM) AS PROGRAM, COUNT(*) AS HOOK_COUNT
FROM HOOK_GLOBAL g
GROUP BY RTRIM(g.PROGRAM)
ORDER BY COUNT(*) DESC
```

### Find Which Script Is Bound to a Hook ID

```sql
SELECT
    a.ID, a.SEQ, RTRIM(a.SCRIPT_NAME) AS SCRIPT_NAME,
    RTRIM(a.SCRIPT_PATH) AS SCRIPT_PATH,
    RTRIM(a.ACTIVE_FLAG) AS ACTIVE, RTRIM(a.SYNC_FLAG) AS SYNC
FROM HOOK_ASSOCIATION a
WHERE RTRIM(a.ID) = '000011910'
ORDER BY a.SEQ
```

### List All User-Defined Hooks

```sql
SELECT RTRIM(u.ID) AS ID, RTRIM(u.SCRIPT_DESC) AS DESCRIPTION
FROM HOOK_USER u
ORDER BY u.ID
```

### Check If a Hook Is Active

```sql
SELECT h.HOOK, RTRIM(h.ACTIVE_FLAG) AS ACTIVE, RTRIM(h.TRACE_FLAG) AS TRACE
FROM HOOK_HEADER h
WHERE RTRIM(h.HOOK) = '000011910'
```

### Find All Hooks with a Specific Script

```sql
SELECT
    a.ID, RTRIM(g.PROGRAM) AS PROGRAM, RTRIM(g.HOOK_TYPE) AS HOOK_TYPE,
    RTRIM(a.SCRIPT_NAME) AS SCRIPT_NAME, a.SEQ
FROM HOOK_ASSOCIATION a
INNER JOIN HOOK_GLOBAL g ON a.ID = g.ID
WHERE RTRIM(a.SCRIPT_NAME) LIKE '%CRM_OPP%'
ORDER BY g.PROGRAM, a.ID
```

---

## Appendix: Top 25 Programs by Hook Count

| # | Program | Hooks | Module |
|---|---------|-------|--------|
| 1 | CRM.exe | 188 | CRM |
| 2 | ORD201 | 120 | Order Entry |
| 3 | SFDC2 | 101 | Shop Floor |
| 4 | JB0011GI | 91 | Jobs/WO |
| 5 | INVMAIN | 81 | Inventory |
| 6 | ORD200 | 77 | Order Entry |
| 7 | OLG002 | 76 | General Ledger |
| 8 | Global_Shop_CRM.exe | 75 | CRM |
| 9 | GA_CRM01.exe | 70 | CRM |
| 10 | QTE200 | 59 | Quotes |
| 11 | QTE201 | 54 | Quotes |
| 12 | RE0010GI | 53 | Router/Eng |
| 13 | WOQUERY | 49 | Jobs/WO |
| 14 | AR0020GI | 45 | Accts Receivable |
| 15 | JB0052GI | 45 | Jobs/WO |
| 16 | JB0075GI | 44 | Jobs/WO |
| 17 | MENUSEC.exe | 43 | System/Menu |
| 18 | INV014GI | 42 | Inventory |
| 19 | JB0010GI | 41 | Jobs/WO |
| 20 | AP0020GI | 41 | Accts Payable |
| 21 | PUR064GI | 39 | Purchasing |
| 22 | OrderEntry.exe | 34 | Order Entry |
| 23 | JB033A | 34 | Jobs/WO |
| 24 | JB0083 | 33 | Jobs/WO |
| 25 | PUR100GI | 32 | Purchasing |
