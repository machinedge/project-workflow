export const meta = {
  name: 'document',
  description: 'Accelerate the documentation lifecycle: plan the guides, author them in parallel, review them across accuracy / not-overstated / readability-per-audience / completeness lenses, then revise to apply the must-fix findings. Human approval gates live in the main conversation BETWEEN phase invocations — invoke this once per phase. Pass args as an object, e.g. args: { scope: "project", phase: "plan" }. scope defaults to "project" (the whole codebase) and may instead be a milestone id (e.g. "M18") or a single topic/guide. phase is one of plan|author|review|revise. The author/review phases also take args.guides = the guide set approved at the plan gate; the revise phase takes args.guides = [{ path, findings }] (the guides with their must-fix findings approved at the review gate).',
  phases: [
    { title: 'Plan' },
    { title: 'Author' },
    { title: 'Review' },
    { title: 'Revise' },
  ],
}

// args may arrive in EITHER shape:
//   - object form (programmatic, how the main loop chains phases forward):
//       { scope: string, phase: 'plan'|'author'|'review'|'revise', guides?: [...] }
//   - string form (slash command, e.g. `/documentation project plan` or `/documentation M18 author`):
//       "project" | "M18 author" | "plan" — an optional scope plus an optional phase token.
// normalizeArgs() collapses both into the object form. Unlike the milestone workflow, this one does
// NOT fail loud on a missing scope: documenting "the whole project" is a safe, intended default, so
// scope falls back to "project" (and we log it). The phase still defaults to "plan".
//
// This is the Claude Code accelerator for agents/skills/team-docs/SKILL.md (the portable runbook).
// It runs the parallelizable work of ONE phase and returns structured results to the main loop,
// where the human gate for that phase happens. Skills are followed by reading their SKILL.md under
// .agents/skills/. Subagents are non-interactive: they produce DRAFT artifacts / findings and
// return — they never wait for user approval.
//
// Phase order:
//   plan    doc-plan -> .sdlc/documentation-plan.md (audiences, guide inventory, DOC-NNN)   [GATE 1]
//   author  one doc-author per approved guide -> docs/guides/*.md (parallel, distinct files)[GATE 2]
//   review  guides x lenses fan-out (accuracy / overclaiming / completeness / readability), [GATE 3]
//           returns findings grouped by guide; must-fix block
//   revise  one doc-author (fix mode) per guide carrying must-fix findings; then files the
//           remaining should-fix / observations as doc- backlog issues (sequentially).
// args.guides for review/revise is the set approved at the previous gate, carried by the main loop.

const PHASES = ['plan', 'author', 'review', 'revise']
function normalizeArgs(a) {
  if (a && typeof a === 'object' && !Array.isArray(a)) return a
  if (typeof a === 'string') {
    // An object arg can arrive JSON-stringified (some harness paths serialize it in transit).
    // Detect that BEFORE slash-token parsing — otherwise the JSON body is tokenized and any
    // stray phase word inside it (e.g. "review" in a guide summary) misroutes the phase.
    const t = a.trim()
    if (t.startsWith('{') || t.startsWith('[')) {
      try {
        const parsed = JSON.parse(t)
        if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) return parsed
      } catch (_) { /* not JSON — fall through to slash-token parsing */ }
    }
    const toks = a.trim().split(/\s+/).filter(Boolean)
    const phase = toks.map(t => t.toLowerCase()).find(t => PHASES.includes(t))
    const scope = toks.filter(t => !PHASES.includes(t.toLowerCase())).join(' ')
    return { scope: scope || undefined, phase }
  }
  return {}
}
const a = normalizeArgs(args)
const scope = a.scope || 'project'
const stage = a.phase || 'plan'

if (!a.scope) log('No scope in args — defaulting to "project" (the whole codebase). Pass args.scope to target a milestone id or a single topic/guide.')
if (!a.phase) log('No phase in args — defaulting to "plan". Pass args.phase (author|review|revise) to run a later phase.')

// ---------------------------------------------------------------------------
// Schemas for structured subagent output.
// ---------------------------------------------------------------------------
const DOCPLAN_SCHEMA = {
  type: 'object',
  required: ['scope', 'audiences', 'guides'],
  properties: {
    scope: { type: 'string', description: 'what the plan covers, echoed back (project | milestone id | topic)' },
    audiences: { type: 'array', items: { type: 'string' }, description: 'the reader audiences this scope serves (e.g. end user, developer, maintainer, operator)' },
    guides: {
      type: 'array',
      items: {
        type: 'object',
        required: ['path', 'summary'],
        properties: {
          path: { type: 'string', description: 'the guide file, e.g. docs/guides/deployment.md' },
          audiences: { type: 'array', items: { type: 'string' }, description: 'the audience(s) this guide serves' },
          summary: { type: 'string', description: 'what the guide covers' },
          requirements: { type: 'array', items: { type: 'string' }, description: 'the DOC-NNN ids this guide must satisfy' },
        },
      },
    },
  },
}

const AUTHOR_SCHEMA = {
  type: 'object',
  required: ['path', 'summary', 'verified'],
  properties: {
    path: { type: 'string', description: 'the guide file written or updated' },
    summary: { type: 'string', description: 'what was written and which DOC-NNN it satisfies' },
    verified: { type: 'boolean', description: 'true only if every step/command was walked and works as written' },
    unverifiedSteps: { type: 'array', items: { type: 'string' }, description: 'steps that could not be walked (no env, external dependency) — stated honestly' },
  },
}

const REVIEW_SCHEMA = {
  type: 'object',
  required: ['guide', 'lens', 'verdict', 'findings'],
  properties: {
    guide: { type: 'string', description: 'the guide path reviewed' },
    lens: { type: 'string', description: 'the review lens applied (accuracy | overclaiming | completeness | readability:<audience>)' },
    verdict: { type: 'string', description: 'overall for this guide+lens: pass | findings | blocked' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        required: ['severity', 'title', 'location'],
        properties: {
          severity: { type: 'string', enum: ['must-fix', 'should-fix', 'observation'] },
          title: { type: 'string' },
          location: { type: 'string', description: 'guide path:line, or the exact step/command' },
          recommendation: { type: 'string' },
        },
      },
    },
  },
}

// ---------------------------------------------------------------------------
// Phase 1: Plan — produce/extend .sdlc/documentation-plan.md (audiences, guide
// inventory, DOC-NNN) scoped to `scope`. Proposes the guide set for GATE 1.
// ---------------------------------------------------------------------------
if (stage === 'plan') {
  phase('Plan')
  log(`Planning documentation for scope "${scope}": audiences, guide inventory, and DOC-NNN.`)
  const plan = await agent(
    `You are planning the documentation for scope "${scope}" (this is the whole project unless the scope names a milestone or a single topic). Read and follow .agents/skills/doc-plan/SKILL.md. Read docs/project-brief.md, .sdlc/architecture.md, .sdlc/ux-guidelines.md, .sdlc/env-context.md, .sdlc/release-plan.md (whichever exist) and the actual code/commands so the plan reflects what shipped. Produce or extend .sdlc/documentation-plan.md with the audiences (end user / developer / maintainer / operator as applicable), the inventory of guides under docs/guides/ that this scope needs, and verifiable DOC-NNN requirements written for readers unfamiliar with the project. You are a non-interactive subagent: do NOT wait for user approval — write the plan file and RETURN the audiences and the guide inventory (each guide with its path, audience(s), summary, and DOC-NNN ids) for the human gate.`,
    { label: 'plan:doc-plan', phase: 'Plan', schema: DOCPLAN_SCHEMA }
  )
  return {
    phase: 'plan',
    scope: (plan && plan.scope) || scope,
    audiences: (plan && plan.audiences) || [],
    guides: (plan && plan.guides) || [],
    nextGate: 'GATE 1 — present the audiences and the guide inventory for approval. Trim or add guides here, where it is cheap, before authoring. After approval, run the author phase with args.guides set to the approved guide list.',
  }
}

// ---------------------------------------------------------------------------
// Phase 2: Author — write each approved guide in parallel (distinct files).
// ---------------------------------------------------------------------------
if (stage === 'author') {
  phase('Author')
  const guides = a.guides || []
  if (!guides.length) {
    return { phase: 'author', scope, error: 'Pass args.guides as the approved guide list from GATE 1 (each item with at least a path; ideally audiences + summary).' }
  }
  log(`Authoring ${guides.length} guide(s) in parallel from the specs and the shipped code.`)
  const results = await parallel(guides.map(g => () =>
    agent(
      `You are authoring one documentation guide for scope "${scope}". Read and follow .agents/skills/doc-author/SKILL.md. The guide to write or update is ${g.path}${g.summary ? ` — it covers: ${g.summary}` : ''}${g.audiences ? ` (audience: ${[].concat(g.audiences).join(', ')})` : ''}. Read .sdlc/documentation-plan.md for its DOC-NNN requirements; if this scope has a docs surface (a documentation plan was produced) but .sdlc/documentation-plan.md is absent, STOP and report: "documentation-plan.md not found at .sdlc/documentation-plan.md. Produce it with doc-plan, or run migrate-sdlc for an existing project." (if this scope legitimately has no docs surface, that is a documented no-op — but you were handed a guide to author, so the plan is required). Then read the relevant expert specs (.sdlc/architecture.md, .sdlc/ux-guidelines.md, .sdlc/env-context.md, .sdlc/release-plan.md) and the ACTUAL shipped code/commands, then write the guide for a reader unfamiliar with the project — exact commands, paths, and example values, following the "Writing clearly" conventions in AGENTS.md. Self-verify by walking every step/command as the target reader; fix anything that fails or assumes insider knowledge. You are a non-interactive subagent: do NOT wait for user approval. RETURN the path, a summary, whether you verified it by walking it, and any steps you could not verify.`,
      { label: `author:${g.path}`, phase: 'Author', schema: AUTHOR_SCHEMA }
    )
  ))
  return {
    phase: 'author',
    scope,
    authored: results.filter(Boolean),
    nextGate: 'GATE 2 — skim the drafted guides. When ready, run the review phase with args.guides set to the authored guide list (carry each guide\'s audiences so readability runs per audience).',
  }
}

// ---------------------------------------------------------------------------
// Phase 3: Review — guides x lenses fan-out (all parallel). Returns findings
// grouped by guide; does NOT file issues (numbering is not concurrency-safe).
// ---------------------------------------------------------------------------
if (stage === 'review') {
  phase('Review')
  const guides = a.guides || []
  if (!guides.length) {
    return { phase: 'review', scope, error: 'Pass args.guides as the authored guide list from GATE 2 (each with a path; ideally audiences for the readability lens).' }
  }
  // Build one job per (guide, lens). Accuracy / overclaiming / completeness run once per guide;
  // readability runs once per audience the guide serves.
  const jobs = []
  for (const g of guides) {
    const path = g.path || g
    const audiences = (g.audiences && [].concat(g.audiences)) || (g.audience ? [g.audience] : ['end user', 'developer', 'maintainer'])
    jobs.push({ path, lens: 'accuracy', focus: 'every command, path, config key, and behavior in the guide matches the REAL shipped code — not the plan; flag anything wrong, stale, or unverifiable, with the exact location' })
    jobs.push({ path, lens: 'overclaiming', focus: 'flag any capability, guarantee, maturity, or performance/security claim the code does NOT back up; nothing aspirational may be stated as if it already works' })
    jobs.push({ path, lens: 'completeness', focus: 'every DOC-NNN requirement for this guide (see .sdlc/documentation-plan.md) is delivered, with no missing prerequisite or step. Read .sdlc/documentation-plan.md; if it is absent, STOP and report: "documentation-plan.md not found at .sdlc/documentation-plan.md. Produce it with doc-plan, or run migrate-sdlc for an existing project." — without the plan there are no DOC-NNN requirements to check completeness against' })
    for (const aud of audiences) {
      jobs.push({ path, lens: `readability:${aud}`, focus: `read the guide as a ${aud} with NO insider knowledge — is every step followable and the whole thing digestible from that seat? Flag jargon, gaps, and assumed context that would stall this reader` })
    }
  }
  log(`Reviewing ${guides.length} guide(s) across ${jobs.length} lens-checks (accuracy, not-overstated, completeness, readability-per-audience) in parallel.`)
  const results = await parallel(jobs.map(j => () =>
    agent(
      `Review the documentation guide ${j.path} through ONE lens. Read and follow .agents/skills/doc-review/SKILL.md for HOW to evaluate, but apply ONLY this lens: ${j.focus}. Read the guide AND the shipped code/specs it describes so your verdict is evidence-based. Do NOT file issues yourself (issue numbering is not concurrency-safe). RETURN your findings (severity must-fix|should-fix|observation, title, location, recommendation) and an overall verdict for this guide+lens. Set guide="${j.path}" and lens="${j.lens}".`,
      { label: `review:${j.lens}:${j.path}`, phase: 'Review', schema: REVIEW_SCHEMA }
    )
  ))
  const all = results.filter(Boolean)
  // Group findings by guide for the gate presentation.
  const byGuide = {}
  for (const r of all) {
    const key = r.guide || 'unknown'
    if (!byGuide[key]) byGuide[key] = { guide: key, mustFix: [], shouldFix: [], observations: [] }
    for (const f of (r.findings || [])) {
      const bucket = f.severity === 'must-fix' ? 'mustFix' : f.severity === 'should-fix' ? 'shouldFix' : 'observations'
      byGuide[key][bucket].push({ ...f, lens: r.lens })
    }
  }
  const mustFix = Object.values(byGuide).reduce((n, g) => n + g.mustFix.length, 0)
  return {
    phase: 'review',
    scope,
    reviews: all,
    byGuide: Object.values(byGuide),
    mustFix,
    nextGate: `GATE 3 — present findings grouped by guide, most severe first. ${mustFix} must-fix finding(s) ${mustFix ? 'BLOCK the docs until fixed.' : 'open.'} Approve the revise set and run the revise phase with args.guides = [{ path, findings }] (each guide with its must-fix findings, plus any should-fix worth fixing now).`,
  }
}

// ---------------------------------------------------------------------------
// Phase 4: Revise — apply the approved findings to each guide (fix mode), then
// file the remaining should-fix / observations as doc- issues (sequentially).
// ---------------------------------------------------------------------------
if (stage === 'revise') {
  phase('Revise')
  const guides = a.guides || []
  if (!guides.length) {
    return { phase: 'revise', scope, error: 'Pass args.guides as [{ path, findings }] — the guides with the findings approved at GATE 3.' }
  }
  log(`Revising ${guides.length} guide(s): applying approved findings and re-walking each.`)
  const results = await parallel(guides.map(g => () =>
    agent(
      `You are revising the documentation guide ${g.path} to apply review findings (fix mode). Read and follow .agents/skills/doc-author/SKILL.md. Apply these findings to the existing guide, then re-walk every changed step/command to confirm it works as written: ${JSON.stringify(g.findings || [])}. Do not introduce new claims the code does not back up. You are a non-interactive subagent: do NOT wait for user approval. RETURN the path, a summary of what changed, whether you re-verified by walking it, and any step you could not verify.`,
      { label: `revise:${g.path}`, phase: 'Revise', schema: AUTHOR_SCHEMA }
    )
  ))
  // Collect any leftover should-fix / observations passed through for filing.
  const leftover = guides.flatMap(g => (g.findings || []).filter(f => f.severity && f.severity !== 'must-fix').map(f => ({ ...f, guide: g.path })))
  let filed = 0
  if (leftover.length) {
    await agent(
      `File these ${leftover.length} leftover documentation findings as issue files in .sdlc/issues/backlog/. Process them ONE AT A TIME: for each, run .agents/scripts/next-issue-number.sh to claim a number, then write a doc-bug-NNN.md (or doc-techdebt-NNN.md) issue referencing the guide, location, and recommendation, with doc- as the executor. After all are filed, run .agents/scripts/update-issues-list.sh. Return the count filed. Findings: ${JSON.stringify(leftover)}`,
      { label: 'revise:file-issues', phase: 'Revise' }
    )
    filed = leftover.length
    log(`Filed ${filed} leftover should-fix/observation finding(s) as doc- issues.`)
  }
  return {
    phase: 'revise',
    scope,
    revised: results.filter(Boolean),
    filed,
    nextGate: 'Wrap-up gate — present the revised guides and the filed doc- issues. The guides in docs/guides/ are the deliverable; confirm the must-fix findings are resolved before closing. Produce a doc-handoff note if this was a working session.',
  }
}

return { error: `Unknown phase "${stage}". Use one of: plan, author, review, revise.` }
