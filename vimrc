filetype off
set encoding=utf-8
set fileencoding=utf-8
set nocompatible
set nobk
let mapleader=","

" pathogen setup
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect() 

" general settings
set history=1000
set viminfo='10,\"100,:20,%,n~/.viminfo'

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
autocmd FileType c,cpp,java setlocal sw=2 ts=2

" searching
set hlsearch
set ignorecase
set incsearch
set smartcase

" visual
set display+=lastline
set mouse=
set number
set ruler
set scrolloff=3
set showcmd
set showmatch
set title
set wildmode=list:longest
set wildignore=.svn,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" syntax highlighting and colors
syntax on
set backspace=indent,eol,start
colorscheme default
set background=light
"set cursorline

highlight Comment ctermfg=lightblue
highlight CursorLine cterm=NONE ctermbg=darkgray guibg=darkgray
highlight EvilSpace ctermbg=darkred guibg=darkred
highlight LeadingTab ctermbg=blue guibg=blue
highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
highlight MatchParen ctermbg=4
highlight Pmenu ctermbg=238 gui=bold
highlight Search ctermfg=grey ctermbg=yellow
highlight SpellBad term=reverse ctermfg=white ctermbg=darkred
highlight StatusLine ctermfg=black ctermbg=green cterm=NONE
highlight StatusLineNC ctermfg=black ctermbg=lightblue cterm=NONE
highlight Tab gui=underline guifg=blue ctermbg=blue 
highlight WhitespaceEOL ctermbg=lightblue

" highlight tabs

" statusline
set laststatus=2
set statusline=
set statusline +=%f                 "relative path
"set statusline +=%h                "help buffer flag
set statusline +=%r                 "readonly
set statusline +=%y                 "file type
set statusline +=%m                 "modified flag
set statusline +=\ %{&ff}\          "file format
set statusline+=%{&encoding}\       "encoding
set statusline +=%=%c               "separator and column number
set statusline +=,%l/%L\            "current line / total lines
set statusline +=%{strftime(\"%d/%m/%y\ %H:%M\",getftime(expand(\"%:p\")))} " last modified
set statusline +=\ %P               " percentage of file
"set statusline +=0x%04B\           "character under cursor
"set statusline +=%1*\ %n\ %*       "buffer number

" indent-guide stuff
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=lightgrey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=white

" Load other macros
source $HOME/.vim/macros.vim
