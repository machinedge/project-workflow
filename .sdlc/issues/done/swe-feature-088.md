# Repoint spec skills' authoring and consume paths from docs/ to .sdlc/

**Type:** feature
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:**
**Detail level:** implementation-ready

## User Story

As a maintainer of the expert toolkit, I want every spec-authoring and spec-consuming skill to write and read its artifact under `.sdlc/` instead of `docs/`, so that `docs/` stops accumulating expert-authored specs and the SDLC boundary is enforced at the point each spec is created or read.

## Description

Each spec skill has a literal "Draft `docs/<spec>.md`" authoring step and/or reads sibling specs from `docs/`. Repoint every authoring/save step and every consume reference inside the skill `SKILL.md` files from `docs/<spec>.md` to `.sdlc/<spec>.md`. This is a relocation of path references only — no change to skill logic or spec content. User-facing paths (`docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md`) stay in `docs/`.

## Files to Create or Modify

The exact file set. Every row below was verified by grepping the live skill files (see the audit grep in the Implementation Outline) — each "what changes" entry names only `docs/<spec>.md` strings that **actually occur** in that file today. References that the canonical inventory lists but that **no skill emits** (`components.md`, `research/`, `security/`, `runbooks/`) are explicitly called out as "no occurrence — nothing to repoint" below and must NOT be added.

All actions are **modify** — replace each occurring `docs/<spec>.md` string with `.sdlc/<spec>.md`; leave `docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md` untouched. The line count is exact: **96 lines across 22 skill files** when the audit grep excludes the `team-milestone/`/`team-docs/` directories by path (see the exact command in the Implementation Outline). Note the exclusion must be **path-anchored** (`/(team-milestone|team-docs)/`): a bare word-match on `team-milestone` would also drop the `pm-decompose` line at `:15`, which only *mentions* the workflow in prose but genuinely references `docs/task-detail-standard.md` and IS an in-scope repoint.

| Path | Action | What changes (verified occurrences) |
|------|--------|--------------|
| `agents/skills/sa-design/SKILL.md` | modify | author target → `.sdlc/architecture.md` (Step 5 "Draft" + "Save" line + description); read `.sdlc/architecture.md`, `.sdlc/env-context.md`. No `components.md` occurs — do not add it. |
| `agents/skills/sa-update/SKILL.md` | modify | author/read `.sdlc/architecture.md` (incl. the `description:` frontmatter line and Step "Update" lines) |
| `agents/skills/sa-research/SKILL.md` | modify | read `.sdlc/architecture.md` (two refs). No `research/` output-dir reference occurs — do not add one. |
| `agents/skills/sa-review/SKILL.md` | modify | read `.sdlc/architecture.md` |
| `agents/skills/sec-requirements/SKILL.md` | modify | author `.sdlc/security-requirements.md` (Step 5 "Draft" + "Save" + description); read `.sdlc/architecture.md`. No `security/` subfolder reference occurs — do not add one. |
| `agents/skills/sec-review/SKILL.md` | modify | read `.sdlc/security-requirements.md`, `.sdlc/architecture.md` |
| `agents/skills/sec-handoff/SKILL.md` | modify | read/reference `.sdlc/security-requirements.md` |
| `agents/skills/ux-guidelines/SKILL.md` | modify | author `.sdlc/ux-guidelines.md` (Step 5 "Draft" + "Save" + description + no-surface "Scope" note); read `.sdlc/architecture.md` |
| `agents/skills/ux-review/SKILL.md` | modify | read `.sdlc/ux-guidelines.md`, `.sdlc/architecture.md` |
| `agents/skills/ux-handoff/SKILL.md` | modify | read/reference `.sdlc/ux-guidelines.md` |
| `agents/skills/doc-plan/SKILL.md` | modify | author `.sdlc/documentation-plan.md` (Step 5 "Draft" + "Save" + description + no-change "Scope" note); read `.sdlc/architecture.md`, `.sdlc/ux-guidelines.md`, `.sdlc/env-context.md`, `.sdlc/release-plan.md`. Guides output stays `docs/guides/` (do not change). |
| `agents/skills/doc-author/SKILL.md` | modify | read specs from `.sdlc/` (`documentation-plan.md`, `architecture.md`, `ux-guidelines.md`, `env-context.md`, `release-plan.md`, `security-requirements.md`); write guides to `docs/guides/` (unchanged) |
| `agents/skills/doc-review/SKILL.md` | modify | read `.sdlc/documentation-plan.md`, `.sdlc/architecture.md`, `.sdlc/env-context.md`, `.sdlc/release-plan.md`; guides read from `docs/guides/` (unchanged) |
| `agents/skills/doc-handoff/SKILL.md` | modify | read/reference `.sdlc/documentation-plan.md` |
| `agents/skills/qa-test-plan/SKILL.md` | modify | author `.sdlc/test-plan.md` ("Save to" + final "Save" line); read `.sdlc/env-context.md`, `.sdlc/architecture.md` |
| `agents/skills/qa-review/SKILL.md` | modify | read `.sdlc/test-plan.md`, `.sdlc/env-context.md`, `.sdlc/architecture.md` |
| `agents/skills/qa-regression/SKILL.md` | modify | read `.sdlc/test-plan.md`, `.sdlc/architecture.md` |
| `agents/skills/qa-bug-triage/SKILL.md` | modify | read `.sdlc/architecture.md` (this file references **only** `architecture.md`, not `test-plan.md` — do not add a `test-plan.md` ref) |
| `agents/skills/ops-pipeline/SKILL.md` | modify | read `.sdlc/env-context.md`, `.sdlc/test-plan.md`; repoint the emitted-template prose line (`Implement the pipeline defined in .sdlc/pipeline.md. See .sdlc/env-context.md ...`). NOTE: there is **no literal "Save `docs/pipeline.md`" authoring step** here — pipeline authoring is carried by that emitted prose (see rule in Implementation Outline step 2c). |
| `agents/skills/ops-release-plan/SKILL.md` | modify | author `.sdlc/release-plan.md` ("Save to" line); read `.sdlc/env-context.md`, `.sdlc/test-plan.md` |
| `agents/skills/ops-handoff/SKILL.md` | modify | read/reference `.sdlc/env-context.md` (this file references **only** `env-context.md`, not `pipeline.md`/`release-plan.md` — do not add those) |
| `agents/skills/pm-decompose/SKILL.md` | modify | read `.sdlc/architecture.md`, `.sdlc/security-requirements.md`, `.sdlc/test-plan.md`, `.sdlc/task-detail-standard.md` (Step 1 list + the two body refs at the completeness-check and "denser template" lines) |
| `agents/skills/pm-postmortem/SKILL.md` | modify | read `.sdlc/test-plan.md`, `.sdlc/release-plan.md` |
| `agents/skills/team-status/SKILL.md` | modify | read `.sdlc/env-context.md`, `.sdlc/test-plan.md`, `.sdlc/release-plan.md`, `.sdlc/architecture.md` |

**Phantom references — confirmed zero occurrences in `agents/skills/`, nothing to repoint (do NOT introduce them):** `components.md`, `docs/research/`, `docs/security/`, `docs/runbooks/`. They appear in the canonical inventory for context (other M19 tasks may touch them elsewhere), but no skill file in this task's scope references any of them. The implementer must not add a `.sdlc/components.md`, `.sdlc/research/`, `.sdlc/security/`, or `.sdlc/runbooks/` string anywhere.

Note: the `team-milestone/` and `team-docs/` directories also matched the grep (8 lines inside those two directories) but are owned by swe-feature-090 — do NOT edit them here. Excluding those directories leaves the 96 in-scope lines above.

## Interfaces and Data Models

No code interface. The contract is the **path string** — the canonical spec inventory from `docs/architecture.m19-draft.md` ("Canonical spec inventory") that all M19 tasks share. This inventory is the *classification rule* (what may move), NOT the edit list — the edit list is the "Files to Create or Modify" table above, which contains only references that actually occur in skills.

```
Files in inventory (docs/ → .sdlc/):
  architecture.md, pipeline.md, components.md, documentation-plan.md,
  test-plan.md, security-requirements.md, ux-guidelines.md,
  task-detail-standard.md, env-context.md, release-plan.md
Subfolders in inventory: research/, security/, runbooks/
Stays in docs/ (do NOT touch): guides/, README.md, project-brief.md, roadmap.md
```

Of that inventory, the references that actually occur in this task's skills (and so get repointed) are: `architecture.md`, `documentation-plan.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `task-detail-standard.md`, `env-context.md`, `release-plan.md`, and the `pipeline.md` string inside the ops-pipeline emitted-template prose. The inventory entries `components.md`, `research/`, `security/`, `runbooks/`, and standalone `pipeline.md` (outside the emitted prose) have **zero occurrences** in the in-scope skills — they are NOT edited.

Substitution rule applied per occurring reference:
- `docs/architecture.md` → `.sdlc/architecture.md` (and the same for every occurring spec above)
- Any `docs/guides/...`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md` → **unchanged**
- `components.md`, `docs/research/`, `docs/security/`, `docs/runbooks/` → **not present, not introduced**

## Implementation Outline

**Canonical edit target (read this first).** Make all edits to the **real source files under `agents/skills/`**. The repo also has a `.agents` symlink that points at `agents` (`.agents -> agents`), so `.agents/skills/...` resolves to the same files — but always edit through the `agents/skills/` path, never through `.agents/`. Editing through the symlink risks tooling writing to the link target ambiguously and double-counting in greps; the literal commands below all use `agents/skills/`.

**task-detail-standard.md ordering (not a typo).** This task repoints the *reference text* in `pm-decompose` to read `.sdlc/task-detail-standard.md`, even though the physical file still sits at `docs/task-detail-standard.md` in this repo right now. That is correct and intended: the physical move happens later (the `migrate-sdlc` workflow / dogfooding step, swe-feature-093), and fail-loud-on-missing is swe-feature-091. Pointing a read at `.sdlc/...` before the file physically moves is the deliberate instruction-text change this task makes — do NOT stall, skip it, or "fix" it back to `docs/`. The same ordering applies to every spec this repo happens to still hold in `docs/` (e.g. `architecture.md`, `test-plan.md`).

1. Run the **audit grep** to get the exact line set, excluding the two out-of-scope team runbooks (`team-milestone`, `team-docs` — owned by swe-feature-090). They live under `agents/skills/` and match the regex, so without the exclusion the grep can never reach zero. Exact runnable command:
   ```
   grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/skills/ | grep -vE '/(team-milestone|team-docs)/'
   ```
   Before any edits this prints **96** lines across the 22 in-scope skill files. (The unfiltered grep prints 104; the 8-line difference is the lines inside the `team-milestone/` and `team-docs/` directories. The exclusion is **path-anchored** on purpose — `/(team-milestone|team-docs)/` keeps the `pm-decompose` line at `:15` that merely names the `team-milestone` workflow in prose while actually referencing `docs/task-detail-standard.md`, which is an in-scope repoint.)
2. For each matching line in the files listed in the table above, triage and repoint `docs/<spec>.md → .sdlc/<spec>.md`:
   - **2a.** An authoring/save step (e.g. `## Step 5: Draft docs/architecture.md`, `Save docs/architecture.md ...`, `Save to docs/test-plan.md`) or a consume/read step naming a spec → repoint.
   - **2b.** A `docs/guides/`, `project-brief.md`, `roadmap.md`, or `README.md` reference → **leave it.**
   - **2c.** **ops-pipeline emitted-template prose.** The line `Implement the pipeline defined in docs/pipeline.md. See docs/env-context.md for environment details.` is boilerplate the skill EMITS into a downstream implementation issue. It IS a spec reference (it tells a downstream SWE where the spec lives), so **repoint it** to `.sdlc/`: `Implement the pipeline defined in .sdlc/pipeline.md. See .sdlc/env-context.md for environment details.` This is the only `pipeline.md` occurrence in scope; there is no separate "Save docs/pipeline.md" line to change.
   - **2d.** Do NOT introduce `components.md`, `docs/research/`, `docs/security/`, or `docs/runbooks/` strings — they do not occur and are not in this task's edit list.
3. Do NOT add fail-loud behavior here (that is swe-feature-091) — only change the path. Do NOT touch `team-milestone`/`team-docs`/`ops-*` commands/`*.js` (those are swe-feature-090).
4. Re-run the exact excluded audit grep from step 1 over `agents/skills/`; confirm it returns **0** lines.

## Acceptance Criteria

- [ ] `sa-design` authors `.sdlc/architecture.md`; `sa-update`, `sa-research`, `sa-review` read `.sdlc/architecture.md` — no `docs/architecture.md` reference remains in any of the four. (No `components.md` or `research/` reference exists in these files — none is added.)
- [ ] `sec-requirements` authors `.sdlc/security-requirements.md` (and reads `.sdlc/architecture.md`); `sec-review` reads `.sdlc/security-requirements.md` + `.sdlc/architecture.md`; `sec-handoff` references `.sdlc/security-requirements.md`. (No `security/` subfolder reference exists — none is added.)
- [ ] `ux-guidelines` authors `.sdlc/ux-guidelines.md` (and reads `.sdlc/architecture.md`); `ux-review` reads `.sdlc/ux-guidelines.md` + `.sdlc/architecture.md`; `ux-handoff` references `.sdlc/ux-guidelines.md`
- [ ] `doc-plan` authors `.sdlc/documentation-plan.md` and reads `.sdlc/architecture.md` / `.sdlc/ux-guidelines.md` / `.sdlc/env-context.md` / `.sdlc/release-plan.md`; `doc-author`, `doc-review`, `doc-handoff` read them from `.sdlc/` (the user-facing guides themselves stay in `docs/guides/`)
- [ ] `qa-test-plan` authors `.sdlc/test-plan.md` (and reads `.sdlc/env-context.md` / `.sdlc/architecture.md`); `qa-review` reads `.sdlc/test-plan.md` / `.sdlc/env-context.md` / `.sdlc/architecture.md`; `qa-regression` reads `.sdlc/test-plan.md` / `.sdlc/architecture.md`; `qa-bug-triage` reads `.sdlc/architecture.md` (it has no `test-plan.md` reference — none is added)
- [ ] `ops-pipeline` reads `.sdlc/env-context.md` / `.sdlc/test-plan.md` and its emitted-template prose points at `.sdlc/pipeline.md` + `.sdlc/env-context.md`; `ops-release-plan` authors `.sdlc/release-plan.md` and reads `.sdlc/env-context.md` / `.sdlc/test-plan.md`; `ops-handoff` references `.sdlc/env-context.md` (it has no `pipeline.md`/`release-plan.md` reference — none is added). (No `runbooks/` reference exists in any ops skill — none is added.)
- [ ] `pm-decompose` reads `.sdlc/architecture.md` / `.sdlc/security-requirements.md` / `.sdlc/test-plan.md` / `.sdlc/task-detail-standard.md`; `pm-postmortem` reads `.sdlc/test-plan.md` / `.sdlc/release-plan.md`
- [ ] `team-status` reads `.sdlc/env-context.md` / `.sdlc/test-plan.md` / `.sdlc/release-plan.md` / `.sdlc/architecture.md`
- [ ] User-facing paths (`docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md`) are left unchanged
- [ ] The excluded audit grep (`... agents/skills/ | grep -vE '/(team-milestone|team-docs)/'`) returns **zero** lines

## Test Specification

**Test instrument:** the deterministic audit grep (this milestone has no unit-test harness — verification is the exact grep commands below, per `.sdlc/test-plan.md`). Each case is a single runnable command with an objective pass condition. Run all from the repo root. `team-milestone`/`team-docs` are excluded everywhere because they match the regex but are out of scope (swe-feature-090).

| Case | Exact command | Pass condition (objective) |
|------|---------------|----------------------------|
| 1. No stale spec refs remain | `grep -rn -E 'docs/(architecture\|pipeline\|components\|documentation-plan\|test-plan\|security-requirements\|ux-guidelines\|task-detail-standard\|env-context\|release-plan)\.md\|docs/(research\|security\|runbooks)/' agents/skills/ \| grep -vE '/(team-milestone\|team-docs)/' \| wc -l` | output is exactly `0` (before edits this prints `96`) |
| 2. User-facing paths untouched | `grep -rcn -E 'docs/guides/\|docs/project-brief\.md\|docs/roadmap\.md\|docs/README\.md' agents/skills/ \| grep -v ':0$' \| wc -l` then diff against the pre-edit run | identical line count and identical files before vs. after (these refs must NOT change) |
| 3. New `.sdlc/` author refs present | `grep -l 'Save .*\.sdlc/architecture\.md' agents/skills/sa-design/SKILL.md; grep -l 'Save .*\.sdlc/security-requirements\.md' agents/skills/sec-requirements/SKILL.md; grep -l 'Save .*\.sdlc/ux-guidelines\.md' agents/skills/ux-guidelines/SKILL.md; grep -l 'Save .*\.sdlc/documentation-plan\.md' agents/skills/doc-plan/SKILL.md; grep -l 'Save .*\.sdlc/test-plan\.md' agents/skills/qa-test-plan/SKILL.md; grep -l 'Save to .*\.sdlc/release-plan\.md' agents/skills/ops-release-plan/SKILL.md` | each command prints its file path (the `.sdlc/` save line is present in all six authoring skills). NOTE: `ops-pipeline` has **no** "Save" line — verify it separately in case 4. |
| 4. ops-pipeline emitted prose repointed | `grep -n 'Implement the pipeline defined in .sdlc/pipeline.md. See .sdlc/env-context.md' agents/skills/ops-pipeline/SKILL.md \| wc -l` | output is exactly `1`, and `grep -c 'docs/pipeline.md' agents/skills/ops-pipeline/SKILL.md` is exactly `0` |
| 5. No phantom paths introduced | `grep -rn -E '\.sdlc/(components\.md\|research/\|security/\|runbooks/)' agents/skills/ \| wc -l` | output is exactly `0` (these were never present and must not be added) |

## Security Constraints

- [SR-007] After repoint, no expert-authored spec reference in any skill still points at `docs/<spec>.md`; the audit grep returns zero stale spec-path hits — from `docs/security-requirements.md`.
- (SR-008 fail-loud behavior is layered in swe-feature-091, not here.)

## Architecture Contracts

- Honor the **Path contract (the boundary)** — every authored spec resolves to `.sdlc/<spec>.md`; every consumer resolves the same path — from `docs/architecture.m19-draft.md`.
- Use the single **Canonical spec inventory** in `docs/architecture.m19-draft.md`; do not invent or extend the spec list (ADR-M19-3).
- Boundary is **by audience, not authorship** (ADR-M19-1): do not touch `docs/project-brief.md`, `docs/roadmap.md`, `docs/agent-reference.md`, or `docs/guides/`.
- This is reference-repointing only; no skill logic or spec content changes.

## Build / CI Notes

- No compiled artifact and no test harness. The "CI gate" is the audit grep returning zero stale references (`docs/test-plan.md`, "The audit grep").

## Technical Notes

**Estimated effort:** Large session
**Dependencies:** none (parallel with swe-feature-089, swe-feature-090, swe-feature-092)
**Out of scope:** Role files (swe-feature-089), the `team-*` runbooks / `ops-*` commands / `.js` accelerators (swe-feature-090), installer (swe-feature-092), fail-loud consumer behavior (swe-feature-091), the `migrate-sdlc` workflow (swe-feature-093). Do NOT move `docs/guides/`, `project-brief.md`, `roadmap.md`, or `README.md`. Do NOT change spec content.
