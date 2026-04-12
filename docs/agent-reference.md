# Agent Reference

This document is for AI coding assistants working **on this repository** — helping to build, modify, or extend expert definitions. It is not operating instructions for deployed experts; those come from each platform's rules/roles at runtime.

If you're an AI assistant and someone has asked you to work on this repo, read this first.

## Orienting Yourself in the Repo

### What This Repo Is

This repo defines platform-native AI expert implementations for Cursor and Claude Code. Each expert has a role definition, structured skills, commands, and scripts. The implementations are pre-built and installed to users' projects via direct copy.

### Key Directories

| Path | Purpose |
|------|---------|
| `targets/ide/cursor/` | Cursor platform-native implementation (rules, commands, skills, scripts) |
| `targets/ide/claude-code/` | Claude Code platform-native implementation (roles, commands, skills, scripts) |
| `targets/ide/install.sh` | Shared installer — copies platform files to user's project |
| `docs/` | Documentation about the repo itself (you're reading one now) |

### Repo Structure

```
targets/ide/
  install.sh / install.ps1       ← Shared installer
  cursor/                        ← Cursor implementation
    README.md
    rules/                       ← .mdc files with YAML frontmatter
    commands/                    ← Explicit command files (.md)
    skills/                      ← Discoverable skill folders (SKILL.md)
    scripts/                     ← Mechanical shell scripts (.sh + .ps1)
  claude-code/                   ← Claude Code implementation
    README.md
    CLAUDE.md                    ← Shared principles + expert routing
    settings.json                ← Hook definitions
    roles/                       ← Expert role files (.md)
    commands/                    ← Explicit command files (.md)
    skills/                      ← Discoverable skill folders (SKILL.md)
    scripts/                     ← Mechanical shell scripts (.sh + .ps1)
docs/                            ← Vision, architecture, guides
.workflow/                       ← Managed artifacts (handoff notes, issues, lessons log)
```

### Current Experts

| Expert | Prefix | Status |
|--------|--------|--------|
| Project Manager | `pm-` | Active |
| Software Engineer | `swe-` | Active |
| QA | `qa-` | Active |
| DevOps | `ops-` | Active |
| System Architect | `sa-` | Active |
| Shared | `team-` | Active (cross-expert) |

## How to Work on Expert Definitions

### Modifying an Existing Expert

1. Read the expert's role definition to understand its identity and protocols:
   - Cursor: `targets/ide/cursor/rules/<expert>-os.mdc`
   - Claude Code: `targets/ide/claude-code/roles/<expert>.md`
2. Read the expert's existing skills and commands to understand capabilities
3. Make changes in **both** platform implementations to keep them aligned
4. Test by installing into a real project

### File Types

| Type | Cursor Location | Claude Code Location | Purpose |
|------|----------------|---------------------|---------|
| Role/Rule | `rules/<expert>-os.mdc` | `roles/<expert>.md` | Expert identity, session protocols, principles |
| Command | `commands/<prefix>-<name>.md` | `commands/<prefix>-<name>.md` | Explicit user-invoked workflows (`/start`, `/interview`, etc.) |
| Skill | `skills/<prefix>-<name>/SKILL.md` | `skills/<prefix>-<name>/SKILL.md` | Agent-discoverable autonomous operations |
| Script | `scripts/<name>.sh` + `.ps1` | `scripts/<name>.sh` + `.ps1` | Mechanical shell utilities |

### Writing a Role/Rule

The role file defines the expert's identity. It must include:

| Section | Purpose |
|---------|---------|
| **Document Locations** | Documents this expert reads and produces |
| **Session Protocol** | What to read at session start, do during, produce at end |
| **Commands** | Explicit user-invoked workflows |
| **Skills** | Agent-discoverable capabilities with descriptions |
| **Principles** | Non-negotiable behavioral rules |

Cursor rules use `.mdc` format with YAML frontmatter (`alwaysApply`, `description`). Claude Code roles are plain markdown.

### Writing a Skill

Skills are `SKILL.md` files with YAML frontmatter:

```yaml
---
name: <prefix>-<skill-name>
description: <What this skill does. When to use it. Max 1024 chars.>
---
```

The `description` is the primary discovery mechanism. It should answer two questions: "What does this skill do?" and "When should the agent use it?" A description like "Generate project brief" is less effective than "Generate the project brief from interview notes. Use when the user has completed a project interview."

The body contains the skill instructions — steps, context loading, output specification.

### Writing a Command

Commands are plain markdown files. They use `$ARGUMENTS` for user input. Commands are used for workflows that need:
- Full context loading with approval gates (`/start` commands)
- Back-and-forth interaction with the user (`/interview`, `/deploy`)

### Adding Scripts

Scripts go in the platform's `scripts/` directory. Each `.sh` script should have a `.ps1` companion for Windows. Skills and commands reference scripts via Shell tool calls.

## Document Contracts

Experts communicate through shared documents and issues:

| Producer | Artifact | Consumer(s) |
|----------|----------|-------------|
| Project Manager | `docs/project-brief.md` | All experts |
| Project Manager | `docs/roadmap.md` | All experts |
| Project Manager | `.workflow/issues/` (task issues) | SWE, QA, DevOps |
| SWE | Code + tests | QA, DevOps |
| SWE | `.workflow/handoff-notes/swe/session-NN.md` | Project Manager, QA |
| QA | `docs/test-plan.md` | SWE, DevOps |
| QA | Review issues | SWE, Project Manager |
| QA | `.workflow/handoff-notes/qa/session-NN.md` | Project Manager, SWE |
| DevOps | `docs/env-context.md` | SWE, QA |
| DevOps | `docs/release-plan.md` | Project Manager, QA |
| DevOps | `.workflow/handoff-notes/devops/session-NN.md` | Project Manager |
| System Architect | `docs/architecture.md` | SWE, QA, DevOps, Project Manager |
| System Architect | `.workflow/handoff-notes/system-architect/session-NN.md` | Project Manager, SWE |

### In-Repo Issue Tracking

Issues are tracked as files in `.workflow/issues/` within the deployed project. The project manager manages issue lifecycle. Skills that create, read, or close issues reference `.workflow/issues/` rather than any external service.

## Common Mistakes When Editing This Repo

**Updating one platform but not the other.** Changes must go into both `targets/ide/cursor/` and `targets/ide/claude-code/`. The implementations should stay aligned.

**Weak skill descriptions.** The `description` field in SKILL.md frontmatter is how the agent discovers the skill. Include both what it does and when to use it.

**Forgetting script companions.** Every `.sh` script needs a `.ps1` companion. They must maintain behavioral parity.

**Referencing external services in skills.** Skills should reference `.workflow/issues/` for task tracking, not GitHub Issues or any other external service. The system is designed to work in disconnected environments.
