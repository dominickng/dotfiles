return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local fzf = require("fzf-lua")

      vim.keymap.set("n", "<Bslash>f", function()
        fzf.files()
      end, { desc = "FZF [F]iles" })
      vim.keymap.set("n", "<Bslash>b", function()
        fzf.buffers()
      end, { desc = "FZF [B]uffers" })
      vim.keymap.set("n", "<Bslash>r", function()
        fzf.oldfiles()
      end, { desc = "FZF [R]ecent files" })
      vim.keymap.set("v", "<Bslash>g", function()
        fzf.grep_visual()
      end, { desc = "[G]rep" })
      vim.keymap.set("n", "<Bslash>gr", function()
        fzf.live_grep()
      end, { desc = "[G]rep [W]ord" })
      vim.keymap.set("n", "<Bslash>gw", function()
        fzf.grep_cword()
      end, { desc = "[G]rep [W]ord" })

      vim.keymap.set({ "i" }, "<C-x><C-f>",
        function()
          fzf.complete_file({
            cmd = "rg --files",
            winopts = { preview = { hidden = true } }
          })
        end, { silent = true, desc = "Fuzzy complete file" })

      local actions = fzf.actions
      fzf.setup({
        actions = {
          files = {
            true, -- inherit defaults
            ["enter"]  = actions.file_switch_or_edit,
            ["ctrl-s"] = false,
            ["ctrl-x"] = actions.file_split,
          },
        },
        files = {
          fd_opts = [[--color=never --hidden --type f --type l --exclude .git --ignore-file ]]
              .. vim.fn.stdpath("config") .. "/lua/plugins/fd-ignore",
        }
      })
    end,
  },
}
