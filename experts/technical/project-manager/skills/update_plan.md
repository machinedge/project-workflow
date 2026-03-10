Update the project brief and roadmap with a newly scoped feature.

If the user provided a reference: $ARGUMENTS

First, read these files:
1. `docs/project-brief.md` — if it doesn't exist, tell the user to run `/interview` and `/vision` first.
2. `docs/roadmap.md` — if it doesn't exist, tell the user to run `/roadmap` first.
3. The most recent `docs/interview-notes-*.md` file (by modification date), or the one the user specifies.

If no feature interview notes exist (`docs/interview-notes-*.md`), tell the user to run `/add_feature` first.

## Update the project brief

Add the new feature to `docs/project-brief.md`. This is a surgical update — do NOT rewrite existing content.

Changes to make:
1. **Success Looks Like** — Append new success criteria for the feature. Prefix each with the feature name in brackets, e.g. `- [ ] [Dark Mode] User can toggle between light and dark themes`.
2. **Constraints** — Add any new constraints surfaced during the feature interview. If none, skip.
3. **Key Decisions Made** — Add a row recording the decision to add this feature, with today's date and reasoning from the interview notes.
4. **Current Status** — Update `Last updated`, set `Next task` to "Decompose [feature name] into tasks".

After updating, check the word count. If over 1,000 words:
- Compress older entries in "Key Decisions Made" (collapse rationale).
- Tighten "Notes for AI" to essentials only.
- If still over, flag it to the user and ask what to cut — do NOT silently drop content.

## Update the roadmap

Add new milestones to `docs/roadmap.md` for the feature:

1. **Milestones table** — Add 1-3 new milestones for the feature. Follow existing milestone conventions:
   - Milestones are demo-able outcomes, not layers or tasks.
   - Each milestone delivers a thin vertical slice.
   - Each should take 2-5 sessions.
   - Set `Depends On` to reference existing milestones where the feature touches existing functionality.
   - Prefix milestone names with the feature name in brackets, e.g. `[Dark Mode] User can toggle theme`.
2. **Dependency Map** — Update to show how new milestones relate to existing ones.
3. **Risk Register** — Add at least one risk for the new feature.
4. **Change Log** — Add a row with today's date: "Added [feature name] milestones from interview notes."

## Present changes for review

Show the user a summary of what changed:
- New success criteria added to brief
- New milestones added to roadmap (with dependency links)
- New risks identified
- Current word count of the brief

Ask the user to review and approve before saving. If they request changes, incorporate them.

## After saving

Tell the user to run `/decompose` next to break the new milestones into tasks. Suggest specifying the milestone name, e.g.:
> Run `/decompose [Dark Mode] User can toggle theme` to create tasks for the first new milestone.

Rules:
- Do NOT rewrite or reorder existing milestones, success criteria, or decisions.
- Do NOT remove or compress existing content without user approval.
- Do NOT re-run the interview — the feature interview notes are the input.
- If the interview notes contradict the existing brief, flag the contradiction and ask the user to decide. Do not silently resolve it.
- Keep changes minimal and additive. The brief and roadmap are shared artifacts — other experts depend on their stability.
