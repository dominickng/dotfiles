return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter" },
    branch = "v0.6",
    opts = {
      extensions = {
        alpha = {
          after = true,
        },
      },
    },
  },

  {
    "AndrewRadev/switch.vim",
    event = { "BufReadPost" },
    dependencies = {
      {
        "monaqa/dial.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        opts = function()
          local augend = require("dial.augend")

          local logical_alias = augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          })

          return {
            dials_by_ft = {
              css = "css",
              vue = "vue",
              javascript = "typescript",
              typescript = "typescript",
              typescriptreact = "typescript",
              javascriptreact = "typescript",
              json = "json",
              lua = "lua",
              markdown = "markdown",
              sass = "css",
              scss = "css",
              python = "python",
            },
            groups = {
              default = {
                augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                -- augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
                augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                augend.date.alias["%Y/%m/%d"], -- date (2022/02/19)
                augend.date.alias["%Y-%m-%d"], -- date (2022-02-19)
                augend.date.alias["%d/%m/%Y"], -- date (19/02/2022)
                augend.constant.alias.bool, -- boolean value (true <-> false)
                logical_alias,
              },
              vue = {
                augend.constant.new({ elements = { "let", "const" } }),
                augend.hexcolor.new({ case = "lower" }),
                augend.hexcolor.new({ case = "upper" }),
              },
              typescript = {
                augend.constant.new({ elements = { "let", "const" } }),
              },
              css = {
                augend.hexcolor.new({
                  case = "lower",
                }),
                augend.hexcolor.new({
                  case = "upper",
                }),
              },
              markdown = {
                augend.constant.new({
                  elements = { "[ ]", "[x]" },
                  word = false,
                  cyclic = true,
                }),
                augend.misc.alias.markdown_header,
              },
              json = {
                augend.semver.alias.semver, -- versioning (v1.1.2)
              },
              lua = {
                augend.constant.new({
                  elements = { "and", "or" },
                  word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                  cyclic = true, -- "or" is incremented into "and".
                }),
              },
              python = {
                augend.constant.new({
                  elements = { "and", "or" },
                }),
              },
            },
          }
        end,
        config = function(_, opts)
          -- copy defaults to each group
          for name, group in pairs(opts.groups) do
            if name ~= "default" then
              vim.list_extend(group, opts.groups.default)
            end
          end
          require("dial.config").augends:register_group(opts.groups)
          vim.g.dials_by_ft = opts.dials_by_ft
        end,
      },
    },
    config = function()
      vim.g.switch_mapping = ""
      local fk = [=[\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>]=]
      local fv = [=[\=toupper(submatch(1)) . submatch(2)]=]
      local sk = [=[\<\(\u\l\+\)\(\u\l\+\)\+\>]=]
      local sv = [=[\=tolower(substitute(submatch(0), '\(\l\)\(\u\)', '\1_\2', 'g'))]=]
      local tk = [=[\<\(\l\+\)\(_\l\+\)\+\>]=]
      local tv = [=[\U\0]=]
      local fok = [=[\<\(\u\+\)\(_\u\+\)\+\>]=]
      local fov = [=[\=tolower(substitute(submatch(0), '_', '-', 'g'))]=]
      local fik = [=[\<\(\l\+\)\(-\l\+\)\+\>]=]
      local fiv = [=[\=substitute(submatch(0), '-\(\l\)', '\u\1', 'g')]=]
      vim.g["switch_custom_definitions"] = {
        vim.fn["switch#NormalizedCaseWords"]({
          "sunday",
          "monday",
          "tuesday",
          "wednesday",
          "thursday",
          "friday",
          "saturday",
        }),
        vim.fn["switch#NormalizedCaseWords"]({
          "january",
          "february",
          "march",
          "april",
          "may",
          "june",
          "july",
          "august",
          "september",
          "october",
          "november",
          "december",
        }),
        vim.fn["switch#NormalizedCaseWords"]({
          "first",
          "second",
          "third",
          "fourth",
          "fifth",
          "sixth",
          "seventh",
          "eighth",
          "ninth",
          "tenth",
        }),
        vim.fn["switch#NormalizedCaseWords"]({
          "1st",
          "2nd",
          "3rd",
          "4th",
          "5th",
          "6th",
          "7th",
          "8th",
          "9th",
          "10th",
        }),
        vim.fn["switch#NormalizedCase"]({ "yes", "no" }),
        vim.fn["switch#NormalizedCase"]({ "on", "off" }),
        vim.fn["switch#NormalizedCase"]({ "left", "right" }),
        vim.fn["switch#NormalizedCase"]({ "up", "down" }),
        vim.fn["switch#NormalizedCase"]({ "enable", "disable" }),
        vim.fn["switch#NormalizedCase"]({ "true", "false" }),
        { "==", "!=" },
        {
          [fk] = fv,
          [sk] = sv,
          [tk] = tv,
          [fok] = fov,
          [fik] = fiv,
        },
      }
      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        vim.cmd([[
        :if !switch#Switch() | lua require("dial.map").manipulate("increment", "normal")
        :endif
        ]])
      end, {
        desc = "Switch variant or increment number/date",
      })
      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        vim.cmd([[
        :if !switch#Switch({"reverse": 1}) | lua require("dial.map").manipulate("decrement", "normal")
        :endif
        ]])
      end, {
        desc = "Switch reverse variant or decrement number/date",
      })
    end,
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.api.nvim_set_hl(0, "MatchParen", { bg = "green" })
    end,
  },

  {
    "bezhermoso/tree-sitter-ghostty",
    build = "make nvim_install",
  },

  {
    "duqcyxwd/stringbreaker.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("string-breaker").setup()
    end,
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },

  {
    "Goose97/timber.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-mini/mini.ai",
    dependencies = {
      {
        "nvim-mini/mini.extra",
        version = false,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    config = function()
      local gen_spec = require("mini.ai").gen_spec
      local gen_ai_spec = require("mini.extra").gen_ai_spec
      local get_find_pattern = function(pattern)
        return function(line, init)
          local from, to = line:find(pattern, init)
          return from, to
        end
      end
      local get_pattern_textobj_spec = function(pattern)
        return function(ai_type)
          if ai_type == "i" then
            return { pattern }
          end
          return { get_find_pattern(pattern), { "^().*()$" } }
        end
      end
      require("mini.ai").setup({
        custom_textobjects = {
          -- Function definition
          F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),

          -- the nearest enclosing conditional or loop
          o = gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),

          -- variable
          v = gen_spec.treesitter({
            a = "@variable.outer",
            i = "@variable.inner",
          }),

          -- key: value property
          [":"] = gen_spec.treesitter({
            a = "@property.outer",
            i = "@property.inner",
          }),

          -- assignment
          ["="] = gen_spec.treesitter({
            a = "@assignment.outer",
            i = "@assignment.inner",
          }),

          -- line without whitespace
          L = gen_ai_spec.line(),

          -- number (possibly including a decimal)
          -- %f is the frontier pattern: http://lua-users.org/wiki/FrontierPattern
          N = get_pattern_textobj_spec("%f[%d-%.]-?[%d%.]+[%d,.]*%f[%D]"),

          -- function usage
          u = gen_spec.function_call(),

          -- URL
          U = get_pattern_textobj_spec([[%f[%l]%l+://[^%s{}"'`<>]+]]),

          -- UUID
          D = get_pattern_textobj_spec("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"),
        },
      })
    end,
    version = false,
  },

  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "<C-H>",
        right = "<C-L>",
        down = "<C-J>",
        up = "<C-K>",
      },
    },
    version = false,
  },

  {
    "nvim-mini/mini.operators",
    opts = {},
    version = false,
  },

  {
    "nvim-mini/mini.splitjoin",
    opts = {},
    version = false,
  },

  {
    "nvim-mini/mini.surround",
    opts = {
      respect_selection_type = true,
      search_method = "cover_or_nearest",
    },
    version = false,
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },

  {
    "Goose97/timber.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
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
        "lua",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
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

      -- Enable highlight and indent per-buffer; auto-install missing parsers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "<filetype>" },
        group = vim.api.nvim_create_augroup("treesitter-features", { clear = true }),
        callback = function(ev)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
          if ok and stats and stats.size > 100 * 1024 then
            return
          end

          local hl_ok = pcall(vim.treesitter.start, ev.buf)
          if not hl_ok then
            -- Auto-install the parser for this filetype, then retry
            local lang = vim.treesitter.language.get_lang(ev.match)
            if lang then
              TS.install({ lang }):await(function()
                pcall(vim.treesitter.start, ev.buf)
                vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
              end)
            end
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

  {
    "ruicsh/tailwindcss-dial.nvim",
    dependencies = { "monaqa/dial.nvim" },
    opts = {
      -- group = "default", -- optional, defaults to "default"
      ft = { "html", "vue" },
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({
            async = true,
          })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Don't format on save in certain directories.
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {
          c = true,
          cpp = true,
          vue = true,
        }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 2500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        -- lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        javascript = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        typescript = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        vue = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },

  {
    "tpope/vim-abolish",
  },

  {
    "tpope/vim-ragtag",
  },

  {
    "Wansmer/sibling-swap.nvim",
    opts = {
      allowed_separators = {
        ",",
        ";",
        "and",
        "or",
        "&&",
        "&",
        "||",
        "|",
        "==",
        "===",
        "!=",
        "!==",
        "-",
        "+",
        ["<"] = ">",
        ["<="] = ">=",
        [">"] = "<",
        [">="] = "<=",
      },
      use_default_keymaps = true,
      -- Highlight recently swapped node. Can be boolean or table
      -- If table: { ms = 500, hl_opts = { link = "IncSearch" } }
      -- `hl_opts` is a `val` from `nvim_set_hl()`
      highlight_node_at_cursor = true,
      -- keybinding for movements to right or left (and up or down, if `allow_interline_swaps` is true)
      -- (`<C-,>` and `<C-.>` may not map to control chars at system level, so are sent by certain terminals as just `,` and `.`. In this case, just add the mappings you want.)
      keymaps = {
        ["g>"] = "swap_with_right",
        ["g<"] = "swap_with_left",
      },
      ignore_injected_langs = false,
      -- allow swaps across lines
      allow_interline_swaps = true,
      -- swaps interline siblings without separators (no recommended, helpful for swaps html-like attributes)
      interline_swaps_without_separator = false,
      -- Fallbacks for tiny settings for langs and nodes. See #fallback
      fallback = {},
    },
  },

  {
    "wurli/contextindent.nvim",
    opts = { pattern = "*" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
