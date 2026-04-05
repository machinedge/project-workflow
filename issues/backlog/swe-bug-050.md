# PowerShell next-session-number.ps1 missing atomic session claiming

**Type:** bug
**Expert:** swe
**Milestone:** M11
**Status:** backlog
**Severity:** should-fix
**Found by:** /qa-review of swe-feature-034 (qa-feature-039)

## Description

`targets/ide/cursor/scripts/next-session-number.ps1` does not implement the atomic session claiming logic added to its bash counterpart for sa-bug-048. The bash version uses `set -C` (noclobber) with a retry loop to atomically create a placeholder file, preventing concurrent sessions from claiming the same number. The PowerShell version simply computes and outputs the number with no concurrency protection, no directory creation, and no placeholder file.

This parity gap means concurrent PowerShell sessions could claim the same session number, overwriting each other's handoff notes — the exact problem sa-bug-048 was designed to prevent.

The same gap likely exists in `targets/ide/claude-code/scripts/next-session-number.ps1`.

## Acceptance Criteria

- [ ] `next-session-number.ps1` creates the handoff-notes directory if it doesn't exist (equivalent to `mkdir -p`)
- [ ] `next-session-number.ps1` atomically creates a placeholder file at the claimed session path
- [ ] `next-session-number.ps1` retries with incremented number if the placeholder file already exists
- [ ] `next-session-number.ps1` fails with a clear error after a maximum number of attempts
- [ ] Claude Code copy (`targets/ide/claude-code/scripts/next-session-number.ps1`) is updated to match

## Technical Notes

**Estimated effort:** Small
**File(s):** `targets/ide/cursor/scripts/next-session-number.ps1`, `targets/ide/claude-code/scripts/next-session-number.ps1`
