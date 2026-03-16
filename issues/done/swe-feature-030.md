# Add adaptive complexity assessment to /add-feature

**Type:** feature
**Expert:** swe
**Milestone:** [PM Planning Improvements] Adaptive interview and date-free PM output
**Status:** backlog

## User Story

As a developer using the PM expert, I want `/add-feature` to assess the complexity of my request upfront and shorten the interview for small or obvious features so that I don't have to answer 5 categories of questions for a trivial change.

## Description

The PM's `/add-feature` skill currently runs a fixed 5-category interview (What, Why, Scope, Success, Risks) regardless of how simple the request is. Add a complexity assessment step at the beginning: when the user provides a description, the PM should reason about its size and complexity. For small/trivial features, it should run an abbreviated interview — confirming its understanding and assumptions in one pass rather than walking through each category individually. The PM must explicitly state its assumptions when shortening the interview so the user can correct if it misjudged.

## Acceptance Criteria

- [ ] `add_feature.md` includes a complexity assessment step before the interview begins
- [ ] When the user provides a description, the PM evaluates whether the feature is small, medium, or large
- [ ] For small features, the PM runs an abbreviated interview: summarizes its understanding with explicit assumptions, then asks the user to confirm or correct — instead of 5 separate categories
- [ ] For medium/large features, the PM runs the full 5-category interview as before
- [ ] The PM always states its assumptions explicitly when using the abbreviated flow
- [ ] The skill instructions make clear the user can push back and request the full interview at any time

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** None
**Inputs:** project brief (always), `experts/technical/project-manager/skills/add_feature.md`, `docs/interview-notes-pm-planning-improvements.md`
**Out of scope:** Changing the full `/interview` skill (that's for new projects, not features); changing other experts' skills

## Session 15 Summary

**What was done:** Restructured `/add-feature` skill into a 3-step flow with complexity assessment. Small features get an abbreviated single-pass interview; medium/large features get the full 5-category interview.
**Handoff note:** `docs/handoff-notes/swe/session-15.md`
**All acceptance criteria met:** Yes
