## Run Fastfetch
if [[ -o interactive ]]; then
    fastfetch
fi


# set global variables
export HOMEBREW_GITHUB_API_TOKEN=
export HOMEBREW_BAT=true

# LLM models
export GEMINI_API_KEY=

# weather api for tmux
export OPEN_WEATHER_API_KEY=

# set default editor
export EDITOR='/usr/local/bin/nvim'
# export VISUAL="nvr --remote-wait +'set bufhidden=wipe'"

# set xdg paths
export XDG_CONFIG_HOME="$HOME/.config"


# python support
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# plugins
source ~/.zsh-config-settings/plugins/omz-git-lib-funcs.zsh
source ~/.zsh-config-settings/plugins/omz-functions.zsh
source ~/.zsh-config-settings/plugins/colored-man-pages.plugin.zsh
source ~/.zsh-config-settings/plugins/you-should-use.plugin.zsh

if type brew &>/dev/null; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # set gnu-sed as default sed
  export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"

  # If you receive "highlighters directory not found" error message,
  # you may need to add the following to your .zshenv:
  # export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

  # Intel
  # FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  # M-series
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"


  eval "$(brew shellenv)"
fi


export PATH="$HOME/.pyenv/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH"




# You may also need to force rebuild `zcompdump`:
#
#   rm -f ~/.zcompdump; compinit
#
# Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
# to load these completions, you may need to run these commands:
#
#   chmod go-w '/opt/homebrew/share'
#   chmod -R go-w '/opt/homebrew/share/zsh'


# Initialize completion system only if it's not already initialized
if [[ -z ${_compconfig+x} ]]; then
  autoload -U +X compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
fi

# include plugins and plugin settings
source ~/.zsh-config-settings/my-plugins.zsh

# plugins using completions
source ~/.zsh-config-settings/plugins/omz-directories.zsh
source ~/.zsh-config-settings/plugins/omz-git.zsh

# custom aliases and settings
source ~/.zsh-config-settings/my-aliases.zsh
source ~/.zsh-config-settings/my-local-aliases.zsh
source ~/.zsh-config-settings/my-functions.zsh
source ~/.zsh-config-settings/my-keybindings.zsh
source ~/.zsh-config-settings/my-settings.zsh

# Enable additional plugins for prompt
source ~/.zsh-config-settings/plugins/zsh-starship.zsh
source ~/.zsh-config-settings/plugins/zsh-zoxide.zsh

