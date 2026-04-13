# Handoff Note: Verify Deployment Restructure End-to-End

**Session date:** 2026-03-12
**Issue:** qa-feature-017 — Verify Deployment Restructure End-to-End

## What Was Reviewed

Full end-to-end verification of the Deployment Restructure (M6 + M7) covering: validation, install, packaging, scaffolding, OpenClaw isolation, extensibility model, documentation consistency, CLAUDE.md removal, and stale path sweep.

## Scope of Review

All 9 verification areas defined in the issue were covered. Runtime testing was performed for validation, install, and scaffolding. Package.sh and install-team.sh were code-reviewed only (packaging requires python3 tooling download; team mode requires Docker).

## Findings Summary

| Severity | Count |
|----------|-------|
| must-fix | 1 |
| should-fix | 3 |
| nit | 1 |
| **total** | **5** |

### must-fix

1. **swe-bug-018: README.md Quick Start references non-existent `./workflows/setup.sh`** — The Quick Start section uses a path that doesn't exist and never has. Should be `./targets/ide/install.sh`. Also uses `--expert` (singular) instead of `--experts` (plural).

### should-fix

2. **swe-bug-019: Multiple docs reference non-existent files** — `docs/overview.md`, `docs/getting-started.md`, and `docs/workflow-anatomy.md` are referenced in README.md, agent-reference.md, CONTRIBUTING.md, and openclaw README.md but none exist. PM should decide whether to create them or remove the references.

3. **swe-bug-020: IDE target READMEs missing System Architect prefix** — Both `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md` Skill Namespacing tables omit the `sa-` prefix for System Architect, despite the install script supporting it.

4. **swe-bug-021: Test plan ATP-4 step 7 references deleted CLAUDE.md** — `docs/test-plan.md` has a test step that checks the repo-level `CLAUDE.md` which was deleted in M7. The test is invalid and should be updated or removed.

### nit

5. **SKILL.md Edge Cases references `./tools/scaffold/create-expert.sh`** — This path doesn't exist in the packaged `.skill` file (scaffold tools are dev-only). Not filed as an issue — the reference is guidance text for the AI, and scaffold is a repo-level activity.

## Verification Results

| Check | Result | Method |
|-------|--------|--------|
| Validation (`validate.sh`) | PASS — 5/5 experts, 0 failures | Runtime |
| Install (`install.sh`) | PASS — 30 commands, 5 roles, 6 rules, SA fully represented, handoff dirs created | Runtime |
| Packaging (`package.sh`) | PASS — paths consistent with SKILL.md, package structure matches | Code review |
| Scaffolding (`create-expert.sh`) | PASS — creates expert structure, correct validate path in output | Runtime |
| OpenClaw isolation | PASS — 14 files in `targets/autonomous/openclaw/`, no references leak to other targets | Inspection |
| Extensibility model | PASS — no cross-class target references; adding a new target class is atomic | Inspection |
| Documentation consistency | 4 ISSUES FOUND — see findings above | Inspection + grep |
| CLAUDE.md removal | PASS — deleted, essential content preserved in `docs/agent-reference.md` | Inspection |
| Stale path sweep | PASS — no `framework/` or `package/` references outside historical records | grep sweep |

## Acceptance Criteria Status (from issue)

- [x] All verification checks performed — issues filed for failures
- [x] Findings documented in QA handoff note (this document)

## What the Next Session Needs to Know

1. The deployment restructure is functionally sound — validation, install, and scaffolding all work end-to-end. The core infrastructure (directory layout, script path resolution, OpenClaw isolation, extensibility model) is solid.

2. Four documentation issues need fixing before this milestone can be considered complete. The must-fix (swe-bug-018) is a Quick Start that would fail for any new user.

3. The non-existent docs question (swe-bug-019) requires a PM decision: create the three referenced docs, or remove the references. This affects multiple files.

4. Pre-existing phase-count warnings on PM, QA, and DevOps `/start` skills (5 phases instead of 7) are unrelated to the deployment restructure and were not filed.

## Open Questions

None.
