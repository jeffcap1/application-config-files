#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

info() {
  printf '\033[1;34m[%s]\033[0m %s\n' "$SCRIPT_NAME" "$*"
}

success() {
  printf '\033[1;32m[%s]\033[0m %s\n' "$SCRIPT_NAME" "$*"
}

warn() {
  printf '\033[1;33m[%s]\033[0m %s\n' "$SCRIPT_NAME" "$*" >&2
}

error() {
  printf '\033[1;31m[%s]\033[0m %s\n' "$SCRIPT_NAME" "$*" >&2
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_tap() {
  local tap="$1"

  if brew tap | grep -Fxq "$tap"; then
    success "Tap already configured: $tap"
    return
  fi

  info "Adding Homebrew tap: $tap"
  brew tap "$tap"
}

install_formula() {
  local formula="$1"

  if brew list --formula "$formula" >/dev/null 2>&1; then
    success "Formula already installed: $formula"
    return
  fi

  info "Installing formula: $formula"
  brew install "$formula"
}

clone_or_update_repo() {
  local repo_url="$1"
  local destination="$2"
  local name="${3:-$(basename "$destination")}"

  if [[ -d "$destination/.git" ]]; then
    info "Updating $name..."

    git -C "$destination" pull --ff-only
    success "Updated $name."
    return
  fi

  if [[ -e "$destination" ]]; then
    warn "Skipping $name because destination exists but is not a Git repository:"
    warn "  $destination"
    return
  fi

  info "Cloning $name..."
  git clone "$repo_url" "$destination"
  success "Installed $name."
}

main() {
  install_tap "satococoa/tap"

  local formulae=(
    atuin
    bat
    carapace
    chafa
    csvkit
    direnv
    eza
    exiftool
    fastfetch
    fzf
    git
    gnu-sed
    lazygit
    lesspipe
    neovim
    pyenv
    pyenv-virtualenv
    tmux
    uv
    vivid
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting
  )

  local formula

  for formula in "${formulae[@]}"; do
    install_formula "$formula"
  done

  install_formula "satococoa/tap/wtp"

  clone_or_update_repo \
    "https://github.com/jimeh/tmuxifier.git" \
    "$HOME/.tmuxifier" \
    "tmuxifier"

  clone_or_update_repo \
    "https://github.com/Aloxaf/fzf-tab.git" \
    "$HOME/fzf-tab" \
    "fzf-tab"

  clone_or_update_repo \
    "https://github.com/Freed-Wu/fzf-tab-source.git" \
    "$HOME/fzf-tab-source" \
    "fzf-tab-source"

  mkdir -p \
    "$HOME/.zsh-cache/completions" \
    "$HOME/zsh_functions"

  success "Zsh dependencies installed successfully."
  info "Restart your shell with: exec zsh"
}

main "$@"

