Begin an execution session for a planned task. Works for any expert — the role is inferred from the task issue.

The user may specify a task: $ARGUMENTS

> Your Claude Code session id is `${CLAUDE_SESSION_ID}`. Use this exact value when stamping the issue's `**Session:**` field below. If that placeholder appears literally (you are not on Claude Code), stamp today's date instead — never write the literal `${CLAUDE_SESSION_ID}` text.

---

## Phase 1: Select the task (planned only)

Pick exactly one task to execute. **Only `planned/` tasks are eligible** — that is the bucket of work approved for execution.

- If the user named an issue (e.g. "swe-feature-001" or a description), find it in `.sdlc/issues/planned/`. If it isn't there, tell the user where it actually is and stop — `start-task` does not pull from `backlog/` (un-promoted) or `in-progress/` (use `/resume-task` for that).
- Otherwise, check the project brief's "Next task" field for the issue filename (it should be in `planned/`).
- Otherwise, scan `.sdlc/issues/planned/` and list the candidates grouped by their `**Expert:**` field. Ask the user which to pick.

If `planned/` is empty, tell the user: "No tasks are promoted for execution. Promote tasks from `backlog/` to `planned/` first (PM decision, or the `team-milestone` planned-set gate)." Then stop.

Read the chosen issue and note its `**Expert:**` field.

---

## Phase 2: Claim the task (move to in-progress + stamp)

Before doing any work, claim the task so the `in-progress/` bucket reflects what's being worked:

1. Run `.agents/scripts/move-issue.sh <filename> in-progress` to move the issue into `.sdlc/issues/in-progress/`.
2. Edit the moved file's header: set `**Status:** in-progress` and set `**Session:**` to your session id (see the note at the top — the `${CLAUDE_SESSION_ID}` value on Claude Code, otherwise today's date).
3. Run `.agents/scripts/update-issues-list.sh` to regenerate the issues list.

---

## Phase 3: Load role and context

Map the issue's `**Expert:**` field to its role file and load it — that role file carries the expert's identity, the documents to load, and the **execution discipline** you will follow:

| Expert | Role file |
|--------|-----------|
| `swe` | `.agents/roles/swe.md` |
| `qa` | `.agents/roles/qa.md` |
| `devops` | `.agents/roles/devops.md` |
| `sa` | `.agents/roles/system-architect.md` |
| `sec` | `.agents/roles/security-engineer.md` |
| `pm` | `.agents/roles/project-manager.md` |

Then read these automatically — do not ask the user to provide them:

1. `docs/project-brief.md`
2. `.sdlc/lessons-log.md`
3. The documents listed under the role's **Context to load** section.
4. The most recent handoff note in that role's `.sdlc/handoff-notes/<role-dir>/` (if any exist).

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Role: [which expert, from the issue]"
- "Last session: [1 sentence from the role's latest handoff, or 'First session']"
- "Today's task: [issue filename] — [restate the objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 4: Plan the approach

Present a short plan before producing anything:

- What is the approach? (1-3 sentences)
- What files or artifacts will you create or modify?
- What are the key decisions or trade-offs?
- Are there any open questions that need answers before you start?

Keep it concise — a few bullet points, not a document. The goal is alignment. Wait for user approval or feedback before proceeding.

---

## Phase 5: Execute

Do the work, following the **Execution discipline** in the loaded role file (e.g. SWE designs → writes tests first → implements; QA reviews and records findings; SA researches → designs → validates; etc.).

- Stay within the scope defined in the issue. If you discover something out of scope, flag it — don't do it.
- If you make a decision that affects future work, note it for the handoff.

---

## Phase 6: Verify

Walk through each acceptance criterion in the issue file:

- Can each one be demonstrated or verified? Check them off one by one.
- Run whatever the role's discipline requires (tests, endpoint checks, evidence-gathering).
- Check for regressions where applicable.

If verification fails, go back to Phase 5. Do not proceed until verification passes or you've documented why a criterion can't be met yet.

---

## Phase 7: Review and report

Summarize what was done:

- What was produced and where (file paths)
- Acceptance criteria status (all met / any caveats)
- Any decisions made that weren't in the original plan
- Downstream impact / follow-ups / technical debt
- Anything the user should manually verify

Then ask the user if they'd like to proceed to the role's `*-handoff` skill to close out the session. The handoff writes the session note and moves the issue `in-progress → done` (setting `**Status:** done`) once all acceptance criteria are met.
