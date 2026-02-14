# /review — Methodological Review

You are reviewing analysis produced by previous sessions with fresh eyes. Your job is to evaluate whether the methods are sound, the conclusions are justified, and the work is reproducible. Push findings as GitHub issues.

This is designed to run in a separate session from the one that performed the analysis. You have no memory of doing the work — which is exactly the point.

---

## Step 1: Determine Review Scope

- **Single task** (e.g., `#42`) — review the analysis from that task
- **Range** (e.g., `#38 through #42`) — review cumulative analysis across those tasks
- **Nothing specified** — ask the user: latest task or everything since the last phase completed?

---

## Step 2: Load Context (DON'T read notebooks yet)

1. `docs/analysis-brief.md` — understand goals, questions, constraints
2. `docs/domain-context.md` — understand application domain constraints, appropriate methods, and common pitfalls
3. `docs/data-profile.md` — understand what's known about the data
4. `docs/lessons-log.md` — know what gotchas are already documented
5. Relevant GitHub issue(s): `gh issue view [number]` for each task
6. Relevant handoff note(s) — understand what was done, what was found, what decisions were made

Understand the intent first. You need to evaluate analysis against what it was supposed to answer, not just whether the code runs.

---

## Step 3: Read the Analysis

Read the notebooks and code listed in the handoff notes under "Files produced."

Read carefully — as if you didn't write it, because in this session, you didn't. Pay attention to:
- The narrative flow: does the analysis tell a coherent story?
- The code: does it do what the markdown cells claim?
- The visualizations: do they support the stated conclusions?

---

## Step 4: Evaluate

Assess across these dimensions. Be critical, not polite.

### Statistical Validity
- Are the statistical tests appropriate for the data characteristics? (e.g., parametric tests on non-normal data, correlation on non-stationary series)
- Are assumptions of the methods checked and documented? (normality, independence, homoscedasticity)
- Are p-values interpreted correctly? Is there a multiple comparisons problem?
- Are confidence intervals reported alongside point estimates?
- Are effect sizes reported, not just significance?
- Is the sample size sufficient for the conclusions drawn?

### Methodology
- Are the analysis methods appropriate for the question being asked?
- If decomposition was used: is the period parameter justified?
- If stationarity was tested: was the right test used for the data characteristics?
- If anomalies were detected: is the threshold justified or arbitrary?
- If features were engineered: are they meaningful or just numerology?
- Could an alternative method produce different conclusions? If so, was this acknowledged?

### Domain Appropriateness
Check against `docs/domain-context.md`:
- Are the methods used consistent with what's standard in this application domain?
- Were any methods used that the domain context warns against? If so, was this deviation justified?
- Do the findings align with known domain patterns, or if they diverge, is the divergence explored?
- Are domain-specific pitfalls (from the "Common Pitfalls" section) avoided?
- Is domain vocabulary used correctly and consistently?
- Would a domain expert find the analysis approach credible?

### Data Handling
- Was the data validated before analysis? (Phase 4 of `/start`)
- How were missing values handled? Was the approach appropriate?
- Were outliers handled appropriately? (not just silently removed)
- Is the temporal alignment correct? (timezone issues, off-by-one in resampling)
- Could data preprocessing choices have influenced the conclusions?

### Conclusions & Findings
- Are conclusions supported by the evidence shown?
- Is the confidence level (High/Medium/Low) appropriate given the evidence?
- Are caveats and limitations honestly stated?
- Could the findings be explained by data quality issues rather than real patterns?
- Are "no finding" results properly documented? (Absence of evidence vs. evidence of absence)
- Do findings actually answer the hypothesis/question in the issue title?

### Reproducibility
- Can the notebook run from top to bottom without errors?
- Are data file paths valid?
- Are random seeds set?
- Are library versions documented?
- Would another analyst reach the same conclusions from the same notebook?

### Documentation
- Is `docs/data-profile.md` updated with discoveries from this session?
- Are visualizations self-explanatory? (titles, axis labels, legends)
- Is the analysis narrative clear enough for someone new to follow?
- Are code cells explained in accompanying markdown?

---

## Step 5: Present Findings

Organize into three categories:

### Must Fix
Issues that could lead to wrong conclusions, invalid findings, or mislead decision makers. Should be addressed before building further analysis on these results.

### Should Fix
Methodological weaknesses that don't invalidate current findings but will cause problems as the analysis grows. Address within the current phase if time allows.

### Nits
Documentation gaps, code style, minor clarity improvements. Note them but don't block on them.

For each finding:
- State the notebook/file and what the issue is
- Explain **WHY it matters** — what goes wrong if not fixed? What conclusion might be wrong?
- Suggest a specific fix or alternative approach

---

## Step 6: Create GitHub Issues for Findings

After user reviews and approves, create issues for **Must Fix** and **Should Fix** items only. No issues for Nits.

```bash
gh issue create \
  --title "[What needs to be corrected — phrased as an action]" \
  --label "must-fix" \
  --body "$(cat <<'EOF'
## User Story
As a [persona], I need [what the fix provides] so that I can [trust the findings / make sound decisions / build on this analysis].

## Description
[What's wrong, where it is (notebook path, cell number), and what needs to change.]

**Found by:** `/review` of #[original task issue number]
**Severity:** Must Fix
**Risk if not fixed:** [What conclusion might be wrong, what decision might be misinformed]

## Acceptance Criteria
- [ ] [What "fixed" looks like — e.g., "Stationarity test replaced with KPSS which is appropriate for this data structure"]
- [ ] [Validation — e.g., "Results re-evaluated with corrected method and findings updated"]
- [ ] [Documentation — e.g., "docs/data-profile.md updated with corrected characterization"]

## Technical Notes
**Estimated effort:** [Small / Medium / Large session]
**Notebook:** [affected notebook path]
**Methods involved:** [what statistical methods need to be reconsidered]
EOF
)"
```

Create labels if missing:
```bash
gh label create must-fix --description "Review finding: must fix — conclusions may be invalid" --color D93F0B
gh label create should-fix --description "Review finding: should fix within current phase" --color FBCA04
```

---

## Step 7: Update Documents

After creating issues:
- Add lessons to `docs/lessons-log.md` — patterns to catch earlier next time (e.g., "Always check stationarity before computing correlations")
- If review found incorrect findings: flag which parts of `docs/data-profile.md` may need correction
- List created issue numbers for a clear action list

**Do NOT fix the analysis yourself.** This is review, not rework. Fixes happen in a dedicated `/start` session so they go through the full hypothesize → design → validate → analyze → validate → report loop. Shortcuts here defeat the purpose of the process.
