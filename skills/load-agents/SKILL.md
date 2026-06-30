---
name: load-agents
description: >-
  Deploy or update the GSS agent kit in the current workspace.
  Use when the user says "load agents" or "/load-agents".
---

# Load Agents

Deploys the centralized GSS agent kit into the current workspace using directory junctions. This ensures every project uses the same up-to-date kit from `~/.gab-agents/`.

## Instructions

1. Run the deployment script:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$HOME\.gab-agents\scripts\deploy-kit.ps1"
```

2. After deployment, read Tier 1 files from the workspace into context:
   - `AGENTS.md`
   - `AGENTS.INDEX.md`
   - `AGENTS.PROJECT.md`
   - `AGENTS.TDD.md`

3. Confirm deployment with:

**Agent kit deployed. Ready.**

## How It Works

The canonical kit lives at `~/.gab-agents/` (a Git clone). Projects reference it via Windows directory junctions -- no copying, no version drift.

| What | Source | Deployment Method |
|------|--------|-------------------|
| Agent docs (`.md`) | `~/.gab-agents/agents/` | Junction → workspace `agents/` |
| Cursor rules (`.mdc`) | `~/.gab-agents/cursor-rules/` | Junction → `.cursor/rules/` |
| Cursor hooks | `~/.gab-agents/cursor-hooks/` | Junction → `.cursor/hooks/` |
| VS Code settings | `~/.gab-agents/vscode/` | Copied to `.vscode/` |
| Root files | `~/.gab-agents/root-files/` | Copied to workspace root |
| Extensions (`.vsix`) | `~/.gab-agents/extensions/` | Installed globally by `install-kit.ps1` |
| Skills | `~/.gab-agents/skills/` | Copied to `~/.cursor/skills/` |
| Auto-sync | `.vscode/tasks.json` | `quick-sync.ps1` runs on folder open |

## First-Time Setup (New Developer)

```powershell
git clone https://github.com/silasFulsom/gab-agents-kit.git "$HOME\.gab-agents"
powershell -NoProfile -ExecutionPolicy Bypass -File "$HOME\.gab-agents\scripts\install-kit.ps1"
```

Then in any project folder, say `/load-agents` to deploy.

## CRITICAL: Version Bumping Rule

**Before ANY push to the `gab-agents-kit` GitHub repo, you MUST bump the version:**

```powershell
cd "$env:USERPROFILE\.gab-agents"
& .\scripts\bump-version.ps1 -Changes "Short description of what changed"
```

This updates `version.json` which is how downstream developers detect updates. Without a version bump, their `.gab-agents-version` file stays stale even though `git pull` delivers the new code. Never push without bumping.
