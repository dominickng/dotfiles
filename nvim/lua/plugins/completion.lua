return {
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "fang2hou/blink-copilot",
      },
      {
        "folke/lazydev.nvim",
      },
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        version = "v2.*",
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
          },
        },
        config = function()
          require("luasnip").setup({ enable_autosnippets = true })
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
        end
      },
      {
        "moyiz/blink-emoji.nvim",
      },
      {
        "xzbdmw/colorful-menu.nvim",
        opts = {}
      },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end
      },
    },
    event = "InsertEnter",
    version = "1.*",

    opts = {
      appearance = {
        nerd_font_variant = "mono",
      },

      keymap = {
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = false,
        ["<C-q>"] = { "hide" },
        ["<C-y>"] = { "select_and_accept" },

        ["<Tab>"] = {
          function(cmp)
            local items = cmp.get_items()
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            elseif (#items == 1) then
              return cmp.select_and_accept()
            else
              return cmp.select_next()
            end
          end,
          "fallback"
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },

        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },

        ["<C-s>"] = { "show_signature", "hide_signature", 'fallback' },
      },

      completion = {
        ghost_text = {
          enabled = true,
          show_with_selection = true,
          show_without_selection = false,
          show_with_menu = true,
          show_without_menu = true,
        },
        trigger = {
          prefetch_on_insert = false,
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },
        list = {
          selection = {
            auto_insert = true,
            preselect = false
          },
        },

        menu = {
          border = "single",
          direction_priority = { "n", "s" },
          draw = {
            columns = { { "kind_icon" }, { "label", "source_name", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
              source_name = {
                text = function(ctx)
                  if ctx.source_id == 'cmdline' then return end
                  return ctx.source_name:sub(1, 7)
                end,
              },
            },
            treesitter = { "lsp" },
          },
          max_height = 30,
        },
      },

      cmdline = {
        completion = {
          list = {
            selection = {
              preselect = false,
            },
          },
          menu = {
            auto_show = true
          },
        },
        keymap = {
          ["<C-e>"] = false,
          ["<C-q>"] = { "hide" },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
      },

      signature = {
        enabled = true,
        window = {
          border = "rounded",
          show_documentation = false
        },
      },

      snippets = {
        preset = "luasnip",
      },

      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer", "emoji" }
          else
            return { "lsp", "copilot", "path", "snippets" }
          end
        end,

        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 10,
            async = true,
          },
          cmdline = {
            min_keyword_length = function(ctx)
              if string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 1,
            opts = {
              insert = true,
              ---@type string|table|fun():table
              trigger = function()
                return { ":" }
              end,
            },
          },
          lazydev = {
            module = "lazydev.integrations.blink",
            score_offset = 100
          },
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
              end, items)
            end,
          },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
        },
        per_filetype = {
          gitcommit = { "lsp", "buffer", "path", "snippets", "emoji" },
          help = { "lsp", "buffer", "path", "snippets" },
          json = { "lsp", "buffer", "path", "snippets" },
          lua = { "lsp", "path", "lazydev", "snippets" },
          markdown = { "lsp", "buffer", "path", "snippets", "emoji" },
          txt = { "lsp", "buffer", "path", "snippets" },
        }
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function(keyword)
          return 0
        end,
        sorts = {
          "exact",
          -- defaults
          "score",
          "sort_text",
        },
      }
    }
  },
}
