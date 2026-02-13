# /start — Begin an Analysis Session

You are executing a structured, 7-phase analysis session. This is the core command — where hypotheses get tested and findings get produced.

---

## Phase 1: Load Context (automatic)

Read these files in order:

1. **`docs/analysis-brief.md`** — Project context, goals, current status
2. **`docs/data-profile.md`** — What's already known about the data
3. **`docs/lessons-log.md`** — Gotchas and domain knowledge from prior sessions
4. **The GitHub issue:**
   - If user specified `#42` or `42`: `gh issue view [number]`
   - Otherwise: check the brief's "Next task" field
   - If still unclear: `gh issue list --label analysis --state open` and ask the user which one
5. **Most recent handoff note** in `docs/handoff-notes/` (if any exist)

**Confirm understanding with the user:**

> **Project:** [1 sentence — what we're analyzing and why]
> **Data state:** [What's known so far — profiled? cleaned? patterns found?]
> **Last session:** [1 sentence from handoff, or "First session"]
> **Today's task:** #[number] — [restate the hypothesis or question in your own words]

Flag anything unclear or contradictory. Wait for user confirmation before proceeding.

---

## Phase 2: Hypothesize

State your expectations BEFORE looking at the data for this task. This prevents confirmation bias and makes surprising results visible.

Present to the user:

- **Hypothesis/Question:** [Restate from the issue]
- **Prior expectation:** [What you expect to find based on domain knowledge, prior sessions, and data profile. Be specific — "I expect weekly seasonality with amplitude of roughly X" not "there might be patterns"]
- **What would change our mind:** [What result would refute the hypothesis or surprise us]
- **Assumptions:** [What we're assuming about the data for this analysis to be valid]

If this is the data profiling phase and there's no prior knowledge, say so explicitly: "This is exploratory — we don't have prior expectations. We're characterizing the data to establish a baseline understanding."

**APPROVAL GATE — Wait for user confirmation before proceeding.**

---

## Phase 3: Design Analysis

Design the analytical approach before writing code. Present:

- **Method:** [What statistical technique(s) will be used and why they're appropriate]
- **Data preparation:** [Filtering, aggregation, transformation needed before analysis]
- **Validation approach:** [How we'll check that results are statistically sound]
- **Visualizations:** [What plots will be created and what each one reveals]
- **Notebook:** [Which notebook file — e.g., `notebooks/03-anomaly-detection.ipynb`]
- **Expected output:** [Concrete deliverables — plots, statistics, documented findings]

Be specific about method choices:
- If testing for seasonality: which decomposition method (STL, classical, X-13) and why?
- If testing stationarity: which test (ADF, KPSS, Phillips-Perron) and why?
- If detecting anomalies: which method (IQR, isolation forest, STL residuals) and what threshold?
- If engineering features: which features (lags, rolling stats, tsfresh extraction) and why those?

Scale detail to complexity. A simple profiling task needs less design than a multi-method anomaly detection task.

**APPROVAL GATE — Wait for user confirmation before proceeding.**

---

## Phase 4: Validate Data

Before running the planned analysis, verify the data is fit for purpose. This phase replaces "write tests first" from software development — you're testing your inputs, not your outputs.

**For every analysis session:**
- Load the data and verify basic expectations (row count, column names, date range)
- Check for missing values in the columns relevant to this analysis
- Verify temporal ordering and spacing
- Check for obvious data quality issues (duplicates, impossible values, type mismatches)

**For specific analysis types, also check:**

| Analysis Type | Additional Validation |
|---|---|
| Trend/decomposition | Sufficient time span for the patterns you're looking for (at least 2 full cycles for seasonality) |
| Stationarity tests | No structural breaks that would invalidate the test (or test segments separately) |
| Correlation/regression | Variables measured at compatible frequencies, overlapping time ranges |
| Anomaly detection | Baseline period is representative (not itself anomalous) |
| Feature engineering | Sufficient data for the window sizes you're computing |

**If data validation fails:**
- Document the issue in `docs/data-profile.md`
- Determine if the planned analysis can proceed with modifications, or if the issue must be resolved first
- If the analysis can't proceed: report findings from validation as the session's output (data quality findings ARE findings)
- If the analysis can proceed with caveats: document the caveats and proceed

Do NOT skip this phase. The most common source of wrong conclusions in time series analysis is unvalidated assumptions about data quality.

---

## Phase 5: Analyze

Execute the planned analysis:

- Create or open the designated notebook
- Write clean, documented code — another session will need to understand it
- Follow the approach from Phase 3
- Stay within scope defined in the issue
- If you discover something interesting but out of scope: **note it in a comment, don't chase it**
- If you need to deviate from the planned approach: note the deviation and why

**Code standards:**
- Each notebook cell should do one thing and have a markdown cell above explaining what and why
- Use the opinionated stack (pandas, numpy, scikit-learn, statsmodels, scipy, sktime, tsfresh, plotly, matplotlib, seaborn)
- Save intermediate results to `data/processed/` if they'll be needed by future sessions
- Create visualizations that are self-explanatory (titles, axis labels, legends, annotations)

**Update `docs/data-profile.md`** with anything new you learn about the data during analysis. Don't wait until the end — do it as you discover things.

---

## Phase 6: Validate Results

Before reporting findings, verify they're sound. This is the analysis equivalent of "run the tests."

**Statistical validation:**
- Are the assumptions of your statistical tests met? (normality, independence, sufficient sample size)
- If you ran significance tests: are p-values meaningful given multiple comparisons?
- If you found patterns: are they statistically significant or could they be noise?
- If you fit a model: how does it perform on held-out data or through cross-validation?

**Sanity checks:**
- Do the results make sense given domain knowledge?
- Are effect sizes practically meaningful, not just statistically significant?
- Could the results be explained by data quality issues rather than real patterns?
- If you found "no pattern," is the data sufficient to conclude absence (vs. insufficient power)?

**Reproducibility:**
- Can the notebook be run from top to bottom without errors?
- Are random seeds set where relevant?
- Are data file paths correct and data accessible?

**Acceptance criteria:**
Walk through each acceptance criterion from the GitHub issue. Can each be demonstrated?

If validation fails: go back to Phase 5 and fix. If the data genuinely doesn't support the hypothesis, that's a valid finding — document it clearly.

---

## Phase 7: Report Findings

Summarize what was learned. This is the most important output of the session.

Present to the user:

**Finding:** [1-2 sentences — what was discovered]

**Evidence:**
- [Key statistic, test result, or quantitative measure]
- [Supporting visualization reference — "See Figure 3 in notebook X"]

**Confidence:** [High / Medium / Low — and why]
- High: Statistically significant, validated, consistent with domain knowledge
- Medium: Suggestive but not definitive, or some assumptions uncertain
- Low: Preliminary, small sample, or conflicting signals

**Implication:** [What this means for the analysis questions in the brief. So what?]

**Caveats:** [Limitations, assumptions, what could change this conclusion]

**Recommended next steps:**
- [What analysis should follow from this finding]
- [What questions does this raise]

**Files produced:**
- [Notebook path — what it contains]
- [Any data files saved to `data/processed/`]
- [Updates made to `docs/data-profile.md`]

**Acceptance criteria status:**
- [x] [Met criterion]
- [x] [Met criterion]
- [ ] [Unmet criterion — explain why]

Then prompt the user: "Ready to run `/handoff` to close this session?"
