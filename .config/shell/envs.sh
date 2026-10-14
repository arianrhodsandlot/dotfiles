envs_file="${DOTFILES_CONFIG_DIR}/shell/envs.json"
add_env_command=$(yq -r 'to_entries[] | select(.key | test("^[A-Za-z_][A-Za-z0-9_]*$")) | "export " + .key + "=\"" + .value + "\""' "$envs_file")
eval "$add_env_command"

if [[ -f "${DOTFILES_CONFIG_DIR}/private/.config/shell/secrets.json" ]]; then
  secrets_file="${DOTFILES_CONFIG_DIR}/private/.config/shell/secrets.json"
  add_secret_command=$(yq -r 'to_entries[] | select(.key | test("^[A-Za-z_][A-Za-z0-9_]*$")) | "export " + .key + "=\"" + .value + "\""' "$secrets_file")
  eval "$add_secret_command"
fi

GPG_TTY=$(tty)
export GPG_TTY

export MANPATH=/usr/local/man:$MANPATH

if [[ -z "$USER" ]] && type id &>/dev/null; then
  USER="$(id -un)"
  export USER
fi
