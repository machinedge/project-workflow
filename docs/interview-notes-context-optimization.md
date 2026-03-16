# Interview Notes — Context Loading Optimization

## What
Reduce the number of documents each expert reads during session startup. Currently every expert loads a broad set of documents on startup; the goal is to audit what each expert actually needs and trim the list.

## Why
Three motivations:
1. **Token cost** — loading unnecessary documents wastes tokens.
2. **Context window** — unnecessary context consumes space that could be used for actual work.
3. **Output quality** — research suggests excessive context can over-constrain agents and degrade results.

## Scope
- **In:** All 5 experts (PM, SWE, QA, DevOps, System Architect). Both canonical expert role definitions and `.cursor/rules/*-os.mdc` workspace rules. This is primarily a **research task** — the deliverable is data and recommendations, not implementation.
- **Out:** Actually modifying session protocols or role files. That would be a follow-up task based on the research findings.

## Success Criteria
- A matrix of **expert x document** with ratings: essential, nice-to-have, or unnecessary.
- A recommendation section with proposed changes and rationale.

## Risks
- **Regression risk:** If context that seems unnecessary actually matters, experts will miss important information and produce worse results. The research should err on the side of caution and flag uncertainty rather than aggressively recommending cuts.

## Open Questions
- None identified during interview.
