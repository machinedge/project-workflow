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
| M11 | [Platform-Native Refactor] Fork to platform-native implementations with rules, skills, tools, hooks + context optimization | Done | M7, M10 | 5-8 (actual: ~24) |
| M12 | [Repo Alignment] Remove legacy directories, align docs and CONTRIBUTING.md with platform-native paradigm | Done | M11 | 1-2 (actual: 1) |
| M13 | [Workflow Directory] Update structure and references — all paths point to `.workflow/`, fresh install creates new layout | Done | M12 | 3-5 (actual: 8 SWE + 2 QA + 1 SA + 2 bugfix) |
| M14 | [Workflow Directory] Migration from old structure — install script detects old layout and migrates artifacts | Done | M13 | 2-3 (actual: 3) |
| M15 | [Security Expert] FIPS-focused new expert — design (`sec-` contract, skill inventory, `pm-decompose` change spec, PM reconciliation skill spec) + implementation on both IDE platforms (role, skills, `/sec-start`, `/sec-handoff`, design-time constraints skill, review-time validation skill, `pm-decompose` update, reconciliation skill) + worked demonstration through both engagement gates + CONTRIBUTING/README/agent-reference positioning | Not started | M14 | 9-14 |

## Dependency Map

```
M1 (Core experts) ──┬──> M3 (System Architect)  ──┐
                     │                              ├──> M5 (SWE update + docs-protocol)
                     └──> M4 (Standardize start/handoff) ─┘
M2 (Framework) ──────────> M6 (Deployment Restructure) ──> M7 (Docs + verify) ──┐
M1 (Core experts) ──────> M8 (PM Planning Improvements) ──> M9 (Date Removal)  │
M1 (Core experts) ──────> M10 (Context Optimization research) ──────────────────┼──> M11 (Platform-Native Refactor)
                                                                                 └──────┘       │
                                                                                                └──> M12 (Repo Alignment)
                                                                                                       │
                                                                                                       └──> M13 (Workflow Directory: structure + refs) ──> M14 (Workflow Directory: migration) ──> M15 (Security Expert: FIPS)
```

## Risk Register

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| System Architect becomes a bottleneck for all tasks | High | Medium | Experts escalate on out-of-scope decisions only; no pre-approval required for domain-level work |
| Naming confusion between System Architect expert and domain-level architecture in `/start` | Medium | Medium | Clear documentation in role files and docs-protocol; distinct naming conventions |
| Backward compatibility broken for existing projects | High | Low | SWE `/start` updated, not replaced; existing flow preserved; new skills are additive |
| First-draft skill content requires significant iteration | Medium | High | Flesh out fully for working baseline; user tests on real projects and refines |
| Restructure design doesn't accommodate unforeseen target types | Medium | Low | Simplified to IDE-only (`targets/ide/`); new target classes can be added later |
| Complexity assessment misjudges feature size, shortening interview when it shouldn't | Medium | Low | PM states assumptions explicitly; user can push back and request full interview |
| Removing context that appears unnecessary but is actually essential degrades expert output | High | Medium | Research errs conservative; flag uncertainty; validate recommendations before implementing |
| Platform divergence between Cursor and Claude Code becomes maintenance burden | Medium | High | Manual alignment for now; rebuild sync tooling as needed |
| ~~PowerShell scripts untested on Windows~~ | ~~Medium~~ | ~~Medium~~ | **Resolved in M14:** `install.ps1` functionally tested on macOS PowerShell during swe-feature-078; produces identical results to `install.sh` |
| Auto-triggered skills (handoff, context loading) fire unreliably or at wrong time | Medium | Medium | QA acceptance testing; respond as bugs |
| Retiring canonical definitions makes future platform additions harder | Medium | Low | 5 working experts in `targets/ide/` serve as living examples for new platforms |
| Path reference coverage — missing a `.workflow/` reference means an expert silently reads/writes the wrong location | High | Medium | Systematic grep audit of all path references across both platforms |
| Migration moves or misses user-created files in `docs/` | Medium | Medium | Migration only moves known artifacts by name pattern; leaves everything else |
| Partial migration leaves files split between old and new locations | High | Low | Migration script should be idempotent (safe to re-run) |
| [Security] FIPS depth — model isn't a certified compliance officer; constraints/findings could be plausible-but-wrong | High | Medium | Accept and iterate; real users surface gaps; demonstration must produce substantive non-generic output |
| [Security] `pm-decompose` change emits `sec-` tasks on milestones with no FIPS surface → noise that dilutes signal | Medium | Medium | Empty/short constraint doc is acceptable when nothing applies; design phase defines the low-signal case |
| [Security] Parallel SA+Security and QA+Security produce contradictory or overlapping findings | Medium | Medium | New PM reconciliation skill (scoped into M15) owns merging into a single coherent picture |
| [Security] Shallow or formulaic Security output undermines credibility for regulated audiences (worse than not shipping) | High | Medium | Quality bar enforced in M15 demonstration; positioning in CONTRIBUTING/README reinforces first-class status |
| [Security] M15 estimate (9-14 sessions) is on the larger side; risk of sprawl as in M11 (5-8 → ~24) | Medium | Medium | Postmortem checkpoint; willingness to split into sub-milestones if scope drifts |

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
| — | Added [Platform-Native Refactor] milestone (M11) from interview notes. Absorbs M10 context optimization implementation. Retires platform-agnostic canonical definitions in favor of platform-native implementations. |
| — | Decomposed M11 into 13 tasks: sa-feature-033 (design), swe-feature-034 through swe-feature-038 (Cursor implementation), qa-feature-039 (Cursor QA), swe-feature-040 and swe-feature-041 (Claude Code implementation), qa-feature-042 (Claude Code QA), swe-feature-043 (sync command), swe-feature-044 (install + docs), qa-feature-045 (final regression). |
| — | Post sa-feature-033: reconciled all M11 backlog issues with architecture design. Renamed `tools/` → `scripts/` per ADR-007. Aligned script list with architecture spec (4 + session-context.sh). Added settings.json hook to Claude Code tasks. No new tasks or milestones needed. |
| — | Postmortem: M11 marked Done. 13 planned issues, 29 delivered (2.2x). 24 sessions used vs. 5-8 estimated. 10 ADRs produced (005-010 + 4 operational decisions). 4 QA sessions filed 9 issues (1 must-fix, 6 should-fix, 2 nits), all resolved. Architecture design phase (5 SA sessions) prevented implementation rework. Persistent gap: PowerShell untested on Windows. |
| — | Added [Repo Alignment] milestone (M12) from interview notes. Remove `experts/`, `tools/`, `targets/desktop-cli/`, `targets/autonomous/`. Rewrite `CONTRIBUTING.md`. Update all docs with stale references. |
| — | Postmortem: M12 marked Done. Scoped and executed in 1 combined PM+SWE session. 105 files changed (~10,400 lines removed). No formal issue file — scope was clear enough to execute directly from interview notes. No QA rework needed — deletion + doc rewrite with systematic grep verification. All 12 milestones now complete. |
| — | Added [Workflow Directory] milestones (M13-M14) from interview notes. Split managed artifacts (`.workflow/`) from user-facing docs (`docs/`). |
| — | Decomposed M13 into 13 tasks: sa-feature-063 (design), swe-feature-064 through swe-feature-067 (Cursor: rules, commands, skills, scripts), swe-feature-068 through swe-feature-071 (Claude Code: rules, commands, skills, scripts), swe-feature-072 (install fresh), swe-feature-073 (docs + READMEs), swe-feature-074 (reinstall + verify), qa-feature-075 (grep audit). Decomposed M14 into 4 tasks: swe-feature-076 (bash migration), swe-feature-077 (PowerShell migration), swe-feature-078 (test on this project), qa-feature-079 (end-to-end verification). |
| — | Postmortem: M13 marked Done. 13 planned / 13 delivered + 2 stale-path bugs from QA (swe-bug-080, swe-bug-081) — both resolved. Mechanical execution; ADR-011 left no ambiguity. 2-3x QA rework multiplier did not apply (low cross-expert interaction). |
| — | Postmortem: M14 marked Done. 4 planned / 4 delivered. Install scripts verified on both bash and PowerShell — closes long-standing PowerShell-untested gap from M11. All 14 project milestones now complete. |
| — | Added [Security Expert] milestone (M15) from interview notes. FIPS-focused new persona; bookend workflow (constraints parallel to SA, validation parallel to QA); `pm-decompose` change + new PM reconciliation skill in scope. Single milestone covering design, implementation across both platforms, and worked demonstration. |
