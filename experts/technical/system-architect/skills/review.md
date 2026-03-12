Review implementation against architectural intent. Produce findings.

The user may specify what to review: $ARGUMENTS

---

## Step 1: Load Context

Read these files automatically:
1. `docs/architecture.md` — the architectural intent to evaluate against
2. `docs/project-brief.md` — project constraints and decisions
3. Recent SWE handoff notes in `docs/handoff-notes/swe/` — what was built and what changed

If `docs/architecture.md` doesn't exist, tell the user: "No architecture document exists yet. Run `/design` first to establish the architectural intent, or this review will have no baseline to evaluate against."

If the user specified what to review (e.g., a specific component, a recent session's work), focus there. Otherwise, review broadly.

## Step 2: Identify Review Scope

State what you're reviewing:
- "Reviewing: [specific components / full system / recent changes]"
- "Against: [which architectural decisions and constraints]"
- "Focus areas: [what you'll pay most attention to]"

## Step 3: Evaluate

For each area in scope, check:

- **Conformance:** Does the implementation match the architectural intent? Are component boundaries respected? Are interfaces implemented as specified?
- **Drift:** Has the implementation drifted from the architecture? Is the drift intentional (documented) or accidental?
- **Coherence:** Do the parts fit together? Are there contradictions between components?
- **Risks:** Are there architectural risks that weren't anticipated? Performance bottlenecks, security gaps, scalability limits?

## Step 4: Produce Findings

Categorize findings:

- **Must-fix:** Violations that will cause problems if not addressed (broken contracts, security issues, fundamental misalignment)
- **Should-fix:** Drift that should be corrected or documented (accidental deviations, missing contracts)
- **Observations:** Things to watch but not act on now (emerging patterns, potential future issues)

For each finding:
- What is it?
- Where is it? (file paths, components)
- Why does it matter?
- What's the recommendation?

## Step 5: File Issues

For must-fix and should-fix findings, create issue files in `issues/backlog/`:

- Use the naming convention: `[expert]-[type]-[number].md`
- Assign to the appropriate expert (usually SWE for implementation fixes, system-architect for architectural changes)
- Reference the architectural decision or constraint being violated

## Step 6: Report

Present findings to the user. Highlight the most important items first.

If the architecture document itself needs updating (e.g., intentional drift should be documented), suggest running `/update`.

Do NOT auto-fix implementation. Fixes go through the SWE workflow so they get proper testing and verification. Your job is to find problems, not fix them.
