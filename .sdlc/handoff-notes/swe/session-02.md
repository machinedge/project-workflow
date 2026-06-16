# Handoff Note: Add /start and /handoff Skills to QA and DevOps

**Session date:** 2026-03-12
**Issue:** swe-feature-003 — Add /start and /handoff Skills to QA and DevOps

## What Was Accomplished

Created `/start` and `/handoff` skill files for both QA and DevOps experts, modeled on SWE's existing skills but adapted for each expert's domain. Updated both `role.md` files to list the new skills. All 10 acceptance criteria met.

## Acceptance Criteria Status
- [x] Skill files exist at `experts/technical/qa/skills/start.md` and `handoff.md`
- [x] Skill files exist at `experts/technical/devops/skills/start.md` and `handoff.md`
- [x] QA `/start` loads: project brief, roadmap, SWE handoff notes, test plan, assigned issue
- [x] DevOps `/start` loads: project brief, env-context, release-plan, SWE handoff notes, assigned issue
- [x] Both `/start` skills confirm understanding before executing
- [x] Both `/handoff` skills produce handoff notes and update project brief if needed
- [x] QA `role.md` updated to list `/start` and `/handoff` in Skills section
- [x] DevOps `role.md` updated to list `/start` and `/handoff` in Skills section
- [x] Existing QA skills (review, test-plan, regression, bug-triage) unchanged
- [x] Existing DevOps skills (env-discovery, pipeline, release-plan, deploy) unchanged

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| QA `/start` has a dedicated "Record Findings" phase | QA's primary output is issues/findings, not code — needs its own phase |
| DevOps `/start` includes pipeline status check in context loading | Matches DevOps session protocol step 4 |
| QA handoff template uses "Findings Summary" section | More useful than SWE's generic "Files Created or Modified" for QA context |
| DevOps handoff template uses "Environment Changes" section | Captures what changed in infra, more useful than generic file list |
| `/start` and `/handoff` listed first in Skills sections | Matches SWE's ordering — execution skills before domain-specific skills |

## Problems Encountered
None. Straightforward task with clear structural references (SWE's existing skills).

## Scope Changes
No scope changes. Task went exactly as planned.

## Files Created or Modified
- `experts/technical/qa/skills/start.md` — QA execution skill (5 phases)
- `experts/technical/qa/skills/handoff.md` — QA session close-out (6 steps)
- `experts/technical/devops/skills/start.md` — DevOps execution skill (5 phases)
- `experts/technical/devops/skills/handoff.md` — DevOps session close-out (6 steps)
- `experts/technical/qa/role.md` — added `/start` and `/handoff` to Skills section
- `experts/technical/devops/role.md` — added `/start` and `/handoff` to Skills section

## What the Next Session Needs to Know
QA now has 6 skills and DevOps now has 6 skills. The `/start` and `/handoff` patterns are consistent across SWE, QA, and DevOps — all three follow the same structural template with domain-appropriate phases and context loading. PM still needs `/start` and `/handoff` (swe-feature-002). swe-feature-004 will update SWE's `/start` to consume `architecture.md`.

## Open Questions
- None
