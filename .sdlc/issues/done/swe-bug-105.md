# BUG: No explicit closing verification summary on success (UX-011)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

UX-011 requires migrate-sdlc to END with an explicit verification summary that states no listed spec remains in docs/ and lists the relocated set (or states none were found) — a closing line distinct from the per-file move lines. The success path prints the `Relocated:` list (the move lines themselves) but no separate closing confirmation; `verify_clean` only emits text on FAILURE (the `Verification failed:` lines), so a clean success has no positive "no specs remain in docs/ — migration complete" line.

## Location

`agents/scripts/migrate-sdlc.sh:139-201` and `agents/scripts/migrate-sdlc.ps1:165-217`

## Acceptance Criteria

- [ ] A closing summary line is printed on success, e.g. `Verified: N spec(s) relocated; no specs remain in docs/.`
- [ ] The line is distinct from the per-file move lines
- [ ] Applied consistently in both the bash and PowerShell scripts

## Notes

**Found by:** UX/SWE review of M19 SDLC boundary.
**Recommendation:** Add an affirmative end-of-run verification summary on success in both harnesses.
