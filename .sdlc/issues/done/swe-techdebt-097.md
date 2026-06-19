# TECHDEBT: No M19 test plan exists; the QA verification issue references paths and procedures that are not present

**Type:** techdebt
**Expert:** swe
**Status:** done
**Severity:** must-fix

## Description

`.sdlc/test-plan.md` is the old Expert Skill Restructure plan (its Scope line reads "Milestones M3, M4, M5"); it has zero M19 content, no SDLC-boundary test matrix, and none of the ATP-1..ATP-4 procedures that `qa-feature-094` says it "drives." The QA issue also cites `docs/test-plan.md`, `docs/security-requirements.md`, and `docs/architecture.m19-draft.md` (8 references total) — all of which no longer exist at those paths after M19's own repoint moved specs to `.sdlc/`. The recorded verification therefore could not have run against the artifacts it claims.

A re-run of the core checks (audit grep, collision, idempotency, fail-loud, user-file safety) passes except the SR-003 draft-glob defect (see related must-fix). The boundary itself is largely sound; the gap is that the formal test plan and the verification record are not trustworthy as written.

## Location

`.sdlc/test-plan.md` (stale) and `.sdlc/issues/done/qa-feature-094.md`

## Acceptance Criteria

- [ ] An M19-scoped test plan is authored at `.sdlc/test-plan.md` (the SR-001..SR-008 controls supply the test matrix)
- [ ] `qa-feature-094`'s input paths are repointed to `.sdlc/`
- [ ] The acceptance procedures are re-run against the real artifacts and the record reflects what was actually run

## Notes

**Found by:** SWE/QA review of M19 SDLC boundary.
**Recommendation:** Author M19 test plan, repoint QA issue inputs, re-run acceptance against real artifacts.
