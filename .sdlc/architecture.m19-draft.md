# M19 Architecture Draft — SDLC Boundary (`docs/` vs `.sdlc/`)

> **Status:** DRAFT for the M19 enrich gate. Scoped to the [SDLC Boundary] milestone only — not a rewrite of the whole-system architecture (`docs/architecture.md`). This draft defines the one new contract M19 introduces (the artifact-location boundary) and the data flow of the relocation + migration. The toolkit's component model is unchanged; M19 moves *where specs live*, not *what produces them*.

## Overview

M19 draws a hard line through the toolkit's two persistence surfaces. Today both expert-authored specs (architecture, test-plan, security-requirements, etc.) and user-facing docs (guides, README, brief, roadmap) live in `docs/`. M19 makes `docs/` user-facing-only and moves every expert-authored spec/plan/draft to `.sdlc/`.

This is a **reference-repointing + relocation** change, not a redesign. No skill logic changes, no spec content changes. The architectural deliverable is a single, enforceable rule — the **SDLC boundary** — plus two new behaviors that protect it: consumers **fail loudly** at the new path, and a **`migrate-sdlc` workflow** relocates an existing project's specs idempotently. The grep audit confirms the blast radius: **190 path references across 38 files** under `agents/`, plus both installers and the brief.

## The boundary contract (the one new architectural element)

The boundary is a classification rule applied to every file the toolkit reads or writes. It is the contract every skill, role, runbook, accelerator, and installer must obey.

| Surface | Holds | Audience | Examples |
|---------|-------|----------|----------|
| `docs/` | User-facing documentation only | A human onboarding to the project | `guides/*`, `README.md`, `project-brief.md`, `roadmap.md` |
| `.sdlc/` | Expert-authored specs, plans, drafts, session artifacts | Experts (agent memory) | `architecture.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `documentation-plan.md`, `pipeline.md`, `release-plan.md`, `env-context.md`, `components.md`, `task-detail-standard.md`, `*-draft.md`, `research/`, `security/`, `runbooks/`, plus the already-relocated `issues/`, `handoff-notes/`, `lessons-log.md`, `interview-notes-*.md` |

Two deliberate exceptions keep blast radius down (per interview notes): `project-brief.md` and `roadmap.md` stay in `docs/` even though experts author them, because they answer a user's "what / where-now / where-next" and because moving them would force changes to the SessionStart primer and every "read the brief first" instruction. `docs/agent-reference.md` is the contributor-facing reference and also stays — it is read by humans modifying expert definitions, not consumed as a spec. The boundary is therefore *audience*, not *authorship*: brief, roadmap, and agent-reference are expert-touched but user/contributor-read, so they stay.

### Canonical spec inventory (the migration set)

This is the authoritative list of artifacts that move `docs/ → .sdlc/`. Every M19 task (repoint, installer, migrate, audit) references this same set, so it lives here as the single source.

- **Files:** `architecture.md`, `pipeline.md`, `components.md`, `documentation-plan.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `task-detail-standard.md`, `env-context.md`, `release-plan.md`
- **Drafts (glob):** `architecture.*-draft.md`, `pipeline.*-draft.md` (any `<spec>.*-draft.md`)
- **Subfolders:** `research/`, `security/`, `runbooks/`

Currently present in this repo's `docs/` (the dogfood case the migration must handle): `architecture.md`, `documentation-plan.md`, `test-plan.md`, `task-detail-standard.md`. The others are absent here but may exist in user projects — migration must treat each as optional.

## Components touched (boundaries — what each owns vs. consumes)

M19 changes path strings inside existing components; it adds exactly one new component (the migration workflow). Grouped by the seven decomposed tasks:

- **Spec-authoring skills** (`sa-*`, `sec-*`, `ux-*`, `doc-plan`, `qa-*`, `ops-*`) — own the "Draft `<spec>.md`" step. *Boundary change:* author target moves to `.sdlc/`. (swe-feature-088)
- **Spec-consuming skills** (`pm-decompose`, `pm-postmortem`, `team-status`, `qa-review`, `doc-author`, `doc-review`, review skills) — read sibling specs. *Boundary change:* read from `.sdlc/`, fail loud if absent. (088, then 091)
- **Role files** (`agents/roles/*.md`) — declare each expert's owned/consumed artifacts. *Boundary change:* ownership/consume paths point at `.sdlc/`. (swe-feature-089)
- **Conventions** (`agents/AGENTS.md`, `docs/project-brief.md` line ~96) — codify the ownership rule and the workflow-contract rule. *Boundary change:* state the `docs/`=user-facing rule and the fail-loud rule. (089, 091)
- **Runbooks** (`team-milestone`, `team-docs`) and **commands** (`ops-deploy`, `ops-env-discovery`) — drive phases that read/write specs. *Boundary change:* phase prompts point at `.sdlc/`. (swe-feature-090)
- **Accelerators** (`agents/workflows/implement.js`, `document.js`) — enrich/review fan-out with `out:` targets and inlined prompt strings naming specs. *Boundary change:* `out:` targets and prompt strings point at `.sdlc/`. (swe-feature-090)
- **Installer** (`install.sh`, `install.ps1`) — scaffolds `docs/` and `.sdlc/` on fresh install. *Boundary change:* stop seeding specs into `docs/`; create `.sdlc/` spec locations; comment fix. (swe-feature-092)
- **`migrate-sdlc` workflow** (NEW — `agents/scripts/migrate-sdlc.sh` + `.ps1`) — the only net-new component. Relocates an existing project's specs `docs/ → .sdlc/`, idempotent, verifies. (swe-feature-093)

System boundary unchanged: everything inside `agents/` (the installed payload) and the two installers is in scope; the harness (Claude Code / Codex) and the user's other project files are outside and untouched.

## Data flow

Three flows, two of which already exist and only change their endpoint, one of which is new.

**1. Author flow (skill writes a spec) — endpoint moves**
```
expert runs spec skill  →  draft step  →  WRITE .sdlc/<spec>.md   (was docs/<spec>.md)
```

**2. Consume flow (skill/role/accelerator reads a spec) — endpoint moves + fail-loud added**
```
consumer step  →  READ .sdlc/<spec>.md
                    ├─ present  →  proceed
                    └─ absent   →  STOP, named error:
                                   "<spec>.md not found at .sdlc/. Produce it with
                                    <authoring-skill>, or run migrate-sdlc for an
                                    existing project."
```
Distinguish *required-missing* (hard fail) from *legitimately-absent* (a milestone with no UX surface produces no `ux-guidelines.md` — a documented no-op, not an error). The fail-loud rule applies only to specs a step actually requires.

**3. Migration flow (`migrate-sdlc`, new) — one-time per existing project**
```
re-install (gets new payload)  →  user runs migrate-sdlc  →
   for each artifact in canonical spec inventory:
     docs/<artifact> present?
       ├─ no                          →  skip (optional)
       ├─ yes, .sdlc/ slot empty      →  move docs/ → .sdlc/
       └─ yes, .sdlc/ slot occupied   →  COLLISION: report, do NOT overwrite
   verify: no listed spec remains in docs/  →  report relocated set
```
Idempotent: a second run finds nothing in `docs/`, moves nothing, reports already-clean. User-facing files and unknown files in `docs/` are never touched.

## Interfaces and contracts

- **Path contract (the boundary).** Every authored spec resolves to `.sdlc/<spec>.md`; every consumer resolves the same path. The canonical spec inventory above is the shared list — repoint (088-092), migrate (093), and audit (094) must all reference the same set or they will drift. *Verification:* `grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/ install.sh install.ps1` returns zero authoring/consume hits (user-facing `guides/`, `project-brief.md`, `roadmap.md` refs are allowed and expected).
- **Fail-loud contract.** A missing *required* spec at `.sdlc/` is a hard stop with a message naming (a) the missing file and (b) the remedy — the authoring skill, or `migrate-sdlc`. This replaces today's silent "read X if it exists." Codified in the `AGENTS.md` "Workflow contracts" convention.
- **Migration idempotency + no-clobber contract.** `migrate-sdlc` moves only canonical-inventory artifacts by name; re-run is a no-op; an occupied destination is a reported collision, never an overwrite. It reuses the M14 `migrate_file`/`migrate_dir` *move + idempotency* structure but **must deviate from its collision behavior**: the M14 prior art does `rm "$src"` when the destination already exists (silently discarding the source). M19 requires the opposite — **on collision, leave the source untouched, print both paths, and exit non-zero** (GATE 2 decision; satisfies SR-001 and swe-feature-093's "collision reported, not silently overwritten" criterion). A run with any collision is a non-zero exit the user must resolve.
- **Cross-harness parity contract.** `install.ps1` and the PowerShell migrate entry point produce results identical to their bash counterparts (M14 discipline).
- **Self-application note.** This repo dogfoods the payload. When 088-092 land, *this* project's consumers will point at `.sdlc/` while its specs still sit in `docs/` — so running `migrate-sdlc` on this repo (093) is the integration test, and the `docs/architecture.m19-draft.md` you are reading will itself move to `.sdlc/` at compile/migration time.

## Technology choices

| Area | Choice | Rationale |
|------|--------|-----------|
| Boundary enforcement | Instruction text in skills/roles/runbooks + grep audit | The toolkit expresses behavior as agent instructions, not runtime code; consistent with M13/M14 path work. No new error-handling scripts (per 091 scope). |
| Migration mechanism | Shell script (`bash` + `PowerShell`), reuse `migrate_file`/`migrate_dir` | Proven idempotent pattern from M14; matches the toolkit's "shell scripts for mechanical ops" decision. |
| Workflow naming | `migrate-sdlc` (fallback `sync-sdlc` if user prefers at execution) | Per interview notes; mirrors `agents/scripts/` convention. |
| Drafts handling | Glob `<spec>.*-draft.md` | Catches `architecture.m1-draft.md`-style intermediates without enumerating every milestone. |

## Architecture decisions

| ID | Decision | Status |
|----|----------|--------|
| ADR-M19-1 | Boundary is by audience, not authorship: brief, roadmap, agent-reference stay in `docs/` though experts touch them | Accepted (Gate 2) |
| ADR-M19-2 | Consumers fail loud (hard stop) on a missing *required* spec; tiered scope — architecture always, others by surface | Accepted (Gate 2) |
| ADR-M19-3 | Canonical spec inventory lives in one place (this doc) and is referenced by repoint/installer/migrate/audit tasks | Accepted (Gate 2) |
| ADR-M19-4 | `migrate-sdlc` is a separate user-run workflow, not folded into the installer | Accepted (Gate 2) |

### ADR-M19-1: Boundary by audience, not authorship
**Context:** Brief and roadmap are expert-authored but a strict authorship rule would move them, breaking the SessionStart primer and many "read the brief first" instructions.
**Options:** (a) Pure authorship rule — move everything experts write. (b) Audience rule — keep what a human reads to onboard. (c) Move everything including brief, accept the larger blast radius.
**Decision:** (b). `docs/` = what a human reads to understand the project today (guides, README, brief, roadmap, agent-reference); `.sdlc/` = expert working memory.
**Consequences:** Smaller, safer change; the "boundary" is a judgment about audience that the convention text must state explicitly so future specs are classified correctly. A reader of a guide loses the signposted path into `.sdlc/` reasoning — captured as a separate backlog feature (pm-feature-087), explicitly out of scope here.

### ADR-M19-2: Fail loud on missing required spec
**Context:** Half-migrated projects (or a missed repoint) currently degrade silently and produce wrong output.
**Options:** (a) Keep "if it exists" soft-skip. (b) Hard fail with a named, actionable message. (c) Auto-run migration on miss.
**Decision:** (b). (c) rejected — hides the inconsistency and could move files unexpectedly. The message names the file and the remedy.
**Consequences:** A partially-migrated project breaks loudly during debug/test — the intended safety property. Requires distinguishing required-missing from legitimately-absent (no-op UX/security on a milestone with no such surface), so the rule is conditional, not blanket.

### ADR-M19-3: Single canonical spec inventory
**Context:** Four tasks (repoint, installer, migrate, audit) each enumerate "the specs." Divergent lists would let an artifact be repointed but not migrated, or migrated but not audited.
**Decision:** Keep the inventory in this architecture doc; every task cites it.
**Consequences:** One list to maintain; adding a future spec type means updating one place plus the four consumers. Drift becomes a documented, greppable risk rather than silent.

### ADR-M19-4: `migrate-sdlc` separate from the installer
**Context:** The installer already migrates *session* artifacts (M13/M14). Specs could ride along, or be a distinct user-run step.
**Options:** (a) Fold spec migration into the installer. (b) Separate `migrate-sdlc` workflow the user runs after re-install.
**Decision:** (b), per interview notes. The installer scaffolds locations; the user explicitly runs migration so spec relocation is a deliberate, verifiable, re-runnable act.
**Consequences:** Two-step adoption (re-install, then `migrate-sdlc`) — must be documented at a known entry point. Cleaner separation: installer never moves specs, so an install can't surprise a user by relocating spec content.

## Constraints (M19 must respect)

- No spec **content** changes — relocation + reference-repoint only.
- `agents/` is the single source of truth; payload paths use `.agents/...` to resolve across harnesses (installer-written paths must respect this).
- `docs/project-brief.md` and `docs/roadmap.md` files do not move; only the ownership-path *text* inside the brief changes.
- `CLAUDE.md` is a symlink to `AGENTS.md` — do not edit it directly.
- `.sdlc/` is NOT added to `.gitignore` (ADR, prior milestone) — `migrate-sdlc` must not gitignore it.
- bash/PowerShell parity (M14 discipline) for installer and migration.

## Gate 2 decisions (resolved 2026-06-19)

All four open questions were ruled at the foundations gate. These are now binding for compile/implementation:

1. **`docs/agent-reference.md` stays in `docs/`.** It is a contributor-facing reference read by humans modifying expert definitions, not a spec consumed by a skill. Not in the migration set. (Confirms ADR-M19-1.)
2. **Fail-loud scope is tiered.** `architecture.md` is required for any milestone with implementation (hard fail if missing at `.sdlc/`). `security-requirements.md` / `ux-guidelines.md` / `documentation-plan.md` / `test-plan.md` are required only when the milestone has the corresponding surface; otherwise their absence is a documented no-op, not an error. (Confirms ADR-M19-2.)
3. **Workflow name is `migrate-sdlc`.** Final — every reference (guide filename, error-message remedy text, installer output) uses this name. `sync-sdlc` is dropped.
4. **Collision policy: report and halt, non-zero exit.** On a destination collision `migrate-sdlc` never touches the source, names both paths, and exits non-zero. This deviates from the M14 `rm "$src"` prior art (a latent data-loss bug). See the migration idempotency contract above; swe-feature-093 amended to match.
