# Cursor Target

Translation rules for generating Cursor configurations from platform-agnostic expert definitions.

Currently, the Cursor translation logic lives inline in `install.sh`. This directory is the future home for extracted, modular translation configs.

**Output paths:** `.cursor/rules/*-os.mdc`, `.cursor/commands/*.md`, `.cursor/rules/project-os.mdc`

## Skill Namespacing

Skills are installed with a short prefix to avoid filename collisions in the flat `.cursor/commands/` directory. Underscores in source filenames are normalized to hyphens.

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
