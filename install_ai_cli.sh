#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# --- Node.js 20 (prerequisite for both CLIs) ---
if command -v node &>/dev/null && node -v | grep -q 'v20'; then
    log_info "Node.js 20 already installed, skipping..."
else
    log_info "Installing Node.js 20..."
    curl -fsSL https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz -o /tmp/node.tar.xz
    $SUDO tar -xJf /tmp/node.tar.xz -C /opt
    rm /tmp/node.tar.xz
    $SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/node /usr/local/bin/node
    $SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/npm /usr/local/bin/npm
    $SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/npx /usr/local/bin/npx
fi

# --- Claude Code ---
log_info "Installing Claude Code..."
$SUDO /usr/local/bin/npm install -g @anthropic-ai/claude-code
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/claude /usr/local/bin/claude 2>/dev/null || true

# --- OpenAI Codex ---
log_info "Installing OpenAI Codex..."
$SUDO /usr/local/bin/npm install -g @openai/codex
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/codex /usr/local/bin/codex 2>/dev/null || true

log_info "Done. Run 'claude' or 'codex' to get started."
