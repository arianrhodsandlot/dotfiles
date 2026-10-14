source ~/.config/vim/basic.vim

if $VIM_EXTEND == 'true'
  source ~/.config/vim/extend.vim
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
