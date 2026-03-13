# QA, DevOps, PM Role Session Protocol Missing `architecture.md`

**Type:** bug
**Expert:** swe
**Milestone:** M5
**Status:** backlog
**Severity:** should-fix
**Found by:** qa-feature-005

## Description

SWE `role.md` (step 7) and SA `role.md` (step 2) include `architecture.md` in their Session Protocol "Starting a session" list. QA, DevOps, and PM do not, despite all three:

- Listing `architecture.md` in their Document Locations section
- Loading it in their `/start` skills (QA step 8, DevOps step 9, PM step 6)

The Session Protocol governs context loading for **all** sessions, not just `/start`. When an expert runs a different skill (e.g., QA `/review`, DevOps `/pipeline`, PM `/decompose`), the Session Protocol is the only context-loading instruction — and `architecture.md` would be missed.

This creates an inconsistency: the `/start` skill loads architecture context, but any other skill entry point does not.

## Acceptance Criteria

- [ ] QA `role.md` Session Protocol "Starting a session" includes `architecture.md` with `(if it exists)` qualifier
- [ ] DevOps `role.md` Session Protocol "Starting a session" includes `architecture.md` with `(if it exists)` qualifier
- [ ] PM `role.md` Session Protocol "Starting a session" includes `architecture.md` with `(if it exists)` qualifier
- [ ] Placement is consistent with how SWE and SA include it (after domain-specific docs, before "Confirm understanding")

## Affected Files

- `experts/technical/qa/role.md`
- `experts/technical/devops/role.md`
- `experts/technical/project-manager/role.md`
