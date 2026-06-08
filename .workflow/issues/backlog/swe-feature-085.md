# Build "hello expert" end-to-end spike server

**Type:** feature
**Expert:** swe
**Milestone:** M1 — End-to-end "hello expert" spike
**Status:** backlog

## User Story

As a developer running the Expert MCP-Servers stack on my dev laptop, I want a single dockerized server with one tool that reads a host file, calls a local LLM, and writes a host file — callable from Claude Code — so that I can validate end-to-end that the chosen transport, filesystem mechanism, and framework actually work together before any further investment.

## Description

Implement the smallest possible expert server that exercises every load-bearing decision from M1's three research issues. One Python server, one tool (e.g., `summarize_file`), packaged in a Dockerfile, wired into `docker-compose.yml` alongside any host-filesystem bridge required, configured via a `.env` file pointing at an OpenAI-compatible local endpoint. Callable from Claude Code on the dev laptop. Lives in a new top-level directory in this repo (suggested: `mcp-servers/`).

## Acceptance Criteria

- [ ] Developer can run `docker compose up` from the repo root and the spike server is reachable
- [ ] A `.env` (or equivalent) lets the developer point the server at any OpenAI-compatible endpoint without editing code
- [ ] The server's single tool reads a file from the host project directory using the mechanism chosen in sa-research-083
- [ ] The server's single tool calls the configured local LLM and writes the result to a file in the host project directory
- [ ] Claude Code on the dev laptop can invoke the tool using the transport chosen in sa-research-082
- [ ] A README in the new directory documents how to run, configure, and tear down the spike
- [ ] No code from `.claude/skills/` is touched — this milestone does not replace any existing expert yet

## Technical Notes

**Estimated effort:** Large session
**Dependencies:** sa-research-082, sa-research-083, sa-research-084
**Inputs:** `docs/project-brief-mcp-servers.md`, `docs/roadmap-mcp-servers.md`, `docs/research-mcp-transport.md`, `docs/research-mcp-filesystem.md`, `docs/research-mcp-framework.md`
**Out of scope:** Building the M2 authoring library; replacing any existing expert; multi-tool servers; production-grade error handling; observability beyond docker logs.
