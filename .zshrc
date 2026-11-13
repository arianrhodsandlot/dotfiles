autoload -Uz compinit
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
compinit
HISTFILE="$HOME/.zsh_history"

setopt ALWAYS_TO_END AUTO_CD AUTO_MENU AUTO_PUSHD COMPLETE_IN_WORD HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY INTERACTIVE_COMMENTS LONG_LIST_JOBS MULTIOS PROMPT_SUBST PUSHD_IGNORE_DUPS PUSHD_MINUS
setopt EXTENDED_HISTORY SHARE_HISTORY
unsetopt FLOW_CONTROL MENU_COMPLETE

bindkey -e
bindkey ' ' magic-space

bindkey "${terminfo[kcbt]}" reverse-menu-complete
bindkey "${terminfo[kdch1]}" delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
for k in "${terminfo[kcud1]}" '^[[B'; do [[ -n "$k" ]] && bindkey "$k" history-search-forward; done
for k in "${terminfo[kcuu1]}" '^[[A'; do [[ -n "$k" ]] && bindkey "$k" history-search-backward; done
for k in "${terminfo[kend]}" '^[[F' '^[[4~'; do [[ -n "$k" ]] && bindkey "$k" end-of-line; done
for k in "${terminfo[khome]}" '^[[H' '^[[1~'; do [[ -n "$k" ]] && bindkey "$k" beginning-of-line; done

zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true

export SHELL_NAME=zsh

. "$HOME/.config/dotfiles/.config/shell/init.sh"

ZSH_CONFIG_DIR="${XDG_CONFIG_HOME}/zsh"

if [[ -e "${ZSH_CONFIG_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  . "${ZSH_CONFIG_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CONFIG_DIR}/zsh-autosuggestions"
  . "${ZSH_CONFIG_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -e "${ZSH_CONFIG_DIR}/F-Sy-H/F-Sy-H.plugin.zsh" ]]; then
  . "${ZSH_CONFIG_DIR}/F-Sy-H/F-Sy-H.plugin.zsh"
else
  git clone --depth=1 https://github.com/z-shell/F-Sy-H "${ZSH_CONFIG_DIR}/F-Sy-H"
  . "${ZSH_CONFIG_DIR}/F-Sy-H/F-Sy-H.plugin.zsh"
fi

if [[ ! -f "${ZSH_CONFIG_DIR}/sudo.plugin.zsh" ]]; then
  curl -fsSL -o "${ZSH_CONFIG_DIR}/sudo.plugin.zsh" https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
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
