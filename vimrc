" Don't try to be like vi
set nocompatible

" Backspace should work across lines
set bs=2

"set leader key to ,
let mapleader=","

"set yankring prefs
let g:yankring_history_dir = '$HOME/.vim'
let g:yankring_history_file = 'yankring_history'

"set supertab prefs
"let g:SuperTabDefaultCompletionType = "context"
"disable supertab
let g:complType = 1

" Read files from ~/.vim
"""source ~/.vim/commenter.vim
source ~/.vim/display.vim
source ~/.vim/filetypes.vim
source ~/.vim/indent.vim
source ~/.vim/macros.vim
source ~/.vim/mappings.vim
source ~/.vim/state.vim
if !filereadable(expand("~/.vim/abbrsout.vim"))
	!python ~/.vim/abbrs2vim.py
endif
source ~/.vim/abbrsout.vim
if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif
