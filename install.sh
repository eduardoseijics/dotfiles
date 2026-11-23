#!/usr/bin/env bash
set -euo pipefail

repo="$HOME/dotfiles"
omz="$HOME/.oh-my-zsh"
plugins="$omz/custom/plugins"
plugin_names=(zsh-autosuggestions zsh-syntax-highlighting)

if [[ "${1:-}" == doctor ]]; then
  issues=0

  check() {
    local label="$1"
    shift
    if "$@" >/dev/null 2>&1; then
      printf '[OK] %s\n' "$label"
    else
      printf '[CHECK] %s\n' "$label"
      issues=$((issues + 1))
    fi
  }

  check "Git is installed" command -v git
  check "Zsh is installed" command -v zsh
  login_shell=$(getent passwd "$(id -un)" | cut -d: -f7)
  check "Zsh is the default shell" test "${login_shell##*/}" = zsh
  check "Oh My Zsh is installed" test -r "$omz/oh-my-zsh.sh"

  for plugin in "${plugin_names[@]}"; do
    check "$plugin is installed" test -r "$plugins/$plugin/$plugin.zsh"
  done

  check ".zshrc matches the repo" cmp -s "$repo/zsh/.zshrc" "$HOME/.zshrc"
  if command -v zsh >/dev/null; then
    check "A new Zsh session loads shortcuts and gst" \
      zsh -ic '(( ${+functions[shortcuts]} && ${+aliases[gst]} ))'
  fi

  printf '\n%d check(s) need attention.\n' "$issues"
  exit "$(( issues > 0 ))"
fi

if [[ $# -gt 0 ]]; then
  echo "Usage: ./install.sh [doctor]" >&2
  exit 1
fi

if ! command -v git >/dev/null || ! command -v zsh >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y git zsh
fi

if [[ ! -f "$omz/oh-my-zsh.sh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz"
fi

mkdir -p "$plugins"
for plugin in "${plugin_names[@]}"; do
  if [[ ! -f "$plugins/$plugin/$plugin.zsh" ]]; then
    git clone --depth=1 "https://github.com/zsh-users/$plugin.git" "$plugins/$plugin"
  fi
done

if ! cmp -s "$repo/zsh/.zshrc" "$HOME/.zshrc"; then
  cp -iv "$repo/zsh/.zshrc" "$HOME/.zshrc"
fi

zsh_path=$(command -v zsh)
login_shell=$(getent passwd "$(id -un)" | cut -d: -f7)
if [[ ! "$login_shell" -ef "$zsh_path" ]]; then
  chsh -s "$zsh_path"
fi
