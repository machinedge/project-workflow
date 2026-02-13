# Getting Started

This guide walks through setting up a project with either the SWE or EDA workflow, from installation through your first session.

## Prerequisites

Before you begin, make sure you have:

- **Git** installed and configured
- **GitHub CLI (`gh`)** installed and authenticated — [install here](https://cli.github.com/)
- **Claude Code** or **Cursor** (or both) installed
- **`GITHUB_ORG`** environment variable set to your GitHub org or username (or pass `--org` per invocation)

For EDA projects, you also need Python 3.10+ with [uv](https://github.com/astral-sh/uv) (recommended) or pip.

## Option A: Add to an Existing Project

If you already have a project repo and want to add the workflow to it:

**macOS / Linux:**
```bash
# SWE workflow — both editors (default)
./swe/setup.sh ~/projects/my-app

# SWE workflow — Claude Code only
./swe/setup.sh --editor claude ~/projects/my-app

# EDA workflow — Cursor only
./eda/setup.sh --editor cursor ~/projects/my-analysis
```

**Windows (PowerShell):**
```powershell
# SWE workflow
.\swe\setup.ps1 -Target ~\projects\my-app

# EDA workflow, Claude Code only
.\eda\setup.ps1 -Editor claude -Target ~\projects\my-analysis
```

The setup script creates the necessary directory structure, copies the rules file to the editor's config location, and copies all slash commands. It does not touch your existing code.

## Option B: Create a New GitHub Repo

If you're starting fresh and want a new repo with the workflow already installed:

**macOS / Linux:**
```bash
# SWE workflow — new repo under your org
./swe/new_repo.sh my-app
./swe/new_repo.sh --org mycompany --editor claude my-app

# EDA workflow — new repo
./eda/new_repo.sh my-analysis
```

**Windows (PowerShell):**
```powershell
.\swe\new_repo.ps1 my-app
.\eda\new_repo.ps1 -Org mycompany my-analysis
```

This creates the GitHub repo, clones it locally, runs the setup, and commits the initial structure.

## What Setup Creates

After setup, your project will have this structure added (existing files are untouched):

**SWE project:**
```
my-app/
├── .claude/
│   ├── CLAUDE.md                    # Auto-loaded rules for Claude Code
│   └── commands/*.md                # Slash commands
├── .cursor/
│   ├── rules/project-os.mdc        # Auto-loaded rules for Cursor
│   └── commands/*.md                # Slash commands
└── docs/
    └── lessons-log.md               # Running gotchas (template)
```

**EDA project:**
```
my-analysis/
├── .claude/
│   ├── CLAUDE.md                    # Auto-loaded rules for Claude Code
│   └── commands/*.md                # Slash commands
├── .cursor/
│   ├── rules/analysis-os.mdc       # Auto-loaded rules for Cursor
│   └── commands/*.md                # Slash commands
├── docs/
│   └── lessons-log.md               # Running gotchas (template)
├── notebooks/                       # Working surface for analysis
├── data/
│   ├── raw/                         # Untouched source data
│   └── processed/                   # Cleaned/transformed data
└── reports/                         # Synthesis reports (the deliverables)
```

## Your First Session

### SWE Workflow

Open your project in Claude Code or Cursor and run these commands in order:

1. **`/brainstorm`** — The AI conducts a structured interview to pull your project ideas out. It asks about goals, users, constraints, and scope. Output: `docs/brainstorm-notes.md`.

2. **`/vision`** — The AI reads your brainstorm notes and drafts a concise project brief. Review it carefully — this becomes the source of truth for every future session. Output: `docs/project-brief.md`.

3. **`/roadmap`** — The AI reads the brief and creates a milestone plan with dependencies and risks. Output: `docs/roadmap.md`.

4. **`/decompose`** — Pick a milestone. The AI breaks it into session-sized GitHub Issues, each with a user story and acceptance criteria.

5. **`/start #N`** — Pick an issue number. The AI loads all context, presents a plan (approval gate), designs the architecture (approval gate), writes tests, implements, verifies, and reports. This is where the actual coding happens.

6. **`/handoff`** — Run this before closing the session. The AI documents what was done, updates the project brief, and closes the GitHub issue.

Repeat steps 5-6 for each task. Occasionally run `/review #N` in a fresh session for code review. After finishing a milestone, run `/postmortem`.

### EDA Workflow

Open your project in Claude Code or Cursor and run these commands in order:

1. **`/intake`** — The AI generates domain context for your specific application area (e.g., predictive maintenance, demand forecasting), then conducts a structured interview about your data, questions, and goals. Output: `docs/domain-context.md` + `docs/intake-notes.md`.

2. **`/brief`** — The AI synthesizes the interview into an analysis brief. Output: `docs/analysis-brief.md`.

3. **`/scope`** — The AI defines 3-6 analysis phases with dependencies and risks. Output: `docs/scope.md`.

4. **`/decompose`** — Pick a phase. The AI breaks it into hypothesis-driven GitHub Issues.

5. **`/start #N`** — Pick an issue. The AI loads context, states hypotheses (approval gate), designs the analysis (approval gate), validates data, runs the analysis, validates results, and reports findings.

6. **`/handoff`** — Run this before closing. The AI documents findings, updates the brief, and closes the issue.

Repeat steps 5-6 for each task. Run `/review #N` in a fresh session for methodological review. After completing a phase, run `/synthesize` to pull findings into a recommendations report.

## Tips for Getting the Most Out of the Workflows

**Always run `/handoff` before closing a session.** This is the single most important habit. Two minutes at session end saves twenty minutes of re-orientation next session. The handoff note is how the next session knows what happened.

**Keep sessions focused.** One task per session. If you're tempted to squeeze in "one more thing," start a new session instead. The overhead of loading context is minimal; the cost of a messy, multi-task session with no clear handoff is high.

**Review the brief after `/vision` or `/brief`.** The project/analysis brief becomes the source of truth for every downstream command. If it's wrong, everything built on it will be wrong. Invest time reviewing it.

**Use `/review` in a fresh session.** The whole point of fresh-eyes review is that the AI has no memory of implementation decisions. Running it in the same session that wrote the code defeats the purpose.

**The `docs/` folder is your team's shared context.** It's editor-agnostic. Team members using different editors all read and write the same documents. Tasks on GitHub are visible to everyone.

## Editor-Specific Notes

### Claude Code
- `CLAUDE.md` is automatically loaded every session — no configuration needed.
- Commands appear when you type `/` in the CLI.

### Cursor
- Rules use `.mdc` files with frontmatter (`alwaysApply: true`) for automatic loading.
- Commands appear in the `/` menu in chat.
- Use **Agent mode** (not Ask or Edit mode) for commands to work properly.
