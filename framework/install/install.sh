#!/bin/bash

# MachinEdge Expert Teams — Install
# Usage: ./install.sh [--editor claude|cursor|both] [--experts pm,swe,qa,devops] [--domain technical] [project-directory]
#
# Installs one or more experts into a project directory by translating
# platform-agnostic expert definitions into editor-specific configurations.
#
# Expert short names are mapped to their full directory names:
#   pm → project-manager, swe → swe, qa → qa, devops → devops, data-analyst → data-analyst
#
# Skill prefix mapping (for flat command namespaces):
#   pm- → project-manager, swe- → swe, qa- → qa, ops- → devops
#   da- → data-analyst, ux- → user-experience, team- → shared
#
# Examples:
#   ./install.sh ~/myproj                                    # All core experts, both editors
#   ./install.sh --experts pm,swe ~/myproj                   # Just PM and SWE
#   ./install.sh --experts pm,swe,qa --editor cursor .       # PM+SWE+QA, Cursor only
#   ./install.sh --editor claude ~/myproj                    # All core experts, Claude only

set -e

# Resolve the directory where this script lives
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

# Parse arguments
EDITOR="both"
EXPERT_LIST="project-manager,swe,qa,devops"
DOMAIN="technical"
TARGET="."

while [[ $# -gt 0 ]]; do
    case $1 in
        --editor)
            EDITOR="$2"
            shift 2
            ;;
        --experts|--workflows)
            EXPERT_LIST="$2"
            shift 2
            ;;
        --domain)
            DOMAIN="$2"
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

# ─────────────────────────────────────────────
# Map expert directory names to short prefixes
# Used to namespace skills in flat command directories
# ─────────────────────────────────────────────

resolve_expert_prefix() {
    local name="$1"
    case "$name" in
        project-manager) echo "pm" ;;
        swe)             echo "swe" ;;
        qa)              echo "qa" ;;
        devops)          echo "ops" ;;
        data-analyst)    echo "da" ;;
        user-experience) echo "ux" ;;
        *)               echo "$name" ;;
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

echo "Setting up expert team in: $TARGET"
echo "  Experts: ${EXPERTS[*]}"
echo "  Domain: $DOMAIN"
echo "  Editor: $EDITOR"
echo ""

# ─────────────────────────────────────────────
# Create shared project structure
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

# Create handoff-notes subdirectories for each expert
for expert in "${EXPERTS[@]}"; do
    mkdir -p "$TARGET/docs/handoff-notes/$expert"
done

# ─────────────────────────────────────────────
# Clean previous installation (managed files only)
# Preserves user content in docs/, issues/, and
# any custom commands without our known prefixes
# ─────────────────────────────────────────────

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    # Remove managed commands (known prefixes only)
    for prefix in pm swe qa ops da ux team; do
        rm -f "$TARGET/.claude/commands/${prefix}"-*.md 2>/dev/null
    done
    # Remove managed roles and generated root config
    rm -rf "$TARGET/.claude/roles" 2>/dev/null
    rm -f "$TARGET/.claude/CLAUDE.md" 2>/dev/null
fi

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    # Remove managed commands (known prefixes only)
    for prefix in pm swe qa ops da ux team; do
        rm -f "$TARGET/.cursor/commands/${prefix}"-*.md 2>/dev/null
    done
    # Remove managed rules and generated root config
    rm -f "$TARGET/.cursor/rules/"*-os.mdc 2>/dev/null
    rm -f "$TARGET/.cursor/rules/project-os.mdc" 2>/dev/null
fi

# ─────────────────────────────────────────────
# Install each expert's definition
# ─────────────────────────────────────────────

for expert in "${EXPERTS[@]}"; do
    EXPERT_SRC="$REPO_ROOT/experts/$DOMAIN/$expert"
    echo "  [$expert] Installing expert definition..."

    # Claude Code: role.md → .claude/roles/<expert>.md, skills → .claude/commands/
    if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
        mkdir -p "$TARGET/.claude/roles"
        mkdir -p "$TARGET/.claude/commands"

        if [ -f "$EXPERT_SRC/role.md" ]; then
            cp "$EXPERT_SRC/role.md" "$TARGET/.claude/roles/$expert.md"
        fi

        # Copy skills as slash commands (prefixed and normalized)
        if [ -d "$EXPERT_SRC/skills" ]; then
            PREFIX=$(resolve_expert_prefix "$expert")
            for skill_file in "$EXPERT_SRC"/skills/*.md; do
                if [ -f "$skill_file" ]; then
                    skill_basename=$(basename "$skill_file" | tr '_' '-')
                    cp "$skill_file" "$TARGET/.claude/commands/${PREFIX}-${skill_basename}"
                fi
            done
        fi
    fi

    # Cursor: role.md → .cursor/rules/<expert>-os.mdc (with frontmatter), skills → .cursor/commands/
    if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
        mkdir -p "$TARGET/.cursor/rules"
        mkdir -p "$TARGET/.cursor/commands"

        if [ -f "$EXPERT_SRC/role.md" ]; then
            # Prepend Cursor's YAML frontmatter
            {
                printf '%s\n' "---"
                printf '%s\n' "description: $expert expert — operating rules"
                printf '%s\n' "alwaysApply: true"
                printf '%s\n' "---"
                printf '\n'
                cat "$EXPERT_SRC/role.md"
            } > "$TARGET/.cursor/rules/${expert}-os.mdc"
        fi

        # Copy skills as commands (prefixed and normalized)
        if [ -d "$EXPERT_SRC/skills" ]; then
            PREFIX=$(resolve_expert_prefix "$expert")
            for skill_file in "$EXPERT_SRC"/skills/*.md; do
                if [ -f "$skill_file" ]; then
                    skill_basename=$(basename "$skill_file" | tr '_' '-')
                    cp "$skill_file" "$TARGET/.cursor/commands/${PREFIX}-${skill_basename}"
                fi
            done
        fi
    fi

    # Copy expert tools to project if any exist (beyond .gitkeep)
    if [ -d "$EXPERT_SRC/tools" ]; then
        TOOL_COUNT=$(find "$EXPERT_SRC/tools" -type f ! -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$TOOL_COUNT" -gt 0 ]; then
            mkdir -p "$TARGET/tools/$expert"
            find "$EXPERT_SRC/tools" -type f ! -name ".gitkeep" -exec cp {} "$TARGET/tools/$expert/" \;
            echo "    Copied $TOOL_COUNT tool(s) to tools/$expert/"
        fi
    fi
done

# ─────────────────────────────────────────────
# Install shared skills (e.g., /status)
# ─────────────────────────────────────────────

SHARED_DIR="$REPO_ROOT/experts/$DOMAIN/shared"
if [ -d "$SHARED_DIR/skills" ]; then
    echo ""
    echo "  [shared] Installing shared skills..."

    if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
        for skill_file in "$SHARED_DIR"/skills/*.md; do
            if [ -f "$skill_file" ]; then
                skill_basename=$(basename "$skill_file" | tr '_' '-')
                cp "$skill_file" "$TARGET/.claude/commands/team-${skill_basename}"
            fi
        done
    fi

    if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
        for skill_file in "$SHARED_DIR"/skills/*.md; do
            if [ -f "$skill_file" ]; then
                skill_basename=$(basename "$skill_file" | tr '_' '-')
                cp "$skill_file" "$TARGET/.cursor/commands/team-${skill_basename}"
            fi
        done
    fi
fi

# ─────────────────────────────────────────────
# Generate the root CLAUDE.md / Cursor rules
# ─────────────────────────────────────────────

# Build the list of installed experts and their skills
ROLE_LIST=""
SKILL_LIST=""
for expert in "${EXPERTS[@]}"; do
    EXPERT_SRC="$REPO_ROOT/experts/$DOMAIN/$expert"

    # Extract the first line of role.md as the display name
    if [ -f "$EXPERT_SRC/role.md" ]; then
        DISPLAY_NAME=$(head -1 "$EXPERT_SRC/role.md" | sed 's/^#\s*//' | sed 's/ Operating System$//')
    else
        DISPLAY_NAME="$expert"
    fi

    ROLE_LIST="$ROLE_LIST\n- **$DISPLAY_NAME** (\`.claude/roles/$expert.md\`)"

    # List skills from the expert (prefixed and normalized)
    if [ -d "$EXPERT_SRC/skills" ]; then
        PREFIX=$(resolve_expert_prefix "$expert")
        for skill_file in "$EXPERT_SRC"/skills/*.md; do
            if [ -f "$skill_file" ]; then
                skill_name=$(basename "$skill_file" .md | tr '_' '-')
                SKILL_LIST="$SKILL_LIST\n- \`/${PREFIX}-${skill_name}\` ($DISPLAY_NAME)"
            fi
        done
    fi
done

# Add shared skills
if [ -d "$SHARED_DIR/skills" ]; then
    for skill_file in "$SHARED_DIR"/skills/*.md; do
        if [ -f "$skill_file" ]; then
            skill_name=$(basename "$skill_file" .md | tr '_' '-')
            SKILL_LIST="$SKILL_LIST\n- \`/team-${skill_name}\` (Shared)"
        fi
    done
fi

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo ""
    echo "  [claude] Generating .claude/CLAUDE.md..."
    cat > "$TARGET/.claude/CLAUDE.md" << CLAUDE_EOF
# Project Operating System

This project uses the MachinEdge Expert Teams toolkit. Each session, you operate as a specific expert.

## Experts

Read the role file for your active expert at the start of every session:
$(echo -e "$ROLE_LIST")

## Starting a Session

1. Ask the user which expert role they want for this session.
2. Read the corresponding role file from \`.claude/roles/\`.
3. Follow that expert's session protocol.

If the user jumps straight into a skill (e.g. \`/swe-start\`), infer the expert from the skill prefix and load the appropriate role file automatically. Skill prefixes: pm=Project Manager, swe=SWE, qa=QA, ops=DevOps, da=Data Analyst, ux=User Experience, team=Shared.

## Available Skills
$(echo -e "$SKILL_LIST")

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (\`docs/project-brief.md\`) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
- Issues are tracked in \`issues/\`, not external services.
CLAUDE_EOF
fi

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "  [cursor] Generating .cursor/rules/project-os.mdc..."
    cat > "$TARGET/.cursor/rules/project-os.mdc" << CURSOR_EOF
---
description: Project operating system — MachinEdge Expert Teams
alwaysApply: true
---

# Project Operating System

This project uses the MachinEdge Expert Teams toolkit. Each session, you operate as a specific expert.

## Experts

Read the role file for your active expert at the start of every session:
$(echo -e "$ROLE_LIST")

Role files are in \`.cursor/rules/\` as \`<expert>-os.mdc\`.

## Starting a Session

1. Ask the user which expert role they want for this session.
2. Read the corresponding role rules file.
3. Follow that expert's session protocol.

If the user jumps straight into a skill (e.g. \`/swe-start\`), infer the expert from the skill prefix and load the appropriate role file automatically. Skill prefixes: pm=Project Manager, swe=SWE, qa=QA, ops=DevOps, da=Data Analyst, ux=User Experience, team=Shared.

## Available Skills
$(echo -e "$SKILL_LIST")

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (\`docs/project-brief.md\`) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
- Issues are tracked in \`issues/\`, not external services.
CURSOR_EOF
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Project structure:"
echo ""
find "$TARGET/docs" -type f 2>/dev/null | sort | while read f; do
    echo "  $f"
done
if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.claude" -type f 2>/dev/null | sort | while read f; do
        echo "  $f"
    done
fi
if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.cursor" -type f 2>/dev/null | sort | while read f; do
        echo "  $f"
    done
fi
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
if [ "$EDITOR" = "claude" ]; then
    echo "  2. Open Claude Code and run /pm-interview to start a new project"
elif [ "$EDITOR" = "cursor" ]; then
    echo "  2. Open Cursor and run /pm-interview in Agent mode to start a new project"
else
    echo "  2. Open Claude Code or Cursor and run /pm-interview to start a new project"
fi
echo "  3. Or run /team-status to see the project health summary"
echo ""
