# Test Workflow Operating System

You are working on a multi-session test-workflow project. This file tells you how to operate.

## Document Locations

All project management documents live in `docs/`:

| Document | Path | Purpose |
|----------|------|---------|
| Project Brief | `docs/project-brief.md` | Goals, constraints, decisions, status. READ THIS FIRST every session. |
| Plan | `docs/plan.md` | Milestones, dependencies, risks. |
| Handoff Notes | `docs/handoff-notes/session-NN.md` | What happened in each past session. |
| Lessons Log | `docs/lessons-log.md` | Project-specific gotchas and patterns. |
<!-- GUIDE: Add domain-specific documents here. Examples:
     | Domain Context | `docs/domain-context.md` | Application-specific constraints and methods. |
     | Data Profile | `docs/data-profile.md` | Living dataset characterization. |
     Delete this comment when done. -->

<!-- GUIDE: If your workflow produces work products in specific locations, add a
     second table here. Example:
     | Location | Purpose |
     |----------|---------|
     | `notebooks/` | Working surface for analysis |
     | `reports/` | Final deliverables |
     Delete this comment when done. -->

## Session Protocol

### Starting a session
1. Read `docs/project-brief.md` (always — no exceptions)
<!-- GUIDE: Add domain-specific documents to read here. -->
2. Read `docs/lessons-log.md` (skim for relevant entries)
3. Read the GitHub issue you've been assigned (or check the brief's "Next task" field)
4. Read the most recent handoff note in `docs/handoff-notes/`
5. Confirm your understanding of the task before starting work

### During a session
- If you make a decision that affects future work, note it — you'll add it to the brief at the end.
- Stay within the scope defined in the GitHub issue. If you discover something out of scope, flag it, don't do it.
- Verify your work before declaring the task complete.
<!-- GUIDE: Add domain-specific session rules here. Example:
     "If you discover something new about the data, update data-profile.md immediately."
     Delete this comment when done. -->

### Ending a session
When told to wrap up (or when you finish the task), produce a handoff note and save it to `docs/handoff-notes/session-NN.md`. Update `docs/project-brief.md` with any new decisions and current status.

## Slash Commands

The following custom commands are available:

- `/interview` — Structured interview to understand goals, context, and constraints
- `/brief` — Generate the project brief from interview notes
- `/plan` — Create the milestone plan with dependencies and risks
- `/decompose` — Break a milestone into session-sized GitHub Issues
- `/start` — Begin an execution session (7-phase structured process)
- `/review` — Fresh-eyes review (run in a separate session from `/start`)
- `/handoff` — End a session and produce the handoff note
- `/synthesis` — Review completed milestone and synthesize results

<!-- GUIDE: If your workflow has an opinionated tool stack, add it here:

## Opinionated Stack

This project uses a specific stack. Use these tools unless you have a strong reason not to,
and document exceptions in the lessons log.

**Core:** [tools]
**Specialized:** [tools]
**Package management:** [tool]

Delete this comment when done. -->

## Principles
- You have no memory between sessions. These documents ARE your memory. Trust them.
- The project brief is the source of truth. If something contradicts it, ask the user.
- Decisions made in previous sessions are recorded in the project brief. Don't re-litigate them unless the user asks you to.
- Keep the project brief under 1,000 words. Be ruthless about conciseness.
- Every task includes verification. "It should work" is not verification.
<!-- GUIDE: Add domain-specific principles here. Examples:
     "Hypothesize before analyzing. State what you expect to find, then look."
     "Data surprises are findings, not problems. Document them, don't hide them."
     Delete this comment when done. -->
