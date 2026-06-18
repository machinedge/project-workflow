---
name: team-milestone
description: "Compile and build one roadmap milestone end-to-end: enrich it across SA, Security, UX, QA, and DevOps, synthesize implementation-ready tasks, implement and verify them, then run the close-out review gates. Use when the user hands off a whole milestone and wants the full lifecycle run, not a single skill."
---

Run one roadmap milestone through its full lifecycle. This is a **cross-expert** skill — no single expert role is loaded; it orchestrates the expert skills in sequence, pausing at each **[GATE]** for human approval.

The user names the milestone to run: $ARGUMENTS

> **Claude Code:** a multi-agent accelerator exists at `.claude/workflows/milestone.js` that runs the enrichment and review fan-outs in parallel and drives the implementation loop with a small model. Prefer it when available. Invoke the Workflow tool **once per phase**, passing the milestone id and phase as `args` — either the object form `args: { milestone: 'M1', phase: 'plan' }` or the string form `"M1 plan"` (the named milestone is `$ARGUMENTS`). The phases are `plan → enrich → compile → implement → review → postmortem`; the human gate for each runs in the conversation between invocations, and the `implement` phase also takes `args.tasks` (the planned/ paths approved at GATE 3). The closing `postmortem` phase runs after the GATE 4 go decision — it drafts the honest close-out assessment and the updated brief/roadmap/lessons-log for the wrap-up gate. This runbook is the portable, harness-neutral equivalent — and the spec that accelerator implements. On harnesses without the Workflow tool, follow the steps below sequentially.

## Step 0: Load context and confirm the milestone

Read `docs/project-brief.md` and `docs/roadmap.md`. Identify the named milestone (if none was named, propose the next un-started one and confirm). Restate its scope and demo definition in your own words.

If `docs/roadmap.md` doesn't exist, stop and tell the user: "No roadmap exists. Ask for the `pm-roadmap` skill first — there's no milestone to compile."

State the plan: "I'll decompose this milestone into an execution plan first, then enrich it across SA, Security, UX, QA, and DevOps, densify the tasks to implementation-ready and promote the approved ones for execution, implement and verify each, then run the close-out reviews. I'll pause for your approval at the plan gate, the foundations gate, the planned-set gate, and the go/no-go gate." Wait for the user to start.

**Timebox the enrichment** — the standing risk on a foundations milestone is analysis paralysis. Aim for sufficient, not exhaustive.

## Phase 1: Plan (decompose the milestone into an execution plan)

Decompose the milestone **before** enriching it, so the enrichment and the human both have the concrete task list in view. Run `pm-decompose` in **standard mode** (see its Modes section): session-sized tasks with acceptance criteria, referenced file paths, and dependency order, created under `.sdlc/issues/backlog/`. Do **not** aim for implementation-ready detail yet — the foundation artifacts don't exist, so the tasks get densified later in Compile.

### [GATE 1] Plan approval

Present the task list and dependency order. **Wait for the user to approve the execution plan before enriching.** Scope changes are cheap here, before any foundations work is invested. If they want changes, re-run the decomposition.

## Phase 2: Enrich (cross-expert review of the milestone)

Produce the foundation artifacts for this milestone, each **scoped to the planned task set** from Phase 1. On Claude Code these run in parallel; otherwise run them in order. Each is the existing skill, scoped to this milestone:

- **System Architect** → `sa-design` (scoped to the milestone): component boundaries, interfaces, data flow, contracts → `docs/architecture.md`.
- **Security** → `sec-requirements`: threat model + verifiable controls (`SR-NNN`) → `docs/security-requirements.md`.
- **UX Designer** → `ux-guidelines`: user flows, interaction, accessibility, content & CLI ergonomics (`UX-NNN`) → `docs/ux-guidelines.md` (says so and produces a minimal note if the milestone has no user-facing surface).
- **QA** → `qa-test-plan`: test strategy, acceptance criteria, explicit test cases → `docs/test-plan.md`.
- **DevOps** → `ops-pipeline`: build/test/deploy stages and environment needs.

Each skill has its own user-approval step; honor them. If an upstream artifact a skill needs is missing, follow that skill's guidance — don't invent data.

### [GATE 2] Foundations approval

Consolidate the foundation artifacts into a short walkthrough (the milestone's "Foundations defined" demo): the architecture slice, the top threats and their controls, the key UX flows and their requirements, the test strategy, and the pipeline. Present it. **Wait for the user to approve the foundations before the tasks are densified.** If they want changes, loop back to the relevant skill.

## Phase 3: Compile (densify the tasks and promote them for execution)

Run `pm-decompose` in **implementation-ready mode** (see its Modes section and `docs/task-detail-standard.md`). The skeleton tasks already exist from Phase 1 — **densify each one in place** (reuse its issue number; don't create duplicates), inlining the enrichment outputs — architecture contracts, `SR-NNN` security constraints, and test cases — so a small model can implement it.

Then run the **completeness check** (`pm-decompose` Step 4.5): for each task, confirm it could be implemented and tested with no further design decision. Enrich any task that fails; if the gap is in a source artifact, flag it. Propose which tasks are ready to **promote** (cleared the bar, dependencies promotable) and which to **hold**.

### [GATE 3] Planned-set approval

Present the proposed planned set (one-line summary each + dependency order) and any held-back tasks with the reason. **Wait for the user to approve the planned set before implementation.** Once approved, promote each approved task with `.agents/scripts/move-issue.sh <file> planned` (set its `**Status:**` to `planned`) and run `.agents/scripts/update-issues-list.sh`. The held tasks stay in `backlog/`.

## Phase 4: Implement (per task, in dependency order)

Work the approved tasks in `.sdlc/issues/planned/`, in dependency order. For each:

1. Move it `planned → in-progress` (`.agents/scripts/move-issue.sh <file> in-progress`, set `**Status:** in-progress`) before starting.
2. Implement the code and tests exactly as the task specifies. On Claude Code, the accelerator delegates this to a small model; on a plain harness, implement it directly per the SWE role's execution discipline (`/start-task`).
3. **Verify**: run the task's tests and check each acceptance criterion. A task is not done until its tests pass and its criteria are met.
4. On pass, move it `in-progress → done` (`move-issue.sh <file> done`, set `**Status:** done`). If verification fails, retry; if it still fails after a reasonable attempt (or the task turns out under-specified), leave it in `in-progress/`, escalate — fix the task spec or hand it to a fuller `/start-task` session — and note it.
5. Record progress so a resumed run knows what's already built.

## Phase 5: Review / close-out (automatic gates)

Run the review gates over the milestone's implemented work. On Claude Code these run in parallel; otherwise in order:

- **QA** → `qa-review` (code vs. intent and test plan)
- **System Architect** → `sa-review` (conformance to architecture)
- **Security** → `sec-review` (controls enforced; vuln/authz/secrets/deps)
- **UX** → `ux-review` (`UX-NNN` conformance; flow completeness; accessibility; consistency; CLI ergonomics)
- **QA** → `qa-regression` (acceptance criteria still pass across the milestone)

Collect all findings. **Must-fix** findings loop back to Phase 4 (implement the fix, re-verify). Other findings become backlog issues via the skills' own issue-filing steps.

### [GATE 4] Go / no-go

Present the review verdict: criteria met, open must-fix issues (if any), security posture, regression result. **Wait for the user's go/no-go.** Do not declare the milestone done while a must-fix issue is open.

## Phase 6: Wrap-up

Once the user gives the go:

1. Run `pm-postmortem` for the milestone (honest assessment, lessons, plan adjustments). On Claude Code this is the accelerator's `postmortem` phase, which drafts the assessment and the doc updates for you to review; on a plain harness, run the `pm-postmortem` skill directly.
2. Update `docs/roadmap.md` (mark the milestone complete) and `docs/project-brief.md` status.
3. Move completed issues to `.sdlc/issues/done/` (`move-issue.sh`) and regenerate the list (`update-issues-list.sh`).
4. Write handoff notes for the experts that did substantive work, via their `*-handoff` skills.

Report what was built, what's deferred to the backlog, and what the next milestone needs to know.

## Principles

- **Gated, not autonomous.** The orchestration moves fast between gates but never past one without the user. The plan, foundations, planned-set, and go/no-go gates each end in an explicit human decision.
- **Reuse, don't reinvent.** Every phase is an existing skill. This runbook sequences them and carries their outputs forward; it doesn't re-implement their logic.
- **Documents are memory.** All state lands in `docs/` and `.sdlc/` so a resumed or parallel run — and the next session — can pick up without this conversation.
