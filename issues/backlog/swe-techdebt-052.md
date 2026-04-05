# Dead `count` variable in update-issues-list.sh

**Type:** techdebt
**Expert:** swe
**Milestone:** M11
**Status:** backlog
**Severity:** nit
**Found by:** /qa-review of swe-feature-034 (qa-feature-039)

## Description

In `targets/ide/cursor/scripts/update-issues-list.sh`, the `count` variable is incremented inside a `{ ... } | sort ...` pipeline subshell but is never read after the pipeline completes. The parent shell's `count` remains 0. The variable and its increments are dead code.

The PowerShell version (`update-issues-list.ps1`) does not have this issue — it uses an array accumulator pattern instead.

## Acceptance Criteria

- [ ] `count` variable and its increments are removed from `update-issues-list.sh`
- [ ] Same fix applied to `targets/ide/claude-code/scripts/update-issues-list.sh` if the same dead code exists there

## Technical Notes

**Estimated effort:** Small (2-line deletion)
**File(s):** `targets/ide/cursor/scripts/update-issues-list.sh`, `targets/ide/claude-code/scripts/update-issues-list.sh`
