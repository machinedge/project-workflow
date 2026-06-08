# Decide framework for the expert-server Python authoring library

**Type:** research
**Expert:** system-architect
**Milestone:** M1 — End-to-end "hello expert" spike
**Status:** backlog

## User Story

As a developer building expert servers on this stack, I need a framework foundation that lets me author a new server (with internal multi-step LLM pipelines) in a few lines of Python, so that adding new microtasks does not become a chore that bleeds project velocity.

## Description

The brief mentions LangChain and LangGraph as candidates, but the choice is open. Evaluate framework options for the M2 authoring library against our actual needs: server-internal deterministic multi-step pipelines, OpenAI-compatible endpoint per server, fine-grained microtask granularity, dogfooding-driven iteration. Decide whether to adopt a framework, build hand-rolled, or layer something thin on top of the official transport SDK chosen in sa-research-082.

## Acceptance Criteria

- [ ] At least three framework options are evaluated (e.g., LangChain, LangGraph, Pydantic AI, raw transport SDK + glue)
- [ ] Each is judged on: ergonomics for short servers, support for deterministic multi-step pipelines, OpenAI-compatible endpoint flexibility, dependency weight, lock-in risk
- [ ] A recommendation is made with explicit rationale
- [ ] If the recommendation is "no framework," the gap (what the library will provide) is named
- [ ] Decision is saved to `docs/research-mcp-framework.md`

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-research-082 (transport choice may constrain framework)
**Inputs:** `docs/project-brief-mcp-servers.md`, `docs/roadmap-mcp-servers.md`, `docs/research-mcp-transport.md` (once produced)
**Out of scope:** Building the library — that happens in M2. Filesystem mechanism (sa-research-083). Skill-decomposition strategy (deferred to M2).
