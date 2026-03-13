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

## Dependency Map

```
M1 (Core experts) ──┬──> M3 (System Architect)  ──┐
                     │                              ├──> M5 (SWE update + docs-protocol)
                     └──> M4 (Standardize start/handoff) ─┘
M2 (Framework) ──────────> M6 (Deployment Restructure) ──> M7 (Docs + verify)
```

## Risk Register

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| System Architect becomes a bottleneck for all tasks | High | Medium | Experts escalate on out-of-scope decisions only; no pre-approval required for domain-level work |
| Naming confusion between System Architect expert and domain-level architecture in `/start` | Medium | Medium | Clear documentation in role files and docs-protocol; distinct naming conventions |
| Backward compatibility broken for existing projects | High | Low | SWE `/start` updated, not replaced; existing flow preserved; new skills are additive |
| First-draft skill content requires significant iteration | Medium | High | Flesh out fully for working baseline; user tests on real projects and refines |
| Restructure design doesn't accommodate unforeseen target types | Medium | Medium | Design for known target classes (IDE, Desktop/Code, Autonomous); iterate structure as new targets are added |

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
