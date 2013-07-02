" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_disable_auto_complete = 0
" Use smartcase.
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_auto_completion_start_length = 2
let g:neocomplcache_manual_completion_start_length = 2
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_min_syntax_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" max completions
let g:neocomplcache_max_list = 20
let g:neocomplcache_max_keyword_width = 50
let g:neocomplcache_max_filename_width = 15
let g:neocomplcache_enable_auto_select = 1

if !exists('g:neocomplcache_same_filetype_lists')
  let g:neocomplcache_same_filetype_lists = {}
endif
let g:neocomplcache_same_filetype_lists.html  = 'css'
let g:neocomplcache_same_filetype_lists.xhtml = 'html'

let g:neocomplcache_plugin_disable = { 'tags_complete': 1 }

" do ctrl-n like completion
"if !exists('g:neocomplcache_same_filetype')
  "let g:neocomplcache_same_filetype_lists = {}
"endif
"let g:neocomplcache_same_filetype_lists._ = '_'

" Define file-type dependent dictionaries.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

let g:neocomplcache_source_rank = {
    \ 'snippets_complete' : 100,
    \ 'abbrev_complete' : 50,
    \ 'syntax_complete' : 50,
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

function! s:neocom_cancel_popup_and(key)
  if pumvisible() && exists('*neocomplcache#cancel_popup')
    return neocomplcache#cancel_popup() . a:key
  else
    return a:key
  endif
endfunction
 
function! s:neocom_close_popup_and(key)
  if pumvisible() && exists('*neocomplcache#close_popup')
    return neocomplcache#close_popup() . a:key
  else
    return a:key
  endif
endfunction

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" inoremap <expr><TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"

imap <expr> <C-x> <SID>neocom_cancel_popup_and('<C-x>')

" make <CR> play nice with vim-smartinput
inoremap <expr> <CR>
      \ neocomplcache#smart_close_popup()
      \ . eval(smartinput#sid().'_trigger_or_fallback("\<Enter>", "\<Enter>")')

" <C-h>, <BS>: close popup and delete backword char. Play nice with smartinput
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr> <BS>
      \ neocomplcache#smart_close_popup()
      \ . eval(smartinput#sid().'_trigger_or_fallback("\<BS>", "\<BS>")')
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" imap <leader><CR>     <Plug>(neosnippet_expand_or_jump)
smap <leader><CR>     <Plug>(neosnippet_expand_or_jump)
xmap <leader><CR>     <Plug>(neosnippet_expand_target)

" Tab jumps to the next spot if jumpable. Otherwise it advances through
" completions like usual
inoremap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : pumvisible() ? neocomplcache#complete_common_string() : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable omni completion following a matching pattern
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" Works like g:neocomplcache_snippets_disable_runtime_snippets
" which disables all runtime snippets
let g:neosnippet#disable_runtime_snippets = {
\   '_' : 1,
\ }

" add snipmate style functions
let g:neosnippet#enable_snipmate_compatibility = 1

" For snippet_complete marker.
"if has('conceal')
  "set conceallevel=2 concealcursor=i
"endif

let g:neosnippet#snippets_directory='~/.vim/snippets'
