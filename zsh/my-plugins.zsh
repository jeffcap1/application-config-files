### Starting colorls
# Adding Ruby Gems to PATH
# export PATH=$PATH:/usr/local/opt/ruby/bin:$HOME/.gem/ruby/3.0.0/bin
export PATH="$(brew --prefix)/opt/ruby/bin:$PATH"

# Ruby Config for compilers
export LDFLAGS="-L$(brew --prefix)/opt/ruby/lib"
export CPPFLAGS="-I$(brew --prefix)/opt/ruby/include"

# Colorize ls output
if [ -x "$(command -v colorls)" ]; then
  alias ls="colorls"
  alias la="colorls -al"
fi
### Ending colorls


export ZSH_FNM_INSTALL_DIR="$HOME/.fnm"
export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd"
export ZSH_FNM_USE_EXTRA_ARGS="--install-if-missing"
source ~/.zsh-config-settings/plugins/zsh-fnm-plugin.zsh


if [ ! -d ~/.tmuxifier ]; then
  echo "Cloning tmuxifier..."
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
fi
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

# fzf

# Default settigns
export FZF_DEFAULT_OPT="--height 40% --layout reverse --info inline --border \
    --bind 'ctrl-/:change-preview-window(50%|hidden|)' \
"

# Options to fzf command
export FZF_COMPLETION_OPTS="--height 40% --layout reverse --info inline --border \
    --preview 'bat {}' --preview-window up,1,border-horizontal \
    --bind 'ctrl-/:change-preview-window(50%|hidden|)' \
    --color header:italic \
    --header 'Compeletion Menu'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS=" \
  --preview 'echo {}' --preview-window up:3:hidden:wrap \
  --bind 'ctrl-/:toggle-preview' \
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
  --color header:italic \
  --header 'Press CTRL-Y to copy command into clipboard'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

if [ -x "$(command -v fzf)" ]; then
  eval "$(fzf --zsh)"
fi
