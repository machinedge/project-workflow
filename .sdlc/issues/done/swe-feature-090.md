# Repoint team-* runbooks, ops/start commands, and the two workflow accelerators to .sdlc/

**Type:** feature
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:**
**Detail level:** implementation-ready

## User Story

As someone running a milestone or documentation workflow, I want the runbooks and Claude Code accelerators to point every enrichment, compile, review, and consume step at `.sdlc/<spec>.md`, so that the orchestrated lifecycle reads and writes specs at the new boundary instead of leaving them in `docs/`.

## Description

The two `team-*` runbooks (`team-milestone`, `team-docs`), the command files that reference specs (`ops-deploy`, `ops-env-discovery`), and the two workflow accelerators (`workflows/implement.js`, `workflows/document.js`) all hard-code `docs/<spec>.md` paths in subagent prompts and phase definitions. Repoint every such reference to `.sdlc/`. In the accelerators, both the `out:` targets and the inlined prompt strings must be updated. Guide output paths (`docs/guides/*`) stay unchanged.

## Files to Create or Modify

| Path | Action | What changes |
|------|--------|--------------|
| `agents/skills/team-milestone/SKILL.md` | modify | enrichment/compile/review/consume specs → `.sdlc/<spec>.md` (architecture, security-requirements, ux-guidelines, documentation-plan, test-plan, task-detail-standard, pipeline, release-plan) |
| `agents/skills/team-docs/SKILL.md` | modify | plan/author/review phase spec references → `.sdlc/`; `docs/guides/` output unchanged |
| `agents/workflows/implement.js` | modify | enrichment matrix `out:` targets (lines 200-205) AND every subagent prompt naming a spec → `.sdlc/`. Three specific spots beyond the `out:` targets: (a) the `sa-review` review-phase `focus` string (line 338, `focus: 'conformance to docs/architecture.md'`) → `.sdlc/architecture.md` — review-phase focus strings ARE in scope; (b) the `compile` prompts naming `docs/task-detail-standard.md` (lines 231, 237) → `.sdlc/task-detail-standard.md`; (c) the postmortem prompt (line 387) is a **same-line mixed edit**: it names `docs/test-plan.md` and `docs/release-plan.md` (both MOVE → `.sdlc/`) alongside `docs/project-brief.md` and `docs/roadmap.md` (both STAY at `docs/`, per ADR-M19-1). Repoint ONLY `test-plan.md` and `release-plan.md`; leave `project-brief.md` and `roadmap.md` at `docs/`. Do NOT do an over-broad `docs/` → `.sdlc/` substitution on this line. |
| `agents/workflows/document.js` | modify | plan/author/review phase prompts BOTH read AND write specs at `.sdlc/`. Specifically: (a) the plan-phase prompt (line 131) WRITES the documentation plan — `Produce or extend docs/documentation-plan.md` → `.sdlc/documentation-plan.md`; `documentation-plan.md` is a spec, so its **write** target moves too, not just reads. The same line 131 READS `docs/project-brief.md` (STAYS at `docs/`, per ADR-M19-1), `docs/architecture.md`, `docs/ux-guidelines.md`, `docs/env-context.md`, `docs/release-plan.md` (these four MOVE → `.sdlc/`), and the guide inventory lives under `docs/guides/` (user-facing OUTPUT, STAYS). (b) the author-phase prompt (line 155) READS `docs/documentation-plan.md`, `docs/architecture.md`, `docs/ux-guidelines.md`, `docs/env-context.md`, `docs/release-plan.md` (all MOVE → `.sdlc/`) and WRITES to `docs/guides/*` (STAYS). (c) the review-phase prompt (line 185) READS `docs/documentation-plan.md` → `.sdlc/`. Rule: BOTH reads AND writes of specs move; only `docs/guides/` OUTPUT and the `docs/project-brief.md` read stay. |
| `agents/commands/ops-deploy.md` | modify | pipeline/release-plan references → `.sdlc/` |
| `agents/commands/ops-env-discovery.md` | modify | env-context references → `.sdlc/` |

**`docs/project-brief.md` is NOT in this task.** The brief's only spec reference is the line-96 ownership convention, which is owned end-to-end by swe-feature-089 (its file table, outline step 4, and a dedicated acceptance criterion all repoint that line). There is no separate "Notes for AI" architecture reference distinct from line 96, so this task touches the brief not at all.

## Interfaces and Data Models

The accelerators define an enrichment fan-out matrix with `out:` targets. The substitution applies to both fields:

```js
// implement.js enrichment matrix — each entry's `out:` target moves:
{ skill: 'sa-design',        out: '.sdlc/architecture.md' }          // was docs/architecture.md
{ skill: 'sec-requirements', out: '.sdlc/security-requirements.md' }  // was docs/...
{ skill: 'ux-guidelines',    out: '.sdlc/ux-guidelines.md' }
{ skill: 'doc-plan',         out: '.sdlc/documentation-plan.md' }
{ skill: 'qa-test-plan',     out: '.sdlc/test-plan.md' }
// ...and any release-plan / task-detail-standard reference
// AND every inlined prompt string that says "read docs/<spec>.md" → ".sdlc/<spec>.md"
```

`document.js` phase prompts move BOTH spec reads AND spec writes to `.sdlc/`: reads (architecture, ux-guidelines, env-context, release-plan, documentation-plan) AND the documentation-plan WRITE target on line ~131 (`Produce or extend docs/documentation-plan.md` → `.sdlc/documentation-plan.md`) → `.sdlc/`. Only the guide *output* paths (`docs/guides/...`) and the `docs/project-brief.md` read stay at `docs/`.

Apply the canonical spec inventory from `docs/architecture.m19-draft.md`. Path substitution rule identical to swe-feature-088/089.

## Implementation Outline

1. Grep both `.md` and `.js` scope: `grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/skills/team-milestone agents/skills/team-docs agents/commands agents/workflows` (the brief is swe-feature-089's scope, not this task's).
2. In each `team-*` runbook, repoint enrichment/review/consume spec paths to `.sdlc/`.
3. In `implement.js`, repoint every enrichment matrix `out:` target (lines 200-205) and every inlined prompt string that names a spec. Do NOT change orchestration logic (phase order, fan-out structure) — only the path strings. Named surgical edits:
   - **Line 338, `sa-review` review-phase `focus` string** (`focus: 'conformance to docs/architecture.md'`): repoint to `.sdlc/architecture.md`. Review-phase `focus` fields ARE in scope — they name a spec the consumer resolves.
   - **Lines 231 & 237, compile prompts**: repoint `docs/task-detail-standard.md` → `.sdlc/task-detail-standard.md`.
   - **Line 387, postmortem prompt (same-line mixed edit — be surgical)**: this one prompt string names four `docs/` paths. Repoint EXACTLY two — `docs/test-plan.md` → `.sdlc/test-plan.md` and `docs/release-plan.md` → `.sdlc/release-plan.md`. KEEP `docs/project-brief.md` and `docs/roadmap.md` at `docs/` (ADR-M19-1: brief and roadmap stay; boundary is by audience, not authorship). Edit the two move-refs by their full literal path so the substitution cannot bleed onto the two stay-refs on the same line. Do NOT run a blanket `docs/` → `.sdlc/` replace here.
4. In `document.js`, repoint spec reads AND writes to `.sdlc/`; leave `docs/guides/` *output* paths and the `docs/project-brief.md` read at `docs/`. Named surgical edits:
   - **Line 131, plan prompt (same-line mixed edit)**: this is a WRITE target mis-framed as a read — `Produce or extend docs/documentation-plan.md` → `.sdlc/documentation-plan.md` (the write target of a spec moves, same as a read). On the same line, repoint the reads `docs/architecture.md`, `docs/ux-guidelines.md`, `docs/env-context.md`, `docs/release-plan.md` → `.sdlc/`, but KEEP the `docs/project-brief.md` read and the `docs/guides/` inventory reference at `docs/`.
   - **Line 155, author prompt**: repoint the spec reads `docs/documentation-plan.md`, `docs/architecture.md`, `docs/ux-guidelines.md`, `docs/env-context.md`, `docs/release-plan.md` → `.sdlc/`; keep the `docs/guides/*` write target at `docs/`.
   - **Line 185, review prompt**: repoint `docs/documentation-plan.md` → `.sdlc/documentation-plan.md`.
5. In `ops-deploy.md` / `ops-env-discovery.md`, repoint pipeline/release-plan/env-context references to `.sdlc/`.
6. Re-grep the scope; confirm zero stale spec references; confirm `docs/guides/` output paths in `document.js`/`team-docs` are unchanged.

## Acceptance Criteria

- [ ] `team-milestone/SKILL.md` and `team-docs/SKILL.md` reference enrichment/review/consume specs at `.sdlc/<spec>.md`
- [ ] `agents/workflows/implement.js` enrichment matrix `out:` targets and every subagent prompt naming a spec point at `.sdlc/` (architecture, security-requirements, ux-guidelines, documentation-plan, test-plan, task-detail-standard, release-plan), INCLUDING the `sa-review` review-phase `focus` string (line ~338) → `.sdlc/architecture.md`
- [ ] In the `implement.js` postmortem prompt (line ~387), `docs/test-plan.md` and `docs/release-plan.md` are repointed to `.sdlc/`, while `docs/project-brief.md` and `docs/roadmap.md` REMAIN at `docs/` (no over-broad substitution)
- [ ] `agents/workflows/document.js` plan/author/review phase prompts read AND write specs at `.sdlc/` (architecture, ux-guidelines, env-context, release-plan, documentation-plan — including the documentation-plan WRITE target on line ~131); `docs/guides/` output paths and the `docs/project-brief.md` read stay unchanged
- [ ] `agents/commands/ops-deploy.md` and `agents/commands/ops-env-discovery.md` reference pipeline/release-plan/env-context at `.sdlc/`
- [ ] User-facing guide output paths (`docs/guides/*`) and brief/roadmap references remain unchanged
- [ ] `docs/project-brief.md` is left untouched by this task (the brief's spec reference is swe-feature-089's responsibility)
- [ ] The audit grep over this task's files returns zero stale `docs/<spec>.md` hits

## Test Specification

**Test instrument:** the deterministic audit grep.

| Case | Input | Expected result |
|------|-------|-----------------|
| Runbooks/accelerators repointed | audit grep over `agents/skills/team-milestone agents/skills/team-docs agents/commands agents/workflows` | zero `docs/<spec>.md` hits |
| Guide output preserved | grep `agents/workflows/document.js` and `team-docs/SKILL.md` for `docs/guides/` | still present (unchanged) |
| Accelerator out: targets | grep `implement.js` for `out:` spec targets | each names `.sdlc/<spec>.md` |
| sa-review focus repointed | grep `implement.js` line ~338 `focus:` for `docs/architecture.md` | absent; `.sdlc/architecture.md` present |
| Postmortem move-refs repointed | grep `implement.js` postmortem prompt (line ~387) for `docs/test-plan.md` and `docs/release-plan.md` | both absent; `.sdlc/test-plan.md` and `.sdlc/release-plan.md` present |
| Postmortem STAY-refs survive (over-broad-substitution guard) | grep `implement.js` postmortem prompt (line ~387) for `docs/project-brief.md` and `docs/roadmap.md` | BOTH still present at `docs/` — must NOT have been rewritten to `.sdlc/` |
| documentation-plan WRITE target repointed | grep `document.js` plan prompt (line ~131) for `docs/documentation-plan.md` | absent; `.sdlc/documentation-plan.md` present (the write target moved, not just reads) |
| document.js STAY-refs survive | grep `document.js` plan prompt (line ~131) for `docs/project-brief.md` and `docs/guides/` | BOTH still present at `docs/` — brief read and guide-inventory reference must NOT have been rewritten |

## Security Constraints

- [SR-007] No spec reference in any runbook, command, or accelerator still points at `docs/<spec>.md`; the audit grep returns zero stale hits — from `docs/security-requirements.md`.

## Architecture Contracts

- Honor the **Path contract (the boundary)** and the single **Canonical spec inventory** — from `docs/architecture.m19-draft.md`.
- Accelerators: change only spec paths in prompts/`out:` targets, NOT orchestration logic (phase order, fan-out) — from the M19 draft "Accelerators" boundary note and this issue's out-of-scope.
- `docs/guides/*` output paths stay (audience rule, ADR-M19-1).

## Build / CI Notes

- `implement.js` / `document.js` are Node accelerators run by Claude Code. After editing, confirm they still parse: `node --check agents/workflows/implement.js` and `node --check agents/workflows/document.js`.
- The gate is the audit grep returning zero stale references across this task's files.

## Technical Notes

**Estimated effort:** Large session
**Dependencies:** none (parallel with swe-feature-088, swe-feature-089, swe-feature-092)
**Out of scope:** Skills (swe-feature-088), roles **and the entire `docs/project-brief.md`** (swe-feature-089), fail-loud behavior (swe-feature-091), installer (swe-feature-092), `migrate-sdlc` (swe-feature-093). Do not change accelerator orchestration logic — only the spec paths in prompts/targets. Do not touch `docs/project-brief.md` at all — its only spec reference (the line-96 ownership convention) is owned end-to-end by swe-feature-089.
