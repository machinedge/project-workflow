# Research: Context Loading Optimization

**Issue:** sa-research-032
**Milestone:** M10

## Summary

Audited the "Starting a session" protocol across all 5 experts (PM, SWE, QA, DevOps, System Architect), covering both canonical role definitions and `.cursor/rules/*-os.mdc` workspace rules. Cataloged every document loaded on startup, classified each expert x document pair, and identified structural inefficiencies.

**Key finding:** The largest optimization opportunity is not in the session protocol documents — it's in the workspace rules. All 5 expert role files are `alwaysApply: true`, meaning ~280 lines of irrelevant expert definitions are injected into every session regardless of which expert is active.

## Classification Key

- **E** = Essential — expert cannot function without it
- **N** = Nice-to-have — improves quality but expert can function without it
- **U** = Unnecessary — no plausible use for this expert
- **—** = Not in current protocol (not loaded)
- **?** = Low certainty flag

## Matrix 1: Workspace Rules (Always Loaded)

Current state: 6 files, ~422 lines, all `alwaysApply: true`. Loaded on every Cursor message regardless of active expert.

| Rule File | Lines | PM | SWE | QA | DevOps | SA |
|-----------|-------|----|----|-----|--------|-----|
| `project-os.mdc` | ~70 | **E** | **E** | **E** | **E** | **E** |
| `project-manager-os.mdc` | ~73 | **E** | U | U | U | U |
| `swe-os.mdc` | ~66 | U | **E** | U | U | U |
| `qa-os.mdc` | ~70 | U | U | **E** | U | U |
| `devops-os.mdc` | ~73 | U | U | U | **E** | U |
| `system-architect-os.mdc` | ~70 | U | U | U | U | **E** |

**Impact:** For any session, 4 of 5 expert roles (~280 lines, ~66%) are unnecessary context. The canonical role files and workspace rules are identical in content (workspace rules just add YAML frontmatter), so the role definition is effectively present twice — once as an always-loaded rule, and again when the session protocol tells the agent to "read the role file."

## Matrix 2: Session Protocol Documents

Documents loaded by instruction at session start. Compared across both the role file session protocol and the `/start` skill.

| Document | PM | SWE | QA | DevOps | SA |
|----------|----|----|-----|--------|-----|
| `docs/project-brief.md` | **E** | **E** | **E** | **E** | **E** |
| `docs/roadmap.md` | **E** | — | **E** | — | N |
| `docs/architecture.md` | N | N | N | N | **E** |
| `docs/lessons-log.md` | — | **E** | — | — | N |
| `docs/env-context.md` | — | N | N | **E** | N |
| `docs/test-plan.md` | — | N | **E** | — | — |
| `docs/release-plan.md` | — | — | — | **E** | — |
| `issues/issues-list.md` | **E** | — | — | — | — |
| Task issue | **E** | **E** | **E** | **E** | **E** |
| Own handoff notes | **E** | **E** | **E?** | **E** | **E** |
| SWE handoff notes | N | — | **E** | N | N |
| All cross-expert handoffs | N | — | — | — | N |
| Pipeline status | — | — | — | **E** | — |

### Classification Rationale

**Essential for all experts:**
- `docs/project-brief.md` — Source of truth. Every expert reads this first. Contains constraints and decisions all experts must respect.
- Task issue — Defines the work to be done. Required by every `/start` skill.
- Own handoff notes — Session continuity. Without this, the expert has no memory of previous work.

**Essential for specific experts:**
- `docs/roadmap.md` — PM produces and maintains it. QA needs milestone scope for review boundaries. Other experts don't need it at startup.
- `docs/architecture.md` — SA produces and owns it. Other experts skim it for constraints, but most tasks don't touch architectural boundaries.
- `docs/lessons-log.md` — SWE is the primary beneficiary (prevents repeated mistakes during implementation). Other experts benefit less.
- `docs/env-context.md` — DevOps produces and owns it. SWE and QA may need it for environment-specific work.
- `docs/test-plan.md` — QA produces and evaluates against it. SWE consumes it when writing tests.
- `docs/release-plan.md` — DevOps produces and owns it. Other experts don't need it at startup.
- `issues/issues-list.md` — PM needs backlog awareness for planning and decomposition.
- SWE handoff notes — QA's primary input (what was built and changed). Other experts may benefit but don't need it at startup.
- Pipeline status — DevOps-specific operational check.

**Nice-to-have rationale:**
- `docs/architecture.md` for non-SA experts — Most tasks operate within established boundaries. Only needed when the task touches component boundaries or integration points. The conditional "if exists, skim" instruction is already appropriate.
- `docs/roadmap.md` for SA — Provides milestone context but most SA skills (research, review) can function without it.
- Cross-expert handoff notes for PM and SA — Useful for `/postmortem` and status assessment but unnecessary for most skills (`/add_feature`, `/interview`, `/research`).

## Inconsistencies Found

Session protocols (in role files) and `/start` skills (in skill files) diverge on what to load. These should be aligned.

| Expert | Session Protocol Says | `/start` Skill Says | Gap |
|--------|---------------------|--------------------|----|
| QA | No own handoff notes | Reads own QA handoff (step 4) | Session protocol missing step — likely a bug |
| DevOps | No SWE handoffs, no test-plan | Reads SWE handoffs (step 6) + test-plan (step 7) | Session protocol under-specified for deployment context |
| SA | Skim all cross-expert handoffs; no lessons-log or env-context | Reads lessons-log (step 3) + env-context (step 7); no cross-expert handoffs | Protocol and skill are misaligned in both directions |
| PM | Skim ALL handoff notes from all workflows (step 4) | Only reads PM handoff notes (step 5) | Protocol is over-broad; skill is correctly scoped |

## Recommendations

### Recommendation 1: Make Expert Roles Conditional (HIGH IMPACT)

**Change:** Set all 5 expert-specific workspace rules from `alwaysApply: true` to `alwaysApply: false`. Keep only `project-os.mdc` as `alwaysApply: true`.

**Mechanism:** `project-os.mdc` already instructs the agent to "read the corresponding role rules file" — this would load the right expert role on demand instead of loading all 5 every time.

**Savings:** ~280 lines per session (~66% reduction in always-loaded workspace rule context).

**Risk:** LOW. The meta-orchestrator handles routing. The role file content is loaded when the agent identifies the active expert and reads the file.

**Caveat:** Need to verify that Cursor properly handles this flow — agent reads `project-os.mdc` (always loaded), identifies the expert from the user's command, then uses Read tool to load the role file. If Cursor's conditional rules don't work this way, the role content could be loaded by each skill command's preamble instead.

**Certainty:** HIGH for the classification. MEDIUM for the implementation mechanism (needs testing).

### Recommendation 2: Remove Document Loading from Session Protocols (MEDIUM IMPACT)

**Change:** Remove the "Starting a session" document-loading instructions from role files. Let skill commands handle all context loading (they already define their own loading steps).

**Rationale:** Session protocols and `/start` skills currently duplicate and contradict each other. Skills are more carefully tuned to their specific needs. The session protocol's "Starting a session" section should focus on identity and behavioral principles, not document loading.

**Savings:** Eliminates ~5-8 lines of redundant/contradictory instructions per expert. More importantly, removes a source of confusion when the protocol says one thing and the skill says another.

**Risk:** MEDIUM. Some skills (like `/add_feature`) rely on the session protocol preamble ("First, read `docs/project-brief.md` and `docs/roadmap.md`") rather than having a dedicated Load Context phase. Those skills would need their own loading steps added before the session protocol can be stripped. An audit of all skills that lack explicit context loading would be required first.

**Certainty:** MEDIUM — the approach is sound but the implementation has a prerequisite (skill audit).

### Recommendation 3: Scope Handoff Note Loading (LOW IMPACT)

**Change:** Replace "skim all handoff notes across all workflows" (PM session protocol step 4, SA session protocol step 5) with "read most recent handoff note in own subdirectory." Cross-expert handoffs should be loaded only by skills that need them (e.g., `/postmortem`, `/regression`).

**Savings:** Variable — depends on project history. Could be significant for projects with many sessions.

**Risk:** LOW. Cross-expert handoffs are consumed by specific skills that can load them on demand.

**Certainty:** HIGH.

### Recommendation 4: Fix QA Session Protocol Gap (BUG FIX)

**Change:** Add "Read most recent handoff note in `docs/handoff-notes/qa/`" to QA's session protocol and ensure alignment with QA `/start` skill.

**Rationale:** QA's session protocol omits own handoff notes, breaking session continuity. The `/start` skill includes it (step 4), confirming this is an oversight.

**Risk:** None — this is a bug fix.

**Certainty:** HIGH.

## Implementation Priority

| # | Recommendation | Impact | Risk | Effort | Priority |
|---|---------------|--------|------|--------|----------|
| 1 | Make expert roles conditional | HIGH (~280 lines saved) | LOW | Small (change frontmatter + test) | First |
| 4 | Fix QA handoff gap | BUG FIX | None | Trivial | First |
| 3 | Scope handoff note loading | LOW (variable savings) | LOW | Small (update 2 protocols) | Second |
| 2 | Remove doc loading from protocols | MEDIUM | MEDIUM (needs skill audit) | Medium (audit + update all skills) | Third (after skill audit) |

## Out of Scope

- Modifying skill files or role files (this research produces data and recommendations only)
- Optimizing what documents are loaded _during_ skill execution (as opposed to at session startup)
- Evaluating the content efficiency of individual documents (e.g., whether `project-brief.md` could be shorter)
