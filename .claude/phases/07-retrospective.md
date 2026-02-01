# Phase 7: Retrospective

## Purpose
Synthesize learnings from the sprint, update planning documents, and prepare context for the next planning cycle.

## Input
- `sprints/sprint-XX/POSTMORTEM.md` (all story entries)
- `sprints/sprint-XX/CODE_REVIEW.md`
- `sprints/sprint-XX/INDEPENDENT_CODE_REVIEW.md`
- `docs/vision.md`, `docs/architecture.md`, `docs/roadmap.md`

## Output
- Updated sprint-level section in `POSTMORTEM.md`
- `sprints/sprint-XX/sprint-learnings.md` - Condensed learnings for future reference
- Updated `docs/roadmap.md` (if needed)
- Updated `docs/architecture.md` (if decisions changed)

## Claude's Role

I'll help you extract and synthesize learnings through **focused questions**:

1. **Pattern Recognition** - What themes emerge across stories?
2. **Process Evaluation** - What worked/didn't work in how we worked?
3. **Technical Insights** - What did we learn about the technology/domain?
4. **Planning Accuracy** - How well did our estimates and assumptions hold?
5. **Forward Application** - What should we do differently next sprint?

## How This Works

1. **Load sprint artifacts** as context (POSTMORTEM.md, CODE_REVIEW.md, etc.)
2. **Review questions** - I help you identify patterns and insights
3. **Complete POSTMORTEM.md** - Sprint-level retrospective section
4. **Generate sprint-learnings.md** - Condensed version for long-term reference
5. **Update planning docs** - Roadmap, architecture if needed
6. **You approve** - "ok, it looks good"

## Questions I Might Ask

### Pattern Recognition
- "Looking at the 'What Went Poorly' across stories, what themes do you see?"
- "Which 'What Went Well' items should become standard practice?"
- "Were there surprises that came up in multiple stories?"

### Process Evaluation
- "How accurate were the story complexity estimates?"
- "Did the acceptance criteria capture what was actually needed?"
- "Were there blockers that better planning could have prevented?"

### Technical Insights
- "What technical decisions would you make differently now?"
- "What did you learn about the libraries/frameworks used?"
- "Are there architecture changes suggested by what you learned?"

### Planning Accuracy
- "Did the milestone scope turn out to be right-sized?"
- "What assumptions from the roadmap proved wrong?"
- "What should we add/remove from the next milestone?"

### Forward Application
- "What's the #1 thing to do differently next sprint?"
- "Are there new risks we've identified?"
- "Should any learnings update our architecture decisions?"

## Sprint-Level Retrospective Format

Complete this section in `POSTMORTEM.md`:

```markdown
## Sprint-Level Retrospective

### Overall What Went Well
- [Pattern/practice that worked across multiple stories]
- [Tool/approach that proved valuable]
- [Process element that helped]

### Overall What Went Poorly
- [Recurring issue across stories]
- [Process problem]
- [Planning/estimation miss]

### Key Learnings

#### Technical
- [Technical insight 1]
- [Technical insight 2]

#### Process
- [Process insight 1]
- [Process insight 2]

#### Domain
- [Domain/business insight 1]

### Metrics (if tracked)
| Metric | Planned | Actual | Notes |
|--------|---------|--------|-------|
| Stories completed | X | Y | [context] |
| Estimated complexity | X | Y | [context] |

### Process Improvements for Next Sprint
1. [Specific, actionable improvement]
2. [Specific, actionable improvement]

### Technical Debt Identified
- [Debt item 1] - [priority]
- [Debt item 2] - [priority]

### Questions for Next Planning Cycle
- [Question about scope]
- [Question about approach]
```

## sprint-learnings.md Template

This is the **condensed** version that persists after the sprint is archived:

```markdown
# Sprint [XX] Learnings

**Sprint Goal:** [What this sprint achieved]
**Milestone:** [Which roadmap milestone]
**Completed:** [Date]

## Key Outcomes
- [Outcome 1]
- [Outcome 2]

## Top Learnings

### Technical
1. **[Learning title]** - [1-2 sentence explanation]
2. **[Learning title]** - [1-2 sentence explanation]

### Process
1. **[Learning title]** - [1-2 sentence explanation]

### Planning
1. **[Learning title]** - [1-2 sentence explanation]

## Patterns to Keep
- [Pattern that worked well]
- [Pattern that worked well]

## Patterns to Avoid
- [Anti-pattern identified]
- [Anti-pattern identified]

## Changes Made
- **Roadmap:** [What changed, if anything]
- **Architecture:** [What changed, if anything]
- **Process:** [What changed, if anything]

## Carry-Forward Items
- [Tech debt or issue to address in future sprint]
- [Question to resolve]
```

## Updating Planning Documents

### Roadmap Updates
Consider updating `docs/roadmap.md` if:
- Milestone scope needs adjustment
- New milestones identified
- Timeline assumptions changed
- Dependencies discovered

### Architecture Updates
Consider updating `docs/architecture.md` if:
- Key decisions changed based on learnings
- New components identified
- Integration approaches evolved
- Technical constraints discovered

### Vision Updates (Rare)
Consider updating `docs/vision.md` if:
- Success criteria need refinement
- Scope boundaries shifted significantly
- Target users or value prop clarified

## Sprint Closure

When retrospective is complete:

1. **POSTMORTEM.md** - Sprint-level section filled in
2. **sprint-learnings.md** - Created and saved
3. **Planning docs** - Updated as needed
4. **Archive decision** - Move sprint folder to `archive/` or keep for reference

### Archive Approach
```bash
# Option A: Archive full sprint
mv sprints/sprint-01 sprints/archive/sprint-01

# Option B: Keep only learnings (recommended for long-term)
mv sprints/sprint-01/sprint-learnings.md sprints/archive/
rm -rf sprints/sprint-01
```

## Starting Next Cycle

With retrospective complete, you have:
- Synthesized learnings documented
- Planning documents updated
- Clean context for next sprint

For the next sprint:
1. Open new session
2. Load: `roadmap.md`, `architecture.md`, previous `sprint-learnings.md`
3. Return to **Phase 4: Sprint Planning** for the next milestone

---

**Ready to start?** Load the sprint's POSTMORTEM.md and review artifacts as context, then tell me you're ready to begin the retrospective.
