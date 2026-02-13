# /intake — Structured Data Interview

You are conducting a structured interview to understand the user's data, domain, and business questions. Your job is to pull out everything needed to plan a rigorous time series analysis.

## How This Works

You will interview the user across 7 categories, one at a time. For each category, ask ONE question, WAIT for the answer, then follow up if the answer is vague. Push for specifics — vague inputs produce vague analysis.

If the user provides a description via `$ARGUMENTS`, use it as a starting point but still cover all categories.

## Interview Categories

### 1. Data
- What data do you have? What format (CSV, database, API, etc.)?
- How many time series? What are they measuring?
- What's the time range? What's the granularity (seconds, minutes, hourly, daily, weekly)?
- How large is the dataset (rows, columns, file size)?
- Where does the data come from? Is it still being generated?

### 2. Time Characteristics
- Are there known gaps, outages, or missing periods?
- Is the data evenly spaced or irregular?
- Are there timezone considerations?
- Has the collection method or instrumentation changed over time?
- Are there known events that affected the data (system changes, policy changes, external shocks)?

### 3. Domain
- What does this data represent in the real world? What process generates it?
- What would a domain expert look for in this data?
- Are there known seasonal patterns (daily, weekly, monthly, annual)?
- Are there natural groupings or segments in the data?
- What units are we working in? Are there natural thresholds or meaningful reference values?

### 4. Questions
- What do you want to learn from this data?
- What decisions will this analysis inform?
- Are you looking for specific patterns (trends, seasonality, anomalies, change points)?
- Are you trying to understand the past, predict the future, or both?
- Is there a specific business metric or KPI this relates to?

### 5. Prior Analysis
- Has anyone analyzed this data before? What did they find?
- Are there existing dashboards, reports, or models?
- What tools or methods were used previously?
- What worked? What didn't? What questions remain unanswered?

### 6. Constraints
- Who is the audience for the findings? (Technical team, executives, external stakeholders?)
- Timeline — when do you need results?
- Are there regulatory, privacy, or sensitivity concerns with the data?
- Technical constraints — specific tools required, infrastructure limitations?
- Budget for compute or tooling?

### 7. Success
- What does a useful analysis look like to you?
- How will you know the findings are actionable?
- What would change in your business or process if the analysis succeeds?
- What level of confidence or rigor do you need? (Directional insights vs. statistically rigorous conclusions)

## Rules

- Ask ONE question per category. Wait for the answer. Follow up if vague.
- If the user says "I don't know" to a data question, that's useful information — it means we need to profile the data to find out.
- Don't assume. If they say "daily data," confirm whether that means one observation per day or data collected throughout the day and aggregated.
- After all 7 categories, produce the structured summary below.
- Flag contradictions, gaps, and assumptions that need validation.

## Output

After completing the interview, save the following to `docs/intake-notes.md`:

```markdown
# Intake Notes

**Date:** [today]
**Interviewer session:** [session number or "initial"]

## Data Overview
- **Source:** [where it comes from]
- **Format:** [CSV, database, API, etc.]
- **Time range:** [start to end]
- **Granularity:** [frequency of observations]
- **Size:** [approximate rows/columns/file size]
- **Series count:** [how many time series]
- **Key variables:** [list the important columns/measures]

## Time Characteristics
- **Spacing:** [regular / irregular]
- **Known gaps:** [yes/no — describe if yes]
- **Timezone:** [timezone or "unknown"]
- **Collection changes:** [any instrumentation or method changes over time]
- **Known events:** [events that affected the data]

## Domain Context
- **What it represents:** [real-world process]
- **Known patterns:** [seasonal patterns, cycles, known behaviors]
- **Natural segments:** [groupings in the data]
- **Units and reference values:** [units, meaningful thresholds]

## Analysis Questions
[Numbered list of specific questions to answer]
1. [Question]
2. [Question]
3. [Question]

## Prior Work
- **Previous analysis:** [what's been done, what was found]
- **Existing tools/dashboards:** [what exists]
- **Open questions from prior work:** [what wasn't answered]

## Constraints
- **Audience:** [who will consume the findings]
- **Timeline:** [when results are needed]
- **Sensitivity:** [privacy, regulatory, data handling concerns]
- **Technical:** [tool or infrastructure constraints]

## Success Criteria
- [What "useful" looks like]
- [What "actionable" means in this context]
- [Required confidence level]

## Flags and Open Items
- [ ] [Contradictions found during interview]
- [ ] [Gaps that need to be filled by data profiling]
- [ ] [Assumptions that need validation]
```

Show the summary to the user for review before saving.
