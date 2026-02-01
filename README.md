# Project Workflow Template

A structured workflow system for collaborative project planning and execution with Claude.

## Directory Structure

```
project-workflow/
├── .claude/                    # Workflow guides for Claude
│   ├── CLAUDE.md               # Master orchestrator - start here
│   └── phases/                 # Phase-specific instructions
│       ├── 01-ideation.md      # Extract ideas from your head
│       ├── 02-vision.md        # Define vision & architecture
│       ├── 03-roadmap.md       # Plan MVP & milestones
│       ├── 04-sprint-planning.md # Break into stories
│       ├── 05-execution.md     # Implement (Claude Code)
│       ├── 06-code-review.md   # Multi-model review
│       └── 07-retrospective.md # Synthesize learnings
├── docs/                       # Planning documents (generated)
│   ├── ideation.md             # Phase 1 output
│   ├── vision.md               # Phase 2 output
│   ├── architecture.md         # Phase 2 output
│   └── roadmap.md              # Phase 3 output
├── sprints/                    # Sprint artifacts
│   └── sprint-01/
│       ├── STORIES_INDEX.md    # Sprint overview
│       ├── stories/            # Individual story files
│       ├── POSTMORTEM.md       # Per-story learnings
│       ├── CODE_REVIEW.md      # Multi-model review (generated)
│       └── sprint-learnings.md # Retrospective output (generated)
├── src/                        # Your code
├── init-project-workflow.sh    # Standalone bootstrap script
└── newrepo-enhanced.zsh        # Enhanced newrepo function
```

## Setup

### Option 1: Use with newrepo function

1. Copy templates to your config directory:
   ```bash
   mkdir -p ~/.config/claude-workflow
   cp -r .claude ~/.config/claude-workflow/
   ```

2. Add to your `.zshrc`:
   ```bash
   source /path/to/newrepo-enhanced.zsh
   ```

3. Create new projects:
   ```bash
   newrepo my-project
   ```

### Option 2: Bootstrap existing directory

```bash
./init-project-workflow.sh /path/to/project
```

### Option 3: Manual copy

Copy the `.claude/` directory into your project root.

## Usage

### Starting a Project

1. Open a new Claude chat (Cowork or claude.ai)
2. Add `.claude/phases/01-ideation.md` as context
3. Share your rough idea
4. Claude asks questions one at a time to extract your thinking
5. Review and approve the generated `ideation.md`

### Phase Transitions

Each phase produces artifacts that become input to the next:

| Phase | You Provide | Claude Produces |
|-------|-------------|-----------------|
| 1. Ideation | Rough thoughts | `docs/ideation.md` |
| 2. Vision | Ideation doc | `docs/vision.md`, `docs/architecture.md` |
| 3. Roadmap | Vision + Architecture | `docs/roadmap.md` |
| 4. Sprint Planning | Roadmap milestone | `sprints/sprint-XX/*` |
| 5. Execution | Story file | Code + POSTMORTEM entry |
| 6. Code Review | Completed code | `CODE_REVIEW.md` |
| 7. Retrospective | Sprint artifacts | `sprint-learnings.md` |

**Important:** Start a new chat session for each phase to manage context window.

### Working with Claude

- Claude asks **one question at a time** to extract information
- Claude generates **drafts** for your review
- You **iterate** until satisfied
- Say **"ok, it looks good"** to finalize

## Phase Details

### Phase 1-3: Planning (Cowork/Claude.ai)
Collaborative document generation through Socratic questioning.

### Phase 4: Sprint Planning (Cowork/Claude.ai)
Break roadmap milestones into executable stories with acceptance criteria.

### Phase 5: Execution (Claude Code / IDE)
Implement stories with Claude as pair programming partner.

### Phase 6: Code Review
Run reviews through multiple AI models, then synthesize with independent review.

### Phase 7: Retrospective (Cowork/Claude.ai)
Extract learnings, update planning docs, prepare for next sprint.

## Sprint Lifecycle

**Active Sprint:** Full documentation in `sprints/sprint-XX/`

**Sprint Closure:**
1. Complete retrospective
2. Generate `sprint-learnings.md`
3. Archive or delete full sprint folder
4. Only learnings persist long-term

## License

MIT - Use freely, attribution appreciated.
