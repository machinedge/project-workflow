# Handoff Note: Remove date references from all remaining expert templates

**Issue:** swe-feature-031 — Remove date references from all remaining expert templates

## What Was Accomplished

Removed all session-tracking date references from SWE, QA, DevOps, and System Architect skill templates (15 files total). Also cleaned up the lessons-log template and its existing rows to remove the `Date` column. Preserved the `Target release date` field in DevOps `release-plan.md` as an operational date.

## Acceptance Criteria Status

- [x] No SWE skill template contains `Session date`, `today's date`, or `"Last updated" date` instructions
- [x] No QA skill template contains `Session date`, `today's date`, `[today]`, or `"Last updated" date` instructions
- [x] No DevOps skill template contains `Session date` or session-tracking dates; operational dates in `release-plan.md` are preserved
- [x] No System Architect skill template contains `Session date`, `today's date`, or date columns in ADR tables
- [x] Lessons-log template header has `Date` column removed
- [x] All removals are consistent with the convention from swe-feature-029 (drop entirely, don't replace)
- [x] "Today's task" phrasing in `/start` skills is left alone (conversational, not a date stamp)

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Cleaned up existing lessons-log rows (removed date prefixes) in addition to the header | Header-only change would create a malformed markdown table with mismatched column counts |
| Preserved `Target release date` in release-plan.md with "if applicable" qualifier | This is an operational date tracking real-world deployments, not AI session progress |
| Removed `[Date]` from release notes version header (`### [Version] — [Date]` → `### [Version]`) | Releases are identified by version, not date |

## Problems Encountered

None.

## Scope Changes

Minor expansion: cleaned up existing lessons-log data rows (not just the template header) to keep the markdown table valid. This was a pragmatic call — leaving 3-column rows under a 2-column header would break the table.

## Files Created or Modified

- `experts/technical/swe/skills/handoff.md` — removed `Session date`, `"Last updated" date`
- `experts/technical/qa/skills/handoff.md` — removed `Session date`, `"Last updated" date`
- `experts/technical/qa/skills/regression.md` — removed `Date: [today]` from report template
- `experts/technical/qa/skills/bug-triage.md` — removed `Date: [today]` from report template
- `experts/technical/qa/skills/test-plan.md` — removed `Created` and `Last updated` date fields
- `experts/technical/devops/skills/handoff.md` — removed `Session date`, `"Last updated" date`
- `experts/technical/devops/skills/env-discovery.md` — removed `Last updated` date
- `experts/technical/devops/skills/pipeline.md` — removed `Last updated` date
- `experts/technical/devops/skills/deploy.md` — removed `Date: [today]` from deployment report
- `experts/technical/devops/skills/release-plan.md` — removed `Last updated` date and version-date; preserved `Target release date`
- `experts/technical/system-architect/skills/handoff.md` — removed `Session date`, `"Last updated" date`
- `experts/technical/system-architect/skills/design.md` — removed `Date` column from ADR table
- `experts/technical/system-architect/skills/update.md` — removed "or date" from revision history instruction
- `docs/lessons-log.md` — removed `Date` column from header and existing rows

## What the Next Session Needs to Know

1. M9 is complete (single task). Ready for postmortem or can just be marked done.
2. The Data Analyst expert (under development) still has date references in 3 skill files (`scope.md`, `synthesize.md`, `brief.md`). Not in scope for M9 since that expert isn't finalized. Should be cleaned up when the Data Analyst is completed.
3. The SWE handoff template itself (this file's format as defined in the Cursor command) still says `**Session date:** [today's date]` — that's in the Cursor command definition, not in the canonical skill file. The canonical `experts/technical/swe/skills/handoff.md` is now clean.

## Open Questions

- [ ] Data Analyst skills still have date references — clean up when that expert is finalized?
- [ ] Cursor command definitions (in `.cursor/rules/`) still reference `Session date` in handoff templates — update those too?
