# Update Install Scripts and READMEs for Platform-Native Structure

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Cursor user or Claude Code user, I need the install script to set up the new platform-native structure (rules, skills, tools, hooks) in my project so that I get the full experience without manual configuration.

## Description

Update `targets/ide/install.sh` and `targets/ide/install.ps1` to install the new platform-native file structure. Update `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md` with the new concepts, directory layout, and shell script requirements. Update root `README.md` if the Quick Start section needs changes.

## Acceptance Criteria

- [ ] `targets/ide/install.sh` installs Cursor-native rules to `.cursor/rules/`
- [ ] `targets/ide/install.sh` installs Cursor skills to the correct location per sa-feature-033 design
- [ ] `targets/ide/install.sh` installs shell scripts to `.cursor/scripts/` and sets them executable
- [ ] `targets/ide/install.sh` installs Claude Code rules/skills/scripts to the correct Claude Code locations
- [ ] `targets/ide/install.sh` merges `settings.json` hooks into existing `.claude/settings.json` (don't overwrite user settings)
- [ ] `targets/ide/install.ps1` handles the same for Windows (PowerShell scripts to correct locations)
- [ ] `targets/ide/cursor/README.md` documents: what's installed, directory layout, how skills are discovered, how hooks auto-trigger, shell script requirements
- [ ] `targets/ide/claude-code/README.md` documents: same for Claude Code
- [ ] Root `README.md` Quick Start section updated if needed
- [ ] Install script includes the sync command as an available tool for users
- [ ] Uninstall/cleanup documented (how to remove the toolkit from a project)

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** qa-feature-039, qa-feature-042 (both platforms reviewed and finalized), swe-feature-043 (sync command exists)
**Inputs:** project brief, sa-feature-033 design, current `targets/ide/install.sh`, current README files
**Out of scope:** Desktop/CLI target install. OpenClaw install. Package distribution.
