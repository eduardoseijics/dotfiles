#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
omz="$HOME/.oh-my-zsh"
plugins="$omz/custom/plugins"
plugin_names=(zsh-autosuggestions zsh-syntax-highlighting)

if [[ $# -eq 1 && "${1:-}" == doctor ]]; then
  exec bash "$repo/doctor.sh"
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

target="$HOME/.zshrc"
source_file="$repo/zsh/.zshrc"

if [[ ! -f "$source_file" || ! -f "$repo/zsh/shortcuts.zsh" ]]; then
  echo "Missing zsh/.zshrc or zsh/shortcuts.zsh in $repo" >&2
  exit 1
fi

if [[ ! -L "$target" || ! "$target" -ef "$source_file" ]]; then
  if [[ -e "$target" || -L "$target" ]]; then
    backup_dir=$(mktemp -d "$HOME/.zshrc-backup.XXXXXXXX")
    cp -a -- "$target" "$backup_dir/.zshrc"
    printf 'Previous configuration saved to %s\n' "$backup_dir/.zshrc"
  fi

  ln -sfnT -- "$source_file" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source_file"
fi

zsh_path=$(command -v zsh)
login_shell=$(getent passwd "$(id -un)" | cut -d: -f7)
if [[ ! "$login_shell" -ef "$zsh_path" ]]; then
  chsh -s "$zsh_path"
fi
