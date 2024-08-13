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

# fzf-tab
if [ ! -d ~/fzf-tab ]; then
  echo "Cloning fzf-tab..."
  git clone https://github.com/Aloxaf/fzf-tab ~/fzf-tab
fi
autoload -U compinit; compinit
source ~/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh-config-settings/config/fzf-tab.zsh

# fzf-tab-sources
if [ ! -d ~/fzf-tab-source ]; then
  echo "Cloning fzf-tab-sources..."
  git clone https://github.com/Freed-Wu/fzf-tab-source ~/fzf-tab-source
fi
source ~/fzf-tab-source/*.plugin.zsh

if type brew &>/dev/null && [ ! -d "$HOMEBREW_CELLAR/lesspipe" ]; then
  brew install lesspipe
fi

if type brew &>/dev/null && [ ! -d "$HOMEBREW_CELLAR/exiftool" ]; then
  brew install exiftool
fi

if type brew &>/dev/null && [ ! -d "$HOMEBREW_CELLAR/chafa" ]; then
  brew install chafa
fi

# export LESSOPEN="|$HOMEBREW_PREFIX/bin/lesspipe.sh %s"
export LESSOPEN='|~/.zsh-config-settings/config/lessfilter.sh %s'
export LESSCOLORIZER='bat --theme="Catppuccin Mocha"'
fpath=(~/zsh_functions $fpath)
