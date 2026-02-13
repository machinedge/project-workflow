# /decompose — Break Analysis Phase into Hypothesis-Driven Tasks

You are breaking an analysis phase into session-sized tasks and creating them as GitHub Issues. Each issue is framed as a hypothesis or question to answer, with acceptance criteria that specify the analytical activities needed.

## Process

### Step 1: Determine the phase
- Read `docs/analysis-brief.md` and `docs/scope.md`
- If user specified a phase: use it
- If not: identify the next unstarted phase, confirm with user

### Step 2: Identify stakeholders
Identify who will consume the findings from this phase. These are the personas for user stories. Common personas in analysis work:
- **Domain expert** — understands the business process, needs interpretable findings
- **Decision maker** — needs actionable recommendations, not statistical details
- **Data engineer** — needs to understand data quality issues and processing requirements
- **Data scientist** — needs reproducible analysis and methodological rigor
- **Analyst (future self)** — needs clear documentation to build on this work

Use these personas consistently in the issue user stories.

### Step 3: Create GitHub Issues

For each task, the title is the **hypothesis or question**. The acceptance criteria are the **analytical activities** needed to answer it.

```bash
gh issue create \
  --title "[Hypothesis or question — phrased as something testable]" \
  --label "analysis" \
  --milestone "[Phase name]" \
  --body "$(cat <<'EOF'
## User Story
As a [persona], I want to know [what the analysis reveals] so that I can [decision or action this enables].

## Hypothesis
**H₀ (null):** [What we'd conclude if there's nothing interesting — e.g., "No significant seasonal pattern exists in daily transaction volume"]
**H₁ (alternative):** [What we'd conclude if there IS something — e.g., "Daily transaction volume exhibits a statistically significant weekly seasonal pattern"]

*If this is exploratory rather than hypothesis-testing, replace with:*
**Exploration question:** [Specific question — e.g., "What is the autocorrelation structure of the residuals after detrending?"]
**Expected output:** [What the answer looks like — e.g., "ACF/PACF plots with significance bounds, interpretation of dominant lags"]

## Description
[2-3 sentences. What analysis needs to be performed and why it matters for the overall project.]

## Acceptance Criteria
- [ ] [Specific analytical activity — e.g., "STL decomposition performed with appropriate period parameter"]
- [ ] [Validation check — e.g., "Seasonality significance tested using appropriate statistical test"]
- [ ] [Output artifact — e.g., "Decomposition plot saved to notebooks/ with trend, seasonal, and residual components"]
- [ ] [Finding documented — e.g., "Results and interpretation added to docs/data-profile.md"]
- [ ] [Domain sanity check — e.g., "Seasonal pattern (if found) validated against known business cycles"]

## Technical Notes
**Estimated effort:** [Small / Medium / Large session]
**Dependencies:** [Issues that must be completed first, e.g. #12, #13]
**Data inputs:** [Specific files or data sources needed]
**Methods:** [Statistical methods and libraries to use]
**Notebook:** [Suggested notebook name, e.g. `notebooks/02-seasonality-analysis.ipynb`]
**Out of scope:** [What NOT to investigate — prevents rabbit holes]
EOF
)"
```

### Writing Good Analysis Hypotheses

The hypothesis IS the issue title. It should be:
- **Testable:** Can be confirmed or refuted with data ("Is there weekly seasonality?" not "Understand the patterns")
- **Specific:** Names the variable, the pattern, and the context ("Does mean daily temperature show a structural break after sensor replacement in March 2024?" not "Are there change points?")
- **Valuable:** Answering it moves the analysis forward or informs a decision

**Good examples:**
- "Does transaction volume exhibit weekly seasonality with Monday troughs?"
- "Is the upward trend in sensor readings real or an artifact of instrument drift?"
- "Are anomalies in Q4 2024 correlated with the system migration event?"
- "What lag structure best characterizes the autocorrelation in residual demand?"

**Bad examples:**
- "Analyze the data" (not a question)
- "Check for patterns" (not specific)
- "Is the data good?" (not testable)

### Writing Good Acceptance Criteria

Each criterion should be independently verifiable. Aim for a mix of:
1. **Analytical activity** — the statistical work performed
2. **Validation check** — confirmation the method was appropriate and results are sound
3. **Output artifact** — notebook, plot, or data file produced
4. **Documentation** — findings recorded in `docs/data-profile.md` or handoff note
5. **Domain check** — results make sense in the real-world context

## Rules
- Each task must be completable in ONE session (~10 substantive exchanges with the AI). If bigger: split it. If trivial: batch with a neighbor.
- Order by dependency — profiling before pattern analysis, pattern analysis before anomaly detection.
- Every task MUST have a hypothesis or exploration question. No "just run some analysis" tasks.
- Every task MUST specify which notebook to use and what to add to `docs/data-profile.md`.
- If a phase has more than 8 tasks, it's too big — split the phase.
- Reference specific data files and column names in Technical Notes where possible.

### Step 4: Cleanup

Create labels if they don't exist:
```bash
gh label create analysis --description "Analysis task — hypothesis to test or question to answer" --color 1D76DB
```

Create milestone if it doesn't exist:
```bash
gh api repos/{owner}/{repo}/milestones -f title="[Phase name]"
```

### Step 5: Output

1. List created issues for user review: `gh issue list --label analysis --milestone "[Phase name]"`
2. Update `docs/scope.md` to note the phase has been decomposed (log issue numbers)
3. Update `docs/analysis-brief.md` "Current Status" with the first task's issue number as "Next task"
