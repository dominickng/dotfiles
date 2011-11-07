filetype off
set encoding=utf-8
set fileencoding=utf-8
set nocompatible
set nobk
colorscheme default
let mapleader=","

" pathogen setup
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect() 

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
set softtabstop=2
set smarttab
set tabstop=8
set nojoinspaces
set shiftwidth=2
set shiftround

" filetypes
filetype plugin indent on
autocmd BufNewFile,BufRead *.tex setlocal ft=tex spell! sw=2
autocmd FileType tex setlocal textwidth=78 nosmartindent
autocmd FileType c,cpp,java setlocal sw=2 ts=2

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
highlight Pmenu ctermbg=238 gui=bold
highlight SpellBad term=reverse ctermfg=white ctermbg=darkred

highlight WhitespaceEOL ctermbg=lightblue

" highlight tabs
syntax match Tab /\t/
highlight Tab gui=underline guifg=blue ctermbg=blue 

" indent-guide stuff
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=lightgrey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=white

" Load other macros
source $HOME/.vim/macros.vim
