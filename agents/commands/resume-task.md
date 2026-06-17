Resume an interrupted task that is already in progress. Works for any expert — the role is inferred from the task issue.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Select the task (in-progress only)

Pick the task to resume. **Only `in-progress/` tasks are eligible** — that is the bucket of work that was started but not finished.

- If the user named an issue, find it in `.sdlc/issues/in-progress/`. If it isn't there, tell the user where it actually is and stop — to start fresh planned work use `/start-task`.
- Otherwise, scan `.sdlc/issues/in-progress/` and list the candidates grouped by their `**Expert:**` field (show each one's `**Session:**` stamp). Ask the user which to resume.

If `in-progress/` is empty, tell the user there's nothing to resume and suggest `/start-task` to pick up planned work. Then stop.

Read the chosen issue. Note its `**Expert:**` field and its `**Session:**` stamp. **Do not move buckets** — the task is already in `in-progress/`.

---

## Phase 2: Reconstruct context (documents are memory)

Rebuild the state of the interrupted work from the documents — this is what lets a fresh session pick up where the last one stopped:

1. Map the issue's `**Expert:**` field to its role file (`swe→swe.md`, `qa→qa.md`, `devops→devops.md`, `sa→system-architect.md`, `sec→security-engineer.md`, `pm→project-manager.md` under `.agents/roles/`) and load it for the role's identity, **Context to load** list, and **Execution discipline**.
2. Read `docs/project-brief.md`, `.sdlc/lessons-log.md`, the role's **Context to load** documents, and the most recent handoff note in that role's `.sdlc/handoff-notes/<role-dir>/`.
3. Read any `## Session NN Summary` section already appended to the issue — it records what the prior session got done and what remains.
4. Inspect the actual working tree / produced artifacts to see what already exists versus what the acceptance criteria still require.

**On Claude Code:** if the issue's `**Session:**` field holds a real session id and you want the original conversation with full history rather than a document-based reconstruction, tell the user they can run `claude --resume <session-id>` from this directory in their shell. (A running command can't re-attach to a different conversation itself — this is a shell action for the user.)

Confirm understanding with the user:
- "Resuming: [issue filename] — [objective]"
- "Role: [which expert]"
- "Already done: [1-2 sentences from the session summary / artifacts]"
- "Remaining: [the acceptance criteria not yet met]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 3: Finish the work

Continue the task from where it stopped, following the **Execution discipline** in the loaded role file. Do only what remains — don't redo completed, verified work. Stay within the issue's scope; flag out-of-scope discoveries.

---

## Phase 4: Verify

Walk through each acceptance criterion in the issue file:

- Can each one be demonstrated or verified now? Check them off one by one.
- Run whatever the role's discipline requires; check for regressions where applicable.

If verification fails, return to Phase 3. Do not proceed until verification passes or you've documented why a criterion can't be met yet.

---

## Phase 5: Review and report

Summarize:

- What was finished this session and where (file paths)
- Acceptance criteria status (all met / any caveats)
- Any decisions made that weren't already recorded
- Downstream impact / follow-ups
- Anything the user should manually verify

Then ask the user if they'd like to proceed to the role's `*-handoff` skill to close out the session. The handoff writes the session note and moves the issue `in-progress → done` (setting `**Status:** done`) once all acceptance criteria are met.
