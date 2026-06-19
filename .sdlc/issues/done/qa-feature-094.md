# QA: Grep audit and end-to-end verification of the SDLC boundary

**Type:** feature
**Expert:** qa
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:** qa-09

## Description

Verify that the SDLC boundary is fully enforced: no expert-authored spec reference still points at `docs/`, fresh install and migration both land specs in `.sdlc/`, and consumers fail loudly on a missing required spec. This is the systematic grep audit (same playbook as the M13/M14 path work) plus an end-to-end functional check of the installer and the new `migrate-sdlc` workflow. Drive the acceptance test procedures (ATP-1..ATP-4) defined in `docs/test-plan.md` and check the SR-001..SR-008 controls in `docs/security-requirements.md`.

## Scope

- **Grep audit (Test Matrix rows 1-7; the primary instrument).** Run the canonical audit grep from the repo root and triage every hit:
  ```
  grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/ install.sh install.ps1 docs/project-brief.md
  ```
  Pass condition: zero hits, OR every remaining hit is an intentional, documented consume reference (no *authoring* hit may remain). Verifies SR-007.
- **User-facing untouched (row 7).** Confirm `docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md`, `docs/agent-reference.md` references were intentionally left in place — no false-positive repoint.
- **Fresh install (ATP-1, rows 10-11).** Install into a clean temp target; confirm `docs/` holds only the user-facing set and `.sdlc/` holds the spec locations; re-run does not clobber a seeded user file. Verifies SR-004.
- **Migration (ATP-3, rows 12-15).** Seed an existing-style fixture with specs in `docs/`, run `migrate-sdlc`; confirm every listed spec + draft + subfolder moved, user files untouched, a second run is a clean no-op, and a pre-placed `.sdlc/` copy is a reported collision (not clobbered, non-zero exit). Verifies SR-001, SR-002, SR-003, SR-004.
- **Fail-loud (ATP-2, rows 8-9).** With `.sdlc/architecture.md` absent, drive a consumer (widest fan-out) and confirm a clear, named error naming the file + remedy — not a silent skip. Confirm an optional/no-op spec (e.g. UX guideline on a no-UX milestone) is NOT treated as a hard failure. Verifies SR-008.
- **Cross-harness parity (ATP-4, row 16).** Spot-check that `install.ps1` and the PowerShell `migrate-sdlc` entry point match the bash results (run under `pwsh` on macOS; diff the resulting trees). Verifies SR-005, SR-006.

## Acceptance Criteria

- [ ] Grep audit reports zero stale `docs/<spec>.md` authoring references across `agents/`, `install.sh`, `install.ps1`, `docs/project-brief.md` (any remaining consume reference is intentional and documented) — SR-007
- [ ] Fresh install produces a `docs/` containing only `guides/`, `README.md`, `project-brief.md`, `roadmap.md`, and a `.sdlc/` with the spec locations
- [ ] `migrate-sdlc` moves all listed specs (files + `*-draft.md` + `research/`/`security/`/`runbooks/`) `docs/ → .sdlc/`, leaves user files in place, and a re-run is a clean no-op — SR-003, SR-004
- [ ] A `.sdlc/` collision is reported and not clobbered, with a non-zero exit (explicitly not the M14 `rm "$src"` behavior) — SR-001, SR-002
- [ ] A missing required spec at the `.sdlc/` path produces a clear, named fail-loud error (verified for `architecture.md`, the widest-fan-out consumer); an optional/no-op spec absence does not hard-fail — SR-008
- [ ] bash and PowerShell paths produce equivalent results for install and migration — SR-005, SR-006
- [ ] Any defects found are filed as issue files in `.sdlc/issues/backlog/`

## Notes

**Depends on:** swe-feature-088, swe-feature-089, swe-feature-090, swe-feature-091, swe-feature-092, swe-feature-093 (verifies the complete delivered surface)
**Inputs:** project brief (always), `docs/test-plan.md` (Test Matrix + ATP-1..ATP-4 + the audit grep), `docs/security-requirements.md` (SR-001..SR-008 checklist), `docs/architecture.m19-draft.md` (canonical spec inventory + boundary/idempotency/fail-loud contracts), `.sdlc/interview-notes-sdlc-boundary.md` (Success criteria + Boundary list), the SWE handoff notes for 088-093, `install.sh`, `install.ps1`, the `migrate-sdlc` scripts (`agents/scripts/migrate-sdlc.sh`/`.ps1`).
**Test infrastructure:** local dev machine with throwaway temp dirs; `pwsh` on macOS for the parity spot-check (per `docs/test-plan.md`). No emulator/CI rig needed.
