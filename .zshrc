autoload -Uz compinit
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
compinit
HISTFILE="$HOME/.zsh_history"

setopt ALWAYS_TO_END AUTO_CD AUTO_MENU AUTO_PUSHD COMPLETE_IN_WORD HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY INTERACTIVE_COMMENTS LONG_LIST_JOBS MULTIOS PROMPT_SUBST PUSHD_IGNORE_DUPS PUSHD_MINUS
setopt EXTENDED_HISTORY SHARE_HISTORY
unsetopt FLOW_CONTROL MENU_COMPLETE

bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true

export SHELL_NAME=zsh

. "$HOME/.config/dotfiles/.config/shell/init.sh"

if [[ ! -e "${XDG_CONFIG_HOME}/zsh/zsh-autosuggestions" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${XDG_CONFIG_HOME}/zsh/zsh-autosuggestions"
fi
if [[ -e "${XDG_CONFIG_HOME}/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  . "${XDG_CONFIG_HOME}/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ ! -e "${XDG_CONFIG_HOME}/zsh/F-Sy-H" ]]; then
  git clone --depth=1 https://github.com/z-shell/F-Sy-H "${XDG_CONFIG_HOME}/zsh/F-Sy-H"
fi
if [[ -e "${XDG_CONFIG_HOME}/zsh/F-Sy-H/F-Sy-H.plugin.zsh" ]]; then
  . "${XDG_CONFIG_HOME}/zsh/F-Sy-H/F-Sy-H.plugin.zsh"
fi

if [[ ! -f "${XDG_CONFIG_HOME}/zsh/sudo.plugin.zsh" ]]; then
  curl -fsSL -o "${XDG_CONFIG_HOME}/zsh/sudo.plugin.zsh" https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
fi
. "${XDG_CONFIG_HOME}/zsh/sudo.plugin.zsh"

auto-peek() {
  if [ "$ZSH_AUTO_PEEK_ENABLED" = "true" ]; then
    peek
  fi
}

add-zsh-hook chpwd auto-peek

magic-enter() {
  if [[ -n "$BUFFER" || "$CONTEXT" != start ]]; then
    return
  fi
  zle -I
  eval "$MAGIC_ENTER_COMMAND"
}

_magic-enter_accept-line() {
  if [[ -n "$BUFFER" || "$CONTEXT" != start ]]; then
    zle .accept-line
  else
    magic-enter
  fi
}

zle -N accept-line _magic-enter_accept-line

if ! type starship &>/dev/null; then
  exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"
  PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}@ \
%{$fg[green]%}%m \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
 \
[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
fi

if [[ -e "$HOME/.zshrc.local" ]]; then
  . "$HOME/.zshrc.local"
fi
