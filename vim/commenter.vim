" Commenting of lines! Stolen & modified from vim.org's ToggleCommentify
map <C-c> :call ToggleCommentify()<CR>j
imap <C-c> <ESC>:call ToggleCommentify()<CR>j
" The nice thing about these mapping is that you don't have to select a visual block to comment 
" ... just keep the CTRL-key pressed down and tap on 'c' as often as you need. 

function! ToggleCommentify()
	let lineString = getline(".")
	if lineString != $						" don't comment empty lines
		let isCommented = strpart(lineString,0,3)		" getting the first 3 symbols
		let commentSymbol = ''

		let commentMapping = {
					\'###': ['python', 'sh', 'muttrc', 'sshconfig', 'make', 'vrml', 'ruby', 'perl', 'conf'], 
					\'///': ['ox', 'java', 'cpp', 'c', 'php', 'javascript'],	
					\'"""': ['vim'], 
					\'!!!': ['xdefaults'],
					\'%%%': ['tex'],
					\'---': ['sql', 'lua', 'nse']
				\}

		for commentChar in keys(commentMapping)
			for name in commentMapping[commentChar]
				if &filetype == name
					let commentSymbol = commentChar
				endif
			endfor
		endfor

		if commentSymbol == ''
			execute 'echo "ToggleCommentify has not (yet) been implemented for the file-type " . &filetype'
		else
			if isCommented == commentSymbol					
				call UnCommentify(commentSymbol)			" if the line is already commented, uncomment
			else
				call Commentify(commentSymbol)				" if the line is uncommented, comment
			endif
		endif
	endif
endfunction

function! Commentify(commentSymbol)	
	execute ':s+^+'.a:commentSymbol.'+'
	nohlsearch
endfunction
	
function! UnCommentify(commentSymbol)	
	execute ':s+'.a:commentSymbol.'++'
	nohlsearch
endfunction

