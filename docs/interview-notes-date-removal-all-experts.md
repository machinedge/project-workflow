# Interview Notes — Date Removal Across All Experts

## What
Extend the date-removal treatment from PM (swe-feature-029) to SWE, QA, DevOps, and System Architect skill templates. Also update the lessons-log template.

## Why
Consistency. PM skills no longer produce dates, but other experts still do. Same rationale as M8: dates are meaningless in AI-assisted, session-based development.

## Scope
- **In:** Handoff templates and any skill files across SWE, QA, DevOps, and System Architect that reference dates. The lessons-log template (`Date` column). SWE handoff template's `Session date: [today's date]`.
- **Out:** Existing generated documents; PM skills (already done in swe-feature-029); the `decompose.md` skill's example about "invalid dates" (domain content, not a date stamp); Cursor rule files (reference skills but don't contain date-producing templates).

## Success Criteria
- No expert skill template instructs the AI to produce or consume calendar dates.
- Same convention as M8: drop date columns entirely.

## Risks
- Low. Pattern is proven from M8. Only risk is missing a date reference in a file we don't check.
