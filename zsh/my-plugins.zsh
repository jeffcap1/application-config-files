### Starting colorls
# Adding Ruby Gems to PATH
export PATH=$PATH:/usr/local/opt/ruby/bin:$HOME/.gem/ruby/3.0.0/bin

# Ruby Config for compilers
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

# Colorize ls output
if [ -x "$(command -v colorls)" ]; then
  alias ls="colorls"
  alias la="colorls -al"
fi
### Ending colorls


export NVM_AUTO_USE=true
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
# export NVM_LAZY_LOAD_EXTRA_COMMANDS=('cd','ls')
source ~/.zsh-config-settings/plugins/zsh-nvm-plugin.zsh

### Starting Node Version Manager (nvm)
# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && export NVM_BASE="/usr/local/opt/nvm" || export NVM_BASE="/opt/homebrew/opt/nvm"
# [ -s "$NVM_BASE/nvm.sh" ] && \. "$NVM_BASE/nvm.sh"  # This loads nvm
# [ -s "$NVM_BASE/bash_completion" ] && \. "$NVM_BASE/bash_completion"  # This loads nvm bash_completion
#
# # Adding global require support -- Sublime Text and other apps
# export NODE_PATH="$(npm config get prefix)/lib/node_modules"
#
# # place this after nvm initialization!
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
#
#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc
# ### Ending nvm
#
