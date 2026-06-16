# Handoff Note: Install Scripts and READMEs for Platform-Native Structure

**Issue:** swe-feature-044

## What Was Accomplished

Rewrote install scripts and updated all READMEs for the platform-native architecture (ADR-008: direct copy replaces translation pipeline).

1. **`targets/ide/install.sh`** — Replaced the translation pipeline (read from `experts/technical/`, parse role files, generate frontmatter, build CLAUDE.md dynamically) with direct file copy from `targets/ide/<platform>/`. New helpers for copying skills (subdirectory structure), scripts (with chmod +x, excluding test files), and commands. Settings.json merge via Python 3 preserves existing user settings. Outputs sync command reference and uninstall instructions.

2. **`targets/ide/install.ps1`** — PowerShell equivalent with identical behavior. Uses `ConvertFrom-Json`/`ConvertTo-Json` for settings.json merge (no Python dependency). Tested and verified to produce byte-identical output to bash.

3. **`targets/ide/cursor/README.md`** — Full documentation: installed directory layout, how rules/commands/skills/scripts work, Cursor skill discovery flow, handoff auto-trigger mechanism, script requirements, skill namespacing, uninstall instructions, source structure.

4. **`targets/ide/claude-code/README.md`** — Full documentation: same as Cursor plus CLAUDE.md role, settings.json merge behavior, SessionStart hook and session-primer.sh, uninstall instructions.

5. **`README.md`** (root) — Updated Quick Start to show `--editor` flag (replaces old `--experts`), added "Keeping Up to Date" section with sync command, added platform README links to documentation table, added `cursor/` and `claude-code/` directories to repo structure tree, added `sync.sh / sync.ps1` to tools tree.

## Acceptance Criteria Status

- [x] `install.sh` installs Cursor-native rules to `.cursor/rules/`
- [x] `install.sh` installs Cursor skills to correct location (`.cursor/skills/*/SKILL.md`)
- [x] `install.sh` installs shell scripts to `.cursor/scripts/` and sets them executable
- [x] `install.sh` installs Claude Code rules/skills/scripts to correct locations
- [x] `install.sh` merges `settings.json` hooks into existing `.claude/settings.json`
- [x] `install.ps1` handles the same for Windows
- [x] `cursor/README.md` documents: what's installed, directory layout, skill discovery, hooks, script requirements
- [x] `claude-code/README.md` documents: same for Claude Code
- [x] Root `README.md` Quick Start updated
- [x] Install script includes sync command as available tool
- [x] Uninstall/cleanup documented (both in READMEs and install script output)

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Dropped `--experts` and `--domain` CLI flags | Pre-built platform files are a coherent set; partial install would require regenerating routing configs (`project-os.mdc`/`CLAUDE.md`), defeating direct-copy purpose. |
| Python 3 for bash settings.json merge, `ConvertFrom-Json` for PowerShell | Avoids `jq` dependency. Python available on macOS/Linux (Claude Code's platforms). PowerShell has native JSON support. Falls back to manual instructions if Python unavailable. |
| Excluded `test-*` scripts from install | `test-scripts.sh` is a development/maintainer tool, not user-facing. |
| Lessons log seeded without Date column | Consistent with M8/M9 date-removal decision. |

## Problems Encountered

None.

## Scope Changes

None.

## Files Created or Modified

- `targets/ide/install.sh` — rewritten (direct copy architecture)
- `targets/ide/install.ps1` — rewritten (PowerShell equivalent)
- `targets/ide/cursor/README.md` — expanded from ~35 lines to full documentation
- `targets/ide/claude-code/README.md` — expanded from ~35 lines to full documentation
- `README.md` — updated Quick Start, added sync section, updated docs table and repo structure

## What the Next Session Needs to Know

1. **Install scripts are fully rewritten.** They no longer read from `experts/technical/` — they copy directly from `targets/ide/cursor/` and `targets/ide/claude-code/`. The `--experts` and `--domain` flags are gone.
2. **Both scripts tested and verified on macOS.** Bash and PowerShell produce byte-identical installed files. Settings.json merge tested with both.
3. **swe-feature-044 is complete.** All 11 acceptance criteria met.
4. **Next work** per project brief: qa-feature-045 (cross-platform regression testing).
5. **The project brief should be updated** with swe-feature-044 completion status.

## Open Questions

None.
