# Plan: Restructure SWE Workflow into PM, SWE, QA, and DevOps

## Context

The current `workflows/swe/` directory contains a monolithic AI Project Toolkit that covers product management, software engineering, and code review in a single workflow with 9 commands. We're breaking it into four separate but interconnected workflows that mirror real team roles:

- **PM** (Product/Project Management) — Discovers what to build and why
- **SWE** (Software Engineering) — Builds it
- **QA** (Quality Assurance) — Validates it
- **DevOps** — Gets it deployed, tested on targets, and released

### Design Principle: PM is Extractive, Not Prescriptive

The PM workflow asks open-ended questions to build context. It does NOT assume the project is embedded, cloud, mobile, or anything else. The answers shape what artifacts get produced and what downstream workflows need. This keeps PM universal while allowing SWE, QA, and DevOps to specialize based on the context PM captures.

---

## Target Directory Structure

```
workflows/
├── pm/
│   ├── editor.md                  # PM operating system
│   ├── setup.sh                   # PM setup script
│   ├── setup.ps1                  # PM setup script (Windows)
│   └── commands/
│       ├── interview.md           # (migrated from swe, expanded)
│       ├── vision.md              # (migrated from swe, expanded)
│       ├── roadmap.md             # (migrated from swe, expanded)
│       ├── decompose.md           # (migrated from swe, expanded)
│       ├── add_feature.md         # (migrated from swe)
│       └── postmortem.md          # (migrated from swe, expanded)
│
├── swe/
│   ├── editor.md                  # SWE operating system (slimmed down)
│   ├── setup.sh                   # SWE setup script
│   ├── setup.ps1                  # SWE setup script (Windows)
│   └── commands/
│       ├── start.md               # (migrated, remove review/PM concerns)
│       └── handoff.md             # (migrated, tightened to SWE scope)
│
├── qa/
│   ├── editor.md                  # QA operating system
│   ├── setup.sh                   # QA setup script
│   ├── setup.ps1                  # QA setup script (Windows)
│   └── commands/
│       ├── review.md              # (migrated from swe, expanded)
│       ├── test-plan.md           # NEW: generate test plan from task/milestone
│       ├── regression.md          # NEW: run regression check across milestone
│       └── bug-triage.md          # NEW: triage and prioritize bug reports
│
├── devops/
│   ├── editor.md                  # DevOps operating system
│   ├── setup.sh                   # DevOps setup script
│   ├── setup.ps1                  # DevOps setup script (Windows)
│   └── commands/
│       ├── env-discovery.md       # NEW: interview to capture environment context
│       ├── pipeline.md            # NEW: define build/test/deploy pipeline
│       ├── release-plan.md        # NEW: define release gates and rollback
│       └── deploy.md              # NEW: execute a release with verification
│
└── shared/
    ├── new_repo.sh                # (migrated from swe)
    ├── new_repo.ps1               # (migrated from swe)
    └── docs-protocol.md           # Shared document conventions and locations
```

---

## Phase 1: Shared Foundation

Before building individual workflows, establish the shared contracts between them.

### 1.1 Create `workflows/shared/docs-protocol.md`

This document defines the shared artifacts all workflows read/write. It replaces the document-location table currently embedded in `editor.md`. Contents:

- **Document locations table** (project-brief, roadmap, tasks, handoff-notes, lessons-log — same as today)
- **New: Environment context** → `docs/env-context.md` (produced by DevOps, consumed by SWE/QA)
- **New: Test plan** → `docs/test-plan.md` (produced by QA, consumed by SWE/DevOps)
- **New: Release plan** → `docs/release-plan.md` (produced by DevOps, consumed by PM for postmortem)
- **Contract definitions**: What each workflow produces and what it expects as input
- **Principles** (migrated from current editor.md): no memory between sessions, project brief is source of truth, keep it under 1,000 words, etc.

### 1.2 Define workflow contracts

| Producer | Artifact | Consumer(s) |
|----------|----------|-------------|
| PM | `project-brief.md` | SWE, QA, DevOps |
| PM | `roadmap.md` | SWE, QA, DevOps |
| PM | GitHub issues (tasks) | SWE, QA |
| PM | `interview-notes*.md` | PM (internal) |
| SWE | Code + tests | QA, DevOps |
| SWE | `handoff-notes/session-NN.md` | PM, QA, SWE (next session) |
| QA | `test-plan.md` | SWE, DevOps |
| QA | Review issues (must-fix, should-fix) | SWE, PM |
| QA | Regression reports | PM (postmortem) |
| DevOps | `env-context.md` | SWE, QA |
| DevOps | `release-plan.md` | PM, QA |
| DevOps | Pipeline config | DevOps (internal) |

### 1.3 Migrate `new_repo.sh` / `new_repo.ps1` to `workflows/shared/`

These are project-level scaffolding, not specific to any workflow. Move them as-is, updating internal paths.

---

## Phase 2: PM Workflow

### 2.1 Create `workflows/pm/editor.md`

New PM-specific operating system. Contents:

- Role definition: "You are a product/project manager. Your job is to discover context, define scope, and produce planning artifacts."
- Document locations (reference shared/docs-protocol.md)
- PM-specific session protocol (load project-brief → check roadmap → check issue backlog)
- Available commands list (only PM commands)
- Principles: extractive not prescriptive, ask don't assume, flag gaps don't fill them

### 2.2 Migrate and expand `interview.md`

Current interview covers 8 categories: Context, Problem, Audience, Success, Scope, Constraints, Prior Art, Risks.

**Add two new categories** (open-ended, not prescriptive):

9. **Environment & Delivery** — How does this software reach its users today? What does the build/test/deploy cycle look like? Are there physical devices, hardware, or infrastructure involved? What happens when something goes wrong in production?
10. **Operations & Compliance** — Are there regulatory, safety, or compliance requirements? Who maintains this after it ships? What does monitoring or observability look like today?

These questions are intentionally open. They work whether the answer is "it's a Rails app on Heroku" or "we flash firmware via JTAG to PLCs on a factory floor." The answers feed into DevOps's env-discovery later, but PM captures the raw context first.

**Keep all existing rules** (one question at a time, wait for answers, push for specifics, tolerate speech-to-text, etc.)

### 2.3 Migrate and expand `vision.md`

Current project-brief template has: Identity, Goal, Who It's For, Success, Constraints, Key Decisions, Current Status, Notes for AI.

**Add one new section** to the project-brief template:

```markdown
## Delivery & Operations Context
- **How software reaches users:** [from interview — could be app store, OTA, USB flash, CI/CD, manual deploy, etc.]
- **Hardware/infrastructure involved:** [from interview — or "N/A" for pure software]
- **Compliance/regulatory:** [from interview — or "None identified"]
- **Current pain points:** [from interview — what's hard about building/testing/deploying today]
```

This section gives DevOps and QA the context they need without PM making architectural decisions. It's just recording what the user said.

### 2.4 Migrate `roadmap.md`

Move as-is with minor updates:
- Reference the PM editor.md instead of the monolithic one
- Add a note that milestones may trigger DevOps work (env setup, pipeline config) that should be tracked alongside feature milestones

### 2.5 Migrate `decompose.md`

Move as-is with minor updates:
- Add ability to create QA-labeled issues (e.g., "write test plan for milestone X")
- Add ability to create DevOps-labeled issues (e.g., "set up CI pipeline for target X")
- Keep the existing task/SWE issue creation unchanged

### 2.6 Migrate `add_feature.md`

Move as-is. No changes needed — it's already PM-scoped.

### 2.7 Migrate and expand `postmortem.md`

Current postmortem covers: Progress, Plan Impact, Decisions Audit, Lessons, Updated Brief, Next Milestone Prep.

**Add two new analysis sections:**

- **Quality Assessment** — Pull QA data: review findings resolved vs. unresolved, regression results, test coverage gaps. Were bugs caught early or late?
- **Delivery Assessment** — Pull DevOps data: did the pipeline work smoothly? Any deployment failures? Environment issues? Release gate failures? Time from "code complete" to "deployed and verified"?

These give PM a full picture for planning the next milestone.

### 2.8 Create `workflows/pm/setup.sh` and `setup.ps1`

Adapted from current `swe/setup.sh`. Key differences:
- Only installs PM commands
- References PM editor.md
- Creates the same docs/ directory structure (it's shared)
- Supports `--editor claude|cursor|both` flag (same as current)

---

## Phase 3: SWE Workflow

### 3.1 Create `workflows/swe/editor.md`

New SWE-specific operating system. Contents:

- Role definition: "You are a software engineer. Your job is to implement tasks defined in GitHub issues, following the architecture and test plans provided."
- Document locations (reference shared/docs-protocol.md)
- SWE-specific session protocol (load project-brief → read task issue → read handoff note → check test plan if exists → check env-context if exists)
- Available commands list (only SWE commands: /start, /handoff)
- Principles: stay in scope, test first, verify against acceptance criteria, be honest in handoffs

### 3.2 Slim down `start.md`

Current start.md has 7 phases. Keep the structure but adjust:

- **Phase 1 (Load Context)**: Add reading `docs/test-plan.md` and `docs/env-context.md` if they exist. These inform how to build and what constraints to respect.
- **Phase 2 (Plan)**: Unchanged
- **Phase 3 (Architect)**: Unchanged
- **Phase 4 (Write Tests)**: Add reference to QA's test plan — if QA has defined test requirements, SWE should implement them, not invent different ones
- **Phase 5 (Implement)**: Unchanged
- **Phase 6 (Verify)**: Keep self-verification but remove the "fresh eyes review" aspect — that's QA's job now. SWE verifies acceptance criteria and runs tests. QA does the critical review.
- **Phase 7 (Report)**: Unchanged

### 3.3 Slim down `handoff.md`

Mostly unchanged. Minor updates:
- Reference SWE editor.md
- Remove any PM-level document updates (project-brief status updates move to PM's postmortem/decompose)
- Actually, keep the project-brief status update — SWE should still update "last completed task" and "next task" since it's the workflow closest to the work. This prevents the brief from going stale between PM sessions.

### 3.4 Update `workflows/swe/setup.sh` and `setup.ps1`

Slim down from current setup.sh:
- Only installs SWE commands (/start, /handoff)
- References SWE editor.md
- Shares the same docs/ directory structure

---

## Phase 4: QA Workflow

### 4.1 Create `workflows/qa/editor.md`

New QA-specific operating system. Contents:

- Role definition: "You are a quality assurance engineer. Your job is to validate that work meets requirements, catch bugs before they compound, and maintain quality standards."
- Document locations (reference shared/docs-protocol.md)
- QA-specific session protocol (load project-brief → read task/milestone scope → read handoff notes for context → review code with fresh eyes)
- Available commands list: /review, /test-plan, /regression, /bug-triage
- Principles: be critical not polite, evaluate against intent not just behavior, catch problems early, review only — don't auto-fix

### 4.2 Migrate and expand `review.md`

Move from swe/commands/ with these changes:
- Reference QA editor.md
- Unchanged core (Steps 1-7 are solid as-is)
- Add: if `docs/test-plan.md` exists, evaluate test coverage against the test plan, not just against "does it test the happy path"
- Add: if `docs/env-context.md` exists, check for environment-specific concerns (e.g., memory constraints, endianness, peripheral assumptions)

### 4.3 Create `test-plan.md` (NEW)

Command: `/test-plan [milestone or task]`

Purpose: Generate a test plan that defines what needs to be tested and at what level. This plan is consumed by SWE (to write tests) and DevOps (to configure test infrastructure).

Flow:
1. Load context: project-brief, roadmap, relevant issues, env-context (if exists)
2. For each task/acceptance criterion, determine:
   - What to test (the behavior)
   - How to verify it (specific test approach)
   - What level of testing is needed (unit, integration, system, manual)
   - What infrastructure is needed (if env-context specifies hardware/emulator requirements)
3. Produce `docs/test-plan.md` with structure:
   - Test scope (what milestone/tasks this covers)
   - Test matrix (behavior × test level × environment)
   - Test infrastructure requirements (what's needed to run these tests)
   - Acceptance test procedures (step-by-step for manual/system tests)
   - Risk-based priority (what to test first based on risk)

Key rule: The test plan asks what the project needs, based on the context PM captured. It doesn't assume any particular test infrastructure exists — it states what's needed and lets DevOps figure out how to provide it.

### 4.4 Create `regression.md` (NEW)

Command: `/regression [milestone]`

Purpose: After a milestone is complete, run a comprehensive regression check.

Flow:
1. Load all context (brief, roadmap, all handoff notes, all issues for milestone)
2. Identify all acceptance criteria across the milestone
3. Verify each one is still working (run tests, check behavior)
4. Check for cross-task interference (did task 5 break what task 2 built?)
5. Produce a regression report:
   - All passing criteria (with evidence)
   - Any failures (with details)
   - New issues discovered
   - Test coverage gaps
6. Create GitHub issues for any regressions found
7. Feed results to PM for postmortem

### 4.5 Create `bug-triage.md` (NEW)

Command: `/bug-triage`

Purpose: Review open bug/issue backlog and prioritize.

Flow:
1. Pull all open issues: `gh issue list --state open`
2. Load project-brief and roadmap for context
3. For each issue, assess:
   - Severity (blocking, high, medium, low)
   - Impact on current milestone
   - Effort to fix
   - Dependencies
4. Produce a prioritized list with recommendations
5. Create/update labels as needed
6. Suggest which bugs to address before continuing with new feature work

---

## Phase 5: DevOps Workflow

### 5.1 Create `workflows/devops/editor.md`

New DevOps-specific operating system. Contents:

- Role definition: "You are a DevOps engineer. Your job is to ensure software can be built, tested, and deployed reliably to its target environments."
- Document locations (reference shared/docs-protocol.md)
- DevOps-specific session protocol (load project-brief → read env-context → read release-plan → check pipeline status)
- Available commands list: /env-discovery, /pipeline, /release-plan, /deploy
- Principles: automate what's repeated, make failures visible, environments are documented not assumed, rollback is planned not improvised

### 5.2 Create `env-discovery.md` (NEW)

Command: `/env-discovery`

Purpose: Structured interview to capture the deployment/test environment context. This is the DevOps equivalent of PM's `/interview` — extractive, not prescriptive.

Flow:
1. Read `docs/project-brief.md` (specifically the "Delivery & Operations Context" section PM captured)
2. Use that as a starting point, then deep-dive with open-ended questions:

Interview categories:
1. **Build** — How is the software built today? What toolchains, compilers, build systems? Cross-compilation? Multiple targets from one codebase?
2. **Targets** — What does the software run on? Describe each target (OS, architecture, memory, peripherals). Are there multiple hardware revisions or SKUs?
3. **Testing Infrastructure** — What test environments exist today? Emulators/simulators? Hardware-in-the-loop rigs? Shared or dedicated? What can't be tested without real hardware?
4. **Delivery** — How does software get onto the target? OTA? Physical flash? Factory programming? App store? Container registry? What's the update mechanism?
5. **Failure & Recovery** — What happens when a deployment fails? Is there rollback? Watchdog recovery? Brick risk? What's the worst-case scenario?
6. **Monitoring & Observability** — How do you know if the deployed software is working? Logging? Telemetry? Manual inspection? Field reports?

Rules: Same as PM interview — one question at a time, wait for answers, push for specifics, tolerate speech-to-text.

Output: `docs/env-context.md` with structured summary of all answers. This becomes a first-class project artifact consumed by SWE, QA, and DevOps commands.

### 5.3 Create `pipeline.md` (NEW)

Command: `/pipeline`

Purpose: Define the build/test/deploy pipeline based on env-context.

Flow:
1. Read `docs/project-brief.md`, `docs/env-context.md`, `docs/test-plan.md` (if exists)
2. Design pipeline stages:
   - **Build stage**: Compilation, cross-compilation, artifact generation
   - **Test stage tier 1**: Host-based unit tests (fast, no hardware)
   - **Test stage tier 2**: Emulator/simulator tests (if applicable per env-context)
   - **Test stage tier 3**: Hardware-in-the-loop tests (if applicable per env-context)
   - **Test stage tier 4**: On-target validation (if applicable per env-context)
   - **Package stage**: Firmware image, container, binary, installer — whatever the delivery mechanism requires
   - **Deploy stage**: How artifacts reach the target (per env-context delivery answers)
3. For each stage, define:
   - What runs
   - What it needs (tools, hardware, credentials)
   - Pass/fail criteria
   - How long it typically takes
   - What blocks on what
4. Output: Pipeline definition document (not necessarily a CI config file — the document describes the pipeline; actual CI config is an SWE task)

Key rule: Only define stages that the env-context supports. If there's no emulator, don't create an emulator stage. If it's a web app, skip hardware tiers entirely. The pipeline adapts to the project, not the other way around.

### 5.4 Create `release-plan.md` (NEW)

Command: `/release-plan [milestone]`

Purpose: Define what "ready to release" means for a milestone.

Flow:
1. Read project-brief, env-context, roadmap, test-plan
2. Define release gates:
   - All must-fix issues resolved
   - All acceptance criteria verified
   - Test plan fully executed (which tiers, what coverage)
   - Compliance checks passed (if applicable per project-brief)
   - Rollback procedure documented and tested
   - Release notes drafted
3. Define rollback procedure:
   - How to detect a failed release
   - How to revert (specific to the delivery mechanism in env-context)
   - What data/state is at risk
   - Maximum acceptable rollback time
4. Define release artifacts:
   - What gets shipped (firmware image, binary, container, etc.)
   - Version numbering scheme
   - Where artifacts are stored
   - How artifacts are signed/verified (if applicable)
5. Output: `docs/release-plan.md`

### 5.5 Create `deploy.md` (NEW)

Command: `/deploy [milestone]`

Purpose: Execute a release with verification.

Flow:
1. Read release-plan, verify all gates are met
2. If any gate is not met, STOP and report what's missing
3. If all gates are met:
   - Build the release artifacts
   - Run the release verification tests
   - Deploy to target (per env-context delivery mechanism)
   - Run post-deployment verification
   - Produce deployment report
4. If deployment fails:
   - Execute rollback procedure
   - Report what went wrong
   - Create GitHub issue for the failure

### 5.6 Create `workflows/devops/setup.sh` and `setup.ps1`

- Only installs DevOps commands
- References DevOps editor.md
- Shares the same docs/ directory structure

---

## Phase 6: Setup Script Orchestration

### 6.1 Create a top-level setup mechanism

Users need a way to install one or more workflows into a project. Options:

**Option A: Separate setup per workflow**
```bash
./workflows/pm/setup.sh ~/myproject
./workflows/swe/setup.sh ~/myproject
./workflows/qa/setup.sh ~/myproject
./workflows/devops/setup.sh ~/myproject
```

**Option B: Top-level setup with workflow selection**
```bash
./setup.sh --workflows pm,swe,qa,devops ~/myproject
./setup.sh --workflows pm,swe ~/myproject  # Just PM and SWE
```

Recommend **Option B** with a top-level `setup.sh` at `workflows/setup.sh` that delegates to individual workflow setups. This lets customers adopt incrementally (start with PM+SWE, add QA later, add DevOps when ready).

### 6.2 Handle shared docs/ directory

All workflows share the same `docs/` directory in the target project. Each setup script should:
- Create `docs/` and subdirectories if they don't exist
- Never overwrite existing docs (user's data)
- Install its own commands into `.claude/commands/` or `.cursor/commands/`
- Reference the shared docs-protocol

### 6.3 Command namespacing

With multiple workflows, commands need clear ownership. Two approaches:

**Option A: Flat namespace (current)**
`/interview`, `/start`, `/review`, `/env-discovery`
Simple but could collide as workflows grow.

**Option B: Prefixed namespace**
`/pm-interview`, `/swe-start`, `/qa-review`, `/devops-env-discovery`
Verbose but unambiguous.

Recommend **Option A** for now — the command names are already distinct. Add prefixes only if collisions emerge.

---

## Phase 7: Migration & Backward Compatibility

### 7.1 Keep `workflows/swe/` functional during migration

Don't delete the existing swe/ directory until all four workflows are built and tested. Customers using the current setup.sh should not be broken.

### 7.2 Migration path for existing projects

Projects already using the current toolkit have `.claude/commands/` with all 9 commands. They should be able to:
1. Re-run the new setup scripts to get the restructured commands
2. Keep all their existing docs/ artifacts (project-brief, roadmap, handoff-notes, lessons-log)
3. New artifacts (env-context, test-plan, release-plan) are created on demand by the new commands, not required

### 7.3 Deprecation notice

Add a note to the old `workflows/swe/setup.sh` that it's been superseded by the per-workflow setup scripts. Don't remove it immediately.

---

## Implementation Order

1. **Phase 1** (Shared foundation) — Must be first, everything depends on it
2. **Phase 2** (PM) — Next, because it produces the artifacts everything else consumes
3. **Phase 3** (SWE) — Slimming down existing code, relatively straightforward
4. **Phase 4** (QA) — Builds on existing review.md, adds new commands
5. **Phase 5** (DevOps) — Entirely new, depends on PM's expanded interview capturing environment context
6. **Phase 6** (Setup orchestration) — After all workflows exist
7. **Phase 7** (Migration) — Last, once everything is stable

---

## Open Questions

1. **Should workflows be installable independently?** (e.g., a team that only wants QA). Current plan says yes via separate setup scripts, but this means each workflow needs to handle the case where its upstream artifacts don't exist.

2. **Should there be a `/status` command?** A cross-workflow command that reads all artifacts and gives a project health summary. Could live in shared/ or PM.

3. **Should handoff notes be workflow-scoped?** Currently all handoff notes go to `docs/handoff-notes/session-NN.md`. With multiple workflows, should QA review sessions and DevOps sessions also produce handoff notes? If so, should they be namespaced (e.g., `qa-session-01.md`, `devops-session-01.md`)?

4. **How do the setup scripts handle editor config for multiple workflows?** Currently editor.md gets copied to `.claude/CLAUDE.md`. With 4 workflows, do we concatenate them, or does the user choose which role the AI plays per session?
