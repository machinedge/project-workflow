# Handoff Note: Decide on Missing Documentation Files

**Session date:** 2026-03-12
**Issue:** pm-feature-022 — Decide on missing documentation files (overview.md, getting-started.md, workflow-anatomy.md)

## What Was Decided

**Remove all references.** Three toolkit documentation files (overview.md, getting-started.md, workflow-anatomy.md) were referenced across 7 files but never created. Investigation confirmed they are not PM-generated artifacts — they were aspirational entries in the README documentation table. Their intended content is largely covered by existing docs (README.md, architecture.md, agent-reference.md).

Decision recorded in project brief. swe-bug-019 updated with detailed per-file removal instructions, including OpenClaw runtime messages that reference getting-started.md.

## Artifacts Updated

- `issues/backlog/swe-bug-019.md` — Added PM decision section with per-file approach, expanded affected files to include OpenClaw scripts, updated acceptance criteria
- `docs/project-brief.md` — Decision recorded, status updated

## What's Next

- **swe-bug-019** is now unblocked — SWE can execute the reference removal
- **swe-bug-023** is also ready (independent)
- After those, remaining backlog: qa-feature-005 (QA consistency review)
