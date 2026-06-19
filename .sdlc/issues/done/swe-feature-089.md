# Repoint role files, AGENTS.md conventions, and brief convention to .sdlc/

**Type:** feature
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:**
**Detail level:** implementation-ready

## User Story

As an expert loading my role at session start, I want my role file and the shared conventions to name `.sdlc/<spec>.md` as the artifact I own and consume, so that I author and read specs at the correct location and never write to the deprecated `docs/` path.

## Description

Every role file names `docs/<spec>.md` as the artifact the expert "owns" or "consumes", the project brief codifies that ownership convention (line 96), and `AGENTS.md` describes the workflow-contract convention. Repoint all of these to `.sdlc/`. The brief and roadmap files themselves stay in `docs/` — only the ownership-path *text* inside the brief changes.

## Files to Create or Modify

| Path | Action | What changes |
|------|--------|--------------|
| `agents/roles/system-architect.md` | modify | owned/consumed → `.sdlc/architecture.md`, `.sdlc/components.md`, `.sdlc/research/` |
| `agents/roles/security-engineer.md` | modify | owned/consumed → `.sdlc/security-requirements.md`, `.sdlc/security/` |
| `agents/roles/ux-designer.md` | modify | owned/consumed → `.sdlc/ux-guidelines.md` |
| `agents/roles/technical-writer.md` | modify | owns `.sdlc/documentation-plan.md`; still owns `docs/guides/` (unchanged) |
| `agents/roles/qa.md` | modify | owned/consumed → `.sdlc/test-plan.md`, `.sdlc/architecture.md` |
| `agents/roles/devops.md` | modify | owned/consumed → `.sdlc/pipeline.md`, `.sdlc/release-plan.md`, `.sdlc/env-context.md`, `.sdlc/runbooks/` |
| `agents/roles/swe.md` | modify | consumed → `.sdlc/architecture.md`, `.sdlc/test-plan.md`, `.sdlc/security-requirements.md` |
| `agents/roles/project-manager.md` | modify | consumed specs + `.sdlc/task-detail-standard.md` |
| `agents/AGENTS.md` | modify | Conventions section states expert specs/plans/drafts live in `.sdlc/`; `docs/` is user-facing only (`guides/`, `README.md`, `project-brief.md`, `roadmap.md`) |
| `docs/project-brief.md` | modify | line 96 ownership convention → each owner at `.sdlc/<spec>.md`; Constraints/Notes reflect `docs/` = user-facing-only boundary |

The current brief line 96 reads:
> `- The System Architect owns docs/architecture.md; the Security Engineer owns docs/security-requirements.md; the UX Designer owns docs/ux-guidelines.md; the Technical Writer owns docs/documentation-plan.md and docs/guides/; all other experts consume them`

Repoint every `docs/<spec>.md` in that line to `.sdlc/<spec>.md`, but keep `docs/guides/` (Technical Writer's user-facing output) as `docs/guides/`.

## Interfaces and Data Models

No code interface. Apply the same path-substitution contract as swe-feature-088, using the canonical spec inventory from `docs/architecture.m19-draft.md`:
- `docs/<spec>.md` → `.sdlc/<spec>.md` for every spec in the inventory
- `docs/research|security|runbooks/` → `.sdlc/research|security|runbooks/`
- `docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md`, `docs/agent-reference.md` → **unchanged** (audience rule, ADR-M19-1)

## Implementation Outline

1. Grep the scope: `grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/roles/ agents/AGENTS.md docs/project-brief.md`.
2. For each role file, repoint the "owns" / "consumes" lines to `.sdlc/`. Keep `docs/guides/` in `technical-writer.md` (user-facing output).
3. In `agents/AGENTS.md`, add/adjust the Conventions text to state the boundary: expert specs/plans/drafts in `.sdlc/`; `docs/` holds only `guides/`, `README.md`, `project-brief.md`, `roadmap.md`.
4. Edit `docs/project-brief.md` line 96 ownership convention and the Constraints/Notes to reflect `docs/` = user-facing-only. Do NOT move the brief file itself. Do NOT edit `CLAUDE.md` (symlink to `AGENTS.md`).
5. Re-grep the scope; confirm no role file or AGENTS.md still names an *authored* spec at `docs/<spec>.md`.

## Acceptance Criteria

- [ ] Each role file (`system-architect.md`, `security-engineer.md`, `ux-designer.md`, `technical-writer.md`, `qa.md`, `devops.md`, `swe.md`, `project-manager.md`) names its owned/consumed specs at `.sdlc/<spec>.md`
- [ ] `agents/AGENTS.md` conventions section states that expert-authored specs/plans/drafts live in `.sdlc/` and `docs/` is user-facing only (`guides/`, `README.md`, `project-brief.md`, `roadmap.md`)
- [ ] The project brief's codified ownership convention (line ~96) points each owner at `.sdlc/<spec>.md`
- [ ] The project brief's Constraints/Notes reflect the `docs/` = user-facing-only boundary
- [ ] No role file or AGENTS.md still names an *authored* spec at `docs/<spec>.md`
- [ ] References to `docs/project-brief.md`, `docs/roadmap.md`, `docs/guides/`, and `docs/agent-reference.md` remain unchanged (these stay user/contributor-facing)

## Test Specification

**Test instrument:** the deterministic audit grep.

| Case | Input | Expected result |
|------|-------|-----------------|
| Roles repointed | `grep -rn -E 'docs/(architecture\|pipeline\|components\|documentation-plan\|test-plan\|security-requirements\|ux-guidelines\|task-detail-standard\|env-context\|release-plan)\.md\|docs/(research\|security\|runbooks)/' agents/roles/ agents/AGENTS.md` | zero hits |
| Brief ownership repointed | grep `docs/project-brief.md` line 96 for `docs/architecture.md` | absent; `.sdlc/architecture.md` present |
| Guides preserved in TW role | grep `agents/roles/technical-writer.md` for `docs/guides/` | still present (unchanged) |
| Brief/roadmap refs preserved | `grep -rn 'docs/project-brief.md\|docs/roadmap.md' agents/roles/ agents/AGENTS.md` | still resolve to `docs/` |

## Security Constraints

- [SR-007] No role/AGENTS spec reference still points at `docs/<spec>.md`; the audit grep returns zero stale hits — from `docs/security-requirements.md`.

## Architecture Contracts

- Honor the **Path contract (the boundary)** and the single **Canonical spec inventory** — from `docs/architecture.m19-draft.md`.
- **Boundary by audience, not authorship** (ADR-M19-1): brief, roadmap, and `agent-reference.md` stay in `docs/` even though experts author/touch them — only the ownership-path *text* inside the brief changes; the files do not move.
- `CLAUDE.md` is a symlink to `AGENTS.md` — edit `AGENTS.md`, never `CLAUDE.md` (from the Constraints in the M19 draft).

## Build / CI Notes

- No compiled artifact. The gate is the audit grep returning zero stale references in `agents/roles/`, `agents/AGENTS.md`, and the brief ownership line.

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** none (parallel with swe-feature-088, swe-feature-090, swe-feature-092)
**Out of scope:** Skills (swe-feature-088), runbooks/commands/accelerators (swe-feature-090), installer (swe-feature-092), fail-loud behavior (swe-feature-091), `migrate-sdlc` (swe-feature-093). Do not move the brief or roadmap files. Do not edit `CLAUDE.md`. Do not touch `docs/agent-reference.md`.
