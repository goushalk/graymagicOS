# ================================
# Oh My Zsh
# ================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gallifrey"

plugins=(
  git
  sudo
)

source "$ZSH/oh-my-zsh.sh"

# ================================
# PATH (portable, no username leak)
# ================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export VISUAL=vim
export EDITOR="$VISUAL"
# ================================
# NVM (single clean load)
# ================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ================================
# Aliases
# ================================
alias c='clear'
alias rg='ripgrep'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias gitauth='eval "$(ssh-agent -s)" && ssh-add ~/.ssh/github'
alias ls='eza --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
# alias pacpick='yay -Slq | fzf --multi --preview 'yay -Si {}' --height=80% --reverse | xargs -r yay -S --needed --noconfirm'
alias shutdown='systemctl poweroff'

alias v='$HOME/softwares/nvim-linux-x86_64.appimage'

# tmux / sesh helper
alias tsm='sesh connect $(sesh list -i -d | gum choose)'

# ================================
# Prompt (oh-my-posh)
# ================================
# eval "$(oh-my-posh init zsh --config "$HOME/.poshthemes/arch.omp.json")"

# ================================
# Git helper function
# ================================
gcap() {
    # ----- Colors -----
    local blue red green yellow reset
    blue=$(tput setaf 4)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    reset=$(tput sgr0)

    # ----- Git sanity check -----
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "${red}[✗] Not inside a git repository${reset}"
        return 1
    fi

    # ----- Message check -----
    if [[ -z "$1" ]]; then
        echo "${red}[✗] Commit message required${reset}"
        echo "Usage: gcap \"message\""
        return 1
    fi

    # ----- Branch detection -----
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -z "$branch" ]]; then
        echo "${red}[✗] Detached HEAD state${reset}"
        return 1
    fi

    # ----- Show status before doing anything -----
    echo ""
    echo "${yellow}[i] Current status:${reset}"
    git status --short
    echo ""

    # ----- Stage changes -----
    echo "${blue}[+] Staging changes...${reset}"
    git add .

    # ----- Check if anything was staged -----
    if git diff --cached --quiet; then
        echo "${yellow}[!] No changes to commit${reset}"
        return 0
    fi

    # ----- Commit -----
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "${blue}[+] Committing on '${branch}'...${reset}"
    git commit -m "$1 — $timestamp" || {
        echo "${red}[✗] Commit failed${reset}"
        return 1
    }

    # ----- Push (with upstream auto-fix) -----
    echo "${blue}[+] Pushing to origin/${branch}...${reset}"
    if ! git push; then
        echo "${yellow}[!] No upstream found. Setting upstream...${reset}"
        git push -u origin "$branch" || {
            echo "${red}[✗] Push failed${reset}"
            return 1
        }
    fi

    echo ""
    echo "${green}[✓] Done. Clean push on '${branch}'.${reset}"
}


# ================================
# Zinit (plugin manager)
# ================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

autoload -U compinit && compinit

# ================================
# Local overrides (NOT tracked)
# ================================
# Create ~/.zshrc.local for private stuff
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"


