#!/usr/bin/env bash
#
# Stage Manager — Session Mirror
#
# One file. One location. Zero choices.
# Run /sm:stage-manage to start your first session.
#
# Usage:
#   cd Stage_Manager_Skills
#   bash install-practitioner.sh
#

set -euo pipefail

# ═══ Colors ═══
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}▸${NC} $1"; }
ok()    { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
fail()  { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
echo -e "${BOLD}═══ Stage Manager — Session Mirror ═══${NC}"
echo ""

# ═══ Locate the repo ═══

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd 2>/dev/null || true)"

if [[ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ]]; then
    REPO_DIR="$SCRIPT_DIR"
elif [[ -f ".claude-plugin/plugin.json" ]]; then
    REPO_DIR="$(pwd)"
else
    fail "Run this script from the Stage_Manager_Skills repo root, or use the full path."
fi

# ═══ Create session mirror ═══

MIRROR_DIR="$HOME/.stage-manager"

mkdir -p "$MIRROR_DIR"

# ── session-journal.md ──

if [[ ! -f "$MIRROR_DIR/session-journal.md" ]]; then
    cat > "$MIRROR_DIR/session-journal.md" << 'JOURNAL'
# Stage Manager — Session Journal

---

[Sessions append here automatically]

---
JOURNAL
    ok "session-journal.md — created"
else
    ok "session-journal.md — already exists, keeping your data"
fi

# ── CLAUDE.md ──

cat > "$MIRROR_DIR/CLAUDE.md" << 'CLAUDEMD'
# Stage Manager — Session Mirror

You are working with a Stage Manager builder.

At the start of every session:
1. Read session-journal.md for history

At the end of every session:
1. Append a session entry to session-journal.md using this format:

## Session [N] — [date]

**One thing:** [what the builder wanted to move]
**What moved:** [what actually happened]
**Pattern noticed:** [one observation about how they worked]
**Open:** [what carries forward]
CLAUDEMD
ok "CLAUDE.md — created"

# ═══ Symlink ═══

SYMLINK_PATH="$REPO_DIR/.practitioner"

if [[ -L "$SYMLINK_PATH" ]]; then
    rm "$SYMLINK_PATH"
fi

if [[ ! -e "$SYMLINK_PATH" ]]; then
    ln -s "$MIRROR_DIR" "$SYMLINK_PATH"
    ok "Symlink: .practitioner → $MIRROR_DIR"
fi

# ═══ .gitignore ═══

GITIGNORE="$REPO_DIR/.gitignore"

for entry in ".practitioner/" ".practitioner"; do
    if [[ -f "$GITIGNORE" ]]; then
        grep -qxF "$entry" "$GITIGNORE" || echo "$entry" >> "$GITIGNORE"
    else
        echo "$entry" > "$GITIGNORE"
    fi
done
ok ".gitignore updated"

# ═══ Clipboard ═══

if command -v pbcopy &>/dev/null; then
    pbcopy < "$MIRROR_DIR/CLAUDE.md"
    CLIP_MSG="Copied to clipboard."
elif command -v xclip &>/dev/null; then
    xclip -selection clipboard < "$MIRROR_DIR/CLAUDE.md"
    CLIP_MSG="Copied to clipboard."
elif command -v xsel &>/dev/null; then
    xsel --clipboard --input < "$MIRROR_DIR/CLAUDE.md"
    CLIP_MSG="Copied to clipboard."
else
    CLIP_MSG="Copy $MIRROR_DIR/CLAUDE.md to your Claude project settings."
fi

# ═══ Done ═══

echo ""
echo -e "${BOLD}═══ Session Mirror installed ═══${NC}"
echo ""
echo "  $MIRROR_DIR"
echo "  $CLIP_MSG"
echo ""
echo "  Paste into your Claude project settings, then:"
echo ""
echo "  /sm:stage-manage"
echo ""
echo "──────────────────────────────────────────────"
echo "  When you outgrow the mirror —"
echo "  → mnfst.ai/practitioner"
echo "──────────────────────────────────────────────"
echo ""
