# Test Migration on This Project

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Migration from old structure (M14)
**Status:** backlog

## User Story

As the project maintainer, I need to run the migration on this project (which has the old directory layout with `docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, and `issues/`) and verify that everything moves correctly and all experts still work.

## Description

Run `install.sh` on this project to trigger the migration. Verify that all artifacts moved to `.workflow/`, that `docs/` retains only planning docs and project-specific files, and that the old directories are gone. Then do a smoke test: start a session with at least one expert and confirm it can read handoff notes and issues from the new location.

## Acceptance Criteria

- [x] `.workflow/handoff-notes/` contains all expert subdirectories with existing handoff notes
- [x] `.workflow/issues/` contains `backlog/`, `planned/`, `in-progress/`, `done/`, and `issues-list.md`
- [x] `.workflow/` contains all `interview-notes-*.md` files
- [x] `.workflow/lessons-log.md` exists
- [x] `.workflow/` contains all `research-*.md` files
- [x] `docs/` contains only `project-brief.md`, `roadmap.md`, `test-plan.md`, `architecture.md`, `agent-reference.md`, and any user docs
- [x] Top-level `issues/` directory no longer exists
- [x] `docs/handoff-notes/` directory no longer exists
- [x] At least one expert session starts successfully and reads from `.workflow/` paths

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** swe-feature-076 (migration logic), swe-feature-074 (all path references updated)
**Inputs:** This project's existing file structure
**Out of scope:** Full regression testing (that's the QA task)

## Session 42 Summary

**What was done:** Ran migration on this project using both `install.sh` and `install.ps1`. Both correctly migrated all artifacts to `.workflow/`, left `docs/` clean, and removed old directories. Scripts verified working with new paths.
**Handoff note:** `.workflow/handoff-notes/swe/session-42.md`
**All acceptance criteria met:** Yes
