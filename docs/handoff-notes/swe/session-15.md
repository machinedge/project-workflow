# Handoff Note: Add adaptive complexity assessment to /add-feature

**Issue:** swe-feature-030 — Add adaptive complexity assessment to /add-feature

## What Was Accomplished

Restructured the PM's `/add-feature` skill from a fixed 5-category interview into a 3-step flow: assess complexity, run the appropriate interview (abbreviated or full), then produce the summary. Small features now get a single-pass summary with explicit assumptions instead of 5 separate interview rounds.

## Acceptance Criteria Status

- [x] `add_feature.md` includes a complexity assessment step before the interview begins
- [x] When the user provides a description, the PM evaluates whether the feature is small, medium, or large
- [x] For small features, the PM runs an abbreviated interview: summarizes its understanding with explicit assumptions, then asks the user to confirm or correct
- [x] For medium/large features, the PM runs the full 5-category interview as before
- [x] The PM always states its assumptions explicitly when using the abbreviated flow
- [x] The skill instructions make clear the user can push back and request the full interview at any time

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Three-tier classification (small/medium/large) with only two interview paths (abbreviated/full) | Medium and large both need the full interview — splitting into three paths would add complexity without value. The three tiers help the PM reason about the request; the two paths keep behavior simple. |
| Included a template blockquote showing the exact abbreviated format | Concrete examples produce more consistent PM behavior than abstract instructions |

## Problems Encountered

None.

## Scope Changes

None — task went exactly as planned.

## Files Created or Modified

- `experts/technical/project-manager/skills/add_feature.md` — restructured from flat 5-category interview to 3-step flow with complexity assessment

## What the Next Session Needs to Know

1. Both M8 tasks (swe-feature-029 and swe-feature-030) are now complete. M8 should be ready for postmortem or can simply be marked done.
2. The Cursor rules file (`.cursor/rules/project-manager-os.mdc`) references `/add_feature` in its Skills section but doesn't contain the skill logic itself — the canonical definition in `experts/technical/project-manager/skills/add_feature.md` is what gets installed. No Cursor rule update needed.
3. Open question from session 14 still stands: should date-removal treatment be applied to other experts' handoff/skill templates too?

## Open Questions

- [ ] Should M8 be marked done now, or does the user want a QA review first?
- [ ] Should date-removal be applied across all experts (not just PM)?
