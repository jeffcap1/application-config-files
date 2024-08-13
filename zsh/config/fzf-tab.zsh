# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# set key bindings
zstyle ':fzf-tab:complete:*' fzf-bindings \
  'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
  'ctrl-f:page-down,ctrl-b:page-up'

# set padding
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0

# set min-height
zstyle ':fzf-tab:*' fzf-min-height 50
zstyle ':fzf-tab:*' popup-min-size 50 8

# completion styles for different commands
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'

# completion styles for different commands
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'

zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
# zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
#   ¦ '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'
#

# Use TMUX popup
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
