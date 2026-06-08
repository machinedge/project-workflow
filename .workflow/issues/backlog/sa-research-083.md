# Decide filesystem-context mechanism for Dockerized expert servers

**Type:** research
**Expert:** system-architect
**Milestone:** M1 — End-to-end "hello expert" spike
**Status:** backlog

## User Story

As a developer running the Expert MCP-Servers stack, I need a reliable, low-friction way for servers running inside Docker to read and write files in whatever host project directory I'm currently working in, so that the stack is genuinely useful across multiple projects without per-project setup pain.

## Description

The expert servers operate on the project's `docs/`, `.workflow/`, and source files. Running them in Docker means we have to bridge the host filesystem into containers in a way that (a) follows the user's current working directory, (b) does not require fragile config edits per project, (c) handles permissions reasonably on macOS, and (d) does not prevent the spike from being demoable in M1. Evaluate options (bind mounts via env var, host filesystem MCP server, sidecar agent on host, etc.) and produce a decision.

## Acceptance Criteria

- [ ] At least three candidate mechanisms are described with concrete examples (Compose YAML / runtime invocation)
- [ ] Each is evaluated on: friction to switch projects, permission/UID handling on macOS, security surface, demo viability for M1
- [ ] A recommendation is made with explicit rationale
- [ ] Known risks of the recommended approach are documented
- [ ] Decision is saved to `docs/research-mcp-filesystem.md`

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** None
**Inputs:** `docs/project-brief-mcp-servers.md`, `docs/roadmap-mcp-servers.md`, `.workflow/interview-notes-mcp-servers.md`
**Out of scope:** Implementing the mechanism — that happens in swe-feature-085. Transport choice (sa-research-082) and framework choice (sa-research-084).
