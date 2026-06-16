# MachinEdge Expert Teams

AI expert roles for structured software development. Install into your project and get a coordinated team of specialists — PM, SWE, QA, DevOps, System Architect — each with discoverable skills, structured workflows, and document-based memory.

Works with **Claude Code**, **Codex**, and any harness that reads an `AGENTS.md` at the project root.

## Quick Start

```bash
# Full install (AGENTS.md flow + Claude Code wiring)
./install.sh ~/projects/my-app

# Generic only — for Codex and other AGENTS.md-only harnesses
./install.sh --no-claude ~/projects/my-app

# Windows
.\install.ps1 -Target ~\projects\my-app
```

Then open the project in your harness:
- Run `/pm-interview` to start a new project
- Run `/swe-start` to pick up an implementation task
- Ask for a "team status" to see the project health summary

## How It Works

### Experts

Six experts, each with a defined role and set of skills:

| Expert | Prefix | What It Does |
|--------|--------|-------------|
| **Project Manager** | `pm-` | Interviews, scopes work, creates roadmaps, decomposes milestones, runs postmortems |
| **Software Engineer** | `swe-` | Implements tasks from issue files with test-first methodology and structured handoffs |
| **QA** | `qa-` | Reviews code, creates test plans, runs regressions, triages bugs |
| **DevOps** | `ops-` | Captures environment context, defines pipelines, plans releases, executes deployments |
| **System Architect** | `sa-` | Designs system architecture, researches technical questions, reviews implementation against intent |
| **Security Engineer** | `sec-` | Defines security requirements and threat models, reviews implementation for vulnerabilities and authz/secrets risk |

A shared `team-` prefix covers cross-expert operations: project health summaries (`team-status`) and the full milestone lifecycle (`team-milestone`).

### Skills, Commands, and Scripts

The toolkit installs three types of files:

**Commands** (10) are explicit workflows you invoke with `/command-name`:
- Start commands (`/pm-start`, `/swe-start`, `/qa-start`, `/ops-start`, `/sa-start`, `/sec-start`) begin a session with full context loading and approval gates.
- Interactive commands (`/pm-interview`, `/pm-add-feature`, `/ops-deploy`, `/ops-env-discovery`) require back-and-forth with the user.

**Skills** (25) are discoverable by the agent. Each is a `SKILL.md` with a description the agent matches against your intent, invoked autonomously when it recognizes the right context. Skills cover autonomous operations (vision, roadmap, review, decompose, etc.), session handoffs, and the cross-expert `team-milestone` lifecycle. Under Claude Code they also surface in the `/` menu via the `.claude/skills` symlink.

**Scripts** (5) are hidden shell utilities for mechanical operations — issue numbering, file movement, session claiming, issues list regeneration, and atomic project brief updates. Skills call these via shell instead of reimplementing the logic.

**Workflows** (Claude Code) are multi-agent scripts under `workflows/`. `team-milestone`'s accelerator (`workflows/milestone.js`) runs the milestone's enrich and review phases as parallel subagents and drives a small-model implementation loop. Other harnesses run the portable `team-milestone` runbook sequentially.

### Documents Are Memory

Experts have no memory between sessions. All state lives in project documents:

```
docs/
  project-brief.md              # Source of truth — goals, constraints, decisions, status
  architecture.md               # System architecture and key decisions
  roadmap.md                    # Milestone plan
.workflow/
  lessons-log.md                # Project-specific gotchas and patterns
  handoff-notes/                # What each expert accomplished per session
    pm/ swe/ qa/ devops/ system-architect/
  issues/
    backlog/ planned/ in-progress/ done/
```

The PM creates the project brief and roadmap. SWE picks up issues and produces handoff notes. QA reviews and files bugs. Each expert reads the previous session's handoff note to resume where the last session left off.

### The Workflow

```
Interview → Brief → Roadmap → Decompose → Execute → Review → Handoff
```

1. **PM interviews** the user to understand the project (`/pm-interview`)
2. **PM generates** the project brief, roadmap, and task issues
3. **SWE picks up** an issue (`/swe-start`), implements with tests, produces a handoff note
4. **QA reviews** the implementation, files bugs if needed
5. **Security Engineer** sets security requirements and gates the close-out review
6. **DevOps** handles deployment when ready
7. **System Architect** makes cross-cutting design decisions as needed
8. **PM runs a postmortem** at milestone boundaries

Or hand off a whole milestone to **`team-milestone`**, which chains these into one gated lifecycle — enrich (SA + Security + QA + DevOps) → compile implementation-ready tasks → implement + verify → close-out review.

## What Gets Installed

```
AGENTS.md           # The operating-system file — expert routing + conventions.
                    #   Read by Codex and any AGENTS.md-aware harness.
CLAUDE.md → AGENTS.md   # Symlink, so Claude Code reads the same file.
.agents/            # The toolkit payload — one generic copy:
  roles/            #   6 expert role files
  commands/         #   10 explicit command files
  skills/           #   25 discoverable skill folders (SKILL.md each)
  scripts/          #   5 shell scripts + PowerShell companions + session-primer.sh
  workflows/        #   Claude Code multi-agent workflow scripts (.js)
.claude/            # Claude Code wiring (skipped with --no-claude):
  commands → ../.agents/commands   # symlink — native /command discovery
  skills   → ../.agents/skills     # symlink — native skill discovery
  roles    → ../.agents/roles      # symlink
  scripts  → ../.agents/scripts    # symlink
  workflows → ../.agents/workflows # symlink — Workflow tool named-workflow discovery
  settings.json     # SessionStart hook (merged, not overwritten)
docs/               # Core planning docs (created)
.workflow/          # Managed artifacts — issues, handoff notes, lessons log
```

One `.agents/` payload feeds both flows: AGENTS.md-aware harnesses read `AGENTS.md` + `.agents/` directly; Claude Code additionally gets native slash-command and skill discovery plus a `SessionStart` hook that extracts project context at the start of every session. On Windows, the installer falls back to copies when symlinks aren't available (enable Developer Mode for symlinks).

## Repository Structure

```
project-workflow/
├── README.md                       ← You are here
├── LICENSE                         ← Apache 2.0
├── CONTRIBUTING.md                 ← How to contribute
├── install.sh / install.ps1        ← Installer (copies agents/ into a project)
├── agents/                         ← Single source of truth
│   ├── AGENTS.md                   ← Operating-system file
│   ├── roles/  commands/  skills/  scripts/  workflows/
│   └── settings.json               ← Claude SessionStart hook
└── docs/                           ← Documentation
    ├── agent-reference.md          ← Reference for AI assistants working on this repo
    ├── architecture.md             ← System architecture and key decisions
    └── ...                         ← Project docs (brief, roadmap, test plan, etc.)
```

## Documentation

| Guide | Audience | Description |
|-------|----------|-------------|
| [Agent Reference](docs/agent-reference.md) | AI assistants + Contributors | How to work on this repo |
| [Architecture](docs/architecture.md) | Contributors | System architecture and key decisions |
| [Contributing](CONTRIBUTING.md) | Contributors | How to contribute |

## Design Principles

**Documents are memory.** No memory between sessions. If it's not written down, it didn't happen.

**One generic source, harness-neutral.** A single `agents/` payload drives every target. The installer copies it to `.agents/` and wires `AGENTS.md` (+ a `CLAUDE.md` symlink and optional `.claude/` symlinks) — no per-platform forks, no translation pipeline.

**Skills are discoverable.** Most expert capabilities are agent-discovered skills, not commands you have to remember. The agent finds and invokes the right skill based on what you're doing.

**Simplicity over features.** If setup requires more than one command, it's too complex.

## Terminology

| Term | Meaning |
|------|---------|
| **Expert** | An AI agent with a defined role, operating rules, and skills (PM, SWE, QA, DevOps, SA, Security) |
| **Skill** | A discoverable capability the agent can invoke autonomously (e.g., handoff, review, vision) |
| **Command** | An explicit workflow the user invokes (e.g., `/swe-start`, `/pm-interview`) |
| **Script** | A hidden shell utility for mechanical operations (issue numbering, file movement) |
| **Handoff note** | Session summary written at the end of each session — the next session's memory |
| **Project brief** | Source of truth document — goals, constraints, decisions, current status |

## Prerequisites

- Claude Code, Codex, or another harness that reads `AGENTS.md`
- Bash (macOS/Linux) or PowerShell (Windows)

## License

Apache 2.0 — see [LICENSE](LICENSE).
