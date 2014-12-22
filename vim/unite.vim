" unite
let g:unite_data_directory='~/tmp/vim/unite'
let g:unite_enable_start_insert = 1
let g:unite_cursor_line_highlight = 'CursorLine'
let g:unite_force_overwrite_statusline = 0
let g:unite_source_rec_max_cache_files=20000
let g:unite_split_rule = 'botright'
let g:unite_winheight = 15
let g:unite_source_tag_max_fname_length = 60
let g:unite_source_history_yank_enable = 1

let g:unite_source_session_options = "blank,curdir,tabpages,winpos,winsize"

augroup plugin-unite-source-session
  autocmd!
  autocmd BufEnter,BufLeave *
        \ if v:this_session != '' | call unite#sources#session#_save('') | endif
augroup END

" use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-i --line-numbers --nogroup --nocolor --hidden --ignore ''' . join(split(&wildignore, ','), "' --ignore '") . "'"
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_rec_async_command = 'ag --follow --nogroup --nocolor --hidden -g "" --ignore "' . join(split(&wildignore, ','), '" --ignore "') . '"'
endif

call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_globs', split(&wildignore, ','))
call unite#custom#source('file_mru', 'max_candidates', 20)
call unite#custom#source('file_rec,file_rec/async', 'max_candidates', 0)

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_skip_cursor_down)
  imap <buffer> <C-k>   <Plug>(unite_skip_cursor_up)
  imap <buffer> <C-w>   <Plug>(unite_delete_backward_path)
  imap <buffer> '       <Plug>(unite_quick_match_default_action)
  nmap <buffer> '       <Plug>(unite_quick_match_default_action)
  imap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-e>   <Plug>(unite_narrowing_input_history)
  imap <silent><buffer><expr> <C-g> unite#do_action('goto')
  imap <silent><buffer><expr> <C-s> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  imap <silent><buffer><expr> <C-d> unite#do_action('delete')
  imap <silent><buffer><expr> <C-x> unite#do_action('delete')
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
nnoremap <expr> [unite]f UniteWrapper('file' . (expand('%') == '' ? '' : ':%:h') . ' file_rec/async:!' . (expand('%') == '' ? '' : ':%:h') . ' file/new', '-buffer-name=files')
" nnoremap <silent>[unite]c :UniteWithCursorWord -profile-name=files -buffer-name=files file_rec/async:!<CR>
nnoremap <silent>[unite]c :UniteWithCurrentDir -buffer-name=file_rec file_rec/async<CR>
nnoremap <silent>[unite]p :UniteWithBufferDir -buffer-name=file_rec file_rec/async<CR>
nnoremap <silent>[unite]r :Unite buffer tab file_mru directory_mru<CR>
nnoremap <silent>[unite]b :Unite -default-action=goto buffer tab<CR>
nnoremap <silent>[unite]o :Unite -auto-preview outline<CR>
nnoremap <silent>[unite]t :Unite tag<CR>
nnoremap <silent>[unite]a :UniteWithCursorWord -buffer-name=tag tag<CR>
nnoremap <silent>[unite]g :Unite grep:.<CR>
nnoremap <silent>[unite]y :Unite -buffer-name=yanks history/yank<CR>
nnoremap <silent>[unite]l :Unite session<CR>
nnoremap <silent>[unite]e :UniteResume<CR>
nnoremap <silent>[unite]i :UniteResume<CR><End><C-U>
nnoremap [unite]s :UniteSessionSave<CR>
