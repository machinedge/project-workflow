# QA: Verify Migration End-to-End

**Type:** feature
**Expert:** qa
**Milestone:** [Workflow Directory] Migration from old structure (M14)
**Status:** backlog

## Description

End-to-end verification that the migration from old directory structure to `.workflow/` is complete, correct, and doesn't break any expert workflow. This is the final gate before M14 is marked done.

## Scope

- Verify all artifacts are in `.workflow/` and none remain in old locations
- Verify `docs/` contains only planning docs and user content
- Test that each expert type can start a session and interact with `.workflow/` paths
- Verify scripts work: `move-issue.sh`, `next-issue-number.sh`, `next-session-number.sh`, `update-issues-list.sh`
- Verify migration is idempotent (re-run install, confirm no errors or duplicates)
- Check for edge cases: empty directories, files with unusual names

## Acceptance Criteria

- [ ] All managed artifacts confirmed in `.workflow/`
- [ ] No managed artifacts remain in old locations (`docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, `issues/`)
- [ ] At least 2 different expert sessions start and complete without path errors
- [ ] All 4 core scripts execute successfully against `.workflow/` paths
- [ ] Re-running install.sh does not duplicate or error
- [ ] Any issues found are filed as bug issues in `.workflow/issues/backlog/` (using new path)

## Notes

**Depends on:** swe-feature-078 (migration must be tested first)
**Inputs:** SWE handoff notes from migration tasks, all `.workflow/` and `docs/` contents
