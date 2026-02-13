Generate the project brief from brainstorm notes.

First, read `docs/brainstorm-notes.md`. If it doesn't exist, ask the user to run `/brainstorm` first or provide project details.

Create `docs/project-brief.md` using this exact structure:

```markdown
# Project Brief

## Identity
- **Project:** [Name]
- **Owner:** [Name]
- **Started:** [Date]
- **Target completion:** [Date]

## Goal
[One sentence]

## Who It's For
[Specific audience]

## Success Looks Like
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

## Constraints
- **Budget:**
- **Timeline:**
- **Tech stack:**
- **Skills:**
- **Other:**

## Key Decisions Made
| Date | Decision | Reasoning |
|------|----------|-----------|

## Current Status
**Last updated:** [today]
**Current phase:** Planning
**Last completed task:** None
**Next task:** Create project roadmap
**Blockers:** None

## Notes for Claude
- [Anything that consistently matters across sessions]
```

Rules:
- Keep it under 1,000 words total. Every word costs context window in future sessions.
- Be specific, not aspirational. Measurable outcomes, not vibes.
- Flag anything from the brainstorm that was vague as a decision that still needs to be made.
- Show the draft to the user for review. Don't save until they approve it.

Also create an empty `docs/lessons-log.md` from the template if it doesn't exist.
