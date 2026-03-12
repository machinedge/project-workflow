# Handoff Note: Create Target-Class Directories and Relocate Files

**Session date:** 2026-03-12
**Issue:** swe-feature-014 — Create Target-Class Directories and Relocate Files

## What Was Accomplished

Implemented the full directory restructure defined in `docs/architecture.md`. Created the new `targets/` (with `ide/`, `desktop-cli/claude/`, `autonomous/openclaw/` subdirectories) and `tools/` (with `scaffold/`, `validate/`) directory trees. Moved all 43 tracked files from `framework/` and `package/` to their new locations using `git mv` (preserving history), plus gitignored build artifacts via plain `mv`. Removed the old `framework/` and `package/` directories.

## Acceptance Criteria Status

- [x] New directory structure matches what `docs/architecture.md` specifies
- [x] All files from `framework/` have been moved to their new locations (nothing left behind)
- [x] All files from `package/` have been moved to their new locations (nothing left behind)
- [x] OpenClaw code (templates, team install scripts) is in its own target directory (`targets/autonomous/openclaw/`)
- [x] `package/tools/` utilities (new_repo, list-experts) are in their designated location per architecture.md (`tools/`), with `new_repo` renamed to `new-repo`
- [x] Old `framework/` and `package/` directories are removed
- [x] No files are deleted — everything is relocated

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Used `git mv` for all tracked files | Preserves git history across the rename so `git log --follow` works |
| Used plain `mv` for `package/build/` contents | These are gitignored build artifacts; `git mv` doesn't work on untracked files |
| Updated `.gitignore` from `package/build` to `targets/desktop-cli/claude/build` | Direct consequence of the move; without this, build artifacts would be tracked |

## Problems Encountered

None. The migration mapping in `docs/architecture.md` was precise and unambiguous. Every file had a clear destination.

## Scope Changes

None. Stayed exactly within the issue scope. Did not update script contents (swe-feature-015) or documentation references (swe-feature-016).

## Files Created or Modified

**New directories created:**
- `targets/ide/`, `targets/ide/cursor/`, `targets/ide/claude-code/`
- `targets/desktop-cli/claude/`, `targets/desktop-cli/claude/build/`
- `targets/autonomous/openclaw/`, `targets/autonomous/openclaw/templates/`
- `tools/`, `tools/scaffold/`, `tools/validate/`

**Files moved (43 tracked, via `git mv`):**
- `framework/install/install.{sh,ps1}` → `targets/ide/`
- `framework/install/targets/cursor/README.md` → `targets/ide/cursor/`
- `framework/install/targets/claude-code/README.md` → `targets/ide/claude-code/`
- `framework/install/install-team.{sh,ps1}` → `targets/autonomous/openclaw/`
- `framework/install/targets/openclaw/README.md` → `targets/autonomous/openclaw/`
- `framework/install/templates/team/*` (11 files) → `targets/autonomous/openclaw/templates/`
- `framework/scaffold/*` (11 files) → `tools/scaffold/`
- `framework/validate/validate.sh` → `tools/validate/`
- `framework/docs/agent-reference.md` → `docs/`
- `framework/docs/CONTRIBUTING.md` → repo root
- `package/{package,install-skill,uninstall-skill}.{sh,ps1}` + `SKILL.md` → `targets/desktop-cli/claude/`
- `package/tools/new_repo.{sh,ps1}` → `tools/new-repo.{sh,ps1}` (renamed)
- `package/tools/list-experts.{sh,ps1}` → `tools/`

**Build artifacts moved (gitignored, via plain `mv`):**
- `package/build/*` → `targets/desktop-cli/claude/build/`

**Modified:**
- `.gitignore` — updated build path from `package/build` to `targets/desktop-cli/claude/build`

**Removed:**
- `framework/` — empty after all files moved
- `package/` — empty after all files moved

## What the Next Session Needs to Know

The directory restructure is complete but **scripts still reference old paths**. Every script that uses `framework/` or `package/` paths will break until swe-feature-015 updates them. Key scripts to fix:
- `targets/ide/install.sh` and `install.ps1` — reference `framework/` paths internally
- `targets/desktop-cli/claude/package.sh` and `package.ps1` — reference `package/` paths internally
- `tools/validate/validate.sh` — may reference `framework/` paths
- `tools/scaffold/create-expert.sh` and `.ps1` — may reference `framework/` paths
- `CLAUDE.md` repo guide still references `framework/` and `package/` — that's swe-feature-016

The `.gitignore` update was the only content change made; everything else was pure file relocation.

## Open Questions

None.
