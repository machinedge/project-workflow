---
name: doc-author
description: "Write or update a guide in docs/guides/ from the expert specs and what actually shipped, then verify it by walking every step as the target reader. Use during task execution when a planned doc- issue calls for authoring or updating documentation."
---

Write or update a guide so that a reader unfamiliar with the project can follow it. Produces or updates a file under `docs/guides/`.

This is a task-execution skill: it is normally reached through `/start-task` on a planned `doc-` issue. The user may specify which guide: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. The task issue (in `.sdlc/issues/in-progress/` once `/start-task` has moved it) — the acceptance criteria and the `DOC-NNN` requirements this guide must satisfy
2. `docs/documentation-plan.md` — the guide's audience and requirements
3. The upstream specs the guide draws on — `docs/architecture.md`, `docs/ux-guidelines.md`, `docs/env-context.md`, `docs/release-plan.md`, `docs/security-requirements.md` (whichever apply)
4. The relevant `.sdlc/handoff-notes/swe/` and `.sdlc/handoff-notes/devops/` — what actually shipped
5. The code, config, and commands the guide describes — read them directly so the guide matches reality

If `docs/documentation-plan.md` doesn't exist, tell the user: "No documentation plan exists yet. Ask for the `doc-plan` skill first so this guide has defined audience and requirements," then proceed best-effort from the brief and the issue if the user wants.

## Step 2: Confirm the Reader and Their Starting Point

State plainly before writing:
- "Guide: [path]"
- "Reader: [end user / operator / maintainer], who knows [starting assumptions] and wants to [goal]"
- "Starting point: [a clean machine / an installed project / a running service]"

The reader did not build this. Assume no insider knowledge beyond the stated starting point.

## Step 3: Draft the Guide

Write `docs/guides/<name>.md`. Follow the **Writing clearly** conventions in `AGENTS.md`, and structure it for a reader following along:

```markdown
# [Guide Title]

[One sentence: what this guide gets you to, and who it's for.]

## Prerequisites
[Exactly what must be in place first — versions, accounts, tools, prior guides — with how to check each.]

## Steps
1. [One action per step. Show the exact command, file path, and any value to set — with a real example value.]
   [Show the expected output or how to confirm the step worked.]
2. ...

## Troubleshooting
[The likely failure at each step, how to recognize it, and how to fix it.]
```

Rules while drafting:
- Show exact commands, paths, env vars, and real example values. No "configure appropriately", no "etc.", no hand-waving.
- Document what shipped, not what was planned. If the code and a spec disagree, document the code and flag the discrepancy.
- Keep it proportionate to the surface. Don't pad an internal script into a manual.

## Step 4: Verify by Walking It

A guide is done only when you have followed it yourself:
- Run every command and follow every step exactly as written, from the stated starting point (a clean state where feasible).
- A step that fails, a missing prerequisite, a command that doesn't work, or anything that silently assumes insider knowledge is a defect — fix the guide and walk it again.
- Confirm each `DOC-NNN` requirement and each acceptance criterion in the issue is met, with the walkthrough as evidence.

If you cannot fully verify a step (no environment, external dependency), say so explicitly in the guide and in your summary — do not imply it was tested.

## Step 5: Report

Summarize for the user: which guide was written or updated, which `DOC-NNN` requirements it satisfies, what you verified by walking it, and any step you could not verify. List anything out of scope you noticed but did not fix.

Hand off via `doc-handoff` when wrapping up.
