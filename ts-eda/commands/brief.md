# /brief — Generate the Analysis Brief

You are creating the analysis brief — the single source of truth for this analysis project. This document will be read at the start of every session by every AI assistant. Every word costs context window.

## Process

### Step 1: Read the intake notes
Read `docs/intake-notes.md`. If it doesn't exist, tell the user to run `/intake` first.

### Step 2: Create the analysis brief
Create `docs/analysis-brief.md` with this exact structure:

```markdown
# Analysis Brief

## Identity
- **Project:** [Name — descriptive, not generic]
- **Owner:** [Name]
- **Started:** [Date]
- **Target completion:** [Date or "ongoing"]

## Data
- **Source:** [Where it comes from]
- **Series:** [What's being measured — be specific]
- **Time range:** [Start — End]
- **Granularity:** [Observation frequency]
- **Size:** [Approximate scale]

## Goal
[One sentence. What insight or recommendation will this analysis produce?]

## Questions to Answer
1. [Specific, answerable question]
2. [Specific, answerable question]
3. [Specific, answerable question]

## Who This Is For
[Specific audience. "The data team" is too vague. "VP of Operations who needs to decide whether to change the maintenance schedule" is specific.]

## Success Looks Like
- [ ] [Measurable or verifiable outcome 1]
- [ ] [Measurable or verifiable outcome 2]
- [ ] [Measurable or verifiable outcome 3]

## Constraints
- **Timeline:** [When results are needed]
- **Audience technical level:** [What they can and can't interpret]
- **Sensitivity:** [Data handling requirements]
- **Stack:** pandas, numpy, scikit-learn, statsmodels, scipy, sktime, tsfresh, plotly, matplotlib, seaborn

## Key Decisions Made
| Date | Decision | Reasoning |
|------|----------|-----------|

## Current Status
**Last updated:** [today]
**Current phase:** Planning
**Last completed task:** None
**Next task:** Define analysis scope
**Blockers:** None

## Notes for AI
- [Domain knowledge that matters across sessions]
- [Data quirks discovered so far]
- [Anything that consistently matters]
```

### Step 3: Create supporting files

If they don't already exist, create:

**`docs/lessons-log.md`:**
```markdown
# Lessons Log

Record analysis-specific gotchas, data quirks, method pitfalls, and domain knowledge here. Future sessions will read this to avoid repeating mistakes.

| Date | Lesson | Context |
|------|--------|---------|
```

**`docs/data-profile.md`:**
```markdown
# Data Profile

This is a living document. Every analysis session should leave it richer than it was found. Record what you learn about the data here — characteristics, quality issues, discovered patterns, statistical properties.

## Dataset Overview
[To be populated during first `/start` session]

## Variable Catalog
[To be populated — list of variables with types, distributions, missing rates]

## Temporal Characteristics
[To be populated — stationarity, seasonality, gaps, resolution]

## Quality Issues
[To be populated — missing data patterns, outliers, anomalies, data collection artifacts]

## Statistical Properties
[To be populated — distributions, correlations, autocorrelation structure]

## Discovery Log
| Date | Session | Discovery | Implication |
|------|---------|-----------|-------------|
```

## Rules
- Keep the analysis brief under 1,000 words. Every word costs context window.
- Be specific, not aspirational. "Understand the data" is not a goal. "Determine whether transaction volume has a weekly seasonal pattern and quantify its amplitude" is.
- Convert vague questions from intake into specific, testable questions.
- Flag items from the intake that are still vague — list them as decisions that need to be made.
- Show the draft to the user for review before saving.
- If the intake notes have contradictions, resolve them with the user NOW, not later.
