# Handoff Note: Update Commands for .workflow Paths

**Issue:** swe-feature-065 — Update Cursor Commands for .workflow Paths
**Issue:** swe-feature-069 — Update Claude Code Commands for .workflow Paths

## What Was Accomplished

Updated all 16 command files (8 per platform) in `targets/ide/cursor/commands/` and `targets/ide/claude-code/commands/` to replace old artifact paths with `.workflow/` equivalents per ADR-011. This completes step 2 (commands) of the M13 implementation order for both platforms.

## Acceptance Criteria Status

### swe-feature-065 (Cursor)
- [x] All `/start` commands load handoff notes from `.workflow/handoff-notes/<expert>/`
- [x] All `/start` commands reference `.workflow/issues/` for issue discovery
- [x] `pm-interview.md` writes interview notes to `.workflow/`
- [x] `pm-add-feature.md` writes interview notes to `.workflow/`
- [x] `swe-start.md` and `sa-start.md` reference `.workflow/` for lessons-log
- [x] grep confirms zero stale references in `targets/ide/cursor/commands/`

### swe-feature-069 (Claude Code)
- [x] All `/start` commands load handoff notes from `.workflow/handoff-notes/<expert>/`
- [x] All `/start` commands reference `.workflow/issues/` for issue discovery
- [x] `pm-interview.md` writes interview notes to `.workflow/`
- [x] `pm-add-feature.md` writes interview notes to `.workflow/`
- [x] `swe-start.md` and `sa-start.md` reference `.workflow/` for lessons-log
- [x] grep confirms zero stale references in `targets/ide/claude-code/commands/`

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Purely mechanical path replacement per ADR-011, mirroring sessions 34-35 |

## Problems Encountered
None.

## Scope Changes
None — executed exactly as scoped. `ops-env-discovery.md` required no changes on either platform (only references `docs/project-brief.md` and `docs/env-context.md`, which stay in `docs/`).

## Files Created or Modified
- `targets/ide/cursor/commands/pm-start.md` — issue discovery + handoff notes paths updated
- `targets/ide/cursor/commands/pm-interview.md` — interview notes directory + save path updated
- `targets/ide/cursor/commands/pm-add-feature.md` — interview notes save path updated
- `targets/ide/cursor/commands/swe-start.md` — lessons-log, issue discovery, handoff notes paths updated
- `targets/ide/cursor/commands/qa-start.md` — issue discovery, handoff notes (qa + swe), issue creation path updated
- `targets/ide/cursor/commands/sa-start.md` — lessons-log, issue discovery, handoff notes paths updated
- `targets/ide/cursor/commands/ops-start.md` — issue discovery, handoff notes (devops + swe) paths updated
- `targets/ide/cursor/commands/ops-deploy.md` — 7 issue path references updated
- `targets/ide/claude-code/commands/` — same 8 files, identical changes

## What the Next Session Needs to Know
Steps 1 (conventions/roles) and 2 (commands) are now complete for both Cursor and Claude Code. The remaining M13 steps in order:
1. ~~Update conventions (rules/roles)~~ — done (064 Cursor + 068 Claude Code)
2. ~~Update commands~~ — done (065 Cursor + 069 Claude Code)
3. Update skills — largest surface area (066 Cursor, 070 Claude Code)
4. Update scripts — shell/PowerShell (067 Cursor, 071 Claude Code)
5. Update install scripts (072)
6. Update docs and READMEs (073)
7. Reinstall and verify (074)

## Open Questions
- [ ] None
