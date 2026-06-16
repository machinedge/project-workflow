# Implement Migration Logic in install.sh

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Migration from old structure (M14)
**Status:** backlog

## User Story

As a developer upgrading an existing project that uses the old directory layout, I need the install script to automatically migrate my handoff notes, interview notes, lessons-log, research reports, and issues from the old locations into `.sdlc/`, so that I don't lose any session history.

## Description

Add migration logic to `targets/ide/install.sh` that detects the old directory structure (`docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, top-level `issues/`) and moves those artifacts into `.sdlc/`. The migration must be idempotent (safe to re-run) and must not touch user-created files in `docs/`.

## Acceptance Criteria

- [ ] Script detects old structure by checking for `docs/handoff-notes/` or top-level `issues/`
- [ ] Moves `docs/handoff-notes/` to `.sdlc/handoff-notes/` (preserving all subdirectories and files)
- [ ] Moves `docs/interview-notes*.md` to `.sdlc/`
- [ ] Moves `docs/lessons-log.md` to `.sdlc/`
- [ ] Moves `docs/research-*.md` to `.sdlc/`
- [ ] Moves `issues/` to `.sdlc/issues/` (preserving all subdirectories and files)
- [ ] Does NOT move `docs/project-brief.md`, `docs/roadmap.md`, `docs/test-plan.md`, `docs/architecture.md`, `docs/agent-reference.md`
- [ ] Does NOT move any files in `docs/` that aren't matched by known patterns
- [ ] Idempotent: running twice doesn't fail or duplicate files
- [ ] Prints clear output showing what was migrated

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** swe-feature-072 (fresh install logic must exist first)
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/install.sh`
**Out of scope:** PowerShell migration (separate task), testing on this project (separate task)

## Session 02 Summary

**What was done:** Added `migrate_dir`/`migrate_file` helpers and real migration logic to `install.sh`. Restructured scaffold to run unconditionally. Tested fresh install, migration, and idempotency.
**Handoff note:** `.sdlc/handoff-notes/swe/session-02.md`
**All acceptance criteria met:** Yes
