" Keep viminfo
set viminfo=%,'100,\"100,:100,n~/.vim/viminfo

" Vim jumps to the last position when reading a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Keep history
set history=1000

" Make a backup (i. e. 'file~') and save it.
set backup
" create ~/tmp/ if it doesn't exist and use ~/tmp to save the 
" backups into
if has("unix")
	if !isdirectory(expand("~/tmp/vimbak/."))
		!mkdir -p ~/tmp/vimbak
	endif
	if !isdirectory(expand("~/tmp/vimtmp/."))
		!mkdir -p ~/tmp/vimtmp
	endif
endif
set backupdir=~/tmp/vimbak
set directory=~/tmp/vimtmp,.,/var/tmp,/tmp

set modelines=5
