# GAB GUI Controls Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when creating forms, controls, or UI
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

## Routing (split reference)

This file is the **index** for the GAB GUI reference. The former single document exceeded practical size limits; body content is split into focused sub-files, each **under 100,000 characters**, with **no loss of documentation** (original lines 5–6635).

**How to use:** Start here, then open the sub-file(s) that match your task. For a full-screen rewrite or unfamiliar script, read all GUI sub-files in order. For **grid binding, column properties, and data-bound grid operations**, also read [`agents/gab/GRID.md`](../gab/GRID.md).

| Sub-file | Lines | Contents |
|----------|-------|----------|
| [`GUI_FORMS.md`](GUI_FORMS.md) | 2,036 | `# GUI (ScreenSU)` — Form Types, Form Creation, **Control Types & Creation** from `### Button` through **`### GsLookUpControl`** (inclusive). |
| [`GUI_CONTROLS.md`](GUI_CONTROLS.md) | 1,927 | Continues **Control Types & Creation**: **`### GsRepositoryLookup`** through **`### GsTileViewControl`** (inclusive). |
| [`GUI_ADVANCED_CONTROLS.md`](GUI_ADVANCED_CONTROLS.md) | 492 | Continues **Control Types & Creation**: **`### GsCardView`** and **`### GsAdvBandedGridControl`** (including event `V.Args` tables for the adv. banded grid). *Separate file required so no chunk exceeds 100K characters.* |
| [`GUI_EVENTS.md`](GUI_EVENTS.md) | 1,655 | **GUI Runtime, V.Screen State & Events**: **`### GsToggleSwitch`** through **`## Context Menus`** — remaining control types, **Common Control Properties**, **Control Runtime Methods**, **Screen Variable Properties (V.Screen.\*form.\*)**, form runtime examples, **Alert System**, **Event Types Reference**, context menus, and the separator before UI dialogs. |
| [`GUI_DIALOGS.md`](GUI_DIALOGS.md) | 557 | **`# UI DIALOGS`** through end of file — double-dot notation, `F.Intrinsic.UI.*`, browsers, dialogs, mobile script patterns, FunctionLinks, GsObjectGridControl, GsDashboardViewer, additional control methods. |

### Original top-level outline (for search)

- **`# GUI (ScreenSU)`** → `GUI_FORMS.md` + `GUI_CONTROLS.md` + `GUI_ADVANCED_CONTROLS.md` + start of `GUI_EVENTS.md`
- **`# UI DIALOGS`** → `GUI_DIALOGS.md` (starts after blank line following `---` that ends the main GUI section)
- **`# MOBILE SCRIPT PATTERNS`**, **`# FUNCTIONLINKS CONTROL`**, **`# GSOBJECTGRIDCONTROL`**, **`# GSDASHBOARDVIEWER`**, **`# ADDITIONAL CONTROL METHODS`** → `GUI_DIALOGS.md`

### Verification

- **Line-for-line parity:** Concatenating each sub-file’s body (all lines after its 3-line header) reproduces original `GUI.md` lines **5–6635** exactly.
- **Character budget:** Each `GUI_*.md` sub-file is under **100,000** characters.
