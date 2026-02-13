# /intake — Domain Context Generation + Structured Data Interview

You are conducting a two-part intake process. First, you generate the domain context document by synthesizing your knowledge of the application area. Then, you use that context to run a sharper, domain-informed interview.

---

## Part 1: Generate Domain Context

Before asking interview questions, establish the application domain. This gives every downstream command (`/start`, `/review`, `/synthesize`) the constraints and vocabulary needed to do rigorous, domain-appropriate analysis.

### Step 1: Identify the application area

If the user provides a description via `$ARGUMENTS`, extract the application domain from it. Otherwise, ask:

> "What application area is this analysis for? For example: predictive maintenance, demand forecasting, anomaly detection for IoT, energy load profiling, financial time series, clinical monitoring, manufacturing quality, etc."

Get a clear answer before proceeding. Follow up if vague — "manufacturing" is too broad; "vibration-based predictive maintenance for rotating equipment" is specific enough.

### Step 2: Generate `docs/domain-context.md`

Using your knowledge of the application area, generate a domain context document. This is NOT a generic template — it should reflect real domain expertise for the specific application area the user described.

Save to `docs/domain-context.md`:

```markdown
# Domain Context: [Application Area]

**Generated:** [today]
**Application:** [Specific application area]
**Industry:** [Industry or sector]

## What This Domain Is About
[2-3 sentences. What problem does this application area solve? What's the business value? Why does time series analysis matter here?]

## Typical Data Characteristics
- **Common signals/variables:** [What gets measured in this domain — e.g., vibration amplitude, temperature, pressure, throughput]
- **Typical granularity:** [What time resolution is common — e.g., sub-second for vibration, hourly for energy]
- **Typical time spans:** [How much history is usually available or needed]
- **Data generation process:** [How the data is produced — sensors, transactions, logs, manual entry]
- **Common data quality issues:** [What goes wrong — sensor drift, missing readings, reporting delays, unit changes]

## Domain-Specific Patterns to Look For
- **Expected seasonal patterns:** [What cyclicality is typical — shift patterns, weekly cycles, annual maintenance windows]
- **Known trend behaviors:** [Degradation curves, growth patterns, regime changes]
- **Anomaly signatures:** [What anomalies look like in this domain — spike patterns, drift patterns, flatlines]
- **Correlation structures:** [What variables tend to move together and why]

## Critical Statistical Considerations
- **Stationarity:** [Is the data typically stationary? What makes it non-stationary in this domain?]
- **Distribution properties:** [Typical distributions — heavy-tailed? bounded? censored?]
- **Appropriate methods:** [Statistical methods that are standard in this domain]
- **Methods to avoid or use with caution:** [Methods that are commonly misapplied in this domain and why]
- **Feature engineering norms:** [What derived features matter — RMS, kurtosis, spectral features, rolling aggregations]

## Common Pitfalls in This Domain
1. [Pitfall — e.g., "Treating sensor drift as a real trend"]
2. [Pitfall — e.g., "Ignoring censored data in survival analysis"]
3. [Pitfall — e.g., "Assuming failures are independent when they cascade"]
4. [Pitfall — e.g., "Using correlation on non-stationary signals"]
5. [Pitfall — e.g., "Overfitting to small anomaly sample sizes"]

## Domain Vocabulary
| Term | Meaning | Why It Matters for Analysis |
|------|---------|---------------------------|
| [Domain-specific term] | [Definition] | [How it affects analysis decisions] |

## Success Criteria in This Domain
- **What stakeholders typically care about:** [e.g., "Predicting remaining useful life within ±10% accuracy"]
- **How findings are typically used:** [e.g., "Fed into maintenance scheduling systems"]
- **Common deliverable formats:** [e.g., "Degradation curves per asset, risk rankings, threshold recommendations"]

## Recommended Analysis Sequence for This Domain
1. [What to analyze first and why — domain-specific ordering]
2. [What to analyze second]
3. [What to analyze third]
4. [What typically provides the most actionable insight]

## References and Standards
- [Industry standards relevant to this domain — e.g., ISO 10816 for vibration analysis]
- [Common benchmarks or reference datasets]
- [Key papers or methodological references the analyst should be aware of]
```

### Step 3: Review with user

Present the generated domain context to the user. Ask:

> "Here's what I know about this application domain. Does this match your situation? Anything I should add, remove, or correct?"

Incorporate their feedback before saving. This is a living document — it will be updated as the analysis progresses and domain knowledge deepens.

---

## Part 2: Domain-Informed Interview

Now conduct the structured interview. **Use the domain context you just generated to ask sharper, more specific questions.** Instead of generic "what patterns exist?" questions, ask domain-specific ones informed by what you know about the application area.

### Interview Categories

Work through these 7 categories. For each, ask ONE question, WAIT for the answer, and follow up if vague. Push for specifics — vague inputs produce vague analysis.

**Tailor every question to the domain context.** The examples below show the generic form; your actual questions should reference the specific application area, typical signals, common patterns, and known pitfalls from `docs/domain-context.md`.

### 1. Data
- What data do you have? What format (CSV, database, API, etc.)?
- How many time series? What are they measuring?
- What's the time range? What's the granularity (seconds, minutes, hourly, daily, weekly)?
- How large is the dataset (rows, columns, file size)?
- Where does the data come from? Is it still being generated?

*Domain-informed follow-ups: Based on the domain context, ask about specific signals and variables that are typical for this application. If the domain context mentions common data quality issues, ask about those specifically.*

### 2. Time Characteristics
- Are there known gaps, outages, or missing periods?
- Is the data evenly spaced or irregular?
- Are there timezone considerations?
- Has the collection method or instrumentation changed over time?
- Are there known events that affected the data (system changes, policy changes, external shocks)?

*Domain-informed follow-ups: If the domain context identifies typical granularity or data generation processes, use that to probe for issues specific to how this data is collected.*

### 3. Domain Specifics
- Does your situation match the typical patterns described in the domain context, or are there notable differences?
- Are there domain-specific thresholds, standards, or reference values that matter?
- What does a domain expert in your organization look for when they examine this data manually?
- Are there natural groupings, segments, or operating conditions that should be analyzed separately?

*This category replaces the generic "Domain" category. Use the domain context to ask pointed questions rather than starting from zero.*

### 4. Questions
- What do you want to learn from this data?
- What decisions will this analysis inform?
- Are you looking for specific patterns (trends, seasonality, anomalies, change points)?
- Are you trying to understand the past, predict the future, or both?
- Is there a specific business metric or KPI this relates to?

*Domain-informed follow-ups: Reference the "Success Criteria in This Domain" section to ask whether the user's questions align with typical goals, or if they're pursuing something non-standard.*

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

- Generate domain context FIRST, get user feedback, THEN start the interview.
- Ask ONE question per category. Wait for the answer. Follow up if vague.
- Use the domain context to make every question sharper and more specific. Generic questions waste the user's time.
- If the user says "I don't know" to a data question, that's useful information — it means we need to profile the data to find out.
- Don't assume. If they say "daily data," confirm whether that means one observation per day or data collected throughout the day and aggregated.
- After all 7 categories, produce the structured summary below.
- Flag contradictions, gaps, and assumptions that need validation.
- If the user's answers reveal that the domain context needs correction, update `docs/domain-context.md` before saving the intake notes.

## Output

After completing the interview, save the following to `docs/intake-notes.md`:

```markdown
# Intake Notes

**Date:** [today]
**Interviewer session:** [session number or "initial"]
**Application domain:** [from domain context]

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

## Domain Specifics
- **What it represents:** [real-world process]
- **Alignment with typical domain patterns:** [how this matches or differs from domain context]
- **Domain-specific thresholds:** [reference values, standards]
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
- [ ] [Domain context corrections needed]
```

Show the summary to the user for review before saving.
