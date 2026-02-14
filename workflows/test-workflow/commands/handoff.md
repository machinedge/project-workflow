<!-- TEMPLATE: Handoff Command
     This command closes a session and transfers context to the next one.
     It's the MOST IMPORTANT HABIT in the workflow. Without it, the next
     session starts cold.

     The handoff note format is highly standardized — don't deviate much.
     The "What the Next Session Needs to Know" section is the most important part.

     Replace project-brief.md with the brief file.
     Replace task with your task label.
     Delete these comments when done.
-->
End the current session and produce a handoff note.

---

## Step 1: Determine Session Number

Check `docs/handoff-notes/` for existing files. The next session number is one higher than the highest existing file. If no files exist, this is session 01.

---

## Step 2: Write the Handoff Note

Save to `docs/handoff-notes/session-NN.md` (zero-padded):

```markdown
# Handoff Note: [Descriptive Title of What Was Done]

**Session date:** [Today's date]
**GitHub issue:** #[Number] — [Issue title]

## What Was Accomplished
[2-3 sentences summarizing the session's work]

## Acceptance Criteria Status
- [x] [Criterion that was met]
- [ ] [Criterion not yet met — briefly explain why]

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| [What was decided] | [Why this choice over alternatives] |

## Problems Encountered
[Honest assessment of issues, blockers, or surprises. "None" if truly none.]

## Scope Changes
[Any deviations from the original plan. "None" if stayed on track.]

## Files Created/Modified
- `path/to/file` — [what it is / what changed]

## What the Next Session Needs to Know
[THIS IS THE MOST IMPORTANT SECTION.
What context does the next AI need? What was left incomplete?
What's tricky or non-obvious? What should the next session do first?]

## Open Questions
- [ ] [Unresolved question or decision that needs user input]
```

---

## Step 3: Update the Brief

Read `docs/project-brief.md` and update:
- **Current Status** section: update last completed task, set next task, update date
- **Key Decisions** table: add any new decisions from this session

Do not rewrite other sections of the brief.

---

## Step 4: Update the Lessons Log

If anything was learned this session that future sessions should know (a gotcha, a pattern, a tool quirk), add it to `docs/lessons-log.md`.

---

## Step 5: Close the GitHub Issue

If all acceptance criteria are met:
```bash
gh issue comment [number] --body "Completed in session [NN]. See docs/handoff-notes/session-[NN].md"
gh issue close [number]
```

If acceptance criteria are NOT all met, comment with status but leave the issue open.

---

Rules:
- The handoff note must be thorough. 2 minutes now saves 20 minutes next session.
- Be honest about problems. The next session needs truth, not optimism.
- The "What the Next Session Needs to Know" section is non-negotiable — always fill it in.
- Don't update the brief beyond the Current Status and Key Decisions sections.
