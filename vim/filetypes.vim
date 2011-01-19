" Make vim aware of filetypes
filetype plugin indent on

" Pick up some filetypes from their extensions
autocmd BufNewFile,BufRead *.txt setlocal ft=text
autocmd BufNewFile,BufRead mutt* setlocal ft=mail spell!
autocmd BufNewFile,BufRead *.tex setlocal ft=tex spell!
autocmd BufNewFile,BufRead *.nse setlocal ft=lua
autocmd BufNewFile,BufRead *.nse setlocal ft=php

" Set options based on filetypes
autocmd FileType text setlocal nosmartindent "textwidth=78 
autocmd FileType mail setlocal textwidth=78 nosmartindent
autocmd FileType tex setlocal textwidth=78 nosmartindent

"""autocmd FileType html setlocal sw=2 sts=2
"""autocmd FileType css setlocal sw=2 sts=2

"highlight tabs
syntax match Tab /\t/
hi Tab gui=underline guifg=blue ctermbg=blue 

" Don't automatically continue comments on new lines
"""autocmd BufNewFile,BufRead * setlocal formatoptions-=r
"""if has("autocmd")
"""    autocmd FileType python set complete+=k~/.vim/pydiction-0.5/pydiction isk+=.,(
"""endif " has("autocmd") 

"add stl tags dir
"""autocmd FileType cpp set tags+=~/.tags/stl3.3.tags

"""autocmd FileType cpp let OmniCpp_MayCompleteDot = 1 " autocomplete with .
"""autocmd FileType cpp let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
"""autocmd FileType cpp let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
"""autocmd FileType cpp let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
"""autocmd FileType cpp let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
"""autocmd FileType cpp let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) in popup window
