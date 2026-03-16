# Handoff Note: Remove date references from PM skill templates

**Issue:** swe-feature-029 — Remove date references from PM skill templates

## What Was Accomplished

Removed all calendar date references from 5 PM skill templates (vision, roadmap, update_plan, postmortem, handoff). Date columns were dropped entirely from Key Decisions and Change Log tables rather than replaced with an alternative identifier. The `Last updated` field in the vision template was changed to `[current session or milestone]`. Also removed the "Assume timelines take 1.5x longer" rule from roadmap.md since it implies date-based scheduling.

## Acceptance Criteria Status

- [x] `vision.md` template no longer includes `Started: [Date]`, `Target completion: [Date]`, or date-based `Last updated`
- [x] `vision.md` Key Decisions table uses a non-date identifier instead of `| Date |`
- [x] `roadmap.md` milestones table no longer includes `Target Date` column
- [x] `roadmap.md` change log uses a non-date identifier instead of `| Date |`
- [x] `update_plan.md` no longer instructs PM to use "today's date" for Key Decisions or Change Log entries
- [x] `postmortem.md` no longer says "update dates" when updating the roadmap
- [x] `handoff.md` no longer uses `Session date: [today's date]` or "Update the 'Last updated' date"
- [x] All replacements are consistent — dates dropped everywhere, no conflicting conventions

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Drop date columns entirely rather than replacing with session numbers | Entries are sequential — order is sufficient context. Adding session numbers would be another form of noise since they're only meaningful within a single project. |
| Remove "Assume timelines take 1.5x longer" from roadmap.md | Implies date-based scheduling, which contradicts the session-based model |

## Problems Encountered

None.

## Scope Changes

None — task went exactly as planned.

## Files Created or Modified

- `experts/technical/project-manager/skills/vision.md` — removed `Started`, `Target completion`, date column from Key Decisions, changed `Last updated` placeholder
- `experts/technical/project-manager/skills/roadmap.md` — removed `Target Date` column, date column from Change Log, removed timeline rule
- `experts/technical/project-manager/skills/update_plan.md` — removed "today's date" from Key Decisions and Change Log instructions
- `experts/technical/project-manager/skills/postmortem.md` — removed "update dates" from roadmap update step
- `experts/technical/project-manager/skills/handoff.md` — removed `Session date` from template, removed "Update the 'Last updated' date" instruction

## What the Next Session Needs to Know

1. swe-feature-030 (adaptive complexity assessment for `/add-feature`) is the remaining task in M8. It's independent of this task.
2. The existing generated documents (`docs/project-brief.md`, `docs/roadmap.md`) still have dates from before this change — that's intentional (out of scope per the issue).
3. The SWE handoff template (this file's own format) still uses `Session date` — that's in the SWE expert's skills, not PM's. Out of scope for this task, but worth noting if consistency across all experts is desired later.

## Open Questions

- [ ] Should the date-removal treatment be applied to other experts' handoff/skill templates too? (Currently scoped to PM only)
