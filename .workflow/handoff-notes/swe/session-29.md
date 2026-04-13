# Handoff Note: QA Regression Bug Fixes (056, 057, 058)

**Issue:** swe-bug-056, swe-bug-057, swe-bug-058 — Install script PM dir mismatch, update-brief-status missing from cleanup/READMEs, sync check false positives

## What Was Accomplished

Fixed all three bugs found during QA cross-platform regression (qa-feature-045). Install script now creates `pm/` (not `project-manager/`) for PM handoff notes, `update-brief-status` is included in install cleanup and README documentation, and `sync.sh check` no longer flags `.gitkeep`/`test-*` files as missing.

## Acceptance Criteria Status

### swe-bug-056 (must-fix)
- [x] Install script creates `docs/handoff-notes/pm/` (not `project-manager/`)
- [x] Both platform READMEs updated to show `pm/` in scaffolding
- [x] Both install scripts (bash and PowerShell) are consistent

### swe-bug-057 (should-fix)
- [x] `install.sh` cleanup section includes `rm -f` for `update-brief-status.*` (both Cursor and Claude Code blocks)
- [x] `install.ps1` cleanup section includes equivalent cleanup
- [x] Cursor README scripts section lists `update-brief-status.sh` and `.ps1` with description
- [x] Claude Code README scripts section lists `update-brief-status.sh` and `.ps1` with description

### swe-bug-058 (should-fix)
- [x] `sync.sh check` excludes `.gitkeep` files from comparison
- [x] `sync.sh check` excludes `test-*` and `*.test.*` files from comparison
- [x] `sync.ps1 check` applies the same exclusions
- [x] Running `sync.sh check` against a freshly installed project reports 0 differences

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Extended `should_skip_source_file()` instead of adding inline checks | Single function controls all exclusions for both check and apply modes; mirrors install script's `copy_scripts` exclusion pattern |
| Added full script descriptions to Claude Code README | It previously only had "Same set as Cursor, plus session-primer.sh" — inconsistent with Cursor README which listed each script with a description |

## Problems Encountered

None. All three bugs were straightforward mechanical fixes.

## Scope Changes

Added individual script descriptions to the Claude Code README Scripts section (was missing, unlike Cursor README). This was adjacent to bug-057 and improved consistency.

## Files Created or Modified
- `targets/ide/install.sh` — changed `project-manager` to `pm` in expert loop; added `update-brief-status.*` cleanup
- `targets/ide/install.ps1` — same two changes
- `targets/ide/cursor/README.md` — `project-manager/` → `pm/`; added `update-brief-status` to scripts listing and description
- `targets/ide/claude-code/README.md` — `project-manager/` → `pm/`; added `update-brief-status` to scripts listing; added full script descriptions
- `tools/sync.sh` — extended `should_skip_source_file()` to exclude `.gitkeep` and `test-*`/`*.test.*`
- `tools/sync.ps1` — extended `Test-ShouldSkip` with same patterns

## What the Next Session Needs to Know

1. All three QA regression bugs are resolved. No remaining must-fix or should-fix issues from qa-feature-045.
2. The `sync.sh diff` mode still shows pre-existing platform differences (11 DIFFERS in skills/commands, 1 MISSING `.gitkeep`). These are expected — some skills legitimately differ between platforms (e.g., script path references). The `.gitkeep` in diff mode is not filtered because `should_skip_source_file` only applies to check/apply modes, not cross-platform diff.
3. PowerShell scripts (`install.ps1`, `sync.ps1`) are untestable on macOS — logic mirrors bash exactly but is unverified on Windows.

## Open Questions

None.
