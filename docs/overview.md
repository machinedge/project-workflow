# Overview

## What This Is

This repository contains two structured workflow toolkits that enable AI coding assistants (Claude Code, Cowork, and Cursor) to manage complex, multi-session work. One toolkit is for software engineering projects, the other for time series exploratory data analysis. Both are distributed as a single installable Claude skill (`machinedge-workflows.skill`).

The fundamental problem both toolkits solve: AI assistants start every session with a blank slate. Without structure, they lose context between sessions, re-litigate past decisions, and produce work that doesn't connect to what came before. These workflows fix that by giving the AI a protocol — documents to read, a process to follow, and artifacts to produce — so each session picks up exactly where the last one left off.

## The Two Workflows

### SWE (Software Engineering)

For building software across multiple sessions. The workflow moves through brainstorming → project brief → roadmap → task decomposition → structured execution → code review → milestone postmortems.

Tasks are tracked as GitHub Issues with user stories and acceptance criteria. The `/start` command enforces a test-first development process: plan → architect → write tests → implement → verify. The `/review` command runs in a separate session to provide fresh-eyes code review without implementation bias.

See the [SWE README](../skills/machinedge-workflows/workflows/swe/README.md) for full details.

### EDA (Time Series Analysis)

For multi-session exploratory data analysis on time series data. The workflow moves through intake interview → analysis brief → scope definition → hypothesis-driven task decomposition → structured analysis → methodological review → synthesis into recommendations.

What makes this different from ad-hoc analysis: every session starts by stating hypotheses *before* looking at the data, a living data profile accumulates knowledge across sessions, and domain context is dynamically generated (not templated) for the specific application area. The deliverable is a synthesis report with recommendations, not a pile of notebooks.

See the [EDA README](../skills/machinedge-workflows/workflows/eda/README.md) for full details.

## How They Compare

Both workflows share the same structural arc and differ in domain-specific details:

| Aspect | SWE | EDA |
|--------|-----|-----|
| Planning starts with | `/brainstorm` → `/vision` | `/intake` → `/brief` |
| Work is organized into | Milestones with task issues | Analysis phases with hypothesis issues |
| Execution (`/start`) | Plan → Architect → Test → Implement → Verify | Hypothesize → Design → Validate Data → Analyze → Validate Results |
| Review focus | Correctness, tests, security, consistency | Statistical validity, methodology, data handling |
| Synthesis | `/postmortem` (milestone review) | `/synthesize` (recommendations report) |
| Source of truth | `docs/project-brief.md` | `docs/analysis-brief.md` |
| Deliverables | Working software + tests | Insights report in `reports/` |

Both use GitHub Issues for task tracking, enforce approval gates during execution, and produce handoff notes at session end.

## Design Philosophy

**Documents are memory.** The AI has no memory between sessions. Every project decision, lesson learned, and session outcome is written to `docs/`. The AI reads these at the start of every session. If it's not written down, it didn't happen.

**Structured execution prevents drift.** The `/start` command enforces a 7-phase process with approval gates. The AI can't jump straight to implementation — it must first load context, present its plan, and get approval. This catches misunderstandings early.

**Fresh-eyes review catches what implementation bias misses.** The `/review` command is designed to run in a separate session. The reviewing AI has no memory of the implementation decisions, shortcuts, or compromises that led to the current code. It evaluates purely against acceptance criteria and project standards.

**Tasks are persona-centric.** GitHub Issues use user stories ("As a [persona], I need [capability] so that [value]") rather than developer-centric descriptions. Acceptance criteria describe what the end user can do or see, not internal implementation details.

**The toolkit is editor-agnostic.** Both workflows maintain a single source for rules (`editor.md`) and commands (`commands/*.md`). The setup script copies these to the appropriate locations for Claude Code (`.claude/`) and Cursor (`.cursor/`), with Cursor's YAML frontmatter auto-prepended. The `docs/` folder works identically regardless of editor.

**Distribution is built-in.** The workflows are packaged as a Claude skill (`machinedge-workflows.skill`) that can be installed in Claude Code or Cowork. Once installed, users can set up a workflow by simply asking Claude — no terminal commands, no cloning repos, no reading documentation. The skill walks them through choosing a workflow, selecting editors, and configuring the project.

## Repository Structure

```
project-workflow/
├── README.md                       ← Top-level overview
├── LICENSE                         ← Apache 2.0
├── docs/                           ← Documentation
│   ├── overview.md                 ← What this toolkit is (this file)
│   ├── getting-started.md          ← Installation and first session walkthrough
│   ├── agent-reference.md          ← Reference for AI agents
│   └── workflow-anatomy.md         ← Deep-dive on patterns and conventions
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
└── framework/                      ← Scaffolding tools for new workflows
    ├── create-workflow.sh
    ├── validate.sh
    ├── CONTRIBUTING.md
    └── templates/
```
