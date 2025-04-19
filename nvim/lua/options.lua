local utils = require("utils")
local HOME = os.getenv("HOME")

if vim.g.is_linux or vim.g.is_mac then
  utils.may_create_dir(HOME .. "/tmp/nvim")
end
vim.opt.backupdir = HOME .. "/tmp/nvim"
vim.opt.directory = HOME .. "/tmp/nvim"
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = HOME .. "/tmp/nvim/undodir"

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Turn off the mouse
vim.opt.mouse = ""

-- Make space the mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Always show the signcolumn merged with the number column
vim.opt.signcolumn = "number"

-- Show line numbers
vim.opt.number = true
vim.opt.laststatus = 2

-- Color
vim.opt.background = "dark"
vim.opt.backspace = "indent,eol,start"
vim.opt.termguicolors = true
vim.opt.colorcolumn = "+1"
vim.opt.cursorline = true
vim.opt.formatoptions = "qrnj1"

-- Indentation
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 4
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.breakindent = true
vim.opt.showbreak = "↪  "
vim.opt.joinspaces = false
vim.opt.smarttab = true

-- Split direction
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Tabs
vim.opt.hidden = true
vim.opt.switchbuf = "useopen,usetab"

-- Searching
vim.opt.complete = ".,w,b,u,t"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"
vim.opt.smartcase = true

-- Visual options
vim.opt.backspace = "indent,eol,start"
vim.opt.shortmess = "atI"
vim.opt.showmatch = true
vim.opt.showtabline = 2
vim.opt.tabpagemax = 15
vim.opt.title = true
vim.opt.scrolloff = 3
vim.opt.ruler = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "»·",
  trail = "·",
  nbsp = "·",
  extends = "$"
}

-- wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
vim.opt.wildignore:append({ "*.o", "*~", "*.obj", "*.so", "*.pyc", "*pycache*", "*.swp", "*.bak", "*.class", "*.jar", })
vim.opt.wildignore:append({ "*.zip", "*.tar.gz", "*.tar.bz2", "*.rar", "*.tar.xz", })
vim.opt.wildignore:append({ "*.git", "*.svn", "*.hg", "*.bzr", "*.vagrant", "*.DS_Store", "tmp", })
vim.opt.wildignore:append({ "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.tiff", "*.ico", "*.svg", "*.webp", "*.pdf" })

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = lastplace,
  desc = "remember last cursor place",
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- vim.cmd([[
-- " Chops a filename down to max_length characters, replacing
-- " the middle with ...
-- function! ChopFilename(fname, max_length)
--   if len(a:fname) > a:max_length
--     let affix = (a:max_length / 2) - 3
--     let s =  a:fname[: affix] . '...' . a:fname[-affix :]
--     return s
--   endif
--   return a:fname
-- endfunction
--
-- " format tabline
-- set tabline=%!MyTabLine()
-- function! MyTabLine()
--   let l = []
--   " loop through each tab page
--   for t in range(tabpagenr('$'))
--     let s = '' " each component goes here
--     " select the highlighting for the buffer names
--     if t + 1 == tabpagenr()
--       let s .= '%#TabLineSel#'
--     else
--       let s .= '%#TabLine#'
--     endif
--     " empty space
--     let s .= ' '
--     " set the tab page number (for mouse clicks)
--     let s .= '%' . (t + 1) . 'T'
--     " set page number string
--     let s .= t + 1 . ' '
--     " get buffer names and statuses
--     let n = ''  "temp string for buffer names while we loop and check buftype
--     let buflist = tabpagebuflist(t+1)
--     let winnr = tabpagewinnr(t+1)
--     let b = buflist[winnr-1]
--     " buffer types: quickfix gets a [Q], help gets [H]{base fname}
--     " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
--     if getbufvar( b, "&buftype" ) == 'help'
--       let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
--     elseif getbufvar( b, "&buftype" ) == 'quickfix'
--       let n .= '[Q]'
--     else
--       " let n .= pathshorten(bufname(b))
--       " let n .= bufname(b)
--       " chop filenames down to a max of 25 characters
--       let n .= ChopFilename(fnamemodify(bufname(b), ':t'), 20)
--     endif
--     if len(tabpagebuflist(t + 1)) > 1
--       let n .= '[' . len(tabpagebuflist(t + 1)) . ']'
--     endif
--     " check and ++ tab's &modified count
--     if getbufvar( b, "&modified" )
--       let n .= '+'
--     else
--       let n .= ''
--     endif
--
--     if n == ' '
--       let s .= '[No Name]'
--     else
--       let s .= n
--     endif
--     call add(l, s)
--   endfor
--   " add modified label [n+] where n pages in tab are modified
--   " add buffer names
--   " switch to no underlining and add final space to buffer list
--   "let s .= '%#TabLineSel#' . ' '
--   let s = join(l)
--   let s .= ' '
--   " after the last tab fill with TabLineFill and reset tab page nr
--   let s .= '%#TabLineFill#%T'
--   " right-align the label to close the current tab page
--   if tabpagenr('$') > 1
--     let s .= '%=%#TabLine#%999XX'
--   endif
--   return s
-- endfunction
-- ]])
