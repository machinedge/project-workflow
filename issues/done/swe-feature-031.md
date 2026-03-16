# Remove date references from all remaining expert templates

**Type:** feature
**Expert:** swe
**Milestone:** [Date Removal] Remove date references from all remaining expert templates
**Status:** backlog

## User Story

As a developer using the expert system, I want all experts to stop generating calendar dates in their output so that the entire system consistently uses session-based tracking instead of meaningless date stamps.

## Description

M8 removed date references from PM skills. This task extends the same treatment to SWE, QA, DevOps, System Architect, and the lessons-log template. Follow the same convention: drop date columns/fields entirely rather than replacing them. Exception: DevOps operational dates that track real-world deployment events (not AI session progress) should be preserved — flag these with a comment if judgment is needed.

## Files to Modify

**SWE:**
- `experts/technical/swe/skills/handoff.md` — remove `Session date: [today's date]` and `Update the "Last updated" date`

**QA:**
- `experts/technical/qa/skills/handoff.md` — remove `Session date: [today's date]` and `Update the "Last updated" date`
- `experts/technical/qa/skills/regression.md` — remove `**Date:** [today]` from report template
- `experts/technical/qa/skills/bug-triage.md` — remove `**Date:** [today]` from report template
- `experts/technical/qa/skills/test-plan.md` — remove `**Created:** [today's date]` and `**Last updated:** [today's date]`

**DevOps:**
- `experts/technical/devops/skills/handoff.md` — remove `Session date: [today's date]` and `Update the "Last updated" date`
- `experts/technical/devops/skills/env-discovery.md` — remove `**Last updated:** [today's date]`
- `experts/technical/devops/skills/pipeline.md` — remove `**Last updated:** [today's date]`
- `experts/technical/devops/skills/deploy.md` — remove `**Date:** [today]` from deployment record template
- `experts/technical/devops/skills/release-plan.md` — remove `**Last updated:** [today's date]`; PRESERVE `**Target release date:**` and `### [Version] — [Date]` (these are operational dates tracking real-world releases, not AI session progress)

**System Architect:**
- `experts/technical/system-architect/skills/handoff.md` — remove `Session date: [today's date]` and `Update the "Last updated" date`
- `experts/technical/system-architect/skills/design.md` — remove `Date` column from ADR table
- `experts/technical/system-architect/skills/update.md` — remove `Update the document's revision history or date`

**Shared:**
- `docs/lessons-log.md` — remove `Date` column from table template (header row only; leave existing entries intact since those are generated docs, out of scope)

## Acceptance Criteria

- [ ] No SWE skill template contains `Session date`, `today's date`, or `"Last updated" date` instructions
- [ ] No QA skill template contains `Session date`, `today's date`, `[today]`, or `"Last updated" date` instructions
- [ ] No DevOps skill template contains `Session date` or session-tracking dates; operational dates in `release-plan.md` are preserved
- [ ] No System Architect skill template contains `Session date`, `today's date`, or date columns in ADR tables
- [ ] Lessons-log template header has `Date` column removed
- [ ] All removals are consistent with the convention from swe-feature-029 (drop entirely, don't replace)
- [ ] "Today's task" phrasing in `/start` skills is left alone (conversational, not a date stamp)

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** None (follows pattern from swe-feature-029)
**Inputs:** project brief (always), all files listed above, `issues/done/swe-feature-029.md` (for reference on the convention used)
**Out of scope:** PM skills (already done in swe-feature-029); existing generated documents; Cursor rule files; "Today's task" conversational phrasing in `/start` skills

## Session 16 Summary

**What was done:** Removed all session-tracking date references from 15 files across SWE, QA, DevOps, System Architect, and lessons-log. Preserved operational dates in DevOps release-plan.
**Handoff note:** `docs/handoff-notes/swe/session-16.md`
**All acceptance criteria met:** Yes
