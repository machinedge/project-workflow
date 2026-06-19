# Issues List

| File | Title | Expert | Type | Milestone | Prerequisites | Status |
|------|-------|--------|------|-----------|---------------|--------|
| swe-feature-001 | Create System Architect Expert | swe | feature | [Expert Skill Restructure] System Architect expert with full skill set (M3) | — | done |
| swe-feature-002 | Add /start and /handoff Skills to PM | swe | feature | [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4) | None | done |
| swe-feature-003 | Add /start and /handoff Skills to QA and DevOps | swe | feature | [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4) | None | done |
| swe-feature-004 | Update SWE /start, Docs-Protocol, and Role Files for architecture.md | swe | feature | [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5) | swe-feature-001, swe-feature-002, swe-feature-003, swe-feature-006 | done |
| qa-feature-005 | QA: Review Expert Skill Restructure for Consistency | qa | feature | [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5) | — | done |
| swe-feature-006 | Update Install Scripts for System Architect Expert | swe | feature | [Expert Skill Restructure] System Architect expert with full skill set (M3) | swe-feature-001 | done |
| swe-bug-007 | PM, QA, DevOps /start skills don't load architecture.md | swe | bug | [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5) | — | done |
| swe-techdebt-008 | Add escalation behavior to QA and DevOps role files | swe | techdebt | [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5) | — | done |
| swe-techdebt-009 | Add "Problems Encountered" section to PM handoff template | swe | techdebt | [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4) | — | done |
| swe-techdebt-010 | Update CLAUDE.md repo guide to include System Architect | swe | techdebt | [Expert Skill Restructure] System Architect expert with full skill set (M3) | — | done |
| swe-techdebt-011 | Add update_plan to PM role.md Skills section | swe | techdebt | [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4) | — | done |
| swe-techdebt-012 | Fix nits: /start tagline, docs-protocol description, PM docs-protocol path | swe | techdebt | [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5) | — | done |
| sa-feature-013 | Design Target-Class Directory Layout | system-architect | feature | M6 | — | done |
| swe-feature-014 | Create Target-Class Directories and Relocate Files | swe | feature | M6 | sa-feature-013 | done |
| swe-feature-015 | Update Install, Packaging, and Validation Scripts for New Layout | swe | feature | M6 | swe-feature-014 | done |
| swe-feature-016 | Update Documentation References and Remove CLAUDE.md | swe | feature | M7 | swe-feature-015 | done |
| qa-feature-017 | QA: Verify Deployment Restructure End-to-End | qa | feature | M7 | — | done |
| swe-bug-018 | BUG: README.md Quick Start references non-existent `./workflows/setup.sh` | swe | bug | M7 | — | done |
| swe-bug-019 | BUG: Multiple docs reference non-existent files (overview.md, getting-started.md, workflow-anatomy.md) | swe | bug | M7 | — | done |
| swe-bug-020 | BUG: IDE target READMEs missing System Architect prefix | swe | bug | M7 | — | done |
| swe-bug-021 | BUG: Test plan ATP-4 step 7 references deleted CLAUDE.md | swe | bug | M7 | — | done |
| pm-feature-022 | PM: Decide on missing documentation files (overview.md, getting-started.md, workflow-anatomy.md) | pm | feature | M7 | — | done |
| swe-bug-023 | BUG: PM decompose skill doesn't include Prerequisites column in issues-list.md | swe | bug | M4 | — | done |
| swe-bug-024 | QA `/start` Missing Dedicated Verify Phase for Own Acceptance Criteria | swe | bug | M5 | — | done |
| swe-bug-025 | QA, DevOps, PM Role Session Protocol Missing `architecture.md` | swe | bug | M5 | — | done |
| swe-techdebt-026 | SWE Escalation Routing Language Differs from QA and DevOps | swe | techdebt | M5 | — | done |
| swe-techdebt-027 | DevOps Escalation Example List Uses "service topology" Instead of "technology choices" | swe | techdebt | M5 | — | done |
| swe-techdebt-028 | agent-reference.md Overstates `/start` Phase Count | swe | techdebt | M5 | — | done |
| swe-feature-029 | Remove date references from PM skill templates | swe | feature | [PM Planning Improvements] Adaptive interview and date-free PM output | — | done |
| swe-feature-030 | Add adaptive complexity assessment to /add-feature | swe | feature | [PM Planning Improvements] Adaptive interview and date-free PM output | — | done |
| swe-feature-031 | Remove date references from all remaining expert templates | swe | feature | [Date Removal] Remove date references from all remaining expert templates | None | done |
| sa-research-032 | Audit Startup Context and Produce Optimization Matrix | system-architect | research | M10 | — | done |
| sa-feature-033 | Design Platform-Native Architecture for Cursor and Claude Code | system-architect | feature | M11 | — | done |
| swe-feature-034 | Create Workflow Shell Scripts for Mechanical Operations | swe | feature | M11 | sa-feature-033 | done |
| swe-feature-035 | Create Cursor Rules and Project Structure | swe | feature | M11 | sa-feature-033 | done |
| swe-feature-036 | Create Cursor-Native PM Expert Skills | swe | feature | M11 | sa-feature-033, swe-feature-034, swe-feature-035 | done |
| swe-feature-037 | Create Cursor-Native SWE and QA Expert Skills | swe | feature | M11 | sa-feature-033, swe-feature-034, swe-feature-035 | done |
| swe-feature-038 | Create Cursor-Native DevOps and System Architect Expert Skills | swe | feature | M11 | sa-feature-033, swe-feature-034, swe-feature-035 | done |
| qa-feature-039 | QA: Review Cursor Implementation for Completeness and Consistency | qa | feature | M11 | — | done |
| swe-feature-040 | Create Claude Code Rules, Project Structure, PM and SWE Expert Skills | swe | feature | M11 | sa-feature-033, swe-feature-034, swe-feature-035, swe-feature-036, swe-feature-037 | done |
| swe-feature-041 | Create Claude Code QA, DevOps, and System Architect Expert Skills | swe | feature | M11 | swe-feature-040, swe-feature-037, swe-feature-038 | done |
| qa-feature-042 | QA: Review Claude Code Implementation for Completeness and Consistency | qa | feature | M11 | — | done |
| swe-feature-043 | Build Sync/Management Command | swe | feature | M11 | qa-feature-039, qa-feature-042 — both implementations must be finalized before the sync command can be validated | done |
| swe-feature-044 | Update Install Scripts and READMEs for Platform-Native Structure | swe | feature | M11 | qa-feature-039, qa-feature-042, swe-feature-043 | done |
| qa-feature-045 | QA: Cross-Platform Regression and Install Verification | qa | feature | M11 | — | done |
| sa-feature-046 | Redesign session-context as Agent Skill Instead of Shell Script | system-architect | feature | M11 | sa-feature-033 | done |
| sa-feature-047 | Define Routing for Cross-Expert Skills (team- prefix) | sa | feature | M11 | swe-feature-035 | done |
| sa-bug-048 | Concurrent session conflicts: session numbering and project brief overwrites | system-architect | bug | — | — | done |
| swe-feature-049 | Robust concurrent handoff: script-based project brief updates and session claiming | swe | feature | — | sa-bug-048 | done |
| swe-bug-050 | PowerShell next-session-number.ps1 missing atomic session claiming | swe | bug | M11 | — | done |
| swe-bug-051 | Issue filename prefix convention inconsistent across skills | swe | bug | M11 | — | done |
| swe-techdebt-052 | Dead `count` variable in update-issues-list.sh | swe | techdebt | M11 | — | done |
| swe-feature-053 | SWE: Add team-status skill to Claude Code implementation | swe | feature | M11 | — | done |
| swe-techdebt-054 | SWE: Update outdated README files in both IDE target directories | swe | techdebt | M11 | — | done |
| sa-techdebt-055 | Update architecture.md script specifications for update-brief-status | system-architect | techdebt | — | swe-feature-049 | done |
| swe-bug-056 | Install script creates wrong PM handoff directory | swe | bug | M11 | — | done |
| swe-bug-057 | update-brief-status script missing from install cleanup and READMEs | swe | bug | M11 | — | done |
| swe-bug-058 | Sync check command flags intentionally excluded files as MISSING | swe | bug | M11 | — | done |
| qa-feature-059 | QA Review: Commands vs Skills Slash Prefix Cleanup | QA | feature (review) | Platform-Native Refactor (M11) | — | done |
| swe-bug-060 | Data-analyst role.md has mixed command/skill treatment | SWE | bug | Platform-Native Refactor (M11) — data-analyst cleanup | — | done |
| swe-bug-061 | pm-add-feature.md wording inconsistency between Cursor and Claude Code | SWE | bug | Platform-Native Refactor (M11) | — | done |
| swe-bug-062 | Cursor README incorrectly describes expert rules as alwaysApply: true | swe | bug | — | — | done |
| sa-feature-063 | Design .workflow Directory Structure and Path Mapping | sa | feature | [Workflow Directory] Update structure and references (M13) | — | done |
| swe-feature-064 | Update Cursor Rules for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063 | done |
| swe-feature-065 | Update Cursor Commands for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063 | done |
| swe-feature-066 | Update Cursor Skills for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063 | done |
| swe-feature-067 | Update Cursor Scripts for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063 | done |
| swe-feature-068 | Update Claude Code Rules for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063, swe-feature-064 | done |
| swe-feature-069 | Update Claude Code Commands for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063, swe-feature-065 | done |
| swe-feature-070 | Update Claude Code Skills for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063, swe-feature-066 | done |
| swe-feature-071 | Update Claude Code Scripts for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063, swe-feature-067 | done |
| swe-feature-072 | Update Install Scripts for Fresh .workflow Structure | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063 | done |
| swe-feature-073 | Update agent-reference.md and READMEs for .workflow Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | sa-feature-063 | done |
| swe-feature-074 | Reinstall Into Project and Verify All Paths | swe | feature | [Workflow Directory] Update structure and references (M13) | swe-feature-064 through swe-feature-073 | done |
| qa-feature-075 | QA: Grep Audit for Stale Path References | qa | feature | [Workflow Directory] Update structure and references (M13) | — | done |
| swe-feature-076 | Implement Migration Logic in install.sh | swe | feature | [Workflow Directory] Migration from old structure (M14) | swe-feature-072 | done |
| swe-feature-077 | Implement Migration Logic in install.ps1 | swe | feature | [Workflow Directory] Migration from old structure (M14) | swe-feature-076 | done |
| swe-feature-078 | Test Migration on This Project | swe | feature | [Workflow Directory] Migration from old structure (M14) | swe-feature-076, swe-feature-074 | done |
| qa-feature-079 | QA: Verify Migration End-to-End | qa | feature | [Workflow Directory] Migration from old structure (M14) | — | done |
| swe-bug-080 | Project Brief Constraints Section Has Stale `issues/` Path | swe | bug | [Workflow Directory] Update structure and references (M13) | — | done |
| swe-bug-081 | architecture.md Has Stale Paths in Non-ADR Sections | swe | bug | [Workflow Directory] Update structure and references (M13) | — | done |
| swe-bug-082 | BUG: pm-interview command writes a typo'd notes filename (.sdlc/rview-notes.md) | swe | bug |  | — | done |
| doc-techdebt-083 | TECHDEBT: Workflow accelerators still called milestone.js / documentation.js in ~9 docs | doc | techdebt |  | — | backlog |
| doc-techdebt-084 | TECHDEBT: README overstates command count as 10; actual is 6 | doc | techdebt |  | — | backlog |
| doc-techdebt-085 | TECHDEBT: Handoff-note path mismatch: AGENTS.md says .sdlc/notes/, skills write .sdlc/handoff-notes/ | doc | techdebt |  | — | backlog |
| doc-techdebt-086 | TECHDEBT: CONTRIBUTING.md references a non-existent /swe-start command | doc | techdebt |  | — | backlog |
| pm-feature-087 | FEATURE: Enable readers to dig deeper than the user-facing documentation | pm | feature |  | — | backlog |
| swe-feature-088 | Repoint spec skills' authoring and consume paths from docs/ to .sdlc/ | swe | feature | [SDLC Boundary] | none | done |
| swe-feature-089 | Repoint role files, AGENTS.md conventions, and brief convention to .sdlc/ | swe | feature | [SDLC Boundary] | none | done |
| swe-feature-090 | Repoint team-* runbooks, ops/start commands, and the two workflow accelerators to .sdlc/ | swe | feature | [SDLC Boundary] | none | done |
| swe-feature-091 | Make spec consumers fail loudly when a spec is missing at the new .sdlc/ path | swe | feature | [SDLC Boundary] | swe-feature-088, swe-feature-089, swe-feature-090 — **HARD blocker, this task is last in the SWE repoint chain.** The paths must already be repointed to `.sdlc/` before the fail-loud behavior is layered on the same consume steps. By the time 091 runs, the consume steps already say `.sdlc/<spec>.md``); 091 only adds the fail-loud directive and removes that soft suffix on required specs — it does **not** repoint `docs/ → .sdlc/`. If a consume step still shows `docs/<spec>.md`, an upstream task has not landed: report it, do not repoint it here. Downstream of 091: swe-feature-093 and qa-feature-094. | done |
| swe-feature-092 | Update installer to stop seeding specs into docs/ and create .sdlc/ spec locations | swe | feature | [SDLC Boundary] | none | done |
| swe-feature-093 | Add migrate-sdlc workflow that relocates an existing project's specs docs/ → .sdlc/ | swe | feature | [SDLC Boundary] | swe-feature-088, swe-feature-089, swe-feature-090, swe-feature-091, swe-feature-092 | done |
| qa-feature-094 | QA: Grep audit and end-to-end verification of the SDLC boundary | qa | feature | [SDLC Boundary] | — | done |
| swe-bug-095 | BUG: Skill files were left pointing at docs/ after the SDLC-boundary migration | swe | bug | [SDLC Boundary] | — | done |
| swe-bug-096 | BUG: migrate-sdlc moves ANY docs/*-draft.md, including user files — SR-003 / architecture draft-glob contract violation | swe | bug |  | — | done |
| swe-techdebt-097 | TECHDEBT: No M19 test plan exists; the QA verification issue references paths and procedures that are not present | swe | techdebt |  | — | done |
| swe-techdebt-098 | TECHDEBT: Claimed verification artifact test-sdlc-boundary.sh does not exist in the repo | swe | techdebt |  | — | done |
| swe-techdebt-099 | TECHDEBT: M19 deliverables are entirely uncommitted; roadmap has no M19 row | swe | techdebt |  | — | done |
| swe-techdebt-100 | TECHDEBT: migrate-sdlc draft glob is broader than the architecture's canonical inventory specifies | swe | techdebt |  | — | done |
| swe-bug-101 | BUG: Migration draft glob is over-broad — relocates user-owned files it does not own (SR-003 / T-002 violation) | swe | bug |  | — | done |
| swe-bug-102 | BUG: docs/security/ subfolder is migrated wholesale, capturing any user content under that name (SR-003 edge / T-002) | swe | bug |  | — | backlog |
| swe-bug-103 | BUG: migrate-sdlc move-lines violate UX-007: absolute paths + ASCII arrow instead of the installer's `docs/X → .sdlc/X` convention | swe | bug |  | — | done |
| swe-bug-104 | BUG: Collision run prints the contradictory line `Already clean — no specs to migrate.` (UX-009 / UX-011 clarity) | swe | bug |  | — | done |
| swe-bug-105 | BUG: No explicit closing verification summary on success (UX-011) | swe | bug |  | — | done |
| swe-bug-106 | BUG: Installer migration output is inconsistent across bash and PowerShell (UX-006) | swe | bug |  | — | done |
| swe-bug-107 | BUG: overview.md links readers to docs/architecture.md, which no longer exists after M19 moved it to .sdlc/architecture.md (DOC-011, DOC-015) | swe | bug |  | — | done |
| swe-bug-108 | BUG: overview.md 'Where state lives' describes the docs/ vs .sdlc/ boundary backwards (DOC-010, DOC-011) | swe | bug |  | — | done |
| swe-bug-109 | BUG: contributing.md install-output example shows 'Scripts: 11 files'; the installer now prints 13 after M19 added the migrate-sdlc pair (DOC-012, DOC-015) | swe | bug |  | — | done |
