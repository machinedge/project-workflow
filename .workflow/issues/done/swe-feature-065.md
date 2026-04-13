# Update Cursor Commands for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer using Cursor, I need the expert commands (`/pm-start`, `/swe-start`, etc.) to reference `.workflow/` paths, so that session startup reads from and writes to the correct locations.

## Description

Update all command files in `targets/ide/cursor/commands/` to replace old path references with `.workflow/` equivalents. Commands affected: `pm-start`, `pm-interview`, `pm-add-feature`, `swe-start`, `qa-start`, `sa-start`, `ops-start`, `ops-deploy`.

## Acceptance Criteria

- [ ] All `/start` commands load handoff notes from `.workflow/handoff-notes/<expert>/`
- [ ] All `/start` commands reference `.workflow/issues/` for issue discovery
- [ ] `pm-interview.md` writes interview notes to `.workflow/`
- [ ] `pm-add-feature.md` writes interview notes to `.workflow/`
- [ ] `swe-start.md` and `sa-start.md` reference `.workflow/` for lessons-log
- [ ] `grep -r 'docs/handoff-notes\|docs/lessons-log\|docs/interview-notes\|issues/' targets/ide/cursor/commands/` returns zero matches

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/cursor/commands/`
**Out of scope:** Rules, skills, and scripts

## Session 36 Summary

**What was done:** Updated all 8 Cursor command files to replace old artifact paths (docs/handoff-notes/, docs/lessons-log.md, docs/interview-notes*, issues/) with .workflow/ equivalents per ADR-011.
**Handoff note:** `docs/handoff-notes/swe/session-36.md`
**All acceptance criteria met:** Yes
