#!/bin/bash

# MachinEdge Expert Teams — Install Team (Docker)
# Usage: ./install-team.sh [--experts pm,swe,qa,devops] [--domain technical] [--project-name NAME] [project-directory]
#
# Generates Docker infrastructure for running an expert team in containers.
# Creates a .octeam/ directory in the target project with docker-compose.yml,
# Matrix messaging (Conduit + Element Web), and per-expert configurations.
#
# Each expert runs in its own container based on the OpenClaw image, with
# its own git clone for true parallel work. The human interacts with the
# team through Element Web (Matrix client) in a browser.
#
# Expert short names are mapped to their full directory names:
#   pm → project-manager, swe → swe, qa → qa, devops → devops, data-analyst → data-analyst
#
# Examples:
#   ./install-team.sh ~/myproj                                  # All core experts, defaults
#   ./install-team.sh --experts pm,swe ~/myproj                 # Just PM and SWE
#   ./install-team.sh --project-name acme-app ~/myproj          # Custom project name

set -e

# ─────────────────────────────────────────────
# Resolve paths
# ─────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    _dir="$SCRIPT_DIR"
    while [ "$_dir" != "/" ]; do
        if [ -d "$_dir/.git" ] || [ -f "$_dir/SKILL.md" ]; then
            REPO_ROOT="$_dir"
            break
        fi
        _dir="$(dirname "$_dir")"
    done
fi
if [ -z "$REPO_ROOT" ]; then
    echo "Error: Could not find repository or skill root from $SCRIPT_DIR"
    exit 1
fi

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

EXPERT_LIST="project-manager,swe,qa,devops"
DOMAIN="technical"
PROJECT_NAME=""
TARGET="."

while [[ $# -gt 0 ]]; do
    case $1 in
        --experts|--workflows)
            EXPERT_LIST="$2"
            shift 2
            ;;
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

# Derive project name from target directory if not provided
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$(cd "$TARGET" && pwd)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g')
fi

OCTEAM_DIR="$TARGET/.octeam"

# ─────────────────────────────────────────────
# Map short names to full expert directory names
# ─────────────────────────────────────────────

resolve_expert_name() {
    local name="$1"
    case "$name" in
        pm|project-manager) echo "project-manager" ;;
        swe)                echo "swe" ;;
        qa)                 echo "qa" ;;
        devops)             echo "devops" ;;
        data-analyst|eda)   echo "data-analyst" ;;
        user-experience|ux) echo "user-experience" ;;
        *)                  echo "$name" ;;
    esac
}

# Parse and validate expert names
IFS=',' read -ra RAW_EXPERTS <<< "$EXPERT_LIST"
EXPERTS=()
for raw in "${RAW_EXPERTS[@]}"; do
    raw=$(echo "$raw" | tr -d ' ')
    resolved=$(resolve_expert_name "$raw")
    EXPERT_DIR="$REPO_ROOT/experts/$DOMAIN/$resolved"
    if [ ! -d "$EXPERT_DIR" ]; then
        echo "Error: Expert '$raw' (resolved to '$resolved') not found at $EXPERT_DIR"
        exit 1
    fi
    EXPERTS+=("$resolved")
done

# ─────────────────────────────────────────────
# Prerequisite checks
# ─────────────────────────────────────────────

if ! command -v docker &>/dev/null; then
    echo "Error: docker is not installed or not in PATH"
    echo "  Install it: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker compose version &>/dev/null; then
    echo "Error: docker compose plugin is not available"
    echo "  Install it: https://docs.docker.com/compose/install/"
    exit 1
fi

# ─────────────────────────────────────────────
# Status banner
# ─────────────────────────────────────────────

echo "Setting up expert team (Docker) in: $TARGET/.octeam/"
echo "  Project name: $PROJECT_NAME"
echo "  Experts: ${EXPERTS[*]}"
echo "  Domain: $DOMAIN"
echo ""

# ─────────────────────────────────────────────
# Create directory structure
# ─────────────────────────────────────────────

mkdir -p "$OCTEAM_DIR/configs/conduit"
mkdir -p "$OCTEAM_DIR/configs/element"
mkdir -p "$OCTEAM_DIR/scripts"
mkdir -p "$OCTEAM_DIR/data"

for expert in "${EXPERTS[@]}"; do
    mkdir -p "$OCTEAM_DIR/configs/$expert/skills"
    mkdir -p "$OCTEAM_DIR/configs/$expert/tools"
done

# ─────────────────────────────────────────────
# Generate .gitignore
# ─────────────────────────────────────────────

cat > "$OCTEAM_DIR/.gitignore" << 'GITIGNORE_EOF'
# Runtime data (volumes, databases, logs)
data/

# Sensitive configuration
.env

# Docker runtime
*.log
GITIGNORE_EOF
echo "  Generated .gitignore"

# ─────────────────────────────────────────────
# Generate .env template
# Only created if not already present (preserves user edits)
# ─────────────────────────────────────────────

if [ ! -f "$OCTEAM_DIR/.env" ]; then
    cat > "$OCTEAM_DIR/.env" << ENV_EOF
# ─────────────────────────────────────────────
# MachinEdge Expert Teams — Environment
# ─────────────────────────────────────────────
# Edit this file with your project-specific values.
# This file is gitignored and will not be overwritten by re-running install-team.sh.

# ── LLM Configuration ──

# Required: API key for the LLM provider
OPENAI_API_KEY=sk-your-key-here

# Model to use (default: gpt-4o)
LLM_MODEL=gpt-4o

# API base URL (change for local/alternative providers)
LLM_API_BASE=https://api.openai.com/v1

# ── Git Configuration ──

# Repository URL for the project (experts clone this into their workspaces)
GIT_REPO_URL=

# Auth token for git operations (shared across all experts)
GIT_TOKEN=

# Git identity for expert commits
GIT_USER_NAME=machinedge-team
GIT_USER_EMAIL=team@machinedge.local

# ── Docker Configuration ──

# Project name (used to namespace containers, networks, volumes)
COMPOSE_PROJECT_NAME=${PROJECT_NAME}

# ── Matrix Configuration ──

# Matrix homeserver domain (changing this after first start requires wiping data/)
MATRIX_SERVER_NAME=${PROJECT_NAME}.local

# Admin password for the Matrix homeserver
MATRIX_ADMIN_PASSWORD=admin-changeme

# ── Port Configuration ──

# Conduit Matrix homeserver (must match configs/element/config.json)
CONDUIT_PORT=6167

# Element Web browser UI
ELEMENT_PORT=8009

# OpenClaw gateway control UI
OPENCLAW_PORT=18789

# ── Image Configuration (override to use custom images) ──

OPENCLAW_IMAGE=alpine/openclaw
OPENCLAW_SANDBOX_IMAGE=openclaw-sandbox:bookworm-slim
ENV_EOF
    echo "  Created .env template (edit with your API keys and git URL)"
else
    echo "  .env already exists, preserving"
fi

# ─────────────────────────────────────────────
# Generate Conduit (Matrix homeserver) config
# ─────────────────────────────────────────────

cat > "$OCTEAM_DIR/configs/conduit/conduit.toml" << CONDUIT_EOF
[global]
server_name = "${PROJECT_NAME}.local"
database_backend = "rocksdb"
database_path = "/var/lib/matrix-conduit/"
port = 6167
address = "0.0.0.0"

max_request_size = 20_000_000
allow_registration = true
registration_token = ""
allow_federation = false
allow_check_for_updates = false
enable_lightning_bolt = false

trusted_servers = []
log = "warn"
CONDUIT_EOF
echo "  Generated configs/conduit/conduit.toml"

# ─────────────────────────────────────────────
# Generate Element Web config
# Note: base_url uses localhost because this config is read by the
# user's browser, not by a container. If you change CONDUIT_PORT
# in .env, update the port here too and re-run install-team.sh.
# ─────────────────────────────────────────────

cat > "$OCTEAM_DIR/configs/element/config.json" << ELEMENT_EOF
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "http://localhost:6167",
            "server_name": "${PROJECT_NAME}.local"
        }
    },
    "brand": "MachinEdge Team: ${PROJECT_NAME}",
    "integrations_ui_url": "",
    "integrations_rest_url": "",
    "integrations_widgets_urls": [],
    "disable_custom_urls": true,
    "disable_guests": true,
    "disable_login_language_selector": true,
    "disable_3pid_login": true,
    "default_theme": "dark",
    "room_directory": {
        "servers": []
    },
    "features": {
        "feature_video_rooms": false
    },
    "setting_defaults": {
        "breadcrumbs": true
    }
}
ELEMENT_EOF
echo "  Generated configs/element/config.json"

# ─────────────────────────────────────────────
# Translate expert definitions to OpenClaw format
# ─────────────────────────────────────────────

for expert in "${EXPERTS[@]}"; do
    EXPERT_SRC="$REPO_ROOT/experts/$DOMAIN/$expert"
    echo "  [$expert] Translating expert definition..."

    # role.md → AGENTS.md (injected as the agent's system prompt)
    if [ -f "$EXPERT_SRC/role.md" ]; then
        cp "$EXPERT_SRC/role.md" "$OCTEAM_DIR/configs/$expert/AGENTS.md"
        echo "    role.md -> AGENTS.md"
    fi

    # skills/*.md → skills/<name>/SKILL.md (with YAML frontmatter)
    if [ -d "$EXPERT_SRC/skills" ]; then
        SKILL_COUNT=0
        for skill_file in "$EXPERT_SRC"/skills/*.md; do
            if [ -f "$skill_file" ]; then
                skill_name=$(basename "$skill_file" .md)
                skill_dir="$OCTEAM_DIR/configs/$expert/skills/$skill_name"
                mkdir -p "$skill_dir"

                # Extract description from first heading
                skill_desc=$(head -1 "$skill_file" | sed 's/^#\s*//')

                # Generate SKILL.md with YAML frontmatter
                {
                    printf '%s\n' "---"
                    printf 'name: %s\n' "$skill_name"
                    printf 'description: "%s"\n' "$skill_desc"
                    printf '%s\n' "---"
                    printf '\n'
                    cat "$skill_file"
                } > "$skill_dir/SKILL.md"

                SKILL_COUNT=$((SKILL_COUNT + 1))
            fi
        done
        if [ "$SKILL_COUNT" -gt 0 ]; then
            echo "    $SKILL_COUNT skill(s) translated"
        fi
    fi

    # tools/ → tools/ (copy directly, skip .gitkeep)
    if [ -d "$EXPERT_SRC/tools" ]; then
        TOOL_COUNT=$(find "$EXPERT_SRC/tools" -type f ! -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$TOOL_COUNT" -gt 0 ]; then
            find "$EXPERT_SRC/tools" -type f ! -name ".gitkeep" -exec cp {} "$OCTEAM_DIR/configs/$expert/tools/" \;
            echo "    $TOOL_COUNT tool(s) copied"
        fi
    fi

    # Per-expert env overrides (create template if not exists)
    if [ ! -f "$OCTEAM_DIR/configs/$expert/env" ]; then
        cat > "$OCTEAM_DIR/configs/$expert/env" << EXPERT_ENV_EOF
# Per-expert environment overrides for: $expert
# These override the project-level .env values for this expert only.
# Uncomment and modify as needed.

# LLM_MODEL=
# OPENAI_API_KEY=
EXPERT_ENV_EOF
    fi
done

# ─────────────────────────────────────────────
# Translate shared skills (copied into every expert)
# ─────────────────────────────────────────────

SHARED_DIR="$REPO_ROOT/experts/$DOMAIN/shared"
if [ -d "$SHARED_DIR/skills" ]; then
    echo ""
    echo "  [shared] Translating shared skills..."
    SHARED_COUNT=0
    for skill_file in "$SHARED_DIR"/skills/*.md; do
        if [ -f "$skill_file" ]; then
            skill_name="team-$(basename "$skill_file" .md)"
            skill_desc=$(head -1 "$skill_file" | sed 's/^#\s*//')

            for expert in "${EXPERTS[@]}"; do
                skill_dir="$OCTEAM_DIR/configs/$expert/skills/$skill_name"
                mkdir -p "$skill_dir"
                {
                    printf '%s\n' "---"
                    printf 'name: %s\n' "$skill_name"
                    printf 'description: "%s"\n' "$skill_desc"
                    printf '%s\n' "---"
                    printf '\n'
                    cat "$skill_file"
                } > "$skill_dir/SKILL.md"
            done
            SHARED_COUNT=$((SHARED_COUNT + 1))
        fi
    done
    if [ "$SHARED_COUNT" -gt 0 ]; then
        echo "    $SHARED_COUNT shared skill(s) → all experts"
    fi
fi

# ─────────────────────────────────────────────
# Generate expert-entrypoint.sh
# Runs inside each expert container at startup
# ─────────────────────────────────────────────

cat > "$OCTEAM_DIR/scripts/expert-entrypoint.sh" << 'ENTRYPOINT_EOF'
#!/bin/bash
set -e

# MachinEdge Expert Teams — Expert Entrypoint
# Runs inside each expert's Docker container at startup.
# 1. Clones the project repo (or pulls if already cloned)
# 2. Creates the shared docs/issues structure
# 3. Waits for the Matrix homeserver to be available
# 4. Hands off to the container command

EXPERT_NAME="${EXPERT_NAME:?EXPERT_NAME environment variable not set}"
WORKSPACE="/workspace"

echo "[$EXPERT_NAME] Starting expert container..."

# ── Git clone or pull ──
if [ -n "$GIT_REPO_URL" ]; then
    if [ ! -d "$WORKSPACE/.git" ]; then
        echo "[$EXPERT_NAME] Cloning repository..."
        if [ -n "$GIT_TOKEN" ]; then
            AUTH_URL=$(echo "$GIT_REPO_URL" | sed "s|https://|https://oauth2:${GIT_TOKEN}@|")
            git clone "$AUTH_URL" "$WORKSPACE"
        else
            git clone "$GIT_REPO_URL" "$WORKSPACE"
        fi
    else
        echo "[$EXPERT_NAME] Repository already cloned, pulling latest..."
        cd "$WORKSPACE"
        git pull --ff-only || echo "[$EXPERT_NAME] Warning: pull failed, continuing with existing state"
    fi
    cd "$WORKSPACE"
    git config user.name "${GIT_USER_NAME:-machinedge-$EXPERT_NAME}"
    git config user.email "${GIT_USER_EMAIL:-$EXPERT_NAME@machinedge.local}"
else
    echo "[$EXPERT_NAME] No GIT_REPO_URL set, using empty workspace"
    mkdir -p "$WORKSPACE"
fi

# ── Ensure docs/issues structure exists ──
mkdir -p "$WORKSPACE/docs/handoff-notes/$EXPERT_NAME"
mkdir -p "$WORKSPACE/issues"

# ── Log agent config location ──
AGENT_DIR="/agent"
if [ -d "$AGENT_DIR" ]; then
    echo "[$EXPERT_NAME] Agent config mounted at $AGENT_DIR"
    if [ -f "$AGENT_DIR/AGENTS.md" ]; then
        echo "[$EXPERT_NAME] AGENTS.md loaded"
    fi
fi

# ── Wait for Matrix homeserver ──
echo "[$EXPERT_NAME] Waiting for Matrix homeserver..."
CONDUIT_URL="${CONDUIT_URL:-http://conduit:6167}"
for i in $(seq 1 30); do
    if curl -sf "${CONDUIT_URL}/_matrix/client/versions" > /dev/null 2>&1; then
        echo "[$EXPERT_NAME] Matrix homeserver is ready"
        break
    fi
    if [ "$i" -eq 30 ]; then
        echo "[$EXPERT_NAME] Warning: Matrix homeserver not reachable after 30s, continuing anyway"
    fi
    sleep 1
done

# ── Hand off to container command ──
echo "[$EXPERT_NAME] Ready."
exec "$@"
ENTRYPOINT_EOF
chmod +x "$OCTEAM_DIR/scripts/expert-entrypoint.sh"
echo ""
echo "  Generated scripts/expert-entrypoint.sh"

# ─────────────────────────────────────────────
# Generate setup-matrix.sh
# One-shot script to register Matrix users and create rooms
# ─────────────────────────────────────────────

cat > "$OCTEAM_DIR/scripts/setup-matrix.sh" << 'MATRIX_EOF'
#!/bin/bash
set -e

# MachinEdge Expert Teams — Matrix Setup
# Runs once after docker compose up to:
# 1. Register Matrix users for each expert
# 2. Create the project coordination room
# 3. Invite all experts to the room

CONDUIT_URL="${CONDUIT_URL:-http://conduit:6167}"
ADMIN_USER="admin"
ADMIN_PASSWORD="${MATRIX_ADMIN_PASSWORD:-admin-changeme}"
SERVER_NAME="${MATRIX_SERVER_NAME:-project.local}"
PROJECT_ROOM_ALIAS="project"

echo "Matrix Setup: Configuring team communication..."
echo "  Homeserver: $CONDUIT_URL"
echo "  Server name: $SERVER_NAME"
echo ""

# ── Wait for Conduit to be ready ──
echo "  Waiting for Matrix homeserver..."
for i in $(seq 1 60); do
    if curl -sf "${CONDUIT_URL}/_matrix/client/versions" > /dev/null 2>&1; then
        echo "  Matrix homeserver is ready"
        break
    fi
    if [ "$i" -eq 60 ]; then
        echo "  Error: Matrix homeserver not reachable after 60s"
        exit 1
    fi
    sleep 1
done

# ── Helper: register a Matrix user ──
register_user() {
    local username="$1"
    local password="$2"

    echo "  Registering user: $username"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST "${CONDUIT_URL}/_matrix/client/v3/register" \
        -H "Content-Type: application/json" \
        -d "{
            \"username\": \"${username}\",
            \"password\": \"${password}\",
            \"auth\": {\"type\": \"m.login.dummy\"},
            \"inhibit_login\": true
        }" 2>/dev/null)

    if [ "$HTTP_CODE" = "200" ]; then
        echo "    Registered: @${username}:${SERVER_NAME}"
    elif [ "$HTTP_CODE" = "400" ]; then
        echo "    Already exists: @${username}:${SERVER_NAME}"
    else
        echo "    Warning: registration returned HTTP $HTTP_CODE"
    fi
}

# ── Helper: login and get access token ──
get_token() {
    local username="$1"
    local password="$2"

    curl -s -X POST "${CONDUIT_URL}/_matrix/client/v3/login" \
        -H "Content-Type: application/json" \
        -d "{
            \"type\": \"m.login.password\",
            \"identifier\": {\"type\": \"m.id.user\", \"user\": \"${username}\"},
            \"password\": \"${password}\"
        }" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4
}

# ── Register admin user ──
register_user "$ADMIN_USER" "$ADMIN_PASSWORD"

# ── Register expert users ──
IFS=',' read -ra EXPERTS <<< "${EXPERT_LIST:-project-manager,swe,qa,devops}"
for expert in "${EXPERTS[@]}"; do
    expert=$(echo "$expert" | tr -d ' ')
    register_user "$expert" "${expert}-agent"
done

# ── Login as admin and create the project room ──
echo ""
echo "  Creating project room..."
ADMIN_TOKEN=$(get_token "$ADMIN_USER" "$ADMIN_PASSWORD")
if [ -z "$ADMIN_TOKEN" ]; then
    echo "  Error: Failed to get admin token. Room creation skipped."
    echo "  You may need to re-run: docker compose run --rm matrix-setup"
    exit 1
fi

ROOM_RESPONSE=$(curl -s -X POST "${CONDUIT_URL}/_matrix/client/v3/createRoom" \
    -H "Authorization: Bearer $ADMIN_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
        \"room_alias_name\": \"${PROJECT_ROOM_ALIAS}\",
        \"name\": \"Project: ${SERVER_NAME}\",
        \"topic\": \"MachinEdge Expert Team coordination room\",
        \"visibility\": \"private\",
        \"preset\": \"private_chat\"
    }")

ROOM_ID=$(echo "$ROOM_RESPONSE" | grep -o '"room_id":"[^"]*"' | cut -d'"' -f4)

if [ -n "$ROOM_ID" ]; then
    echo "    Room created: $ROOM_ID"
else
    echo "    Room may already exist, looking it up..."
    ROOM_ID=$(curl -s \
        "${CONDUIT_URL}/_matrix/client/v3/directory/room/%23${PROJECT_ROOM_ALIAS}:${SERVER_NAME}" \
        -H "Authorization: Bearer $ADMIN_TOKEN" | grep -o '"room_id":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$ROOM_ID" ]; then
        echo "    Found room: $ROOM_ID"
    else
        echo "    Warning: Could not create or find room"
    fi
fi

# ── Invite all experts to the room ──
if [ -n "$ROOM_ID" ]; then
    echo ""
    echo "  Inviting experts to project room..."
    for expert in "${EXPERTS[@]}"; do
        expert=$(echo "$expert" | tr -d ' ')

        # Invite
        curl -s -o /dev/null -X POST \
            "${CONDUIT_URL}/_matrix/client/v3/rooms/${ROOM_ID}/invite" \
            -H "Authorization: Bearer $ADMIN_TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"user_id\": \"@${expert}:${SERVER_NAME}\"}"

        # Auto-join as the expert
        EXPERT_TOKEN=$(get_token "$expert" "${expert}-agent")
        if [ -n "$EXPERT_TOKEN" ]; then
            curl -s -o /dev/null -X POST \
                "${CONDUIT_URL}/_matrix/client/v3/join/${ROOM_ID}" \
                -H "Authorization: Bearer $EXPERT_TOKEN"
            echo "    Invited and joined: @${expert}:${SERVER_NAME}"
        else
            echo "    Warning: Could not login as $expert to auto-join"
        fi
    done
fi

echo ""
echo "Matrix setup complete!"
echo "  Project room: #${PROJECT_ROOM_ALIAS}:${SERVER_NAME}"
echo "  Connect with Element at: http://localhost:${ELEMENT_PORT:-8009}"
echo ""
echo "  Login as 'admin' with your MATRIX_ADMIN_PASSWORD to interact with the team."
MATRIX_EOF
chmod +x "$OCTEAM_DIR/scripts/setup-matrix.sh"
echo "  Generated scripts/setup-matrix.sh"

# ─────────────────────────────────────────────
# Generate docker-compose.yml
# ─────────────────────────────────────────────

# Build expert service blocks dynamically
EXPERT_SERVICES=""
EXPERT_VOLUMES=""
EXPERT_LIST_CSV=""

for expert in "${EXPERTS[@]}"; do
    if [ -n "$EXPERT_LIST_CSV" ]; then
        EXPERT_LIST_CSV="$EXPERT_LIST_CSV,$expert"
    else
        EXPERT_LIST_CSV="$expert"
    fi

    EXPERT_SERVICES="$EXPERT_SERVICES
  ${expert}:
    image: \${OPENCLAW_SANDBOX_IMAGE:-openclaw-sandbox:bookworm-slim}
    container_name: \${COMPOSE_PROJECT_NAME}-${expert}
    entrypoint: [\"/bin/bash\", \"/scripts/expert-entrypoint.sh\"]
    command: [\"sleep\", \"infinity\"]
    environment:
      - EXPERT_NAME=${expert}
      - OPENAI_API_KEY=\${OPENAI_API_KEY}
      - LLM_MODEL=\${LLM_MODEL:-gpt-4o}
      - LLM_API_BASE=\${LLM_API_BASE:-https://api.openai.com/v1}
      - GIT_REPO_URL=\${GIT_REPO_URL}
      - GIT_TOKEN=\${GIT_TOKEN}
      - GIT_USER_NAME=\${GIT_USER_NAME:-machinedge-team}
      - GIT_USER_EMAIL=\${GIT_USER_EMAIL:-team@machinedge.local}
      - CONDUIT_URL=http://conduit:6167
      - MATRIX_SERVER_NAME=\${MATRIX_SERVER_NAME}
    volumes:
      - ${expert}-workspace:/workspace
      - ./configs/${expert}:/agent:ro
      - ./scripts:/scripts:ro
    networks:
      - octeam
    depends_on:
      conduit:
        condition: service_healthy
    restart: unless-stopped
    env_file:
      - .env
      - ./configs/${expert}/env"

    EXPERT_VOLUMES="$EXPERT_VOLUMES
  ${expert}-workspace:"
done

cat > "$OCTEAM_DIR/docker-compose.yml" << COMPOSE_EOF
# MachinEdge Expert Teams — Docker Compose
# Generated by install-team.sh — re-run to regenerate.
#
# Usage:
#   docker compose up -d          # Start the team
#   docker compose logs -f        # Watch all logs
#   docker compose down           # Stop the team
#   docker compose down -v        # Stop and remove all data

services:

  # ─────────────────────────────────────────────
  # Matrix Homeserver (Conduit)
  # Lightweight Rust-based homeserver for inter-expert communication
  # ─────────────────────────────────────────────
  conduit:
    image: matrixconduit/matrix-conduit:latest
    container_name: \${COMPOSE_PROJECT_NAME}-conduit
    volumes:
      - conduit-data:/var/lib/matrix-conduit
      - ./configs/conduit/conduit.toml:/etc/conduit/conduit.toml:ro
    environment:
      - CONDUIT_CONFIG=/etc/conduit/conduit.toml
    ports:
      - "\${CONDUIT_PORT:-6167}:6167"
    networks:
      - octeam
    healthcheck:
      test: ["CMD-SHELL", "curl -sf http://localhost:6167/_matrix/client/versions || exit 1"]
      interval: 5s
      timeout: 3s
      retries: 10
      start_period: 5s
    restart: unless-stopped

  # ─────────────────────────────────────────────
  # Element Web (Human Interface)
  # Browser-based Matrix client for interacting with the team
  # Open http://localhost:\${ELEMENT_PORT} in your browser
  # ─────────────────────────────────────────────
  element-web:
    image: vectorim/element-web:latest
    container_name: \${COMPOSE_PROJECT_NAME}-element
    volumes:
      - ./configs/element/config.json:/app/config.json:ro
    ports:
      - "\${ELEMENT_PORT:-8009}:80"
    networks:
      - octeam
    depends_on:
      conduit:
        condition: service_healthy
    restart: unless-stopped

  # ─────────────────────────────────────────────
  # OpenClaw Gateway
  # Agent routing, tool execution, and multi-agent coordination
  # ─────────────────────────────────────────────
  openclaw-gateway:
    image: \${OPENCLAW_IMAGE:-alpine/openclaw}
    container_name: \${COMPOSE_PROJECT_NAME}-gateway
    ports:
      - "\${OPENCLAW_PORT:-18789}:18789"
    volumes:
      - openclaw-config:/home/node/.openclaw
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - OPENAI_API_KEY=\${OPENAI_API_KEY}
    networks:
      - octeam
    depends_on:
      conduit:
        condition: service_healthy
    restart: unless-stopped

  # ─────────────────────────────────────────────
  # Matrix Setup (one-shot)
  # Registers users and creates rooms, then exits
  # Re-run: docker compose run --rm matrix-setup
  # ─────────────────────────────────────────────
  matrix-setup:
    image: curlimages/curl:latest
    container_name: \${COMPOSE_PROJECT_NAME}-matrix-setup
    entrypoint: ["/bin/sh", "-c"]
    command:
      - |
        apk add --no-cache bash > /dev/null 2>&1
        bash /scripts/setup-matrix.sh
    volumes:
      - ./scripts:/scripts:ro
    environment:
      - CONDUIT_URL=http://conduit:6167
      - MATRIX_SERVER_NAME=\${MATRIX_SERVER_NAME}
      - MATRIX_ADMIN_PASSWORD=\${MATRIX_ADMIN_PASSWORD:-admin-changeme}
      - EXPERT_LIST=${EXPERT_LIST_CSV}
      - ELEMENT_PORT=\${ELEMENT_PORT:-8009}
    networks:
      - octeam
    depends_on:
      conduit:
        condition: service_healthy
    restart: "no"

  # ─────────────────────────────────────────────
  # Expert Containers
  # One container per expert, each with its own workspace clone
  # ─────────────────────────────────────────────
$(echo -e "$EXPERT_SERVICES")

networks:
  octeam:
    name: \${COMPOSE_PROJECT_NAME}-network

volumes:
  conduit-data:
  openclaw-config:$(echo -e "$EXPERT_VOLUMES")
COMPOSE_EOF
echo ""
echo "  Generated docker-compose.yml"

# ─────────────────────────────────────────────
# Create shared project docs structure
# ─────────────────────────────────────────────

mkdir -p "$TARGET/docs/handoff-notes"
mkdir -p "$TARGET/issues"

if [ ! -f "$TARGET/docs/lessons-log.md" ]; then
cat > "$TARGET/docs/lessons-log.md" << 'DOC_EOF'
# Lessons Log

Record project-specific gotchas, patterns, and knowledge here. Future sessions will read this to avoid repeating mistakes.

| Date | Lesson | Context |
|------|--------|---------|
DOC_EOF
fi

for expert in "${EXPERTS[@]}"; do
    mkdir -p "$TARGET/docs/handoff-notes/$expert"
done

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Team infrastructure generated:"
echo ""
find "$OCTEAM_DIR" -type f 2>/dev/null | sort | while read f; do
    echo "  $f"
done
echo ""
echo "Next steps:"
echo "  1. Edit .octeam/.env with your API keys and git URL"
echo "  2. cd $TARGET/.octeam"
echo "  3. docker compose up -d"
echo "  4. Wait for all services to start (~30 seconds)"
echo "  5. Open http://localhost:8009 in your browser (Element Web)"
echo "  6. Login as 'admin' with the password from .env (MATRIX_ADMIN_PASSWORD)"
echo "  7. Join the #project room to interact with your expert team"
echo ""
echo "Useful commands:"
echo "  docker compose ps                        # Show running containers"
echo "  docker compose logs -f                   # Watch all logs"
echo "  docker compose logs -f project-manager   # Watch PM logs"
echo "  docker compose run --rm matrix-setup     # Re-run Matrix setup"
echo "  docker compose down                      # Stop the team"
echo "  docker compose down -v                   # Stop and remove all data"
echo ""
