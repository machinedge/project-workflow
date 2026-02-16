Execute a release with verification.

The user may specify a milestone: $ARGUMENTS

---

## Step 1: Load Context and Verify Readiness

Read these files:
1. `docs/release-plan.md` — the release gates, rollback procedure, and artifact definitions
2. `docs/project-brief.md` — project context
3. `docs/env-context.md` — deployment mechanism and failure/recovery characteristics

If `docs/release-plan.md` doesn't exist, tell the user: "No release plan found. Run `/release-plan` first to define release gates and rollback procedures."

## Step 2: Check Release Gates

Walk through every gate in `docs/release-plan.md` and verify it's met:

**Code gates:**
```bash
# Check for open must-fix issues
gh issue list --label must-fix --state open
# Check for open blockers
gh issue list --label blocker --state open
# Check milestone completion
gh issue list --milestone "[Milestone name]" --state open --json number,title,labels
```

**Test gates:**
- Verify test results (run tests or check most recent results)
- Check regression report if one exists

**Compliance gates** (if applicable):
- Verify each compliance requirement is met

**Deployment gates:**
- Rollback procedure documented? (check release-plan.md)
- Release notes drafted? (check release-plan.md)
- Artifacts built? (check or build them)

## Step 3: Gate Check Result

Present the gate check results:

```markdown
## Release Gate Check: [Milestone Name]

| Gate | Status | Details |
|------|--------|---------|
| Must-fix issues resolved | PASS/FAIL | [N open] |
| No open blockers | PASS/FAIL | [N open] |
| All acceptance criteria verified | PASS/FAIL | [details] |
| Tests passing | PASS/FAIL | [details] |
| Regression check complete | PASS/FAIL | [details] |
| Rollback procedure documented | PASS/FAIL | |
| Release notes drafted | PASS/FAIL | |
| Artifacts built | PASS/FAIL | |

**Overall: READY / NOT READY**
```

**If any gate FAILS: STOP.** Report what's not met and what needs to happen to fix it. Do NOT proceed with deployment. Create GitHub issues for any blocking items if they don't already exist.

**If all gates PASS:** Confirm with the user before proceeding to deployment.

## Step 4: Build Release Artifacts

Following the release plan's artifact definitions:
1. Build the release artifacts (per env-context build process)
2. Verify the artifacts (checksums, signatures, size checks)
3. Tag the release in git if applicable

Present the artifacts to the user for confirmation.

## Step 5: Deploy

Following the env-context delivery mechanism and the release plan's pre-release checklist:

1. Execute the deployment procedure step by step
2. After each step, verify it succeeded before proceeding
3. Run post-deployment verification checks (health checks, smoke tests per env-context monitoring)

**If any step fails:**
- STOP immediately
- Report what failed and at which step
- Ask the user: continue troubleshooting or execute rollback?

## Step 6: Post-Deployment Verification

After deployment completes:
1. Run the post-deployment checks defined in the release plan
2. Verify monitoring/observability signals (per env-context)
3. Confirm the deployed version matches what was intended

## Step 7: Produce Deployment Report

```markdown
## Deployment Report: [Milestone Name]

**Date:** [today]
**Version:** [version]
**Status:** SUCCESS / FAILED / ROLLED BACK

### Gate Check
[Summary of gate results]

### Artifacts
| Artifact | Version | Checksum |
|----------|---------|----------|
| [name] | [ver] | [hash] |

### Deployment Steps
| Step | Status | Notes |
|------|--------|-------|
| [step] | OK/FAIL | [details] |

### Post-Deployment Verification
| Check | Status | Details |
|-------|--------|---------|
| [check] | PASS/FAIL | [details] |

### Issues Encountered
[Any problems during deployment and how they were resolved.]

### Rollback
[Was rollback needed? If so, what triggered it and was it successful?]
```

If the deployment failed or was rolled back, create a GitHub issue:

```bash
gh issue create \
  --title "Deployment failure: [Milestone name] — [brief description]" \
  --label "bug" \
  --body "$(cat <<'EOF'
## Description

[What failed during deployment of [Milestone name].]

**Step that failed:** [which deployment step]
**Rollback status:** [executed successfully / not needed / failed]

## Details

[Error messages, logs, observations]

## Next Steps

- [ ] [What needs to happen before re-attempting deployment]
EOF
)"
```

Save the deployment report as part of the DevOps handoff note for this session.
