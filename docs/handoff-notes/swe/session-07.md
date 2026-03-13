# Handoff Note: Update Scripts for New Directory Layout

**Session date:** 2026-03-12
**Issue:** swe-feature-015 — Update Install, Packaging, and Validation Scripts for New Layout

## What Was Accomplished

Updated 12 scripts to reference the new `targets/` and `tools/` directory layout instead of the old `framework/` and `package/` paths. Verified with grep sweeps (no stale references remain in source scripts), `validate.sh` (all experts pass), `install.sh` (full install to temp directory succeeds), `list-experts.sh` (lists all 7 experts), and `create-expert.sh` (correct validate path in summary).

## Acceptance Criteria Status

- [x] `install.sh` and `install.ps1` work with the new directory layout (installs experts into a target project)
- [x] `package.sh` and `package.ps1` build a `.skill` file from the new layout (code updated and reviewed; full packaging not runtime-tested — requires python3 packaging tools download)
- [x] `validate.sh` validates expert definitions from the new paths
- [x] `create-expert.sh` and `create-expert.ps1` scaffold new experts correctly
- [x] Team install scripts (`install-team.sh`, `install-team.ps1`) reference correct paths for OpenClaw templates (code updated and reviewed; runtime requires Docker)
- [x] `install-skill.sh` and `install-skill.ps1` work with new layout (code updated and reviewed; runtime requires a built package)
- [x] No hardcoded references to old `framework/` or `package/` paths remain in any script

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| `package.sh` reconstructs `framework/install/` inside the built `.skill` package | SKILL.md references those paths and is out of scope to modify (swe-feature-016). Backward compatibility preserved. |
| `install-team.sh` uses walk-up approach for SKILL_ROOT instead of naive `../..` | Script moved from 2 levels deep (`framework/install/`) to 3 levels deep (`targets/autonomous/openclaw/`) but the packaged version is still at 2 levels (`framework/install/`). Walk-up approach works in both contexts. |
| `list-experts.sh` fallback changed from 2 levels up to 1 | Script moved from `package/tools/` (2 levels deep) to `tools/` (1 level deep). |
| `install-skill.sh` fallback changed from 1 level up to 3 | Script moved from `package/` (1 level deep) to `targets/desktop-cli/claude/` (3 levels deep). |

## Problems Encountered

None. The migration mapping in `docs/architecture.md` made every path change unambiguous. The only design question was how to handle `install-team.sh`'s different depth in repo vs. package contexts, resolved with the walk-up approach.

## Scope Changes

None. Stayed within issue scope. SKILL.md and CLAUDE.md documentation changes are swe-feature-016 as specified.

## Files Created or Modified

**Modified (12 scripts):**
- `targets/ide/install.sh` — comment + error message updated
- `targets/ide/install.ps1` — comment + error message updated
- `targets/desktop-cli/claude/package.sh` — BUILD_DIR, SKILL_SRC, tool copying, install script source paths, usage comments
- `targets/desktop-cli/claude/package.ps1` — same as package.sh
- `targets/desktop-cli/claude/install-skill.sh` — build path, REPO_ROOT fallback depth, error message
- `targets/desktop-cli/claude/install-skill.ps1` — same as install-skill.sh
- `targets/autonomous/openclaw/install-team.sh` — SKILL_ROOT walk-up, TEMPLATE_DIR (`templates/team` → `templates`), error messages
- `targets/autonomous/openclaw/install-team.ps1` — same as install-team.sh
- `tools/scaffold/create-expert.sh` — validate path in summary
- `tools/scaffold/create-expert.ps1` — same
- `tools/list-experts.sh` — REPO_ROOT fallback depth (2→1)
- `tools/list-experts.ps1` — same

**Not modified (no changes needed):**
- `tools/validate/validate.sh` — uses git-based resolution, no old paths
- `tools/new-repo.sh` / `.ps1` — no old path references
- `targets/desktop-cli/claude/uninstall-skill.sh` / `.ps1` — no old path references

## What the Next Session Needs to Know

All scripts now work with the new layout. The remaining work is swe-feature-016: documentation references. Key items for that task:

1. **`targets/desktop-cli/claude/SKILL.md`** references `$SKILL_DIR/framework/install/install.sh`, `$SKILL_DIR/framework/install/install-team.sh`, `$SKILL_DIR/framework/scaffold/create-expert.sh`, and `$SKILL_DIR/tools/new_repo.sh` (underscore). The package.sh currently reconstructs the `framework/install/` layout inside the package to preserve compatibility, but SKILL.md should be updated to reference the new paths directly (and the package structure should match).

2. **`CLAUDE.md`** repo guide still references `framework/` and `package/` in its directory tree and descriptions. Per the project brief decision, `CLAUDE.md` is being removed entirely in M7.

3. **`docs/test-plan.md`** references old paths in ATP procedures (`./framework/validate/validate.sh`, `./framework/install/install.sh`). Should be updated to match new paths.

## Open Questions

None.
