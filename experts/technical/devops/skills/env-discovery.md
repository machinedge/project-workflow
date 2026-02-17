Structured interview to capture the deployment and test environment context. This is the DevOps equivalent of PM's `/interview` — extractive, not prescriptive.

If the user provided context: $ARGUMENTS

---

## Step 1: Load Existing Context

Read `docs/project-brief.md`, specifically the "Delivery & Operations Context" section that PM captured during the initial interview. Use this as your starting point — don't re-ask questions that were already answered.

If `docs/project-brief.md` doesn't exist, tell the user: "No project brief found. Run `/interview` and `/vision` first so I have project context to build on."

Also read `docs/env-context.md` if it exists — this may be an update to an existing environment context, not a first-time capture.

## Step 2: Interview

Using the project brief's delivery context as a starting point, deep-dive with open-ended questions across these categories:

1. **Build** — How is the software built today? What toolchains, compilers, build systems? Cross-compilation? Multiple targets from one codebase? How long does a build take? What's the output — a binary, container, package, firmware image?

2. **Targets** — What does the software run on? Describe each target: OS, architecture, memory, peripherals, network. Are there multiple hardware revisions or SKUs? What's the minimum viable target for development vs. production?

3. **Testing Infrastructure** — What test environments exist today? Emulators or simulators? Hardware-in-the-loop rigs? Shared or dedicated? What can't be tested without real hardware? What's the bottleneck in testing today?

4. **Delivery** — How does software get onto the target? OTA update? Physical flash? Factory programming? App store submission? Container registry push? Package manager publish? What's the update mechanism for deployed systems?

5. **Failure & Recovery** — What happens when a deployment fails? Is there rollback? Watchdog recovery? Brick risk? What's the worst-case scenario? Has it happened before? What's the mean time to recovery?

6. **Monitoring & Observability** — How do you know if the deployed software is working? Logging? Telemetry? Manual inspection? Field reports? Health checks? Alerting? What's the time between a problem occurring and someone knowing about it?

Rules:
- Ask questions one-at-a-time per category, then WAIT for answers before moving on.
- Keep questions short and conversational — the user may be speaking, not typing.
- If an answer is vague, push back and ask for specifics.
- Summarize what you heard after each category and confirm before moving on.
- Don't penalize typos, incomplete sentences, or speech-to-text artifacts — interpret intent.
- These questions are intentionally open-ended. They work for web apps, mobile apps, embedded systems, firmware, CLI tools, libraries, or anything else. Don't assume any particular technology stack.
- If the project brief already answers a question, confirm the answer rather than re-asking: "The project brief says you deploy via OTA — is that still accurate, and can you tell me more about how that works?"

## Step 3: Produce the Environment Context

After all categories, save to `docs/env-context.md`:

```markdown
# Environment Context

**Last updated:** [today's date]
**Source:** `/env-discovery` interview

## Build
- **Build system:** [what and how]
- **Toolchain:** [compilers, SDKs, versions]
- **Cross-compilation:** [yes/no, details]
- **Build outputs:** [what the build produces]
- **Build time:** [approximate]

## Targets
| Target | OS | Architecture | Memory | Notes |
|--------|-----|-------------|--------|-------|
| [name] | [os] | [arch] | [ram] | [peripherals, constraints] |

## Testing Infrastructure
- **Unit/integration tests:** [how and where they run]
- **Emulators/simulators:** [what exists, what's available]
- **Hardware-in-the-loop:** [rigs, availability, shared/dedicated]
- **What requires real hardware:** [list]
- **Current bottleneck:** [what slows testing down]

## Delivery
- **Delivery mechanism:** [how software reaches the target]
- **Update mechanism:** [how deployed systems get updates]
- **Artifacts:** [what gets shipped — image, binary, container, package]
- **Signing/verification:** [if applicable]

## Failure & Recovery
- **Rollback capability:** [yes/no, how]
- **Worst-case scenario:** [what happens if deployment fails completely]
- **Mean time to recovery:** [approximate]
- **Known risks:** [brick risk, data loss, etc.]

## Monitoring & Observability
- **How you know it's working:** [logs, telemetry, health checks, etc.]
- **Alerting:** [what triggers alerts, who receives them]
- **Time to detection:** [how long between problem and awareness]

## Open Questions
- [Anything the user couldn't answer or needs to investigate]
```

Show the draft to the user for review. Don't save until they approve.

Tell the user they can run `/pipeline` next to define their build/test/deploy pipeline based on this context.
