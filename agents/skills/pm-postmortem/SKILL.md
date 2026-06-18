---
name: pm-postmortem
description: "Review a completed milestone with an honest assessment. Use when a milestone is finished and the user wants analysis of what happened, lessons learned, quality and delivery assessment, and plan adjustments."
---

Run a post-mortem on a completed milestone.

The user may specify which milestone: $ARGUMENTS

## Step 1: Load context

Read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`
3. ALL handoff notes across all workflows — read every file in `.sdlc/handoff-notes/swe/`, `.sdlc/handoff-notes/qa/`, `.sdlc/handoff-notes/devops/`, `.sdlc/handoff-notes/pm/`, and `.sdlc/handoff-notes/system-architect/`
4. `.sdlc/lessons-log.md`
5. `docs/test-plan.md` (if it exists — QA's test plan)
6. `docs/release-plan.md` (if it exists — DevOps release plan)

Also read the milestone's issues: scan all `.sdlc/issues/` subdirectories for files matching the milestone (check the **Milestone** field in each file). Read `.sdlc/issues/issues-list.md` for a quick overview.

If the user didn't specify a milestone, determine which one was most recently completed based on the handoff notes and roadmap.

## Step 2: Perform the post-mortem

Gather the eight areas below, then present them to the user in the scannable layout at the end of this step.

**1. Progress Assessment**
Is the milestone actually done? Compare what was planned vs. what was delivered. Check the issue files — are all tasks in `.sdlc/issues/done/`? Any still in `backlog/`, `planned/`, or `in-progress/`? Any review findings (`must-fix`, `should-fix`) unresolved?

**2. Plan Impact**
Based on what we learned, do remaining milestones need to change? New risks? Scope adjustments?

**3. Decisions Audit**
List every decision made across the milestone's sessions (from handoff notes). Verify they're all in the project brief. Add any missing ones.

**4. Lessons Learned**
What went well? What was harder than expected? What should change for the next milestone?

**5. Quality Assessment**
Pull QA data from handoff notes and issues:
- Review findings: how many must-fix vs. should-fix? How many resolved vs. unresolved?
- If `docs/test-plan.md` exists: what's the test coverage? Any gaps?
- Regression results: any cross-task interference discovered?
- Were bugs caught early (during development) or late (during review/regression)?
- Overall quality trend: is quality improving, stable, or declining across milestones?

If no QA sessions were run for this milestone, note that as a gap.

**6. Delivery Assessment**
Pull DevOps data from handoff notes and issues:
- Did the build/test pipeline work smoothly? Any failures or flakiness?
- Any deployment failures or environment issues?
- If `docs/release-plan.md` exists: were all release gates met? Any gate failures?
- Time from "code complete" to "deployed and verified" — was it reasonable?
- Any rollback events?

If no DevOps sessions were run for this milestone, note that as a gap (or note it's not applicable if the project doesn't have deployment concerns yet).

**7. Updated Project Brief**
Produce an updated `docs/project-brief.md` with current status, all decisions, and any corrections.

**8. Next Milestone Prep**
What should the first task of the next milestone be? Any blockers to resolve first? Any open `must-fix` or `should-fix` issues that should be addressed before starting new work? Any QA or DevOps tasks to front-load?

### Presentation layout

Present the post-mortem in this layout. Follow the **Writing clearly** conventions in `AGENTS.md` — lead each section with its verdict, expand every issue ID and codename on first mention, write full sentences, use real bullets. The *Updated Project Brief* (area 7) is a document action in Step 3, not a presented section. Be critical, not encouraging.

```markdown
## Postmortem: M<N> — <title>
**Bottom line:** <one sentence — is it done, and the single most important caveat>

### Is it actually done?
<one-line status, e.g. "6 of 6 issues done; 3 acceptance items never verified">
- <plain bullet per gap, jargon expanded>

### Impact on the plan
- <risks to remaining milestones, scope shifts — plain bullets>

### Decisions to record
- <each decision made this milestone, and whether it's already in the brief>

### Quality
- <findings must-fix vs should-fix, resolved vs open; coverage gaps; regression; trend. Note if no QA ran.>

### Delivery
- <pipeline / deploy / release-gate / rollback notes. Note if no DevOps ran, or N/A.>

### What we learned
- <what went well / what was harder than expected — plain bullets>

### What to do next
- <first task of the next milestone; blockers to clear first; open must-fix/should-fix to address>
```

Section map: *Is it actually done?* = area 1, *Impact on the plan* = area 2, *Decisions to record* = area 3, *Quality* = area 5, *Delivery* = area 6, *What we learned* = area 4, *What to do next* = area 8.

## Step 3: Update documents

These are authored artifacts that future sessions read as memory — write the edits following the **Writing clearly** conventions in `AGENTS.md` (plain language, expand IDs/codenames on first mention, real lists, no walls of text), not the dense terminal report you just presented.

After user reviews and approves:
- Save updated `docs/project-brief.md`
- Update `docs/roadmap.md` — mark milestone complete, adjust risks
- Add lessons to `.sdlc/lessons-log.md`

Be critical, not encouraging. The user needs an honest assessment, not cheerleading.
