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
| 1 | System Architect expert passes structural validation | swe-feature-001, AC 10 | Unit | Run `./tools/validate/validate.sh technical/system-architect` | Local | P1 |
| 2 | All original experts still pass structural validation | Backward compat constraint | Unit | Run `validate.sh` for each of: `technical/project-manager`, `technical/swe`, `technical/qa`, `technical/devops` | Local | P1 |
| 3 | Default install produces the AGENTS.md layout | ADR-012 | Integration | Run `./install.sh /tmp/test-proj`; verify `AGENTS.md`, `CLAUDE.md`→`AGENTS.md` symlink, `.agents/{roles,commands,skills,scripts}`, `.claude/*` symlinks, settings hook, `.sdlc/` | Local | P1 |
| 4 | `--no-claude` install omits `.claude/` | ADR-012 | Integration | Run `./install.sh --no-claude /tmp/test-generic`; verify `AGENTS.md` + `.agents/` present and no `.claude/` | Local | P2 |
| 5 | Claude discovery resolves through symlinks | ADR-012 | Integration | In a default install, verify `.claude/skills/pm-vision/SKILL.md` and `.claude/scripts/session-primer.sh` are readable via the symlinks | Local | P1 |
| 6 | Existing user `AGENTS.md` is backed up, not clobbered | ADR-012 | Integration | Pre-create `AGENTS.md`, install, verify `AGENTS.md.pre-install.bak` holds the original | Local | P2 |
| 7 | Every expert's `/start` loads `architecture.md` | swe-bug-007, swe-feature-004 | System | Grep all `start.md` files for `architecture.md` reference; verify `(if it exists)` qualifier present | Local | P1 |
| 8 | Every expert's role.md lists `/start` and `/handoff` in Skills | swe-feature-002, -003 | System | Grep all `role.md` files for `/start` and `/handoff` entries | Local | P1 |
| 9 | SWE, QA, DevOps role files include escalation principle | swe-techdebt-008, swe-feature-004 | System | Grep `role.md` files for "Escalate" in Principles section | Local | P1 |
| 10 | docs-protocol lists `architecture.md` in Document Locations | swe-feature-004, AC 4 | System | Read docs-protocol.md, verify Architecture row in table | Local | P1 |
| 11 | docs-protocol Workflow Contracts includes System Architect | swe-feature-004, AC 4 | System | Read docs-protocol.md, verify SA rows in Contracts table | Local | P1 |
| 12 | docs-protocol Handoff Notes description includes system-architect/ | swe-techdebt-012 | System | Read docs-protocol.md, verify system-architect/ in description and tree | Local | P2 |
| 13 | PM role.md lists `/update-plan` in Skills | swe-techdebt-011 | System | Read PM role.md, verify entry | Local | P2 |
| 14 | PM handoff template includes "Problems Encountered" | swe-techdebt-009 | System | Read PM handoff.md, verify section exists | Local | P2 |
| 15 | agent-reference.md repo guide lists system-architect/ | swe-techdebt-010 | System | Read `docs/agent-reference.md`, verify system-architect/ in repo structure | Local | P2 |
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
1. Run `./tools/validate/validate.sh technical/system-architect`
2. Run `./tools/validate/validate.sh technical/project-manager`
3. Run `./tools/validate/validate.sh technical/swe`
4. Run `./tools/validate/validate.sh technical/qa`
5. Run `./tools/validate/validate.sh technical/devops`
**Expected result:** All experts pass with 0 failures and 0 warnings

### ATP-2: Install Model — Default (Tests #3, #5)
**Tests:** Matrix rows 3, 5
**Prerequisites:** Clean target directory
1. Run `./install.sh /tmp/test-install`
2. Verify top-level `AGENTS.md` exists (regular file)
3. Verify `CLAUDE.md` is a symlink resolving to `AGENTS.md`
4. Verify `.agents/roles` (5), `.agents/commands` (9), `.agents/skills` (21), `.agents/scripts` are populated
5. Verify `.claude/{commands,skills,roles,scripts}` are symlinks into `../.agents/*`
6. Verify `.claude/skills/pm-vision/SKILL.md` and `.claude/scripts/session-primer.sh` are readable via the symlinks
7. Verify `.claude/settings.json` contains the `SessionStart` → `session-primer.sh` hook
8. Verify `.sdlc/issues/{backlog,planned,in-progress,done}` and `.sdlc/handoff-notes/<expert>/` exist
9. Clean up: `rm -rf /tmp/test-install`
**Expected result:** Full AGENTS.md layout present; Claude wiring resolves through symlinks

### ATP-3: Install Model — Generic and Safety (Tests #4, #6)
**Tests:** Matrix rows 4, 6
**Prerequisites:** Clean target directory
1. Run `./install.sh --no-claude /tmp/test-generic`; verify `AGENTS.md` + `.agents/` present and **no** `.claude/` directory
2. Re-run `./install.sh /tmp/test-generic` (idempotency); verify symlinks intact and the settings hook is not duplicated
3. In a fresh dir, pre-create `AGENTS.md` with custom content, run `./install.sh`, verify the original is preserved at `AGENTS.md.pre-install.bak`
4. Clean up the temp directories
**Expected result:** `--no-claude` omits Claude wiring; re-runs are idempotent; a user's AGENTS.md is never silently overwritten

### ATP-4: Cross-Expert Consistency Check (Tests #7-16)
**Tests:** Matrix rows 7-16
**Prerequisites:** None
1. For each expert (PM, SWE, QA, DevOps, System Architect): verify `start.md` references `architecture.md` with `(if it exists)` qualifier
2. For each expert: verify `role.md` lists `/start` and `/handoff` in Skills section
3. For SWE, QA, DevOps: verify `role.md` Principles includes escalation instruction
4. Read `experts/technical/shared/docs-protocol.md`: verify `architecture.md` in Document Locations, System Architect in Workflow Contracts, `system-architect/` in handoff conventions
5. Read PM `role.md`: verify `/update-plan` listed, correct docs-protocol path
6. Read PM `handoff.md`: verify "Problems Encountered" section
7. Read `docs/agent-reference.md`: verify `system-architect/` in repo structure
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
