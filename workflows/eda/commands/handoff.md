# /handoff — End Session and Produce Handoff Note

You are closing the current analysis session and producing a handoff note for the next session. The handoff note IS the next session's memory of what happened here.

---

## Step 1: Determine Session Number

Look at existing files in `docs/handoff-notes/`. The new file should be the next number in sequence:
- If `session-02.md` is the latest → create `session-03.md`
- If no handoff notes exist → create `session-01.md`

---

## Step 2: Identify the Task

Determine which GitHub issue was worked on this session:
- Check conversation context
- Read `docs/analysis-brief.md`
- If unclear: ask the user

Read the issue to get the hypothesis and acceptance criteria: `gh issue view [number]`

---

## Step 3: Write the Handoff Note

Save to `docs/handoff-notes/session-NN.md`:

```markdown
# Handoff Note: [Hypothesis or question — from issue title]

**Session date:** [today's date]
**GitHub issue:** #[number] — [title]

## What Was Analyzed
[2-3 sentences. What analysis was performed? What question was being answered?]

## Key Findings
[The most important results from this session. Be specific — include numbers, not just directions.]

- **Finding 1:** [Specific result with quantitative evidence]
- **Finding 2:** [Specific result with quantitative evidence]
- **No finding:** [If the hypothesis was refuted or the analysis was inconclusive, state that clearly]

**Confidence level:** [High / Medium / Low — with 1-sentence justification]

## Hypothesis Outcome
- **Hypothesis:** [What we set out to test]
- **Outcome:** [Confirmed / Refuted / Inconclusive / Modified — explain]

## Data Profile Updates
[What was added to `docs/data-profile.md` this session]

## Acceptance Criteria Status
- [x] [Criterion that was met]
- [x] [Criterion that was met]
- [ ] [Criterion not yet met — explain why]

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| [e.g., Used STL over classical decomposition] | [e.g., Robust to outliers present in Q3 data] |

## Problems Encountered
[What went wrong or was harder than expected? Data issues? Method failures? Be honest.]

## Scope Changes
[Did the analysis go exactly as designed in Phase 3, or did it shift? Document deviations.]

## Files Produced
- `notebooks/[name].ipynb` — [what it contains]
- `data/processed/[name]` — [what it is, if any]
- `docs/data-profile.md` — [what was updated]

## What the Next Session Needs to Know
[MOST IMPORTANT SECTION. What context makes the next session immediately productive? What should they read first? What subtle thing isn't obvious from the files alone?]

## Rabbit Holes Noted (Out of Scope)
- [ ] [Interesting things noticed but not investigated — potential future tasks]

## Open Questions
- [ ] [Anything unresolved that affects future analysis]
```

---

## Step 4: Update the GitHub Issue

Comment on the issue with a session summary:

```bash
gh issue comment [number] --body "$(cat <<'EOF'
## Session [NN] Summary

**Hypothesis:** [What was tested]
**Outcome:** [Confirmed / Refuted / Inconclusive]
**Key finding:** [1-2 sentences]
**Confidence:** [High / Medium / Low]
**Handoff note:** `docs/handoff-notes/session-NN.md`
**All acceptance criteria met:** [Yes / No — if no, what remains]
EOF
)"
```

If all acceptance criteria met: close the issue:
```bash
gh issue close [number] --reason completed
```

If NOT all met: do NOT close. Note what remains and leave open for the next session.

---

## Step 5: Update the Analysis Brief

Read and update `docs/analysis-brief.md`:
- Add new decisions to the "Key Decisions Made" table
- Update "Current Status": last completed task, next task, blockers
- Update "Last updated" date
- If findings change the analysis direction: flag for user to review

---

## Step 6: Update the Lessons Log

If anything was learned this session that future sessions should know, add to `docs/lessons-log.md`:
- Data quirks discovered (e.g., "Sensor 3 reports in UTC despite documentation claiming EST")
- Method pitfalls (e.g., "STL decomposition fails silently with fewer than 2 full seasonal cycles")
- Domain knowledge gained (e.g., "Operations team confirms maintenance windows every Tuesday night — explains weekly dips")

---

## Rules

- **Be honest in the handoff note.** If a finding is weak, say so. If a method was questionable, say so. The next session needs the truth, not optimism.
- **"Rabbit Holes Noted" matters.** These often become the most valuable future tasks. Don't lose them.
- **The "What the Next Session Needs to Know" section is the single most important thing you write.** Invest time here. What would you want to know if you were starting fresh tomorrow?
