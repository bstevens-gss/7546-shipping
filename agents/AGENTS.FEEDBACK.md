---
AGENT_TITLE: Agent Kit Feedback Protocol
AGENT_DESCRIPTION: Manages the feedback loop between developers using the kit in projects and the author maintaining the master kit.
AGENT_USAGE: Load when logging feedback about the agent kit, or reviewing and applying developer feedback.
---

# Agent Kit Feedback Protocol

> **When to use this file:** Any time a developer wants to log feedback about the agent kit, or the author wants to review and apply feedback from developers.

This protocol manages the feedback loop between developers using the agents in project sandboxes and the author maintaining the master agent kit.

---

## Adding Feedback (developer in sandbox)

**Signal words:** add feedback, log feedback, report issue with agents, agent improvement, agent bug

When a developer wants to log feedback:

1. Read `FEEDBACK.md` to find the last `FB-{NNN}` entry number (or start at FB-001)
2. Ask the developer for:
   - **Target:** which agent file needs updating (show the Valid Targets table from FEEDBACK.md)
   - **Category:** Bug, Missing Pattern, Improvement, New Rule, or Correction
   - **Summary:** one-line description
   - **Details:** full context including error messages, code, or scenarios
   - **Suggested Fix:** optional proposed change
3. Append the formatted entry to `FEEDBACK.md` below the `<!-- Append new feedback entries -->` comment
4. Set Status to `Open`
5. Remind the developer to send `FEEDBACK.md` to the agent kit author when ready

---

## Reviewing Feedback (author in master kit)

**Signal words:** review feedback, process feedback, apply feedback

When the author drops a `FEEDBACK.md` into the master kit and asks for review:

1. Read `FEEDBACK.md` and collect all entries with **Status: Open**
2. Group entries by Target agent file
3. For each Open entry:
   - Read the target agent file (and sub-file if specified)
   - Assess whether the feedback is valid and actionable
   - Propose a specific change: new rule, content update, pattern addition, or correction
4. Present a plan to the author with all proposed changes for approval
5. After the author approves and changes are applied, update each entry's Status from `Open` to `Applied`
6. Entries the author rejects should be marked `Rejected` with a brief reason appended to Details

---

## Lifecycle

- `FEEDBACK.md` is deployed as a blank template to every project
- `FEEDBACK.md` is protected from overwrite during re-deploy (like `AGENTS.PROJECT.md`)
- Developers accumulate entries over the project lifecycle
- The author merges feedback from multiple projects by reviewing each file independently
- Applied feedback becomes part of the master kit and propagates on next deploy
