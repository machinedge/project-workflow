Give the user a cross-workflow project health summary.

Read all available project artifacts and produce a concise status report. Check for each artifact's existence before reading — missing artifacts are useful information, not errors.

## Steps

### 1. Load core artifacts

Read these if they exist:
- `docs/project-brief.md` — project identity, goals, current status
- `docs/roadmap.md` — milestones, what's planned vs. completed
- `docs/lessons-log.md` — accumulated gotchas and patterns

If `docs/project-brief.md` doesn't exist, tell the user: "No project brief found. Run `/interview` and `/vision` to get started." and stop.

### 2. Check issues

Read `issues/issues-list.md` for an overview. Then count issue files in each status folder:
- `issues/backlog/` — items not yet scheduled
- `issues/planned/` — items scheduled for work
- `issues/in-progress/` — items currently being worked on
- `issues/done/` — completed items

Summarize: total by status, any with severity `must-fix` or `blocker`, any bugs (files with `-bug-` in the name).

### 3. Check handoff notes

Look for handoff notes in `docs/handoff-notes/` subdirectories (swe/, qa/, devops/, pm/). For each workflow that has notes, report:
- Number of sessions completed
- Most recent session date and summary (from the last note)

### 4. Check downstream artifacts

For each of these, report whether it exists and give a one-line summary if it does:
- `docs/env-context.md` — Environment and deployment context (DevOps)
- `docs/test-plan.md` — Test plan (QA)
- `docs/release-plan.md` — Release plan (DevOps)

### 5. Produce the status report

Format:

```
## Project Status: [project name from brief]

**Goal:** [one-line goal from brief]
**Current milestone:** [from roadmap or brief]
**Overall progress:** [X of Y milestones complete]

### Issue Tracker
- Backlog: N
- Planned: N
- In Progress: N (M bugs, K blockers)
- Done: N

### Workflow Activity
- **PM:** [N sessions | No sessions yet]
- **SWE:** [N sessions, last: brief summary | No sessions yet]
- **QA:** [N sessions, last: brief summary | No sessions yet]
- **DevOps:** [N sessions, last: brief summary | No sessions yet]

### Artifacts
| Artifact | Status |
|----------|--------|
| Project Brief | [exists / missing] |
| Roadmap | [exists / missing] |
| Env Context | [exists / missing] |
| Test Plan | [exists / missing] |
| Release Plan | [exists / missing] |

### Attention Needed
- [Any blockers, stale issues, missing artifacts that downstream workflows need, etc.]
```

### 6. Suggest next actions

Based on the current state, suggest 1-3 concrete next actions. For example:
- If no roadmap exists: "Run `/roadmap` to create a milestone plan."
- If there are open bugs: "Run `/bug-triage` to prioritize the bug backlog."
- If a milestone looks complete but no postmortem exists: "Run `/postmortem` to review the completed milestone."
- If no env-context exists but the project has deployment concerns: "Run `/env-discovery` to capture environment context."
