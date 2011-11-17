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

inoremap <TAB> <C-R>=InsertTabWrapper("forward")<CR>
inoremap <S-TAB> <C-R>=InsertTabWrapper("backward")<CR>

" search for visually highlighted text
vmap // y/<C-R>"<CR>

" tab to switch between split windows
noremap <Tab> <C-w><C-w>

" toggle spell
nnoremap <leader>s :setlocal spell!<CR>

" make enter, space, and delete work in normal mode like insert mode
nnoremap <CR> i<CR><ESC>
nnoremap <Space> i<Space><ESC>
"nnoremap <Del> a<Del><Esc>

" use ,x to clear search highlight
noremap <leader>x :nohlsearch<CR>/<BS><CR>

" show whitespace at EOL with <leader>ws
set listchars=tab:>-,trail:·,eol:$
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
nnoremap <leader>q gqip

" paste mode
map <leader>p :setlocal paste!<CR>

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
nnoremap ; :
inoremap kj <Esc>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

noremap <up> gk
noremap <down> gj
