# Docs Protocol

Shared conventions for all workflows (PM, SWE, QA, DevOps). Every workflow references this file for document locations, artifact contracts, and operating principles.

## Document Locations

All project documents live in `docs/`:

| Document | Path | Purpose |
|----------|------|---------|
| Project Brief | `docs/project-brief.md` | Project context, goals, constraints, decisions. READ THIS FIRST every session. |
| Roadmap | `docs/roadmap.md` | Milestones, dependencies, risks. |
| Handoff Notes | `docs/handoff-notes/<workflow>/session-NN.md` | What happened in each past session, organized by workflow (swe/, qa/, devops/, pm/). |
| Lessons Log | `docs/lessons-log.md` | Project-specific gotchas and patterns. |
| Interview Notes | `docs/interview-notes*.md` | Raw interview transcripts from PM discovery. |
| Environment Context | `docs/env-context.md` | Build targets, deployment mechanisms, test infrastructure. |
| Test Plan | `docs/test-plan.md` | What to test, at what level, with what infrastructure. |
| Release Plan | `docs/release-plan.md` | Release gates, rollback procedures, artifact definitions. |
| Issues List | `issues/issues-list.md` | Overview list of reported or captured issues and their current status |

## Workflow Contracts

Each workflow produces artifacts that other workflows consume. If an upstream artifact doesn't exist, the workflow should check for it and guide the user (e.g., "Run `/interview` and `/vision` first to create a project brief.").

| Producer | Artifact | Consumer(s) |
|----------|----------|-------------|
| PM | `docs/project-brief.md` | SWE, QA, DevOps, UX and other experts|
| PM | `docs/roadmap.md` | SWE, QA, DevOps |
| PM | `issues/issues-list.md` | SWE, QA, DevOps, UX and other experts|
| PM | `docs/interview-notes*.md` | PM (internal) |
| SWE | Code + tests | QA, DevOps |
| SWE | `docs/handoff-notes/swe/session-NN.md` | PM, QA, SWE (next session) |
| QA | `docs/test-plan.md` | SWE, DevOps |
| QA | Review issues (must-fix, should-fix) | SWE, PM |
| QA | `docs/handoff-notes/qa/session-NN.md` | PM, SWE, QA (next session) |
| QA | Regression reports | PM (postmortem) |
| DevOps | `docs/env-context.md` | SWE, QA |
| DevOps | `docs/release-plan.md` | PM, QA |
| DevOps | `docs/handoff-notes/devops/session-NN.md` | PM, DevOps (next session) |
| DevOps | Pipeline config | DevOps (internal) |

## Handoff Note Conventions

Handoff notes are organized by expert in subdirectories:

```
docs/handoff-notes/
├── swe/
│   ├── session-01.md
│   └── session-02.md
├── qa/
│   └── session-01.md
├── devops/
│   └── session-01.md
└── pm/
    └── session-01.md
```


Every expert can **read** all handoff notes. Each workflow **writes** only to its own subdirectory. Session numbers are sequential within each workflow.

## Issues Conventions
Issues are organized by the report and status

```
issues/
    issues-list.md
    backlog/
        [expert]-[feature | bug | techdebt]-[issue number].md
    planned/
        [expert]-[feature | bug | techdebt]-[issue number].md
    in-progress/
        [expert]-[feature | bug | techdebt]-[issue number].md
    done/
        [expert]-[feature | bug | techdebt]-[issue number].md
```
Every expert can **read** all issues and the `issues-list.md`. All experts can create issues in `backlog`, but only PM can move them from `backlog`, 

## Principles

These apply to all experts:

- **No memory between sessions.** These documents ARE your memory. Trust them.
- **Project brief is source of truth.** If something contradicts it, ask the user.
- **Don't re-litigate past decisions.** Decisions are recorded in the project brief. Only revisit if the user asks.
- **Keep the project brief under 1,000 words.** Be ruthless about conciseness.
- **Verify your work.** "It should work" is not verification. Run it, read it, test it.
- **Stay in scope.** If you discover something out of scope, flag it — don't do it.
- **Graceful degradation.** If an upstream artifact doesn't exist, tell the user what's missing and how to create it. Don't fail silently or invent data.

## Editor Configuration

Each workflow has its own `role.md` that defines the AI's role and available commands. When installing workflows into a project:

- **Claude Code:** Each workflow's role.md is installed as `.claude/roles/<workflow>.md`. The user selects which role to activate at the start of a session.
- **Cursor:** Each workflow's role.md is installed as `.cursor/rules/<workflow>-os.mdc` with appropriate frontmatter.

Commands from all installed workflows are available regardless of which role is active. The role determines the AI's persona, session protocol, and priorities — not which commands exist.
