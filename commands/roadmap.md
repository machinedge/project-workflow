Create the project milestone plan.

First, read `docs/project-brief.md`. If it doesn't exist, tell the user to run `/vision` first.

Create `docs/roadmap.md` with 5-8 milestones using this structure:

```markdown
# Project Plan

## Milestones
| # | Milestone | Status | Target Date | Depends On | Risks / Unknowns |
|---|-----------|--------|-------------|------------|-------------------|

## Dependency Map
[show which milestones block which — text or ASCII diagram]

## Risk Register
| Risk | Likelihood | Impact | Mitigation | Status |
|------|-----------|--------|------------|--------|

## Change Log
| Date | What Changed | Why |
|------|-------------|-----|
```

Rules:
- Milestones are meaningful state changes, not tasks. "Working prototype on staging" not "set up database."
- Each milestone should take 2-5 sessions to complete.
- Be explicit about dependencies between milestones.
- Every milestone needs at least one identified risk or unknown.
- Assume timelines take 1.5x longer than they seem.
- Flag uncertainties for the user to decide on.

Show the plan to the user for review. Update `docs/project-brief.md` status to reflect that planning is complete.
