# BUG: migrate-sdlc move-lines violate UX-007: absolute paths + ASCII arrow instead of the installer's `docs/X → .sdlc/X` convention

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

UX-007 requires each relocation to print as one line `docs/X → .sdlc/X`, reusing the exact arrow convention already in `install.sh:117-137` (relative path, spaced Unicode arrow `→`, two-space indent) so the migration surface reads identically to the installer's. The shipped output instead prints a `Relocated:` header followed by `<absolute-src>-><absolute-dest>` (ASCII `->`, no spaces, full machine paths). Verified by driving the script: it emitted `  /Users/.../docs/architecture.md->/Users/.../.sdlc/architecture.md`. The accessibility bar (UX-007) wants the move legible as text; absolute paths bury the `docs/ → .sdlc/` relationship the user is trying to confirm.

## Location

`agents/scripts/migrate-sdlc.sh:68,194-197` and `agents/scripts/migrate-sdlc.ps1:78,209-213`

## Acceptance Criteria

- [ ] RELOCATED records the relative `docs/X → .sdlc/X` form per move (not a deferred list of absolute paths)
- [ ] The line is emitted inline as each file moves, matching `install.sh`
- [ ] The same fix is applied to both the bash and PowerShell scripts so they read identically (this also closes part of UX-006)

## Notes

**Found by:** UX/SWE review of M19 SDLC boundary.
**Recommendation:** Print relative `docs/X → .sdlc/X` per move inline in both harnesses.
