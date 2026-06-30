---
AGENT_TITLE: Custom Bugs Ticket Lifecycle
AGENT_DESCRIPTION: Workflow guide for the Custom Bugs ticket lifecycle — intake, classification, fix, delivery, and closure.
AGENT_USAGE: Load when working on Custom Bugs tickets, triaging issues, fixing GAB/Crystal/P&E bugs, or delivering fixes to customers.
---

# AGENTS.BUGFIX.md — Custom Bugs Ticket Lifecycle
# Tier 2 entry point for bug fix / ticket / Custom Bugs / triage activities
# Last verified: 2026-06-30 | v5.0.0

> Developers may supplement this shared workflow with personal rules in their `custom-rules/` directory.

---

## 1. Ticket Intake

When receiving a Custom Bugs ticket:
1. Extract the ticket number from the request (e.g., ServiceWeb #, email subject)
2. Echo the ticket number back to confirm understanding
3. Classify attachments by type and route handling:
   - **Screenshots/Videos** — visual evidence of the issue; analyze for UI state, error messages, data
   - **GAB scripts (.g2u/.lib)** — the code to fix; open and read immediately
   - **Log files** — runtime errors, timestamps, sequence of events
   - **Crystal Reports (.rpt)** — report layout issues; route to Crystal workflow
   - **PDFs/Documents** — specs, requirements, or customer correspondence
4. Summarize the issue in one sentence before proceeding

---

## 2. Issue Classification

Before attempting ANY fix, classify the issue into one of these categories. The classification determines the fix approach:

| Classification | Action | Example |
|---------------|--------|---------|
| **GAB Logic Bug** | Fix the .g2u/.lib code | Wrong calculation, missing condition, incorrect SQL |
| **Scope Issue** | Document and communicate — not a bug, it's a feature request | "Can you also add X?" when X was never in scope |
| **P&E Core Issue** | Escalate to P&E team — the ERP core has a bug | Standard screen behaves incorrectly without customization |
| **Crystal/CodeSoft** | Route to Crystal workflow (AGENTS.CRYSTAL.md) | Report layout, formula, or data source issue |
| **Environment/Technical** | Investigate infrastructure | Connectivity, permissions, version mismatch, Zen errors |
| **Grid Serialization** | Reset saved layout or fix schema mismatch | Form opens blank, grid columns wrong after upgrade |

**If the classification is unclear, investigate further before committing to a fix approach.**

---

## 3. Solution Implementation

Every code change MUST be annotated with a change-tracking comment:
```
' [TICKET#] - Custom Bugs - [MM/DD/YYYY] - Brief description of change
```

Place the annotation ABOVE the changed/added block. Example:
```
' [8391] - Custom Bugs - 06/30/2026 - Added null check for DATE_SHIP before comparison
F.Intrinsic.Control.If(V.DataTable.dtOrders(V.Local.iRow).DATE_SHIP!FieldValTrim,<>,"")
    '... date comparison logic ...
F.Intrinsic.Control.EndIf
```

Rules:
- One annotation per logical change (not per line)
- Keep the description brief but specific
- Include the ticket number for traceability
- Do NOT annotate unchanged code

---

## 4. Non-Custom Issue Handoff

When the issue is NOT custom-related (classified as P&E Core, Environment, or out-of-scope):

1. **Document investigation** — What you checked, what you found, why it's not custom
2. **Identify destination** — Which queue/team should handle it (P&E, Infrastructure, Customer Success)
3. **Prepare handoff summary:**
   ```
   Issue: [brief description]
   Investigated: [what was checked]
   Finding: [why this is not a custom bug]
   Recommended: [where to route and suggested next steps]
   ```
4. **Communicate clearly** — Do not just close the ticket; explain the routing to the customer and receiving team

---

## 5. Delivery Protocol

After fixing the issue:

1. **Validate** — Test the fix against the reported scenario. Run gab-lint. Sign the script.
2. **Communicate** — Inform the customer what was fixed and how to verify
3. **Update repositories:**
   - For ARC projects: commit to the project's Git repo via GAPEW
   - For standalone scripts: deliver to the customer's PLUGINS\GAB\GAS\ directory
4. **Write ServiceWeb summary** — Use the Issue/Investigation/Solution format (see Section 6)
5. **Attach deliverables** — Scripts, reports, screenshots of the fix working
6. **Close ticket** — Set status to resolved/closed

---

## 6. Completion Summary Format

Use this standard format for ServiceWeb ticket resolution notes:

```
Issue:
-- [Description of the reported problem]
-- [How it manifested — error message, wrong data, UI freeze, etc.]

Investigation:
-- [What was checked]
-- [Root cause identified]
-- [Any related findings]

Solution:
-- [What was changed/fixed]
-- [Which file(s) were modified]
-- [How to verify the fix is working]
```

Each bullet uses `--` prefix. Keep it concise but complete.

---

## 7. VC Program Notes (Virtual Consultations)

When the ticket is classified as a Virtual Consultation (VC):

Use the Request/Solution format:
```
Request:
-- [What the customer asked for]

Solution:
-- [What was implemented]
-- [How to use it]
```

Add a `#Region "Program Notes"` block between `Preflight.End` and `Main.Start`:
```
Program.Sub.Preflight.End

#Region "Program Notes"
' VC - [Customer Name] - [MM/DD/YYYY]
' Request: [Brief description of what was asked]
' Solution: [Brief description of what was built]
' Files: [List of .g2u/.lib files involved]
#End Region

Program.Sub.Main.Start
```

This documents the VC context directly in the script for future maintainers.
