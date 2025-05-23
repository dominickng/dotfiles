return {
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
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
        -- for treesitter textobjects to be defined.
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      local gen_ai_spec = require('mini.extra').gen_ai_spec
      local get_find_pattern = function(pattern)
        return function(line, init)
          local from, to = line:find(pattern, init)
          return from, to
        end
      end
      local get_pattern_textobj_spec = function(pattern)
        return function(ai_type)
          if ai_type == 'i' then
            return { pattern }
          end
          return { get_find_pattern(pattern), { '^().*()$' } }
        end
      end
      require("mini.ai").setup({
        custom_textobjects = {
          -- Function definition
          F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),

          -- the nearest enclosing conditional or loop
          o = spec_treesitter({
            a = { "@conditional.outer", '@loop.outer' },
            i = { "@conditional.inner", '@loop.inner' },
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
    config = function()
      require("mini.operators").setup()
    end,
    version = false
  },
  {
    "echasnovski/mini.splitjoin",
    config = function()
      require("mini.splitjoin").setup()
    end,
    version = false
  },
  {
    "echasnovski/mini.surround",
    config = function()
      require("mini.surround").setup({
        respect_selection_type = true
      })
    end,
    version = false
  },
  {
    "Goose97/timber.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("timber").setup({})
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
          "c",
          "java",
          "json",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "html",
          "css",
          "javascript",
          "typescript",
          "bash",
          "gitignore",
          "dockerfile",
          "tsx",
          "yaml",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        indent = {
          enable = true,
        },

        highlight = {
          enable = true,

          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
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
        desc = "Jump to the start of the current function or method",
      })

      vim.keymap.set({ "n", "x" }, "]M", function()
        local current_node = vim.treesitter.get_node({ ignore_injections = false })
        jump_to_node(current_node, true)
      end, {
        desc = "Jump to the end of the current function",
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
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" }
      },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        }
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-pro-exp-03-25",
              },
            },
          })
        end,
      },
    }
  },
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
        -- Check if locally or globally disabled.
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
          cpp = true
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
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { "prettier", "prettierd", stop_after_first = true },
        typescript = { "prettier", "prettierd", stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
    "Wansmer/sibling-swap.nvim",
    config = function()
      require("sibling-swap").setup({
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
        -- If table: { ms = 500, hl_opts = { link = 'IncSearch' } }
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
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({
        enable_check_bracket_line = false
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end
  },
}
