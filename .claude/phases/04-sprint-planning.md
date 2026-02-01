# Phase 4: Sprint Planning

## Purpose
Break a roadmap milestone into executable stories with clear acceptance criteria. Create the sprint structure that will guide execution.

## Input
- `docs/roadmap.md` from Phase 3
- `docs/architecture.md` from Phase 2
- Previous `sprint-learnings.md` (if not first sprint)

## Output
- `sprints/sprint-XX/STORIES_INDEX.md` - Sprint overview and story list
- `sprints/sprint-XX/stories/*.md` - Individual story files
- `sprints/sprint-XX/POSTMORTEM.md` - Initialized (empty template)

## Claude's Role

I'll help you decompose the milestone into stories through **focused questions**:

1. **Capability Breakdown** - What distinct pieces make up this milestone?
2. **Story Identification** - What's a single, deliverable unit of work?
3. **Sequencing** - What depends on what?
4. **Acceptance Criteria** - How do we know it's done?
5. **Testing Strategy** - How will each story be verified?

## How This Works

1. **Load roadmap.md and architecture.md** as context
2. **Identify target milestone** - Which milestone are we planning?
3. **Decomposition questions** - I help break it into stories
4. **Generate STORIES_INDEX.md** - Sprint overview
5. **Generate individual story files** - One per story
6. **Initialize POSTMORTEM.md** - Empty template ready for entries
7. **You approve** - "ok, it looks good"

## Story Principles

### Good Stories Are
- **Independent** - Can be worked on without blocking others (where possible)
- **Negotiable** - Details can be discussed during execution
- **Valuable** - Delivers something meaningful
- **Estimable** - Scope is clear enough to estimate
- **Small** - Completable in a reasonable timeframe (1-3 days ideal)
- **Testable** - Clear criteria for "done"

### Story Scope
- **Too Big:** "Build the authentication system"
- **Right Size:** "Implement JWT validation middleware"
- **Too Small:** "Add import statement for jwt library"

## Questions I Might Ask

### Decomposition Questions
- "What are the major capabilities this milestone delivers?"
- "For [capability], what are the distinct pieces that could be built separately?"
- "Is there foundational work that multiple stories depend on?"
- "Are there natural boundaries (frontend/backend, module boundaries)?"

### Sequencing Questions
- "Which stories have no dependencies and could start immediately?"
- "What must be complete before [story] can begin?"
- "Are there stories that could be worked in parallel?"

### Acceptance Criteria Questions
- "What would you check to verify [story] is complete?"
- "Are there edge cases that must be handled?"
- "What documentation needs to be updated?"
- "How should this be tested?"

## STORIES_INDEX.md Template

```markdown
# [Sprint Name] - Stories Index

## Sprint Overview

**Goal:** [One sentence describing what this sprint achieves]

**Milestone:** [Which roadmap milestone this addresses]

**Duration:** [Estimated timeframe]

**Key Deliverables:**
- [Deliverable 1]
- [Deliverable 2]

---

## Architecture Decisions

| Area | Decision |
|------|----------|
| [Area] | [Decision and brief rationale] |

---

## Stories Overview

| ID | Title | Status | Dependencies | Complexity |
|----|-------|--------|--------------|------------|
| 01 | [Story Title] | ⬜ | None | [Low/Med/High] |
| 02 | [Story Title] | ⬜ | 01 | [Low/Med/High] |
| 03 | [Story Title] | ⬜ | 01 | [Low/Med/High] |

---

## Story Status Legend

- ⬜ Not Started
- 🔄 In Progress
- ✅ Completed
- ⏸️ Blocked
- ❌ Cancelled

---

## Story Summaries

### Story 01: [Title]
[Brief description of what this story delivers]

### Story 02: [Title]
[Brief description]

---

## Success Criteria

When this sprint is complete:
- [Verifiable outcome 1]
- [Verifiable outcome 2]

---

## Out of Scope
- [Explicitly deferred item 1]
- [Explicitly deferred item 2]
```

## Individual Story Template

```markdown
# Story [XX]: [Title]

## Story Information

- **ID:** [XX]
- **Title:** [Descriptive title]
- **Dependencies:** [Story IDs or "None"]
- **Estimated Complexity:** [Low/Medium/High]

## User Story

As a [persona],
I need [feature/capability],
so that [goal/benefit].

## Description

[2-3 paragraphs explaining what this story delivers and why it matters.
Include enough context for someone to understand the purpose without
reading the entire sprint documentation.]

## Context for AI Agents

[This section provides implementation context without prescribing solutions.
Include relevant architecture details, existing patterns to follow, and
any constraints. Avoid specifying exact implementation - let the agent
discover the best approach.]

### Relevant Files/Modules
- `path/to/relevant/file.py` - [why it's relevant]
- `path/to/another/file.py` - [why it's relevant]

### Patterns to Follow
- [Existing pattern in codebase to maintain consistency]

### Constraints
- [Technical constraint]
- [Business constraint]

## Testing Strategy

### Unit Tests
- [What should be unit tested]

### Integration Tests
- [What integration testing is needed]

### Manual Verification
- [Steps to manually verify the story works]

## Acceptance Criteria

- [ ] [Specific, verifiable criterion 1]
- [ ] [Specific, verifiable criterion 2]
- [ ] [Specific, verifiable criterion 3]
- [ ] Unit tests passing
- [ ] Documentation updated (README, inline comments)
- [ ] POSTMORTEM.md entry added
```

## POSTMORTEM.md Template (Initialized)

```markdown
# [Sprint Name] - Postmortems

This document captures learnings from each story to improve future development.

---

## Story 01: [Title]

**Status:** Not Started

**What Went Well:**
-

**What Went Poorly:**
-

**What We Learned:**
-

**Improvements for Next Time:**
-

---

## Story 02: [Title]

**Status:** Not Started

[Same structure]

---

## Sprint-Level Retrospective

*(To be filled after all stories are complete)*

### Overall What Went Well:
-

### Overall What Went Poorly:
-

### Key Learnings:
-

### Process Improvements for Next Sprint:
-
```

## Moving to Phase 5

With sprint planning complete, you have:
- Clear story breakdown with dependencies
- Individual story files ready for execution
- Initialized postmortem ready for entries

For **Phase 5: Execution**, you'll work through stories using Claude Code, updating the postmortem as each story completes.

---

**Ready to start?** Make sure you have `docs/roadmap.md` and `docs/architecture.md` loaded as context. Tell me which milestone you're planning, and we'll begin decomposition.
