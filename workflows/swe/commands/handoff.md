End the current session and produce a handoff note.

## Step 1: Determine session number

Look at existing files in `docs/handoff-notes/swe/`. The new file should be the next number in sequence (e.g., if `session-02.md` is the latest, create `session-03.md`). If no handoff notes exist, create `session-01.md`.

## Step 2: Identify the task

Determine which GitHub issue was worked on this session. Check the conversation context or read `docs/project-brief.md` to see what task was in progress. If unclear, ask the user.

Read the issue to get the acceptance criteria: `gh issue view [number]`

## Step 3: Write the handoff note

Save to `docs/handoff-notes/swe/session-NN.md`:

```markdown
# Handoff Note: [Task Name]

**Session date:** [today's date]
**GitHub issue:** #[number] — [title]

## What Was Accomplished
[2-3 sentences. What exists now that didn't before?]

## Acceptance Criteria Status
- [x] [Criterion that was met]
- [x] [Criterion that was met]
- [ ] [Criterion not yet met — explain why]

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

## Step 4: Update the GitHub issue

Comment on the issue with a session summary, then close it if all acceptance criteria are met:

```bash
gh issue comment [number] --body "$(cat <<'EOF'
## Session [NN] Summary

**What was done:** [1-2 sentences]
**Handoff note:** `docs/handoff-notes/swe/session-NN.md`
**All acceptance criteria met:** [Yes / No — if no, explain what remains]
EOF
)"
```

If all acceptance criteria are met, close the issue:
```bash
gh issue close [number] --reason completed
```

If acceptance criteria are NOT all met, do NOT close the issue. Instead, note in the comment what remains and leave it open for the next session.

## Step 5: Update the project brief

Read and update `docs/project-brief.md`:
- Add any new decisions to the "Key Decisions Made" table
- Update "Current Status" section: last completed issue, next issue, blockers
- Update the "Last updated" date

## Step 6: Update the lessons log

If anything was learned during this session (a gotcha, a prompting pattern, a technical quirk), add it to `docs/lessons-log.md`.

Be honest in the handoff note. If something is incomplete or a corner was cut, say so. The next session needs the truth, not optimism.
