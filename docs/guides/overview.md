# Overview: What This Toolkit Is

MachinEdge Expert Teams is a toolkit you install into a software project so that an AI coding assistant works as a coordinated team of specialists — a project manager, an engineer, a reviewer, and others — instead of a single general-purpose chatbot. This page is the big-picture orientation for anyone who has never seen the project. You can read it in one pass, before any other document. When you want the decision-level detail behind a claim here, follow the link to the architecture document (`docs/architecture.md`).

## The one-paragraph version

You install the toolkit into your own project with a single command. It drops a set of plain-text Markdown files into that project: one operating-system file at the root (`AGENTS.md`) plus a payload folder (`.agents/`) of expert definitions, skills, and helper scripts. From then on, when you open the project in an AI assistant that reads `AGENTS.md` — Claude Code, Codex, or any harness that follows that convention — the assistant loads the right expert for the job and follows that expert's defined process. There is no server to run, no account to create, and no background process. The toolkit is just files that shape how the AI behaves.

A "harness" here means the AI coding tool you run the assistant inside — for example Claude Code or Codex. The toolkit does not replace it; it configures it.

## Documents are memory

This is the single idea that explains everything else, so it comes first.

The AI experts have **no memory between sessions**. When a session ends, everything the expert "knew" is gone. The toolkit works anyway because it never relies on the AI remembering. Instead, every decision, plan, and piece of work-in-progress is written to a file in the project. The next session — possibly a different expert, possibly days later — rebuilds its understanding by reading those files.

So the project's own documents *are* the memory. The project brief (`docs/project-brief.md`) is the source of truth for what the project is. Issue files track what work is planned and in flight. Handoff notes record where the last session left off. Nothing important lives only in a chat transcript, because a transcript cannot be read by the next session.

Two practical consequences follow:

- If you want the AI to know something, it has to end up in a file. Telling it once in conversation is not enough.
- You can read the same files yourself. The project's state is plain Markdown you can open in any editor, not hidden inside a tool.

## The eight experts

The toolkit ships eight expert roles. Each has a short prefix used to name its commands and skills (for example, the Project Manager's prefix is `pm`, so its interview command is `/pm-interview`). One expert is active per session.

| Expert | Prefix | What it does |
|--------|--------|--------------|
| Project Manager | `pm` | Interviews you, scopes the work, builds the roadmap, breaks milestones into tasks, runs postmortems |
| Software Engineer | `swe` | Implements tasks from issue files, test-first, and writes a handoff at the end |
| QA Engineer | `qa` | Reviews code, writes test plans, runs regressions, triages bugs |
| DevOps Engineer | `ops` | Captures the environment, defines pipelines, plans releases, runs deployments |
| System Architect | `sa` | Designs the architecture, researches technical questions, checks code against intent |
| Security Engineer | `sec` | Writes the threat model and security requirements, reviews code for vulnerabilities |
| UX Designer | `ux` | Defines UX guidelines, reviews for usability and accessibility |
| Technical Writer | `doc` | Plans documentation, writes the guides in `docs/guides/`, reviews docs against what shipped |

The assistant figures out which expert to load from the command or skill prefix you use. A ninth prefix, `team`, is not an expert — it marks cross-expert workflows that run without adopting any single expert's persona. Two of them are full lifecycle workflows described below; a third, `team-status`, summarizes project health across all experts and has no accelerator script.

## How you drive it: commands and skills

The toolkit gives the AI two kinds of capabilities.

- **Commands** are things *you* invoke explicitly by typing `/name`. There are **6** of them, reserved for interactive or approval-gated work: `/start-task` and `/resume-task` (begin or continue a work session), plus `/pm-interview`, `/pm-add-feature`, `/ops-env-discovery`, and `/ops-deploy`.
- **Skills** are capabilities the *assistant* selects on its own when it recognizes the right moment — for example, it runs the handoff skill when you signal you are wrapping up. There are **33** of them. Each skill is a folder under `.agents/skills/` containing a `SKILL.md` file whose description tells the assistant when to use it. You can still trigger a skill explicitly by name if you want.

The difference matters because it tells you what you control directly (commands) versus what the assistant offers proactively (skills).

## The two workflow accelerators

Most of the time you drive one expert at a time. For larger pieces of work, the toolkit bundles two cross-expert **workflows** that chain many experts together end to end, pausing at human approval gates so you stay in control:

- **`team-milestone`** runs one roadmap milestone through its whole lifecycle — plan, enrich (architecture, security, UX, QA, DevOps lenses), compile tasks, implement, and review.
- **`team-docs`** runs the whole documentation lifecycle — plan the guides, author them, review them across several quality lenses, then revise.

A third `team-` skill, **`team-status`**, summarizes project health across all experts. It is a one-shot summary rather than a full lifecycle workflow, so it has no accelerator script.

Each workflow works as a portable runbook in any `AGENTS.md` harness, run step by step. Under Claude Code specifically, each also has a faster accelerator: a script that runs the independent steps as parallel sub-agents. The two accelerator scripts live in `.agents/workflows/` and are named **`implement.js`** (the `team-milestone` accelerator) and **`document.js`** (the `team-docs` accelerator).

> Note: if you see these scripts called `milestone.js` or `documentation.js` in the README or several other documents around the repo, those are older names for the same two scripts. The files on disk are `implement.js` and `document.js` — the real, current names. This guide was checked against the files on disk, so where the two disagree, this guide is the one to trust; the older docs are pending a rename.

## Where state lives: `docs/` versus `.sdlc/`

Because documents are memory, it matters where each document lives. The toolkit splits project state into two top-level folders.

- **`docs/`** holds the documents meant for humans to read and edit — the durable planning artifacts. The project brief (`docs/project-brief.md`), the roadmap (`docs/roadmap.md`), the architecture (`docs/architecture.md`), the test plan, and the user-facing guides under `docs/guides/` all live here.
- **`.sdlc/`** holds the working artifacts the AI manages session to session — noisy for a human browsing the tree, so they are tucked into a dot-folder. This is where issue files (`.sdlc/issues/`), handoff notes (`.sdlc/handoff-notes/`), and the lessons log (`.sdlc/lessons-log.md`) live.

A simple rule of thumb: if it is something you would put in front of a stakeholder, it is in `docs/`; if it is the team's internal scratch and tracking, it is in `.sdlc/`.

Issue files move through four status folders as work progresses: `.sdlc/issues/backlog/` (broken down, not yet committed), `.sdlc/issues/planned/` (approved to work on), `.sdlc/issues/in-progress/` (being worked now), and `.sdlc/issues/done/`. The `/start-task` command picks up work only from `planned/`; `/resume-task` continues only what is already `in-progress/`.

## The shape of the toolkit: one source, copied in

There is one place all the expert definitions live: the `agents/` folder in this repository. That is the single source of truth. Nothing is duplicated per harness.

Installing is a copy operation. The installer (`install.sh` on macOS or Linux, `install.ps1` on Windows) takes that one `agents/` source and lays it down in your target project:

- `agents/` is copied to `.agents/` in your project (the dot-prefix marks it as tooling).
- A root `AGENTS.md` is written, and `CLAUDE.md` is symlinked to it so Claude Code reads the same file.
- Unless you pass `--no-claude`, a `.claude/` folder is wired up with symlinks back into `.agents/`, giving Claude Code native menu discovery of the commands and skills.
- The `docs/` and `.sdlc/` folders are created for the project's documents and working artifacts.

To extend the toolkit — say, to change how an expert behaves — you edit the source under `agents/` in this repo and re-install. You never edit the installed copy in a consuming project as the way to make a lasting change, because the next install would overwrite it.

The architecture document (`docs/architecture.md`) covers the reasoning behind this single-source model, the symlink wiring, and the exact install steps.

## Where to go next

- To install the toolkit and reach a first productive session, read the getting-started guide (`docs/guides/getting-started.md`).
- For the design decisions behind everything above, read the architecture document (`docs/architecture.md`).
- For the exhaustive contracts (which document each expert produces, file-type rules), read the agent reference (`docs/agent-reference.md`).

- For the day-to-day commands and the order of operations, read the usage guide (`docs/guides/usage.md`).
- To change or add an expert, read the contributing guide (`docs/guides/contributing.md`).
