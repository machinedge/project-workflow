# Phase 2: Vision & Architecture

## Purpose
Transform the ideation capture into a clear vision statement and initial architecture that will guide all subsequent work.

## Input
- `docs/ideation.md` from Phase 1

## Output
- `docs/vision.md` - What we're building, why, and what success looks like
- `docs/architecture.md` - High-level technical approach and key decisions

## Claude's Role

I'll help you refine the raw ideas into actionable documents through **focused questions**. We'll tackle vision first, then architecture.

### Vision Extraction

1. **Value Proposition** - What's the unique value this delivers?
2. **Target Outcome** - What state of the world are we creating?
3. **Scope Boundaries** - What's explicitly in/out of scope?
4. **Success Metrics** - How will we measure progress?
5. **Differentiators** - What makes this approach unique?

### Architecture Extraction

1. **Core Components** - What are the major building blocks?
2. **Technology Choices** - What platforms, languages, frameworks?
3. **Integration Points** - What external systems/APIs?
4. **Data Model** - What are the key entities and relationships?
5. **Deployment Model** - Where does this run? How is it delivered?
6. **Key Trade-offs** - What decisions have significant implications?

## How This Works

1. **Load ideation.md** as context
2. **Vision questions** - I ask about purpose, value, boundaries
3. **Generate vision.md draft** - you review and refine
4. **Architecture questions** - I ask about technical approach
5. **Generate architecture.md draft** - you review and refine
6. **You approve both** - "ok, it looks good"

## Questions I Might Ask

### Vision Questions
- "Looking at your goals, which one is the *primary* driver?"
- "If you had to explain this to a potential user in 30 seconds, what would you say?"
- "What's the one thing this absolutely must do well to succeed?"
- "What are you explicitly *not* trying to solve?"
- "How will you know in 6 months if this was worth building?"

### Architecture Questions
- "Do you have existing technology preferences or constraints?"
- "What's your deployment target - cloud, edge, local, hybrid?"
- "Are there specific integrations that are must-haves?"
- "What scale are we designing for initially? What about later?"
- "What are the highest-risk technical unknowns?"
- "Are there security or compliance requirements?"

## Vision Document Template

```markdown
# [Project Name] - Vision

## Vision Statement
[2-3 sentences capturing the essence of what this is and why it matters]

## Problem We're Solving
[Clear articulation of the pain point, derived from ideation]

## Target Users
### Primary
[Who benefits most? Be specific about their role/context]

### Secondary
[Who else benefits?]

## Value Proposition
[What unique value does this deliver that alternatives don't?]

## Goals
### Primary Goal
[The one thing that matters most]

### Supporting Goals
- [Goal 2]
- [Goal 3]

## Scope

### In Scope (MVP)
- [Capability 1]
- [Capability 2]

### In Scope (Future)
- [Capability 3]
- [Capability 4]

### Out of Scope
- [Explicitly excluded 1]
- [Explicitly excluded 2]

## Success Metrics
| Metric | Target | Timeframe |
|--------|--------|-----------|
| [Metric 1] | [Target] | [When] |
| [Metric 2] | [Target] | [When] |

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk 1] | [H/M/L] | [Approach] |
| [Risk 2] | [H/M/L] | [Approach] |
```

## Architecture Document Template

```markdown
# [Project Name] - Architecture

## Overview
[High-level description of the technical approach]

## Architecture Diagram
[ASCII diagram or description of major components and their relationships]

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Component  │────▶│  Component  │────▶│  Component  │
│      A      │     │      B      │     │      C      │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Core Components

### [Component 1]
- **Purpose:** [What it does]
- **Technology:** [Stack/framework]
- **Responsibilities:** [Key functions]

### [Component 2]
- **Purpose:** [What it does]
- **Technology:** [Stack/framework]
- **Responsibilities:** [Key functions]

## Technology Stack
| Layer | Technology | Rationale |
|-------|------------|-----------|
| [Layer] | [Tech] | [Why] |

## Data Model

### Key Entities
- **[Entity 1]:** [Description]
- **[Entity 2]:** [Description]

### Relationships
[Description of how entities relate]

## Integration Points
| System | Purpose | Protocol |
|--------|---------|----------|
| [System] | [Why] | [How] |

## Deployment Model
[Where and how this runs - cloud provider, edge devices, local, etc.]

## Key Architecture Decisions

### [Decision 1]
- **Context:** [Why this decision was needed]
- **Decision:** [What we decided]
- **Rationale:** [Why]
- **Trade-offs:** [What we gave up]

### [Decision 2]
...

## Security Considerations
[Authentication, authorization, data protection approach]

## Scalability Considerations
[How the architecture handles growth]

## Open Technical Questions
- [Question 1]
- [Question 2]
```

## Moving to Phase 3

With vision and architecture defined, you have:
- Clear articulation of what you're building and why
- Technical foundation and key decisions documented
- Scope boundaries that will inform roadmap planning

This becomes input to **Phase 3: Roadmap**, where we'll plan the evolution from MVP to full vision.

---

**Ready to start?** Make sure you have `docs/ideation.md` loaded as context, then tell me you're ready to begin vision extraction.
