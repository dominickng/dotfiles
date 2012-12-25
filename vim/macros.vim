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

inoremap <TAB> <C-R>=InsertTabWrapper("forward")<CR>
inoremap <S-TAB> <C-R>=InsertTabWrapper("backward")<CR>

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

" buffet keymap
map <leader>b :Bufferlist<CR>

" toggle spell
nnoremap <leader>spell :setlocal spell!<CR>

" make enter, space, and delete work in normal mode like insert mode
nnoremap <CR> i<CR><ESC>
nnoremap <Space> i<Space><ESC>
"nnoremap <Del> a<Del><Esc>

" use ,/ to clear search highlight
"noremap <leader>/ :nohlsearch<CR>/<BS><CR>
noremap <silent> <leader>/ :nohlsearch<CR>

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
nnoremap <silent> <leader>rn :%s/\r/\r/ge<CR>:nohlsearch<CR>

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
