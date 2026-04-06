# Cursor Target

Platform-native implementation of MachinEdge Expert Teams for Cursor. Files in this directory are pre-built and installed to the user's project via direct copy — no translation or generation step.

## What's Installed

The install script copies files from this directory into your project's `.cursor/` directory:

```
.cursor/
  rules/
    project-os.mdc              # Always-applied — expert routing + shared principles
    project-manager-os.mdc      # Expert role — Project Manager
    swe-os.mdc                  # Expert role — Software Engineer
    qa-os.mdc                   # Expert role — QA Engineer
    devops-os.mdc               # Expert role — DevOps Engineer
    system-architect-os.mdc     # Expert role — System Architect
  commands/
    pm-start.md                 # Start a PM session
    pm-interview.md             # Run a project interview
    pm-add-feature.md           # Scope a new feature
    swe-start.md                # Start an SWE session
    qa-start.md                 # Start a QA session
    ops-start.md                # Start a DevOps session
    ops-deploy.md               # Execute a deployment
    ops-env-discovery.md        # Capture environment context
    sa-start.md                 # Start a System Architect session
  skills/
    pm-vision/SKILL.md          # Generate project brief
    pm-roadmap/SKILL.md         # Create milestone plan
    pm-decompose/SKILL.md       # Break milestone into tasks
    pm-update-plan/SKILL.md     # Update project plan
    pm-postmortem/SKILL.md      # Review completed milestone
    pm-handoff/SKILL.md         # End PM session
    swe-handoff/SKILL.md        # End SWE session
    qa-review/SKILL.md          # Code review with findings
    qa-test-plan/SKILL.md       # Generate test plan
    qa-regression/SKILL.md      # Regression check
    qa-bug-triage/SKILL.md      # Prioritize bug backlog
    qa-handoff/SKILL.md         # End QA session
    ops-pipeline/SKILL.md       # Define build/test/deploy pipeline
    ops-release-plan/SKILL.md   # Define release gates
    ops-handoff/SKILL.md        # End DevOps session
    sa-design/SKILL.md          # Create system architecture
    sa-research/SKILL.md        # Investigate technical question
    sa-review/SKILL.md          # Review implementation vs. intent
    sa-update/SKILL.md          # Evolve architecture
    sa-handoff/SKILL.md         # End System Architect session
    team-status/SKILL.md        # Project health summary
  scripts/
    next-issue-number.sh        # Get next available issue number
    next-issue-number.ps1
    move-issue.sh               # Move issue between status directories
    move-issue.ps1
    next-session-number.sh      # Claim next handoff note number (atomic)
    next-session-number.ps1
    update-issues-list.sh       # Regenerate issues/issues-list.md
    update-issues-list.ps1
    update-brief-status.sh      # Atomically update project brief status line
    update-brief-status.ps1
```

The install script also creates the project scaffolding:

```
docs/
  lessons-log.md                # Seeded if it doesn't exist
  handoff-notes/
    pm/
    swe/
    qa/
    devops/
    system-architect/
issues/
  backlog/
  planned/
  in-progress/
  done/
```

## How It Works

### Rules

Rules use Cursor's `.mdc` format with YAML frontmatter.

- **`project-os.mdc`** is always applied (`alwaysApply: true`). It provides expert routing (which role file to load based on command/skill prefix) and shared principles. This is loaded on every message.
- **Expert role rules** (e.g., `swe-os.mdc`) are also set to `alwaysApply: true`. Cursor loads all of them, but only the one matching the active session is relevant. The agent identifies the correct expert from the command prefix or user request.

### Commands

Commands are explicit workflows invoked by the user via `/command-name` in Agent mode. They are used for:

- **Start commands** (`/pm-start`, `/swe-start`, etc.) — begin a session with full context loading and approval gates.
- **Interactive commands** (`/pm-interview`, `/pm-add-feature`, `/ops-deploy`, `/ops-env-discovery`) — workflows that require back-and-forth with the user.

### Skills

Skills are discoverable by the Cursor agent. Each skill folder contains a `SKILL.md` with YAML frontmatter:

```yaml
---
name: swe-handoff
description: End the current SWE session and produce a handoff note. Use when...
---
```

**Discovery flow:**
1. Cursor scans `.cursor/skills/` at startup and reads SKILL.md frontmatter.
2. Skills appear in the "Agent Decides" category.
3. When the user sends a message, the agent evaluates skill descriptions against intent.
4. Matching skills are loaded into context and followed.
5. Users can also invoke skills explicitly by name (e.g., `/swe-handoff`).

Skills cover autonomous operations (vision, roadmap, review, etc.) and handoffs.

### Scripts

Scripts are hidden shell utilities in `.cursor/scripts/` for mechanical operations:

- **`next-issue-number.sh`** — scans `issues/` to find the next unused issue number.
- **`move-issue.sh`** — moves an issue file between status directories (`backlog/` → `in-progress/`, etc.).
- **`next-session-number.sh`** — atomically claims the next handoff note number using `set -C` (noclobber) to prevent concurrent session collisions.
- **`update-issues-list.sh`** — regenerates `issues/issues-list.md` from all issue files.
- **`update-brief-status.sh`** — atomically updates the "Last updated" line in `docs/project-brief.md` under a lockfile to prevent concurrent overwrites.

Each `.sh` script has a `.ps1` companion for Windows. Skills and commands reference these scripts via `Shell` tool calls rather than reimplementing the logic.

**Requirements:** Bash must be available for `.sh` scripts. On macOS and Linux this is standard. On Windows, scripts use the `.ps1` versions (PowerShell).

### Handoff Auto-Trigger

When the user signals they're wrapping up (e.g., "let's wrap up", "I'm done for now"), the agent is instructed to invoke the appropriate handoff skill automatically:

1. `project-os.mdc` includes the instruction: "When the user signals they're wrapping up, invoke the appropriate handoff skill."
2. Each handoff `SKILL.md` description includes trigger phrases for discovery.
3. Users can always invoke `/prefix-handoff` explicitly as a fallback.

Estimated auto-trigger reliability: ~70-80%.

## Skill Namespacing

Skills and commands use a short prefix to identify the expert. The prefix is the **executor** (who does the work), not the finder.

| Prefix | Expert | Examples |
|--------|--------|---------|
| `pm-` | Project Manager | `pm-start`, `pm-interview`, `pm-vision` |
| `swe-` | SWE | `swe-start`, `swe-handoff` |
| `qa-` | QA | `qa-start`, `qa-review`, `qa-test-plan` |
| `ops-` | DevOps | `ops-start`, `ops-deploy`, `ops-pipeline` |
| `sa-` | System Architect | `sa-start`, `sa-design`, `sa-research` |
| `team-` | Shared (cross-expert) | `team-status` |

## Uninstall

To remove the toolkit from a project, delete the managed files:

```bash
# Rules
rm -f .cursor/rules/*-os.mdc .cursor/rules/project-os.mdc

# Commands (only managed prefixes)
rm -f .cursor/commands/{pm,swe,qa,ops,sa,team}-*.md

# Skills (only managed prefixes)
rm -rf .cursor/skills/{pm,swe,qa,ops,sa,team}-*/

# Scripts
rm -rf .cursor/scripts/
```

Project documents (`docs/`, `issues/`) are yours and are not removed. Any custom rules, commands, or skills you created (without the managed prefixes above) are also preserved.

## Source Structure

```
targets/ide/cursor/
  README.md                     # This file
  rules/                        # → installed to .cursor/rules/
  commands/                     # → installed to .cursor/commands/
  skills/                       # → installed to .cursor/skills/
  scripts/                      # → installed to .cursor/scripts/
```
