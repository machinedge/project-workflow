Evolve the architecture based on new requirements, implementation feedback, or changed constraints. Updates `docs/architecture.md`.

The user may specify what changed: $ARGUMENTS

---

## Step 1: Load Context

Read these files automatically:
1. `docs/architecture.md` — the current architecture
2. `docs/project-brief.md` — current project context and constraints
3. `docs/roadmap.md` (if it exists) — upcoming work that the architecture should support
4. Recent handoff notes across all experts — what happened since the architecture was last updated

If `docs/architecture.md` doesn't exist, tell the user: "No architecture document exists yet. Run `/design` to create one, or `/start` to pick up an architect-scoped issue."

## Step 2: Identify What Changed

Determine the driver for this update:

- **New requirements:** A new feature or milestone that the current architecture doesn't address
- **Implementation feedback:** SWE discovered that the architecture doesn't work as designed
- **Changed constraints:** Environment, technology, or business constraints shifted
- **Review findings:** An architectural review identified drift or issues
- **User request:** The user wants to change a specific decision

State clearly:
- "Update driver: [what changed]"
- "Affected areas: [which components, interfaces, or decisions]"
- "Current state: [what the architecture says now]"

Wait for user confirmation before proceeding.

## Step 3: Propose Changes

For each change:

- What specifically changes in `docs/architecture.md`?
- Why? (Link back to the driver from Step 2)
- What are the consequences? (Other components affected, migration needed, etc.)
- Does this invalidate any existing Architecture Decision Records? If so, document the superseding decision.

Present changes as a clear before/after. Don't just describe — show.

## Step 4: Check Coherence

Before applying changes, verify:

- Do the proposed changes conflict with any existing architectural decisions?
- Are there cascading effects on other components?
- Do downstream experts (SWE, QA, DevOps) need to know about these changes?
- Are there open issues that this update affects?

Flag any conflicts or cascading effects for the user.

## Step 5: Apply Changes

After user approval:

1. Update `docs/architecture.md` with the approved changes
2. Add new ADRs for any new decisions; mark superseded ADRs as "Superseded by ADR-XXX"
3. Update the document's revision history or date

If downstream experts need to be informed, note this for the handoff.
