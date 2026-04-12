# Handoff Note: Reinstall and Verify .workflow Paths

**Issue:** swe-feature-074 — Reinstall Into Project and Verify All Paths

## What Was Accomplished

Ran the install script on this project to copy all updated source files into `.cursor/` and `.claude/`. Ran the grep audits from the acceptance criteria — both returned zero stale references. 81 files updated (312 insertions, 312 deletions — all path replacements).

Also completed swe-feature-073 (docs and READMEs) in the same session as a prerequisite.

## Acceptance Criteria Status
- [x] Install script runs successfully on this project
- [x] `.cursor/rules/`, `.cursor/commands/`, `.cursor/skills/`, `.cursor/scripts/` all reference `.workflow/` paths
- [x] `.claude/roles/`, `.claude/commands/`, `.claude/skills/`, `.claude/scripts/`, `.claude/CLAUDE.md` all reference `.workflow/` paths
- [x] `grep -r 'docs/handoff-notes|docs/lessons-log|docs/interview-notes' .cursor/ .claude/` returns zero matches
- [x] `grep -r 'issues/backlog|issues/planned|issues/in-progress|issues/done' .cursor/ .claude/` — all matches are `.workflow/issues/` (no stale standalone `issues/` refs)

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Verification-only task |

## Problems Encountered
The reinstalled `next-session-number.sh` now looks in `.workflow/handoff-notes/swe/` which is empty — this project's data hasn't migrated yet (M14). Session numbering will be off for installed scripts until migration. Not a bug — expected edge case documented in swe-feature-072's detection logic.

## Scope Changes
None — executed exactly as scoped.

## Files Created or Modified
- `.cursor/` — 40 files updated via install
- `.claude/` — 41 files updated via install
- (swe-feature-073 also in this session: `docs/agent-reference.md`, `targets/ide/cursor/README.md`, `targets/ide/claude-code/README.md`)

## What the Next Session Needs to Know
**M13 is now complete.** All 7 steps done:
1. ~~Update conventions (rules/roles)~~ — 064, 068
2. ~~Update commands~~ — 065, 069
3. ~~Update skills~~ — 066, 070
4. ~~Update scripts~~ — 067, 071
5. ~~Update install scripts~~ — 072
6. ~~Update docs and READMEs~~ — 073
7. ~~Reinstall and verify~~ — 074

Next up is M14: migration support for existing projects that have data in `docs/handoff-notes/`, `docs/lessons-log.md`, and `issues/`.

**Important:** The installed scripts now reference `.workflow/` paths. This project's own data is still in the old locations (`docs/handoff-notes/`, `issues/`). The repo's own `project-os.mdc` (which is the always-applied rule, not the installed version) still references old paths. Until M14 migration runs, there's a mismatch between installed script paths and actual data locations in this project.

## Open Questions
- [ ] None
