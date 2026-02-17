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
