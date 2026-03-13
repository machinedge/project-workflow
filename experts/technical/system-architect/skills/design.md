Create the initial system architecture or a major feature architecture. Produces `docs/architecture.md`.

The user may specify a scope or focus area: $ARGUMENTS

---

## Step 1: Load Context

Read these files automatically:
1. `docs/project-brief.md`
2. `docs/roadmap.md` (if it exists)
3. `docs/interview-notes*.md` (if any exist — raw requirements context)
4. `docs/architecture.md` (if it exists — you may be extending, not starting fresh)
5. `docs/env-context.md` (if it exists — deployment and infrastructure constraints)

If the user specified a scope (e.g., "design the data layer"), focus on that area. Otherwise, design the full system architecture.

Confirm your understanding:
- "Project: [1 sentence]"
- "Design scope: [full system / specific area]"
- "Key constraints I see: [from project brief and env-context]"

Wait for user confirmation before proceeding.

## Step 2: Identify Components

Analyze the project requirements and identify the major components:

- What are the system boundaries? (What's inside vs. outside your control?)
- What are the major components or modules?
- How do they communicate? (APIs, events, shared state, etc.)
- What are the cross-cutting concerns? (Auth, logging, error handling, config, etc.)

Present this as a structured list, not prose. Keep it concrete.

## Step 3: Define Interfaces and Data Flow

For each component boundary:

- What data crosses the boundary? (Inputs, outputs, formats)
- What are the contracts? (API shapes, message schemas, shared types)
- What are the failure modes? (What happens when a component is unavailable or returns errors?)

## Step 4: Document Decisions

For each significant architectural decision:

- What was the question?
- What options were considered?
- What was chosen and why?
- What are the consequences and trade-offs?

Use an Architecture Decision Record (ADR) style within the document.

## Step 5: Draft `docs/architecture.md`

Create the architecture document using this structure:

```markdown
# System Architecture

## Overview
[1-2 paragraphs. What the system does at a high level and the architectural approach.]

## Components
[For each component: name, responsibility, boundaries]

## Data Flow
[How data moves through the system. Key paths.]

## Cross-Cutting Concerns
[Auth, logging, error handling, configuration, etc.]

## Interfaces and Contracts
[API contracts, message formats, shared types between components]

## Technology Choices
| Area | Choice | Rationale |
|------|--------|-----------|

## Architecture Decisions
| ID | Decision | Status | Date |
|----|----------|--------|------|
| ADR-001 | [Decision title] | Accepted | [Date] |

### ADR-001: [Decision Title]
**Context:** [What question needed answering]
**Options:** [What was considered]
**Decision:** [What was chosen]
**Consequences:** [Trade-offs accepted]

## Constraints
[From project brief and env-context — what the architecture must respect]
```

Scale the detail to the project's complexity. A small project needs a short document. Don't pad.

## Step 6: Review with User

Present the draft to the user. Walk through the key decisions and trade-offs. Wait for approval before saving.

If the user requests changes, update the draft and present again.

Save `docs/architecture.md` only after the user approves.
