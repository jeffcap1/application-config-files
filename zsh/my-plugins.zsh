# Eza
if [ -x "$(command -v eza)" ]; then
  alias ls="eza --color=always --icons=always"
  alias la="eza -al --color=always --icons=always"
fi

# fnm -- Node.js version manager
export ZSH_FNM_INSTALL_DIR="$HOME/.fnm"
export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd"
export ZSH_FNM_USE_EXTRA_ARGS="--install-if-missing"
source ~/.zsh-config-settings/plugins/zsh-fnm-plugin.zsh

# tmuxifier
if [ ! -d ~/.tmuxifier ]; then
  echo "Cloning tmuxifier..."
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
fi
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

# fzf
source ~/.zsh-config-settings/config/fzf.zsh

