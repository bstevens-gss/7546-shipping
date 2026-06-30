---
AGENT_TITLE: Agent File Index & Activity Router
AGENT_DESCRIPTION: Routes the agent to the correct agent files based on the user's current activity (demand-based loading).
AGENT_USAGE: Load at session start to route to the right Tier-2 entry points by activity.
---

# Agent File Index & Activity Router

> This file routes the agent to the correct agent files based on the user's current activity.
> It replaces the "read all files every turn" mandate with demand-based loading.

---

## Tier 1: Always Load

These files are read on EVERY turn (small, universally applicable):

| File | Purpose |
|------|---------|
| `AGENTS.md` | Core behavioral rules and principles |
| `AGENTS.INDEX.md` | This file -- activity routing |
| `AGENTS.PROJECT.md` | Project-specific configuration and context |
| `AGENTS.TDD.md` | Test-driven development rules (applies to DLL/.NET work) |

---

## Tier 2: Activity-Based Loading

Determine the user's activity from their request, then read ONLY the relevant files.
Multiple activities may apply (e.g., GAB + Database for a script with SQL queries).

All Tier 2 files live in the `agents/` directory.

| Activity | Signal Words / Context | Files to Load |
|----------|----------------------|---------------|
| **GAB Development** | .g2u, .lib, GAB, script, subroutine, form, grid, control, hook coding | `agents/AGENTS.GAB.md` → then relevant `agents/gab/*.md` sub-files |
| **GS Mobile / custom mobile transactions** | GS Mobile, mobile site, wireless, custom transaction, standard mobile transaction, material picklist, MobExt, `DTLABELS`, `DTTRANS`, `DTOPTION`, `WIRELESS_LINE`, `Mobile_Custom_Result`, `ExportHTML`, `Custom.aspx`, `CustomResults.aspx`, `IssuesFromInvtoWO`, `IssuesFromInvtoWOL`, `SetCustomResult`, `GetCustomHeader`, `GetCustomLine`, `GetCustomPrinter`, mobile redirect, T-Card, shop floor receipt, `F.Global.Mobile`, `DATA-TRANSID` | `agents/AGENTS.MOBILE.md` → then `agents/AGENTS.GAB.md` + gab bundles listed in that file |
| **Database / SQL** | SQL, query, table, schema, column, SELECT, INSERT, CREATE, Zen, Pervasive | `agents/AGENTS.ZEN.md` + `agents/AGENTS.GSSDB.md` → then relevant `agents/schema/*.md` |
| **Hook System** | hook, V.Caller, V.Passed, pre-process, post-process, HOOK_GLOBAL, hook ID | `agents/AGENTS.HOOKS.md` → then relevant `agents/hooks/*.md` + `agents/gab/HOOKS.md` |
| **Quoting / Specs** | quote, spec, proposal, NTP, estimate, agreement, ServiceWeb | `agents/AGENTS.QUOTING.md` → then relevant `agents/quoting/*.md` |
| **Help Articles / Docs** | help article, documentation, PDF, knowledge base, help document | `agents/AGENTS.HELPARTICLE.md` + `agents/AGENTS.DOCUMENTS.md` |
| **Document Extraction** | PDF extraction, DOCX, embedded images, extract document | `agents/AGENTS.DOCUMENTS.md` |
| **Crystal Reports** | .rpt, Crystal, report modification, report creation, RptToXml, Crystal SDK, CrystalDecisions | `agents/AGENTS.CRYSTAL.md` → then relevant `agents/crystal/*.md` sub-files |
| **Agent Kit Feedback** | feedback, agent improvement, agent bug, report issue with agents | `agents/AGENTS.FEEDBACK.md` |

If the activity is unclear or spans multiple domains, ask the user which area they are working in.

---

## Tier 3: Deep Reference (Demand-Loaded by Tier 2 Files)

These sub-files are loaded by the Tier 2 files based on specific task needs.
Do NOT load them preemptively -- follow the routing tables in the Tier 2 files.

| Directory | Sub-Files | Routed By |
|-----------|-----------|-----------|
| `agents/gab/*.md` | CORE, VARIABLES, ENUMS, DATA (index) + DATA_*.md, GUI (index) + GUI_*.md, GRID, API (index) + API_*.md, HOOKS, IO, CALLWRAPPERS (index) + CW_*.md, INTEGRATION, DLL, PITFALLS, PATTERNS | `agents/AGENTS.GAB.md` |
| `agents/quoting/*.md` | COMPONENTS, TEMPLATES, SERVICEWEB | `agents/AGENTS.QUOTING.md` |
| `agents/hooks/*.md` | SALES_ORDER, WORK_ORDER, INVENTORY, PURCHASING, QUALITY, SHIPPING, AR_AP_GL, MISC, all_hooks_table | `agents/AGENTS.HOOKS.md` |
| `agents/schema/*.md` | 112 table group schema files | `agents/AGENTS.GSSDB.md` |
| `agents/crystal/*.md` | MODIFICATION, CREATION, GROUPS, FORMULAS, FORMATTING, DATASOURCES, ADVANCED | `agents/AGENTS.CRYSTAL.md` |

---

## Cross-Reference Map

Shows which files reference each other. Use this when loading one file implies needing another.

| File | References |
|------|-----------|
| `agents/AGENTS.GAB.md` | → `agents/gab/*.md` (41 sub-files incl. PITFALLS, PATTERNS), `AGENTS.PROJECT.md` (sample g2u location) |
| `agents/AGENTS.MOBILE.md` | → `agents/gab/INTEGRATION.md`, `agents/gab/GUI_DIALOGS.md`, `agents/gab/CORE.md`, `agents/gab/VARIABLES.md`, `agents/gab/PITFALLS.md`, `agents/gab/PATTERNS.md`, `agents/AGENTS.GSSDB.md`, `agents/schema/WIRELESS.md`, `agents/schema/MISC.md`, `agents/AGENTS.GAB.md` |
| `agents/AGENTS.HOOKS.md` | → `agents/gab/HOOKS.md`, `agents/schema/HOOK.md`, `agents/AGENTS.ZEN.md`, `AGENTS.PROJECT.md` |
| `agents/AGENTS.QUOTING.md` | → `agents/quoting/*.md` (3 sub-files), `AGENTS.PROJECT.md`, `agents/gab/GUI.md`, `agents/gab/GRID.md` |
| `agents/AGENTS.HELPARTICLE.md` | → GAB scripts (.g2u), screenshots |
| `agents/AGENTS.GSSDB.md` | → `agents/schema/*.md` (112 files), `agents/AGENTS.ZEN.md` |
| `agents/AGENTS.ZEN.md` | → Standalone (Actian Zen SQL reference) |
| `agents/AGENTS.DOCUMENTS.md` | → `AGENTS.PROJECT.md` (supplemental documents table) |
| `agents/AGENTS.FEEDBACK.md` | → All agents/AGENTS.*.md files (feedback targets) |
| `agents/AGENTS.CRYSTAL.md` | → `agents/crystal/MODIFICATION.md`, `agents/crystal/CREATION.md`, `agents/crystal/GROUPS.md`, `agents/crystal/FORMULAS.md`, `agents/crystal/FORMATTING.md`, `agents/crystal/DATASOURCES.md`, `agents/crystal/ADVANCED.md` |
| `AGENTS.TDD.md` | → Standalone (.NET/DLL testing rules) |
