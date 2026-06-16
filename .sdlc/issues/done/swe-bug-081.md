# architecture.md Has Stale Paths in Non-ADR Sections

**Type:** bug
**Expert:** swe
**Severity:** should-fix
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## Description

`docs/architecture.md` has 4 stale path references in non-ADR sections that should have been updated when the corresponding scripts and install logic were updated (per ADR-011 edge case 6). The ADR-011 section itself correctly documents old→new mappings and is not affected.

## Stale References

1. **Line 31** — Top-level directory layout shows `issues/` as a standalone directory. Should show `.sdlc/` structure instead.
2. **Line 346** — Cursor `project-os.mdc` description says `issues in `issues/``. Should be `.sdlc/issues/`.
3. **Line 513** — Session-primer.sh behavior says `docs/handoff-notes/`. Should be `.sdlc/handoff-notes/`.
4. **Line 537** — Script specifications table says output is `Regenerated `issues/issues-list.md``. Should be `.sdlc/issues/issues-list.md`.

## Acceptance Criteria

- [ ] Line 31: Top-level directory layout updated to show `.sdlc/` structure (add `.sdlc/` with subdirs, remove standalone `issues/`)
- [ ] Line 346: `issues/` → `.sdlc/issues/`
- [ ] Line 513: `docs/handoff-notes/` → `.sdlc/handoff-notes/`
- [ ] Line 537: `issues/issues-list.md` → `.sdlc/issues/issues-list.md`
- [ ] No other non-ADR sections in architecture.md reference old paths

## Notes

ADR-011 edge case 6 explicitly predicted this: "Update these when the corresponding scripts and install logic are updated — not before, to avoid a half-current/half-future document." The scripts and install logic are updated; these sections were not.

The ADR-011 section itself (lines ~564–676) intentionally references old paths in the path mapping table and context descriptions — those are correct and should NOT be changed.
