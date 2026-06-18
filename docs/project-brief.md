# Project Brief — MachinEdge Expert Teams

## What This Is

A toolkit that defines AI expert roles for coordinated software development. Each expert (PM, SWE, QA, DevOps, System Architect, Security Engineer, UX Designer, Technical Writer) has a role definition, structured skills, and scripts. A single harness-neutral source (`agents/`) installs as a root `AGENTS.md` plus a `.agents/` payload, working with Claude Code, Codex, and any harness that reads `AGENTS.md`. Cross-expert **workflows** chain the skills into a full milestone lifecycle.

## Who It's For

Developers using AI coding assistants who want structured, repeatable workflows across planning, implementation, review, and deployment — rather than ad-hoc prompting.

## How It Works

- Expert definitions install into a project as `AGENTS.md` + a `.agents/` payload of roles, skills, and scripts. The AI loads the right expert context automatically; autonomous skills are discoverable without commands. Human-interactive workflows (interviews, deployment) remain explicit commands. Claude Code additionally gets native slash-command/skill discovery and a SessionStart hook via `.claude/` symlinks.
- **Documents are memory.** Experts have no memory between sessions. All state lives in `docs/` and `.sdlc/`.

## Success Looks Like

- [x] Core experts (PM, SWE, QA, DevOps, System Architect) have complete, tested skill sets
- [x] Users can install into a project and immediately start a productive session
- [x] [AGENTS.md Model] Single `agents/` source installs as root `AGENTS.md` + `.agents/` + `CLAUDE.md` and `.claude/` symlinks; `targets/` and Cursor removed (ADR-012)
- [x] [Repo Alignment] Remove legacy directories (`experts/`, `tools/`, `targets/desktop-cli/`, `targets/autonomous/`)
- [x] [Repo Alignment] `CONTRIBUTING.md` reflects current platform-native paradigm
- [x] [Repo Alignment] All docs free of stale references to removed directories
- [x] [Workflow Directory] Managed artifacts (handoff notes, interview notes, lessons-log, research reports, issues) live under `.sdlc/`
- [x] [Workflow Directory] `docs/` contains only core planning docs and user-generated content
- [x] [Workflow Directory] Install over existing project migrates artifacts to `.sdlc/` without data loss
- [x] [Milestone Workflows] `team-milestone` runs a milestone end-to-end (enrich → compile → implement → review) with human gates; Claude Code accelerator parallelizes it (ADR-013)
- [x] [Milestone Workflows] Security Engineer (`sec`) role owns security requirements (kickoff) and the security review gate (close-out)
- [x] [Milestone Workflows] `pm-decompose` emits implementation-ready tasks meeting `docs/task-detail-standard.md`, enforced by a completeness verifier
- [x] [UX Advisor] UX Designer (`ux`) role owns UX guidelines (kickoff) and the UX review gate (close-out), wired as a standing lens into the milestone enrich and review fan-outs
- [x] [Technical Writer] Technical Writer (`doc`) role owns the documentation plan (kickoff), writes accessible user/deployment/maintenance guides in `docs/guides/` as task execution, and gates the docs review (close-out); wired as a standing lens into the milestone enrich and review fan-outs

## Constraints

- `agents/` is the single source of truth; payload paths use `.agents/...` to resolve across harnesses
- Project brief must stay under 1,000 words
- Issues tracked in `.sdlc/issues/`, not external services

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
| — | Split docs into user-facing (`docs/`) and managed (`.sdlc/`) | Handoff notes, issues, and session artifacts are agent memory — noisy for humans; `.sdlc/` boundary defines future persistence surface |
| — | `.sdlc/` not auto-added to `.gitignore` | User's choice whether to commit agent memory; teams may want shared history |
| — | Flat `.sdlc/` layout (no sub-categories beyond expert dirs) — ADR-011 | Artifacts already have clear names; a prefix change is simpler than a reorganization |
| — | Install migrates files but does not rewrite path references inside migrated documents | Historical handoff notes and interview notes are records of what was true when written; rewriting would be revisionist and error-prone |
| 2026-06-16 | Generic AGENTS.md model; drop Cursor and `targets/` (ADR-012) | One harness-neutral `agents/` source ends dual-platform maintenance; `AGENTS.md` covers Claude + Codex, with Claude native discovery preserved via symlinks |
| 2026-06-16 | Milestone workflows + Security Engineer role (ADR-013) | Hand off a whole milestone and have every expert lens applied automatically; portable runbook stays harness-neutral, Claude Code accelerator adds parallelism + a small-model build loop; security becomes a first-class gate |
| 2026-06-17 | Add UX Designer advisor role (`ux`) | No expert evaluated usability or accessibility; UX joins as an advisor (like Security) — owns `docs/ux-guidelines.md`, gates close-out review, and runs as a standing lens in the milestone enrich/review fan-outs (graceful no-op when a milestone has no user-facing surface) |
| 2026-06-18 | Add Technical Writer role (`doc`) | No expert owned user-facing documentation; the Technical Writer is a hybrid — it plans docs (enrich lens), writes the guides itself as task execution (unlike the pure advisors), and gates the docs review (close-out). Owns `docs/documentation-plan.md` + `docs/guides/`; writes for readers unfamiliar with how to deploy, maintain, or use the project |

## Current Status

- **Milestones:** M1-M16 complete. M17 (UX Advisor role) and M18 (Technical Writer role) added.
- **Experts:** PM, SWE, QA, DevOps, System Architect, Security Engineer, UX Designer, Technical Writer — one harness-neutral implementation. 8 roles, 6 commands, 32 skills.
- **Blockers:** None
- **Next task:** Verify the milestone lifecycle end-to-end on a real milestone (run `team-milestone` and the `workflows/milestone.js` accelerator against a sample milestone in a consuming project), now including the UX and documentation enrich/review lenses.
- **Last updated:** Added the Technical Writer role (`doc`) with `doc-plan`, `doc-author`, `doc-review`, `doc-handoff`, wired into the milestone enrich/review fan-outs; it plans and writes accessible guides in `docs/guides/` for readers unfamiliar with the project.

## Notes for AI

- The single source of truth is `agents/`; the installer copies it into projects
- Read `docs/agent-reference.md` before modifying expert definitions
- The System Architect owns `docs/architecture.md`; the Security Engineer owns `docs/security-requirements.md`; the UX Designer owns `docs/ux-guidelines.md`; the Technical Writer owns `docs/documentation-plan.md` and `docs/guides/`; all other experts consume them
- `team-milestone` chains the expert skills into a milestone lifecycle; `agents/workflows/milestone.js` is its Claude Code accelerator
