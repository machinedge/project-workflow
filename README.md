# MachinEdge Expert Teams

Platform-agnostic expert definitions for AI development teams. Define your experts once — deploy them anywhere.

This repo contains the canonical definitions for AI experts (PM, SWE, QA, DevOps, EDA) that can be deployed as a coordinated team on the MachinEdge platform, or used standalone in **Claude Code**, **Cowork**, and **Cursor**.

## The Idea

You run a single command to spin up a full AI dev team for your project. The PM leads the team, the SWE implements, QA validates, DevOps delivers. You talk to the PM — the PM handles the rest. Experts communicate through Matrix, coordinate code through git, and each run in isolated Docker containers.

No cloud dependencies. No 50-module configuration maze. On-prem first.

## Quick Start

### Standalone Mode (Single Expert in an Editor)

Install the skill in Claude Code or Cowork and use one expert at a time:

```
# In Claude Code
claude install-skill machinedge-workflows.skill

# Then say: "Set up a software workflow for my project"
```

Or run setup directly:

```bash
# Full team setup (all experts)
./workflows/setup.sh ~/projects/my-app

# Single expert
./workflows/setup.sh --expert swe ~/projects/my-app
```

### Team Mode (Coordinated Experts in Docker)

```bash
# Generate Docker infrastructure for a full expert team
./framework/install/install-team.sh ~/projects/my-app

# Configure your API keys and git URL
vi ~/projects/my-app/.octeam/.env

# Start the team
cd ~/projects/my-app/.octeam
docker compose up -d

# Open Element Web in your browser to talk to the team
open http://localhost:8009
```

Each expert runs in its own container with its own git clone. Communication happens through Matrix (Conduit). You interact with the PM through Element Web in your browser.

## How It Works

### Expert Definitions

Each expert is defined by a `role.md` (identity + operating rules) and a `skills/` directory (structured capabilities):

```
experts/
  technical/
    project-manager/    # project manager
      role.md           # Who the PM is, what it reads/writes, how it operates
      skills/           # interview, vision, roadmap, decompose, postmortem
    swe/                # software engineer
      role.md
      skills/           # start, handoff
    qa/                 # quality assurance
      role.md
      skills/           # test-plan, review, regression
    ux/                 # user experience - under active development
      role.md           
      skills/       
    devops/             # devops
      role.md
      skills/           # env-discovery, pipeline, deploy, release-plan
    data-analyst/       # data analyst - under active development0
      role.md
      skills/           # intake, brief, scope, decompose, start, review, synthesize
```

These definitions are platform-agnostic. A translation layer generates configs for the target runtime — **OpenClaw** for team mode, **Claude Code** and **Cursor** for standalone mode.

### Team Architecture

```
┌──────────┐
│  Human   │  ← You. Talk to the PM via Element Web.
└────┬─────┘
     │  http://localhost:8009
┌────▼──────────────────────────────────┐
│         Matrix (Conduit)              │
│  Lightweight · On-prem · No federation│
└──┬────────┬────────┬────────┬────────┘
   │        │        │        │
┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐
│ PM  │ │ SWE │ │ QA  │ │DevOp│
│     │ │     │ │     │ │  s  │ ... [others]
└─────┘ └─────┘ └─────┘ └─────┘
Docker   Docker   Docker   Docker
(own     (own     (own     (own
 clone)   clone)   clone)   clone)
```

The PM is the orchestrator and the human's single point of contact. It breaks down work, delegates to experts, enforces process rigor, and pulls the human in only for reviews and approvals.

### The Skill Lifecycle

Every expert follows the same structured arc:

```
Interview → Brief → Plan → Decompose → Execute → Review → Handoff → Synthesize
```

In standalone mode, you trigger these as slash commands. In team mode, the PM triggers them on other experts. Documents accumulate in `docs/`, issues accumulate in `issues/` and serve as each expert's memory between sessions.

## Documentation

| Guide | Audience | Description |
|-------|----------|-------------|
| [Overview](docs/overview.md) | Everyone | Vision, architecture, design philosophy, platform comparisons |
| [Getting Started](docs/getting-started.md) | Users | Setup for standalone and team modes |
| [Agent Reference](docs/agent-reference.md) | AI assistants + Contributors | How to work on this repo — building, modifying, and extending expert definitions |
| [Expert Anatomy](docs/workflow-anatomy.md) | Contributors | Deep-dive on expert structure, skill patterns, translation layer |
| [Docs Protocol](experts/technical/shared/docs-protocol.md) | Contributors | Cross-expert document contracts and conventions |

## Terminology

| Term | Meaning |
|------|---------|
| **Expert** | An AI agent with a defined and limited role, operating rules, and skills (PM, SWE, QA, DevOps, EDA) |
| **`role.md`** | The expert's identity file — persona, document locations, session protocol, principles |
| **Skill** | A structured capability an expert can execute (e.g., interview, start, review, deploy) |
| **Team** | A set of coordinated experts working on a project, led by the PM |
| **Standalone mode** | Using a single expert in an editor (Claude Code, Cursor, Cowork) |
| **Team mode** | Coordinated experts on the MachinEdge platform, communicating via Matrix |

## Design Principles

**Experts are defined once, deployed anywhere.** The canonical format is platform-agnostic. Translation to specific runtimes is automated.

**The PM leads.** The human talks to the PM; the PM talks to everyone else.

**Documents are memory.** No memory between sessions. If it's not written down, it didn't happen.

**Isolation by default.** Each expert has its own container and workspace. Code via git, communication via Matrix.

**On-prem first.** Single box deployment. No cloud required.

**Simplicity over features.** If setup requires a PhD in configuration, it's failed.

## Repository Structure

```
project-workflow/
├── README.md                       ← You are here
├── LICENSE                         ← Apache 2.0
├── docs/                           ← Documentation
│   ├── overview.md                 ← Vision and architecture
│   ├── getting-started.md          ← Setup guide
│   ├── agent-reference.md          ← Reference for AI experts
│   └── workflow-anatomy.md         ← Deep-dive on expert structure
├── experts/                        ← Expert definitions
│   └── technical/                  ← Domain: technical/software development
│       ├── project-manager/        ← Orchestrator and team lead
│       │   ├── role.md
│       │   ├── skills/
│       │   └── tools/
│       ├── swe/                    ← Software engineer
│       │   ├── role.md
│       │   ├── skills/
│       │   └── tools/
│       ├── qa/                     ← Quality assurance
│       ├── devops/                 ← DevOps/deployment
│       ├── data-analyst/           ← Data analysis (under development)
│       ├── user-experience/        ← UX design (under development)
│       └── shared/                 ← Cross-expert protocols and shared skills
├── package/                        ← Build & distribution
│   ├── package.sh / package.ps1    ← Build the .skill file
│   ├── install-skill.sh / .ps1     ← Install built skill into Claude Code
│   ├── SKILL.md                    ← Skill definition for Claude Code/Cowork
│   ├── tools/                      ← Repo creation and expert listing
│   │   ├── new_repo.sh / new_repo.ps1
│   │   └── list-experts.sh / list-experts.ps1
│   └── build/                      ← Build output (gitignored)
└── framework/                      ← Setup scripts, scaffolding, validation
    ├── install/
    │   ├── install.sh / install.ps1          ← Standalone mode setup
    │   ├── install-team.sh                   ← Team mode setup (Docker)
    │   └── targets/                          ← Per-platform translation docs
    ├── scaffold/                             ← Expert authoring tools
    ├── validate/                             ← Validation (validate.sh)
    └── docs/                                 ← Framework docs
```

## Prerequisites

**Standalone mode:**
- Git + GitHub CLI (`gh`)
- Claude Code, Cursor, or Cowork
- For EDA: Python 3.10+

**Team mode:**
- Docker + Docker Compose
- OpenAI-compatible API key (or any LLM provider)
- A git repo URL and token for the project
- OpenClaw ([openclaw.ai](https://openclaw.ai/))

## License

Apache 2.0 — see [LICENSE](LICENSE).
