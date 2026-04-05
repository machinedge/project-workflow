# SWE: Add team-status skill to Claude Code implementation

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Severity:** should-fix

## Description

The `team-status` skill exists in the Cursor implementation (`targets/ide/cursor/skills/team-status/SKILL.md`) but is missing from the Claude Code implementation. This is a content parity gap — every Cursor skill should have a Claude Code equivalent.

The skill is a cross-expert (team-prefixed) skill that generates a project health summary. It runs roleless per ADR-010.

## Context

- Flagged during swe-feature-041 (session 24): "team-status skill is missing from Claude Code. It exists in Cursor but was not included in swe-feature-040 or swe-feature-041 acceptance criteria."
- The Cursor version is QA-reviewed and correct (qa-feature-039).
- The adaptation is mechanical: copy the Cursor SKILL.md, no script path changes needed (team-status references no `.cursor/scripts/` paths).

## Acceptance Criteria

- [ ] `targets/ide/claude-code/skills/team-status/SKILL.md` exists
- [ ] Content matches the Cursor version (this skill has no platform-specific script references)
- [ ] Claude Code implementation has 21 skills, matching the architecture's full skill map

## Notes

**Found by:** qa-feature-042 (Claude Code QA review)
**Source:** `targets/ide/cursor/skills/team-status/SKILL.md`

## Session 25 Summary

**What was done:** Copied team-status SKILL.md from Cursor to Claude Code. Content is identical (no platform-specific script references). Claude Code now has 21 skills matching the architecture's full skill map.
**Handoff note:** `docs/handoff-notes/swe/session-25.md`
**All acceptance criteria met:** Yes
