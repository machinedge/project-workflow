# Agent Reference

This document is for AI coding assistants (Claude Code, Cowork, Cursor, etc.) working **on this repository** — helping to build, modify, validate, or extend expert definitions. It is not operating instructions for deployed experts; those come from each expert's `role.md` at runtime.

If you're an AI assistant and someone has asked you to work on this repo, read this first.

## Orienting Yourself in the Repo

### What This Repo Is

This repo defines platform-agnostic AI expert definitions. Each expert has a role, a set of skills, and optional tooling. The definitions get translated into platform-specific configurations for deployment on Claude Code, Cursor, NanoClaw, OpenClaw, or MachinEdge's own container-based platform.

Read [overview.md](overview.md) for the full vision. Read [workflow-anatomy.md](workflow-anatomy.md) for structural details.

### Key Directories

| Path | Purpose |
|------|---------|
| `experts/` | All expert definitions, organized by domain |
| `experts/technical/` | Software development domain (the current focus) |
| `experts/technical/shared/` | Cross-expert protocols, shared skills, shared tools |
| `framework/` | Setup scripts, scaffolding, validation, build tooling |
| `docs/` | Documentation about the repo itself (you're reading one now) |
| `skills/` | Distributable skill package for Claude Code / Cowork |
| `build/` | Build tooling |

### Expert Directory Structure

Every expert follows this layout:

```
experts/<domain>/<expert-name>/
  role.md         # Identity, operating rules, session protocols
  skills/         # Markdown skill definitions (LLM-executed)
  tools/          # Executable scripts specific to this expert
```

Current experts in `experts/technical/`:

| Directory | Role | Status |
|-----------|------|--------|
| `project-manager/` | Orchestrator, team lead, planning | Active |
| `swe/` | Software engineering, implementation | Active |
| `qa/` | Quality assurance, testing, review | Active |
| `devops/` | Deployment, pipelines, environments | Active |
| `data-analyst/` | Time series data analysis | Under development |
| `user-experience/` | UX design | Under development (empty skills) |

## How to Work on Expert Definitions

### Modifying an Existing Expert

1. Read the expert's `role.md` to understand its current identity and protocols
2. Read the expert's existing skills in `skills/` to understand capabilities
3. Read `experts/technical/shared/docs-protocol.md` to understand document contracts between experts
4. Make changes, ensuring consistency with the patterns described in [workflow-anatomy.md](workflow-anatomy.md)

### Creating a New Expert

Use the scaffold script:

```bash
./framework/scaffold/create-expert.sh --domain technical maintenance-planner
```

This creates `experts/technical/maintenance-planner/` with a skeleton `role.md`, `skills/` directory, `tools/` directory, and guidance comments. Customize from there.

If creating manually, ensure your expert has all three directories and that `role.md` includes the required sections (see [workflow-anatomy.md](workflow-anatomy.md#the-rolemd-file)).

### Writing a `role.md`

The `role.md` file is the expert's identity. It must include:

| Section | Purpose |
|---------|---------|
| **Title** | "X Operating System" — tells the deployed expert what role it plays |
| **Document Locations** | Table of every document this expert reads and produces |
| **Session Protocol** | What to read at session start, do during, produce at end |
| **Skills** | List of available skills with descriptions |
| **Principles** | Non-negotiable behavioral rules |

Reference existing `role.md` files as templates. The project manager's is the most complete; the SWE's is a good minimal example.

### Writing a Skill

Skills are markdown files in `skills/` that define what an expert does when that skill is triggered. Every skill file should have:

1. **Opening context** (1-2 lines) — What is happening and why
2. **Steps or phases** — The actual work, numbered and self-contained
3. **Approval gates** — Explicit "wait for confirmation" at decision points
4. **Output specification** — What gets produced, where, in what format
5. **Rules section** — Constraints and edge case handling

Skills follow an 8-slot lifecycle (interview, brief, plan, decompose, execute, handoff, review, synthesis). Not every expert needs all 8. See [workflow-anatomy.md](workflow-anatomy.md#the-8-skill-lifecycle) for which slots each expert typically fills.

The `/start` skill is the most structured — it enforces a 7-phase process with approval gates. See [workflow-anatomy.md](workflow-anatomy.md#the-start-skill-7-phase-execution) for the required phase structure.

### Adding Tools

Tools go in the expert's `tools/` directory. Unlike skills (which are LLM-executed markdown), tools are executable scripts (`.sh`, `.ps1`, `.py`, etc.) that the expert can invoke. Tools enforce capability boundaries — only the project manager has `new_repo.sh`, for instance.

If an expert doesn't need tools yet, keep the `tools/` directory with a `.gitkeep` file.

## Document Contracts

When modifying experts, you need to understand how they exchange information at runtime. Experts communicate through shared documents and issues:

### Producer/Consumer Matrix

| Producer | Artifact | Consumer(s) |
|----------|----------|-------------|
| Project Manager | `docs/project-brief.md` | All experts |
| Project Manager | `docs/roadmap.md` | All experts |
| Project Manager | `issues/` (task issues) | SWE, QA, DevOps |
| SWE | Code + tests | QA, DevOps |
| SWE | `docs/handoff-notes/swe/session-NN.md` | Project Manager, QA |
| QA | `docs/test-plan.md` | SWE, DevOps |
| QA | Review issues | SWE, Project Manager |
| QA | `docs/handoff-notes/qa/session-NN.md` | Project Manager, SWE |
| DevOps | `docs/env-context.md` | SWE, QA |
| DevOps | `docs/release-plan.md` | Project Manager, QA |
| DevOps | `docs/handoff-notes/devops/session-NN.md` | Project Manager |
| Data Analyst | Analysis notebooks, `reports/` | Project Manager |
| Data Analyst | `docs/handoff-notes/data-analyst/session-NN.md` | Project Manager |

The full protocol is in `experts/technical/shared/docs-protocol.md`. When you add a new expert or modify document production/consumption, update that file.

### In-Repo Issue Tracking

Issues are tracked as files in `issues/` within the deployed project (not this repo, but in projects that use these expert definitions). The project manager manages issue lifecycle. When writing or modifying skills that create, read, or close issues, ensure they reference `issues/` rather than any external service.

## The Translation Layer

Expert definitions in this repo are platform-agnostic. The framework translates them to platform-specific configs. The MVP targets **OpenClaw** for team mode and **Claude Code / Cursor** for standalone mode.

| Target | `role.md` becomes | `skills/` become | `tools/` become |
|--------|-------------------|-----------------|-----------------|
| **OpenClaw** (MVP team mode) | Workspace `AGENTS.md` | `skills/*/SKILL.md` (+ YAML frontmatter) | In workspace |
| Claude Code (standalone) | `.claude/CLAUDE.md` | `.claude/commands/*.md` | Copied to project |
| Cursor (standalone) | `.cursor/rules/{name}.mdc` (+ YAML frontmatter) | `.cursor/commands/*.md` | Copied to project |

When modifying expert definitions, keep them platform-neutral. Don't include OpenClaw-specific, Claude Code-specific, or Cursor-specific syntax in `role.md` or skill files — the translation layer handles that.

### OpenClaw Translation Notes

For team mode, each expert becomes an OpenClaw agent with its own workspace. The translation generates `AGENTS.md` from `role.md`, `SKILL.md` files with YAML frontmatter from each skill, and agent routing bindings for Matrix message flow. See [workflow-anatomy.md](workflow-anatomy.md#openclaw-translation-team-mode) for details.

### Cursor-Specific Notes

Cursor requires YAML frontmatter. The setup script prepends this automatically:
```yaml
---
description: [1-line description]
alwaysApply: true
---
```

## Validation

After making changes, validate the expert definitions:

```bash
./framework/validate/validate.sh                              # Validate all experts
./framework/validate/validate.sh technical/swe                 # Validate a specific expert
./framework/validate/validate.sh technical/maintenance-planner # Validate a new expert
```

Validation checks for required sections in `role.md`, skill file structure, document contract consistency, and cross-references between experts.

## Common Mistakes When Editing This Repo

**Breaking document contracts.** If you change what an expert produces or consumes, update `experts/technical/shared/docs-protocol.md` and every other expert's `role.md` that references those documents.

**Platform-specific syntax in expert definitions.** Don't put `.claude/` paths, Cursor frontmatter, or NanoClaw-specific config in `role.md` or skill files. Keep them platform-neutral.

**Forgetting the `tools/` directory.** Every new expert needs `role.md`, `skills/`, and `tools/` (even if `tools/` is empty with a `.gitkeep`).

**Inconsistent naming.** Use the full expert directory name in references (e.g., `project-manager`, not `pm`; `data-analyst`, not `eda`). The old short names are deprecated.

**Referencing external services in skills.** Skills should reference `issues/` for task tracking, not GitHub Issues or any other external service. The platform is designed to be self-contained and work in disconnected environments.

**Skipping the shared protocol.** Every expert must reference `experts/technical/shared/docs-protocol.md` in its `role.md` for document locations. The shared protocol is the contract between experts — it's not optional.
