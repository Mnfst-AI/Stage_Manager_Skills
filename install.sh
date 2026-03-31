#!/usr/bin/env bash
#
# Stage Manager — Standalone Installer
#
# Installs all 11 Stage Manager skills into Claude Code as slash commands.
# Does NOT require Compound Engineering or Superpowers.
#
# For the enhanced CE integration, use install-enhanced-ce.sh instead.
# For the Superpowers integration, use install-superpowers.sh instead.
#
# Usage:
#   git clone https://github.com/Mnfst-AI/Stage_Manager_Skills.git
#   cd Stage_Manager_Skills
#   bash install.sh
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
echo -e "${BOLD}═══ Stage Manager — Skill Installer ═══${NC}"
echo ""

# ═══ Step 1: Locate the repo ═══

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd 2>/dev/null || true)"

if [[ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ]]; then
    REPO_DIR="$SCRIPT_DIR"
elif [[ -f ".claude-plugin/plugin.json" ]]; then
    REPO_DIR="$(pwd)"
else
    fail "Run this script from the Stage_Manager_Skills repo root, or use the full path."
fi

info "Using repo at: $REPO_DIR"

# ═══ Step 2: Check prerequisites ═══

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"

if [[ ! -d "$CLAUDE_DIR" ]]; then
    mkdir -p "$CLAUDE_DIR"
    info "Created $CLAUDE_DIR"
fi

mkdir -p "$SKILLS_DIR"

# ═══ Step 3: Install Stage Manager skills ═══

SKILLS_SRC="$REPO_DIR/plugins/stage-manager/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
    fail "Stage Manager skills not found at $SKILLS_SRC"
fi

info "Installing Stage Manager skills..."

SKILL_DIRS=(
    shape-find-holes
    shape-collapsed-options
    shape-risk-sequence
    shape-soul-check
    shape-brief
    shape-to-stage-gate
    stage-chunking
    stage-prompt-craft
    stage-live-mirror
    stage-decision-capture
    coherence-check
)

INSTALLED=0
SKIPPED=0

for skill in "${SKILL_DIRS[@]}"; do
    TARGET="$SKILLS_DIR/$skill"
    SOURCE="$SKILLS_SRC/$skill"

    if [[ ! -d "$SOURCE" ]]; then
        warn "Skill source not found: $skill — skipping"
        ((SKIPPED++)) || true
        continue
    fi

    if [[ -L "$TARGET" ]]; then
        CURRENT_TARGET="$(readlink "$TARGET")"
        if [[ "$CURRENT_TARGET" == "$SOURCE" ]]; then
            ((SKIPPED++)) || true
            continue
        fi
        rm "$TARGET"
    elif [[ -d "$TARGET" ]]; then
        warn "Existing skill directory at $TARGET — backing up to ${TARGET}.bak"
        mv "$TARGET" "${TARGET}.bak"
    fi

    ln -s "$SOURCE" "$TARGET"
    ((INSTALLED++)) || true
done

ok "Skills: $INSTALLED installed, $SKIPPED already present"

# ═══ Step 4: Install shared references ═══

REFS_SRC="$REPO_DIR/plugins/shared/references"
REFS_TARGET="$SKILLS_DIR/../shared/references"

if [[ -d "$REFS_SRC" ]]; then
    info "Installing shared references..."
    mkdir -p "$(dirname "$REFS_TARGET")"
    if [[ -L "$REFS_TARGET" ]]; then
        rm "$REFS_TARGET"
    fi
    ln -s "$REFS_SRC" "$REFS_TARGET" 2>/dev/null || true
    ok "Shared references linked"
fi

# ═══ Step 5: Verify ═══

echo ""
info "Verifying installation..."

ERRORS=0
for skill in "${SKILL_DIRS[@]}"; do
    if [[ ! -f "$SKILLS_DIR/$skill/SKILL.md" ]]; then
        warn "  Skill not accessible: $skill"
        ((ERRORS++)) || true
    fi
done

if [[ $ERRORS -eq 0 ]]; then
    ok "All 11 skills verified"
else
    warn "$ERRORS verification warnings (see above)"
fi

# ═══ Summary ═══

echo ""
echo -e "${BOLD}═══ Installation Complete ═══${NC}"
echo ""
echo "  Stage Manager skills: $SKILLS_DIR"
echo ""
echo "  Slash commands now available in Claude Code:"
echo ""
echo "  Shape:"
echo "    /sm:shape:find-holes  /sm:shape:collapsed-options  /sm:shape:risk-sequence"
echo "    /sm:shape:soul-check  /sm:shape:gate"
echo ""
echo "  Shape Brief (handoff to CE or Superpowers):"
echo "    /sm:shape:brief"
echo ""
echo "  Stage:"
echo "    /sm:stage:chunking  /sm:stage:prompt-craft"
echo "    /sm:stage:live-mirror  /sm:stage:decision-capture"
echo ""
echo "  Any Node:"
echo "    /sm:coherence-check"
echo ""
echo "  ── The Shape Brief Flow ──"
echo "  Run shape skills → /sm:shape:brief → Stage_Manager_Brief.md"
echo "  + [Spec_Name]-Staged.md → CE or Superpowers"
echo ""
echo "  Want Stage Manager integrated with Compound Engineering?"
echo "  Run: bash install-enhanced-ce.sh"
echo ""
echo "  Want Stage Manager integrated with Superpowers?"
echo "  Run: bash install-superpowers.sh"
echo ""
echo -e "${CYAN}═══ Stage Manager · github.com/Mnfst-AI/Stage_Manager_Skills ═══${NC}"
echo ""
