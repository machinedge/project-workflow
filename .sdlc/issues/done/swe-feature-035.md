# Create Cursor Rules and Project Structure

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Cursor user, I want only the relevant expert role loaded into my session so that my context window isn't wasted on 4 irrelevant expert definitions.

## Description

Create the Cursor-native rules structure in `targets/ide/cursor/`. Implement M10 Recommendations 1 (conditional rules), 3 (scoped handoff loading), and 4 (QA bug fix). Rewrite `project-os.mdc` as the sole always-on rule that routes to the correct expert. Make all 5 expert-specific rules conditional. Set up the directory structure that downstream tasks will populate with skills and commands.

## Acceptance Criteria

- [ ] `targets/ide/cursor/rules/project-os.mdc` is `alwaysApply: true` — routes to correct expert, references skill discovery
- [ ] 5 expert rule files are conditional (`alwaysApply: false`) and load only when the agent identifies the active expert
- [ ] QA rule file includes own handoff notes in session protocol (M10 Rec 4 fix)
- [ ] PM and SA rules scope handoff loading to own subdirectory only (M10 Rec 3)
- [ ] Session protocol document-loading instructions removed from rules — skills handle their own context loading (M10 Rec 2)
- [ ] `targets/ide/cursor/` directory structure matches the design from sa-feature-033
- [ ] `docs-protocol` content integrated as a rule or reference
- [ ] Existing functionality preserved — an expert session can still be started (even if skills aren't yet migrated in later tasks)

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-033 (design defines structure and rule format)
**Inputs:** project brief, sa-feature-033 design output, `docs/research-context-optimization.md`, current `.cursor/rules/*.mdc` files
**Out of scope:** Skill files (subsequent tasks). Shell script integration (done in swe-feature-034). Claude Code rules (separate task).
