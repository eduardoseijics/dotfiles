omz="$HOME/.oh-my-zsh"
plugins="$omz/custom/plugins"
plugin_names=(zsh-autosuggestions zsh-syntax-highlighting)

check "Git is installed" command -v git
check "Zsh is installed" command -v zsh

login_shell=$(getent passwd "$(id -un)" | cut -d: -f7) || login_shell=""
check "Zsh is the default shell" test "${login_shell##*/}" = zsh
check "Oh My Zsh is installed" test -r "$omz/oh-my-zsh.sh"

for plugin in "${plugin_names[@]}"; do
  check "$plugin is installed" test -r "$plugins/$plugin/$plugin.zsh"
done

check "~/.zshrc is a symlink" test -L "$HOME/.zshrc"
check "~/.zshrc points to this repo" test "$HOME/.zshrc" -ef "$repo/zsh/.zshrc"

if command -v zsh >/dev/null; then
  check "A new Zsh session loads shortcuts and gst" \
    zsh -ic '(( ${+functions[shortcuts]} && ${+aliases[gst]} ))'
fi
