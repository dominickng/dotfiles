" Launches neocomplcache automatically on vim startup.
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_auto_select = 0
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Sets minimum char length of syntax keyword.
" let g:neocomplete#auto_completion_start_length = 2
" let g:neocomplete#manual_completion_start_length = 2
" let g:neocomplete#min_keyword_length = 3
let g:neocomplete#sources#syntax#min_keyword_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" max completions
let g:neocomplete#max_list = 20
let g:neocomplete#max_keyword_width = 50

if !exists('g:neocomplete#same_filetypes')
  let g:neocomplete#same_filetypes = {}
endif
let g:neocomplete#same_filetypes.html  = 'css'
let g:neocomplete#same_filetypes.xhtml = 'html'
let g:neocomplete#same_filetypes.php = 'html'

" Define file-type dependent dictionaries.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

function! s:neocom_cancel_popup_and(key)
  if pumvisible() && exists('*neocomplete#cancel_popup')
    return neocomplete#cancel_popup() . a:key
  else
    return a:key
  endif
endfunction
 
function! s:neocom_close_popup_and(key)
  if pumvisible() && exists('*neocomplete#close_popup')
    return neocomplete#close_popup() . a:key
  else
    return a:key
  endif
endfunction

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

inoremap <expr><TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"

imap <expr> <C-x> <SID>neocom_cancel_popup_and('<C-x>')

" make <CR> play nice with vim-smartinput
" inoremap <expr> <CR>
      " \ neocomplete#smart_close_popup()
      " \ . eval(smartinput#sid().'_trigger_or_fallback("\<Enter>", "\<Enter>")')
" inoremap <expr> <BS>
      " \ neocomplete#smart_close_popup()
      " \ . eval(smartinput#sid().'_trigger_or_fallback("\<BS>", "\<BS>")')
inoremap <expr> <CR> delimitMate#WithinEmptyPair() ?
          \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
          \ neocomplete#close_popup() . '<CR>'
inoremap <expr> <BS> delimitMate#WithinEmptyPair() ?
          \ "\<C-R>=delimitMate#BS()\<CR>" :
          \ neocomplete#smart_close_popup() . '<BS>'

" <C-h>, <BS>: close popup and delete backword char. Play nice with smartinput
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
imap <expr><C-k> (pumvisible() ? "\<C-y>":"")."\<Plug>(neosnippet_expand_or_jump)"
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" imap <expr> - pumvisible() ? "\<Plug>(neocomplcache_start_unite_quick_match)" : '-'

smap <leader><CR>            <Plug>(neosnippet_expand_or_jump)
xmap <leader><CR>            <Plug>(neosnippet_expand_target)

" inoremap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : pumvisible() ? neocomplcache#complete_common_string() : "\<TAB>"
" inoremap <expr><TAB> pumvisible() ? neocomplete#complete_common_string() : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable omni completion following a matching pattern
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

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

" call neocomplete#custom#source('_', 'converters',
    " \ ['converter_remove_overlap', 'converter_remove_last_paren',
    " \  'converter_delimiter', 'converter_abbr'])
