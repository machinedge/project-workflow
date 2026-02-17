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
