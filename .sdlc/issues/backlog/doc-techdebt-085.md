# TECHDEBT: Handoff-note path mismatch: AGENTS.md says .sdlc/notes/, skills write .sdlc/handoff-notes/

**Type:** techdebt
**Expert:** doc
**Status:** backlog
**Severity:** should-fix

## Description

`AGENTS.md` documents handoff notes at `.sdlc/notes/<expert>/`, but the shipped `*-handoff` skills write `.sdlc/handoff-notes/<expert>/` (the real on-disk directory). Align `AGENTS.md` to the path the skills actually use.

## Acceptance Criteria

- [ ] `AGENTS.md` (Conventions: Handoff notes) documents the path as `.sdlc/handoff-notes/<expert>/`
- [ ] The documented path matches what `agents/skills/*-handoff/SKILL.md` write

## Notes

**Found by:** Documentation review.
**Files:** `AGENTS.md` (Conventions: Handoff notes), `agents/skills/*-handoff/SKILL.md`
