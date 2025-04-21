return {
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.api.nvim_set_hl(0, "MatchParen", { bg = "green", italic = true })
    end
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
  {
    "echasnovski/mini.ai",
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      require("mini.ai").setup({
        custom_textobjects = {
          F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
          o = spec_treesitter({
            a = { "@conditional.outer", '@loop.outer' },
            i = { "@conditional.inner", '@loop.inner' },
          }),
          [":"] = spec_treesitter({
            a = "@property.outer",
            i = "@property.inner",
          }),
          ["="] = spec_treesitter({
            a = "@assignment.outer",
            i = "@assignment.inner",
          }),
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
              ["]M"] = { query = "@function.outer", desc = "Next [M]ethod/Function definition end" },
            },
            goto_previous_start = {
              ["[c"] = { query = "@comment.outer", desc = "Previous [c]omment start" },
              ["[f"] = { query = "@call.outer", desc = "Previous [f]unction call start" },
              ["[m"] = { query = "@function.outer", desc = "Previous [m]ethod/function definition start" },
            },
            goto_previous_end = {
              ["[C"] = { query = "@comment.outer", desc = "Previous [C]omment end" },
              ["[F"] = { query = "@call.outer", desc = "Previous [F]unction call end" },
              ["[M"] = { query = "@function.outer", desc = "Previous [M]ethod/Function definition end" },
            },
          },
        }
      })
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    end
  },
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
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
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
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
        -- lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
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
