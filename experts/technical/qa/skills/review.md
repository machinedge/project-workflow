Review code produced by previous sessions with fresh eyes. Record findings as local issue files.

The user may specify a scope: $ARGUMENTS

---

## Step 1: Determine Review Scope

Figure out what to review based on what the user provides:

- **Single task** (e.g. "swe-feature-001" or a description) — review the code produced in that task's sessions
- **Range** (e.g. "issues 001 through 005") — review cumulative changes across those tasks
- **Nothing specified** — ask the user: review the latest task, or review everything since the last milestone?

## Step 2: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals and constraints
2. `docs/lessons-log.md` — know what gotchas have already been identified
3. The relevant issue file(s) from `issues/` — find them in `in-progress/`, `done/`, or `planned/` and read each one for acceptance criteria and scope
4. The relevant SWE handoff note(s) in `docs/handoff-notes/swe/` — understand what was done and what decisions were made
5. `docs/test-plan.md` (if it exists) — understand what QA has defined as test requirements
6. `docs/env-context.md` (if it exists) — understand environment-specific constraints

Do NOT read the code yet. Understand the intent first so you can evaluate the code against what it was supposed to do, not just what it happens to do.

## Step 3: Read the Code

Now read the files that were created or modified (listed in the handoff notes under "Files Created or Modified"). Read them carefully, as if you did not write them — because in this session, you didn't.

## Step 4: Evaluate

Assess the code across these dimensions. Be critical, not polite. The goal is to catch problems before they compound.

**Correctness**
- Does the code do what the user story and acceptance criteria asked for?
- Are there edge cases that aren't handled?
- Are there logic errors, off-by-one mistakes, or incorrect assumptions?

**Test Coverage**
- Do the tests actually test the important behavior, or do they just test the happy path?
- Are there missing edge case tests?
- Could the tests pass even if the implementation were subtly wrong? (Tests that are too tightly coupled to implementation details are a smell.)
- If `docs/test-plan.md` exists: evaluate coverage against the test plan, not just against "does it test the happy path." Are QA's defined test requirements implemented?

**Security & Error Handling**
- Input validation — is user/external input trusted where it shouldn't be?
- Error handling — do failures surface clearly or get swallowed?
- Secrets, credentials, API keys — anything hardcoded that shouldn't be?
- Dependency risks — anything pulled in that's unnecessary or unmaintained?

**Consistency**
- Does the new code follow the same patterns, naming conventions, and style as the rest of the project?
- Are there naming mismatches between this code and existing code?
- If multiple tasks are being reviewed: do the pieces fit together coherently, or do they look like they were written by different people with different assumptions?

**Environment-Specific Concerns**
If `docs/env-context.md` exists, also evaluate:
- Memory constraints — any unbounded allocations, large buffers, or memory leaks?
- Target architecture — endianness assumptions, word size, alignment?
- Peripheral or hardware assumptions — hardcoded addresses, timing assumptions?
- Deployment constraints — binary size, startup time, resource limits?

Skip this section if no env-context exists or if it's not relevant (e.g., pure web app with no special constraints).

**Technical Debt**
- TODOs or FIXMEs left behind — are they tracked or forgotten?
- Hardcoded values that should be configurable
- Duplicated logic that should be extracted
- Overly complex code that could be simplified
- Missing documentation where intent isn't obvious from the code

**Architecture Fit**
- Does this code fit the architecture defined in Phase 3 of `/start`, or did it drift?
- Are module boundaries clean, or is there inappropriate coupling?
- Would this code be easy for the next session to extend or modify?

## Step 5: Present Findings

Organize your findings into three categories:

### Must Fix
Issues that will cause bugs, security problems, or make future work significantly harder. These should be addressed before moving on.

### Should Fix
Code quality issues that won't cause immediate problems but will accumulate as technical debt. Address in the current milestone if time allows.

### Nits
Style, naming, minor readability improvements. Note them but don't block on them.

For each finding:
- State the file and what the issue is
- Explain why it matters (not just "this is bad" — say what goes wrong if it's not fixed)
- Suggest a specific fix

## Step 6: Create Issue Files for Findings

After the user reviews and approves the findings, create issue files in `issues/backlog/` for **Must Fix** and **Should Fix** items. Do NOT create issues for Nits — those are informational only.

Check existing issue files to determine the next available issue number.

Identify the persona who is affected by each finding. Then create files following the naming convention:

For must-fix findings: `issues/backlog/qa-bug-[number].md`
For should-fix / tech debt findings: `issues/backlog/qa-techdebt-[number].md`

Use this template:

```markdown
# [Short descriptive title]

**Type:** bug | techdebt
**Expert:** swe
**Milestone:** [Current milestone]
**Status:** backlog
**Severity:** must-fix | should-fix
**Found by:** /review of [original task issue filename]

## User Story

As a [persona], I [need | want] [what the fix provides] so that I can [why it matters — what goes wrong without the fix].

## Description

[What's wrong, where it is (file paths), and what needs to change.]

## Acceptance Criteria

- [ ] [What "fixed" looks like from the persona's perspective]
- [ ] [Another verifiable criterion]

## Technical Notes

**Estimated effort:** [Small / Medium / Large session]
**File(s):** [affected file paths]
```

## Step 7: Update Documents

After creating issue files:
- Update `issues/issues-list.md` with the new issues
- Add any new lessons to `docs/lessons-log.md` (patterns that should be caught earlier next time)
- If the review found scope drift or incorrect decisions, flag these for the user to update in `docs/project-brief.md`
- List the created issue filenames so the user has a clear action list

Do not auto-fix the code. This is a review, not a refactoring session. Fixes should happen in a dedicated `/start` session so they go through the full plan → architect → test → implement → verify loop.
