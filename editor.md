# Project Operating System

You are working on a multi-session project. This file tells you how to operate.

## Document Locations

All project management documents live in `docs/`:

| Document | Path | Purpose |
|----------|------|---------|
| Project Brief | `docs/project-brief.md` | Project context, goals, constraints, decisions. READ THIS FIRST every session. |
| Roadmap | `docs/roadmap.md` | Milestones, dependencies, risks. |
| Task Briefs | `docs/tasks/task-NN.md` | Individual session assignments. |
| Handoff Notes | `docs/handoff-notes/session-NN.md` | What happened in each past session. |
| Lessons Log | `docs/lessons-log.md` | Project-specific gotchas and patterns. |

## Session Protocol

### Starting a session
1. Read `docs/project-brief.md` (always — no exceptions)
2. Read `docs/lessons-log.md` (skim for relevant entries)
3. Read the task brief you've been assigned (e.g. `docs/tasks/task-03.md`)
4. Read the most recent handoff note in `docs/handoff-notes/`
5. Confirm your understanding of the task before starting work

### During a session
- If you make a decision that affects future work, note it — you'll add it to the project brief at the end.
- Stay within the scope defined in the task brief. If you discover something out of scope, flag it, don't do it.
- Verify your work before declaring the task complete. Run code, review output, check against acceptance criteria.

### Ending a session
When told to wrap up (or when you finish the task), produce a handoff note and save it to `docs/handoff-notes/session-NN.md`. Update `docs/project-brief.md` with any new decisions and current status.

## Slash Commands

The following custom commands are available:

- `/brainstorm` — Structured interview to pull project ideas out of the user's head
- `/vision` — Generate the project brief from brainstorm notes
- `/roadmap` — Create the milestone plan
- `/decompose` — Break a milestone into session-sized task briefs
- `/start` — Begin an execution session (reads all context automatically)
- `/handoff` — End a session and produce the handoff note
- `/postmortem` — Review a completed milestone and update the plan

## Principles
- You have no memory between sessions. These documents ARE your memory. Trust them.
- The project brief is the source of truth. If something contradicts it, ask the user.
- Decisions made in previous sessions are recorded in the project brief. Don't re-litigate them unless the user asks you to.
- Keep the project brief under 1,000 words. Be ruthless about conciseness.
- Every task includes verification. "It should work" is not verification. Run it, read it, test it.
