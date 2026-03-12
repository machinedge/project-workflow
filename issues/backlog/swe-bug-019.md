# BUG: Multiple docs reference non-existent files (overview.md, getting-started.md, workflow-anatomy.md)

**Type:** bug
**Expert:** swe
**Milestone:** M7
**Status:** backlog
**Severity:** should-fix

## Description

Three documentation files are referenced across multiple locations but do not exist:
- `docs/overview.md`
- `docs/getting-started.md`
- `docs/workflow-anatomy.md`

SWE session-08 flagged this but left it as an open item. These are broken links that will confuse both users and AI agents reading the docs.

## Affected Files

| File | References |
|------|------------|
| `README.md` | `docs/overview.md`, `docs/getting-started.md`, `docs/workflow-anatomy.md` (lines 126-129) |
| `docs/agent-reference.md` | `overview.md`, `workflow-anatomy.md` (lines 13, 90, 102, 128, 130, 184) |
| `CONTRIBUTING.md` | `workflow-anatomy.md` (lines 69, 119) |
| `targets/autonomous/openclaw/README.md` | `docs/overview.md` (line 48) |

## Acceptance Criteria

- [ ] Either create the three missing docs, OR remove/replace all references to them
- [ ] No broken doc links remain in non-historical files

## Notes

**Found by:** qa-feature-017
**Decision needed:** Should these docs be created (more content to maintain) or should the references be removed/replaced with inline content? PM should decide.
