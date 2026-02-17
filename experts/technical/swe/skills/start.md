Begin an execution session. This is the most important command.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Load Context

Read these files automatically — do not ask the user to provide them:
1. `docs/project-brief.md`
2. `docs/lessons-log.md`
3. The task issue:
   - If user specified an issue (e.g. "swe-feature-001" or a description), find and read it from `issues/`
   - If not, check project brief's "Next task" field for the issue filename
   - If still unclear, scan `issues/planned/` and `issues/in-progress/` for SWE tasks and ask
4. Most recent handoff note in `docs/handoff-notes/swe/` (if any exist)
5. `docs/test-plan.md` (if it exists) — skim for test requirements relevant to this task
6. `docs/env-context.md` (if it exists) — skim for environment constraints relevant to this task

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Last session: [1 sentence from handoff, or 'First session']"
- "Today's task: [issue filename] — [restate the user story objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 2: Plan the Approach

Before writing any code, present a short plan for how you will accomplish the task:

- What is the approach? (1-3 sentences)
- What files will you create or modify?
- What are the key decisions or trade-offs?
- Are there any open questions that need answers before you start?

Keep this concise — a few bullet points, not a document. The goal is alignment, not a formal spec.

Wait for user approval or feedback before proceeding.

---

## Phase 3: Architect the Solution

Design before you build:

- Define the structure: modules, functions, classes, data models, API contracts — whatever applies.
- Identify how this integrates with existing code (if applicable). Read relevant existing files.
- Call out any dependencies, libraries, or tools needed.
- If there are multiple valid approaches, present them with trade-offs and recommend one.

For small tasks this can be brief. For large tasks this should be thorough. Scale to the complexity.

Present the architecture to the user. Wait for approval before writing implementation code.

---

## Phase 4: Write Tests First

Write test code before implementation code:

- **Unit tests** for the core logic (individual functions, edge cases, error handling)
- **Integration tests** for how components interact (API calls, data flow, end-to-end paths)

If `docs/test-plan.md` exists and covers this task, implement the test requirements QA defined — don't invent different ones. Use QA's test plan as the specification for what to test and at what level.

If the project has an existing test framework, use it. If not, choose one that fits the stack and note the decision.

Tests should be runnable but expected to fail at this point (they test code that doesn't exist yet). Save the test files.

If tests are not applicable to this task (e.g., the task is writing documentation or configuration), skip this phase and note why.

---

## Phase 5: Implement

Now write the implementation code:

- Follow the architecture from Phase 3.
- Write code that makes the tests from Phase 4 pass.
- If `docs/env-context.md` exists, respect its constraints (target architecture, memory limits, toolchain requirements, etc.).
- Stay within the scope defined in the issue. If you discover something out of scope, flag it — don't do it.
- If you make a decision that wasn't covered in the architecture, note it for the handoff.

---

## Phase 6: Verify

Run verification before declaring the task complete:

- **Run the tests.** All tests from Phase 4 should pass. If any fail, fix the implementation (not the tests, unless the test was wrong).
- **Check acceptance criteria.** Walk through each acceptance criterion from the issue file. Can each one be demonstrated or verified? Check them off.
- **Check for regressions** — does existing functionality still work?

If verification fails, go back to Phase 5 and fix. Do not proceed until verification passes.

---

## Phase 7: Review and Report

Summarize what was done:

- What was implemented and where (file paths)
- What tests were written and their status (all passing / any caveats)
- Acceptance criteria status (all met / any caveats)
- Any decisions made during implementation that weren't in the original plan
- Any concerns, technical debt, or follow-up items
- Anything the user should manually verify

Then ask the user if they'd like to proceed to `/handoff` to close out the session.
