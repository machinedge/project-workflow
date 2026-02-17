# OpenClaw Target

Translation rules for generating OpenClaw container-based agent teams from platform-agnostic expert definitions.

## Generated Artifacts

The `install-team.sh` script generates a `.octeam/` directory in the target project with:

- `docker-compose.yml` — Conduit (Matrix), Element Web, OpenClaw gateway, per-expert containers
- `configs/<expert>/AGENTS.md` — translated from `role.md`
- `configs/<expert>/skills/<name>/SKILL.md` — skills with YAML frontmatter
- `configs/<expert>/tools/` — copied from expert tools
- `configs/<expert>/env` — per-expert environment overrides
- `configs/conduit/conduit.toml` — Matrix homeserver configuration
- `configs/element/config.json` — Element Web browser client configuration
- `scripts/expert-entrypoint.sh` — container startup (git clone, Matrix wait, agent start)
- `scripts/setup-matrix.sh` — one-shot Matrix user registration and room creation

## Translation Table

| Source | Destination | Transform |
|--------|-------------|-----------|
| `role.md` | `AGENTS.md` | Direct copy |
| `skills/<name>.md` | `skills/<name>/SKILL.md` | YAML frontmatter prepended (`name`, `description`) |
| `tools/*` | `tools/` | Direct copy (excluding `.gitkeep`) |
| `shared/skills/<name>.md` | `skills/team-<name>/SKILL.md` | Frontmatter + copied into every expert |

## Docker Compose Services

| Service | Image | Purpose |
|---------|-------|---------|
| `conduit` | `matrixconduit/matrix-conduit` | Matrix homeserver (Conduit, lightweight Rust-based) |
| `element-web` | `vectorim/element-web` | Browser UI for human interaction |
| `openclaw-gateway` | `alpine/openclaw` | Agent routing and coordination |
| `matrix-setup` | `curlimages/curl` | One-shot user/room setup |
| `<expert>` | `openclaw-sandbox:bookworm-slim` | One container per expert, own workspace |

## Usage

```bash
./framework/install/install-team.sh ~/myproject
cd ~/myproject/.octeam
# Edit .env with API keys and git URL
docker compose up -d
# Open http://localhost:8009 (Element Web)
```

**Status:** MVP. See `docs/overview.md` for the full team mode vision.
