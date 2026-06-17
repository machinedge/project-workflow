export const meta = {
  name: 'milestone',
  description: 'Accelerate one phase of the team-milestone lifecycle: up-front decomposition into a milestone plan, parallel cross-expert enrichment, implementation-ready task synthesis + verification with a backlog→planned promotion proposal, small-model implementation from the planned bucket, or parallel close-out reviews. Human approval gates live in the main conversation BETWEEN phase invocations — invoke this once per phase. REQUIRED: pass args as an object with the explicit milestone id and phase, e.g. args: { milestone: "M1", phase: "plan" }. phase is one of plan|enrich|compile|implement|review (implement also needs args.tasks = the approved planned/ paths). The script does NOT guess — it errors if args.milestone is missing. Resolve and confirm the target milestone from docs/roadmap.md in the conversation BEFORE invoking.',
  phases: [
    { title: 'Plan' },
    { title: 'Enrich' },
    { title: 'Compile' },
    { title: 'Implement' },
    { title: 'Review' },
  ],
}

// args may arrive in EITHER shape:
//   - object form (programmatic, how the main loop chains phases forward):
//       { milestone: string, phase: 'plan'|'enrich'|'compile'|'implement'|'review', tasks?: string[] }
//   - string form (slash command, e.g. `/milestone m1` or `/milestone M1 enrich`):
//       "m1" | "M1 enrich" | "plan m1" — the milestone id plus an optional phase token.
// normalizeArgs() below collapses both into the object form. The script does NOT guess: if no
// milestone is resolvable it returns an error rather than silently defaulting to "the next
// un-started milestone" — that silent default once decomposed the WRONG milestone (M2) when a
// caller invoked without args. Resolving/confirming the target is the conversation's job
// (team-milestone Step 0), done BEFORE invoking. The Plan/Compile subagents additionally echo
// back the milestone they ACTUALLY decomposed (resolvedMilestone) so the human gate can confirm.
// This is the Claude Code accelerator for agents/skills/team-milestone/SKILL.md (the portable
// runbook). It runs the parallelizable work of ONE phase and returns structured results to the
// main loop, where the human gate for that phase happens. Skills are followed by reading their
// SKILL.md under .agents/skills/. Subagents are non-interactive: they produce DRAFT artifacts /
// findings and return — they never wait for user approval.
//
// Phase order (the milestone is decomposed BEFORE it is enriched):
//   plan      pm-decompose (standard mode) -> skeleton tasks in .sdlc/issues/backlog/   [GATE 1]
//   enrich    SA / Security / QA / DevOps draft foundations (scoped by the plan)        [GATE 2]
//   compile   densify the backlog tasks in place -> implementation-ready; verify;
//             propose which to promote backlog -> planned                               [GATE 3]
//   implement read the approved planned/ tasks; each moves planned -> in-progress -> done
//   review    QA / SA / Security / regression close-out gates                           [GATE 4]
// The backlog->planned promotion runs in the main conversation AFTER GATE 3 (the script
// can't pause mid-run), so 'compile' only PROPOSES; 'implement' receives the approved paths.

const PHASES = ['plan', 'enrich', 'compile', 'implement', 'review']
function normalizeArgs(a) {
  if (a && typeof a === 'object' && !Array.isArray(a)) return a
  if (typeof a === 'string') {
    const toks = a.trim().split(/\s+/).filter(Boolean)
    const phase = toks.map(t => t.toLowerCase()).find(t => PHASES.includes(t))
    const milestone = toks.filter(t => !PHASES.includes(t.toLowerCase())).join(' ')
    return { milestone: milestone || undefined, phase }
  }
  return {}
}
const a = normalizeArgs(args)
const milestone = a.milestone
const stage = a.phase || 'plan'

// Fail loud, never guess. A missing milestone is the bug that silently decomposed the wrong
// milestone — refuse to run instead of falling back to "the next un-started" one.
if (!milestone) {
  return {
    error: 'No milestone specified. This workflow does not guess. Invoke the Workflow tool with explicit object args, e.g. args: { milestone: "M1", phase: "plan" }. Valid phases: plan, enrich, compile, implement, review. Resolve and confirm the target milestone from docs/roadmap.md in the conversation first (team-milestone Step 0).',
  }
}
if (!a.phase) log('No phase in args — defaulting to "plan". Pass args.phase (enrich|compile|implement|review) to run a later phase.')

const ENRICH_SCHEMA = {
  type: 'object',
  required: ['lens', 'summary', 'artifactPath'],
  properties: {
    lens: { type: 'string' },
    summary: { type: 'string', description: 'concise summary of the draft produced' },
    artifactPath: { type: 'string', description: 'file the draft was written to' },
    openQuestions: { type: 'array', items: { type: 'string' } },
  },
}

const DECOMP_SCHEMA = {
  type: 'object',
  required: ['resolvedMilestone', 'tasks'],
  properties: {
    resolvedMilestone: { type: 'string', description: 'the milestone actually decomposed, canonical "M<N> — <title>" from docs/roadmap.md' },
    tasks: {
      type: 'array',
      items: {
        type: 'object',
        required: ['path', 'title'],
        properties: {
          path: { type: 'string' },
          title: { type: 'string' },
          dependsOn: { type: 'array', items: { type: 'string' } },
        },
      },
    },
  },
}

const VERDICT_SCHEMA = {
  type: 'object',
  required: ['path', 'passes', 'gaps'],
  properties: {
    path: { type: 'string' },
    passes: { type: 'boolean', description: 'true if a small model could implement task + tests with no further design' },
    gaps: { type: 'array', items: { type: 'string' } },
  },
}

const IMPL_SCHEMA = {
  type: 'object',
  required: ['path', 'filesChanged', 'testCommand'],
  properties: {
    path: { type: 'string' },
    filesChanged: { type: 'array', items: { type: 'string' } },
    testCommand: { type: 'string' },
    notes: { type: 'string' },
  },
}

const IMPL_VERDICT_SCHEMA = {
  type: 'object',
  required: ['path', 'pass'],
  properties: {
    path: { type: 'string' },
    pass: { type: 'boolean' },
    failing: { type: 'array', items: { type: 'string' }, description: 'failing criteria or tests' },
  },
}

const REVIEW_SCHEMA = {
  type: 'object',
  required: ['gate', 'verdict', 'findings'],
  properties: {
    gate: { type: 'string' },
    verdict: { type: 'string', description: 'overall: pass | findings | blocked' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        required: ['severity', 'title', 'location'],
        properties: {
          severity: { type: 'string', enum: ['must-fix', 'should-fix', 'observation'] },
          title: { type: 'string' },
          location: { type: 'string', description: 'file:line or component' },
          recommendation: { type: 'string' },
        },
      },
    },
  },
}

// ---------------------------------------------------------------------------
// Phase 1: Plan — decompose the milestone into a skeleton task set FIRST, before
// any enrichment. Standard pm-decompose mode: session-sized tasks in backlog/,
// no enrichment inlined yet (the foundations don't exist at this point).
// ---------------------------------------------------------------------------
if (stage === 'plan') {
  phase('Plan')
  log(`Planning ${milestone}: decomposing into a skeleton task set (backlog/).`)
  const decomp = await agent(
    `Run pm-decompose in STANDARD mode for milestone "${milestone}". First read docs/roadmap.md, confirm "${milestone}" matches a real roadmap milestone, and return its canonical "M<N> — <title>" as resolvedMilestone so the human gate can confirm the right target before any work is committed. Read and follow .agents/skills/pm-decompose/SKILL.md (its Modes section — standard mode, the Plan phase of the milestone workflow). Produce the milestone's execution plan: session-sized task issues with acceptance criteria, referenced file paths, and dependency order, created under .sdlc/issues/backlog/. Do NOT attempt implementation-ready detail — the enrichment artifacts (architecture, security requirements, test plan) do not exist yet; they are inlined later in the Compile phase. Return the list of created task files with their dependency order.`,
    { label: 'plan:decompose', phase: 'Plan', schema: DECOMP_SCHEMA }
  )
  return {
    phase: 'plan',
    milestone: (decomp && decomp.resolvedMilestone) || milestone,
    tasks: (decomp && decomp.tasks) || [],
    nextGate: 'GATE 1 — present the execution plan (task list + dependency order) for approval before enriching. Adjust scope here, where it is cheap, before investing in foundations.',
  }
}

// ---------------------------------------------------------------------------
// Phase 2: Enrich — four expert lenses in parallel, each drafting its artifact,
// scoped to the planned task set from Phase 1.
// ---------------------------------------------------------------------------
if (stage === 'enrich') {
  phase('Enrich')
  log(`Enriching ${milestone} across SA, Security, UX, QA, DevOps (parallel drafts).`)
  const lenses = [
    { key: 'architecture', skill: 'sa-design', out: 'docs/architecture.md', focus: 'component boundaries, interfaces, data flow, and contracts for this milestone' },
    { key: 'security', skill: 'sec-requirements', out: 'docs/security-requirements.md', focus: 'a threat model and verifiable security controls (SR-NNN)' },
    { key: 'ux', skill: 'ux-guidelines', out: 'docs/ux-guidelines.md', focus: 'user flows, interaction patterns, accessibility, content/error clarity, and CLI ergonomics (UX-NNN); if the milestone has no user-facing surface, say so and produce a minimal note rather than inventing UI' },
    { key: 'test', skill: 'qa-test-plan', out: 'docs/test-plan.md', focus: 'test strategy, acceptance criteria, and explicit test cases' },
    { key: 'pipeline', skill: 'ops-pipeline', out: 'the pipeline definition', focus: 'build/test/deploy stages and environment needs' },
  ]
  const results = await parallel(lenses.map(l => () =>
    agent(
      `You are enriching milestone "${milestone}" from one expert lens. First read the milestone's planned task set (the skeleton issues created in the Plan phase under .sdlc/issues/backlog/) so your draft is scoped to the actual work, not the whole project. Then read and follow the skill at .agents/skills/${l.skill}/SKILL.md, scoped to this milestone, to produce a DRAFT of ${l.out} focused on ${l.focus}. You are a non-interactive subagent: do NOT wait for user approval. Write the draft to its file path, keep it proportionate (the milestone risk is analysis paralysis — timebox it), and return a concise summary plus any open questions for the human gate.`,
      { label: `enrich:${l.key}`, phase: 'Enrich', schema: ENRICH_SCHEMA }
    )
  ))
  return {
    phase: 'enrich',
    milestone,
    lenses: results.filter(Boolean),
    nextGate: 'GATE 2 — present the four drafts to the user for foundations approval before compiling tasks.',
  }
}

// ---------------------------------------------------------------------------
// Phase 3: Compile — densify the EXISTING backlog tasks (from the Plan phase) to
// implementation-ready in place, verify each, and PROPOSE which to promote from
// backlog -> planned. The actual move happens in the main conversation after the
// GATE 3 approval, so this phase only proposes — it does not move files.
// ---------------------------------------------------------------------------
if (stage === 'compile') {
  phase('Compile')
  log(`Compiling ${milestone}: densifying the planned tasks to implementation-ready.`)
  const decomp = await agent(
    `Run pm-decompose in IMPLEMENTATION-READY mode for milestone "${milestone}". First read docs/roadmap.md, confirm "${milestone}" matches a real roadmap milestone, and return its canonical "M<N> — <title>" as resolvedMilestone so the gate can confirm the right target. Read and follow .agents/skills/pm-decompose/SKILL.md (its Modes + implementation-ready template) and docs/task-detail-standard.md. The skeleton task issues for this milestone ALREADY EXIST under .sdlc/issues/backlog/ (created in the Plan phase) — DENSIFY EACH ONE IN PLACE to implementation-ready, reusing its already-assigned issue number. Do NOT create new duplicate issues. Inline the architecture contracts, SR-NNN security constraints, and test cases from the enrichment artifacts. Return the list of task files with their dependency order.`,
    { label: 'compile:densify', phase: 'Compile', schema: DECOMP_SCHEMA }
  )
  const tasks = (decomp && decomp.tasks) || []
  const verdicts = await parallel(tasks.map(t => () =>
    agent(
      `Be the skeptical small model. Read the task file ${t.path} and the completeness checklist in docs/task-detail-standard.md. Could you implement this task AND its tests with no further design decision and no questions? Check every checklist item. Return passes=true only if it fully clears the bar; otherwise list the concrete gaps.`,
      { label: `verify:${t.title}`, phase: 'Compile', schema: VERDICT_SCHEMA }
    )
  ))
  // Build the promote/hold proposal: a task is promotable only if it cleared the
  // completeness bar AND every task it depends on is also promotable.
  const passed = new Set(verdicts.filter(Boolean).filter(v => v.passes).map(v => v.path))
  const verdictByPath = new Map(verdicts.filter(Boolean).map(v => [v.path, v]))
  const promote = []
  const hold = []
  for (const t of tasks) {
    const v = verdictByPath.get(t.path)
    const deps = t.dependsOn || []
    const blockedBy = deps.filter(d => !passed.has(d))
    if (passed.has(t.path) && blockedBy.length === 0) {
      promote.push({ path: t.path, title: t.title })
    } else {
      const reason = !passed.has(t.path)
        ? `failed completeness: ${(v && v.gaps || []).join('; ') || 'incomplete'}`
        : `blocked by un-promotable dependency: ${blockedBy.join(', ')}`
      hold.push({ path: t.path, title: t.title, reason })
    }
  }
  return {
    phase: 'compile',
    milestone: (decomp && decomp.resolvedMilestone) || milestone,
    tasks,
    verdicts: verdicts.filter(Boolean),
    promote,
    hold,
    nextGate: 'GATE 3 — present the proposed planned set (promote) and held-back tasks (hold) for approval. Enrich any held task whose gap is fixable. After the user approves, promote the approved tasks with `.agents/scripts/move-issue.sh <file> planned` and run `.agents/scripts/update-issues-list.sh`, then run the implement phase with args.tasks set to the approved planned/ paths.',
  }
}

// ---------------------------------------------------------------------------
// Phase 4: Implement — small-model loop over the APPROVED planned tasks,
// sequential in dependency order. Each task walks planned -> in-progress (on
// start) -> done (on verified pass); a failing task is left in in-progress and
// flagged. args.tasks holds the planned/ paths approved at GATE 3.
// ---------------------------------------------------------------------------
if (stage === 'implement') {
  phase('Implement')
  const tasks = a.tasks || []
  if (!tasks.length) {
    return { phase: 'implement', milestone, error: 'Pass args.tasks as the ordered list of approved planned/ task file paths to implement (the set approved at GATE 3).' }
  }
  log(`Implementing ${tasks.length} planned task(s) with a small model, in dependency order.`)
  const results = []
  for (let i = 0; i < tasks.length; i++) {
    const taskPath = tasks[i]
    // Move the task into in-progress and update its Status before work begins.
    await agent(
      `Begin work on the task currently at ${taskPath}. Run \`.agents/scripts/move-issue.sh <basename> in-progress\` (basename = the file name without directory) to move it into .sdlc/issues/in-progress/, then edit the moved file's header so **Status:** reads in-progress. Return the new in-progress/ path of the file.`,
      { label: `start:${taskPath}`, phase: 'Implement' }
    )
    const baseName = taskPath.split('/').pop()
    const activePath = `.sdlc/issues/in-progress/${baseName}`
    // Small model implements from the dense spec.
    let impl = await agent(
      `Implement the task specified in ${activePath} EXACTLY as written: write the code and the tests per its Files/Interfaces/Implementation Outline/Test Specification. Honor its Security Constraints and Architecture Contracts. Reuse the utilities it names. Return the files changed and the exact test command.`,
      { label: `impl:${baseName}`, phase: 'Implement', model: 'haiku', schema: IMPL_SCHEMA }
    )
    let verdict = impl ? await agent(
      `Verify the implementation of ${activePath}. Run ${impl.testCommand || 'its tests'} and check each acceptance criterion in the task file. Return pass=true only if all tests pass and all criteria are met; otherwise list what failed.`,
      { label: `verify-impl:${baseName}`, phase: 'Implement', schema: IMPL_VERDICT_SCHEMA }
    ) : null
    // One retry; then escalate to a fuller model.
    if (verdict && !verdict.pass) {
      impl = await agent(
        `The implementation of ${activePath} failed verification: ${(verdict.failing || []).join('; ')}. Fix it so all tests pass and all acceptance criteria are met. Return the files changed and the test command.`,
        { label: `impl-escalate:${baseName}`, phase: 'Implement', schema: IMPL_SCHEMA }
      )
      verdict = impl ? await agent(
        `Re-verify ${activePath}: run ${impl.testCommand || 'its tests'} and check every acceptance criterion. Return pass + any remaining failures.`,
        { label: `reverify:${baseName}`, phase: 'Implement', schema: IMPL_VERDICT_SCHEMA }
      ) : null
    }
    const passed = !!(verdict && verdict.pass)
    if (passed) {
      // Move to done and mark Status: done.
      await agent(
        `The task ${activePath} passed verification. Run \`.agents/scripts/move-issue.sh ${baseName} done\` to move it into .sdlc/issues/done/, edit the moved file's header so **Status:** reads done, then run \`.agents/scripts/update-issues-list.sh\`. Return when complete.`,
        { label: `done:${baseName}`, phase: 'Implement' }
      )
    }
    results.push({ taskPath: activePath, impl, verdict, escalated: !passed, done: passed })
    log(`  ${baseName}: ${passed ? 'passed → done' : 'NEEDS ATTENTION (left in in-progress/)'}`)
  }
  const unresolved = results.filter(r => !r.done).map(r => r.taskPath)
  return { phase: 'implement', milestone, results, unresolved }
}

// ---------------------------------------------------------------------------
// Phase 5: Review — close-out gates in parallel (read-only), then file issues
// sequentially to avoid issue-number races.
// ---------------------------------------------------------------------------
if (stage === 'review') {
  phase('Review')
  log(`Running close-out gates for ${milestone} (QA, SA, Security, UX, regression) in parallel.`)
  const gates = [
    { key: 'qa', skill: 'qa-review', focus: 'code vs. intent and the test plan' },
    { key: 'architecture', skill: 'sa-review', focus: 'conformance to docs/architecture.md' },
    { key: 'security', skill: 'sec-review', focus: 'security controls enforced; vuln / authz / secrets / dependency risk' },
    { key: 'ux', skill: 'ux-review', focus: 'UX-NNN conformance: flow completeness, accessibility, consistency, content & CLI ergonomics; skip if no user-facing surface' },
    { key: 'regression', skill: 'qa-regression', focus: 'acceptance criteria still pass across the milestone' },
  ]
  const reviews = await parallel(gates.map(g => () =>
    agent(
      `Run the ${g.skill} close-out gate for milestone "${milestone}", focused on ${g.focus}. Read and follow .agents/skills/${g.skill}/SKILL.md for HOW to evaluate, but do NOT file issues yourself (issue numbering is not concurrency-safe). Instead RETURN your findings (severity, title, location, recommendation) and an overall verdict.`,
      { label: `review:${g.key}`, phase: 'Review', schema: REVIEW_SCHEMA }
    )
  ))
  const all = reviews.filter(Boolean)
  const actionable = all.flatMap(r => (r.findings || []).filter(f => f.severity !== 'observation'))
  // File issues sequentially via one agent so next-issue-number.sh doesn't collide.
  let filed = 0
  if (actionable.length) {
    const res = await agent(
      `File these ${actionable.length} review findings as issue files in .sdlc/issues/backlog/. Process them ONE AT A TIME: for each, run .agents/scripts/next-issue-number.sh to claim a number, write a swe-bug-NNN.md (or swe-techdebt-NNN.md) issue referencing the location and recommendation. After all are filed, run .agents/scripts/update-issues-list.sh. Return the count filed. Findings: ${JSON.stringify(actionable)}`,
      { label: 'review:file-issues', phase: 'Review' }
    )
    filed = actionable.length
    log(`Filed ${filed} issue(s). ${res ? '' : ''}`)
  }
  const mustFix = actionable.filter(f => f.severity === 'must-fix').length
  return {
    phase: 'review',
    milestone,
    reviews: all,
    filed,
    mustFix,
    nextGate: `GATE 4 — go/no-go. ${mustFix} must-fix finding(s) ${mustFix ? 'BLOCK the milestone until fixed (loop back to implement).' : 'open.'}`,
  }
}

return { error: `Unknown phase "${stage}". Use one of: plan, enrich, compile, implement, review.` }
