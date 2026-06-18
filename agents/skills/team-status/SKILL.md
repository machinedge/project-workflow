---
name: team-status
description: "Generate a cross-workflow project health summary. Use when the user asks about project status, overall progress, or wants to know what's happening across all expert workflows. Does not require any specific expert role."
---

Give the user a cross-workflow project health summary.

Read all available project artifacts and produce a concise status report. Check for each artifact's existence before reading — missing artifacts are useful information, not errors.

## Step 1: Load core artifacts

Read these if they exist:
- `docs/project-brief.md` — project identity, goals, current status
- `docs/roadmap.md` — milestones, what's planned vs. completed
- `.sdlc/lessons-log.md` — accumulated gotchas and patterns

If `docs/project-brief.md` doesn't exist, tell the user: "No project brief found. Run `/pm-interview` and ask for the `pm-vision` skill to get started." and stop.

## Step 2: Check issues

Read `.sdlc/issues/issues-list.md` for an overview. Then count issue files in each status folder:
- `.sdlc/issues/backlog/` — items not yet scheduled
- `.sdlc/issues/planned/` — items scheduled for work
- `.sdlc/issues/in-progress/` — items currently being worked on
- `.sdlc/issues/done/` — completed items

Summarize: total by status, any with severity `must-fix` or `blocker`, any bugs (files with `-bug-` in the name).

## Step 3: Check handoff notes

Look for handoff notes in `.sdlc/handoff-notes/` subdirectories (swe/, qa/, devops/, pm/, system-architect/). For each workflow that has notes, report:
- Number of sessions completed
- Most recent session summary (from the last note)

## Step 4: Check downstream artifacts

For each of these, report whether it exists and give a one-line summary if it does:
- `docs/env-context.md` — Environment and deployment context (DevOps)
- `docs/test-plan.md` — Test plan (QA)
- `docs/release-plan.md` — Release plan (DevOps)
- `docs/architecture.md` — System architecture (System Architect)

## Step 5: Produce the status report

Keep the template structure below. Fill its free-text fields (the Workflow Activity summaries and Attention Needed items) following the **Speaking to the user** conventions in `AGENTS.md` — plain language, expand issue IDs and codenames on first mention, one concrete point per bullet.

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
- **System Architect:** [N sessions, last: brief summary | No sessions yet]

### Artifacts
| Artifact | Status |
|----------|--------|
| Project Brief | [exists / missing] |
| Architecture | [exists / missing] |
| Roadmap | [exists / missing] |
| Env Context | [exists / missing] |
| Test Plan | [exists / missing] |
| Release Plan | [exists / missing] |

### Attention Needed
- [Any blockers, stale issues, missing artifacts that downstream workflows need, etc.]
```

## Step 6: Suggest next actions

Based on the current state, suggest 1-3 concrete next actions. For example:
- If no roadmap exists: "Ask for the `pm-roadmap` skill to create a milestone plan."
- If there are open bugs: "Ask for the `qa-bug-triage` skill to prioritize the bug backlog."
- If a milestone looks complete but no postmortem exists: "Ask for the `pm-postmortem` skill to review the completed milestone."
- If no env-context exists but the project has deployment concerns: "Run `/ops-env-discovery` to capture environment context."
