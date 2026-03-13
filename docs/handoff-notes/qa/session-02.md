# Handoff Note: Review Expert Skill Restructure for Consistency

**Session date:** 2026-03-12
**Issue:** qa-feature-005 — Review Expert Skill Restructure for Consistency

## What Was Accomplished

Systematic consistency review of the entire Expert Skill Restructure (M3-M5). Reviewed all 5 expert role files, all `/start` and `/handoff` skills (10 files), all 6 System Architect skills, docs-protocol, agent-reference.md, and backward compatibility of 8 existing QA and DevOps skills. Filed 5 issues for findings (2 should-fix, 3 nit).

## Findings Summary

- **Must-fix:** 0 issues
- **Should-fix:** 2 issues
- **Nit:** 3 issues
- swe-bug-024 — QA `/start` missing dedicated Verify phase for own acceptance criteria (should-fix)
- swe-bug-025 — QA, DevOps, PM role.md Session Protocol missing `architecture.md` (should-fix)
- swe-techdebt-026 — SWE escalation routing language differs from QA and DevOps (nit)
- swe-techdebt-027 — DevOps escalation example list uses "service topology" instead of "technology choices" (nit)
- swe-techdebt-028 — agent-reference.md overstates `/start` phase count (nit)

## Acceptance Criteria Status

- [x] All new skill files follow the same structural conventions as existing skills
- [x] Every `/start` skill across all experts follows a consistent pattern — gap found in QA, filed as swe-bug-024
- [x] Every `/handoff` skill follows a consistent pattern
- [x] docs-protocol Workflow Contracts table is complete and accurate for System Architect
- [x] No conflicting responsibilities between System Architect and other experts
- [x] All role files reference `architecture.md` with graceful degradation — Session Protocol gap filed as swe-bug-025
- [x] Escalation instructions are consistent across all expert role files — minor language differences filed as swe-techdebt-026, -027
- [x] Existing skills are not broken by changes — git diff confirms zero modifications

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|

None.

## Problems Encountered

None. The review scope was well-defined and all prerequisite tasks were complete.

## Files Reviewed

- `experts/technical/system-architect/role.md` — SA expert role definition
- `experts/technical/system-architect/skills/start.md` — SA `/start` skill
- `experts/technical/system-architect/skills/handoff.md` — SA `/handoff` skill
- `experts/technical/system-architect/skills/design.md` — SA `/design` skill
- `experts/technical/system-architect/skills/research.md` — SA `/research` skill
- `experts/technical/system-architect/skills/review.md` — SA `/review` skill
- `experts/technical/system-architect/skills/update.md` — SA `/update` skill
- `experts/technical/project-manager/role.md` — PM role definition
- `experts/technical/project-manager/skills/start.md` — PM `/start` skill
- `experts/technical/project-manager/skills/handoff.md` — PM `/handoff` skill
- `experts/technical/swe/role.md` — SWE role definition
- `experts/technical/swe/skills/start.md` — SWE `/start` skill (7 phases confirmed)
- `experts/technical/swe/skills/handoff.md` — SWE `/handoff` skill
- `experts/technical/qa/role.md` — QA role definition
- `experts/technical/qa/skills/start.md` — QA `/start` skill (missing Verify)
- `experts/technical/qa/skills/handoff.md` — QA `/handoff` skill
- `experts/technical/devops/role.md` — DevOps role definition
- `experts/technical/devops/skills/start.md` — DevOps `/start` skill
- `experts/technical/devops/skills/handoff.md` — DevOps `/handoff` skill
- `experts/technical/shared/docs-protocol.md` — cross-expert document contracts
- `docs/agent-reference.md` — repo guide for AI assistants
- Existing QA skills (review, test-plan, regression, bug-triage) — backward compat verified via git
- Existing DevOps skills (env-discovery, pipeline, release-plan, deploy) — backward compat verified via git

## What the Next Session Needs to Know

1. The Expert Skill Restructure (M3-M5) is structurally sound. No must-fix issues. The 5 findings are all refinements, not blockers.

2. Two should-fix issues need SWE attention before M5 can be considered fully complete:
   - swe-bug-024: Add a Verify phase to QA `/start` (straightforward — copy the pattern from PM or DevOps `/start`)
   - swe-bug-025: Add `architecture.md` to QA, DevOps, and PM role.md Session Protocols (one-line addition to each)

3. Three nit-level techdebt issues can be addressed opportunistically:
   - swe-techdebt-026, -027: Escalation language consistency (minor wording changes)
   - swe-techdebt-028: agent-reference.md phase count accuracy (one sentence edit)

## Open Questions

None.
