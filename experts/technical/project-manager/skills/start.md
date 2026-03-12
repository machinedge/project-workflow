Begin an execution session for a PM-scoped issue.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Load Context

Read these files automatically — do not ask the user to provide them:
1. `docs/project-brief.md`
2. `docs/roadmap.md`
3. `issues/issues-list.md`
4. The task issue:
   - If user specified an issue (e.g. "pm-feature-006" or a description), find and read it from `issues/`
   - If not, check project brief's "Next task" field for the issue filename
   - If still unclear, scan `issues/planned/` and `issues/in-progress/` for PM tasks and ask
5. Most recent handoff note in `docs/handoff-notes/pm/` (if any exist)
6. `docs/architecture.md` (if it exists) — understand system-level context relevant to this task

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Last PM session: [1 sentence from handoff, or 'First PM session']"
- "Today's task: [issue filename] — [restate the task objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 2: Plan the Approach

Before doing any work, present a short plan:

- What is the objective? (1-2 sentences)
- What artifacts will you produce or update?
- What information do you need to gather or analyze?
- Are there any open questions that need answers before you start?

Keep this concise — a few bullet points, not a document. The goal is alignment, not a formal spec.

Wait for user approval or feedback before proceeding.

---

## Phase 3: Execute

Do the PM work defined in the issue:

- Synthesize information from project documents, handoff notes, and user input.
- Produce or update planning artifacts (project brief, roadmap, issues, interview notes, etc.).
- Make scoping and prioritization decisions — document reasoning, not just conclusions.
- Ask questions to fill gaps. Don't assume or prescribe.
- Stay within the scope defined in the issue. If you discover something out of scope, flag it — don't do it.
- If you make a decision that affects future work, note it for the handoff.

PM work is analysis, synthesis, and artifact production — not code. If the task requires implementation, flag it and suggest routing to an SWE session.

---

## Phase 4: Verify

Walk through each acceptance criterion from the issue file:

- Can each criterion be demonstrated or verified from the artifacts produced?
- Check them off one by one.
- If any criterion is not met, go back to Phase 3 and address it.

Do not proceed until all acceptance criteria are satisfied or you've documented why one cannot be met yet.

---

## Phase 5: Review and Report

Summarize what was done:

- What artifacts were produced or updated (file paths)
- Acceptance criteria status (all met / any caveats)
- Any decisions made during the session
- Any concerns, open questions, or follow-up items
- Anything the user should review or approve

Then ask the user if they'd like to proceed to `/handoff` to close out the session.
