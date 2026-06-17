# Handoff Note: Update Scripts for .workflow Paths

**Issue:** swe-feature-067 — Update Cursor Scripts for .workflow Paths
**Issue:** swe-feature-071 — Update Claude Code Scripts for .workflow Paths

## What Was Accomplished

Updated all shell and PowerShell scripts in `targets/ide/cursor/scripts/` and `targets/ide/claude-code/scripts/` to replace hardcoded `docs/handoff-notes/` and `issues/` paths with `.sdlc/handoff-notes/` and `.sdlc/issues/` equivalents per ADR-011. Also updated `test-scripts.sh` (Cursor) and `session-primer.sh` (Claude Code). This completes step 4 (scripts) of the M13 implementation order for both platforms.

## Acceptance Criteria Status

### swe-feature-067 (Cursor)
- [x] `move-issue.sh` and `move-issue.ps1` operate on `.sdlc/issues/`
- [x] `next-issue-number.sh` and `.ps1` scan `.sdlc/issues/`
- [x] `next-session-number.sh` and `.ps1` create handoff notes in `.sdlc/handoff-notes/`
- [x] `update-issues-list.sh` and `.ps1` scan `.sdlc/issues/` and write `.sdlc/issues/issues-list.md`
- [x] `update-brief-status.sh` and `.ps1` still update `docs/project-brief.md` (stays in `docs/`)
- [x] `test-scripts.sh` validates the new `.sdlc/` directory structure
- [x] grep confirms only `docs/project-brief.md` references remain

### swe-feature-071 (Claude Code)
- [x] `move-issue.sh` and `move-issue.ps1` operate on `.sdlc/issues/`
- [x] `next-issue-number.sh` and `.ps1` scan `.sdlc/issues/`
- [x] `next-session-number.sh` and `.ps1` create handoff notes in `.sdlc/handoff-notes/`
- [x] `update-issues-list.sh` and `.ps1` scan `.sdlc/issues/` and write `.sdlc/issues/issues-list.md`
- [x] `session-primer.sh` reads handoff notes from `.sdlc/handoff-notes/`
- [x] `update-brief-status.sh` and `.ps1` still update `docs/project-brief.md` (stays in `docs/`)
- [x] grep confirms only `docs/project-brief.md` references remain

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Purely mechanical path replacement per ADR-011, mirroring sessions 34-37 |

## Problems Encountered
None.

## Scope Changes
None — executed exactly as scoped.

## Files Created or Modified
- `targets/ide/cursor/scripts/move-issue.sh` — issues/ → .sdlc/issues/
- `targets/ide/cursor/scripts/move-issue.ps1` — issues/ → .sdlc/issues/
- `targets/ide/cursor/scripts/next-issue-number.sh` — issues/ → .sdlc/issues/
- `targets/ide/cursor/scripts/next-issue-number.ps1` — issues/ → .sdlc/issues/
- `targets/ide/cursor/scripts/next-session-number.sh` — docs/handoff-notes/ → .sdlc/handoff-notes/
- `targets/ide/cursor/scripts/next-session-number.ps1` — docs/handoff-notes/ → .sdlc/handoff-notes/
- `targets/ide/cursor/scripts/update-issues-list.sh` — issues/ → .sdlc/issues/
- `targets/ide/cursor/scripts/update-issues-list.ps1` — issues/ → .sdlc/issues/
- `targets/ide/cursor/scripts/test-scripts.sh` — all test fixtures updated to .sdlc/ paths
- `targets/ide/claude-code/scripts/move-issue.sh` — issues/ → .sdlc/issues/
- `targets/ide/claude-code/scripts/move-issue.ps1` — issues/ → .sdlc/issues/
- `targets/ide/claude-code/scripts/next-issue-number.sh` — issues/ → .sdlc/issues/
- `targets/ide/claude-code/scripts/next-issue-number.ps1` — issues/ → .sdlc/issues/
- `targets/ide/claude-code/scripts/next-session-number.sh` — docs/handoff-notes/ → .sdlc/handoff-notes/
- `targets/ide/claude-code/scripts/next-session-number.ps1` — docs/handoff-notes/ → .sdlc/handoff-notes/
- `targets/ide/claude-code/scripts/update-issues-list.sh` — issues/ → .sdlc/issues/
- `targets/ide/claude-code/scripts/update-issues-list.ps1` — issues/ → .sdlc/issues/
- `targets/ide/claude-code/scripts/session-primer.sh` — docs/handoff-notes → .sdlc/handoff-notes

## What the Next Session Needs to Know
Steps 1 (conventions/roles), 2 (commands), 3 (skills), and 4 (scripts) are now complete for both Cursor and Claude Code. The remaining M13 steps in order:
1. ~~Update conventions (rules/roles)~~ — done (064 Cursor + 068 Claude Code)
2. ~~Update commands~~ — done (065 Cursor + 069 Claude Code)
3. ~~Update skills~~ — done (066 Cursor + 070 Claude Code)
4. ~~Update scripts~~ — done (067 Cursor + 071 Claude Code)
5. Update install scripts (072)
6. Update docs and READMEs (073)
7. Reinstall and verify (074)

## Open Questions
- [ ] None
