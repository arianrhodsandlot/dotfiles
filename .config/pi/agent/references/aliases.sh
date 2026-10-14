shopt -s expand_aliases
alias_file="${DOTFILES_CONFIG_DIR}/shell/aliases.json"
add_alias_command=$(yq -r "to_entries[] | \"alias \" + .key + \"='\" + .value + \"'\"" "$alias_file")
eval "$add_alias_command"