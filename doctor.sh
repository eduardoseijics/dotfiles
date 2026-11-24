#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
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

source "$repo/zsh/doctor.sh"

printf '\n%d check(s) need attention.\n' "$issues"
exit "$((issues > 0))"
