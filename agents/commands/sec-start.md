Begin an execution session. Pick up a security-scoped issue and work through it.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Load Context

Read these files automatically — do not ask the user to provide them:
1. `docs/project-brief.md`
2. `docs/security-requirements.md` (if it exists — you own this)
3. `docs/architecture.md` (if it exists) — trust boundaries
4. `.sdlc/lessons-log.md`
5. The task issue:
   - If user specified an issue (e.g. "sec-feature-001" or a description), find and read it from `.sdlc/issues/`
   - If not, check project brief's "Next task" field for the issue filename
   - If still unclear, scan `.sdlc/issues/planned/` and `.sdlc/issues/in-progress/` for security-scoped tasks and ask
6. Most recent handoff note in `.sdlc/handoff-notes/security-engineer/` (if any exist)
7. `docs/roadmap.md` (if it exists) — understand the current milestone scope

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Last Security session: [1 sentence from handoff, or 'First Security session']"
- "Today's task: [issue filename] — [restate the objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 2: Plan the Approach

Before producing any artifacts, present a short plan:

- What is the approach? (1-3 sentences)
- Is this a requirements task (use the `sec-requirements` skill) or a review task (use the `sec-review` skill)?
- What artifacts will you create or modify?
- Are there any open questions that need answers before you start?

Wait for user approval or feedback before proceeding.

---

## Phase 3: Execute

Do the security work for the issue. This is assessment, requirement-definition, and review — not implementation.

- For a **requirements** task, follow the `sec-requirements` skill: threat model → verifiable controls → `docs/security-requirements.md`.
- For a **review** task, follow the `sec-review` skill: evaluate against the requirements, default to refuted, gather file:line evidence.
- If the task turns out to require code changes, flag it and suggest creating an SWE issue (`/swe-start`) rather than patching code yourself.

Flag anything unclear or contradictory before proceeding.

---

## Phase 4: Verify

Walk through each acceptance criterion from the task issue:

- Can each criterion be demonstrated or verified against the artifacts/findings produced?
- For review tasks, confirm each in-scope security requirement was actually checked, with evidence.
- Check them off one by one.

If any criterion is not met, go back to Phase 3 and address it.

---

## Phase 5: Review and Report

Summarize what was done:

- What was assessed, required, or found, and where (file paths, issue filenames)
- Acceptance criteria status (all met / any caveats)
- Overall security verdict for the scope (meets the bar / open must-fix issues block release)
- Downstream impact: what SWE, QA, or DevOps need to know
- Any concerns, open questions, or follow-up items

Then ask the user if they'd like to proceed to the `sec-handoff` skill to close out the session.
