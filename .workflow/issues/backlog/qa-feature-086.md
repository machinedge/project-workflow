# QA: Verify "hello expert" spike end-to-end and confirm M1 decisions hold

**Type:** feature
**Expert:** qa
**Milestone:** M1 — End-to-end "hello expert" spike
**Status:** backlog

## Description

Independently exercise the M1 spike server end-to-end on a clean checkout: clone the repo, follow the spike README, configure an OpenAI-compatible endpoint, bring the stack up, and invoke the tool from Claude Code. Confirm the three research decisions (transport, filesystem, framework) survive contact with reality. Record any friction, ambiguity, or gaps as issues for M2 to address before the authoring library is built on these decisions.

## Scope

- Run the spike from a clean clone following only the README — no insider knowledge
- Verify each acceptance criterion in `swe-feature-085`
- Note any step that required guesswork, undocumented config, or workaround
- Compare actual behavior against what the three research docs predicted

## Acceptance Criteria

- [ ] Spike runs end-to-end from a clean checkout following only the README
- [ ] Each acceptance criterion in swe-feature-085 is independently confirmed pass or fail
- [ ] Any drift between research-doc predictions and observed behavior is documented
- [ ] New issues are filed in `.workflow/issues/backlog/` for any friction worth fixing before M2 begins
- [ ] A short M1 verification report is written to the QA handoff note

## Notes

**Depends on:** swe-feature-085
**Inputs:** `mcp-servers/README.md` (or wherever the spike lands), `docs/research-mcp-transport.md`, `docs/research-mcp-filesystem.md`, `docs/research-mcp-framework.md`, `swe-feature-085.md`
