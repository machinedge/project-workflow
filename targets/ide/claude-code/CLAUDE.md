# Project Operating System

This project uses the MachinEdge Expert Teams toolkit. Each session, you operate as a specific expert.

## Expert Routing

Load the active expert's role file before executing any skill or command:

| Expert | Role File | Prefix |
|--------|-----------|--------|
| Project Manager | `.claude/roles/project-manager.md` | pm |
| Software Engineer | `.claude/roles/swe.md` | swe |
| QA Engineer | `.claude/roles/qa.md` | qa |
| DevOps Engineer | `.claude/roles/devops.md` | ops |
| System Architect | `.claude/roles/system-architect.md` | sa |

Infer the expert from the skill or command prefix (e.g. `/swe-start` → SWE, `/pm-interview` → PM). For `team-` prefixed skills, no expert role is loaded — these are cross-expert skills that run with only project-os context and their own SKILL.md instructions.

## Conventions

**Handoff notes:** `docs/handoff-notes/<expert>/session-NN.md`. Each expert writes only to its own subdirectory. Session numbers are sequential.

**Issues:** `issues/<status>/[expert]-[type]-[NNN].md` where status is `backlog/`, `planned/`, `in-progress/`, or `done/`. The `[expert]` prefix is the **executor** — the expert who will fix or implement the issue, not the expert who found it. DevOps issues use `devops-` (not `ops-`). All experts can read all issues and create in `backlog/`. Only PM moves issues between directories.

**Workflow contracts:** Each expert produces artifacts that others consume. If an upstream artifact doesn't exist, tell the user what's missing and how to create it — don't fail silently or invent data.

**Skills:** Expert skills are discoverable in `.claude/skills/`. Each expert's role file lists its available skills. Skills can be invoked explicitly (e.g. `/pm-vision`) or discovered automatically by the agent based on context.

**Scripts:** Mechanical operations (issue numbering, file movement, session numbering, issues-list regeneration) use shell scripts in `.claude/scripts/`. Use these instead of reimplementing the logic inline.

## Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (`docs/project-brief.md`) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
- Issues are tracked in `issues/`, not external services.
- Stay in scope. Flag out-of-scope discoveries, don't act on them.
- When the user signals they're wrapping up, invoke the appropriate handoff skill for the active expert.
