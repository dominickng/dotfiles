" To use, save this file and type ":so %"
" Optional: First enter ":let g:rgb_fg=1" to highlight foreground only.
" Restore normal highlighting by typing ":call clearmatches()"
"
" Create a new scratch buffer:
" - Read file $VIMRUNTIME/rgb.txt
" - Delete lines where color name is not a single word (duplicates).
" - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
" Add matches so each color name is highlighted in its color.
call clearmatches()
new
setlocal buftype=nofile bufhidden=hide noswapfile
0read $VIMRUNTIME/rgb.txt
let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
silent execute 'v/'.find_color.'/d'
silent g/grey/d
1
while search(find_color, 'W') > 0
  let w = expand('<cword>')
  if exists('g:rgb_fg') && g:rgb_fg
    execute 'hi col_'.w.' guifg='.w.' guibg=NONE'
  else
    execute 'hi col_'.w.' guifg=black guibg='.w
  endif
  call matchadd('col_'.w, '\<'.w.'\>', -1)
endwhile
1
nohlsearch
