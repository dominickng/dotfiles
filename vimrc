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
set path=.,,**
set history=1000
set viminfo='10,\"100,:20,%,n~/.viminfo'

" create ~/tmp/ if it doesn't exist and use ~/tmp as the .swp dir
if has("unix")
  if !isdirectory(expand("~/tmp/vim/."))
    !mkdir -p ~/tmp/vim
  endif
endif
set directory=~/tmp/vim,.,/var/tmp,/tmp

" no backups
set nobackup
set writebackup

" tab and buffer behaviour
set switchbuf=usetab,newtab

" diable netrw history
let g:netrw_dirhistmax=0

" indentation
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
autocmd FileType c,cpp,java setlocal sw=2 softtabstop=2
let g:tex_flavor='latex'

" searching
set hlsearch
set ignorecase
set incsearch
set smartcase

" stop using the arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" visual
set display+=lastline
set list
set listchars=tab:»·,trail:·,nbsp:·,extends:$
set mouse=
set number
set ruler
set scrolloff=3
set showcmd
set showmatch
set showtabline=2
set switchbuf=usetab
set title
set wildmenu
set wildmode=list:longest,full
set wildignore=.svn,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.bak,*.pyc,*.class

" syntax highlighting and colors
syntax on
set backspace=indent,eol,start
set cursorline
set background=dark
let g:solarized_termtrans = 1
"colorscheme default
colorscheme solarized

"highlight Comment ctermfg=lightblue
"highlight CursorLine cterm=NONE ctermbg=darkgray guibg=darkgray
highlight EvilSpace ctermbg=darkred guibg=darkred
highlight LeadingTab ctermbg=blue guibg=blue
highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
"highlight MatchParen ctermbg=4
"highlight Pmenu ctermbg=238 gui=bold
"highlight Search ctermfg=grey ctermbg=yellow
"highlight SpellBad term=reverse ctermfg=white ctermbg=darkred
"highlight StatusLine ctermfg=black ctermbg=green cterm=NONE
"highlight StatusLineNC ctermfg=black ctermbg=lightblue cterm=NONE
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

" ctrl-p
let g:ctrlp_map = ',f'
"let g:ctrlp_prompt_mappings = {
  "\ 'AcceptSelection("e")': ['<c-e>'],
  "\ 'AcceptSelection("t")': ['<cr>', '<c-m>'],
  "\ }

" fix the shift-left/right etc. mappings in tmux
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Load other macros
source $HOME/.vim/macros.vim
