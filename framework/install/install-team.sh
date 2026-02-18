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
# Skill root is two levels up from framework/install/
SKILL_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ ! -d "$SKILL_ROOT/experts" ]; then
    echo "Error: Could not find experts/ directory at $SKILL_ROOT/experts"
    echo "  Expected script location: <skill-root>/framework/install/"
    exit 1
fi

TEMPLATE_DIR="$SCRIPT_DIR/templates/team"
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Template directory not found at $TEMPLATE_DIR"
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
    EXPERT_DIR="$SKILL_ROOT/experts/$DOMAIN/$resolved"
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
# Auto-detect git configuration
# ─────────────────────────────────────────────

DETECTED_GIT_REPO_URL=""
DETECTED_GIT_USER_NAME=""
DETECTED_GIT_USER_EMAIL=""

if git -C "$TARGET" rev-parse --is-inside-work-tree &>/dev/null; then
    # Repository URL (convert SSH to HTTPS for token-based auth in containers)
    DETECTED_GIT_REPO_URL=$(git -C "$TARGET" remote get-url origin 2>/dev/null || echo "")
    if [[ "$DETECTED_GIT_REPO_URL" =~ ^git@([^:]+):(.+)$ ]]; then
        DETECTED_GIT_REPO_URL="https://${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
    fi
    DETECTED_GIT_REPO_URL="${DETECTED_GIT_REPO_URL%.git}"

    # Git identity
    DETECTED_GIT_USER_NAME=$(git -C "$TARGET" config user.name 2>/dev/null || echo "")
    DETECTED_GIT_USER_EMAIL=$(git -C "$TARGET" config user.email 2>/dev/null || echo "")

    echo "Git configuration detected:"
    [ -n "$DETECTED_GIT_REPO_URL" ]   && echo "  Repo URL:   $DETECTED_GIT_REPO_URL"
    [ -n "$DETECTED_GIT_USER_NAME" ]  && echo "  User name:  $DETECTED_GIT_USER_NAME"
    [ -n "$DETECTED_GIT_USER_EMAIL" ] && echo "  User email: $DETECTED_GIT_USER_EMAIL"
    echo ""
else
    echo "Not a git repository — git fields in .env will need manual configuration."
    echo ""
fi

# Check for GIT_TOKEN in environment
if [ -z "$GIT_TOKEN" ]; then
    echo "Note: GIT_TOKEN is not set in your environment."
    echo "  For private repos, export it before running docker compose:"
    echo "    export GIT_TOKEN=\$(gh auth token)   # GitHub CLI"
    echo "    export GIT_TOKEN=ghp_your-token      # or set directly"
    echo ""
fi

# Fall back to defaults for user name/email if not detected
GIT_REPO_URL_VALUE="${DETECTED_GIT_REPO_URL}"
GIT_USER_NAME_VALUE="${DETECTED_GIT_USER_NAME:-machinedge-team}"
GIT_USER_EMAIL_VALUE="${DETECTED_GIT_USER_EMAIL:-team@machinedge.local}"

# ─────────────────────────────────────────────
# Template helpers
# ─────────────────────────────────────────────

# Replace template placeholders in a file and write to destination
render_simple_template() {
    local template="$1"
    local output="$2"
    sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{GIT_REPO_URL}}|$GIT_REPO_URL_VALUE|g" \
        -e "s|{{GIT_USER_NAME}}|$GIT_USER_NAME_VALUE|g" \
        -e "s|{{GIT_USER_EMAIL}}|$GIT_USER_EMAIL_VALUE|g" \
        "$template" > "$output"
}

# Replace {{EXPERT_NAME}} in a template file and write to destination
render_expert_template() {
    local template="$1"
    local output="$2"
    local expert_name="$3"
    sed "s/{{EXPERT_NAME}}/$expert_name/g" "$template" > "$output"
}

# Render docker-compose.yml template with dynamic expert blocks
render_compose_template() {
    local template="$1"
    local output="$2"
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == *'{{EXPERT_SERVICES}}'* ]]; then
            printf '%s\n' "$EXPERT_SERVICES"
        elif [[ "$line" == *'{{EXPERT_VOLUMES}}'* ]]; then
            printf '%s\n' "$EXPERT_VOLUMES"
        elif [[ "$line" == *'{{EXPERT_LIST_CSV}}'* ]]; then
            printf '%s\n' "${line//\{\{EXPERT_LIST_CSV\}\}/$EXPERT_LIST_CSV}"
        else
            printf '%s\n' "$line"
        fi
    done < "$template" > "$output"
}

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
# Generate static and templated config files
# ─────────────────────────────────────────────

cp "$TEMPLATE_DIR/gitignore" "$OCTEAM_DIR/.gitignore"
echo "  Generated .gitignore"

if [ ! -f "$OCTEAM_DIR/.env" ]; then
    render_simple_template "$TEMPLATE_DIR/env.template" "$OCTEAM_DIR/.env"
    if [ -n "$DETECTED_GIT_REPO_URL" ]; then
        echo "  Created .env (git config auto-detected — review and add your API key)"
    else
        echo "  Created .env template (edit with your API keys and git URL)"
    fi
else
    echo "  .env already exists, preserving"
fi

render_simple_template "$TEMPLATE_DIR/conduit.toml.template" "$OCTEAM_DIR/configs/conduit/conduit.toml"
echo "  Generated configs/conduit/conduit.toml"

render_simple_template "$TEMPLATE_DIR/element-config.json.template" "$OCTEAM_DIR/configs/element/config.json"
echo "  Generated configs/element/config.json"

# ─────────────────────────────────────────────
# Translate expert definitions to OpenClaw format
# ─────────────────────────────────────────────

for expert in "${EXPERTS[@]}"; do
    EXPERT_SRC="$SKILL_ROOT/experts/$DOMAIN/$expert"
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
        render_expert_template "$TEMPLATE_DIR/expert-env.template" "$OCTEAM_DIR/configs/$expert/env" "$expert"
    fi
done

# ─────────────────────────────────────────────
# Translate shared skills (copied into every expert)
# ─────────────────────────────────────────────

SHARED_DIR="$SKILL_ROOT/experts/$DOMAIN/shared"
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
# Generate runtime scripts from templates
# ─────────────────────────────────────────────

cp "$TEMPLATE_DIR/expert-entrypoint.sh" "$OCTEAM_DIR/scripts/expert-entrypoint.sh"
chmod +x "$OCTEAM_DIR/scripts/expert-entrypoint.sh"
echo ""
echo "  Generated scripts/expert-entrypoint.sh"

cp "$TEMPLATE_DIR/setup-matrix.sh" "$OCTEAM_DIR/scripts/setup-matrix.sh"
chmod +x "$OCTEAM_DIR/scripts/setup-matrix.sh"
echo "  Generated scripts/setup-matrix.sh"

# ─────────────────────────────────────────────
# Generate docker-compose.yml from template
# ─────────────────────────────────────────────

# Build expert service blocks from per-expert template
EXPERT_SERVICES=""
EXPERT_VOLUMES=""
EXPERT_LIST_CSV=""

for expert in "${EXPERTS[@]}"; do
    if [ -n "$EXPERT_LIST_CSV" ]; then
        EXPERT_LIST_CSV="$EXPERT_LIST_CSV,$expert"
    else
        EXPERT_LIST_CSV="$expert"
    fi

    SERVICE=$(sed "s/{{EXPERT_NAME}}/$expert/g" "$TEMPLATE_DIR/expert-service.yml.template")
    if [ -z "$EXPERT_SERVICES" ]; then
        EXPERT_SERVICES="$SERVICE"
    else
        EXPERT_SERVICES="$EXPERT_SERVICES
$SERVICE"
    fi

    if [ -z "$EXPERT_VOLUMES" ]; then
        EXPERT_VOLUMES="  ${expert}-workspace:"
    else
        EXPERT_VOLUMES="$EXPERT_VOLUMES
  ${expert}-workspace:"
    fi
done

render_compose_template "$TEMPLATE_DIR/docker-compose.yml.template" "$OCTEAM_DIR/docker-compose.yml"
echo ""
echo "  Generated docker-compose.yml"

# ─────────────────────────────────────────────
# Create shared project docs structure
# ─────────────────────────────────────────────

mkdir -p "$TARGET/docs/handoff-notes"
mkdir -p "$TARGET/issues"

if [ ! -f "$TARGET/docs/lessons-log.md" ]; then
    cp "$TEMPLATE_DIR/lessons-log.md" "$TARGET/docs/lessons-log.md"
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
if [ -n "$DETECTED_GIT_REPO_URL" ]; then
    echo "  1. Review .octeam/.env — git config was auto-detected. Add your OPENAI_API_KEY."
else
    echo "  1. Edit .octeam/.env with your API keys, git URL, and access token"
    echo "     (See docs/getting-started.md → 'Setting Up a Git Access Token')"
fi
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
