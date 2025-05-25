export STARSHIP_CONFIG=~/dotfiles/starship/starship.toml
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"

alias l='lsd -ali'
alias cat='bat'
alias cd='z'
alias ci='zi'
alias nv='nvim'

# ── python stuff ──────────────────────────────────────────────────────
alias python='python3'
alias py='python3'
alias pysour='source ./venv/bin/activate'
alias pip='pip3'
alias v='nvim'

# ── Tmux stuff ────────────────────────────────────────────────────────
# alias tmux="tmux -f '$DOT_FILES/tmux/tmux.conf'"
alias tm="tmux"
alias tms="tmux source-file '$DOT_FILES/tmux/tmux.conf'"
alias tmk="tmux kill-server"

alias cld="claude --continue"
alias lg="lazygit"

export XDG_CONFIG_HOME="$HOME/.config"

# Locale settings
export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# Use Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
