# Add "Problems Encountered" section to PM handoff template

**Type:** techdebt
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4)
**Status:** backlog
**Severity:** should-fix
**Found by:** /review of swe-feature-002

## User Story

As a toolkit user, I want PM handoff notes to capture problems encountered during PM sessions so that future sessions can learn from difficulties and patterns are visible across all expert types.

## Description

Every other expert's handoff template (SWE, QA, DevOps, System Architect) includes a "Problems Encountered" section. PM's handoff template omits it. This means difficulties encountered during PM sessions (scoping ambiguity, contradictions in requirements, stakeholder disagreements) won't be captured systematically.

## Acceptance Criteria

- [ ] PM `handoff.md` template includes a "Problems Encountered" section
- [ ] Section placement is consistent with other experts' handoff templates

## Technical Notes

**Estimated effort:** Small session
**File(s):** `experts/technical/project-manager/skills/handoff.md`
