" search for visually highlighted text
:vmap // y/<C-R>"<CR>

" Unhighlight search results
" map <C-l> :nohlsearch<CR>:redraw!<CR>

" Map Y to be consistent with D, C, etc
noremap Y y$

" CTRL-n and CTRL-p to go forwards and backwards through files
nnoremap <C-n> :next<CR>
nnoremap <C-p> :prev<CR>

" CTRL-J/K to move up and down, collapsing open windows
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" Press CTRL-X after pasting something to fix up formatting
""imap <C-z> <ESC>u:set paste<CR>.:set nopaste<CR>i

" Tab to switch between split windows
noremap <Tab> <C-w><C-w>

" autocomplete braces with { } - use same line style
"""imap {<space>} {<CR><Backspace>}<C-o>O

"autocomplete brackets with ( )
"""imap (<space>) ()<LEFT>

"autocomplete quotes with ' ' or \" \"
"imap '<space>' ''<LEFT>
"imap \"<space>\" \""<LEFT>

" mapping F2 to toggle paste mode on and off to avoid autoindenting of pasted code
"""nnoremap <F3> :set invpaste paste?<CR>
"""imap <F3> <C-O><F3>
"""set pastetoggle=<F3>

"map CTRL-f and CTRL-b to move forward and back a word in insert mode
imap <C-f> <C-o>w
imap <C-b> <C-o>b

"map CTRL-a and  CTRL-e to move to start and end of line
"""imap <C-a> <C-o>^
"""imap <C-e> <C-o>$

"""noremap <C-a> ^
"""noremap <C-e> $

"map CTRL-h/j/k/l to move around in insert mode
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l
imap <C-h> <C-o>h

"vnoremap <ESC>[A k
"inoremap <ESC>[B <C-O>vj
"vnoremap <ESC>[B j
"inoremap <ESC>[C <C-O>vl
"vnoremap <ESC>[C l
"inoremap <ESC>[D <C-O>vh
"vnoremap <ESC>[D h

"blame tools
vmap <Leader>b :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR> 
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR> 
vmap <Leader>h :<C-U>!hg blame -fu <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

"delete end of line whitespace
"""nmap <leader>rt :%s/\s\+$//<CR>

"paste mode
map <leader>p :setlocal paste!<CR>

"YRShow
map <leader>r :YRShow<CR>

" clear out all trailing whitespace
nnoremap <leader>w :%s/\s\+$//<CR>:let @/=''<CR>"

" sort CSS properties
nnoremap <leader>css ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" hard re-wrap text
nnoremap <leader>q gqip

" re-select pasted text
nnoremap <leader>v V`]

" use ,x to clear search highlight
noremap <leader>x :nohlsearch<CR>/<BS><CR>

" make enter, space, and delete work in normal mode like insert mode
nnoremap <CR> i<CR><Esc>
nnoremap <Space> i<Space><Esc>
"""nnoremap <Del> a<Del><Esc>

" toggle spell
nnoremap <leader>s :setlocal spell!<CR>

"allow deleting without updating yank buffer
vnoremap x "_x
vnoremap X "_X

"select visual block after in/dedent so we can in/dedent more
vnoremap < <gv
vnoremap > >gv

"case insensitive tags
map <silent> <c-]> :set noic<cr>g<c-]><silent>:set ic<cr>
