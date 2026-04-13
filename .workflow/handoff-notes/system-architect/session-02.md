# Handoff Note: Context Loading Optimization Research

**Issue:** sa-research-032 — Audit Startup Context and Produce Optimization Matrix

## What Was Accomplished
Audited all 5 experts' session protocols (role files, workspace rules, and `/start` skills) to catalog every document loaded at session startup. Produced two classification matrices (workspace rules and session protocol documents), identified 4 inconsistencies between session protocols and `/start` skills, and delivered 4 prioritized recommendations.

## Acceptance Criteria Status
- [x] Every document referenced in each expert's "Starting a session" protocol is cataloged
- [x] Both canonical role files and `.cursor/rules/*-os.mdc` workspace rules are covered
- [x] Each expert x document pair is classified as essential, nice-to-have, or unnecessary with brief rationale
- [x] Classifications with low certainty are explicitly flagged
- [x] A recommendation section proposes specific changes with rationale
- [x] Recommendations err conservative — when uncertain, classify as nice-to-have rather than unnecessary
- [x] Research is saved to `docs/research-context-optimization.md`

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Analyzed workspace rules as a separate optimization surface from session protocol documents | Workspace rules are always loaded by Cursor (different mechanism than instructed reads); they represent the biggest optimization opportunity |
| Classified `docs/architecture.md` as nice-to-have for all non-SA experts | Most tasks operate within established boundaries; architecture context is only needed when touching component boundaries |
| Flagged session protocol vs `/start` skill inconsistencies as a distinct finding | These misalignments cause contradictory context loading instructions; fixing them is prerequisite to further optimization |

## Downstream Impact
- **SWE:** Recommendations 1, 2, and 3 would require modifying workspace rules and role files if approved
- **QA:** Recommendation 4 identifies a bug in QA's session protocol (missing own handoff notes)
- **PM:** Should review recommendations and decide which to implement; Recommendation 2 requires a skill audit first

## Problems Encountered
None. The research was straightforward — the source material is well-organized and the patterns were clear.

## Files Created or Modified
- `docs/research-context-optimization.md` — full research document with matrices, inconsistency analysis, and recommendations

## What the Next Session Needs to Know
The research is complete. The next step is a PM decision on which recommendations to implement, then SWE tasks to execute the approved changes. Recommendation 1 (conditional workspace rules) is the highest-impact change. Recommendation 4 (QA bug fix) is trivial and should be done regardless.

## Open Questions
- [ ] Does Cursor properly handle the flow where `project-os.mdc` (always loaded) instructs the agent to Read a conditional role file? Needs testing before Recommendation 1 can be implemented.
