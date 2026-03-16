# Roadmap — MachinEdge Expert Teams

## Milestones

| # | Milestone | Status | Depends On | Sessions Est. |
|---|-----------|--------|------------|---------------|
| M1 | Core experts functional (PM, SWE, QA, DevOps) | Done | — | — |
| M2 | Framework tooling functional (scaffold, validate, install, package) | Done | — | — |
| M3 | [Expert Skill Restructure] System Architect expert with full skill set | Done | M1 | 2 |
| M4 | [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps | Done | M1 | 2 |
| M5 | [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` | Done | M3, M4 | 3 |
| M6 | [Deployment Restructure] Design and implement target-class directory layout | Done | M2 | 3 |
| M7 | [Deployment Restructure] Update docs, remove CLAUDE.md, verify functionality | Done | M6 | 3 |
| M8 | [PM Planning Improvements] Adaptive interview and date-free PM output | Done | M1 | 1-2 |
| M9 | [Date Removal] Remove date references from all remaining expert templates | Done | M8 | 1 |
| M10 | [Context Optimization] Research essential vs. unnecessary startup context per expert | Done | M1 | 1-2 |

## Dependency Map

```
M1 (Core experts) ──┬──> M3 (System Architect)  ──┐
                     │                              ├──> M5 (SWE update + docs-protocol)
                     └──> M4 (Standardize start/handoff) ─┘
M2 (Framework) ──────────> M6 (Deployment Restructure) ──> M7 (Docs + verify)
M1 (Core experts) ──────> M8 (PM Planning Improvements) ──> M9 (Date Removal)
M1 (Core experts) ──────> M10 (Context Optimization research)
```

## Risk Register

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| System Architect becomes a bottleneck for all tasks | High | Medium | Experts escalate on out-of-scope decisions only; no pre-approval required for domain-level work |
| Naming confusion between System Architect expert and domain-level architecture in `/start` | Medium | Medium | Clear documentation in role files and docs-protocol; distinct naming conventions |
| Backward compatibility broken for existing projects | High | Low | SWE `/start` updated, not replaced; existing flow preserved; new skills are additive |
| First-draft skill content requires significant iteration | Medium | High | Flesh out fully for working baseline; user tests on real projects and refines |
| Restructure design doesn't accommodate unforeseen target types | Medium | Medium | Design for known target classes (IDE, Desktop/Code, Autonomous); iterate structure as new targets are added |
| Complexity assessment misjudges feature size, shortening interview when it shouldn't | Medium | Low | PM states assumptions explicitly; user can push back and request full interview |
| Removing context that appears unnecessary but is actually essential degrades expert output | High | Medium | Research errs conservative; flag uncertainty; validate recommendations before implementing |

## Change Log

| Date | Change |
|------|--------|
| 2026-03-12 | Initial roadmap created. M1 and M2 marked as done (pre-existing). Added Expert Skill Restructure milestones (M3-M5) from interview notes. |
| 2026-03-12 | Decomposed M3-M5 into 5 tasks: swe-feature-001 (M3), swe-feature-002 and swe-feature-003 (M4), swe-feature-004 and qa-feature-005 (M5). |
| 2026-03-12 | Added swe-feature-006 (update install scripts for System Architect) to M3. |
| 2026-03-12 | QA review completed (qa-feature-005). Created 6 fix issues: swe-bug-007 (must-fix), swe-techdebt-008 through swe-techdebt-012 (should-fix). |
| 2026-03-12 | Added Deployment Restructure milestones (M6-M7) from interview notes. |
| 2026-03-12 | Decomposed M6-M7 into 5 tasks: sa-feature-013 (M6, design), swe-feature-014 and swe-feature-015 (M6, implementation), swe-feature-016 and qa-feature-017 (M7, docs + verification). |
| 2026-03-12 | Postmortem: M3-M7 all marked Done. 28 issues delivered (vs. 11 planned). Cleanup tail from QA reviews accounted for the gap. All risks mitigated successfully. |
| — | Added [PM Planning Improvements] milestone (M8) from interview notes. |
| — | Decomposed M8 into 2 tasks: swe-feature-029 (remove dates), swe-feature-030 (adaptive interview). |
| — | Postmortem: M8 marked Done. 2 issues planned, 2 delivered. No QA rework needed — template-only changes with low regression risk. |
| — | Added [Date Removal] milestone (M9) from interview notes. |
| — | Decomposed M9 into 1 task: swe-feature-031 (remove dates from all remaining experts + lessons-log). |
| — | Postmortem: M9 marked Done. 1 issue planned, 1 delivered. M8+M9 together delivered full date removal across all experts in 3 sessions with zero rework. |
| — | Added [Context Optimization] milestone (M10) from interview notes. |
| — | Decomposed M10 into 1 task: sa-research-032 (audit startup context, produce matrix + recommendations). |
