# Eza
if (( $+commands[eza] )); then
  alias ls="eza --color=always --icons=always"
  alias la="eza -al --color=always --icons=always"
fi


# uv -- Python package and project manager
if [[ -r "$HOME/.zsh-config-settings/plugins/omz-uv-plugin.zsh" ]]; then
  source "$HOME/.zsh-config-settings/plugins/omz-uv-plugin.zsh"
fi


# fnm -- Node.js version manager
# export ZSH_FNM_INSTALL_DIR="$HOME/.fnm"
# export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd"
# export ZSH_FNM_USE_EXTRA_ARGS="--install-if-missing"
# source ~/.zsh-config-settings/plugins/zsh-fnm-plugin.zsh


# tmuxifier
if [[ -d "$HOME/.tmuxifier" ]]; then
  path=("$HOME/.tmuxifier/bin" $path)

  if (( $+commands[tmuxifier] )); then
    eval "$(tmuxifier init -)"
  fi
fi


# -------------------------------------------------------------------
# fzf base integration
#
# Load before fzf-tab.
# -------------------------------------------------------------------

if [[ -r "$HOME/.zsh-config-settings/config/fzf.zsh" ]]; then
  source "$HOME/.zsh-config-settings/config/fzf.zsh"
fi


# Atuin
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh --disable-up-arrow)"
fi


# -------------------------------------------------------------------
# Carapace
#
# Load before other completion plugins to ensure it is registered globally.
# -------------------------------------------------------------------

if (( $+commands[carapace] )); then
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  export CARAPACE_ENV=1
  export CARAPACE_HIDDEN=1
  export CARAPACE_MATCH=1

  source <(carapace _carapace zsh)
fi


# -------------------------------------------------------------------
# Colors
# -------------------------------------------------------------------

if (( $+commands[vivid] )); then
  export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

export LESSCOLORIZER='bat --theme="Catppuccin Mocha"'


# -------------------------------------------------------------------
# WTP
#
# This must come after global Carapace registration.
# Use the real binary path rather than a possible shell wrapper.
# -------------------------------------------------------------------

if [[ -x /opt/homebrew/bin/wtp ]]; then
  eval "$(/opt/homebrew/bin/wtp shell-init zsh)"
elif (( $+commands[wtp] )); then
  eval "$(command wtp shell-init zsh)"
fi


# -------------------------------------------------------------------
# fzf-tab sources
#
# Load supporting sources before the main fzf-tab plugin unless their
# documentation explicitly requires otherwise.
# -------------------------------------------------------------------

if [[ -d "$HOME/fzf-tab-source" ]]; then
  for plugin_file in "$HOME"/fzf-tab-source/*.plugin.zsh(N); do
    source "$plugin_file"
  done

  unset plugin_file
fi


# -------------------------------------------------------------------
# fzf-tab
#
# Keep this near the end so it is the final plugin wrapping Tab.
# -------------------------------------------------------------------

if [[ -r "$HOME/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/fzf-tab/fzf-tab.plugin.zsh"
fi

if [[ -r "$HOME/.zsh-config-settings/config/fzf-tab.zsh" ]]; then
  source "$HOME/.zsh-config-settings/config/fzf-tab.zsh"
fi

