# Build Sync/Management Command

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a toolkit developer, I need a command that detects drift between the Cursor and Claude Code implementations so that I can keep both platforms aligned when changes are made to one.

As a Cursor user or Claude Code user, I need a management command that can check and update my installed toolkit so that I stay current without re-running the full install.

## Description

Build a sync/management command that serves two purposes: (1) for repo maintainers, it compares `targets/ide/cursor/` and `targets/ide/claude-code/` and reports differences in content (ignoring expected format differences), and (2) for end users, it can check their installed toolkit against the latest version and update files. Both `.sh` and `.ps1` versions.

## Acceptance Criteria

- [ ] `sync.sh` / `sync.ps1` script exists in `tools/` (repo-level utility, not hidden)
- [ ] **Diff mode:** compares shell scripts between Cursor and Claude Code directories — reports any differences (these should be identical)
- [ ] **Diff mode:** compares expert coverage — reports any expert or skill that exists in one platform but not the other
- [ ] **User update mode:** when run in a user's project directory, compares installed files against the source and reports what's changed
- [ ] **User update mode:** can apply updates (with user confirmation) — copies updated files to the correct locations
- [ ] Clear output — differences are reported in a human-readable format, not just raw diff
- [ ] Exit codes: 0 = in sync, 1 = differences found, 2 = error
- [ ] Both `.sh` and `.ps1` versions

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** qa-feature-039 (Cursor reviewed), qa-feature-042 (Claude Code reviewed) — both implementations must be finalized before the sync command can be validated
**Inputs:** project brief, `targets/ide/cursor/`, `targets/ide/claude-code/`
**Out of scope:** Automatic sync (human decides what to update). Version numbering. Package distribution.
