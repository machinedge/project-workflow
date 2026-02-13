# /scope — Define Analysis Phases and Sequence

You are creating the analysis scope — the phased plan for how this time series analysis will proceed. This maps the path from raw data to actionable recommendations.

## Process

### Step 1: Read context
Read `docs/analysis-brief.md` and `docs/domain-context.md`. Fail if the analysis brief doesn't exist — the user needs to run `/brief` first.

The domain context is especially important here — its "Recommended Analysis Sequence for This Domain" section should inform your choice and ordering of phases.

### Step 2: Determine analysis phases
Based on the analysis questions, data characteristics, and domain context, define 3–6 phases. Typical time series EDA phases include:

- **Data Profiling** — Understand the dataset: schema, quality, distributions, temporal characteristics. Almost always Phase 1.
- **Temporal Pattern Analysis** — Trend decomposition, seasonality detection, cyclicality. The core of time series EDA.
- **Statistical Characterization** — Stationarity testing, autocorrelation analysis, distribution fitting. Establishes what methods are valid.
- **Anomaly & Change Point Detection** — Identify unusual observations and structural breaks. Often reveals the most actionable insights.
- **Feature Engineering & Correlation** — Derive features (lags, rolling stats, tsfresh features), test relationships between series or with external factors.
- **Segment Analysis** — Compare patterns across natural groupings (regions, products, customer types). Relevant when data has segments.
- **Forecasting Readiness** — Assess whether the data supports forecasting, recommend approaches. Only if forecasting is in scope.

Not all phases apply to every project. Choose based on the analysis questions.

### Step 3: Create the scope document
Save to `docs/scope.md`:

```markdown
# Analysis Scope

## Phases
| # | Phase | Status | Target Date | Depends On | Key Question |
|---|-------|--------|-------------|------------|--------------|
| 1 | [Phase name] | Not started | [Date] | — | [What this phase answers] |
| 2 | [Phase name] | Not started | [Date] | Phase 1 | [What this phase answers] |
| 3 | [Phase name] | Not started | [Date] | Phases 1, 2 | [What this phase answers] |

## Dependency Map
[ASCII diagram or text showing which phases block which]

Example:
Phase 1 (Profiling) → Phase 2 (Temporal Patterns) → Phase 4 (Anomaly Detection)
                    → Phase 3 (Statistical Char.)  → Phase 5 (Feature Engineering)

## Methods and Tools
| Phase | Primary Methods | Libraries | Expected Outputs |
|-------|----------------|-----------|-----------------|
| 1 | Descriptive stats, missing data analysis, temporal coverage | pandas, matplotlib | Data profile doc, quality report notebook |
| 2 | STL decomposition, FFT, periodogram | statsmodels, scipy | Decomposition plots, seasonality report |

## Risk Register
| Risk | Likelihood | Impact | Mitigation | Status |
|------|-----------|--------|------------|--------|
| [Data too sparse for seasonal analysis] | [Med] | [High] | [Aggregate to coarser granularity] | [Open] |
| [Non-stationarity invalidates correlation analysis] | [Med] | [Med] | [Differencing or detrending first] | [Open] |

## Data Requirements
[What data needs to be available, in what state, for each phase]

## Change Log
| Date | What Changed | Why |
|------|-------------|-----|
```

## Rules
- Phases are meaningful analytical milestones, not tasks. "Determine whether seasonal patterns exist and quantify them" not "run seasonal decomposition."
- Each phase should take 2–5 sessions.
- Be explicit about dependencies — some analyses are invalid without prior phases completing.
- Every phase needs at least one identified risk or unknown. If you can't think of one, you haven't thought hard enough about what could go wrong with the data or methods.
- Assume timelines take 1.5x longer than they seem. Data work always surfaces surprises.
- Flag methodological uncertainties for user decision — don't assume the right statistical approach.
- Data Profiling should almost always be Phase 1. You can't plan rigorous analysis without knowing what you're working with.

## Output
- Show the scope to the user for review before saving.
- Update `docs/analysis-brief.md` status to reflect scoping complete.
