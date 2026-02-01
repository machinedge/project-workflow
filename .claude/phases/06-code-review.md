# Phase 6: Code Review

## Purpose
Conduct thorough code review using multiple AI models to catch issues, identify improvements, and validate architecture decisions before release.

## Input
- Completed code from Phase 5
- `docs/architecture.md` for context
- `sprints/sprint-XX/STORIES_INDEX.md` for scope context

## Output
- `sprints/sprint-XX/CODE_REVIEW.md` - Multi-model review results
- `sprints/sprint-XX/INDEPENDENT_CODE_REVIEW.md` - Skeptical synthesis review

## Review Approach

### Multi-Model Review
Run the same review prompt through multiple AI models to get diverse perspectives:
- Different models catch different issues
- Consensus across models indicates real problems
- Disagreement highlights areas needing human judgment

### Independent Skeptical Review
After collecting multi-model reviews, run a final "independent review" that:
- Scrutinizes the other reviews for accuracy
- Identifies hallucinations or overstatements
- Provides a balanced final assessment
- Calls out what other reviews missed

## Review Process

### Step 1: Prepare Review Context

Gather the key files/modules to review. For a typical backend:
```
- src/api/          (API layer)
- src/modules/      (business logic)
- src/shared/       (infrastructure)
- tests/            (test coverage)
- README.md         (documentation)
```

### Step 2: Multi-Model Reviews

Run this prompt (or similar) through each model:

```markdown
# Architecture Review Request

Please review the following codebase for:

1. **Architecture Quality**
   - Module boundaries and separation of concerns
   - Dependency management
   - Scalability considerations

2. **Code Quality**
   - Error handling patterns
   - Type safety
   - Code organization

3. **Security**
   - Authentication/authorization
   - Input validation
   - Secrets management

4. **Testability**
   - Test coverage approach
   - Mocking strategy
   - Test isolation

5. **Production Readiness**
   - Observability (logging, metrics)
   - Configuration management
   - Error recovery

For each area:
- What's done well?
- What needs improvement?
- Priority recommendations (P0/P1/P2/P3)

Provide an overall score (1-10) with justification.

[ATTACH: relevant code files]
```

### Step 3: Collect Results

Save each model's review in CODE_REVIEW.md:

```markdown
# Code Review Notes

## [Model 1 Name]

[Full review output]

---

## [Model 2 Name]

[Full review output]

---

## [Model 3 Name]

[Full review output]
```

### Step 4: Independent Review

Run this prompt through a capable model (ideally different from above):

```markdown
# Independent Code Review Request

You are conducting an independent review of this codebase. You have access to:
1. The actual code
2. Reviews from other AI models (attached)

Your job is to:

1. **Verify the other reviews** - Are their claims accurate? Check specific line references.

2. **Identify overstatements** - Where are the reviews being too generous or too harsh?

3. **Find what they missed** - What issues did no review catch?

4. **Assess hallucinations** - Did any review make claims not supported by the code?

5. **Provide your own assessment** - Score each dimension independently.

Be skeptical. Verify claims against actual code. Call out disagreements explicitly.

Format:
- What Is Done Well (verified)
- Critical Issues (verified, with severity)
- Issues Other Reviews Missed
- Claims I Dispute (with evidence)
- My Overall Assessment

[ATTACH: code files + CODE_REVIEW.md]
```

### Step 5: Save Independent Review

Save to `INDEPENDENT_CODE_REVIEW.md`

## CODE_REVIEW.md Template

```markdown
# Code Review Notes

## Review Context
- **Sprint:** [Sprint name/number]
- **Scope:** [What was reviewed]
- **Date:** [Review date]
- **Models Used:** [List of models]

---

## [Model 1 Name]

### Summary
[Model's executive summary]

### What's Done Well
[Model's positive findings]

### Areas for Improvement
[Model's concerns]

### Priority Recommendations
- **P0:** [Critical]
- **P1:** [High]
- **P2:** [Medium]
- **P3:** [Low]

### Overall Score: [X/10]

---

## [Model 2 Name]

[Same structure]

---

## [Model 3 Name]

[Same structure]

---

## Cross-Model Comparison

### Consensus Issues (Multiple models flagged)
| Issue | Models | Severity |
|-------|--------|----------|
| [Issue] | [Which models] | [H/M/L] |

### Divergent Opinions
| Topic | Model A Says | Model B Says |
|-------|--------------|--------------|
| [Topic] | [Opinion] | [Opinion] |
```

## INDEPENDENT_CODE_REVIEW.md Template

```markdown
# Independent Code Review: [Project Name]

**Reviewer:** [Model used]
**Date:** [Date]
**Scope:** Full review with skeptical evaluation of existing CODE_REVIEW.md

---

## Executive Summary

[2-3 paragraph honest assessment comparing this review to others]

**My Overall Score: [X/10]** (vs other reviews ranging [X-Y])

---

## What Is Done Well

### [Area 1] (Agree/Disagree with existing reviews)
[Verified positive findings with specific code references]

---

## Critical Issues (The Existing Reviews Understate/Overstate These)

### [Issue 1] (HIGH/MEDIUM/LOW SEVERITY)
[Detailed explanation with code references]

**Impact:** [What could go wrong]
**Required Fix:** [What needs to happen]

---

## Issues the Existing Reviews Miss Entirely

### [Missed Issue 1]
[Description with code evidence]

---

## Claims in Existing Reviews I Dispute

### [Model X]'s "[Claim]" Is [Too High/Too Low/Inaccurate]
[Evidence-based rebuttal]

---

## Security Assessment

| Area | Status | Notes |
|------|--------|-------|
| [Area] | [Good/Partial/Missing] | [Details] |

---

## Recommended Priority Fixes

### P0 - Production Blockers
1. [Fix with rationale]

### P1 - High Priority
1. [Fix with rationale]

### P2 - Medium Priority
1. [Fix with rationale]

---

## Summary Scorecard

| Dimension | Score | Notes |
|-----------|-------|-------|
| Code Quality | [X/10] | [Brief note] |
| Maintainability | [X/10] | [Brief note] |
| Scalability | [X/10] | [Brief note] |
| Security | [X/10] | [Brief note] |
| Testability | [X/10] | [Brief note] |

**Overall: [X/10]** - [One sentence summary]

---

## Conclusion

[Final honest assessment of production readiness]
```

## Acting on Reviews

### Before Closing Sprint
1. Address all P0 (production blocker) issues
2. Create stories for P1 issues (next sprint or tech debt backlog)
3. Document P2/P3 for future consideration

### Updating Postmortem
Add review findings to sprint retrospective:
- What the reviews caught that we missed during development
- Patterns to adopt based on "what's done well"
- Process changes to prevent recurring issues

## Moving to Phase 7

With code review complete:
- Critical issues addressed
- Improvement backlog captured
- Quality assessment documented

Move to **Phase 7: Retrospective** to synthesize learnings and update planning docs.

---

**Ready to start?** Gather the code files to review and tell me which models you want to use for the multi-model review.
