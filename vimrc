filetype off
set encoding=utf-8
set fileencoding=utf-8
set nocompatible
set nobk
let mapleader=","

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

" general settings
set history=1000
set nrformats-=octal
set path=.,,**
set splitbelow
set splitright
set viminfo='10,\"100,:20,%,n~/.viminfo'

" create ~/tmp/ if it doesn't exist and use ~/tmp as the .swp dir
if has("unix")
  if !isdirectory(expand("~/tmp/vim/."))
    !mkdir -p ~/tmp/vim
  endif
endif
set backupdir=~/tmp/vim,/var/tmp,/tmp,.
set directory=~/tmp/vim,/var/tmp,/tmp,.

" no backups
set nobackup
set writebackup

" persist undo across sessions
if has("persistent_undo")
    set undodir=~/.tmp/vim/undodir
    set undofile
endif

" tab and buffer behaviour
set hidden
set switchbuf=usetab,newtab

" disable netrw history
let g:netrw_dirhistmax=0

" NeoBundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
call neobundle#end()
filetype plugin indent on
NeoBundleCheck

NeoBundle 'AndrewRadev/splitjoin.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'ap/vim-css-color'
NeoBundle 'bb:atimholt/ArrowKeyRepurpose', {'type': 'hg'}
NeoBundle 'bling/vim-airline'
NeoBundle 'ConradIrwin/vim-bracketed-paste'
NeoBundle 'gcmt/wildfire.vim'
NeoBundle 'godlygeek/tabular'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'justinmk/vim-gtfo'
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'lucapette/vim-textobj-underscore'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'nelstrom/vim-visual-star-search'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'PeterRincker/vim-argumentative'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'tommcdo/vim-exchange'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-characterize'
NeoBundle 'tpope/vim-ragtag'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-sleuth'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'vim-scripts/tex_autoclose.vim', { 'disabled': &ft =~ 'tex' }
NeoBundle 'voithos/vim-python-matchit'
NeoBundle 'wellle/targets.vim'

" autocmd FileType php set filetype=php.html.javascript.css
autocmd FileType c,cpp,java setlocal sw=2 softtabstop=2
autocmd FileType c,cpp,java let b:match_words=
   \ '\%(\<else\s\+\)\@<!\<if\>:\<else\s\+if\>:\<else\%(\s\+if\)\@!\>,' .
   \ '\<switch\>:\<case\>:\<default\>'
let g:tex_indent_items = 0
let g:tex_flavor = 'latex'
let g:tex_noindent_env = 'verbatim\|comment\|lstlisting'

" searching
set complete=.,w,b,u,t
set completeopt-=preview
set hlsearch
set ignorecase
set incsearch
set smartcase

" stop using the arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" nnoremap <up> <c-w>+
" nnoremap <down> <c-w>-
" nnoremap <left> <c-w><
" nnoremap <right> <c-w>>

" visual
set display+=lastline
set lazyredraw
set list
set listchars=tab:»·,trail:·,nbsp:·,extends:$
set mouse=
set number
set ruler
set scrolloff=3
set shortmess=atI
set showcmd
set showmatch
set showtabline=2
set switchbuf=usetab
set tabpagemax=15
set title
set virtualedit+=block " allow cursor to roam in visual block
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.swp,*.swo
set wildignore+=.svn,.git,.hg " version control
set wildignore+=*.7z,*.lz4,*.zip,*.gz,*.rar,*.bz2 " compressed
set wildignore+=*.aux,*.out,*.toc,*.log,*.bbl,*.blg,*.d,*.lof,*.lot " LaTeX
set wildignore+=*.jpg,*.jpeg,*.png,*.bmp,*.gif " binary files
set wildignore+=*.o,*.obj,*.la,*.mo,*.pyc,*.so,*.class,*.a,*.sw? " object files
set wildignore+=migrations " Django migration"

" resize splits on window resize
autocmd VimResized * :wincmd =

" syntax highlighting and colors
syntax on
set background=dark
set backspace=indent,eol,start
set colorcolumn=+1
set cursorline
set formatoptions=qrn1
let g:solarized_termtrans = 1
colorscheme solarized
highlight! link DiffText MatchParen

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" highlight Comment ctermfg=lightblue
" highlight CursorLine cterm=NONE ctermbg=darkgray guibg=darkgray
highlight EvilSpace ctermbg=darkred guibg=darkred
highlight LeadingTab ctermbg=blue guibg=blue
highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
" highlight MatchParen ctermbg=4
" highlight Pmenu ctermbg=238 gui=bold
" highlight Search ctermfg=grey ctermbg=yellow
" highlight SpellBad term=reverse ctermfg=white ctermbg=darkred
" highlight StatusLine ctermfg=black ctermbg=green cterm=NONE
" highlight StatusLineNC ctermfg=black ctermbg=lightblue cterm=NONE
highlight Tab gui=underline guifg=blue ctermbg=blue
highlight WhitespaceEOL ctermbg=lightblue
highlight IndentGuidesOdd ctermbg=black
highlight IndentGuidesEven ctermbg=darkgrey
let NERDSpaceDelims=1

" statusline
set laststatus=2
let g:airline_powerline_fonts=0
let g:airline_left_sep=''
let g:airline_right_sep=''
" let g:airline#extensions#tabline#enabled = 1

" indent-guide
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=lightgrey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=white

" ctrl-p
let g:ctrlp_map = ',f'
" let g:ctrlp_prompt_mappings = {
"   \ 'AcceptSelection("e")': ['<c-e>'],
"   \ 'AcceptSelection("t")': ['<cr>', '<c-m>'],
"   \ }
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_root_markers = ['src']
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_cache_dir = '~/tmp/vim/ctrlp'
let g:ctrlp_open_multiple_files = '2vjr'
let g:ctrlp_extensions = ['funky']
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.git|\.hg|\.svn|working|bin|build|dist)$',
    \ 'file': '\v\.(exe|so|dll|o|dylib|aux|bbl|blg|lot|lof|toc|pyc|swp|egg)$',
    \ }

" ctrlp buffer finding
noremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>r :CtrlPMRU<CR>
nnoremap <leader>c :CtrlPClearCache<CR>
nnoremap <leader>u :CtrlPFunky<CR>
" narrow the list down with a word under cursor
nnoremap <leader>U :execute 'CtrlPFunky ' . expand('<cword>')<CR>

" tabularize
nmap <leader>a& :Tabularize /&<CR>
vmap <leader>a& :Tabularize /&<CR>
nmap <leader>a\| :Tabularize /\|<CR>
vmap <leader>a\| :Tabularize /\|<CR>
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>

" fix the shift-left/right etc. mappings in tmux
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" toggle gundo
nnoremap <leader>g :GundoToggle<CR>

let g:matchparen_insert_timeout=5

" easymotion search for 2 chars
map <leader><Space> <Plug>(easymotion-s2)

" tex_autoclose mappings
autocmd FileType tex inoremap <buffer><silent><C-x>} <esc>:call TexCloseCurrent()<CR>}
autocmd FileType tex nnoremap <buffer><silent><C-x>c :call TexClosePrev(0)<CR>
autocmd FileType tex inoremap <buffer><silent><C-x>/ <esc>:call TexClosePrev(1)<CR>

function! ModifiedTime()
  return strftime(\"%d/%m/%y\ %H:%M\",getftime(expand(\"%:p\")))
endfunction

" targets - disable angle bracket map (conflict with arg text object)
let g:targets_pairs = '()b {}B []r'

" argumentative - rename argument text object
xmap ia <Plug>Argumentative_InnerTextObject
xmap aa <Plug>Argumentative_OuterTextObject
omap ia <Plug>Argumentative_OpPendingInnerTextObject
omap aa <Plug>Argumentative_OpPendingOuterTextObject

" ArrowKeyRepurpose - disable shift left right map
let g:ArrowKeyRepurp_settings = {}
let g:ArrowKeyRepurp_settings.do_map_shift_leftright=0

" wildfire
let g:wildfire_objects = {
    \ "*" : ["i'", 'i"', "i)", "i]", "il", "i}", "ip"],
    \ "html,xml" : ['i"', "at"],
\ }

" Load other macros
source $HOME/.vim/macros.vim
source $HOME/.vim/neocomplete.vim
runtime macros/matchit.vim
