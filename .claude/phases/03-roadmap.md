# Phase 3: Roadmap

## Purpose
Create a high-level roadmap that defines the MVP and plans the evolution toward the full vision. This is about milestones and goalposts, not detailed tasks.

## Input
- `docs/vision.md` from Phase 2
- `docs/architecture.md` from Phase 2

## Output
- `docs/roadmap.md` - Milestones from MVP through future evolution

## Claude's Role

I'll help you think through the sequencing of capabilities through **focused questions**:

1. **MVP Definition** - What's the smallest thing that delivers value?
2. **Milestone Sequencing** - What comes after MVP? In what order?
3. **Dependencies** - What must come before what?
4. **Risk Ordering** - Should we tackle risky things early or late?
5. **Value Delivery** - When do users start getting value?

## How This Works

1. **Load vision.md and architecture.md** as context
2. **MVP questions** - I help you identify the minimal viable scope
3. **Milestone questions** - I help you sequence the remaining capabilities
4. **Generate roadmap.md draft** - you review and refine
5. **You approve** - "ok, it looks good"

## Key Principles

### MVP Should Be
- **Viable** - Actually delivers value to someone
- **Minimal** - Smallest scope that's still viable
- **Testable** - You can validate assumptions with it
- **Buildable** - Achievable in a reasonable timeframe

### Milestones Should Be
- **Outcome-oriented** - Defined by what users can do, not tasks completed
- **Incrementally valuable** - Each milestone adds real capability
- **Demonstrable** - You can show progress to stakeholders
- **Appropriately sized** - Big enough to matter, small enough to achieve

## Questions I Might Ask

### MVP Questions
- "Looking at your in-scope capabilities, which ones are absolutely essential for first value?"
- "What's the simplest user journey that would validate your core assumption?"
- "If you could only ship one thing, what would it be?"
- "What can you defer that feels important but isn't critical for initial validation?"
- "Who is the first user, and what's the minimum they need?"

### Sequencing Questions
- "After MVP, what's the most requested/valuable addition?"
- "Are there technical foundations that need to be laid before certain features?"
- "What capabilities reduce risk if built early?"
- "What can be parallelized vs. what must be sequential?"
- "Are there external dependencies that affect timing?"

### Scope Questions
- "Is there anything in your 'future scope' that should move up?"
- "Is there anything in MVP scope that could be deferred?"
- "What would cause you to change this sequence?"

## Roadmap Document Template

```markdown
# [Project Name] - Roadmap

## Overview
[Brief description of the journey from MVP to full vision]

## Milestone Summary

| Milestone | Theme | Key Outcome | Target |
|-----------|-------|-------------|--------|
| M0: MVP | [theme] | [what users can do] | [timeframe] |
| M1: [name] | [theme] | [what users can do] | [timeframe] |
| M2: [name] | [theme] | [what users can do] | [timeframe] |
| M3: [name] | [theme] | [what users can do] | [timeframe] |

---

## M0: MVP - [Theme]

### Objective
[What this milestone achieves - user-focused]

### Key Capabilities
- [Capability 1] - [why it's essential]
- [Capability 2] - [why it's essential]

### Success Criteria
- [Measurable outcome 1]
- [Measurable outcome 2]

### What's Explicitly Deferred
- [Deferred item 1] - [why it can wait]
- [Deferred item 2] - [why it can wait]

### Key Risks
- [Risk 1] - [mitigation approach]

### Estimated Scope
[T-shirt size: S/M/L or sprint count estimate]

---

## M1: [Milestone Name] - [Theme]

### Objective
[What this milestone achieves]

### Prerequisites
- M0 complete
- [Any other dependencies]

### Key Capabilities
- [Capability 1]
- [Capability 2]

### Success Criteria
- [Measurable outcome 1]
- [Measurable outcome 2]

### Estimated Scope
[T-shirt size or sprint count]

---

## M2: [Milestone Name] - [Theme]

[Same structure as M1]

---

## M3: [Milestone Name] - [Theme]

[Same structure as M1]

---

## Future Considerations

### Potential Future Milestones
- [Idea 1] - [brief description]
- [Idea 2] - [brief description]

### Dependencies & External Factors
- [Factor 1] - [how it affects roadmap]
- [Factor 2] - [how it affects roadmap]

### Decision Points
- After M0: [What we'll evaluate before committing to M1]
- After M1: [What we'll evaluate before committing to M2]

---

## Roadmap Visualization

```
[Timeline or dependency visualization]

M0:MVP ────▶ M1:[Name] ────▶ M2:[Name] ────▶ M3:[Name]
  │              │               │
  │              │               └── [parallel track if any]
  │              └── [branch if any]
  └── [foundation work]
```

## Assumptions
- [Assumption 1]
- [Assumption 2]

## Open Questions
- [Question that might affect roadmap]
```

## Moving to Phase 4

With the roadmap defined, you have:
- Clear MVP scope
- Sequenced milestones with defined outcomes
- Understanding of dependencies and decision points

For **Phase 4: Sprint Planning**, you'll pick a milestone (usually M0/MVP first) and break it into executable stories.

---

**Ready to start?** Make sure you have `docs/vision.md` and `docs/architecture.md` loaded as context, then tell me you're ready to begin roadmap planning.
