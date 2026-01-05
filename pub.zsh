# Set a default Dotfiles directory
DOT_FILES="${DOT_FILES:-$HOME/dotfiles}"
source "$DOT_FILES/zsh/history.zsh"

eval "$(zoxide init zsh)"

# Disable vim mode in zsh for now.
bindkey -e

export BAT_CONFIG_DIR="$DOT_FILES/bat"

export STARSHIP_CONFIG=~/dotfiles/starship/starship.toml
export STARSHIP_CACHE=~/.starship/cache
if command -v starship &> /dev/null; then
	eval "$(starship init zsh)"
fi

alias l='lsd -ali'
alias cat='bat'
alias cd='z'
alias ci='zi'
alias nv='nvim'
alias f='flutter'

# ── python stuff ──────────────────────────────────────────────────────
alias python='python3'
alias py='python3'
alias pip='pip3'

# Auto-activate venv on cd
autoload -U add-zsh-hook
_auto_venv() {
	if [[ -d .venv ]]; then
		source .venv/bin/activate
		echo "venv activated: .venv"
	elif [[ -d venv ]]; then
		source venv/bin/activate
		echo "venv activated: venv"
	elif [[ -n "$VIRTUAL_ENV" ]]; then
		deactivate
	fi
}
add-zsh-hook chpwd _auto_venv
_auto_venv
alias v='nvim'

# ── Tmux stuff ────────────────────────────────────────────────────────
export ZELLIJ_CONFIG_DIR="$DOT_FILES/zellij"
alias tm="zellij attach --create --index 0" # attach to existing or create a new session
alias tmn="zellij" # tm new

alias gem="gemini -r"
alias cld="claude"
alias cldn="claude" # claude new 
alias lg="lazygit"
alias ld="lazydocker"
alias cpy="pbcopy <"
alias dk="docker"
alias dc="docker compose"
alias cont="container"
alias t="just"
alias tt='just -g'

alias nt="nvim --cmd 'let g:auto_session_enabled=v:false' +term"

# ── AI stuff ──────────────────────────────────────────────────────────
alias qr="q chat --resume"
alias ql="q login"

mkcd(){
	mkdir -p "$1" && cd "$1"
	pwd
}

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Add dotfiles scripts to PATH
export PATH="$HOME/dotfiles/scripts:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"

# Locale settings
export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# Use Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Enforce use of virtual environments for pip
export PIP_REQUIRE_VIRTUAL_ENV=true

if [[ -n "$IS_PERSONAL" ]]; then
	echo "Using personal configuration"
	# alias flutter="fvm flutter
fi


# Add Homebrew completions to fpath
if command -v brew &> /dev/null; then
	BREW_PREFIX="$(brew --prefix)"
	fpath+=("$BREW_PREFIX/share/zsh/site-functions")
fi

# Load completion system (handles compinit, fzf, fzf-tab, syntax plugins, etc.)
source "$DOT_FILES/zsh/completion.zsh"

# ── macOS-specific stuff ──────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
	# Android studio stuff
	export ANDROID_HOME=~/Library/Android/sdk
	export PATH=$PATH:$ANDROID_HOME/platform-tools
	export PATH=$PATH:$ANDROID_HOME/build-tools/30.0.3 # Change this to latest version.
	export PATH=$PATH:$ANDROID_HOME/tools
	export PATH=$PATH:$ANDROID_HOME/tools/bin

	# Java stuff
	export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
fi

# ── Key bindings ───────────────────────────────────────────────────────
# Bind Alt+Delete to forward delete word
bindkey '^[[3;3~' kill-word
