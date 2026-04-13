# Handoff Note: Robust Concurrent Handoff Scripts

**Issue:** swe-feature-049 — Robust concurrent handoff: script-based project brief updates and session claiming

## What Was Accomplished

Created `update-brief-status.sh` (+ `.ps1` companion) that atomically updates the "Last updated" line in `docs/project-brief.md` under a lockfile. Updated all 10 handoff skills (5 Cursor + 5 Claude Code) to call this script instead of relying on agent instructions to re-read and merge the project brief.

## Acceptance Criteria Status
- [x] Project brief updates from concurrent sessions cannot silently overwrite each other (enforced by lockfile + atomic read-modify-write)
- [x] Works on both Cursor and Claude Code platforms (identical scripts, platform-appropriate paths in skills)
- [x] Handoff skills updated to use the new script (all 10 files)
- [x] Backward compatible — works with single session (lock is uncontested)

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Lockfile approach (not git-based conflict detection) | Simpler, no git dependency, works in non-git projects |
| Stale lock timeout at 5 seconds | Line replacement takes milliseconds; 5s is generous for crash recovery |
| `while read` loop instead of `sed` for line replacement | Avoids sed escaping issues with special characters in status descriptions |
| Agent still manually edits "Key Decisions Made" table | Append-only table is inherently safe from concurrent conflicts; writing decision rationale is agent work |
| "Next task" field left to agent | Requires judgment about what to work on next; not mechanical |

## Problems Encountered

None. Implementation was straightforward — the patterns from `next-session-number.sh` (noclobber locking, retry loop, stale detection) applied directly.

## Scope Changes

None. Implemented the lockfile approach from the issue's primary proposal. The lighter git-based alternative was not needed.

## Files Created or Modified
- `targets/ide/cursor/scripts/update-brief-status.sh` — new: atomic project brief updater
- `targets/ide/cursor/scripts/update-brief-status.ps1` — new: PowerShell companion
- `targets/ide/claude-code/scripts/update-brief-status.sh` — new: identical copy
- `targets/ide/claude-code/scripts/update-brief-status.ps1` — new: identical copy
- `targets/ide/cursor/skills/pm-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/cursor/skills/swe-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/cursor/skills/qa-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/cursor/skills/ops-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/cursor/skills/sa-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/claude-code/skills/pm-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/claude-code/skills/swe-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/claude-code/skills/qa-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/claude-code/skills/ops-handoff/SKILL.md` — Step 5 replaced with script call
- `targets/ide/claude-code/skills/sa-handoff/SKILL.md` — Step 5 replaced with script call

## What the Next Session Needs to Know

1. **All acceptance criteria met.** The script is tested (single run, concurrent run, error cases, lockfile cleanup).
2. **SA follow-up needed:** `docs/architecture.md` script specifications table should be updated to include `update-brief-status.sh`. This was flagged rather than done directly per escalation principles.
3. **PowerShell untestable on macOS** — same caveat as `next-session-number.ps1`. Logic mirrors bash exactly but behavioral parity is unverified on Windows.
4. **macOS `stat` flag:** The script uses `stat -f %m` (macOS) with fallback to `stat -c %Y` (Linux) for stale lock detection. Both paths are implemented but only macOS is tested.

## Open Questions

None.
