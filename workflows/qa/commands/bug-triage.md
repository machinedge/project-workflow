Review the open bug and issue backlog and produce a prioritized action plan.

---

## Step 1: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals, constraints, and current status
2. `docs/roadmap.md` — understand the current milestone and what's planned

Pull all open issues from GitHub:
```bash
gh issue list --state open --json number,title,labels,milestone,createdAt,body --limit 100
```

## Step 2: Categorize Issues

For each open issue, assess:

**Severity**
- **Blocker** — Prevents core functionality from working. Must be fixed before any other work.
- **High** — Causes significant problems but has a workaround. Fix within the current milestone.
- **Medium** — Noticeable quality issue. Schedule for this or next milestone.
- **Low** — Minor annoyance. Fix when convenient.

**Impact on current milestone**
- Does this bug block any in-progress or upcoming tasks?
- Does it affect a completed task's acceptance criteria (regression)?
- Is it in scope for the current milestone, or is it a future concern?

**Effort to fix**
- **Small** — Quick fix, single file, low risk of side effects.
- **Medium** — Requires understanding context, touches multiple files.
- **Large** — Significant rework or architectural implications.

**Dependencies**
- Does fixing this require other issues to be resolved first?
- Does fixing this unblock other work?

## Step 3: Produce the Triage Report

Present findings:

```markdown
## Bug Triage Report

**Date:** [today]
**Open issues:** [N total]
**Current milestone:** [name from roadmap]

### Blockers (fix immediately)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| #N | [title] | [what it blocks] | [Small/Med/Large] |

### High Priority (fix this milestone)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| #N | [title] | [what's affected] | [Small/Med/Large] |

### Medium Priority (schedule soon)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| #N | [title] | [what's affected] | [Small/Med/Large] |

### Low Priority (backlog)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| #N | [title] | [what's affected] | [Small/Med/Large] |

### Recommended Order of Work
1. [Issue #N — why first]
2. [Issue #N — why next]
3. [Issue #N — ...]

### Assessment
[1-3 sentences. Overall bug health — is the backlog growing, shrinking, or stable? Are bugs being caught early or late? Any systemic patterns?]
```

## Step 4: Update Labels

Apply severity labels to issues that don't have them:

```bash
gh issue edit [number] --add-label "blocker"
gh issue edit [number] --add-label "high"
gh issue edit [number] --add-label "medium"
gh issue edit [number] --add-label "low"
```

Create labels if they don't exist:
```bash
gh label create blocker --description "Blocks core functionality" --color B60205
gh label create high --description "High priority bug" --color D93F0B
gh label create medium --description "Medium priority bug" --color FBCA04
gh label create low --description "Low priority bug" --color 0E8A16
```

## Step 5: Recommend Next Actions

Based on the triage, suggest concrete next steps:
- Which bugs should be fixed before continuing with new feature work?
- Should any bugs be batched together into a single fix session?
- Are there patterns suggesting a systemic issue (e.g., all bugs in one module)?
- Should the user adjust the roadmap to account for bug fix work?
