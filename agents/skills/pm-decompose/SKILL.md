---
name: pm-decompose
description: "Break a milestone into session-sized task issues in .sdlc/issues/backlog/. Use when the user wants to decompose a roadmap milestone into actionable issue files for SWE, QA, and DevOps experts."
---

Break a milestone into session-sized tasks and create them as local issue files in `.sdlc/issues/backlog/`.

The user may specify which milestone: $ARGUMENTS

## Modes

This skill runs in one of two detail modes:

- **Standard mode** (default, invoked directly): session-sized tasks with acceptance criteria and referenced file paths, using the templates below.
- **Implementation-ready mode** (invoked as the *Compile* phase of the `team-milestone` workflow): denser tasks that a small language model can implement — code and tests — with no further design. SA, Security, QA, and DevOps have already enriched the milestone; their outputs are inlined into each task. Use the implementation-ready SWE template and follow the bar in `docs/task-detail-standard.md`, then run the completeness check in Step 4.5.

If you are unsure which mode you're in: you're in implementation-ready mode only when the milestone workflow says so, or when `docs/security-requirements.md` and the enrichment artifacts for this milestone exist and the user asks for implementation-ready tasks.

## Step 1: Load context

Read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`
3. `.sdlc/issues/issues-list.md` (if it exists — to know what issues already exist)

In **implementation-ready mode**, also read the milestone's enrichment artifacts so their decisions can be inlined into each task:
4. `docs/architecture.md` — component boundaries and interfaces the tasks must honor
5. `docs/security-requirements.md` — the `SR-NNN` controls that apply to this milestone
6. `docs/test-plan.md` — the test strategy and cases QA defined
7. `docs/task-detail-standard.md` — the bar each task must meet

If the user didn't specify a milestone, look at the roadmap and identify the next milestone that hasn't been started. Confirm with the user before proceeding.

## Step 2: Identify the personas

Before writing tasks, identify the relevant personas for this milestone. These are the people who will use or benefit from the work — end users, developers, admins, etc. Use these personas consistently in the user stories below.

## Step 3: Determine the next issue number

Run `.agents/scripts/next-issue-number.sh` to get the next available issue number. Start numbering new issues from that number.

## Step 4: Create issue files

For each task in the milestone, create a markdown file in `.sdlc/issues/backlog/`. Files follow the naming convention:

```
.sdlc/issues/backlog/[expert]-[type]-[number].md
```

Where:
- `[expert]` = the workflow that will execute this task (`swe`, `qa`, `devops`, etc.)
- `[type]` = `feature`, `bug`, or `techdebt`
- `[number]` = sequential issue number (zero-padded to 3 digits, e.g. `001`)

### SWE tasks

Implementation work — building features, writing code, fixing bugs.

Create a file like `.sdlc/issues/backlog/swe-feature-001.md`:

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

**In implementation-ready mode**, use the denser SWE template in `docs/task-detail-standard.md` instead of the one above. It adds *Files to Create or Modify*, *Interfaces and Data Models*, an *Implementation Outline*, a *Test Specification* (explicit input→output cases), and inlined *Security Constraints* (`SR-NNN`) and *Architecture Contracts* drawn from the enrichment artifacts. The goal: a small model can write the code and tests from the task alone, without inventing any design decision.

### QA tasks

Quality assurance work — writing test plans, running reviews, regression testing.

Create a file like `.sdlc/issues/backlog/qa-feature-004.md`:

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

Create a file like `.sdlc/issues/backlog/devops-feature-005.md`:

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

Each criterion should be independently verifiable. Write them as checkboxes so they can be checked off during `/swe-start` Phase 6 (Verify).

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

## Step 4.5: Completeness check (implementation-ready mode only)

Before finalizing, verify each implementation-ready task against the completeness checklist in `docs/task-detail-standard.md`. Be the skeptical small model: "Could I implement this and its tests without asking a single question or making a single design choice?"

For each task, confirm:
- Every referenced file path is exact, not vague.
- Every interface/type/schema the code must implement is specified, not just described.
- The test specification has explicit input→output cases (not "test it").
- Applicable security requirements (`SR-NNN` for this surface) are reflected.
- Every acceptance criterion is verifiable.

If a task fails any check, enrich it (pull the missing detail from the architecture, security-requirements, or test-plan artifacts — or flag the gap to the user if the source artifact itself is silent). Do not finalize a task that still requires the implementer to invent a design decision.

## Step 5: Finalize

After creating all issue files:

1. List the created issue files and present them to the user for review.
2. Run `.agents/scripts/update-issues-list.sh` to regenerate `.sdlc/issues/issues-list.md`.
3. Update `docs/roadmap.md` to note that the milestone has been decomposed. Log the issue filenames in the roadmap's change log.
4. Update `docs/project-brief.md` "Current Status" with the first task's issue filename as "Next task."
