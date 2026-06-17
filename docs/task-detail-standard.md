# Task-Detail Standard (Implementation-Ready Tasks)

This is the contract for a task issue that a **small language model can implement** — write the
code and the tests — with no further reasoning, design, or cross-file investigation. It is the
output standard for the milestone workflow's *Compile* phase and the bar the completeness
verifier enforces.

A normal `pm-decompose` task ("≤1 session, acceptance criteria, reference file paths") is *not*
implementation-ready. The difference is that an implementation-ready task **inlines every
decision** a larger model would otherwise make: exact files, exact signatures, exact test cases,
and the security/architecture constraints pulled from the expert enrichment phase. The
implementer should never have to infer intent, choose an interface, or hunt the codebase for a
convention.

## When it applies

- **Implementation-ready** tasks are produced when `pm-decompose` runs inside the milestone
  workflow (`team-milestone`), where SA, Security, QA, and DevOps have already enriched the
  milestone. Their outputs are inlined into each task.
- Outside the workflow, `pm-decompose` produces normal session-sized tasks. The two modes share
  the same issue location and naming; only the detail bar differs.

## The standard — every implementation-ready SWE task MUST carry

1. **Intent** — a specific user story (persona, need, value), not a generic one.
2. **Files to create or modify** — exact paths, the action (create/modify/delete), and what
   changes in each. No "somewhere in the auth module."
3. **Interfaces and data models** — the exact signatures, types, schemas, and contracts the code
   must expose and consume. Concrete enough to type out verbatim.
4. **Implementation outline** — an ordered step list the implementer follows. Names the existing
   functions/utilities to reuse (with paths) so the model doesn't reinvent them.
5. **Acceptance criteria** — independently verifiable, from the persona's perspective.
6. **Test specification** — the test file path(s) and a table of explicit cases: input →
   expected output (including error/edge cases). Each row maps to one test to write.
7. **Security constraints** — the applicable `SR-NNN` controls from `docs/security-requirements.md`,
   stated as what this task must enforce.
8. **Architecture contracts** — the boundaries/interfaces from `docs/architecture.md` this task
   must honor (what it may and may not depend on).
9. **Build / CI notes** — anything from the pipeline the task must satisfy (where tests run, lint
   gates, generated artifacts).
10. **Dependencies and order** — issue filenames that must complete first; out-of-scope list to
    prevent creep.

## Implementation-ready SWE task template

```markdown
# [Short descriptive title]

**Type:** feature
**Expert:** swe
**Milestone:** [Milestone name]
**Status:** backlog
**Session:**
**Detail level:** implementation-ready

## User Story
As a [specific persona], I [need | want] [capability] so that I can [value].

## Description
[2-3 sentences: what to build and why.]

## Files to Create or Modify
| Path | Action | What changes |
|------|--------|--------------|
| `src/...` | create | [purpose] |
| `src/...` | modify | [the specific change] |

## Interfaces and Data Models
[Exact signatures / types / schemas the implementation must expose and consume.]
```[lang]
// function/class signatures, type definitions, request/response schemas
```

## Implementation Outline
1. [Step — name existing utilities to reuse, with paths]
2. [Step]

## Acceptance Criteria
- [ ] [Verifiable, from the persona's perspective]

## Test Specification
**Test file(s):** `tests/...`
| Case | Input | Expected result |
|------|-------|-----------------|
| [happy path] | [input] | [output] |
| [edge/error] | [input] | [output] |

## Security Constraints
- [SR-NNN] [what this task must enforce] — from `docs/security-requirements.md`

## Architecture Contracts
- [Boundary/interface this task must honor] — from `docs/architecture.md`

## Build / CI Notes
- [Where tests run / lint gates / generated artifacts] — from the pipeline

## Technical Notes
**Estimated effort:** [Small / Medium session]
**Dependencies:** [issue filenames that must complete first]
**Out of scope:** [what NOT to do]
```

QA-specific and DevOps-specific tasks keep their existing `pm-decompose` templates — their
"implementation" is test code and pipeline config, and the relevant detail (test cases, pipeline
stages) already lives in the test plan and pipeline definition produced during enrichment.

## Completeness checklist (what the verifier checks)

A task **fails** the bar and loops back for enrichment if any of these is true:

- [ ] A referenced file path is vague ("the handler", "the config") rather than an exact path.
- [ ] An interface/type/schema the code must implement is described in prose but not specified.
- [ ] The test specification is missing, or has no explicit input→output cases (just "test it").
- [ ] A security requirement that applies to this surface (authz, input validation, secrets) is
      not reflected, when `docs/security-requirements.md` has a matching `SR-NNN`.
- [ ] An acceptance criterion is not verifiable ("works correctly", "is robust").
- [ ] The task plausibly needs a design decision the implementer would have to invent.

The verifier's job is to be the skeptical small model: "Could I implement this and its tests
without asking a single question or making a single design choice?" If not, name the gap.
