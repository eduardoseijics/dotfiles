alias branch='git branch --show-current'

function shortcuts() {
  local row=$'\e[32m%-24s\e[0m %s\n'

  print -P '%BStatus and history%b'
  printf "$row" \
    'gst / gss'              'Show full / short status' \
    'gd / gds'               'Show unstaged / staged changes' \
    'glog'                   'Show commit history as a graph'

  print -P '\n%BBranches and commits%b'
  printf "$row" \
    'branch'                 'Show the current branch name' \
    'gb / gba'               'List local / all branches' \
    'gsw main'               'Switch to main' \
    'gsw -'                  'Switch to the previous branch' \
    'gswc feature/example'   'Create a branch and switch to it' \
    'ga file.ts / gaa'       'Stage one file / all changes' \
    'grst file.ts'           'Unstage a file and keep its changes' \
    'gcmsg "message"'        'Commit staged changes'

  print -P '\n%BRemote operations%b'
  printf "$row" \
    'gf'                     'Fetch remote updates' \
    'gl / gp'                'Pull / push' \
    'ggl / ggp'              'Pull / push the current branch on origin' \
    'gpsup'                  'Push and set the upstream branch'

  print -P '\n%BStash%b'
  printf "$row" \
    'gsta -u -m "name"'      'Stash changes and untracked files' \
    'gstl'                   'List stashes' \
    'gsts'                   'Show the latest stash patch' \
    'gstaa / gstp'           'Apply and keep / pop the latest stash'

  print -P '\n%BTerminal%b'
  printf "$row" \
    'ls -lah'                'List all files with readable sizes' \
    'cd -'                   'Return to the previous directory' \
    'tail -f app.log'        'Follow a log file' \
    'Ctrl+R'                 'Search command history' \
    'Ctrl+L'                 'Clear the screen and scrollback' \
    'alias gst'              'Show what an alias runs'
}

autoload -Uz add-zsh-hook

show_expanded_alias() {
  local -a words
  words=("${(@z)1}")
  if (( ${#words} && ${+aliases[${words[1]}]} )); then
    print -ru2 -- "→ $3"
  fi
}

add-zsh-hook preexec show_expanded_alias

clear_scrollback() {
  printf '\e[H\e[2J\e[3J'
  zle reset-prompt
}

zle -N clear_scrollback
bindkey '^L' clear_scrollback
alias ghwho='ssh -T git@github.com'
