shopt -s histappend

export SHELL_NAME=bash

. "$HOME/.config/dotfiles/.config/shell/init.sh"

if [[ -e $HOME/.bashrc.local ]]; then
  . "$HOME"/.bashrc.local
fi
