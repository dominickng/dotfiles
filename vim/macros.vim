" surround.vim notes
" viwS' -> surround inner word with '
" ys$)  -> surround to end of line with parentheses
" cs"'  -> change surround from " to '
" ds"   -> delete surrounding "
" yss)  -> surround entire line with parentheses

" restore cursor position
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" make tab autocomplete or insert tab as defined by prior context
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col-1] !~ '\k' && getline('.')[col-1] !~ ':'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

"inoremap <TAB> <C-R>=InsertTabWrapper("forward")<CR>
"inoremap <S-TAB> <C-R>=InsertTabWrapper("backward")<CR>

" indentation switching
function! Spaces(...)
  if a:0 == 1
    let l:width = a:1
  else
    let l:width = 2
  endif
  setlocal expandtab
  let &l:shiftwidth = l:width
  let &l:softtabstop = l:width
endfunction
command! T setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8
command! -nargs=? Sp call Spaces(<args>)</args>
noremap <leader>t :setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8<CR>
noremap <leader>s2 :call Spaces(2)<CR>
noremap <leader>s4 :call Spaces(4)<CR>

"turning off visuals for copying
function! s:NoVisuals()
if !exists("s:visuals_on")
  let s:visuals_on = "true"
endif
if s:visuals_on == "true"
  let s:visuals_on = "false"
  set nonumber
  set nolist
  echo 'Visuals off'
else
  let s:visuals_on = "true"
  set number
  set list
  echo 'Visuals on'
endif
endfunction
noremap <leader>n :call <SID>NoVisuals()<CR>

"noremap <buffer> <silent> <expr> <leader>a AutoPairsToggle()
" paste mode
map <leader>p :setlocal paste!<CR>

" ctrlp buffer finding
noremap <leader>r :CtrlPBuffer<CR>

"function! PasteToggle()
  "setlocal paste!
  "call AutoPairsToggle()
  "return
"endfunction
"noremap <buffer> <silent> <expr> <leader>p PasteToggle()

" search for visually highlighted text
vmap // y/<C-R>"<CR>

" tab to switch between split windows
noremap <Tab> <C-w><C-w>

" make s act like C-w
nnoremap s <C-W>

" yank visual selection as a single line
" vnoremap <silent> <Leader>y "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+", "", "")'), " ")<CR>

" buffet keymap
map <leader>b :Bufferlist<CR>

" toggle spell
nnoremap <leader>spell :setlocal spell!<CR>

" toggle gundo
nnoremap <leader>g :GundoToggle<CR>

" make enter, space, and delete work in normal mode like insert mode
nnoremap <CR> i<CR><ESC>
nnoremap <Space> i<Space><ESC>
"nnoremap <Del> a<Del><Esc>

" use ,/ to clear search highlight
"noremap <leader>/ :nohlsearch<CR>/<BS><CR>
noremap <silent> <leader>/ :nohlsearch<CR>

" use ,, to open a quickfix window for the result of the previous search
nnoremap <silent> <leader>, :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" show whitespace at EOL with <leader>ws
nmap <silent> <leader>ws :set nolist!<CR>

" don't jump to the start of a line when typing #
inoremap # X<c-h>#

" map Y to be consistent with D, C, etc
noremap Y y$

" map CTRL-f and CTRL-b to move forward and back a word in insert mode
imap <C-f> <C-o>w
imap <C-b> <C-o>b

" CTRL-J/K to move up and down, collapsing open windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" select visual block after in/dedent so we can in/dedent more
vnoremap < <gv
vnoremap > >gv

" hard re-wrap text
vmap <leader>q gq
nmap <leader>q gqip

" re-select pasted text
nnoremap <leader>v V`]

" clear out all trailing whitespace
nnoremap <leader>c :%s/\s\+$//<CR>:let @/=''<CR>"

" sort CSS properties
nnoremap <leader>css ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" format XML
nnoremap <leader>xml :%s/>\s*</>\r</g<CR>:set ft=xml<CR>ggVG=

" format JSON
nnoremap <leader>json :%s/{/{\r/g<CR>:%s/}/\r}/g<CR>:%s/,/,\r/g<CR>:set ft=javascript<CR>ggVG=

" time saver
"nnoremap ; :
"inoremap kj <Esc>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

noremap k gk
noremap j gj

" CCG category searching
command! -nargs=1 S let @/ = escape('<args>', '\')
nmap <leader>S :execute(":S " . input('Regex-off: /'))<CR>

" remove DOS end of lines
nnoremap <silent> <leader>dos :%s/\r/\r/ge<CR>:nohlsearch<CR>

" edit vimrc
nnoremap <silent> <leader>vimrc :e ~/.vimrc<CR>
nnoremap <silent> <leader>macros :e ~/.vim/macros.vim<CR>

" tabs
nnoremap <silent> <S-Right> :tabnext<CR>
nnoremap <silent> <S-Left>  :tabprevious<CR>
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
"nnoremap <silent> <C-]> :tabnext<CR>
"nnoremap <silent> <C-[> :tabprevious<CR>
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-g> :tabclose<CR>

" buffer transfer
"nmap <leader>w :!echo ""> ~/.vim/vimxfer<CR><CR>:w! ~/.vim/vimxfer<CR>
"vmap <leader>w :w! ~/.vim/vimxfer<CR>
"nmap <leader>a :!echo ""> ~/.vim/vimxfer<CR><CR>:w! >>~/.vim/vimxfer<CR>
"vmap <leader>a :w! >>~/.vim/vimxfer<CR>
"nmap <leader>r :r ~/.vim/vimxfer<CR>
"vmap <leader>r :r ~/.vim/vimxfer<CR>

" forgot to sudo
cnoreabbrev <expr> w!!
                \((getcmdtype() == ':' && getcmdline() == 'w!!')
                \?('!sudo tee % >/dev/null'):('w!!'))

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

" Start the find and replace command across the entire file
vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>/

" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
let g:acp_enableAtStartup = 0
" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_min_syntax_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder 
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define file-type dependent dictionaries.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion, which require computational power and may stall the vim. 
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Works like g:neocomplcache_snippets_disable_runtime_snippets
" which disables all runtime snippets
let g:neosnippet#disable_runtime_snippets = {
\   '_' : 1,
\ }

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#snippets_directory='~/.vim/snippets'
