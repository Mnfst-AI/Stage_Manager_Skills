#!/usr/bin/env bash
#
# Stage Manager — Enhanced Compound Engineering Installer
#
# Installs Stage Manager skills and enhanced CE workflows into Claude Code.
#
# If Compound Engineering is already installed, it backs up the originals
# and overlays the enhanced versions with Stage Manager gates.
#
# If Compound Engineering is NOT installed, it installs stock CE first,
# then overlays the enhanced versions — giving you everything in one shot.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Mnfst-AI/Stage_Manager_Skills/main/install-enhanced-ce.sh | bash
#
# Or clone the repo and run locally:
#   git clone https://github.com/Mnfst-AI/Stage_Manager_Skills.git
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

# ═══ Step 1: Locate the Stage Manager repo ═══

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd 2>/dev/null || true)"
CLEANUP_CLONE=false

if [[ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ]]; then
    REPO_DIR="$SCRIPT_DIR"
elif [[ -f ".claude-plugin/plugin.json" ]]; then
    REPO_DIR="$(pwd)"
else
    info "Cloning Stage Manager repo..."
    TMPDIR_CLONE="$(mktemp -d)"
    git clone --depth 1 https://github.com/Mnfst-AI/Stage_Manager_Skills.git "$TMPDIR_CLONE/Stage_Manager_Skills" 2>/dev/null
    REPO_DIR="$TMPDIR_CLONE/Stage_Manager_Skills"
    CLEANUP_CLONE=true
    ok "Cloned to temporary directory"
fi

info "Using Stage Manager repo at: $REPO_DIR"

# ═══ Step 2: Set up directories ═══

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SKILLS_DIR="$CLAUDE_DIR/skills"
CE_DIR="$COMMANDS_DIR/ce"
CE_BACKUP_DIR="$COMMANDS_DIR/ce.backup"

CE_FILES=(brainstorm.md compound.md plan.md review.md work.md)

if [[ ! -d "$CLAUDE_DIR" ]]; then
    mkdir -p "$CLAUDE_DIR"
    info "Created $CLAUDE_DIR"
fi

mkdir -p "$COMMANDS_DIR"
mkdir -p "$SKILLS_DIR"

# ═══ Step 3: Handle Compound Engineering ═══

CE_REPO_URL="https://github.com/EveryInc/compound-engineering-plugin.git"
CLEANUP_CE_CLONE=false

if [[ -d "$CE_DIR" ]]; then
    CE_COMPLETE=true
    for f in "${CE_FILES[@]}"; do
        if [[ ! -f "$CE_DIR/$f" ]]; then
            CE_COMPLETE=false
            break
        fi
    done

    if [[ "$CE_COMPLETE" == "true" ]]; then
        ok "Compound Engineering found at $CE_DIR"

        if [[ -d "$CE_BACKUP_DIR" ]]; then
            warn "Backup already exists at $CE_BACKUP_DIR — skipping backup"
        else
            info "Backing up original CE commands to ce.backup/..."
            mkdir -p "$CE_BACKUP_DIR"
            for f in "${CE_FILES[@]}"; do
                cp "$CE_DIR/$f" "$CE_BACKUP_DIR/$f"
            done
            ok "Original CE commands backed up"
        fi
    else
        warn "CE directory exists but appears incomplete — will reinstall stock CE first"
        CE_NEEDS_INSTALL=true
    fi
else
    info "Compound Engineering not found — installing it now"
    CE_NEEDS_INSTALL=true
fi

if [[ "${CE_NEEDS_INSTALL:-false}" == "true" ]]; then
    info "Cloning Compound Engineering from Every.io..."
    CE_TMPDIR="$(mktemp -d)"
    CLEANUP_CE_CLONE=true

    if ! git clone --depth 1 "$CE_REPO_URL" "$CE_TMPDIR/ce-plugin" 2>/dev/null; then
        fail "Could not clone Compound Engineering from $CE_REPO_URL. Check your internet connection."
    fi

    ok "Compound Engineering cloned"

    CE_SOURCE_DIR=""

    for candidate in \
        "$CE_TMPDIR/ce-plugin/.claude/commands/ce" \
        "$CE_TMPDIR/ce-plugin/commands/ce" \
        "$CE_TMPDIR/ce-plugin/commands" \
        "$CE_TMPDIR/ce-plugin/.claude/commands" \
        "$CE_TMPDIR/ce-plugin/src/commands/ce" \
        "$CE_TMPDIR/ce-plugin/src/commands" \
        "$CE_TMPDIR/ce-plugin"; do
        if [[ -f "$candidate/brainstorm.md" && -f "$candidate/work.md" ]]; then
            CE_SOURCE_DIR="$candidate"
            break
        fi
    done

    if [[ -z "$CE_SOURCE_DIR" ]]; then
        FOUND_BRAINSTORM="$(find "$CE_TMPDIR/ce-plugin" -name "brainstorm.md" -path "*/ce/*" 2>/dev/null | head -1)"
        if [[ -n "$FOUND_BRAINSTORM" ]]; then
            CE_SOURCE_DIR="$(dirname "$FOUND_BRAINSTORM")"
        fi
    fi

    if [[ -z "$CE_SOURCE_DIR" ]]; then
        FOUND_BRAINSTORM="$(find "$CE_TMPDIR/ce-plugin" -name "brainstorm.md" 2>/dev/null | head -1)"
        if [[ -n "$FOUND_BRAINSTORM" ]]; then
            CE_SOURCE_DIR="$(dirname "$FOUND_BRAINSTORM")"
        fi
    fi

    if [[ -z "$CE_SOURCE_DIR" ]]; then
        rm -rf "$CE_TMPDIR"
        fail "Could not find CE command files in the cloned repo. Install CE manually first:\n  Inside Claude Code, run: /install-plugin EveryInc/compound-engineering-plugin\n  Then re-run this installer."
    fi

    info "Found CE commands at: $CE_SOURCE_DIR"

    mkdir -p "$CE_DIR"
    for f in "${CE_FILES[@]}"; do
        if [[ -f "$CE_SOURCE_DIR/$f" ]]; then
            cp "$CE_SOURCE_DIR/$f" "$CE_DIR/$f"
        else
            warn "CE command not found in source: $f"
        fi
    done

    CE_SKILLS_DIR=""
    for candidate in \
        "$CE_TMPDIR/ce-plugin/.claude/skills" \
        "$CE_TMPDIR/ce-plugin/skills"; do
        if [[ -d "$candidate" ]]; then
            CE_SKILLS_DIR="$candidate"
            break
        fi
    done

    if [[ -n "$CE_SKILLS_DIR" ]]; then
        info "Installing CE skills..."
        cp -r "$CE_SKILLS_DIR"/* "$SKILLS_DIR/" 2>/dev/null || true
        ok "CE skills installed"
    fi

    mkdir -p "$CE_BACKUP_DIR"
    for f in "${CE_FILES[@]}"; do
        if [[ -f "$CE_DIR/$f" ]]; then
            cp "$CE_DIR/$f" "$CE_BACKUP_DIR/$f"
        fi
    done

    ok "Stock Compound Engineering installed and backed up"
fi

# ═══ Step 4: Overlay enhanced CE commands ═══

ENHANCED_CE_DIR="$REPO_DIR/plugins/compound-engineering/commands/ce"

if [[ ! -d "$ENHANCED_CE_DIR" ]]; then
    fail "Enhanced CE commands not found at $ENHANCED_CE_DIR"
fi

info "Installing enhanced CE commands (Stage Manager gates)..."
for f in "${CE_FILES[@]}"; do
    if [[ -f "$ENHANCED_CE_DIR/$f" ]]; then
        cp "$ENHANCED_CE_DIR/$f" "$CE_DIR/$f"
    fi
done
ok "Enhanced CE commands installed"

# ═══ Step 5: Install Stage Manager skills ═══

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

for f in "${CE_FILES[@]}"; do
    if ! grep -qi "stage.manager\|coherence\|soul.check\|find.the.holes\|shape.brief" "$CE_DIR/$f" 2>/dev/null; then
        warn "  $CE_DIR/$f may not have Stage Manager integration"
        ((ERRORS++))
    fi
done

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

if [[ "$CLEANUP_CLONE" == "true" ]]; then
    rm -rf "$TMPDIR_CLONE"
fi

if [[ "$CLEANUP_CE_CLONE" == "true" ]]; then
    rm -rf "$CE_TMPDIR"
fi

# ═══ Summary ═══

echo ""
echo -e "${BOLD}═══ Installation Complete ═══${NC}"
echo ""
echo "  Enhanced CE commands:  $CE_DIR"
echo "  Original CE backup:    $CE_BACKUP_DIR"
echo "  Stage Manager skills:  $SKILLS_DIR"
echo ""
echo "  ── The Shape Brief Flow ──"
echo "  Run shape skills → /sm:shape:brief"
echo "  Accept/reject inline changes →"
echo "    Stage_Manager_Brief.md + [Spec_Name]-Staged.md"
echo "  → /ce:brainstorm, /ce:plan, or /ce:work"
echo ""
echo "  CE Pipeline (with Stage Manager gates):"
echo "    /ce:brainstorm  /ce:plan  /ce:work  /ce:review  /ce:compound"
echo ""
echo "  Stage Manager — Shape:"
echo "    /sm:shape:find-holes  /sm:shape:collapsed-options  /sm:shape:risk-sequence"
echo "    /sm:shape:soul-check  /sm:shape:brief  /sm:shape:gate"
echo ""
echo "  Stage Manager — Stage:"
echo "    /sm:stage:chunking  /sm:stage:prompt-craft"
echo "    /sm:stage:live-mirror  /sm:stage:decision-capture"
echo ""
echo "  Stage Manager — Any Node:"
echo "    /sm:coherence-check"
echo ""
echo "  To restore original CE:  cp ~/.claude/commands/ce.backup/* ~/.claude/commands/ce/"
echo ""
echo -e "${CYAN}═══ Stage Manager · github.com/Mnfst-AI/Stage_Manager_Skills ═══${NC}"
echo ""
