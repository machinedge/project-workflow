Investigate a specific technical question and produce a research summary with a recommendation.

The user should specify the question: $ARGUMENTS

---

## Step 1: Define the Question

If the user provided a clear question, confirm it. If vague, ask clarifying questions to narrow the scope:

- What specific decision does this research inform?
- What are the constraints? (Performance, cost, team expertise, timeline, compatibility)
- Is there a leading candidate or assumption to validate?

State the question clearly:
- "Research question: [precise statement]"
- "This informs: [what decision or architectural choice]"
- "Key constraints: [list]"

Wait for user confirmation before proceeding.

## Step 2: Identify Options

List the realistic options. For each:

- What is it? (1-2 sentences)
- Why is it a candidate? (What makes it worth evaluating?)

Don't list options just to have a long list. If there are really only 2 viable choices, list 2.

## Step 3: Evaluate

For each option, evaluate against the constraints identified in Step 1:

- How does it perform against each constraint?
- What are the risks?
- What's the migration/adoption cost?
- What's the long-term maintenance burden?
- Are there deal-breakers?

Use a comparison table when it helps. Be concrete — "faster" means nothing without context.

## Step 4: Recommend

State your recommendation clearly:

- "Recommendation: [option]"
- "Why: [2-3 sentences — the key reasons]"
- "Risk: [main risk of this choice and how to mitigate it]"
- "What this means for the architecture: [how this decision affects `docs/architecture.md`]"

## Step 5: Present to User

Present the full research summary. Wait for the user to decide.

If the user accepts the recommendation:
- Note whether `docs/architecture.md` should be updated (suggest running `/update` if so)
- Record the decision in the session's handoff note

If the user wants more investigation, go deeper on the specific areas they identify.
