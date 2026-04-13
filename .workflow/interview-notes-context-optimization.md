# Interview Notes — Context Optimization Implementation

**Source:** Research document `docs/research-context-optimization.md` (sa-research-032, M10)

## What

Implement the 4 context optimization recommendations from the M10 research:

1. **Make expert roles conditional (HIGH IMPACT)** — Change 5 expert-specific workspace rules from `alwaysApply: true` to `alwaysApply: false`. Keep only `project-os.mdc` as always-apply. Saves ~280 lines (~66%) of unnecessary context per session.

2. **Remove document loading from session protocols (MEDIUM IMPACT)** — Strip "Starting a session" document-loading instructions from role files. Let skill commands handle all context loading. Requires a skill audit first to identify skills that lack their own loading steps.

3. **Scope handoff note loading (LOW IMPACT)** — Replace "skim all handoff notes across all workflows" in PM and SA session protocols with "read most recent handoff note in own subdirectory." Cross-expert handoffs loaded only by skills that need them.

4. **Fix QA session protocol gap (BUG FIX)** — Add "Read most recent handoff note in `docs/handoff-notes/qa/`" to QA's session protocol. Currently missing, breaking session continuity.

## Why

Excessive startup context wastes tokens, consumes context window, and may degrade output quality. Research confirmed ~66% of always-loaded workspace rule content is unnecessary in any given session. Session protocols and `/start` skills also duplicate and contradict each other on what to load.

## Scope

**In:**
- All 4 recommendations from the research
- Skill audit (prerequisite for Recommendation 2)
- Changes to `.cursor/rules/*-os.mdc` workspace rules
- Changes to canonical role files and session protocols
- Verification that Cursor handles conditional loading correctly

**Out:**
- Modifying what documents are loaded during skill execution (only startup context)
- Evaluating individual document content efficiency (e.g., shortening `project-brief.md`)
- Changes to skill files beyond adding missing context-loading steps (found during audit)

## Success Criteria

- Expert sessions load only the workspace rule relevant to the active expert (not all 5)
- QA session protocol includes own handoff note loading (matches `/start` skill)
- PM and SA session protocols don't load cross-expert handoffs at startup
- No expert loses access to context it actually needs
- Skills that previously relied on session protocol for context loading have their own loading steps

## Risks

- **Cursor conditional loading mechanism (MEDIUM):** Need to verify that Cursor properly handles the flow: agent reads `project-os.mdc` (always loaded) → identifies expert from user command → reads role file via Read tool. If this doesn't work, role content could be loaded by skill command preambles instead.
- **Rec 2 prerequisite dependency:** Removing doc loading from session protocols before auditing skills could break skills that depend on the session protocol for context. Skill audit must happen first.
- **False negative in classification:** Research may have classified a document as unnecessary for an expert when it's actually needed in edge cases. Research erred conservative to mitigate this.

## Implementation Priority

| # | Recommendation | Impact | Risk | Effort | Priority |
|---|---------------|--------|------|--------|----------|
| 1 | Make expert roles conditional | HIGH | LOW | Small | First |
| 4 | Fix QA handoff gap | BUG FIX | None | Trivial | First |
| 3 | Scope handoff note loading | LOW | LOW | Small | Second |
| 2 | Remove doc loading from protocols | MEDIUM | MEDIUM | Medium (audit + updates) | Third |

## Next Step

Run `/pm-update-plan` to integrate into project brief and roadmap.
