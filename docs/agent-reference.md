# Agent Reference

This document is for AI agents (Claude Code, Cowork, Cursor, or other LLM-based assistants) operating as experts within projects that use the MachinEdge expert system. It explains how to orient yourself, what to read, and how skills work — in both standalone and team deployment modes.

## Deployment Context

> **Note:** Team mode is under active development. If you're reading this in a standalone editor session, the team mode sections describe the target behavior.

You may be running in one of two modes:

**Standalone mode:** You are a single expert running in an editor (Claude Code, Cursor, Cowork). The human triggers your skills directly as slash commands. You are the only expert active in this session.

**Team mode:** You are one of several experts coordinated by a PM agent through Matrix. The PM triggers your skills via messages. You communicate results back through Matrix and the shared `docs/` directory. Other experts are working in parallel in their own containers.

In either mode, your `role.md` (loaded as `CLAUDE.md`, `AGENTS.md`, or equivalent) tells you everything you need to know about your specific role.

## Orienting Yourself in a Project

When you start a session, your operating rules will be auto-loaded:

- **Claude Code:** `.claude/CLAUDE.md` is read automatically.
- **Cursor:** `.cursor/rules/{expert}-os.mdc` is read automatically.
- **Team mode (MachinEdge):** Your `role.md` is injected into your container's system context.
- **Team mode (NanoClaw):** Your `CLAUDE.md` is loaded from your group directory.
- **Team mode (OpenClaw):** Your `AGENTS.md` is loaded from your workspace.

That rules file is your operating manual. Follow it.

## The Document System

All experts share a `docs/` folder as persistent memory. You have no memory between sessions — these documents ARE your memory.

### Universal Documents (All Experts Read These)

| Document | Path | When to Read |
|----------|------|-------------|
| Project Brief | `docs/project-brief.md` | Every session start — no exceptions |
| Lessons Log | `docs/lessons-log.md` | Every session start — skim for relevant entries |
| Your Handoff Notes | `docs/handoff-notes/<your-role>/session-NN.md` | Session start — read the most recent one |

### Expert-Specific Documents

| Expert | Also Reads | Also Produces |
|--------|-----------|---------------|
| **PM** | All handoff notes across all experts, `docs/roadmap.md` | `docs/project-brief.md`, `docs/roadmap.md`, `docs/interview-notes.md`, GitHub Issues |
| **SWE** | `docs/test-plan.md`, `docs/env-context.md`, assigned GitHub Issue | Code + tests, `docs/handoff-notes/swe/session-NN.md` |
| **QA** | Code produced by SWE, `docs/test-plan.md` | `docs/test-plan.md`, review issues, `docs/handoff-notes/qa/session-NN.md` |
| **DevOps** | `docs/release-plan.md`, pipeline configs | `docs/env-context.md`, `docs/release-plan.md`, `docs/handoff-notes/devops/session-NN.md` |
| **EDA** | `docs/domain-context.md`, `docs/data-profile.md`, `docs/scope.md` | Analysis notebooks, `reports/`, `docs/handoff-notes/eda/session-NN.md` |

### Document Contracts

See `experts/shared/docs-protocol.md` (formerly `workflows/shared/docs-protocol.md`) for the full producer/consumer matrix. The key rule: you can read any document, but you write only to your own handoff notes subdirectory and your own domain-specific documents. The PM is the exception — it maintains the project brief and roadmap.

## How Skills Work

Skills are defined in markdown files. In standalone mode, they live at `.claude/commands/*.md` or `.cursor/commands/*.md`. In team mode, they are injected into your container or workspace.

Each skill file contains the full instructions for what to do when invoked — you read it and execute the process described.

### Skill Lifecycle

Skills follow a lifecycle that mirrors the project arc:

**Planning skills** produce foundational documents:

| PM | SWE | QA | DevOps | EDA | Purpose |
|-----|-----|-----|--------|-----|---------|
| `/interview` | — | — | — | `/intake` | Interview the human, capture raw notes |
| `/vision` | — | — | — | `/brief` | Synthesize notes into source-of-truth |
| `/roadmap` | — | `/test-plan` | `/release-plan` | `/scope` | Plan the work structure |
| `/decompose` | — | — | — | `/decompose` | Break work into GitHub Issues |

**Execution skills** run repeatedly — once per task:

| Skill | Purpose |
|-------|---------|
| `/start #N` | Load context, execute a structured work session against issue #N |
| `/handoff` | Close the session, produce handoff note, update the brief |

**Review skills** run periodically:

| PM | QA | EDA | Purpose |
|-----|-----|-----|---------|
| `/postmortem` | `/review #N`, `/regression` | `/review #N`, `/synthesize` | Evaluation or synthesis |

### The `/start` Skill in Detail

`/start` is the most important skill. It enforces a 7-phase structure with approval gates:

1. **Load Context** (automatic) — Read brief, lessons log, issue, last handoff
2. **Plan / Hypothesize** (approval gate) — Present your approach, wait for approval
3. **Design / Architect** (approval gate) — Design the solution, wait for approval
4. **Test / Validate Inputs** — Write tests (SWE), validate data (EDA), or other pre-work
5. **Implement / Analyze** — Do the main work
6. **Verify / Validate Results** — Check work against acceptance criteria
7. **Report** — Summarize what was done, prompt for `/handoff`

Phase names vary by domain (SWE uses "Test First" and "Implement"; EDA uses "Validate Data" and "Analyze"), but the structure is constant.

The approval gates at phases 2 and 3 are critical. Do not proceed past them without explicit approval — from the human in standalone mode, or from the PM (or human, for high-stakes decisions) in team mode.

## Key Behavioral Rules

These rules apply regardless of which expert you are or which mode you're in:

**Read the brief first.** Every session, no exceptions. The project brief is the source of truth. If your understanding contradicts the brief, the brief is right — ask before deviating.

**Don't re-litigate past decisions.** Decisions made in previous sessions are recorded in the brief. Trust them. If you think a past decision was wrong, flag it rather than silently changing direction.

**Stay in scope.** Each GitHub Issue defines the scope of your `/start` session. If you discover something interesting but out of scope, note it in the handoff note — don't chase it.

**Update living documents immediately.** If you learn something new, update `lessons-log.md` or your domain-specific documents right away. Don't wait until session end.

**Verify before declaring done.** "It should work" is not verification. Run tests, check assumptions, validate against acceptance criteria.

**Produce a handoff note every session.** The handoff note in `docs/handoff-notes/<your-role>/session-NN.md` is how the next session knows what happened. Be thorough.

## Team Mode Behavior

When operating in team mode, additional rules apply:

**Communicate through Matrix.** Post status updates, questions, and completion notices to the project room. The PM and other experts need to see your progress.

**Respect the PM's authority.** The PM assigns tasks, sets priorities, and manages the project timeline. If you disagree with a direction, raise it — but defer to the PM's decision unless safety or correctness is at stake.

**Work on your branch.** Each expert has its own git branch. Commit your work there. The PM manages merges to the main branch.

**Don't touch other experts' workspaces.** Your container filesystem is yours. Code sharing happens through git. Document sharing happens through the shared `docs/` directory.

**Report blockers immediately.** If you're stuck, say so in the Matrix room. Don't spin silently.

## Identifying Your Role

If you're dropped into a project and need to determine which expert you are:

- Check your loaded rules file — it will say "X Operating System" at the top
- Check your handoff notes directory — it will be `docs/handoff-notes/<your-role>/`
- Check the available slash commands — they are role-specific

If you can't determine your role, check the project brief and ask the human (standalone) or PM (team mode) for clarification.

## Common Pitfalls

**Skipping the brief read.** The most common failure mode. Even if you think you know the project, read the brief. Context may have changed.

**Overly broad sessions.** One task, one session. If an issue is larger than expected, flag it and break it down.

**Forgetting `/handoff`.** Every session should end with `/handoff`. Without it, the next session starts cold.

**Running `/review` in the same session as `/start` (standalone mode).** Fresh-eyes review requires absence of implementation memory. Run it in a new session.

**Ignoring other experts' handoff notes (team mode).** Even if you're SWE, QA's findings and DevOps's environment constraints affect your work. Skim cross-expert handoffs when starting a session.
