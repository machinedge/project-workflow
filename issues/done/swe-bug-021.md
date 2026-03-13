# BUG: Test plan ATP-4 step 7 references deleted CLAUDE.md

**Type:** bug
**Expert:** swe
**Milestone:** M7
**Status:** backlog
**Severity:** should-fix

## Description

`docs/test-plan.md` test matrix row 15 and ATP-4 step 7 reference reading `CLAUDE.md` in the repo root to verify `system-architect/` appears in the repo structure section. `CLAUDE.md` was deleted as part of M7 (swe-feature-016). The test is now invalid.

The intent (verifying SA is represented in generated configs) is already covered by ATP-2 steps 7-8, which check the *generated* `.claude/CLAUDE.md` and `.cursor/rules/project-os.mdc` in an installed project. The repo-level `CLAUDE.md` check should either be removed or redirected to `docs/agent-reference.md` (which absorbed the repo structure content).

## Acceptance Criteria

- [ ] Test matrix row 15 updated or removed to reflect CLAUDE.md deletion
- [ ] ATP-4 step 7 updated or removed accordingly

## Notes

**Found by:** qa-feature-017
**File:** `docs/test-plan.md`, lines 43 and 104
