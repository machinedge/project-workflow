# Getting Started

This guide covers the two deployment modes: standalone (single expert in an editor) and team (coordinated experts on the MachinEdge platform). Most users will start with standalone mode to get familiar with the expert definitions, then move to team mode for real project work.

## Deployment Modes

### Standalone Mode (Single Expert, Single Editor)

Use a single expert directly in Claude Code, Cowork, or Cursor. This is the simplest way to get started — install the skill, set up a workflow, and use the slash commands interactively. You are the orchestrator, switching between experts manually as needed.

This is how the workflows have worked historically and remains a fully supported path.

### Team Mode (Coordinated Experts, MachinEdge Platform)

Spin up a full AI development team for a project. The PM leads, experts coordinate through Matrix, and you interact primarily with the PM. This is the target deployment model — see the [Overview](overview.md) for the full vision.

Team mode is under active development. The rest of this guide covers both modes.

---

## Standalone Mode Setup

### Option A: Install the Skill (recommended)

Install the `.skill` package in Claude Code or Cowork. Once installed, just ask Claude to set up a workflow — no terminal commands needed.

```
# In Claude Code
claude install-skill machinedge-workflows.skill

# In Cowork
# Just say: "Set up an SWE workflow for my project"
```

The skill walks you through choosing an expert (SWE, EDA, PM, QA, or DevOps), selecting your editor(s), and configuring the project.

### Option B: Run the Setup Scripts Directly

If you prefer the command line:

**macOS / Linux:**
```bash
# Full team setup (all experts) for a new project
./workflows/setup.sh ~/projects/my-app

# Single expert setup
./workflows/setup.sh --expert swe ~/projects/my-app
./workflows/setup.sh --expert eda ~/projects/my-analysis
```

**Windows (PowerShell):**
```powershell
.\workflows\setup.ps1 -Target ~\projects\my-app
.\workflows\setup.ps1 -Expert swe -Target ~\projects\my-app
```

Then open the project in your editor and run the first skill (`/interview` for PM, `/start` for SWE, `/intake` for EDA).

### What Setup Creates

After setup, your project will have this structure added (existing files are untouched):

```
my-app/
├── .claude/
│   ├── CLAUDE.md                    # Auto-loaded rules (from expert's role.md)
│   └── commands/*.md                # Skills as slash commands
├── .cursor/
│   ├── rules/expert-os.mdc         # Auto-loaded rules for Cursor
│   └── commands/*.md                # Skills as slash commands
└── docs/
    ├── lessons-log.md               # Running gotchas (template)
    └── handoff-notes/               # Session memory
        ├── swe/
        ├── qa/
        ├── devops/
        └── pm/
```

### Prerequisites (Standalone Mode)

- Git (installed and configured)
- GitHub CLI (`gh`) — [install here](https://cli.github.com/)
- Claude Code, Cursor, or Cowork
- For EDA: Python 3.10+ with uv or pip

---

## Team Mode Setup

> **Status:** Under active development. The following describes the target experience.

### Prerequisites (Team Mode)

- Docker and Docker Compose
- A Matrix homeserver (Dendrite recommended for single-box deployments)
- OpenAI API key
- A Matrix client (Element recommended) for monitoring the team

### Spinning Up a Team

```bash
# Initialize a new project with a full dev team
machinedge init my-project

# This provisions:
# - A Matrix room for the project
# - Docker containers for each expert (PM, SWE, QA, DevOps)
# - A shared git repo with branch-per-expert strategy
# - Static configuration generated from the expert definitions
```

### Interacting with Your Team

Once the team is running, you interact with it through Matrix:

1. **Open your Matrix client** (Element or any Matrix-compatible client)
2. **Join the project room** — you'll see all expert activity here
3. **Talk to the PM** — describe what you want built, report a bug, or request a feature
4. **The PM handles the rest** — it breaks down work, delegates to experts, and pulls you in for reviews

You can also monitor individual expert activity, interject at any point, or step back and let the team work autonomously.

### What Team Mode Creates

```
~/.machinedge/
├── projects/
│   └── my-project/
│       ├── config.yaml              # Static team configuration
│       ├── docker-compose.yaml      # Container definitions
│       ├── matrix/                  # Matrix room configuration
│       └── workspaces/              # Per-expert isolated workspaces
│           ├── pm/
│           ├── swe/
│           ├── qa/
│           └── devops/
└── shared/
    └── git/
        └── my-project.git           # Shared bare repo
```

---

## Your First Session (Standalone Mode)

### With the PM Expert

1. **`/interview`** — The PM conducts a structured interview to pull your project ideas out. Asks about goals, users, constraints, and scope. Output: `docs/interview-notes.md`.
2. **`/vision`** — Reads interview notes and drafts a concise project brief. Review carefully — this becomes the source of truth. Output: `docs/project-brief.md`.
3. **`/roadmap`** — Creates a milestone plan with dependencies and risks. Output: `docs/roadmap.md`.
4. **`/decompose`** — Pick a milestone. Breaks it into session-sized GitHub Issues with user stories and acceptance criteria.

### With the SWE Expert

5. **`/start #N`** — Pick an issue number. Loads all context, presents a plan (approval gate), designs architecture (approval gate), writes tests, implements, verifies, and reports.
6. **`/handoff`** — Run before closing the session. Documents what was done, updates the brief, closes the issue.

Repeat steps 5-6 for each task.

### With the QA Expert

- **`/review #N`** — Fresh-eyes evaluation in a separate session.
- **`/test-plan`** — Creates a test plan based on the project brief and roadmap.
- **`/regression`** — Runs regression analysis against existing test coverage.

### With the DevOps Expert

- **`/env-discovery`** — Discovers and documents the deployment environment.
- **`/pipeline`** — Sets up CI/CD pipeline configuration.
- **`/deploy`** — Executes deployment following the release plan.

## Your First Session (Team Mode)

> **Status:** Under active development.

In team mode, your interaction is simpler:

1. **Open your Matrix client** and join the project room
2. **Tell the PM what you want:** "I need a web app that tracks inventory for a small warehouse"
3. **The PM interviews you** — same structured interview, but through chat
4. **The PM spins up the work** — creates the brief, roadmap, decomposes tasks, and delegates
5. **You review when asked** — the PM pulls you in for approval gates and decisions
6. **Monitor progress** — watch the team work in the Matrix room, or check back later

---

## Tips

**Always run `/handoff` before closing a session (standalone mode).** This is the single most important habit. The handoff note is how the next session knows what happened.

**Keep sessions focused.** One task per session. If you're tempted to squeeze in "one more thing," start a new session instead.

**Review the brief after `/vision` or `/brief`.** The project brief becomes the source of truth for every downstream action. If it's wrong, everything built on it will be wrong.

**Use `/review` in a fresh session (standalone mode).** The whole point of fresh-eyes review is the absence of implementation memory. Running it in the same session that wrote the code defeats the purpose.

**The `docs/` folder is your team's shared context.** It's editor-agnostic and expert-agnostic. All experts read and write the same document pool.
