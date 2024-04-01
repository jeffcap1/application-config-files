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


export NVM_AUTO_USE=true
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('cd','ls')
source ~/.zsh-config-settings/plugins/zsh-nvm-plugin.zsh


if [ ! -d ~/.tmuxifier ]; then
  echo "Cloning tmuxifier..."
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
fi
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

