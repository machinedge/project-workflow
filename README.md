# MachinEdge Project Workflows

Structured workflows for running multi-session projects with AI coding assistants. Works with **Claude Code**, **Cowork** (Claude desktop app), and **Cursor**.

This repo contains two workflow toolkits, distributed as a single installable Claude skill:

| Workflow | Purpose |
|----------|---------|
| **SWE** | Software engineering projects — plan, build, test, review |
| **EDA** | Time series exploratory data analysis — hypothesize, analyze, synthesize |

Both toolkits solve the same core problem: AI assistants have no memory between sessions. These workflows give them a protocol — what to read, how to work, what to produce — so context is preserved and work is structured across as many sessions as a project needs.

## Install

### Option A: Install the Skill (recommended)

Install the `.skill` package in Claude Code or Cowork. Once installed, just ask Claude to set up a workflow — no terminal commands needed.

```
# In Claude Code
claude install-skill machinedge-workflows.skill

# In Cowork
# Just say: "Set up an SWE workflow for my project"
```

The skill walks you through choosing a workflow (SWE or EDA), selecting your editor(s), and configuring the project. Everything is handled by Claude.

### Option B: Run the Setup Scripts Directly

If you prefer the command line, you can run the setup scripts from the skill bundle:

```bash
# Software engineering project
./skills/machinedge-workflows/workflows/swe/setup.sh ~/projects/my-app

# Time series analysis project
./skills/machinedge-workflows/workflows/eda/setup.sh ~/projects/my-analysis

# Create a new GitHub repo instead
./skills/machinedge-workflows/workflows/swe/new_repo.sh my-app
./skills/machinedge-workflows/workflows/eda/new_repo.sh my-analysis
```

Then open the project in your editor and run the first command (`/interview` for SWE, `/intake` for EDA).

## Packaging the Skill

To build a distributable `.skill` file from the source:

```bash
python framework/package_skill.py skills/machinedge-workflows
```

This validates the skill structure and produces `machinedge-workflows.skill` — a single file that anyone can install.

## Documentation

| Guide | Audience | Description |
|-------|----------|-------------|
| [Overview](docs/overview.md) | Everyone | What this toolkit is, how the two workflows compare, and the design philosophy |
| [Getting Started](docs/getting-started.md) | Users | Installation, setup, first session walkthrough for both workflows |
| [Agent Reference](docs/agent-reference.md) | AI agents | How agents should orient themselves, which documents to read, and how commands interact |
| [Workflow Anatomy](docs/workflow-anatomy.md) | Contributors | Deep-dive reference on patterns, conventions, and how to customize |

Each workflow also has its own detailed README:

- [SWE Workflow README](skills/machinedge-workflows/workflows/swe/README.md)
- [EDA Workflow README](skills/machinedge-workflows/workflows/eda/README.md)

## Creating Your Own Workflow

Want to build a workflow for a different domain? The framework makes it straightforward:

```bash
# Scaffold a new workflow from templates
./framework/create-workflow.sh devops

# Customize the generated files, then validate
./framework/validate.sh devops
```

The scaffold generates a complete workflow skeleton — editor rules, 8 command files, setup scripts, and a README — all pre-populated with the structural patterns from the existing workflows and guidance comments explaining what to customize.

See [framework/CONTRIBUTING.md](framework/CONTRIBUTING.md) for the full contributor guide.

## How the Workflows Operate

Both workflows follow the same arc:

```
Interview → Brief → Plan → Decompose → Execute → Review → Synthesize
```

Every session is structured: load context first, work within scope, hand off at the end. Documents accumulate across sessions and serve as the AI's memory. GitHub Issues track tasks and review findings.

## Repository Structure

```
project-workflow/
├── README.md                       ← You are here
├── LICENSE                         ← Apache 2.0
├── docs/                           ← Documentation
│   ├── overview.md
│   ├── getting-started.md
│   ├── agent-reference.md
│   └── workflow-anatomy.md
├── skills/
│   └── machinedge-workflows/       ← The distributable skill package
│       ├── SKILL.md                ← Skill entry point (Claude reads this)
│       └── workflows/
│           ├── swe/                ← Software engineering workflow
│           │   ├── editor.md       ← Operating rules (single source)
│           │   ├── commands/       ← Slash command definitions
│           │   ├── setup.sh / setup.ps1
│           │   └── new_repo.sh / new_repo.ps1
│           └── eda/                ← Time series analysis workflow
│               ├── editor.md
│               ├── commands/
│               ├── setup.sh / setup.ps1
│               └── new_repo.sh / new_repo.ps1
└── framework/                      ← Scaffolding tools for creating new workflows
    ├── create-workflow.sh
    ├── validate.sh
    ├── CONTRIBUTING.md
    └── templates/
```

## Prerequisites

For script-based setup (Option B):

- Git (installed and configured)
- GitHub CLI (`gh`) — [install here](https://cli.github.com/)
- `GITHUB_ORG` environment variable set (or pass `--org` per invocation)
- For EDA: Python 3.10+ with uv or pip

For skill-based setup (Option A): just Claude Code or Cowork.

## License

Apache 2.0 — see [LICENSE](LICENSE).
