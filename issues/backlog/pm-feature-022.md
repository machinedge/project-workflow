# PM: Decide on missing documentation files (overview.md, getting-started.md, workflow-anatomy.md)

**Type:** feature
**Expert:** pm
**Milestone:** M7
**Status:** backlog

## Description

Three documentation files are referenced across README.md, agent-reference.md, CONTRIBUTING.md, and openclaw README.md but do not exist:

- `docs/overview.md` — Vision, architecture, design philosophy, platform comparisons
- `docs/getting-started.md` — Setup for standalone and team modes
- `docs/workflow-anatomy.md` — Deep-dive on expert structure, skill patterns, translation layer

A PM decision is needed: should these docs be created (more content to maintain, but fills real gaps in user/contributor documentation), or should the references be removed/replaced with inline content?

## Context

- These files were never created — they appear to be aspirational references added when README.md and agent-reference.md were first written.
- SWE session-08 flagged this as an open item but left it unresolved.
- QA session-01 filed swe-bug-019 for the broken links, noting it's blocked on this PM decision.
- The references span 4 files and 10+ locations — this isn't a quick find-and-delete.

## Options

1. **Create the docs** — Fills a real gap in user/contributor documentation. More content to maintain. Could be scoped as a future milestone task.
2. **Remove all references** — Eliminates broken links immediately. Loses the navigational structure they were meant to provide.
3. **Create minimal stubs** — Placeholder files with a "coming soon" note. Unblocks the broken links without committing to full content. Risk of permanent stubs.

## Acceptance Criteria

- [ ] Decision made and recorded in project brief
- [ ] swe-bug-019 updated with the chosen approach so SWE can execute

## Notes

**Blocks:** swe-bug-019
**Found by:** qa-feature-017
