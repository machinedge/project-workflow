# Interview Notes: Expert Skill Restructure

## What

Add a System Architect expert and standardize session skills across all experts.

### New System Architect Expert
- Project-level role (not task-level) responsible for system-wide architectural decisions
- Skills: `/design`, `/research`, `/review`, `/update`, `/start`, `/handoff`
- Owns `docs/architecture.md` — the system architecture artifact consumed by all other experts
- Distinct from domain-level architecture that each expert handles within their own `/start`

### PM Gets `/start`
- PM currently has no way to execute PM-scoped issues (research synthesis, decision-making tasks)
- `/pm-start` allows the PM to pick up and execute issues created by `/decompose` or other experts

### Every Expert Gets `/start` and `/handoff`
- Consistent pattern: each expert can pick up a task from the issue system and close out with handoff notes
- QA and DevOps get `/start` and `/handoff` alongside their existing domain-specific skills

### SWE `/start` Updated (Not Replaced)
- Current 7-phase flow is preserved (plan, architect, test, implement, verify, review)
- Updated to consume `architecture.md` as required context
- System-level architecture decisions removed from SWE scope — SWE handles domain-level only
- Checkpoints (wait for user approval) enforced harder

### Role File Updates
- Every expert's role file updated to consume `architecture.md`
- Every expert explicitly instructed to escalate to PM or System Architect when hitting decisions outside their scope (not make assumptions)

## Why

- On large/ambiguous tasks, the SWE agent makes assumptions and proceeds without consulting the user or other experts, causing rework
- The monolithic `/swe-start` has approval checkpoints in theory, but the agent blows through them because it's all one command
- No mechanism exists for system-level architecture to inform domain-level work
- PM has no `/start` command, so PM-scoped issues (like synthesizing research) have no structured execution path

## Scope

### In Scope
- New System Architect expert (role.md, 6 skills, tools directory)
- `docs/architecture.md` defined as artifact in docs-protocol, owned by System Architect
- `/start` and `/handoff` for PM, QA, DevOps
- SWE `/start` updated to consume architecture.md and enforce checkpoints
- Role files updated for all experts (architecture.md consumption, escalation behavior)
- docs-protocol updated for new artifacts and cross-expert contracts

### Out of Scope
- Data Analyst and User Experience experts (still under development)
- Framework tooling (scaffold, validate, install)
- Platform translation layer
- Existing PM skills (interview, vision, roadmap, decompose, etc.) — unchanged
- Existing QA skills (review, test-plan, regression, bug-triage) — unchanged
- Existing DevOps skills (env-discovery, pipeline, release-plan, deploy) — unchanged

## Success Criteria

1. System Architect expert exists with role.md, all 6 skills, and tools directory — passes `validate.sh`
2. `docs/architecture.md` defined in docs-protocol, owned by System Architect, consumed by other experts
3. Every expert (PM, SWE, QA, DevOps) has `/start` and `/handoff`
4. SWE `/start` updated to consume architecture.md and scope down to domain-level architecture
5. Role files and docs-protocol updated to reflect new skills, artifacts, and escalation behavior
6. Existing skills not broken by the changes
7. Backward compatible with existing projects

## Risks

1. **Skill content quality** — First drafts need iteration. Mitigated: fleshing out fully for a working baseline.
2. **System vs. domain architecture confusion** — Mitigated: no separate `/architect` for other experts; clear boundary in role files.
3. **Backward compatibility** — Mitigated: SWE `/start` updated, not replaced; flow preserved.
4. **Architect as bottleneck** — Mitigated: experts escalate on out-of-scope decisions, not pre-approval for everything.

## Open Questions

- None identified during interview.

## Next Step

Run `/pm-update-plan` to integrate this into the project brief and roadmap.
