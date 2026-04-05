# Create Cursor-Native SWE and QA Expert Skills

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Cursor user running SWE or QA sessions, I want the AI to automatically load context when I start work and auto-trigger handoff when I'm done so that I spend time on implementation and review, not on session ceremony.

## Description

Transform the SWE (2 files) and QA (6 files) canonical skill files into Cursor-native formats per the design from sa-feature-033. SWE has start (hybrid) and handoff (hook). QA has start (hybrid), handoff (hook), review (skill), test-plan (skill), regression (skill), and bug-triage (skill).

## Acceptance Criteria

- [ ] SWE `start` → hybrid (auto context loading; approval gates at Phase 1, 2, 3 remain explicit)
- [ ] SWE `handoff` → auto-trigger hook
- [ ] QA `start` → hybrid (auto context loading; approval gates remain)
- [ ] QA `handoff` → auto-trigger hook
- [ ] QA `review` → discoverable skill (autonomous code review with user review of findings)
- [ ] QA `test-plan` → discoverable skill (produces plan, user reviews)
- [ ] QA `regression` → discoverable skill (autonomous regression analysis)
- [ ] QA `bug-triage` → discoverable skill (autonomous triage with user review)
- [ ] All skills reference shell scripts from `.cursor/tools/` for mechanical operations
- [ ] Each skill has its own context loading steps
- [ ] QA skills include own handoff notes in context loading (M10 Rec 4 fix applied at skill level)

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-033 (design), swe-feature-034 (shell scripts), swe-feature-035 (Cursor rules structure)
**Inputs:** project brief, sa-feature-033 design, `experts/technical/swe/skills/*.md`, `experts/technical/qa/skills/*.md`
**Out of scope:** Other experts. Claude Code version.
