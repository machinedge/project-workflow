# Workflow Anatomy

This document is a deep-dive reference for contributors who want to understand, modify, or create workflows. It explains every structural pattern, how the pieces connect, and why each convention exists.

If you just want to create a new workflow quickly, start with [CONTRIBUTING.md](../framework/CONTRIBUTING.md) and the scaffold script. Come back here when you need to understand *why* things work the way they do.

## The Big Picture

Every workflow in this repo follows the same arc:

```
Interview → Brief → Plan → Decompose → Execute → Review → Handoff → Synthesize
```

This maps to 8 slash commands. The commands are not independent — they form a chain where each command's output becomes the next command's input. Documents accumulate in `docs/` and serve as the AI's memory between sessions.

## The 8-Command Lifecycle

Each workflow defines 8 commands that cover the full project lifecycle. They fall into four groups:

### Planning Commands (run once or rarely)

| Slot | SWE Example | EDA Example | Purpose |
|------|-------------|-------------|---------|
| Interview | `/brainstorm` | `/intake` | Pull context from the user's head via structured interview |
| Brief | `/vision` | `/brief` | Synthesize interview notes into a concise source-of-truth document |
| Plan | `/roadmap` | `/scope` | Define the work structure (milestones, phases, dependencies, risks) |
| Decompose | `/decompose` | `/decompose` | Break a work unit into session-sized GitHub Issues |

### Execution Commands (run per task)

| Slot | Command | Purpose |
|------|---------|---------|
| Execute | `/start #N` | Load context, run a structured multi-phase work session against a GitHub Issue |
| Handoff | `/handoff` | Close the session, produce a handoff note, update the brief |

### Review Commands (run periodically)

| Slot | SWE Example | EDA Example | Purpose |
|------|-------------|-------------|---------|
| Review | `/review` | `/review` | Fresh-eyes evaluation in a separate session |
| Synthesis | `/postmortem` | `/synthesize` | Milestone/phase-level reflection or final deliverable |

### Which Commands Are Required?

All 8 slots should have a command. The *interview*, *brief*, *execute*, and *handoff* commands are essential — without them, the workflow can't function. The *plan*, *decompose*, *review*, and *synthesis* commands can be simpler for lightweight workflows, but should still exist.

## How Commands Chain Together

Commands form a dependency chain through the documents they produce and consume:

```
/interview ──produces──→ docs/interview-notes.md
                              │
/brief ──────reads────────────┘──produces──→ docs/brief.md (source of truth)
                                                  │
/plan ───────reads────────────────────────────────┘──produces──→ docs/plan.md
                                                                      │
/decompose ──reads────────────────────────────────────────────────────┘──produces──→ GitHub Issues
                                                                                        │
/start ──────reads brief + lessons + issue + last handoff─────────────────────────────────┘
      │
      └──produces──→ work products + updated docs
                          │
/handoff ─────reads───────┘──produces──→ docs/handoff-notes/session-NN.md
                                              │
/review ──────reads work products─────────────┘──produces──→ new GitHub Issues (findings)
                                                                   │
/synthesis ───reads all handoff notes + work products──────────────┘──produces──→ final report
```

The key insight: **every command reads documents produced by earlier commands.** There is no state carried in memory — documents are the only communication channel between sessions.

## Anatomy of a Command File

Every command file (`commands/*.md`) follows this structure:

### 1. Opening Context (1-2 lines)

A sentence describing what the user is doing and why this command exists. If the command accepts arguments, reference `$ARGUMENTS`.

```markdown
The user is starting a new project and needs help pulling ideas out of their head.

If the user provided a description: $ARGUMENTS
```

### 2. Steps or Phases (the body)

The main work, organized as numbered steps or phases. Each phase should be self-contained enough that the AI knows exactly what to do.

For simple commands (interview, brief), these are sequential steps:
```markdown
Interview them about this project, one category at a time, in this order:

1. **Problem** — What problem does this solve?
2. **Audience** — Who specifically is this for?
...
```

For complex commands (execute), these are formal phases with separators:
```markdown
## Phase 1: Load Context
Read these files automatically...

---

## Phase 2: Plan the Approach
Before writing any code, present a short plan...
```

### 3. Approval Gates

Explicit "wait for user confirmation" statements at decision points. These prevent the AI from charging ahead with a wrong approach.

```markdown
Present the architecture to the user. Wait for approval before writing implementation code.
```

Approval gates typically appear after planning/design phases and before execution phases. The `/start` command should have at least two: one after planning and one after design.

### 4. Output Specification

What gets produced, where it goes, and in what format. Always include explicit file paths.

```markdown
Save the summary to `docs/brainstorm-notes.md`.
```

For commands that produce structured documents, include a template:
```markdown
Save to `docs/handoff-notes/session-NN.md` using this structure:

# Handoff Note: [Title]

**Session date:** [Date]
**GitHub issue:** #[Number]

## What Was Accomplished
...
```

### 5. Rules Section

Bullet-point constraints that the AI must enforce. These handle edge cases and prevent common failure modes.

```markdown
Rules:
- Ask questions one-at-a-time per category, then WAIT for answers before moving on.
- If an answer is vague, push back and ask for specifics.
- Keep the brief under 1,000 words.
```

## The `/start` Command: 7-Phase Execution

The `/start` command is the most important and most structured command. It enforces a 7-phase process:

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

Every `/start` command begins by reading documents in a specific order:
1. The source-of-truth brief (always first, always required)
2. Domain-specific context documents (if any)
3. The lessons log
4. The GitHub issue for this task
5. The most recent handoff note

After reading, the AI confirms understanding with a brief summary and waits for the user to confirm before proceeding.

### Customizing the Phases

When creating a new workflow, you can rename phases and adjust their content, but preserve the structure:

- **Phase 1** always loads context. Don't skip this.
- **Phases 2-3** always involve planning and get approval gates. The AI must present its approach before doing work.
- **Phase 4** is preparation/validation — the step before the main work that ensures inputs are sound.
- **Phase 5** is the main work.
- **Phase 6** is verification — checking that the work meets criteria.
- **Phase 7** is reporting and prompting for handoff.

## The Document-as-Memory System

### Core Principle

The AI has no memory between sessions. Documents in `docs/` are its only memory. If something isn't written down, it doesn't exist for the next session.

### Document Types

Every workflow needs these document types:

| Type | Example | Purpose | Update Frequency |
|------|---------|---------|-----------------|
| **Brief** | `project-brief.md` | Source of truth — goals, constraints, decisions, status | Every `/handoff` |
| **Plan** | `roadmap.md` | Work structure — milestones/phases, dependencies, risks | At milestones |
| **Lessons Log** | `lessons-log.md` | Accumulated gotchas, patterns, domain knowledge | Any session |
| **Handoff Notes** | `handoff-notes/session-NN.md` | What happened each session | Every `/handoff` |
| **Interview Notes** | `brainstorm-notes.md` | Raw interview output | Once (at start) |

Some workflows add domain-specific documents. EDA adds `domain-context.md` (application-specific knowledge) and `data-profile.md` (living dataset characterization). Your workflow can add whatever persistent documents its domain needs.

### The Brief: Source of Truth

The brief is the most important document. Every session reads it first. It should contain:

- Project/analysis identity (name, owner, stakeholders)
- Goals and non-goals
- Constraints
- Key decisions with dates and reasoning
- Current status (what's done, what's next, blockers)

Keep it under 1,000 words. Every word costs context in future sessions.

### Handoff Notes: Session Memory

Handoff notes transfer context from one session to the next. They follow a consistent format:

```markdown
# Handoff Note: [Descriptive Title]

**Session date:** [Date]
**GitHub issue:** #[Number] — [Title]

## What Was Accomplished
[2-3 sentences]

## Acceptance Criteria Status
- [x] [Criterion met]
- [ ] [Criterion not yet met — explain why]

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| [Choice] | [Why] |

## Problems Encountered
[Honest assessment — don't hide issues]

## Files Created/Modified
- `path/to/file` — [description]

## What the Next Session Needs to Know
[THE MOST IMPORTANT SECTION — what context does the next AI need?]

## Open Questions
- [ ] [Unresolved item]
```

## GitHub Issue Format

All task tracking uses GitHub Issues with a consistent format:

```markdown
## User Story
As a [specific persona], I [need/want] [capability] so that [value].

## Description
[Short description of the work]

## Acceptance Criteria
- [ ] [Criterion from the persona's perspective]
- [ ] [Another criterion]

## Technical Notes
**Estimated effort:** [Small/Medium/Large]
**Dependencies:** #[issue numbers]
```

Key conventions:
- Personas are specific ("warehouse manager", not "user")
- Acceptance criteria describe what the end user can do or see, not internal implementation
- The `/decompose` command creates these; `/handoff` closes them; `/review` creates new ones for findings

## The `editor.md` File

`editor.md` is the operating rules file — the AI reads it at every session start. It gets copied to `.claude/CLAUDE.md` and `.cursor/rules/{name}.mdc` by the setup script.

### Required Sections

| Section | Purpose |
|---------|---------|
| **Title** | "X Operating System" — tells the AI what kind of project this is |
| **Document Locations** | Table listing every document, its path, and its purpose |
| **Session Protocol** | What to read at start, do during, and produce at end |
| **Slash Commands** | List of available commands with 1-line descriptions |
| **Principles** | Non-negotiable behavioral rules (5-10 bullets) |

### Optional Sections

| Section | Purpose |
|---------|---------|
| **Opinionated Stack** | Prescribed tools/libraries for the domain |
| **Work Product Locations** | Where non-document outputs live (notebooks, reports, etc.) |

### The Principles Section

Every workflow should include these universal principles:

- "You have no memory between sessions. These documents ARE your memory. Trust them."
- "The [brief] is the source of truth. If something contradicts it, ask the user."
- "Decisions made in previous sessions are recorded in the [brief]. Don't re-litigate them unless the user asks you to."
- "Keep the [brief] under 1,000 words."
- "Every task includes verification."

Add domain-specific principles as needed (e.g., EDA adds "Hypothesize before analyzing" and "Data surprises are findings, not problems").

## Setup Scripts

### `setup.sh` / `setup.ps1`

The setup script copies workflow files into a project directory. It follows this pattern:

1. **Parse arguments:** `--editor claude|cursor|both` and target directory
2. **Create shared directories:** `docs/handoff-notes/`, domain-specific dirs
3. **Create template files:** `lessons-log.md`, any domain-specific templates
4. **Claude Code setup:** Copy `editor.md` → `.claude/CLAUDE.md`, copy commands → `.claude/commands/`
5. **Cursor setup:** Prepend YAML frontmatter to `editor.md` → `.cursor/rules/{name}.mdc`, copy commands → `.cursor/commands/`
6. **Summary:** List created files and next steps

The Cursor frontmatter is always:
```yaml
---
description: [1-line description of the workflow]
alwaysApply: true
---
```

### `new_repo.sh` / `new_repo.ps1`

Creates a new GitHub repo with the workflow pre-installed:

1. **Parse arguments:** repo name, `--org`, `--editor`
2. **Create local directory** (typically under `$HOME/work/`)
3. **Call setup.sh** to install the workflow
4. **Initialize git** and make initial commit
5. **Create GitHub repo** via `gh repo create`
6. **Push** and output next steps

## How to Customize

### Adding a Phase to `/start`

Insert a new `## Phase N:` section between existing phases. Update the phase numbers of subsequent phases. If the new phase needs an approval gate, add an explicit "Wait for user confirmation" statement.

### Adding a New Document Type

1. Add the document to the `editor.md` Document Locations table
2. Add it to the session protocol (when to read it, when to update it)
3. Update the `/start` Phase 1 context loading to include it
4. Update `/handoff` to maintain it if needed
5. Add a template in `setup.sh` if it needs initial content

### Adding Domain-Specific Tooling

Add an "Opinionated Stack" section to `editor.md`. List the tools/libraries the workflow prescribes. The setup script can create a `pyproject.toml`, `package.json`, or equivalent with these pre-configured.

### Making a Command Optional

If your workflow doesn't need a synthesis/postmortem equivalent, you can omit it. But update `editor.md` to remove it from the command list, and note its absence in the README.
