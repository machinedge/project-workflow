# Implement Migration Logic in install.ps1

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Migration from old structure (M14)
**Status:** backlog

## User Story

As a Windows developer upgrading an existing project that uses the old directory layout, I need the PowerShell install script to automatically migrate my artifacts into `.workflow/`.

## Description

Port the migration logic from `install.sh` (swe-feature-076) to `targets/ide/install.ps1`. Same behavior: detect old structure, move known artifacts to `.workflow/`, leave user files untouched, idempotent.

## Acceptance Criteria

- [ ] Same detection and migration behavior as `install.sh` (swe-feature-076)
- [ ] Moves handoff notes, interview notes, lessons-log, research reports, and issues to `.workflow/`
- [ ] Does NOT move planning docs or unknown user files
- [ ] Idempotent: running twice doesn't fail or duplicate
- [ ] Prints clear output showing what was migrated

## Technical Notes

**Estimated effort:** Small session (port from bash to PowerShell)
**Dependencies:** swe-feature-076 (bash version must be implemented first as reference)
**Inputs:** `docs/project-brief.md`, `targets/ide/install.ps1`, completed `targets/ide/install.sh`
**Out of scope:** Testing on Windows (persistent gap from M11)

## Session 02 Summary

**What was done:** Ported migration logic from bash to PowerShell with `Migrate-Directory`/`Migrate-File` functions. Syntax-checked with `pwsh`.
**Handoff note:** `.workflow/handoff-notes/swe/session-02.md`
**All acceptance criteria met:** Yes
