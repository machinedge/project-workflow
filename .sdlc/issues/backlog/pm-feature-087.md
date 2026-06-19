# FEATURE: Enable readers to dig deeper than the user-facing documentation

**Type:** feature
**Expert:** pm
**Status:** backlog
**Severity:** should-fix

## Description

Once [SDLC Boundary] (M19) moves expert-authored specs out of `docs/` and into `.sdlc/`, a curious reader of the user-facing guides has no signposted path into the underlying reasoning (architecture decisions, security requirements, UX guidelines, etc.). The guides answer "how do I use/deploy/maintain this," but a reader with a deeper "why" question is stranded — the specs that hold the answer now live in a directory framed as internal working state.

Scope a discoverability/drill-down mechanism so moving the specs to `.sdlc/` does not cut readers off from the depth they sometimes need.

Open questions to explore (not yet decided):
- Should the guides link directly into `.sdlc/` artifacts, or is `.sdlc/` meant to stay internal?
- Is the right answer a curated "deeper reading" index in `docs/`, generated/maintained by the Technical Writer, that points at the relevant `.sdlc/` artifacts?
- Or should the Technical Writer surface a "background / rationale" appendix per guide, synthesized from the specs rather than linking raw?

## Acceptance Criteria

- [ ] A reader of the user-facing docs has a clear, supported path to the deeper "why" behind a topic
- [ ] The mechanism respects the M19 boundary (does not re-pollute `docs/` with raw specs)
- [ ] The Technical Writer role owns whatever surface this produces

## Notes

**Origin:** Captured during the [SDLC Boundary] feature interview (`.sdlc/interview-notes-sdlc-boundary.md`) as an explicit follow-up the user wanted logged. Deliberately **out of scope** for M19 — that milestone only relocates artifacts and repoints references.
**Depends on:** M19 (the boundary must exist before the drill-down path is meaningful).
