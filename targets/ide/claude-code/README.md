# Claude Code Target

Platform-native implementation of MachinEdge Expert Teams for Claude Code. Files in this directory are pre-built and installed to the user's project via direct copy — no translation or generation step.

## File Categories

| Category | Source Path | Install Path | Count |
|----------|-------------|--------------|-------|
| Roles | `roles/*.md` | `.claude/roles/` | 5 |
| Commands | `commands/*.md` | `.claude/commands/` | 9 |
| Skills | `skills/*/SKILL.md` | `.claude/skills/` | 21 |
| Scripts | `scripts/*` | `.claude/scripts/` | 9 |
| CLAUDE.md | `CLAUDE.md` | `.claude/CLAUDE.md` | 1 |
| Settings | `settings.json` | `.claude/settings.json` | 1 |

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

- **Roles** are plain markdown files loaded conditionally when the user selects an expert. `CLAUDE.md` provides shared principles and expert routing (always loaded).
- **Commands** are explicit workflows invoked by the user (e.g., `/swe-start`). Used for interactive processes and approval-gated operations.
- **Skills** are discoverable by the agent via YAML frontmatter (`name`, `description`). The agent invokes them autonomously when the description matches the user's intent.
- **Scripts** are hidden shell utilities for mechanical operations (issue numbering, file movement, session claiming). Referenced by skills and commands but not user-facing.
- **settings.json** defines the `SessionStart` hook, which runs `session-primer.sh` to extract raw project context at the start of each session.
- **session-primer.sh** is a raw content extractor (not a summarizer). It extracts project identity, current status, and the most recent handoff note for the agent to process.
