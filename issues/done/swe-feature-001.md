# Create System Architect Expert

**Type:** feature
**Expert:** swe
**Milestone:** [Expert Skill Restructure] System Architect expert with full skill set (M3)
**Status:** backlog

## User Story

As a toolkit user, I want a System Architect expert available in my project so that system-level architectural decisions are made deliberately before implementation begins, rather than ad-hoc by the SWE during execution.

## Description

Create the full System Architect expert: directory structure, role.md, and all 6 skills. The System Architect is a project-level role (not task-level) responsible for system-wide architectural coherence. It owns `docs/architecture.md`.

## Acceptance Criteria

- [ ] Directory exists at `experts/technical/system-architect/` with `role.md`, `skills/`, and `tools/` (with `.gitkeep`)
- [ ] `role.md` defines: identity, document locations (produces `docs/architecture.md`, consumes project brief/roadmap/handoff notes), session protocol, skills list, principles
- [ ] Skill: `/design` — creates initial system architecture or major feature architecture; produces `docs/architecture.md`
- [ ] Skill: `/research` — investigates a specific technical question; produces a research summary with recommendation
- [ ] Skill: `/review` — reviews implementation against architectural intent; produces findings
- [ ] Skill: `/update` — evolves the architecture based on new requirements or implementation feedback; updates `docs/architecture.md`
- [ ] Skill: `/start` — picks up an architect-scoped issue from `issues/`, loads context, executes, produces handoff
- [ ] Skill: `/handoff` — closes session, produces handoff note to `docs/handoff-notes/system-architect/session-NN.md`
- [ ] All skill files follow existing skill conventions (see `experts/technical/swe/skills/start.md` for reference)
- [ ] Expert passes `./framework/validate/validate.sh technical/system-architect`

## Session 03 Summary

**What was done:** Created the full System Architect expert — directory structure, role.md, and all 6 skills (/design, /research, /review, /update, /start, /handoff). Passes all 15 validation checks.
**Handoff note:** `docs/handoff-notes/swe/session-03.md`
**All acceptance criteria met:** Yes

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** None
**Inputs:** project brief, `docs/interview-notes-expert-skill-restructure.md`, existing expert role.md files (PM, SWE, QA, DevOps) for style reference
**Out of scope:** Updating other experts' role files (that's swe-feature-004). Do not modify docs-protocol yet.
