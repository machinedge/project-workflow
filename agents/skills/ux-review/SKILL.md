---
name: ux-review
description: "Review implementation against the UX guidelines and usability/accessibility heuristics, and produce findings. Use at milestone close-out, or when the user wants to check whether built output is usable, accessible, and consistent — flows, states, content clarity, and CLI ergonomics."
---

Review implementation against the UX guidelines. Produce findings.

The user may specify what to review: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. `docs/ux-guidelines.md` — the requirements to evaluate against (your checklist)
2. `docs/project-brief.md` — who the users are, constraints, the kind of surface
3. `docs/architecture.md` (if it exists) — which components present a surface
4. Recent SWE handoff notes in `.sdlc/handoff-notes/swe/` — what was built and changed

If `docs/ux-guidelines.md` doesn't exist, tell the user: "No UX guidelines exist yet. Ask for the `ux-guidelines` skill first to establish the bar, or this review will have no baseline to evaluate against." You may still do a best-effort review from standard heuristics (Nielsen, WCAG), but say so.

If the milestone has no user-facing surface, say so and stop — there is nothing to review.

If the user specified what to review (a component, a flow, a session's work), focus there. Otherwise review the milestone's changes broadly.

## Step 2: Identify Review Scope

State what you're reviewing:
- "Reviewing: [surfaces / flows / recent changes]"
- "Against: [UX requirements UX-NNN … / standard heuristics if no spec]"
- "Focus areas: [where the friction concentrates]"

## Step 3: Evaluate

For each requirement and each flow in scope, walk the user's path and check:

- **Flow completeness:** Can the user actually get from start to goal? Are the entry point, the action, and the result all present?
- **States:** Are loading, empty, and error states explicit and helpful — not blank screens or silent failures?
- **Interaction & consistency:** Do controls behave consistently and follow convention? No surprising or hidden behavior?
- **Accessibility:** Keyboard reachable, focus order sane, labels/alt present, sufficient contrast, no color-only signals (WCAG).
- **Content & errors:** Are labels and messages plain and specific? Does each error tell the user what went wrong and what to do next?
- **CLI / output ergonomics:** Discoverable help, sensible defaults, confirmation on destructive actions, clear exit codes and output.

For each requirement, record: satisfied / violated / not-applicable, with concrete evidence (file:line, the screen/flow, or the exact message/output).

## Step 4: Produce Findings

Write this for a human scanning a terminal — follow the **Writing clearly** conventions in `AGENTS.md` (lead with the verdict, expand IDs/jargon on first mention, real bullet lists, short paragraphs). Stay critical.

Categorize findings:

- **Must-fix:** A broken or blocked flow, an accessibility violation, or usability that prevents the user from completing the goal.
- **Should-fix:** Friction, inconsistency, or unclear content that increases effort or confusion but doesn't block.
- **Observations:** Polish opportunities and things to watch.

For each finding:
- What is it? (and which `UX-NNN` it relates to, if any)
- Where is it? (file:line, component, flow, or the exact message)
- Why does it matter? (the concrete user impact)
- What's the recommendation?

## Step 5: File Issues

For must-fix and should-fix findings, create issue files in `.sdlc/issues/backlog/`. Run `.agents/scripts/next-issue-number.sh` for the next available number.

- Use the naming convention `[expert]-[type]-[number].md` with `swe-` as the executor (fixes are implemented by SWE) and `bug` or `techdebt` as the type — e.g. `swe-bug-082.md`.
- Reference the UX requirement (`UX-NNN`) being violated, and include the concrete evidence so the fix is unambiguous.

Run `.agents/scripts/update-issues-list.sh` after creating issues.

## Step 6: Report

Present findings to the user, most severe first. Give an overall verdict: does the milestone meet its UX requirements, or are there open must-fix issues that block release?

Do NOT auto-fix implementation. Fixes go through the SWE workflow so they get proper testing and verification. Your job is to find problems and state the bar, not to patch code.
