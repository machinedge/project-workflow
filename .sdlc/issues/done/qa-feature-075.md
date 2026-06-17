# QA: Grep Audit for Stale Path References

**Type:** feature
**Expert:** qa
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## Description

Comprehensive audit of the entire repository for any remaining references to old paths (`docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `issues/`) that should have been updated to `.sdlc/` equivalents. File any findings as bug issues.

## Scope

- All files in `targets/ide/cursor/`
- All files in `targets/ide/claude-code/`
- All files in `.cursor/`
- All files in `.claude/`
- `targets/ide/install.sh` and `targets/ide/install.ps1`
- `docs/agent-reference.md`
- `docs/project-brief.md` (verify "How It Works" and conventions mention `.sdlc/`)

## Acceptance Criteria

- [ ] Grep audit completed across all in-scope files
- [ ] Any stale references found are filed as bug issues in `issues/backlog/`
- [ ] If no stale references found, audit report confirms clean state
- [ ] Cross-check: skills that reference both `docs/` (for planning docs) and `.sdlc/` (for managed artifacts) are using the correct path for each

## Session 07 Summary

**What was done:** Grep audit across all in-scope files for 5 stale path patterns. Found 1 should-fix (swe-bug-080) and 1 nit. Cross-check confirmed correct `docs/` vs `.sdlc/` usage in skills.
**Handoff note:** `docs/handoff-notes/qa/session-07.md`
**All acceptance criteria met:** Yes

## Notes

**Depends on:** swe-feature-074 (reinstall must be complete)
**Inputs:** All installed and source files, sa-feature-063 path mapping for reference
