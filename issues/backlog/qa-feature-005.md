# QA: Review Expert Skill Restructure for Consistency

**Type:** feature
**Expert:** qa
**Milestone:** [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5)
**Status:** backlog

## Description

Review the entire Expert Skill Restructure for internal consistency. Check that all new skills follow established conventions, that cross-references between role files and docs-protocol are correct, that the System Architect's responsibilities don't overlap with other experts, and that backward compatibility is maintained.

## Scope

- All new and modified skill files across all experts
- System Architect role.md and skills
- Updated docs-protocol
- Updated SWE start.md
- Cross-expert escalation behavior consistency

## Acceptance Criteria

- [ ] All new skill files follow the same structural conventions as existing skills
- [ ] Every `/start` skill across all experts follows a consistent pattern (load context, read issue, confirm, execute, verify)
- [ ] Every `/handoff` skill follows a consistent pattern (summarize, update brief, save to correct path)
- [ ] docs-protocol Workflow Contracts table is complete and accurate for System Architect
- [ ] No conflicting responsibilities between System Architect and other experts
- [ ] All role files reference `architecture.md` with graceful degradation (if it doesn't exist, proceed without it)
- [ ] Escalation instructions are consistent across all expert role files
- [ ] Existing skills are not broken by changes

## Notes

**Depends on:** swe-feature-001, swe-feature-002, swe-feature-003, swe-feature-004 (all implementation must be complete)
**Inputs:** all expert role.md files, all new/modified skill files, `experts/technical/shared/docs-protocol.md`, `docs/interview-notes-expert-skill-restructure.md`
