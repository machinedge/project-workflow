# Add escalation behavior to QA and DevOps role files

**Type:** techdebt
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5)
**Status:** backlog
**Severity:** should-fix
**Found by:** /review of swe-feature-004

## User Story

As a toolkit user, I want QA and DevOps experts to explicitly know when to escalate decisions to PM or System Architect so that they don't make out-of-scope decisions that conflict with the architecture.

## Description

The project brief success criterion says "All experts escalate out-of-scope decisions to PM or System Architect." SWE's role.md has an explicit escalation principle, but QA and DevOps role files do not. Without this, a DevOps expert might make infrastructure decisions that conflict with the architecture, or a QA expert might misinterpret architectural boundaries during review.

## Acceptance Criteria

- [ ] QA `role.md` Principles section includes an escalation instruction appropriate to QA's domain
- [ ] DevOps `role.md` Principles section includes an escalation instruction appropriate to DevOps's domain
- [ ] Escalation language is consistent with SWE's existing principle but adapted for each expert's scope

## Technical Notes

**Estimated effort:** Small session
**File(s):** `experts/technical/qa/role.md`, `experts/technical/devops/role.md`
