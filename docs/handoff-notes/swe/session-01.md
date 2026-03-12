# Handoff Note: Add /start and /handoff Skills to PM

**Session date:** 2026-03-12
**Issue:** swe-feature-002 — Add /start and /handoff Skills to PM

## What Was Accomplished
Created `/start` and `/handoff` skill files for the PM expert and updated PM `role.md` to list them. PM now has a structured workflow for executing PM-scoped issues and closing sessions with handoff notes.

## Acceptance Criteria Status
- [x] Skill file exists at `experts/technical/project-manager/skills/start.md`
- [x] Skill file exists at `experts/technical/project-manager/skills/handoff.md`
- [x] PM `/start` loads: project brief, roadmap, issues-list, assigned issue, most recent PM handoff note
- [x] PM `/start` confirms understanding with the user before executing
- [x] PM `/start` executes PM-appropriate work (synthesizing, deciding, producing planning artifacts) — not code
- [x] PM `/handoff` produces handoff note and updates project brief with any new decisions
- [x] PM `role.md` updated to list `/start` and `/handoff` in the Skills section
- [x] Existing PM skills (interview, add_feature, vision, roadmap, decompose, postmortem, update_plan) are unchanged

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| PM `/start` uses 5 phases (Load Context, Plan, Execute, Verify, Review) instead of SWE's 7 | PM work doesn't have test or architecture phases — those are code concerns |
| PM `/handoff` mirrors SWE handoff structure almost exactly | The handoff workflow is role-agnostic; consistency across experts is more valuable than differentiation |
| `/start` and `/handoff` listed at the top of Skills section in role.md | They're the primary session lifecycle commands; listing them first makes them easy to find |

## Problems Encountered
None. Straightforward task with clear requirements.

## Scope Changes
None. Task completed exactly as specified.

## Files Created or Modified
- `experts/technical/project-manager/skills/start.md` — new PM execution workflow (5 phases)
- `experts/technical/project-manager/skills/handoff.md` — new PM session close workflow (6 steps)
- `experts/technical/project-manager/role.md` — added `/start` and `/handoff` to Skills section

## What the Next Session Needs to Know
- swe-feature-003 (Add `/start` and `/handoff` to QA and DevOps) can use the PM skills created here as structural reference, alongside SWE's existing skills.
- The `update_plan` skill file exists on disk but isn't listed in PM `role.md`. This was pre-existing and out of scope for this task, but worth noting for a future cleanup pass.

## Open Questions
- [ ] Should `update_plan` be added to PM `role.md`'s Skills section? (Pre-existing gap, not introduced by this session.)
