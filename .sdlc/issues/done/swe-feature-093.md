# Add migrate-sdlc workflow that relocates an existing project's specs docs/ → .sdlc/

**Type:** feature
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:**
**Detail level:** implementation-ready

## User Story

As a user with an existing project whose specs still live in `docs/`, I want a `migrate-sdlc` workflow that moves my spec artifacts into `.sdlc/` and confirms a clean end state, so that I can adopt the new boundary safely without hand-moving files or risking data loss.

## Description

Add a new `migrate-sdlc` workflow that owns the user-side migration: it relocates the canonical spec artifacts from `docs/` to `.sdlc/`, then verifies the result. It must be idempotent (safe to re-run) and must only move known artifacts by name — leaving everything else in `docs/` untouched. Reuse the M14 `migrate_file`/`migrate_dir` *move + idempotency* structure, but **deviate from its collision behavior**: M14 runs `rm "$src"` when the destination already exists, silently discarding the source — a data-loss bug. On a destination collision this workflow must leave the source untouched, print both paths, and exit non-zero (Gate 2 decision). Provide both bash and PowerShell so it works across the toolkit's supported harnesses.

## Files to Create or Modify

| Path | Action | What changes |
|------|--------|--------------|
| `agents/scripts/migrate-sdlc.sh` | create | bash entry point: relocate canonical specs `docs/ → .sdlc/`, idempotent, collision-safe, verify + report |
| `agents/scripts/migrate-sdlc.ps1` | create | PowerShell entry point producing identical behavior |
| `docs/guides/maintenance.md` (or the existing maintenance/usage guide) | modify | document how to invoke `migrate-sdlc` after re-installing |

(Place the scripts in `agents/scripts/` — the toolkit's "shell scripts for mechanical ops" home. The installer already symlinks/copies `agents/scripts/`; no installer change is needed here, that scaffolding is swe-feature-092.)

## Interfaces and Data Models

**Canonical spec inventory** (the only artifacts the workflow moves — from `docs/architecture.m19-draft.md`):

```
FILES (move docs/<f> → .sdlc/<f> when present; each optional):
  architecture.md  pipeline.md  components.md  documentation-plan.md
  test-plan.md  security-requirements.md  ux-guidelines.md
  task-detail-standard.md  env-context.md  release-plan.md
DRAFT GLOBS (move each match):
  docs/architecture.*-draft.md   docs/pipeline.*-draft.md   (any docs/<spec>.*-draft.md)
SUBFOLDERS (move docs/<d>/ → .sdlc/<d>/ when present):
  research/  security/  runbooks/
NEVER TOUCH (user-facing or unknown):
  docs/guides/  docs/README.md  docs/project-brief.md  docs/roadmap.md
  docs/agent-reference.md  and any file not in the inventory above
```

**`migrate_file` contract (corrected collision behavior — replaces the M14 `rm "$src"` bug):**
```sh
migrate_file(src, dest):
  [ -f "$src" ] || return 0            # absent source = nothing to do (optional)
  if [ -e "$dest" ]; then
      echo "COLLISION: $src and $dest both exist; not moving. Resolve manually." >&2
      COLLISIONS=1                       # record; do NOT rm, do NOT overwrite
      return 0
  fi
  mkdir -p "$(dirname "$dest")"
  mv "$src" "$dest"
  RELOCATED="$RELOCATED $src->$dest"
```
`migrate_dir(src, dest)` follows the same shape for `research/`, `security/`, `runbooks/`: skip if dest exists (collision → report, no merge/clobber), else `mv`.

**Exit + report contract:**
```
- Relocated set printed: "Relocated:" then each src→dest.
- Skipped/collision set printed: "Collisions (resolve manually):" then each path pair.
- Verify step: assert no inventory file/glob/subfolder remains in docs/.
- Exit 0 when no collisions and docs/ is clean of inventory items.
- Exit non-zero when any collision occurred (user must resolve).
- Idempotent: a re-run with nothing left to move prints "already clean" and exits 0.
```

**Target validation (SR-005):** resolve and validate `$TARGET` (repo root); abort with a clear message if empty or not a directory; quote every path expansion; never `rm -rf` an unvalidated/relative path. The workflow performs `mv` only — no `rm` of sources (collision leaves source in place).

## Implementation Outline

1. Create `agents/scripts/migrate-sdlc.sh`. Resolve `$TARGET` (default to repo root / `$PWD`); validate it is a non-empty directory or abort (SR-005). Quote all path variables.
2. Define `migrate_file` and `migrate_dir` with the **corrected collision behavior** above — report + record + skip on dest-exists; never `rm "$src"`, never overwrite.
3. Iterate the canonical file list; for each, `migrate_file "$TARGET/docs/<f>" "$TARGET/.sdlc/<f>"`.
4. Expand the draft globs (`$TARGET/docs/*-draft.md` filtered to `<spec>.*-draft.md`); migrate each match.
5. Iterate the subfolder list (`research`, `security`, `runbooks`); `migrate_dir` each.
6. Verify: re-scan `docs/` for any inventory item; if any remain (and it was not a reported collision), that is a failure to report. Print the relocated set and the collision set.
7. Set exit code: non-zero if any collision occurred; 0 if clean. A re-run finds nothing to move → "already clean", exit 0 (idempotency).
8. Port the identical logic to `agents/scripts/migrate-sdlc.ps1` (Test-Path / Move-Item; same collision report + non-zero exit). Do NOT echo file *contents* (SR: log paths only).
9. Document the invocation in the maintenance/usage guide: re-install to get the new payload, then run `migrate-sdlc` once.
10. Dogfood: run on this repo (its `docs/` holds `architecture.md`, `documentation-plan.md`, `test-plan.md`, `task-detail-standard.md`, plus `architecture.m19-draft.md`) — this is the integration test (self-application note in the M19 draft).

## Acceptance Criteria

- [ ] Running `migrate-sdlc` on a project with specs in `docs/` moves every listed spec artifact (files + `architecture.*-draft.md` drafts + the `research/`/`security/`/`runbooks/` subfolders) into `.sdlc/`
- [ ] User-facing files (`guides/`, `README.md`, `project-brief.md`, `roadmap.md`, `agent-reference.md`) and any unknown/user-created file in `docs/` are left in place, byte-identical
- [ ] The workflow is idempotent: a second run is a no-op that reports an already-clean state (no errors, no duplicate moves)
- [ ] A spec already present at the `.sdlc/` destination is NOT clobbered by a stale `docs/` copy: the source is left in place, both paths are printed, and the run exits non-zero (collision reported, never overwritten or silently discarded — explicitly NOT the M14 `rm "$src"` behavior)
- [ ] The workflow verifies and reports a clean end state: no listed spec remains in `docs/`, and reports the relocated set
- [ ] A bash entry point and a PowerShell entry point exist and produce identical results
- [ ] Documented entry point so a user knows how to invoke it after re-installing
- [ ] Target path is validated and quoted; no destructive op runs against an empty/relative target

## Test Specification

**Test instrument:** ATP-3 + ATP-4 from `docs/test-plan.md`, run against seeded temp-dir fixtures.

**Test fixture:** a `docs/` holding `architecture.md`, `architecture.m1-draft.md`, `pipeline.md`, `components.md`, `documentation-plan.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `task-detail-standard.md`, `research/`, `security/`, `runbooks/`, plus user files `guides/`, `README.md`, `project-brief.md`, `roadmap.md`, and an unknown `docs/notes.md`.

| Case | Input | Expected result |
|------|-------|-----------------|
| Full relocation | run `migrate-sdlc.sh` on the fixture | every inventory file + draft + subfolder now under `.sdlc/`, none under `docs/`; exit 0 |
| User files untouched (SR-003) | after run, compare `docs/guides/`, `README.md`, `project-brief.md`, `roadmap.md`, `notes.md` | byte-identical, still in `docs/` |
| Idempotent re-run (SR-004) | run a second time | "already clean", no moves, exit 0; `.sdlc/` content byte-identical to after first run |
| Collision no-clobber (SR-001) | pre-place `.sdlc/architecture.md` (different content) AND `docs/architecture.md`; run | both files' content preserved; collision reported by name; exit non-zero |
| Report completeness (SR-002) | mixed movable + colliding specs | report names relocated set AND collision set; no silent skip |
| Empty/invalid target (SR-005) | invoke with empty target and with a path containing a space | aborts cleanly, performs no move/delete; quoted paths handle the space |
| bash/PS parity (SR-006) | run `migrate-sdlc.ps1` (pwsh) on identical fixture B; diff trees + reports against bash fixture A | identical end state and reports |
| No content echoed | inspect stdout/stderr | only paths printed, never file contents |

## Security Constraints

- [SR-001] On a `.sdlc/` destination collision, do NOT silently overwrite or `rm` the `docs/` source — report the collision and leave both files in place — from `docs/security-requirements.md` (T-001). **This is the explicit deviation from the M14 `rm "$src"` prior art.**
- [SR-002] The verify/report step lists exactly which artifacts were relocated and which were skipped (collision), with no silent skips — (T-001).
- [SR-003] Move ONLY the named spec artifacts + the three subfolders; user-facing and any unlisted file in `docs/` are provably untouched; no broad globs that match user files (the only glob is `<spec>.*-draft.md`) — (T-002).
- [SR-004] Idempotent: a second run is a no-op reporting an already-clean state, no duplicate moves, no clobber of correct `.sdlc/` content — (T-003).
- [SR-005] Quote all path variables; operate on a validated, non-empty target directory; abort cleanly rather than `mv`/`rm` on an empty/relative path; no `rm -rf` on an unvalidated path — (T-004).
- [SR-006] bash and PowerShell entry points produce an identical end state for the same input tree — (T-005).
- (Secrets/Data note: log file paths only; never echo spec file contents.)

## Architecture Contracts

- Honor the **Migration idempotency + no-clobber contract** — reuse the M14 `migrate_file`/`migrate_dir` move+idempotency structure but invert its collision behavior (report + non-zero exit, never `rm "$src"`) — from `docs/architecture.m19-draft.md` and ADR-M19-2/Gate 2 decision 4.
- Use the single **Canonical spec inventory** (ADR-M19-3) — do not invent or widen the moved set; drafts only via the `<spec>.*-draft.md` glob.
- **`migrate-sdlc` is a separate user-run workflow, not folded into the installer** (ADR-M19-4).
- **Cross-harness parity** (M14 discipline). `.sdlc/` is NOT gitignored — the workflow must not add it to `.gitignore` (M19 Constraints).
- Self-application: running this on the dogfood repo (`docs/architecture.md`, `documentation-plan.md`, `test-plan.md`, `task-detail-standard.md`, `architecture.m19-draft.md`) is the M19 integration test.

## Build / CI Notes

- No compiled artifact. Bash syntax check: `bash -n agents/scripts/migrate-sdlc.sh`. PowerShell parse-check under `pwsh`.
- Tests run on a local dev machine with throwaway temp dirs; `pwsh` on macOS required for the parity check (`docs/test-plan.md` infrastructure note).
- No new third-party dependency — POSIX builtins/coreutils (bash) and built-in cmdlets (PowerShell) only (`docs/security-requirements.md` dependency constraint).

## Technical Notes

**Estimated effort:** Large session
**Dependencies:** swe-feature-088, swe-feature-089, swe-feature-090, swe-feature-091, swe-feature-092 (the new payload — repointed references, fail-loud consumers, updated installer — must exist first; the workflow is the supported path to make an existing project consistent with that payload)
**Inputs:** `docs/architecture.m19-draft.md` (canonical inventory + idempotency/no-clobber contract), `docs/security-requirements.md` (SR-001..006), `docs/test-plan.md` (ATP-3, ATP-4), `install.sh` migration block (the `migrate_file`/`migrate_dir` pattern to reuse — but NOT its `rm "$src"` collision behavior), `agents/scripts/` (script home).
**Out of scope:** Rewriting spec content; migrating session artifacts (already done by the installer in M13/M14). Name is `migrate-sdlc` (final, Gate 2 — `sync-sdlc` dropped). Do not gitignore `.sdlc/`. Do not fold migration into the installer.
