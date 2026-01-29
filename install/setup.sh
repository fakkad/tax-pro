#!/bin/bash

# Tax Pro Setup Script
# Installs Tax Pro extensions to your Claude Code configuration

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "╔═══════════════════════════════════════╗"
echo "║         Tax Pro Setup                 ║"
echo "║   Your AI Tax Strategist              ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Determine script directory (where tax-pro repo is)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Claude config directory
CLAUDE_DIR="$HOME/.claude"

# Check if Claude Code config exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}Creating ~/.claude directory...${NC}"
    mkdir -p "$CLAUDE_DIR"
fi

# Create subdirectories if needed
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/rules"

# Copy agents
echo "Installing tax-strategist agent..."
cp "$REPO_DIR/.claude/agents/tax-strategist.md" "$CLAUDE_DIR/agents/"

# Copy commands
echo "Installing /tax-intake command..."
cp "$REPO_DIR/.claude/commands/tax-intake.md" "$CLAUDE_DIR/commands/"

# Copy rules
echo "Installing security rules..."
cp "$REPO_DIR/.claude/rules/tax-security.md" "$CLAUDE_DIR/rules/"

# Copy example profile if user doesn't have one
if [ ! -f "$CLAUDE_DIR/tax-profile.yaml" ]; then
    echo "Creating example tax profile..."
    cp "$REPO_DIR/install/tax-profile.example.yaml" "$CLAUDE_DIR/tax-profile.yaml"
    echo -e "${YELLOW}Created ~/.claude/tax-profile.yaml — edit this or run /tax-intake${NC}"
else
    echo -e "${YELLOW}Existing tax-profile.yaml found — not overwriting${NC}"
fi

echo ""
echo -e "${GREEN}✓ Tax Pro installed successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Open Claude Code"
echo "  2. Run: /tax-intake"
echo "  3. Complete the intake interview"
echo "  4. Ask: 'Load the tax-strategist agent and review my situation'"
echo ""
echo "Your profile is stored at: ~/.claude/tax-profile.yaml"
echo "Delete that file anytime to clear your data."
echo ""
