# Project Workflow System

This project uses a structured workflow for planning, execution, and continuous improvement. Claude assists as a collaborative partner throughout each phase.

## Workflow Phases

| Phase | Purpose | Input | Output | Guide |
|-------|---------|-------|--------|-------|
| 1. Ideation | Extract ideas from your head | Brain dump / rough notes | `docs/ideation.md` | [01-ideation.md](phases/01-ideation.md) |
| 2. Vision & Architecture | Define what we're building and why | Ideation output | `docs/vision.md`, `docs/architecture.md` | [02-vision.md](phases/02-vision.md) |
| 3. Roadmap | Plan milestones and MVP evolution | Vision + Architecture | `docs/roadmap.md` | [03-roadmap.md](phases/03-roadmap.md) |
| 4. Sprint Planning | Break milestone into executable stories | Roadmap milestone | `sprints/sprint-XX/` | [04-sprint-planning.md](phases/04-sprint-planning.md) |
| 5. Execution | Implement, test, document | Story file | Code + POSTMORTEM entries | [05-execution.md](phases/05-execution.md) |
| 6. Code Review | Multi-perspective quality review | Completed code | `CODE_REVIEW.md`, `INDEPENDENT_CODE_REVIEW.md` | [06-code-review.md](phases/06-code-review.md) |
| 7. Retrospective | Extract learnings, update docs | Sprint postmortems | `sprint-learnings.md`, updated roadmap | [07-retrospective.md](phases/07-retrospective.md) |

## How to Use This System

### Starting a New Phase

1. Open a **new chat/session** (to manage context window)
2. Add the relevant phase guide as context (e.g., `phases/02-vision.md`)
3. Add any input artifacts from previous phases (e.g., `docs/ideation.md`)
4. Tell Claude which phase you're starting

### Working with Claude

Claude will:
- **Ask questions one at a time** to extract information from you
- **Generate drafts** for your review
- **Iterate** based on your feedback
- **Finalize** when you approve (e.g., "ok, it looks good")

You control the pace. If Claude's questions aren't hitting the mark, redirect. If you want to skip ahead, say so.

### Phase Transitions

When you complete a phase:
1. Ensure output artifacts are saved
2. Open a new session
3. Load the next phase guide + previous outputs as context
4. Continue

## Directory Structure

```
project-root/
├── .claude/
│   ├── CLAUDE.md              # This file - workflow overview
│   └── phases/                # Phase-specific guides
│       ├── 01-ideation.md
│       ├── 02-vision.md
│       ├── 03-roadmap.md
│       ├── 04-sprint-planning.md
│       ├── 05-execution.md
│       ├── 06-code-review.md
│       └── 07-retrospective.md
├── docs/
│   ├── ideation.md            # Phase 1 output
│   ├── vision.md              # Phase 2 output
│   ├── architecture.md        # Phase 2 output
│   └── roadmap.md             # Phase 3 output
├── sprints/
│   ├── sprint-01/
│   │   ├── STORIES_INDEX.md   # Sprint overview + story list
│   │   ├── stories/           # Individual story files
│   │   │   ├── 01-story-name.md
│   │   │   └── ...
│   │   ├── POSTMORTEM.md      # Per-task learnings (single file)
│   │   ├── CODE_REVIEW.md     # Multi-model review results
│   │   └── sprint-learnings.md # Condensed sprint retrospective
│   └── archive/               # Completed sprints (condensed)
└── src/                       # Your actual code
```

## Sprint Lifecycle

### Active Sprint
Full documentation in `sprints/sprint-XX/`:
- Story files with acceptance criteria
- Running postmortem entries as tasks complete
- Code review artifacts

### Sprint Closure
1. Complete retrospective (Phase 7)
2. Generate `sprint-learnings.md`
3. Move sprint folder to `archive/` (or delete, keeping only learnings)
4. Learnings feed into next planning cycle

## Quick Reference

**To start ideation:** "I'm starting Phase 1 - Ideation. Here's my rough idea: [brain dump]"

**To continue a phase:** "Let's continue working on [artifact]. Here's where we left off: [context]"

**To move to next phase:** "Phase X is complete. Let's start Phase Y."

**To skip Claude's questions:** "I have a clear picture already. Let me give you the full context: [details]"

**To get a draft:** "Generate a draft based on what we've discussed so far."
