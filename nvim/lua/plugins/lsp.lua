return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {}
      },
      {
        "mason-org/mason-lspconfig.nvim"
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim"
      },
      {
        "nvimdev/lspsaga.nvim",
        event        = "LspAttach",
        opts         = {
          definition = {
            keys = {
              vsplit = "<C-v>",
              split = "<C-s>",
              tabe = "<C-t>",
            }
          },
          diagnostic = {
            auto_preview = true,
            extend_relatedInformation = true,
          },
          lightbulb = {
            enable = false,
            virtual_text = false,
          },
          outline = {
            win_position = "left",
          },
          scroll_preview = {
            scroll_down = '<C-j>',
            scroll_up = '<C-k>',
          },
          symbol_in_winbar = {
            enable = true,
          },
        },
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        },
      },
      {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
          { "nvim-lua/plenary.nvim" },
        },
        event = "LspAttach",
        opts = {
          picker = "buffer",
          opts = {
            hotkeys = true,
            hotkeys_mode = "text_diff_based",
            auto_preview = true,
            auto_accept = false,
            position = "cursor",
            winborder = "single",
            custom_keys = {
              { key = 'm', pattern = 'Fill match arms' },
              { key = 'r', pattern = 'Rename.*' },
            },
          },
        },
      }
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lspconfig-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          local fzf = require("fzf-lua")
          map("gd", "<cmd>Lspsaga peek_definition<CR>", "[G]oto [D]efinition")

          -- map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Pee[K]")
          map("K", function()
            require("pretty_hover").hover()
          end, "Pee[K]")

          -- Find references for the word under your cursor.
          map("gR", fzf.lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          map("<leader>D", fzf.lsp_typedefs, "Type [D]efinition")

          -- Fuzzy find all the symbols in current document or workspace.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", fzf.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

          -- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")

          map("<leader>do", "<cmd>Lspsaga outline<CR>", "Show [D]ocument [O]utline", { "n", "x", "o" })

          -- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
          -- map("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction", { "n", "x" })
          map("<leader>aa", function()
            require("tiny-code-action").code_action()
          end, "Code [A]ction", { "n", "x" })

          map("<leader>ai", fzf.lsp_incoming_calls, "[A]ll [I]ncoming Calls", { "n", "x" })
          map("<leader>ao", fzf.lsp_outgoing_calls, "[A]ll [O]utgoing Calls", { "n", "x" })

          -- Jump through diagnostics
          -- map("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next [D]iagnostic", { "n", "x" })
          -- map("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to previous [D]iagnostic", { "n", "x" })
          map("<leader>df", vim.diagnostic.open_float, "Open [D]iagnostics [F]loat")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          -- vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          -- vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          -- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        mason = {
          bashls = {},
          clangd = {},
          cssls = {},
          gh_actions_ls = {},
          html = {},
          jsonls = {},
          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          },
          pyright = {},
          terraformls = {},
          ts_ls = {
            filetypes = {
              "typescript",
              "javascript",
              "javascriptreact",
              "typescriptreact",
            },
          },
          vtsls = {
            root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = vim.fn.stdpath("data") ..
                          "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                      languages = { "vue" },
                      configNamespace = "typescript",
                    }
                  }
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
            filetypes = {
              "vue"
            },
          },
          vue_ls = {
            typescript = {}
          },
        },
        others = {}
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers.mason or {})
      vim.list_extend(ensure_installed, {
        "stylua",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
      -- to the default language server configs as provided by nvim-lspconfig or
      -- define a custom server config that's unavailable on nvim-lspconfig.
      for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
        if not vim.tbl_isempty(config) then
          vim.lsp.config(server, config)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_enable = true
      })

      if not vim.tbl_isempty(servers.others) then
        vim.lsp.enable(vim.tbl_keys(servers.others))
      end
    end,
  },
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      grace_period = 60 * 5,
      wakeup_delay = 5000
    }
  },
}
