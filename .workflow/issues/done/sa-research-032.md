# Audit Startup Context and Produce Optimization Matrix

**Type:** research
**Expert:** system-architect
**Milestone:** M10
**Status:** done

## User Story

As a toolkit maintainer, I need to understand which startup context documents are essential, nice-to-have, or unnecessary for each expert so that I can reduce token cost, preserve context window space, and improve output quality by eliminating excessive context loading.

## Description

Audit the "Starting a session" protocol across all 5 experts (PM, SWE, QA, DevOps, System Architect). For each expert, catalog every document they currently read on startup — both in the canonical role definitions (`experts/technical/*/role.md`) and the platform-specific workspace rules (`.cursor/rules/*-os.mdc`). Analyze what each expert actually uses each document for during its skills, then classify each expert x document pair. Produce a matrix and recommendations.

## Acceptance Criteria

- [ ] Every document referenced in each expert's "Starting a session" protocol is cataloged
- [ ] Both canonical role files and `.cursor/rules/*-os.mdc` workspace rules are covered
- [ ] Each expert x document pair is classified as essential, nice-to-have, or unnecessary with brief rationale
- [ ] Classifications with low certainty are explicitly flagged
- [ ] A recommendation section proposes specific changes with rationale
- [ ] Recommendations err conservative — when uncertain, classify as nice-to-have rather than unnecessary
- [ ] Research is saved to `docs/research-context-optimization.md`

## Technical Notes

**Estimated effort:** 1 session
**Dependencies:** None
**Inputs:** All 5 expert role files (`experts/technical/*/role.md`), all workspace rules (`.cursor/rules/*-os.mdc`), `experts/technical/shared/docs-protocol.md`, skill files for each expert (to understand what documents are actually consumed during execution)
**Out of scope:** Implementing changes to session protocols or role files — this task produces research only.

## Session 02 Summary

**What was done:** Audited all 5 experts' startup context loading across role files, workspace rules, and `/start` skills. Produced classification matrices and 4 prioritized recommendations. Research saved to `docs/research-context-optimization.md`.
**Handoff note:** `docs/handoff-notes/system-architect/session-02.md`
**All acceptance criteria met:** Yes
