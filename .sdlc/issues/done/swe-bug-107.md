# BUG: overview.md links readers to docs/architecture.md, which no longer exists after M19 moved it to .sdlc/architecture.md (DOC-011, DOC-015)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** must-fix

## Description

M19's canonical inventory moved `architecture.md` from `docs/` to `.sdlc/` (verified: `docs/architecture.md` is absent, `.sdlc/architecture.md` exists). Three reader-facing "follow the link to / read the architecture document (docs/architecture.md)" pointers are now dead.

Note: per ADR-M19-1, `docs/agent-reference.md` correctly STAYS in `docs/`, so the agent-reference links (`overview.md:93`, `contributing.md`) are fine — do not touch those.

## Location

`docs/guides/overview.md:3, :87, :92`

## Acceptance Criteria

- [ ] The three `docs/architecture.md` pointers are repointed to `.sdlc/architecture.md`
- [ ] The agent-reference links (`overview.md:93`, `contributing.md`) are left unchanged

## Notes

**Found by:** Documentation review of M19 SDLC boundary.
**Recommendation:** Repoint the three architecture links to `.sdlc/architecture.md`; leave agent-reference links alone.
