Run a post-mortem on a completed milestone.

The user may specify which milestone: $ARGUMENTS

## Step 1: Load context

Read these files:
1. `docs/project-brief.md`
2. `docs/roadmap.md`
3. ALL handoff notes in `docs/handoff-notes/` (read every file)
4. `docs/lessons-log.md`

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

**5. Updated Project Brief**
Produce an updated `docs/project-brief.md` with current status, all decisions, and any corrections.

**6. Next Milestone Prep**
What should the first task of the next milestone be? Any blockers to resolve first? Any open `must-fix` or `should-fix` issues that should be addressed before starting new work?

## Step 3: Update documents

After user reviews and approves:
- Save updated `docs/project-brief.md`
- Update `docs/roadmap.md` — mark milestone complete, update dates, adjust risks
- Add lessons to `docs/lessons-log.md`

Be critical, not encouraging. The user needs an honest assessment, not cheerleading.
