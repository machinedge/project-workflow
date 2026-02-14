# MachinEdge Project Workflows

Structured workflows for running multi-session projects with AI coding assistants. Works with **Claude Code** and **Cursor**.

This repo contains two workflow toolkits:

| Workflow | Purpose | Location |
|----------|---------|----------|
| **SWE** | Software engineering projects — plan, build, test, review | [`swe/`](swe/) |
| **EDA** | Time series exploratory data analysis — hypothesize, analyze, synthesize | [`eda/`](eda/) |

Both toolkits solve the same core problem: AI assistants have no memory between sessions. These workflows give them a protocol — what to read, how to work, what to produce — so context is preserved and work is structured across as many sessions as a project needs.

## Quick Start

Pick a workflow, then set up a project:

```bash
# Software engineering project
./swe/setup.sh ~/projects/my-app

# Time series analysis project
./eda/setup.sh ~/projects/my-analysis

# Create a new GitHub repo instead
./swe/new_repo.sh my-app
./eda/new_repo.sh my-analysis
```

Then open the project in your editor and run the first command (`/brainstorm` for SWE, `/intake` for EDA).

## Documentation

| Guide | Audience | Description |
|-------|----------|-------------|
| [Overview](docs/overview.md) | Everyone | What this toolkit is, how the two workflows compare, and the design philosophy |
| [Getting Started](docs/getting-started.md) | Users | Installation, setup, first session walkthrough for both workflows |
| [Agent Reference](docs/agent-reference.md) | AI agents | How agents should orient themselves, which documents to read, and how commands interact |
| [Workflow Anatomy](docs/workflow-anatomy.md) | Contributors | Deep-dive reference on patterns, conventions, and how to customize |

Each workflow also has its own detailed README:

- [SWE Workflow README](swe/README.md)
- [EDA Workflow README](eda/README.md)

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

## Prerequisites

- Git (installed and configured)
- GitHub CLI (`gh`) — [install here](https://cli.github.com/)
- `GITHUB_ORG` environment variable set (or pass `--org` per invocation)
- For EDA: Python 3.10+ with uv or pip

## License

Apache 2.0 — see [LICENSE](LICENSE).
