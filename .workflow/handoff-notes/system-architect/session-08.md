# Handoff Note: Design .workflow Directory Structure and Path Mapping

**Issue:** sa-feature-063 — Design .workflow directory structure and path mapping

## What Was Accomplished
Designed the `.workflow/` directory structure (ADR-011) with a complete path mapping table covering all managed artifacts that move from `docs/` and top-level `issues/` into `.workflow/`. Conducted a systematic audit of ~90 files per platform to inventory every path reference that needs updating.

## Acceptance Criteria Status
- [x] Path mapping table documents every old path and its new `.workflow/` equivalent
- [x] Directory tree diagram shows the complete `.workflow/` layout
- [x] `docs/` retention list explicitly names which files stay
- [x] Naming conventions for scripts that reference paths are documented
- [x] Edge cases documented: what happens when a skill references both a `docs/` file that stays and a `docs/` file that moves
- [x] Design saved to `docs/architecture.md` as an addendum or ADR

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Flat `.workflow/` structure (Option A) | Artifacts already have clear names; sub-categories add depth without value. The move is a prefix change, not a reorganization. |

## Downstream Impact
- SWE tasks (swe-feature-064 through swe-feature-074) now have an unambiguous path mapping reference for mechanical find-and-replace
- The implementation order section in ADR-011 gives SWE the recommended sequence: conventions first, then rules/roles, commands, skills, scripts, install, docs, verify
- QA grep audit (qa-feature-075) can use the path mapping table as its checklist
- `docs/research-*.md` has zero code references — SWE tasks don't need to update any code for this artifact, only the install script scaffolding (if research outputs are ever scaffolded)

## Problems Encountered
None. The interview notes were clear on all boundary decisions and the audit revealed no surprises.

## Files Created or Modified
- `docs/architecture.md` — added ADR-011 to decisions table, updated install step 4, appended full ADR with directory tree, path mapping, retention list, script changes, conventions update, edge cases, and implementation order

## What the Next Session Needs to Know
sa-feature-063 is complete. ADR-011 in `docs/architecture.md` is the single reference for all M13 implementation tasks. The implementation order section specifies the sequence SWE should follow. Six edge cases are documented including the self-referential updates needed in `architecture.md` itself. No open questions remain.

## Open Questions
- None
