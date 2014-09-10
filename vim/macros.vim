" surround.vim notes
" viwS' -> surround inner word with '
" ys$)  -> surround to end of line with parentheses
" cs"'  -> change surround from " to '
" ds"   -> delete surrounding "
" yss)  -> surround entire line with parentheses

" use sane regexes in searches
"nnoremap / /\v
"vnoremap / /\v

" recover from accidental C-w or C-u in insert mode
inoremap <C-u> <c-g>u<C-u>
inoremap <C-w> <c-g>u<C-w>

" like ciw but runs a search
nmap c* :<C-U>let @/='\<'.expand("<cword>").'\>'<cr>:set hls<cr>ciw

" don't move on *
nnoremap * *<C-o>

" gi already moves to 'last place you exited insert mode', so map
" gI as move to last change
nnoremap gI `.

" (visual) X to eXchange two pieces of text
" to use: first delete something, then visual something else
" xnoremap X <esc>`.``gvP``P

" restore last cursor position when reopening a file
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
noremap <leader><Tab> :setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8<CR>
noremap <leader>s2 :call Spaces(2)<CR>
noremap <leader>s4 :call Spaces(4)<CR>

" noremap <leader>n :set number! list!<CR>

" paste mode
" map <leader>p :setlocal paste!<CR>
nnoremap <silent><leader>1 :set paste!<CR>

" search for visually highlighted text
vmap // y/<C-R>"<CR>

" search and replace visually highlighted text
vnoremap <C-r> hy:%s/<C-r>h//g<left><left>

" faster way to start global replace for the previous search
" nnoremap <C-k> :%s///g<left><left>

" tab to switch between split windows
noremap <Tab> <C-w><C-w>

" don't enter ex mode on accident
" nnoremap Q <nop>

" http://tex.stackexchange.com/questions/1548/intelligent-paragraph-reflowing-in-vim
" Reformat lines (getting the spacing correct) {{{
function! TeX_fmt()
  if (getline(".") != "")
    let save_cursor = getpos(".")
    let op_wrapscan = &wrapscan
    set nowrapscan
    let par_begin = '^\(%D\)\=\s*\($\|\\label\|\\begin\|\\end\|\\[\|\\]\|\\\(sub\)*section\>\|\\item\>\|\\NC\>\|\\blank\>\|\\noindent\>\)'
    let par_end   = '^\(%D\)\=\s*\($\|\\begin\|\\end\|\\\(sub\)*section\>\|\\item\>\|\\NC\>\|\\blank\>\)'
    try
      exe '?'.par_begin.'?+'
    catch /E384/
      1
    endtry
    norm V
    try
      exe '/'.par_end.'/-'
    catch /E385/
      $
    endtry
    norm gq
    let &wrapscan = op_wrapscan
    call setpos('.', save_cursor) 
  endif
endfunction
nmap Q :call TeX_fmt()<CR>
" }}}

" split line at cursor, analogue to J
nnoremap K i<CR><ESC>

" remap K (open man page)
" nnoremap M K

" make space and delete work in normal mode like insert mode
" nnoremap <Space> i<Space><ESC>
" nnoremap <Del> a<Del><Esc>

" enter adds a new line below the current one
" nnoremap <CR> A<CR><ESC>

" append a semicolon to the current line
nnoremap <leader>; A;<Esc>

" move the current line up and down
" nnoremap <leader>k      :m-2<CR>==
" nnoremap <leader>j      :m+<CR>==
" nnoremap <leader><Up>   :m-2<CR>==
" nnoremap <C-Up>   :m-2<CR>==
" nnoremap <C-Down> :m+<CR>==

" move the word under the cursor left and right
nnoremap <leader>h       "_yiw?\v\w+\_W+%#<CR>:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o><C-l>
nnoremap <leader>l       "_yiw:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o>/\v\w+\_W+<CR><C-l>
nnoremap <leader><Left>  "_yiw?\v\w+\_W+%#<CR>:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o><C-l>
nnoremap <leader><Right> "_yiw:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o>/\v\w+\_W+<CR><C-l>

" isolate the current line
nnoremap <leader><Space><Space> o<C-o>k<C-o>O<C-o>j<ESC>

" yank visual selection as a single line
vnoremap <leader>- "+y:let @+ = join(map(split(@+, '\n'), 'substitute(v:val, "^\\s\\+", "", "")'), " ")<CR>

" yank and paste to system clipboard
nnoremap <leader>y "+Y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" paste but don't clobber
" xnoremap <leader>p "_dP

" toggle spell
" nnoremap <leader>spell :setlocal spell!<CR>

" use ,/ to clear search highlight
noremap <silent><leader>/ :nohlsearch<CR>

" use ,x to open a quickfix window for the result of the previous search
nnoremap <silent><leader>x :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" don't jump to the start of a line when typing #
inoremap # X<C-h>#

" map Y to be consistent with D, C, etc
noremap Y y$

" map CTRL-f and CTRL-b to move forward and back a word in insert mode
imap <C-f> <C-o>w
imap <C-b> <C-o>b

" select visual block after in/dedent so we can in/dedent more
vnoremap < <gv
vnoremap > >gv

" hard re-wrap text
vmap <leader>q gq
nmap <leader>q gqip

" re-select pasted text
nnoremap <leader>v V`]

" different way to re-select pasted text
nnoremap <expr> gV    "`[".getregtype(v:register)[0]."`]"

" clear out all trailing whitespace
nnoremap <leader>w :%s/\s\+$//<CR>:let @/=''<CR>"
vnoremap <silent> <leader>w :s/\s\+$//<CR>gv

" sort CSS properties
nnoremap <leader>css vi}:sort<CR>

" format XML
nnoremap <leader>=xml :%s/>\s*</>\r</g<CR>:set ft=xml<CR>ggVG=

" format JSON
nnoremap <leader>=json :%s/{/{\r/g<CR>:%s/}/\r}/g<CR>:%s/,/,\r/g<CR>:set ft=javascript<CR>ggVG=

" - or _ : Quick horizontal splits
nnoremap - :sp<Space>
nnoremap -- :sp<CR>

" | : Quick vertical splits
nnoremap <bar> :vsp<Space>
nnoremap <bar><bar> :vsp<CR>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent><leader>d "_d
vmap <silent><leader>d "_d

" k and j don't skip lines in wrapped mode
noremap k gk
noremap j gj

" CCG category searching
command! -nargs=1 S let @/ = escape('<args>', '\')
nmap <leader>S :execute(":S " . input('Regex-off: /'))<CR>

" remove DOS end of lines
nnoremap <silent><leader>dos :%s/\r/\r/ge<CR>:nohlsearch<CR>

" edit vimrc
nnoremap <silent><leader>vimrc :e ~/.vimrc<CR>

" tabs
inoremap <silent><S-Right> <C-o>:tabnext<CR>
inoremap <silent><S-Left>  <C-o>:tabprevious<CR>
nnoremap <silent><S-Right> :tabnext<CR>
nnoremap <silent><S-Left>  :tabprevious<CR>
nnoremap <silent><C-g> :tabclose<CR>

" forgot to sudo
cnoremap w!! w !sudo tee % >/dev/null

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
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
" Based on http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
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

" function call text objects - uses targets.vim
vnoremap ic :<C-U>call targets#xmap('()', 'grow seekselectp')<CR>ob
omap ic :normal vic<CR>
vnoremap ac ::<C-U>call targets#xmap('()', 'grow seekselectp')<CR>oB
omap ac :normal vac<CR>

" latex environment text object
call textobj#user#plugin('latex', {
\   'environment': {
\     'pattern': ['\\begin{[^}]\+}.*\n\s*', '\n^\s*\\end{[^}]\+}.*$'],
\     'select-a': 'ae',
\     'select-i': 'ie',
\   },
\ })

call textobj#user#plugin('php', {
\   'code': {
\     'pattern': ['<?php\>', '?>'],
\     'select-a': 'aP',
\     'select-i': 'iP',
\   },
\ })

" format tabline
set tabline=%!MyTabLine()
function! MyTabLine()
  let s = '' " complete tabline goes here
  " loop through each tab page
  for t in range(tabpagenr('$'))
    " select the highlighting for the buffer names
    if t + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " empty space
    let s .= ' '
    " set the tab page number (for mouse clicks)
    let s .= '%' . (t + 1) . 'T'
    " set page number string
    let s .= t + 1 . ' '
    " get buffer names and statuses
    let n = ''  "temp string for buffer names while we loop and check buftype
    let buflist = tabpagebuflist(t+1)
    let winnr = tabpagewinnr(t+1)
    let b = buflist[winnr-1]
    " buffer types: quickfix gets a [Q], help gets [H]{base fname}
    " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
    if getbufvar( b, "&buftype" ) == 'help'
      let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
    elseif getbufvar( b, "&buftype" ) == 'quickfix'
      let n .= '[Q]'
    else
      let n .= pathshorten(bufname(b))
      "let n .= bufname(b)
    endif
    if len(tabpagebuflist(t + 1)) > 1
      let n .= '[' . len(tabpagebuflist(t + 1)) . ']'
    endif
    " check and ++ tab's &modified count
    if getbufvar( b, "&modified" )
      let n .= '+'
    else
      let n .= ' '
    endif

    if n == ' '
      let s .= '[No Name]'
    else
      let s .= n
    endif
  endfor
  " add modified label [n+] where n pages in tab are modified
  " add buffer names
  " switch to no underlining and add final space to buffer list
  "let s .= '%#TabLineSel#' . ' '
  let s .= ' '
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif
  return s
endfunction

