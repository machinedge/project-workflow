# Update Claude Code Rules for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer using Claude Code, I need the project routing file and expert role files to reference `.workflow/` paths, so that experts read and write managed artifacts to the correct location.

## Description

Update `CLAUDE.md` and all 5 expert role files in `targets/ide/claude-code/roles/` to replace old `docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, and `issues/` references with their `.workflow/` equivalents.

## Acceptance Criteria

- [ ] `CLAUDE.md` conventions section references `.workflow/handoff-notes/` and `.workflow/issues/`
- [ ] `project-manager.md` references `.workflow/` for handoff notes, interview notes, and issues paths
- [ ] `swe.md` references `.workflow/` for handoff notes, lessons-log, and issues paths
- [ ] `qa.md` references `.workflow/` for handoff notes, lessons-log, and issues paths
- [ ] `devops.md` references `.workflow/` for handoff notes and lessons-log paths
- [ ] `system-architect.md` references `.workflow/` for handoff notes and lessons-log paths
- [ ] `grep -r 'docs/handoff-notes\|docs/lessons-log\|docs/interview-notes\|issues/' targets/ide/claude-code/roles/ targets/ide/claude-code/CLAUDE.md` returns zero matches

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063, swe-feature-064 (use Cursor rules as reference for consistency)
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/claude-code/roles/`, `targets/ide/claude-code/CLAUDE.md`
**Out of scope:** Commands, skills, and scripts

## Session 35 Summary

**What was done:** Updated CLAUDE.md and all 5 Claude Code role files to replace old artifact paths with `.workflow/` equivalents per ADR-011. Verified zero stale references via grep.
**Handoff note:** `docs/handoff-notes/swe/session-35.md`
**All acceptance criteria met:** Yes
