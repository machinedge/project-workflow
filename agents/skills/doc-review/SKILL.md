---
name: doc-review
description: "Review delivered documentation against the documentation plan and a fresh-reader walkthrough, and produce findings. Use at milestone close-out, or when the user wants to check whether the guides are accurate versus what shipped, complete, and followable by someone unfamiliar with the project."
---

Review delivered documentation against the documentation plan. Produce findings.

The user may specify what to review: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. `docs/documentation-plan.md` — the requirements to evaluate against (your checklist)
2. The guides in `docs/guides/` that are in scope
3. `docs/project-brief.md` — who the readers are, the kind of surface
4. The upstream specs and the shipped code the guides describe (`docs/architecture.md`, `docs/env-context.md`, `docs/release-plan.md`, and recent `.sdlc/handoff-notes/swe/` and `.sdlc/handoff-notes/devops/`) — so you can check the guides against reality

If `docs/documentation-plan.md` doesn't exist, tell the user: "No documentation plan exists yet. Ask for the `doc-plan` skill first to establish the bar, or this review will have no baseline." You may still do a best-effort review for accuracy and readability, but say so.

If the milestone changed nothing a user, operator, or maintainer interacts with, say so and stop — there is nothing to review.

If the user specified what to review (a guide, an audience), focus there. Otherwise review the milestone's guides broadly.

## Step 2: Identify Review Scope

State what you're reviewing:
- "Reviewing: [guides / audiences in scope]"
- "Against: [requirements DOC-NNN … / best-effort if no plan]"
- "Reader's seat: [end user / operator / maintainer]"

## Step 3: Evaluate

For each guide and each requirement in scope, read as the target reader and check:
- **Accuracy:** Does the guide match what shipped? Commands, paths, config keys, env vars, and behavior must reflect the real code — not the plan.
- **Not overstated:** Does the guide claim only what the code actually backs up? Flag any capability, guarantee, maturity, or performance/security claim that the shipped code does not support, and anything aspirational ("fully automated", a feature that isn't built yet) stated as if it already works.
- **Completeness:** Is every prerequisite, step, and required value present? No silent insider gaps?
- **Runnability:** Following the steps exactly from the stated starting point, can the reader reach the goal? Walk it where feasible; flag any step that fails or assumes unstated knowledge.
- **Readability:** Plain words before identifiers, exact specifics, short paragraphs, real lists — does it follow the **Writing clearly** conventions in `AGENTS.md`?

For each requirement, record: satisfied / violated / not-applicable, with concrete evidence (the guide path and line, the exact command that fails, or the missing prerequisite).

## Step 4: Produce Findings

Write this for a human scanning a terminal — follow the **Writing clearly** conventions in `AGENTS.md` (lead with the verdict, expand IDs/jargon on first mention, real bullet lists, short paragraphs). Stay critical.

Categorize findings:
- **Must-fix:** The guide is wrong (won't work as written), or a required step/prerequisite is missing so the reader cannot reach the goal.
- **Should-fix:** Friction, vagueness, or an insider assumption that increases effort or confusion but doesn't block.
- **Observations:** Polish opportunities and things to watch.

For each finding:
- What is it? (and which `DOC-NNN` it relates to, if any)
- Where is it? (guide path:line, or the exact command/step)
- Why does it matter? (the concrete reader impact)
- What's the recommendation?

## Step 5: File Issues

For must-fix and should-fix findings, create issue files in `.sdlc/issues/backlog/`. Run `.agents/scripts/next-issue-number.sh` for the next available number.

- Use the naming convention `[expert]-[type]-[number].md`. Documentation fixes you will write yourself use `doc-` as the executor (e.g. `doc-bug-014.md`); fixes that require code or behavior changes use `swe-`. Type is `bug` or `techdebt`.
- Reference the documentation requirement (`DOC-NNN`) being violated, and include the concrete evidence so the fix is unambiguous.

Run `.agents/scripts/update-issues-list.sh` after creating issues.

## Step 6: Report

Present findings to the user, most severe first. Give an overall verdict: do the guides meet their documentation requirements — could an unfamiliar reader actually deploy, maintain, or use the project from them — or are there open must-fix issues that block release?
