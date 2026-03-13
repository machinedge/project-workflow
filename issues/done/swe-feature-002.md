# Add /start and /handoff Skills to PM

**Type:** feature
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4)
**Status:** backlog

## User Story

As a toolkit user, I want the PM expert to have a `/start` command so that when `/decompose` creates PM-scoped issues (like synthesizing research or making a planning decision), I have a structured way to execute them.

## Description

Create `/start` and `/handoff` skills for the PM expert, and update the PM role.md to list them. PM's `/start` should load context (project brief, roadmap, issue backlog, handoff notes), confirm understanding, then execute the PM-scoped task. PM's `/handoff` should produce a handoff note to `docs/handoff-notes/pm/session-NN.md` and update the project brief if needed.

## Acceptance Criteria

- [ ] Skill file exists at `experts/technical/project-manager/skills/start.md`
- [ ] Skill file exists at `experts/technical/project-manager/skills/handoff.md`
- [ ] PM `/start` loads: project brief, roadmap, issues-list, assigned issue, most recent PM handoff note
- [ ] PM `/start` confirms understanding with the user before executing
- [ ] PM `/start` executes PM-appropriate work (synthesizing, deciding, producing planning artifacts) — not code
- [ ] PM `/handoff` produces handoff note and updates project brief with any new decisions
- [ ] PM `role.md` updated to list `/start` and `/handoff` in the Skills section
- [ ] Existing PM skills (interview, add_feature, vision, roadmap, decompose, postmortem, update_plan) are unchanged

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** None (can be done in parallel with swe-feature-001)
**Inputs:** project brief, PM `role.md`, SWE `start.md` (for structural reference, not content — PM start is different from SWE start)
**Out of scope:** Modifying existing PM skills. Do not add architecture.md consumption yet (that's swe-feature-004).

## Session 01 Summary

**What was done:** Created `start.md` and `handoff.md` skill files for PM expert; updated PM `role.md` to list both new skills.
**Handoff note:** `docs/handoff-notes/swe/session-01.md`
**All acceptance criteria met:** Yes
