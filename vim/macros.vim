" Python Calculator
command! -nargs=+ Calc :r! python -c "from math import *; print <args>"

" I frequently type :Q or :WQ, etc instead of :q, :wq
command! WQA :wqa
command! WqA :wqa
command! WQa :wqa
command! Wqa :wqa
command! WA :wa
command! Wa :wa
command! WQ :wq
command! Wq :wq
command! W :w
command! Wn :wn
command! WN :wn
command! Wp :wp
command! WP :wp
command! QA :qa
command! Qa :qa
command! Q :q

" Spell checking mode toggle
function s:spell()
	if !exists("s:spell_check") || s:spell_check == 0
		echo  "Spell check on"
		let s:spell_check = 1
		setlocal spell spelllang=en_au
	else
		echo "Spell check off"
		let s:spell_check = 0
		setlocal spell spelllang=
	endif
endfunction
map <F8> :call <SID>spell()<CR>
imap <F8> <C-o>:call <SID>spell()<CR>

"make % jump between more stuff
runtime macros/matchit.vim

"use tab intelligently to autocomplete or insert tabs based on context
"also check for :: for c++ code
"function! SuperCleverTab()
    "if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        "return "\<Tab>"
    "else
        "if &omnifunc != ''
            "return "\<C-X>\<C-O>"
        "elseif &dictionary != ''
            "return "\<C-K>"
        "else
            "return "\<C-N>"
        "endif
    "endif
"endfunction

"inoremap <Tab> <C-R>=SuperCleverTab()<CR>

function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k' && getline('.')[col - 1] !~ ':'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<CR>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<CR>

function! CheckForShebang()
   if (match( getline(1) , '^\#!') == 0)
       map <F5> :!./%<CR>
   else
       unmap <F%>
   endif  
endfunction
map <F5> :call CheckForShebang()

