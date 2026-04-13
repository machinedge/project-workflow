# Handoff Note: Create Workflow Shell Scripts for Mechanical Operations

**Issue:** swe-feature-034 — Create Workflow Shell Scripts for Mechanical Operations

## What Was Accomplished

Created 4 reusable shell scripts (`.sh` + `.ps1` versions) that handle the mechanical file operations repeated across expert skill files: issue numbering, session numbering, issue file movement, and issues-list regeneration. Scripts are stored identically in `targets/ide/cursor/scripts/` and `targets/ide/claude-code/scripts/`. A 31-test suite validates all scripts including edge cases.

## Acceptance Criteria Status

- [x] `next-issue-number` script: scans all `issues/` subdirectories, finds highest issue number, prints next number (zero-padded to 3 digits)
- [x] `next-session-number` script: takes expert name as argument, scans `docs/handoff-notes/<expert>/`, prints next session number (zero-padded to 2 digits)
- [x] `move-issue` script: takes issue filename and target status (backlog/planned/in-progress/done), moves the file to the correct directory
- [x] `update-issues-list` script: regenerates `issues/issues-list.md` from all issue files across all status directories
- [ ] `session-context` script — **Re-scoped.** During review, determined this is agent work (reading docs, extracting context, summarizing), not a mechanical file operation. Filed as sa-feature-046 for architectural redesign as a skill.
- [x] All scripts have both `.sh` and `.ps1` versions
- [x] All `.sh` scripts are executable and work on macOS/Linux (bash/zsh)
- [x] Scripts handle edge cases: empty directories, missing files, first-ever issue/session
- [x] Scripts are stored in `targets/ide/cursor/scripts/` and `targets/ide/claude-code/scripts/`

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| `session-context` re-scoped from shell script to agent skill (sa-feature-046) | Requires reading project documents, understanding content, and producing a compressed summary — that's LLM work, not bash work |
| Scripts assume project-root execution with a one-line guard | Agents always invoke Shell from workspace root; guard gives a clear error if run from wrong directory |
| Test script kept in cursor scripts dir only, not claude-code | Development utility, not a production script; should be excluded from install |
| Dependencies parsing strips parenthetical descriptions, "None" → em dash | Matches existing `issues-list.md` format exactly |

## Problems Encountered

None. The scripts are straightforward file operations. The only complexity was `update-issues-list` which parses markdown metadata, but the issue file format is consistent enough that simple `grep`/`sed` handles it reliably.

## Scope Changes

`session-context` removed from this task's scope. It was the 5th of 5 scripts but fundamentally different from the other 4 — it needs to understand content, not just manipulate files. Filed as sa-feature-046 for the System Architect to redesign as a discoverable skill. This also affects the Claude Code `SessionStart` hook configuration in the architecture.

## Files Created or Modified

- `targets/ide/cursor/scripts/next-issue-number.sh` — scans issue dirs, outputs next 3-digit number
- `targets/ide/cursor/scripts/next-issue-number.ps1` — PowerShell equivalent
- `targets/ide/cursor/scripts/next-session-number.sh` — takes expert name, outputs next 2-digit session number
- `targets/ide/cursor/scripts/next-session-number.ps1` — PowerShell equivalent
- `targets/ide/cursor/scripts/move-issue.sh` — moves issue file between status directories
- `targets/ide/cursor/scripts/move-issue.ps1` — PowerShell equivalent
- `targets/ide/cursor/scripts/update-issues-list.sh` — regenerates issues-list.md from all issue files
- `targets/ide/cursor/scripts/update-issues-list.ps1` — PowerShell equivalent
- `targets/ide/cursor/scripts/test-scripts.sh` — test suite (31 tests, development utility)
- `targets/ide/claude-code/scripts/` — identical copies of all 8 production scripts (no test script)
- `issues/backlog/sa-feature-046.md` — new SA issue for session-context redesign
- `issues/issues-list.md` — added sa-feature-046

## What the Next Session Needs to Know

1. The 4 mechanical scripts are complete and tested. Downstream tasks (swe-feature-035 through swe-feature-038) can reference them as `.cursor/scripts/<name>.sh` or `.claude/scripts/<name>.sh`.
2. **sa-feature-046 should be addressed before swe-feature-040/041** (Claude Code skill tasks) since those tasks depend on the `SessionStart` hook configuration, which currently references a `session-context.sh` script that won't exist. The SA needs to redesign this as a skill.
3. `.ps1` scripts are untested (no Windows/PowerShell environment). QA (qa-feature-039) should code-review them for parity.
4. The test script (`test-scripts.sh`) lives in `targets/ide/cursor/scripts/` only. The install script update (swe-feature-044) should exclude it from being copied to user projects.

## Open Questions

- [ ] sa-feature-046: Should session-context become a discoverable skill, or does the Claude Code hook need a different mechanism entirely?
- [ ] Should the test script be moved to `tools/` instead of living alongside production scripts?
