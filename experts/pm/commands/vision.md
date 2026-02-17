Generate the project brief from interview notes.

First, read `docs/interview-notes.md`. If it doesn't exist, ask the user to run `/interview` first or provide project details.

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

## Delivery & Operations Context
- **How software reaches users:** [from interview — could be app store, OTA, USB flash, CI/CD, manual deploy, etc.]
- **Hardware/infrastructure involved:** [from interview — or "N/A" for pure software]
- **Compliance/regulatory:** [from interview — or "None identified"]
- **Current pain points:** [from interview — what's hard about building/testing/deploying today]

## Key Decisions Made
| Date | Decision | Reasoning |
|------|----------|-----------|

## Current Status
**Last updated:** [today]
**Current phase:** Planning
**Last completed task:** None
**Next task:** Create project roadmap
**Blockers:** None

## Notes for AI
- [Anything that consistently matters across sessions]
```

Rules:
- Keep it under 1,000 words total. Every word costs context window in future sessions.
- Be specific, not aspirational. Measurable outcomes, not vibes.
- Flag anything from the interview that was vague as a decision that still needs to be made.
- The "Delivery & Operations Context" section should faithfully record what the user said in the interview. Don't interpret, prescribe, or fill in gaps — just capture what was said. If the user didn't cover these topics, mark them as "Not yet discussed" rather than guessing.
- Show the draft to the user for review. Don't save until they approve it.

Also create an empty `docs/lessons-log.md` from the template if it doesn't exist.
