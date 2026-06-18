---
name: sec-handoff
description: "End the current Security session and produce a handoff note. Use when the user signals they're done, wrapping up, or ending the session. Saves session state so the next Security session can pick up where this one left off."
---

End the current session and produce a handoff note.

## Step 1: Claim session number

Run `.agents/scripts/next-session-number.sh security-engineer` to atomically claim the next session number. The script creates a placeholder file to prevent concurrent sessions from claiming the same number. It outputs the claimed number (e.g., "04").

## Step 2: Identify the task

Determine which issue or milestone was worked on this session. Check the conversation context or read `docs/project-brief.md` to see what was in progress. If unclear, ask the user.

If an issue file applies, read it from `.sdlc/issues/` (check `in-progress/`, `planned/`, or `backlog/`) to get the acceptance criteria.

## Step 3: Write the handoff note

Write the note following the **Writing clearly** conventions in `AGENTS.md` — expand issue IDs and codenames on first mention, full sentences, real bullet lists, no walls of text. The next session has no memory of this one; make it legible.

Save to `.sdlc/handoff-notes/security-engineer/session-NN.md`:

```markdown
# Handoff Note: [Task Name]

**Issue / Milestone:** [filename or milestone] — [title]

## What Was Accomplished
[2-3 sentences. Requirements produced? Review performed? Scope?]

## Security Posture Summary
- **Requirements defined / updated:** [count or "n/a"] (`docs/security-requirements.md`)
- **Must-fix:** [count] issues
- **Should-fix:** [count] issues
- **Observations:** [count]
- [Link to each issue file created in `.sdlc/issues/backlog/`]

## Acceptance Criteria Status
- [x] [Criterion verified as met]
- [ ] [Criterion not yet met — explain why]

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|

## Problems Encountered
[What went wrong or was harder than expected? Be honest.]

## What the Next Session Needs to Know
[MOST IMPORTANT SECTION. Open threats, unverified controls, blocked fixes.]

## Open Questions
- [ ] [Anything unresolved]
```

## Step 4: Update the issue file

If an issue was worked, add a session summary section to it:

```markdown
## Session [NN] Summary

**What was done:** [1-2 sentences]
**Handoff note:** `.sdlc/handoff-notes/security-engineer/session-NN.md`
**All acceptance criteria met:** [Yes / No — if no, explain what remains]
```

If all acceptance criteria are met:
1. Run `.agents/scripts/move-issue.sh <filename> done` to move the issue to `.sdlc/issues/done/`.
2. Edit the issue header so `**Status:**` reads `done`.
3. Run `.agents/scripts/update-issues-list.sh` to regenerate the issues list.

If acceptance criteria are NOT all met, leave the issue file in its current folder (it stays `in-progress`) and note what remains in the session summary so `/resume-task` can pick it up.

## Step 5: Update the project brief

Run `.agents/scripts/update-brief-status.sh <issue-id> "<brief description of what was accomplished>"` to atomically update the "Last updated" line in `docs/project-brief.md`. The script acquires a lock to prevent concurrent sessions from overwriting each other.

If new decisions were made during this session, append them to the "Key Decisions Made" table in `docs/project-brief.md`.

## Step 6: Update the lessons log

If anything was learned during this session (a recurring vulnerability class, a control that's easy to miss, a dependency gotcha), add it to `.sdlc/lessons-log.md`.

Be honest in the handoff note. If a review was shallow or a control is unverified, say so. The next session needs the truth, not optimism.
