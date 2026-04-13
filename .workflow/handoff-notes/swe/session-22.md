# Handoff Note: QA Bug Fixes (swe-bug-050, swe-bug-051, swe-techdebt-052)

**Issues:** swe-bug-050, swe-bug-051, swe-techdebt-052

## What Was Accomplished

Fixed three QA-found issues from the Cursor implementation review (qa-feature-039):

1. **swe-bug-050:** Ported atomic session claiming from `next-session-number.sh` to `next-session-number.ps1` for both Cursor and Claude Code. The PowerShell version now uses `[System.IO.File]::Open()` with `FileMode::CreateNew` (same kernel-level `O_CREAT|O_EXCL` semantics as bash noclobber) to atomically create a placeholder file, with a retry loop and max-attempts guard.

2. **swe-bug-051:** Standardized issue filename prefix convention across all issue-creating skills. Clarified in `project-os.mdc` that the `[expert]` prefix is the **executor** (who fixes it), not the finder. Changed `qa-review` and `qa-regression` from `qa-bug-NNN` / `qa-techdebt-NNN` to `swe-bug-NNN` / `swe-techdebt-NNN`. Standardized DevOps prefix to `devops-` (not `ops-`), fixing the `ops-start` example.

3. **swe-techdebt-052:** Removed dead `count` variable from `update-issues-list.sh` in both Cursor and Claude Code copies. The variable was incremented inside a pipeline subshell and never read by the parent shell.

## Acceptance Criteria Status

### swe-bug-050
- [x] `next-session-number.ps1` creates handoff-notes directory if it doesn't exist
- [x] `next-session-number.ps1` atomically creates a placeholder file at the claimed session path
- [x] `next-session-number.ps1` retries with incremented number if placeholder exists
- [x] `next-session-number.ps1` fails with clear error after max attempts
- [x] Claude Code copy updated to match

### swe-bug-051
- [x] `project-os.mdc` clarifies `[expert]` is the executor
- [x] All issue-creating skills use executor prefix consistently
- [x] DevOps issue filename prefix is `devops-` consistently
- [x] `ops-start` example matches `devops-` convention

### swe-techdebt-052
- [x] `count` variable and increments removed from Cursor `update-issues-list.sh`
- [x] Same fix applied to Claude Code `update-issues-list.sh`

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| `[System.IO.File]::Open()` with `FileMode::CreateNew` for atomic claiming | .NET equivalent of `O_CREAT\|O_EXCL` — same kernel-level atomicity as bash `set -C`. More reliable than `New-Item` which has a TOCTOU window. |
| Executor prefix convention (who fixes it, not who found it) | Matches pre-M11 established behavior, `pm-decompose` convention, and existing issue files in the repo. |
| `devops-` prefix (not `ops-`) for issue filenames | 3-of-4 existing skills already used `devops-`; matches full expert directory name convention. |

## Problems Encountered

None. All three fixes were straightforward and mechanical.

## Scope Changes

None.

## Files Created or Modified

- `targets/ide/cursor/scripts/next-session-number.ps1` — rewritten with atomic claiming
- `targets/ide/claude-code/scripts/next-session-number.ps1` — rewritten with atomic claiming
- `targets/ide/cursor/rules/project-os.mdc` — clarified executor prefix and `devops-` convention
- `targets/ide/cursor/skills/qa-review/SKILL.md` — changed `qa-bug-`/`qa-techdebt-` to `swe-bug-`/`swe-techdebt-`
- `targets/ide/cursor/skills/qa-regression/SKILL.md` — changed `qa-bug-` to `swe-bug-`
- `targets/ide/cursor/commands/ops-start.md` — changed `ops-feature-001` to `devops-feature-001`
- `targets/ide/cursor/scripts/update-issues-list.sh` — removed dead `count` variable
- `targets/ide/claude-code/scripts/update-issues-list.sh` — removed dead `count` variable

## What the Next Session Needs to Know

1. **All three QA-found bugs are fixed.** The Cursor implementation QA review (qa-feature-039) had 0 must-fix, 2 should-fix (swe-bug-050, swe-bug-051), and 1 nit (swe-techdebt-052). All resolved.
2. **Convention established:** Issue filename prefix = executor. DevOps prefix = `devops-`. Documented in `project-os.mdc`.
3. **PowerShell scripts are untestable on macOS** without PowerShell Core. Logic mirrors bash exactly but behavioral parity is unverified on Windows.
4. **Next work is Claude Code implementation** (swe-feature-040, swe-feature-041) per the project brief.

## Open Questions

None.
