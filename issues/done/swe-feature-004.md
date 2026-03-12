# Update SWE /start, Docs-Protocol, and Role Files for architecture.md

**Type:** feature
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5)
**Status:** backlog

## User Story

As a toolkit user, I want all experts to consume `docs/architecture.md` and escalate out-of-scope architectural decisions so that system-level direction is followed consistently and assumptions don't cause rework.

## Description

This is the integration task that ties the restructure together. Update SWE `/start` to consume `architecture.md` as context and remove system-level architecture from its scope (keep domain-level). Update docs-protocol to include `architecture.md` as an artifact owned by System Architect and consumed by all experts. Update all expert role files to: (1) reference `architecture.md` in their document locations, (2) include escalation behavior in their principles — explicitly instruct agents to ask PM or System Architect when hitting decisions outside their domain scope.

## Acceptance Criteria

- [ ] SWE `start.md` Phase 1 (Load Context) reads `docs/architecture.md` if it exists
- [ ] SWE `start.md` Phase 3 (Architect) scoped to domain-level architecture; explicitly states system-level decisions are out of scope
- [ ] SWE `start.md` includes explicit instruction: if an architectural decision is needed that isn't covered by `architecture.md`, flag it and ask the user rather than assuming
- [ ] `experts/technical/shared/docs-protocol.md` updated: `architecture.md` in Document Locations table, System Architect added to Workflow Contracts table (producer of `architecture.md`, handoff notes; consumer of project brief, roadmap)
- [ ] `docs-protocol.md` handoff note conventions updated to include `system-architect/` subdirectory
- [ ] PM `role.md` updated: consumes `architecture.md`, consumes System Architect handoff notes
- [ ] SWE `role.md` updated: consumes `architecture.md`; principles include escalation behavior
- [ ] QA `role.md` updated: consumes `architecture.md`
- [ ] DevOps `role.md` updated: consumes `architecture.md`
- [ ] System Architect `role.md` (created in swe-feature-001) cross-checked for consistency with docs-protocol changes
- [ ] Backward compatible: if `architecture.md` doesn't exist, experts proceed without it (graceful degradation)

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** swe-feature-001 (System Architect must exist), swe-feature-002 (PM start), swe-feature-003 (QA/DevOps start), swe-feature-006 (install scripts)
**Inputs:** project brief, `docs/interview-notes-expert-skill-restructure.md`, all expert role.md files, `experts/technical/shared/docs-protocol.md`, SWE `start.md`
**Out of scope:** Modifying existing domain-specific skills (QA review, DevOps pipeline, etc.). Only role files, docs-protocol, and SWE start are updated.
