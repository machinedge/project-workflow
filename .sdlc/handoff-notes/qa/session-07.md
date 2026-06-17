# Handoff Note: Grep Audit for Stale Path References

**Issue:** qa-feature-075 — QA: Grep Audit for Stale Path References

## What Was Accomplished

Comprehensive grep audit of the entire repository for stale path references (`docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, standalone `issues/`) that should have been updated to `.sdlc/` equivalents during M13. Searched all source files in `targets/ide/cursor/`, `targets/ide/claude-code/`, installed files in `.cursor/` and `.claude/`, install scripts, `docs/agent-reference.md`, and `docs/project-brief.md`.

## Findings Summary
- **Must-fix:** 0 issues
- **Should-fix:** 1 issue
- **Nit:** 1 (not filed)
- `issues/backlog/swe-bug-080.md` — Project brief Constraints section has stale `issues/` path (should-fix)
- Nit: `targets/ide/install.sh` line 119 comment mentions `issues/` but not `.sdlc/` (code comment, no functional impact)

## Acceptance Criteria Status
- [x] Grep audit completed across all in-scope files
- [x] Any stale references found are filed as bug issues in `issues/backlog/`
- [x] Cross-check: skills that reference both `docs/` (for planning docs) and `.sdlc/` (for managed artifacts) are using the correct path for each

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Install script old-path references classified as intentional, not stale | Lines 88/91 in install.sh and 49/52/55 in install.ps1 check for old directory layouts as M14 migration detection — correct behavior |
| Install.sh comment (line 119) classified as nit, no issue filed | Code comment only, no functional impact; cleanup section never touches `docs/`, `issues/`, or `.sdlc/` |

## Problems Encountered
The installed `update-issues-list.sh` script references `.sdlc/issues/` but this project's issues are still in `issues/` (pre-migration). Could not regenerate the issues list after filing swe-bug-080. This is the expected mismatch documented in swe-feature-074's handoff — it will resolve when M14 migration runs.

## Files Reviewed

### Source files — `targets/ide/cursor/` (full tree)
- rules/ (6 files), commands/ (9 files), skills/ (21 SKILL.md files), scripts/ (10 files), README.md — all `.sdlc/` paths correct

### Source files — `targets/ide/claude-code/` (full tree)
- CLAUDE.md, roles/ (5 files), commands/ (9 files), skills/ (21 SKILL.md files), scripts/ (11 files), README.md — all `.sdlc/` paths correct

### Installed files — `.cursor/` (full tree)
- rules/, commands/, skills/, scripts/ — all `.sdlc/` paths correct (mirrors source)

### Installed files — `.claude/` (full tree)
- CLAUDE.md, roles/, commands/, skills/, scripts/ — all `.sdlc/` paths correct (mirrors source)

### Install scripts
- `targets/ide/install.sh` — old-path refs are intentional (migration detection); one nit in comment (line 119)
- `targets/ide/install.ps1` — old-path refs are intentional (migration detection); no comment issue

### Docs
- `docs/agent-reference.md` — all paths correct (`.sdlc/issues/`, `.sdlc/handoff-notes/`)
- `docs/project-brief.md` — **one stale ref** on line 31: `issues/` should be `.sdlc/issues/` (swe-bug-080 filed)

### Cross-check verification
- `targets/ide/cursor/skills/qa-review/SKILL.md` — correct (`docs/` for planning, `.sdlc/` for artifacts)
- `targets/ide/cursor/commands/swe-start.md` — correct
- `targets/ide/claude-code/scripts/session-primer.sh` — correct

## What the Next Session Needs to Know

1. **M13 path migration is nearly clean.** Only 1 stale reference found across the entire repo (in `docs/project-brief.md`). The SWE work was high quality.

2. **swe-bug-080 is a trivial fix** — single-line change in `docs/project-brief.md` line 31. Can be done as part of any SWE session or bundled with M14 work.

3. **This project's own data hasn't migrated** (M14). Issues are in `issues/`, handoff notes in `docs/handoff-notes/`. Installed scripts reference `.sdlc/` paths. This mismatch is expected and will resolve with M14.

4. **The issues list (`issues/issues-list.md`) was not regenerated** after filing swe-bug-080 because the installed script expects `.sdlc/issues/`.

## Open Questions
- None
