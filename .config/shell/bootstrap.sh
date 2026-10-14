export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_DIR="$XDG_CONFIG_HOME/dotfiles"
export DOTFILES_CONFIG_DIR="$XDG_CONFIG_HOME/dotfiles/.config"

if [ -d /opt/homebrew/bin ]; then
  PATH=/opt/homebrew/bin:$PATH
elif [ -d /home/linuxbrew/.linuxbrew/bin ]; then
  PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
fi
PATH=$HOME/.bin:$HOME/.local/bin:$DOTFILES_CONFIG_DIR/bin:$XDG_DATA_HOME/pnpm/bin:$HOME/.orbstack/bin:$PATH
export PATH

if type mise &>/dev/null; then
  export MISE_CONFIG_DIR="$HOME/.config/dotfiles/.config/mise"
  export MISE_DATA_DIR="$HOME/.local/share/mise"
  if [[ "$OS" != "Windows_NT" ]]; then
    eval "$(mise activate $SHELL_NAME)"
    eval "$(mise completion $SHELL_NAME)"
  else
    export PATH="$MISE_DATA_DIR/shims:$PATH"
  fi
fi

if type zoxide &>/dev/null; then
  export _ZO_DATA_DIR="$HOME/.local/share/zoxide"
  eval "$(zoxide init $SHELL_NAME)"
fi

if type starship &>/dev/null; then
  eval "$(starship init $SHELL_NAME)"
fi

if type brew &>/dev/null; then
  eval "$(brew shellenv)"
fi
