# BUG: Installer migration output is inconsistent across bash and PowerShell (UX-006)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

UX-006 requires the installer scaffolding output to be consistent across bash and PowerShell (same messages). The bash installer prints migration moves with the Unicode arrow `docs/handoff-notes/ → .sdlc/handoff-notes/`, while the PowerShell installer prints the ASCII `docs/handoff-notes/ -> .sdlc/handoff-notes/`. The two surfaces should read identically. This is the same divergence the migrate-sdlc scripts inherit, so fixing the arrow convention in all four files (two installers + two migrate scripts) closes UX-006 and UX-007 together.

## Location

`install.sh:120-138` (uses `→`) vs `install.ps1:99-117` (uses `->`)

## Acceptance Criteria

- [ ] Both installers use the same arrow convention (the established `→`)
- [ ] The arrow convention is consistent across all four files (`install.sh`, `install.ps1`, `migrate-sdlc.sh`, `migrate-sdlc.ps1`)

## Notes

**Found by:** UX/SWE review of M19 SDLC boundary.
**Recommendation:** Standardize on the Unicode `→` across both installers and both migrate scripts.
