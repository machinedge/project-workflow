Define the build/test/deploy pipeline based on the project's environment context.

---

## Step 1: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals and constraints
2. `docs/env-context.md` — understand the build, targets, testing infrastructure, and delivery mechanisms
3. `docs/test-plan.md` (if it exists) — understand what tests need to run and at what level

If `docs/env-context.md` doesn't exist, tell the user: "No environment context found. Run `/env-discovery` first so I understand your build targets and deployment mechanisms."

## Step 2: Design Pipeline Stages

Based on the env-context, design a pipeline with only the stages that apply. Do NOT include stages the project doesn't need.

### Possible stages (include only what applies):

**Build Stage**
- Compilation, cross-compilation, artifact generation
- What runs: [specific build commands]
- What it needs: [toolchain, SDKs, dependencies]
- Output: [binary, container image, firmware image, package, etc.]
- Pass/fail: [build succeeds, no errors, no warnings treated as errors]

**Test Stage — Tier 1: Host-based**
- Unit tests and integration tests that run on the build machine
- Fast, no hardware or emulator needed
- What runs: [test framework, test commands]
- Pass/fail: [all tests pass, coverage threshold if applicable]

**Test Stage — Tier 2: Emulator/Simulator**
- Tests that need an emulated or simulated environment
- Only include if env-context says emulators/simulators exist
- What runs: [which emulator, what tests]
- What it needs: [emulator software, configuration]
- Pass/fail: [specific criteria]

**Test Stage — Tier 3: Hardware-in-the-Loop**
- Tests that run against real hardware in a test rig
- Only include if env-context mentions HIL infrastructure
- What runs: [which tests, how they connect to hardware]
- What it needs: [specific rigs, availability]
- Pass/fail: [specific criteria]

**Test Stage — Tier 4: On-Target Validation**
- Tests that run on the actual deployment target
- Only include if env-context describes on-target testing capability
- What runs: [validation suite, smoke tests]
- What it needs: [target device, flashing tools]
- Pass/fail: [specific criteria]

**Package Stage**
- Produces the deployable artifact from tested code
- What runs: [packaging commands]
- Output: [what gets produced — firmware image, container, installer, etc.]
- Signing/verification: [if applicable per env-context]

**Deploy Stage**
- How artifacts reach the target
- What runs: [deployment commands or procedures]
- What it needs: [credentials, access, infrastructure per env-context]
- Verification: [post-deploy checks]

## Step 3: Define Pipeline Flow

For each stage, document:
- What runs
- What it needs (tools, hardware, credentials)
- Pass/fail criteria
- Approximate duration
- What it blocks on (dependencies between stages)

Present as a pipeline definition:

```markdown
# Pipeline Definition

**Last updated:** [today's date]
**Based on:** `docs/env-context.md`

## Pipeline Overview

[ASCII diagram or ordered list showing the flow]

## Stages

### 1. Build
**Runs:** [commands]
**Needs:** [tools, dependencies]
**Duration:** ~[time]
**Pass criteria:** [specific]
**Blocks:** Tier 1 tests

### 2. Test — Tier 1 (Host-based)
**Runs:** [commands]
**Needs:** [framework]
**Duration:** ~[time]
**Pass criteria:** [specific]
**Blocks:** [next stage]

[...additional stages as applicable...]

## Pipeline Requirements

- **CI system:** [what's needed — GitHub Actions, Jenkins, local scripts, etc.]
- **Infrastructure:** [what hardware or services the pipeline needs]
- **Credentials/secrets:** [what access is needed, stored where]
- **Estimated total duration:** [end-to-end pipeline time]

## Not Included (and Why)

[Stages that were considered but not included because the env-context doesn't support them. This makes the reasoning visible.]
```

## Step 4: Review with User

Present the pipeline design. Key questions:
- Are the stages in the right order?
- Are the pass/fail criteria right?
- Is the estimated duration acceptable?
- Is the infrastructure available for all stages?
- Anything missing?

Don't save until the user approves.

## Step 5: Determine Implementation Approach

After user approval, discuss how to implement this pipeline:
- Is this a document-only definition (the team implements it manually)?
- Should we generate CI config files (GitHub Actions, Makefile, scripts)?
- Are there existing pipeline configs to modify?

If CI config generation is needed, that's an SWE task — create a GitHub issue for it via `/decompose` or directly:

```bash
gh issue create \
  --title "DevOps: Implement CI pipeline from pipeline definition" \
  --label "devops" \
  --body "Implement the pipeline defined in docs/pipeline.md. See docs/env-context.md for environment details."
```

The pipeline definition document describes *what* the pipeline does. Actual CI config files are implementation — they go through the SWE workflow.
