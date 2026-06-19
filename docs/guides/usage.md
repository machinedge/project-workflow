# Using the Expert Team Day to Day

This guide shows a developer how to drive the toolkit's eight experts through a real piece of work — from the first interview to a finished, handed-off task — and how to tell the two ways you reach them (commands and skills) apart.

It assumes the toolkit is already installed in your project. If it is not, follow `docs/guides/getting-started.md` first, then come back here.

## Prerequisites

- The toolkit is installed in your project. You can confirm this by checking that these exist at your project root: a file named `AGENTS.md`, a directory `.agents/`, and a directory `.sdlc/`. If any is missing, run the installer (see `docs/guides/getting-started.md`).
- You are working inside an AI harness (the coding tool that runs the AI and reads `AGENTS.md`) — Claude Code or Codex. The walkthrough below shows Claude Code, where commands appear in the `/` menu. On Codex and other harnesses the same workflows exist, but you reach them by asking in plain language instead of typing a slash command.
- No server, port, or login is involved. Everything runs as a conversation with the AI plus files written under `docs/` and `.sdlc/` in your project.

## The eight experts and their prefixes

The toolkit gives you eight specialists. Each one is a "role" the AI adopts for a session. You rarely name an expert directly — you invoke a command or skill whose **prefix** selects the expert for you. The prefixes are the two- to three-letter tags below.

| Expert | Prefix | What it does, in one sentence |
|--------|--------|-------------------------------|
| Project Manager | `pm` | Interviews you, scopes the work, writes the brief and roadmap, breaks milestones into task issues, and runs postmortems. |
| Software Engineer | `swe` | Implements a task from its issue file, test-first, and writes a handoff note when done. |
| QA Engineer | `qa` | Reviews code, writes test plans, runs regressions, and triages bugs. |
| DevOps Engineer | `ops` | Captures the build/test/deploy environment, defines pipelines, plans releases, and runs deployments. |
| System Architect | `sa` | Makes system-level design decisions and checks that what was built matches the intended architecture. |
| Security Engineer | `sec` | Defines the threat model and security requirements, and reviews the code against them. |
| UX Designer | `ux` | Defines the UX guidelines (flows, accessibility, content, CLI ergonomics) and reviews the result for usability. |
| Technical Writer | `doc` | Plans the documentation, writes the guides for people who did not build the project, and reviews docs against what shipped. |

Two notes on the prefixes:

- DevOps is the one place where the expert prefix (`ops`) and the issue-file prefix differ: DevOps **issue files** are named `devops-...`, not `ops-...`. You will see this when you read an issue, not when you invoke a command.
- A ninth, shared prefix `team` is not an expert. It covers cross-expert workflows that run several experts in sequence — covered in "The two cross-expert workflows" below.

## Commands versus skills

There are two kinds of things you can invoke, and the difference matters because it changes how you reach them.

- A **command** is something *you* invoke explicitly by name. In Claude Code you type `/name`. Commands are used for work that needs a real back-and-forth with you, or that loads a lot of context and pauses at approval gates (points where the work stops and waits for your go-ahead before continuing). There are exactly **six** commands.
- A **skill** is something the *agent* invokes for you. You describe what you want in plain language ("write the project brief", "review this code"), and the agent matches your intent to a skill's description and runs it. There are 33 skills. Under Claude Code they also appear in the `/` menu (via a `.claude/skills` symlink), so you *can* type them — but you are not expected to memorize them. The point of a skill is that you ask for the outcome, not the tool.

The six commands, by name:

| Command | Expert it loads | Why it is a command (not a skill) |
|---------|-----------------|-----------------------------------|
| `/start-task` | inferred from the task issue's `**Expert:**` field | Begins an execution session on a planned task — heavy context loading plus approval gates. |
| `/resume-task` | inferred from the task issue's `**Expert:**` field | Continues a task that is already in progress — same heavy context loading. |
| `/pm-interview` | Project Manager (`pm`) | Needs back-and-forth: it asks you questions about the project. |
| `/pm-add-feature` | Project Manager (`pm`) | Needs back-and-forth: it interviews you to scope a new feature into existing plans. |
| `/ops-deploy` | DevOps (`ops`) | Needs back-and-forth: it walks a real release with verification. |
| `/ops-env-discovery` | DevOps (`ops`) | Needs back-and-forth: it interviews you to capture the deployment and test environment. |

Everything else — writing the brief, building the roadmap, decomposing a milestone, reviewing code, planning tests, writing guides, ending a session with a handoff note — is a **skill**. You ask for it; the agent finds it.

`/start-task` and `/resume-task` carry no expert prefix on purpose. They are role-agnostic: they read the chosen issue file, look at its `**Expert:**` field, and load that expert's role for the session. So the same `/start-task` command runs as the SWE on a `swe-` issue and as the Technical Writer on a `doc-` issue.

## One end-to-end walkthrough

Here is the full path for a brand-new project, in order, with the artifact each step writes. Run these in a single project over several sessions. Steps 1 and 2 (`/pm-interview`) are the only ones with a slash command; the rest are skills you ask for in plain language.

1. **Interview.** Run `/pm-interview`. The Project Manager asks you about the project (it offers an abbreviated or extended interview first). It saves the interview summary to `.sdlc/interview-notes.md`, then tells you to ask for the brief next.

2. **Brief.** Ask for the project brief (the `pm-vision` skill). The PM reads `.sdlc/interview-notes.md` and writes the source-of-truth document, `docs/project-brief.md`. It also creates an empty `.sdlc/lessons-log.md` if one does not exist.

3. **Roadmap.** Ask for the roadmap (the `pm-roadmap` skill). The PM reads `docs/project-brief.md` and writes the milestone plan to `docs/roadmap.md` (5–8 milestones with dependencies and risks).

4. **Decompose.** Ask the PM to decompose a milestone (the `pm-decompose` skill). It breaks one roadmap milestone into session-sized task issues — one markdown file per task — under `.sdlc/issues/backlog/`. Each file is named `[expert]-[type]-[NNN].md`, for example `.sdlc/issues/backlog/swe-feature-001.md`. The `[expert]` part is the expert who will *do* the task.

5. **Promote (a deliberate decision).** The decompose step lands tasks in `backlog/`. Before anyone can execute them, the approved ones must move to `planned/`. There is no dedicated promotion command or skill — you ask the PM in plain language to promote the task(s) you want built (for example, "promote `swe-feature-001` to planned"), and the PM does the move with the helper script `.agents/scripts/move-issue.sh`. This is a separate, on-purpose decision — see "The issue lifecycle" below for why.

6. **Execute.** Run `/start-task`. It pulls one task from `.sdlc/issues/planned/`, moves it to `.sdlc/issues/in-progress/`, stamps the issue's `**Status:**` and `**Session:**` fields, loads the expert named in the issue's `**Expert:**` field, and implements the work. For a `swe-` task this produces code and tests; for a `doc-` task it produces a guide under `docs/guides/`.

7. **Review (optional, when work is worth a second pair of eyes).** Ask QA to review the implementation (the `qa-review` skill), or ask the relevant lens — architecture (`sa-review`), security (`sec-review`), UX (`ux-review`), or docs (`doc-review`). A review that finds problems files them as new issue files in `.sdlc/issues/backlog/`.

8. **Handoff.** When you are wrapping up, ask for the handoff (the active expert's `*-handoff` skill — for example `swe-handoff` after a SWE session). It writes the session note to `.sdlc/handoff-notes/<expert>/session-NN.md` (for example `.sdlc/handoff-notes/swe/session-22.md`) and, once the task's acceptance criteria are met, moves the issue `in-progress → done` and sets its `**Status:** done`.

After that, the next session has no memory of this one except what these files hold. That is by design: the documents *are* the memory.

## The issue lifecycle

Every task issue lives in exactly one of four directories under `.sdlc/issues/`, and moving between them is how the toolkit tracks work. The directory and the issue's `**Status:**` field always agree.

| Bucket | Meaning | How a task gets here |
|--------|---------|----------------------|
| `backlog/` | Decomposed, but not yet committed to. | `pm-decompose` creates it; any expert may add an issue here (for example, a review that found a bug). |
| `planned/` | Approved for execution. | The PM promotes it from `backlog/` — a deliberate decision, or the `team-milestone` planned-set gate. |
| `in-progress/` | Actively being worked right now. | `/start-task` moves it here when it claims the task. |
| `done/` | Acceptance criteria met, finished. | The expert's `*-handoff` skill moves it here. |

The promotion from `backlog/` to `planned/` is the one step that is never automatic. It is the deliberate "yes, build this" decision, made by the PM or at the milestone workflow's planned-set gate (the pause inside `team-milestone` where the workflow stops and asks you to confirm which tasks to promote before it builds them). This is why `start-task` cannot pull a task straight out of `backlog/`.

Which command reads which bucket:

- `/start-task` pulls **only** from `planned/`. If you name a task that is still in `backlog/`, it tells you where the task actually is and stops — it will not promote the task for you. If `planned/` is empty, it tells you to promote work first.
- `/resume-task` picks up **only** from `in-progress/`. Use it to continue a task that an earlier `/start-task` session already claimed.

Only the PM moves issues between directories. The mechanical move is done by a helper script, `.agents/scripts/move-issue.sh`, which the commands and skills call for you — you do not normally run it by hand.

## The two cross-expert workflows

Two `team-` workflows run a whole lifecycle end to end instead of one expert at a time. No single expert role is loaded; the workflow orchestrates several experts' skills in sequence and pauses at human approval gates between phases.

You reach both the same way you reach any skill: ask for them in plain language ("run the full milestone lifecycle for M1", "document the whole project"). They are skills, not commands.

**`team-milestone` — compile and build one roadmap milestone.** It chains six phases, each with a human gate where noted: plan (decompose the milestone) → enrich (System Architect, Security, UX, Technical Writer, QA, and DevOps each draft their foundation artifact, scoped to the milestone) → compile (densify the tasks to implementation-ready and propose which to promote `backlog → planned`) → implement (work each approved `planned/` task through `in-progress → done`) → review (the close-out QA, architecture, security, UX, and docs gates) → postmortem (the honest milestone wrap-up).

**`team-docs` — produce a complete, verified documentation set.** It chains four phases: plan (the documentation plan and guide inventory) → author (write each guide from the actual shipped code) → review (check every guide across four lenses — accuracy versus the code, not-overstated, readability per audience, and completeness versus the plan) → revise (apply the must-fix findings). It defaults to the whole project but can be scoped to one milestone or one topic.

Under Claude Code, each workflow has a faster **accelerator script** (a script that runs the same lifecycle but speeds up the steps that can happen at the same time) that runs the parallelizable parts — the enrichment and review fan-outs, meaning the points where several experts work in parallel — as separate helper agents (subagents) instead of one at a time. The accelerators are discovered by the Workflow tool (the Claude Code feature that finds and runs these scripts) under the name in each script:

| Workflow | On-disk script (in `.agents/workflows/`) | Name you invoke |
|----------|------------------------------------------|-----------------|
| `team-milestone` | `implement.js` | `implement` |
| `team-docs` | `document.js` | `document` |

On harnesses without the Workflow tool (Codex and others), the same lifecycles run, just sequentially — you follow the portable runbook (the step-by-step instructions written into the skill file) in `.agents/skills/team-milestone/SKILL.md` or `.agents/skills/team-docs/SKILL.md`, one phase at a time.

Day to day you do not need any of these filenames: ask for the workflow in plain language, or invoke `implement` or `document` by name. (Maintainer footnote: some prose elsewhere in the repo still calls these accelerators by their old names, `milestone.js` and `documentation.js`; the files that actually ship are `implement.js` and `document.js`.)

## Migrating an existing project to use the new .sdlc/ layout

If you have an existing project with specs in `docs/` (such as `docs/architecture.md`, `docs/test-plan.md`, `docs/security-requirements.md`, and spec subfolders like `docs/research/`), and you want to adopt the new `.sdlc/` layout, run the migration workflow:

**On bash/macOS/Linux:**
```bash
.agents/scripts/migrate-sdlc.sh
```

**On PowerShell/Windows:**
```powershell
.\.agents\scripts\migrate-sdlc.ps1
```

The workflow relocates your canonical spec files from `docs/` into `.sdlc/` — including files like `architecture.md`, `pipeline.md`, `components.md`, `documentation-plan.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `task-detail-standard.md`, `env-context.md`, and `release-plan.md`, plus any draft versions (e.g., `architecture.m19-draft.md`) and the spec subfolders (`research/`, `security/`, `runbooks/`).

User-facing files stay in `docs/` — your `docs/guides/`, `README.md`, `project-brief.md`, `roadmap.md`, and any files you created are left untouched.

The workflow is **idempotent**: you can run it multiple times safely. A second run finds nothing to move and exits cleanly. It is also **collision-safe**: if a spec already exists at the `.sdlc/` destination, the workflow reports the collision by name and leaves both files in place so you can resolve it manually — it will never silently overwrite or discard your work.

## Troubleshooting

- **`/start-task` says no tasks are eligible.** The `planned/` bucket is empty. Promote work from `backlog/` to `planned/` first — that is a PM decision (or the `team-milestone` planned-set gate). `/start-task` will not pull from `backlog/`.
- **`/start-task` says the task you named is somewhere else.** The task is still in `backlog/` (not yet promoted) or already in `in-progress/`. For an in-progress task use `/resume-task` instead; for a backlog task, get it promoted to `planned/` first.
- **A skill you expected to run did not.** Skills are matched by intent, not name. Describe the outcome you want more concretely ("generate the project brief from the interview notes"), or, under Claude Code, type the skill from the `/` menu directly.
- **A command does not appear in the `/` menu.** Slash-command discovery requires the Claude wiring, which is skipped when the toolkit is installed with `--no-claude`. On a `--no-claude` (Codex) install, ask for the workflow in plain language instead.
- **The Workflow tool cannot find `implement` or `document`.** You are on a harness without the Workflow tool, or the `.claude/workflows` symlink was not installed. Fall back to the sequential runbook in the workflow's `SKILL.md` under `.agents/skills/`.
- **The migration script says "COLLISION"**. A spec file already exists at both `docs/` and `.sdlc/` locations. The workflow leaves both in place. Inspect the files to see which one is newer or more complete, delete or merge them as needed, then re-run the migration script.
