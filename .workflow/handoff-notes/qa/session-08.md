# Handoff Note: Verify Migration End-to-End

**Issue:** qa-feature-079 — QA: Verify Migration End-to-End

## What Was Accomplished

End-to-end verification of the `.workflow/` migration. Audited artifact locations, confirmed old paths are clean, tested all 4 core scripts, verified install idempotency, checked CLAUDE.md paths (both source and installed), and ran a cross-platform source audit across `targets/ide/`.

## Findings Summary
- **Must-fix:** 0 issues
- **Should-fix:** 1 issue
- **Nit:** 0 issues
- `.workflow/issues/backlog/swe-bug-081.md` — architecture.md has 4 stale paths in non-ADR sections (lines 31, 346, 513, 537)

## Acceptance Criteria Status
- [x] All managed artifacts confirmed in `.workflow/`
- [x] No managed artifacts remain in old locations (`docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, `issues/`)
- [x] At least 2 different expert sessions start and complete without path errors (team-status + this QA session)
- [x] All 4 core scripts execute successfully against `.workflow/` paths
- [x] Re-running install.sh does not duplicate or error
- [x] Issues found filed in `.workflow/issues/backlog/` (swe-bug-081)

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Classified architecture.md stale paths as should-fix, not must-fix | Documentation file, not a runtime artifact; no functional impact on expert workflows |
| Did not file issue for old path references inside pre-migration handoff notes | Historical records naturally reference paths that existed when written; rewriting would be revisionist |

## Problems Encountered
None. The migration was clean and all verification steps passed on first attempt.

## Files Reviewed

### Artifact locations
- `.workflow/handoff-notes/` — all 5 expert subdirs present (pm/3, swe/42, qa/8, devops/0, sa/8)
- `.workflow/issues/` — all 4 status dirs + issues-list.md (backlog/1, done/79)
- `.workflow/*.md` — 8 interview notes, lessons-log.md, research-context-optimization.md
- `docs/` — only 5 planning docs remain (project-brief, roadmap, architecture, agent-reference, test-plan)
- Old locations (docs/handoff-notes/, docs/interview-notes*, docs/lessons-log.md, docs/research-*, issues/) — all absent

### Scripts tested
- `.cursor/scripts/next-issue-number.sh` — returned 081 (correct)
- `.cursor/scripts/next-session-number.sh qa` — returned 08, created placeholder (correct)
- `.cursor/scripts/update-issues-list.sh` — regenerated successfully
- `.cursor/scripts/move-issue.sh` — round-trip backlog→planned→backlog (correct)

### Install idempotency
- Re-ran `targets/ide/install.sh .` — exit 0, all counts identical before/after, no old locations recreated

### Source files audited
- `targets/ide/claude-code/CLAUDE.md` — correct `.workflow/` paths (resolved SWE session-42 concern)
- `.claude/CLAUDE.md` — correct `.workflow/` paths
- `targets/ide/claude-code/roles/` — all correct
- `targets/ide/claude-code/scripts/` — all correct
- `targets/ide/cursor/` and `targets/ide/claude-code/` — grep for stale patterns returned zero matches in skill/command/rule files
- `docs/architecture.md` — 4 stale refs found in non-ADR sections (filed as swe-bug-081)
- `docs/project-brief.md` — correct (swe-bug-080 fix confirmed)

## What the Next Session Needs to Know

1. **qa-feature-079 is complete.** All 6 acceptance criteria met. M13+M14 migration is verified end-to-end.
2. **One should-fix remains:** swe-bug-081 — 4 stale paths in `docs/architecture.md` non-ADR sections. Trivial fix (4 string replacements). The ADR-011 section itself is correct and should not be modified.
3. **The install script does NOT update path references inside migrated documents.** It only moves files. Pre-migration handoff notes retain old paths — this is acceptable since they're historical records and all new content uses correct paths.
4. **SWE session-42's CLAUDE.md concern is resolved.** Both source and installed files have correct `.workflow/` paths. The stale paths visible in Cursor's auto-appended rule context are a Cursor indexing artifact.

## Open Questions
- None
