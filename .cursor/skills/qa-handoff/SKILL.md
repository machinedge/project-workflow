---
name: qa-handoff
description: "End the current QA session and produce a handoff note. Use when the user signals they're done, wrapping up, or ending the session. Saves session state so the next QA session can pick up where this one left off."
---

End the current session and produce a handoff note.

## Step 1: Claim session number

Run `.cursor/scripts/next-session-number.sh qa` to atomically claim the next session number. The script creates a placeholder file to prevent concurrent sessions from claiming the same number. It outputs the claimed number (e.g., "04").

## Step 2: Identify the task

Determine which issue was worked on this session. Check the conversation context or read `docs/project-brief.md` to see what task was in progress. If unclear, ask the user.

Read the issue file from `.workflow/issues/` (check `in-progress/`, `planned/`, or `backlog/`) to get the acceptance criteria.

## Step 3: Write the handoff note

Save to `.workflow/handoff-notes/qa/session-NN.md`:

```markdown
# Handoff Note: [Task Name]

**Issue:** [filename] — [title]

## What Was Accomplished
[2-3 sentences. What was reviewed? What was the scope?]

## Findings Summary
- **Must-fix:** [count] issues
- **Should-fix:** [count] issues
- **Nit:** [count] issues
- [Link to each issue file created in `.workflow/issues/backlog/`]

## Acceptance Criteria Status
- [x] [Criterion that was verified as met]
- [ ] [Criterion not yet met — explain why]

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|

## Problems Encountered
[What went wrong or was harder than expected? Be honest.]

## Files Reviewed
- [path — what it is / what was found]

## What the Next Session Needs to Know
[MOST IMPORTANT SECTION. What context makes the next session immediately productive?]

## Open Questions
- [ ] [Anything unresolved]
```

## Step 4: Update the issue file

Add a session summary section to the issue file:

```markdown
## Session [NN] Summary

**What was done:** [1-2 sentences]
**Handoff note:** `.workflow/handoff-notes/qa/session-NN.md`
**All acceptance criteria met:** [Yes / No — if no, explain what remains]
```

If all acceptance criteria are met:
1. Run `.cursor/scripts/move-issue.sh <filename> done` to move the issue to `.workflow/issues/done/`.
2. Run `.cursor/scripts/update-issues-list.sh` to regenerate the issues list.

If acceptance criteria are NOT all met, leave the issue file in its current folder and note what remains in the session summary.

## Step 5: Update the project brief

Run `.cursor/scripts/update-brief-status.sh <issue-id> "<brief description of what was accomplished>"` to atomically update the "Last updated" line in `docs/project-brief.md`. The script acquires a lock to prevent concurrent sessions from overwriting each other.

If new decisions were made during this session, append them to the "Key Decisions Made" table in `docs/project-brief.md`.

## Step 6: Update the lessons log

If anything was learned during this session (a gotcha, a review pattern, a quality concern), add it to `.workflow/lessons-log.md`.

Be honest in the handoff note. If something is incomplete or a review was shallow, say so. The next session needs the truth, not optimism.
