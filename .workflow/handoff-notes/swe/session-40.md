# Handoff Note: Update Docs and READMEs for .workflow Paths

**Issue:** swe-feature-073 — Update agent-reference.md and READMEs for .workflow Paths

## What Was Accomplished

Updated `docs/agent-reference.md`, `targets/ide/cursor/README.md`, and `targets/ide/claude-code/README.md` to replace all stale path references (`docs/handoff-notes/`, `docs/lessons-log.md`, `issues/`) with `.workflow/` equivalents. This completes M13 step 6 (docs and READMEs).

## Acceptance Criteria Status
- [x] `docs/agent-reference.md` repo tree diagram shows `.workflow/` instead of `issues/` and `docs/handoff-notes/`
- [x] `docs/agent-reference.md` document contracts table references `.workflow/` paths
- [x] `docs/agent-reference.md` "In-Repo Issue Tracking" section references `.workflow/issues/`
- [x] `targets/ide/cursor/README.md` references `.workflow/` for managed artifacts
- [x] `targets/ide/claude-code/README.md` references `.workflow/` for managed artifacts
- [x] Grep audit returns zero stale path matches

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Purely mechanical path replacement |

## Problems Encountered
None.

## Scope Changes
None — executed exactly as scoped.

## Files Created or Modified
- `docs/agent-reference.md` — repo tree, document contracts table, issue tracking section, common mistakes
- `targets/ide/cursor/README.md` — scaffolding tree, script comments/descriptions, uninstall note
- `targets/ide/claude-code/README.md` — same changes as Cursor README

## What the Next Session Needs to Know
M13 steps 1-6 are now complete:
1. ~~Update conventions (rules/roles)~~ — done (064 Cursor + 068 Claude Code)
2. ~~Update commands~~ — done (065 Cursor + 069 Claude Code)
3. ~~Update skills~~ — done (066 Cursor + 070 Claude Code)
4. ~~Update scripts~~ — done (067 Cursor + 071 Claude Code)
5. ~~Update install scripts~~ — done (072)
6. ~~Update docs and READMEs~~ — done (073)
7. Reinstall and verify (074)

Only swe-feature-074 remains: reinstall the updated toolkit into this project and run the grep audit on installed files.

## Open Questions
- [ ] None
