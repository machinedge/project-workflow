# Overview

## What This Is

This repository defines a platform-agnostic expert definition format for AI development teams. Each expert (PM, SWE, QA, DevOps, EDA) is defined by a `role.md` file that specifies its identity, operating rules, and session protocols, along with a `skills/` directory containing the structured capabilities the expert can execute.

These definitions are the canonical source of truth — they are not tied to any specific runtime platform. A translation layer (maintained by MachinEdge) generates platform-specific configurations from these definitions, targeting runtimes like NanoClaw, OpenClaw, Claude Code, Cursor, or MachinEdge's own container-based platform.

## The Problem

Building and maintaining bespoke software solutions doesn't scale when one person is switching between roles — PM, engineer, QA, DevOps — session by session. The current generation of AI agent platforms (OpenClaw, NanoClaw, Claude Code) each solve pieces of this, but none provide a complete, simple, on-prem-first solution for spinning up a coordinated AI development team.

OpenClaw has the features (multi-agent routing, Matrix support, 12+ messaging channels) but is complex and difficult to extend without deep technical investment. NanoClaw has the right philosophy (simple, container-isolated, small codebase) but lacks multi-agent coordination and is coupled to WhatsApp. Neither provides a turnkey way to say "give me a dev team for this project" and have it just work.

## The Vision

A user runs a single CLI command to spin up a dedicated AI development team for a project. That team consists of expert agents — PM, SWE, QA, DevOps — each running in its own Docker container with an isolated workspace. They coordinate through Matrix rooms: one shared project room where the human can observe and participate, with the PM agent leading the team.

The human interacts primarily with the PM. They describe a feature, report a bug, or get interviewed for a new product vision. The PM breaks down the work, delegates to the right experts, enforces process rigor, and pulls the human in only for reviews and approvals. Agents share code through git, working on branches in isolated workspaces — just like a real development team.

### Today (MVP)

The MVP uses **OpenClaw** as the agent infrastructure runtime. OpenClaw provides the gateway, multi-agent routing, Matrix integration, and container isolation out of the box. MachinEdge's contribution is the opinionated expert definitions and the translation layer that converts them into OpenClaw workspaces, agent configs, and skill files — so users don't need to understand OpenClaw's internals.

The immediate goal is a CLI-driven platform that:

- Translates expert definitions into OpenClaw agent configurations
- Provisions a Matrix room and OpenClaw agent workspaces for each expert on a project
- Routes messages between experts through Matrix with the project manager as team lead and orchestrator
- Deploys on a single Linux box or small set of VMs (on-prem first)
- Uses the OpenAI API for the LLM layer
- Generates static, debuggable configuration from the canonical expert definitions

### Tomorrow

The platform evolves toward:

- A chat-based interface where users describe the team they need and it gets provisioned automatically (a "team factory")
- Local/on-prem LLM support for disconnected ("blackout") operations
- Domain-specific expert teams beyond software development — OT maintenance, industrial controls, operations management
- Full lifecycle product development and maintenance infrastructure

## The Expert Definitions

Each expert is defined in a platform-agnostic format, organized by domain:

```
experts/
  technical/                    # Domain: technical/software development
    project-manager/            # Orchestrator and team lead
      role.md                   # Identity, operating rules, session protocols
      skills/                   # interview, vision, roadmap, decompose, postmortem
      tools/                    # Expert-specific scripts
    swe/                        # Software engineer
      role.md
      skills/                   # start, handoff
      tools/
    qa/                         # Quality assurance
      role.md
      skills/                   # test-plan, review, regression, bug-triage
      tools/
    devops/                     # DevOps/deployment
      role.md
      skills/                   # env-discovery, pipeline, deploy, release-plan
      tools/
    data-analyst/               # Data analysis (under development)
      role.md
      skills/                   # intake, brief, scope, decompose, start, review, synthesize
      tools/
    user-experience/            # UX design (under development)
      role.md
      skills/
      tools/
    shared/                     # Cross-expert protocols and shared skills
      docs-protocol.md
      skills/
      tools/
```

The domain hierarchy (`technical/`, and eventually `business/`, `operations/`, etc.) allows expert definitions to be grouped by the type of team they belong to. A software project spins up a `technical` team; a future OT maintenance project might spin up an `operations` team with different experts.

Each expert directory contains three things:

`role.md` defines who the expert is: its persona, what documents it reads and produces, how it starts a session, what principles it follows. This is the single file an expert author maintains.

`skills/` contains the structured capabilities the expert can execute. Each skill follows a phased lifecycle with approval gates. Skills are what the PM triggers on other experts — they are not user-facing slash commands in the team context.

`tools/` contains expert-specific scripts and tooling. Unlike skills (which are LLM-executed markdown instructions), tools are executable scripts that only that expert has access to. Shared tooling (like `new_repo.sh` and `list-experts.sh`) lives in `package/tools/`.

This format is deliberately platform-agnostic. The same expert definition can be translated into:

- A NanoClaw `CLAUDE.md` + `.claude/skills/` structure
- An OpenClaw `AGENTS.md` + workspace + `SKILL.md` files
- A Claude Code `.claude/CLAUDE.md` + `.claude/commands/` structure
- A Cursor `.cursor/rules/*.mdc` + `.cursor/commands/` structure
- MachinEdge's own container-based runtime configuration

The translation is MachinEdge's responsibility, not the user's.

## How Experts Collaborate

### The PM as Orchestrator

The PM expert is the team lead. It is the human's single point of contact and the orchestrator for all other experts. In the team context, the PM:

- Receives feature requests, bug reports, and product vision from the human
- Breaks work into tasks and delegates to the right expert
- Triggers skills on other experts (e.g., telling SWE to `/start` on an issue)
- Reviews handoff notes from all experts to maintain project awareness
- Enforces process rigor and pushes back on incomplete or sloppy work
- Pulls the human in only when approval or input is needed

The PM's "challenging" personality is intentional — it enforces boundaries, demands rigor, and prevents scope creep. This is not a friendly dispatcher; it is a quality gate.

### Communication via Matrix

All inter-expert communication flows through Matrix:

- One shared project room where all experts and the human participate
- The human can monitor all activity, interject at any point, or step back entirely
- Message routing rules control which expert responds to what
- Security policy enforcement and audit trails are built into the messaging layer
- The messaging system has routing intelligence — it knows that "implementation complete, ready for review" should involve QA

### Code Coordination via Git

Each expert works in its own isolated workspace (container filesystem) but shares code through git:

- Each expert works on branches, commits are atomic and attributable
- Pull requests are the natural review surface for both PM and human approval
- Merge conflicts become explicit rather than silent corruption
- The PM manages branching strategy, branch assignment, and merge authority

## Architecture

```
┌──────────┐
│  Human   │
└────┬─────┘
     │ (Matrix client / CLI)
     │
┌────▼──────────────────────────────────────────┐
│              Matrix Homeserver                 │
│  (Dendrite — lightweight, on-prem)            │
│                                                │
│  Routing rules · Security policies · Audit    │
└──┬────────┬────────┬────────┬────────┬────────┘
   │        │        │        │        │
┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐ ┌──▼──┐
│ PM  │ │ SWE │ │ QA  │ │DevOp│ │ EDA │
│     │ │     │ │     │ │     │ │     │
│role │ │role │ │role │ │role │ │role │
│.md  │ │.md  │ │.md  │ │.md  │ │.md  │
│     │ │     │ │     │ │     │ │     │
│skill│ │skill│ │skill│ │skill│ │skill│
│s/   │ │s/   │ │s/   │ │s/   │ │s/   │
└─────┘ └─────┘ └─────┘ └─────┘ └─────┘
Docker   Docker   Docker   Docker   Docker
container container container container container
   │        │        │        │        │
   └────────┴────────┴────────┴────────┘
              Shared Git Repo
              (branch-per-expert)
```

## Design Philosophy

**Experts are defined once, deployed anywhere.** The canonical `role.md` + `skills/` format is platform-agnostic. Translation to specific runtimes is automated and maintained by MachinEdge.

**The PM leads the team.** The human talks to the PM; the PM talks to everyone else. This mirrors how real project teams work and keeps the human focused on the "what" and "why" rather than orchestrating AI agents.

**Documents and issues are memory.** Experts have no memory between sessions. Every decision, lesson, and session outcome is written to `docs/`. Task tracking lives in `issues/` within the repo itself — no external service required. The PM manages issue lifecycle. If it's not written down, it didn't happen.

**Isolation by default.** Each expert runs in its own container with its own filesystem. Code sharing happens through git, communication through Matrix. No shared mutable state.

**On-prem first.** Everything runs on your infrastructure — a single Linux box, a VM, a server in a closet. No cloud dependencies required. This isn't a preference; for the target users (industrial controls, OT, mission-critical operations), it's a requirement.

**Simplicity over features.** The platform should be understandable, debuggable, and approachable. If setting up requires understanding 50+ configuration modules, the platform has failed. Users shouldn't need to be deeply technical to get a functioning AI development team.

## Relationship to Existing Platforms

### OpenClaw (MVP Runtime)

OpenClaw is the agent infrastructure for the MVP. It provides the gateway, multi-agent routing via bindings, Matrix channel support, container isolation, and the `AGENTS.md` / `SKILL.md` / workspace conventions. MachinEdge doesn't fork OpenClaw — it sits on top of it, translating our expert definitions into OpenClaw's expected format and providing an opinionated setup experience that hides OpenClaw's complexity from the user.

What we use from OpenClaw: the gateway architecture, multi-agent routing, Matrix integration, workspace isolation, skill registry conventions, and the agent execution runtime.

What we abstract away: the configuration sprawl, manual agent/binding setup, the 50+ module codebase, and the learning curve. Our users interact with `machinedge init`, not `openclaw gateway` and manual YAML editing.

### Other Platforms

| Platform | What we take from it | What we leave behind |
|----------|---------------------|---------------------|
| **NanoClaw** | Philosophy of simplicity, container isolation model, small codebase ethos (design inspiration, not runtime dependency) | WhatsApp coupling, single-agent-per-group limitation, skills-as-installation-modification |
| **Claude Code** | `.claude/commands/` pattern, CLAUDE.md conventions (standalone mode) | Single-agent assumption, no inter-agent coordination |
| **Cursor** | Rules file conventions, `.mdc` frontmatter pattern (standalone mode) | Single-agent assumption |

The expert definitions in this repo are platform-agnostic by design. OpenClaw is the MVP runtime, but the translation layer can target other platforms (Claude Code, Cursor, NanoClaw) for standalone mode or future runtime changes.
