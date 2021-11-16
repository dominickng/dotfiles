" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Jump to something's definition in a tab, vsplit, or split
nmap <silent> <leader>td :call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> <leader>vd :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> <leader>sd :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> <leader>ti :call CocAction('jumpImplementation', 'tab drop')<CR>
nmap <silent> <leader>vi :call CocAction('jumpImplementation', 'vsplit')<CR>
nmap <silent> <leader>si :call CocAction('jumpImplementation', 'split')<CR>
nmap <silent> gr <Plug>(coc-references)
