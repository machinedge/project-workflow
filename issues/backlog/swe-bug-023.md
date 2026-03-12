# BUG: PM decompose skill doesn't include Prerequisites column in issues-list.md

**Type:** bug
**Expert:** swe
**Milestone:** M4
**Status:** backlog
**Severity:** should-fix

## Description

The PM `/decompose` skill instructs the agent to update `issues/issues-list.md` with "filename, title, expert, type, milestone, and status" but does not include a Prerequisites/Blocked-by column. Dependencies between issues are only recorded inside individual issue files (via `**Dependencies:**` lines), making them invisible in the overview list.

This means anyone scanning `issues-list.md` to find the next available task can't see which issues are blocked without opening each file individually. The QA session for qa-feature-017 created 5 new issues and missed adding dependency information to the list because the table format didn't call for it.

## Root Cause

`experts/technical/project-manager/skills/decompose.md` line 158 specifies the issues-list columns as "filename, title, expert, type, milestone, and status" — no prerequisites column. Line 150 says to use `**Dependencies:**` inside issue files, but doesn't carry that forward to the summary table.

## Acceptance Criteria

- [ ] `experts/technical/project-manager/skills/decompose.md` updated to include a Prerequisites column in the issues-list.md update instruction
- [ ] The issues-list.md table format documented or templated to include: File, Title, Expert, Type, Milestone, Prerequisites, Status

## Notes

**Found by:** qa-feature-017 (post-session observation)
**Files:** `experts/technical/project-manager/skills/decompose.md` (line 158)
