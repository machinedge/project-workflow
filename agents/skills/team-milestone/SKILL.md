---
name: team-milestone
description: "Compile and build one roadmap milestone end-to-end: enrich it across SA, Security, QA, and DevOps, synthesize implementation-ready tasks, implement and verify them, then run the close-out review gates. Use when the user hands off a whole milestone and wants the full lifecycle run, not a single skill."
---

Run one roadmap milestone through its full lifecycle. This is a **cross-expert** skill — no single expert role is loaded; it orchestrates the expert skills in sequence, pausing at each **[GATE]** for human approval.

The user names the milestone to run: $ARGUMENTS

> **Claude Code:** a multi-agent accelerator exists at `.claude/workflows/milestone.js` that runs the enrichment and review fan-outs in parallel and drives the implementation loop with a small model. Prefer it when available (invoke the Workflow tool with that script). This runbook is the portable, harness-neutral equivalent — and the spec that accelerator implements. On harnesses without the Workflow tool, follow the steps below sequentially.

## Step 0: Load context and confirm the milestone

Read `docs/project-brief.md` and `docs/roadmap.md`. Identify the named milestone (if none was named, propose the next un-started one and confirm). Restate its scope and demo definition in your own words.

If `docs/roadmap.md` doesn't exist, stop and tell the user: "No roadmap exists. Ask for the `pm-roadmap` skill first — there's no milestone to compile."

State the plan: "I'll enrich this milestone across SA, Security, QA, and DevOps, synthesize implementation-ready tasks, implement and verify each, then run the close-out reviews. I'll pause for your approval at the foundations gate, the task gate, and the go/no-go gate." Wait for the user to start.

**Timebox the enrichment** — the standing risk on a foundations milestone is analysis paralysis. Aim for sufficient, not exhaustive.

## Phase 1: Enrich (cross-expert review of the milestone)

Produce the four foundation artifacts for this milestone. On Claude Code these run in parallel; otherwise run them in order. Each is the existing skill, scoped to this milestone:

- **System Architect** → `sa-design` (scoped to the milestone): component boundaries, interfaces, data flow, contracts → `docs/architecture.md`.
- **Security** → `sec-requirements`: threat model + verifiable controls (`SR-NNN`) → `docs/security-requirements.md`.
- **QA** → `qa-test-plan`: test strategy, acceptance criteria, explicit test cases → `docs/test-plan.md`.
- **DevOps** → `ops-pipeline`: build/test/deploy stages and environment needs.

Each skill has its own user-approval step; honor them. If an upstream artifact a skill needs is missing, follow that skill's guidance — don't invent data.

### [GATE 1] Foundations approval

Consolidate the four artifacts into a short walkthrough (the milestone's "Foundations defined" demo): the architecture slice, the top threats and their controls, the test strategy, and the pipeline. Present it. **Wait for the user to approve the foundations before any tasks are written.** If they want changes, loop back to the relevant skill.

## Phase 2: Compile (synthesize implementation-ready tasks)

Run `pm-decompose` in **implementation-ready mode** (see its Modes section and `docs/task-detail-standard.md`). It inlines the enrichment outputs — architecture contracts, `SR-NNN` security constraints, and test cases — into each task so a small model can implement it.

Then run the **completeness check** (`pm-decompose` Step 4.5): for each task, confirm it could be implemented and tested with no further design decision. Enrich any task that fails; if the gap is in a source artifact, flag it.

### [GATE 2] Task set approval

Present the task list with a one-line summary of each and the dependency order. **Wait for the user to approve the task set before implementation.**

## Phase 3: Implement (per task, in dependency order)

For each task, in dependency order:

1. Implement the code and tests exactly as the task specifies. On Claude Code, the accelerator delegates this to a small model; on a plain harness, implement it directly per `/swe-start`'s execution discipline.
2. **Verify**: run the task's tests and check each acceptance criterion. A task is not done until its tests pass and its criteria are met.
3. If verification fails, retry. If it still fails after a reasonable attempt (or the task turns out under-specified), escalate — fix the task spec or hand it to a fuller `/swe-start` session — and note it.
4. Record progress so a resumed run knows what's already built.

## Phase 4: Review / close-out (automatic gates)

Run the review gates over the milestone's implemented work. On Claude Code these run in parallel; otherwise in order:

- **QA** → `qa-review` (code vs. intent and test plan)
- **System Architect** → `sa-review` (conformance to architecture)
- **Security** → `sec-review` (controls enforced; vuln/authz/secrets/deps)
- **QA** → `qa-regression` (acceptance criteria still pass across the milestone)

Collect all findings. **Must-fix** findings loop back to Phase 3 (implement the fix, re-verify). Other findings become backlog issues via the skills' own issue-filing steps.

### [GATE 3] Go / no-go

Present the review verdict: criteria met, open must-fix issues (if any), security posture, regression result. **Wait for the user's go/no-go.** Do not declare the milestone done while a must-fix issue is open.

## Phase 5: Wrap-up

Once the user gives the go:

1. Run `pm-postmortem` for the milestone (honest assessment, lessons, plan adjustments).
2. Update `docs/roadmap.md` (mark the milestone complete) and `docs/project-brief.md` status.
3. Move completed issues to `.workflow/issues/done/` (`move-issue.sh`) and regenerate the list (`update-issues-list.sh`).
4. Write handoff notes for the experts that did substantive work, via their `*-handoff` skills.

Report what was built, what's deferred to the backlog, and what the next milestone needs to know.

## Principles

- **Gated, not autonomous.** The orchestration moves fast between gates but never past one without the user. Phases 1, 2, and 4 each end in an explicit human decision.
- **Reuse, don't reinvent.** Every phase is an existing skill. This runbook sequences them and carries their outputs forward; it doesn't re-implement their logic.
- **Documents are memory.** All state lands in `docs/` and `.workflow/` so a resumed or parallel run — and the next session — can pick up without this conversation.
