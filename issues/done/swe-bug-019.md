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

## PM Decision (pm-feature-022)

**Remove all references.** These are aspirational toolkit documentation that was never authored. They are not PM-generated artifacts (PM produces project-brief, roadmap, interview-notes, issues). The content they were meant to cover is largely redundant with existing docs (README.md covers vision/setup, architecture.md covers system design, agent-reference.md covers contributor guidance).

If richer toolkit documentation is needed later, scope it as a new milestone task with proper acceptance criteria.

### Approach for each file

**`README.md`** (lines 126-129): Remove the Documentation table rows for overview.md, getting-started.md, and workflow-anatomy.md. Keep the agent-reference.md and docs-protocol rows.

**`docs/agent-reference.md`** (lines 13, 90, 102, 128, 130, 184): Remove or rewrite sentences that link to overview.md or workflow-anatomy.md. Where the link provides context the reader needs, replace with inline content or a reference to an existing doc.

**`CONTRIBUTING.md`** (lines 69, 119): Remove or rewrite sentences linking to workflow-anatomy.md. Replace with inline guidance or remove if the surrounding text is self-sufficient.

**`targets/autonomous/openclaw/README.md`** (line 48): Remove the reference to `docs/overview.md`. Replace with a reference to README.md if context is needed.

**`targets/autonomous/openclaw/install-team.sh`** (line 488), **`install-team.ps1`** (line 418), **`env.template`** (lines 23, 33): These print user-facing runtime messages referencing `docs/getting-started.md`. Redirect to `targets/autonomous/openclaw/README.md` or replace with inline guidance in the env.template comments.

## Affected Files

| File | References |
|------|------------|
| `README.md` | `docs/overview.md`, `docs/getting-started.md`, `docs/workflow-anatomy.md` (lines 126-129) |
| `docs/agent-reference.md` | `overview.md`, `workflow-anatomy.md` (lines 13, 90, 102, 128, 130, 184) |
| `CONTRIBUTING.md` | `workflow-anatomy.md` (lines 69, 119) |
| `targets/autonomous/openclaw/README.md` | `docs/overview.md` (line 48) |
| `targets/autonomous/openclaw/install-team.sh` | `docs/getting-started.md` (line 488) |
| `targets/autonomous/openclaw/install-team.ps1` | `docs/getting-started.md` (line 418) |
| `targets/autonomous/openclaw/templates/env.template` | `docs/getting-started.md` (lines 23, 33) |

## Acceptance Criteria

- [ ] All references to `docs/overview.md`, `docs/getting-started.md`, and `docs/workflow-anatomy.md` removed or replaced in non-historical files
- [ ] No broken doc links remain
- [ ] Runtime messages in OpenClaw scripts redirected to existing docs or replaced with inline guidance

## Notes

**Found by:** qa-feature-017
**Unblocked by:** pm-feature-022
