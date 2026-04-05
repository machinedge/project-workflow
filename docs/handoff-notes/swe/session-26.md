# Handoff Note: Build Sync/Management Command

**Issue:** swe-feature-043 — Build Sync/Management Command

## What Was Accomplished

Built `tools/sync.sh` and `tools/sync.ps1` — a dual-mode command for detecting drift between Cursor and Claude Code platform implementations (maintainer use) and checking/updating installed toolkit files (user use). Also created `tools/test-sync.sh` with 36 tests covering all modes, edge cases, and error handling.

### Three modes:
1. **diff** — compares `targets/ide/cursor/` and `targets/ide/claude-code/`, reports coverage gaps (missing skills/commands) and content differences (shared commands, skills, and scripts that should be identical)
2. **check [project-dir]** — auto-detects installed platform, compares installed files against source, reports drift
3. **apply [project-dir]** — same as check but copies updated files with user confirmation (`-y`/`--yes` for non-interactive/agent use)

## Acceptance Criteria Status

- [x] `sync.sh` / `sync.ps1` script exists in `tools/`
- [x] Diff mode: compares shell scripts between platforms — reports differences (shared scripts only; platform-specific scripts naturally excluded)
- [x] Diff mode: compares expert coverage — reports skills or commands in one platform but not the other
- [x] User update mode: compares installed files against source, reports what's changed
- [x] User update mode: applies updates with user confirmation (or `-y` flag)
- [x] Clear output — structured markers `[OK]`, `[DIFFERS]`, `[MISSING:*]`, `[UPDATED]`, `[SKIPPED]` documented in script header for agent consumption
- [x] Exit codes: 0 = in sync, 1 = differences found, 2 = error
- [x] Both `.sh` and `.ps1` versions

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| `SYNC_REPO_ROOT` env var for repo root override | Enables testing with fixtures without affecting normal usage |
| Scripts coverage not checked (only content of shared scripts) | Platform-specific scripts (test-scripts.sh, session-primer.sh) are legitimate; hardcoding exceptions would be fragile |
| `settings.json` skipped during apply, flagged `[SKIPPED]` | Contains user hooks that need merging, not overwriting |
| `README.md` excluded from check/apply | READMEs live in the repo, not installed to user projects |
| Compressed output: summary counts for OK, individual lines for problems | User requested "just point out differences"; reduces noise |
| `-y`/`--yes` flag for non-interactive apply | Agents and CI need to skip interactive prompts |

## Problems Encountered

None. Implementation was straightforward.

## Scope Changes

None.

## Files Created or Modified

- `tools/sync.sh` — main sync command (bash, ~310 lines)
- `tools/sync.ps1` — PowerShell equivalent (~310 lines)
- `tools/test-sync.sh` — test suite (36 tests, ~280 lines)

## What the Next Session Needs to Know

1. **Sync command is complete and tested.** 36/36 tests pass. All acceptance criteria met.
2. **Real drift exists:** running `sync.sh diff` on the actual repo detects 14 differences between Cursor and Claude Code (11 skills, 2 commands, 1 .gitkeep coverage gap). This is pre-existing drift, not introduced by this task.
3. **PowerShell is untested on Windows.** Logic mirrors bash exactly but behavioral parity is unverified without PowerShell Core or a Windows environment.
4. **Next tasks per project brief:** swe-feature-044 (install + docs), qa-feature-045 (cross-platform regression).
5. **Output format is agent-friendly.** The script header documents all markers (`[OK]`, `[DIFFERS]`, `[MISSING:*]`, `[UPDATED]`, `[SKIPPED]`) and exit codes so agents can invoke the script and parse results.

## Open Questions

None.
