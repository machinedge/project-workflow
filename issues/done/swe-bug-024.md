# QA `/start` Missing Dedicated Verify Phase for Own Acceptance Criteria

**Type:** bug
**Expert:** swe
**Milestone:** M5
**Status:** backlog
**Severity:** should-fix
**Found by:** qa-feature-005

## Description

Every other expert's `/start` skill has a dedicated "Verify" phase that walks through the task issue's own acceptance criteria before reporting:

- SWE Phase 6: "Walk through each acceptance criterion from the issue file."
- SA Phase 6: "Walk through each acceptance criterion from the task issue."
- PM Phase 4: "Walk through each acceptance criterion from the issue file."
- DevOps Phase 4: "Walk through each acceptance criterion from the issue file."

QA's `/start` (5 phases: Load Context, Plan, Execute, Record Findings, Report) does not have this. Phase 3 "Execute" checks the acceptance criteria *of the work being reviewed*, not the QA issue itself. Phase 5 "Report" mentions "Acceptance criteria status for the reviewed work" — again, the reviewed work's criteria.

A QA agent can complete a session without ever explicitly verifying that it met its own task requirements.

## Acceptance Criteria

- [ ] QA `/start` skill includes a Verify phase (or equivalent step) that explicitly walks through the QA issue's own acceptance criteria before the Report phase
- [ ] The Verify phase follows the same pattern as other experts: check each criterion, go back if any are unmet

## Affected Files

- `experts/technical/qa/skills/start.md`
