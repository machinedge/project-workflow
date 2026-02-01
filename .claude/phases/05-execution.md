# Phase 5: Execution

## Purpose
Implement stories through collaborative planning, coding, testing, and documentation. This phase runs in Claude Code (terminal) or your IDE with Claude integration.

## Input
- Individual story file from `sprints/sprint-XX/stories/`
- `docs/architecture.md` for context
- `sprints/sprint-XX/POSTMORTEM.md` for recording learnings

## Output
- Implemented, tested code
- Updated documentation
- Postmortem entry for the story

## Claude's Role

I work as your **pair programming partner**, helping with:

1. **Planning** - Understanding the story, asking clarifying questions
2. **Implementation** - Writing code, following existing patterns
3. **Testing** - Writing tests, verifying acceptance criteria
4. **Documentation** - Updating README, inline comments
5. **Postmortem** - Capturing learnings in POSTMORTEM.md

## How This Works

### Starting a Story

1. Load the story file as context (e.g., `stories/03-feature-name.md`)
2. Tell me: "Let's work on Story 03"
3. I'll review the story and ask clarifying questions **one at a time**
4. Once I understand the requirements, I'll propose an approach
5. You approve or redirect, then we implement

### During Implementation

- I'll write code incrementally, explaining as I go
- I'll ask questions when requirements are ambiguous
- I'll run tests and fix issues
- I'll follow existing patterns in the codebase

### Completing a Story

1. All acceptance criteria checked off
2. Tests passing
3. Documentation updated
4. POSTMORTEM.md entry added

## Execution Principles

### Questions First
Before writing code, I should understand:
- What problem are we solving?
- What's the expected behavior?
- What are the edge cases?
- What patterns should I follow?

If any of these are unclear, **I'll ask before implementing**.

### Incremental Progress
- Small, testable changes
- Commit logical units of work
- Verify each piece works before moving on

### Test-Driven When Appropriate
- Write tests for the expected behavior
- Implement until tests pass
- Refactor if needed

### Documentation as You Go
- Update README if user-facing changes
- Add inline comments for complex logic
- Keep architecture docs current

## Story Execution Checklist

```markdown
## Story [XX] Execution

### Planning
- [ ] Story requirements understood
- [ ] Clarifying questions answered
- [ ] Approach agreed upon

### Implementation
- [ ] Code implemented
- [ ] Existing patterns followed
- [ ] Edge cases handled

### Testing
- [ ] Unit tests written/updated
- [ ] Integration tests (if needed)
- [ ] Manual verification complete

### Documentation
- [ ] README updated (if user-facing)
- [ ] Inline comments added
- [ ] Architecture docs updated (if applicable)

### Completion
- [ ] All acceptance criteria met
- [ ] Tests passing
- [ ] POSTMORTEM.md entry added
- [ ] Code committed
```

## Postmortem Entry Format

After completing each story, add an entry to `POSTMORTEM.md`:

```markdown
## Story [XX]: [Title]

**Status:** Completed

**What Went Well:**
- [Positive outcome 1]
- [Positive outcome 2]

**What Went Poorly:**
- [Issue encountered 1]
- [Issue encountered 2]

**What We Learned:**
- [Technical learning]
- [Process learning]
- [Domain learning]

**Improvements for Next Time:**
- [Actionable improvement 1]
- [Actionable improvement 2]
```

### What to Capture

**What Went Well:**
- Patterns that worked
- Tools/libraries that helped
- Approaches that were efficient
- Documentation that was accurate

**What Went Poorly:**
- Unexpected issues
- Inaccurate story assumptions
- Technical debt encountered
- Time sinks

**What We Learned:**
- Technical discoveries
- Codebase insights
- Library/framework behaviors
- Domain knowledge gained

**Improvements for Next Time:**
- Story writing improvements
- Process changes
- Technical debt to address
- Patterns to adopt/avoid

## Handling Blockers

If you hit a blocker:

1. **Technical blocker** - Let's debug together, or note it and move to another story
2. **Requirements unclear** - We'll document the question and may need to pause
3. **Dependency not ready** - Mark story as blocked, move to independent story
4. **Scope creep** - Identify what's in scope vs. what should be a new story

## Common Commands

```bash
# Run tests
pytest tests/

# Run specific test file
pytest tests/test_feature.py

# Run with coverage
pytest --cov=src tests/

# Lint check
ruff check .

# Type check
mypy src/
```

## Moving to Phase 6

When all stories are complete (or at defined checkpoints):
- All acceptance criteria met
- Tests passing
- Documentation current
- Postmortem entries added

Move to **Phase 6: Code Review** for multi-perspective quality review.

---

**Ready to start?** Load the story file you want to work on and tell me which story we're implementing.
