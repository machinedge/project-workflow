Run a comprehensive regression check after a milestone is complete.

The user may specify a milestone: $ARGUMENTS

---

## Step 1: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals and constraints
2. `docs/roadmap.md` — identify the milestone scope
3. ALL SWE handoff notes in `docs/handoff-notes/swe/` — understand what was built across the milestone
4. ALL QA handoff notes in `docs/handoff-notes/qa/` — understand what's already been reviewed
5. `docs/test-plan.md` (if it exists) — the defined test requirements
6. `docs/lessons-log.md` — known gotchas

Scan all `issues/` subdirectories for files matching the milestone (check the **Milestone** field in each file). Read each issue to get its acceptance criteria and scope.

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

**Date:** [today]
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

For each regression failure, create an issue file in `issues/backlog/`. Check existing issue files to determine the next available issue number.

Use the naming convention: `issues/backlog/qa-bug-[number].md`

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
**Found by:** `/regression` check of [Milestone name]

## Acceptance Criteria

- [ ] [What "fixed" looks like]

## Technical Notes

**File(s):** [affected file paths]
```

Update `issues/issues-list.md` with the new issues.

## Step 6: Update Documents

- Add any patterns to `docs/lessons-log.md` (e.g., "tasks that modify shared config should re-run all tests")
- Note in `docs/roadmap.md` change log that regression was run and how many issues were found
- The regression report feeds into PM's `/postmortem` for the milestone
