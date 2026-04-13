# Handoff Note: M11 Postmortem — Platform-Native Refactor

**Issue:** Postmortem for milestone M11 [Platform-Native Refactor]

## What Was Accomplished

Ran the M11 postmortem covering the full Platform-Native Refactor milestone. Analyzed all 29 delivered issues (13 planned + 16 follow-on), ~24 sessions across SA/SWE/QA, and 10 architectural decisions. Marked M11 complete. Updated project brief, roadmap, and lessons log.

Also completed two housekeeping tasks:
1. Regenerated `issues/issues-list.md` (was stale — showed 2 issues as "backlog" that were actually in `done/`)
2. Filed `swe-bug-062` for Cursor README `alwaysApply` inaccuracy (observed in qa-session-06 but never formally filed)

## Postmortem Summary

### Delivery
- **Planned:** 13 issues, estimated 5-8 sessions
- **Delivered:** 29 issues (2.2x), ~24 sessions (3-4x estimate)
- **Pattern confirmed:** M3-M7 was 2.5x, M11 was 2.2x. The QA rework multiplier is a reliable constant.

### Quality
- 4 QA sessions filed 9 issues (1 must-fix, 6 should-fix, 2 nits) — all resolved
- Must-fix was a one-line install script error (PM directory name)
- All findings were consistency/completeness issues, not architectural bugs
- PowerShell remains untested on Windows (persistent gap across all milestones)

### Architecture
- 6 ADRs produced (005-010) plus 4 operational decisions
- 5 SA sessions prevented rework by catching design issues before they multiplied across implementations
- No architectural decisions needed to be reversed

### Lessons Added
1. The 2-3x QA rework multiplier is a reliable planning constant — budget for it
2. An architecture design phase before SWE implementation prevents rework at scale
3. Sweeping ad-hoc changes need formal issues for QA to review against

## Artifacts Updated

- `docs/project-brief.md` — M11 success criteria checked off, 3 missing decisions added, status updated to "M1-M11 complete"
- `docs/roadmap.md` — M11 marked Done with actual session count, postmortem entry in change log
- `docs/lessons-log.md` — 3 lessons added
- `issues/backlog/swe-bug-062.md` — Cursor README alwaysApply inaccuracy
- `issues/issues-list.md` — regenerated (all issues now show correct status)

## What's Next

No next milestone is planned. Remaining open items:
1. `swe-bug-062` — Cursor README nit (trivial fix)
2. Data Analyst and User Experience experts — under development, no milestone
3. Claude Code `Stop` hook as handoff safety net — deferred enhancement from ADR-006
4. PowerShell testing on Windows — persistent gap, no mitigation planned

## Open Questions

- Should Data Analyst and UX completion be planned as M12, or are they indefinitely deferred?
