return {
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "buschco/nvim-cmp-ts-tag-close",
      "rafamadriz/friendly-snippets",
      "folke/lazydev.nvim",
    },
    event = "VimEnter",
    version = "1.*",

    config = function()
      local kind_icons = {
        -- LLM Provider icons
        claude = '󰋦',
        openai = '󱢆',
        codestral = '󱎥',
        gemini = '',
        Groq = '',
        Openrouter = '󱂇',
        Ollama = '󰳆',
        ['Llama.cpp'] = '󰳆',
        Deepseek = ''
      }
      require("blink-cmp").setup({
        appearance = {
          nerd_font_variant = "mono",
          kind_icons = kind_icons,
        },

        keymap = {
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide" },
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
              columns = { { "kind_icon" }, { "label", gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
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

        sources = {
          default = {
            "lsp",
            "close_tags",
            "minuet",
            "path",
            "snippets"
          },
          providers = {
            close_tags = {
              name = "nvim-cmp-ts-tag-close",
              module = "blink.compat.source",
            },
            cmdline = {
              min_keyword_length = function(ctx)
                if string.find(ctx.line, " ") == nil then
                  return 3
                end
                return 0
              end
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
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              async = true,
              -- Should match minuet.config.request_timeout * 1000,
              -- since minuet.config.request_timeout is in seconds
              timeout_ms = 4000,
              score_offset = 0,
            },
          },
          per_filetype = {
            gitcommit = { "lsp", "buffer", "path", "snippets" },
            txt = { "lsp", "buffer", "path", "snippets" },
            json = { "lsp", "buffer", "path", "snippets" },
            markdown = { "lsp", "buffer", "path", "snippets" },
            help = { "lsp", "buffer", "path", "snippets" },
            lua = { inherit_defaults = true, "lazydev" },
          }
        },

        fuzzy = {
          implementation = "prefer_rust_with_warning",
          max_typos = function(keyword)
            return 0
          end
        }
      })
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   -- event = { "InsertEnter", "CmdLineEnter" },
  --   event = { "InsertEnter" },
  --   dependencies = {
  --     {
  --       "L3MON4D3/LuaSnip",
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
  --           return
  --         end
  --         return "make install_jsregexp"
  --       end)(),
  --       dependencies = {
  --         {
  --           "rafamadriz/friendly-snippets",
  --           config = function()
  --             require("luasnip.loaders.from_vscode").lazy_load()
  --           end,
  --         },
  --       },
  --     },
  --     {
  --       "hrsh7th/cmp-buffer",
  --     },
  --     {
  --       "hrsh7th/cmp-nvim-lsp",
  --     },
  --     {
  --       "hrsh7th/cmp-nvim-lua",
  --     },
  --     {
  --       "hrsh7th/cmp-path",
  --     },
  --     {
  --       "hrsh7th/cmp-nvim-lsp-signature-help",
  --     },
  --     {
  --       "hrsh7th/cmp-nvim-lsp-document-symbol",
  --     },
  --     {
  --       "saadparwaiz1/cmp_luasnip",
  --     },
  --   },
  --   config = function()
  --     local cmp = require("cmp")
  --     local luasnip = require("luasnip")
  --     luasnip.config.setup({})
  --
  --     -- Add parentheses after inserting a function
  --     local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  --     cmp.event:on(
  --       'confirm_done',
  --       cmp_autopairs.on_confirm_done()
  --     )
  --
  --     -- local has_words_before = function()
  --     --   unpack = unpack or table.unpack
  --     --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --     --   return col ~= 0
  --     --       and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  --     -- end
  --
  --     local has_words_before = function()
  --       if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  --       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --       return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  --     end
  --
  --     local lspkind = require('lspkind')
  --     cmp.setup({
  --       experimental = {
  --         ghost_text = true,
  --       },
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --
  --       -- Read `:help ins-completion` for more on mappings
  --       mapping = cmp.mapping.preset.insert({
  --         -- Manually trigger minuet
  --         -- ["<C-m>"] = require('minuet').make_cmp_map(),
  --         -- Select the [n]ext item
  --         ["<C-n>"] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         ["<C-p>"] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  --
  --         -- ["<CR>"] = cmp.mapping({
  --         --   i = function(fallback)
  --         --     if cmp.visible() and cmp.get_active_entry() then
  --         --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
  --         --     else
  --         --       fallback()
  --         --     end
  --         --   end,
  --         --   s = cmp.mapping.confirm({ select = true }),
  --         --   c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  --         -- }),
  --
  --         ["<Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             -- First, just complete if there's only one option
  --             if #cmp.get_entries() == 1 then
  --               cmp.confirm({ select = true })
  --               -- If there's more than one option, complete the common string of them.
  --               -- Exist if successful.
  --             elseif cmp.complete_common_string() then
  --               return
  --               -- Otherwise, select the next item in the completion menu
  --             else
  --               cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  --             end
  --           elseif luasnip.locally_jumpable(1) then
  --             luasnip.jump(1)
  --             -- elseif has_words_before() then
  --             --   -- Try generating a completion and select it if it's the only one
  --             --   cmp.complete()
  --             --   if #cmp.get_entries() == 1 then
  --             --     cmp.confirm({ select = true })
  --             --   end
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --
  --         ["<S-Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  --           elseif luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ["<C-Space>"] = cmp.mapping.complete({}),
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ["<C-l>"] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { "i", "s" }),
  --         ["<C-h>"] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { "i", "s" }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       }),
  --       performance = {
  --         -- LLMs are slow.
  --         fetching_timeout = 2000,
  --       },
  --       sources = {
  --         {
  --           name = "lazydev",
  --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
  --           group_index = 0,
  --           entry_filter = function()
  --             if vim.bo.filetype ~= "lua" then
  --               return false
  --             end
  --             return true
  --           end,
  --           priority = 100,
  --         },
  --         -- { name = "copilot",                 group_index = 2 },
  --         -- { name = "codecompanion",           group_index = 2 },
  --         {
  --           name = "nvim_lsp",
  --           group_index = 1,
  --           priority = 150
  --         },
  --         {
  --           name = "buffer",
  --           group_index = 2,
  --           priority = 100,
  --           entry_filter = function(entry)
  --             return not entry.exact
  --           end,
  --           option = {
  --             get_bufnrs = function()
  --               return vim.api.nvim_list_bufs()
  --             end,
  --           },
  --         },
  --         {
  --           name = "minuet",
  --           group_index = 1,
  --           priority = 150
  --         },
  --         {
  --           name = "nvim_lsp_signature_help",
  --           group_index = 1,
  --           priority = 150
  --         },
  --         {
  --           name = "path",
  --           group_index = 2,
  --           priority = 100
  --         },
  --         {
  --           name = 'render-markdown',
  --           group_index = 1,
  --           priority = 150
  --         },
  --         {
  --           name = "luasnip",
  --           group_index = 1,
  --           priority = 120
  --         },
  --         {
  --           name = "nvim_lua",
  --           entry_filter = function()
  --             if vim.bo.filetype ~= "lua" then
  --               return false
  --             end
  --             return true
  --           end,
  --           priority = 150,
  --           group_index = 1,
  --         },
  --       },
  --
  --       matching = {
  --         disallow_fuzzy_matching = true,
  --         disallow_fullfuzzy_matching = true,
  --         disallow_partial_fuzzy_matching = true,
  --         disallow_partial_matching = false,
  --         disallow_prefix_unmatching = true,
  --       },
  --
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --
  --       formatting = {
  --         format = lspkind.cmp_format({
  --           mode = "symbol_text", -- show only symbol annotations
  --           maxwidth = {
  --             -- menu = function() return math.floor(0.45 * vim.o.columns) end,
  --             menu = 120,             -- leading text (labelDetails)
  --             abbr = 120,             -- actual suggestion item
  --           },
  --           ellipsis_char = "...",    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
  --           show_labelDetails = true, -- show labelDetails in menu. Disabled by default
  --
  --           -- The function below will be called before any actual modifications from lspkind
  --           -- so that you can provide more controls on popup customization.
  --           -- (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
  --           before = function(entry, vim_item)
  --             return vim_item
  --           end
  --         })
  --       }
  --     })
  --
  --     cmp.setup.filetype({ "gitcommit", "help", "json", "txt" }, {
  --       sources = {
  --         { name = "nvim_lsp",        group_index = 1 },
  --         { name = "buffer",          group_index = 1 },
  --         { name = "path",            group_index = 1 },
  --         { name = "render-markdown", group_index = 1 },
  --         { name = "luasnip",         group_index = 1 },
  --       }
  --     })
  --
  --     -- cmp.setup.cmdline({ "/", "?" }, {
  --     --   mapping = cmp.mapping.preset.cmdline(),
  --     --   sources = {
  --     --     {
  --     --       { name = 'nvim_lsp_document_symbol' }
  --     --     },
  --     --     { name = "buffer" }
  --     --   }
  --     -- })
  --
  --     -- commented out cause it breaks tab completion
  --     -- cmp.setup.cmdline(":", {
  --     --   mapping = cmp.mapping.preset.cmdline(),
  --     --   sources = cmp.config.sources({
  --     --     { name = "path" }
  --     --   }, {
  --     --     { name = "cmdline" }
  --     --   }),
  --     --   matching = { disallow_symbol_nonprefix_matching = false }
  --     -- })
  --   end,
  -- },
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      request_timeout = 4,
      provider = "gemini",
      provider_options = {
        gemini = {
          model = "gemini-2.5-flash",
          optional = {
            generationConfig = {
              maxOutputTokens = 256,
              thinkingConfig = {
                thinkingBudget = 0,
              },
            },
            safetySettings = {
              {
                -- HARM_CATEGORY_HATE_SPEECH,
                -- HARM_CATEGORY_HARASSMENT
                -- HARM_CATEGORY_SEXUALLY_EXPLICIT
                category = "HARM_CATEGORY_DANGEROUS_CONTENT",
                -- BLOCK_NONE
                threshold = "BLOCK_ONLY_HIGH",
              },
            },
          },
        },
      }
    }
  },
  {
    "xzbdmw/colorful-menu.nvim",
    opts = {}
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     })
  --   end
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },
}
