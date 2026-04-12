# Handoff Note: Migration Logic + Brief Bug Fix

**Issues:** swe-bug-080, swe-feature-076, swe-feature-077

## What Was Accomplished

Fixed the last M13 stale path reference (`issues/` → `.workflow/issues/` in the project brief Constraints section). Implemented migration logic in both `install.sh` and `install.ps1` that detects old directory layouts (`docs/handoff-notes/`, top-level `issues/`) and moves artifacts to `.workflow/`. The `.workflow/` scaffold now runs unconditionally after migration, ensuring completeness in all scenarios.

## Acceptance Criteria Status

### swe-bug-080
- [x] `docs/project-brief.md` Constraints section references `.workflow/issues/` instead of `issues/`

### swe-feature-076
- [x] Script detects old structure by checking for `docs/handoff-notes/` or top-level `issues/`
- [x] Moves `docs/handoff-notes/` to `.workflow/handoff-notes/`
- [x] Moves `docs/interview-notes*.md` to `.workflow/`
- [x] Moves `docs/lessons-log.md` to `.workflow/`
- [x] Moves `docs/research-*.md` to `.workflow/`
- [x] Moves `issues/` to `.workflow/issues/`
- [x] Does NOT move planning docs or unknown user files
- [x] Idempotent: running twice doesn't fail or duplicate files
- [x] Prints clear output showing what was migrated

### swe-feature-077
- [x] Same detection and migration behavior as `install.sh`
- [x] Moves all artifact categories to `.workflow/`
- [x] Does NOT move planning docs or unknown user files
- [x] Idempotent
- [x] Prints clear output showing what was migrated

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Scaffold runs unconditionally (not in else branch) | After migration, the old dirs are gone but `.workflow/` may be incomplete. Unconditional scaffold with `mkdir -p` is naturally idempotent and fills gaps. |
| `mv` for common case, `cp -R && rm -rf` for merge | `mv` is atomic and fast. The merge fallback uses `&&` to prevent data loss on copy failure. |

## Problems Encountered

None. All three tasks were straightforward.

## Scope Changes

Bundled three issues (swe-bug-080 + swe-feature-076 + swe-feature-077) into one session to compress the schedule. No scope creep within any individual issue.

## Files Created or Modified

- `docs/project-brief.md` — fixed `issues/` → `.workflow/issues/` in Constraints (swe-bug-080)
- `targets/ide/install.sh` — replaced migration placeholder with real migration logic + helpers (swe-feature-076)
- `targets/ide/install.ps1` — ported migration logic from bash to PowerShell (swe-feature-077)

## What the Next Session Needs to Know

- **swe-feature-078 is the remaining M14 task:** Run the migration on this project itself and verify everything works. This is the only task left before M14 is complete.
- The install scripts now handle three scenarios: fresh install (no old dirs), migration (old dirs detected), and re-run (already migrated). All tested on bash; PowerShell syntax-checked only.
- The `install.ps1` port has NOT been functionally tested — consistent with the project's existing Windows testing gap.

## Open Questions

- [ ] swe-feature-078: Should migration on this project happen via `install.sh` or manually? The install script would also reinstall all toolkit files, which may or may not be desired.
