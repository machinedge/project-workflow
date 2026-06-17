# Update Claude Code Scripts for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer using Claude Code, I need the workflow shell scripts to operate on `.sdlc/` paths, so that mechanical operations (issue movement, session numbering, issues-list generation) target the correct directories.

## Description

Update all scripts in `targets/ide/claude-code/scripts/` to replace hardcoded `docs/handoff-notes/` and `issues/` paths with `.sdlc/` equivalents. Both `.sh` and `.ps1` variants must be updated. Also update `session-primer.sh` (Claude Code only) to read from `.sdlc/`.

## Acceptance Criteria

- [ ] `move-issue.sh` and `move-issue.ps1` operate on `.sdlc/issues/`
- [ ] `next-issue-number.sh` and `.ps1` scan `.sdlc/issues/`
- [ ] `next-session-number.sh` and `.ps1` create handoff notes in `.sdlc/handoff-notes/`
- [ ] `update-issues-list.sh` and `.ps1` scan `.sdlc/issues/` and write `.sdlc/issues/issues-list.md`
- [ ] `session-primer.sh` reads handoff notes from `.sdlc/handoff-notes/`
- [ ] `update-brief-status.sh` and `.ps1` still update `docs/project-brief.md` (stays in `docs/`)
- [ ] `grep -r 'docs/handoff-notes\|issues/' targets/ide/claude-code/scripts/` returns only references to `docs/project-brief.md`

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063, swe-feature-067 (use Cursor scripts as reference for consistency)
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/claude-code/scripts/`
**Out of scope:** Rules, commands, and skills
