if [ ! -x "$(command -v fzf)" ]; then
  echo "Installing fzf..."
  brew install fzf
fi

alias e="fzf --preview 'bat -n --color=always {}' --preview-window right:wrap --multi --bind 'enter:become(nvim {+})'"

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
    cd)           fzf --preview 'eza -T --icons=always {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

eval "$(fzf --zsh)"
