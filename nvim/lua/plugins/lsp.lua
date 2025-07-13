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
      -- {
      --   "hrsh7th/cmp-nvim-lsp",
      -- },
    },
    config = function()
      -- See `:help lsp-vs-treesitter` for a comparison of the two.
      -- This function gets run when an LSP attaches to a particular buffer.
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

          map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Pee[K]")

          -- Find references for the word under your cursor.
          map("gR", fzf.lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", fzf.lsp_typedefs, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", fzf.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          -- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")

          map("<leader>o", "<cmd>Lspsaga outline<CR>", "Show [O]utline", { "n", "x", "o" })

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          -- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
          map("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction", { "n", "x" })

          -- View incoming calls to the function
          map("<leader>ci", fzf.lsp_incoming_calls, "[C]alls ([I]ncoming)", { "n", "x" })

          -- View outgoing calls from the function
          map("<leader>co", fzf.lsp_outgoing_calls, "[C]alls ([O]utcoming)", { "n", "x" })

          -- Jump through diagnostics
          map("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next [D]iagnostic", { "n", "x" })
          map("[p", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to previous [D]iagnostic", { "n", "x" })
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

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
              client
              and client_supports_method(
                client,
                vim.lsp.protocol.Methods.textDocument_documentHighlight,
                event.buf
              )
          then
            local highlight_augroup =
                vim.api.nvim_create_augroup("lspconfig-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lspconfig-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lspconfig-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if
              client
              and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
          then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
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

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data") ..
                      "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                },
              },
            },
            filetypes = {
              "typescript",
              "javascript",
              "javascriptreact",
              "typescriptreact",
              "vue"
            },
          },
          vue_ls = {},
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
  -- {
  --   "onsails/lspkind.nvim",
  --   config = function()
  --     local lspkind = require("lspkind")
  --     lspkind.init({
  --       symbol_map = {
  --         Copilot = "",
  --         Minuet = "",
  --       },
  --     })
  --
  --     vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
  --     vim.api.nvim_set_hl(0, "CmpItemKindMinuet", { fg = "#6CC644" })
  --   end
  -- },
}
