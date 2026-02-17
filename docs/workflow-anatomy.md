# Expert Anatomy

This document is a deep-dive reference for contributors who want to understand, modify, or create experts. It explains every structural pattern, how the pieces connect, and why each convention exists.

If you just want to create a new expert quickly, start with [CONTRIBUTING.md](../framework/docs/CONTRIBUTING.md) and the scaffold script. Come back here when you need to understand *why* things work the way they do.

Note: Expert definitions live in `experts/<domain>/` (e.g., `experts/technical/swe/`). Experts are organized by domain — `technical` for software development teams, with future domains like `business`, `operations`, etc. This document uses relative references like `skills/*.md` and `role.md` — these refer to files within an expert directory (e.g., `experts/technical/swe/`).

## Terminology

This project has evolved its terminology. Here's the mapping:

| Old Term | New Term | Rationale |
|----------|----------|-----------|
| Workflow | Expert | An expert is a role with skills, not just a process |
| `editor.md` | `role.md` | Platform-neutral; describes who the agent is, not which editor it runs in |
| `commands/` | `skills/` | Aligns with NanoClaw and OpenClaw conventions; skills are capabilities, not just slash commands |
| Slash commands | Skills | In team mode, the PM triggers skills on other experts — they aren't user-invoked commands |
| `pm/` | `project-manager/` | More explicit naming |
| `eda/` | `data-analyst/` | More explicit naming |
| issues | `issues/` directory | In-repo issue tracking — no external service dependency |

## The Big Picture

Every expert in this repo follows the same lifecycle arc:

```
Interview → Brief → Plan → Decompose → Execute → Review → Handoff → Synthesize
```

This maps to 8 skills. The skills are not independent — they form a chain where each skill's output becomes the next skill's input. Documents accumulate in `docs/` and serve as the expert's memory between sessions.

### Standalone vs. Team Context

In **standalone mode** (single expert in an editor), the human triggers skills directly as slash commands. The human is the orchestrator.

In **team mode** (coordinated experts on the MachinEdge platform), the PM expert triggers skills on other experts through Matrix messages. The human interacts with the PM; the PM orchestrates the team. Skills become internal team operations rather than user-facing commands.

The skill definitions are identical in both modes. The difference is who triggers them and how.

## The 8-Skill Lifecycle

Each expert defines up to 8 skills that cover the full project lifecycle. They fall into four groups:

### Planning Skills (run once or rarely)

| Slot | Project Manager | SWE | QA | DevOps | Data Analyst | Purpose |
|------|-----------------|-----|-----|--------|--------------|---------|
| Interview | `/interview` | — | — | — | `/intake` | Pull context from the human via structured interview |
| Brief | `/vision` | — | — | — | `/brief` | Synthesize notes into source-of-truth document |
| Plan | `/roadmap` | — | `/test-plan` | `/release-plan` | `/scope` | Define work structure |
| Decompose | `/decompose` | — | — | — | `/decompose` | Break work into session-sized issues |

### Execution Skills (run per task)

| Slot | Command | Purpose |
|------|---------|---------|
| Execute | `/start #N` | Load context, run structured multi-phase work session against a issue |
| Handoff | `/handoff` | Close the session, produce handoff note, update the brief |

### Review Skills (run periodically)

| Slot | Project Manager | SWE | QA | Data Analyst | Purpose |
|------|-----------------|-----|-----|--------------|---------|
| Review | — | — | `/review` | `/review` | Fresh-eyes evaluation in a separate session |
| Synthesis | `/postmortem` | — | `/regression` | `/synthesize` | Phase-level reflection or final deliverable |

### Not All Experts Need All 8 Slots

The project manager is the primary planning expert — it owns interview, brief, plan, and decompose. SWE, QA, and DevOps focus on execution and their domain-specific planning (test plans, release plans, etc.). An expert only needs the skills relevant to its role.

## How Skills Chain Together

Skills form a dependency chain through the documents they produce and consume:

```
/interview ──produces──→ docs/interview-notes.md
                              │
/brief ──────reads────────────┘──produces──→ docs/brief.md (source of truth)
                                                  │
/plan ───────reads────────────────────────────────┘──produces──→ docs/plan.md
                                                                      │
/decompose ──reads────────────────────────────────────────────────────┘──produces──→ issues
                                                                                        │
/start ──────reads brief + lessons + issue + last handoff─────────────────────────────────┘
      │
      └──produces──→ work products + updated docs
                          │
/handoff ─────reads───────┘──produces──→ docs/handoff-notes/<expert>/session-NN.md
                                              │
/review ──────reads work products─────────────┘──produces──→ new issues (findings)
                                                                   │
/synthesis ───reads all handoff notes + work products──────────────┘──produces──→ final report
```

The key insight: **every skill reads documents produced by earlier skills.** There is no state carried in memory — documents are the only communication channel between sessions.

### Cross-Expert Document Flow

In team mode, the document chain spans experts:

```
PM /interview → PM /vision → PM /roadmap → PM /decompose
                                                    │
                              ┌──────────────────────┘
                              │
                    SWE /start #N → SWE /handoff
                              │            │
                              │      QA /review #N → QA /handoff
                              │                           │
                              │                 DevOps /deploy → DevOps /handoff
                              │                                        │
                              └────────────────────────────────────────┘
                                                    │
                                              PM /postmortem
```

All experts read from and write to the shared `docs/` directory. The PM reads everyone's handoff notes to maintain project awareness.

## Anatomy of a Skill File

Every skill file (`skills/*.md`) follows this structure:

### 1. Opening Context (1-2 lines)

A sentence describing what is happening and why this skill exists. If the skill accepts arguments, reference `$ARGUMENTS`.

```markdown
The user is starting a new project and needs help pulling ideas out of their head.

If the user provided a description: $ARGUMENTS
```

### 2. Steps or Phases (the body)

The main work, organized as numbered steps or phases. Each phase should be self-contained enough that the expert knows exactly what to do.

For simple skills (interview, brief), these are sequential steps:
```markdown
Interview them about this project, one category at a time, in this order:

1. **Problem** — What problem does this solve?
2. **Audience** — Who specifically is this for?
...
```

For complex skills (execute), these are formal phases with separators:
```markdown
## Phase 1: Load Context
Read these files automatically...

---

## Phase 2: Plan the Approach
Before writing any code, present a short plan...
```

### 3. Approval Gates

Explicit "wait for confirmation" statements at decision points. These prevent the expert from charging ahead with a wrong approach.

```markdown
Present the architecture to the user. Wait for approval before writing implementation code.
```

In standalone mode, the "user" is the human. In team mode, approval may come from the PM or from the human (depending on the gate's importance).

### 4. Output Specification

What gets produced, where it goes, and in what format. Always include explicit file paths.

```markdown
Save the summary to `docs/brainstorm-notes.md`.
```

### 5. Rules Section

Bullet-point constraints that the expert must enforce. These handle edge cases and prevent common failure modes.

```markdown
Rules:
- Ask questions one-at-a-time per category, then WAIT for answers before moving on.
- If an answer is vague, push back and ask for specifics.
- Keep the brief under 1,000 words.
```

## The `/start` Skill: 7-Phase Execution

The `/start` skill is the most important and most structured skill. It enforces a 7-phase process:

| Phase | Purpose | Approval Gate? |
|-------|---------|---------------|
| 1. Load Context | Read all relevant documents | No (automatic) |
| 2. Plan / Hypothesize | State the approach or expectations | **Yes** |
| 3. Design / Architect | Design the solution or analysis | **Yes** |
| 4. Test / Validate Inputs | Write tests or validate data quality | No |
| 5. Implement / Analyze | Do the actual work | No |
| 6. Verify / Validate Results | Check the work against criteria | No |
| 7. Report | Summarize and prompt for `/handoff` | No |

The phase names change by domain (SWE uses "Test First" and "Implement"; EDA uses "Validate Data" and "Analyze"), but the structure is constant. Phases 2-3 have approval gates; phases 4-6 flow continuously.

### Phase 1: Load Context (Universal Pattern)

Every `/start` skill begins by reading documents in a specific order:
1. The source-of-truth brief (always first, always required)
2. Domain-specific context documents (if any)
3. The lessons log
4. The GitHub issue for this task
5. The most recent handoff note for this expert

After reading, the expert confirms understanding with a brief summary and waits for confirmation before proceeding.

### Customizing the Phases

When creating a new expert, you can rename phases and adjust their content, but preserve the structure:

- **Phase 1** always loads context. Don't skip this.
- **Phases 2-3** always involve planning and get approval gates.
- **Phase 4** is preparation/validation — the step before the main work.
- **Phase 5** is the main work.
- **Phase 6** is verification.
- **Phase 7** is reporting and prompting for handoff.

## The Document-as-Memory System

### Core Principle

Experts have no memory between sessions. Documents in `docs/` are their only memory. If something isn't written down, it doesn't exist for the next session.

### Document Types

Every project needs these document types:

| Type | Example | Purpose | Update Frequency |
|------|---------|---------|-----------------|
| **Brief** | `project-brief.md` | Source of truth — goals, constraints, decisions, status | Every `/handoff` |
| **Plan** | `roadmap.md` | Work structure — milestones/phases, dependencies, risks | At milestones |
| **Lessons Log** | `lessons-log.md` | Accumulated gotchas, patterns, domain knowledge | Any session |
| **Handoff Notes** | `handoff-notes/<expert>/session-NN.md` | What happened each session, per expert | Every `/handoff` |
| **Interview Notes** | `interview-notes.md` | Raw interview output | Once (at start) |

Domain-specific experts add their own documents. EDA adds `domain-context.md` and `data-profile.md`. QA adds `test-plan.md`. DevOps adds `env-context.md` and `release-plan.md`.

### In-Repo Issue Tracking

Issues are tracked as files in the `issues/` directory within the project repo itself, rather than relying on an external service like GitHub Issues. This keeps everything self-contained and works in disconnected/on-prem environments. The project manager manages the issue lifecycle — creating, assigning, updating status, and closing issues. All experts can read issues; the project manager is the primary author.

### Cross-Expert Document Contracts

See `experts/technical/shared/docs-protocol.md` for the full producer/consumer matrix. The key principle: every expert can read all documents, but each expert writes only to its own handoff notes subdirectory and its own domain-specific documents.

## The `tools/` Directory

Each expert has a `tools/` directory for executable scripts specific to that expert's role. Unlike skills (which are LLM-executed markdown instructions), tools are scripts that extend the expert's capabilities:

- **project-manager** has `new_repo.sh` / `new_repo.ps1` — only the PM can create new repositories
- Other experts have empty `tools/` directories (with `.gitkeep`) ready for custom tooling
- **shared** has a `tools/` directory for scripts available to all experts

Tools enforce capability boundaries between experts — an SWE cannot create repos, a QA cannot deploy, etc.

## The `role.md` File

`role.md` (formerly `editor.md`) is the operating rules file — the expert reads it at every session start. In standalone mode, it gets copied to `.claude/CLAUDE.md` and `.cursor/rules/{name}.mdc` by the setup script. In team mode, it gets injected into the expert's container as part of static configuration generation.

### Required Sections

| Section | Purpose |
|---------|---------|
| **Title** | "X Operating System" — tells the expert what role this is |
| **Document Locations** | Table listing every document, its path, and its purpose |
| **Session Protocol** | What to read at start, do during, and produce at end |
| **Skills** | List of available skills with 1-line descriptions |
| **Principles** | Non-negotiable behavioral rules (5-10 bullets) |

### Optional Sections

| Section | Purpose |
|---------|---------|
| **Opinionated Stack** | Prescribed tools/libraries for the domain |
| **Work Product Locations** | Where non-document outputs live (notebooks, reports, etc.) |

### The Principles Section

Every expert should include these universal principles:

- "You have no memory between sessions. These documents ARE your memory. Trust them."
- "The [brief] is the source of truth. If something contradicts it, ask the user."
- "Decisions made in previous sessions are recorded in the [brief]. Don't re-litigate them unless asked."
- "Keep the [brief] under 1,000 words."
- "Every task includes verification."

Add domain-specific principles as needed.

## The Translation Layer

The expert definitions in this repo are platform-agnostic. A translation layer converts them to platform-specific configurations. The MVP targets **OpenClaw** for team mode and **Claude Code / Cursor** for standalone mode.

| Target Platform | `role.md` becomes | `skills/` become | `tools/` become |
|-----------------|-------------------|-----------------|-----------------|
| **OpenClaw** (MVP team mode) | Workspace `AGENTS.md` | `skills/*/SKILL.md` (with YAML frontmatter) | In workspace |
| Claude Code (standalone) | `.claude/CLAUDE.md` | `.claude/commands/*.md` | Copied to project |
| Cursor (standalone) | `.cursor/rules/{name}.mdc` (with YAML frontmatter) | `.cursor/commands/*.md` | Copied to project |
| NanoClaw (future) | `groups/{name}/CLAUDE.md` | `.claude/skills/*.md` (with YAML frontmatter) | Mounted into container |

The translation is automated and maintained by MachinEdge. Expert authors write `role.md` and `skills/*.md` in the canonical format; the translation handles the rest.

### OpenClaw Translation (Team Mode)

For team mode, each expert becomes an OpenClaw agent with its own workspace. The translation generates:

- **`AGENTS.md`** from `role.md` — injected into the agent's workspace as the system prompt
- **`SKILL.md` files** from each skill in `skills/` — with YAML frontmatter (`name`, `description`)
- **Agent routing bindings** — configuring which expert responds to which message patterns
- **Workspace isolation** — each expert gets its own `agentDir` and session store

OpenClaw's multi-agent routing handles the message flow between experts via Matrix. The project manager agent gets moderator-level permissions; other experts get standard permissions.

```yaml
# Example SKILL.md frontmatter (generated by translation layer)
---
name: start
description: "Load context and execute a structured work session against an issue"
---
```

### Cursor-Specific Translation (Standalone Mode)

Cursor requires YAML frontmatter on rules files:
```yaml
---
description: [1-line description of the expert]
alwaysApply: true
---
```

## How to Customize

### Creating a New Expert

```bash
# Scaffold a new expert from templates (specify domain)
./framework/scaffold/create-expert.sh --domain technical maintenance-planner

# Customize the generated files, then validate
./framework/validate/validate.sh technical/maintenance-planner
```

The scaffold generates a complete expert skeleton — `role.md`, `skills/` directory, `tools/` directory, and a README — pre-populated with structural patterns and guidance comments. The expert is created under `experts/<domain>/<name>/`.

### Adding a Phase to `/start`

Insert a new `## Phase N:` section between existing phases. Update the phase numbers of subsequent phases. If the new phase needs an approval gate, add an explicit "Wait for confirmation" statement.

### Adding a New Document Type

1. Add the document to the `role.md` Document Locations table
2. Add it to the session protocol (when to read it, when to update it)
3. Update the `/start` Phase 1 context loading to include it
4. Update `/handoff` to maintain it if needed
5. Update `experts/shared/docs-protocol.md` with the new producer/consumer relationship

### Adding Domain-Specific Tooling

Add an "Opinionated Stack" section to `role.md`. List the tools/libraries the expert prescribes. The setup script can create a `pyproject.toml`, `package.json`, or equivalent with these pre-configured.
