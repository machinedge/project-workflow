# Define Routing for Cross-Expert Skills (team- prefix)

**Type:** feature
**Expert:** sa
**Milestone:** M11
**Status:** backlog

## User Story

As a user invoking `team-status` or other future cross-expert skills, I want the agent to route correctly without requiring me to have an active expert session, so that shared skills work reliably regardless of session context.

## Description

The `team-` prefix in `project-os.mdc` doesn't map to any specific expert. Currently the routing instruction says "For `team-` prefixed skills, use the current session context," but this has gaps:
- What if no expert session is active?
- What if the `team-status` skill needs artifacts from multiple experts (e.g., all handoff notes, roadmap, issues list)?
- As more shared skills are added, does `team-` need its own lightweight role or just a routing convention?

The System Architect should decide the routing mechanism for shared/cross-expert skills and update the architecture accordingly.

## Acceptance Criteria

- [ ] Decision recorded in `docs/architecture.md` on how `team-` prefixed skills are routed
- [ ] `project-os.mdc` routing logic updated to reflect the decision
- [ ] Approach handles the case where no expert session is active
- [ ] Approach is extensible to future shared skills beyond `team-status`

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** swe-feature-035 (Cursor rules structure — defines the routing table)
**Inputs:** `targets/ide/cursor/rules/project-os.mdc`, `docs/architecture.md`
**Out of scope:** Implementing the `team-status` skill itself (separate task)
