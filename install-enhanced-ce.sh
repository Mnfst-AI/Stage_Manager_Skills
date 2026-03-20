#!/usr/bin/env bash
#
# Stage Manager — Enhanced Compound Engineering Installer
#
# Installs Stage Manager skills and enhanced CE workflows into a user's
# Claude Code configuration. Requires Compound Engineering to already be
# installed at ~/.claude/commands/ce/.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Mnfst-AI/Stage_Manager_Skills/enhanced-cli-skills/install-enhanced-ce.sh | bash
#
# Or clone the repo and run locally:
#   git clone -b enhanced-cli-skills https://github.com/Mnfst-AI/Stage_Manager_Skills.git
#   cd Stage_Manager_Skills
#   bash install-enhanced-ce.sh
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
echo -e "${BOLD}═══ Stage Manager — Enhanced CE Installer ═══${NC}"
echo ""

# ═══ Step 1: Locate the repo ═══

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd 2>/dev/null || true)"

if [[ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ]]; then
    REPO_DIR="$SCRIPT_DIR"
elif [[ -f ".claude-plugin/plugin.json" ]]; then
    REPO_DIR="$(pwd)"
else
    # Running via curl — clone to a temp location
    info "Cloning Stage Manager repo..."
    TMPDIR_CLONE="$(mktemp -d)"
    git clone -b enhanced-cli-skills --depth 1 https://github.com/Mnfst-AI/Stage_Manager_Skills.git "$TMPDIR_CLONE/Stage_Manager_Skills" 2>/dev/null
    REPO_DIR="$TMPDIR_CLONE/Stage_Manager_Skills"
    CLEANUP_CLONE=true
    ok "Cloned to temporary directory"
fi

info "Using repo at: $REPO_DIR"

# ═══ Step 2: Check prerequisites ═══

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SKILLS_DIR="$CLAUDE_DIR/skills"
CE_DIR="$COMMANDS_DIR/ce"
CE_BACKUP_DIR="$COMMANDS_DIR/ce.backup"

# Check Claude Code is set up
if [[ ! -d "$CLAUDE_DIR" ]]; then
    fail "Claude Code config not found at $CLAUDE_DIR. Install Claude Code first."
fi

# Check Compound Engineering is installed
if [[ ! -d "$CE_DIR" ]]; then
    fail "Compound Engineering not found at $CE_DIR. Install CE first, then run this installer."
fi

CE_FILES=(brainstorm.md compound.md plan.md review.md work.md)
for f in "${CE_FILES[@]}"; do
    if [[ ! -f "$CE_DIR/$f" ]]; then
        fail "Missing CE command: $CE_DIR/$f — CE installation appears incomplete."
    fi
done

ok "Compound Engineering found at $CE_DIR"

# ═══ Step 3: Back up original CE commands ═══

if [[ -d "$CE_BACKUP_DIR" ]]; then
    warn "Backup already exists at $CE_BACKUP_DIR — skipping backup"
else
    info "Backing up original CE commands to ce.backup/..."
    mkdir -p "$CE_BACKUP_DIR"
    for f in "${CE_FILES[@]}"; do
        cp "$CE_DIR/$f" "$CE_BACKUP_DIR/$f"
    done
    ok "Original CE commands backed up to $CE_BACKUP_DIR"
fi

# ═══ Step 4: Install enhanced CE commands ═══

ENHANCED_CE_DIR="$REPO_DIR/plugins/compound-engineering/commands/ce"

if [[ ! -d "$ENHANCED_CE_DIR" ]]; then
    fail "Enhanced CE commands not found at $ENHANCED_CE_DIR"
fi

info "Installing enhanced CE commands..."
for f in "${CE_FILES[@]}"; do
    if [[ -f "$ENHANCED_CE_DIR/$f" ]]; then
        cp "$ENHANCED_CE_DIR/$f" "$CE_DIR/$f"
    fi
done
ok "Enhanced CE commands installed (Stage Manager gates integrated)"

# ═══ Step 5: Install Stage Manager skills ═══

SKILLS_SRC="$REPO_DIR/plugins/stage-manager/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
    fail "Stage Manager skills not found at $SKILLS_SRC"
fi

mkdir -p "$SKILLS_DIR"

info "Installing Stage Manager skills..."

SKILL_DIRS=(
    shape-find-holes
    shape-collapsed-options
    shape-risk-sequence
    shape-soul-check
    shape-to-stage-gate
    stage-chunking
    stage-wsjf
    stage-prompt-craft
    stage-prompt-guard
    stage-live-mirror
    stage-output-review
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
        # Already a symlink — check if it points to the right place
        CURRENT_TARGET="$(readlink "$TARGET")"
        if [[ "$CURRENT_TARGET" == "$SOURCE" ]]; then
            ((SKIPPED++))
            continue
        fi
        # Points somewhere else — remove and re-link
        rm "$TARGET"
    elif [[ -d "$TARGET" ]]; then
        # Real directory — back it up
        warn "Existing skill directory at $TARGET — backing up to ${TARGET}.bak"
        mv "$TARGET" "${TARGET}.bak"
    fi

    ln -s "$SOURCE" "$TARGET"
    ((INSTALLED++))
done

ok "Skills: $INSTALLED installed, $SKIPPED already present"

# ═══ Step 6: Install shared references ═══

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

# ═══ Step 7: Verify installation ═══

echo ""
info "Verifying installation..."

ERRORS=0

# Check CE commands have Stage Manager references
for f in "${CE_FILES[@]}"; do
    if ! grep -qi "stage.manager\|coherence\|soul.check\|find.the.holes" "$CE_DIR/$f" 2>/dev/null; then
        warn "  $CE_DIR/$f may not have Stage Manager integration"
        ((ERRORS++))
    fi
done

# Check skills are accessible
for skill in "${SKILL_DIRS[@]}"; do
    if [[ ! -f "$SKILLS_DIR/$skill/SKILL.md" ]]; then
        warn "  Skill not accessible: $skill"
        ((ERRORS++))
    fi
done

if [[ $ERRORS -eq 0 ]]; then
    ok "All checks passed"
else
    warn "$ERRORS verification warnings (see above)"
fi

# ═══ Cleanup ═══

if [[ "${CLEANUP_CLONE:-false}" == "true" ]]; then
    rm -rf "$TMPDIR_CLONE"
fi

# ═══ Summary ═══

echo ""
echo -e "${BOLD}═══ Installation Complete ═══${NC}"
echo ""
echo "  Enhanced CE commands:  $CE_DIR"
echo "  Original CE backup:   $CE_BACKUP_DIR"
echo "  Stage Manager skills:  $SKILLS_DIR"
echo ""
echo "  Slash commands now available in Claude Code:"
echo ""
echo "  CE Pipeline (with Stage Manager gates):"
echo "    /ce:brainstorm  /ce:plan  /ce:work  /ce:review  /ce:compound"
echo ""
echo "  Stage Manager — Shape:"
echo "    /shape-find-holes  /shape-collapsed-options  /shape-risk-sequence"
echo "    /shape-soul-check  /sense-shape-to-stage-gate"
echo ""
echo "  Stage Manager — Stage:"
echo "    /stage-chunking  /stage-wsjf  /stage-prompt-craft"
echo "    /stage-prompt-guard  /stage-live-mirror"
echo "    /stage-output-review  /stage-decision-capture"
echo ""
echo "  Stage Manager — Any Node:"
echo "    /coherence-check"
echo ""
echo "  To restore original CE:  cp ~/.claude/commands/ce.backup/* ~/.claude/commands/ce/"
echo ""
echo -e "${CYAN}═══ Stage Manager · github.com/Mnfst-AI/Stage_Manager_Skills ═══${NC}"
echo ""
