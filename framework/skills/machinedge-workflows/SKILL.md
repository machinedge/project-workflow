---
name: machinedge-workflows
description: >
  Set up structured AI-assisted project workflows by MachinEdge. Available workflows:
  Software Engineering (SWE) for multi-session development with test-first execution,
  and Exploratory Data Analysis (EDA) for hypothesis-driven time series analysis.
  Use this skill whenever someone mentions: setting up a workflow, starting a new project,
  "swe workflow", "eda workflow", "machinedge", structured development, data analysis project,
  project setup, configuring Claude Code or Cursor for multi-session work, or wants to
  add workflow commands to an existing project. Also trigger when someone says "setup workflow",
  "/setup_workflow", or asks about organizing AI-assisted project sessions. Works in both
  Cowork (Claude desktop app) and Claude Code (CLI).
---

# MachinEdge Workflow Setup

You are helping a user set up a MachinEdge workflow in a project directory. Your job is to
guide them through a few choices and then configure everything — creating directories, copying
editor rules, and installing slash commands — so they can immediately start working.

The user should not need to touch a terminal themselves. You handle all of it.

## What Gets Installed

A MachinEdge workflow gives a project:

1. **Editor rules** — an operating system file that Claude Code or Cursor auto-loads every session,
   telling the AI how to behave on this project (read docs first, stay in scope, produce handoff notes).
2. **Slash commands** — a set of `/commands` that structure the project lifecycle
   (interview → plan → decompose → execute → review → handoff).
3. **A docs directory** — where project memory lives between sessions (briefs, handoff notes, lessons).
4. **Workflow-specific extras** — EDA gets `notebooks/`, `data/`, `reports/`, and a `pyproject.toml`
   with pre-configured Python dependencies.

## Step 1: Gather Information

Ask the user three things. Use the AskUserQuestion tool to present these as clear choices rather
than open-ended questions. You can ask them all at once.

### Which workflow?

| Workflow | Best For | Commands |
|----------|----------|----------|
| **SWE** (Software Engineering) | Building software — apps, APIs, libraries, tools | `/interview` → `/vision` → `/roadmap` → `/decompose` → `/start` → `/review` → `/handoff` → `/postmortem` |
| **EDA** (Exploratory Data Analysis) | Time series analysis — data exploration, hypothesis testing, statistical analysis | `/intake` → `/brief` → `/scope` → `/decompose` → `/start` → `/review` → `/handoff` → `/synthesize` |

### New project or existing?

- **New project** — Create a fresh directory with everything set up from scratch.
  Ask for the project/directory name. The directory will be created inside the user's
  current working folder (or wherever they specify).
- **Existing project** — Add the workflow to a project that already has code in it.
  Ask where the project is. The workflow files get layered in without touching existing code.

### Which editor(s)?

- **Claude Code** — installs `.claude/CLAUDE.md` and `.claude/commands/*.md`
- **Cursor** — installs `.cursor/rules/{name}.mdc` and `.cursor/commands/*.md`
- **Both** (default) — installs for both editors. This is the right choice when a team
  uses mixed editors, since the docs directory is shared and editor-agnostic.

### GitHub repo? (new projects only)

If the user is creating a new project, ask if they want to also create a GitHub repo.
This requires `git` and `gh` CLI to be installed. If they say yes, you'll need:
- A GitHub org or username (check for `GITHUB_ORG` env var first)
- The repo name (default to the project directory name)

## Step 2: Execute Setup

Once you have the user's choices, run the appropriate setup script. Everything is bundled
inside this skill's directory.

### Locating the scripts

You already know the path to this SKILL.md because you read it. The skill directory is
the parent of this file. All workflow files are bundled right here:

```
machinedge-workflows/       ← this skill (the distributable package)
├── SKILL.md                ← you are reading this
└── workflows/
    ├── swe/                ← editor.md, commands/, setup.sh, new_repo.sh
    └── eda/                ← editor.md, commands/, setup.sh, new_repo.sh
```

Resolve the paths like this:

```bash
SKILL_DIR="<directory containing this SKILL.md>"
# e.g. /home/user/.skills/skills/machinedge-workflows
```

The workflow files are at:
- `$SKILL_DIR/workflows/swe/` — SWE workflow (editor.md, commands/, setup.sh, new_repo.sh)
- `$SKILL_DIR/workflows/eda/` — EDA workflow (editor.md, commands/, setup.sh, new_repo.sh)

### For existing projects

Run the setup script:

```bash
bash "$SKILL_DIR/workflows/<workflow>/setup.sh" --editor <claude|cursor|both> "<target-directory>"
```

### For new projects (local only)

Create the directory first, then run setup:

```bash
mkdir -p "<target-directory>"
bash "$SKILL_DIR/workflows/<workflow>/setup.sh" --editor <claude|cursor|both> "<target-directory>"
```

Then initialize git if appropriate:

```bash
cd "<target-directory>" && git init && git add . && git commit -m "Initial commit: project scaffold with MachinEdge workflow"
```

### For new projects with GitHub repo

Run the new_repo script. It handles directory creation, setup, git init, and GitHub repo creation:

```bash
bash "$SKILL_DIR/workflows/<workflow>/new_repo.sh" --org "<github-org>" --editor <claude|cursor|both> "<repo-name>"
```

Before running this, verify prerequisites:
- `git` is installed: `command -v git`
- `gh` CLI is installed: `command -v gh`
- `gh` is authenticated: `gh auth status`

If any prerequisite is missing, explain what needs to be installed and offer to help
(but note that the user may need to handle authentication themselves).

### Platform handling

The setup scripts have both `.sh` (macOS/Linux) and `.ps1` (Windows/PowerShell) versions.
Detect the platform and use the right one:

```bash
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    pwsh "$SKILL_DIR/workflows/<workflow>/setup.ps1" ...
else
    bash "$SKILL_DIR/workflows/<workflow>/setup.sh" ...
fi
```

In practice, Claude Code and Cowork run in bash-compatible environments. The PowerShell
scripts exist for users who run setup manually on Windows.

## Step 3: Confirm and Orient

After setup completes, give the user a clear summary of what was created and what to do next.
Tailor the next-steps to the workflow they chose.

### For SWE workflow

Tell them:
> Your project is set up with the Software Engineering workflow. Here's what to do next:
>
> 1. Open the project in Claude Code or Cursor
> 2. Run `/interview` — this walks you through a structured conversation to capture your
>    project idea, goals, and constraints
> 3. Then follow the lifecycle: `/vision` → `/roadmap` → `/decompose` → `/start`
>
> Each command builds on the previous one. The workflow creates living documents in `docs/`
> that carry your project context across sessions.

### For EDA workflow

Tell them:
> Your project is set up with the Exploratory Data Analysis workflow. Here's what to do next:
>
> 1. Place your data files in `data/raw/`
> 2. Install Python dependencies: `uv sync` (or `pip install -e .`)
> 3. Open the project in Claude Code or Cursor
> 4. Run `/intake` — this generates domain context and walks you through an interview
>    about your data, business questions, and analysis goals
> 5. Then follow the lifecycle: `/brief` → `/scope` → `/decompose` → `/start`

### Key concept to communicate

The most important thing for the user to understand: **these workflows give AI memory across sessions**.
Every session reads project documents at startup and writes handoff notes at the end. The user
doesn't need to re-explain their project every time they open a new chat. This is the core value
proposition — explain it in plain language, not jargon.

## Edge Cases

### User wants a workflow that doesn't exist yet

The toolkit includes a framework for creating custom workflows. If someone asks for a workflow
type that isn't SWE or EDA (e.g., DevOps, Content Writing, Research), let them know:

1. The two available workflows are SWE and EDA
2. Custom workflows can be created using the framework scaffolder
3. They can start by picking whichever existing workflow is closest to their needs
   and customizing the commands and editor rules after setup

### User already has workflow files in their project

If the target directory already has `.claude/CLAUDE.md` or `.cursor/rules/`, warn the user
that setup will overwrite those files. Ask for confirmation before proceeding.

### User is in Cowork without a folder selected

If the user hasn't selected a folder in Cowork, you won't have a target directory to work with.
Guide them to select a folder first (they can do this from the Cowork interface), then re-run
the setup.

### User is in Cowork with a folder already selected

The selected folder is mounted and accessible. For "existing project" setups, this mounted
folder is the natural target — you don't need to ask where the project is. For "new project"
setups, create the new directory inside the mounted folder.

### User is in Claude Code

The current working directory is the project. For "existing project" setups, use `.` as the
target. For "new project" setups, ask where they want the new directory (default: current
working directory or `$HOME/work/`).

### User just wants to explore

If the user is just asking about the workflows (not ready to set one up), read the relevant
`editor.md` file from this skill's `workflows/` directory (e.g. `workflows/swe/editor.md`)
and explain what the workflow does, what commands it includes, and what kind of project
it's designed for. Don't push setup until they're ready.
