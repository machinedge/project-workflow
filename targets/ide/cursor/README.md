# Cursor Target

Platform-native implementation of MachinEdge Expert Teams for Cursor. Files in this directory are pre-built and installed to the user's project via direct copy — no translation or generation step.

## File Categories

| Category | Source Path | Install Path | Count |
|----------|-------------|--------------|-------|
| Rules | `rules/*.mdc` | `.cursor/rules/` | 6 |
| Commands | `commands/*.md` | `.cursor/commands/` | 9 |
| Skills | `skills/*/SKILL.md` | `.cursor/skills/` | 21 |
| Scripts | `scripts/*` | `.cursor/scripts/` | 9 |

## Skill Namespacing

Skills and commands use a short prefix to identify the expert workflow. Prefixes match the executor, not the finder.

| Prefix | Expert | Examples |
|--------|--------|---------|
| `pm-` | Project Manager | `pm-start`, `pm-interview`, `pm-vision` |
| `swe-` | SWE | `swe-start`, `swe-handoff` |
| `qa-` | QA | `qa-start`, `qa-review`, `qa-test-plan` |
| `ops-` | DevOps | `ops-start`, `ops-deploy`, `ops-pipeline` |
| `sa-` | System Architect | `sa-start`, `sa-design`, `sa-research` |
| `team-` | Shared (cross-expert) | `team-status` |

## Platform-Specific Details

- **Rules** use `.mdc` format with YAML frontmatter (`alwaysApply: true`). `project-os.mdc` is loaded on every message; expert role rules are always-applied but only one is relevant per session.
- **Commands** are explicit workflows invoked by the user (e.g., `/swe-start`). Used for interactive processes and approval-gated operations.
- **Skills** are discoverable by the agent via YAML frontmatter (`name`, `description`). The agent invokes them autonomously when the description matches the user's intent.
- **Scripts** are hidden shell utilities for mechanical operations (issue numbering, file movement, session claiming). Referenced by skills and commands but not user-facing.
