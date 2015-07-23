" unite
let g:unite_data_directory = '~/tmp/vim/unite'
let g:unite_enable_start_insert = 1
let g:unite_cursor_line_highlight = 'CursorLine'
let g:unite_force_overwrite_statusline = 0
let g:unite_source_rec_max_cache_files = 0
let g:unite_source_file_rec_max_cache_files = 0
let g:unite_split_rule = 'botright'
let g:unite_winheight = 15
let g:unite_source_tag_max_fname_length = 60
let g:unite_source_history_yank_enable = 1
let g:unite_redraw_hold_candidates = 100000

let g:unite_source_session_options = "blank,curdir,tabpages,winpos,winsize"

augroup plugin-unite-source-session
  autocmd!
  autocmd BufEnter,BufLeave *
        \ if v:this_session != '' | call unite#sources#session#_save('') | endif
augroup END

function! s:ExtractGitProject()
  let b:git_dir = finddir('.git', ';')
  return b:git_dir
endfunction

function! UniteGetSource()
  " when inside git dir, do file_rec/git, otherwise file_rec/async
  if exists('b:git_dir') && (b:git_dir ==# '' || b:git_dir =~# '/$')
    unlet b:git_dir
  endif

  if !exists('b:git_dir')
    let dir = s:ExtractGitProject()
    if dir !=# ''
      let b:git_dir = dir
    endif
  endif

  if strlen(b:git_dir)
      return "file_rec/git:--cached:--others:--exclude-standard"
    else
      return "file_rec/async:!"
  endif
endfunction

" use ag for search
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-i --line-numbers --nogroup --nocolor --hidden --ignore "' . join(split(&wildignore, ','), '" --ignore "') . '"'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_max_candidates = 0
  let g:unite_source_rec_async_command = 'ag --follow --nogroup --nocolor --hidden -g "" --ignore "' . join(split(&wildignore, ','), '" --ignore "') . '"'
endif

" call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_globs', split(&wildignore, ','))
call unite#custom#source('file_mru', 'max_candidates', 10)
call unite#custom#source('file_rec,file_rec/async', 'max_candidates', 0)
call unite#custom#source('file_rec,file_rec/async', 'converters', 'converter_relative_word')
call unite#custom#source('file_rec/async,file_rec/git', 'ignore_globs', [])

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " imap <buffer> <C-j>   <Plug>(unite_skip_cursor_down)
  " imap <buffer> <C-k>   <Plug>(unite_skip_cursor_up)
  imap <buffer> <C-w>   <Plug>(unite_delete_backward_path)
  imap <buffer> '       <Plug>(unite_quick_match_default_action)
  nmap <buffer> '       <Plug>(unite_quick_match_default_action)
  imap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <silent><buffer><expr> <C-g> unite#do_action('goto')
  nmap <silent><buffer><expr> <C-g> unite#do_action('goto')
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  nmap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  nmap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  imap <silent><buffer><expr> <C-e> unite#do_action('tabsplit')
  nmap <silent><buffer><expr> <C-e> unite#do_action('tabsplit')
  imap <silent><buffer><expr> <C-d> unite#do_action('delete')
  nmap <silent><buffer><expr> <C-d> unite#do_action('delete')
  imap <silent><buffer> <CR> <Plug>(unite_do_default_action)
  " imap <buffer> <Tab>   <Plug>(unite_select_next_line)
  " imap <silent><buffer> <Tab> <Plug>(unite_do_default_action)
  " nmap <silent><buffer> <Tab> <Plug>(unite_do_default_action)
  imap <silent><buffer> <C-Tab> <Plug>(unite_choose_action)

  nmap <silent><buffer> <C-c> <Plug>(unite_exit)
  imap <silent><buffer> <C-c> <Plug>(unite_exit)
endfunction

function! UniteWrapper(call, action, arguments)
  return ":\<C-u>" . a:call . " " . a:action . " " . a:arguments . "\<CR>"
endfunction

nnoremap [unite] <nop>
nmap <BSlash> [unite]
nnoremap <silent>[unite]f :execute "Unite -no-hide-source-names -resume -sync -buffer-name=unite-f -select=1 " . UniteGetSource()<CR>
nnoremap <silent>[unite]e :execute "UniteWithInputDirectory -no-hide-source-names -resume -sync -buffer-name=unite-e -select=1 " . UniteGetSource()<CR>
" nnoremap <silent>[unite]c :UniteWithCursorWord -profile-name=files -buffer-name=files file_rec/async:!<CR>
nnoremap <silent>[unite]c :execute "UniteWithCurrentDir -resume -sync -buffer-name=unite-c -select=1 " . UniteGetSource()<CR>
nnoremap <silent>[unite]p :execute "UniteWithBufferDir -buffer-name=unite-p -select=1 " . UniteGetSource()<CR>
" nnoremap <silent>[unite]r :Unite buffer tab file_mru directory_mru -resume -sync -buffer-name=unite-r -select=1<CR>
nnoremap <silent>[unite]b :Unite -default-action=goto -select=1 buffer tab<CR>
nnoremap <silent>[unite]o :Unite -auto-preview outline<CR>
nnoremap <silent>[unite]t :Unite tag<CR>
nnoremap <silent>[unite]a :UniteWithCursorWord -select=1 -buffer-name=tag tag<CR>
nnoremap <silent>[unite]g :Unite grep:.<CR>
nnoremap <silent>[unite]y :Unite -select=1 -buffer-name=yanks history/yank<CR>
nnoremap <silent>[unite]l :Unite session<CR>
nnoremap <silent>[unite]m :UniteResume<CR>
nnoremap <silent>[unite]i :UniteResume<CR><End><C-U>
nnoremap <silent>[unite]q :Unite -quick-match
nnoremap [unite]s :UniteSessionSave
