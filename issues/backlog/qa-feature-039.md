# QA: Review Cursor Implementation for Completeness and Consistency

**Type:** feature
**Expert:** qa
**Milestone:** M11
**Status:** backlog

## Description

Fresh-eyes review of the complete Cursor platform-native implementation. Verify that all 5 experts are correctly implemented with the right mix of rules, skills, commands, and hooks. Verify M10 recommendations are properly applied. Test that auto-triggering and skill discovery work as designed.

## Scope

- All Cursor rules in `targets/ide/cursor/rules/` — correct conditional loading, no always-on bloat
- All Cursor skills across 5 experts — correct format, discoverable, self-contained context loading
- All Cursor commands — interview-style and deploy correctly remain explicit
- All handoff hooks — auto-trigger mechanism works
- Shell scripts in `targets/ide/cursor/scripts/` — all 5 scripts present, executable, handle edge cases
- M10 recommendations — Rec 1 (conditional rules), Rec 2 (doc loading in skills not protocols), Rec 3 (scoped handoffs), Rec 4 (QA bug fix) all implemented
- Cross-expert consistency — naming conventions, file structure, context loading patterns are uniform
- No canonical file left unmapped — every file in `experts/technical/` (excluding data-analyst and shared) has a Cursor counterpart

## Acceptance Criteria

- [ ] All 5 expert rules are conditional (`alwaysApply: false`); only `project-os` is always-on
- [ ] Each expert has the correct number of skills/commands/hooks matching the design from sa-feature-033
- [ ] No skill relies on session protocol preamble for context loading — each has its own loading steps
- [ ] Handoff hooks reference shell scripts for mechanical operations (session numbering, issue movement, etc.)
- [ ] Shell scripts are present, executable, and handle empty-directory edge cases
- [ ] No must-fix issues found, or must-fix issues filed in `issues/backlog/`
- [ ] Findings recorded as issue files per QA review conventions

## Notes

**Depends on:** swe-feature-035, swe-feature-036, swe-feature-037, swe-feature-038
**Inputs:** sa-feature-033 design, SWE handoff notes for 035-038, `docs/research-context-optimization.md`
