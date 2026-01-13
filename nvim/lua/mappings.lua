-- Turn the word under cursor to upper case
vim.keymap.set("i", "<C-u>", "<Esc>viwUea", { desc = "Uppercase word under cursor" })

-- Turn the current word into title case
vim.keymap.set("i", "<C-t>", "<Esc>b~lea", { desc = "Titlecase word under cursor" })

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
-- vim.keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "Paste below current line" })
-- vim.keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "Paste above current line" })

vim.keymap.set("i", "<S-Right>", "<C-o><cmd>tabnext<CR>",
  { silent = true, noremap = true, desc = "Switch to next tab" })
vim.keymap.set("i", "<S-Left>", "<C-o><cmd>tabprev<CR>",
  { silent = true, noremap = true, desc = "Switch to previous tab" })
vim.keymap.set({"n", "t"}, "<S-Right>", "<cmd>tabnext<CR>",
  { silent = true, noremap = true, desc = "Switch to next tab" })
vim.keymap.set({"n", "t"}, "<S-Left>", "<cmd>tabprev<CR>",
  { silent = true, noremap = true, desc = "Switch to previous tab" })

-- Make C-u and C-d centre after movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Centre cursor after moving down half-page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Centre cursor after moving up half-page" })

-- use <leader>, to clear search highlight
vim.keymap.set("n", "<leader>,", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- don't use exact searches for */#
vim.keymap.set("n", "*", "g*")
vim.keymap.set("n", "#", "g#")

-- Search inside visually highlighted text
vim.keymap.set("x", "/", "<Esc>/\\%V", { silent = false, desc = "Search forward inside visual selection" })
vim.keymap.set("x", "?", "<Esc>?\\%V", { silent = false, desc = "Search backward inside visual selection" })

-- Search and replace word under the cursor
vim.keymap.set("n", "<Leader>re", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "Search and replace word under cursor" })

-- select visual block after indent/unindent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- reselect pasted text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, replace_keycodes = false, desc = "Reselect pasted text" })

-- map Y to be consistent with D, C, etc
vim.keymap.set("n", "Y", "y$")

-- duplicate line and comment out the first one
vim.keymap.set("n", "yc", "yygccp", { remap = true, desc = "Duplicate and comment out first line" })

-- git conflicts
vim.keymap.set("n", "<leader>fc", "/<<<<CR>", { desc = "[F]ind [C]onflicts" })
vim.keymap.set("n", "<leader>gcu", "dd/|||<CR>0v/>>><CR>$x", { desc = "[G]it [C]onflict Choose [U]pstream" })
vim.keymap.set("n", "<leader>gcb", "0v/|||<CR>$x/====<CR>0v/>>><CR>$x", { desc = "[G]it [C]onflict Choose [B]ase" })
vim.keymap.set("n", "<leader>gcs", "0v/====<CR>$x/>>><CR>dd", { desc = "[G]it [C]onflict Choose [S]tashed" })

-- yank and paste to system clipboard
-- vim.keymap.set("n", "<leader>y", '"+Y', { desc = "Yank to system clipboard" })
-- vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
-- vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
-- vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from system clipboard" })

-- hard re-wrap text
vim.keymap.set("v", "<leader>q", "gq", { desc = "Hard re-wrap paragraph" })
vim.keymap.set("n", "<leader>q", "gqip", { desc = "Hard re-wrap paragraph" })

-- cmdline convenience mappings
vim.keymap.set("c", "<M-f>", "<S-Right>", { desc = "Jump forward a word" })
vim.keymap.set("c", "<M-b>", "<S-Left>", { desc = "Jump backward a word" })
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Jump to start of line" })
vim.keymap.set("c", "<C-e>", "<end>", { desc = "Jump to end of line" })

-- Use %%  to get the current file's directory in cmdline
-- vim.keymap.set('c', '%%', function()
--   if vim.fn.getcmdtype() == ':' then
--     return vim.fn.expand '%:h'
--   else
--     return '%%'
--   end
-- end, { expr = true, desc = 'Get the directory of the current file (cmdline) mode' })

-- C-w deletes path components in cmdline (or otherwise deletes words)
-- https://vim.fandom.com/wiki/Command_line_file_name_completion
vim.cmd([[
function! s:RemoveLastPathComponent()
  let l:cmdlineBeforeCursor = strpart(getcmdline(), 0, getcmdpos() - 1)
  let l:cmdlineAfterCursor = strpart(getcmdline(), getcmdpos() - 1)

  let l:cmdlineRoot = fnamemodify(cmdlineBeforeCursor, ':r')
  let l:result = (l:cmdlineBeforeCursor ==# l:cmdlineRoot ? substitute(l:cmdlineBeforeCursor, '\%(\\ \|[\\/]\@!\f\)\+[\\/ ]\=$\|.$', '', '') : l:cmdlineRoot)
  call setcmdpos(strlen(l:result) + 1)
  return l:result . l:cmdlineAfterCursor
endfunction
cnoremap <C-w> <C-\>e(<SID>RemoveLastPathComponent())<CR>
]])

-- Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
-- yanked stack (also, in visual mode)
-- vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete and throw away" })
-- vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete and throw away" })

-- k and j don't skip lines in wrapped mode
local mux_with_g = function(key)
  local gkey = "g" .. key
  return function()
    if vim.v.count == 0 then return gkey else return key end
  end
end
vim.keymap.set({ "n", "x" }, "j", mux_with_g("j"), { expr = true })
vim.keymap.set({ "n", "x" }, "k", mux_with_g("k"), { expr = true })
