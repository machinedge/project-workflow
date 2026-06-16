# System Architecture

## Overview

This repo contains a single, harness-neutral set of expert implementations under `agents/`. The installer copies that one source into a project as `.agents/` and wires it to `AGENTS.md` — the operating-system file read by Claude Code, Codex, and any harness that follows the AGENTS.md convention. There is no per-platform fork and no translation pipeline; `agents/` is the source of truth.

## Directory Layout

### Top Level (toolkit repo)

```
install.sh / install.ps1        ← Installer (copies agents/ into a project)
agents/                         ← Single source of truth (harness-neutral)
  AGENTS.md                     ← Operating-system file (expert routing + conventions)
  settings.json                 ← Claude Code SessionStart hook definition
  roles/                        ← Expert role definitions
  commands/                     ← Explicit command files
  skills/                       ← Discoverable skill folders (SKILL.md)
  scripts/                      ← Mechanical operation scripts (.sh + .ps1)
docs/                           ← Documentation
.workflow/                      ← Managed artifacts (handoff notes, issues, lessons)
```

### Installed Layout (user's project)

```
AGENTS.md                       ← copy of agents/AGENTS.md
CLAUDE.md → AGENTS.md           ← symlink (Claude Code reads the same file)
.agents/                        ← copy of agents/ (roles, commands, skills, scripts)
.claude/                        ← Claude-native wiring (skipped with --no-claude)
  commands → ../.agents/commands   skills → ../.agents/skills
  roles    → ../.agents/roles      scripts → ../.agents/scripts
  settings.json                 ← SessionStart hook (merged, not overwritten)
docs/        .workflow/
```

## Data Flow

```
agents/ ──(install.sh)──→ project AGENTS.md + .agents/  (+ .claude/ symlinks)
```

- `agents/` is self-contained and installed to the user's project via file copy.
- The install script is a copy operation plus symlink wiring — no transformation or generation.
- One `.agents/` payload serves every harness: AGENTS.md-aware tools read `AGENTS.md` + `.agents/` directly; Claude Code additionally gets native slash-command / skill discovery and a `SessionStart` hook through the `.claude/` symlinks.

## Extensibility Model

**New harness:** if it reads `AGENTS.md`, it works out of the box — no changes. If it needs native wiring like Claude's `.claude/` symlinks, add a small wiring branch to the installer that points the harness's config dir at `.agents/`. The payload itself never forks.

The rule: **one source, harness-specific wiring is symlinks only.**

## Architecture Decisions

| ID | Decision | Status | Date |
|----|----------|--------|------|
| ADR-012 | Generic AGENTS.md model — single `agents/` source, `.agents/` copy + symlinked `CLAUDE.md`/`.claude/`, Cursor dropped | Accepted | 2026-06-16 |
| ADR-001 | Organize targets by class hierarchy | Superseded (ADR-012) | 2026-03-12 |
| ADR-002 | Top-level `tools/` for development and repo utilities | Superseded (removed in M12) | 2026-03-12 |
| ADR-003 | Merge framework docs into `docs/` and repo root | Accepted | 2026-03-12 |
| ADR-004 | Name second target class `desktop-cli` with per-target subdirectories | Superseded (removed in M12) | 2026-03-12 |
| ADR-005 | Handoffs and autonomous skills as discoverable skills (not commands) | Accepted | — |
| ADR-006 | Soft auto-trigger for handoff on both platforms | Accepted | — |
| ADR-007 | Shell scripts in `.cursor/scripts/` and `.claude/scripts/` | Accepted | — |
| ADR-008 | Direct-copy install replaces translation pipeline | Superseded (ADR-012) | — |
| ADR-009 | Session primer as raw extractor, not agent summarizer | Accepted | — |
| ADR-010 | Team-prefixed skills run roleless (no expert role loaded) | Accepted | — |
| ADR-011 | Split managed artifacts into `.workflow/` directory | Accepted | — |

### ADR-012: Generic AGENTS.md model

**Context:** The toolkit shipped two pre-built platform copies under `targets/ide/` (Cursor `.mdc` rules and Claude Code roles), kept byte-for-byte aligned by hand. The `agents/` directory already held a generic copy identical to the Claude implementation. Maintaining parallel forks is pure overhead, and the ecosystem has converged on a root `AGENTS.md` convention (Claude Code, Codex, and others) that makes a single neutral source viable.

**Options considered:**
- **(A) Generic single source** — One `agents/` payload. Install copies it to `.agents/`, writes a top-level `AGENTS.md`, symlinks `CLAUDE.md → AGENTS.md`, and symlinks `.claude/{commands,skills,roles,scripts} → .agents/*` for Claude's native discovery. Drop Cursor.
- **(B) Keep platform forks** — Continue maintaining `targets/ide/cursor/` and `targets/ide/claude-code/` separately. No new convention to rely on, but double the maintenance and a Cursor implementation nobody is driving.
- **(C) Generic source + keep Cursor** — Neutral `agents/` plus a retained Cursor `.mdc` target. Keeps Cursor but reintroduces a fork for the one harness that doesn't read `AGENTS.md`.

**Decision:** Option A. A single harness-neutral source eliminates the dual-maintenance burden. `AGENTS.md` covers Claude Code and Codex directly; Claude's native slash-command/skill discovery and `SessionStart` hook are preserved through symlinks into the same `.agents/` payload (no duplicated content). Cursor is dropped — it does not read `AGENTS.md` and keeping it would mean a fork for zero current users. `--no-claude` installs the pure-generic layout for Codex-only projects.

**Consequences:** `targets/` is deleted; `experts/` etc. were already removed in M12. Path references in the payload move from `.claude/...` to `.agents/...` so they resolve for every harness. Native Claude discovery now depends on Claude Code resolving symlinked `.claude/skills`/`.claude/commands` directories (verified). Windows installs fall back to copies when symlinks are unavailable (no Developer Mode). Adding Cursor back later would require either re-introducing a `.mdc` fork or a translation step. Supersedes ADR-001 (target-class hierarchy) and ADR-008 (direct-copy of platform dirs).

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

### ADR-005: Handoffs and autonomous skills as discoverable skills (not commands)

**Context:** Canonical skill files are all installed as commands today. The platform-native refactor needs to decide which files become discoverable skills (SKILL.md) vs. explicit commands.

**Options considered:**
- **(A) Conservative** — Only purely autonomous skills become discoverable. Handoffs and `/start` stay as commands.
- **(B) Aggressive** — All autonomous skills AND handoffs become discoverable skills. Only interactive skills (interview, add_feature, env-discovery, deploy) and `/start` (approval gates) stay as commands.

**Decision:** Option B. Skills can be invoked both via agent discovery AND explicit `/skill-name` (same UX as commands). Handoffs benefit from discovery — the agent should recognize "wrapping up" intent without the user typing a command.

**Consequences:** 21 skills + 9 commands instead of ~4 skills + ~26 commands. More SKILL.md folders to maintain, but agent discovery is the primary UX improvement of M11.

### ADR-006: Soft auto-trigger for handoff on both platforms

**Context:** The goal is automatic handoff when users signal they're done. Cursor has no session-end hook. Claude Code's `SessionEnd` can't run complex workflows after the session closes.

**Options considered:**
- **(A) Hard hook (Claude Code only)** — Use `SessionEnd` hook for Claude Code; rule-based soft trigger for Cursor. Creates platform divergence.
- **(B) Soft trigger (both platforms)** — Expert role files instruct the agent to run handoff when "wrapping up" is detected. Handoff skill descriptions reinforce discovery. Consistent across platforms.
- **(C) Stop hook + soft trigger** — Use Claude Code's `Stop` prompt hook as a safety net alongside soft triggers on both platforms.

**Decision:** Option B for M11. Both platforms use the same mechanism: role instruction + discoverable skill description. Consistent behavior across platforms. Option C can be added later as an enhancement.

**Consequences:** Auto-trigger reliability is ~70-80% (dependent on agent recognizing intent). Users can always invoke `/prefix-handoff` explicitly. Consistent behavior across platforms.

### ADR-007: Shell scripts in `.cursor/scripts/` and `.claude/scripts/`

**Context:** Seven mechanical operations (issue numbering, file movement, session numbering, issues list regeneration) are repeated across multiple skill files. Where should extracted scripts live?

**Options considered:**
- **(A) Platform config scripts directory** — `.cursor/scripts/`, `.claude/scripts/`. Our convention, hidden from user.
- **(B) Skill subdirectories** — Each skill's `scripts/` folder. Duplicates scripts across skills.
- **(C) Project-level scripts** — `scripts/` at project root. Visible and modifiable but not hidden.

**Decision:** Option A. Scripts are implementation details, not user-facing tools. Placing them in the platform config directory keeps them hidden while accessible to the agent via Shell tool.

**Consequences:** New directory convention (`.cursor/scripts/`, `.claude/scripts/`) not standard to either platform, but agents invoke them without issue.

### ADR-008: Direct-copy install replaces translation pipeline

**Context:** Currently `install.sh` reads canonical definitions from `experts/technical/`, parses role files, generates platform-specific frontmatter, applies prefixes, and writes to the user's project. With platform-native implementations pre-built in `targets/ide/<platform>/`, the install script can simplify.

**Options considered:**
- **(A) Direct copy** — Install script copies pre-built files from `targets/ide/<platform>/` to user's project. No transformation.
- **(B) Keep translation** — Maintain the translation pipeline from canonical definitions. Platform directories are just overrides.

**Decision:** Option A. Translation adds complexity and maintenance burden. The entire point of the platform-native refactor is that each platform is a first-class implementation.

**Consequences:** Install script becomes dramatically simpler. Changes must be made separately in each platform implementation (sync command addresses this).

### ADR-009: Session primer as raw extractor, not agent summarizer

**Context:** The original architecture specified `session-context.sh` as a shell script invoked by Claude Code's `SessionStart` hook to "output brief project context (project name, current status from brief, most recent handoff summary)." During implementation (swe-feature-034), it was determined that producing a compressed summary from project documents is agent work, not mechanical file manipulation (see lessons log).

**Options considered:**
- **(A) Redefine hook script as raw content extractor** — Output sections from project files without summarization. Rename to `session-primer.sh`. Agent processes raw text naturally. Cursor gets no equivalent (no session-start hook).
- **(B) Replace with discoverable skill** — `team-session-context/SKILL.md` on both platforms. Remove the hook. Agent invokes skill to produce intelligent summary.
- **(C) Discoverable skill + hook prompt** — Skill on both platforms. Hook outputs instruction to run the skill. Two mechanisms for one behavior.
- **(D) Remove hook entirely** — Rely on `/start` and per-skill context loading. No new artifact.

**Decision:** Option A. The script's scope is redefined: extract raw content (project identity, current status section, most recent handoff note) using mechanical operations (`head`, `sed`, `find`, `cat`). The agent's natural reasoning handles interpretation and prioritization. This preserves the hook's 100% reliability while respecting the boundary — scripts do mechanical work, agents do intelligent work.

**Consequences:** Claude Code retains its platform advantage (automatic context at session start). Cursor has no equivalent, which is an acceptable gap — Cursor users use `/start` commands and per-skill context loading. Script should cap output length to avoid flooding the agent with verbose handoff notes.

### ADR-010: Team-prefixed skills run roleless

**Context:** The `team-` prefix routes to shared, cross-expert skills (currently `team-status`, with room for future additions). Unlike other prefixes (pm, swe, qa, ops, sa) which each map to a specific expert role, `team-` has no corresponding expert. The routing instruction "use the current session context" is ambiguous when no session is active and semantically incorrect — cross-expert skills should not adopt a single-expert persona.

**Options considered:**
- **(A) Roleless** — `team-` skills run with only the always-loaded project-os context (`project-os.mdc` / `CLAUDE.md`) and their own SKILL.md instructions. No expert role is loaded.
- **(B) Lightweight team role** — Create a minimal `team-os.mdc` / `team.md` providing cross-expert identity and listing shared skills.
- **(C) PM fallback** — Route `team-` to the PM role when no expert session is active, since PM is the natural project-level coordinator.

**Decision:** Option A. Team-prefixed skills are cross-expert by definition. Loading any single expert role would add irrelevant context (~70 lines) and impose wrong-persona principles. Each `team-*` skill is self-contained: its SKILL.md includes its own context loading and instructions. The always-loaded project-os context provides shared principles — that's sufficient grounding.

**Consequences:** `team-*` skills must be fully self-contained (own context loading, own instructions). No new role files to create or maintain. Future shared skills follow the same pattern. The routing table explicitly notes `team-` as roleless.

## Constraints

- `agents/` is the single source of truth; the installer copies it into a project
- Payload path references use `.agents/...` so they resolve across harnesses
- `experts/`, `tools/`, `targets/desktop-cli/`, and `targets/autonomous/` were removed in M12; `targets/` (Cursor + Claude forks) was removed under ADR-012

## Implementation Model

### Overview

There is one implementation under `agents/`. The installer copies it to `.agents/` in the project and wires `AGENTS.md`. Harness-specific behavior (Claude's native discovery and `SessionStart` hook) is added by symlinks into the same payload — never by a fork.

### Design Principles

1. **One generic source.** A single `agents/` payload drives every harness. No per-platform implementation, no abstraction layer.
2. **Skills are discoverable.** Autonomous skills are `SKILL.md` folders the agent matches against intent. Claude Code also surfaces them in the `/` menu via the `.claude/skills` symlink.
3. **Commands are intentional.** Interactive workflows and approval-gated processes are explicit commands the user invokes.
4. **Context is loaded on demand.** Expert roles load by prefix (one per session). Document loading happens in individual skills, not a global protocol.
5. **Mechanical operations are scripted.** Repetitive file operations (issue numbering, file movement) live in `scripts/`, not inline in skills.
6. **Harness-neutral paths.** Payload files reference `.agents/...`, which resolves for every harness; `.claude/...` exists only when Claude wiring is installed.

### File Categories

The 36 in-scope expert files fall into 5 categories:

| Category | Count | Form | Invocation |
|----------|-------|------|------------|
| Role definitions | 5 | `roles/<expert>.md` | Loaded by prefix when expert is identified |
| Start commands | 5 | `commands/<prefix>-start.md` | Explicit `/prefix-start` |
| Interactive commands | 4 | `commands/<prefix>-<name>.md` | Explicit `/prefix-name` |
| Autonomous skills | 16 | `skills/<prefix>-<name>/SKILL.md` | Agent-discovered or explicit `/prefix-name` |
| Handoff skills | 5 | `skills/<prefix>-handoff/SKILL.md` | Agent-discovered or explicit `/prefix-handoff` |
| Shared protocol | 1 | Absorbed into `AGENTS.md` | N/A |

**Totals:** 5 roles + 9 commands + 21 skills = 35 installed files, plus `AGENTS.md`.

### AGENTS.md

`AGENTS.md` is the always-loaded operating-system file. It contains the expert routing table (prefix → `.agents/roles/<expert>.md`), the `team-` roleless rule (ADR-010), shared conventions (handoff-note and issue path patterns under `.workflow/`), a `.agents/scripts/` reference, and shared principles. Claude Code reads it through the `CLAUDE.md → AGENTS.md` symlink; Codex and other harnesses read it directly.

### Skills and Commands

Each skill is a `skills/<prefix>-<name>/` folder with a `SKILL.md` carrying YAML frontmatter:

```yaml
---
name: <prefix>-<skill-name>
description: <What this skill does. When to use it. Max 1024 chars.>
---
```

The `description` is the discovery trigger. Command references inside skills use full prefixes (e.g. `/pm-interview`). Skills that need context include their own loading phase. Commands are plain markdown using `$ARGUMENTS`, reserved for approval-gated `/start` sessions and interactive workflows (interview, add-feature, deploy, env-discovery).

### Scripts

| Script | Arguments | Output |
|--------|-----------|--------|
| `next-issue-number.sh` | — | Next available issue number |
| `move-issue.sh` | `<filename> <target-dir>` | Confirmation; moves issue between `.workflow/issues/` dirs |
| `update-issues-list.sh` | — | Regenerated `.workflow/issues/issues-list.md` |
| `next-session-number.sh` | `<expert-name>` | Next session number; atomically claims a placeholder to avoid collisions |
| `update-brief-status.sh` | `<issue-id> <status>` | `"OK"`; atomically updates the "Last updated" line in `docs/project-brief.md` under a lock |

Each `.sh` has a `.ps1` companion. Additionally, `session-primer.sh` (no `.ps1` needed) is invoked by Claude Code's `SessionStart` hook to extract raw project context — see ADR-009.

### Claude Code Hook

`agents/settings.json` defines the hook, merged into a project's `.claude/settings.json` (never overwritten):

```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command", "command": ".claude/scripts/session-primer.sh" } ] }
    ]
  }
}
```

The command resolves through the `.claude/scripts → ../.agents/scripts` symlink. The hook runs only under Claude Code; harnesses without a session-start hook rely on `/start` commands and per-skill context loading.

### Install Steps

The installer (`install.sh` / `install.ps1`) performs:

1. Create `docs/` and the `.workflow/` structure; migrate any legacy `issues/` and `docs/handoff-notes/` into `.workflow/`.
2. Copy `agents/{roles,commands,skills,scripts}`, `AGENTS.md`, and `settings.json` into `.agents/`.
3. Write a top-level `AGENTS.md` (backing up a pre-existing user `AGENTS.md`) and symlink `CLAUDE.md → AGENTS.md`.
4. Unless `--no-claude`: symlink `.claude/{commands,skills,roles,scripts} → ../.agents/*` and merge the `settings.json` hook.

On Windows, symlink creation falls back to copies when Developer Mode is unavailable.

### ADR-011: Split managed artifacts into `.workflow/` directory

**Context:** Managed workflow artifacts (handoff notes, issues, interview notes, lessons log, research reports) are agent memory — noisy for humans browsing the project tree. Currently they live in `docs/` and top-level `issues/`. How should user-facing planning docs be separated from agent-managed artifacts?

**Options considered:**
- **(A) Flat `.workflow/`** — All moved artifacts directly under `.workflow/` (e.g., `.workflow/lessons-log.md`, `.workflow/issues/`, `.workflow/handoff-notes/`). Simple, mirrors current structure with a prefix change.
- **(B) Nested `.workflow/docs/`** — Keep a `docs/` subdirectory inside `.workflow/` for non-issue artifacts. Preserves old mental model but adds unnecessary nesting.
- **(C) Categorized `.workflow/`** — Group by type: `.workflow/memory/` for handoff/lessons, `.workflow/tracking/` for issues. Adds structure but also complexity for zero benefit.

**Decision:** Option A. The artifacts already have clear names; adding sub-categories creates depth without value. The move is a prefix change from `docs/` or top-level to `.workflow/`.

**Consequences:** Every path reference across ~90 files per platform changes. The change is mechanical (string replacement) but high-surface-area. `.workflow/` is not auto-added to `.gitignore` — user's choice whether to commit agent memory.

#### Directory Tree

```
.workflow/
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
    issues-list.md
  lessons-log.md
  interview-notes.md            # from pm-interview (initial)
  interview-notes-*.md          # from pm-add-feature (per-feature)
  research-*.md                 # ad-hoc research outputs
```

#### Path Mapping

| Old Path | New Path | Code References |
|----------|----------|-----------------|
| `docs/handoff-notes/` | `.workflow/handoff-notes/` | ~45 files/platform |
| `docs/handoff-notes/<expert>/session-NN.md` | `.workflow/handoff-notes/<expert>/session-NN.md` | (included above) |
| `docs/interview-notes.md` | `.workflow/interview-notes.md` | ~7 files/platform |
| `docs/interview-notes-*.md` | `.workflow/interview-notes-*.md` | (included above) |
| `docs/lessons-log.md` | `.workflow/lessons-log.md` | ~19 files/platform |
| `docs/research-*.md` | `.workflow/research-*.md` | 0 (no code refs) |
| `issues/` | `.workflow/issues/` | ~40 files/platform |
| `issues/backlog/` | `.workflow/issues/backlog/` | (included above) |
| `issues/planned/` | `.workflow/issues/planned/` | (included above) |
| `issues/in-progress/` | `.workflow/issues/in-progress/` | (included above) |
| `issues/done/` | `.workflow/issues/done/` | (included above) |
| `issues/issues-list.md` | `.workflow/issues/issues-list.md` | (included above) |

#### docs/ Retention List

These files stay in `docs/` — they are core planning docs or user-generated content, not agent memory:

| File | Why it stays |
|------|-------------|
| `project-brief.md` | Core planning doc, source of truth |
| `roadmap.md` | Core planning doc |
| `architecture.md` | Core planning doc, SA-owned |
| `agent-reference.md` | Project-specific reference |
| `test-plan.md` | Core planning doc, QA-owned |
| `env-context.md` | Core planning doc (may not exist) |
| Any user-created docs | Not workflow artifacts |

#### Script Path Changes

| Script | Old Path | New Path |
|--------|----------|----------|
| `next-session-number.sh/.ps1` | `docs/handoff-notes/$expert` | `.workflow/handoff-notes/$expert` |
| `move-issue.sh/.ps1` | `issues/backlog` ... `issues/done`, `issues/$target` | `.workflow/issues/backlog` ... `.workflow/issues/done`, `.workflow/issues/$target` |
| `next-issue-number.sh/.ps1` | `issues/backlog` ... `issues/done` | `.workflow/issues/backlog` ... `.workflow/issues/done` |
| `update-issues-list.sh/.ps1` | `issues/issues-list.md`, `issues/backlog` ... `issues/done` | `.workflow/issues/issues-list.md`, `.workflow/issues/backlog` ... `.workflow/issues/done` |
| `session-primer.sh` (Claude Code only) | `docs/handoff-notes` | `.workflow/handoff-notes` |
| `test-scripts.sh` | `docs/handoff-notes` + `issues/` | `.workflow/handoff-notes` + `.workflow/issues/` |
| `update-brief-status.sh/.ps1` | `docs/project-brief.md` | No change (stays in `docs/`) |

#### Conventions Update

The conventions sections in `project-os.mdc` (Cursor) and `CLAUDE.md` (Claude Code) currently define canonical path patterns. These update as follows:

| Current Convention | New Convention |
|--------------------|----------------|
| `docs/handoff-notes/<expert>/session-NN.md` | `.workflow/handoff-notes/<expert>/session-NN.md` |
| `issues/<status>/[expert]-[type]-[NNN].md` | `.workflow/issues/<status>/[expert]-[type]-[NNN].md` |

#### Edge Cases

1. **Mixed references in skills:** Many skills reference both staying files (e.g., `docs/project-brief.md`) and moving files (e.g., `docs/lessons-log.md`). Since every path is fully qualified, this is a mechanical find-and-replace — no ambiguity.

2. **`docs/research-*.md` has no code references:** The `sa-research` skill doesn't codify an output path — research results go into `docs/architecture.md` or handoff notes. The mapping is included for completeness.

3. **Conventions are the routing hub:** `project-os.mdc` and `CLAUDE.md` define the canonical path patterns. Update these first — they're the reference all other files point back to.

4. **Install script scaffolding:** `install.sh` and `install.ps1` create directory structures on fresh install. These change from `docs/handoff-notes/`, `docs/lessons-log.md`, and `issues/` to `.workflow/handoff-notes/`, `.workflow/lessons-log.md`, and `.workflow/issues/`. The `docs/` directory is still created for core planning docs.

5. **Top-level `issues/` disappears:** On fresh installs, there is no top-level `issues/` directory. It becomes `.workflow/issues/`. Migration (M14) handles moving existing `issues/` content.

6. **`docs/architecture.md` self-referential updates:** This document's own non-ADR sections reference old paths: the Top Level directory layout (line ~31), session-primer.sh behavior description (lines ~511-513), and script specifications table (lines ~534-539). Update these when the corresponding scripts and install logic are updated — not before, to avoid a half-current/half-future document.

#### Implementation Order

SWE tasks should follow this order to minimize risk:
1. Update conventions (`project-os.mdc`, `CLAUDE.md`) — establishes the new canonical paths
2. Update rules/roles — expert role files reference artifact locations
3. Update commands — `/start` commands load context from these paths
4. Update skills — the largest surface area; mechanical find-and-replace
5. Update scripts — hardcoded paths in shell/PowerShell scripts
6. Update install scripts — fresh install creates new layout
7. Update docs and READMEs — documentation references
8. Reinstall and verify — end-to-end test on this project
