# PM, QA, DevOps /start skills don't load architecture.md

**Type:** bug
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5)
**Status:** backlog
**Severity:** must-fix
**Found by:** /review of swe-feature-002, swe-feature-003, swe-feature-004

## User Story

As a toolkit user, I want all experts' `/start` commands to load `docs/architecture.md` so that every expert session is informed by the system architecture, not just SWE sessions.

## Description

The role files for PM, QA, and DevOps were updated to list `docs/architecture.md` in "Key artifacts you consume" and in the session protocol. But their `/start` skill files don't include `architecture.md` in Phase 1 context loading. SWE's `/start` was properly updated (item 7), but the other three were not. This means running `/start` for PM, QA, or DevOps will skip loading the architecture document even though the role says it should be consumed.

## Acceptance Criteria

- [ ] PM `/start` Phase 1 includes `docs/architecture.md (if it exists)` in context loading
- [ ] QA `/start` Phase 1 includes `docs/architecture.md (if it exists)` in context loading
- [ ] DevOps `/start` Phase 1 includes `docs/architecture.md (if it exists)` in context loading
- [ ] All three use graceful degradation (proceed without it if it doesn't exist)

## Technical Notes

**Estimated effort:** Small session
**File(s):** `experts/technical/project-manager/skills/start.md`, `experts/technical/qa/skills/start.md`, `experts/technical/devops/skills/start.md`
