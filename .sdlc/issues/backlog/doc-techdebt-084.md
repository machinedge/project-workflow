# TECHDEBT: README overstates command count as 10; actual is 6

**Type:** techdebt
**Expert:** doc
**Status:** backlog
**Severity:** should-fix

## Description

The README states there are 10 commands, but only 6 command files ship in `agents/commands/`: start-task, resume-task, pm-interview, pm-add-feature, ops-deploy, ops-env-discovery. Correct the count.

## Acceptance Criteria

- [ ] `README.md` states the command count as 6 (not 10)
- [ ] The count matches the actual files in `agents/commands/`

## Notes

**Found by:** Documentation review.
**Files:** `README.md`
