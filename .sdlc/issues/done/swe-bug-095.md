# BUG: Skill files were left pointing at docs/ after the SDLC-boundary migration

**Type:** bug
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Severity:** must-fix

## Description

The SDLC-boundary migration (M19, tasks swe-feature-088 through swe-feature-093) repointed the role files (`agents/roles/*.md`) and the workflow files (`agents/workflows/*.js`) from `docs/<spec>.md` to `.sdlc/<spec>.md`, but it never touched the skill files (`agents/skills/*/SKILL.md`). As a result the boundary was only half-enforced.

Found by the QA grep audit and end-to-end verification (qa-feature-094, session qa-09). Two concrete failures:

- **Stale authoring references survived.** The canonical audit grep returned 75 hits, not zero. These included true *authoring* targets, not just consume references — so the audit's "no authoring hit may remain" clause was violated. Examples: `agents/skills/qa-test-plan/SKILL.md` saved to `docs/test-plan.md` (lines 43, 113); `agents/skills/sa-design/SKILL.md` drafted/saved `docs/architecture.md` (58, 107); `sec-requirements`, `ux-guidelines`, `doc-plan`, and `ops-release-plan` likewise authored to their old `docs/` paths. Authoring to `docs/` means new specs would have been written outside the boundary.
- **Soft-degradation language remained.** 37 "if it exists" references survived across `agents/`, concentrated in the un-migrated skill files (plus a few role files for genuinely optional context). The SR-008 fail-loud threshold is fewer than 5.

## Acceptance Criteria

- [x] The canonical audit grep returns zero stale `docs/<spec>.md` references across `agents/`, `install.sh`, `install.ps1`, and `docs/project-brief.md` — SR-007
- [x] All skill authoring targets (Save/Draft/Produces lines) point at `.sdlc/`, not `docs/`
- [x] "if it exists" soft-degradation references across `agents/` are below the SR-008 threshold of 5; genuinely optional context reads "when present" while required/conditional specs follow the role files' fail-loud contract — SR-008
- [x] User-facing references (`docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md`, `docs/agent-reference.md`) are left in place

## Notes

**Origin:** Discovered during qa-feature-094 verification (session qa-09).
**Resolution:** Fixed in the same qa-09 verification session. The 19 affected skill files and `docs/project-brief.md` were repointed to `.sdlc/` for the canonical spec tokens and the `research/`, `security/`, `runbooks/` subfolders; the soft-degradation phrasing was reworded. Verified by the deterministic boundary audit grep returning **zero** stale `docs/<spec>.md` authoring/consume references across `agents/`, both installers, and `docs/project-brief.md` (re-confirmed independently during the M19 close-out). (An earlier note here cited a `test-sdlc-boundary.sh` harness — a throwaway artifact since removed; the durable gate is the audit grep, which lives in the QA skill and the M19 test plan at `.sdlc/test-plan.md`.) Filed for the record per qa-feature-094 acceptance criterion 7 (defects found are logged as issue files).
**Affected files:** `agents/skills/{qa-review,qa-bug-triage,doc-handoff,qa-test-plan,sec-requirements,ux-guidelines,doc-plan,pm-postmortem,sec-handoff,ux-handoff,ops-release-plan,pm-decompose,qa-regression,sa-design,doc-author,ops-handoff,sa-research,ops-pipeline,sa-update}/SKILL.md`, `agents/skills/team-docs/SKILL.md`, `agents/commands/{pm-add-feature,ops-env-discovery}.md`, role files for the "when present" reword, `docs/project-brief.md`.
