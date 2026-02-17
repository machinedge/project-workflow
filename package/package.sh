#!/bin/bash

# Package the machinedge-workflows skill into a distributable .skill file
# Usage: ./package/package.sh
#
# Assembles the skill directory structure (copying experts/ into
# skills/machinedge-workflows/experts/), downloads packaging tools
# from GitHub if needed, validates, and produces machinedge-workflows.skill
# in the build/ directory.
#
# Examples:
#   ./package/package.sh

set -euo pipefail

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
    echo "Error: Could not find repository root from $SCRIPT_DIR"
    exit 1
fi

BUILD_DIR="$REPO_ROOT/package/build"
SKILL_NAME="machinedge-workflows"
SKILL_SRC="$REPO_ROOT/package"
EXPERTS_SRC="$REPO_ROOT/experts"
SKILL_BUILD="$BUILD_DIR/skills/$SKILL_NAME"

# ─────────────────────────────────────────────
# Prerequisite checks
# ─────────────────────────────────────────────

if [ ! -f "$SKILL_SRC/SKILL.md" ]; then
    echo "Error: SKILL.md not found at $SKILL_SRC/SKILL.md"
    echo "  Are you running this from the project root?"
    exit 1
fi

if [ ! -d "$EXPERTS_SRC" ]; then
    echo "Error: experts/ directory not found at $EXPERTS_SRC"
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo "Error: python3 is required but not found in PATH"
    exit 1
fi

# ─────────────────────────────────────────────
# Clean build directory
# ─────────────────────────────────────────────

echo "Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$SKILL_BUILD"

# ─────────────────────────────────────────────
# Assemble skill directory
# ─────────────────────────────────────────────

echo "Copying skill files..."
cp "$SKILL_SRC/SKILL.md" "$SKILL_BUILD/"
cp -R "$SKILL_SRC/tools" "$SKILL_BUILD/tools"

echo "Copying experts into skill package..."
cp -R "$EXPERTS_SRC" "$SKILL_BUILD/experts"

# Also include the framework install scripts for installation
echo "Copying framework install scripts..."
mkdir -p "$SKILL_BUILD/framework/install"
cp "$REPO_ROOT/framework/install/install.sh" "$SKILL_BUILD/framework/install/"
cp "$REPO_ROOT/framework/install/install.ps1" "$SKILL_BUILD/framework/install/"
cp "$REPO_ROOT/framework/install/install-team.sh" "$SKILL_BUILD/framework/install/"

# ─────────────────────────────────────────────
# Ensure packaging tools are available
# ─────────────────────────────────────────────

PACKAGE_SCRIPT="$BUILD_DIR/package_skill.py"
VALIDATE_SCRIPT="$BUILD_DIR/quick_validate.py"

GITHUB_RAW="https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/scripts"

download_if_missing() {
    local file="$1"
    local name
    name="$(basename "$file")"
    local url="$GITHUB_RAW/$name"

    if [ -f "$file" ]; then
        echo "  Found $name locally"
        return 0
    fi

    echo "  Downloading $name from GitHub..."
    if command -v curl &>/dev/null; then
        curl -fsSL -o "$file" "$url"
    elif command -v wget &>/dev/null; then
        wget -q -O "$file" "$url"
    else
        echo "Error: Neither curl nor wget found. Cannot download $name."
        echo "  Download it manually from: $url"
        echo "  Place it at: $file"
        exit 1
    fi

    echo "  Downloaded $name"
}

echo "Checking packaging tools..."
download_if_missing "$PACKAGE_SCRIPT"
download_if_missing "$VALIDATE_SCRIPT"

# ─────────────────────────────────────────────
# Package the skill
# ─────────────────────────────────────────────

echo ""
echo "Packaging skill..."

export PYTHONPATH="${SCRIPT_DIR}:${PYTHONPATH:-}"

python3 "$PACKAGE_SCRIPT" "$SKILL_BUILD" "$BUILD_DIR"

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

SKILL_FILE="$BUILD_DIR/$SKILL_NAME.skill"

if [ -f "$SKILL_FILE" ]; then
    SIZE=$(du -h "$SKILL_FILE" | cut -f1)
    echo ""
    echo "Done! Skill packaged successfully."
    echo "  Output: $SKILL_FILE ($SIZE)"
    echo ""
    echo "To install:"
    echo "  ./install-skill.sh                          # Personal (all projects)"
    echo "  ./install-skill.sh --project <project-dir>  # Project-local"
else
    echo ""
    echo "Error: Expected output file not found at $SKILL_FILE"
    echo "  The packager may have failed silently."
    exit 1
fi
