return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = function()
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- Disable default split action and reassign it to Ctrl-x
      config.defaults.actions.files["ctrl-s"] = false
      config.defaults.actions.files["ctrl-x"] = actions.file_split

      -- Make enter switch to buffer if it is already open
      config.defaults.actions.files["enter"] = actions.file_switch_or_edit

      vim.keymap.set("n", "<Bslash>f", function()
        require("fzf-lua").files()
      end, { desc = "FZF [F]iles" })
      vim.keymap.set("n", "<Bslash>b", function()
        require("fzf-lua").buffers()
      end, { desc = "FZF [B]uffers" })
      vim.keymap.set("n", "<Bslash>r", function()
        require("fzf-lua").oldfiles()
      end, { desc = "FZF [R]ecent files" })
      vim.keymap.set("v", "<Bslash>g", function()
        require("fzf-lua").grep_visual()
      end, { desc = "[G]rep" })
      vim.keymap.set("n", "<Bslash>gr", function()
        require("fzf-lua").live_grep()
      end, { desc = "[G]rep [W]ord" })
      vim.keymap.set("n", "<Bslash>gw", function()
        require("fzf-lua").grep_cword()
      end, { desc = "[G]rep [W]ord" })

      vim.keymap.set({ "i" }, "<C-x><C-f>",
        function()
          require("fzf-lua").complete_file({
            cmd = "rg --files",
            winopts = { preview = { hidden = true } }
          })
        end, { silent = true, desc = "Fuzzy complete file" })
    end,
  },
}
