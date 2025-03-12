local opts = { silent = true, noremap = true }

-- Save key strokes (now we do not need to press shift to enter command mode).
-- vim.keymap.set({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
vim.keymap.set("i", "<C-u>", "<Esc>viwUea")

-- Turn the current word into title case
vim.keymap.set("i", "<C-t>", "<Esc>b~lea")

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
-- vim.keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "Paste below current line" })
-- vim.keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "Paste above current line" })

vim.keymap.set("i", "<S-Right>", "<C-o><cmd>tabnext<CR>", opts)
vim.keymap.set("i", "<S-Left>", "<C-o><cmd>tabprev<CR>", opts)
vim.keymap.set("n", "<S-Right>", "<cmd>tabnext<CR>", opts)
vim.keymap.set("n", "<S-Left>", "<cmd>tabprev<CR>", opts)

-- use <leader>, to clear search highlight
vim.keymap.set("n", "<leader>,", "<cmd>nohlsearch<CR>")

-- don't use exact searches for */#
vim.keymap.set("n", "*", "g*")
vim.keymap.set("n", "#", "g#")

-- select visual block after indent/unindent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- reselect pasted text
vim.cmd([[  nnoremap <expr> gV    "`[".getregtype(v:register)[0]."`]"  ]])

-- map Y to be consistent with D, C, etc
vim.keymap.set("n", "Y", "y$")

-- yank and paste to system clipboard
vim.keymap.set("n", "<leader>y", '"+Y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from system clipboard" })

-- hard re-wrap text
vim.keymap.set("v", "<leader>q", "gq", { desc = "Hard re-wrap paragraph" })
vim.keymap.set("n", "<leader>q", "gqip", { desc = "Hard re-wrap paragraph" })

-- Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
-- yanked stack (also, in visual mode)
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete and throw away" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete and throw away" })

-- k and j don't skip lines in wrapped mode
local mux_with_g = function(key)
  local gkey = "g" .. key
  return function()
    if vim.v.count == 0 then return gkey else return key end
  end
end
vim.keymap.set("n", "j", mux_with_g("j"), { expr = true })
vim.keymap.set("n", "k", mux_with_g("k"), { expr = true })
vim.keymap.set("v", "j", mux_with_g("j"), { expr = true })
vim.keymap.set("v", "k", mux_with_g("k"), { expr = true })
