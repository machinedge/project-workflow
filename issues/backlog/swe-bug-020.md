# BUG: IDE target READMEs missing System Architect prefix

**Type:** bug
**Expert:** swe
**Milestone:** M7
**Status:** backlog
**Severity:** should-fix

## Description

Both `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md` have a Skill Namespacing table that lists all expert prefixes but omits `sa-` for System Architect. The install script (`targets/ide/install.sh`) supports `sa-` and installs SA commands, so the reference documentation is incomplete.

## Acceptance Criteria

- [ ] `targets/ide/cursor/README.md` Skill Namespacing table includes `sa-` → System Architect row
- [ ] `targets/ide/claude-code/README.md` Skill Namespacing table includes `sa-` → System Architect row

## Notes

**Found by:** qa-feature-017
**Files:** `targets/ide/cursor/README.md` (line 14-21), `targets/ide/claude-code/README.md` (line 14-21)
