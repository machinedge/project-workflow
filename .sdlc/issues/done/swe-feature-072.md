# Update Install Scripts for Fresh .workflow Structure

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer installing the workflow toolkit into a new project, I need the install script to create the `.sdlc/` directory structure instead of `docs/handoff-notes/` and `issues/`, so that new projects start with the correct layout from day one.

## Description

Update `targets/ide/install.sh` and `targets/ide/install.ps1` to create `.sdlc/` with the proper subdirectories on fresh install. This task covers fresh install only — migration logic is M14.

## Acceptance Criteria

- [ ] Fresh install creates `.sdlc/handoff-notes/{pm,swe,qa,devops,system-architect}/`
- [ ] Fresh install creates `.sdlc/issues/{backlog,planned,in-progress,done}/`
- [ ] Fresh install seeds `.sdlc/lessons-log.md` (instead of `docs/lessons-log.md`)
- [ ] Fresh install still creates `docs/` for planning docs (project-brief.md, etc.)
- [ ] Install script no longer creates `docs/handoff-notes/` or top-level `issues/` on fresh install
- [ ] Script detects fresh install vs. existing install (has old structure) — fresh install path only in this task

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/install.sh`, `targets/ide/install.ps1`
**Out of scope:** Migration logic for existing installs (that's M14)
