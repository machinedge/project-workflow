# Security Requirements

> **Draft — M19 (SDLC Boundary), Security lens.** Non-interactive enrichment draft for the human gate. Scope is one milestone, not the whole toolkit.

## Bottom line

M19 is a file-relocation refactor of the toolkit itself: it repoints spec paths from `docs/` to `.sdlc/`, updates the installer's scaffolding, and adds a `migrate-sdlc` workflow that moves an existing project's spec files. There is **no network edge, no authentication/authorization, no PII, no money, and no runtime service** in this milestone. The entire credible threat surface is one thing: **shell scripts (`install.sh`/`install.ps1` and the new `migrate-sdlc` scripts) performing `mv`/`rm`/`cp` against a user's working repository.** The asset worth protecting is the integrity of the user's files — their hand-edited specs and their unrelated `docs/` content. Get the file operations right (idempotent, collision-safe, scoped to known names) and this milestone is secure. The requirements below are deliberately short and concentrated on that one boundary.

## Scope

Covers **M19 — SDLC Boundary** only. The milestone's tasks:

- swe-feature-088/089/090: repoint spec path references in skills, roles, runbooks, accelerators from `docs/` to `.sdlc/` (instruction-text edits).
- swe-feature-091: make consumers fail loudly when a required spec is missing at the new path.
- swe-feature-092: update `install.sh`/`install.ps1` to stop seeding specs into `docs/` and create `.sdlc/` spec locations.
- swe-feature-093: new `migrate-sdlc` workflow (bash + PowerShell) relocating an existing project's specs `docs/ → .sdlc/`, idempotent, collision-safe, verifies a clean end state.
- qa-feature-094: grep audit + end-to-end install/migration/fail-loud verification.

This document is additive: later milestones extend it; nothing here describes prior milestones.

## Trust Boundaries and Assets

**Process boundary — toolkit script vs. user's repository.** The only boundary that matters here. `install.sh`, `install.ps1`, and the new `migrate-sdlc` scripts run on the user's machine with the user's permissions and write to the user's project tree (`$TARGET`). Everything else in M19 is text edits to instruction files, which carry no execution privilege of their own.

**Assets:**

- **User's hand-edited spec files** (`architecture.md`, `security-requirements.md`, `ux-guidelines.md`, `pipeline.md`, `components.md`, `test-plan.md`, drafts, and the `research/`/`security/`/`runbooks/` subfolders). These hold real engineering work and must not be lost, overwritten, or duplicated during the move.
- **User's unrelated `docs/` content** (user-facing guides, README, project-brief, roadmap, and any file the user created that the migration does not own). Must be left untouched.
- **Integrity of the boundary itself** — the instruction text that tells every expert where to read/write specs. A wrong or partial repoint silently sends an expert to the wrong path.

**Actors:**

- **The user running the installer/migration** — trusted, but may run on a dirty tree, re-run the script, or have a partially-migrated project. Not malicious; the threats are accidents, not attacks.
- **No anonymous, remote, or multi-tenant actor exists in this milestone.** There is no abuser persona to model here beyond "the script does the wrong thing to honest input." Recording that absence is itself the finding — do not invent attackers to justify controls.

## Threat Model

| ID | Threat | Boundary/Asset | Impact | Likelihood | Mitigated By |
|----|--------|----------------|--------|------------|--------------|
| T-001 | Migration overwrites or silently discards a spec that already exists at the `.sdlc/` destination, losing the user's newer hand edits | Process boundary / hand-edited spec files | High — irreversible loss of engineering work | Medium (collisions are normal on re-installed or partially-migrated projects) | SR-001, SR-002 |
| T-002 | Migration moves files it doesn't own — a `docs/` file the user created, or a glob that matches too widely — relocating or deleting unrelated content | Process boundary / unrelated `docs/` content | High — user loses or misplaces their own files | Medium | SR-003 |
| T-003 | Re-running the migration is not idempotent: a second run errors, double-moves, or clobbers the now-correct `.sdlc/` state | Process boundary / spec files | Medium — broken/confusing state, possible loss | Medium (users re-run installers routinely) | SR-004 |
| T-004 | Path handling mishaps — unquoted `$TARGET`, paths with spaces, or a relative/empty target — cause `mv`/`rm` to act on the wrong directory | Process boundary / entire repo | High — destructive operation outside intended scope | Low (paths are internal, but `rm -rf` raises the blast radius) | SR-005 |
| T-005 | bash and PowerShell implementations diverge, so one harness migrates correctly and the other loses or mis-places files | Process boundary / spec files | Medium — platform-dependent data loss | Medium (two hand-written implementations of the same logic) | SR-006 |
| T-006 | A spec path is repointed in some references but not others; an expert reads/writes the old `docs/` path and works on a stale or empty spec without anyone noticing | Boundary integrity / spec correctness | Medium — silent wrong-path reads, wrong outputs | Medium (references are spread across roles, skills, both runbooks, both accelerators) | SR-007, SR-008 |

Threats deliberately **not** modeled (out of scope for M19, recorded so the gate sees they were considered): network/transport security, authentication, authorization/RBAC, injection from untrusted input, secrets storage, dependency supply chain. M19 adds no network surface, no auth, no new third-party dependencies, and processes no untrusted external input — the scripts act only on the local project's own files at the user's own privilege.

## Security Requirements

| ID | Requirement (verifiable control) | Layer | Verifies Threat | How to Verify |
|----|----------------------------------|-------|-----------------|---------------|
| SR-001 | When a spec already exists at its `.sdlc/` destination, the migration must **not** silently overwrite or `rm` the `docs/` source. It reports the collision and leaves both files in place (or refuses that one move) so the user can resolve it. | migration script (bash + ps1) | T-001 | Seed `docs/architecture.md` AND `.sdlc/architecture.md` with different content; run migration; assert neither file's content was lost and the run reported the collision by name. |
| SR-002 | The migration's verify/report step lists exactly which artifacts it relocated and which it skipped (e.g. on collision), with no silent skips. | migration script | T-001 | Run with a mix of movable and colliding specs; assert the printed report names both categories. |
| SR-003 | The migration moves **only** the named spec artifacts (the explicit M19 list of files + the `research/`/`security/`/`runbooks/` subfolders). User-facing files (`guides/`, `README.md`, `project-brief.md`, `roadmap.md`) and any unlisted file in `docs/` are provably untouched. No broad globs that could match user files. | migration script | T-002 | Place a user-created `docs/notes.md` and the user-facing set; run migration; assert all are byte-identical and still in `docs/` afterward. |
| SR-004 | The migration is idempotent: a second run is a no-op that reports an already-clean state with no errors, no duplicate moves, and no clobber of the correct `.sdlc/` content. | migration script | T-003 | Run migration twice; assert second run exits 0, moves nothing, and `.sdlc/` content is byte-identical to after the first run. |
| SR-005 | All filesystem operations quote their path variables and operate on an explicit, validated target; the script aborts with a clear message rather than running `mv`/`rm` if the target path is empty or not a directory. No `rm -rf` is issued against an unvalidated or relative path. | migration script | T-004 | Invoke with an empty/missing target and with a path containing a space; assert it aborts cleanly and performs no deletion; grep the scripts to confirm every `$TARGET`/path expansion is quoted. |
| SR-006 | The bash and PowerShell migration entry points produce an **identical** end state for the same input tree (same files moved, same files left, same collisions reported). | migration script (parity) | T-005 | Run both implementations against identical fixture trees on their respective platforms (or the PowerShell one under pwsh) and diff the resulting trees + reports. |
| SR-007 | After the repoint tasks, no expert-authored spec reference in any role, skill, runbook, or accelerator still points at `docs/<spec>.md`. The grep audit returns zero stale spec-path hits. | instruction text / CI-style grep | T-006 | `grep -rEn 'docs/(architecture|security-requirements|ux-guidelines|pipeline|components|test-plan|documentation-plan|task-detail-standard)' agents/ .agents/ workflows/` returns nothing (this is qa-feature-094's audit). |
| SR-008 | A consumer that requires a spec fails **loudly** when that spec is absent at the `.sdlc/` path — naming the missing file and the remedy — rather than degrading silently. Genuinely optional artifacts are exempt and must not be made hard failures. | consumer instruction text | T-006 | Remove a required spec from `.sdlc/`; run the consuming step; assert it stops and names the file + remedy. Confirm an optional-artifact case still proceeds. |

## Secrets and Data

**No secrets are introduced, handled, stored, or transported in M19.** The scripts touch no credentials, tokens, keys, or environment secrets. The only sensitive data is the user's own spec content, and the protection required is integrity (do not lose/overwrite/leak it across paths), not confidentiality — covered by SR-001 through SR-004. Nothing in this milestone should be logged beyond the file paths being moved (which are non-sensitive project paths). Do not echo file *contents* during migration.

## Dependency Constraints

**M19 adds no new third-party dependencies.** The migration scripts must use only POSIX shell builtins / coreutils (bash side) and built-in cmdlets (PowerShell side), consistent with the existing `install.sh`/`install.ps1`, which depend on nothing external. No new package, no network fetch, no `curl|sh`-style execution is introduced. If a future revision of these scripts reaches for an external tool, that is a new dependency and must be re-reviewed; for M19 the constraint is simply: zero new dependencies.

## Note for the gate and downstream

- These SR-IDs are inputs to `pm-decompose` (so swe-feature-092 and swe-feature-093 carry SR-001..SR-006 inline, and swe-feature-088..091 + qa-feature-094 carry SR-007/SR-008) and become the checklist for the `sec-review` close-out gate.
- **Real finding flagged for the gate:** the existing installer's `migrate_file` prior art (referenced by swe-feature-093) does, on destination collision, `rm "$src"` — it *discards* the source silently. SR-001 deliberately contradicts that pattern: the `migrate-sdlc` collision behavior must **report, not discard**. Reusing the M14 pattern verbatim would violate SR-001 and issue 093's own acceptance criterion ("collision is reported, not silently overwritten"). Resolve this divergence before implementation.
