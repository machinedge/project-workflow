Define what "ready to release" means for a milestone.

The user may specify a milestone: $ARGUMENTS

---

## Step 1: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals, constraints, and compliance requirements
2. `docs/env-context.md` — understand the delivery mechanism and failure/recovery characteristics
3. `docs/roadmap.md` — understand the milestone scope
4. `docs/test-plan.md` (if it exists) — understand what tests must pass

If `docs/env-context.md` doesn't exist, tell the user: "No environment context found. Run `/env-discovery` first so I understand your deployment targets and failure/recovery characteristics."

Scan all `issues/` subdirectories for files matching the milestone (check the **Milestone** field in each file). Read `issues/issues-list.md` for a quick overview.

If the user didn't specify a milestone, determine the current or next milestone from the roadmap. Confirm with the user.

## Step 2: Define Release Gates

Based on the project context, define the gates that must pass before release:

**Code gates:**
- All must-fix issues resolved (check: scan `issues/backlog/`, `issues/planned/`, `issues/in-progress/` for files with **Severity: must-fix**)
- All acceptance criteria verified (check SWE handoff notes and issue files in `issues/done/`)
- No open blocker issues (check: scan open issue folders for files with **Severity: blocker**)

**Test gates:**
- If `docs/test-plan.md` exists: all P1 test matrix rows passing
- Regression check completed (or scheduled)
- Test coverage at acceptable level (define what "acceptable" means for this project)

**Compliance gates** (only if project brief mentions compliance):
- Regulatory requirements met
- Required documentation produced
- Audit trail complete

**Deployment gates:**
- Rollback procedure documented and tested
- Release notes drafted
- Release artifacts built and verified

## Step 3: Define Rollback Procedure

Based on `docs/env-context.md`, document how to revert a failed release:

- **How to detect a failed release** — what signals indicate the release is bad? (monitoring, health checks, user reports, automated tests)
- **How to revert** — specific to the delivery mechanism (redeploy previous version, OTA rollback, reflash, revert container tag, etc.)
- **What data/state is at risk** — database migrations, user data, device state, configuration changes
- **Maximum acceptable rollback time** — how long can the system be in a degraded state?
- **Who can trigger rollback** — and how (manual, automated, approval required?)

## Step 4: Define Release Artifacts

What gets shipped:
- **Artifact type:** firmware image, container, binary, installer, package, etc.
- **Version numbering:** scheme and how the version is determined
- **Where artifacts are stored:** registry, S3 bucket, release page, etc.
- **How artifacts are signed/verified:** if applicable per env-context
- **Release notes:** what format, what's included, who writes them

## Step 5: Produce the Release Plan

Save to `docs/release-plan.md`:

```markdown
# Release Plan

**Milestone:** [name]
**Last updated:** [today's date]
**Target release date:** [from roadmap or user]

## Release Gates

### Code
- [ ] All must-fix issues resolved
- [ ] All acceptance criteria verified
- [ ] No open blocker issues

### Testing
- [ ] [Specific test requirements from test plan]
- [ ] Regression check completed
- [ ] Test coverage acceptable

### Compliance
[Include only if applicable]
- [ ] [Specific compliance requirement]

### Deployment
- [ ] Rollback procedure documented and tested
- [ ] Release notes drafted
- [ ] Release artifacts built and verified

## Rollback Procedure

**Trigger:** [What signals a failed release]
**Steps:**
1. [Step]
2. [Step]
3. [Step]
**Maximum rollback time:** [duration]
**Data at risk:** [what could be lost or corrupted]
**Who can trigger:** [role/person]

## Release Artifacts

| Artifact | Type | Location | Signed |
|----------|------|----------|--------|
| [name] | [type] | [where] | [yes/no] |

**Version:** [version number and scheme]

## Release Notes Template

```
### [Version] — [Date]

**Milestone:** [name]

#### What's New
- [Feature or change]

#### Bug Fixes
- [Fix]

#### Known Issues
- [Issue]
```

## Pre-Release Checklist

[Ordered list of everything that needs to happen before the release command is run.]

1. [ ] [Step]
2. [ ] [Step]
```

Show the plan to the user for review. Don't save until they approve.
