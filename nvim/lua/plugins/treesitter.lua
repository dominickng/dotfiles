return {
  {
    "bezhermoso/tree-sitter-ghostty",
    build = "make nvim_install",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local TS = require("nvim-treesitter")
      TS.setup({})

      -- Install any missing ensure_installed parsers
      local installed_set = {}
      for _, lang in ipairs(TS.get_installed() or {}) do
        installed_set[lang] = true
      end
      local ensure_installed = {
        "astro",
        "bash",
        "c",
        "css",
        "diff",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "html",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "svelte",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
      }
      local to_install = vim.tbl_filter(function(lang)
        return not installed_set[lang]
      end, ensure_installed)
      if #to_install > 0 then
        TS.install(to_install)
      end

      local function installed_for_filetype(filetype)
        local ok, lang = pcall(vim.treesitter.language.get_lang, filetype)
        if not ok or not lang or lang == "" then
          return false
        end

        return vim.tbl_contains(TS.get_installed() or {}, lang)
      end

      -- Enable highlight and indent per-buffer when a parser is available.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        group = vim.api.nvim_create_augroup("treesitter-features", { clear = true }),
        callback = function(ev)
          if not installed_for_filetype(ev.match) then
            return
          end

          local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(ev.buf))
          if file_size > 100 * 1024 then
            return
          end

          local hl_ok = pcall(vim.treesitter.start, ev.buf)
          if not hl_ok then
            return
          end

          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Incremental selection (replaces the removed nvim-treesitter module)
      local function select_node(node)
        local sr, sc, er, ec = node:range()
        vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
        vim.fn.setpos("'>", { 0, er + 1, math.max(1, ec), 0 })
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>gv", true, false, true), "x", false)
      end

      local stacks = {} -- per-window node history for shrink

      vim.keymap.set("n", "<C-space>", function()
        local node = vim.treesitter.get_node({ ignore_injections = false })
        if not node then
          return
        end
        local win = vim.api.nvim_get_current_win()
        stacks[win] = { node }
        select_node(node)
      end, { desc = "Init treesitter selection" })

      vim.keymap.set("x", "<C-space>", function()
        local node = vim.treesitter.get_node({ ignore_injections = false })
        if not node then
          return
        end
        local parent = node:parent()
        if not parent then
          return
        end
        local win = vim.api.nvim_get_current_win()
        stacks[win] = stacks[win] or {}
        table.insert(stacks[win], parent)
        select_node(parent)
      end, { desc = "Expand treesitter selection" })

      vim.keymap.set("x", "<bs>", function()
        local win = vim.api.nvim_get_current_win()
        local stack = stacks[win]
        if not stack or #stack <= 1 then
          return
        end
        table.remove(stack)
        select_node(stack[#stack])
      end, { desc = "Shrink treesitter selection" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "VeryLazy" },
    config = function()
      -- taken from https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/713
      local function_node_types = {
        "arrow_function",
        "function_declaration",
        "function_definition",
      }

      local function is_function_node(node)
        return vim.tbl_contains(function_node_types, node:type())
      end

      --- @param node TSNode|nil
      --- @param types string[]
      --- @return TSNode|nil
      local function find_parent(node, types)
        if node == nil then
          return nil
        end

        if is_function_node(node) then
          return node
        end

        return find_parent(node:parent(), types)
      end

      --- @param current_node TSNode|nil
      --- @param to_end? boolean
      local function jump_to_node(current_node, to_end)
        if not current_node then
          return
        end

        --- @type TSNode|nil
        local function_node

        if is_function_node(current_node) then
          function_node = current_node
        else
          function_node = find_parent(
            current_node:parent(), -- getting parent to avoid being stuck in the same function
            function_node_types
          )
        end

        if not function_node then
          return
        end

        local start_row, start_col, end_row, end_col = function_node:range()
        local current_row, current_col = unpack(vim.api.nvim_win_get_cursor(0))

        local dest_row = (to_end and end_row or start_row) + 1
        local dest_col = to_end and (end_col - 1) or start_col

        if current_row == dest_row and current_col == dest_col then
          jump_to_node(function_node:parent(), to_end)
          return
        end

        vim.cmd("normal! m'") -- set jump list so I can jump back
        vim.api.nvim_win_set_cursor(0, { dest_row, dest_col })
      end

      vim.keymap.set({ "n", "x" }, "[M", function()
        local current_node = vim.treesitter.get_node({ ignore_injections = false })
        jump_to_node(current_node, false)
      end, {
        desc = "Jump to the start of the current function or [m]ethod",
      })

      vim.keymap.set({ "n", "x" }, "]M", function()
        local current_node = vim.treesitter.get_node({ ignore_injections = false })
        jump_to_node(current_node, true)
      end, {
        desc = "Jump to the end of the current function or [m]ethod",
      })

      require("nvim-treesitter-textobjects").setup({
        move = { enable = true, set_jumps = true },
      })

      -- Keymaps are now created manually in the new API
      local move = require("nvim-treesitter-textobjects.move")
      local keymaps = {
        goto_next_start = {
          ["]c"] = { query = "@comment.outer", desc = "Next [c]omment start" },
          ["]f"] = { query = "@call.outer", desc = "Next [f]unction call start" },
          ["]m"] = { query = "@function.outer", desc = "Next [m]ethod/function definition start" },
        },
        goto_next_end = {
          ["]C"] = { query = "@comment.outer", desc = "Next [C]omment end" },
          ["]F"] = { query = "@call.outer", desc = "Next [F]unction call end" },
        },
        goto_previous_start = {
          ["[c"] = { query = "@comment.outer", desc = "Previous [c]omment start" },
          ["[f"] = { query = "@call.outer", desc = "Previous [f]unction call start" },
          ["[m"] = { query = "@function.outer", desc = "Previous [m]ethod/function definition start" },
        },
        goto_previous_end = {
          ["[C"] = { query = "@comment.outer", desc = "Previous [C]omment end" },
          ["[F"] = { query = "@call.outer", desc = "Previous [F]unction call end" },
        },
      }

      for method, bindings in pairs(keymaps) do
        for key, opts in pairs(bindings) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            move[method](opts.query, "textobjects")
          end, { desc = opts.desc })
        end
      end
    end,
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  -- },

  -- TODO: these plugins use the old nvim-treesitter.configs module API and may not be
  -- compatible with the new nvim-treesitter main branch. Verify or replace them.
  -- {
  --   "RRethy/nvim-treesitter-textsubjects",
  -- },

  {
    "RRethy/nvim-treesitter-endwise",
  },
}
