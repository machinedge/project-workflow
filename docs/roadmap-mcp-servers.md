# Project Plan — Expert MCP Servers

## Milestones
| # | Milestone | Status | Depends On | Risks / Unknowns |
|---|-----------|--------|------------|-------------------|
| M1 | **End-to-end "hello expert" spike.** A single dockerized server exposes one tool that (a) calls a local LLM via OpenAI-compatible endpoint, (b) reads and writes a file in the host project directory, and (c) is callable from Claude Code on the dev laptop. Forces resolution of all five open research questions through working software. | Not started | — | Transport choice (MCP vs REST vs JSON-RPC) may need re-do mid-spike; Docker → host filesystem context mechanism unproven; framework choice may not survive contact with reality |
| M2 | **Python authoring library v0.1.** Library that abstracts M1's decisions so a new expert server can be authored in <50 lines and dropped into Docker Compose. State storage model (markdown vs SQL/graph) is decided and implemented here. | Not started | M1 | Library API may over- or under-fit the four real expert servers (M3–M5); state storage decision affects every downstream milestone if revisited |
| M3 | **SWE expert servers.** Decompose SWE skills (`swe-start`, `swe-handoff`) into microtask servers on the M2 library. Demo: Claude Code drives a single SWE issue end-to-end on local LLM. | Not started | M2 | Local model code-generation quality may not clear the bar; rework cost could erase token savings; needs QA review of the demo issue (cross-workflow) |
| M4 | **QA expert servers.** `qa-review`, `qa-test-plan`, `qa-regression` as microtask servers. Demo: QA review on M3's SWE-completed work runs locally and produces issue files. | Not started | M2 (parallel with M3) | Reviewing local-LLM-generated code may need different prompting than reviewing human/Claude code; needs a real SWE issue to review (depends on M3 demo artifact) |
| M5 | **DevOps + System Architect expert servers.** `ops-pipeline`, `ops-deploy`, `sa-design`, `sa-review`, `sa-update` as microtask servers. Demo: SA review on a milestone runs end-to-end locally. | Not started | M2 (parallel with M3, M4) | DevOps server needs to invoke real shell commands inside Docker — security and host-access surface area; SA `sa-update` writes architecture docs which may need higher-quality model than other tools |
| M6 | **Full milestone autonomy.** Claude Code orchestrates SWE → QA → DevOps → SA servers through a real milestone with no per-step human prompts. Recovery semantics on failure are defined and demoed. Stretch: the *next* MCP-Servers milestone after M6 ships through the system itself. | Not started | M3, M4, M5 | Orchestration brittleness across many small servers; failure recovery design is currently undefined; quantitative success bar (token cost, autonomy %) still TBD; needs DevOps work for the orchestrator runtime config |

## Dependency Map

```
M1 (research-via-spike)
   │
   ▼
M2 (authoring library)
   │
   ├──► M3 (SWE)  ─┐
   ├──► M4 (QA)   ─┤
   └──► M5 (Ops+SA)─┤
                   ▼
                  M6 (full milestone autonomy)
```

M3, M4, M5 can run in parallel after M2 lands. M6 is gated on all three.

## Risk Register
| Risk | Likelihood | Impact | Mitigation | Status |
|------|-----------|--------|------------|--------|
| Local model output quality too poor for production-grade code/review | High | High | Server-internal multi-step pipelines; per-server model config so stronger models can be used where it matters; dogfood early via M3 demo | Open |
| Docker → host filesystem context mechanism is clunky and degrades dev experience | Medium | High | Resolve in M1 spike with working code, not just docs; reject clunky options early | Open |
| Transport decision (MCP vs REST vs JSON-RPC) revisited after library is built | Medium | High | Force the decision in M1 with a runnable end-to-end demo before M2 | Open |
| State storage decision (markdown vs DB) revisited after migrations | Medium | Medium | Decide in M2 design, not later; implement once and stick | Open |
| Orchestration across many tiny servers is brittle; many places to fail | High | Medium | Define recovery semantics in M6 explicitly; budget for retry/resume | Open |
| Library API does not fit the real expert servers, requiring v0.2 mid-project | Medium | Medium | Build M3 first, in parallel with library hardening; let real usage shape the API | Open |
| Scope creep — temptation to also migrate PM expert | Medium | Low | Brief explicitly defers PM migration; reject in scoping | Open |

## Change Log
| What Changed | Why |
|-------------|-----|
| Initial roadmap | Project planning |
| M1 decomposed into 5 issues: sa-research-082, sa-research-083, sa-research-084, swe-feature-085, qa-feature-086 | Ready for execution |
