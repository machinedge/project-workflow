# BUG: contributing.md install-output example shows 'Scripts: 11 files'; the installer now prints 13 after M19 added the migrate-sdlc pair (DOC-012, DOC-015)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

The installer counts all files in `.agents/scripts` (`find -type f`), now 13 (7 `.sh` + 6 `.ps1`) after M19 added the migrate-sdlc pair. The pasted "full block" shows "Scripts: 11 files", so a reader copy-comparing the block sees a mismatch. `getting-started.md` already hedges this correctly ("count varies"); only `contributing.md` hardcodes the stale number.

## Location

`docs/guides/contributing.md:93` (and the "11 skills"-style prose at :81)

## Acceptance Criteria

- [ ] The count is updated to 13, or — better, matching `getting-started.md` — hedged as "Scripts: N files (count varies)" so it does not drift again
- [ ] The "11 skills"-style prose at :81 is reconciled with the actual count

## Notes

**Found by:** Documentation review of M19 SDLC boundary.
**Recommendation:** Update or hedge the script count in contributing.md to match the installer output.
