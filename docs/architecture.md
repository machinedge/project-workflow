# System Architecture

## Overview

This repo's infrastructure layer handles getting platform-agnostic expert definitions into users' environments. Three fundamentally different deployment mechanisms exist — IDE integration, desktop/CLI tool packaging, and autonomous multi-agent deployment — each with its own install/package workflow. The architecture organizes these by **target class**, replacing the current tangled `framework/` and `package/` split with a layout where each class and each target within it is self-contained.

## Directory Layout

### Top Level

```
experts/                    ← UNCHANGED (expert definitions)
docs/                       ← UNCHANGED + absorbs framework/docs/agent-reference.md
issues/                     ← UNCHANGED
CONTRIBUTING.md             ← moved from framework/docs/ to repo root (convention)

targets/                    ← NEW: all deployment targets (replaces framework/ + package/)
  ide/                      ← Target class 1: IDE-based
  desktop-cli/              ← Target class 2: Desktop/CLI environments
  autonomous/               ← Target class 3: Autonomous agent frameworks

tools/                      ← NEW: repo development + management utilities
  scaffold/                 ← Expert authoring
  validate/                 ← Expert validation
  new-repo.sh / .ps1        ← Create new project repos
  list-experts.sh / .ps1    ← Enumerate available experts
```

### Targets

```
targets/
  ide/                          ← IDE-based targets
    install.sh                  ← Shared standalone installer
    install.ps1
    cursor/                     ← Cursor-specific translation/config
      README.md
    claude-code/                ← Claude Code standalone-specific
      README.md
    # Future: kiro/, vscode/, continue-io/

  desktop-cli/                  ← Desktop/CLI environments
    claude/                     ← Claude Desktop, Claude Code, Cowork (.skill packaging)
      package.sh
      package.ps1
      install-skill.sh
      install-skill.ps1
      uninstall-skill.sh
      uninstall-skill.ps1
      SKILL.md
      build/                    ← Build scripts + output (output gitignored)
    # Future: gemini/, warp/

  autonomous/                   ← Autonomous agent frameworks
    openclaw/                   ← OpenClaw (Matrix + Docker)
      install-team.sh
      install-team.ps1
      templates/                ← Docker Compose, Matrix, conduit, etc.
    # Future: hermes/, beeai/
```

### Tools

```
tools/
  scaffold/                     ← Expert authoring
    create-expert.sh
    create-expert.ps1
    templates/
      role.md.tmpl
      skills/                   ← Skill templates (interview, review, brief, etc.)
  validate/                     ← Expert validation
    validate.sh
  new-repo.sh                   ← Create new project repos
  new-repo.ps1
  list-experts.sh               ← Enumerate available experts
  list-experts.ps1
```

## Data Flow

```
experts/ ──→ targets/<class>/<target>/<scripts> ──→ user's environment
               ↑
tools/ (scaffold creates experts, validate checks them)
```

- Expert definitions are **inputs** to every target. Targets read from `experts/` and transform/install into a user's environment.
- Target scripts are **independent**. Each target class has its own mechanism; they share no code.
- Development tools operate **on expert definitions**, not on targets.
- Repo utilities (`new-repo`, `list-experts`) are **end-user tools** that ship with the toolkit but aren't part of any deployment mechanism.

## Extensibility Model

Adding a new target follows one pattern across all three classes:

**New IDE target (e.g., Kiro):**
1. Create `targets/ide/kiro/`
2. Add Kiro-specific translation config or install overrides
3. No changes to other targets or core files

**New desktop-cli target (e.g., Gemini):**
1. Create `targets/desktop-cli/gemini/`
2. Add Gemini-specific packaging scripts and config
3. No changes to Claude or other target directories

**New autonomous target (e.g., BeeAI):**
1. Create `targets/autonomous/beeai/`
2. Add BeeAI-specific install script and templates
3. No changes to OpenClaw or other directories

The rule: **one directory, optionally one script, zero changes elsewhere.**

## Migration Mapping

| Current Location | New Location |
|------------------|-------------|
| `framework/install/install.sh` | `targets/ide/install.sh` |
| `framework/install/install.ps1` | `targets/ide/install.ps1` |
| `framework/install/targets/cursor/` | `targets/ide/cursor/` |
| `framework/install/targets/claude-code/` | `targets/ide/claude-code/` |
| `framework/install/install-team.sh` | `targets/autonomous/openclaw/install-team.sh` |
| `framework/install/install-team.ps1` | `targets/autonomous/openclaw/install-team.ps1` |
| `framework/install/templates/team/*` | `targets/autonomous/openclaw/templates/*` |
| `framework/install/targets/openclaw/` | `targets/autonomous/openclaw/` (merged) |
| `framework/scaffold/*` | `tools/scaffold/*` |
| `framework/validate/*` | `tools/validate/*` |
| `framework/docs/agent-reference.md` | `docs/agent-reference.md` |
| `framework/docs/CONTRIBUTING.md` | `CONTRIBUTING.md` (repo root) |
| `package/package.sh` | `targets/desktop-cli/claude/package.sh` |
| `package/package.ps1` | `targets/desktop-cli/claude/package.ps1` |
| `package/install-skill.sh` | `targets/desktop-cli/claude/install-skill.sh` |
| `package/install-skill.ps1` | `targets/desktop-cli/claude/install-skill.ps1` |
| `package/uninstall-skill.sh` | `targets/desktop-cli/claude/uninstall-skill.sh` |
| `package/uninstall-skill.ps1` | `targets/desktop-cli/claude/uninstall-skill.ps1` |
| `package/SKILL.md` | `targets/desktop-cli/claude/SKILL.md` |
| `package/build/*` | `targets/desktop-cli/claude/build/*` |
| `package/tools/new_repo.sh` | `tools/new-repo.sh` |
| `package/tools/new_repo.ps1` | `tools/new-repo.ps1` |
| `package/tools/list-experts.sh` | `tools/list-experts.sh` |
| `package/tools/list-experts.ps1` | `tools/list-experts.ps1` |
| `CLAUDE.md` | Deleted (separate task, M7) |

**Deleted after migration:**
- `framework/` — fully replaced by `targets/` + `tools/` + `docs/`
- `package/` — fully replaced by `targets/desktop-cli/claude/` + `tools/`

## Architecture Decisions

| ID | Decision | Status | Date |
|----|----------|--------|------|
| ADR-001 | Organize targets by class hierarchy | Accepted | 2026-03-12 |
| ADR-002 | Top-level `tools/` for development and repo utilities | Accepted | 2026-03-12 |
| ADR-003 | Merge framework docs into `docs/` and repo root | Accepted | 2026-03-12 |
| ADR-004 | Name second target class `desktop-cli` with per-target subdirectories | Accepted | 2026-03-12 |

### ADR-001: Organize targets by class hierarchy

**Context:** The current `framework/` and `package/` directories have overlapping responsibilities and no clear organization principle. Three distinct deployment mechanisms exist (IDE install, .skill packaging, container-based multi-agent). How should they be organized?

**Options considered:**
- **(A) Target-class hierarchy** — `targets/ide/`, `targets/desktop-cli/`, `targets/autonomous/` with per-target subdirectories. Shows relationships, shared class-level scripts co-located, scales well.
- **(B) Flat targets** — `targets/cursor/`, `targets/claude-code/`, `targets/openclaw/`. Simpler, but doesn't show relationships, shared class-level scripts have no home, scales poorly.
- **(C) Keep framework/package** — Reorganize internally. Minimal disruption, but doesn't solve the core problem.

**Decision:** Option A. The three target classes have fundamentally different deployment mechanisms. Making that visible in the directory structure is the purpose of this restructure.

**Consequences:** One extra level of nesting compared to Option B. Accepted — clarity is worth more than flatness.

### ADR-002: Top-level `tools/` for development and repo utilities

**Context:** Scaffold, validate, new-repo, and list-experts are currently scattered across `framework/scaffold/`, `framework/validate/`, and `package/tools/`. Where should they live?

**Options considered:**
- **(A) Top-level `tools/`** — Clear separation from targets, visible at top level.
- **(B) Under `targets/`** — Fewer top-level dirs, but confusing — dev tools aren't targets.
- **(C) Scattered** — No new directory, but no clear home either.

**Decision:** Option A. These tools are for repo development and project management, not deployment. A top-level directory makes this obvious and separates concerns cleanly.

**Consequences:** One new top-level directory. Net zero change since `framework/` and `package/` are removed.

### ADR-003: Merge framework docs into `docs/` and repo root

**Context:** `framework/docs/` contains `agent-reference.md` and `CONTRIBUTING.md`. Where should they go when `framework/` is removed?

**Options considered:**
- **(A) Merge into `docs/` and repo root** — `agent-reference.md` joins other docs in `docs/`, `CONTRIBUTING.md` goes to repo root per convention.
- **(B) Keep separate** — `tools/docs/` or similar. Extra nesting, harder to find.

**Decision:** Option A. `docs/` already contains toolkit documentation. `CONTRIBUTING.md` at repo root follows standard open-source convention.

**Consequences:** `docs/` mixes toolkit docs with framework-internal docs, but the directory is already toolkit-scoped.

### ADR-004: Name second target class `desktop-cli` with per-target subdirectories

**Context:** The second target class covers Claude Desktop, Claude Code, Cowork, and potentially future tools like Gemini CLI or Warp. The original name "desktop" was too narrow, and all artifacts were at the class level assuming Claude-only.

**Options considered:**
- **(A) `desktop/` with all scripts at class level** — Assumes Claude .skill is the only packaging mechanism.
- **(B) `desktop-cli/` with per-target subdirectories** — Each tool (Claude, Gemini, Warp) gets its own subdirectory with its own packaging mechanism.

**Decision:** Option B. Different desktop/CLI tools will likely have different packaging formats. Per-target subdirectories follow the same extensibility pattern as the other two target classes.

**Consequences:** Current Claude artifacts move one level deeper (`targets/desktop-cli/claude/` instead of `targets/desktop/`). Future targets can be added without modifying Claude's directory.

## Constraints

- Expert definitions (`experts/`) are unchanged — this restructure is infrastructure only
- Breaking changes to `framework/` and `package/` paths are accepted
- OpenClaw code is preserved, not deleted — isolated in `targets/autonomous/openclaw/`
- `CLAUDE.md` removal is a separate task (M7)
- No implementation in this task — design only
