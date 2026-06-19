# BUG: pm-interview command writes a typo'd notes filename (.sdlc/rview-notes.md)

**Type:** bug
**Expert:** swe
**Status:** done
**Severity:** must-fix

## Description

The `/pm-interview` command saves interview notes to `.sdlc/rview-notes.md` (a typo), but the pm-vision skill (`agents/skills/pm-vision/SKILL.md`) reads `.sdlc/interview-notes.md`. A real `/pm-interview` → pm-vision run breaks: the brief skill finds no notes because the filenames don't match. Fix the command to write `.sdlc/interview-notes.md`.

## Acceptance Criteria

- [x] `agents/commands/pm-interview.md` writes interview notes to `.sdlc/interview-notes.md`
- [x] The path matches what `agents/skills/pm-vision/SKILL.md` reads
- [x] A `/pm-interview` → pm-vision run finds the notes

## Notes

**Found by:** Documentation review (`docs/guides/usage.md` and `getting-started.md`) — the one must-fix that blocked the usage walkthrough.
**Files:** `agents/commands/pm-interview.md:30`

**Resolved:** Fixed inline during the same documentation workflow (revise phase) — `agents/commands/pm-interview.md:30` now writes `.sdlc/interview-notes.md`, matching the path pm-vision reads. Verified in the working tree.
