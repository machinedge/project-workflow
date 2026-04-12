# Implement Migration Logic in install.sh

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Migration from old structure (M14)
**Status:** backlog

## User Story

As a developer upgrading an existing project that uses the old directory layout, I need the install script to automatically migrate my handoff notes, interview notes, lessons-log, research reports, and issues from the old locations into `.workflow/`, so that I don't lose any session history.

## Description

Add migration logic to `targets/ide/install.sh` that detects the old directory structure (`docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, top-level `issues/`) and moves those artifacts into `.workflow/`. The migration must be idempotent (safe to re-run) and must not touch user-created files in `docs/`.

## Acceptance Criteria

- [ ] Script detects old structure by checking for `docs/handoff-notes/` or top-level `issues/`
- [ ] Moves `docs/handoff-notes/` to `.workflow/handoff-notes/` (preserving all subdirectories and files)
- [ ] Moves `docs/interview-notes*.md` to `.workflow/`
- [ ] Moves `docs/lessons-log.md` to `.workflow/`
- [ ] Moves `docs/research-*.md` to `.workflow/`
- [ ] Moves `issues/` to `.workflow/issues/` (preserving all subdirectories and files)
- [ ] Does NOT move `docs/project-brief.md`, `docs/roadmap.md`, `docs/test-plan.md`, `docs/architecture.md`, `docs/agent-reference.md`
- [ ] Does NOT move any files in `docs/` that aren't matched by known patterns
- [ ] Idempotent: running twice doesn't fail or duplicate files
- [ ] Prints clear output showing what was migrated

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** swe-feature-072 (fresh install logic must exist first)
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/install.sh`
**Out of scope:** PowerShell migration (separate task), testing on this project (separate task)
