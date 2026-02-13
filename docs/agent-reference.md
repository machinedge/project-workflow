# Agent Reference

This document is for AI agents (Claude Code, Cursor, or other LLM-based coding assistants) working within projects that use these workflows. It explains how to orient yourself, what to read, and how the command system works.

## Orienting Yourself in a Project

When you start a session in a project that uses one of these workflows, the rules file will be auto-loaded:

- **Claude Code:** `.claude/CLAUDE.md` is read automatically at session start.
- **Cursor:** `.cursor/rules/project-os.mdc` (SWE) or `.cursor/rules/analysis-os.mdc` (EDA) is read automatically.

That rules file is your operating manual. It tells you where every document lives, what to read at session start, how to behave during a session, and what to produce at session end. Follow it.

## The Document System

Both workflows use a `docs/` folder as the AI's persistent memory. You have no memory between sessions — these documents ARE your memory.

### SWE Projects

| Document | Path | When to Read | When to Update |
|----------|------|-------------|----------------|
| Project Brief | `docs/project-brief.md` | Every session start — no exceptions | At `/handoff` — new decisions, status changes |
| Roadmap | `docs/roadmap.md` | When planning or decomposing milestones | At `/postmortem` — revised estimates, new risks |
| Lessons Log | `docs/lessons-log.md` | Every session start — skim for relevant entries | When you discover a gotcha, pattern, or constraint |
| Handoff Notes | `docs/handoff-notes/session-NN.md` | Session start — read the most recent one | At `/handoff` — create a new one for the current session |
| Brainstorm Notes | `docs/brainstorm-notes.md` | Only during `/vision` | Created by `/brainstorm` |

### EDA Projects

| Document | Path | When to Read | When to Update |
|----------|------|-------------|----------------|
| Analysis Brief | `docs/analysis-brief.md` | Every session start — no exceptions | At `/handoff` — new decisions, status, findings |
| Domain Context | `docs/domain-context.md` | Every session start — understand the domain | Created by `/intake`, rarely updated after |
| Data Profile | `docs/data-profile.md` | Every session start — know what's known about the data | During any session where you learn something new about the data |
| Scope | `docs/scope.md` | When planning or decomposing phases | When phase dependencies or risks change |
| Lessons Log | `docs/lessons-log.md` | Every session start — skim for relevant entries | When you discover data quirks, method pitfalls, or domain knowledge |
| Handoff Notes | `docs/handoff-notes/session-NN.md` | Session start — read the most recent one | At `/handoff` — create a new one |
| Intake Notes | `docs/intake-notes.md` | Only during `/brief` | Created by `/intake` |

## How Commands Work

Slash commands are defined in markdown files under `.claude/commands/` and `.cursor/commands/`. Each command file contains the full instructions for what to do when invoked — you read it and execute the process described.

### Command Lifecycle

Commands follow a lifecycle that mirrors the project arc. You should understand where each command fits:

**Planning commands** run once (or rarely) and produce foundational documents:

| SWE | EDA | Purpose |
|-----|-----|---------|
| `/brainstorm` | `/intake` | Interview the user, capture raw notes |
| `/vision` | `/brief` | Synthesize notes into the source-of-truth document |
| `/roadmap` | `/scope` | Plan the work structure |
| `/decompose` | `/decompose` | Break a unit of work into GitHub Issues |

**Execution commands** run repeatedly — once per task:

| Command | Purpose |
|---------|---------|
| `/start #N` | Load context, execute a structured work session against issue #N |
| `/handoff` | Close the session, produce handoff note, update the brief |

**Review commands** run periodically:

| SWE | EDA | Purpose |
|-----|-----|---------|
| `/review #N` | `/review #N` | Fresh-eyes evaluation in a separate session |
| `/postmortem` | `/synthesize` | Milestone/phase-level reflection or synthesis |

### The `/start` Command in Detail

`/start` is the most important command. It enforces a 7-phase structure with approval gates to prevent you from jumping ahead:

**SWE phases:**
1. Load Context (automatic) — Read brief, lessons log, issue, last handoff
2. Plan (approval gate) — Present your approach, wait for user approval
3. Architect (approval gate) — Design the solution, wait for approval
4. Test First — Write tests that define expected behavior (they should fail)
5. Implement — Write code to make the tests pass
6. Verify — Run tests, check acceptance criteria, self-review
7. Report — Summarize what was done, prompt for `/handoff`

**EDA phases:**
1. Load Context (automatic) — Read brief, domain context, data profile, lessons log, issue, last handoff
2. Hypothesize (approval gate) — State what you expect to find BEFORE looking at data
3. Design Analysis (approval gate) — Choose methods, plan visualizations
4. Validate Data — Check data quality and fitness for the planned analysis
5. Analyze — Execute the analysis, create visualizations, update data profile
6. Validate Results — Statistical checks, sanity checks, reproducibility
7. Report Findings — Summarize findings, confidence level, implications

The approval gates at phases 2 and 3 are critical. Do not proceed past them without explicit user approval.

## Key Behavioral Rules

These rules apply regardless of which workflow you're in:

**Read the brief first.** Every session, no exceptions. The project/analysis brief is the source of truth. If your understanding of the project contradicts the brief, the brief is right — ask the user before deviating.

**Don't re-litigate past decisions.** Decisions made in previous sessions are recorded in the brief. Trust them. If you think a past decision was wrong, flag it to the user rather than silently changing direction.

**Stay in scope.** Each GitHub Issue defines the scope of your `/start` session. If you discover something interesting but out of scope, note it in the handoff note — don't chase it.

**Update living documents immediately.** If you learn something new about the data (EDA) or discover a gotcha (both), update `data-profile.md` or `lessons-log.md` right away. Don't wait until session end.

**Verify before declaring done.** "It should work" is not verification. Run tests (SWE), check statistical assumptions (EDA), and validate against acceptance criteria (both).

**Produce a handoff note every session.** The handoff note in `docs/handoff-notes/session-NN.md` is how the next session (possibly a different instance of you) will know what happened. Be thorough: what was done, what decisions were made, what's left, what the next session needs to know.

## GitHub Integration

Both workflows use GitHub Issues as the task tracking system, managed through the `gh` CLI:

- `/decompose` creates issues with user stories and acceptance criteria
- `/start #N` reads the issue to understand the task
- `/handoff` comments on and closes the issue when acceptance criteria are met
- `/review` creates new issues for findings categorized as must-fix or should-fix

All issue operations use `gh issue create`, `gh issue view`, `gh issue comment`, and `gh issue close`. The `gh` CLI must be installed and authenticated.

## Identifying Which Workflow You're In

If you're dropped into a project and need to determine which workflow is active:

- Check for `docs/analysis-brief.md` → EDA workflow
- Check for `docs/project-brief.md` → SWE workflow
- Check for `docs/domain-context.md` or `docs/data-profile.md` → EDA workflow
- Check for `docs/roadmap.md` → SWE workflow
- Check the rules file content — it will reference either "Analysis Operating System" (EDA) or "Project Operating System" (SWE)

## Common Pitfalls

**Skipping the brief read.** The most common failure mode is starting work without reading the brief. Even if you think you know the project, read it. Context may have changed since your last session.

**Treating notebooks as deliverables (EDA).** Notebooks in `notebooks/` are the working surface. The actual deliverable is the synthesis report in `reports/`. Stakeholders read reports, not notebooks.

**Overly broad sessions.** One task, one session. If an issue turns out to be larger than expected, flag it and break it down rather than trying to do everything in one session.

**Forgetting `/handoff`.** Every session should end with `/handoff`. Without it, the next session starts cold with no record of what happened. This is the single most important habit.

**Running `/review` in the same session as `/start`.** The point of fresh-eyes review is the absence of implementation memory. Run it in a new session.
