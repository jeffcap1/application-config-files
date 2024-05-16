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


# export NVM_AUTO_USE=true
# export NVM_COMPLETION=true
# export NVM_LAZY_LOAD=true
# export NVM_LAZY_LOAD_EXTRA_COMMANDS=('cd','ls')
# source ~/.zsh-config-settings/plugins/zsh-nvm-plugin.zsh

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

# Options to fzf command
export FZF_COMPLETION_OPTS="--height 40% --layout reverse --info inline --border \
    --preview 'bat {}' --preview-window up,1,border-horizontal \
    --bind 'ctrl-/:change-preview-window(50%|hidden|)' \
    --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'\
"

if [ -x "$(command -v fzf)" ]; then
  eval "$(fzf --zsh)"
fi
