# Handoff Note: Test Migration on This Project

**Issue:** swe-feature-078 — Test Migration on This Project

## What Was Accomplished

Ran the `.sdlc/` migration on this project using both `install.sh` (bash) and `install.ps1` (PowerShell). Both scripts correctly detected the old directory layout, moved all managed artifacts to `.sdlc/`, left `docs/` with only planning docs, and removed the old directories. All 9 acceptance criteria pass on both platforms.

## Acceptance Criteria Status
- [x] `.sdlc/handoff-notes/` contains all expert subdirectories with existing handoff notes
- [x] `.sdlc/issues/` contains `backlog/`, `planned/`, `in-progress/`, `done/`, and `issues-list.md`
- [x] `.sdlc/` contains all `interview-notes-*.md` files (8 files)
- [x] `.sdlc/lessons-log.md` exists
- [x] `.sdlc/` contains all `research-*.md` files
- [x] `docs/` contains only `project-brief.md`, `roadmap.md`, `test-plan.md`, `architecture.md`, `agent-reference.md`
- [x] Top-level `issues/` directory no longer exists
- [x] `docs/handoff-notes/` directory no longer exists
- [x] Expert session reads from `.sdlc/` paths — scripts (`next-session-number.sh`, `next-issue-number.sh`, `update-issues-list.sh`) all work correctly

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Used `install.sh`/`install.ps1` rather than manual migration | Validates the real user-facing migration path; reinstalling toolkit files into the source repo is a harmless no-op |
| Tested both bash and PowerShell install scripts | User has PowerShell available; closes the long-standing "install.ps1 untested" gap |
| Removed empty `.sdlc/handoff-notes/project-manager/` dir after bash migration | Convention uses `pm/`, not `project-manager/`; was a pre-existing artifact, not created by the migration |

## Problems Encountered

None. Both install scripts worked correctly as shipped — no code changes needed.

## Scope Changes

Added PowerShell testing at user's request. This was out of scope per the original issue but valuable — it closes the testing gap noted in multiple prior sessions.

## Files Created or Modified

No files manually created or modified. The install scripts handled all file movement:
- `docs/handoff-notes/` → `.sdlc/handoff-notes/` (pm/3, swe/41, qa/7, sa/8, devops/empty)
- `issues/` → `.sdlc/issues/` (78 done, 2 backlog, issues-list.md)
- `docs/lessons-log.md` → `.sdlc/lessons-log.md`
- `docs/interview-notes-*.md` (8 files) → `.sdlc/`
- `docs/research-context-optimization.md` → `.sdlc/`

## What the Next Session Needs to Know

- **M14 is complete.** All migration tasks (swe-feature-076, 077, 078) and the stale path fix (swe-bug-080) are done.
- The project is now in the migrated state — `.sdlc/` is the canonical location for managed artifacts.
- Both `install.sh` and `install.ps1` have been functionally tested and produce identical results.
- The `CLAUDE.md` file installed to `.claude/` still references old paths (`docs/handoff-notes/`, `issues/`) — this is the source-of-truth file from `targets/ide/claude-code/CLAUDE.md`. The Cursor `project-os.mdc` was already updated in an earlier task. If `CLAUDE.md` hasn't been updated yet, that's a separate issue.

## Open Questions

- [ ] Is M14 formally complete, or does PM need to run a postmortem first?
- [ ] The `.claude/CLAUDE.md` conventions section may still reference old paths — verify and file an issue if needed.
