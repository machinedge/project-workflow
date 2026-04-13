# pm-add-feature.md wording inconsistency between Cursor and Claude Code

**Expert:** SWE
**Type:** bug
**Priority:** nit
**Milestone:** Platform-Native Refactor (M11)

## Description

`pm-add-feature.md` line 69 has a minor wording difference between Cursor and Claude Code:

- **Cursor:** `Skip directly to the `pm-decompose` skill — the brief and roadmap must be updated first via the `pm-update-plan` skill.`
- **Claude Code:** `Skip directly to `pm-decompose` — the brief and roadmap must be updated first via the `pm-update-plan` skill.`

Claude Code version drops "the" and "skill" after `pm-decompose`. The classification is correct in both (no `/` prefix), but the wording should be identical across platforms.

## Files to Fix

- `targets/ide/claude-code/commands/pm-add-feature.md` line 69 — align wording with Cursor version

## Acceptance Criteria

- [ ] Line 69 is identical in both `targets/ide/cursor/commands/pm-add-feature.md` and `targets/ide/claude-code/commands/pm-add-feature.md`
