# TECHDEBT: CONTRIBUTING.md references a non-existent /swe-start command

**Type:** techdebt
**Expert:** doc
**Status:** backlog
**Severity:** should-fix

## Description

`CONTRIBUTING.md` uses `/swe-start` as an example, but no such command ships. Sessions start via the role-agnostic `/start-task`. Update the example.

## Acceptance Criteria

- [ ] `CONTRIBUTING.md` no longer references `/swe-start`
- [ ] The example uses `/start-task` (which infers the expert from the issue)

## Notes

**Found by:** Documentation review.
**Files:** `CONTRIBUTING.md`
