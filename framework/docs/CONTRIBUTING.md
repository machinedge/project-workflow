# Contributing an Expert

This guide walks through creating a new expert definition for this toolkit. Whether you're building a DevOps expert, a research analyst, or something else entirely, the process is the same.

## Quick Start

```bash
# 1. Scaffold a new expert
./framework/create-expert.sh --domain technical my-expert

# 2. Customize role.md and add skills
#    (see "What to Customize" below)

# 3. Validate your expert
./framework/validate.sh technical/my-expert
```

On Windows:
```powershell
.\framework\create-expert.ps1 -Domain technical my-expert
.\framework\validate.sh technical/my-expert   # validation is bash-only for now
```

## What the Scaffold Creates

Running `create-expert.sh --domain technical my-expert` generates:

```
experts/technical/my-expert/
├── role.md         # Identity, operating rules, session protocols
├── skills/         # Markdown skill definitions (empty — add as you go)
│   └── (empty)
└── tools/          # Executable scripts for this expert
    └── .gitkeep
```

To also scaffold the 8 default skill files from templates, use `--with-skills`:

```bash
./framework/create-expert.sh --domain technical --with-skills my-expert
```

This adds starter skill files to `skills/` with structural patterns and `<!-- GUIDE: ... -->` comments. Delete the guide comments as you fill in real content.

## What to Customize

### 1. Define `role.md`

This is the expert's identity — what it reads, how it operates, what it produces. Focus on:

**Document Locations** — What documents does your expert read and produce? Every expert needs a brief and handoff notes. Add domain-specific documents as needed.

**Session Protocol** — What should the expert read at session start? What should it produce at the end?

**Skills** — List each skill with a 1-line description.

**Principles** — Non-negotiable behavioral rules. Keep the universal ones (no memory, brief is source of truth, verification required) and add domain-specific ones.

### 2. Add Skills

Skills are markdown files in `skills/` that define what the expert does when triggered. Every skill file should have:

1. **Opening context** — What is happening and why
2. **Steps or phases** — The actual work, numbered and self-contained
3. **Approval gates** — Explicit "wait for confirmation" at decision points
4. **Output specification** — What gets produced, where, in what format
5. **Rules section** — Constraints and edge case handling

The 8-skill lifecycle (interview, brief, plan, decompose, start, review, handoff, synthesis) is a starting framework — not every expert needs all 8. See [workflow-anatomy.md](../docs/workflow-anatomy.md) for which slots each expert typically fills.

### 3. Add Tools (optional)

Tools go in `tools/` and are executable scripts (`.sh`, `.ps1`, `.py`) that the expert can invoke at runtime. Unlike skills (which are LLM-executed markdown), tools enforce capability boundaries. If your expert doesn't need tools, keep the directory with `.gitkeep`.

## Validation

Run `./framework/validate.sh technical/my-expert` to check your expert. It verifies:

- All required files exist (`role.md`, `skills/`, `tools/`)
- Skills referenced in `role.md` have matching files
- `role.md` has the required sections (Document Locations, Session Protocol, Skills, Principles)
- `start` skill has the 7-phase structure with approval gates (if present)
- `handoff` skill produces handoff notes (if present)
- `decompose` skill references in-repo `issues/` (if present)
- No leftover `{{PLACEHOLDER}}` markers or `<!-- GUIDE: -->` comments

Passing validation doesn't mean the expert is good — it means the structure is complete. The content quality is up to you.

## Packaging the Skill

After making changes to experts or the skill, rebuild the distributable `.skill` file:

```bash
./framework/package_skill.sh
```

This script:

1. Creates a `build/` directory
2. Copies `framework/skills/` into `build/skills/`
3. Copies `experts/` into `build/skills/machinedge-workflows/experts/` (assembling the nested structure the skill expects)
4. Downloads `package_skill.py` and `quick_validate.py` from the [anthropics/skills](https://github.com/anthropics/skills) repo if not already present
5. Validates the skill structure and produces `build/machinedge-workflows.skill`

## PR Checklist

Before submitting a pull request for a new expert:

- [ ] `./framework/validate.sh technical/my-expert` passes with no failures
- [ ] All `<!-- GUIDE: ... -->` comments removed (if using `--with-skills`)
- [ ] All `{{PLACEHOLDER}}` markers replaced
- [ ] `role.md` has at least 5 principles (including the universal ones)
- [ ] `start` skill has 7 phases with approval gates at phases 2 and 3 (if present)
- [ ] `handoff` skill produces handoff notes with "What the Next Session Needs to Know" (if present)
- [ ] Tested the expert end-to-end: set up a project, run through at least the interview and brief skills

## Reference

For a deep-dive into the structural patterns, conventions, and the reasoning behind them, see [docs/workflow-anatomy.md](../docs/workflow-anatomy.md).

For examples of completed experts, look at:
- [project-manager/](../experts/technical/project-manager/) — Orchestrator and team lead
- [swe/](../experts/technical/swe/) — Software engineering
- [data-analyst/](../experts/technical/data-analyst/) — Time series data analysis
