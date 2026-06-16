export const meta = {
  name: 'milestone',
  description: 'Accelerate one phase of the team-milestone lifecycle: parallel cross-expert enrichment, implementation-ready task synthesis + verification, small-model implementation, or parallel close-out reviews. Human approval gates live in the main conversation BETWEEN phase invocations — invoke this once per phase.',
  phases: [
    { title: 'Enrich' },
    { title: 'Compile' },
    { title: 'Implement' },
    { title: 'Review' },
  ],
}

// args: { milestone: string, phase: 'enrich'|'compile'|'implement'|'review', tasks?: string[] }
// This is the Claude Code accelerator for agents/skills/team-milestone/SKILL.md (the portable
// runbook). It runs the parallelizable work of ONE phase and returns structured results to the
// main loop, where the human gate for that phase happens. Skills are followed by reading their
// SKILL.md under .agents/skills/. Subagents are non-interactive: they produce DRAFT artifacts /
// findings and return — they never wait for user approval.

const milestone = (args && args.milestone) || 'the next un-started milestone in docs/roadmap.md'
const stage = (args && args.phase) || 'enrich'

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
  required: ['tasks'],
  properties: {
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
// Phase 1: Enrich — four expert lenses in parallel, each drafting its artifact.
// ---------------------------------------------------------------------------
if (stage === 'enrich') {
  phase('Enrich')
  log(`Enriching ${milestone} across SA, Security, QA, DevOps (parallel drafts).`)
  const lenses = [
    { key: 'architecture', skill: 'sa-design', out: 'docs/architecture.md', focus: 'component boundaries, interfaces, data flow, and contracts for this milestone' },
    { key: 'security', skill: 'sec-requirements', out: 'docs/security-requirements.md', focus: 'a threat model and verifiable security controls (SR-NNN)' },
    { key: 'test', skill: 'qa-test-plan', out: 'docs/test-plan.md', focus: 'test strategy, acceptance criteria, and explicit test cases' },
    { key: 'pipeline', skill: 'ops-pipeline', out: 'the pipeline definition', focus: 'build/test/deploy stages and environment needs' },
  ]
  const results = await parallel(lenses.map(l => () =>
    agent(
      `You are enriching milestone "${milestone}" from one expert lens. Read and follow the skill at .agents/skills/${l.skill}/SKILL.md, scoped to this milestone, to produce a DRAFT of ${l.out} focused on ${l.focus}. You are a non-interactive subagent: do NOT wait for user approval. Write the draft to its file path, keep it proportionate (the milestone risk is analysis paralysis — timebox it), and return a concise summary plus any open questions for the human gate.`,
      { label: `enrich:${l.key}`, phase: 'Enrich', schema: ENRICH_SCHEMA }
    )
  ))
  return {
    phase: 'enrich',
    milestone,
    lenses: results.filter(Boolean),
    nextGate: 'GATE 1 — present the four drafts to the user for foundations approval before compiling tasks.',
  }
}

// ---------------------------------------------------------------------------
// Phase 2: Compile — decompose into implementation-ready tasks, verify each.
// ---------------------------------------------------------------------------
if (stage === 'compile') {
  phase('Compile')
  log(`Compiling ${milestone} into implementation-ready tasks.`)
  const decomp = await agent(
    `Run pm-decompose in IMPLEMENTATION-READY mode for milestone "${milestone}". Read and follow .agents/skills/pm-decompose/SKILL.md (its Modes + implementation-ready template) and docs/task-detail-standard.md. Inline the architecture contracts, SR-NNN security constraints, and test cases from the enrichment artifacts. Create the issue files under .workflow/issues/backlog/ and return the list of created task files with their dependency order.`,
    { label: 'compile:decompose', phase: 'Compile', schema: DECOMP_SCHEMA }
  )
  const tasks = (decomp && decomp.tasks) || []
  const verdicts = await parallel(tasks.map(t => () =>
    agent(
      `Be the skeptical small model. Read the task file ${t.path} and the completeness checklist in docs/task-detail-standard.md. Could you implement this task AND its tests with no further design decision and no questions? Check every checklist item. Return passes=true only if it fully clears the bar; otherwise list the concrete gaps.`,
      { label: `verify:${t.title}`, phase: 'Compile', schema: VERDICT_SCHEMA }
    )
  ))
  return {
    phase: 'compile',
    milestone,
    tasks,
    verdicts: verdicts.filter(Boolean),
    nextGate: 'GATE 2 — enrich any task that failed verification, then present the task set for approval before implementation.',
  }
}

// ---------------------------------------------------------------------------
// Phase 3: Implement — small-model loop, sequential in dependency order.
// ---------------------------------------------------------------------------
if (stage === 'implement') {
  phase('Implement')
  const tasks = (args && args.tasks) || []
  if (!tasks.length) {
    return { phase: 'implement', milestone, error: 'Pass args.tasks as the ordered list of task file paths to implement.' }
  }
  log(`Implementing ${tasks.length} task(s) with a small model, in dependency order.`)
  const results = []
  for (let i = 0; i < tasks.length; i++) {
    const taskPath = tasks[i]
    // Small model implements from the dense spec.
    let impl = await agent(
      `Implement the task specified in ${taskPath} EXACTLY as written: write the code and the tests per its Files/Interfaces/Implementation Outline/Test Specification. Honor its Security Constraints and Architecture Contracts. Reuse the utilities it names. Return the files changed and the exact test command.`,
      { label: `impl:${taskPath}`, phase: 'Implement', model: 'haiku', schema: IMPL_SCHEMA }
    )
    let verdict = impl ? await agent(
      `Verify the implementation of ${taskPath}. Run ${impl.testCommand || 'its tests'} and check each acceptance criterion in the task file. Return pass=true only if all tests pass and all criteria are met; otherwise list what failed.`,
      { label: `verify-impl:${taskPath}`, phase: 'Implement', schema: IMPL_VERDICT_SCHEMA }
    ) : null
    // One retry; then escalate to a fuller model.
    if (verdict && !verdict.pass) {
      impl = await agent(
        `The implementation of ${taskPath} failed verification: ${(verdict.failing || []).join('; ')}. Fix it so all tests pass and all acceptance criteria are met. Return the files changed and the test command.`,
        { label: `impl-escalate:${taskPath}`, phase: 'Implement', schema: IMPL_SCHEMA }
      )
      verdict = impl ? await agent(
        `Re-verify ${taskPath}: run ${impl.testCommand || 'its tests'} and check every acceptance criterion. Return pass + any remaining failures.`,
        { label: `reverify:${taskPath}`, phase: 'Implement', schema: IMPL_VERDICT_SCHEMA }
      ) : null
    }
    results.push({ taskPath, impl, verdict, escalated: !!(verdict && !verdict.pass) })
    log(`  ${taskPath}: ${verdict && verdict.pass ? 'passed' : 'NEEDS ATTENTION'}`)
  }
  const unresolved = results.filter(r => !(r.verdict && r.verdict.pass)).map(r => r.taskPath)
  return { phase: 'implement', milestone, results, unresolved }
}

// ---------------------------------------------------------------------------
// Phase 4: Review — close-out gates in parallel (read-only), then file issues
// sequentially to avoid issue-number races.
// ---------------------------------------------------------------------------
if (stage === 'review') {
  phase('Review')
  log(`Running close-out gates for ${milestone} (QA, SA, Security, regression) in parallel.`)
  const gates = [
    { key: 'qa', skill: 'qa-review', focus: 'code vs. intent and the test plan' },
    { key: 'architecture', skill: 'sa-review', focus: 'conformance to docs/architecture.md' },
    { key: 'security', skill: 'sec-review', focus: 'security controls enforced; vuln / authz / secrets / dependency risk' },
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
      `File these ${actionable.length} review findings as issue files in .workflow/issues/backlog/. Process them ONE AT A TIME: for each, run .agents/scripts/next-issue-number.sh to claim a number, write a swe-bug-NNN.md (or swe-techdebt-NNN.md) issue referencing the location and recommendation. After all are filed, run .agents/scripts/update-issues-list.sh. Return the count filed. Findings: ${JSON.stringify(actionable)}`,
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
    nextGate: `GATE 3 — go/no-go. ${mustFix} must-fix finding(s) ${mustFix ? 'BLOCK the milestone until fixed (loop back to implement).' : 'open.'}`,
  }
}

return { error: `Unknown phase "${stage}". Use one of: enrich, compile, implement, review.` }
