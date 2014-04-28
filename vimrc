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
NeoBundle 'AndrewRadev/splitjoin.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'ap/vim-css-color'
NeoBundle 'bb:atimholt/ArrowKeyRepurpose', {'type': 'hg', 'external_commands' : 'hg'}
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
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'lucapette/vim-textobj-underscore'
NeoBundle 'nelstrom/vim-visual-star-search'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'PeterRincker/vim-argumentative'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
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
NeoBundle 'Yggdroot/indentLine'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

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

highlight EvilSpace ctermbg=darkred guibg=darkred
highlight LeadingTab ctermbg=blue guibg=blue
highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
highlight Tab gui=underline guifg=blue ctermbg=blue
highlight WhitespaceEOL ctermbg=lightblue
let NERDSpaceDelims=1

" indentLine
let g:indentLine_enabled = 0
nnoremap <leader>ii :IndentLinesToggle<CR>

" statusline
set laststatus=2
let g:airline_powerline_fonts=0
let g:airline_left_sep=''
let g:airline_right_sep=''
" let g:airline#extensions#tabline#enabled = 1

" unite
let g:unite_data_directory='~/tmp/vim/unite'
let g:unite_enable_start_insert = 1
let g:unite_force_overwrite_statusline = 0
let g:unite_source_rec_max_cache_files=5000
let g:unite_split_rule = 'botright'
let g:unite_winheight = 10

" use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" extend default ignore pattern for file_rec source (same as directory_rec)
let s:file_rec_ignore = unite#get_all_sources('file_rec')['ignore_pattern'] .
    \ '\|\.\%(jar\|jpg\|gif\|png\)$' .
    \ '\|vim/bundle/' .
    \ '\|.git/\|.svn/' .
    \ '\|opt\|Downloads\|eclipse_workspace\|gwt-unitCache\|grimoire-remote'
call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_pattern', s:file_rec_ignore)
call unite#custom#source('file_mru', 'max_candidates', 10)

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-g> unite#do_action('goto')
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  imap <silent><buffer> <CR> <Plug>(unite_do_default_action)
  imap <silent><buffer> <Tab> <Plug>(unite_do_default_action)
  nmap <silent><buffer> <Tab> <Plug>(unite_do_default_action)
  imap <silent><buffer> <C-Tab> <Plug>(unite_choose_action)

  nmap <silent><buffer> <C-c> <Plug>(unite_exit)
  imap <silent><buffer> <C-c> <Plug>(unite_exit)
  nmap <silent><buffer> <Esc> <Plug>(unite_exit)
endfunction

function! UniteWrapper(action, arguments)
  return ":\<C-u>Unite " . a:action . " " . a:arguments . "\<CR>"
endfunction

nnoremap [unite] <nop>
nmap <Space> [unite]
nnoremap <expr> [unite]f UniteWrapper('file' . (expand('%') == '' ? '' : ':%:h') . ' file_rec/async:!' . (expand('%') == '' ? '' : ':%:h') . ' file/new', '-start-insert')
nnoremap [unite]c :Unite -profile-name=files -buffer-name=files -start-insert file_rec/async:!<CR>
nnoremap [unite]p :UniteWithBufferDir -buffer-name=file_rec file_rec<CR>
nnoremap [unite]r :Unite -start-insert buffer tab file_mru directory_mru<CR>
nnoremap [unite]b :Unite -start-insert -default-action=goto buffer tab<CR>
nnoremap [unite]o :Unite -start-insert -auto-preview outline<CR>
nnoremap [unite]g :Unite grep:.<CR>

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

let g:matchparen_insert_timeout=5

" easymotion search for 2 chars
map <leader><Space> <Plug>(easymotion-s2)

" tex_autoclose mappings
autocmd FileType tex inoremap <buffer><silent><C-x>} <esc>:call TexCloseCurrent()<CR>}
autocmd FileType tex nnoremap <buffer><silent><C-x>c :call TexClosePrev(0)<CR>
autocmd FileType tex inoremap <buffer><silent><C-x>/ <esc>:call TexClosePrev(1)<CR>

" targets - disable angle bracket map to a (conflict with arg text object)
let g:targets_pairs = '()b {}B []r <>'

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
