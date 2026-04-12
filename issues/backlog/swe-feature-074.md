# Reinstall Into Project and Verify All Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer, I need to verify that after reinstalling the updated toolkit into this project, all installed files (`.cursor/` and `.claude/`) reference `.workflow/` paths and that no stale references remain.

## Description

Run the install script on this project to copy updated source files into `.cursor/` and `.claude/`. Then do a comprehensive grep audit to confirm zero stale path references in the installed files.

## Acceptance Criteria

- [ ] Install script runs successfully on this project
- [ ] `.cursor/rules/`, `.cursor/commands/`, `.cursor/skills/`, `.cursor/scripts/` all reference `.workflow/` paths
- [ ] `.claude/roles/`, `.claude/commands/`, `.claude/skills/`, `.claude/scripts/`, `.claude/CLAUDE.md` all reference `.workflow/` paths
- [ ] `grep -r 'docs/handoff-notes\|docs/lessons-log\|docs/interview-notes' .cursor/ .claude/` returns zero matches
- [ ] `grep -r 'issues/backlog\|issues/planned\|issues/in-progress\|issues/done' .cursor/ .claude/` returns zero matches (all should be `.workflow/issues/`)

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** swe-feature-064 through swe-feature-073 (all path updates must be complete)
**Inputs:** `targets/ide/install.sh`, all updated source files
**Out of scope:** Migration testing (M14)
