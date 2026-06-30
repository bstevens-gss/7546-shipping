# GAB API, Communication & Global Functions Reference (Index)
# Sub-agent of agents/AGENTS.GAB.md -- start here; open the topic files below (each under 100,000 characters)
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

The full API reference was split from a single file (~11k lines) into topic files. **No body text was removed** — original lines 5–11098 are partitioned across the files below (verified by byte-identical reassembly).

## Quick routing

| Read this file | Former line range (monolithic `API.md`) | Contents |
|----------------|----------------------------------------|----------|
| [`API_HTTP.md`](API_HTTP.md) | 5–230 | `# COMMUNICATION` — HTTP, REST, JSON, SOAP, XML, SFTP, FTP, IMAP, OAuth, serial, upload, encoding |
| [`API_AUTOMATION.md`](API_AUTOMATION.md) | 231–1204 | `# EXTERNAL AUTOMATION (.NET)` and `# GLOBAL FUNCTIONS` — .NET interop steps, `F.Global.*`, CallWrappers, CRM, BI, scales, IPM, etc. |
| [`API_PRINTER.md`](API_PRINTER.md) | 1205–1242, 9345–9488 | `# HOOK-BASED SCRIPTS`, `# LIBRARY INCLUDES`, `# NETWORK`, `# PRINTER`, `# DEBUGGING`, `# TASK MANAGEMENT` |
| [`API_LIBRARIES_1.md`](API_LIBRARIES_1.md) | 1243–3374 | `# STANDARD LIBRARIES` (Part 1 of 5) |
| [`API_LIBRARIES_2.md`](API_LIBRARIES_2.md) | 3375–5000 | `# STANDARD LIBRARIES` (Part 2 of 5) |
| [`API_LIBRARIES_3.md`](API_LIBRARIES_3.md) | 5001–7156 | `# STANDARD LIBRARIES` (Part 3 of 5) |
| [`API_LIBRARIES_4.md`](API_LIBRARIES_4.md) | 7157–9246 | `# STANDARD LIBRARIES` (Part 4 of 5) |
| [`API_LIBRARIES_5.md`](API_LIBRARIES_5.md) | 9247–9344 | `# STANDARD LIBRARIES` (Part 5 of 5) |
| [`API_MISC.md`](API_MISC.md) | 9489–10788 | `# ADDITIONAL API SURFACE` (Part 1 of 2) — through `## Global.WebService` |
| [`API_MISC_2.md`](API_MISC_2.md) | 10789–11098 | `# ADDITIONAL API SURFACE` (Part 2 of 2) — `## Global.WorkFlow` onward |

**Why five library files and two misc files?** The 100K character limit per file required splitting `# STANDARD LIBRARIES` at `##` (`.lib`) boundaries into five parts, and splitting `# ADDITIONAL API SURFACE` into two parts (the second part begins at `## Global.WorkFlow`).

---

## `STANDARD LIBRARIES`: level-2 (`##`) sub-sections

Under `# STANDARD LIBRARIES`, each `##` subsection documents one numbered `.lib` include (CallWrapper-oriented). There are **79** subsections, from `1000.lib` through `930000.lib`:

- **API_LIBRARIES_1** (1243–3374): `# STANDARD LIBRARIES` through `## 6001.lib` (ends before `## 6002.lib`).
- **API_LIBRARIES_2** (3375–5000): `## 6002.lib` through `## 6017.lib` (ends before `## 6020.lib`).
- **API_LIBRARIES_3** (5001–7156): `## 6020.lib` through the subsection ending immediately before `## 251000.lib` (line 7157).
- **API_LIBRARIES_4** (7157–9246): `## 251000.lib` through `## 920000.lib` (ends before `## 930000.lib`).
- **API_LIBRARIES_5** (9247–9344): `## 930000.lib` and closing material before `# NETWORK`.

---

## `ADDITIONAL API SURFACE`: level-2 (`##`) sub-sections

The appendix documents namespaces alphabetically (Automation.*, Communication.*, Global.*, Intrinsic.*, Program.*, etc.). Part 1 ends after `## Global.WebService`; Part 2 starts at `## Global.WorkFlow` and continues through `## Sample.form.SampleControl`.

---

## Note: XML API namespace casing

`F.Global.Xml.*` and `F.Global.XML.*` are the **same API** -- GAB identifiers are case-insensitive. The curated XML reference in [`API_HTTP.md`](API_HTTP.md) uses `F.Global.Xml.*` (PascalCase); the exhaustive surface dump in [`API_MISC_2.md`](API_MISC_2.md) and the subset in [`API_AUTOMATION.md`](API_AUTOMATION.md) use `F.Global.XML.*` (all-caps). Prefer the curated examples in `API_HTTP.md` when writing new code.

---

## Migration note for deep links

References that pointed to “`API.md` § EXTERNAL AUTOMATION (.NET)” should use [`API_AUTOMATION.md`](API_AUTOMATION.md). References for `V.Printer` / printer intrinsics should use [`API_PRINTER.md`](API_PRINTER.md). Hook and include topics: same file (**API_PRINTER**).


---

## OCTSRS ComponentDocumentation cross-reference

Runtime implementation notes imported from `OCTSRS/octsrs-silas-clone/ComponentDocumentation/` (65 components). Each section is appended to the mapped `API_*.md` file under `## Component Reference: {ComponentName}`.

| Component | Agent doc target | Related non-API doc |
|-----------|------------------|---------------------|
| OpenDatabaseConnectivityComponent | [`API_AUTOMATION.md`](API_AUTOMATION.md) | Also see [`DATA_ODBC.md`](DATA_ODBC.md) for GAB script usage |
| StringComponent | [`API_MISC_2.md`](API_MISC_2.md) | Also see [`DATA_STRING.md`](DATA_STRING.md) |
| UiComponent | [`API_AUTOMATION.md`](API_AUTOMATION.md) | Also see [`GUI_DIALOGS.md`](GUI_DIALOGS.md), [`GUI_CONTROLS.md`](GUI_CONTROLS.md) |
| VariableComponent | [`API_MISC_2.md`](API_MISC_2.md) | Also see [`VARIABLES.md`](VARIABLES.md) |
| HookAssociationComponent | [`API_PRINTER.md`](API_PRINTER.md) | Also see [`HOOKS.md`](HOOKS.md) |
| DataTableComponent / DataViewComponent | [`API_MISC.md`](API_MISC.md) | Also see [`DATA_DATATABLE.md`](DATA_DATATABLE.md) |
| AccountingComponent | [`API_LIBRARIES_1.md`](API_LIBRARIES_1.md) | CallWrapper-oriented |
| AdvancedPlanningSchedulingComponent | [`API_LIBRARIES_3.md`](API_LIBRARIES_3.md) | APS scheduling libraries |
| VersionManagementSystemComponent | [`API_MISC.md`](API_MISC.md) | `Global.VMS` — error codes, DB tables, ADO.NET toggle `549c32a2-2bae-42c9-ade9-05931119b0aa` |

**Full component → file mapping:** Access/Actian/BI/CRM/Excel/Outlook/PDF/Word/Zip/GlobalShop* → `API_AUTOMATION.md`; HTTP/REST/JSON/SOAP/FTP/SFTP/IMAP/OAuth/XML/CalDAV/Mime/Network/Azure → `API_HTTP.md`; Printer/Debug/Hook/CommandProtocol/Network(task) → `API_PRINTER.md`; WorkFlow/XML/Hash/Control/Calc/String/Variable → `API_MISC_2.md`; remaining Global.* intrinsics → `API_MISC.md`.

Source: OCTSRS `ComponentDocumentation/` directory (extracted via Extract-GabApiRegistry.ps1)
