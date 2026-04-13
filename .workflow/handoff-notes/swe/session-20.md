# Handoff Note: Create Cursor-Native SWE and QA Expert Skills

**Issue:** swe-feature-037 — Create Cursor-Native SWE and QA Expert Skills

## What Was Accomplished

Transformed all 8 SWE and QA canonical skill files into Cursor-native formats in `targets/ide/cursor/`. Created 2 commands (swe-start, qa-start) and 6 discoverable skills (swe-handoff, qa-handoff, qa-review, qa-test-plan, qa-regression, qa-bug-triage). Each skill has YAML frontmatter with discovery-optimized descriptions, its own context loading, and references to `.cursor/scripts/` for mechanical operations.

## Acceptance Criteria Status

- [x] SWE `start` → hybrid (auto context loading; approval gates at Phase 1, 2, 3 remain explicit)
- [x] SWE `handoff` → auto-trigger hook
- [x] QA `start` → hybrid (auto context loading; approval gates remain)
- [x] QA `handoff` → auto-trigger hook
- [x] QA `review` → discoverable skill (autonomous code review with user review of findings)
- [x] QA `test-plan` → discoverable skill (produces plan, user reviews)
- [x] QA `regression` → discoverable skill (autonomous regression analysis)
- [x] QA `bug-triage` → discoverable skill (autonomous triage with user review)
- [x] All skills reference shell scripts from `.cursor/scripts/` for mechanical operations
- [x] Each skill has its own context loading steps
- [x] QA skills include own handoff notes in context loading (M10 Rec 4 fix applied at skill level)

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Added `architecture.md` to QA skill context loading (review, test-plan, regression, bug-triage) | Canonical files didn't consistently load it, but QA review has an "Architecture Fit" evaluation section, and other QA skills benefit from architectural context when assessing impact and test scope. |
| QA start command includes script references for issue creation (Phase 5) | Canonical QA start mentioned creating issue files but had no script references. Cursor-native version uses `next-issue-number.sh` and `update-issues-list.sh` for consistency with other skills. |
| Skill descriptions follow "what + when" pattern | Per lessons log: descriptions that answer both "what does this do?" and "when should the agent use it?" perform better for agent discovery (~50% reliability on Cursor). |

## Problems Encountered

None. The pattern established by swe-feature-036 (PM skills) made implementation straightforward. All 8 files followed the same adaptation rules.

Note: this handoff note was originally overwritten by a concurrent swe-feature-038 session that computed the same session number. Restored after the collision was discovered. See sa-bug-048 for the underlying concurrency issue.

## Scope Changes

None. Task went exactly as planned — 2 commands + 6 skills, matching the architecture mapping table.

## Files Created or Modified

- `targets/ide/cursor/commands/swe-start.md` — SWE start command (7 phases, approval gates)
- `targets/ide/cursor/commands/qa-start.md` — QA start command (6 phases, approval gates)
- `targets/ide/cursor/skills/swe-handoff/SKILL.md` — SWE session handoff with auto-trigger
- `targets/ide/cursor/skills/qa-handoff/SKILL.md` — QA session handoff with auto-trigger
- `targets/ide/cursor/skills/qa-review/SKILL.md` — Fresh-eyes code review with issue creation
- `targets/ide/cursor/skills/qa-test-plan/SKILL.md` — Test plan generation
- `targets/ide/cursor/skills/qa-regression/SKILL.md` — Milestone regression check
- `targets/ide/cursor/skills/qa-bug-triage/SKILL.md` — Bug backlog prioritization

## What the Next Session Needs to Know

1. **SWE and QA experts are complete for Cursor.** All 8 skills converted (2 commands + 6 skills).
2. **DevOps and SA were completed by swe-feature-038** (session-21) in a parallel session: 4 commands + 8 skills.
3. **All five experts now have Cursor-native skills.** The Cursor target has 9 commands + 21 skills, matching the architecture's full skill map.
4. **team-status was already done** in swe-feature-036. No duplication.
5. **Script references are consistent.** `swe-handoff` and `qa-handoff` use `next-session-number.sh`, `move-issue.sh`, and `update-issues-list.sh`. `qa-review`, `qa-regression`, and `qa-start` use `next-issue-number.sh` and `update-issues-list.sh` for issue creation.

## Open Questions

None.
