
# Set a default Dotfiles directory
DOT_FILES="${DOT_FILES:-$HOME/dotfiles}"
source "$DOT_FILES/zsh/history.zsh"

# Disable vim mode in zsh for now.
bindkey -e

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
alias zellij="zellij -c $DOT_FILES/zellij/zellij.kdl"
alias tm="zellij attach --create --index 0" # attach to existing or create a new session
alias tmn="zellij" # tm new

alias cld="claude --continue"
alias cldn="claude" # claude new 
alias lg="lazygit"
alias cpy="pbcopy <"
alias dcr="docker"

mkcd(){
	mkdir -p "$1" && cd "$1"
	pwd
}

if [[ -n "$IS_PERSONAL" ]]; then
	echo "Using personal configuration"
	alias flutter="fvm flutter"
	alias f="flutter"
fi


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

# ── Android studio stuff ──────────────────────────────────────────────
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/30.0.3 # Change this to latest version.
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

# ── Key bindings ───────────────────────────────────────────────────────
# Bind Alt+Delete to forward delete word
bindkey '^[[3;3~' kill-word

