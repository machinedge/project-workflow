Begin an execution session. Pick up an architect-scoped issue and work through it.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Load Context

Read these files automatically — do not ask the user to provide them:
1. `docs/project-brief.md`
2. `docs/architecture.md` (if it exists)
3. `docs/lessons-log.md`
4. The task issue:
   - If user specified an issue (e.g. "sa-feature-001" or a description), find and read it from `issues/`
   - If not, check project brief's "Next task" field for the issue filename
   - If still unclear, scan `issues/planned/` and `issues/in-progress/` for architect-scoped tasks and ask
5. Most recent handoff note in `docs/handoff-notes/system-architect/` (if any exist)
6. `docs/roadmap.md` (if it exists) — understand the current milestone scope
7. `docs/env-context.md` (if it exists) — skim for constraints relevant to this task

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Last session: [1 sentence from handoff, or 'First session']"
- "Today's task: [issue filename] — [restate the objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 2: Plan the Approach

Before producing any artifacts, present a short plan:

- What is the approach? (1-3 sentences)
- What artifacts will you create or modify?
- What are the key decisions or trade-offs?
- Are there any open questions that need answers before you start?

Keep this concise. The goal is alignment, not a formal spec.

Wait for user approval or feedback before proceeding.

---

## Phase 3: Research and Analyze

Gather the information needed to make sound architectural decisions:

- Read relevant existing code, configs, or documentation
- Identify constraints from the project brief, env-context, and existing architecture
- If the task requires evaluating technology options, do the evaluation here (same rigor as `/research`)
- If the task involves a new component or subsystem, identify integration points with existing components

Present your analysis:
- Key findings
- Constraints that will shape the design
- Options where multiple valid approaches exist (with trade-offs)

Wait for user feedback before proceeding to design.

---

## Phase 4: Design and Document

Produce the architectural artifacts required by the task:

- If creating new architecture: draft the relevant sections of `docs/architecture.md`
- If extending existing architecture: draft the additions or modifications
- If the task produces a different artifact (research summary, decision record), draft it here

For each significant decision, use ADR format:
- Context (what question needed answering)
- Options (what was considered)
- Decision (what was chosen)
- Consequences (trade-offs accepted)

Present the draft to the user. Wait for approval before saving.

---

## Phase 5: Validate

Before finalizing, check coherence:

- Do the new decisions conflict with existing architectural decisions?
- Are component boundaries clear and consistent?
- Are interfaces between components fully specified?
- Are cross-cutting concerns (auth, logging, error handling, config) addressed?
- Does the architecture respect constraints from `docs/project-brief.md` and `docs/env-context.md`?
- Will downstream experts (SWE, QA, DevOps) have enough information to do their work?

If validation reveals issues, go back to Phase 4 and revise. Do not proceed until the design is coherent.

---

## Phase 6: Verify

Walk through each acceptance criterion from the task issue:

- Can each criterion be demonstrated or verified against the artifacts produced?
- Check them off one by one.

If any criterion is not met, go back to the appropriate phase and address it.

---

## Phase 7: Review and Report

Summarize what was done:

- What was designed or decided and where (file paths, artifact names)
- Acceptance criteria status (all met / any caveats)
- Any decisions made during the session that weren't in the original plan
- Downstream impact: what other experts need to know about these changes
- Any concerns, open questions, or follow-up items
- Anything the user should manually verify

Then ask the user if they'd like to proceed to `/handoff` to close out the session.
