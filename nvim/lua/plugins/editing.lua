return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter" },
    branch = "v0.6",
    opts = {
      extensions = {
        alpha = {
          after = true
        }
      },
    },
  },
  {
    "AndrewRadev/switch.vim",
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
                augend.integer.alias.decimal,  -- nonnegative decimal number (0, 1, 2, 3, ...)
                -- augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
                augend.integer.alias.hex,      -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
                augend.constant.alias.bool,    -- boolean value (true <-> false)
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
                  word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
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
        vim.fn["switch#NormalizedCaseWords"] { "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" },
        vim.fn["switch#NormalizedCaseWords"] { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
        vim.fn["switch#NormalizedCase"] { "yes", "no" },
        vim.fn["switch#NormalizedCase"] { "on", "off" },
        vim.fn["switch#NormalizedCase"] { "left", "right" },
        vim.fn["switch#NormalizedCase"] { "up", "down" },
        vim.fn["switch#NormalizedCase"] { "enable", "disable" },
        vim.fn["switch#NormalizedCase"] { "true", "false" },
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
        vim.cmd [[
        :if !switch#Switch() | lua require("dial.map").manipulate("increment", "normal")
        :endif
        ]]
      end, {
        desc = "Switch variant or increment number/date",
      })
      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        vim.cmd [[
        :if !switch#Switch({"reverse": 1}) | lua require("dial.map").manipulate("decrement", "normal")
        :endif
        ]]
      end, {
        desc = "Switch reverse variant or decrement number/date",
      })
    end
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.api.nvim_set_hl(0, "MatchParen", { bg = "green" })
    end
  },
  {
    "echasnovski/mini.ai",
    dependencies = {
      {
        "echasnovski/mini.extra",
        version = false,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
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
          F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),

          -- the nearest enclosing conditional or loop
          o = spec_treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),

          -- variable
          v = spec_treesitter({
            a = "@variable.outer",
            i = "@variable.inner",
          }),

          -- key: value property
          [":"] = spec_treesitter({
            a = "@property.outer",
            i = "@property.inner",
          }),

          -- assignment
          ["="] = spec_treesitter({
            a = "@assignment.outer",
            i = "@assignment.inner",
          }),

          -- line without whitespace
          L = gen_ai_spec.line(),

          -- number (possibly including a decimal)
          -- %f is the frontier pattern: http://lua-users.org/wiki/FrontierPattern
          N = get_pattern_textobj_spec("%f[%d-%.]-?[%d%.]+[%d,.]*%f[%D]"),

          -- URL
          U = get_pattern_textobj_spec([[%f[%l]%l+://[^%s{}"'`<>]+]]),

          -- UUID
          D = get_pattern_textobj_spec("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"),
        },
      })
    end,
    version = false
  },
  {
    "echasnovski/mini.operators",
    opts = {},
    version = false
  },
  -- {
  --   "echasnovski/mini.pairs",
  --   opts = {},
  --   version = false
  -- },
  {
    "echasnovski/mini.splitjoin",
    opts = {},
    version = false
  },
  {
    "echasnovski/mini.surround",
    opts = {
      respect_selection_type = true,
      search_method = "cover_or_next",
    },
    version = false
  },
  {
    "Goose97/timber.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
          "bash",
          "c",
          "css",
          "dockerfile",
          "gitignore",
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },

        auto_install = true,

        indent = {
          enable = true,
        },

        highlight = {
          enable = true,

          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          additional_vim_regex_highlighting = false,
        },

        matchup = {
          enable = true,
          include_match_words = true,
        },

        tree_setter = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
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

      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = false
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]c"] = { query = "@comment.outer", desc = "Next [c]omment start" },
              ["]f"] = { query = "@call.outer", desc = "Next [f]unction call start" },
              ["]m"] = { query = "@function.outer", desc = "Next [m]ethod/function definition start" },
            },
            goto_next_end = {
              ["]C"] = { query = "@comment.outer", desc = "Next [C]omment end" },
              ["]F"] = { query = "@call.outer", desc = "Next [F]unction call end" },
              -- ["]M"] = { query = "@function.outer", desc = "Next [M]ethod/Function definition end" },
            },
            goto_previous_start = {
              ["[c"] = { query = "@comment.outer", desc = "Previous [c]omment start" },
              ["[f"] = { query = "@call.outer", desc = "Previous [f]unction call start" },
              ["[m"] = { query = "@function.outer", desc = "Previous [m]ethod/function definition start" },
            },
            goto_previous_end = {
              ["[C"] = { query = "@comment.outer", desc = "Previous [C]omment end" },
              ["[F"] = { query = "@call.outer", desc = "Previous [F]unction call end" },
              -- ["[M"] = { query = "@function.outer", desc = "Previous [M]ethod/Function definition end" },
            },
          },
        }
      })
    end
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  -- },
  {
    "RRethy/nvim-treesitter-textsubjects",
  },
  {
    "RRethy/nvim-treesitter-endwise",
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
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        javascript = { "prettier", "prettierd", stop_after_first = true },
        typescript = { "prettier", "prettierd", stop_after_first = true },
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
    }
  },
  -- {
  --   "windwp/nvim-autopairs",
  --   event = "InsertEnter",
  --   opts = {
  --     enable_check_bracket_line = false
  --   },
  -- },
  -- {
  --   "windwp/nvim-ts-autotag",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {
  --     opts = {
  --       enable_close = true,          -- Auto close tags
  --       enable_rename = true,         -- Auto rename pairs of tags
  --       enable_close_on_slash = false -- Auto close on trailing </
  --     },
  --     per_filetype = {
  --       ["html"] = {
  --         enable_close = false
  --       }
  --     }
  --   }
  -- },
}
