Break a milestone into session-sized tasks and create them as GitHub issues.

The user may specify which milestone: $ARGUMENTS

First, read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`

If the user didn't specify a milestone, look at the roadmap and identify the next milestone that hasn't been started. Confirm with the user before proceeding.

## Identify the personas

Before writing tasks, identify the relevant personas for this milestone. These are the people who will use or benefit from the work — end users, developers, admins, etc. Use these personas consistently in the user stories below.

## Create GitHub issues

For each task in the milestone, create a GitHub issue using the `gh` CLI:

```bash
gh issue create \
  --title "[Short descriptive title]" \
  --label "task" \
  --milestone "[Milestone name]" \
  --body "$(cat <<'EOF'
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
**Dependencies:** [Issues that must be completed first, e.g. #12, #13]
**Inputs:** project brief (always), [other files or resources needed — give paths]
**Out of scope:** [What NOT to do — prevents scope creep]
EOF
)"
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
- Order by dependency — what has to happen first. Use `**Dependencies:**` to link issue numbers.
- Every task MUST have acceptance criteria. No "trust me."
- Reference specific file paths in Inputs so the AI can read them directly (no copy-paste).
- Create a `task` label if it doesn't exist: `gh label create task --description "Session-sized work item" --color 0E8A16`
- Create the milestone if it doesn't exist: `gh api repos/{owner}/{repo}/milestones -f title="[Milestone name]"`

## After creating all issues

1. List the created issues with `gh issue list --label task --milestone "[Milestone name]"` and present them to the user for review.
2. Update `docs/roadmap.md` to note that the milestone has been decomposed. Log the issue numbers in the roadmap's change log.
3. Update `docs/project-brief.md` "Current Status" with the first task's issue number as "Next task."
