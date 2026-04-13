# DevOps Escalation Example List Uses "service topology" Instead of "technology choices"

**Type:** techdebt
**Expert:** swe
**Milestone:** M5
**Status:** backlog
**Severity:** nit
**Found by:** qa-feature-005

## Description

SWE and QA escalation principles use the parenthetical examples "component boundaries, technology choices, cross-cutting concerns." DevOps uses "component boundaries, service topology, cross-cutting concerns."

"Service topology" is arguably more appropriate for DevOps, but it breaks the parallel structure across experts. The parenthetical list should be consistent, with expert-specific additions if needed rather than substitutions.

## Acceptance Criteria

- [ ] DevOps `role.md` escalation principle parenthetical examples match SWE and QA (e.g., "component boundaries, technology choices, cross-cutting concerns"), optionally adding "service topology" as an additional example rather than replacing "technology choices"

## Affected Files

- `experts/technical/devops/role.md`
