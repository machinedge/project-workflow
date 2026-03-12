# Project Brief — MachinEdge Expert Teams

## What This Is

A platform-agnostic toolkit that defines AI expert roles for coordinated software development. Each expert (PM, SWE, QA, DevOps, etc.) has a role definition, structured skills, and tools. A translation layer converts these canonical definitions to platform-specific configs (Claude Code, Cursor, OpenClaw).

## Who It's For

Developers using AI coding assistants who want structured, repeatable workflows across planning, implementation, review, and deployment — rather than ad-hoc prompting.

## How It Works

- **Standalone mode:** Expert definitions install into a project as role files and skill commands. The user picks an expert and runs skill commands (e.g., `/swe-start`, `/qa-review`).
- **Team mode (OpenClaw):** PM orchestrates a multi-agent team over Matrix. The human talks to PM; PM delegates to other experts.
- **Documents are memory.** Experts have no memory between sessions. All state lives in `docs/` and `issues/`.

## Success Looks Like

- [ ] Core experts (PM, SWE, QA, DevOps) have complete, tested skill sets
- [ ] Framework tooling (scaffold, validate, install, package) works reliably
- [ ] Users can install into a project and immediately start a productive session
- [ ] [Expert Skill Restructure] System Architect expert exists with design, research, review, update, start, handoff skills
- [ ] [Expert Skill Restructure] Every expert has `/start` and `/handoff` for executing issues
- [ ] [Expert Skill Restructure] SWE `/start` consumes `architecture.md` and enforces checkpoints
- [ ] [Expert Skill Restructure] All experts escalate out-of-scope decisions to PM or System Architect

## Constraints

- Expert definitions must be platform-agnostic (no `.claude/` paths, no Cursor frontmatter in canonical files)
- Project brief must stay under 1,000 words
- Issues tracked in `issues/`, not external services
- Every expert needs `role.md`, `skills/`, and `tools/` directories
- Backward compatible with existing projects using the toolkit

## Key Decisions Made

| Date | Decision | Rationale |
|------|----------|-----------|
| Pre-existing | Documents are memory, not conversation history | Experts have no cross-session memory; docs are the only continuity mechanism |
| Pre-existing | PM is the orchestrator in team mode | Single point of coordination; human talks to PM, PM delegates |
| Pre-existing | Platform-agnostic canonical definitions | Avoids lock-in; translation layer handles platform differences |
| 2026-03-12 | Add System Architect expert | System-level architecture decisions were being made ad-hoc by SWE during execution, causing rework on large/ambiguous tasks |
| 2026-03-12 | Standardize `/start` and `/handoff` across all experts | Every expert needs to pick up issues and close sessions consistently |
| 2026-03-12 | SWE `/start` updated (not replaced) to consume `architecture.md` | Backward compatible; removes system-level architecture from SWE scope while preserving the existing flow |

## Current Status

- **Core experts:** PM (9 skills), SWE (2 skills), QA (6 skills), DevOps (6 skills), System Architect (6 skills) — functional
- **Under development:** Data Analyst, User Experience
- **Framework:** scaffold, validate, install, package — functional
- **Last completed:** swe-feature-006 (Update install scripts for System Architect)
- **Next task:** qa-feature-005 (QA review of expert skill restructure)
- **Last updated:** 2026-03-12

## Notes for AI

- Use full expert directory names (`project-manager`, not `pm`; `data-analyst`, not `eda`)
- Read `experts/technical/shared/docs-protocol.md` for cross-expert document contracts
- Read `framework/docs/agent-reference.md` before modifying framework tooling
- The System Architect owns `docs/architecture.md`; all other experts consume it
