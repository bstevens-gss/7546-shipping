---
AGENT_TITLE: GAB Spec/Quote Design System
AGENT_DESCRIPTION: Single source of truth for generating professional HTML spec and quote documents for GAB development projects.
AGENT_USAGE: Load when quoting or specing — quotes, specs, proposals, estimates, NTP, agreements.
---

# GAB Spec/Quote Design System

> **When to use this file:** Activity = Quoting/Specing (quotes, specs, proposals, estimates, NTP, agreements)

This file is the single source of truth for generating professional HTML spec/quote documents for GAB development projects. It encodes the design system, component library, and section templates that ensure every quote produced looks identical to the published NTP agreements.

**Reference artifacts** (read these if you need to see a working example):
- See `AGENTS.PROJECT.md` for reference artifact paths (NTP agreements, spec examples)

---

# SUB-FILE ROUTING

Detailed design and template references are split into focused sub-files in the `agents/quoting/` directory.
**Read the relevant sub-file(s) based on what the task requires:**

| When you need... | Read this file |
|------------------|----------------|
| Color palette, typography, layout, CSS for all 14 components (header, info-grid, sections, stat-grid, callout boxes, data tables, phase cards, flow diagrams, responsibility cards, mockup gallery, signatures, budget bar, checklists, architecture diagrams) | [`agents/quoting/COMPONENTS.md`](agents/quoting/COMPONENTS.md) |
| Section templates by classification type (A/A-DaaS/B/C/D), document skeleton, CSS assembly rules, JavaScript toggle | [`agents/quoting/TEMPLATES.md`](agents/quoting/TEMPLATES.md) |
| ServiceWeb Quote format (page structure, content mapping, disclaimers, HTML skeleton, rich-text styling) | [`agents/quoting/SERVICEWEB.md`](agents/quoting/SERVICEWEB.md) |

**For a full spec generation, read ALL sub-files.**
**For a quick edit (e.g., "update the stat grid colors"), read only COMPONENTS.**

---

## 1. Classification System

Every project is classified before a quote is generated. Classification determines which section template to use.

| Type | Name | Hours | Complexity | Billing Model |
|------|------|-------|------------|---------------|
| A | Block-Hour | 100+ | High | Initial 100-hr block, incremental increases |
| A-DaaS | Development as a Service | 100+ | High (undefined scope) | 100-hr block, discovery-driven |
| B | Time & Materials | 20-100 | Medium | Weekly/bi-weekly T&M with 15-20% buffer |
| C | Quick Fix | 2-20 | Low | Auto-billed weekly, 10-15% buffer |
| D | Support/Retainer | Ongoing | Variable | Monthly retainer or hourly |

---

<!-- Sections 2-4 live in sub-files: §2-3 in COMPONENTS.md, §4 in TEMPLATES.md -->

## 5. Content Rules

### 5.1 Header Metadata

Every document MUST include these doc-meta fields:
- **Customer:** Full company name with abbreviation in parentheses
- **Project Code:** The GAB project code (e.g., 0000, 6271)
- **Date:** Full date in "Month Day, Year" format (e.g., March 7, 2026)
- **Version:** Semantic version starting at 1.0

### 5.2 Initial Status

All newly generated documents MUST have:
- Status: `Draft &mdash; Pending Approval`
- The status appears in the info-card table for project/engagement information

### 5.3 Financial Formatting

- Hourly rate: `$225.00 / hour` (always include cents)
- Total amounts: `$22,500.00` (comma-separated with cents)
- Hours: **Always round UP** each line item to the next whole number. Never quote fractional hours on any line item. If raw estimation yields 3.5 hours, quote 4 hours. This applies to every row in `quote_details.line_items` individually.
- Percentages: `15%`, `70%`, `110%` (no decimal unless necessary)
- Billing increment: always 15 minutes (0.25 hours)

### 5.4 Inline Code

`<code>` elements appear in section content for table names, function names, column names, and script filenames. No special CSS is needed -- browsers render `<code>` in a monospace font by default. Use `<code>` for:
- Database table names: `<code>GCG_NTP_QUOTES</code>`
- Column/field names: `<code>PART</code>`, `<code>DISPLAY_PART</code>`
- Script filenames: `<code>GCG_0000_ProductConfigurator_MOCKUP.g2u</code>`
- Function/wrapper names: `<code>AddDisplayPartColumn</code>`
- Company options: `<code>400861</code>`

### 5.5 Typography Conventions

- Em-dashes: always use `&mdash;` (never `--` or `-`)
- Inline bullets in architecture descriptions: use `&bull;`
- Arrows in flow text: use `&rarr;` (right), `&larr;` (left)
- Less-than/greater-than in text: use `&le;`, `&ge;`, `&lt;`, `&gt;`
- Section references: use `&sect;` (e.g., "see &sect;5.6")
- Non-breaking spaces around numbers: use `&nbsp;` (e.g., `Option&nbsp;A`)
- Quotes in text: use `&ldquo;` and `&rdquo;` (curly quotes)
- Apostrophes in text: use `&rsquo;`

### 5.6 Inline Style Overrides

Callout boxes and other components may need occasional inline style overrides for spacing. Common patterns:
- Final info-box before end of document: `style="margin-top: 30px;"` for extra breathing room
- Lists inside callout boxes: `style="margin-left: 25px; margin-top: 10px;"` for inline lists

These are acceptable and expected. Use sparingly.

### 5.7 Section Numbering

- Top-level sections are numbered sequentially: `1. Solution`, `2. Scope`, etc.
- Subsections within a section use dot notation: `5.1 — System Context`, `5.2 — Integration Points`
- Subsection headings use h3 with the format: `{N}.{M} &mdash; {Title}`
- Sub-subsection headings use h4 (no number prefix, just the title)

### 5.8 Standard Terms Content

The following terms are standard across all agreement types. Adjust wording for formality based on type (Type A is most formal, Type C is most abbreviated).

**Standard hourly rate:** $225.00/hr
**Overtime rate:** $262.50/hr (requires prior approval)
**Billing increment:** 15 minutes (0.25 hours)
**Work schedule:** Monday-Friday, 8:00 AM - 5:00 PM CT
**Bug fix warranty:** 30 calendar days after sign-off, at no charge, for defects within original scope
**Post-warranty support:** Available at standard rate as Type C or D engagements
**IP:** Custom scripts and libraries are property of the customer upon full payment. Developer retains the right to reuse general-purpose patterns.
**Cancellation:** Either party may cancel with 5 business days written notice. Hours worked are billed; unused hours refunded or credited.
**Liability:** Developer liability shall not exceed total amount paid. Neither party liable for indirect, consequential, or punitive damages.
**Exclusions:** Issues caused by environment changes, database modifications, or third-party updates after deployment.

### 5.9 Testing Plan (replaces Acceptance Criteria)

**CRITICAL: Every spec MUST include a Testing Plan section. Acceptance Criteria sections are NEVER used.**

The Testing Plan section replaces what was formerly called "Acceptance Criteria." It applies to every agreement type (A, A-DaaS, B, C, D).

**Rules:**
- Every scope of work item must have **at least one test case.**
- Every test case must include exactly **three elements** in this order:
  1. **Objective** — one bullet stating what is being verified
  2. **Steps** — one bullet per action the tester performs
  3. **Expected Results** — one bullet per distinct observable outcome that constitutes a pass
- Use `<ul><li>` bullet lists for all three elements (never `<p>` tags, never `<ol>` for steps)
- Group test cases under `<h3>` headings that match the scope item they cover (e.g., `2.1 — Feature Name`)
- Number test cases sequentially: `TC-01`, `TC-02`, etc.

**DOCX JSON pattern (standard):**

Test cases are defined in the `test_cases` array of the JSON content file. The DOCX generator (`scripts/generate_quote_docx.py`) renders them as bordered boxes with proper formatting. Each test case object:

```json
{
  "id": "TC-01",
  "title": "Short Title",
  "reference": "optional -- e.g., 'see Section 3a for field breakdown'",
  "objective": "What is being verified",
  "steps": ["Action 1", "Action 2"],
  "expected_results": [
    { "heading": "optional sub-heading (e.g., 'A Record')", "items": ["Pass condition 1"] },
    { "heading": "General", "items": ["Pass condition 2", "Pass condition 3"] }
  ]
}
```

- `reference` is optional. Include when a test case references a specific section or sample file.
- `expected_results` supports two formats:
  - **Flat array of strings** (simple): `["condition 1", "condition 2"]`
  - **Array of `{ heading, items }` objects** (sub-headed): use when expected results are grouped by category (e.g., "A Record", "C Record", "General")

**Legacy reference — ServiceWeb HTML pattern (inline styles, for HTML output only):**

<details>
<summary>Click to expand legacy HTML pattern</summary>

```html
<div style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 18px; margin: 12px 0; color: #333;">
    <p style="color: #764ba2; font-weight: bold; margin-bottom: 10px;">TC-01: {Short Title}</p>
    <p style="color: #555; font-weight: 600; margin: 8px 0 4px;">Objective:</p>
    <ul>
        <li style="color: #333; margin-bottom: 6px;">{What is being verified}</li>
    </ul>
    <p style="color: #555; font-weight: 600; margin: 8px 0 4px;">Steps:</p>
    <ul>
        <li style="color: #333; margin-bottom: 6px;">{Action 1}</li>
    </ul>
    <p style="color: #555; font-weight: 600; margin: 8px 0 4px;">Expected Results:</p>
    <ul>
        <li style="color: #333; margin-bottom: 6px;">{Pass condition 1}</li>
    </ul>
</div>
```

</details>

### 5.10 Dark Mode Resilience

Dark mode affects the generated HTML in **two independent ways**. Both MUST be handled in every spec.

#### 5.10.1 Browser Dark Mode (Legacy -- HTML Only)

> **NOTE (2026-04-02):** This section applies only to the **legacy HTML format**. DOCX files are opened in Microsoft Word, which is immune to browser dark mode. If you are generating the standard DOCX output, skip this section.

**For legacy HTML output only:** When a user opens a generated `.html` file in Chrome, Edge, or Firefox with dark mode enabled, the browser may apply automatic color transformations that override the CSS `<style>` block, making text unreadable.

**Mandatory fix for HTML files -- include both of these:**

1. **Meta tag** in `<head>` (after `<meta charset="UTF-8">`, before `<title>`):
   ```html
   <meta name="color-scheme" content="only light">
   ```
2. **CSS property** as the first rule in the `<style>` block:
   ```css
   html { color-scheme: light only; }
   ```

#### 5.10.2 ServiceWeb Paste Dark Mode (Rich Text Editor)

**CRITICAL:** ServiceWeb strips CSS `<style>` blocks on paste. Only inline `style="..."` attributes survive. The DevExpress rich text editor inherits the host app's theme -- in dark mode, text without an explicit inline color becomes invisible.

**DOCX advantage:** When pasting from Word (the standard workflow), Word's clipboard format includes explicit colors on every text run because python-docx sets `RGBColor` on every run in the DOCX. This is inherently more resilient than browser HTML copy-paste. However, the DevExpress editor can still override inherited colors, so the risk is reduced but not eliminated.

**Anti-patterns (NEVER do these in ServiceWeb paste content):**

- **Never** generate `<p>`, `<li>`, `<td>`, `<th>`, `<span>`, `<code>`, or `<div>` inside ServiceWeb Description or Specifications content without an explicit `style="color: #333;"` (or other appropriate color) attribute
- **Never** set `background` or `background-color` in an inline style without also setting `color` in the same `style` attribute (and vice versa)
- **Never** rely on inherited text color from a parent element or CSS class -- the rich text editor overrides inheritance
- **Never** rely on CSS classes for color in ServiceWeb content -- classes are stripped on paste

**Mandatory patterns:**

- Every text-bearing element (`<p>`, `<li>`, `<td>`, `<th>`, `<span>`, `<code>`, `<div>`) MUST have an explicit inline `style="color: ..."` attribute
- Headings (`<h3>`, `<h4>`) MUST have inline `style="color: #667eea;"` or `style="color: #764ba2;"` -- not from a class
- Table headers MUST have inline `style="background: #34495e; color: white;"`
- Callout boxes MUST have both `background-color` and `color` on the outer `<div>` AND on every `<p>`/`<li>` inside them
- Test: temporarily set `body { background: #1e1e1e; }` -- all content must remain readable

See [SERVICEWEB.md Section 12.6](agents/quoting/SERVICEWEB.md) for copy-paste-ready inline style examples.

### 5.11 New Project vs. Modification Detection

**CRITICAL:** Before generating any spec, the agent MUST determine whether this is:
- (a) A **new project** (new scripts, new project number)
- (b) A **modification** of an existing project (changes to existing scripts under the same or a new project number)

**Detection signals:**
- User mentions an existing script filename (e.g., `GAB_5219_OE_...g2u`)
- User references a prior project number
- User says "update", "modify", "enhance", "add to", "change"

**When a modification is detected, the agent MUST ask the developer:**
> "This appears to be a modification of an existing project ({project name/number}).
> Will this be quoted under a **new project number** (new scripts and deliverables)
> or as a **continuation/modification under the existing project number**?
> This affects file naming, deliverable references, and scope boundaries."

**Do NOT proceed with spec generation until this is answered.** The answer determines:
- File naming (`{ProjectCode}` vs `{ProjectCode}-MOD`)
- Whether the scope section references "new" scripts or "modified" scripts
- Whether the existing-project assumption disclaimer is included (see Section 5.12)

### 5.12 Existing Project Assumption Disclaimer

**When the spec is for a modification of an existing project**, the Assumptions section (Section 1 of the ServiceWeb format) MUST include the following disclaimer as the **first assumption**, before any project-specific assumptions:

> "The existing {project name} ({script filename}) has been tested, accepted, and is functioning as designed with its current feature set. This engagement covers only the modifications described in the Scope of Work. Pre-existing defects, untested functionality, or issues unrelated to the modifications defined herein are excluded from this scope and will be addressed as a separate engagement if discovered."

This disclaimer:
- Protects against scope creep from undiscovered bugs in the original project
- Establishes a clear boundary between "what exists" and "what we are changing"
- MUST be present in every modification spec (never omitted)
- May be lightly tailored to the specific project but must retain the core protective language

### 5.13 Mandatory Line Items (NEVER Omit)

**Every quote MUST include these explicit line items in `quote_details.line_items`, regardless of project type:**

| Line Item | Type C (2-20 hr) | Type B (20-100 hr) | Type A / A-DaaS (100+ hr) |
|-----------|-------------------|---------------------|----------------------------|
| **Quality Assurance / Testing** | Minimum 2 hours | Minimum 4 hours | Minimum 8 hours |
| **Documentation** | Minimum 1 hour | Minimum 2 hours | Minimum 4 hours |

**Rules:**
- These are NOT optional. They must appear even if the developer estimates zero -- the minimums exist because every project requires testing and documentation.
- **Quality Assurance / Testing** covers: writing test cases, executing the TDD cycle, validating against acceptance criteria, regression testing.
- **Documentation** covers: updating README/deployment notes, documenting configuration, spec finalization, handoff documentation.
- Both line items use the standard hourly rate (`$225.00/hr`).
- Hours on these lines (like all lines) must be rounded UP to the next whole number per Section 5.3.
- If the project scope clearly requires MORE than the minimum, estimate appropriately (always rounding up). The minimums are floors, not caps.

---

<!-- Sections 6-8 live in TEMPLATES.md (legacy: JS, Skeleton, CSS) -->

## 9. Generation Checklist

**CRITICAL: Every spec generation produces TWO artifacts.** Both MUST be generated in the same pass.

When generating a spec/quote document, follow this sequence:

### 9.1 ServiceWeb Quote (Single Artifact -- DOCX)

The ServiceWeb Quote is generated as a **DOCX** (Word document) by `scripts/generate_quote_docx.py`. The agent builds a structured JSON content file; the script produces the styled document. The DOCX matches the GSS ServiceWeb Quote Details page layout with three clearly separated sections for easy copy-paste into ServiceWeb.

1. **Classify the project** (Type A/A-DaaS/B/C/D) based on estimated hours and scope definition
2. **Determine new vs. modification** per Section 5.11. If modification detected, ask the developer about project number before proceeding.
3. **Gather inputs:** customer name, abbreviation, project title, quote-rev, expiration date, contact, call reference, scope details, rate, hours
4. **Build the JSON content file** following the schema documented in `scripts/generate_quote_docx.py` and [`agents/quoting/SERVICEWEB.md`](agents/quoting/SERVICEWEB.md) Section 12.4
5. **Populate `section1_description`:** executive_summary paragraphs, assumptions (with existing-project disclaimer per Section 5.12 as the first item if this is a modification), prerequisites
6. **Populate `section2_specifications`:** scope_items in plain language (no code refs), deliverables table (with `type` field), test_cases per Section 5.9 (with optional `reference` and sub-headed `expected_results`)
7. **Populate `section3_technical`:** content_blocks array with headings, sub_headings (with code refs, SQL, hooks), tables (field breakdowns, custom tables), code_blocks (sample files), callouts (schema discovery, conflict risks). Add architecture object (boxes + connections). Add integration_points array. Add screenshots array if mockup images exist.
8. **Populate `quote_details`:** line_items (sequence, type, hours, rate, total, description; set `is_buffer: true` for buffer/contingency rows), total_hours, total_amount. **After populating development line items, ALWAYS add "Quality Assurance / Testing" and "Documentation" as separate line items per Section 5.13 minimums. Round ALL line item hours UP to the next whole number (Section 5.3) before calculating totals.**
9. **Run the generator:** `python "skills/generate-quote-docx/scripts/generate_quote_docx.py" content.json "output.docx"`
10. **Open the DOCX in Word and verify:** formatting renders correctly, all sections present, architecture diagram visible
11. **Apply content rules** from Section 5 above (formatting, typography, ServiceWeb paste dark mode awareness per Section 5.10.2)
12. **Verify:** hours, rate, and total are consistent across all sections and the quote details table. Disclaimers and signature are present.

**File naming:** `{Customer Abbrev} - {Project Name} ServiceWeb Quote.docx`

**3-Section Content Routing:**

| Section | Pastes Into | Contains |
|---------|-------------|----------|
| **1. Description** | ServiceWeb "Description" field | Executive summary, assumptions (with modification disclaimer if applicable), prerequisites |
| **2. Specifications (Customer Facing)** | ServiceWeb "Specifications" field (first half) | User-friendly scope of work (no code refs), deliverables table, all test cases (TC-01, TC-02, ...) |
| **3. Technical Specifications** | ServiceWeb "Specifications" field (second half) | Developer-detail scope (code refs, SQL, hooks), architecture diagram, integration points table, callout boxes |

**What is NOT included in ServiceWeb specs** (these elements are retired from standard generation):
- Collapsible sections / toggle mechanism
- Stat grid boxes
- Phase cards
- Flow diagrams
- Budget bar / threshold alerts
- Change order process
- Billing & payment terms (GSS disclaimers cover this)
- Terms & conditions (GSS disclaimers cover this)
- Dual-column signature blocks (ServiceWeb provides its own)

### 9.2 GAB UI Mockup (.g2u)

Build a light-functional GAB mockup script that shows the customer what the proposed UI will look like. The mockup is **both** a deliverable (shipped alongside the quote) **and** the source of screenshots for the Mockup Screenshots section in the HTML quote.

**Applicability by type:**

| Type | Mockup Required? |
|------|-----------------|
| A / A-DaaS | **Mandatory** |
| B | **Mandatory** |
| C | Optional -- at developer discretion if a visual would help sell the scope |
| D | Skip -- support/retainer agreements do not involve new UI |

**Data strategy:**

| Project Complexity | Data Approach |
|-------------------|---------------|
| **Simple** (single screen, known schema, existing tables) | Populate grids and forms with **real customer data** via ODBC queries against the customer DSN (see `AGENTS.PROJECT.md` for DSN) |
| **Complex** (multi-screen, undefined schema, new custom tables) | Use **hardcoded example data** in DataTable/DataView literals -- no database dependency |

**What to include (light-functional scope):**
- Form layout: panels, tabs, labels, textboxes, comboboxes, checkboxes, buttons
- Grid columns with realistic widths, formatting, and column headers
- Tab navigation that switches visible panels
- Button click handlers showing `F.Intrinsic.UI.Msgbox` confirmations (e.g., `"Save clicked -- will write to GCG_ORDERS table"`)
- Status bar or info labels showing context (e.g., current record count, selected item)

**What to skip:**
- Real business logic, CRUD write operations, validation rules
- Error handling beyond basic `SetErrorHandler` structure
- Hook integration, DLL calls, external API calls
- Security checks, user permission logic

**Naming convention:** `{CustomerCode}_{ProjectCode}_{FeatureName}_MOCKUP.g2u`

**Screenshot workflow:**
1. Build the `.g2u` mockup
2. Run it in the GAB IDE
3. Screenshot each tab, state, or dialog that the customer needs to see
4. Embed the screenshots in the **Mockup Screenshots** section (Section 3) of the HTML quote using the `mockup-gallery` component from [`agents/quoting/COMPONENTS.md`](agents/quoting/COMPONENTS.md)

**Cross-reference:** Read `agents/gab/GUI.md` and `agents/gab/GRID.md` for form/grid API when building mockups.

**File delivery:** The `.g2u` file is delivered alongside the DOCX quote file. File naming for the full package:
- `{Customer Abbrev} - {Project Name} ServiceWeb Quote.docx`
- `{CustomerCode}_{ProjectCode}_{FeatureName}_MOCKUP.g2u`

---

## 10. Integration Points Table Template

For GAB projects that integrate with GSS, use this standard table structure. Adapt the rows to the specific project.

**DOCX output:** Integration points are defined in the `integration_points` JSON array and rendered automatically by the DOCX generator. The `direction` field accepts `"READ"`, `"WRITE"`, or `"READ / WRITE"` -- the generator colorizes these as green/red badges. The HTML template below is legacy reference.

```html
<table class="data-table">
    <tr>
        <th style="width: 140px;">GSS Module</th>
        <th style="width: 70px;">Direction</th>
        <th>Integration Points</th>
    </tr>
    <tr>
        <td><strong>{Module Name}</strong></td>
        <td><span style="color:#2ecc71; font-weight:bold;">READ</span></td>
        <td>{Description of data read from this module}</td>
    </tr>
    <tr>
        <td><strong>{Module Name}</strong></td>
        <td><span style="color:#e74c3c; font-weight:bold;">WRITE</span></td>
        <td>{Description of data written to this module}</td>
    </tr>
</table>
```

Standard GSS modules to consider: Customer, Inventory/Parts, BOM, Router, Sales/Quotes, Work Orders, Pricing, Equipment, Reports, Quality.

---

## 11. Lessons Learned

Record any issues encountered during quote generation here so they are not repeated.

- **2026-03-24 (SPS):** The initial spec used vague "CallWrapper J55" references. PoC testing revealed the actual mechanism is `F.Global.General.CallWrapperSync(450100, sFileName)` -- a file-based numeric CallWrapper, not a named property-based one. Always include the mode number and invocation pattern, not just the transaction code.
- **2026-03-24 (SPS):** The full T&M agreement was overly detailed for the ServiceWeb submission format. ServiceWeb only has Description + Specifications rich text fields and a simple hours table. Always generate both versions.
- **2026-03-26 (SPS):** Quote HTML pasted into ServiceWeb and viewed in dark-mode apps became unreadable. Root cause: CSS rules set `background` without a paired `color`, so dark text inherited the host app's dark theme and disappeared. Fix: Section 5.10 now mandates every `background` must pair with `color` and vice versa.
- **2026-04-01 (RK):** Despite the 5.10 rule, agents continued generating invisible text in ServiceWeb dark mode. Root cause: the original rule was a design principle ("pair background and color") rather than a mechanical anti-pattern. Agents follow "Never generate X without Y" far more reliably than abstract pairing guidelines. Additionally, the rule said "every container" but didn't cover leaf elements (`<p>`, `<li>`, `<td>`, `<code>`), which are where most text lives. Fix: Section 5.10 rewritten as explicit anti-patterns listing every element type. Section 12.6 added to SERVICEWEB.md with inline style templates. COMPONENTS.md now has a paste-safety callout at the top.
- **2026-04-01 (ARC):** Generated ServiceWeb quote contained only a summary table for the Testing Plan, not the full test cases. Root cause: "Acceptance criteria" was listed in the ServiceWeb OMIT list with no replacement rule, so agents omitted the section entirely, and the Testing Plan was silently dropped. Fix: Section 5.9 added (formerly 5.11), mandating Testing Plan in every spec with three required elements per test case (Objective, Steps, Expected Results). Generation checklist updated accordingly.
- **2026-04-02 (ARC):** Consolidated from dual-document (Full Agreement + ServiceWeb) to single 3-section ServiceWeb format. The full agreement was never the artifact entered into the system; only the ServiceWeb version was pasted. Three sections (Description, Specifications, Technical) allow clean copy-paste workflow. Added modification-project guardrails: agent must validate new vs. existing project number before generating (Section 5.11), and existing-project specs include a disclaimer assumption protecting against pre-existing defects (Section 5.12). Full agreement templates, collapsible sections, stat grids, phase cards, flow diagrams, budget bars, and dual-column signatures moved to legacy status in TEMPLATES.md.
- **2026-04-02 (ARC):** Generated HTML was unreadable when opened in browsers (Chrome, Edge, Firefox) with dark mode enabled. Root cause: the HTML skeleton lacked `<meta name="color-scheme" content="only light">` and `html { color-scheme: light only; }` CSS -- the W3C standard mechanism to opt out of automatic browser dark mode transformations. Section 5.10 only covered ServiceWeb paste dark mode (inline styles on text elements), not browser-level rendering. Fix: added meta tag and CSS rule to the HTML skeleton in SERVICEWEB.md Section 12.4, added the CSS rule to COMPONENTS.md Section 2.3. Split Section 5.10 into two subsections: 5.10.1 (Browser Dark Mode) and 5.10.2 (ServiceWeb Paste Dark Mode) so agents address both layers.
- **2026-04-02 (ADAMS):** Migrated quote output from HTML to native DOCX (Word) format. Motivations: (1) HTML dark mode issues required opt-out meta tags that could still fail in some browsers, (2) copy-paste from browser to ServiceWeb lost formatting, (3) Word paste puts RTF+HTML on clipboard with explicit colors, giving DevExpress editors high-fidelity paste. Architecture: AI agent generates structured JSON content file following a strict schema; Python script (`scripts/generate_quote_docx.py`) converts it to styled .docx using python-docx 1.2.0. Architecture diagrams rendered as PNG images via Pillow 12.0.0 and embedded in the DOCX. Schema was validated against the real ADAMS EFT Export ATB Bank quote, which revealed 6 gaps in the original plan: (a) deliverables table needed a Type column, (b) test cases needed sub-headed expected results groups and reference notes, (c) technical scope needed rich content_blocks (tables, code blocks, callouts interleaved), (d) architecture diagrams needed flexible N-box layout, (e) quote details needed buffer row support, (f) integration points needed combined READ/WRITE direction. HTML format moved to legacy status in SERVICEWEB.md, COMPONENTS.md, and TEMPLATES.md. Zero new dependencies.
- **2026-06-17:** Agents frequently omit QA and Documentation line items, especially in HTML-format quotes. Root cause: (1) no rule mandated their inclusion -- agents treated them as optional overhead, (2) `generate_quote_docx.py` was never added to the kit repo so devs fell back to HTML where structure enforcement is weaker. Fix: Section 5.13 now requires explicit QA and Documentation line items with type-based minimums on every quote. Section 5.3 updated to mandate per-line-item rounding up to whole numbers. Generator script added to kit at `skills/generate-quote-docx/scripts/generate_quote_docx.py`.
