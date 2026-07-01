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

log_info "Installing apt packages..."
$SUDO apt update && $SUDO apt install -y git nvtop tmux htop zsh curl

log_info "Setting up git lg alias..."
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

log_info "Installing starship..."
curl -sS https://starship.rs/install.sh | $SUDO sh -s -- -y

log_info "Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-zsh --no-fish

log_info "Configuring bash..."
grep -q 'starship init bash' "$HOME/.bashrc" 2>/dev/null || echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
grep -q 'fzf.bash' "$HOME/.bashrc" 2>/dev/null || echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> "$HOME/.bashrc"
grep -q "alias sq=" "$HOME/.bashrc" 2>/dev/null || echo "alias sq='squeue'" >> "$HOME/.bashrc"
grep -q "alias sc=" "$HOME/.bashrc" 2>/dev/null || echo "alias sc='scancel'" >> "$HOME/.bashrc"

log_info "Configuring tmux..."
grep -q 'set -g mouse on' "$HOME/.tmux.conf" 2>/dev/null || echo 'set -g mouse on' >> "$HOME/.tmux.conf"

log_info "Installing Node.js 20..."
curl -fsSL https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz -o /tmp/node.tar.xz
$SUDO tar -xJf /tmp/node.tar.xz -C /opt
rm /tmp/node.tar.xz
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/node /usr/local/bin/node
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/npm /usr/local/bin/npm
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/npx /usr/local/bin/npx

log_info "Installing Claude Code..."
$SUDO /usr/local/bin/npm install -g @anthropic-ai/claude-code
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/claude /usr/local/bin/claude

log_info "Installing OpenAI Codex..."
$SUDO /usr/local/bin/npm install -g @openai/codex
$SUDO ln -sf /opt/node-v20.18.0-linux-x64/bin/codex /usr/local/bin/codex

log_info "Done. Restart your shell."
