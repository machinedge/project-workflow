---
name: qa-bug-triage
description: "Review the open bug and issue backlog and produce a prioritized action plan. Use when the user wants to assess, categorize, and prioritize open issues, or when deciding which bugs to fix before continuing with new feature work."
---

Review the open bug and issue backlog and produce a prioritized action plan.

## Step 1: Load Context

Read these files:
1. `docs/project-brief.md` — understand the project goals, constraints, and current status
2. `docs/roadmap.md` — understand the current milestone and what's planned
3. Most recent handoff note in `.workflow/handoff-notes/qa/` (if any exist) — understand recent QA activity
4. `docs/architecture.md` (if it exists) — understand system-level context for assessing impact

Read `.workflow/issues/issues-list.md` for an overview, then scan `.workflow/issues/backlog/`, `.workflow/issues/planned/`, and `.workflow/issues/in-progress/` to read all open issue files.

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

**Open issues:** [N total]
**Current milestone:** [name from roadmap]

### Blockers (fix immediately)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| [filename] | [title] | [what it blocks] | [Small/Med/Large] |

### High Priority (fix this milestone)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| [filename] | [title] | [what's affected] | [Small/Med/Large] |

### Medium Priority (schedule soon)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| [filename] | [title] | [what's affected] | [Small/Med/Large] |

### Low Priority (backlog)
| Issue | Title | Impact | Effort |
|-------|-------|--------|--------|
| [filename] | [title] | [what's affected] | [Small/Med/Large] |

### Recommended Order of Work
1. [[filename] — why first]
2. [[filename] — why next]
3. [[filename] — ...]

### Assessment
[1-3 sentences. Overall bug health — is the backlog growing, shrinking, or stable? Are bugs being caught early or late? Any systemic patterns?]
```

## Step 4: Update Issue Files

For each issue, update the **Severity** field in the issue file's metadata to reflect the triage assessment (blocker, high, medium, or low). If the issue file doesn't have a Severity field, add one.

Run `.claude/scripts/update-issues-list.sh` to regenerate `.workflow/issues/issues-list.md` with updated severity assignments.

## Step 5: Recommend Next Actions

Based on the triage, suggest concrete next steps:
- Which bugs should be fixed before continuing with new feature work?
- Should any bugs be batched together into a single fix session?
- Are there patterns suggesting a systemic issue (e.g., all bugs in one module)?
- Should the user adjust the roadmap to account for bug fix work?
