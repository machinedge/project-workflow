# Handoff Note: Fix IDE README Prefix Tables and Test Plan CLAUDE.md Reference

**Session date:** 2026-03-12
**Issues:** swe-bug-020, swe-bug-021

## What Was Accomplished

**swe-bug-020:** Added `sa-` → System Architect row to the Skill Namespacing tables in both `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md`.

**swe-bug-021:** Updated `docs/test-plan.md` test matrix row 15 and ATP-4 step 7 to reference `docs/agent-reference.md` instead of the deleted `CLAUDE.md`.

## Acceptance Criteria Status

**swe-bug-020:**
- [x] `targets/ide/cursor/README.md` Skill Namespacing table includes `sa-` → System Architect row
- [x] `targets/ide/claude-code/README.md` Skill Namespacing table includes `sa-` → System Architect row

**swe-bug-021:**
- [x] Test matrix row 15 updated to reference `docs/agent-reference.md`
- [x] ATP-4 step 7 updated to reference `docs/agent-reference.md`

## Decisions Made This Session

None. Straightforward bug fixes.

## Problems Encountered

None.

## Scope Changes

None.

## Files Modified

- `targets/ide/cursor/README.md` — Added `sa-` row to prefix table
- `targets/ide/claude-code/README.md` — Added `sa-` row to prefix table
- `docs/test-plan.md` — Row 15 and ATP-4 step 7: `CLAUDE.md` → `docs/agent-reference.md`

## What the Next Session Needs to Know

1. All four QA doc bugs (swe-bug-018 through swe-bug-021) are now resolved except swe-bug-019 (broken doc links), which is blocked on pm-feature-022.

2. Remaining backlog: pm-feature-022 (PM decision on missing docs), swe-bug-019 (blocked on pm-feature-022), swe-bug-023 (PM decompose skill missing Prerequisites column), qa-feature-005 (QA consistency review).

## Open Questions

None.
