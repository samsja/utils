#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

main() {
    # Install sudo if not present
    if ! command -v sudo &> /dev/null; then
        apt update && apt install -y sudo
    fi

    log_info "Installing apt packages..."
    
    sudo apt update && sudo apt install -y git nvtop tmux htop zsh neovim exa bat magic-wormhole

    log_info "Installing locales..."
    sudo apt install -y --no-install-recommends locales
    locale-gen "en_US.UTF-8"

    log_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    log_info "Sourcing uv environment..."
    if ! command -v uv &> /dev/null; then
        source $HOME/.local/bin/env
    fi

    log_info "Installing zsh and oh my zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    chsh -s $(which zsh)

    log_info "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh

    log_info "Installing atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

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

source $HOME/.local/bin/env

eval "$(starship init zsh)"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh --disable-up-arrow)"
EOL

    log_info "Installation completed! Please restart your shell and run 'zsh'"

}

main