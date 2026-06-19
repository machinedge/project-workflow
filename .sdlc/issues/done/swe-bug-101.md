# BUG: Migration draft glob is over-broad — relocates user-owned files it does not own (SR-003 / T-002 violation)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** must-fix

## Description

Both scripts move ANY `docs/*-draft.md`, not only the canonical `<spec>.*-draft.md` set that the architecture inventory (`.sdlc/architecture.m19-draft.md:27`, ADR-M19-3) and SR-003 require. SR-003 mandates "No broad globs that could match user files" and that any unlisted docs/ file is "provably untouched." Reproduced in a sandbox: a user file `docs/my-product-design-draft.md` was silently relocated to `.sdlc/` (exit 0, no warning). The bash code comment even admits the deviation ("accept any *-draft.md under docs/ as spec drafts") and the ps1 comment claims "all draft files under docs/ are migration-owned."

## Location

`agents/scripts/migrate-sdlc.sh:117-124` and `agents/scripts/migrate-sdlc.ps1:138-148`

## Acceptance Criteria

- [ ] The glob is restricted to the canonical-spec-prefixed pattern only — basename matches `^(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\..*-draft\.md$`
- [ ] A user's arbitrary `*-draft.md` stays in `docs/`
- [ ] The same fix is applied to `verify_clean` / `Test-Clean`, which use the same broad filter and would otherwise report a false "not clean" on a user draft
- [ ] `qa-feature-094`'s SR-003 fixture is re-run after the fix

## Notes

**Found by:** Security/SWE review of M19 SDLC boundary.
**Recommendation:** Restrict the glob and the verify filter to canonical spec prefixes; re-run the SR-003 fixture.
