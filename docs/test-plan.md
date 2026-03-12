# Test Plan

**Scope:** Expert Skill Restructure — Milestones M3, M4, M5
**Created:** 2026-03-12
**Last updated:** 2026-03-12

## Test Scope

Validates the Expert Skill Restructure feature: System Architect expert creation, `/start` and `/handoff` standardization across all experts, `architecture.md` integration, and install script updates.

### In Scope
- System Architect expert structure and skill content (M3)
- PM, QA, DevOps `/start` and `/handoff` skills (M4)
- SWE `/start` updates for `architecture.md` (M5)
- Cross-expert consistency (role files, docs-protocol, escalation behavior)
- Install script support for System Architect (M3)
- Backward compatibility with existing projects

### Out of Scope
- Data Analyst and User Experience experts (under development)
- Team mode / OpenClaw translation
- Package/distribution tooling
- Existing domain-specific skills (QA `/review`, DevOps `/pipeline`, etc.) — these were not modified

## Test Matrix

| # | Behavior | Source | Test Level | Approach | Infrastructure | Priority |
|---|----------|--------|-----------|----------|---------------|----------|
| 1 | System Architect expert passes structural validation | swe-feature-001, AC 10 | Unit | Run `./framework/validate/validate.sh technical/system-architect` | Local | P1 |
| 2 | All original experts still pass structural validation | Backward compat constraint | Unit | Run `validate.sh` for each of: `technical/project-manager`, `technical/swe`, `technical/qa`, `technical/devops` | Local | P1 |
| 3 | Install script produces correct structure with SA included | swe-feature-006 | Integration | Run `./framework/install/install.sh /tmp/test-proj` and verify output files | Local | P1 |
| 4 | Install script works with `--experts` flag excluding SA | swe-feature-006 | Integration | Run `./install.sh --experts pm,swe,qa,devops /tmp/test-proj-no-sa` and verify SA files absent | Local | P2 |
| 5 | Generated CLAUDE.md includes SA expert and skills | swe-feature-006 | Integration | Inspect `/tmp/test-proj/.claude/CLAUDE.md` for SA entries | Local | P1 |
| 6 | Generated project-os.mdc includes SA expert and skills | swe-feature-006 | Integration | Inspect `/tmp/test-proj/.cursor/rules/project-os.mdc` for SA entries | Local | P1 |
| 7 | Every expert's `/start` loads `architecture.md` | swe-bug-007, swe-feature-004 | System | Grep all `start.md` files for `architecture.md` reference; verify `(if it exists)` qualifier present | Local | P1 |
| 8 | Every expert's role.md lists `/start` and `/handoff` in Skills | swe-feature-002, -003 | System | Grep all `role.md` files for `/start` and `/handoff` entries | Local | P1 |
| 9 | SWE, QA, DevOps role files include escalation principle | swe-techdebt-008, swe-feature-004 | System | Grep `role.md` files for "Escalate" in Principles section | Local | P1 |
| 10 | docs-protocol lists `architecture.md` in Document Locations | swe-feature-004, AC 4 | System | Read docs-protocol.md, verify Architecture row in table | Local | P1 |
| 11 | docs-protocol Workflow Contracts includes System Architect | swe-feature-004, AC 4 | System | Read docs-protocol.md, verify SA rows in Contracts table | Local | P1 |
| 12 | docs-protocol Handoff Notes description includes system-architect/ | swe-techdebt-012 | System | Read docs-protocol.md, verify system-architect/ in description and tree | Local | P2 |
| 13 | PM role.md lists `/update-plan` in Skills | swe-techdebt-011 | System | Read PM role.md, verify entry | Local | P2 |
| 14 | PM handoff template includes "Problems Encountered" | swe-techdebt-009 | System | Read PM handoff.md, verify section exists | Local | P2 |
| 15 | CLAUDE.md repo guide lists system-architect/ | swe-techdebt-010 | System | Read CLAUDE.md, verify system-architect/ in repo structure | Local | P2 |
| 16 | PM role.md references correct docs-protocol path | swe-techdebt-012 | System | Verify `experts/technical/shared/docs-protocol.md` (not `experts/shared/`) | Local | P2 |
| 17 | Backward compat: SWE /start still has all 7 phases | Backward compat constraint | System | Read SWE start.md, verify Phase 1-7 present | Local | P1 |
| 18 | Backward compat: existing skills unmodified | swe-feature-002 AC 8, -003 AC 9-10 | System | Verify QA review/test-plan/regression/bug-triage unchanged; DevOps env-discovery/pipeline/release-plan/deploy unchanged | Local | P1 |
| 19 | SA `/start` behavioral test: pick up issue, load context, execute | swe-feature-001, AC 7 | Acceptance | Install into test project, create an SA-scoped issue, run `/sa-start`, verify it loads context and executes | Real project | P1 |
| 20 | PM `/start` behavioral test: pick up PM issue and execute | swe-feature-002, AC 3-5 | Acceptance | Install into test project, create a PM-scoped issue, run `/pm-start`, verify it loads context and executes PM work | Real project | P1 |
| 21 | SWE `/start` behavioral test: respects architecture.md | swe-feature-004, AC 1-3 | Acceptance | Install into test project, create `docs/architecture.md`, run `/swe-start`, verify it loads architecture and scopes to domain-level | Real project | P1 |
| 22 | QA `/start` behavioral test: loads architecture.md | swe-bug-007 | Acceptance | Install into test project, create `docs/architecture.md`, run `/qa-start`, verify it loads architecture context | Real project | P2 |
| 23 | Escalation behavioral test: SWE flags out-of-scope decision | swe-feature-004, AC 3 | Acceptance | Run `/swe-start` on a task requiring an architectural decision not covered by architecture.md; verify agent flags it rather than assuming | Real project | P1 |
| 24 | Graceful degradation: experts proceed without architecture.md | swe-feature-004, AC 11 | Acceptance | Install into test project with NO `docs/architecture.md`; run `/swe-start`; verify session starts normally without errors | Real project | P2 |

### Priority Key
- **P1** — Must test. Core functionality, high risk, or blocking.
- **P2** — Should test. Important but not blocking.

## Acceptance Test Procedures

### ATP-1: Structural Validation (Tests #1, #2)
**Tests:** Matrix rows 1-2
**Prerequisites:** None
1. Run `./framework/validate/validate.sh technical/system-architect`
2. Run `./framework/validate/validate.sh technical/project-manager`
3. Run `./framework/validate/validate.sh technical/swe`
4. Run `./framework/validate/validate.sh technical/qa`
5. Run `./framework/validate/validate.sh technical/devops`
**Expected result:** All experts pass with 0 failures and 0 warnings

### ATP-2: Install Script Full Test (Tests #3, #5, #6)
**Tests:** Matrix rows 3, 5, 6
**Prerequisites:** Clean target directory
1. Run `./framework/install/install.sh /tmp/test-expert-install`
2. Verify `system-architect` appears in the installed experts list output
3. Verify `.claude/roles/system-architect.md` exists
4. Verify `.cursor/rules/system-architect-os.mdc` exists
5. Verify `.claude/commands/sa-*.md` files exist (6 skills)
6. Verify `.cursor/commands/sa-*.md` files exist (6 skills)
7. Open `.claude/CLAUDE.md` — verify "System Architect" appears in Experts list and skill list
8. Open `.cursor/rules/project-os.mdc` — verify "System Architect" appears in Experts list and skill list with `sa=System Architect` in prefix mapping
9. Verify `docs/handoff-notes/system-architect/` directory exists
10. Clean up: `rm -rf /tmp/test-expert-install`
**Expected result:** All files present, SA expert fully represented in generated configs

### ATP-3: Install Script Exclude Test (Test #4)
**Tests:** Matrix row 4
**Prerequisites:** Clean target directory
1. Run `./framework/install/install.sh --experts pm,swe,qa,devops /tmp/test-no-sa`
2. Verify no `sa-*.md` files in `.claude/commands/` or `.cursor/commands/`
3. Verify no `system-architect.md` in `.claude/roles/`
4. Verify no `system-architect-os.mdc` in `.cursor/rules/`
5. Clean up: `rm -rf /tmp/test-no-sa`
**Expected result:** SA expert absent when excluded from `--experts` list

### ATP-4: Cross-Expert Consistency Check (Tests #7-16)
**Tests:** Matrix rows 7-16
**Prerequisites:** None
1. For each expert (PM, SWE, QA, DevOps, System Architect): verify `start.md` references `architecture.md` with `(if it exists)` qualifier
2. For each expert: verify `role.md` lists `/start` and `/handoff` in Skills section
3. For SWE, QA, DevOps: verify `role.md` Principles includes escalation instruction
4. Read `experts/technical/shared/docs-protocol.md`: verify `architecture.md` in Document Locations, System Architect in Workflow Contracts, `system-architect/` in handoff conventions
5. Read PM `role.md`: verify `/update-plan` listed, correct docs-protocol path
6. Read PM `handoff.md`: verify "Problems Encountered" section
7. Read `CLAUDE.md`: verify `system-architect/` in repo structure
**Expected result:** All cross-references and conventions are consistent

### ATP-5: Behavioral Acceptance — SA Start (Test #19)
**Tests:** Matrix row 19
**Prerequisites:** Toolkit installed into a test project
1. Create a file `issues/backlog/sa-feature-001.md` with a simple architectural task
2. Run `/sa-start sa-feature-001`
3. Verify the agent reads: project brief, architecture.md (if present), roadmap, lessons log, the issue file, most recent SA handoff note
4. Verify the agent confirms understanding and waits for approval
5. Verify the agent produces architectural artifacts (not code)
**Expected result:** SA expert follows its `/start` protocol correctly

### ATP-6: Behavioral Acceptance — Escalation (Test #23)
**Tests:** Matrix row 23
**Prerequisites:** Toolkit installed into a test project with a minimal `docs/architecture.md`
1. Create an SWE issue that requires a decision about a new component boundary (something NOT covered in architecture.md)
2. Run `/swe-start` on the issue
3. During Phase 3 (Architect), verify the agent flags the uncovered decision and asks the user rather than assuming
**Expected result:** SWE agent escalates rather than making system-level assumptions

## Test Coverage Gaps

- **PowerShell install script (`install.ps1`):** ATP-2 and ATP-3 only cover bash. Windows/PowerShell testing requires a Windows environment or PowerShell Core on macOS. Mitigate by code-reviewing install.ps1 for parity with install.sh.
- **Team mode (OpenClaw):** The translation layer for OpenClaw has not been updated for the System Architect expert. Out of scope for this milestone but should be addressed before team mode is used.
- **Multi-session continuity:** Testing that handoff notes produced by `/handoff` are correctly consumed by the next `/start` session requires running sequential sessions. This is expensive and best done through real-world usage rather than formal testing.
- **Agent behavioral variance:** Acceptance tests (ATP-5, ATP-6) depend on AI agent behavior, which is non-deterministic. The tests verify the skill instructions are correct, but actual agent compliance depends on the LLM. Mitigate by running behavioral tests 2-3 times with different tasks.
