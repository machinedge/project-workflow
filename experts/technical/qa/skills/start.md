Begin an execution session for a QA-scoped issue.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Load Context

Read these files automatically — do not ask the user to provide them:
1. `docs/project-brief.md`
2. `docs/roadmap.md` — understand the current milestone scope
3. The task issue:
   - If user specified an issue (e.g. "qa-feature-005" or a description), find and read it from `issues/`
   - If not, check project brief's "Next task" field for the issue filename
   - If still unclear, scan `issues/planned/` and `issues/in-progress/` for QA tasks and ask
4. Most recent handoff note in `docs/handoff-notes/qa/` (if any exist)
5. Relevant SWE handoff notes in `docs/handoff-notes/swe/` — understand what was built and what changed
6. `docs/test-plan.md` (if it exists) — evaluate coverage against it
7. `docs/env-context.md` (if it exists) — check for environment-specific concerns
8. `docs/architecture.md` (if it exists) — understand system-level constraints and review against architectural intent

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Last session: [1 sentence from handoff, or 'First session']"
- "Today's task: [issue filename] — [restate the task objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 2: Plan the Approach

Before doing any review or test work, present a short plan:

- What is being reviewed or tested? (1-3 sentences)
- What artifacts will you produce? (issues, test plan updates, regression report, etc.)
- What are the key concerns or risk areas to focus on?
- Are there any open questions that need answers before you start?

Keep this concise — a few bullet points, not a document. The goal is alignment, not a formal spec.

Wait for user approval or feedback before proceeding.

---

## Phase 3: Execute

Perform the QA work defined by the task issue:

- **Review code** with fresh eyes. Read it as if you didn't write it — because you didn't.
- **Evaluate against intent** — does the implementation match what the user story asked for, not just what the code happens to do?
- **Check acceptance criteria** — walk through each criterion in the issue being reviewed. Is each one demonstrably met?
- **Assess test coverage** — if `docs/test-plan.md` exists, evaluate whether tests cover what it specifies. Identify gaps.
- **Identify issues** — categorize findings by severity:
  - **must-fix:** Broken functionality, missing acceptance criteria, security concerns
  - **should-fix:** Code quality, maintainability, edge cases not handled
  - **nit:** Style, naming, minor improvements

Stay within the scope defined in the task issue. If you discover something out of scope, flag it — don't chase it.

---

## Phase 4: Verify

Walk through each acceptance criterion from the QA task issue (not the work being reviewed — your own issue's criteria):

- Can each criterion be demonstrated or verified from the review work performed?
- Check them off one by one.

If any criterion is not met, go back to Phase 3 and address it. Do not proceed until all acceptance criteria are satisfied or you've documented why one cannot be met yet.

---

## Phase 5: Record Findings

For each issue found:
- Create an issue file in `issues/backlog/` with a clear title, description, and severity
- Reference the source file and line numbers where applicable
- Include reproduction steps or evidence

If no issues are found, say so explicitly — a clean review is a valid outcome.

---

## Phase 6: Report

Summarize what was done:

- What was reviewed and the scope of review
- Total findings by severity (must-fix / should-fix / nit)
- Key findings highlighted
- Acceptance criteria status for the reviewed work
- Test coverage assessment (adequate / gaps identified)
- Any concerns, risks, or follow-up items
- Anything the user should manually verify

Then ask the user if they'd like to proceed to `/handoff` to close out the session.
