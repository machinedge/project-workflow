# update-brief-status script missing from install cleanup and READMEs

**Type:** bug
**Expert:** swe
**Milestone:** M11
**Status:** backlog
**Severity:** should-fix

## Description

`update-brief-status.sh` and `update-brief-status.ps1` were added in swe-feature-049 (session 28) after the install scripts (swe-feature-044, session 27) and READMEs (swe-techdebt-054, session 25) were written. Two gaps result:

1. **Install script cleanup section** — both `install.sh` and `install.ps1` clean up old managed scripts during reinstall (lines 121-138 in bash, equivalent in PS1) but don't clean `update-brief-status.*`. If a future version removes this script, a reinstall won't clean the old file.

2. **Both platform READMEs** — the Scripts section in `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md` lists only 4 scripts. `update-brief-status.sh`/`.ps1` is missing from both the file listing and the description text.

## Files Affected

- `targets/ide/install.sh` — cleanup section missing `update-brief-status.*`
- `targets/ide/install.ps1` — cleanup section missing `update-brief-status.*`
- `targets/ide/cursor/README.md` — scripts listing and description
- `targets/ide/claude-code/README.md` — scripts listing and description

## Acceptance Criteria

- [ ] `install.sh` cleanup section includes `rm -f` for `update-brief-status.*` (both Cursor and Claude Code blocks)
- [ ] `install.ps1` cleanup section includes equivalent cleanup
- [ ] Cursor README scripts section lists `update-brief-status.sh` and `.ps1` with description
- [ ] Claude Code README scripts section lists `update-brief-status.sh` and `.ps1` with description
