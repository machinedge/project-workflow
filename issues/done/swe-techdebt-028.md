# agent-reference.md Overstates `/start` Phase Count

**Type:** techdebt
**Expert:** swe
**Milestone:** M5
**Status:** backlog
**Severity:** nit
**Found by:** qa-feature-005

## Description

`docs/agent-reference.md` states: "The `/start` skill is the most structured — it enforces a 7-phase process with approval gates."

Only SWE and SA have 7 phases. PM, QA, and DevOps have 5 phases. The next sentence ("See the SWE `start.md` for the reference implementation") partially qualifies this, but the initial phrasing is misleading — it implies all experts have 7 phases.

## Acceptance Criteria

- [ ] agent-reference.md language updated to accurately reflect the variable phase count (e.g., "a multi-phase process (5-7 phases depending on the expert) with approval gates" or "The SWE `/start` skill is the most structured — it enforces a 7-phase process...")

## Affected Files

- `docs/agent-reference.md`
