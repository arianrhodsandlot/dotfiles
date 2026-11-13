shopt -s histappend

export SHELL_NAME=bash

. "$HOME/.config/dotfiles/.config/shell/init.sh"

if ! type starship &>/dev/null; then
  if [[ $EUID -eq 0 ]]; then
    ps1_user='\[\e[43;30m\]\u\[\e[0m\]'
  else
    ps1_user='\[\e[36m\]\u\[\e[0m\]'
  fi

  set-ps1() {
    local ec=$?
    PS1='\n\[\e[1;34m\]#\[\e[0m\] '"$ps1_user"' @ \[\e[32m\]\h\[\e[0m\] in \[\e[1;33m\]\w\[\e[0m\] [\t]'
    ((ec)) && PS1+=' \[\e[31m\]C:'"$ec"'\[\e[0m\]'
    PS1+='\n\[\e[1;31m\]$\[\e[0m\] '
  }

  PROMPT_COMMAND="set-ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

if [[ -e $HOME/.bashrc.local ]]; then
  . "$HOME"/.bashrc.local
fi
