# Handoff Note: Update Claude Code Rules for .workflow Paths

**Issue:** swe-feature-068 — Update Claude Code Rules for .workflow Paths

## What Was Accomplished

Updated `CLAUDE.md` and all 5 Claude Code role files in `targets/ide/claude-code/roles/` to replace old artifact paths (`docs/handoff-notes/`, `docs/lessons-log.md`, `docs/interview-notes*`, `issues/`) with their `.sdlc/` equivalents per ADR-011. This completes step 1 (conventions/roles) of the M13 implementation order for both platforms.

## Acceptance Criteria Status
- [x] `CLAUDE.md` conventions section references `.sdlc/handoff-notes/` and `.sdlc/issues/`
- [x] `project-manager.md` references `.sdlc/` for handoff notes, interview notes, and issues paths
- [x] `swe.md` references `.sdlc/` for handoff notes, lessons-log, and issues paths
- [x] `qa.md` references `.sdlc/` for handoff notes, lessons-log, and issues paths
- [x] `devops.md` references `.sdlc/` for handoff notes and lessons-log paths
- [x] `system-architect.md` references `.sdlc/` for handoff notes and lessons-log paths
- [x] grep confirms zero stale references in `targets/ide/claude-code/roles/` and `CLAUDE.md`

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Purely mechanical path replacement per ADR-011, mirroring swe-feature-064 |

## Problems Encountered
None.

## Scope Changes
None — executed exactly as scoped.

## Files Created or Modified
- `targets/ide/claude-code/CLAUDE.md` — conventions + principles paths updated
- `targets/ide/claude-code/roles/project-manager.md` — document locations updated
- `targets/ide/claude-code/roles/swe.md` — document locations updated
- `targets/ide/claude-code/roles/qa.md` — document locations updated
- `targets/ide/claude-code/roles/devops.md` — document locations updated
- `targets/ide/claude-code/roles/system-architect.md` — document locations updated

## What the Next Session Needs to Know
Step 1 (conventions/roles) is now complete for both Cursor and Claude Code. The remaining M13 steps in order:
1. ~~Update conventions (rules/roles)~~ — done (064 Cursor + 068 Claude Code)
2. Update commands — `/start` commands (065 Cursor, 069 Claude Code)
3. Update skills — largest surface area (066 Cursor, 070 Claude Code)
4. Update scripts — shell/PowerShell (067 Cursor, 071 Claude Code)
5. Update install scripts (072)
6. Update docs and READMEs (073)
7. Reinstall and verify (074)

## Open Questions
- [ ] None
