return {
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    config = true,
    build = function()
      local sessions_path = vim.fn.stdpath("data") .. "/sessions"
      if vim.fn.isdirectory(sessions_path) == 0 then
        vim.uv.fs_mkdir(sessions_path, 511) -- 0777 permissions
      end
    end,
    keys = {
      { "<Bslash>l", function() require("nvim-possession").list() end, desc = "📌 List sessions", },
      { "<Bslash>c", function() require("nvim-possession").new() end, desc = "📌 Create new session", },
      { "<Bslash>s", function() require("nvim-possession").update() end, desc = "📌 Update current session", },
      { "<Bslash>d", function() require("nvim-possession").delete() end, desc = "📌 Delete selected session" },
    },
  },
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
      vim.keymap.set("n", "<Bslash>t", function()
        fzf.tabs()
      end, { desc = "FZF Buffers in [T]abs" })
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


      local OutType = {
        OPEN = {},
        NEW_TAB = {}
      }

      -- fzf action which switches to the selected file if it's already open
      -- (using the builtin :drop command), otherwise opens the file. If
      -- OutType is NEWTAB, also passes the :tab option to open in a new tab
      -- rather than current buffer
      local switch_or_drop = function(selected, opts, outtype)
        local entry = require('fzf-lua.path').entry_to_file(selected[1], opts, opts._uri)
        local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
        local command = (outtype == OutType.NEW_TAB) and "drop" or "tab drop"
        vim.cmd(([[silent %s %s]]):format(command, fullpath))
      end

      -- fzf action which switches to the selected file if it's already open
      -- (using the builtin :sbuffer command), otherwise calls `fallback`.
      local switch_or_fallback = function(selected, opts, fallback)
        local entry = require('fzf-lua.path').entry_to_file(selected[1], opts, opts._uri)
        local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
        if vim.fn.bufwinid(fullpath) == -1 then
          fallback(selected, opts)
        else
          vim.cmd(([[silent sbuffer %s]]):format(fullpath))
        end
      end

      fzf.setup({
        actions = {
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
          buffers = {
            true, -- inherit defaults
            ["enter"] = function(selected, opts)
              switch_or_drop(selected, opts, OutType.OPEN);
            end,
            ["ctrl-t"] = function(selected, opts)
              switch_or_drop(selected, opts, OutType.NEW_TAB);
            end,
            ["ctrl-v"] = function(selected, opts)
              switch_or_fallback(selected, opts, fzf.actions.buf_vsplit)
            end,
            ["ctrl-s"] = function(selected, opts)
              switch_or_fallback(selected, opts, fzf.actions.buf_split)
            end,
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
