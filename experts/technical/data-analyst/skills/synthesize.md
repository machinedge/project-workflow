# /synthesize — Pull All Findings into Recommendations

You are synthesizing the accumulated findings from an analysis phase (or the entire project) into a coherent set of insights and recommendations. This is where the real deliverable gets produced — the thing the stakeholder cares about.

This command produces the analysis equivalent of a completed milestone review. It looks backward at what was found and forward at what should happen next.

---

## Step 1: Load Everything

Read ALL of these:

1. `docs/analysis-brief.md` — goals, questions, success criteria
2. `docs/domain-context.md` — application domain constraints, success criteria, and recommended deliverable formats
3. `docs/scope.md` — planned phases and their status
4. `docs/data-profile.md` — everything known about the data
5. **ALL handoff notes** in `docs/handoff-notes/` — read every file
6. `docs/lessons-log.md` — gotchas and domain knowledge
7. All notebooks in `notebooks/` — review the actual analysis work

Scan all `issues/` subdirectories for files matching the phase (check the **Milestone** field in each file). Read `issues/issues-list.md` for a quick overview.

If the user didn't specify a phase: determine which one was most recently completed based on handoff notes and scope document.

---

## Step 2: Synthesize Findings

This is the core intellectual work. You are not just listing findings — you are connecting them into a narrative that answers the original analysis questions.

### 2a. Findings Inventory

Compile every finding from every session in the phase:

| Session | Issue | Hypothesis | Outcome | Key Finding | Confidence |
|---------|-------|-----------|---------|-------------|------------|
| 01 | data-analyst-feature-001 | Weekly seasonality exists | Confirmed | 23% amplitude, Monday trough | High |
| 02 | data-analyst-feature-002 | Upward trend is real | Modified | Trend exists but is stepwise, not linear | Medium |

### 2b. Answer the Analysis Questions

Go back to the "Questions to Answer" in `docs/analysis-brief.md`. For each question:
- **Can we answer it now?** If yes, state the answer with evidence and confidence level.
- **Partially answered?** State what we know and what remains uncertain.
- **Can't answer?** Explain why — insufficient data, wrong methods, out of scope.

### 2c. Identify Cross-Session Patterns

Look for things that emerge only when you see all findings together:
- Do findings from different sessions reinforce or contradict each other?
- Are there patterns that span multiple analyses?
- Did early assumptions hold up or get invalidated by later work?

### 2d. Assess Data Profile Completeness

Is `docs/data-profile.md` a comprehensive characterization of the dataset? What's still unknown?

---

## Step 3: Produce the Recommendations Report

Save to `reports/[phase-name]-synthesis.md` (or `reports/final-synthesis.md` for end-of-project):

```markdown
# Analysis Synthesis: [Phase or Project Name]

**Date:** [today]
**Analysis brief:** `docs/analysis-brief.md`
**Phase:** [Phase name and number]
**Sessions covered:** [session range]
**Issues covered:** [data-analyst-feature-001, data-analyst-feature-002, ...]

## Executive Summary
[3-5 sentences maximum. What was the question, what did we find, what should happen next. Written for the decision maker, not the analyst.]

## Key Findings

### Finding 1: [Headline — make it meaningful]
**Confidence:** [High / Medium / Low]

[2-3 sentences explaining the finding. What was discovered, how strong the evidence is, and what it means in business terms.]

**Evidence:** [Key statistic or test result. Reference the notebook: "See `notebooks/02-seasonality.ipynb`, Figure 3"]

**Implication:** [So what? What should change, what decision does this inform?]

### Finding 2: [Headline]
[Same structure]

### Finding N: [Headline]
[Same structure]

## Questions Answered

| Original Question | Answer | Confidence | Evidence |
|---|---|---|---|
| [From analysis brief] | [Concise answer] | [H/M/L] | [Notebook reference] |

## Questions Remaining
- [Questions that couldn't be fully answered and why]
- [New questions raised by the analysis]

## Data Characterization Summary
[Concise summary of what we now know about the dataset — drawn from `docs/data-profile.md`. This section is for the audience who won't read the data profile.]

## Recommendations

### Immediate Actions
[Things the stakeholder should do based on these findings. Be specific and actionable.]

1. **[Action]** — [Why, based on which finding]
2. **[Action]** — [Why, based on which finding]

### Further Analysis Recommended
[Analysis that should happen next — either remaining phases or new questions raised.]

1. **[Analysis]** — [What question it would answer, estimated effort]
2. **[Analysis]** — [What question it would answer, estimated effort]

### Not Recommended
[If the analysis revealed that certain directions are dead ends, say so explicitly. This saves future effort.]

## Methodology Notes
[Brief summary of methods used, for reviewers who care about rigor. Not a full methods section — point to notebooks for details.]

## Limitations and Caveats
[Honest assessment of what could affect these conclusions. Data quality issues, methodological limitations, small sample sizes, assumptions made.]

## Appendix: Session Log
| Session | Date | Issue | What Was Done | Key Output |
|---------|------|-------|---------------|------------|
```

---

## Step 4: Assess Phase Completion

### Progress Check
- Are all issues for this phase in `issues/done/`?
- Are there unresolved `must-fix` or `should-fix` issues from `/review`?
- Do the success criteria from the analysis brief have answers?

### Scope Impact
Based on what was learned:
- Do remaining phases in `docs/scope.md` need to change?
- New risks identified?
- Timeline shifts needed?
- Scope adjustments — analyses that are now unnecessary or newly necessary?

### Decisions Audit
- List every decision made across sessions (from handoff notes)
- Verify they're all recorded in `docs/analysis-brief.md`
- Add any missing ones

---

## Step 5: Update Documents

After user reviews and approves:

1. **Save the synthesis report** to `reports/`
2. **Update `docs/scope.md`** — mark phase complete, update dates, adjust risks
3. **Update `docs/analysis-brief.md`** — current status, all decisions, next phase
4. **Add lessons to `docs/lessons-log.md`** — what went well, what to do differently

---

## Rules

- **Write for the audience specified in the analysis brief.** If the audience is a VP, lead with business implications, not p-values. If the audience is a data science team, include methodological detail.
- **Be critical, not encouraging.** The user needs an honest assessment, not cheerleading. If the data doesn't support strong conclusions, say so.
- **Distinguish confidence levels clearly.** Don't present medium-confidence findings with the same weight as high-confidence ones.
- **Recommendations must be actionable.** "Consider further analysis" is not actionable. "Run anomaly detection on Q4 2024 data using isolation forest to determine whether the revenue dip was a data issue or a real pattern" is actionable.
- **The Executive Summary is what most people will read.** Invest time in making it clear, accurate, and useful. If someone reads only those 3-5 sentences, they should walk away with the right understanding.
