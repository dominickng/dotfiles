return {
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
        -- have a well standardized coding style.
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
        css = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        graphql = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        html = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        javascript = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        json = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        jsonc = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        markdown = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        scss = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        typescript = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        vue = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
        yaml = { "oxfmt", "prettier", "prettierd", stop_after_first = true },
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
}

