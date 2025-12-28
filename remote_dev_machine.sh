#!/usr/bin/env bash
# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Detect if running as root
if [ "$EUID" -eq 0 ]; then
    log_warn "Running as root - sudo will be omitted from commands"
    SUDO=""
else
    log_info "Running as non-root user - using sudo"
    SUDO="sudo"
fi

main() {
    # Install sudo if not present (only matters if root)
    if ! command -v sudo &> /dev/null; then
        apt update && apt install -y sudo
    fi
    
    log_info "Installing apt packages..."
    $SUDO apt update && $SUDO apt install -y git nvtop tmux htop zsh exa bat magic-wormhole
    
    log_info "Installing Neovim (latest)..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    $SUDO rm -rf /opt/nvim
    $SUDO tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
    $SUDO ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    
    log_info "Installing locales..."
    $SUDO apt install -y --no-install-recommends locales
    $SUDO locale-gen "en_US.UTF-8"
    
    log_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    log_info "Sourcing uv environment..."
    if ! command -v uv &> /dev/null; then
        source $HOME/.local/bin/env
    fi
    
    log_info "Installing zsh and oh my zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    $SUDO chsh -s $(which zsh) $USER
    
    log_info "Installing starship..."
    curl -sS https://starship.rs/install.sh | $SUDO sh -s -- -y
    
    log_info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    
    log_info "Updating .zshrc..."
    cat > $HOME/.zshrc << 'EOL'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export LANG="en_US.UTF-8"
alias ls="exa"
alias ll="exa -lal"
alias gs="git status"
alias gl="git pull"
alias gp="git push"
alias gm="git commit -s -m"
alias ga="git add"
alias sq="squeue"
alias sb="sbatch"
alias si="sinfo"
alias sc="scancel"
source $HOME/.local/bin/env
eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
EOL
    
    log_info "Setting up git aliases..."
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    
    log_info "Installing LazyVim..."
    mv ~/.config/nvim{,.bak} 2>/dev/null || true
    mv ~/.local/share/nvim{,.bak} 2>/dev/null || true
    mv ~/.local/state/nvim{,.bak} 2>/dev/null || true
    mv ~/.cache/nvim{,.bak} 2>/dev/null || true
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    
    log_info "Installing Node.js 20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO -E bash -
    $SUDO apt install -y nodejs
    
    log_info "Installing Claude Code..."
    $SUDO npm install -g @anthropic-ai/claude-code
    
    log_info "Adding alacritty info..."
    curl -sSL https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info | tic -x -
    
    log_info "Installation completed! Please restart your shell and run 'zsh'"
}

main
