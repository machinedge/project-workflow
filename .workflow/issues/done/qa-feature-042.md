# QA: Review Claude Code Implementation for Completeness and Consistency

**Type:** feature
**Expert:** qa
**Milestone:** M11
**Status:** backlog

## Description

Fresh-eyes review of the complete Claude Code platform-native implementation. Verify all 5 experts are correctly implemented. Compare against the Cursor implementation for content parity — the format should differ (platform-native) but the behavior and coverage should match.

## Scope

- All Claude Code rules — correct conditional loading, expert routing
- All Claude Code skills across 5 experts — correct format, self-contained context loading
- All Claude Code commands — interview-style and deploy correctly remain explicit
- All handoff hooks — auto-trigger mechanism defined
- Shell scripts in `targets/ide/claude-code/scripts/` — identical to Cursor versions
- Cross-platform parity — every Cursor skill has a Claude Code equivalent with matching acceptance criteria
- M10 recommendations applied consistently with Cursor version

## Acceptance Criteria

- [ ] All 5 experts have the correct number of skills/commands/hooks matching the design
- [ ] Content parity with Cursor implementation — no expert or skill missing from Claude Code that exists in Cursor
- [ ] Shell scripts are identical between Cursor and Claude Code (diff produces no output)
- [ ] Claude Code-specific conventions are correctly applied (not just Cursor files with different paths)
- [ ] No must-fix issues found, or must-fix issues filed in `issues/backlog/`
- [ ] Findings recorded as issue files per QA review conventions

## Session 04 Summary

**What was done:** Systematic review of all 46 Claude Code files. Verified structural completeness, content parity with Cursor, script identity, Claude Code-specific conventions, M10 recommendations, and bug fix incorporation. Filed 2 issues (0 must-fix, 1 should-fix, 1 nit).
**Handoff note:** `docs/handoff-notes/qa/session-04.md`
**All acceptance criteria met:** No — 2 of 6 criteria not met due to `team-status` skill missing from Claude Code (swe-feature-053). Remaining 4 criteria fully met.

## Notes

**Depends on:** swe-feature-040, swe-feature-041
**Inputs:** sa-feature-033 design, Cursor implementation in `targets/ide/cursor/`, SWE handoff notes for 040-041
