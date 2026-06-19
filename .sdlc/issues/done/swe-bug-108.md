# BUG: overview.md 'Where state lives' describes the docs/ vs .sdlc/ boundary backwards (DOC-010, DOC-011)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** must-fix

## Description

Line 67 lists "the architecture (docs/architecture.md), the test plan" among files that "live here" in `docs/`. M19's entire purpose was to make `docs/` user-facing-only and relocate expert specs (architecture, test-plan, security-requirements, ux-guidelines, documentation-plan, etc.) to `.sdlc/`. As written, the guide teaches a newcomer the new boundary inverted. This is the most load-bearing accuracy fix because the guide is explaining the exact contract this milestone shipped.

## Location

`docs/guides/overview.md:67`

## Acceptance Criteria

- [ ] The section is rewritten so `docs/` holds only guides + README + project-brief + roadmap (+ agent-reference)
- [ ] `.sdlc/` is described as holding the specs/plans/drafts plus issues, handoff notes, and lessons log
- [ ] The architecture and test plan are no longer listed as living in `docs/`

## Notes

**Found by:** Documentation review of M19 SDLC boundary.
**Recommendation:** Rewrite "Where state lives" to state the correct docs/ vs .sdlc/ boundary.
