# Decide transport protocol for expert servers (MCP vs REST vs JSON-RPC)

**Type:** research
**Expert:** system-architect
**Milestone:** M1 — End-to-end "hello expert" spike
**Status:** backlog

## User Story

As a developer building the Expert MCP-Servers stack, I need a documented decision on which transport protocol the expert servers will speak so that I can build the M1 spike without revisiting this choice later.

## Description

Three candidates are on the table — Model Context Protocol (MCP), plain REST, and JSON-RPC. The project's working name says "MCP" but the choice is genuinely open. Evaluate the trade-offs for our specific shape: small Python servers running in Docker, each wrapping one or more local-LLM-driven microtasks, called from Claude Code on the dev laptop. Produce a written decision with rationale.

## Acceptance Criteria

- [ ] Each candidate (MCP, REST, JSON-RPC) is evaluated on at least: native Claude Code integration, ergonomics of authoring a new server in Python, support for streaming/long-running tool calls, ability to express server-internal multi-step pipelines, ecosystem and library maturity
- [ ] Trade-offs are summarized in a table
- [ ] A recommendation is made with explicit rationale
- [ ] Risks of the recommended choice are listed
- [ ] Decision is saved to `docs/research-mcp-transport.md`

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** None
**Inputs:** `docs/project-brief-mcp-servers.md`, `docs/roadmap-mcp-servers.md`, `.workflow/interview-notes-mcp-servers.md`
**Out of scope:** Building any prototype; framework selection (covered by sa-research-084); filesystem mechanism (covered by sa-research-083)
