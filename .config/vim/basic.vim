set ai
set autoread
set autoread
set background=dark
set backspace=indent,eol,start
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set fileencodings=utf-8,chinese,latin-1,gbk,gb18030,gk2312
set fileformats=unix,dos,mac
set gcr=a:blinkon0
set gfn=Monospace\ 10
set guioptions=egmrti
set hidden
set hlsearch
set ignorecase
set incsearch
set iskeyword=65-90,95,97-122,48-57 "the same: a-z,_,A-Z,0-9
set laststatus=2
set lazyredraw
set magic
set modeline
set modelines=10
set mouse=a
set mousemodel=popup
set nocompatible
set noswapfile
set nu
set paste
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set showmatch
set showmode
set si
set smartcase
set softtabstop=0
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set t_Co=256
set tabstop=4
set title
set titleold="Terminal"
set titlestring=%F
set ttyfast
set viminfo+=n~/.config/vim/viminfo
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildmenu
set wildmode=list:longest,list:full

if has("termguicolors")
  if system('echo $SSH_CLIENT') == ''
    set t_8f=^[[38;2;%lu;%lu;%lum
    set t_8b=^[[48;2;%lu;%lu;%lum
    set termguicolors
  endif
endif

if exists('$SHELL')
  set shell=$SHELL
else
  set shell=/bin/sh
endif

if has("win32")
  set fileencoding=chinese
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
  language messages zh_CN.utf-8
  if has("gui_running")
    set guifont=Microsoft\ Yahei\ Mono:h12
  endif
endif

let mapleader=','

if filereadable(expand("$VIMRUNTIME/syntax/synload.vim"))
  syntax on
endif

filetype plugin indent on

map q :q<CR>
map Q :q!<CR>

nnoremap <silent> <C-p> :FZF -m<CR>
nnoremap <silent> <C-j> :below ter<CR>
nnoremap ; :
nnoremap B ^
nnoremap E $
nnoremap n nzzzv
nnoremap N Nzzzv

tnoremap <C-j> <C-d>

source ~/.config/vim/sensible.vim

augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END