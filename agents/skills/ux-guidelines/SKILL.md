---
name: ux-guidelines
description: "Produce the UX guidelines spec for a milestone — target users, key flows, and verifiable UX requirements (UX-NNN) covering interaction, accessibility, content/error clarity, and CLI ergonomics. Use at milestone kickoff before implementation begins."
---

Produce the UX guidelines spec for a milestone. Produces or extends `.sdlc/ux-guidelines.md`.

The user may specify a milestone or scope: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. `docs/project-brief.md` — who the project is for, their goals, constraints, the kind of surface (GUI, web, CLI, API)
2. `.sdlc/architecture.md` (when present) — which components present a surface to a user
3. `docs/roadmap.md` (when present) — the milestone being scoped
4. `.sdlc/interview-notes*.md` (if any exist — raw requirements context)
5. `.sdlc/ux-guidelines.md` (when present — you may be extending, not starting fresh)

If `.sdlc/architecture.md` doesn't exist, you can still proceed from the brief, but tell the user: "No architecture document exists yet — surfaces will be inferred from the brief. Ask for the `sa-design` skill if you want component boundaries pinned down first."

**If the milestone has no user-facing surface** (pure backend, infra, internal plumbing — nothing a human or operator interacts with directly), say so plainly, record a one-line note in `.sdlc/ux-guidelines.md` under a "Scope" entry ("M-NN: no user-facing surface — no UX requirements"), and stop. Do not invent UI.

Confirm your understanding:
- "Milestone: [name / scope]"
- "User-facing surface this milestone touches: [screens / pages / CLI commands / output / errors]"
- "Who uses it and what they're trying to do: [from the brief]"

Wait for user confirmation before proceeding.

## Step 2: Identify Users and Goals

- Who are the users/personas for this milestone's surface? (end user, operator, developer, admin)
- What is each one trying to accomplish? (the job to be done)
- What does success and failure look like from their seat?

Keep it concrete and scoped to this milestone. Don't model the whole product.

## Step 3: Map the Key Flows

For each goal, walk the path the user takes — including the unhappy paths:

- The steps from start to done (entry point → action → feedback → result).
- The states along the way: loading, empty, error, partial, success.
- For a CLI: the invocation, the flags, the output format, the error and help text.

Note where the path forks, stalls, or could surprise the user.

## Step 4: Derive UX Requirements

Turn each flow and risk into one or more **verifiable controls**. A requirement names what is enforced, where, and how it can be checked. Cover the areas that apply:

- **Navigation / information architecture** — how the user moves through and finds things.
- **Interaction patterns & consistency** — controls behave the same way across the surface; conventions are respected.
- **Feedback & states** — loading, empty, error, and success states are explicit, not blank.
- **Accessibility** — WCAG-checkable: keyboard reachability, focus order, labels/alt text, contrast, no color-only signals.
- **Content & error clarity** — labels and messages are plain, specific, and tell the user what to do next.
- **CLI / output ergonomics** — sensible defaults, discoverable help, confirmation on destructive actions, machine-readable output where useful, clear exit codes.

Each requirement must be phrased so QA can write a test and `ux-review` can check it. Bad: "make errors helpful." Good: "on invalid input the CLI prints the offending argument, the expected format, and exits non-zero."

## Step 5: Draft `.sdlc/ux-guidelines.md`

Create or extend the document using this structure:

```markdown
# UX Guidelines

## Scope
[Which milestone(s) this covers. Updated additively as milestones are scoped. Note any milestone with no user-facing surface here.]

## Users and Goals
[Personas and the job each is trying to do, scoped to the surface in play.]

## Key Flows
[The main flows and their states — happy path plus empty/error/loading. CLI invocations and output where relevant.]

## UX Requirements
| ID | Requirement (verifiable control) | Area | Heuristic | How to Verify |
|----|----------------------------------|------|-----------|---------------|
| UX-001 | [what is enforced, where] | [nav/interaction/a11y/content/CLI] | [Nielsen # / WCAG ref] | [test or check] |

## Accessibility Bar
[The WCAG level and the specific checks that apply to this surface.]

## Content & CLI Standards
[Voice/tone for messages, error-message format, help/usage conventions, confirmation/exit-code rules.]
```

Scale detail to the project's real surface. A developer CLI gets ergonomics, help, and clear errors; a consumer UI gets full flow and accessibility rigor.

## Step 6: Review with User

Present the draft. Walk through the key flows and the requirements that protect them. Wait for approval before saving.

Save `.sdlc/ux-guidelines.md` only after the user approves.

These requirements become inputs to `pm-decompose` (so tasks carry their UX constraints inline) and the checklist for the `ux-review` close-out gate. Note that linkage in your closing summary.
