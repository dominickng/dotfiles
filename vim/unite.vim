" unite
let g:unite_data_directory='~/tmp/vim/unite'
let g:unite_enable_start_insert = 1
let g:unite_force_overwrite_statusline = 0
let g:unite_source_rec_max_cache_files=20000
let g:unite_split_rule = 'botright'
let g:unite_winheight = 15
let g:unite_source_tag_max_fname_length = 60

" use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-p ~/.agignore --nogroup --nocolor --column --hidden -g "" ' . '"' . join(split(&wildignore, ','), '" --ignore "') . '"'
  let g:unite_source_grep_recursive_opt = ''
endif

call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_globs', split(&wildignore, ','))
call unite#custom#source('file_mru', 'max_candidates', 20)

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  " imap <buffer> <C-w>   <Plug>(unite_delete_backward_path)
  imap <buffer> '       <Plug>(unite_quick_match_default_action)
  nmap <buffer> '       <Plug>(unite_quick_match_default_action)
  imap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <silent><buffer><expr> <C-g> unite#do_action('goto')
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  imap <silent><buffer><expr> <C-d> unite#do_action('delete')
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
nnoremap <expr> [unite]f UniteWrapper('file' . (expand('%') == '' ? '' : ':%:h') . ' file_rec/async:!' . (expand('%') == '' ? '' : ':%:h') . ' file/new', '-start-insert -buffer-name=files')
nnoremap [unite]c :Unite -profile-name=files -buffer-name=files -start-insert file_rec/async:!<CR>
nnoremap [unite]p :UniteWithBufferDir -buffer-name=file_rec file_rec<CR>
nnoremap [unite]r :Unite -start-insert buffer tab file_mru directory_mru<CR>
nnoremap [unite]b :Unite -start-insert -default-action=goto buffer tab<CR>
nnoremap [unite]o :Unite -start-insert -auto-preview outline<CR>
nnoremap [unite]t :Unite -start-insert tag<CR>
nnoremap [unite]g :Unite grep:.<CR>
