# TECHDEBT: migrate-sdlc draft glob is broader than the architecture's canonical inventory specifies

**Type:** techdebt
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

The architecture's canonical spec inventory (`.sdlc/architecture.m19-draft.md`, lines 27 and 81) scopes draft migration to `<spec>.*-draft.md` — only drafts of canonical spec files. Both scripts instead move ANY `docs/*-draft.md` (the bash comment at lines 119-120 and the PS comment at line 138 explicitly acknowledge this widening). This is a real, if small, deviation from ADR-M19-3's single-canonical-inventory contract: a user draft named e.g. `docs/onboarding-draft.md` would be relocated to `.sdlc/` even though it is not a spec. Bash and PowerShell agree with each other (no cross-harness drift), so the only issue is conformance to the stated contract. The doc and the code should state the same rule.

## Location

`agents/scripts/migrate-sdlc.sh:117-124` and `agents/scripts/migrate-sdlc.ps1:138-142`

## Acceptance Criteria

- [ ] Either the glob is tightened to filter basenames against the canonical spec prefixes (`architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan`), or the architecture draft is updated to record that the accepted scope is all `*-draft.md` under docs/
- [ ] The doc and the code state the same rule

## Notes

**Found by:** SWE/architecture conformance review of M19 SDLC boundary.
**Recommendation:** Reconcile code and architecture so the draft-migration rule matches; relates to the SR-003 must-fix bug.
