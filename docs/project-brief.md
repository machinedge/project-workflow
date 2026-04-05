# Project Brief — MachinEdge Expert Teams

## What This Is

A toolkit that defines AI expert roles for coordinated software development. Each expert (PM, SWE, QA, DevOps, etc.) has a role definition, structured skills, and tools. Platform-native implementations for Cursor and Claude Code leverage each platform's rules, skills, hooks, and tool capabilities directly.

## Who It's For

Developers using AI coding assistants who want structured, repeatable workflows across planning, implementation, review, and deployment — rather than ad-hoc prompting.

## How It Works

- **Standalone mode:** Expert definitions install into a project as platform-native rules, skills, and tools. The AI loads the right expert context automatically; autonomous skills are discoverable without commands. Human-interactive workflows (interviews, deployment) remain explicit commands.
- **Team mode (OpenClaw):** PM orchestrates a multi-agent team over Matrix. The human talks to PM; PM delegates to other experts.
- **Documents are memory.** Experts have no memory between sessions. All state lives in `docs/` and `issues/`.

## Success Looks Like

- [ ] Core experts (PM, SWE, QA, DevOps) have complete, tested skill sets
- [ ] Framework tooling (scaffold, validate, install, package) works reliably
- [ ] Users can install into a project and immediately start a productive session
- [x] [Expert Skill Restructure] System Architect expert exists with design, research, review, update, start, handoff skills
- [x] [Expert Skill Restructure] Every expert has `/start` and `/handoff` for executing issues
- [x] [Expert Skill Restructure] SWE `/start` consumes `architecture.md` and enforces checkpoints
- [x] [Expert Skill Restructure] All experts escalate out-of-scope decisions to PM or System Architect
- [x] [Deployment Restructure] Directory layout organized by target class (IDE, Desktop/Code, Autonomous)
- [x] [Deployment Restructure] Adding a new deployment target is atomic and self-contained
- [x] [Deployment Restructure] OpenClaw code preserved but isolated in its own target directory
- [x] [Deployment Restructure] `CLAUDE.md` removed
- [x] [PM Planning Improvements] PM stops producing calendar dates in generated artifacts
- [x] [PM Planning Improvements] `/add-feature` assesses complexity and shortens interview for small features
- [x] [PM Planning Improvements] PM states assumptions when shortening interview so user can correct
- [x] [Date Removal] No expert skill template produces or consumes calendar dates
- [x] [Context Optimization] Expert x document matrix with essential/nice-to-have/unnecessary ratings
- [x] [Context Optimization] Recommendation with proposed changes and rationale
- [ ] [Platform-Native Refactor] Cursor and Claude Code each have native implementations (not translated from canonical)
- [ ] [Platform-Native Refactor] Autonomous skills discoverable without slash commands
- [ ] [Platform-Native Refactor] Handoffs auto-trigger on session end
- [ ] [Platform-Native Refactor] Mechanical operations handled by hidden shell scripts
- [ ] [Platform-Native Refactor] Sync command keeps platform implementations aligned

## Constraints

- Platform implementations in `targets/ide/cursor/` and `targets/ide/claude-code/` are first-class; `experts/technical/` retained as reference only
- Project brief must stay under 1,000 words
- Issues tracked in `issues/`, not external services
- Every expert needs `role.md`, `skills/`, and `tools/` directories
- Breaking changes to `framework/` and `package/` paths accepted for deployment restructure

## Key Decisions Made

| Date | Decision | Rationale |
|------|----------|-----------|
| Pre-existing | Documents are memory, not conversation history | Experts have no cross-session memory; docs are the only continuity mechanism |
| Pre-existing | PM is the orchestrator in team mode | Single point of coordination; human talks to PM, PM delegates |
| Pre-existing | Platform-agnostic canonical definitions | Avoids lock-in; translation layer handles platform differences |
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
| — | Autonomous skills + handoffs as discoverable SKILL.md; only interactive + /start as commands | Skills support both agent discovery AND explicit /skill-name; 21 skills + 9 commands |
| — | Soft handoff auto-trigger on both platforms (rule instruction + skill discovery) | Cursor lacks session-end hook; consistent behavior across platforms preferred |
| — | Direct-copy install replaces translation pipeline | Platform-native files are pre-built; translation adds complexity without value |
| — | Shell scripts in `.cursor/scripts/` and `.claude/scripts/` | Hidden from user, accessible to agent; more descriptive than "tools" |

## Current Status

- **Milestones:** M1-M10 complete. Platform-Native Refactor (M11) in progress — architecture design complete, 12 tasks in backlog.
- **Core experts:** PM (10 skills), SWE (2 skills), QA (6 skills), DevOps (6 skills), System Architect (6 skills) — functional
- **Under development:** Data Analyst, User Experience
- **Tooling:** scaffold, validate, install, package — functional (in `tools/` and `targets/`)
- **Blockers:** None
- **Next task:** swe-feature-034 (Create Workflow Shell Scripts for Mechanical Operations)
- **Last updated:** M11 backlog reconciled with architecture (post sa-feature-033)

## Notes for AI

- Use full expert directory names (`project-manager`, not `pm`; `data-analyst`, not `eda`)
- Read `experts/technical/shared/docs-protocol.md` for cross-expert document contracts
- Read `docs/agent-reference.md` before modifying tooling or expert definitions
- The System Architect owns `docs/architecture.md`; all other experts consume it
