# Project Brief — MachinEdge Expert Teams

## What This Is

A toolkit that defines AI expert roles for coordinated software development. Each expert (PM, SWE, QA, DevOps, System Architect) has a role definition, structured skills, and scripts. A single harness-neutral source (`agents/`) installs as a root `AGENTS.md` plus a `.agents/` payload, working with Claude Code, Codex, and any harness that reads `AGENTS.md`.

## Who It's For

Developers using AI coding assistants who want structured, repeatable workflows across planning, implementation, review, and deployment — rather than ad-hoc prompting.

## How It Works

- Expert definitions install into a project as `AGENTS.md` + a `.agents/` payload of roles, skills, and scripts. The AI loads the right expert context automatically; autonomous skills are discoverable without commands. Human-interactive workflows (interviews, deployment) remain explicit commands. Claude Code additionally gets native slash-command/skill discovery and a SessionStart hook via `.claude/` symlinks.
- **Documents are memory.** Experts have no memory between sessions. All state lives in `docs/` and `.workflow/`.

## Success Looks Like

- [x] Core experts (PM, SWE, QA, DevOps, System Architect) have complete, tested skill sets
- [x] Users can install into a project and immediately start a productive session
- [x] [AGENTS.md Model] Single `agents/` source installs as root `AGENTS.md` + `.agents/` + `CLAUDE.md` and `.claude/` symlinks; `targets/` and Cursor removed (ADR-012)
- [x] [Repo Alignment] Remove legacy directories (`experts/`, `tools/`, `targets/desktop-cli/`, `targets/autonomous/`)
- [x] [Repo Alignment] `CONTRIBUTING.md` reflects current platform-native paradigm
- [x] [Repo Alignment] All docs free of stale references to removed directories
- [x] [Workflow Directory] Managed artifacts (handoff notes, interview notes, lessons-log, research reports, issues) live under `.workflow/`
- [x] [Workflow Directory] `docs/` contains only core planning docs and user-generated content
- [x] [Workflow Directory] Install over existing project migrates artifacts to `.workflow/` without data loss

## Constraints

- `agents/` is the single source of truth; payload paths use `.agents/...` to resolve across harnesses
- Project brief must stay under 1,000 words
- Issues tracked in `.workflow/issues/`, not external services

## Key Decisions Made

| Date | Decision | Rationale |
|------|----------|-----------|
| Pre-existing | Documents are memory, not conversation history | Experts have no cross-session memory; docs are the only continuity mechanism |
| Pre-existing | PM is the orchestrator in team mode | Single point of coordination; human talks to PM, PM delegates |
| Pre-existing | Platform-agnostic canonical definitions | ~~Superseded~~ — retired in favor of platform-native implementations |
| 2026-03-12 | Add System Architect expert | Ad-hoc architecture decisions by SWE caused rework |
| 2026-03-12 | Standardize `/start` and `/handoff` across all experts | Consistent issue pickup and session close |
| 2026-03-12 | SWE `/start` consumes `architecture.md` | Backward compatible; separates system-level from domain-level |
| 2026-03-12 | Target-class directory layout (IDE, Desktop/Code, Autonomous) | Clean extensibility; replaces tangled `framework/` + `package/` |
| 2026-03-12 | Remove `CLAUDE.md` | Redundant with brief + roles + agent-reference |
| 2026-03-12 | Remove refs to non-existent docs | Never authored; redundant with existing docs |
| — | Remove dates from PM; add adaptive interview | Dates meaningless in AI dev; full interviews for trivial changes wasteful |
| — | Extend date removal to all experts | Consistency with PM |
| — | Research context optimization | Excess startup context degrades output quality |
| — | Retire canonical definitions; fork to platform-native | Only Cursor + Claude Code; translation layer adds complexity without value |
| — | Shell scripts (not MCP) for mechanical ops; hidden in config dirs | Lightest dependency; MCP later if needed |
| — | Absorb M10 into platform-native refactor | Conditional rules, scoped loading, QA fix — same restructuring |
| — | Autonomous skills + handoffs as discoverable SKILL.md; only interactive + /start as commands | 21 skills + 9 commands |
| — | Soft handoff auto-trigger on both platforms (rule instruction + skill discovery) | Cursor lacks session-end hook; consistent behavior across platforms preferred |
| — | Direct-copy install replaces translation pipeline | Platform-native files are pre-built; translation adds complexity without value |
| — | Shell scripts in `.cursor/scripts/` and `.claude/scripts/` | Hidden from user, accessible to agent; more descriptive than "tools" |
| — | Session primer is a raw extractor script, not an agent summarizer (ADR-009) | Summarization is agent work, but raw file extraction is mechanical; agent processes raw output naturally |
| — | Team-prefixed skills run roleless (ADR-010) | Cross-expert skills should not adopt a single-expert persona; self-contained SKILL.md + project-os context is sufficient |
| — | Atomic session claiming via `set -C` (noclobber) in `next-session-number.sh` | Prevents concurrent session number collisions |
| — | Lockfile-based atomic project brief updates via `update-brief-status.sh` | Concurrent handoff sessions can't silently overwrite each other's status line; 5s stale lock timeout for crash recovery |
| — | Drop `--experts`/`--domain` CLI flags from install script | Pre-built platform files are a coherent set; partial install would require regenerating routing configs, defeating direct-copy purpose |
| — | Commands keep `/` prefix; skills listed without `/` as bold names | Explicit distinction between 9 user-invoked commands and 21 agent-discoverable skills; "These are not slash commands" explainer in role files |
| — | Remove `experts/`, `tools/`, `targets/desktop-cli/`, `targets/autonomous/` | Legacy directories from pre-platform-native era; platform-native `targets/ide/` is the only deliverable |
| — | Split docs into user-facing (`docs/`) and managed (`.workflow/`) | Handoff notes, issues, and session artifacts are agent memory — noisy for humans; `.workflow/` boundary defines future persistence surface |
| — | `.workflow/` not auto-added to `.gitignore` | User's choice whether to commit agent memory; teams may want shared history |
| — | Flat `.workflow/` layout (no sub-categories beyond expert dirs) — ADR-011 | Artifacts already have clear names; a prefix change is simpler than a reorganization |
| — | Install migrates files but does not rewrite path references inside migrated documents | Historical handoff notes and interview notes are records of what was true when written; rewriting would be revisionist and error-prone |
| 2026-06-16 | Generic AGENTS.md model; drop Cursor and `targets/` (ADR-012) | One harness-neutral `agents/` source ends dual-platform maintenance; `AGENTS.md` covers Claude + Codex, with Claude native discovery preserved via symlinks |

## Current Status

- **Milestones:** M1-M14 complete. M15 (AGENTS.md install model, ADR-012) delivered.
- **Core experts:** PM (10 skills), SWE (2 skills), QA (6 skills), DevOps (6 skills), System Architect (6 skills), team-status (1 shared) — one harness-neutral implementation
- **Blockers:** None
- **Next task:** None queued. Candidates: new experts (Data Analyst, UX) or new harness wiring — would start with a fresh `/pm-interview`.
- **Last updated:** M15 migrated the toolkit to the generic AGENTS.md + `.agents/` model; `targets/` and Cursor removed.

## Notes for AI

- The single source of truth is `agents/`; the installer copies it into projects
- Read `docs/agent-reference.md` before modifying expert definitions
- The System Architect owns `docs/architecture.md`; all other experts consume it
