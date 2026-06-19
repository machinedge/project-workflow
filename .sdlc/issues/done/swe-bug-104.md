# BUG: Collision run prints the contradictory line `Already clean — no specs to migrate.` (UX-009 / UX-011 clarity)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

When a collision occurs, nothing is moved, so RELOCATED stays empty and the report falls into the else-branch and prints `Already clean — no specs to migrate.` immediately before printing `Error: One or more collisions occurred.` Verified by driving the seeded-collision case: the run emits the COLLISION line, then `Already clean — no specs to migrate.`, then the error, then exits 1. Telling the user the project is clean and then that a collision must be resolved is self-contradictory and undercuts the plain-status bar the UX guidelines set (state the fact, then the next step).

## Location

`agents/scripts/migrate-sdlc.sh:193-201` and `agents/scripts/migrate-sdlc.ps1:209-217`

## Acceptance Criteria

- [ ] The `Already clean` message is gated on `COLLISIONS != 1` so it prints only on a genuine clean no-op
- [ ] On a collision, only the collision report and remedy are printed
- [ ] Fix applied consistently in both the bash and PowerShell scripts

## Notes

**Found by:** UX/SWE review of M19 SDLC boundary.
**Recommendation:** Gate the clean message on absence of collisions; print only collision report + remedy on collision.
