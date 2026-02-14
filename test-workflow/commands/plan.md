<!-- TEMPLATE: Plan Command
     This command reads the brief and creates a structured plan that breaks
     the project into milestones, phases, or work units — whatever your domain
     calls them.

     The plan should define 3-8 work units with dependencies and risks.
     Each unit should be completable in 2-5 sessions.

     Replace plan with your command name (e.g., "roadmap", "scope").
     Replace project-brief.md with the brief file name.
     Replace plan.md with the plan output file (e.g., "roadmap.md", "scope.md").
     Replace milestone with what your domain calls a chunk of work (e.g., "milestone", "phase").
     Delete these comments when done.
-->
The user is ready to plan the work structure.

Read `docs/project-brief.md`.

<!-- GUIDE: If your workflow has additional planning inputs (domain context,
     existing codebase analysis, etc.), read those here too. -->

From the brief, create a milestone plan. Save it to `docs/plan.md`.

Use this structure:

```markdown
# test-workflow Plan

## milestone 1: [Descriptive Name]
**Goal:** [What "done" looks like — a meaningful state change, not a list of tasks]
**Estimated sessions:** [2-5]
**Dependencies:** None (first milestone)

### Scope
[What this milestone covers]

### Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [What could go wrong] | H/M/L | H/M/L | [How to address] |

---

## milestone 2: [Descriptive Name]
...
```

Rules:
- Define 3-8 milestones. Fewer means they're too big; more means they're too granular.
- Name milestones as meaningful state changes, not task lists. "Working prototype on staging" not "set up database."
- Every milestone must have at least one real risk. "No risks identified" is not acceptable.
- Assume timelines take 1.5x longer than your initial estimate.
- Flag any uncertainties that need user input before milestones can be sequenced.
- Present the plan to the user and wait for approval before saving.
