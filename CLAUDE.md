# MachinEdge Expert Teams — Repo Guide

This repo defines platform-agnostic AI expert definitions for coordinated development teams. If you're an AI assistant working on this repo, this file is your starting point.

## Repo Structure

```
experts/technical/          ← Expert definitions (the core of this repo)
  project-manager/          ← Orchestrator and team lead
  swe/                      ← Software engineer
  qa/                       ← Quality assurance
  devops/                   ← DevOps/deployment
  data-analyst/             ← Data analysis (under development)
  user-experience/          ← UX design (under development)
  shared/                   ← Cross-expert protocols and shared skills
framework/                  ← Framework tooling
  scaffold/                 ← Expert authoring (create-expert scripts, templates)
  validate/                 ← Validation (validate.sh)
  install/                  ← Project installation
    install.sh/ps1          ← Standalone mode (Claude Code, Cursor)
    install-team.sh         ← Team mode (Docker + Matrix + OpenClaw)
    targets/                ← Per-platform translation docs
  package/                  ← Build & distribution (package.sh, SKILL.md)
  docs/                     ← Framework documentation (agent-reference.md, CONTRIBUTING.md)
docs/                       ← Vision, architecture, guides
build/                      ← Build output (gitignored)
```

Each expert has three things: `role.md` (identity and operating rules), `skills/` (structured capabilities as markdown), and `tools/` (executable scripts).

## Key Concepts

**Platform-agnostic definitions.** Expert definitions are canonical and platform-neutral. A translation layer converts them to OpenClaw (team mode), Claude Code, or Cursor configs. Never put platform-specific syntax in `role.md` or skill files.

**OpenClaw is the MVP team mode runtime.** Translation generates `AGENTS.md`, `SKILL.md` files, and routing bindings for Matrix-based multi-agent coordination.

**PM is the orchestrator.** In team mode, the human talks to the PM; the PM delegates to other experts. Skills are triggered by the PM, not invoked directly by the user.

**Documents are memory.** Experts have no memory between sessions. Everything goes in `docs/`. Issues are tracked in `issues/` (in-repo, not GitHub Issues).

**8-skill lifecycle.** Interview → Brief → Plan → Decompose → Execute → Review → Handoff → Synthesize. Not every expert needs all 8.

## Before Making Changes

1. Read `framework/docs/agent-reference.md` — the detailed guide for working on this repo
2. Read `experts/technical/shared/docs-protocol.md` — the document contracts between experts
3. Read the relevant expert's `role.md` and existing skills before modifying
4. Use full expert names (`project-manager`, not `pm`; `data-analyst`, not `eda`)

## Creating a New Expert

```bash
./framework/scaffold/create-expert.sh --domain technical <expert-name>
./framework/validate/validate.sh technical/<expert-name>
```

## Common Mistakes

- Breaking document contracts without updating `shared/docs-protocol.md`
- Platform-specific syntax in expert definitions (no `.claude/` paths, no Cursor frontmatter)
- Missing `tools/` directory (every expert needs it, even if empty with `.gitkeep`)
- Referencing external issue trackers instead of `issues/`
- Using deprecated short names (`pm`, `eda`) instead of full directory names

## Documentation

| Doc | What It Covers |
|-----|---------------|
| `docs/overview.md` | Vision, architecture, design philosophy |
| `docs/getting-started.md` | Setup for standalone and team modes |
| `docs/workflow-anatomy.md` | Deep-dive on expert structure, skill patterns, translation layer |
| `framework/docs/agent-reference.md` | Detailed reference for AI assistants working on this repo |
| `experts/technical/shared/docs-protocol.md` | Cross-expert document contracts |
