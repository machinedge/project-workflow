# Update Cursor Rules for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer using Cursor, I need the project routing rules and expert role files to reference `.sdlc/` paths, so that experts read and write managed artifacts to the correct location.

## Description

Update `project-os.mdc` and all 5 expert role files in `targets/ide/cursor/rules/` to replace old `docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, and `issues/` references with their `.sdlc/` equivalents.

## Acceptance Criteria

- [ ] `project-os.mdc` conventions section references `.sdlc/handoff-notes/` and `.sdlc/issues/`
- [ ] `project-manager-os.mdc` references `.sdlc/` for handoff notes, interview notes, and issues paths
- [ ] `swe-os.mdc` references `.sdlc/` for handoff notes, lessons-log, and issues paths
- [ ] `qa-os.mdc` references `.sdlc/` for handoff notes, lessons-log, and issues paths
- [ ] `devops-os.mdc` references `.sdlc/` for handoff notes and lessons-log paths
- [ ] `system-architect-os.mdc` references `.sdlc/` for handoff notes and lessons-log paths
- [ ] `grep -r 'docs/handoff-notes\|docs/lessons-log\|docs/interview-notes\|issues/' targets/ide/cursor/rules/` returns zero matches (except `docs/` files that stay)

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/cursor/rules/`
**Out of scope:** Commands, skills, and scripts — those are separate tasks

## Session 34 Summary

**What was done:** Updated all 6 Cursor rule files to replace old artifact paths with `.sdlc/` equivalents per ADR-011. Verified zero stale references via grep.
**Handoff note:** `docs/handoff-notes/swe/session-34.md`
**All acceptance criteria met:** Yes
