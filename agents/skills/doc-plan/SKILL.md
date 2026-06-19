---
name: doc-plan
description: "Produce the documentation plan for a milestone — the audiences (end user, operator, maintainer), the inventory of guides this milestone needs, and verifiable documentation requirements (DOC-NNN) covering accuracy, completeness, and readability for people unfamiliar with the project. Use at milestone kickoff before implementation begins."
---

Produce the documentation plan for a milestone. Produces or extends `.sdlc/documentation-plan.md`.

The user may specify a milestone or scope: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. `docs/project-brief.md` — who the project is for, their goals, constraints, the kind of surface (service, CLI, library, infra)
2. `docs/roadmap.md` (when present) — the milestone being scoped
3. `.sdlc/architecture.md` (when present) — the components and how they fit, for accessible design/overview docs
4. `.sdlc/ux-guidelines.md` (when present) — the user-facing surface and content standards
5. `.sdlc/env-context.md` and `.sdlc/release-plan.md` (if they exist) — deployment mechanisms and release procedure
6. `.sdlc/documentation-plan.md` (when present — you may be extending, not starting fresh)

**If this milestone changes nothing a user, operator, or maintainer interacts with** (pure internal refactor, plumbing with no new surface and no deploy/operate impact), say so plainly, record a one-line note in `.sdlc/documentation-plan.md` under a "Scope" entry ("M-NN: no user/operator-facing change — no new documentation"), and stop. Do not invent guides.

Confirm your understanding:
- "Milestone: [name / scope]"
- "What changes for a user, operator, or maintainer this milestone: [new commands / new deploy steps / new config / new behavior]"
- "Who reads about it and what they're trying to do: [from the brief]"

Wait for user confirmation before proceeding.

## Step 2: Identify Audiences and Goals

Name the audiences this milestone's documentation serves, and what each is trying to accomplish:
- **End user** — uses the running project. Goal: get their task done.
- **Operator** — deploys and runs it. Goal: stand it up and keep it healthy.
- **Maintainer** — picks up the code later. Goal: understand how it fits together and change it safely.

Keep it scoped to this milestone. Not every milestone serves every audience.

## Step 3: Inventory the Guides

Decide which guides this milestone needs created or updated, and where each lives under `docs/guides/`. Typical set (include only what applies):
- `docs/guides/getting-started.md` — first run, the shortest path to "it works"
- `docs/guides/deployment.md` — how an operator stands it up, end to end
- `docs/guides/maintenance.md` — how to operate, monitor, upgrade, and recover
- `docs/guides/usage.md` — how an end user accomplishes the main tasks
- An accessible design/overview doc when newcomers need the big picture (distinct from the decision-focused `.sdlc/architecture.md`)

For each guide, note its audience, whether it is new or an update, and the upstream specs it draws on.

## Step 4: Derive Documentation Requirements

Turn each guide into one or more **verifiable** requirements. A requirement names the guide, its audience, and a concrete check — phrased so `doc-review` can confirm it and a real reader could follow it. Cover the areas that apply:
- **Accuracy** — the guide matches what shipped (commands, paths, config, behavior).
- **Completeness** — every prerequisite, step, and required value is present; no insider gaps.
- **Runnability** — commands and steps work as written from a clean starting point.
- **Readability** — written for someone unfamiliar; plain words, exact specifics, follows the Writing clearly conventions.

Each requirement must be checkable. Bad: "deployment guide should be clear." Good: "DOC-003: the deployment guide lists every required environment variable with an example value, and a clean-machine walkthrough reaches a running service using only the guide."

## Step 5: Draft `.sdlc/documentation-plan.md`

Create or extend the document using this structure:

```markdown
# Documentation Plan

## Scope
[Which milestone(s) this covers. Updated additively. Note any milestone with no user/operator-facing change here.]

## Audiences
[End user / operator / maintainer in play this milestone, and the job each is trying to do.]

## Guide Inventory
| Guide (path) | Audience | New / Update | Draws on |
|--------------|----------|--------------|----------|
| docs/guides/deployment.md | operator | new | env-context.md, release-plan.md |

## Documentation Requirements
| ID | Requirement (verifiable) | Guide | Area | How to Verify |
|----|--------------------------|-------|------|---------------|
| DOC-001 | [what the guide must contain or achieve] | [path] | [accuracy/completeness/runnability/readability] | [check or walkthrough] |
```

Scale detail to the project's real surface. An internal script gets a short usage note; a deployable service gets full deployment and maintenance coverage.

## Step 6: Review with User

Present the draft. Walk through the audiences, the guide inventory, and the requirements that protect each guide. Wait for approval before saving.

Save `.sdlc/documentation-plan.md` only after the user approves.

These requirements become inputs to `pm-decompose` (so authoring tasks carry their `DOC-NNN` constraints inline) and the checklist for the `doc-review` close-out gate. Note that linkage in your closing summary.
