# MachinEdge Expert Teams

AI expert roles for structured software development. Install into your project and get a coordinated team of specialists — PM, SWE, QA, DevOps, System Architect — each with discoverable skills, structured workflows, and document-based memory.

Supports **Cursor** and **Claude Code** with platform-native implementations. Also deployable as a coordinated multi-agent team via **OpenClaw** (Docker + Matrix).

## Quick Start

### Standalone Mode (Cursor or Claude Code)

```bash
# Both editors
./targets/ide/install.sh ~/projects/my-app

# Cursor only
./targets/ide/install.sh --editor cursor ~/projects/my-app

# Claude Code only
./targets/ide/install.sh --editor claude ~/projects/my-app
```

Then open the project in your editor:
- Run `/pm-interview` to start a new project
- Run `/swe-start` to pick up an implementation task
- Run `/team-status` to see the project health summary

### Team Mode (Coordinated Experts in Docker)

```bash
# Generate Docker infrastructure for a full expert team
./targets/autonomous/openclaw/install-team.sh ~/projects/my-app

# Configure your API keys and git URL
vi ~/projects/my-app/.octeam/.env

# Start the team
cd ~/projects/my-app/.octeam && docker compose up -d

# Open Element Web to talk to the team
open http://localhost:8009
```

Each expert runs in its own container with its own git clone. Communication happens through Matrix (Conduit). You interact with the PM through Element Web.

## How It Works

### Experts

Five core experts, each with a defined role and set of skills:

| Expert | Prefix | What It Does |
|--------|--------|-------------|
| **Project Manager** | `pm-` | Interviews, scopes work, creates roadmaps, decomposes milestones, runs postmortems |
| **Software Engineer** | `swe-` | Implements tasks from issue files with test-first methodology and structured handoffs |
| **QA** | `qa-` | Reviews code, creates test plans, runs regressions, triages bugs |
| **DevOps** | `ops-` | Captures environment context, defines pipelines, plans releases, executes deployments |
| **System Architect** | `sa-` | Designs system architecture, researches technical questions, reviews implementation against intent |

A shared `team-` prefix covers cross-expert operations like project health summaries.

### Skills, Commands, and Scripts

The toolkit installs three types of files:

**Commands** (9) are explicit workflows you invoke with `/command-name`:
- Start commands (`/pm-start`, `/swe-start`, `/qa-start`, `/ops-start`, `/sa-start`) begin a session with full context loading and approval gates.
- Interactive commands (`/pm-interview`, `/pm-add-feature`, `/ops-deploy`, `/ops-env-discovery`) require back-and-forth with the user.

**Skills** (21) are discoverable by the agent. Each is a `SKILL.md` with a description the agent matches against your intent. The agent invokes them autonomously — or you can invoke them explicitly by name. Skills cover autonomous operations (vision, roadmap, review, decompose, etc.) and session handoffs.

**Scripts** (5) are hidden shell utilities for mechanical operations — issue numbering, file movement, session claiming, issues list regeneration, and atomic project brief updates. Skills call these via shell instead of reimplementing the logic.

### Documents Are Memory

Experts have no memory between sessions. All state lives in project documents:

```
docs/
  project-brief.md              # Source of truth — goals, constraints, decisions, status
  lessons-log.md                # Project-specific gotchas and patterns
  architecture.md               # System architecture and key decisions
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
5. **DevOps** handles deployment when ready
6. **System Architect** makes cross-cutting design decisions as needed
7. **PM runs a postmortem** at milestone boundaries

In standalone mode, you switch between experts across sessions. In team mode, the PM orchestrates everything — you talk to the PM, the PM delegates to the rest.

## Keeping Up to Date

After updating the toolkit repo, use the sync command to check for drift and apply updates:

```bash
# Check what's changed
./tools/sync.sh check ~/projects/my-app

# Apply updates
./tools/sync.sh apply ~/projects/my-app

# Compare Cursor and Claude Code implementations for drift (maintainers)
./tools/sync.sh diff
```

## What Gets Installed

### Cursor

```
.cursor/
  rules/          # Expert role rules (.mdc) — loaded contextually
  commands/       # 9 explicit command files
  skills/         # 21 discoverable skill folders (SKILL.md each)
  scripts/        # 5 shell scripts + PowerShell companions
```

### Claude Code

```
.claude/
  CLAUDE.md       # Shared principles + expert routing (always loaded)
  settings.json   # SessionStart hook (merged, not overwritten)
  roles/          # 5 expert role files
  commands/       # 9 explicit command files
  skills/         # 21 discoverable skill folders (SKILL.md each)
  scripts/        # 5 shell scripts + PowerShell companions + session-primer.sh
```

Claude Code has one platform advantage: a `SessionStart` hook that automatically extracts project context at the start of every session. Cursor users rely on `/start` commands for context loading.

See [Cursor README](targets/ide/cursor/README.md) and [Claude Code README](targets/ide/claude-code/README.md) for full details.

## Documentation

| Guide | Audience | Description |
|-------|----------|-------------|
| [Agent Reference](docs/agent-reference.md) | AI assistants + Contributors | How to work on this repo — building, modifying, and extending expert definitions |
| [Cursor Target](targets/ide/cursor/README.md) | Users | What's installed, how skills work, uninstall instructions for Cursor |
| [Claude Code Target](targets/ide/claude-code/README.md) | Users | What's installed, hooks, settings.json, uninstall instructions for Claude Code |
| [Docs Protocol](experts/technical/shared/docs-protocol.md) | Contributors | Cross-expert document contracts and conventions |

## Repository Structure

```
project-workflow/
├── README.md                       ← You are here
├── LICENSE                         ← Apache 2.0
├── CONTRIBUTING.md                 ← How to contribute an expert
├── docs/                           ← Documentation
│   ├── agent-reference.md          ← Reference for AI assistants working on this repo
│   ├── architecture.md             ← System architecture and key decisions
│   └── ...                         ← Project docs (brief, roadmap, test plan, etc.)
├── experts/                        ← Expert definitions (reference)
│   └── technical/
│       ├── project-manager/        ← PM: role + skills
│       ├── swe/                    ← Software engineer
│       ├── qa/                     ← Quality assurance
│       ├── devops/                 ← DevOps/deployment
│       ├── system-architect/       ← System architecture
│       ├── data-analyst/           ← Under development
│       ├── user-experience/        ← Under development
│       └── shared/                 ← Cross-expert protocols and shared skills
├── targets/                        ← All deployment targets
│   ├── ide/                        ← IDE-based (Cursor, Claude Code)
│   │   ├── install.sh / install.ps1
│   │   ├── cursor/                 ← Cursor platform-native implementation
│   │   └── claude-code/            ← Claude Code platform-native implementation
│   ├── desktop-cli/                ← Desktop/CLI environments
│   │   └── claude/                 ← Claude Desktop/Code/Cowork (.skill packaging)
│   └── autonomous/                 ← Autonomous agent frameworks
│       └── openclaw/               ← OpenClaw (Docker + Matrix)
└── tools/                          ← Repo development utilities
    ├── scaffold/                   ← Expert authoring (create-expert)
    ├── validate/                   ← Expert validation
    ├── sync.sh / sync.ps1          ← Check/apply updates to installed projects
    ├── new-repo.sh / .ps1          ← Create new project repos
    └── list-experts.sh / .ps1      ← Enumerate available experts
```

## Design Principles

**Documents are memory.** No memory between sessions. If it's not written down, it didn't happen.

**Platform-native, not translated.** Each platform (Cursor, Claude Code) has its own first-class implementation. The install script copies pre-built files directly — no translation pipeline.

**Skills are discoverable.** Most expert capabilities are agent-discovered skills, not commands you have to remember. The agent finds and invokes the right skill based on what you're doing.

**The PM leads.** In team mode, the human talks to the PM; the PM delegates to everyone else.

**On-prem first.** Single box deployment for team mode. No cloud required.

**Simplicity over features.** If setup requires more than one command, it's too complex.

## Terminology

| Term | Meaning |
|------|---------|
| **Expert** | An AI agent with a defined role, operating rules, and skills (PM, SWE, QA, DevOps, SA) |
| **Skill** | A discoverable capability the agent can invoke autonomously (e.g., handoff, review, vision) |
| **Command** | An explicit workflow the user invokes (e.g., `/swe-start`, `/pm-interview`) |
| **Script** | A hidden shell utility for mechanical operations (issue numbering, file movement) |
| **Handoff note** | Session summary written at the end of each session — the next session's memory |
| **Project brief** | Source of truth document — goals, constraints, decisions, current status |
| **Standalone mode** | Using experts in an editor (Cursor, Claude Code) |
| **Team mode** | Coordinated experts via OpenClaw, communicating through Matrix |

## Prerequisites

**Standalone mode:**
- Cursor or Claude Code
- Bash (macOS/Linux) or PowerShell (Windows)

**Team mode:**
- Docker + Docker Compose
- OpenAI-compatible API key (or any LLM provider)
- A git repo URL and token for the project
- OpenClaw ([openclaw.ai](https://openclaw.ai/))

## License

Apache 2.0 — see [LICENSE](LICENSE).
