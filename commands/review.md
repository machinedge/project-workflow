Review code produced by previous sessions with fresh eyes.

The user may specify a scope: $ARGUMENTS

---

## Step 1: Determine Review Scope

Figure out what to review based on what the user provides:

- **Single task** (e.g. "TASK-03") — review the code produced in that task's sessions
- **Range** (e.g. "TASK-01 through TASK-04") — review cumulative changes across those tasks
- **Nothing specified** — ask the user: review the latest task, or review everything since the last milestone?

## Step 2: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals and constraints
2. `docs/lessons-log.md` — know what gotchas have already been identified
3. The relevant task brief(s) in `docs/tasks/`
4. The relevant handoff note(s) in `docs/handoff-notes/` — understand what was done and what decisions were made

Do NOT read the code yet. Understand the intent first so you can evaluate the code against what it was supposed to do, not just what it happens to do.

## Step 3: Read the Code

Now read the files that were created or modified (listed in the handoff notes under "Files Created or Modified"). Read them carefully, as if you did not write them — because in this session, you didn't.

## Step 4: Evaluate

Assess the code across these dimensions. Be critical, not polite. The goal is to catch problems before they compound.

**Correctness**
- Does the code do what the task brief asked for?
- Are there edge cases that aren't handled?
- Are there logic errors, off-by-one mistakes, or incorrect assumptions?

**Test Coverage**
- Do the tests actually test the important behavior, or do they just test the happy path?
- Are there missing edge case tests?
- Could the tests pass even if the implementation were subtly wrong? (Tests that are too tightly coupled to implementation details are a smell.)

**Security & Error Handling**
- Input validation — is user/external input trusted where it shouldn't be?
- Error handling — do failures surface clearly or get swallowed?
- Secrets, credentials, API keys — anything hardcoded that shouldn't be?
- Dependency risks — anything pulled in that's unnecessary or unmaintained?

**Consistency**
- Does the new code follow the same patterns, naming conventions, and style as the rest of the project?
- Are there naming mismatches between this code and existing code?
- If multiple tasks are being reviewed: do the pieces fit together coherently, or do they look like they were written by different people with different assumptions?

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

## Step 6: Update Documents

After presenting findings:
- Add any new lessons to `docs/lessons-log.md` (patterns that should be caught earlier next time)
- If the review found scope drift or incorrect decisions, flag these for the user to update in `docs/project-brief.md`
- If "Must Fix" items exist, ask the user if they want to create a follow-up task brief in `docs/tasks/` to address them

Do not auto-fix the code. This is a review, not a refactoring session. Fixes should happen in a dedicated `/start` session so they go through the full plan → architect → test → implement → verify loop.
