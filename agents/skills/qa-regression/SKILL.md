---
name: qa-regression
description: "Run a comprehensive regression check after a milestone is complete. Use when the user wants to verify that all acceptance criteria still pass across a completed milestone, or when checking for cross-task interference before a release."
---

Run a comprehensive regression check after a milestone is complete.

The user may specify a milestone: $ARGUMENTS

## Step 1: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals and constraints
2. `docs/roadmap.md` — identify the milestone scope
3. ALL SWE handoff notes in `.sdlc/handoff-notes/swe/` — understand what was built across the milestone
4. ALL QA handoff notes in `.sdlc/handoff-notes/qa/` — understand what's already been reviewed
5. `docs/test-plan.md` (if it exists) — the defined test requirements
6. `.sdlc/lessons-log.md` — known gotchas
7. `docs/architecture.md` (if it exists) — understand architectural intent for evaluating coherence across tasks

Scan all `.sdlc/issues/` subdirectories for files matching the milestone (check the **Milestone** field in each file). Read each issue to get its acceptance criteria and scope.

If the user didn't specify a milestone, determine which one was most recently completed based on the roadmap. Confirm with the user before proceeding.

## Step 2: Build the Regression Checklist

From the issues and handoff notes, compile a complete list of:
- Every acceptance criterion across all tasks in the milestone
- Every behavior that was implemented
- Any must-fix or should-fix items from previous reviews

This is the regression checklist — everything that should still be working.

## Step 3: Run Regression Checks

For each item on the checklist:

1. **Verify it's still working.** Run the relevant tests, check the behavior, or inspect the code.
2. **Check for cross-task interference.** Did a later task break something an earlier task built? Look for:
   - Shared state modified by multiple tasks
   - API contracts that changed
   - Configuration or environment changes that affect earlier work
   - Test files modified or deleted by later tasks
3. **Document the result.** Pass (with evidence) or Fail (with details).

If `docs/test-plan.md` exists, verify coverage against it:
- Which test matrix rows pass?
- Which fail?
- Which were never implemented?

## Step 4: Produce the Regression Report

Present findings:

```markdown
## Regression Report: [Milestone Name]

**Issues in scope:** [issue filenames]
**Total acceptance criteria:** [N]

### Summary
- **Passing:** [N] criteria
- **Failing:** [N] criteria
- **Not testable:** [N] criteria (explain why)

### Passing Criteria
| Issue | Criterion | Evidence |
|-------|-----------|----------|
| [filename] | [criterion] | [test name / manual check] |

### Failing Criteria
| Issue | Criterion | Details | Severity |
|-------|-----------|---------|----------|
| [filename] | [criterion] | [what's broken and why] | [blocker / high / medium] |

### Cross-Task Interference
[Any cases where a later task broke an earlier task's work.]

### Test Coverage Assessment
[If test-plan.md exists:]
- Test matrix rows covered: [N of M]
- Test matrix rows failing: [N]
- Test matrix rows not implemented: [N]
- Coverage gaps: [list]

### New Issues Discovered
[Anything found that wasn't in the original acceptance criteria.]
```

## Step 5: Create Issue Files

For each regression failure, run `.agents/scripts/next-issue-number.sh` to get the next available issue number.

Create an issue file in `.sdlc/issues/backlog/` using the executor prefix convention: `.sdlc/issues/backlog/swe-bug-[number].md` (or the appropriate expert who will fix it).

Template:

```markdown
# Regression: [Short descriptive title]

**Type:** bug
**Expert:** swe
**Milestone:** [Milestone name]
**Status:** backlog
**Severity:** [blocker / high / medium]

## Description

[What's broken, when it was introduced, and what the expected behavior should be.]

**Regression from:** [original task issue filename]
**Broken by:** [task that likely caused the regression, if identifiable]
**Found by:** `qa-regression` check of [Milestone name]

## Acceptance Criteria

- [ ] [What "fixed" looks like]

## Technical Notes

**File(s):** [affected file paths]
```

After creating issue files, run `.agents/scripts/update-issues-list.sh` to regenerate the issues list.

## Step 6: Update Documents

- Add any patterns to `.sdlc/lessons-log.md` (e.g., "tasks that modify shared config should re-run all tests")
- Note in `docs/roadmap.md` change log that regression was run and how many issues were found
- The regression report feeds into PM's `pm-postmortem` skill for the milestone
