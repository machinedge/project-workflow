# Handoff Note: Update Install Scripts for Fresh .workflow Structure

**Issue:** swe-feature-072 — Update Install Scripts for Fresh .workflow Structure

## What Was Accomplished

Updated `targets/ide/install.sh` and `targets/ide/install.ps1` to create `.sdlc/` directory structure instead of `docs/handoff-notes/` and top-level `issues/` on fresh installs. Added detection logic to distinguish fresh installs from existing old-structure installs. This completes M13 step 5 (install scripts).

## Acceptance Criteria Status
- [x] Fresh install creates `.sdlc/handoff-notes/{pm,swe,qa,devops,system-architect}/`
- [x] Fresh install creates `.sdlc/issues/{backlog,planned,in-progress,done}/`
- [x] Fresh install seeds `.sdlc/lessons-log.md` (instead of `docs/lessons-log.md`)
- [x] Fresh install still creates `docs/` for planning docs (project-brief.md, etc.)
- [x] Install script no longer creates `docs/handoff-notes/` or top-level `issues/` on fresh install
- [x] Script detects fresh install vs. existing install (has old structure) — fresh install path only in this task

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Detection heuristic: presence of `docs/handoff-notes/` OR `issues/` indicates old structure | Simple, reliable, covers both indicators. Edge case of non-toolkit `issues/` is acceptable — M14 migration can handle with user confirmation. |
| Already-migrated projects (have `.sdlc/`, no old structure) treated as fresh path | `mkdir -p` is idempotent and `lessons-log.md` check prevents overwrite — safe to re-run. |

## Problems Encountered
None.

## Scope Changes
None — executed exactly as scoped.

## Files Created or Modified
- `targets/ide/install.sh` — project structure section → `.sdlc/`, old-structure detection, updated uninstall message
- `targets/ide/install.ps1` — same changes in PowerShell

## What the Next Session Needs to Know
M13 steps 1-5 are now complete for both platforms:
1. ~~Update conventions (rules/roles)~~ — done (064 Cursor + 068 Claude Code)
2. ~~Update commands~~ — done (065 Cursor + 069 Claude Code)
3. ~~Update skills~~ — done (066 Cursor + 070 Claude Code)
4. ~~Update scripts~~ — done (067 Cursor + 071 Claude Code)
5. ~~Update install scripts~~ — done (072)
6. Update docs and READMEs (073)
7. Reinstall and verify (074)

## Open Questions
- [ ] None
