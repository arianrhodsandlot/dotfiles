envs_file="${DOTFILES_CONFIG_DIR}/shell/envs.json"
add_env_command=$(jq -r 'to_entries[] | "export \(.key)=\"\(.value)\""' "$envs_file")
eval "$add_env_command"

if [[ -f "${DOTFILES_CONFIG_DIR}/private/.config/shell/secrets.json" ]]; then
  secrets_file="${DOTFILES_CONFIG_DIR}/private/.config/shell/secrets.json"
  add_secret_command=$(jq -r 'to_entries[] | "export \(.key)=\"\(.value)\""' "$secrets_file")
  eval "$add_secret_command"
fi

if type tty &>/dev/null; then
  GPG_TTY=$(tty)
  export GPG_TTY
fi

export MANPATH=/usr/local/man:$MANPATH

if [[ -z "$USER" ]] && type id &>/dev/null; then
  USER="$(id -un)"
  export USER
fi
