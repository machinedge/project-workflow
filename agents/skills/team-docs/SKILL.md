---
name: team-docs
description: "Produce a complete, verified set of documentation end-to-end: plan the guides, author them, review them across accuracy / not-overstated / readability-per-audience / completeness lenses, then revise to apply the must-fix findings. Use when the user wants the full documentation lifecycle run for the whole project (or a milestone or topic), not a single doc skill."
---

Run documentation through its full lifecycle: plan → author → review → revise. This is a **cross-perspective** skill — no single expert role is loaded; it orchestrates the documentation skills and a multi-lens review, pausing at each **[GATE]** for human approval. The result is documentation that is accurate (matches what shipped), not overstated (no claims the code can't back), complete (every planned guide delivered), and easy to digest by each audience.

The user names the scope to document: $ARGUMENTS (defaults to the whole project; may instead be a milestone id or a single topic/guide).

> **Claude Code:** a multi-agent accelerator exists at `.claude/workflows/documentation.js` that runs the authoring and the review fan-outs in parallel. Prefer it when available. Invoke the Workflow tool **once per phase**, passing the scope and phase as `args` — either the object form `args: { scope: 'project', phase: 'plan' }` or the string form `"project plan"` (the named scope is `$ARGUMENTS`). The phases are `plan → author → review → revise`; the human gate for each runs in the conversation between invocations. The `author` and `review` phases also take `args.guides` (the guide set approved at the plan gate — carry each guide's audiences so readability runs per audience); the `revise` phase takes `args.guides = [{ path, findings }]` (the guides with their must-fix findings approved at the review gate). This runbook is the portable, harness-neutral equivalent — and the spec that accelerator implements. On harnesses without the Workflow tool, follow the steps below sequentially.

## Step 0: Resolve the scope

Read `docs/project-brief.md` and, if it exists, `docs/documentation-plan.md`. Determine what to document:
- **project** (default) — the whole codebase: how to deploy, maintain, and use it.
- a **milestone id** (e.g. `M18`) — the docs for that milestone's changes.
- a **topic / guide** (e.g. "deployment guide") — a single guide.

Restate the scope and the likely audiences (end user / developer / maintainer / operator) in your own words. State the plan: "I'll plan the guides first, then author them, then review each across accuracy, not-overstated, readability-per-audience, and completeness, then revise to fix the must-fix findings. I'll pause for your approval at the plan gate, the author gate, and the review gate." Wait for the user to start.

**Write for the unfamiliar reader.** Every guide must be followable by someone who did not build the project. Follow the **Writing clearly** conventions in `AGENTS.md`.

## Phase 1: Plan (audiences + guide inventory)

Run `doc-plan` scoped to the resolved scope. It reads the brief, the expert specs (`docs/architecture.md`, `docs/ux-guidelines.md`, `docs/env-context.md`, `docs/release-plan.md` — whichever exist), and the shipped code, then produces or extends `docs/documentation-plan.md` with the audiences, the guide inventory under `docs/guides/`, and verifiable `DOC-NNN` requirements.

### [GATE 1] Guide inventory approval

Present the audiences and the proposed guide inventory (each guide with its path, audience, and what it covers). **Wait for approval before authoring.** Trim or add guides here, where it is cheap. The approved guide list becomes `args.guides` for the author phase.

## Phase 2: Author (write each guide)

For each approved guide, run `doc-author`: write or update `docs/guides/<name>.md` from the `DOC-NNN` requirements, the expert specs, and the **actual shipped code** — exact commands, paths, and example values, never assumptions. Each guide must be self-verified by walking its steps. On Claude Code these run in parallel (distinct files); otherwise run them in order.

### [GATE 2] Drafts review

Present the drafted guides. **Wait for the user to skim them before the review fan-out.** The authored guide list (with each guide's audiences) becomes `args.guides` for the review phase.

## Phase 3: Review (multi-lens, per guide)

Review every guide through each lens. Follow `doc-review` for HOW to evaluate; apply one lens per check. On Claude Code these run in parallel (guides × lenses); otherwise in order:

- **Accuracy** — every command, path, config key, and behavior matches the real shipped code, not the plan. Flag anything wrong, stale, or unverifiable.
- **Not overstated** — flag any capability, guarantee, maturity, or performance/security claim the code does not back up. Nothing aspirational stated as if it already works.
- **Completeness** — every `DOC-NNN` requirement for the guide is delivered; no missing prerequisite or step.
- **Readability per audience** — a separate pass per audience the guide serves (end user / developer / maintainer / operator). Read as that persona with no insider knowledge: is every step followable and the whole thing digestible from that seat?

Collect all findings, grouped by guide and severity (must-fix / should-fix / observation). Do not file issues yet.

### [GATE 3] Findings review

Present findings grouped by guide, most severe first. **Must-fix findings block the docs.** Approve the revise set: the guides plus the findings to apply now (all must-fix, plus any should-fix worth fixing). This becomes `args.guides = [{ path, findings }]` for the revise phase.

## Phase 4: Revise (apply findings + file the rest)

For each guide carrying findings, run `doc-author` in fix mode: apply the approved findings and re-walk every changed step to confirm it works. Do not introduce new claims the code can't back up. Then file any remaining should-fix / observation findings as `doc-` issues in `.sdlc/issues/backlog/` (one at a time via `.agents/scripts/next-issue-number.sh`, then `.agents/scripts/update-issues-list.sh`).

### [Wrap-up] Close out

Confirm the must-fix findings are resolved. The guides in `docs/guides/` are the deliverable. Produce a `doc-handoff` note if this was a working session.
