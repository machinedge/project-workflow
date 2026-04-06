# Install script creates wrong PM handoff directory

**Type:** bug
**Expert:** swe
**Milestone:** M11
**Status:** backlog
**Severity:** must-fix

## Description

`install.sh` and `install.ps1` create `docs/handoff-notes/project-manager/` during project scaffolding, but all PM skills, commands, and roles reference `docs/handoff-notes/pm/`. The PM handoff skill calls `next-session-number.sh pm`, which writes to `docs/handoff-notes/pm/` — a directory that doesn't exist after install.

The script auto-creates the directory via `mkdir -p`, so handoff doesn't fail, but the user ends up with an unused `project-manager/` directory and PM handoff notes in a different `pm/` directory.

Both platform READMEs also document the scaffolding as `project-manager/`, which is consistent with the install script but inconsistent with actual usage.

## Files Affected

- `targets/ide/install.sh` line 91 — `for expert in project-manager swe qa devops system-architect`
- `targets/ide/install.ps1` line 56 — `foreach ($expert in @("project-manager", ...))`
- `targets/ide/cursor/README.md` line 67 — scaffolding shows `project-manager/`
- `targets/ide/claude-code/README.md` line 69 — scaffolding shows `project-manager/`

## Acceptance Criteria

- [ ] Install script creates `docs/handoff-notes/pm/` (not `project-manager/`)
- [ ] Both platform READMEs updated to show `pm/` in scaffolding
- [ ] Both install scripts (bash and PowerShell) are consistent

## Notes

Root cause: the install script uses full expert directory names (`project-manager`) for the loop, but PM artifacts use the short prefix (`pm`). All other experts (swe, qa, devops, system-architect) match between install script and skills.
