# Update installer to stop seeding specs into docs/ and create .sdlc/ spec locations

**Type:** feature
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:**
**Detail level:** implementation-ready

## User Story

As a user installing the toolkit into a fresh project, I want the installer to produce a `docs/` containing only user-facing material and to set up `.sdlc/` as the home for expert specs, so that a brand-new project already obeys the SDLC boundary with no manual cleanup.

## Description

`install.sh` and `install.ps1` currently ensure `docs/` always exists "for core planning docs (project-brief, roadmap, architecture, etc.)" and the comment implies specs belong there. Update both scripts so a fresh install creates only the user-facing `docs/` set and creates the needed `.sdlc/` spec home alongside the existing `issues/`, `handoff-notes/`, `lessons-log.md` scaffolding. Keep bash and PowerShell behavior identical (M14 parity discipline). This task does NOT migrate existing specs — that is the `migrate-sdlc` workflow (swe-feature-093).

## Files to Create or Modify

| Path | Action | What changes |
|------|--------|--------------|
| `install.sh` | modify | line 85 comment (replace "architecture, etc." text with user-facing-only); keep `mkdir -p "$TARGET/docs"` at line 86 unchanged; in the `.sdlc/` structure block (lines 142-150, after the four `issues/` `mkdir -p` lines) add `mkdir -p "$TARGET/.sdlc/research"`, `.sdlc/security`, `.sdlc/runbooks` |
| `install.ps1` | modify | line 56 comment (same user-facing-only fix); keep the `docs/` `New-Item` at line 57 unchanged; append `".sdlc/research"`, `".sdlc/security"`, `".sdlc/runbooks"` to the `$dir` array (lines 123-130) — identical end state to `install.sh` |

The current `install.sh` block to change (lines 85-86):
```sh
# docs/ always needed for core planning docs (project-brief, roadmap, architecture, etc.)
mkdir -p "$TARGET/docs"
```
Becomes a comment that reflects user-facing-only:
```sh
# docs/ holds user-facing material only (guides/, README.md, project-brief.md,
# roadmap.md). These files are authored later by the user/PM (e.g. brief via
# pm-vision) — the installer seeds NO spec files here. Expert specs live in .sdlc/.
mkdir -p "$TARGET/docs"
```
Keep the `mkdir -p "$TARGET/docs"` exactly as-is — the installer creates only the empty `docs/` directory today and must continue to. It does NOT create `docs/guides/` and does NOT seed any of the four user-facing files; those are authored on demand by skills and the user, not by the installer. The single behavioral fix in `docs/` is the comment.

The `.sdlc/` structure block (`install.sh` lines 142-150) today creates `issues/{backlog,planned,in-progress,done}`, per-expert `handoff-notes/` (the 8 experts: `pm swe qa devops system-architect security-engineer ux doc`), and seeds `lessons-log.md`. It does NOT create any spec subfolder. Add exactly the three spec subfolders from the canonical inventory (`docs/architecture.m19-draft.md` → "Subfolders: research/, security/, runbooks/") immediately after the `issues/` block, matching the existing one-line-per-`mkdir -p` style:
```sh
mkdir -p "$TARGET/.sdlc/research"
mkdir -p "$TARGET/.sdlc/security"
mkdir -p "$TARGET/.sdlc/runbooks"
```
Do NOT seed any spec FILES — spec files (`architecture.md`, `test-plan.md`, etc.) live flat in `.sdlc/` and are authored on demand by skills. The installer only creates the three subfolder directories so specs that belong in a subfolder have a destination.

## Interfaces and Data Models

Fresh-install end state (both harnesses must produce this). This reflects what the
installer ACTUALLY creates — an empty `docs/` directory (no files, no `guides/`
seeded) and the `.sdlc/` scaffolding. The four user-facing docs are NOT seeded by
the installer; they are authored later by the user/PM (brief via pm-vision, roadmap
via pm-roadmap, etc.):

```
docs/                  (created empty — user-facing material is authored here later)
  # The installer seeds NOTHING into docs/. No guides/, README.md, project-brief.md,
  # or roadmap.md — those are authored on demand by skills/the user.
  # The hard invariant: NO spec file (architecture.md, test-plan.md,
  # security-requirements.md, etc.) is ever seeded into docs/ on a fresh install.

.sdlc/
  issues/{backlog,planned,in-progress,done}/   (existing)
  handoff-notes/{pm,swe,qa,devops,system-architect,security-engineer,ux,doc}/  (existing)
  lessons-log.md                                (existing, seeded)
  research/                                     (NEW — spec subfolder, empty)
  security/                                     (NEW — spec subfolder, empty)
  runbooks/                                     (NEW — spec subfolder, empty)
  # .sdlc/ is the home for specs (architecture.md, test-plan.md, …); spec FILES
  # live flat in .sdlc/ and are authored on demand — the installer seeds no spec files.
```

The existing artifact-migration block (`migrate_dir`/`migrate_file` for handoff-notes, issues, lessons-log, interview-notes, research) must keep working unchanged — this task does NOT add spec migration.

## Implementation Outline

1. In `install.sh`, fix the line ~85 comment so it no longer lists "architecture, etc." under `docs/`; state `docs/` is user-facing-only and that the installer seeds no files there (see the exact replacement comment above).
2. Keep `mkdir -p "$TARGET/docs"` exactly as-is — `docs/` must still exist as an empty directory. Do NOT add seeding of `guides/`, `README.md`, `project-brief.md`, or `roadmap.md`; those are authored later by skills/the user. Do NOT seed any spec file into `docs/`.
3. In the `.sdlc/` structure block (`install.sh` lines ~142-150), after the four `issues/` `mkdir -p` lines, add exactly these three spec-subfolder lines in the same style — and ONLY these three, taken from the canonical inventory in `docs/architecture.m19-draft.md`:
   ```sh
   mkdir -p "$TARGET/.sdlc/research"
   mkdir -p "$TARGET/.sdlc/security"
   mkdir -p "$TARGET/.sdlc/runbooks"
   ```
   Do NOT create any spec files (`architecture.md`, `test-plan.md`, etc.) — those live flat in `.sdlc/` and are authored on demand by skills. The `handoff-notes/` and `lessons-log.md` scaffolding already present stays unchanged.
4. Confirm the existing migration block (handoff-notes, issues, lessons-log, interview/research notes) is untouched and still runs.
5. Mirror every change into `install.ps1` so the two produce an identical layout (M14 parity). In `install.ps1`: replace the docs/ comment at line ~56 to match, and add the three spec subfolders to the `.sdlc/` structure loop at lines ~123-130 — append `".sdlc/research"`, `".sdlc/security"`, `".sdlc/runbooks"` to the `$dir` array that already lists the four `issues/` paths (each created via `New-Item -ItemType Directory ... -Force`).
6. Verify idempotency: re-running over an installed project must not clobber user content in `docs/` or `.sdlc/`. (All adds use `mkdir -p` / `New-Item -Force`, which are no-ops on existing dirs.)

## Acceptance Criteria

- [ ] A fresh `install.sh` run creates the `docs/` directory and seeds NO files into it — in particular NO spec file (`architecture.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, etc.) is present in `docs/`. (The four user-facing docs — `guides/`, `README.md`, `project-brief.md`, `roadmap.md` — are authored later by the user/PM via skills; the installer does NOT seed them.)
- [ ] A fresh `install.sh` run creates the three `.sdlc/` spec subfolders `research/`, `security/`, `runbooks/` (alongside the existing `issues/{backlog,planned,in-progress,done}`, per-expert `handoff-notes/`, and seeded `lessons-log.md`). No spec FILES are seeded into `.sdlc/`.
- [ ] Installer comments that reference "architecture, etc." under `docs/` are corrected to state `docs/` is user-facing-only and that the installer seeds no files there
- [ ] `install.ps1` produces identical results to `install.sh` (same `docs/` and `.sdlc/` layout, including the three new spec subfolders)
- [ ] Existing artifact-migration block (handoff-notes, issues, lessons-log, interview/research notes) is left functioning — this task does NOT add spec migration (that is swe-feature-093)
- [ ] Re-running the installer over an already-installed project does not clobber user content in `docs/` or `.sdlc/`

## Test Specification

**Test instrument:** ATP-1 from `docs/test-plan.md` (fresh install into a temp dir) — no unit harness.

All checks below run against a fresh `install.sh` into a clean temp dir `A` (`./install.sh "$A"`). Each row is an exact runnable command with an objective pass condition (command exits 0 / the grep matches as stated).

| Case | Runnable check | Pass condition |
|------|----------------|----------------|
| docs/ created | `test -d "$A/docs"` | exit 0 — `docs/` directory exists |
| No spec seeded in docs/ | `! ls "$A/docs"/*.md 2>/dev/null \| grep -E '(architecture\|pipeline\|components\|documentation-plan\|test-plan\|security-requirements\|ux-guidelines\|task-detail-standard\|env-context\|release-plan)\.md'` | exit 0 — no canonical spec file present in `docs/` |
| docs/ seeds nothing | `[ -z "$(ls -A "$A/docs" 2>/dev/null)" ]` | exit 0 — installer leaves `docs/` empty (no files, no `guides/` seeded) |
| .sdlc/ spec subfolders | `test -d "$A/.sdlc/research" && test -d "$A/.sdlc/security" && test -d "$A/.sdlc/runbooks"` | exit 0 — all three spec subfolders exist |
| .sdlc/ existing scaffolding | `test -d "$A/.sdlc/issues/backlog" && test -d "$A/.sdlc/issues/planned" && test -d "$A/.sdlc/issues/in-progress" && test -d "$A/.sdlc/issues/done" && test -d "$A/.sdlc/handoff-notes/pm" && test -f "$A/.sdlc/lessons-log.md"` | exit 0 — issues buckets, per-expert handoff-notes, and seeded lessons-log present |
| No spec FILE seeded in .sdlc/ | `! ls "$A/.sdlc"/*.md 2>/dev/null \| grep -E '(architecture\|test-plan\|security-requirements\|ux-guidelines\|pipeline\|release-plan)\.md'` | exit 0 — only `lessons-log.md` is seeded; no spec file |
| Re-run idempotent | `echo user > "$A/docs/myfile.md"; echo spec > "$A/.sdlc/myspec.md"; ./install.sh "$A"; grep -qx user "$A/docs/myfile.md" && grep -qx spec "$A/.sdlc/myspec.md"` | exit 0 — both user files still present and byte-identical |
| Comment fix | `! grep -q 'architecture, etc.' "$A/install.sh" 2>/dev/null` (run against the repo `install.sh`, not the target) | exit 0 — the misleading comment is gone; comment states user-facing-only |
| PS parity | `pwsh ./install.ps1 -Target "$B"`; then `diff <(cd "$A" && find docs .sdlc -print \| sort) <(cd "$B" && find docs .sdlc -print \| sort)` | empty diff — `install.ps1` produces an identical `docs/` and `.sdlc/` tree, including `research/`, `security/`, `runbooks/` |

## Security Constraints

- [SR-004] Installer re-run is idempotent — a second run does not clobber user content in `docs/` or `.sdlc/` — from `docs/security-requirements.md` (T-003).
- [SR-005] Filesystem operations quote path variables and operate on the validated `$TARGET`; no destructive op against an empty/relative path — from `docs/security-requirements.md` (T-004). Preserve the existing quoting; do not regress it.
- [SR-006] `install.ps1` produces an identical end state to `install.sh` for the same input — from `docs/security-requirements.md` (T-005).

## Architecture Contracts

- Honor the **boundary contract**: `docs/` = user-facing only; `.sdlc/` = expert specs/plans/session artifacts — from `docs/architecture.m19-draft.md`.
- **Installer scaffolds locations; it does NOT move specs** (ADR-M19-4) — spec migration is the separate `migrate-sdlc` workflow (swe-feature-093).
- Payload paths resolve via `.agents/...` across harnesses; installer-written paths must respect this — from the M19 draft Constraints.
- **Cross-harness parity contract**: `install.ps1` matches `install.sh` (M14 discipline).

## Build / CI Notes

- No compiled artifact. Bash syntax check: `bash -n install.sh`. PowerShell: parse-check `install.ps1` under `pwsh`.
- Tests run on a local dev machine with throwaway temp dirs (`docs/test-plan.md` infrastructure note). `pwsh` on macOS is required for the parity check.

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** none (installer scaffolding is independent of the path-reference repointing; can run in parallel with swe-feature-088, 089, 090, 091)
**Inputs:** `install.sh` (lines ~85-165: docs/ ensure block, migration block, .sdlc/ structure block — already read into this task), `install.ps1` (parallel sections), `docs/architecture.m19-draft.md` boundary contract, `docs/security-requirements.md` SR-004/005/006.
**Out of scope:** The user-side spec migration of an existing project's `docs/ → .sdlc/` specs — that is the `migrate-sdlc` workflow (swe-feature-093). Do not repoint skill/role paths here (swe-feature-088-090). Do not seed empty spec files into `.sdlc/`.
