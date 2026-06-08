# Project Brief — Expert MCP Servers

## Identity
- **Project:** Expert MCP Servers (working title; transport TBD)
- **Owner:** Shyam Yadati (shyam@machinedge.io)

## Goal
Wrap each non-PM expert (SWE, QA, DevOps, System Architect) as small, locally-hosted servers so Claude Code can orchestrate milestone-level work end-to-end while pushing implementation generation onto local LLMs.

## Who It's For
Shyam and the MachinEdge team, running on dev laptops. Not packaged for external users in v1.

## Success Looks Like
- [ ] Claude Code can drive an entire milestone (SWE → QA → DevOps → SA) without per-step human prompts; humans intervene only on failure
- [ ] Heavy generative work runs on local models via OpenAI-compatible endpoints, with measurable Claude token-spend reduction (specific bar TBD)
- [ ] A reusable Python library lets a new expert server be stood up in a few lines of code
- [ ] Whole stack runs from `git clone` + `docker compose up` with minimal config
- [ ] Pre-implementation research items (transport, filesystem, framework, decomposition, state storage) resolved with documented decisions

## Constraints
- **Budget:** Not specified
- **Timeline:** Open-ended; library first, then expert servers, then orchestration
- **Tech stack:** Python (preferred). Docker + Docker Compose. OpenAI-compatible LLM endpoints, configurable per server. LangChain / LangGraph under consideration but not committed.
- **Skills:** Solo / small team; user is technically adept
- **Other:** Existing `.claude/skills/` for non-PM experts will be replaced, not run in parallel. PM expert and PM interview stay in Claude Code for v1.

## Delivery & Operations Context
- **How software reaches users:** `git clone` of the repo, then `docker compose up` on a dev laptop with light `.env` config
- **Hardware/infrastructure involved:** Dev laptop running Docker; local LLM runtimes (vLLM, Ollama, LM Studio) the user already has installed
- **Compliance/regulatory:** None identified; deferred
- **Current pain points:** Manual per-step invocation of expert skills; high Claude token cost from doing all generation in the cloud; no mechanism for regimented multi-step pipelines under the current skill model

## Key Decisions Made
| Decision | Reasoning |
|----------|-----------|
| Microtask granularity, not one-server-per-expert | Local LLMs have smaller context and weaker reasoning — fine-grained servers fit their constraints and let Claude orchestrate composition |
| Server-internal pipelines allowed | Some workflows need deterministic multi-step LLM sequencing; encoding this inside the server is cleaner than forcing the orchestrator to manage it |
| Claude Code reused as orchestrator | Avoid building a new orchestrator; keep a minimal set of skills in Claude Code as glue |
| Replace, not coexist | Skills and servers running in parallel adds confusion without value |
| Library-first sequencing | Build a Python framework that makes new servers trivial to author *before* building the four expert servers on it |
| Per-server LLM endpoint config | Different microtasks may want different models; one global endpoint is too rigid |
| Skip prior art and risk analysis | User chose iteration-via-dogfooding over upfront analysis |

## Open Decisions (Research Required Before Implementation)
- **Transport/protocol:** MCP vs REST vs JSON-RPC — project name says MCP but the choice is open
- **Filesystem context:** how Dockerized servers reliably get scoped access to the host project directory
- **Framework selection:** LangChain / LangGraph vs lighter alternatives vs hand-rolled
- **Skill decomposition strategy:** how finely to split each expert's current skills into microtask tools
- **State storage model:** SQL / graph / hybrid database for tasks and outputs vs continuing with markdown files (would shift the "documents are memory" principle)

## Open Gaps (User to Confirm Later)
- No quantitative success bar for token cost or autonomy
- Recovery semantics on mid-milestone failure undefined
- No timeline / milestone shape committed

## Current Status
**Last updated:** 2026-05-09
**Current phase:** Planning complete; ready for execution
**Last completed task:** M1 decomposed into 5 issues (sa-research-082, sa-research-083, sa-research-084, swe-feature-085, qa-feature-086)
**Next task:** sa-research-082 — decide transport protocol (start with `sa-start`)
**Blockers:** None

## Notes for AI
- This project lives in the same repo as the MachinEdge Expert Teams toolkit but is a distinct initiative. Keep its brief and roadmap separate from `docs/project-brief.md`.
- Five open research items must be resolved before serious implementation; treat them as gates, not parking-lot items.
- Stay biased toward MVP / dogfooding iteration; don't over-engineer in v1.
- Python preferred. Docker Compose preferred. OpenAI-compatible endpoint per server.
