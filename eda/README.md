# Time Series EDA Toolkit

A structured workflow for running time series exploratory data analysis with AI coding assistants. Works with **Claude Code** and **Cursor**.

This toolkit gives you a repeatable process for going from raw time series data to actionable insights and recommendations — using AI agents as your analytical partner across multiple sessions.

## Why This Exists

Time series EDA is iterative, multi-session work. Each session builds on what the last one found. Without structure, context gets lost between sessions, analysis wanders, and findings never get synthesized into recommendations.

This toolkit solves that by giving the AI a protocol: what documents to read at the start of each session, how to structure analysis around testable hypotheses, and how to hand off findings to the next session.

## How It Works

Both editors use the same underlying system:

- **`editor.md`** contains the operating rules (copied to `.claude/CLAUDE.md` and `.cursor/rules/analysis-os.mdc`)
- **`commands/*.md`** define the slash commands (copied to both editors)
- **`setup.sh`** / **`setup.ps1`** handles the copying

Maintain files once in this toolkit, deploy to both editors automatically.

## Workflow

### Planning Phase

| Step | Command | What It Does | Output |
|------|---------|-------------|--------|
| 1 | `/intake` | Generate domain context + structured interview | `docs/domain-context.md` + `docs/intake-notes.md` |
| 2 | `/brief` | Generate the analysis brief from intake notes | `docs/analysis-brief.md` |
| 3 | `/scope` | Define analysis phases, dependencies, risks | `docs/scope.md` |
| 4 | `/decompose` | Break phase into hypothesis-driven GitHub Issues | GitHub Issues with user stories |

### Execution Phase

| Step | Command | What It Does | Output |
|------|---------|-------------|--------|
| 5 | `/start #N` | Run a 7-phase analysis session | Notebook + findings + data profile updates |
| 6 | `/handoff` | Close session, document what was found | Handoff note + issue updates |

### Review & Synthesis

| Step | Command | What It Does | Output |
|------|---------|-------------|--------|
| 7 | `/review #N` | Methodological review (fresh eyes) | Must-fix / should-fix issues |
| 8 | `/synthesize` | Pull all findings into recommendations | Synthesis report in `reports/` |

### What `/start` Does (7 Phases)

1. **Load Context** — Reads analysis brief, domain context, data profile, lessons log, GitHub issue, prior handoff notes (automatic)
2. **Hypothesize** — State what you expect to find BEFORE looking at the data (approval gate)
3. **Design Analysis** — Choose methods, plan visualizations, define expected outputs (approval gate)
4. **Validate Data** — Check data quality and fitness for the planned analysis
5. **Analyze** — Execute the analysis, create visualizations, update data profile
6. **Validate Results** — Statistical checks, sanity checks, reproducibility
7. **Report Findings** — Summarize what was found, confidence level, implications

## Setup

### Add to an existing project

```bash
# Both editors (default)
./setup.sh ~/my-analysis

# Claude Code only
./setup.sh --editor claude ~/my-analysis

# Cursor only
./setup.sh --editor cursor ~/my-analysis
```

Windows:
```powershell
.\setup.ps1 -Target ~\my-analysis
.\setup.ps1 -Editor claude -Target ~\my-analysis
```

### Create a new repo

```bash
# Requires: git, gh CLI, GITHUB_ORG env var (or --org flag)
./new_repo.sh my-analysis
./new_repo.sh --org mycompany --editor claude my-analysis
```

Windows:
```powershell
.\new_repo.ps1 my-analysis
.\new_repo.ps1 -Org mycompany -Editor claude my-analysis
```

### Install dependencies

```bash
# With uv (recommended)
uv sync

# With pip
pip install -e .
```

## Project Structure (After Setup)

```
my-analysis/
├── .claude/
│   ├── CLAUDE.md                    # Auto-loaded rules for Claude Code
│   └── commands/*.md                # Slash commands
├── .cursor/
│   ├── rules/analysis-os.mdc       # Auto-loaded rules for Cursor
│   └── commands/*.md                # Slash commands
├── docs/
│   ├── analysis-brief.md            # Source of truth — goals, questions, status
│   ├── domain-context.md            # Application domain — constraints, methods, pitfalls
│   ├── scope.md                     # Analysis phases and sequence
│   ├── data-profile.md              # Living dataset characterization
│   ├── intake-notes.md              # Raw interview notes
│   ├── lessons-log.md               # Gotchas, data quirks, domain knowledge
│   └── handoff-notes/
│       ├── session-01.md
│       └── session-02.md
├── notebooks/                       # Jupyter notebooks (working surface)
├── data/
│   ├── raw/                         # Untouched source data
│   └── processed/                   # Cleaned and transformed data
├── reports/                         # Synthesized findings and recommendations
└── pyproject.toml                   # Python dependencies (opinionated stack)
```

## Opinionated Stack

The toolkit prescribes a Python stack to avoid tool-choice paralysis:

| Category | Libraries |
|----------|-----------|
| Core analysis | pandas, numpy, scikit-learn, statsmodels, scipy |
| Time series | sktime, tsfresh |
| Visualization | plotly (interactive EDA), matplotlib + seaborn (static reports) |
| Package management | uv (default), conda (alternative) |

## Key Design Decisions

**Dynamic domain context.** When you run `/intake`, the AI first generates `docs/domain-context.md` — a comprehensive document encoding the application domain's constraints, typical data characteristics, appropriate statistical methods, common pitfalls, and domain vocabulary. This isn't a static template — it's dynamically generated based on the specific application area (predictive maintenance, demand forecasting, anomaly detection, etc.) and refined with user feedback. Every downstream command reads it, which means the AI shows up to every session already knowing the domain.

**Hypothesis-driven analysis.** Every `/start` session begins by stating what you expect to find before looking at the data. This prevents confirmation bias and makes surprising results visible.

**Living data profile.** `docs/data-profile.md` accumulates across sessions. Every time you learn something about the data, it gets recorded. By the time you reach `/synthesize`, you have a rich characterization that didn't exist when you started.

**Insights are the deliverable, not notebooks.** Notebooks live in `notebooks/` — they're the working surface. The actual deliverable is the synthesis report in `reports/`, written for the stakeholder audience specified in the analysis brief.

**GitHub Issues as analysis tasks.** Each issue title is a hypothesis or question. Acceptance criteria are the analytical activities needed to answer it. This keeps analysis focused and scoped.

**Fresh-eyes review.** `/review` is designed to run in a separate session with zero memory of the original analysis. It evaluates statistical validity, methodology, data handling, and whether conclusions are justified.

## Prerequisites

- Git (installed and configured)
- GitHub CLI (`gh`) — required for `new_repo` scripts and issue tracking
- Python 3.10+ with uv or pip
- `GITHUB_ORG` environment variable set (or pass `--org` each time)

## License

Apache 2.0 — see [LICENSE](../LICENSE).
