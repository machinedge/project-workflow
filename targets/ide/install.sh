#!/bin/bash

# MachinEdge Expert Teams — Install
# Usage: ./install.sh [--editor cursor|claude|both] [project-directory]
#
# Installs platform-native expert files into a project directory by copying
# pre-built implementations from targets/ide/<platform>/.
#
# Examples:
#   ./install.sh ~/myproj                          # Both editors
#   ./install.sh --editor cursor ~/myproj           # Cursor only
#   ./install.sh --editor claude ~/myproj           # Claude Code only
#   ./install.sh .                                  # Current directory, both editors

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CURSOR_SRC="$SCRIPT_DIR/cursor"
CLAUDE_SRC="$SCRIPT_DIR/claude-code"

if [ ! -d "$CURSOR_SRC" ] || [ ! -d "$CLAUDE_SRC" ]; then
    echo "Error: Platform source directories not found."
    echo "  Expected: $CURSOR_SRC and $CLAUDE_SRC"
    exit 2
fi

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

EDITOR="both"
TARGET="."

usage() {
    echo "Usage: $0 [--editor cursor|claude|both] [project-directory]"
    echo ""
    echo "Options:"
    echo "  --editor    Target editor: cursor, claude, or both (default: both)"
    echo "  -h, --help  Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 ~/myproj                          # Both editors"
    echo "  $0 --editor cursor ~/myproj           # Cursor only"
    echo "  $0 --editor claude .                  # Claude Code, current dir"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --editor)
            EDITOR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

case "$EDITOR" in
    cursor|claude|both) ;;
    *)
        echo "Error: --editor must be cursor, claude, or both (got '$EDITOR')"
        exit 2
        ;;
esac

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

echo "MachinEdge Expert Teams — Install"
echo "  Target: $(cd "$TARGET" && pwd)"
echo "  Editor: $EDITOR"
echo ""

# ─────────────────────────────────────────────
# Create shared project structure
# ─────────────────────────────────────────────

mkdir -p "$TARGET/docs/handoff-notes"
mkdir -p "$TARGET/issues/backlog"
mkdir -p "$TARGET/issues/planned"
mkdir -p "$TARGET/issues/in-progress"
mkdir -p "$TARGET/issues/done"

for expert in pm swe qa devops system-architect; do
    mkdir -p "$TARGET/docs/handoff-notes/$expert"
done

if [ ! -f "$TARGET/docs/lessons-log.md" ]; then
cat > "$TARGET/docs/lessons-log.md" << 'EOF'
# Lessons Log

Record project-specific gotchas, patterns, and knowledge here. Future sessions will read this to avoid repeating mistakes.

| Lesson | Context |
|--------|---------|
EOF
fi

# ─────────────────────────────────────────────
# Clean previous installation (managed files only)
# Preserves user content in docs/, issues/, and
# any custom rules/commands/skills without our prefixes
# ─────────────────────────────────────────────

MANAGED_PREFIXES="pm swe qa ops sa da ux team"

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    rm -f "$TARGET/.cursor/rules/"*-os.mdc 2>/dev/null || true
    rm -f "$TARGET/.cursor/rules/project-os.mdc" 2>/dev/null || true
    for prefix in $MANAGED_PREFIXES; do
        rm -f "$TARGET/.cursor/commands/${prefix}"-*.md 2>/dev/null || true
        rm -rf "$TARGET/.cursor/skills/${prefix}"-*/ 2>/dev/null || true
    done
    rm -f "$TARGET/.cursor/scripts/move-issue."* 2>/dev/null || true
    rm -f "$TARGET/.cursor/scripts/next-issue-number."* 2>/dev/null || true
    rm -f "$TARGET/.cursor/scripts/next-session-number."* 2>/dev/null || true
    rm -f "$TARGET/.cursor/scripts/update-issues-list."* 2>/dev/null || true
    rm -f "$TARGET/.cursor/scripts/update-brief-status."* 2>/dev/null || true
fi

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    rm -f "$TARGET/.claude/CLAUDE.md" 2>/dev/null || true
    rm -rf "$TARGET/.claude/roles" 2>/dev/null || true
    for prefix in $MANAGED_PREFIXES; do
        rm -f "$TARGET/.claude/commands/${prefix}"-*.md 2>/dev/null || true
        rm -rf "$TARGET/.claude/skills/${prefix}"-*/ 2>/dev/null || true
    done
    rm -f "$TARGET/.claude/scripts/move-issue."* 2>/dev/null || true
    rm -f "$TARGET/.claude/scripts/next-issue-number."* 2>/dev/null || true
    rm -f "$TARGET/.claude/scripts/next-session-number."* 2>/dev/null || true
    rm -f "$TARGET/.claude/scripts/update-issues-list."* 2>/dev/null || true
    rm -f "$TARGET/.claude/scripts/update-brief-status."* 2>/dev/null || true
    rm -f "$TARGET/.claude/scripts/session-primer.sh" 2>/dev/null || true
fi

# ─────────────────────────────────────────────
# Helper: copy a directory of skills (each is a subfolder with SKILL.md)
# ─────────────────────────────────────────────

copy_skills() {
    local src="$1"
    local dest="$2"
    mkdir -p "$dest"
    for skill_dir in "$src"/*/; do
        [ -d "$skill_dir" ] || continue
        local skill_name
        skill_name=$(basename "$skill_dir")
        [ "$skill_name" = "*" ] && continue
        mkdir -p "$dest/$skill_name"
        cp "$skill_dir"SKILL.md "$dest/$skill_name/"
    done
}

# ─────────────────────────────────────────────
# Helper: copy scripts, set .sh executable, skip test/dev files
# ─────────────────────────────────────────────

copy_scripts() {
    local src="$1"
    local dest="$2"
    mkdir -p "$dest"
    for f in "$src"/*; do
        [ -f "$f" ] || continue
        local fname
        fname=$(basename "$f")
        case "$fname" in
            test-*|*.test.*) continue ;;
            .gitkeep) continue ;;
        esac
        cp "$f" "$dest/"
    done
    chmod +x "$dest"/*.sh 2>/dev/null || true
}

# ─────────────────────────────────────────────
# Helper: copy commands, skip .gitkeep
# ─────────────────────────────────────────────

copy_commands() {
    local src="$1"
    local dest="$2"
    mkdir -p "$dest"
    for f in "$src"/*.md; do
        [ -f "$f" ] || continue
        cp "$f" "$dest/"
    done
}

# ─────────────────────────────────────────────
# Helper: merge settings.json (Claude Code hooks)
# ─────────────────────────────────────────────

merge_settings() {
    local target_dir="$1"
    local existing="$target_dir/.claude/settings.json"
    local source="$CLAUDE_SRC/settings.json"

    if [ ! -f "$source" ]; then
        return
    fi

    if [ ! -f "$existing" ]; then
        cp "$source" "$existing"
        echo "    Settings: created .claude/settings.json"
        return
    fi

    if command -v python3 &>/dev/null; then
        python3 << PYEOF
import json

with open("$existing") as f:
    existing = json.load(f)
with open("$source") as f:
    new_settings = json.load(f)

if "hooks" not in existing:
    existing["hooks"] = {}
for hook_name, hook_value in new_settings.get("hooks", {}).items():
    existing["hooks"][hook_name] = hook_value

with open("$existing", "w") as f:
    json.dump(existing, f, indent=2)
    f.write("\n")
PYEOF
        echo "    Settings: merged hooks into existing .claude/settings.json"
    else
        echo "    WARNING: Could not merge settings.json (python3 not found)."
        echo "    Please manually merge hooks from: $source"
        echo "    Into: $existing"
    fi
}

# ─────────────────────────────────────────────
# Install Cursor
# ─────────────────────────────────────────────

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "  [cursor] Installing platform-native files..."

    mkdir -p "$TARGET/.cursor/rules"
    cp "$CURSOR_SRC"/rules/*.mdc "$TARGET/.cursor/rules/"

    copy_commands "$CURSOR_SRC/commands" "$TARGET/.cursor/commands"
    copy_skills "$CURSOR_SRC/skills" "$TARGET/.cursor/skills"
    copy_scripts "$CURSOR_SRC/scripts" "$TARGET/.cursor/scripts"

    rule_count=$(ls "$TARGET/.cursor/rules/"*.mdc 2>/dev/null | wc -l | tr -d ' ')
    cmd_count=$(ls "$TARGET/.cursor/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    skill_count=$(find "$TARGET/.cursor/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    script_count=$(find "$TARGET/.cursor/scripts" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "    Rules: $rule_count files"
    echo "    Commands: $cmd_count files"
    echo "    Skills: $skill_count folders"
    echo "    Scripts: $script_count files"
fi

# ─────────────────────────────────────────────
# Install Claude Code
# ─────────────────────────────────────────────

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo "  [claude] Installing platform-native files..."

    mkdir -p "$TARGET/.claude"
    cp "$CLAUDE_SRC/CLAUDE.md" "$TARGET/.claude/CLAUDE.md"

    mkdir -p "$TARGET/.claude/roles"
    cp "$CLAUDE_SRC"/roles/*.md "$TARGET/.claude/roles/"

    copy_commands "$CLAUDE_SRC/commands" "$TARGET/.claude/commands"
    copy_skills "$CLAUDE_SRC/skills" "$TARGET/.claude/skills"
    copy_scripts "$CLAUDE_SRC/scripts" "$TARGET/.claude/scripts"

    merge_settings "$TARGET"

    role_count=$(ls "$TARGET/.claude/roles/"*.md 2>/dev/null | wc -l | tr -d ' ')
    cmd_count=$(ls "$TARGET/.claude/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    skill_count=$(find "$TARGET/.claude/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    script_count=$(find "$TARGET/.claude/scripts" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "    Roles: $role_count files"
    echo "    Commands: $cmd_count files"
    echo "    Skills: $skill_count folders"
    echo "    Scripts: $script_count files"
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Installed to: $(cd "$TARGET" && pwd)"
echo ""
echo "Next steps:"
echo "  1. cd $(cd "$TARGET" && pwd)"
if [ "$EDITOR" = "claude" ]; then
    echo "  2. Open Claude Code and run /pm-interview to start a new project"
elif [ "$EDITOR" = "cursor" ]; then
    echo "  2. Open Cursor and run /pm-interview in Agent mode to start a new project"
else
    echo "  2. Open Claude Code or Cursor and run /pm-interview to start a new project"
fi
echo "  3. Or run /team-status to see the project health summary"
echo ""
echo "Uninstall:"
echo "  To remove the toolkit, delete the managed files:"
if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "    rm -rf .cursor/rules/*-os.mdc .cursor/rules/project-os.mdc"
    echo "    rm -rf .cursor/commands/{pm,swe,qa,ops,sa,team}-*.md"
    echo "    rm -rf .cursor/skills/{pm,swe,qa,ops,sa,team}-*"
    echo "    rm -rf .cursor/scripts/"
fi
if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo "    rm -f .claude/CLAUDE.md"
    echo "    rm -rf .claude/roles/ .claude/commands/{pm,swe,qa,ops,sa,team}-*.md"
    echo "    rm -rf .claude/skills/{pm,swe,qa,ops,sa,team}-*"
    echo "    rm -rf .claude/scripts/"
    echo "    # Manually remove hooks from .claude/settings.json if desired"
fi
echo "  Project documents (docs/, issues/) are yours — they are not removed."
echo ""
