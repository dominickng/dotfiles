filetype off
set nocompatible
let mapleader=","

call pathogen#runtime_append_all_bundles()

" general settings
set history=1000
set viminfo=%,'100,\"100,:100,n~/.vim/viminfo
set backup

" create ~/tmp/ if it doesn't exist and use ~/tmp to save the backups into
if has("unix")
  if !isdirectory(expand("~/tmp/vim/."))
    !mkdir -p ~/tmp/vim
  endif
endif
set backupdir=~/tmp/vim
set directory=~/tmp/vim,.,/var/tmp,/tmp

" tabs and indentation
set autoindent
set copyindent
set expandtab
set softtabstop=4
set smarttab
set tabstop=8
set nojoinspaces
set shiftwidth=4
set shiftround

" filetypes
filetype plugin indent on
autocmd BufNewFile,BufRead *.tex setlocal ft=tex spell! sw=2
autocmd FileType tex setlocal textwidth=78 nosmartindent
"autocmd FileType tex source $HOME/.vim/auctex.vim

" syntax highlighting and colors
syntax on
set backspace=indent,eol,start
set display+=lastline
set hlsearch
set ignorecase
set incsearch
set mouse=a
set number
set smartcase
set ruler
set scrolloff=3
set showmatch
set title
set wildmode=list:longest
set wildignore=.svn,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

highlight Comment ctermfg=lightblue
highlight Search ctermfg=grey ctermbg=yellow
highlight LeadingTab ctermbg=blue guibg=blue
highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
highlight EvilSpace ctermbg=darkred guibg=darkred
highlight StatusLine ctermfg=black ctermbg=green cterm=NONE
highlight StatusLineNC ctermfg=black ctermbg=lightblue cterm=NONE

highlight WhitespaceEOL ctermbg=lightblue

" highlight tabs
syntax match Tab /\t/
highlight Tab gui=underline guifg=blue ctermbg=blue 

" Load other macros
source $HOME/.vim/macros.vim
