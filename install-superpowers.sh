#!/usr/bin/env bash
#
# Stage Manager — Superpowers Installer
#
# Installs all 11 Stage Manager skills into Claude Code alongside Superpowers.
# Does NOT modify Superpowers commands — Stage Manager and Superpowers stay
# independent. Shape with Stage Manager, then hand off to Superpowers.
#
# Usage:
#   git clone https://github.com/Mnfst-AI/Stage_Manager_Skills.git
#   cd Stage_Manager_Skills
#   bash install-superpowers.sh
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
echo -e "${BOLD}═══ Stage Manager — Superpowers Installer ═══${NC}"
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

# ═══ Step 2: Check for Superpowers ═══

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
COMMANDS_DIR="$CLAUDE_DIR/commands"

if [[ ! -d "$CLAUDE_DIR" ]]; then
    mkdir -p "$CLAUDE_DIR"
    info "Created $CLAUDE_DIR"
fi

mkdir -p "$SKILLS_DIR"

# Check if Superpowers is installed
SUPERPOWERS_FOUND=false

# Common Superpowers locations
for candidate in \
    "$SKILLS_DIR/superpowers" \
    "$COMMANDS_DIR/superpowers" \
    "$CLAUDE_DIR/plugins/superpowers"; do
    if [[ -d "$candidate" ]]; then
        SUPERPOWERS_FOUND=true
        ok "Superpowers found at $candidate"
        break
    fi
done

# Also check for Superpowers skill files
if [[ "$SUPERPOWERS_FOUND" == "false" ]]; then
    if find "$SKILLS_DIR" -name "*.md" -exec grep -l "superpowers\|using-superpowers" {} \; 2>/dev/null | head -1 | grep -q .; then
        SUPERPOWERS_FOUND=true
        ok "Superpowers skills detected"
    fi
fi

if [[ "$SUPERPOWERS_FOUND" == "false" ]]; then
    warn "Superpowers not detected in ~/.claude/"
    echo ""
    echo "  Stage Manager works best alongside Superpowers."
    echo "  Install Superpowers first via the Anthropic Claude Code marketplace,"
    echo "  or from: https://github.com/obra/superpowers"
    echo ""
    read -r -p "  Continue installing Stage Manager anyway? [y/N] " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo ""
        info "Install Superpowers first, then re-run this script."
        exit 0
    fi
    echo ""
fi

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
        ((SKIPPED++))
        continue
    fi

    if [[ -L "$TARGET" ]]; then
        CURRENT_TARGET="$(readlink "$TARGET")"
        if [[ "$CURRENT_TARGET" == "$SOURCE" ]]; then
            ((SKIPPED++))
            continue
        fi
        rm "$TARGET"
    elif [[ -d "$TARGET" ]]; then
        warn "Existing skill directory at $TARGET — backing up to ${TARGET}.bak"
        mv "$TARGET" "${TARGET}.bak"
    fi

    ln -s "$SOURCE" "$TARGET"
    ((INSTALLED++))
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
        ((ERRORS++))
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
echo "  Superpowers: untouched"
echo ""
echo "  ── How to use Stage Manager with Superpowers ──"
echo ""
echo "  1. Shape your spec:"
echo "     /sm:shape:find-holes     ← find spec gaps"
echo "     /sm:shape:collapsed-options  ← find pre-made decisions"
echo "     /sm:shape:risk-sequence  ← sequence by risk"
echo "     /sm:shape:soul-check     ← check the animating idea"
echo ""
echo "  2. Brief and stage:"
echo "     /sm:shape:brief          ← synthesize findings, accept/reject"
echo "                             inline changes, generate:"
echo "                             → Stage_Manager_Brief.md"
echo "                             → [Spec_Name]-Staged.md"
echo ""
echo "  3. Hand off to Superpowers:"
echo "     Paste Stage_Manager_Brief.md (+ your chosen spec)"
echo "     into your Superpowers session. Superpowers handles"
echo "     planning and execution from there."
echo ""
echo "  Stage skills (during the build):"
echo "     /sm:stage:chunking       ← break work into CoD-sequenced chunks"
echo "     /sm:stage:prompt-craft   ← craft scoped prompts"
echo "     /sm:stage:live-mirror    ← surface what the tool invented"
echo "     /sm:stage:decision-capture ← full build manifest"
echo "     /sm:coherence-check      ← quick pulse check mid-build"
echo ""
echo -e "${CYAN}═══ Stage Manager · github.com/Mnfst-AI/Stage_Manager_Skills ═══${NC}"
echo ""
