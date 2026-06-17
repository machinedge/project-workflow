#!/bin/bash

# MachinEdge Expert Teams — Install
# Usage: ./install.sh [--no-claude] [project-directory]
#
# Installs the generic expert toolkit into a project from agents/:
#   AGENTS.md            Top-level operating-system file (read by Codex and any
#                        harness that follows the AGENTS.md convention).
#   CLAUDE.md → AGENTS.md  Symlink so Claude Code reads the same file.
#   .agents/             Copy of the toolkit source (roles, commands, skills, scripts).
#   .claude/             Claude-native wiring — command/skill/role/script symlinks into
#                        .agents/ plus the SessionStart settings hook. Skipped with --no-claude.
#
# Examples:
#   ./install.sh ~/myproj                 # Full install (AGENTS.md flow + Claude wiring)
#   ./install.sh --no-claude ~/myproj     # Generic only (Codex / other harnesses)
#   ./install.sh .                        # Current directory

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/agents"

if [ ! -d "$SOURCE" ]; then
    echo "Error: toolkit source directory not found."
    echo "  Expected: $SOURCE"
    exit 2
fi

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

CLAUDE_WIRING=1
TARGET="."

usage() {
    echo "Usage: $0 [--no-claude] [project-directory]"
    echo ""
    echo "Options:"
    echo "  --no-claude   Skip the .claude/ wiring; install only AGENTS.md + .agents/"
    echo "                (for Codex and other AGENTS.md-only harnesses)"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 ~/myproj                 # Full install"
    echo "  $0 --no-claude ~/myproj     # Generic only"
    echo "  $0 .                        # Current directory"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-claude)
            CLAUDE_WIRING=0
            shift
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

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

echo "MachinEdge Expert Teams — Install"
echo "  Target: $(cd "$TARGET" && pwd)"
if [ "$CLAUDE_WIRING" = "1" ]; then
    echo "  Mode:   AGENTS.md flow + Claude Code wiring"
else
    echo "  Mode:   AGENTS.md flow only (--no-claude)"
fi
echo ""

# ─────────────────────────────────────────────
# Create shared project structure
# ─────────────────────────────────────────────

# docs/ always needed for core planning docs (project-brief, roadmap, architecture, etc.)
mkdir -p "$TARGET/docs"

# ─────────────────────────────────────────────
# Migrate old directory layout to .sdlc/
# ─────────────────────────────────────────────

migrate_dir() {
    local src="$1" dest="$2"
    [ -d "$src" ] || return 1
    if [ -d "$dest" ]; then
        cp -R "$src"/. "$dest"/ && rm -rf "$src"
    else
        mkdir -p "$(dirname "$dest")"
        mv "$src" "$dest"
    fi
}

migrate_file() {
    local src="$1" dest="$2"
    [ -f "$src" ] || return 1
    mkdir -p "$(dirname "$dest")"
    if [ -f "$dest" ]; then
        rm "$src"
    else
        mv "$src" "$dest"
    fi
}

if [ -d "$TARGET/docs/handoff-notes" ] || [ -d "$TARGET/issues" ]; then
    echo "  Migrating artifacts to .sdlc/..."

    migrate_dir "$TARGET/docs/handoff-notes" "$TARGET/.sdlc/handoff-notes" \
        && echo "    docs/handoff-notes/ → .sdlc/handoff-notes/"
    migrate_dir "$TARGET/issues" "$TARGET/.sdlc/issues" \
        && echo "    issues/ → .sdlc/issues/"

    migrate_file "$TARGET/docs/lessons-log.md" "$TARGET/.sdlc/lessons-log.md" \
        && echo "    docs/lessons-log.md → .sdlc/lessons-log.md"

    for f in "$TARGET"/docs/interview-notes*.md; do
        [ -f "$f" ] || continue
        fname=$(basename "$f")
        migrate_file "$f" "$TARGET/.sdlc/$fname" \
            && echo "    docs/$fname → .sdlc/$fname"
    done

    for f in "$TARGET"/docs/research-*.md; do
        [ -f "$f" ] || continue
        fname=$(basename "$f")
        migrate_file "$f" "$TARGET/.sdlc/$fname" \
            && echo "    docs/$fname → .sdlc/$fname"
    done

    echo ""
fi

# Ensure .sdlc/ structure is complete (fresh install or post-migration)
mkdir -p "$TARGET/.sdlc/issues/backlog"
mkdir -p "$TARGET/.sdlc/issues/planned"
mkdir -p "$TARGET/.sdlc/issues/in-progress"
mkdir -p "$TARGET/.sdlc/issues/done"

for expert in pm swe qa devops system-architect; do
    mkdir -p "$TARGET/.sdlc/handoff-notes/$expert"
done

if [ ! -f "$TARGET/.sdlc/lessons-log.md" ]; then
cat > "$TARGET/.sdlc/lessons-log.md" << 'EOF'
# Lessons Log

Record project-specific gotchas, patterns, and knowledge here. Future sessions will read this to avoid repeating mistakes.

| Lesson | Context |
|--------|---------|
EOF
fi

# ─────────────────────────────────────────────
# Clean previous installation (managed files only)
# Preserves user content in docs/, .sdlc/, and
# user-owned .claude/settings*.json.
# ─────────────────────────────────────────────

# Legacy platform directory from the pre-AGENTS.md layout
rm -rf "$TARGET/.cursor" 2>/dev/null || true

# Managed .agents/ payload (leave any user-added files in .agents/ alone)
rm -rf "$TARGET/.agents/roles" "$TARGET/.agents/commands" \
       "$TARGET/.agents/skills" "$TARGET/.agents/scripts" \
       "$TARGET/.agents/workflows" 2>/dev/null || true
rm -f "$TARGET/.agents/AGENTS.md" "$TARGET/.agents/settings.json" 2>/dev/null || true

# Managed .claude/ symlinks (only remove symlinks; preserve real settings files)
for name in commands skills roles scripts workflows; do
    [ -L "$TARGET/.claude/$name" ] && rm -f "$TARGET/.claude/$name"
done
# Legacy real CLAUDE.md from prior copy-based installs (now a root symlink)
[ -f "$TARGET/.claude/CLAUDE.md" ] && rm -f "$TARGET/.claude/CLAUDE.md"
# Our root CLAUDE.md symlink (will be recreated)
[ -L "$TARGET/CLAUDE.md" ] && rm -f "$TARGET/CLAUDE.md"

# ─────────────────────────────────────────────
# Safety: never silently clobber a user's own AGENTS.md / CLAUDE.md
# ─────────────────────────────────────────────

SRC_AGENTS="$SOURCE/AGENTS.md"

if [ -e "$TARGET/AGENTS.md" ] && [ ! -L "$TARGET/AGENTS.md" ]; then
    if ! cmp -s "$SRC_AGENTS" "$TARGET/AGENTS.md"; then
        cp "$TARGET/AGENTS.md" "$TARGET/AGENTS.md.pre-install.bak"
        echo "  WARNING: existing AGENTS.md backed up to AGENTS.md.pre-install.bak"
    fi
fi

if [ -e "$TARGET/CLAUDE.md" ] && [ ! -L "$TARGET/CLAUDE.md" ]; then
    cp "$TARGET/CLAUDE.md" "$TARGET/CLAUDE.md.pre-install.bak"
    echo "  WARNING: existing CLAUDE.md backed up to CLAUDE.md.pre-install.bak"
    rm -f "$TARGET/CLAUDE.md"
fi

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

copy_skills() {
    local src="$1" dest="$2"
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

copy_scripts() {
    local src="$1" dest="$2"
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

copy_commands() {
    local src="$1" dest="$2"
    mkdir -p "$dest"
    for f in "$src"/*.md; do
        [ -f "$f" ] || continue
        cp "$f" "$dest/"
    done
}

merge_settings() {
    local target_dir="$1"
    local existing="$target_dir/.claude/settings.json"
    local source="$SOURCE/settings.json"

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
# Install generic payload into .agents/
# ─────────────────────────────────────────────

echo "  Installing .agents/ ..."

mkdir -p "$TARGET/.agents/roles"
cp "$SOURCE"/roles/*.md "$TARGET/.agents/roles/"
copy_commands "$SOURCE/commands" "$TARGET/.agents/commands"
copy_skills   "$SOURCE/skills"   "$TARGET/.agents/skills"
copy_scripts  "$SOURCE/scripts"  "$TARGET/.agents/scripts"
if [ -d "$SOURCE/workflows" ]; then
    mkdir -p "$TARGET/.agents/workflows"
    cp "$SOURCE"/workflows/*.js "$TARGET/.agents/workflows/" 2>/dev/null || true
fi
cp "$SRC_AGENTS" "$TARGET/.agents/AGENTS.md"
[ -f "$SOURCE/settings.json" ] && cp "$SOURCE/settings.json" "$TARGET/.agents/settings.json"

# AGENTS.md at the project root + CLAUDE.md symlink
cp "$SRC_AGENTS" "$TARGET/AGENTS.md"
ln -sf AGENTS.md "$TARGET/CLAUDE.md"

role_count=$(ls "$TARGET/.agents/roles/"*.md 2>/dev/null | wc -l | tr -d ' ')
cmd_count=$(ls "$TARGET/.agents/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
skill_count=$(find "$TARGET/.agents/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
script_count=$(find "$TARGET/.agents/scripts" -type f 2>/dev/null | wc -l | tr -d ' ')
echo "    AGENTS.md + CLAUDE.md symlink"
echo "    Roles: $role_count files"
echo "    Commands: $cmd_count files"
echo "    Skills: $skill_count folders"
echo "    Scripts: $script_count files"

# ─────────────────────────────────────────────
# Claude Code wiring (native slash-command / skill discovery + SessionStart hook)
# ─────────────────────────────────────────────

if [ "$CLAUDE_WIRING" = "1" ]; then
    echo "  Wiring .claude/ for Claude Code ..."
    mkdir -p "$TARGET/.claude"
    claude_links="commands skills roles scripts"
    [ -d "$TARGET/.agents/workflows" ] && claude_links="$claude_links workflows"
    for name in $claude_links; do
        rm -rf "$TARGET/.claude/$name" 2>/dev/null || true
        ln -s "../.agents/$name" "$TARGET/.claude/$name"
    done
    echo "    Symlinks: .claude/{commands,skills,roles,scripts,workflows} → ../.agents/*"
    merge_settings "$TARGET"
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Installed to: $(cd "$TARGET" && pwd)"
echo ""
echo "Next steps:"
echo "  1. cd $(cd "$TARGET" && pwd)"
if [ "$CLAUDE_WIRING" = "1" ]; then
    echo "  2. Open Claude Code (or a Codex/AGENTS.md harness) and run /pm-interview to start"
else
    echo "  2. Open your AGENTS.md-aware harness; it reads AGENTS.md + .agents/"
fi
echo "  3. Or run /team-status to see the project health summary"
echo ""
echo "Uninstall:"
echo "  rm -f AGENTS.md CLAUDE.md"
echo "  rm -rf .agents"
echo "  rm -f .claude/commands .claude/skills .claude/roles .claude/scripts .claude/workflows   # symlinks"
echo "  # Manually remove the SessionStart hook from .claude/settings.json if desired"
echo "  Project documents (docs/, .sdlc/) are yours — they are not removed."
echo ""
