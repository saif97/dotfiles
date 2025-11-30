# ══════════════════════════════════════════════════════════════════════
# Completion Configuration
# ══════════════════════════════════════════════════════════════════════
# Load order: fpath setup → compinit → fzf → fzf-tab → syntax plugins
# fpath: It's an array of directories where zsh looks for completion functions (the _command files)

# Docker completions (before compinit)
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

# Initialize completion system
autoload -U compinit
compinit

# Initialize fzf
command -v fzf &> /dev/null && source <(fzf --zsh)

# Load fzf-tab (must be after compinit, before syntax plugins)
[[ -f "$DOT_FILES/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$DOT_FILES/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

# fzf-tab config
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'if [[ -d $realpath ]]; then lsd -1 --color=always $realpath; else bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null; fi'
zstyle ':fzf-tab:*' fzf-min-height 20

# Syntax plugins (must be after fzf-tab)
ZSH_PLUGINS_DIR="$HOME/.zsh"
if command -v brew &> /dev/null; then
	BREW_PREFIX="$(brew --prefix)"
	ZSH_PLUGINS_DIR="$BREW_PREFIX/share"
fi

if [[ -d "$ZSH_PLUGINS_DIR" ]]; then
	source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Google Cloud SDK
[[ -f "$HOME/dev/sdks/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/dev/sdks/google-cloud-sdk/completion.zsh.inc"

# Dart CLI
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"
