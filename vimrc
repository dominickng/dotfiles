filetype off
set encoding=utf-8
set fileencoding=utf-8
let mapleader=" "

" indentation
set autoindent
set copyindent
set expandtab
set softtabstop=4
set smarttab
set tabstop=4
set nojoinspaces
set shiftwidth=4
set shiftround

if exists('+breakindent')
  set breakindent
  set showbreak=↪\ \ " trailing space here
endif

" general settings
set cryptmethod=blowfish2
set history=1000
set nrformats-=octal
set path=.,,**
set splitbelow
set splitright
set viminfo='10,\"100,:20,%,n~/.viminfo'

" create ~/tmp/ if it doesn't exist and use ~/tmp as the .swp dir
if has("unix")
  if !isdirectory(expand("~/tmp/vim/."))
    !mkdir -p $HOME/tmp/vim
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
let g:neobundle#install_process_timeout = 1500

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundleLazy '1995eaton/vim-better-javascript-completion', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'AndrewRadev/splitjoin.vim'
NeoBundle 'AndrewRadev/sideways.vim'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'
NeoBundleLazy 'chrisbra/Colorizer', {'autoload':{'filetypes':['javascript', 'html']}}
NeoBundle 'ConradIrwin/vim-bracketed-paste'
NeoBundle 'dominickng/fzf-session.vim'
" NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'jceb/vim-textobj-uri'
NeoBundle 'jeetsukumaran/vim-indentwise'
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'Julian/vim-textobj-variable-segment'
NeoBundle 'junegunn/fzf', {'base': '~/.fzf', 'build': './install --all'}
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'junegunn/vim-after-object'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'junegunn/vim-peekaboo'
" NeoBundle 'justinmk/vim-gtfo'
NeoBundle 'justinmk/vim-matchparenalways'
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'ludovicchabant/vim-gutentags'
NeoBundle 'luochen1990/rainbow'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'nelstrom/vim-visual-star-search'
NeoBundle 'octol/vim-cpp-enhanced-highlight', {'autoload':{'filetypes':['cpp']}}
NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript', 'html']}}
NeoBundle 'Raimondi/delimitMate'
NeoBundleLazy 'rbonvall/vim-textobj-latex', {'autoload':{'filetypes':['tex']}}
NeoBundleLazy 'rhysd/vim-clang-format', {'autoload':{'filetypes':['c', 'cpp']}}
" NeoBundle 'Valloric/YouCompleteMe', {
"      \ 'build' : {
"      \     'mac' : './install.sh --clang-completer --system-libclang',
"      \     'unix' : './install.sh --clang-completer --system-libclang',
"      \     'windows' : './install.sh --clang-completer --system-libclang',
"      \     'cygwin' : './install.sh --clang-completer --system-libclang'
"      \    }
"      \ }
NeoBundle 'Shougo/neocomplete'
" NeoBundle 'Shougo/neoinclude.vim'
" NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neosnippet'
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'Shougo/unite-outline'
" NeoBundle 'Shougo/unite-session'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
" NeoBundle 'terryma/vim-expand-region'
" NeoBundle 'tommcdo/vim-exchange'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-characterize'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-ragtag'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-sleuth'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
" NeoBundle 'tsukkee/unite-tag'
NeoBundle 'unblevable/quick-scope'
NeoBundle 'Valloric/MatchTagAlways'
NeoBundleLazy 'vim-scripts/tex_autoclose.vim', {'autoload':{'filetypes':['tex']}}
NeoBundle 'vim-scripts/ingo-library'
NeoBundle 'vim-scripts/EnhancedJumps'
NeoBundleLazy 'voithos/vim-python-matchit', {'autoload':{'filetypes':['python']}}
NeoBundleLazy 'whatyouhide/vim-textobj-xmlattr', {'autoload':{'filetypes':['html','javascript','xml']}}
NeoBundle 'wellle/targets.vim'
NeoBundle 'Yggdroot/indentLine'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" autocmd FileType php set filetype=php.html.javascript.css
augroup vimrc
  autocmd!
augroup END

" resize splits on window resize
autocmd vimrc VimResized * :wincmd =

autocmd vimrc BufNewFile,BufReadPost *.md set filetype=markdown.html sw=4 softtabstop=4 textwidth=78 spell
autocmd vimrc FileType c,cpp setlocal sw=2 softtabstop=2 textwidth=80
autocmd vimrc FileType java setlocal sw=2 softtabstop=2 textwidth=100
autocmd vimrc FileType c,cpp,java let b:match_words=
   \ '\%(\<else\s\+\)\@<!\<if\>:\<else\s\+if\>:\<else\%(\s\+if\)\@!\>,' .
   \ '\<switch\>:\<case\>:\<default\>'
let g:tex_conceal = ''
let g:tex_indent_items = 0
let g:tex_flavor = 'latex'
let g:tex_noindent_env = 'verbatim\|comment\|lstlisting'
let g:colorizer_auto_filetype='css,html'

" delimitmate
let g:delimitMate_expand_cr = 2
let g:delimitMate_jump_expansion = 1
let g:delimitMate_smart_quotes = 1
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]

" searching
set complete=.,w,b,u,t
set completeopt-=preview
set hlsearch
set ignorecase
set incsearch
set smartcase

" don't use exact searches for */#
noremap * g*
noremap # g#

" stop using the arrow keys
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>

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
set t_vb= " disable beep
set virtualedit+=block " allow cursor to roam in visual block
set visualbell " disable beep
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.swp,*.swo
set wildignore+=.svn,.git,.hg,.bzr,*.svn-base,*.dir-prop-base
set wildignore+=ext,vim/bundle/**,backup/**,backups/**
set wildignore+=*.tmp,.cache
set wildignore+=*.7z,*.lz4,*.zip,*.gz,*.rar,*.bz2,*DS_Store
set wildignore+=*.aux,*.out,*.toc,*.log,*.bbl,*.blg,*.d,*.lof,*.lot
set wildignore+=*.jpg,*.jpeg,*.png,*.bmp,*.gif,*.doc,*.docx,*.xls,*.xlsx,*.pdf,*.psd,*.eps
set wildignore+=*.o,*.obj,*.la,*.mo,*.pyc,*.so,*.class,*.a,*.jar,*.dylib
set wildignore+=migrations,bin,Documents,Pictures,Library,Movies,Applications,Desktop,Downloads,Public,Music,Dropbox

" syntax highlighting and colors
syntax enable
set backspace=indent,eol,start
set background=dark
set colorcolumn=+1
set cursorline
set formatoptions=qrnj1
let g:solarized_termtrans = 1
colorscheme solarized
highlight! link DiffText MatchParen
if has('gui_running')
  " do something
else
  " in terminal mode
  set term=screen-256color
  set t_Co=256
endif

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

highlight EvilSpace ctermbg=darkred guibg=darkred
highlight LeadingTab ctermbg=blue guibg=blue
highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
highlight Tab gui=underline guifg=blue ctermbg=blue
highlight TabLineSel ctermfg=white ctermbg=darkblue cterm=NONE
highlight WhitespaceEOL ctermbg=lightblue

" vim-signature background colour
highlight SignColumn ctermbg=8

" indentLine
let g:indentLine_enabled = 0
nnoremap <leader>ii :IndentLinesToggle<CR>

" statusline
set laststatus=2
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#hunks#enabled = 0
let g:airline_section_warning = airline#section#create(['syntastic', ' ', 'whitespace', ' ', '%{gutentags#statusline()}'])
let g:airline_extensions = ['branch']

" easy-align
vnoremap <Enter> <Plug>(EasyAlign)
nnoremap <leader>a <Plug>(EasyAlign)

" fix the shift-left/right etc. mappings in tmux
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

let g:matchparen_insert_timeout = 5

" rainbow parentheses
let g:rainbow_active = 0
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan'],
\   'operators': '_,_',
\   'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
\   'separately': {
\       '*': {},
\       'lisp': {
\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\           'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan', 'darkred', 'darkgreen'],
\       },
\       'vim': {
\           'parentheses': [['fu\w* \s*.*)','endfu\w*'], ['for','endfor'], ['while', 'endwhile'], ['if','_elseif\|else_','endif'], ['(',')'], ['\[','\]'], ['{','}']],
\       },
\       'tex': {
\           'parentheses': [['(',')'], ['\[','\]'], ['\\begin{.*}','\\end{.*}']],
\       },
\       'css': 0,
\       'stylus': 0,
\   }
\}

" tagbar
nnoremap <leader>t :TagbarToggle<CR>

" tex_autoclose mappings
autocmd vimrc FileType tex inoremap <buffer><silent><C-x>} <esc>:call TexCloseCurrent()<CR>}
autocmd vimrc FileType tex nnoremap <buffer><silent><C-x>c :call TexClosePrev(0)<CR>
autocmd vimrc FileType tex inoremap <buffer><silent><C-x>/ <esc>:call TexClosePrev(1)<CR>

" sideways
nnoremap <C-h> :SidewaysLeft<CR>
nnoremap <C-l> :SidewaysRight<CR>

" expand-region
" vmap v <Plug>(expand_region_expand)
" vmap <C-v> <Plug>(expand_region_shrink)

" gutentags
let g:gutentags_cache_dir = expand("~/tmp/vim/tags")
let g:gutentags_project_root = ['.svn', '.project']
let g:gutentags_exclude = ['/usr/local', 'third_party', 'out', 'build', 'chromeos', 'chromecast', 'webkit', 'native_client', 'native_client_sdk', 'v8', 'buildtools', 'tools', '*js', '*html']
let g:gutentags_generate_on_write = 0

" targets
let g:targets_separators = ', . ; : + - = _ * # / | & $'
let g:targets_argSeparator = '[,;]'

" after-text-object
autocmd vimrc VimEnter * call after_object#enable(['r', 'rr'], '=', ':', '%', '#', ' ', '-')

" incsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)

"let g:incsearch#emacs_like_keymap = 1
"map n  <Plug>(incsearch-nohl-n)
"map N  <Plug>(incsearch-nohl-N)
"map *  <Plug>(incsearch-nohl-*)
"map #  <Plug>(incsearch-nohl-#)
"map g* <Plug>(incsearch-nohl-g*)
"map g# <Plug>(incsearch-nohl-g#)

" git gutter
let g:gitgutter_eager = 0

" clang format
nnoremap <leader>f :ClangFormat<CR>
vnoremap <leader>f :ClangFormat<CR>
let g:clang_format#code_style = "chromium"

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ag and fzf
nnoremap \g :Ag<CR>
nnoremap \f :Files<CR>
nnoremap \b :Buffers<CR>
nnoremap \l :Sessions<CR>
nnoremap \s :Session<Space>

let g:fzf_layout = { 'down': '25%' }
" custom ignore for ag fuzzy find
" exclude all of third_party except WebKit
let g:fuzzy_ag_ignore = ['native_client_sdk', 'android_emulator_sdk', 'buildtools', 'chromeos', 'sql', 'google_update', 'tools', 'out', 'LayoutTests', 'PerformanceTests', 'ManualTests']
let g:fuzzy_ag_ignore += expand('third_party/[^W]*', 0, 1)
let g:fzf_session_path = $HOME . '/tmp/vim/session'

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let $FZF_DEFAULT_COMMAND = 'ag -l --follow --nogroup -g "" --ignore "' . join(split(&wildignore, ','), '" --ignore "') . '" --ignore "' . join(g:fuzzy_ag_ignore, '" --ignore "') .'"'
endif

" Load other macros
source $HOME/.vim/macros.vim
source $HOME/.vim/neocomplete.vim
runtime macros/matchit.vim
