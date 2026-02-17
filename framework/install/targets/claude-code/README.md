# Claude Code Target

Translation rules for generating Claude Code configurations from platform-agnostic expert definitions.

Currently, the Claude Code translation logic lives inline in `install.sh`. This directory is the future home for extracted, modular translation configs.

**Output paths:** `.claude/roles/*.md`, `.claude/commands/*.md`, `.claude/CLAUDE.md`

## Skill Namespacing

Skills are installed with a short prefix to avoid filename collisions in the flat `.claude/commands/` directory. Underscores in source filenames are normalized to hyphens.

| Prefix | Expert | Example |
|--------|--------|---------|
| `pm-` | Project Manager | `/pm-interview`, `/pm-decompose` |
| `swe-` | SWE | `/swe-start`, `/swe-handoff` |
| `qa-` | QA | `/qa-review`, `/qa-test-plan` |
| `ops-` | DevOps | `/ops-deploy`, `/ops-pipeline` |
| `da-` | Data Analyst | `/da-start`, `/da-synthesize` |
| `ux-` | User Experience | `/ux-...` |
| `team-` | Shared | `/team-status` |

The prefix is applied by the install script during translation. Source skill files in `experts/` remain unprefixed and platform-agnostic.
