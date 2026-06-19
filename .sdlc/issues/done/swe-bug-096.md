# BUG: migrate-sdlc moves ANY docs/*-draft.md, including user files — SR-003 / architecture draft-glob contract violation

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** must-fix

## Description

The draft glob in the migration scripts is unfiltered. Both the architecture (`architecture.m19-draft.md` line 27: drafts are `<spec>.*-draft.md` where `<spec>` is in the canonical list) and the script's own comment (sh line 120-121) say only canonical-spec drafts should move, but the code accepts every `*-draft.md`. Reproduced: a user file named `docs/my-blog-post-draft.md` was moved into `.sdlc/` alongside the real specs. This violates SR-003 ("No broad globs that could match user files; any unlisted file in docs/ is provably untouched").

## Location

`agents/scripts/migrate-sdlc.sh:117-124` and `agents/scripts/migrate-sdlc.ps1:138-148`

## Acceptance Criteria

- [ ] Each matched draft's basename is gated against the canonical spec prefixes (`architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan`) before migrating; anything else is skipped
- [ ] The same filter is applied in both the bash and PowerShell paths to keep SR-006 parity
- [ ] The verify step is updated to match so it does not flag the now-correctly-skipped user drafts
- [ ] A user file such as `docs/my-blog-post-draft.md` stays in `docs/` after migration

## Notes

**Found by:** SWE/architecture review of M19 SDLC boundary.
**Recommendation:** Gate basenames against the canonical spec prefix set in both harnesses, and align the verify step.
