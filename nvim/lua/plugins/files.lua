return {
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    opts = {},
    build = function()
      local sessions_path = vim.fn.stdpath("data") .. "/sessions"
      if vim.fn.isdirectory(sessions_path) == 0 then
        vim.uv.fs_mkdir(sessions_path, 511) -- 0777 permissions
      end
    end,
    keys = {
      { "<Bslash>l", function() require("nvim-possession").list() end, desc = "📌 [L]ist sessions", },
      { "<Bslash>c", function() require("nvim-possession").new() end, desc = "📌 [C]reate session", },
      { "<Bslash>s", function() require("nvim-possession").update() end, desc = "📌 [S]ave session", },
      { "<Bslash>d", function() require("nvim-possession").delete() end, desc = "📌 [D]elete selected session" },
    },
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = {
      {
        "elanmed/fzf-lua-frecency.nvim",
      },
      {
        "junegunn/fzf",
        build = "./install --all"
      },
      {
        "nvim-tree/nvim-web-devicons",
      },
    },
    config = function()
      local fzf = require("fzf-lua")

      local OutType = {
        OPEN = {},
        NEW_TAB = {}
      }

      -- fzf action which switches to the selected file if it's already open
      -- (using the builtin :drop command), otherwise opens the file. If
      -- OutType is NEWTAB, also passes the :tab option to open in a new tab
      -- rather than current buffer
      local switch_or_drop = function(selected, opts, outtype)
        local entry = require("fzf-lua.path").entry_to_file(selected[1], opts, opts._uri)
        local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
        local command = (outtype == OutType.NEW_TAB) and "tab drop" or "drop"
        vim.cmd(([[silent %s %s]]):format(command, fullpath))
      end

      -- fzf action which switches to the selected file if it's already open
      -- (using the builtin :sbuffer command), otherwise calls `fallback`.
      local switch_or_fallback = function(selected, opts, fallback)
        local entry = require("fzf-lua.path").entry_to_file(selected[1], opts, opts._uri)
        local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
        if vim.fn.bufwinid(fullpath) == -1 then
          fallback(selected, opts)
        else
          vim.cmd(([[silent sbuffer %s]]):format(fullpath))
        end
      end

      fzf.setup({
        actions = {
          -- applies to files, buffers, and tabs commands
          files = {
            true, -- inherit defaults
            ["enter"] = function(selected, opts)
              switch_or_drop(selected, opts, OutType.OPEN);
            end,
            ["ctrl-t"] = function(selected, opts)
              switch_or_drop(selected, opts, OutType.NEW_TAB);
            end,
            ["ctrl-v"] = function(selected, opts)
              switch_or_fallback(selected, opts, fzf.actions.file_vsplit)
            end,
            ["ctrl-s"] = function(selected, opts)
              switch_or_fallback(selected, opts, fzf.actions.file_split)
            end,
          },
        },
        files = {
          fd_opts = [[--color=never --hidden --type f --type l --ignore-file ]]
              .. vim.fn.stdpath("config") .. "/lua/plugins/fd-ignore",
        },
        keymap = {
          builtin = {
            true,
            ["<C-k>"] = "preview-page-up",
            ["<C-j>"] = "preview-page-down",
          },
          fzf = {
            true,
            ["ctrl-k"] = "preview-page-up",
            ["ctrl-j"] = "preview-page-down",
          },
        },
        oldfiles = {
          include_current_session = true,
        },
      })

      vim.keymap.set("n", "<Bslash>f", function()
        require("fzf-lua-frecency").frecency({ display_score = true, cwd_only = true, fzf_opts = { ["--no-sort"] = false } })
      end, { desc = "FZF [F]iles by Frecency" })
      vim.keymap.set("n", "<Bslash>p", function()
        fzf.global()
      end, { desc = "FZF Global" })
      vim.keymap.set("n", "<Bslash>e", function()
        fzf.combine({ pickers = "files;lsp_workspace_symbols" })
      end, { desc = "FZF Buffers in [T]abs" })
      vim.keymap.set("n", "<Bslash>b", function()
        fzf.buffers()
      end, { desc = "FZF [B]uffers" })
      vim.keymap.set("n", "<Bslash>t", function()
        fzf.tabs()
      end, { desc = "FZF Buffers in [T]abs" })
      vim.keymap.set("n", "<Bslash>r", function()
        fzf.resume()
      end, { desc = "FZF [R]esume previous search" })
      vim.keymap.set("n", "<Bslash>h", function()
        fzf.help_tags()
      end, { desc = "FZF [H]elp documentation" })
      vim.keymap.set("n", "<Bslash>k", function()
        fzf.keymaps()
      end, { desc = "FZF [K]eymaps" })
      vim.keymap.set("v", "<Bslash>g", function()
        fzf.grep_visual()
      end, { desc = "[G]rep visual selection" })
      vim.keymap.set("n", "<Bslash>gr", function()
        fzf.live_grep()
      end, { desc = "[G]rep [W]ord" })
      vim.keymap.set("n", "<Bslash>gw", function()
        fzf.grep_cword()
      end, { desc = "[G]rep [w]ord under cursor" })
      vim.keymap.set("n", "<Bslash>gW", function()
        fzf.grep_cWORD()
      end, { desc = "[G]rep [W]ORD under cursor" })

      vim.keymap.set("n", "<Bslash>dc", function()
        fzf.dap_configurations()
      end, { desc = "[D]ebugging [C]onfigurations" })

      -- vim.keymap.set({ "i" }, "<C-x><C-f>",
      --   function()
      --     fzf.complete_file({
      --       cmd = "rg --files",
      --       winopts = { preview = { hidden = true } }
      --     })
      --   end, { silent = true, desc = "Fuzzy complete file" })
      vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>",
        function()
          fzf.complete_path()
        end,
        { silent = true, desc = "Fuzzy complete path" })

      -- Ctrl-R <reg> pastes contents of a register into fzf-lua window
      local autogrp = vim.api.nvim_create_augroup("FZF", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fzf",
        group = autogrp,
        callback = function()
          vim.api.nvim_set_keymap("t", "<C-r>", "getreg(nr2char(getchar()))",
            { noremap = true, expr = true, silent = true })
        end,
      })
    end,
  },
}
