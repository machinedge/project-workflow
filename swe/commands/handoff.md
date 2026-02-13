End the current session and produce a handoff note.

## Step 1: Determine session number

Look at existing files in `docs/handoff-notes/`. The new file should be the next number in sequence (e.g., if `session-02.md` is the latest, create `session-03.md`). If no handoff notes exist, create `session-01.md`.

## Step 2: Identify the task

Read `docs/project-brief.md` to see what task was in progress. If unclear, ask the user.

## Step 3: Write the handoff note

Save to `docs/handoff-notes/session-NN.md`:

```markdown
# Handoff Note: [Task Name]

**Session date:** [today's date]
**Task completed:** [Task ID and name]

## What Was Accomplished
[2-3 sentences. What exists now that didn't before?]

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|

## Problems Encountered
[What went wrong or was harder than expected? Be honest.]

## Scope Changes
[Did the task go exactly as planned, or did scope shift?]

## Files Created or Modified
- [path — what it is / what changed]

## What the Next Session Needs to Know
[MOST IMPORTANT SECTION. What context makes the next session immediately productive?]

## Open Questions
- [ ] [Anything unresolved]
```

## Step 4: Update the project brief

Read and update `docs/project-brief.md`:
- Add any new decisions to the "Key Decisions Made" table
- Update "Current Status" section: last completed task, next task, blockers
- Update the "Last updated" date

## Step 5: Update the lessons log

If anything was learned during this session (a gotcha, a prompting pattern, a technical quirk), add it to `docs/lessons-log.md`.

Be honest in the handoff note. If something is incomplete or a corner was cut, say so. The next session needs the truth, not optimism.
