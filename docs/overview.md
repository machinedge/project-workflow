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

The immediate goal is a CLI-driven platform that:

- Provisions a Matrix room and Docker containers for each expert on a project
- Routes messages between experts through Matrix with the PM as team lead and orchestrator
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

Each expert is defined in a platform-agnostic format:

```
experts/
  pm/
    role.md           # Identity, operating rules, session protocols
    skills/           # Structured capabilities (interview, vision, decompose, etc.)
  swe/
    role.md
    skills/
  qa/
    role.md
    skills/
  devops/
    role.md
    skills/
  eda/
    role.md
    skills/
```

`role.md` (formerly `editor.md`) defines who the expert is: its persona, what documents it reads and produces, how it starts a session, what principles it follows. This is the single file an expert author maintains.

`skills/` (formerly `commands/`) contains the structured capabilities the expert can execute. Each skill follows a phased lifecycle with approval gates. Skills are what the PM triggers on other experts — they are not user-facing slash commands in the team context.

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

**Documents are memory.** Experts have no memory between sessions. Every decision, lesson, and session outcome is written to `docs/`. If it's not written down, it didn't happen.

**Isolation by default.** Each expert runs in its own container with its own filesystem. Code sharing happens through git, communication through Matrix. No shared mutable state.

**On-prem first.** Everything runs on your infrastructure — a single Linux box, a VM, a server in a closet. No cloud dependencies required. This isn't a preference; for the target users (industrial controls, OT, mission-critical operations), it's a requirement.

**Simplicity over features.** The platform should be understandable, debuggable, and approachable. If setting up requires understanding 50+ configuration modules, the platform has failed. Users shouldn't need to be deeply technical to get a functioning AI development team.

## Relationship to Existing Platforms

| Platform | What we take from it | What we leave behind |
|----------|---------------------|---------------------|
| **NanoClaw** | Philosophy of simplicity, container isolation model, small codebase ethos | WhatsApp coupling, single-agent-per-group limitation, skills-as-installation-modification |
| **OpenClaw** | Multi-agent routing concepts, Matrix support, skill registry ideas | Complexity, config sprawl, 50+ module architecture, inaccessible extension model |
| **Claude Code** | `.claude/commands/` pattern, CLAUDE.md conventions | Single-agent assumption, no inter-agent coordination |
| **Cursor** | Rules file conventions, `.mdc` frontmatter pattern | Single-agent assumption |

This platform is not a fork of either NanoClaw or OpenClaw. It borrows architectural ideas from both but is its own opinionated system — purpose-built for spinning up coordinated AI expert teams with minimal setup.
