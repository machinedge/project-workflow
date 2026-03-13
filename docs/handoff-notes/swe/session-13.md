# Handoff Note: Fix QA-Found Consistency Issues

**Session date:** 2026-03-12
**Issue:** swe-bug-024, swe-bug-025, swe-techdebt-026, swe-techdebt-027

## What Was Accomplished

Fixed 4 consistency issues found by QA review (qa-feature-005): added Verify phase to QA `/start`, added `architecture.md` to QA/DevOps/PM Session Protocols, aligned SWE escalation language with QA/DevOps, and added "technology choices" to DevOps escalation example list.

## Acceptance Criteria Status

**swe-bug-024:**
- [x] QA `/start` skill includes Verify phase that walks through own issue's acceptance criteria
- [x] Verify phase follows same pattern as other experts (check each criterion, go back if unmet)

**swe-bug-025:**
- [x] QA role.md Session Protocol includes architecture.md with `(if it exists)` qualifier
- [x] DevOps role.md Session Protocol includes architecture.md with `(if it exists)` qualifier
- [x] PM role.md Session Protocol includes architecture.md with `(if it exists)` qualifier
- [x] Placement consistent (after domain-specific docs, before "Confirm understanding")

**swe-techdebt-026:**
- [x] SWE role.md escalation uses "flag it for the System Architect or PM"
- [x] SWE start.md Phase 3 escalation updated to match

**swe-techdebt-027:**
- [x] DevOps role.md escalation includes "technology choices" (added before "service topology")

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Added "technology choices" before "service topology" in DevOps rather than replacing it | "Service topology" is genuinely relevant to DevOps; adding rather than substituting preserves domain-specific context while fixing the parallel structure |

## Problems Encountered

None.

## Scope Changes

None.

## Files Created or Modified

- `experts/technical/qa/skills/start.md` — added Phase 4 Verify, renumbered to 6 phases
- `experts/technical/qa/role.md` — added architecture.md to Session Protocol step 6
- `experts/technical/devops/role.md` — added architecture.md to Session Protocol step 6; added "technology choices" to escalation list
- `experts/technical/project-manager/role.md` — added architecture.md to Session Protocol step 5
- `experts/technical/swe/role.md` — updated escalation to "flag it for the System Architect or PM"
- `experts/technical/swe/skills/start.md` — updated Phase 3 escalation to match

## What the Next Session Needs to Know

1. All 4 issues resolved. One backlog item remains: swe-techdebt-028 (agent-reference.md overstates `/start` phase count). It's a one-sentence edit.

2. With these fixes plus swe-techdebt-028, M3-M5 (Expert Skill Restructure) would be fully complete. M6-M7 (Deployment Restructure) are already done.

## Open Questions

None.
