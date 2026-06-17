# Update Cursor Scripts for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer using Cursor, I need the workflow shell scripts to operate on `.sdlc/` paths, so that mechanical operations (issue movement, session numbering, issues-list generation) target the correct directories.

## Description

Update all scripts in `targets/ide/cursor/scripts/` to replace hardcoded `docs/handoff-notes/` and `issues/` paths with `.sdlc/` equivalents. Both `.sh` and `.ps1` variants must be updated. Also update `test-scripts.sh` to validate the new paths.

## Acceptance Criteria

- [ ] `move-issue.sh` and `move-issue.ps1` operate on `.sdlc/issues/`
- [ ] `next-issue-number.sh` and `.ps1` scan `.sdlc/issues/`
- [ ] `next-session-number.sh` and `.ps1` create handoff notes in `.sdlc/handoff-notes/`
- [ ] `update-issues-list.sh` and `.ps1` scan `.sdlc/issues/` and write `.sdlc/issues/issues-list.md`
- [ ] `update-brief-status.sh` and `.ps1` still update `docs/project-brief.md` (stays in `docs/`)
- [ ] `test-scripts.sh` validates the new `.sdlc/` directory structure
- [ ] `grep -r 'docs/handoff-notes\|issues/' targets/ide/cursor/scripts/` returns only references to `docs/project-brief.md` (which stays)

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/cursor/scripts/`
**Out of scope:** Rules, commands, and skills
