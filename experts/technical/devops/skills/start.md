Begin an execution session for a DevOps-scoped issue.

The user may specify a task: $ARGUMENTS

---

## Phase 1: Load Context

Read these files automatically — do not ask the user to provide them:
1. `docs/project-brief.md`
2. `docs/env-context.md` (if it exists) — current environment and deployment context
3. `docs/release-plan.md` (if it exists) — current release gates and rollback procedures
4. The task issue:
   - If user specified an issue (e.g. "ops-feature-001" or a description), find and read it from `issues/`
   - If not, check project brief's "Next task" field for the issue filename
   - If still unclear, scan `issues/planned/` and `issues/in-progress/` for DevOps tasks and ask
5. Most recent handoff note in `docs/handoff-notes/devops/` (if any exist)
6. Relevant SWE handoff notes in `docs/handoff-notes/swe/` — understand what was built (what needs to be deployed)
7. `docs/test-plan.md` (if it exists) — informs pipeline test stages
8. Check current pipeline status (if a pipeline exists)
9. `docs/architecture.md` (if it exists) — understand system-level constraints relevant to infrastructure and deployment

Confirm understanding with the user:
- "Project: [1 sentence]"
- "Last session: [1 sentence from handoff, or 'First session']"
- "Today's task: [issue filename] — [restate the task objective in your own words]"
- Flag anything unclear or contradictory.

Wait for user confirmation before proceeding.

---

## Phase 2: Plan the Approach

Before making any changes, present a short plan:

- What is being configured, deployed, or set up? (1-3 sentences)
- What artifacts will you produce? (env-context updates, pipeline configs, release-plan updates, etc.)
- What are the key risks or concerns? (downtime, data loss, environment drift, etc.)
- Are there any open questions that need answers before you start?

Keep this concise — a few bullet points, not a document. The goal is alignment, not a formal spec.

Wait for user approval or feedback before proceeding.

---

## Phase 3: Execute

Perform the DevOps work defined by the task issue:

- **Don't assume infrastructure exists.** Verify before depending on it.
- **Document everything.** Environments, configurations, and deployment procedures must be reproducible from documentation alone.
- **If you discover something about the environment that wasn't captured,** update `docs/env-context.md`.
- **Follow the release plan** if one exists. If one doesn't and the task requires deployment, flag this.
- **Automate what's repeated.** If you do it twice, script it. If you script it, test it.

Stay within the scope defined in the task issue. If you discover something out of scope, flag it — don't do it.

---

## Phase 4: Verify

Run verification before declaring the task complete:

- **Check acceptance criteria.** Walk through each acceptance criterion from the issue file. Can each one be demonstrated or verified?
- **Verify environments are functional.** Don't assume — run checks, hit endpoints, confirm connectivity.
- **Confirm rollback is documented.** If the task involved deployment or infrastructure changes, ensure rollback procedures exist.
- **Make failures visible.** Every stage should have clear pass/fail criteria. Silent failures are worse than loud ones.

If verification fails, go back to Phase 3 and fix. Do not proceed until verification passes.

---

## Phase 5: Report

Summarize what was done:

- What was configured, deployed, or set up (and where)
- Acceptance criteria status (all met / any caveats)
- Environment changes made (document for `docs/env-context.md`)
- Pipeline changes made (if applicable)
- Rollback procedures (if applicable)
- Any decisions made during execution that weren't in the original plan
- Any concerns, risks, or follow-up items
- Anything the user should manually verify

Then ask the user if they'd like to proceed to `/handoff` to close out the session.
