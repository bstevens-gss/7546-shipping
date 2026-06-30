# Agent Kit Feedback

This file collects feedback from developers using the GAB agent kit in their project sandboxes. When you discover an issue, missing pattern, or improvement opportunity in any agent file, log it here. Then send this file back to the agent kit author for review and integration into the master kit.

**Workflow:**
1. Tell Cursor: "add feedback" -- it will append a structured entry below
2. When ready, send this file to the agent kit author (email, OneDrive, Teams)
3. Author drops it into the master kit and says "review feedback" to apply updates

---

## Entry Format

Each entry uses this structure. The agent will fill it out when you say "add feedback."

```
### FB-{NNN}
- **Date:** YYYY-MM-DD
- **Author:** {name or initials}
- **Project:** {customer} / {project code}
- **Target:** {AGENTS.*.md file} > {optional sub-file}
- **Category:** Bug | Missing Pattern | Improvement | New Rule | Correction
- **Summary:** One-line description
- **Details:**
  Full description. Include error messages, code examples, or scenarios.
- **Suggested Fix:** *(optional)*
  Proposed wording, code, or rule change.
- **Status:** Open
```

---

## Valid Targets

Use the **Target** column when logging feedback. Format: `AGENTS.*.md` or `AGENTS.*.md > sub-file`.

| Agent File | Sub-Files | Domain |
|------------|-----------|--------|
| `agents/AGENTS.GAB.md` | `agents/gab/VARIABLES.md`, `agents/gab/DATA.md`, `agents/gab/GUI.md`, `agents/gab/GRID.md`, `agents/gab/API.md`, `agents/gab/HOOKS.md`, `agents/gab/IO.md`, `agents/gab/CALLWRAPPERS.md`, `agents/gab/INTEGRATION.md`, `agents/gab/DLL.md` | GAB language, scripting, DLL integration |
| `agents/AGENTS.HOOKS.md` | `agents/hooks/SALES_ORDER.md`, `agents/hooks/WORK_ORDER.md`, `agents/hooks/INVENTORY.md`, `agents/hooks/PURCHASING.md`, `agents/hooks/QUALITY.md`, `agents/hooks/SHIPPING.md`, `agents/hooks/AR_AP_GL.md`, `agents/hooks/MISC.md` | GSS hook system, hook catalogs |
| `agents/AGENTS.QUOTING.md` | `agents/quoting/COMPONENTS.md`, `agents/quoting/TEMPLATES.md`, `agents/quoting/SERVICEWEB.md` | Spec/quote design system |
| `agents/AGENTS.GSSDB.md` | `agents/schema/*.md` | Database schema reference |
| `agents/AGENTS.ZEN.md` | *(none)* | Actian Zen SQL engine |
| `agents/AGENTS.HELPARTICLE.md` | *(none)* | Help article generation |
| `AGENTS.TDD.md` | *(none)* | Test-driven development rules |
| `agents/AGENTS.DOCUMENTS.md` | *(none)* | Document extraction protocol |
| `agents/AGENTS.FEEDBACK.md` | *(none)* | This feedback system |
| `AGENTS.PROJECT.md` | *(none)* | Project-specific config (per-project) |

---

## Entries

<!-- Append new feedback entries below this line. Do not remove this comment. -->