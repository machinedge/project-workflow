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

Setup scripts live in `framework/install/` and install expert definitions into your project:

**macOS / Linux:**
```bash
# Full team setup (all experts) for a new project
./framework/install/install.sh ~/projects/my-app

# Single expert setup
./framework/install/install.sh --expert swe ~/projects/my-app
./framework/install/install.sh --expert data-analyst ~/projects/my-analysis
```

**Windows (PowerShell):**
```powershell
.\framework\install\install.ps1 -Target ~\projects\my-app
.\framework\install\install.ps1 -Expert swe -Target ~\projects\my-app
```

Then open the project in your editor and run the first skill (`/pm-interview` for project-manager, `/swe-start` for SWE, `/da-intake` for data-analyst).

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
├── docs/
│   ├── lessons-log.md               # Running gotchas (template)
│   └── handoff-notes/               # Session memory
│       ├── swe/
│       ├── qa/
│       ├── devops/
│       └── project-manager/
└── issues/                          # In-repo issue tracking (managed by PM)
```

### Prerequisites (Standalone Mode)

- Git (installed and configured)
- Claude Code, Cursor, or Cowork
- For data-analyst expert: Python 3.10+ with uv or pip

---

## Team Mode Setup

> **Status:** Under active development. The following describes the target experience.

### Prerequisites (Team Mode)

- OpenClaw installed and configured ([openclaw.ai](https://openclaw.ai/))
- Docker and Docker Compose
- OpenAI API key
- A Matrix client (Element recommended) for monitoring the team

### Spinning Up a Team

```bash
# cd into the project directory of your choice
cd my-project

# Spin up a full dev team for a project
machinedge init software

# This:
# - Translates expert definitions into OpenClaw agent configs
# - Provisions OpenClaw workspaces for each expert (project-manager, SWE, QA, DevOps)
# - Sets up a Matrix room with routing bindings for the team
# - Configures a shared git repo with branch-per-expert strategy
# - Creates an issues/ directory for in-repo task tracking
# - Starts the OpenClaw gateway with the team running
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
│       ├── machinedge.yaml          # MachinEdge team configuration
│       ├── openclaw/                # Generated OpenClaw configuration
│       │   ├── agents.yaml          # Multi-agent routing and bindings
│       │   └── workspaces/          # Per-expert OpenClaw workspaces
│       │       ├── project-manager/ # AGENTS.md + skills/ + tools/
│       │       ├── swe/
│       │       ├── qa/
│       │       └── devops/
│       └── git/
│           └── my-project.git       # Shared bare repo
```

---

## Your First Session (Standalone Mode)

### With the PM Expert

1. **`/pm-interview`** — The PM conducts a structured interview to pull your project ideas out. Asks about goals, users, constraints, and scope. Output: `docs/interview-notes.md`.
2. **`/pm-vision`** — Reads interview notes and drafts a concise project brief. Review carefully — this becomes the source of truth. Output: `docs/project-brief.md`.
3. **`/pm-roadmap`** — Creates a milestone plan with dependencies and risks. Output: `docs/roadmap.md`.
4. **`/pm-decompose`** — Pick a milestone. Breaks it into session-sized issues (tracked in `issues/`) with user stories and acceptance criteria.

### With the SWE Expert

5. **`/swe-start #N`** — Pick an issue number. Loads all context, presents a plan (approval gate), designs architecture (approval gate), writes tests, implements, verifies, and reports.
6. **`/swe-handoff`** — Run before closing the session. Documents what was done, updates the brief, closes the issue.

Repeat steps 5-6 for each task.

### With the QA Expert

- **`/qa-review #N`** — Fresh-eyes evaluation in a separate session.
- **`/qa-test-plan`** — Creates a test plan based on the project brief and roadmap.
- **`/qa-regression`** — Runs regression analysis against existing test coverage.

### With the DevOps Expert

- **`/ops-env-discovery`** — Discovers and documents the deployment environment.
- **`/ops-pipeline`** — Sets up CI/CD pipeline configuration.
- **`/ops-deploy`** — Executes deployment following the release plan.

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

**Always run the handoff skill (e.g. `/swe-handoff`) before closing a session (standalone mode).** This is the single most important habit. The handoff note is how the next session knows what happened.

**Keep sessions focused.** One task per session. If you're tempted to squeeze in "one more thing," start a new session instead.

**Review the brief after `/vision` or `/brief`.** The project brief becomes the source of truth for every downstream action. If it's wrong, everything built on it will be wrong.

**Use `/qa-review` in a fresh session (standalone mode).** The whole point of fresh-eyes review is the absence of implementation memory. Running it in the same session that wrote the code defeats the purpose.

**`docs/` and `issues/` are your team's shared context.** They're editor-agnostic and expert-agnostic. All experts read from the same document and issue pool. The PM manages the issue lifecycle — creating, assigning, and closing issues as work progresses.
