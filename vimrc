filetype off
set encoding=utf-8
set fileencoding=utf-8
let mapleader=" "

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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

" vim-plug

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug '1995eaton/vim-better-javascript-completion', {'for': 'javascript'}
Plug 'airblade/vim-gitgutter'
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'chaoren/vim-wordmotion'
Plug 'chrisbra/Colorizer', {'for': ['html', 'javascript']}
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'dominickng/fzf-session.vim'
Plug 'hashivim/vim-terraform'
Plug 'haya14busa/incsearch.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jceb/vim-textobj-uri'
" Plug 'jeetsukumaran/vim-indentwise'
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'Julian/vim-textobj-variable-segment'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-after-object'
Plug 'junegunn/vim-easy-align'
" Plug 'junegunn/vim-peekaboo'
" Plug 'justinmk/vim-gtfo'
Plug 'justinmk/vim-matchparenalways'
Plug 'justinmk/vim-sneak'
" Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kshenoy/vim-signature'
" Plug" 'Lokaltog/vim-easymotion'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-swap'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'majutsushi/tagbar'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight', {'for' : 'cpp'}
" Plug 'pangloss/vim-javascript', {'for': ['html', 'javascript']}
Plug 'othree/yajs.vim'
Plug 'posva/vim-vue'
Plug 'Raimondi/delimitMate'
Plug 'rbonvall/vim-textobj-latex', {'for': 'tex'}
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp', 'java', 'javascript']}
" Plug 'Valloric/YouCompleteMe', {
"      \ 'do' : {
"      \     'mac' : './install.sh --clang-completer --system-libclang',
"      \     'unix' : './install.sh --clang-completer --system-libclang',
"      \     'windows' : './install.sh --clang-completer --system-libclang',
"      \     'cygwin' : './install.sh --clang-completer --system-libclang'
"      \    }
"      \ }
" Plug 'Rip-Rip/clang_complete', {'for': ['c', 'cpp'], 'do': 'make install'}
" Plug 'roxma/nvim-completion-manager'
" Plug 'roxma/ncm-clang'
" Plug 'Shougo/neocomplete'
" Plug 'Shougo/neoinclude.vim'
" Plug 'Shougo/neomru.vim'
" Plug 'Shougo/neosnippet'
" Plug 'Shougo/unite.vim'
" Plug 'Shougo/unite-outline'
" Plug 'Shougo/unite-session'
" Plug 'Shougo/vimproc', { 'do' : 'make' }
" Plug 'terryma/vim-expand-region'
Plug 'thalesmello/vim-textobj-methodcall'
" Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" Plug 'tsukkee/unite-tag'
Plug 'unblevable/quick-scope'
Plug 'Valloric/MatchTagAlways'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/tex_autoclose.vim', {'for': 'tex'}
Plug 'vim-scripts/ingo-library'
Plug 'vim-scripts/EnhancedJumps'
Plug 'voithos/vim-python-matchit', {'for': 'python' }
Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html','javascript','xml']}
Plug 'wellle/targets.vim'
Plug 'yaegassy/coc-volar', { 'do': 'yarn install --frozen-lockfile' }
Plug 'yaegassy/coc-volar-tools', { 'do': 'yarn install --frozen-lockfile' }
Plug 'Yggdroot/indentLine'

call plug#end()
filetype plugin indent on

" autocmd FileType php set filetype=php.html.javascript.css
augroup vimrc
  autocmd!
augroup END

" resize splits on window resize
autocmd vimrc VimResized * :wincmd =

autocmd vimrc BufNewFile,BufReadPost *.md set filetype=markdown.html sw=4 softtabstop=4 textwidth=78 spell
autocmd vimrc BufNewFile,BufReadPost *.mdx set filetype=markdown.html sw=4 softtabstop=4 textwidth=78 spell
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
set wildignore+=*.aux,*.out,*.toc,*.log,*.bbl,*.blg,*.d,*.lof,*.lot,*.fdb_latexmk,*.acn,*.acr,*.drv,*.vrb,*.fls,*.glo,*.ist*.loa,*.tdo
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
let g:airline_section_y = airline#section#create(['ffenc', '%{get(g:, "this_fzf_session_name", "")}'])
" let g:airline_section_warning = airline#section#create(['syntastic', ' ', 'whitespace', ' ', '%{gutentags#statusline()}'])
" let g:airline_extensions = ['branch']
let g:airline#extensions#branch#enabled = 0

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

" expand-region
" vmap v <Plug>(expand_region_expand)
" vmap <C-v> <Plug>(expand_region_shrink)

" gutentags
let g:gutentags_cache_dir = expand("~/tmp/vim/tags")
let g:gutentags_project_root = ['.svn', '.project']
let g:gutentags_exclude = ['/usr/local', 'third_party', 'out', 'build', 'chromeos', 'chromecast', 'webkit', 'native_client', 'native_client_sdk', 'v8', 'buildtools', 'tools', '*js', '*html']
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_write = 0
let g:gutentags_enabled = 0

" targets
let g:targets_separators = ', . ; : + - = _ * # / | & $'
let g:targets_argSeparator = '[,;]'

" after-text-object
autocmd vimrc VimEnter * call after_object#enable(['r', 'rr'], '=', ':', '%', '#', ' ', '-')

" switch
let g:switch_mapping = "-"

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
let g:clang_format#filetype_style_options = {
      \   'cpp' : {"BasedOnStyle" : "Chromium"},
      \   'java' : {"BasedOnStyle" : "Chromium"},
      \ }

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ag and fzf
nnoremap \g :Ag<CR>
nnoremap \f :Files<CR>
nnoremap \b :Buffers<CR>
nnoremap \w :Windows<CR>
nnoremap \l :Sessions<CR>
nnoremap \s :Session<Space>

let g:fzf_layout = { 'down': '25%' }
" custom ignore for ag fuzzy find
" exclude all of third_party except WebKit
let g:fuzzy_ag_ignore = ['native_client_sdk', 'android_emulator_sdk', 'buildtools', 'chromeos', 'sql', 'google_update', 'tools', 'out', 'LayoutTests', 'PerformanceTests', 'ManualTests']
let g:fuzzy_ag_ignore += expand('third_party/[^W]*', 0, 1)
let g:fzf_session_path = $HOME . '/tmp/vim/session'
let g:fzf_buffers_jump = 1

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let $FZF_DEFAULT_COMMAND = 'ag -l --follow --nogroup -g "" --ignore "' . join(split(&wildignore, ','), '" --ignore "') . '" --ignore "' . join(g:fuzzy_ag_ignore, '" --ignore "') .'"'
endif

" Load other macros
source $HOME/.vim/macros.vim
" source $HOME/.vim/neocomplete.vim
source $HOME/.vim/coc.vim
runtime macros/matchit.vim
