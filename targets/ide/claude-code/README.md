# Claude Code Target

Platform-native implementation of MachinEdge Expert Teams for Claude Code. Files in this directory are pre-built and installed to the user's project via direct copy — no translation or generation step.

## What's Installed

The install script copies files from this directory into your project's `.claude/` directory:

```
.claude/
  CLAUDE.md                     # Shared principles + expert routing (always loaded)
  settings.json                 # Hook definitions (merged, not overwritten)
  roles/
    project-manager.md          # Expert role — Project Manager
    swe.md                      # Expert role — Software Engineer
    qa.md                       # Expert role — QA Engineer
    devops.md                   # Expert role — DevOps Engineer
    system-architect.md         # Expert role — System Architect
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
    session-primer.sh           # SessionStart hook — raw project context extraction
```

The install script also creates the project scaffolding:

```
docs/
  lessons-log.md                # Seeded if it doesn't exist
  handoff-notes/
    project-manager/
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

### CLAUDE.md

`CLAUDE.md` is always loaded by Claude Code at the start of every session. It provides:

- **Expert routing table** — maps command/skill prefixes to role files (e.g., `swe-` → `.claude/roles/swe.md`).
- **Conventions** — handoff note format, issue naming, workflow contracts.
- **Shared principles** — no memory between sessions, project brief is source of truth, etc.

The `team-` prefix is special: no expert role is loaded. Team-prefixed skills (e.g., `team-status`) are cross-expert and self-contained.

### Roles

Roles in `.claude/roles/` are plain markdown files. Claude Code's role selection UI lets users pick which role to activate at session start. Each role defines:

- Identity and purpose
- Document locations (what the expert reads and writes)
- Available skills
- Expert-specific principles

### Commands

Commands are explicit workflows invoked via `/command-name`. Same set as Cursor — 5 start commands and 4 interactive commands.

### Skills

Skills are discoverable by Claude Code's agent. Each skill folder contains a `SKILL.md` with YAML frontmatter (`name` and `description`). The agent can invoke them autonomously when the description matches user intent, or the user can invoke them explicitly.

### Scripts

Scripts in `.claude/scripts/` handle mechanical operations. Same set as Cursor, plus `session-primer.sh` (Claude Code only — used by the SessionStart hook).

**Requirements:** Bash must be available for `.sh` scripts. On macOS and Linux this is standard. Claude Code currently runs on macOS and Linux, so `.ps1` scripts are included for completeness but not required.

### SessionStart Hook

Claude Code's `settings.json` defines a `SessionStart` hook that runs `session-primer.sh` at the beginning of every session. This is a Claude Code platform advantage over Cursor (which has no session-start hook).

**What `session-primer.sh` does:**
1. Extracts project identity (first few lines of `docs/project-brief.md`).
2. Extracts the "Current Status" section from `docs/project-brief.md`.
3. Finds the most recent handoff note across all experts and outputs its content.
4. Caps total output to avoid flooding the agent context.

This is a **raw content extractor**, not a summarizer. The agent processes the raw text naturally. If no project documents exist yet (fresh project), the script produces minimal output and the agent proceeds normally.

**settings.json merge:** The install script merges the `hooks` key from the toolkit's `settings.json` into any existing `.claude/settings.json` in your project. It does not overwrite other settings (permissions, allowed tools, etc.) you may have configured.

### Handoff Auto-Trigger

Same mechanism as Cursor: role instruction + discoverable skill descriptions. When the user signals they're wrapping up, the agent recognizes the intent and invokes the appropriate handoff skill.

Estimated auto-trigger reliability: ~70-80%. Users can invoke `/prefix-handoff` explicitly as a fallback.

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

To remove the toolkit from a project:

```bash
# Core config
rm -f .claude/CLAUDE.md

# Roles, commands, skills
rm -rf .claude/roles/
rm -f .claude/commands/{pm,swe,qa,ops,sa,team}-*.md
rm -rf .claude/skills/{pm,swe,qa,ops,sa,team}-*/

# Scripts
rm -rf .claude/scripts/

# Hooks — manually edit .claude/settings.json to remove the SessionStart hook
```

Project documents (`docs/`, `issues/`) are yours and are not removed. Any custom commands or skills you created (without the managed prefixes above) are also preserved.

## Source Structure

```
targets/ide/claude-code/
  README.md                     # This file
  CLAUDE.md                     # → installed to .claude/CLAUDE.md
  settings.json                 # → merged into .claude/settings.json
  roles/                        # → installed to .claude/roles/
  commands/                     # → installed to .claude/commands/
  skills/                       # → installed to .claude/skills/
  scripts/                      # → installed to .claude/scripts/
```
