# Remove date references from PM skill templates

**Type:** feature
**Expert:** swe
**Milestone:** [PM Planning Improvements] Adaptive interview and date-free PM output
**Status:** backlog

## User Story

As a developer using the PM expert, I want the PM to stop generating calendar dates in its output so that planning artifacts reflect session-based progress instead of meaningless date stamps.

## Description

The PM expert's skill templates currently include date fields and instruct the PM to insert calendar dates into generated artifacts (project briefs, roadmaps, handoff notes, etc.). Since all development is AI-assisted and session-based, these dates are noise. Replace date-based tracking with session-based references throughout the PM skill definitions.

## Acceptance Criteria

- [ ] `vision.md` template no longer includes `Started: [Date]`, `Target completion: [Date]`, or date-based `Last updated`
- [ ] `vision.md` Key Decisions table uses a non-date identifier instead of `| Date |`
- [ ] `roadmap.md` milestones table no longer includes `Target Date` column
- [ ] `roadmap.md` change log uses a non-date identifier instead of `| Date |`
- [ ] `update_plan.md` no longer instructs PM to use "today's date" for Key Decisions or Change Log entries
- [ ] `postmortem.md` no longer says "update dates" when updating the roadmap
- [ ] `handoff.md` no longer uses `Session date: [today's date]` or "Update the 'Last updated' date"
- [ ] All replacements are consistent — the same non-date convention is used everywhere

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** None
**Inputs:** project brief (always), `experts/technical/project-manager/skills/vision.md`, `experts/technical/project-manager/skills/roadmap.md`, `experts/technical/project-manager/skills/update_plan.md`, `experts/technical/project-manager/skills/postmortem.md`, `experts/technical/project-manager/skills/handoff.md`
**Out of scope:** Changing existing generated documents (project brief, roadmap already in `docs/`); changing other experts' skills; changing the `interview.md`, `start.md`, `add_feature.md`, or `decompose.md` skills (no date references in those)

## Session 14 Summary

**What was done:** Removed all calendar date references from 5 PM skill templates. Date columns dropped from tables, date fields removed from templates, date-related instructions removed.
**Handoff note:** `docs/handoff-notes/swe/session-14.md`
**All acceptance criteria met:** Yes
