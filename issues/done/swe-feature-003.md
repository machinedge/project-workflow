# Add /start and /handoff Skills to QA and DevOps

**Type:** feature
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4)
**Status:** done

## User Story

As a toolkit user, I want QA and DevOps experts to have `/start` commands so that when tasks are created for them via `/decompose` or by other experts, they have a structured way to pick up and execute those tasks.

## Description

Create `/start` and `/handoff` skills for both QA and DevOps experts, and update their role.md files. Each expert's `/start` should follow the same structural pattern (load context, read issue, confirm understanding, execute, verify) but with domain-appropriate behavior. QA executes QA work (reviews, test plans); DevOps executes DevOps work (pipelines, deployments, environment setup).

## Acceptance Criteria

- [ ] Skill files exist at `experts/technical/qa/skills/start.md` and `experts/technical/qa/skills/handoff.md`
- [ ] Skill files exist at `experts/technical/devops/skills/start.md` and `experts/technical/devops/skills/handoff.md`
- [ ] QA `/start` loads: project brief, roadmap, SWE handoff notes, test plan, assigned issue
- [ ] DevOps `/start` loads: project brief, env-context, release-plan, SWE handoff notes, assigned issue
- [ ] Both `/start` skills confirm understanding before executing
- [ ] Both `/handoff` skills produce handoff notes and update project brief if needed
- [ ] QA `role.md` updated to list `/start` and `/handoff` in Skills section
- [ ] DevOps `role.md` updated to list `/start` and `/handoff` in Skills section
- [ ] Existing QA skills (review, test-plan, regression, bug-triage) are unchanged
- [ ] Existing DevOps skills (env-discovery, pipeline, release-plan, deploy) are unchanged

## Technical Notes

**Estimated effort:** Small-Medium session
**Dependencies:** None (can be done in parallel with swe-feature-001 and swe-feature-002)
**Inputs:** project brief, QA `role.md`, DevOps `role.md`, SWE `start.md` and PM `start.md` (for structural reference)
**Out of scope:** Modifying existing QA or DevOps skills. Do not add architecture.md consumption yet (that's swe-feature-004).

## Session 02 Summary

**What was done:** Created `/start` and `/handoff` skill files for QA and DevOps experts, adapted from SWE's existing skills with domain-appropriate phases and context loading. Updated both `role.md` files.
**Handoff note:** `docs/handoff-notes/swe/session-02.md`
**All acceptance criteria met:** Yes
