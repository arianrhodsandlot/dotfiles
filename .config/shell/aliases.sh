alias_file="${DOTFILES_CONFIG_DIR}/shell/aliases.json"
add_alias_command=$(yq -r "to_entries[] | \"alias \" + .key + \"='\" + .value + \"'\"" "$alias_file")
eval "$add_alias_command"

while IFS= read -r line; do
  [[ "$line" == alias.* ]] || continue
  git_alias="${line#alias.}"
  git_alias="${git_alias%% *}"
  shell_alias="g${git_alias}"
  alias "$shell_alias"="git $git_alias"
done < <(git config --get-regexp '^alias\.' 2>/dev/null)