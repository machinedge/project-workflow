# Handoff Note: Update Cursor Rules for .workflow Paths

**Issue:** swe-feature-064 — Update Cursor Rules for .workflow Paths

## What Was Accomplished

Updated all 6 Cursor rule files in `targets/ide/cursor/rules/` to replace old artifact paths (`docs/handoff-notes/`, `docs/lessons-log.md`, `docs/interview-notes*`, `issues/`) with their `.sdlc/` equivalents per ADR-011. This is the first implementation step of M13 (Workflow Directory).

## Acceptance Criteria Status
- [x] `project-os.mdc` conventions section references `.sdlc/handoff-notes/` and `.sdlc/issues/`
- [x] `project-manager-os.mdc` references `.sdlc/` for handoff notes, interview notes, and issues paths
- [x] `swe-os.mdc` references `.sdlc/` for handoff notes, lessons-log, and issues paths
- [x] `qa-os.mdc` references `.sdlc/` for handoff notes, lessons-log, and issues paths
- [x] `devops-os.mdc` references `.sdlc/` for handoff notes and lessons-log paths
- [x] `system-architect-os.mdc` references `.sdlc/` for handoff notes and lessons-log paths
- [x] grep confirms zero stale references in `targets/ide/cursor/rules/`

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Purely mechanical path replacement per ADR-011 |

## Problems Encountered
None. Straightforward find-and-replace with clear path mapping from ADR-011.

## Scope Changes
None — executed exactly as scoped.

## Files Created or Modified
- `targets/ide/cursor/rules/project-os.mdc` — conventions + principles paths updated
- `targets/ide/cursor/rules/project-manager-os.mdc` — document locations updated
- `targets/ide/cursor/rules/swe-os.mdc` — document locations updated
- `targets/ide/cursor/rules/qa-os.mdc` — document locations updated
- `targets/ide/cursor/rules/devops-os.mdc` — document locations updated
- `targets/ide/cursor/rules/system-architect-os.mdc` — document locations updated

## What the Next Session Needs to Know
This was step 1 of the M13 implementation order defined in ADR-011. The remaining steps in order are:
1. ~~Update conventions (rules/roles)~~ — done (this session for Cursor; Claude Code roles still needed)
2. Update commands — `/start` commands load context from these paths
3. Update skills — largest surface area; mechanical find-and-replace
4. Update scripts — hardcoded paths in shell/PowerShell scripts
5. Update install scripts — fresh install creates new layout
6. Update docs and READMEs — documentation references
7. Reinstall and verify — end-to-end test

The Claude Code equivalent (CLAUDE.md + role files) is a separate task that follows the same pattern.

## Open Questions
- [ ] None
