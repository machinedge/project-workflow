# Phase 1: Ideation

## Purpose
Extract the raw ideas, concerns, goals, and problems from your head into a structured document that can inform vision and architecture decisions.

## Input
- Your rough thoughts, brain dump, or initial concept
- Any existing notes, sketches, or prior exploration

## Output
- `docs/ideation.md` - Structured capture of ideas, concerns, goals, and open questions

## Claude's Role

I'll help you externalize your thinking through **focused, one-at-a-time questions**. My goal is to pull out:

1. **The Core Idea** - What are you trying to build/solve?
2. **Motivation** - Why does this matter? What's the pain point?
3. **Users/Beneficiaries** - Who is this for?
4. **Goals** - What does success look like?
5. **Concerns** - What worries you? What could go wrong?
6. **Constraints** - Time, budget, technical limitations, dependencies?
7. **Open Questions** - What don't you know yet?
8. **Prior Art** - What exists that's similar? Why isn't it sufficient?

## How This Works

1. **You share your initial thoughts** - however rough or incomplete
2. **I ask clarifying questions** - one at a time, to dig deeper
3. **I generate a draft** - `ideation.md` capturing everything
4. **We iterate** - you review, I refine
5. **You approve** - "ok, it looks good"

## Conversation Starters

If you're not sure where to begin, try:

- "I have an idea for [X] but I haven't fully thought it through yet..."
- "I keep running into this problem: [describe pain point]..."
- "I want to build something that does [vague description]..."
- "Here's a brain dump of what I'm thinking: [stream of consciousness]..."

## Questions I Might Ask

- "What triggered this idea? Was there a specific moment or frustration?"
- "If this existed and worked perfectly, what would be different?"
- "Who would use this first? What's their current workaround?"
- "What's the smallest version of this that would still be valuable?"
- "What technical unknowns make you nervous?"
- "Is there a deadline or event driving this?"
- "What have you already tried or explored?"

## Draft Template

When I generate the ideation document, it will follow this structure:

```markdown
# [Project Name] - Ideation

## Core Concept
[One paragraph summary of what this is]

## Problem Statement
[What pain point or opportunity does this address?]

## Target Users
[Who benefits? What are their characteristics?]

## Goals
- [Goal 1]
- [Goal 2]
- ...

## Success Criteria
[How will we know this worked?]

## Concerns & Risks
- [Concern 1]
- [Concern 2]
- ...

## Constraints
- **Time:** [timeline if any]
- **Budget:** [resources available]
- **Technical:** [platform constraints, dependencies]
- **Other:** [any other limitations]

## Open Questions
- [Question 1]
- [Question 2]
- ...

## Prior Art & Alternatives
- [Existing solution 1] - why it doesn't fit
- [Existing solution 2] - why it doesn't fit
- ...

## Initial Thoughts on Approach
[Any early ideas about how to solve this - not commitments, just directions to explore]
```

## Moving to Phase 2

When ideation is complete, you'll have a clear capture of:
- What you're trying to do
- Why it matters
- What constraints and risks exist
- What questions need answering

This becomes input to **Phase 2: Vision & Architecture**, where we'll define the solution more concretely.

---

**Ready to start?** Share your initial thoughts and I'll begin the extraction process.
