aguu() {
  sudo apt-get update
  sudo apt-get upgrade
}

cc() {
  append_system_prompt=$(cat AGENTS.md agents.md Agents.md 2>/dev/null || true)
  claude --dangerously-skip-permissions --append-system-prompt="$append_system_prompt" "$@"
}

codex() {
  command codex -c projects."${PWD}".trust_level=trusted "$@"
}

gweekdir() {
  ZSH_AUTO_PEEK_ENABLED=false
  cd "$XDG_PROJECTS_DIR/insgeek" || exit
  wd=$(pwd)
  for d in *; do
    if [[ -d "$d/.git" ]]; then
      cd "$d" || exit
      log=$(gno --all --author=dan.wei@insgeek.com --after="1 weeks ago" | cat)
      log_count=$(echo "$log" | wc -l)
      if [ "$log_count" -gt 1 ]; then
        printf "\n"
        printf '\033[1m%s\033[0m' "$d"
        printf "\n"
        echo "$log"
        printf "\n"
      fi
      cd "$wd" || exit
    fi
  done
  ZSH_AUTO_PEEK_ENABLED=true
}

gmr() {
  gp

  current_branch="$(gb --show-current)"
  local target_branch="${1:-$(git_main_branch)}"
  remote_url=$(g config --get remote.origin.url)
  domain=$(echo "$remote_url" | sed -r 's|^git@([^:]+):([^/]+)/([^/.]+)\.git$|\1|')
  project_path=$(echo "$remote_url" | sed -r 's|^git@([^:]+):([^/]+)/([^/.]+)\.git$|\2/\3|')
  encoded_source_branch=$(urlencode "$current_branch")
  encoded_target_branch=$(urlencode "$target_branch")
  merge_request_url="http://$domain/$project_path/-/merge_requests/new?merge_request%5Bsource_branch%5D=$encoded_source_branch&merge_request%5Btarget_branch%5D=$encoded_target_branch"
  open_command "$merge_request_url"
}

gmrd() {
  gmr "$(git dev-branch)"
}

urlencode() {
  node -e "console.log(encodeURIComponent('$1'))"
}

r() {
  cd "$XDG_PROJECTS_DIR/personal/home-window/" || exit
  nr insert
  cd - || exit
}

src() {
  exec $SHELL
}
