# -------------------------------------------------------------------
# Interactive shell guard
# -------------------------------------------------------------------

[[ -o interactive ]] || return


# -------------------------------------------------------------------
# Homebrew
#
# .zprofile already initializes Homebrew for login shells.
# This fallback covers non-login interactive shells.
# -------------------------------------------------------------------

if [[ -x /opt/homebrew/bin/brew ]]; then
  if (( ! $+commands[brew] )); then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
elif [[ -x /usr/local/bin/brew ]]; then
  if (( ! $+commands[brew] )); then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi


# -------------------------------------------------------------------
# Global environment
# -------------------------------------------------------------------

# API KEYS
export GEMINI_API_KEY=
export CONTEXT7_API_KEY=
export OPEN_WEATHER_API_KEY=

export AWS_PROFILE_STATE_ENABLED=true
export HOMEBREW_BAT=true

export EDITOR="/opt/homebrew/bin/nvim"
export VISUAL="nvr --remote-wait +'set bufhidden=wipe'"

export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/go"

# Put personal executables before system executables.
typeset -U path PATH

path=(
  "$HOME/.pyenv/bin"
  "$HOME/bin"
  "$HOME/.local/bin"
  "/usr/local/sbin"
  "$HOME/go/bin"
  $path
)

# Prefer GNU sed when installed through Homebrew.
if (( $+commands[brew] )); then
  gnu_sed_path="$(brew --prefix)/opt/gnu-sed/libexec/gnubin"

  if [[ -d "$gnu_sed_path" ]]; then
    path=("$gnu_sed_path" $path)
  fi

  unset gnu_sed_path
fi


# -------------------------------------------------------------------
# Completion paths
#
# Every completion directory must be added before compinit.
# -------------------------------------------------------------------

ZSH_CACHE_DIR="$HOME/.zsh-cache"
ZSH_COMPLETION_DIR="$ZSH_CACHE_DIR/completions"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump"

mkdir -p "$ZSH_COMPLETION_DIR"

typeset -U fpath FPATH

fpath=(
  "$ZSH_COMPLETION_DIR"
  "$HOME/zsh_functions"
  "/opt/homebrew/share/zsh/site-functions"
  $fpath
)

if (( $+commands[brew] )); then
  brew_site_functions="$(brew --prefix)/share/zsh/site-functions"

  if [[ -d "$brew_site_functions" ]]; then
    fpath=("$brew_site_functions" $fpath)
  fi

  unset brew_site_functions
fi


# -------------------------------------------------------------------
# Completion system
# -------------------------------------------------------------------

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# Keep this only if one of your tools loads Bash-style completions.
autoload -Uz bashcompinit
bashcompinit

# You may also need to force rebuild `zcompdump`:
#
#   rm -f ~/.zcompdump; compinit
#
# Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
# to load these completions, you may need to run these commands:
#
#   chmod go-w '/opt/homebrew/share'
#   chmod -R go-w '/opt/homebrew/share/zsh'


# -------------------------------------------------------------------
# Runtime managers
# -------------------------------------------------------------------

if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


# -------------------------------------------------------------------
# Core plugins and shared functions
# -------------------------------------------------------------------

source "$HOME/.zsh-config-settings/plugins/omz-git-lib-funcs.zsh"
source "$HOME/.zsh-config-settings/plugins/omz-functions.zsh"
source "$HOME/.zsh-config-settings/plugins/colored-man-pages.plugin.zsh"
source "$HOME/.zsh-config-settings/plugins/you-should-use.plugin.zsh"


# -------------------------------------------------------------------
# Tool integrations
# This runs after compinit and after Homebrew/PATH initialization.
# -------------------------------------------------------------------

source "$HOME/.zsh-config-settings/my-plugins.zsh"


# -------------------------------------------------------------------
# Plugins that rely on the completion system
# -------------------------------------------------------------------

source "$HOME/.zsh-config-settings/plugins/omz-directories.zsh"
source "$HOME/.zsh-config-settings/plugins/omz-git.zsh"
# source "$HOME/.zsh-config-settings/plugins/omz-aws-plugin.zsh"


# -------------------------------------------------------------------
# User configuration
# -------------------------------------------------------------------

source "$HOME/.zsh-config-settings/my-aliases.zsh"
source "$HOME/.zsh-config-settings/my-local-aliases.zsh"
source "$HOME/.zsh-config-settings/my-functions.zsh"
source "$HOME/.zsh-config-settings/my-keybindings.zsh"
source "$HOME/.zsh-config-settings/my-settings.zsh"


# -------------------------------------------------------------------
# Navigation and prompt
# -------------------------------------------------------------------

source "$HOME/.zsh-config-settings/plugins/zsh-zoxide.zsh"
source "$HOME/.zsh-config-settings/plugins/zsh-starship.zsh"



# -------------------------------------------------------------------
# MNTN specific configuration
# -------------------------------------------------------------------

source ~/.zsh-config-settings/my-local-mntn.zsh


# -------------------------------------------------------------------
# Interactive visual plugins
#
# Syntax highlighting should remain near the end because it wraps ZLE
# widgets created by earlier plugins and configuration.
# -------------------------------------------------------------------

if (( $+commands[brew] )); then
  autosuggestions_file="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  highlighting_file="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  [[ -r "$autosuggestions_file" ]] && source "$autosuggestions_file"
  [[ -r "$highlighting_file" ]] && source "$highlighting_file"

  unset autosuggestions_file
  unset highlighting_file
fi


# -------------------------------------------------------------------
# Optional startup display
# -------------------------------------------------------------------

# if (( $+commands[fastfetch] )); then
#   fastfetch
# fi


# -------------------------------------------------------------------
# Past this point, items added automatically by other tools
# -------------------------------------------------------------------


# pnpm
export PNPM_HOME="/Users/jcapone/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

