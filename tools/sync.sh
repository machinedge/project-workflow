#!/usr/bin/env bash

# MachinEdge Expert Teams — Sync Command
# Usage: ./sync.sh [-y|--yes] <mode> [options]
#
# Compares Cursor and Claude Code platform implementations for drift (maintainers),
# or checks/updates an installed toolkit against the source (users).
#
# Modes:
#   diff                     Compare Cursor and Claude Code implementations
#   check [project-dir]      Check installed toolkit against source (default: .)
#   apply [project-dir]      Update installed toolkit from source (with confirmation)
#
# Flags:
#   -y, --yes                Skip confirmation prompt (apply mode)
#
# Exit codes:
#   0 — in sync (diff/check) or all updates applied (apply)
#   1 — differences found
#   2 — usage error or missing prerequisites
#
# Output markers (for agent/script consumption):
#   [OK]                     File or category is in sync
#   [DIFFERS]                File content differs
#   [MISSING:<location>]     File exists in one location but not the other
#   [SKIPPED]                File requires manual handling (e.g., settings.json)
#   [UPDATED]                File was updated (apply mode)
#
# Environment:
#   SYNC_REPO_ROOT           Override toolkit repo root (default: derived from script location)
#
# Examples:
#   ./sync.sh diff                          # Compare platforms for drift
#   ./sync.sh check /path/to/my-project     # Check installed toolkit
#   ./sync.sh -y apply /path/to/my-project  # Update without prompting

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${SYNC_REPO_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"

CURSOR_DIR="$REPO_ROOT/targets/ide/cursor"
CLAUDE_DIR="$REPO_ROOT/targets/ide/claude-code"

DIFFS=0
YES=false

usage() {
  echo "Usage: sync.sh [-y|--yes] <mode> [options]"
  echo ""
  echo "Modes:"
  echo "  diff                     Compare Cursor and Claude Code implementations"
  echo "  check [project-dir]      Check installed toolkit against source (default: .)"
  echo "  apply [project-dir]      Update installed toolkit from source"
  echo ""
  echo "Flags:"
  echo "  -y, --yes                Skip confirmation prompt (apply mode)"
  exit 2
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

list_files() {
  local dir="$1"
  if [ -d "$dir" ]; then
    (cd "$dir" && find . -type f | sed 's|^\./||' | sort)
  fi
}

list_subdirs() {
  local dir="$1"
  if [ -d "$dir" ]; then
    (cd "$dir" && find . -maxdepth 1 -mindepth 1 -type d | sed 's|^\./||' | sort)
  fi
}

should_skip_source_file() {
  case "$1" in
    README.md) return 0 ;;
    *) return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Diff mode
# ---------------------------------------------------------------------------

compare_file_lists() {
  local label="$1" dir1="$2" dir2="$3"
  local list1 list2 only1 only2 count gaps=0

  list1=$(list_files "$dir1")
  list2=$(list_files "$dir2")

  only1=$(comm -23 <(echo "$list1") <(echo "$list2") || true)
  only2=$(comm -13 <(echo "$list1") <(echo "$list2") || true)

  if [ -z "$only1" ] && [ -z "$only2" ]; then
    count=$(echo "$list1" | grep -c '^.' || true)
    echo "[OK] $label: $count in both platforms"
  else
    if [ -n "$only1" ]; then
      while IFS= read -r f; do
        [ -z "$f" ] && continue
        echo "[MISSING:claude-code] $label: $f"
        gaps=$((gaps + 1))
      done <<< "$only1"
    fi
    if [ -n "$only2" ]; then
      while IFS= read -r f; do
        [ -z "$f" ] && continue
        echo "[MISSING:cursor] $label: $f"
        gaps=$((gaps + 1))
      done <<< "$only2"
    fi
    DIFFS=$((DIFFS + gaps))
  fi
}

compare_skill_coverage() {
  local cursor_skills claude_skills only_cursor only_claude count gaps=0

  cursor_skills=$(list_subdirs "$CURSOR_DIR/skills")
  claude_skills=$(list_subdirs "$CLAUDE_DIR/skills")

  only_cursor=$(comm -23 <(echo "$cursor_skills") <(echo "$claude_skills") || true)
  only_claude=$(comm -13 <(echo "$cursor_skills") <(echo "$claude_skills") || true)

  if [ -z "$only_cursor" ] && [ -z "$only_claude" ]; then
    count=$(echo "$cursor_skills" | grep -c '^.' || true)
    echo "[OK] skills: $count in both platforms"
  else
    if [ -n "$only_cursor" ]; then
      while IFS= read -r s; do
        [ -z "$s" ] && continue
        echo "[MISSING:claude-code] skill: $s"
        gaps=$((gaps + 1))
      done <<< "$only_cursor"
    fi
    if [ -n "$only_claude" ]; then
      while IFS= read -r s; do
        [ -z "$s" ] && continue
        echo "[MISSING:cursor] skill: $s"
        gaps=$((gaps + 1))
      done <<< "$only_claude"
    fi
    DIFFS=$((DIFFS + gaps))
  fi
}

compare_dir_content() {
  local label="$1" dir1="$2" dir2="$3"
  local files ok=0 bad=0

  files=$(list_files "$dir1")
  [ -z "$files" ] && return

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    [ -f "$dir2/$f" ] || continue
    if cmp -s "$dir1/$f" "$dir2/$f"; then
      ok=$((ok + 1))
    else
      echo "[DIFFERS] $label: $f"
      bad=$((bad + 1))
    fi
  done <<< "$files"

  if [ "$bad" -eq 0 ]; then
    echo "[OK] $label: $ok/$ok identical"
  else
    DIFFS=$((DIFFS + bad))
  fi
}

compare_skills_content() {
  local shared_skills ok=0 bad=0
  local cursor_skills claude_skills

  cursor_skills=$(list_subdirs "$CURSOR_DIR/skills")
  claude_skills=$(list_subdirs "$CLAUDE_DIR/skills")
  shared_skills=$(comm -12 <(echo "$cursor_skills") <(echo "$claude_skills") || true)

  [ -z "$shared_skills" ] && return

  while IFS= read -r skill; do
    [ -z "$skill" ] && continue
    local f1="$CURSOR_DIR/skills/$skill/SKILL.md"
    local f2="$CLAUDE_DIR/skills/$skill/SKILL.md"
    [ -f "$f1" ] && [ -f "$f2" ] || continue

    if cmp -s "$f1" "$f2"; then
      ok=$((ok + 1))
    else
      echo "[DIFFERS] skills: $skill/SKILL.md"
      bad=$((bad + 1))
    fi
  done <<< "$shared_skills"

  if [ "$bad" -eq 0 ]; then
    echo "[OK] skills: $ok/$ok identical"
  else
    DIFFS=$((DIFFS + bad))
  fi
}

compare_shared_scripts() {
  local cursor_scripts claude_scripts shared ok=0 bad=0

  cursor_scripts=$(list_files "$CURSOR_DIR/scripts")
  claude_scripts=$(list_files "$CLAUDE_DIR/scripts")
  shared=$(comm -12 <(echo "$cursor_scripts") <(echo "$claude_scripts") || true)

  if [ -z "$shared" ]; then
    echo "[OK] scripts: no shared scripts"
    return
  fi

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    if cmp -s "$CURSOR_DIR/scripts/$f" "$CLAUDE_DIR/scripts/$f"; then
      ok=$((ok + 1))
    else
      echo "[DIFFERS] scripts: $f"
      bad=$((bad + 1))
    fi
  done <<< "$shared"

  if [ "$bad" -eq 0 ]; then
    echo "[OK] scripts: $ok/$ok shared scripts identical"
  else
    DIFFS=$((DIFFS + bad))
  fi
}

diff_mode() {
  DIFFS=0

  if [ ! -d "$CURSOR_DIR" ]; then
    echo "Error: Cursor directory not found at $CURSOR_DIR"
    exit 2
  fi
  if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Error: Claude Code directory not found at $CLAUDE_DIR"
    exit 2
  fi

  echo "=== MachinEdge Sync: diff mode ==="
  echo ""

  echo "--- Coverage ---"
  compare_file_lists "commands" "$CURSOR_DIR/commands" "$CLAUDE_DIR/commands"
  compare_skill_coverage
  echo ""

  echo "--- Content: commands ---"
  compare_dir_content "commands" "$CURSOR_DIR/commands" "$CLAUDE_DIR/commands"
  echo ""

  echo "--- Content: skills ---"
  compare_skills_content
  echo ""

  echo "--- Content: scripts (shared) ---"
  compare_shared_scripts
  echo ""

  echo "--- Summary ---"
  if [ "$DIFFS" -eq 0 ]; then
    echo "Status: IN SYNC"
    return 0
  else
    echo "Differences: $DIFFS"
    echo "Status: DRIFT DETECTED"
    return 1
  fi
}

# ---------------------------------------------------------------------------
# Check / Apply mode
# ---------------------------------------------------------------------------

detect_platform() {
  local project_dir="$1"
  if [ -f "$project_dir/.cursor/rules/project-os.mdc" ]; then
    echo "cursor"
  elif [ -f "$project_dir/.claude/CLAUDE.md" ]; then
    echo "claude-code"
  else
    echo ""
  fi
}

get_install_dir() {
  local platform="$1" project_dir="$2"
  case "$platform" in
    cursor) echo "$project_dir/.cursor" ;;
    claude-code) echo "$project_dir/.claude" ;;
  esac
}

check_mode() {
  local project_dir="${1:-.}"
  project_dir="$(cd "$project_dir" && pwd)"
  DIFFS=0

  echo "=== MachinEdge Sync: check mode ==="
  echo ""

  local platform
  platform=$(detect_platform "$project_dir")
  if [ -z "$platform" ]; then
    echo "Error: No toolkit installation detected in $project_dir"
    echo "  Expected .cursor/rules/project-os.mdc or .claude/CLAUDE.md"
    exit 2
  fi

  local source_dir="$REPO_ROOT/targets/ide/$platform"
  local install_dir
  install_dir=$(get_install_dir "$platform" "$project_dir")

  if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory not found at $source_dir"
    exit 2
  fi

  echo "Platform: $platform"
  echo "Project: $project_dir"
  echo ""

  local source_files ok=0
  source_files=$(list_files "$source_dir")

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    should_skip_source_file "$f" && continue

    local src="$source_dir/$f"
    local dst="$install_dir/$f"

    if [ ! -f "$dst" ]; then
      echo "[MISSING:install] $f"
      DIFFS=$((DIFFS + 1))
    elif cmp -s "$src" "$dst"; then
      ok=$((ok + 1))
    else
      if [ "$f" = "settings.json" ]; then
        echo "[DIFFERS] $f (settings.json — check manually, hooks may need merging)"
      else
        echo "[DIFFERS] $f"
      fi
      DIFFS=$((DIFFS + 1))
    fi
  done <<< "$source_files"

  if [ "$ok" -gt 0 ] && [ "$DIFFS" -eq 0 ]; then
    echo "[OK] $ok files up to date"
  elif [ "$ok" -gt 0 ]; then
    echo ""
    echo "$ok file(s) up to date"
  fi

  echo ""
  echo "--- Summary ---"
  if [ "$DIFFS" -eq 0 ]; then
    echo "Status: IN SYNC"
    return 0
  else
    echo "Differences: $DIFFS"
    echo "Status: OUT OF DATE"
    return 1
  fi
}

apply_mode() {
  local project_dir="${1:-.}"
  project_dir="$(cd "$project_dir" && pwd)"
  local updates=0
  local skipped=0

  echo "=== MachinEdge Sync: apply mode ==="
  echo ""

  local platform
  platform=$(detect_platform "$project_dir")
  if [ -z "$platform" ]; then
    echo "Error: No toolkit installation detected in $project_dir"
    echo "  Expected .cursor/rules/project-os.mdc or .claude/CLAUDE.md"
    exit 2
  fi

  local source_dir="$REPO_ROOT/targets/ide/$platform"
  local install_dir
  install_dir=$(get_install_dir "$platform" "$project_dir")

  if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory not found at $source_dir"
    exit 2
  fi

  echo "Platform: $platform"
  echo "Project: $project_dir"
  echo ""

  local source_files
  source_files=$(list_files "$source_dir")

  local files_to_update=()

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    should_skip_source_file "$f" && continue

    local src="$source_dir/$f"
    local dst="$install_dir/$f"

    if [ "$f" = "settings.json" ]; then
      if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
        echo "[SKIPPED] $f — requires manual merging"
        skipped=$((skipped + 1))
      fi
      continue
    fi

    if [ ! -f "$dst" ]; then
      files_to_update+=("$f")
    elif ! cmp -s "$src" "$dst"; then
      files_to_update+=("$f")
    fi
  done <<< "$source_files"

  if [ ${#files_to_update[@]} -eq 0 ]; then
    echo "All files are up to date."
    if [ "$skipped" -gt 0 ]; then
      echo "($skipped file(s) skipped — require manual handling)"
    fi
    echo ""
    echo "Status: IN SYNC"
    return 0
  fi

  echo "${#files_to_update[@]} file(s) to update:"
  echo ""
  for f in "${files_to_update[@]}"; do
    if [ ! -f "$install_dir/$f" ]; then
      echo "  NEW: $f"
    else
      echo "  MOD: $f"
    fi
  done
  echo ""

  if [ "$YES" = true ]; then
    : # proceed
  elif [ -t 0 ]; then
    read -r -p "Apply all updates? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "Aborted."
      echo ""
      echo "--- Summary ---"
      echo "Differences: ${#files_to_update[@]}"
      echo "Status: OUT OF DATE"
      return 1
    fi
  else
    echo "Error: stdin is not a terminal. Use -y/--yes to skip confirmation."
    exit 2
  fi

  for f in "${files_to_update[@]}"; do
    local src="$source_dir/$f"
    local dst="$install_dir/$f"
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "[UPDATED] $f"
    updates=$((updates + 1))
  done

  echo ""
  echo "--- Summary ---"
  echo "Updated: $updates file(s)"
  if [ "$skipped" -gt 0 ]; then
    echo "Skipped: $skipped file(s) (require manual handling)"
  fi
  echo "Status: UPDATED"
  return 0
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

ARGS=()
for arg in "$@"; do
  case "$arg" in
    -y|--yes) YES=true ;;
    -h|--help) usage ;;
    *) ARGS+=("$arg") ;;
  esac
done

MODE="${ARGS[0]:-}"
[ -z "$MODE" ] && usage

case "$MODE" in
  diff)
    diff_mode
    ;;
  check)
    check_mode "${ARGS[1]:-}"
    ;;
  apply)
    apply_mode "${ARGS[1]:-}"
    ;;
  *)
    echo "Error: Unknown mode '$MODE'"
    echo ""
    usage
    ;;
esac
