#!/bin/bash

# MachinEdge Expert Teams — Migrate SDLC
# Usage: ./migrate-sdlc.sh [target-directory]
#
# Relocates canonical spec artifacts from docs/ to .sdlc/:
#   - Named spec files (architecture.md, test-plan.md, etc.)
#   - Draft globs (docs/*-draft.md matching <spec>.*-draft.md)
#   - Spec subfolders (research/, security/, runbooks/)
#
# Leaves user-facing files untouched (docs/guides/, README.md, etc.).
# Idempotent: safe to re-run. Collision-safe: reports and skips, never clobbers.
# Exits 0 when clean; non-zero if any collision occurred.

set -e

# ─────────────────────────────────────────────
# Configuration and validation (SR-005)
# ─────────────────────────────────────────────

# Use ${1-.} (substitute default only when UNSET) — not ${1:-.} (which also
# substitutes on empty). An explicit empty-string target must reach the guard
# below and be rejected, never silently treated as the current directory.
TARGET="${1-.}"

# Resolve and validate target (SR-005)
if [ -z "$TARGET" ]; then
    echo "Error: target directory is empty or missing." >&2
    exit 1
fi

TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || {
    echo "Error: target directory does not exist or is not accessible: $1" >&2
    exit 1
}

if [ ! -d "$TARGET" ]; then
    echo "Error: target is not a directory: $TARGET" >&2
    exit 1
fi

# State tracking
COLLISIONS=0
RELOCATED=""

# Canonical spec names (without extension). Draft files migrate only when their
# basename starts with one of these followed by a dot: <spec>.*-draft.md.
# Any other *-draft.md (e.g. a user's my-blog-post-draft.md) is left untouched.
CANONICAL_SPECS="architecture pipeline components documentation-plan test-plan \
security-requirements ux-guidelines task-detail-standard env-context release-plan"

# is_canonical_draft(basename) — true if basename matches <canonical-spec>.*-draft.md
is_canonical_draft() {
    local fname="$1" spec
    case "$fname" in
        *-draft.md) ;;
        *) return 1 ;;
    esac
    for spec in $CANONICAL_SPECS; do
        case "$fname" in
            "$spec".*-draft.md) return 0 ;;
        esac
    done
    return 1
}

# ─────────────────────────────────────────────
# Migration functions
# ─────────────────────────────────────────────

# migrate_file(src, dest)
# Move src to dest if dest doesn't exist. On collision, report and leave both in place.
migrate_file() {
    local src="$1" dest="$2"

    # Absent source = nothing to do (optional)
    [ -f "$src" ] || return 0

    # Collision: dest already exists
    if [ -e "$dest" ]; then
        echo "COLLISION: $src and $dest both exist; not moving. Resolve manually." >&2
        COLLISIONS=1
        return 0
    fi

    # Move it
    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest"
    echo "  ${src#$TARGET/} → ${dest#$TARGET/}"
    RELOCATED="$RELOCATED $src->$dest"
}

# migrate_dir(src, dest)
# Move src/ to dest/ if dest doesn't exist. On collision, report and skip.
migrate_dir() {
    local src="$1" dest="$2"

    # Absent source = nothing to do (optional)
    [ -d "$src" ] || return 0

    # Collision: dest already exists
    if [ -d "$dest" ]; then
        echo "COLLISION: $src and $dest both exist; not moving. Resolve manually." >&2
        COLLISIONS=1
        return 0
    fi

    # Move it
    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest"
    echo "  ${src#$TARGET/} → ${dest#$TARGET/}"
    RELOCATED="$RELOCATED $src->$dest"
}

# ─────────────────────────────────────────────
# Migrate canonical files
# ─────────────────────────────────────────────

# Canonical file inventory (from docs/architecture.m19-draft.md, ADR-M19-3)
for f in \
    architecture.md \
    pipeline.md \
    components.md \
    documentation-plan.md \
    test-plan.md \
    security-requirements.md \
    ux-guidelines.md \
    task-detail-standard.md \
    env-context.md \
    release-plan.md; do
    migrate_file "$TARGET/docs/$f" "$TARGET/.sdlc/$f"
done

# ─────────────────────────────────────────────
# Migrate draft globs
# ─────────────────────────────────────────────

# Expand docs/*-draft.md and filter to the canonical <spec>.*-draft.md pattern
# (i.e., only migration-owned drafts, not arbitrary user files such as a blog post).
for src in "$TARGET"/docs/*-draft.md; do
    [ -f "$src" ] || continue
    fname=$(basename "$src")
    # Only migrate drafts of canonical specs; leave any other *-draft.md untouched.
    is_canonical_draft "$fname" || continue
    dest="$TARGET/.sdlc/$fname"
    migrate_file "$src" "$dest"
done

# ─────────────────────────────────────────────
# Migrate spec subfolders
# ─────────────────────────────────────────────

for subdir in research security runbooks; do
    migrate_dir "$TARGET/docs/$subdir" "$TARGET/.sdlc/$subdir"
done

# ─────────────────────────────────────────────
# Verify: re-scan docs/ for any remaining inventory items
# (excluding collisions, which are expected to still be present)
# ─────────────────────────────────────────────

verify_clean() {
    local remaining=0

    # Only report verification failure if there are ALSO no collisions recorded
    # (collisions are expected to leave files in place)
    # If collisions occurred, we exit non-zero anyway

    # Check for remaining canonical files (ignore if collision occurred)
    for f in \
        architecture.md \
        pipeline.md \
        components.md \
        documentation-plan.md \
        test-plan.md \
        security-requirements.md \
        ux-guidelines.md \
        task-detail-standard.md \
        env-context.md \
        release-plan.md; do
        if [ -f "$TARGET/docs/$f" ] && [ "$COLLISIONS" != "1" ]; then
            echo "  Verification failed: $TARGET/docs/$f still exists (should be moved)" >&2
            remaining=1
        fi
    done

    # Check for remaining canonical draft globs (ignore if collision occurred).
    # A correctly-skipped user draft (non-canonical) is NOT a failure here.
    for src in "$TARGET"/docs/*-draft.md; do
        [ -f "$src" ] || continue
        is_canonical_draft "$(basename "$src")" || continue
        if [ "$COLLISIONS" != "1" ]; then
            echo "  Verification failed: ${src#$TARGET/} still exists (should be moved)" >&2
            remaining=1
        fi
    done

    # Check for remaining spec subfolders (ignore if collision occurred)
    for subdir in research security runbooks; do
        if [ -d "$TARGET/docs/$subdir" ] && [ "$COLLISIONS" != "1" ]; then
            echo "  Verification failed: $TARGET/docs/$subdir still exists (should be moved)" >&2
            remaining=1
        fi
    done

    return "$remaining"
}

# ─────────────────────────────────────────────
# Report and exit
# ─────────────────────────────────────────────

if ! verify_clean; then
    # Verification failed for reasons other than collisions
    exit 1
fi

# Count relocated specs (entries are space-separated src->dest tokens).
RELOCATED_COUNT=0
for _ in $RELOCATED; do
    RELOCATED_COUNT=$((RELOCATED_COUNT + 1))
done

# Collisions: report and exit non-zero. Do NOT print the "Already clean" line —
# it would be misleading on a collision-only run.
if [ "$COLLISIONS" = "1" ]; then
    echo "" >&2
    echo "Error: One or more collisions occurred. Resolve manually, then re-run." >&2
    exit 1
fi

# Success: print an explicit verification summary.
if [ "$RELOCATED_COUNT" -gt 0 ]; then
    echo "Migration complete: $RELOCATED_COUNT spec(s) relocated, docs/ now clean of specs."
else
    echo "Already clean — no specs to migrate."
fi

exit 0
