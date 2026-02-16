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
- Milestones are demo-able outcomes, not layers or tasks.
  Good: "User can sign up, log in, and see a dashboard"
  Bad: "Database schema complete" or "set up database"
  Test: could you demo this to a stakeholder and they'd see working functionality?
- Each milestone should deliver a thin vertical slice through all relevant layers
  (data, logic, UI) rather than completing one layer at a time.
- Each milestone should take 2-5 sessions to complete.
- Be explicit about dependencies between milestones.
- Every milestone needs at least one identified risk or unknown.
- Assume timelines take 1.5x longer than they seem.
- Flag uncertainties for the user to decide on.
- Milestones may trigger work across multiple workflows — not just SWE. Consider whether a milestone needs DevOps work (environment setup, pipeline config, deployment) or QA work (test plan, review) and note these in the milestone description or risks.

Show the plan to the user for review. Update `docs/project-brief.md` status to reflect that planning is complete.
