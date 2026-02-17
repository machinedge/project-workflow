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

### Team Mode (Coordinated Experts)

> **Status:** Under active development.

```bash
# cd into the project directory of your choice
cd my-project
# Spin up a full dev team for a project
machinedge init software

# Opens a Matrix room with PM, SWE, QA, DevOps
# Talk to the PM to get started
```

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

These definitions are platform-agnostic. A translation layer generates configs for the target runtime — Claude Code, Cursor, NanoClaw, OpenClaw, or MachinEdge's own platform.

### Team Architecture

```
┌──────────┐
│  Human   │  ← You. Talk to the PM.
└────┬─────┘
     │
┌────▼──────────────────────────────────┐
│         Matrix (Dendrite)             │
│  Routing · Security · Audit trails   │
└──┬────────┬────────┬────────┬────────┘
   │        │        │        │
┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐
│ PM  │ │ SWE │ │ QA  │ │DevOp│
│     │ │     │ │     │ │  s  │ ... [others]
└─────┘ └─────┘ └─────┘ └─────┘
Docker   Docker   Docker   Docker
   │        │        │        │
   └────────┴────────┴────────┘
            Shared Git Repo
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
| [Agent Reference](docs/agent-reference.md) | AI agents | How experts orient themselves, read documents, and execute skills |
| [Expert Anatomy](docs/workflow-anatomy.md) | Contributors | Deep-dive on expert structure, skill patterns, translation layer |
| [Docs Protocol](workflows/shared/docs-protocol.md) | Contributors | Cross-expert document contracts and conventions |

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
├── experts/                        ← Expert definitions (current location)
│   ├── pm/                         ← Product/project manager
│   │   ├── role.md                 ← Operating rules (→ role.md)
│   │   └── skills/                 ← Skills (→ skills/)
│   ├── swe/                        ← Software engineer
│   ├── qa/                         ← Quality assurance
│   ├── devops/                     ← DevOps/deployment
│   ├── eda/                        ← Exploratory data analysis
│   └── shared/                     ← Cross-expert protocols
├── skills/
│   └── machinedge-workflows/       ← Distributable skill package
├── build/                          ← Build tooling
└── framework/                      ← Scaffolding for new experts
    ├── create-workflow.sh
    ├── validate.sh
    ├── CONTRIBUTING.md
    └── templates/
```

> **Note:** The repo is in a transition period. Expert definitions currently live in `workflows/` with `editor.md` and `commands/` naming. These will migrate to `experts/` with `role.md` and `skills/` naming in a future release. The documentation reflects the target state.

## Prerequisites

**Standalone mode:**
- Git + GitHub CLI (`gh`)
- Claude Code, Cursor, or Cowork
- For EDA: Python 3.10+

**Team mode (coming):**
- Docker + Docker Compose
- OpenAI API key

## License

Apache 2.0 — see [LICENSE](LICENSE).
