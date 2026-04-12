# Project Brief Constraints Section Has Stale `issues/` Path

**Type:** bug
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog
**Severity:** should-fix
**Found by:** `qa-review` of qa-feature-075 (grep audit)

## User Story

As an AI expert loading the project brief, I need the Constraints section to reference `.workflow/issues/` so that I don't receive contradictory path guidance between the brief and the conventions in `project-os.mdc` / `CLAUDE.md`.

## Description

`docs/project-brief.md` line 31 in the Constraints section says:

```
- Issues tracked in `issues/`, not external services
```

This should be:

```
- Issues tracked in `.workflow/issues/`, not external services
```

All other path references in the project brief are correct. The conventions sections in `project-os.mdc` and `CLAUDE.md` (the authoritative routing hubs) already use `.workflow/issues/`, so the functional impact is low — agents will follow the conventions over the brief's constraints. But the inconsistency should be corrected.

## Acceptance Criteria

- [ ] `docs/project-brief.md` Constraints section references `.workflow/issues/` instead of `issues/`

## Technical Notes

**Estimated effort:** Small session (single-line change)
**File(s):** `docs/project-brief.md`
