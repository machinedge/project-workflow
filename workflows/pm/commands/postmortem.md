Run a post-mortem on a completed milestone.

The user may specify which milestone: $ARGUMENTS

## Step 1: Load context

Read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`
3. ALL handoff notes across all workflows — read every file in `docs/handoff-notes/swe/`, `docs/handoff-notes/qa/`, `docs/handoff-notes/devops/`, and `docs/handoff-notes/pm/`
4. `docs/lessons-log.md`
5. `docs/test-plan.md` (if it exists — QA's test plan)
6. `docs/release-plan.md` (if it exists — DevOps release plan)

Also pull the milestone's issues from GitHub:
```bash
gh issue list --milestone "[Milestone name]" --state all --json number,title,state,labels
```

If the user didn't specify a milestone, determine which one was most recently completed based on the handoff notes and roadmap.

## Step 2: Perform the post-mortem

Analyze and present:

**1. Progress Assessment**
Is the milestone actually done? Compare what was planned vs. what was delivered. Check the GitHub issues — are all tasks closed? Any still open? Any review findings (`must-fix`, `should-fix`) unresolved?

**2. Plan Impact**
Based on what we learned, do remaining milestones need to change? New risks? Timeline shifts? Scope adjustments?

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

## Step 3: Update documents

After user reviews and approves:
- Save updated `docs/project-brief.md`
- Update `docs/roadmap.md` — mark milestone complete, update dates, adjust risks
- Add lessons to `docs/lessons-log.md`

Be critical, not encouraging. The user needs an honest assessment, not cheerleading.
