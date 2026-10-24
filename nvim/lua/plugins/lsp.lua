return {
  {
    "dmmulroy/ts-error-translator.nvim",
  },

  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
  },

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
        opts = {},
      },
      {
        "mason-org/mason-lspconfig.nvim",
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lspconfig-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", function()
            require("lspeek").peek_definition()
          end, "[G]oto [D]efinition")
          map("gT", function()
            require("lspeek").peek_type_definition()
          end, "[G]oto [Type] Definition")

          -- map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Pee[K]")
          map("K", function()
            require("pretty_hover").hover()
          end, "Pee[K]")

          local fzf = require("fzf-lua")
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

          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
          map("<leader>aa", function()
            require("tiny-code-action").code_action()
          end, "Code [A]ction", { "n", "x" })

          map("<leader>ai", fzf.lsp_incoming_calls, "[A]ll [I]ncoming Calls", { "n", "x" })
          map("<leader>ao", fzf.lsp_outgoing_calls, "[A]ll [O]utgoing Calls", { "n", "x" })

          -- Jump through diagnostics
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

      local servers = require("lsp.servers")

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers.mason or {})
      vim.list_extend(ensure_installed, {
        "stylua",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
      -- to the default language server configs as provided by nvim-lspconfig or
      -- define a custom server config that's unavailable on nvim-lspconfig.
      for server, config in pairs(vim.tbl_extend("keep", servers.mason, servers.others)) do
        if not vim.tbl_isempty(config) then
          vim.lsp.config(server, config)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_enable = true,
      })

      if not vim.tbl_isempty(servers.others) then
        vim.lsp.enable(vim.tbl_keys(servers.others))
      end

      require("lsp.xcode").setup()
    end,
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
        hotkeys_mode = function(titles, used_hotkeys)
          local t = {}
          for i = 1, #titles do
            t[i] = tostring(i)
          end
          return t
        end,
        auto_preview = true,
        auto_accept = false,
        position = "cursor",
        winborder = "single",
        custom_keys = {
          { key = "m", pattern = "Fill match arms" },
          { key = "r", pattern = "Rename.*" },
        },
      },
    },
  },

  {
    "r4ppz/lspeek.nvim",
    opts = {
      window = {
        width = 110,
        height = 40,
        border = "single", -- double | rounded | solid | shadow
        win_opts = {
          number = true,
        },
      },

      stack_limit = 5,

      select_first = false,

      -- Keymaps available inside the preview window.
      keymaps = {
        close = "q",
        split = "<C-s>",
        vsplit = "<C-v>",
        enter = "<CR>",
        tab = "<C-t>",
        prev = "[",
        next = "]",
      },
    },

    -- Keymaps call the Lua API. Alternatively, use user commands:
    -- :LSPeekDef      -> Peek Definition
    -- :LSPeekTypeDef  -> Peek Type Definition
    keys = {
      {
        "gD",
        function()
          require("lspeek").peek_definition()
        end,
        desc = "Peek Definition (lspeek)",
      },
      {
        "gT",
        function()
          require("lspeek").peek_type_definition()
        end,
        desc = "Peek Type Definition (lspeek)",
      },
    },
  },

  {
    "zeioth/garbage-day.nvim",
    event = "VeryLazy",
    opts = {
      grace_period = 60 * 5,
      wakeup_delay = 5000,
    },
  },
}
