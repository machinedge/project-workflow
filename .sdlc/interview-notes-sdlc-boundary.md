# Feature Scoping Notes — SDLC Artifact Boundary

**Scoped:** 2026-06-19 · **Expert:** PM · **Next skill:** `pm-update-plan`

## Verdict

`docs/` has become a dumping ground for expert-authored specs, plans, and drafts. This feature draws a **hard line**: `docs/` holds only human-facing documentation; everything an expert authors moves to `.sdlc/`. The Technical Writer reads `.sdlc/` to produce the user-facing guides.

## What

Reclassify where expert artifacts live. Move all expert-authored specs/plans/requirements/drafts out of `docs/` and into `.sdlc/`. Keep `docs/` for documentation a human persona reads to get up to speed. Repoint every authoring instruction (skills, role files, the brief's convention, `AGENTS.md`, the workflow accelerators) at `.sdlc/`. Make consumers **fail loudly** if a spec isn't at the new path, and add a **`migrate-sdlc` workflow** that manages the user-side migration.

## Why

- The original intent was `docs/` = user-facing documentation (what personas read to onboard). That intent was never enforced.
- **Root cause (investigated, confirmed — it is by design, not drift):**
  1. Every spec skill has a literal "Draft `docs/<spec>.md`" step — `sa-design` → `docs/architecture.md`, `sec-requirements` → `docs/security-requirements.md`, `ux-guidelines` → `docs/ux-guidelines.md`, `doc-plan` → `docs/documentation-plan.md`, QA → `docs/test-plan.md`, DevOps → `docs/pipeline.md` / `env-context.md` / `release-plan.md`.
  2. Every role file names `docs/<spec>.md` as the artifact the expert "owns."
  3. The project brief codifies the rule (line 91): "The System Architect owns `docs/architecture.md`; the Security Engineer owns `docs/security-requirements.md`…".
  4. The M13 "Workflow Directory" split only relocated *session* artifacts (handoff notes, lessons-log, interview notes, research reports, issues) to `.sdlc/` — visible in the installer's migration block. It never touched the spec docs.
  5. M16/M17/M18 then added three more spec-owning advisors (security, UX, docs), so `docs/` kept accumulating specs, plus intermediate drafts (`architecture.m1-draft.md`, `pipeline.m2-draft.md`).
- We now have a dedicated Technical Writer expert that can pull from `.sdlc/` artifacts and create/maintain the user-facing docs — so the specs no longer need to sit in `docs/` to be "readable."

## Scope

### In
- Repoint every spec skill's draft/save step from `docs/<spec>.md` to `.sdlc/<spec>.md`.
- Update every role file's ownership + consume paths to `.sdlc/`.
- Update the brief's codified convention (line 91), `AGENTS.md` conventions, the two `team-*` runbooks, and both workflow accelerators (`implement.js`, `document.js`).
- Make consumers **fail loudly** when a referenced spec is absent at the new `.sdlc/` path (no silent "if it exists" degrade) — so half-migrated projects are caught during debug/test.
- Installer: stop seeding spec docs into `docs/`; create the needed `.sdlc/` locations.
- New **`migrate-sdlc` workflow** (name TBD: `migrate-sdlc` or `sync-sdlc`): owns the user-side migration. Flow: user re-installs to get the new payload, then runs the workflow, which moves existing `docs/` spec artifacts → `.sdlc/` (idempotent) and verifies the result is consistent.

### Boundary (the hard line)
- **Stays in `docs/` (user-facing):** `guides/*` (overview, usage, deployment, maintenance, build-a-workflow), `README.md`, `project-brief.md`, `roadmap.md`.
  - *Rationale for brief + roadmap staying:* they answer "what is this project, where is it today, where is it going" — key things a user wants. Keeping them also avoids touching the SessionStart primer and the "read the brief first" instructions, shrinking blast radius.
- **Moves to `.sdlc/`:** `architecture.md` (+ `architecture.m1-draft.md`), `pipeline.md` (+ `pipeline.m2-draft.md`), `components.md`, `documentation-plan.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `task-detail-standard.md`, `env-context.md` / `release-plan.md` (if present), and the `research/`, `security/`, `runbooks/` subfolders.

### Out
- The drill-down/discoverability question (see Backlog request) — captured separately, not built here.
- No change to the content of any spec — this is a relocation + reference-repoint, not a rewrite.

## Success

- A fresh install produces a `docs/` containing only `guides/`, `README.md`, `project-brief.md`, `roadmap.md`. Every expert spec/plan lands in `.sdlc/`.
- Running each spec skill writes to `.sdlc/`; no role file, `AGENTS.md`, runbook, or accelerator still points an *authored* artifact at `docs/`.
- Consumers fail loudly (clear error) when a spec is missing at the new path, rather than degrading silently.
- The `migrate-sdlc` workflow moves an existing project's specs `docs/ → .sdlc/` with no data loss, is idempotent (safe to re-run), and reports a clean/consistent end state.
- The Technical Writer's guides still resolve their references to the relocated specs (no broken `docs/architecture.md`-style links).
- Grep audit: zero stale `docs/<spec>.md` authoring references across `agents/`.

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Stale path references — specs are cross-referenced widely (roles, skills, both runbooks, both accelerators, QA/SWE consumers) | High | Systematic grep audit, same playbook as M13/M14 path work |
| Migration loses or clobbers user edits on existing projects | High | `migrate-sdlc` reuses M14 `migrate_file`/`migrate_dir` idempotent pattern; verify step |
| `docs/architecture.md` has the widest consumer fan-out (SWE, QA, Sec, UX, TW, PM all read it) | Medium | Fail-loud surfaces any missed consumer immediately during test |
| Fail-loud could break a partially-migrated project hard | Low (intended) | This is the point — caught in debug/test, not silently wrong; `migrate-sdlc` is the supported path back to consistent |

## Backlog request (separate future feature — do NOT build in this milestone)

**"Enable readers to dig deeper than the user-facing documentation when they have questions."** Once specs leave `docs/`, a curious reader of the guides has no signposted path into the underlying `.sdlc/` reasoning. Scope a discoverability/drill-down mechanism. → File as a PM backlog feature.

## Milestone-deprecation directive

User directed: deprecate all unfinished milestones and make this feature the sole focus.
- **Note:** the roadmap currently shows M1–M18 all **Done** — there are no in-flight milestones. Interpreting "unfinished" as the open **"Next task"** in the brief (verify the milestone lifecycle end-to-end) plus non-essential open backlog.
- `pm-update-plan` to: add this as the new sole-focus milestone (M19), and mark the stated Next task / non-essential planned work as deferred. **Confirm the exact deprecation set with the user during `pm-update-plan`.**

## Process note (out of scope, flag only)

The `/pm-add-feature` command instructs saving notes to `.sdlc/rview-notes-[slug].md` — the same `rview`/`interview` typo already fixed in `pm-interview.md` (issue `swe-bug-082`). Saved to `.sdlc/interview-notes-sdlc-boundary.md` instead. The `pm-add-feature` command file should get the same fix.
