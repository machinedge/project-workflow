<!-- TEMPLATE: Brief Command
     This command reads the interview notes and synthesizes them into the
     source-of-truth document. This document gets read by EVERY future session,
     so it must be concise (under 1,000 words) and accurate.

     The brief is the single most important document in the workflow.
     Every downstream command reads it. If it's wrong, everything is wrong.

     Replace brief with your command name (e.g., "vision", "brief").
     Replace interview-notes.md with the interview notes file.
     Replace project-brief.md with the brief output file (e.g., "project-brief.md", "analysis-brief.md").
     Delete these comments when done.
-->
The user has completed the interview (via /interview) and is ready to define the project.

Read `docs/interview-notes.md`.

<!-- GUIDE: If your workflow has domain-specific context documents (like EDA's
     domain-context.md), read those here too. -->

From the notes, produce a concise project brief. Save it to `docs/project-brief.md`.

Use this structure:

```markdown
# test-workflow Brief

## Identity
- **Project:** [Name]
- **Owner:** [Name]
- **Stakeholders:** [Who cares about the outcome]
- **Created:** [Date]

## Goals
[2-3 sentences: what we're trying to achieve and why]

## Non-Goals
[What we're explicitly NOT doing]

## Constraints
[Technical, timeline, budget, organizational]

## Key Decisions
| Date | Decision | Reasoning |
|------|----------|-----------|
| [Today] | [First decision from interview] | [Why] |

## Current Status
- **Last updated:** [Date]
- **Phase:** Planning
- **Next step:** Run /plan
- **Blockers:** None
```

Rules:
- Keep the brief under 1,000 words. Every word costs context in future sessions.
- Be specific — "reduce processing time by 40%" not "improve performance."
- If anything from the interview was contradictory or vague, flag it and ask the user to resolve.
- The brief is the source of truth for the entire project. Get it right.
- Present the draft to the user and wait for their approval before saving.
