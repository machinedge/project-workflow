# Handoff Note: Update Documentation References and Remove CLAUDE.md

**Session date:** 2026-03-12
**Issue:** swe-feature-016 — Update Documentation References and Remove CLAUDE.md

## What Was Accomplished

Updated all documentation files to reference the new `targets/` and `tools/` directory layout instead of the old `framework/` and `package/` paths. Deleted `CLAUDE.md` from the repo root and preserved its essential content (repo structure tree, key concepts) in `docs/agent-reference.md`. Updated `package.sh` and `package.ps1` to create the new directory layout inside the built `.skill` package (matching SKILL.md's updated path references).

## Acceptance Criteria Status

- [x] `CLAUDE.md` is deleted from the repo root
- [x] `docs/agent-reference.md` reflects the new directory layout (Key Directories table, repo structure tree, System Architect in experts table and Producer/Consumer matrix, all paths updated)
- [x] `targets/desktop-cli/claude/SKILL.md` reflects the new structure (all `framework/install/` → `targets/ide/` and `targets/autonomous/openclaw/`)
- [x] `experts/technical/shared/docs-protocol.md` has no stale path references (was already clean)
- [x] `docs/project-brief.md` "Notes for AI" section updated (no reference to `CLAUDE.md`)
- [x] `docs/overview.md`, `docs/getting-started.md`, `docs/workflow-anatomy.md` — these files don't exist; no action needed
- [x] No documentation file in the repo contains stale `framework/` or `package/` path references (verified via grep sweep; remaining hits are all in historical records: handoff notes, completed issues, architecture migration mapping, interview notes)
- [x] Essential repo-guide content from `CLAUDE.md` is preserved in `docs/agent-reference.md` (repo structure tree, key directories, expert listing, common mistakes, validation, document contracts)

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Updated `package.sh`/`package.ps1` to use new layout inside the package (beyond issue's "docs only" scope) | SKILL.md is both documentation and a runtime artifact — updating its path references without updating the package layout would break the deployed skill. User approved the scope expansion. |
| Package now creates `targets/ide/` and `targets/autonomous/openclaw/` inside the skill package instead of `framework/install/` | Follows the same directory structure as the repo. Eliminates the backward-compatibility shim that reconstructed the old layout. |
| Left `framework/` and `package/` references in historical records untouched | Handoff notes, completed issues, architecture migration mapping, and interview notes are historical records describing what happened at the time. Changing them would falsify history. |

## Problems Encountered

None. The migration mapping in `docs/architecture.md` made every path change unambiguous. The only design question was about the SKILL.md/package.sh coupling, which the user resolved by approving the scope expansion.

## Scope Changes

Expanded beyond "documentation only" to include `package.sh` and `package.ps1` changes. The user directed this because SKILL.md's path references and the package layout must stay in sync — you can't update one without the other.

Also updated `targets/autonomous/openclaw/README.md` (discovered during grep sweep — had a stale `framework/install/` reference not listed in the original acceptance criteria).

## Files Created or Modified

**Modified (9 files):**
- `targets/desktop-cli/claude/SKILL.md` — All `framework/install/` paths → `targets/ide/` and `targets/autonomous/openclaw/`; `new_repo.sh` → `new-repo.sh`; `./framework/scaffold/` → `./tools/scaffold/`
- `targets/desktop-cli/claude/package.sh` — Package layout changed from `framework/install/` to `targets/ide/` + `targets/autonomous/openclaw/`
- `targets/desktop-cli/claude/package.ps1` — Same as package.sh
- `docs/agent-reference.md` — Key Directories table, repo structure tree added, System Architect in experts table and Producer/Consumer matrix, all scaffold/validate/tools paths updated
- `docs/project-brief.md` — CLAUDE.md removal marked done, status updated, CLAUDE.md removed from Notes for AI
- `docs/test-plan.md` — All ATP procedure paths updated
- `README.md` — Repository Structure tree rewritten, Team Mode path updated, expert tree updated with System Architect
- `CONTRIBUTING.md` — All scaffold, validate, and package paths updated
- `targets/autonomous/openclaw/README.md` — Usage example path updated

**Deleted (1 file):**
- `CLAUDE.md` — Essential content preserved in `docs/agent-reference.md`

## What the Next Session Needs to Know

1. All documentation now references the new `targets/` and `tools/` layout. The deployment restructure (M6-M7) is documentation-complete.

2. The `package.sh` now creates `targets/ide/` and `targets/autonomous/openclaw/` inside the built package instead of `framework/install/`. The `install-team.sh` walk-up approach (searching upward for `experts/`) should still work at this new depth, but it hasn't been runtime-tested — team mode requires Docker.

3. The natural next step is `qa-feature-017` (Verify Deployment Restructure End-to-End) which would catch any remaining integration issues.

4. `docs/overview.md`, `docs/getting-started.md`, and `docs/workflow-anatomy.md` are referenced in `README.md` and `docs/agent-reference.md` but don't exist yet. They should either be created or the references should be removed.

## Open Questions

None.
