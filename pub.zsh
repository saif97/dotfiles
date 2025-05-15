export STARSHIP_CONFIG=~/dotfiles/starship/starship.toml
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"

alias l='lsd -ali'
alias cat='bat'
# alias cd='z'
alias ci='zi'
alias nv='nvim'
alias python='python3'
alias py='python3'
alias pysour='source ./venv/bin/activate'
alias pip='pip3'
alias v='nvim'

export XDG_CONFIG_HOME="$HOME/.config"
