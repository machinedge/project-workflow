Break a milestone into session-sized tasks.

The user may specify which milestone: $ARGUMENTS

First, read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`

If the user didn't specify a milestone, look at the plan and identify the next milestone that hasn't been started. Confirm with the user before proceeding.

For the target milestone, create individual task briefs. Save each one as `docs/tasks/task-NN.md` using this structure:

```markdown
# Task Brief: [Task Name]

**Task ID:** TASK-[NN]
**Milestone:** [Which milestone]
**Estimated effort:** [Small / Medium / Large session]

## Objective
[1-2 sentences. What does "done" look like?]

## Inputs
- Project brief (always — Claude reads this automatically)
- [Other files needed — give paths]

## Specific Instructions
1. [Concrete step]
2. [Concrete step]

## Decisions Already Made
- [Relevant decisions from the project brief that apply to this task]

## Out of Scope
- [What NOT to do — prevents scope creep]

## How to Verify
- [ ] [Specific verification step]
```

Rules:
- Each task must be completable in ONE Claude session (~10 substantive exchanges).
- If it would take more, split it. If it takes fewer than 3 exchanges, batch with a neighbor.
- Order by dependency — what has to happen first.
- Every task MUST have verification steps. No "trust me."
- Reference specific file paths in Inputs so Claude can read them directly (no copy-paste).

After creating the task files, update `docs/roadmap.md` to note that the milestone has been decomposed. List the tasks in the roadmap's change log.
