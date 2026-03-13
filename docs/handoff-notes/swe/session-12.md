# Handoff Note: Add Prerequisites Column to PM Decompose Skill

**Session date:** 2026-03-12
**Issue:** swe-bug-023

## What Was Accomplished

Fixed the PM `/decompose` skill to include "prerequisites" in the column list for the `issues/issues-list.md` update instruction. Previously the skill only specified "filename, title, expert, type, milestone, and status," causing agents to omit dependency information from the overview table.

## Files Modified

| File | Change |
|------|--------|
| `experts/technical/project-manager/skills/decompose.md` | Line 158: added "prerequisites" to the issues-list.md column list |

## Acceptance Criteria Status

- [x] `experts/technical/project-manager/skills/decompose.md` updated to include a Prerequisites column in the issues-list.md update instruction
- [x] The issues-list.md table format documented/templated to include: File, Title, Expert, Type, Milestone, Prerequisites, Status

## Decisions Made This Session

None.

## Problems Encountered

None.

## Scope Changes

None.

## What the Next Session Needs to Know

1. swe-bug-023 is resolved. The decompose skill now instructs agents to produce a 7-column issues-list table matching the format already in use.

2. Remaining backlog: qa-feature-005 (QA consistency review).

## Open Questions

None.
