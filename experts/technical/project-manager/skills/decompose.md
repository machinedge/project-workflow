Break a milestone into session-sized tasks and create them as local issue files in `issues/backlog/`.

The user may specify which milestone: $ARGUMENTS

First, read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`
3. `issues/issues-list.md` (if it exists — to know what issue numbers are already used)

If the user didn't specify a milestone, look at the roadmap and identify the next milestone that hasn't been started. Confirm with the user before proceeding.

## Identify the personas

Before writing tasks, identify the relevant personas for this milestone. These are the people who will use or benefit from the work — end users, developers, admins, etc. Use these personas consistently in the user stories below.

## Determine the next issue number

Check the existing issue files across all `issues/` subdirectories (`backlog/`, `planned/`, `in-progress/`, `done/`) to find the highest issue number in use. Start numbering new issues from the next number.

## Create issue files

For each task in the milestone, create a markdown file in `issues/backlog/`. Files follow the naming convention:

```
issues/backlog/[expert]-[type]-[number].md
```

Where:
- `[expert]` = the workflow that will execute this task (`swe`, `qa`, `devops`, etc.)
- `[type]` = `feature`, `bug`, or `techdebt`
- `[number]` = sequential issue number (zero-padded to 3 digits, e.g. `001`)

### SWE tasks

Implementation work — building features, writing code, fixing bugs.

Create a file like `issues/backlog/swe-feature-001.md`:

```markdown
# [Short descriptive title]

**Type:** feature
**Expert:** swe
**Milestone:** [Milestone name]
**Status:** backlog

## User Story

As a [persona], I [need | want | desire] [feature / capability] so that I can [value proposition].

## Description

[2-3 sentences. What needs to be built or changed, and why.]

## Acceptance Criteria

- [ ] [Criterion from the persona's perspective — what they can now do or see]
- [ ] [Another criterion]
- [ ] [Another criterion]

## Technical Notes

**Estimated effort:** [Small / Medium / Large session]
**Dependencies:** [Issues that must be completed first, e.g. swe-feature-001, qa-feature-003]
**Inputs:** project brief (always), [other files or resources needed — give paths]
**Out of scope:** [What NOT to do — prevents scope creep]
```

### QA tasks

Quality assurance work — writing test plans, running reviews, regression testing.

Create a file like `issues/backlog/qa-feature-004.md`:

```markdown
# QA: [Short descriptive title]

**Type:** feature
**Expert:** qa
**Milestone:** [Milestone name]
**Status:** backlog

## Description

[What needs to be reviewed, tested, or validated.]

## Scope

- [What to cover]
- [What to cover]

## Acceptance Criteria

- [ ] [What "done" looks like for this QA task]

## Notes

**Depends on:** [Issue files that must be completed first]
**Inputs:** [handoff notes, test plan, code to review]
```

### DevOps tasks

Infrastructure and deployment work — setting up pipelines, configuring environments, preparing releases.

Create a file like `issues/backlog/devops-feature-005.md`:

```markdown
# DevOps: [Short descriptive title]

**Type:** feature
**Expert:** devops
**Milestone:** [Milestone name]
**Status:** backlog

## Description

[What infrastructure, pipeline, or deployment work is needed.]

## Acceptance Criteria

- [ ] [What "done" looks like]

## Notes

**Depends on:** [Issue files that must be completed first]
**Inputs:** [env-context, project brief, etc.]
```

### Writing good user stories

- The persona should be specific, not generic. "As a **warehouse manager**" not "As a **user**."
- The need should describe behavior, not implementation. "I need to **see which orders are late**" not "I need a **SQL query that joins orders and shipments**."
- The value proposition should explain *why* it matters. "so that I can **prioritize which trucks to dispatch first**" not "so that I can **have the feature**."
- Acceptance criteria are from the persona's perspective — what they can observe, do, or verify. Not internal implementation details.

### Writing good acceptance criteria

Each criterion should be independently verifiable. Write them as checkboxes so they can be checked off during `/start` Phase 6 (Verify).

Good: "- [ ] Warehouse manager can filter orders by status (pending, shipped, late)"
Bad: "- [ ] The code works correctly"

Good: "- [ ] Error message is shown when CSV upload contains invalid dates"
Bad: "- [ ] Input validation is implemented"

## Rules

- Each task must be completable in ONE session (~10 substantive exchanges). If it would take more, split it. If it takes fewer than 3 exchanges, batch with a neighbor.
- Order by dependency — what has to happen first. Use `**Dependencies:**` to link issue filenames.
- Every task MUST have acceptance criteria. No "trust me."
- Reference specific file paths in Inputs so the AI can read them directly (no copy-paste).
- Not every milestone needs QA or DevOps tasks. Only create them when the milestone genuinely requires that work.

## After creating all issue files

1. List the created issue files and present them to the user for review.
2. Update `issues/issues-list.md` with the new issues — add each one with its filename, title, expert, type, milestone, and status.
3. Update `docs/roadmap.md` to note that the milestone has been decomposed. Log the issue filenames in the roadmap's change log.
4. Update `docs/project-brief.md` "Current Status" with the first task's issue filename as "Next task."
