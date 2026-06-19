# BUG: docs/security/ subfolder is migrated wholesale, capturing any user content under that name (SR-003 edge / T-002)

**Type:** bug
**Expert:** swe
**Status:** backlog
**Severity:** should-fix

## Description

The migration moves the entire `docs/security/` directory (a canonical subfolder per ADR-M19-3) including files the user authored there. The installer scaffolds `.sdlc/security/` (`install.sh:155`), so `docs/security/` only exists if a user created it — meaning its contents are unlikely to be toolkit specs. Reproduced: `docs/security/my-threat-notes.md` was relocated to `.sdlc/security/`. This is lower risk than the draft glob because "security/" is a named canonical folder, but it still moves unlisted user files. The collision guard does NOT protect here — it only fires when `.sdlc/security/` already exists as a directory, not per-file.

## Location

`agents/scripts/migrate-sdlc.sh:130-132` and `agents/scripts/migrate-sdlc.ps1:154-159`

## Acceptance Criteria

- [ ] Either the subfolder move is restricted to known spec filenames within research/security/runbooks rather than the whole tree, or the migrate-sdlc workflow prompt documents loudly that these three subfolders are claimed in full so the user is warned before running
- [ ] The chosen behavior is consistent across the bash and PowerShell scripts

## Notes

**Found by:** Security/SWE review of M19 SDLC boundary.
**Recommendation:** Restrict the subfolder move to known spec filenames, or warn loudly that the subfolders are claimed in full.

**Triage (M19 close-out, 2026-06-19):** Deliberately deferred, not fixed in M19. The two acceptance options are not equal: the `research/`, `security/`, `runbooks/` subfolders legitimately hold **free-form, arbitrarily-named** spec content (research summaries, runbooks), so filtering by "known spec filenames" (option a) would break legitimate migration — there is no fixed filename set to match. The viable fix is option (b): have `migrate-sdlc` print a loud, up-front notice that these three named subfolders are claimed **in full** and moved wholesale, so a user who repurposed `docs/security/` is warned before running. Current behavior is contract-conformant (the canonical spec inventory in `.sdlc/architecture.m19-draft.md`, ADR-M19-3, explicitly claims these three folders), so this is an enhancement, not a boundary violation — distinct from the draft-glob wildcard bug (swe-bug-096), which matched arbitrary user files and WAS fixed. Left as a tracked, non-blocking follow-up.
