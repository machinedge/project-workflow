# Create Workflow Shell Scripts for Mechanical Operations

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As an expert session user, I want mechanical operations (issue numbering, file movement, list updates) to happen reliably via scripts so that I don't have to worry about manual bookkeeping during sessions.

## Description

Create ~7 reusable shell scripts that handle the mechanical operations currently repeated across 10+ skill files. Each script gets both `.sh` and `.ps1` versions. Scripts are stored in the repo under `targets/ide/cursor/tools/` and `targets/ide/claude-code/tools/` (identical content, per the design from sa-feature-033). Install scripts will later copy these into `.cursor/tools/` and `.claude/tools/` in user projects.

## Acceptance Criteria

- [ ] `next-issue-number` script: scans all `issues/` subdirectories, finds highest issue number, prints next number (zero-padded to 3 digits)
- [ ] `next-session-number` script: takes expert name as argument, scans `docs/handoff-notes/<expert>/`, prints next session number (zero-padded to 2 digits)
- [ ] `move-issue` script: takes issue filename and target status (backlog/planned/in-progress/done), moves the file to the correct directory
- [ ] `update-issues-list` script: regenerates `issues/issues-list.md` from all issue files across all status directories
- [ ] `update-brief-status` script: takes key-value pairs, updates the Current Status section of `docs/project-brief.md`
- [ ] `count-issues` script: counts issue files by status directory, outputs summary
- [ ] All scripts have both `.sh` and `.ps1` versions
- [ ] All `.sh` scripts are executable and work on macOS/Linux (bash/zsh)
- [ ] Scripts handle edge cases: empty directories, missing files, first-ever issue/session
- [ ] Scripts are stored in `targets/ide/cursor/tools/` and `targets/ide/claude-code/tools/`

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-033 (design defines exact script locations and naming)
**Inputs:** project brief, sa-feature-033 design output, existing issue/handoff file conventions from `experts/technical/shared/docs-protocol.md`
**Out of scope:** MCP tool wrappers. Integration into install scripts (separate task). Platform-specific script differences (none expected — these are pure file operations).
