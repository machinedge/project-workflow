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
    cursor/                     ← Cursor platform-native implementation
      README.md
      rules/                    ← Rule files (.mdc)
      commands/                 ← Explicit command files
      skills/                   ← Discoverable skill folders (SKILL.md)
      scripts/                  ← Mechanical operation scripts
    claude-code/                ← Claude Code platform-native implementation
      README.md
      CLAUDE.md                 ← Shared principles + expert routing
      settings.json             ← Hook definitions
      roles/                    ← Expert role definitions
      commands/                 ← Explicit command files
      skills/                   ← Discoverable skill folders (SKILL.md)
      scripts/                  ← Mechanical operation scripts
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

- For **IDE targets** (Cursor, Claude Code): platform-native implementations in `targets/ide/<platform>/` are self-contained and installed directly to the user's project via file copy. `experts/technical/` is retained as a reference but is not the source of truth for IDE targets.
- For **other target classes** (desktop-cli, autonomous): targets read from `experts/` and transform/install into users' environments.
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
| ADR-005 | Handoffs and autonomous skills as discoverable skills (not commands) | Accepted | — |
| ADR-006 | Soft auto-trigger for handoff on both platforms | Accepted | — |
| ADR-007 | Shell scripts in `.cursor/scripts/` and `.claude/scripts/` | Accepted | — |
| ADR-008 | Direct-copy install replaces translation pipeline | Accepted | — |

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

## Constraints

- Expert definitions (`experts/`) are unchanged — this restructure is infrastructure only
- Breaking changes to `framework/` and `package/` paths are accepted
- OpenClaw code is preserved, not deleted — isolated in `targets/autonomous/openclaw/`
- `CLAUDE.md` removal is a separate task (M7)
- No implementation in this task — design only

## Platform-Native Architecture

### Overview

Each IDE target platform (Cursor, Claude Code) has its own first-class implementation in `targets/ide/<platform>/`. These are the source of truth for their platform — not translations from canonical definitions. `experts/technical/` is retained as a reference only.

The install script copies pre-built platform files directly to the user's project. No translation pipeline.

### Design Principles

1. **Platform-native, not translated.** Each platform implementation uses the platform's native concepts directly. No abstraction layer.
2. **Skills are discoverable.** Autonomous skills use platform-native discovery (SKILL.md) so the agent can find and invoke them without explicit user commands.
3. **Commands are intentional.** Interactive workflows and approval-gated processes remain explicit commands the user invokes.
4. **Context is loaded on demand.** Expert roles are loaded conditionally (one per session). Document loading happens in individual skills, not in a global session protocol.
5. **Mechanical operations are scripted.** Repetitive file operations (issue numbering, file movement) are handled by hidden shell scripts, not reimplemented in every skill.

### File Categories

The 36 in-scope canonical files (excluding Data Analyst, which is out of scope for M11) fall into 5 categories based on their interaction pattern:

| Category | Count | Platform Concept | Invocation |
|----------|-------|-----------------|------------|
| Role definitions | 5 | Conditional rule (Cursor) / Role (Claude Code) | Auto-loaded when expert is identified |
| Start commands | 5 | Command (both) | Explicit `/prefix-start` by user |
| Interactive commands | 4 | Command (both) | Explicit `/prefix-name` by user |
| Autonomous skills | 16 | Skill with SKILL.md (both) | Agent-discovered or explicit `/prefix-name` |
| Handoff skills | 5 | Skill with SKILL.md (both) | Agent-discovered or explicit `/prefix-handoff` |
| Shared protocol | 1 | Absorbed into role files | N/A |

### Canonical File Mapping

| # | Canonical File | Category | Cursor Path | Claude Code Path |
|---|---------------|----------|-------------|-----------------|
| 1 | `project-manager/role.md` | Role | `rules/project-manager-os.mdc` | `roles/project-manager.md` |
| 2 | `project-manager/skills/start.md` | Start | `commands/pm-start.md` | `commands/pm-start.md` |
| 3 | `project-manager/skills/handoff.md` | Handoff | `skills/pm-handoff/SKILL.md` | `skills/pm-handoff/SKILL.md` |
| 4 | `project-manager/skills/interview.md` | Interactive | `commands/pm-interview.md` | `commands/pm-interview.md` |
| 5 | `project-manager/skills/add_feature.md` | Interactive | `commands/pm-add-feature.md` | `commands/pm-add-feature.md` |
| 6 | `project-manager/skills/vision.md` | Autonomous | `skills/pm-vision/SKILL.md` | `skills/pm-vision/SKILL.md` |
| 7 | `project-manager/skills/roadmap.md` | Autonomous | `skills/pm-roadmap/SKILL.md` | `skills/pm-roadmap/SKILL.md` |
| 8 | `project-manager/skills/decompose.md` | Autonomous | `skills/pm-decompose/SKILL.md` | `skills/pm-decompose/SKILL.md` |
| 9 | `project-manager/skills/update_plan.md` | Autonomous | `skills/pm-update-plan/SKILL.md` | `skills/pm-update-plan/SKILL.md` |
| 10 | `project-manager/skills/postmortem.md` | Autonomous | `skills/pm-postmortem/SKILL.md` | `skills/pm-postmortem/SKILL.md` |
| 11 | `swe/role.md` | Role | `rules/swe-os.mdc` | `roles/swe.md` |
| 12 | `swe/skills/start.md` | Start | `commands/swe-start.md` | `commands/swe-start.md` |
| 13 | `swe/skills/handoff.md` | Handoff | `skills/swe-handoff/SKILL.md` | `skills/swe-handoff/SKILL.md` |
| 14 | `qa/role.md` | Role | `rules/qa-os.mdc` | `roles/qa.md` |
| 15 | `qa/skills/start.md` | Start | `commands/qa-start.md` | `commands/qa-start.md` |
| 16 | `qa/skills/handoff.md` | Handoff | `skills/qa-handoff/SKILL.md` | `skills/qa-handoff/SKILL.md` |
| 17 | `qa/skills/review.md` | Autonomous | `skills/qa-review/SKILL.md` | `skills/qa-review/SKILL.md` |
| 18 | `qa/skills/test-plan.md` | Autonomous | `skills/qa-test-plan/SKILL.md` | `skills/qa-test-plan/SKILL.md` |
| 19 | `qa/skills/regression.md` | Autonomous | `skills/qa-regression/SKILL.md` | `skills/qa-regression/SKILL.md` |
| 20 | `qa/skills/bug-triage.md` | Autonomous | `skills/qa-bug-triage/SKILL.md` | `skills/qa-bug-triage/SKILL.md` |
| 21 | `devops/role.md` | Role | `rules/devops-os.mdc` | `roles/devops.md` |
| 22 | `devops/skills/start.md` | Start | `commands/ops-start.md` | `commands/ops-start.md` |
| 23 | `devops/skills/handoff.md` | Handoff | `skills/ops-handoff/SKILL.md` | `skills/ops-handoff/SKILL.md` |
| 24 | `devops/skills/deploy.md` | Interactive | `commands/ops-deploy.md` | `commands/ops-deploy.md` |
| 25 | `devops/skills/env-discovery.md` | Interactive | `commands/ops-env-discovery.md` | `commands/ops-env-discovery.md` |
| 26 | `devops/skills/pipeline.md` | Autonomous | `skills/ops-pipeline/SKILL.md` | `skills/ops-pipeline/SKILL.md` |
| 27 | `devops/skills/release-plan.md` | Autonomous | `skills/ops-release-plan/SKILL.md` | `skills/ops-release-plan/SKILL.md` |
| 28 | `system-architect/role.md` | Role | `rules/system-architect-os.mdc` | `roles/system-architect.md` |
| 29 | `system-architect/skills/start.md` | Start | `commands/sa-start.md` | `commands/sa-start.md` |
| 30 | `system-architect/skills/handoff.md` | Handoff | `skills/sa-handoff/SKILL.md` | `skills/sa-handoff/SKILL.md` |
| 31 | `system-architect/skills/design.md` | Autonomous | `skills/sa-design/SKILL.md` | `skills/sa-design/SKILL.md` |
| 32 | `system-architect/skills/research.md` | Autonomous | `skills/sa-research/SKILL.md` | `skills/sa-research/SKILL.md` |
| 33 | `system-architect/skills/review.md` | Autonomous | `skills/sa-review/SKILL.md` | `skills/sa-review/SKILL.md` |
| 34 | `system-architect/skills/update.md` | Autonomous | `skills/sa-update/SKILL.md` | `skills/sa-update/SKILL.md` |
| 35 | `shared/docs-protocol.md` | Absorbed | — | — |
| 36 | `shared/skills/status.md` | Autonomous | `skills/team-status/SKILL.md` | `skills/team-status/SKILL.md` |
| 37–45 | `data-analyst/*.md` (9 files) | Out of scope | — | — |

**Totals:** 5 roles + 9 commands + 21 skills + 1 absorbed = 36 in-scope files.

### Cursor Implementation

#### Installed Directory Structure

```
.cursor/
  rules/
    project-os.mdc              # Always-applied — expert routing + shared principles
    project-manager-os.mdc      # Agent-decided — PM role
    swe-os.mdc                  # Agent-decided — SWE role
    qa-os.mdc                   # Agent-decided — QA role
    devops-os.mdc               # Agent-decided — DevOps role
    system-architect-os.mdc     # Agent-decided — SA role
  commands/
    pm-start.md
    pm-interview.md
    pm-add-feature.md
    swe-start.md
    qa-start.md
    ops-start.md
    ops-deploy.md
    ops-env-discovery.md
    sa-start.md
  skills/
    pm-vision/SKILL.md
    pm-roadmap/SKILL.md
    pm-decompose/SKILL.md
    pm-update-plan/SKILL.md
    pm-postmortem/SKILL.md
    pm-handoff/SKILL.md
    swe-handoff/SKILL.md
    qa-review/SKILL.md
    qa-test-plan/SKILL.md
    qa-regression/SKILL.md
    qa-bug-triage/SKILL.md
    qa-handoff/SKILL.md
    ops-pipeline/SKILL.md
    ops-release-plan/SKILL.md
    ops-handoff/SKILL.md
    sa-design/SKILL.md
    sa-research/SKILL.md
    sa-review/SKILL.md
    sa-update/SKILL.md
    sa-handoff/SKILL.md
    team-status/SKILL.md
  scripts/
    next-issue-number.sh
    move-issue.sh
    update-issues-list.sh
    next-session-number.sh
```

#### Toolkit Repo Structure

```
targets/ide/cursor/
  README.md                     # Platform documentation
  rules/                        # → installed to .cursor/rules/
  commands/                     # → installed to .cursor/commands/
  skills/                       # → installed to .cursor/skills/
  scripts/                      # → installed to .cursor/scripts/
```

#### Rule Configuration

**`project-os.mdc` (Always Applied)**

Frontmatter: `alwaysApply: true`

Content (~40 lines, simplified from current ~70):
- Expert list with `.cursor/rules/<expert>-os.mdc` paths
- Routing logic: infer expert from skill/command prefix (pm, swe, qa, ops, sa, team)
- Instruction: "Always load the expert role file before executing any skill or command"
- Shared principles (no memory, project brief is truth, verify work, issues in `issues/`)
- Script reference: `.cursor/scripts/` for mechanical operations
- Handoff instruction: "When the user signals they're wrapping up, invoke the handoff skill"
- **No longer lists all skills** — each expert role lists its own, and skills are discoverable

**Expert role rules (Agent-Decided)**

Frontmatter: `alwaysApply: false`, `description: "<Expert> role — <one-line summary>"`

Content (updated per M10 recommendations):
- Identity and purpose
- Document Locations (what this expert produces / consumes)
- Simplified session protocol — no specific file-loading steps; defers to `/start` command and individual skills
- Available skills list (skill names + one-line descriptions)
- Expert-specific principles

#### Skill Configuration

Each skill is a folder in `.cursor/skills/` containing a `SKILL.md` with YAML frontmatter:

```yaml
---
name: <prefix>-<skill-name>
description: <What this skill does. When to use it. Max 1024 chars.>
---
```

Body: the skill instructions adapted from the canonical file. Internal command references use platform prefixes (e.g., `/pm-interview` not `/interview`). Skills that need context include their own loading phase.

**Cursor skill discovery flow:**
1. Cursor scans `.cursor/skills/` at startup, reads SKILL.md frontmatter
2. Skills appear in the "Agent Decides" category
3. When user sends a message, agent evaluates skill descriptions against user intent
4. Matching skills are loaded into context and followed
5. Explicit `/skill-name` invocation always works as fallback

#### Command Configuration

Commands in `.cursor/commands/` are plain markdown files. They use `$ARGUMENTS` for user input. Unchanged from current format.

#### Handoff Auto-Trigger

Primary: `project-os.mdc` includes "When the user signals they're wrapping up, invoke the appropriate handoff skill."

Secondary: Handoff SKILL.md descriptions include trigger phrases (e.g., "End the current SWE session and produce a handoff note. Use when the user signals they're done, wrapping up, or ending the session.").

Fallback: User invokes `/prefix-handoff` explicitly.

Estimated auto-trigger reliability: ~70-80%.

#### Context Auto-Loading

- The `/start` command handles full context loading (Phase 1) — reads project brief, task issue, handoff notes, etc. This is unchanged.
- For skills invoked directly (without `/start`): `project-os.mdc` (always loaded) instructs agent to load the expert role first. Individual skills include their own context loading where needed.
- No Cursor hook equivalent exists for session-level auto-loading.

### Claude Code Implementation

#### Installed Directory Structure

```
.claude/
  CLAUDE.md                     # Shared principles + expert routing (always loaded)
  settings.json                 # Hook definitions
  roles/
    project-manager.md
    swe.md
    qa.md
    devops.md
    system-architect.md
  commands/                     # Same 9 commands as Cursor
    pm-start.md
    pm-interview.md
    pm-add-feature.md
    swe-start.md
    qa-start.md
    ops-start.md
    ops-deploy.md
    ops-env-discovery.md
    sa-start.md
  skills/                       # Same 21 skills as Cursor
    pm-vision/SKILL.md
    pm-roadmap/SKILL.md
    pm-decompose/SKILL.md
    pm-update-plan/SKILL.md
    pm-postmortem/SKILL.md
    pm-handoff/SKILL.md
    swe-handoff/SKILL.md
    qa-review/SKILL.md
    qa-test-plan/SKILL.md
    qa-regression/SKILL.md
    qa-bug-triage/SKILL.md
    qa-handoff/SKILL.md
    ops-pipeline/SKILL.md
    ops-release-plan/SKILL.md
    ops-handoff/SKILL.md
    sa-design/SKILL.md
    sa-research/SKILL.md
    sa-review/SKILL.md
    sa-update/SKILL.md
    sa-handoff/SKILL.md
    team-status/SKILL.md
  scripts/                      # Same scripts as Cursor
    next-issue-number.sh
    move-issue.sh
    update-issues-list.sh
    next-session-number.sh
```

#### Toolkit Repo Structure

```
targets/ide/claude-code/
  README.md                     # Platform documentation
  CLAUDE.md                     # → installed to .claude/CLAUDE.md
  settings.json                 # → merged into .claude/settings.json
  roles/                        # → installed to .claude/roles/
  commands/                     # → installed to .claude/commands/
  skills/                       # → installed to .claude/skills/
  scripts/                      # → installed to .claude/scripts/
```

#### CLAUDE.md Configuration

Equivalent to Cursor's `project-os.mdc`. Contains:
- Expert list with `.claude/roles/<expert>.md` paths
- Instruction to select expert role at session start or infer from prefix
- Shared principles
- Script reference: `.claude/scripts/`
- Handoff instruction (same as Cursor)

#### Role Configuration

Roles in `.claude/roles/` are plain markdown files. Claude Code's role selection UI lets users pick which role to activate at session start. Content structure matches Cursor expert rules (identity, document locations, simplified session protocol, skills list, principles).

#### Skill and Command Configuration

Identical to Cursor. Skills use SKILL.md with frontmatter. Commands use plain markdown with `$ARGUMENTS`. Cross-platform consistency.

#### Hook Configuration

`settings.json` defines hooks for Claude Code's event system:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/session-context.sh"
          }
        ]
      }
    ]
  }
}
```

**`SessionStart` hook:** Runs `session-context.sh` which outputs brief project context (project name, current status from brief, most recent handoff summary) to prime the session. This is Claude Code's bonus over Cursor — automatic context injection at session start.

**Handoff auto-trigger:** Same soft mechanism as Cursor (role instruction + discoverable skill). Claude Code's `Stop` event could add a safety-net prompt hook in the future, but is not implemented in M11 to keep both platforms consistent.

### Shared Specifications

#### Skill Content Adaptation Rules

When SWE converts canonical skill files to platform-native SKILL.md:

1. Add YAML frontmatter with `name` (matching folder name) and `description` (discovery trigger, max 1024 chars)
2. Update internal command references to use platform prefixes (e.g., `/interview` → `/pm-interview`)
3. Skills that relied on session protocol for context loading must include their own loading phase
4. Reference `.cursor/scripts/` or `.claude/scripts/` for mechanical operations instead of inline logic
5. Remove "Using these commands by platform" sections from role files (no longer needed)

#### Script Specifications

| Script | Arguments | Output | Used By |
|--------|-----------|--------|---------|
| `next-issue-number.sh` | — | Next available issue number (integer) | QA review, any skill creating issues |
| `move-issue.sh` | `<filename> <target-dir>` | Confirmation message | Handoff, start (moving to in-progress) |
| `update-issues-list.sh` | — | Regenerated `issues/issues-list.md` | After any issue creation or movement |
| `next-session-number.sh` | `<expert-name>` | Next session number for that expert (integer) | Handoff skills |

Each `.sh` script has a companion `.ps1` for Windows.

#### Install Script Changes

The install script (`targets/ide/install.sh`) simplifies from a translation pipeline to a copy operation:

- **Current flow:** Read `experts/technical/` → parse → generate platform files → write to `.cursor/` or `.claude/`
- **New flow:** Copy `targets/ide/<platform>/` → `.cursor/` or `.claude/`

Specific steps:
1. Detect target platform (cursor / claude-code) from CLI argument or auto-detection
2. Copy rules/roles, commands, skills, scripts directories
3. For Claude Code: merge `settings.json` hooks into existing `.claude/settings.json` (don't overwrite user settings)
4. Create `docs/` and `issues/` directories if they don't exist (unchanged)

#### M10 Recommendations Implementation

| Rec | Change | Implementation |
|-----|--------|----------------|
| 1 | Conditional expert roles | Cursor: expert `.mdc` rules set to `alwaysApply: false` with `description`. Claude Code: roles in `.claude/roles/`, `CLAUDE.md` has routing. Saves ~280 lines of always-loaded context. |
| 2 | Remove doc loading from session protocols | Role files simplified: session protocol says "use `/start` for context loading; for direct skill invocation, load relevant artifacts as needed." Individual skills include their own loading phases. |
| 3 | Scope handoff note loading | Role files changed: "read most recent handoff in own subdirectory" only. Cross-expert handoffs loaded by specific skills that need them (`/pm-postmortem`, `/qa-regression`). |
| 4 | Fix QA handoff gap | QA role file updated to include own handoff notes. Aligned between role file and `/qa-start` command. |
