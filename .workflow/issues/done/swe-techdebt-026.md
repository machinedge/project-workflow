# SWE Escalation Routing Language Differs from QA and DevOps

**Type:** techdebt
**Expert:** swe
**Milestone:** M5
**Status:** backlog
**Severity:** nit
**Found by:** qa-feature-005

## Description

SWE `role.md` escalation principle says "flag it and ask the user" while QA and DevOps say "flag it for the System Architect or PM." The intent is identical (don't make system-level decisions unilaterally), but the routing target differs.

In standalone mode, "ask the user" is functionally correct since the user is the routing layer. In team mode, "flag it for the System Architect or PM" is more specific. For consistency across expert role files, the language should match.

## Acceptance Criteria

- [ ] SWE `role.md` escalation principle uses the same routing language as QA and DevOps (e.g., "flag it for the System Architect or PM rather than deciding yourself")
- [ ] SWE `start.md` Phase 3 escalation instruction updated to match

## Affected Files

- `experts/technical/swe/role.md`
- `experts/technical/swe/skills/start.md`
