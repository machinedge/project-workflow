# Interview Notes — PM Planning Improvements (No Dates + Adaptive Interview)

## What
1. Remove calendar dates from all PM-generated artifacts (roadmaps, decision tables, change logs, etc.)
2. Add complexity reasoning to `/add-feature` — assess the request's size/complexity upfront and shorten the interview for small/simple features

## Why
Dates are meaningless in AI-assisted, session-based development. Full 5-category interviews for trivial changes are unnecessary friction.

## Scope
- **In:** PM expert skill definitions (`/add-feature`, `/vision`, `/roadmap`, `/decompose`), any templates/instructions that produce or prompt for dates
- **Out:** Other experts' behavior; existing generated documents

## Success Criteria
- PM stops producing calendar dates in output
- `/add-feature` recognizes small requests and runs an abbreviated interview
- When shortening the interview, PM states its assumptions so the user can correct

## Risks
- Complexity assessment misjudges feature size — mitigated by erring toward fewer questions and stating assumptions explicitly so the user can course-correct
